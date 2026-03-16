# Integration Patterns Reference

Platform-specific API patterns, authentication, and common operations for Mamoun's SMOrchestra stack.

## Table of Contents
1. [GoHighLevel (GHL / SalesMfast)](#gohighlevel)
2. [Instantly.ai](#instantly)
3. [HeyReach](#heyreach)
4. [Clay](#clay)
5. [Slack](#slack)
6. [Google Sheets](#google-sheets)
7. [Claude API](#claude-api)

---

## GoHighLevel

**Base URL:** `https://services.leadconnectorhq.com`
**Auth:** API Key (Bearer token) or OAuth2
**Rate Limits:** 100 requests/min per location, 10 requests/sec burst

### Common Operations

#### Create/Update Contact
```json
{
  "method": "POST",
  "url": "https://services.leadconnectorhq.com/contacts/",
  "headers": {
    "Authorization": "Bearer {{$credentials.ghlApiKey}}",
    "Version": "2021-07-28",
    "Content-Type": "application/json"
  },
  "body": {
    "firstName": "={{ $json.contact_name.split(' ')[0] }}",
    "lastName": "={{ $json.contact_name.split(' ').slice(1).join(' ') }}",
    "email": "={{ $json.contact_email }}",
    "phone": "={{ $json.phone || '' }}",
    "companyName": "={{ $json.company }}",
    "tags": ["={{ $json.tier }}", "signal-scored"],
    "customFields": [
      {
        "key": "signal_type",
        "field_value": "={{ $json.signal_type }}"
      },
      {
        "key": "signal_score",
        "field_value": "={{ $json.final_score }}"
      },
      {
        "key": "signal_source",
        "field_value": "={{ $json.source_platform }}"
      },
      {
        "key": "signal_date",
        "field_value": "={{ $json.timestamp }}"
      }
    ],
    "locationId": "LOCATION_ID_PLACEHOLDER"
  }
}
```

#### Search Contact (Idempotency Check)
Before creating, check if contact exists to avoid duplicates.

```json
{
  "method": "GET",
  "url": "={{ 'https://services.leadconnectorhq.com/contacts/search/duplicate?locationId=LOCATION_ID&email=' + encodeURIComponent($json.contact_email) }}",
  "headers": {
    "Authorization": "Bearer {{$credentials.ghlApiKey}}",
    "Version": "2021-07-28"
  }
}
```

**Idempotency pattern:** Search → IF contact exists → Update, ELSE → Create

#### Add Tag to Contact
```json
{
  "method": "PUT",
  "url": "={{ 'https://services.leadconnectorhq.com/contacts/' + $json.ghl_contact_id }}",
  "headers": {
    "Authorization": "Bearer {{$credentials.ghlApiKey}}",
    "Version": "2021-07-28"
  },
  "body": {
    "tags": ["hot-lead", "week-1-campaign"]
  }
}
```

#### Create Opportunity (Pipeline)
```json
{
  "method": "POST",
  "url": "https://services.leadconnectorhq.com/opportunities/",
  "headers": {
    "Authorization": "Bearer {{$credentials.ghlApiKey}}",
    "Version": "2021-07-28"
  },
  "body": {
    "pipelineId": "PIPELINE_ID_PLACEHOLDER",
    "pipelineStageId": "STAGE_ID_PLACEHOLDER",
    "locationId": "LOCATION_ID_PLACEHOLDER",
    "contactId": "={{ $json.ghl_contact_id }}",
    "name": "={{ $json.company + ' - ' + $json.signal_type }}",
    "monetaryValue": 0,
    "status": "open"
  }
}
```

#### Trigger GHL Workflow
```json
{
  "method": "POST",
  "url": "https://services.leadconnectorhq.com/contacts/{{ $json.ghl_contact_id }}/workflow/WORKFLOW_ID_PLACEHOLDER",
  "headers": {
    "Authorization": "Bearer {{$credentials.ghlApiKey}}",
    "Version": "2021-07-28"
  }
}
```

### GHL Custom Fields Setup
These custom fields should exist in GHL for signal tracking:
- `signal_type` (text) — email_open, reply, linkedin_view, etc.
- `signal_score` (number) — 1-10
- `signal_source` (text) — instantly, heyreach, ghl, website
- `signal_date` (date) — ISO timestamp
- `enrichment_status` (dropdown) — pending, enriched, failed
- `fit_score` (number) — ICP fit score from enrichment
- `lead_tier` (dropdown) — hot, warm, cold

---

## Instantly

**Base URL:** `https://api.instantly.ai/api/v1`
**Auth:** API Key (query parameter)
**Rate Limits:** 10 requests/sec
**Sending Limits:** Varies by plan. Respect per-account daily limits.

### Common Operations

#### Add Lead to Campaign
```json
{
  "method": "POST",
  "url": "https://api.instantly.ai/api/v1/lead/add",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "api_key": "{{$credentials.instantlyApiKey}}",
    "campaign_id": "CAMPAIGN_ID_PLACEHOLDER",
    "skip_if_in_workspace": true,
    "leads": [
      {
        "email": "={{ $json.contact_email }}",
        "first_name": "={{ $json.contact_name.split(' ')[0] }}",
        "last_name": "={{ $json.contact_name.split(' ').slice(1).join(' ') }}",
        "company_name": "={{ $json.company }}",
        "custom_variables": {
          "signal_type": "={{ $json.signal_type }}",
          "wedge_variant": "A",
          "signal_data": "={{ $json.metadata.raw_signal || '' }}"
        }
      }
    ]
  }
}
```

**Important:** `skip_if_in_workspace: true` prevents duplicate enrollment. This is your idempotency guard for Instantly.

#### Check Lead Status (Idempotency)
```json
{
  "method": "POST",
  "url": "https://api.instantly.ai/api/v1/lead/get",
  "body": {
    "api_key": "{{$credentials.instantlyApiKey}}",
    "campaign_id": "CAMPAIGN_ID_PLACEHOLDER",
    "email": "={{ $json.contact_email }}"
  }
}
```

#### Get Campaign Analytics
```json
{
  "method": "GET",
  "url": "={{ 'https://api.instantly.ai/api/v1/analytics/campaign/summary?api_key=' + $credentials.instantlyApiKey + '&campaign_id=CAMPAIGN_ID&start_date=' + $json.start_date + '&end_date=' + $json.end_date }}"
}
```

**Response fields:** `sent`, `opened`, `replied`, `bounced`, `unsubscribed`

#### List Campaigns
```json
{
  "method": "GET",
  "url": "={{ 'https://api.instantly.ai/api/v1/campaign/list?api_key=' + $credentials.instantlyApiKey + '&limit=100&skip=0' }}"
}
```

---

## HeyReach

**Base URL:** `https://api.heyreach.io/api/v1`
**Auth:** API Key (header)
**Rate Limits:** 5 requests/sec

### Common Operations

#### Add Leads to Campaign
```json
{
  "method": "POST",
  "url": "https://api.heyreach.io/api/v1/campaign/CAMPAIGN_ID/leads",
  "headers": {
    "X-API-KEY": "{{$credentials.heyreachApiKey}}",
    "Content-Type": "application/json"
  },
  "body": {
    "leads": [
      {
        "linkedinUrl": "={{ $json.linkedin_url }}",
        "firstName": "={{ $json.contact_name.split(' ')[0] }}",
        "lastName": "={{ $json.contact_name.split(' ').slice(1).join(' ') }}",
        "email": "={{ $json.contact_email }}",
        "companyName": "={{ $json.company }}"
      }
    ]
  }
}
```

#### Get Campaign Stats
```json
{
  "method": "GET",
  "url": "https://api.heyreach.io/api/v1/campaign/CAMPAIGN_ID/stats",
  "headers": {
    "X-API-KEY": "{{$credentials.heyreachApiKey}}"
  }
}
```

**Response fields:** `sent_connections`, `accepted_connections`, `messages_sent`, `replies_received`

### LinkedIn URL Detection
Before enrolling in HeyReach, check if contact has a LinkedIn URL:

```javascript
// In Function node
const hasLinkedIn = !!item.json.linkedin_url &&
  item.json.linkedin_url.includes('linkedin.com');
return [{ json: { ...item.json, has_linkedin: hasLinkedIn } }];
```

---

## Clay

**Base URL:** `https://api.clay.com/v3`
**Auth:** API Key (header)
**Rate Limits:** Depends on plan. Use batching for safety.

### Common Operations

#### Enrich Contact (Waterfall)
Clay's enrichment runs multiple data providers in sequence until data is found.

```json
{
  "method": "POST",
  "url": "https://api.clay.com/v3/tables/TABLE_ID/rows",
  "headers": {
    "Authorization": "Bearer {{$credentials.clayApiKey}}",
    "Content-Type": "application/json"
  },
  "body": {
    "data": [
      {
        "email": "={{ $json.contact_email }}",
        "company": "={{ $json.company }}",
        "full_name": "={{ $json.contact_name }}"
      }
    ]
  }
}
```

**Clay enrichment typically returns:**
- Company size, industry, revenue range, funding
- Contact title, LinkedIn URL, phone
- Tech stack (useful for ICP fit scoring)
- Recent news, job postings

#### Poll for Enrichment Results
Clay enrichment is async. Poll until status = "completed":

```javascript
// Function node — check enrichment status
const rowId = $json.row_id;
const maxAttempts = 10;
let attempt = 0;
// Return row_id for the next HTTP Request node to poll
return [{ json: { row_id: rowId, poll_url: `https://api.clay.com/v3/tables/TABLE_ID/rows/${rowId}` } }];
```

Use a Wait node (30s) + IF node (status check) + loop back pattern for polling.

---

## Slack

**Auth:** OAuth2 or Bot Token
**Rate Limits:** Tier 2 (20 requests/min for most methods)

### Channel Conventions
- `#sales-alerts` — Hot lead notifications, high-priority signals
- `#n8n-errors` — Workflow error alerts (Error Trigger destinations)
- `#campaign-metrics` — Daily/weekly campaign performance reports
- `#enrichment-log` — Clay enrichment completions

### Message Formatting
Use Slack Block Kit for structured messages:

```javascript
// Function node — format Slack block message
const blocks = [
  {
    type: "header",
    text: { type: "plain_text", text: "🔥 Hot Lead Alert" }
  },
  {
    type: "section",
    fields: [
      { type: "mrkdwn", text: `*Contact:*\n${$json.contact_name}` },
      { type: "mrkdwn", text: `*Company:*\n${$json.company}` },
      { type: "mrkdwn", text: `*Signal:*\n${$json.signal_type}` },
      { type: "mrkdwn", text: `*Score:*\n${$json.final_score}/10` }
    ]
  },
  {
    type: "actions",
    elements: [
      {
        type: "button",
        text: { type: "plain_text", text: "View in GHL" },
        url: `https://app.gohighlevel.com/contacts/${$json.ghl_contact_id}`
      }
    ]
  }
];
return [{ json: { blocks: JSON.stringify(blocks) } }];
```

---

## Google Sheets

**Auth:** OAuth2
**Rate Limits:** 60 requests/min per user

### Common Patterns

#### Config Sheet Pattern
Use Google Sheets as a runtime-configurable settings store:

**Sheet: "scoring_weights"**
| signal_type | weight | tier_threshold_hot | tier_threshold_warm |
|-------------|--------|-------------------|---------------------|
| reply | 10 | 8 | 5 |
| link_click | 7 | 8 | 5 |
| email_open | 3 | 8 | 5 |

Read this sheet at workflow start, pass to scoring Function node as parameter.

#### Lead List Sheet Pattern
Import prospect lists from Google Sheets for campaign enrollment:

**Sheet: "prospects_q1_2026"**
| email | name | company | linkedin_url | signal_type | campaign_target |
|-------|------|---------|-------------|-------------|-----------------|

Read sheet → SplitInBatches → Enroll in Instantly/HeyReach

#### Logging Sheet Pattern
Append workflow actions to a Google Sheet for audit trail:

```json
{
  "operation": "append",
  "sheetName": "workflow_log",
  "columns": {
    "timestamp": "={{ new Date().toISOString() }}",
    "workflow": "Signal Scorer",
    "action": "scored_lead",
    "contact": "={{ $json.contact_email }}",
    "result": "={{ $json.tier }}",
    "score": "={{ $json.final_score }}"
  }
}
```

---

## Claude API

**Base URL:** `https://api.anthropic.com/v1`
**Auth:** API Key (x-api-key header)
**Rate Limits:** Depends on tier

### Common Pattern: Content Generation
Used in content repurposing pipelines to generate variants.

```json
{
  "method": "POST",
  "url": "https://api.anthropic.com/v1/messages",
  "headers": {
    "x-api-key": "{{$credentials.claudeApiKey}}",
    "anthropic-version": "2023-06-01",
    "Content-Type": "application/json"
  },
  "body": {
    "model": "claude-sonnet-4-5-20250929",
    "max_tokens": 1024,
    "messages": [
      {
        "role": "user",
        "content": "={{ 'Generate 3 variants of this content for different channels:\\n\\nOriginal: ' + $json.content + '\\n\\nGenerate:\\n1. LinkedIn post (max 200 words, professional tone)\\n2. Email snippet (max 100 words, direct CTA)\\n3. WhatsApp message (max 50 words, conversational Arabic-English mix)' }}"
      }
    ]
  }
}
```

### Common Pattern: Sentiment Analysis
Used in reply scoring workflows.

```json
{
  "body": {
    "model": "claude-haiku-3-5-20241022",
    "max_tokens": 256,
    "messages": [
      {
        "role": "user",
        "content": "={{ 'Analyze this email reply sentiment. Respond with JSON only: {\"sentiment\": \"positive|negative|neutral\", \"intent\": \"interested|not_interested|question|objection\", \"score\": 1-10, \"summary\": \"one sentence\"}\\n\\nReply: ' + $json.reply_text }}"
      }
    ]
  }
}
```

Use `claude-haiku-3-5` for high-volume analysis (cheaper, fast enough for sentiment).
Use `claude-sonnet-4-5` for content generation (better quality, worth the cost for customer-facing text).

---

## Cross-Platform Patterns

### Lead Lifecycle Flow
```
New Signal → n8n → GHL (create/update contact + tag)
                  → Instantly (enroll in email campaign)
                  → HeyReach (enroll in LinkedIn campaign, if LinkedIn URL exists)
                  → Slack (alert if hot)
                  → Google Sheets (log action)
```

### Phone Number Detection for WhatsApp
MENA phone numbers → WhatsApp via GHL. US/EU → email/LinkedIn only.

```javascript
// Function node
const phone = $json.phone || '';
const isMENA = phone.startsWith('+971') || // UAE
               phone.startsWith('+966') || // Saudi
               phone.startsWith('+974') || // Qatar
               phone.startsWith('+965') || // Kuwait
               phone.startsWith('+968') || // Oman
               phone.startsWith('+973') || // Bahrain
               phone.startsWith('+962') || // Jordan
               phone.startsWith('+20');     // Egypt
return [{ json: { ...item.json, is_mena_phone: isMENA, use_whatsapp: isMENA && phone.length > 8 } }];
```
