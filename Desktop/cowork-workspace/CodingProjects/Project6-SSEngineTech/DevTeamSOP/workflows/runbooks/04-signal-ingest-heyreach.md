# Runbook: Signal-Ingest-HeyReach

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Triggered by Signal-Ingestion-Master / HeyReach webhook (real-time)
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Receives LinkedIn engagement events from HeyReach (profile views, connection requests sent/accepted, messages sent/replied) via signed webhooks. Also polled on the 4-hour master cycle. LinkedIn signals are high-value indicators of professional intent.

---

## Expected Behavior (Happy Path)

### Webhook Mode (Real-Time)
1. HeyReach sends an HTTP POST to the n8n webhook endpoint on LinkedIn engagement events.
2. Workflow validates the signed payload against the HeyReach secret in n8n credentials.
3. Parses the payload: event_type, linkedin_url, profile_name, campaign_id, timestamp.
4. Looks up the contact in `contacts` table by `linkedin_url`.
5. If contact found, resolves `account_id` via the contact's account association.
6. Generates `dedup_key` = `{signal_type}_{account_id}_{date}`.
7. Inserts into `signals` table:
   - `linkedin_profile_view` (confidence: 50 -- passive signal)
   - `linkedin_connection_sent` (confidence: 40 -- outbound action, not intent)
   - `linkedin_connection_accepted` (confidence: 75 -- mutual interest)
   - `linkedin_message_reply` (confidence: 90 -- strong intent)
8. Returns HTTP 200 within 5 seconds.

### Polling Mode (4-Hour Cycle)
1. Triggered by Signal-Ingestion-Master.
2. Calls HeyReach API to fetch campaign activity since `last_sync_at`.
3. Processes events same as webhook mode.

**Expected Duration:** <10 seconds per webhook; 1-3 minutes for polling batch.

---

## Input/Output Data Shapes

**Input (Webhook):**
```json
{
  "event_type": "connection_accepted",
  "data": {
    "linkedin_url": "https://linkedin.com/in/ahmed-alfarsi",
    "profile_name": "Ahmed Al-Farsi",
    "campaign_id": "hr_camp_xxx",
    "timestamp": "2026-04-14T11:00:00Z",
    "company": "Tech Corp Dubai"
  }
}
```

**Output:**
- Row in `signals` table:
```json
{
  "account_id": "uuid",
  "signal_type": "linkedin_connection_accepted",
  "source": "heyreach",
  "signal_value": {
    "linkedin_url": "https://linkedin.com/in/ahmed-alfarsi",
    "profile_name": "Ahmed Al-Farsi",
    "campaign_id": "hr_camp_xxx",
    "company": "Tech Corp Dubai"
  },
  "confidence_score": 75,
  "dedup_key": "linkedin_connection_accepted_abc123_2026-04-14"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Invalid webhook signature | HTTP 401 returned, Sentry alert | Verify shared secret matches HeyReach dashboard config and n8n credential. |
| Contact not found by LinkedIn URL | Signal logged with null account_id | LinkedIn URL format may vary (with/without trailing slash, www prefix). Normalize URLs before lookup. Queue unmatched for manual review. |
| HeyReach API 401 | Polling returns unauthorized | API key expired. Update in n8n credentials. Check HeyReach dashboard. |
| HeyReach API 429 | Rate limited | HeyReach has strict rate limits (~30 req/min). Add delays between batch requests. |
| LinkedIn account restricted | HeyReach reports account suspension | Stop all LinkedIn outreach for affected accounts immediately. Alert Mamoun. Do NOT retry -- LinkedIn restrictions escalate with continued activity. |
| Duplicate connection events | Same connection reported multiple times | Dedup key handles this. If HeyReach sends both "sent" and "accepted" for same connection on same day, both are valid distinct signal types. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Events per hour (lower volume than email -- LinkedIn has daily limits)
  - Connection acceptance rate (target: >20% for well-targeted campaigns)
  - Message reply rate (target: >8%)
  - Contact match rate by LinkedIn URL (target: >85%)
- **Alert thresholds:**
  - Signature failures >0 -> investigate immediately
  - 0 events for 48+ hours during active campaigns -> check HeyReach campaign status
  - LinkedIn account restriction event -> immediate escalation to Mamoun
  - Connection acceptance rate <5% -> campaign targeting issue, review ICP

---

## Dependencies

- **APIs:** HeyReach API (https://api.heyreach.io/api/v1/)
- **Tables:**
  - `signals` (write: insert LinkedIn events)
  - `individual_entities` / `contacts` view (read: lookup by linkedin_url)
  - `company_entities` / `accounts` view (read: get account_id)
  - `signal_sources` (read: HeyReach config)
  - `circuit_breaker_state` (read/write: HeyReach CB)
- **Other workflows:** Called by Signal-Ingestion-Master. Triggers Scoring-Master on signal insert.
- **Circuit breakers:** `circuit_breaker_state` entry for `heyreach`. Opens after 5 consecutive failures, 1-hour cooldown.

---

## Manual Execution

```bash
# Test webhook endpoint
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-heyreach \
  -H "Content-Type: application/json" \
  -H "X-HeyReach-Signature: test-signature" \
  -d '{
    "event_type": "message_reply",
    "data": {
      "linkedin_url": "https://linkedin.com/in/test-user",
      "profile_name": "Test User",
      "campaign_id": "hr_test",
      "timestamp": "2026-04-14T12:00:00Z"
    }
  }'

# Trigger polling mode
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-heyreach \
  -H "Content-Type: application/json" \
  -d '{"mode": "poll", "manual": true}'
```

---

## LinkedIn-Specific Considerations

- LinkedIn has daily connection request limits (~100/day per account). HeyReach manages this, but SSE must respect it.
- Profile view signals are noisy -- many are bots or random browsing. Weight accordingly.
- Connection acceptance is a much stronger signal in MENA markets where LinkedIn usage is more intentional.
- Message replies from LinkedIn are the second-strongest signal after meeting bookings.
- Always normalize LinkedIn URLs: strip trailing slashes, remove query params, lowercase.
