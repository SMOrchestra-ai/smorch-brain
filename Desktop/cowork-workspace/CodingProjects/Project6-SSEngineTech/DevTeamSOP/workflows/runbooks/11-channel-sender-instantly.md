# Runbook: Channel-Sender-Instantly

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Called by Outreach-Queue-Processor
**Layer:** Activation
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Sends cold emails via the Instantly.ai API. Receives an outreach record from the queue processor, fetches the email template, renders merge tags, sends the email, and returns the external message ID for tracking.

---

## Expected Behavior (Happy Path)

1. Receives outreach record from Outreach-Queue-Processor:
   - `outreach_id`, `contact_id`, `account_id`, `customer_id`, `channel = 'email'`
2. Fetches the contact's email address from `contacts` table.
3. Fetches the campaign's email template (from `campaigns.message_templates` jsonb field).
4. Renders merge tags in the template:
   - `{{first_name}}` -> contact's first name
   - `{{company_name}}` -> account's company name
   - `{{job_title}}` -> contact's job title
   - `{{signal_context}}` -> relevant signal data from the scoring reasoning
5. Calls Instantly.ai API to send the email:
   ```
   POST https://api.instantly.ai/api/v1/email/send
   {
     "campaign_id": "xxx",
     "to": "prospect@company.com",
     "subject": "rendered subject",
     "body": "rendered body",
     "from": "customer's sending email"
   }
   ```
6. Receives response with `message_id` from Instantly.
7. Returns success to queue processor:
   ```json
   { "success": true, "message_id": "inst_msg_xxx", "channel": "email" }
   ```
8. Logs the send in `audit_log`.

**Expected Duration:** 1-3 seconds per email.

---

## Input/Output Data Shapes

**Input:**
```json
{
  "outreach_id": "uuid",
  "contact_id": "uuid",
  "account_id": "uuid",
  "customer_id": "uuid",
  "channel": "email",
  "template_id": "uuid or inline",
  "signal_context": "Funding round detected, recommend case study"
}
```

**Output (Success):**
```json
{
  "success": true,
  "message_id": "inst_msg_abc123",
  "channel": "email",
  "recipient": "prospect@company.com",
  "sent_at": "2026-04-14T09:01:00Z"
}
```

**Output (Failure):**
```json
{
  "success": false,
  "error": "Instantly API returned 422: invalid recipient email",
  "channel": "email",
  "retryable": false
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Instantly API 401 | Unauthorized | API key expired. Update in n8n credentials. Check Instantly dashboard. |
| Instantly API 422 (invalid email) | Validation error | Mark the contact's email as invalid. Set outreach status to `failed` (non-retryable). Do not retry. |
| Instantly API 429 (rate limit) | Too many requests | Back off. Instantly allows ~60 sends/min. Return retryable=true so queue processor retries later. |
| Instantly API 500/503 | Server error | Transient. Return retryable=true. Queue processor handles retry with backoff. |
| Template rendering fails | Merge tag not found, null values | Use fallback values: `{{first_name}}` -> "there", `{{company_name}}` -> "your company". Log warning for data cleanup. |
| Sending domain blacklisted | Emails bouncing at high rate | Stop all sends from this domain. Alert Mamoun. Check domain reputation. May need to warm up a new sending domain. |
| Campaign not found in Instantly | campaign_id mismatch | Verify campaign exists in Instantly dashboard. May have been archived or deleted. |

---

## Monitoring

- **Where to check:** n8n execution logs, Instantly.ai dashboard, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Emails sent per hour
  - Send success rate (target: >98%)
  - API response time (target: <3s p95)
  - Bounce rate (from Instantly webhooks, target: <5%)
  - Reply rate (from Instantly webhooks, target: >15%)
- **Alert thresholds:**
  - Send success rate <90% -> Instantly API issue or sending domain problem
  - Bounce rate >10% -> list quality issue, pause sends and investigate
  - 0 emails sent for 1+ hour during active campaigns -> workflow or API issue

---

## Dependencies

- **APIs:** Instantly.ai API (https://api.instantly.ai/api/v1/)
- **Tables:**
  - `individual_entities` / `contacts` view (read: email address)
  - `company_entities` / `accounts` view (read: company name for merge tags)
  - `campaigns` (read: email template from message_templates jsonb)
  - `audit_log` (write: log send events)
- **Other workflows:** Called by Outreach-Queue-Processor only.
- **Circuit breakers:** `circuit_breaker_state` entry for `instantly`. Outreach-Queue-Processor checks this before calling.

---

## Manual Execution

```bash
# Send a test email (use a test contact, not production)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/channel-sender-instantly \
  -H "Content-Type: application/json" \
  -d '{
    "outreach_id": "test-uuid",
    "contact_id": "test-contact-uuid",
    "account_id": "test-account-uuid",
    "customer_id": "test-customer-uuid",
    "channel": "email",
    "test_mode": true
  }'
```

---

## Deliverability Notes

- Instantly manages sending domain warmup and rotation automatically.
- Each customer should have their own sending domains configured in Instantly.
- Never send more than 50 emails/day per sending account during warmup (first 14 days).
- Monitor domain reputation via Instantly's built-in health checks.
- If a domain gets blacklisted, do NOT try to send from it. Rotate to a backup domain immediately.
