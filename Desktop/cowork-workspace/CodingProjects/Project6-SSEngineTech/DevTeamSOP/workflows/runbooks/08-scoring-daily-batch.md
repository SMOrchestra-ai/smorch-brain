# Runbook: Scoring-Daily-Batch

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (daily at 02:00 UTC)
**Layer:** Scoring
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Safety net for accounts that missed real-time scoring. Runs daily at 02:00 UTC to identify all accounts without a score in the last 24 hours and batch-scores them via Claude API. Ensures no account falls through the cracks if a webhook or real-time trigger was missed.

---

## Expected Behavior (Happy Path)

1. Cron fires at 02:00 UTC daily.
2. Queries `lead_scores_history` (BRD: `account_intent_scores`) to find accounts where the most recent score is older than 24 hours:
   ```sql
   SELECT DISTINCT a.id as account_id, a.customer_id
   FROM company_entities a
   LEFT JOIN lead_scores_history s ON s.account_id = a.id
     AND s.scored_at > NOW() - INTERVAL '24 hours'
   WHERE s.id IS NULL
     AND a.deleted_at IS NULL
   ORDER BY a.id;
   ```
3. Groups accounts into batches of 10 (to manage Claude API rate limits).
4. For each batch:
   a. Fetches signal history (last 30 days) for all accounts in the batch.
   b. Fetches signal weights for each account's customer.
   c. Calls Claude API for each account (sequential within batch, parallel across batches if rate allows).
   d. Applies same fallback logic as Scoring-Master (Claude -> Gemini -> heuristic).
   e. Inserts scores into `lead_scores_history`.
5. After all batches complete, publishes summary Supabase Realtime event.
6. Logs batch summary: total scored, total failed, average score, tier distribution.

**Expected Duration:** 10-60 minutes depending on number of unscored accounts. At ~5s per account (Claude API), 100 accounts = ~8 minutes.

---

## Input/Output Data Shapes

**Input:**
- None (cron-triggered). Queries database for unscored accounts.

**Output:**
- New rows in `lead_scores_history` for each scored account (same shape as Scoring-Master output).
- Execution summary:
```json
{
  "total_accounts_found": 45,
  "total_scored": 43,
  "total_failed": 2,
  "avg_score": 52,
  "tier_distribution": { "hot": 5, "warm": 12, "cool": 18, "cold": 8 },
  "duration_seconds": 240
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Too many unscored accounts (>500) | Execution time >60 min, possible timeout | Increase batch size to 20. Or split into multiple workflow runs with OFFSET/LIMIT. This usually indicates a Signal-Ingestion-Master failure (no signals = no real-time scoring). |
| Claude API rate limit during batch | 429 errors mid-batch | Built-in backoff between batches (5s delay). If persistent, reduce parallel batches to 1. |
| Claude API cost spike | Single batch run costs >$100 | Large batch of accounts with extensive signal histories. Cap signal history to top 20 most recent signals per account to reduce token usage. |
| Scoring-Master already scored some accounts | Batch finds fewer accounts than expected | This is normal and expected. The daily batch only picks up what real-time missed. |
| Database lock contention | Slow INSERT into lead_scores_history | Batch inserts (10 at a time) instead of individual INSERTs. Avoid running during peak dashboard usage hours. 02:00 UTC is chosen for this reason. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Unscored accounts found (trend: should decrease as real-time scoring improves)
  - Batch completion rate (target: >95%)
  - Execution time (target: <30 min for typical volume)
  - Claude API tokens consumed per batch run
- **Alert thresholds:**
  - Unscored accounts >200 -> Signal-Ingestion-Master or Scoring-Master may be failing
  - Batch completion rate <80% -> Claude API stability issue
  - Execution time >60 min -> investigate account volume or API latency

---

## Dependencies

- **APIs:**
  - Claude API (primary)
  - Gemini API (fallback)
- **Tables:**
  - `lead_scores_history` / `account_intent_scores` view (read: find unscored, write: insert scores)
  - `signals` (read: fetch signal history per account)
  - `signal_weights` (read: fetch weights per customer)
  - `company_entities` / `accounts` view (read: account details)
  - `circuit_breaker_state` (read/write: Claude and Gemini CBs)
- **Other workflows:** Delegated to by Scoring-Master (cron mode). Triggers Routing-Master for newly scored accounts.
- **Circuit breakers:** Same as Scoring-Master (claude_api, gemini_api).

---

## Manual Execution

```bash
# Run the daily batch manually
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-daily-batch \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Run with a custom lookback window (e.g., accounts unscored in last 48 hours)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-daily-batch \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "lookback_hours": 48}'

# Dry run (identify unscored accounts without actually scoring)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-daily-batch \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "dry_run": true}'
```

---

## Scheduling Notes

- 02:00 UTC is chosen to avoid overlap with peak dashboard usage (MENA business hours: 05:00-14:00 UTC).
- If Scoring-Master's cron mode also fires at 02:00 UTC, ensure they don't duplicate work. Scoring-Master should delegate to this workflow, not run its own batch logic.
- If this workflow runs long (>30 min), it may overlap with early morning dashboard activity. Monitor and adjust batch size if needed.
