# Runbook: Outreach-Queue-Processor

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (every 15 minutes)
**Layer:** Activation
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

The execution engine for all outbound messaging. Runs every 15 minutes to fetch pending outreach records, dispatch them to the appropriate channel sender (Instantly, HeyReach, GHL), deduct credits, and handle failures with retries and refunds.

---

## Expected Behavior (Happy Path)

1. Cron fires every 15 minutes.
2. Queries `campaign_messages` (BRD: `activation_outreach`) for pending outreach:
   ```sql
   SELECT * FROM campaign_messages
   WHERE status = 'pending'
     AND scheduled_at <= NOW()
   ORDER BY scheduled_at ASC
   LIMIT 100;
   ```
3. For each pending record:
   a. Validates the contact still exists and `do_not_contact != true`.
   b. Performs final credit check: `customer.credit_balance >= channel_cost`.
   c. Dispatches to the appropriate channel sender workflow:
      - `email` -> Channel-Sender-Instantly (cost: 1 credit)
      - `linkedin` -> Channel-Sender-HeyReach (cost: 2 credits)
      - `whatsapp` or `sms` -> Channel-Sender-GHL (cost: 1.5 credits)
      - `phone` -> Sends Slack alert to sales rep (cost: 0 credits)
   d. Waits for channel sender response.
   e. On success: updates status to `sent`, records `sent_at`, deducts credits, logs to `audit_log`.
   f. On failure: increments retry counter. If retries < 3, sets status back to `pending` with new `scheduled_at` (exponential backoff: +2min, +4min, +8min). If retries >= 3, sets status to `failed`, refunds credits, logs failure.
4. After processing all records, logs batch summary.

**Expected Duration:** 1-5 minutes depending on queue depth.

---

## Input/Output Data Shapes

**Input:**
- Reads from `campaign_messages` table (records created by Routing-Master).

**Output:**
- Updated `campaign_messages` records:
```json
{
  "id": "uuid",
  "status": "sent",
  "sent_at": "2026-04-14T09:01:23Z",
  "message_id": "ext_msg_xxx",
  "credits_spent": 1,
  "retry_count": 0
}
```
- Credit deduction on `tenants.credit_balance`.
- Audit log entries for each send and each failure.

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Channel sender timeout | No response from sub-workflow within 30s | Timeout the request. Mark as retry. The channel sender may have sent but not confirmed -- check external API for delivery status before retrying (avoid double-send). |
| All sends failing for one channel | e.g., all Instantly sends fail | Check Channel-Sender-Instantly workflow and circuit breaker. Instantly API may be down. Pause that channel's queue until resolved. |
| Credit balance goes negative | Race condition between check and deduct | Use database transaction with `FOR UPDATE` lock on credit_balance. Never deduct without re-checking within the transaction. |
| Queue backlog (>500 pending) | Processing can't keep up in 15-min window | Increase processing LIMIT from 100 to 200. Or reduce cron interval to 5 minutes temporarily. Investigate why so many records are pending (burst from Routing-Master?). |
| Duplicate sends | Same outreach sent twice | Check `message_id` -- if already set, the send already happened. Add idempotency: before dispatching, verify status is still `pending` with a fresh DB read. |
| Contact deleted between scheduling and sending | FK error or null contact | Skip the record, set status = `cancelled`. Refund any reserved credits. |
| Phone action (Slack alert) fails | Slack webhook returns error | Retry Slack alert. If Slack is down, log the phone action to a fallback (email to sales rep). |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Queue depth (pending records count, checked at start of each run)
  - Records processed per run (target: process entire queue within 15-min window)
  - Success rate per channel (target: >95% for email, >90% for LinkedIn, >95% for WhatsApp)
  - Average processing time per record (target: <5s)
  - Credit refund rate (target: <2% -- indicates low failure rate)
  - Retry rate (target: <10%)
- **Alert thresholds:**
  - Queue depth >500 -> processing bottleneck, investigate
  - Success rate <80% for any channel for 1+ hour -> channel API issue
  - Credit refund rate >10% -> systemic send failures
  - Queue depth growing across consecutive runs -> outflow < inflow, scale up

---

## Dependencies

- **APIs:** None directly (delegates to channel senders)
- **Tables:**
  - `campaign_messages` / `activation_outreach` view (read: fetch pending, write: update status)
  - `individual_entities` / `contacts` view (read: validate contact)
  - `tenants` / `customers` view (read/write: check and deduct credits)
  - `audit_log` (write: log sends, failures, refunds)
- **Other workflows:**
  - Channel-Sender-Instantly (called for email sends)
  - Channel-Sender-HeyReach (called for LinkedIn sends)
  - Channel-Sender-GHL (called for WhatsApp/SMS sends)
- **Circuit breakers:** Checks CBs for instantly, heyreach, ghl before dispatching. Skips channels with open CBs.

---

## Manual Execution

```bash
# Process the queue manually (same as cron trigger)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/outreach-queue-processor \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Process only a specific channel
curl -X POST https://testflow.smorchestra.ai:5170/webhook/outreach-queue-processor \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "channel": "email"}'

# Process a single specific outreach record
curl -X POST https://testflow.smorchestra.ai:5170/webhook/outreach-queue-processor \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "outreach_id": "uuid-here"}'
```

---

## Credit System Notes

- Credits are deducted at time of successful send, not at time of scheduling.
- If a send fails after 3 retries, the credits are refunded automatically.
- Credit deduction is logged in `audit_log` with action = `credit_deduct` and the amount.
- Credit refunds are logged with action = `credit_refund`.
- Cost per channel: email = 1, LinkedIn = 2, WhatsApp/SMS = 1.5, phone alert = 0.
- Always verify `credit_balance >= cost` inside a DB transaction before deducting.
