# Runbook: Scoring-Master

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Webhook (on new signal insertion) + Cron (daily 02:00 UTC fallback)
**Layer:** Scoring
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Core AI scoring engine. When a new signal arrives, this workflow fetches the account's full signal history, calls Claude API with a structured prompt for signal-based trust reasoning, and produces an intent score (0-100) with tier classification, reasoning, and recommended next action/channel. This is the brain of the SSE nervous system.

---

## Expected Behavior (Happy Path)

### Webhook Mode (Real-Time Scoring)
1. Receives webhook from signal ingestion workflows when a new signal is inserted.
2. Extracts `account_id` from the payload.
3. Fetches the account's full signal history from `signals` table (last 30 days).
4. Fetches the customer's `signal_weights` from `signal_weights` table.
5. Builds the Claude API prompt:
   - System prompt: signal-based trust reasoning framework, MENA market context.
   - User prompt: account details, signal history (sorted by recency), signal weights.
   - Structured output format: `{ intent_score, intent_tier, reasoning, next_action_signal, recommended_channel }`.
6. Calls Claude 3.5 Sonnet API with structured output.
7. If Claude API fails, falls back to Gemini API with same prompt.
8. If both fail, applies rule-based heuristic scoring (weighted sum of signal scores).
9. Inserts result into `account_intent_scores` table (actual: `lead_scores_history`):
   - `intent_score`: 0-100
   - `intent_tier`: hot (80-100) / warm (60-79) / cool (40-59) / cold (<40)
   - `reasoning`: Claude's explanation text
   - `next_action_signal`: recommended next step
   - `recommended_channel`: email / linkedin / whatsapp / phone
   - `input_signals_snapshot`: jsonb of signals that drove this score
10. Publishes Supabase Realtime event for dashboard live update.
11. Triggers Routing-Master webhook with the new score.

### Cron Mode (Daily Batch Fallback)
1. Fires at 02:00 UTC daily.
2. Delegates to Scoring-Daily-Batch workflow for accounts without recent scores.

**Expected Duration:** 3-8 seconds per account (dominated by Claude API latency).

---

## Input/Output Data Shapes

**Input (Webhook):**
```json
{
  "account_id": "uuid",
  "signal_id": "uuid",
  "signal_type": "email_reply",
  "customer_id": "uuid"
}
```

**Claude API Prompt Structure:**
```
System: You are an intent scoring engine for B2B signal-based outbound.
Analyze the following signals for this account and produce a structured score.
Consider signal recency (newer = more weight), signal type importance (per customer weights),
and MENA market context (Friday/Saturday weekend, relationship-heavy culture).

User: Account: {company_name}, Industry: {industry}, ICP Match: {icp_score}%
Signals (last 30 days): [array of signals with types, dates, values]
Customer Signal Weights: [array of signal_type: weight pairs]

Output JSON: { intent_score, intent_tier, reasoning, next_action_signal, recommended_channel }
```

