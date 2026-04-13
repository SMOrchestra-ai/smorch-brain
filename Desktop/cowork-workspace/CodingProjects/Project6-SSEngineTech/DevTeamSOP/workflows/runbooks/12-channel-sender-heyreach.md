# Runbook: Channel-Sender-HeyReach

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Called by Outreach-Queue-Processor
**Layer:** Activation
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Sends LinkedIn connection requests and messages via the HeyReach API. Receives an outreach record from the queue processor, fetches the contact's LinkedIn URL, constructs the message, and dispatches it through HeyReach.

---

## Expected Behavior (Happy Path)

1. Receives outreach record from Outreach-Queue-Processor:
   - `outreach_id`, `contact_id`, `account_id`, `customer_id`, `channel = 'linkedin'`
2. Fetches the contact's `linkedin_url` from `contacts` table.
3. Validates the LinkedIn URL format (must be a valid linkedin.com/in/ URL).
4. Fetches the LinkedIn message template (from `campaigns.message_templates` jsonb).
5. Renders merge tags: `{{first_name}}`, `{{company_name}}`, `{{job_title}}`, `{{signal_context}}`.
6. Determines the action type:
   - If no existing connection: send connection request with note (max 300 chars).
   - If already connected: send direct message.
7. Calls HeyReach API:
   ```
   POST https://api.heyreach.io/api/v1/campaigns/{campaign_id}/actions
   {
     "linkedin_url": "https://linkedin.com/in/prospect",
     "action_type": "connection_request" | "message",
     "message": "rendered message text"
   }
   ```
8. Receives response with action ID.
9. Returns success to queue processor.
10. Logs in `audit_log`.

**Expected Duration:** 2-5 seconds per action.

---

## Input/Output Data Shapes

**Input:**
```json
{
  "outreach_id": "uuid",
  "contact_id": "uuid",
  "account_id": "uuid",
  "customer_id": "uuid",
  "channel": "linkedin",
  "template_id": "uuid or inline",
  "signal_context": "Recently changed job to CRO at target company"
}
```

**Output (Success):**
```json
{
  "success": true,
  "message_id": "hr_action_xxx",
  "channel": "linkedin",
  "action_type": "connection_request",
  "linkedin_url": "https://linkedin.com/in/prospect"
}
```

**Output (Failure):**
```json
{
  "success": false,
  "error": "HeyReach: LinkedIn account daily limit reached",
  "channel": "linkedin",
  "retryable": true
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| HeyReach API 401 | Unauthorized | API key expired. Update in n8n credentials. |
| HeyReach API 429 | Rate limited | HeyReach has strict limits (~30 req/min). Return retryable=true. |
| LinkedIn daily limit reached | HeyReach returns limit error | Expected -- LinkedIn allows ~100 connection requests/day. Return retryable=true with next retry scheduled for tomorrow 9am. |
| LinkedIn account restricted/suspended | HeyReach returns suspension notice | CRITICAL: Stop all LinkedIn activity for this account immediately. Alert Mamoun. Do NOT retry. Restrictions escalate with continued activity. |
| Invalid LinkedIn URL | 404 or profile not found | Mark outreach as failed (non-retryable). Log for contact data cleanup. |
| Connection request note >300 chars | HeyReach rejects the message | Truncate the message to 300 chars. LinkedIn enforces this limit on connection notes. |
| Already connected | Connection request returns "already connected" | Switch to direct message action instead. This is not an error -- update the action type and resend. |

---

## Monitoring

- **Where to check:** n8n execution logs, HeyReach dashboard, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - LinkedIn actions sent per day (respect daily limits)
  - Connection request acceptance rate (target: >20%)
  - Message reply rate (target: >8%)
  - API error rate (target: <5%)
  - LinkedIn account health (no restrictions)
- **Alert thresholds:**
  - LinkedIn account restriction -> immediate escalation
  - Connection acceptance rate <5% -> targeting or messaging issue
  - API error rate >10% -> HeyReach platform issue

---

## Dependencies

- **APIs:** HeyReach API (https://api.heyreach.io/api/v1/)
- **Tables:**
  - `individual_entities` / `contacts` view (read: linkedin_url)
  - `company_entities` / `accounts` view (read: company details for merge tags)
  - `campaigns` (read: LinkedIn message template)
  - `audit_log` (write: log actions)
- **Other workflows:** Called by Outreach-Queue-Processor only.
- **Circuit breakers:** `circuit_breaker_state` entry for `heyreach`.

---

## Manual Execution

```bash
# Send a test LinkedIn action
curl -X POST https://testflow.smorchestra.ai:5170/webhook/channel-sender-heyreach \
  -H "Content-Type: application/json" \
  -d '{
    "outreach_id": "test-uuid",
    "contact_id": "test-contact-uuid",
    "account_id": "test-account-uuid",
    "customer_id": "test-customer-uuid",
    "channel": "linkedin",
    "test_mode": true
  }'
```

---

## LinkedIn Best Practices

- Connection request notes should be personal and reference a specific signal (e.g., "Saw your company raised a Series B -- congratulations").
- Keep notes under 200 chars for best acceptance rates (even though 300 is the limit).
- Never send generic "I'd like to connect" messages -- always include signal context.
- LinkedIn is most effective for decision-makers (C-suite, VP-level).
- Best send times for MENA: Sunday-Thursday 8am-10am local time.
- Cost: 2 credits per LinkedIn action (connection request or message).
