# Webhook Setup Reference

## Table of Contents
1. Available Event Types
2. Webhook Configuration
3. Signal Priority Framework
4. n8n Integration Patterns
5. Webhook Management
6. Troubleshooting

---

## 1. Available Event Types

HeyReach supports 13 webhook event types:

### Critical Signals (Always Configure)
| Event Type | Signal Value | Why It Matters |
|-----------|-------------|----------------|
| `CONNECTION_REQUEST_ACCEPTED` | High | Lead is now a connection — ready for messaging |
| `MESSAGE_REPLY_RECEIVED` | Highest | Direct engagement — needs human review |
| `EVERY_MESSAGE_REPLY_RECEIVED` | Highest | Catches all replies including from non-campaign messages |

### Important Signals (Recommended)
| Event Type | Signal Value | Why It Matters |
|-----------|-------------|----------------|
| `INMAIL_REPLY_RECEIVED` | High | InMail engagement from non-connections |
| `LEAD_FINISHED_SEQUENCE_WITHOUT_REPLYING` | Medium | Indicates need for alternative approach |
| `CAMPAIGN_COMPLETED` | Low | Lifecycle tracking |

### Supplementary Signals (Optional)
| Event Type | Signal Value | Why It Matters |
|-----------|-------------|----------------|
| `CONNECTION_REQUEST_SENT` | Low | Activity tracking |
| `MESSAGE_SENT` | Low | Activity tracking |
| `INMAIL_SENT` | Low | Activity tracking |
| `FOLLOW_SENT` | Low | Soft engagement signal |
| `LIKED_POST` | Low | Soft engagement signal |
| `VIEWED_PROFILE` | Low | Awareness indicator |
| `LEAD_TAG_UPDATED` | Medium | Routing trigger |

---

## 2. Webhook Configuration

### Default Webhook Endpoint
```
https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-signal
```

### Webhook Naming Convention
Format: `[Event]-[Dest]` (max 25 characters)

Examples:
- `ConnAccept-n8n Signal` (24 chars)
- `Reply-n8n Signal` (16 chars)
- `SeqDone-n8n Signal` (18 chars)
- `InMail-n8n Signal` (17 chars)

### Creating a Webhook
```json
{
  "webhookName": "Reply-n8n Signal",
  "webhookUrl": "https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-signal",
  "eventType": "MESSAGE_REPLY_RECEIVED",
  "campaignIds": [336673, 313034]  // Scope to specific campaigns, empty = all
}
```

### Minimum Recommended Setup
For any new campaign, configure these 3 webhooks:
1. `CONNECTION_REQUEST_ACCEPTED` — Trigger warm follow-up timing
2. `MESSAGE_REPLY_RECEIVED` — Alert for human review + tag update
3. `LEAD_FINISHED_SEQUENCE_WITHOUT_REPLYING` — Route to alternative channel

### Global vs Campaign-Scoped
- **Campaign-scoped** (`campaignIds: [123, 456]`): Only fires for events in those campaigns. Preferred for targeted routing.
- **Global** (`campaignIds: []` or `null`): Fires for ALL campaigns. Use for universal signal capture.

Recommendation: Start with campaign-scoped for active campaigns. Add a global `EVERY_MESSAGE_REPLY_RECEIVED` as a safety net to catch anything missed.

---

## 3. Signal Priority Framework

### Signal Routing Matrix
| Event | Priority | Action in n8n | GHL Update |
|-------|----------|--------------|------------|
| MESSAGE_REPLY_RECEIVED | P1 - Immediate | Score lead, alert user, tag in GHL | `signal:linkedin_replied`, update pipeline stage |
| INMAIL_REPLY_RECEIVED | P1 - Immediate | Score lead, alert user | `signal:inmail_replied`, update pipeline stage |
| CONNECTION_REQUEST_ACCEPTED | P2 - Within 1h | Tag lead, schedule follow-up timing | `signal:connection_accepted` |
| LEAD_FINISHED_SEQUENCE_WITHOUT_REPLYING | P3 - Daily batch | Route to email channel (Instantly) | `signal:linkedin_no_reply` |
| CAMPAIGN_COMPLETED | P4 - Weekly review | Archive campaign, trigger report | Update campaign status |

