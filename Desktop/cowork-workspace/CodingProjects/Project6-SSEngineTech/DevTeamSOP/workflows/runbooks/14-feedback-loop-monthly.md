# Runbook: Feedback-Loop-Monthly

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (1st Sunday of every month, 02:00 UTC)
**Layer:** Feedback
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

The learning engine of SSE V3. Runs monthly to analyze closed deals from GHL, compare them against signal predictions, calculate scoring accuracy, and reweight the `signal_weights` table to improve future predictions. This is the feedback loop that makes the system smarter over time.

---

## Expected Behavior (Happy Path)

1. Cron fires on the 1st Sunday of the month at 02:00 UTC.
2. **Step 1: Pull Closed Deals**
   - Calls GHL API to fetch all opportunities with status = "won" in the last 30 days.
   - For each deal, extracts: contact_id, account_id, deal_value, closed_at, pipeline_stage_history.
3. **Step 2: Retroactive Scoring**
   - For each closed deal, fetches the account's signal history at the time of close.
   - Retrieves the intent score that was active when the deal was marked as won.
   - Records: predicted_tier, actual_outcome (won), deal_value.
4. **Step 3: Calculate Accuracy**
   - `accuracy = (correct_predictions / total_predictions) * 100`
   - Correct prediction = account was scored hot (80+) or warm (60-79) at time of close.
   - Incorrect prediction = account was scored cool (<60) at time of close.
   - Break down accuracy by signal type: which signals were present in won deals vs. lost/stale deals.
5. **Step 4: Identify Signal Effectiveness**
   - For each signal_type, calculate:
     - Presence rate in won deals vs. overall accounts
     - Average confidence when present in won deals
     - Correlation score (0-1): how predictive is this signal type?
6. **Step 5: Reweight Signal Weights**
   - Update `signal_weights` table with new weights based on correlation scores.
   - Weights are normalized (sum to 1.0 per customer).
   - Cap single-run weight change at +/-20% to prevent oscillation.
   - Set `last_optimized_at = NOW()`.
7. **Step 6: Generate Report**
   - Posts summary report to Slack #sse-v3-product:
     - Overall accuracy %
     - Top 5 most predictive signals
     - Bottom 5 least predictive signals
     - Weight changes >5%
     - Deal attribution summary (which signals predicted which deals)
8. **Step 7: Log Everything**
   - All weight changes logged to `audit_log` with before/after values.
   - Full report stored in Supabase (or filesystem) for historical reference.

**Expected Duration:** 10-30 minutes depending on deal volume and customer count.

---

## Input/Output Data Shapes

**Input:**
- None (cron-triggered). Reads from GHL API and Supabase tables.

**Output:**
- Updated rows in `signal_weights` table:
```json
{
  "customer_id": "uuid",
  "signal_type": "email_reply",
  "weight": 0.82,
  "last_optimized_at": "2026-05-04T02:15:00Z",
  "accuracy_contribution": 0.91
}
```
- Slack report message:
```
SSE V3 Monthly Feedback Loop - May 2026
=====================================
Deals Analyzed: 23
Overall Accuracy: 87.2%

Top Predictive Signals:
1. email_reply (correlation: 0.91)
2. funding_event (correlation: 0.85)
3. linkedin_message_reply (correlation: 0.82)

Weight Changes:
- email_reply: 0.75 -> 0.82 (+9.3%)
- web_visit: 0.60 -> 0.52 (-13.3%)

Customers Reweighted: 4/4
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| GHL API failure | Cannot fetch closed deals | Retry 3x. If GHL is down, postpone the run to next day. Alert al-Jazari. |
| No closed deals in period | 0 deals found | Normal for early-stage customers or slow months. Log "no deals to analyze" and skip reweighting. Do not change weights without data. |
| Weight oscillation | Same signals bouncing up/down monthly | The +/-20% change cap should prevent this. If still happening, increase cap strictness to +/-10%. May need a minimum sample size (e.g., require 5+ deals before reweighting). |
| Missing signal history | Signals were purged (>13 month retention) | Only analyze deals with complete signal history. Log deals with incomplete data as "insufficient_data". |
| Customer has no signal_weights rows | First-time optimization | Create default weights (all 0.5) then optimize. This should be handled during onboarding. |
| Slack notification fails | Report not posted | Log to Sentry. The reweighting still succeeded -- just the notification failed. Retry Slack or send via email to Mamoun. |
| Wrong deals pulled from GHL | Incorrect pipeline or stage filter | Verify the GHL pipeline ID and "won" stage ID in the workflow config. Different customers may have different pipeline structures. |

---

## Monitoring

- **Where to check:** n8n execution logs, Slack #sse-v3-product (monthly report), Sentry
- **Key metrics:**
  - Overall scoring accuracy (target: >85%)
  - Weight change magnitude (avg change per signal type)
  - Deals analyzed (should grow month over month)
  - Signal effectiveness ranking (track trends)
- **Alert thresholds:**
  - Accuracy <70% -> scoring model needs attention, escalate to Mamoun + al-Jazari
  - Any signal weight changes >20% in a single run -> review manually before deploying
  - 0 deals for 2+ consecutive months for any customer -> customer may have churn risk

---

## Dependencies

- **APIs:** GoHighLevel API (https://rest.gohighlevel.com/v1/) for closed deal data
- **Tables:**
  - `signal_weights` (read/write: fetch current weights, update with new weights)
  - `lead_scores_history` / `account_intent_scores` view (read: historical scores at time of deal close)
  - `signals` (read: signal history for closed-deal accounts)
  - `company_entities` / `accounts` view (read: account details)
  - `audit_log` (write: log all weight changes)
- **Other workflows:** Standalone. Does not trigger other workflows.
- **Circuit breakers:** `circuit_breaker_state` entry for `ghl`.

---

## Manual Execution

```bash
# Run the monthly feedback loop manually
curl -X POST https://testflow.smorchestra.ai:5170/webhook/feedback-loop-monthly \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Run for a specific customer only
curl -X POST https://testflow.smorchestra.ai:5170/webhook/feedback-loop-monthly \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "customer_id": "uuid-here"}'

# Dry run (calculate accuracy but do NOT update weights)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/feedback-loop-monthly \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "dry_run": true}'

# Run with custom date range
curl -X POST https://testflow.smorchestra.ai:5170/webhook/feedback-loop-monthly \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "from": "2026-03-01", "to": "2026-03-31"}'
```

---

## Post-Run Checklist

After each monthly run:
1. Review the Slack report for accuracy trends.
2. If accuracy <85%, schedule a prompt review session with Mamoun.
3. If any signal weight changed >15%, verify the change makes business sense.
4. If a new signal type is consistently predictive, consider increasing its default weight for new customers.
5. Update the monthly dashboard metrics with the new accuracy figure.
6. If customer-specific weights diverge significantly from defaults, discuss with the customer during their monthly review.
