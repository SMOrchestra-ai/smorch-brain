# Runbook: Nurture-Email-Sequencer

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (daily, recommended 06:00 UTC / 10:00 AM Dubai)
**Layer:** Supporting
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Handles low-touch nurture email sequences for warm accounts (intent_score 60-79) that haven't received recent outreach. Unlike the main activation channel senders that handle immediate outreach, this workflow manages longer-term nurture cadences to keep warm prospects engaged without being aggressive.

---

## Expected Behavior (Happy Path)

1. Cron fires daily (recommended 06:00 UTC to align with MENA morning).
2. Queries for warm accounts eligible for nurture:
   ```sql
   SELECT a.id, a.customer_id, s.intent_score
   FROM company_entities a
   JOIN lead_scores_history s ON s.account_id = a.id
   WHERE s.intent_score BETWEEN 60 AND 79
     AND s.scored_at = (SELECT MAX(scored_at) FROM lead_scores_history WHERE account_id = a.id)
     AND a.deleted_at IS NULL
     AND NOT EXISTS (
       SELECT 1 FROM campaign_messages cm
       WHERE cm.account_id = a.id
         AND cm.sent_at > NOW() - INTERVAL '7 days'
     );
   ```
3. For each eligible account:
   a. Selects the primary contact (decision_maker = true, preferred_channel = email).
   b. Validates contact is not on DNL and has a valid email.
   c. Determines the nurture sequence step:
      - Step 1: Industry insight email (educational, no CTA)
      - Step 2: Case study relevant to their industry/region
      - Step 3: Soft CTA ("Would a quick overview be useful?")
      - Step 4: Break email ("Closing the loop -- still relevant?")
   d. Fetches the appropriate nurture template from GHL or campaign config.
   e. Creates a pending outreach record in `campaign_messages` with `scheduled_at` = today + timezone offset.
4. The Outreach-Queue-Processor picks up these records and sends them via Channel-Sender-Instantly.
5. Logs summary: accounts nurtures, sequence step distribution.

**Expected Duration:** 1-3 minutes.

---

## Input/Output Data Shapes

**Input:**
- None (cron-triggered). Reads from database.

**Output:**
- New pending rows in `campaign_messages`:
```json
{
  "contact_id": "uuid",
  "account_id": "uuid",
  "channel": "email",
  "status": "pending",
  "scheduled_at": "2026-04-14T10:00:00+04:00",
  "metadata": {
    "nurture_step": 2,
    "nurture_type": "case_study",
    "sequence": "warm_nurture"
  }
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| No warm accounts found | 0 records queued | Normal if all accounts are hot, cool, or cold. Check scoring distribution to verify. |
| Too many warm accounts (>200) | Large queue created | Expected during growth phases. The queue processor handles volume. Monitor send rate to avoid Instantly rate limits. |
| Contact missing email | Can't schedule nurture for account | Skip the account. Log for contact enrichment. The account may only have LinkedIn contacts. |
| Nurture step tracking lost | Contacts receive Step 1 repeatedly | Track nurture step in `campaign_messages.metadata` or a separate `nurture_sequences` tracking table. If metadata is missing, default to Step 1. |
| Account score changes mid-sequence | Account goes from warm to hot between steps | Before sending, re-check the latest score. If now hot, let the main activation flow handle it (Routing-Master will schedule multi-channel outreach). Skip the nurture send. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Nurture emails queued per day (expect 10-50 per customer)
  - Open rate on nurture emails (target: >30% -- higher than cold because warmer relationship)
  - Reply rate on nurture emails (target: >5%)
  - Warm-to-hot conversion rate (accounts that move from warm to hot after nurture)
  - Unsubscribe rate (target: <1%)
- **Alert thresholds:**
  - 0 nurture emails for 7+ days -> check if warm accounts exist, check workflow status
  - Open rate <15% -> nurture content may be stale, review templates
  - Unsubscribe rate >3% -> nurture cadence too aggressive, increase interval

---

## Dependencies

- **APIs:** None directly (creates records for Outreach-Queue-Processor)
- **Tables:**
  - `lead_scores_history` / `account_intent_scores` view (read: find warm accounts)
  - `campaign_messages` / `activation_outreach` view (read: check recent outreach; write: create nurture records)
  - `individual_entities` / `contacts` view (read: select nurture contact)
  - `campaigns` (read: nurture email templates)
- **Other workflows:**
  - Creates work for: Outreach-Queue-Processor -> Channel-Sender-Instantly
- **Circuit breakers:** None (no direct API calls).

---

## Manual Execution

```bash
# Run nurture sequencer manually
curl -X POST https://testflow.smorchestra.ai:5170/webhook/nurture-email-sequencer \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Run for a specific customer
curl -X POST https://testflow.smorchestra.ai:5170/webhook/nurture-email-sequencer \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "customer_id": "uuid-here"}'

# Dry run
curl -X POST https://testflow.smorchestra.ai:5170/webhook/nurture-email-sequencer \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "dry_run": true}'
```

---

## Nurture Content Strategy

- Step 1 (Week 1): Industry insight -- share a relevant data point or trend. No CTA. Build credibility.
- Step 2 (Week 2): Case study -- a MENA-relevant success story matching their industry/size.
- Step 3 (Week 3): Soft CTA -- "Would a 15-minute overview of how [similar company] achieved X be useful?"
- Step 4 (Week 4): Break email -- "I'll close the loop here. If timing changes, here's my calendar link."
- After Step 4: account re-enters the scoring cycle. If still warm after 4 weeks, restart at Step 1 with fresh content.
- Content should be signal-aware: reference the specific signals that make this account warm.