**Output:**
- Row in `lead_scores_history` (BRD: `account_intent_scores`):
```json
{
  "account_id": "uuid",
  "intent_score": 82,
  "intent_tier": "hot",
  "reasoning": "Multiple high-confidence signals in the last 7 days: email reply (Day 1), LinkedIn connection accepted (Day 3), funding event detected (Day 5). Company matches ICP at 85%. Recent hiring signals suggest growth phase. Recommend immediate multi-channel engagement.",
  "next_action_signal": "Schedule warm email with case study relevant to their funding round",
  "recommended_channel": "email",
  "input_signals_snapshot": { "signals": [...], "weights_used": {...} },
  "scored_at": "2026-04-14T12:00:00Z"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Claude API 429 (rate limit) | HTTP 429, scoring queue backs up | Implement request queuing with backoff. Claude allows ~60 RPM on standard tier. Batch requests if possible. |
| Claude API 500/503 | Transient server error | Retry 3x with exponential backoff (2s, 4s, 8s). If all retries fail, fall back to Gemini. |
| Claude API timeout (>30s) | Request hangs | Set 30s timeout on HTTP node. Fall back to Gemini on timeout. |
| Gemini fallback also fails | Both AI APIs down | Apply rule-based heuristic: weighted sum of (signal_confidence * signal_weight) for each signal. Log as "heuristic_scored" for later re-scoring. |
| Claude returns malformed JSON | Parsing error in n8n | Wrap in try-catch. If JSON invalid, retry once with stricter prompt. If still fails, use heuristic. Log malformed response to Sentry. |
| No signals for account | Account has 0 signals in last 30 days | Score as cold (intent_score = 10). Set next_action_signal = "needs more signal data". |
| Signal weights missing for customer | No rows in `signal_weights` for customer_id | Use default weights (all signal types = 0.5). Log warning -- customer onboarding may be incomplete. |
| Score oscillation | Same account bouncing between hot/warm rapidly | Check for noisy signals (e.g., email open bots). Consider adding a smoothing function (rolling average of last 3 scores). |
| Claude API budget exceeded | Monthly spend >$5K | Immediately switch all scoring to Gemini (lower cost). Alert Mamoun. Review scoring frequency -- may need to reduce real-time scoring to batch-only. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts, Claude API usage dashboard
- **Key metrics:**
  - Scores produced per hour (correlates with signal ingestion volume)
  - Claude API latency p50/p95/p99 (target: p95 <8s)
  - Fallback rate to Gemini (target: <5%)
  - Heuristic fallback rate (target: <1%)
  - Score distribution across tiers (healthy: 10-15% hot, 20-30% warm, 30-40% cool, 20-30% cold)
  - Monthly Claude API cost (budget: $5K/month for 50 customers)
- **Alert thresholds:**
  - Fallback rate >10% for 1+ hour -> Claude API issue, investigate
  - 0 scores produced for 1+ hour during business hours -> workflow may be stuck
  - Score distribution >40% hot -> scoring too generous, review prompt/weights
  - Monthly Claude spend >$4K by day 20 -> budget alert to Mamoun

---

## Dependencies

- **APIs:**
  - Claude API (primary: claude-3-5-sonnet, https://api.anthropic.com/v1/messages)
  - Gemini API (fallback: gemini-pro, https://generativelanguage.googleapis.com/)
- **Tables:**
  - `signals` (read: fetch 30-day signal history for account)
  - `signal_weights` (read: fetch customer's signal type weights)
  - `lead_scores_history` / `account_intent_scores` view (write: insert new score)
  - `company_entities` / `accounts` view (read: account details for prompt)
  - `circuit_breaker_state` (read/write: Claude and Gemini CBs)
- **Other workflows:**
  - Receives triggers from all Signal-Ingest-* workflows
  - Triggers Routing-Master with new scores
  - Delegates batch scoring to Scoring-Daily-Batch
- **Circuit breakers:**
  - `circuit_breaker_state` entry for `claude_api`. Opens after 5 consecutive failures, 30-min cooldown.
  - `circuit_breaker_state` entry for `gemini_api`. Opens after 5 consecutive failures, 30-min cooldown.

---

## Manual Execution

```bash
# Score a specific account
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-master \
  -H "Content-Type: application/json" \
  -d '{"account_id": "uuid-here", "manual": true}'

# Force re-score with heuristic only (skip AI)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-master \
  -H "Content-Type: application/json" \
  -d '{"account_id": "uuid-here", "manual": true, "mode": "heuristic"}'

# Force re-score all accounts for a customer
curl -X POST https://testflow.smorchestra.ai:5170/webhook/scoring-master \
  -H "Content-Type: application/json" \
  -d '{"customer_id": "uuid-here", "manual": true, "batch": true}'
```

---

## Scoring Prompt Maintenance

- The Claude system prompt is the most critical piece of IP in the platform.
- Changes to the prompt require Mamoun's approval (product) and al-Jazari's review (architecture).
- A/B test prompt changes against historical data before deploying.
- Keep a versioned history of prompts in `/DevTeamSOP/workflows/scoring-prompts/`.
- The prompt must reference MENA market context, signal-based trust reasoning, and the customer's ICP.
