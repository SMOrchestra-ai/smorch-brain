# Runbook: Channel-Sender-GHL

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Called by Outreach-Queue-Processor
**Layer:** Activation
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Sends WhatsApp messages and SMS via the GoHighLevel (GHL) API. Receives an outreach record from the queue processor, formats the message for the appropriate channel, and dispatches it through GHL's messaging infrastructure. Also handles CRM contact sync.

---

## Expected Behavior (Happy Path)

1. Receives outreach record from Outreach-Queue-Processor:
   - `outreach_id`, `contact_id`, `account_id`, `customer_id`, `channel = 'whatsapp' or 'sms'`
2. Fetches the contact's phone number from `contacts` table.
3. Validates phone format (E.164: +971xxxxxxxxx for UAE, +966xxxxxxxxx for Saudi, etc.).
4. Fetches the message template from `campaigns.message_templates` jsonb.
5. Renders merge tags: `{{first_name}}`, `{{company_name}}`, `{{signal_context}}`.
6. Checks if the contact exists in GHL CRM:
   - If not: creates the contact in GHL first (sync from SSE to GHL).
   - If exists: updates contact data if needed.
7. Calls GHL API to send the message:
   ```
   POST https://rest.gohighlevel.com/v1/conversations/messages
   {
     "type": "WhatsApp" | "SMS",
     "contactId": "ghl_contact_id",
     "message": "rendered message text"
   }
   ```
8. Receives response with message ID.
9. Returns success to queue processor.
10. Logs in `audit_log`.

**Expected Duration:** 2-5 seconds per message.

---

## Input/Output Data Shapes

**Input:**
```json
{
  "outreach_id": "uuid",
  "contact_id": "uuid",
  "account_id": "uuid",
  "customer_id": "uuid",
  "channel": "whatsapp",
  "template_id": "uuid or inline",
  "signal_context": "Company expanding to Saudi, relevant case study"
}
```

**Output (Success):**
```json
{
  "success": true,
  "message_id": "ghl_msg_xxx",
  "channel": "whatsapp",
  "recipient": "+971501234567",
  "ghl_contact_id": "ghl_contact_xxx"
}
```

**Output (Failure):**
```json
{
  "success": false,
  "error": "GHL: WhatsApp template not approved",
  "channel": "whatsapp",
  "retryable": false
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| GHL API 401 | Unauthorized | API key expired or location ID wrong. Update in n8n credentials. Check GHL dashboard. |
| GHL API 429 | Rate limited | GHL allows ~100 req/min. Return retryable=true. |
| Invalid phone number | GHL returns validation error | Verify E.164 format. Common issues: missing country code, extra spaces, wrong length. Mark as non-retryable, log for contact cleanup. |
| WhatsApp template not approved | GHL rejects the message | WhatsApp Business requires pre-approved message templates for first contact. Submit the template in GHL for Meta approval. Use SMS as fallback channel. |
| WhatsApp 24-hour window expired | Can't send free-form message | Outside the 24-hour engagement window, only approved templates can be sent. Switch to template-based message or wait for prospect to respond. |
| Contact not found in GHL | GHL contact creation needed | Create the contact first via GHL API, then send. If creation fails, return failure. |
| GHL webhook signature mismatch | Custom HMAC validation fails | Known tech debt: GHL webhook verification is custom, not standard. Verify implementation against GHL docs. |
| Phone number on MENA DNC list | Legal compliance risk | Check against customer's suppress list before sending. If on DNC, do not send. Mark `do_not_contact = true`. |

---

## Monitoring

- **Where to check:** n8n execution logs, GHL dashboard, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Messages sent per hour (WhatsApp + SMS combined)
  - Delivery rate (target: >95% for SMS, >90% for WhatsApp)
  - Reply rate (target: >25% for WhatsApp -- highest of all channels)
  - Contact sync success rate (SSE to GHL)
  - Template approval status in GHL/Meta
- **Alert thresholds:**
  - Delivery rate <80% -> phone number quality issue or carrier problems
  - WhatsApp template rejections -> review template compliance with Meta policies
  - GHL API down for >15 min -> pause WhatsApp/SMS queue, use email/LinkedIn

---

## Dependencies

- **APIs:** GoHighLevel API (https://rest.gohighlevel.com/v1/)
- **Tables:**
  - `individual_entities` / `contacts` view (read: phone number, E.164 format)
  - `company_entities` / `accounts` view (read: company details for merge tags)
  - `campaigns` (read: WhatsApp/SMS message template)
  - `audit_log` (write: log sends)
- **Other workflows:** Called by Outreach-Queue-Processor only.
- **Circuit breakers:** `circuit_breaker_state` entry for `ghl`.

---

## Manual Execution

```bash
# Send a test WhatsApp message
curl -X POST https://testflow.smorchestra.ai:5170/webhook/channel-sender-ghl \
  -H "Content-Type: application/json" \
  -d '{
    "outreach_id": "test-uuid",
    "contact_id": "test-contact-uuid",
    "account_id": "test-account-uuid",
    "customer_id": "test-customer-uuid",
    "channel": "whatsapp",
    "test_mode": true
  }'

# Send a test SMS
curl -X POST https://testflow.smorchestra.ai:5170/webhook/channel-sender-ghl \
  -H "Content-Type: application/json" \
  -d '{
    "outreach_id": "test-uuid",
    "contact_id": "test-contact-uuid",
    "channel": "sms",
    "test_mode": true
  }'
```

---

## MENA Phone Number Notes

- UAE: +971 5x xxx xxxx (mobile), country code required
- Saudi Arabia: +966 5x xxx xxxx (mobile)
- Qatar: +974 xxxx xxxx (8 digits, no area code)
- Kuwait: +965 xxxx xxxx (8 digits)
- Always store and send in E.164 format (no spaces, no dashes, with + prefix).
- WhatsApp is the dominant messaging channel in MENA -- higher reply rates than email or LinkedIn.
- Arabic messages: use Gulf conversational Arabic, not MSA. Keep messages short (<3 paragraphs).
- Respect business hours: Sun-Thu 9am-5pm local time. Never send outside these hours.
- Cost: 1.5 credits per WhatsApp/SMS send.
