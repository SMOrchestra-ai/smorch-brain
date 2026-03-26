# Integration Checklist: Connecting a New Tool to the GTM Stack

Every new tool must be mapped against the existing stack. This checklist ensures no integration point is missed.

## Pre-Integration Questions

- [ ] Does the tool produce signals? (events that indicate buyer intent/engagement)
- [ ] Does the tool consume leads? (needs contact data as input)
- [ ] Does the tool produce leads? (discovers or enriches contacts)
- [ ] Does the tool need to sync state with GHL? (the source of truth)
- [ ] Does the tool send messages? (email, LinkedIn, WhatsApp, SMS)
- [ ] Does the tool have webhooks? (push events to n8n)
- [ ] Does the tool have an API? (pull data or trigger actions)
- [ ] Does the tool have a native MCP? (direct Claude access)

## Integration Map Template

### [Tool] → GHL (CRM - Source of Truth)

| Question | Answer |
|----------|--------|
| What data flows to GHL? | |
| Connection method? | Native / HTTP API / n8n webhook |
| Dedup strategy? | Email match / Phone match / Custom ID |
| Tags to apply on import? | Source_[Tool], Status_New, [others] |
| Custom fields needed? | [List new fields] |
| GHL rate limit impact? | 100 req/10sec - batch size = ? |
| Bidirectional sync needed? | Yes/No - if yes, what flows back? |

### [Tool] → Instantly (Cold Email)

| Question | Answer |
|----------|--------|
| Does tool feed leads to Instantly? | |
| Does tool receive signals from Instantly? | |
| Required fields? | email, first_name, last_name, company, [personalization] |
| Dedup method? | Email + campaign composite |
| Rate considerations? | 100 req/min Instantly API |

### [Tool] → HeyReach (LinkedIn)

| Question | Answer |
|----------|--------|
| Does tool provide LinkedIn URLs? | |
| Does tool receive LinkedIn signals? | |
| Required fields? | linkedin_url (must end with /), first_name, last_name |
| Campaign enrollment method? | MCP tools / API / manual |

### [Tool] → Clay (Enrichment)

| Question | Answer |
|----------|--------|
| Is tool a data source IN Clay waterfall? | |
| Does tool CONSUME Clay-enriched data? | |
| Claygent integration possible? | |
| Credit cost per lookup? | |

### [Tool] → n8n (Orchestration)

| Question | Answer |
|----------|--------|
| Webhook events available? | [List all events] |
| Webhook payload shape? | [Key fields] |
| Webhook security? | HMAC / API key / None |
| API for n8n HTTP nodes? | REST / GraphQL / None |
| Recommended n8n patterns? | [Signal capture / Sync / Enrichment / Routing] |

## Signal Schema Compatibility

If the tool produces signals, they must normalize to the standard signal event schema:

```json
{
  "signal_id": "unique_event_id",
  "signal_type": "[tool-specific event type mapped to standard]",
  "source_platform": "[tool_name]",
  "contact_email": "string (primary key)",
  "contact_linkedin": "string (if available)",
  "contact_name": "string",
  "company": "string",
  "signal_strength": "1-10 (mapped from tool's native scoring)",
  "timestamp": "ISO 8601",
  "campaign_id": "string (source campaign)",
  "metadata": {}
}
```

Map the tool's native events to signal_type values:
| Tool's Native Event | Standard signal_type | signal_strength |
|---------------------|---------------------|-----------------|
| [Event 1] | [Mapped type] | [Score] |
| [Event 2] | [Mapped type] | [Score] |

## Tag Taxonomy Extension

New tags to add for this tool:

| Tag | Purpose | Automation Trigger? |
|-----|---------|-------------------|
| `Source_[Tool]` | Lead origin tracking | No |
| `[Tool]_status:[value]` | Tool-specific lifecycle | Depends |
| `[Tool]_campaign:[id]` | Campaign membership | No |
| `Eng_[Tool]_[Action]` | Engagement tracking | Yes - score update |

## Data Flow Diagram Template

Create an ASCII diagram showing complete data flow:

```
[Data Source/Trigger]
        │
        ▼
   [Tool Operation]
        │
   ┌────┴────┐
   │ Success  │ Failure
   │         │
   ▼         ▼
[GHL Update] [Dead Letter Queue]
[n8n Route]  [Slack Alert]
[Next Tool]
```

## Post-Integration Verification

- [ ] End-to-end test: trigger event → tool processes → GHL updated → tags correct
- [ ] Error path test: what happens when tool API fails?
- [ ] Rate limit test: send batch at expected volume, verify no 429s
- [ ] Dedup test: send same record twice, verify no duplicates in GHL
- [ ] MENA data test: Arabic names, Gulf phone numbers, .ae domains
- [ ] Webhook replay test: send same webhook twice, verify idempotency
- [ ] Monitoring: verify Slack alerts fire on errors
- [ ] Log verification: check Google Sheets/PostgreSQL dead letter queue works

## Common Integration Anti-Patterns

| Anti-Pattern | Why It's Bad | Do This Instead |
|-------------|-------------|-----------------|
| Direct tool-to-tool connection | No error handling, no logging | Route through n8n |
| No dedup before GHL create | Duplicate contacts = CRM pollution | Always search before create |
| Hardcoded API keys in n8n | Security risk, rotation nightmare | Use n8n credential store |
| No webhook signature verification | Replay attacks, spoofed events | HMAC-SHA256 on all webhooks |
| Unbatched bulk operations | Rate limit explosions | SplitInBatches + Wait |
| No dead letter queue | Lost data on failures | Google Sheet/PostgreSQL capture |
| Sync without conflict resolution | Data overwrites, lost updates | Last-write-wins with timestamp check |
