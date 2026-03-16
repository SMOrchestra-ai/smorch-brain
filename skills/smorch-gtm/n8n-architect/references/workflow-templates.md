# Workflow Templates

Complete production-ready workflow templates for the five core patterns. Each template includes full node configurations, connections, and error handling.

## Table of Contents
1. [Pattern 1: Signal Capture → Score → Route](#pattern-1-signal-capture--score--route)
2. [Pattern 2: Multi-Channel Sequence Orchestration](#pattern-2-multi-channel-sequence-orchestration)
3. [Pattern 3: Content Repurposing Pipeline](#pattern-3-content-repurposing-pipeline)
4. [Pattern 4: Data Enrichment Waterfall](#pattern-4-data-enrichment-waterfall)
5. [Pattern 5: Performance Monitoring & Alerts](#pattern-5-performance-monitoring--alerts)

---

## Pattern 1: Signal Capture → Score → Route

**Purpose:** Receive engagement signals from any platform, normalize them, apply scoring, and route leads to the right destination based on score.

**Trigger:** Webhook (receives signal events from Instantly, HeyReach, website, GHL)
**Output:** Hot leads → GHL pipeline + Slack alert. Warm → GHL tag. Cold → log only.

### Flow Architecture
```
Webhook - Signal Intake
  → Validate - Required Fields
    → IF Valid
      → [TRUE] Normalize - Signal Schema
        → Score - Apply Weights
          → Switch - Route by Tier
            → [hot] GHL - Create/Update Contact (tag: hot)
                     + GHL - Create Opportunity
                     + Slack - Hot Lead Alert
            → [warm] GHL - Create/Update Contact (tag: warm)
            → [cold] Log - Google Sheet
      → [FALSE] Log - Invalid Signal
  → Error Trigger → Format Error → Slack Error Alert
```

### Full Workflow JSON

```json
{
  "name": "[Signal] - Engagement Scorer & Router",
  "nodes": [
    {
      "parameters": {
        "path": "signal-intake",
        "responseMode": "onReceived",
        "options": {}
      },
      "name": "Webhook - Signal Intake",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 2,
      "position": [250, 300],
      "webhookId": "signal-intake-v1"
    },
    {
      "parameters": {
        "functionCode": "const items = $input.all();\nconst results = [];\n\nfor (const item of items) {\n  const d = item.json;\n  const required = ['email', 'event_type'];\n  const hasEmail = d.email || d.lead_email || d.contact_email;\n  const hasEvent = d.event_type || d.signal_type || d.type;\n  \n  results.push({\n    json: {\n      ...d,\n      _email: hasEmail || '',\n      _event: hasEvent || '',\n      validation_passed: !!(hasEmail && hasEvent)\n    }\n  });\n}\nreturn results;"
      },
      "name": "Validate - Required Fields",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [450, 300]
    },
    {
      "parameters": {
        "conditions": {
          "conditions": [
            {
              "leftValue": "={{ $json.validation_passed }}",
              "rightValue": true,
              "operator": { "type": "boolean", "operation": "true" }
            }
          ]
        }
      },
      "name": "IF - Valid Signal",
      "type": "n8n-nodes-base.if",
      "typeVersion": 2,
      "position": [650, 300]
    },
    {
      "parameters": {
        "functionCode": "const items = $input.all();\nconst results = [];\n\nconst eventMap = {\n  'email_opened': 'email_open',\n  'opened': 'email_open',\n  'open': 'email_open',\n  'replied': 'reply',\n  'reply': 'reply',\n  'link_clicked': 'link_click',\n  'clicked': 'link_click',\n  'profile_view': 'linkedin_view',\n  'linkedin_view': 'linkedin_view',\n  'page_view': 'website_visit',\n  'website_visit': 'website_visit',\n  'form_submit': 'form_submit',\n  'form_submitted': 'form_submit'\n};\n\nconst sourceMap = {\n  'instantly': 'instantly',\n  'heyreach': 'heyreach',\n  'ghl': 'ghl',\n  'highlevel': 'ghl',\n  'website': 'website'\n};\n\nfor (const item of items) {\n  const d = item.json;\n  const rawEvent = (d.event_type || d.signal_type || d.type || '').toLowerCase();\n  const rawSource = (d.source || d.platform || d.source_platform || '').toLowerCase();\n  \n  results.push({\n    json: {\n      signal_type: eventMap[rawEvent] || rawEvent,\n      source_platform: sourceMap[rawSource] || rawSource || 'unknown',\n      contact_email: d.email || d.lead_email || d.contact_email || '',\n      contact_name: d.name || d.first_name || d.contact_name || '',\n      company: d.company || d.company_name || '',\n      timestamp: d.timestamp || d.created_at || new Date().toISOString(),\n      metadata: {\n        campaign_id: d.campaign_id || '',\n        raw_event: rawEvent,\n        raw_payload_keys: Object.keys(d).join(',')\n      }\n    }\n  });\n}\nreturn results;"
      },
      "name": "Normalize - Signal Schema",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [850, 250]
    },
    {
      "parameters": {
        "functionCode": "const items = $input.all();\nconst results = [];\n\nconst weights = {\n  reply: 10,\n  form_submit: 8,\n  link_click: 7,\n  website_visit: 5,\n  linkedin_view: 4,\n  email_open: 3\n};\n\nconst DECAY_DAYS = 7;\n\nfor (const item of items) {\n  const d = item.json;\n  const baseScore = weights[d.signal_type] || 3;\n  const daysSince = Math.floor((Date.now() - new Date(d.timestamp).getTime()) / (1000*60*60*24));\n  const decay = Math.max(0, Math.floor(daysSince / DECAY_DAYS));\n  const finalScore = Math.max(1, baseScore - decay);\n  const tier = finalScore >= 8 ? 'hot' : finalScore >= 5 ? 'warm' : 'cold';\n  \n  results.push({\n    json: {\n      ...d,\n      base_score: baseScore,\n      recency_decay: decay,\n      final_score: finalScore,\n      tier: tier\n    }\n  });\n}\nreturn results;"
      },
      "name": "Score - Apply Weights",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [1050, 250]
    },
    {
      "parameters": {
        "dataType": "string",
        "value1": "={{ $json.tier }}",
        "rules": {
          "rules": [
            { "value2": "hot", "output": 0 },
            { "value2": "warm", "output": 1 },
            { "value2": "cold", "output": 2 }
          ]
        },
        "fallbackOutput": 2
      },
      "name": "Route - By Tier",
      "type": "n8n-nodes-base.switch",
      "typeVersion": 3,
      "position": [1250, 250]
    },
    {
      "parameters": {},
      "name": "Error Trigger",
      "type": "n8n-nodes-base.errorTrigger",
      "typeVersion": 1,
      "position": [250, 600]
    }
  ],
  "connections": {
    "Webhook - Signal Intake": {
      "main": [[{ "node": "Validate - Required Fields", "type": "main", "index": 0 }]]
    },
    "Validate - Required Fields": {
      "main": [[{ "node": "IF - Valid Signal", "type": "main", "index": 0 }]]
    },
    "IF - Valid Signal": {
      "main": [
        [{ "node": "Normalize - Signal Schema", "type": "main", "index": 0 }],
        []
      ]
    },
    "Normalize - Signal Schema": {
      "main": [[{ "node": "Score - Apply Weights", "type": "main", "index": 0 }]]
    },
    "Score - Apply Weights": {
      "main": [[{ "node": "Route - By Tier", "type": "main", "index": 0 }]]
    }
  },
  "settings": {
    "executionOrder": "v1",
    "saveManualExecutions": true,
    "callerPolicy": "workflowsFromSameOwner"
  },
  "tags": [
    { "name": "signal" },
    { "name": "production" }
  ]
}
```

**After the Switch node, add platform-specific nodes from `integration-patterns.md`:**
- Hot → GHL Create Contact + GHL Create Opportunity + Slack Alert (parallel)
- Warm → GHL Create Contact (tag: warm)
- Cold → Google Sheets Log

**Credentials needed:** Slack API, GHL API Key, Google Sheets OAuth2

---

## Pattern 2: Multi-Channel Sequence Orchestration

**Purpose:** When a new lead enters the pipeline or gets a specific tag, enroll them across Instantly (email), HeyReach (LinkedIn), and GHL WhatsApp — with idempotency checks on each.

**Trigger:** GHL webhook (tag applied or pipeline stage change)

### Flow Architecture
```
Webhook - GHL New Lead
  → Validate - Has Email
    → [TRUE] Check - Already Processed (idempotency)
      → [NOT DUPLICATE]
        → Parallel Branch 1: Instantly Enrollment
            → Check if in campaign → IF not → Enroll
        → Parallel Branch 2: HeyReach Enrollment
            → Check if has LinkedIn URL → IF yes → Enroll
        → Parallel Branch 3: GHL WhatsApp
            → Check if MENA phone → IF yes → Trigger WhatsApp workflow
        → Merge results → Log to Google Sheet → Slack summary
      → [DUPLICATE] NoOp - Skip
    → [FALSE] Log - No Email
  → Error Trigger → Slack Error Alert
```

### Key Implementation Notes

**Idempotency is critical here** because GHL webhooks fire on any contact update. Without the dedup check, a contact could get re-enrolled every time their record changes.

**Parallel branches** use n8n's native branching — connect the dedup IF node's TRUE output to all three enrollment chains simultaneously. Use a Merge node at the end to collect results.

**Channel decision logic:**
```javascript
// Function node — determine channels
const channels = {
  email: true, // always enroll in email
  linkedin: !!(d.linkedin_url && d.linkedin_url.includes('linkedin.com')),
  whatsapp: isMENAPhone(d.phone)
};
```

---

## Pattern 3: Content Repurposing Pipeline

**Purpose:** When new content is published (YouTube video, blog post), auto-generate platform-specific variants using Claude API and distribute.

**Trigger:** Webhook (YouTube/CMS webhook) or manual

### Flow Architecture
```
Webhook - New Content Published
  → Set - Extract Content Details
  → Claude API - Generate Variants
  → Function - Parse Variants
  → Parallel:
    → LinkedIn Post → Schedule via GHL
    → Email Snippet → Save to Google Sheet (content library)
    → WhatsApp Message → Save to Google Sheet
    → Twitter/X Post → Save to Google Sheet
  → Slack - Content Ready Notification
```

### Claude API Node Configuration
```javascript
// Prompt template for content repurposing
const prompt = `You are a content repurposer for SMOrchestra.ai. The brand voice is contrarian, direct, and backed by specific experience. No buzzwords. No "in today's rapidly evolving landscape" garbage.

Original content:
Title: ${$json.title}
Description: ${$json.description}
Key points: ${$json.key_points}

Generate these variants as JSON:
{
  "linkedin_post": "200 words max. Pattern interrupt opening. End with engagement question.",
  "email_snippet": "100 words max. One key insight + CTA to full content.",
  "whatsapp_message": "50 words max. Casual Gulf Arabic-English mix. Link to content.",
  "twitter_post": "280 chars max. Provocative angle."
}`;
```

---

## Pattern 4: Data Enrichment Waterfall

**Purpose:** When a new contact enters GHL (or on demand for a list), run Clay enrichment, score based on ICP fit, and update the contact with enriched data.

**Trigger:** GHL webhook (new contact) or Schedule (batch enrichment)

### Flow Architecture
```
Trigger (webhook or schedule)
  → IF webhook: Get contact data from GHL
  → IF schedule: Read batch from Google Sheet
  → SplitInBatches (10)
    → Clay - Enrich Contact
    → Wait - 2s (rate limit)
    → Function - Calculate Fit Score
    → GHL - Update Contact with enriched data + fit score
    → IF fit_score >= 7 → Tag "icp-fit"
    → Loop back to SplitInBatches
  → Slack - Enrichment Complete (X contacts, Y fit, Z unfit)
  → Error Handler
```

### Fit Scoring Logic
```javascript
// Function node — ICP fit scoring
const d = $json.enrichment_data;
let score = 0;

// Company size (1-50 employees for SME, 50-500 for enterprise)
const employees = d.company_size || 0;
if (employees >= 5 && employees <= 500) score += 3;
if (employees >= 10 && employees <= 200) score += 2; // sweet spot

// Geography (MENA = higher priority)
const menaCountries = ['UAE', 'Saudi Arabia', 'Qatar', 'Kuwait', 'Oman', 'Bahrain', 'Jordan', 'Egypt'];
if (menaCountries.includes(d.country)) score += 3;

// Industry match
const targetIndustries = ['SaaS', 'Technology', 'Software', 'Real Estate', 'Healthcare', 'Beauty'];
if (targetIndustries.some(i => (d.industry || '').includes(i))) score += 2;

// Has LinkedIn (needed for multi-channel)
if (d.linkedin_url) score += 1;

// Has phone (needed for WhatsApp)
if (d.phone) score += 1;

const tier = score >= 8 ? 'high_fit' : score >= 5 ? 'medium_fit' : 'low_fit';

return [{
  json: {
    ...item.json,
    fit_score: score,
    fit_tier: tier,
    enrichment_data: d
  }
}];
```

---

## Pattern 5: Performance Monitoring & Alerts

**Purpose:** Scheduled daily/weekly workflow that pulls campaign stats from all platforms, aggregates them, detects anomalies, and sends a Slack report.

**Trigger:** Schedule (daily 9 AM UAE, weekly Monday 8 AM)

### Flow Architecture
```
Schedule - Daily 9AM
  → Parallel:
    → Instantly API - Get Campaign Stats
    → HeyReach API - Get Campaign Stats
    → GHL API - Get Pipeline Data
  → Merge - Combine All Stats
  → Function - Aggregate & Detect Anomalies
  → Function - Format Slack Report
  → Slack - Post to #campaign-metrics
  → Google Sheets - Append Daily Row (historical tracking)
  → IF anomaly detected → Slack - Alert to #sales-alerts
```

### Anomaly Detection Logic
```javascript
// Function node — detect anomalies
const stats = $json;
const anomalies = [];

// Reply rate drop >30% from 7-day average
if (stats.reply_rate < stats.avg_reply_rate_7d * 0.7) {
  anomalies.push({
    metric: 'reply_rate',
    current: stats.reply_rate,
    average: stats.avg_reply_rate_7d,
    severity: 'high',
    message: `Reply rate dropped to ${stats.reply_rate}% (7-day avg: ${stats.avg_reply_rate_7d}%)`
  });
}

// Bounce rate spike >5%
if (stats.bounce_rate > 5) {
  anomalies.push({
    metric: 'bounce_rate',
    current: stats.bounce_rate,
    threshold: 5,
    severity: 'critical',
    message: `Bounce rate spiked to ${stats.bounce_rate}% — check email list quality`
  });
}

// Zero sends (workflow broken?)
if (stats.emails_sent === 0 && stats.expected_sends > 0) {
  anomalies.push({
    metric: 'emails_sent',
    current: 0,
    severity: 'critical',
    message: 'Zero emails sent today — check Instantly campaign status'
  });
}

return [{
  json: {
    ...stats,
    anomalies: anomalies,
    has_anomalies: anomalies.length > 0,
    anomaly_count: anomalies.length
  }
}];
```

### Slack Report Format
```javascript
// Function node — format daily report
const s = $json;
const anomalySection = s.has_anomalies
  ? `\n⚠️ *Anomalies Detected (${s.anomaly_count}):*\n${s.anomalies.map(a => `• ${a.message}`).join('\n')}`
  : '\n✅ No anomalies detected';

const report = `📊 *Daily Campaign Report — ${new Date().toLocaleDateString()}*

*Email (Instantly):*
• Sent: ${s.emails_sent} | Opened: ${s.emails_opened} (${s.open_rate}%)
• Replied: ${s.emails_replied} (${s.reply_rate}%) | Bounced: ${s.bounced} (${s.bounce_rate}%)

*LinkedIn (HeyReach):*
• Connections sent: ${s.connections_sent} | Accepted: ${s.connections_accepted} (${s.accept_rate}%)
• Messages: ${s.linkedin_messages} | Replies: ${s.linkedin_replies} (${s.linkedin_reply_rate}%)

*Pipeline (GHL):*
• New opportunities: ${s.new_opportunities}
• Pipeline value: $${s.pipeline_value}
• Meetings booked: ${s.meetings_booked}
${anomalySection}`;

return [{ json: { report_text: report } }];
```

---

## Template Customization Guide

When building from these templates:

1. **Replace all PLACEHOLDER values** — credential IDs, sheet IDs, campaign IDs, pipeline IDs, location IDs
2. **Adjust scoring weights** for your specific ICP — what counts as "hot" varies by business line (SalesMfast SME vs Enterprise consulting)
3. **Add/remove channels** — not every workflow needs all three channels. If you're US-only, drop WhatsApp. If enterprise-only, drop Instantly.
4. **Adjust rate limits** — the wait times in these templates are conservative. If your API tier allows more throughput, reduce them.
5. **Customize Slack channels** — match your team's channel naming convention
