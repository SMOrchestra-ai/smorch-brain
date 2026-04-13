# Runbook: Signal-Ingestion-Master

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (every 4 hours: 00:00, 04:00, 08:00, 12:00, 16:00, 20:00 UTC)
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Top-level orchestrator for all signal ingestion. Calls each sub-workflow (Clay, Instantly, HeyReach, News, Apify) in sequence, manages deduplication, and ensures the `signals` table stays current with a 13-month rolling window.

---

## Expected Behavior (Happy Path)

1. Cron fires every 4 hours.
2. Workflow fetches the list of active signal sources from `signal_sources` table (where `is_active = true`).
3. For each active source type, triggers the corresponding sub-workflow:
   - `clay` -> Signal-Ingest-Clay
   - `instantly` -> Signal-Ingest-Instantly
   - `heyreach` -> Signal-Ingest-HeyReach
   - `news_api` -> Signal-Ingest-News
   - `apify` -> Signal-Ingest-Apify (only if last_sync_at > 24 hours ago)
4. Waits for all sub-workflows to complete (parallel execution where possible).
5. Runs deduplication pass: checks `dedup_key` (signal_type + account_id + date) and removes any duplicates inserted during this cycle.
6. Runs retention cleanup: deletes signals older than 13 months (`created_at < NOW() - INTERVAL '13 months'`).
7. Updates `signal_sources.last_sync_at` for each successfully synced source.
8. Publishes a Supabase Realtime event to notify the dashboard of new signals.
9. Logs execution summary to n8n execution log (signals ingested count, sources synced, errors).

**Expected Duration:** 3-8 minutes depending on signal volume.

---

## Input/Output Data Shapes

**Input:**
- None (cron-triggered). Reads from `signal_sources` table to determine which sources to sync.

**Output:**
- New rows inserted into `signals` table via sub-workflows.
- Updated `last_sync_at` timestamps on `signal_sources`.
- Deleted stale signals (>13 months old).
- Supabase Realtime event: `{ event: 'signals_updated', payload: { count: N, sources: [...] } }`

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Sub-workflow timeout (>5 min per source) | Execution log shows timeout error for specific source | Check the sub-workflow directly. If API is down, the master will continue with remaining sources. Retry the failed source manually. |
| Supabase connection failure | All sub-workflows fail with connection error | Check Supabase status at status.supabase.com. Verify n8n credentials. Restart n8n if needed: `systemctl restart n8n` on smo-brain. |
| Dedup key collision (race condition) | Postgres unique constraint violation on `dedup_key` | Safe to ignore -- the dedup pass handles this. If persistent, check if two master instances are running simultaneously (cron overlap). |
| Signal source marked degraded | Source has 3+ consecutive failures | Check `circuit_breaker_state` table for the API. If state = `open`, wait for cooldown. If the API is genuinely down, disable the source in `signal_sources` (set `is_active = false`) until resolved. |
| Retention cleanup takes too long | Execution time >15 min | Add a `LIMIT 10000` to the DELETE query to batch the cleanup. Run manually in smaller batches. |
| n8n OOM on smo-brain | Workflow killed mid-execution, systemd journal shows OOM | Check `htop` on smo-brain. If memory is exhausted, reduce parallel sub-workflow execution (run sequentially). Consider increasing RAM. |

---

## Monitoring

- **Where to check:** n8n execution logs (testflow.smorchestra.ai:5170), Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Signals ingested per cycle (expect 50-500 depending on customer count)
  - Execution time (target: <8 min)
  - Source success rate (target: >95% of active sources complete without error)
  - Dedup removals per cycle (should be <5% of total ingested; higher indicates source issues)
- **Alert thresholds:**
  - Execution time >15 min -> investigate
  - 0 signals ingested for 2+ consecutive cycles -> escalate to al-Jazari
  - Any source failing 3+ consecutive cycles -> check circuit breaker, escalate

---

## Dependencies

- **APIs:** None directly (delegates to sub-workflows)
- **Tables:**
  - `signal_sources` (read: fetch active sources, write: update last_sync_at)
  - `signals` (write: dedup cleanup, delete: retention purge)
  - `circuit_breaker_state` (read: check if any API is in open state)
- **Other workflows:**
  - Signal-Ingest-Clay (called)
  - Signal-Ingest-Instantly (called)
  - Signal-Ingest-HeyReach (called)
  - Signal-Ingest-News (called)
  - Signal-Ingest-Apify (called)
- **Circuit breakers:** Checks all API circuit breakers before dispatching sub-workflows. Skips sources with CB state = `open`.

---

## Manual Execution

```bash
# Trigger manually via n8n webhook (if configured)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingestion-master \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "reason": "on-call triggered"}'

# Or trigger from n8n UI:
# 1. Open testflow.smorchestra.ai:5170
# 2. Find "Signal-Ingestion-Master" workflow
# 3. Click "Execute Workflow" button

# To run only a specific source:
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingestion-master \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "sources": ["clay"]}'
```

---

## Rollback / Safe Mode

If the ingestion pipeline is causing data quality issues:

1. **Pause the workflow** in n8n UI (toggle OFF).
2. Identify the problematic source from execution logs.
3. Disable that specific source: `UPDATE signal_sources SET is_active = false WHERE source_type = 'problematic_source';`
4. Re-enable the master workflow.
5. Investigate the source issue separately.
6. Re-enable the source once fixed: `UPDATE signal_sources SET is_active = true WHERE source_type = 'fixed_source';`