### Signal-to-Score Mapping
| Signal | Score Update | Next Action |
|--------|-------------|-------------|
| Connection accepted | cold → warm | Wait 24h, then first message fires automatically |
| Reply (positive) | warm → hot | Alert user, pause other channels for this lead |
| Reply (negative/not interested) | → cold | Stop sequence, tag, remove from other channels |
| Reply (neutral/question) | → warm | Alert user for manual response |
| Sequence complete, no reply | stays cold | Move to email channel after 7-day cooldown |
| InMail reply | → hot | High intent signal — prioritize |

---

## 4. n8n Integration Patterns

### Pattern 1: Direct Signal Processing
```
HeyReach Webhook → n8n Webhook Node → Switch by Event Type
    → CONNECTION_REQUEST_ACCEPTED → Tag lead in HeyReach + Update GHL
    → MESSAGE_REPLY_RECEIVED → Classify sentiment → Route to user alert
    → SEQUENCE_COMPLETE → Route to Instantly for email follow-up
```

### Pattern 2: Signal Scoring Pipeline
```
HeyReach Webhook → n8n Webhook Node → Enrich signal data
    → Calculate signal score (based on event type + lead ICP tier)
    → Update GHL contact with new score
    → If score crosses threshold → Trigger alert / move pipeline stage
    → Log to tracking sheet
```

### Pattern 3: Cross-Channel Coordination
```
HeyReach Webhook (reply received) → n8n
    → Check: Is lead also in Instantly campaign?
        → YES: Pause lead in Instantly
    → Check: Does GHL contact exist?
        → YES: Update tags and pipeline
        → NO: Create GHL contact with LinkedIn data
    → Send Slack/email alert to user
```

### Webhook Payload Processing
HeyReach webhooks send JSON payloads. Key fields to extract in n8n:
- `event_type` — Which event fired
- `lead` — Lead data (name, LinkedIn URL, company, etc.)
- `campaign` — Campaign ID and name
- `account` — Which sender account
- `message` — Message content (for reply events)
- `timestamp` — When the event occurred

### n8n Webhook URL Patterns
- Single endpoint for all events: `https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-signal`
- Event-specific endpoints: `https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-{event}`

Recommendation: Use single endpoint with event type switching in n8n for simplicity.

---

## 5. Webhook Management

### Auditing Existing Webhooks
1. `get_all_webhooks()` — List all configured webhooks
2. For each webhook, verify:
   - URL is correct and reachable
   - Event type matches intended signal capture
   - Campaign scope is still relevant (not pointing to finished/deleted campaigns)
   - Webhook is active

### Updating Webhook Scope
When campaigns change (new campaigns added, old ones finished):
1. Identify webhooks scoped to finished campaigns
2. Update `campaignIds` array to include new active campaigns
3. Remove finished campaign IDs from scope

### Cleanup Protocol
Monthly review:
1. List all webhooks
2. Cross-reference with active campaigns
3. Delete webhooks for campaigns that are FINISHED or CANCELED with no reuse planned
4. Verify n8n endpoints are still receiving and processing payloads

---

## 6. Troubleshooting

### Webhook Not Firing
1. Verify webhook exists: `get_all_webhooks()`
2. Check webhook status is active: `get_webhook_by_id(id)`
3. Verify campaign scope includes the relevant campaign
4. Test n8n endpoint manually (cURL or n8n test webhook)
5. Check if event is actually occurring (is the campaign running?)

### Duplicate Events
- HeyReach may send retry events if endpoint returns non-200
- n8n should implement idempotency (check event ID if available)
- Use n8n's built-in dedup or a temporary cache node

### Missing Signals
- `MESSAGE_REPLY_RECEIVED` vs `EVERY_MESSAGE_REPLY_RECEIVED`:
  - `MESSAGE_REPLY_RECEIVED`: Only replies from campaign sequences
  - `EVERY_MESSAGE_REPLY_RECEIVED`: All replies including manual/off-campaign
  - Recommendation: Use `EVERY_MESSAGE_REPLY_RECEIVED` as safety net

### n8n Not Processing
1. Check n8n workflow is active
2. Verify webhook URL matches n8n's webhook trigger URL
3. Check n8n execution history for errors
4. Test with manual trigger
