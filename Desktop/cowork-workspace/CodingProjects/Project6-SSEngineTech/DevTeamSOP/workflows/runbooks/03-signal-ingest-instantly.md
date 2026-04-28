# Runbook: Signal-Ingest-Instantly

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Triggered by Signal-Ingestion-Master / Instantly webhook (real-time)
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Receives email engagement events from Instantly.ai (opens, clicks, replies, bounces) via HMAC-signed webhooks. Also polled by the master workflow on a 4-hour cycle for any missed events. These signals feed directly into intent scoring.

---

## Expected Behavior (Happy Path)

### Webhook Mode (Real-Time)
1. Instantly sends an HTTP POST to the n8n webhook endpoint when an email event occurs.
2. Workflow validates the HMAC signature in the `X-Instantly-Signature` header against the shared secret stored in n8n credentials.
3. Parses the webhook payload to extract: event_type, recipient_email, campaign_id, timestamp, metadata.
4. Looks up the contact in `contacts` table by email address.
5. If contact found, looks up the associated `account_id`.
6. Generates `dedup_key` = `{signal_type}_{account_id}_{date}`.
7. Inserts into `signals` table with appropriate `signal_type`:
   - `email_open` (confidence: 60 -- opens can be unreliable due to pixel blocking)
   - `email_click` (confidence: 85 -- strong intent signal)
   - `email_reply` (confidence: 95 -- strongest email signal)
   - `email_bounce` (confidence: 100 -- definitive, triggers contact data cleanup)
8. For replies, also stores the reply text in `signal_value.reply_text` for AI analysis.
9. Returns HTTP 200 to Instantly within 5 seconds (avoid webhook timeout).

### Polling Mode (4-Hour Cycle)
1. Triggered by Signal-Ingestion-Master.
2. Calls Instantly API to fetch events since `last_sync_at`.
3. Processes events same as webhook mode (steps 3-8).
4. Acts as a safety net for any missed webhooks.

**Expected Duration:** <10 seconds per webhook; 1-2 minutes for polling batch.

---

## Input/Output Data Shapes

**Input (Webhook):**
```json
{
  "event": "email_opened",
  "data": {
    "email": "prospect@company.com",
    "campaign_id": "camp_xxx",
    "timestamp": "2026-04-14T10:30:00Z",
    "subject": "Re: Signal-based growth for MENA",
    "metadata": {
      "ip": "185.x.x.x",
      "user_agent": "Mozilla/5.0...",
      "location": "Dubai, AE"
    }
  }
}
```

**Output:**
- Row in `signals` table:
```json
{
  "account_id": "uuid",
  "signal_type": "email_open",
  "source": "instantly",
  "signal_value": {
    "campaign_id": "camp_xxx",
    "recipient_email": "prospect@company.com",
    "subject": "Re: Signal-based growth for MENA",
    "location": "Dubai, AE"
  },
  "confidence_score": 60,
  "dedup_key": "email_open_abc123_2026-04-14"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Invalid HMAC signature | Webhook returns HTTP 401, logged as security event | Verify the HMAC secret matches between Instantly dashboard and n8n credential store. If recently rotated, update n8n. |
| Contact not found by email | Signal logged with `account_id = null`, warning in execution log | The prospect may not be in SSE yet. Queue for account creation or log as unmatched for review. |
| Instantly webhook timeout (>30s) | Instantly retries, potential duplicate events | Ensure workflow responds within 5s. Move heavy processing (DB writes) to async sub-workflow if needed. Dedup key prevents duplicate signals. |
| Instantly API 401 on polling | HTTP 401 from Instantly API | API key expired. Update in n8n credential store. Check Instantly dashboard. |
| Instantly API rate limit (429) | Polling returns 429 | Back off and retry. Instantly allows ~60 requests/min. Reduce polling batch size. |
| Bounce event for valid contact | Signal created with type `email_bounce` | Mark contact's email as invalid. Update `contacts.email` status. Do NOT send further emails to this address. |
| High volume of opens from same IP | Many `email_open` signals from bot-like behavior | These are likely email security scanners (Barracuda, Mimecast). Filter by known scanner user-agents. Reduce confidence for suspicious opens. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Webhook events per hour (varies by campaign volume)
  - Event type distribution (opens >> clicks >> replies >> bounces)
  - HMAC validation failure rate (target: 0% -- any failures = security concern)
  - Contact match rate (target: >90%)
  - Webhook response time (target: <5s p99)
- **Alert thresholds:**
  - HMAC failures >0 -> investigate immediately (potential spoofing)
  - 0 events for 24+ hours during active campaigns -> check Instantly webhook config
  - Bounce rate >10% for any campaign -> alert Mamoun (list quality issue)

---

## Dependencies

- **APIs:** Instantly.ai API (https://api.instantly.ai/api/v1/)
- **Tables:**
  - `signals` (write: insert email events)
  - `individual_entities` / `contacts` view (read: lookup by email)
  - `company_entities` / `accounts` view (read: get account_id from contact)
  - `signal_sources` (read: Instantly config)
  - `circuit_breaker_state` (read/write: Instantly CB)
- **Other workflows:** Called by Signal-Ingestion-Master (polling mode). Triggers Scoring-Master on new signal insertion.
- **Circuit breakers:** `circuit_breaker_state` entry for `instantly`. Opens after 5 consecutive API failures, 1-hour cooldown.

---

## Manual Execution

```bash
# Test webhook endpoint with a sample event
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-instantly \
  -H "Content-Type: application/json" \
  -H "X-Instantly-Signature: test-hmac-value" \
  -d '{
    "event": "email_opened",
    "data": {
      "email": "test@example.com",
      "campaign_id": "camp_test",
      "timestamp": "2026-04-14T10:00:00Z"
    }
  }'

# Trigger polling mode manually
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-instantly \
  -H "Content-Type: application/json" \
  -d '{"mode": "poll", "manual": true}'
```

---

## Security Notes

- HMAC signature verification is mandatory. Never disable it, even for testing.
- The webhook endpoint is publicly accessible -- signature validation is the only auth layer.
- Log all failed signature validations to Sentry with the request IP for incident response.
- Rotate the HMAC secret quarterly. Coordinate rotation with Instantly dashboard update.
