# SignalEvent Schema for Sales Navigator Signals

## Purpose
Normalize every signal extracted from Sales Navigator into a consistent schema that downstream tools (n8n, Supabase, Clay, scoring engine) can consume without per-signal parsing logic.

## SignalEvent Object

```json
{
  "signal_id": "string (UUID, auto-generated)",
  "source": "sales_navigator",
  "detected_at": "ISO 8601 timestamp",
  "signal_type": "enum (see Signal Type Registry below)",
  "signal_tier": "1 | 2 | 3",
  "priority": "P1 | P2 | P3",
  "recency_days": "integer (days since signal occurred)",

  "lead": {
    "full_name": "string",
    "first_name": "string",
    "last_name": "string",
    "current_title": "string",
    "previous_title": "string | null",
    "linkedin_url": "string (https://www.linkedin.com/in/xxx/)",
    "profile_language": "en | ar | other",
    "connection_degree": "1st | 2nd | 3rd",
    "seniority_level": "CXO | VP | Director | Manager | Other",
    "function": "string (Sales, Marketing, Operations, IT, etc.)"
  },

  "account": {
    "company_name": "string",
    "linkedin_url": "string (company page URL)",
    "headcount": "integer | null",
    "headcount_growth_pct": "float | null",
    "industry": "string",
    "hq_location": "string (country or city, country)",
    "lead_location": "string (where the lead actually is)"
  },

  "signal_detail": {
    "description": "string (human-readable, e.g., 'Moved from Acme to TechCorp as VP Sales')",
    "previous_company": "string | null (for job changes)",
    "previous_role": "string | null (for job changes)",
    "funding_amount": "string | null (for funding signals)",
    "content_topic": "string | null (for content share signals)",
    "content_url": "string | null (link to shared content)",
    "growth_department": "string | null (which dept grew for headcount signals)",
    "raw_alert_text": "string (exact text from Sales Nav alert)"
  },

  "qualification": {
    "icp_fit": "PASS | PARTIAL | FAIL",
    "fit_checks": {
      "industry_match": "boolean",
      "size_match": "boolean",
      "geo_match": "boolean",
      "role_match": "boolean"
    },
    "fit_score": "0-4 (count of passing checks)"
  },

  "routing": {
    "recommended_channel": "heyreach | instantly | ghl | manual | monitor",
    "recommended_action": "string (e.g., 'CR with job change angle' or 'Save to watchlist')",
    "sequence_type": "string | null (e.g., 'job-change-congrats', 'funding-reference')",
    "urgency": "immediate | within_48h | within_1w | monitor"
  },

  "evidence": {
    "screenshot_path": "string | null",
    "alert_screenshot": "string | null",
    "profile_screenshot": "string | null"
  },

  "metadata": {
    "extracted_by": "salesnav-operator",
    "session_id": "string (links to triage session)",
    "processed": "boolean (has this been sent downstream?)",
    "processed_at": "ISO 8601 | null",
    "notes": "string | null"
  }
}
```

## Signal Type Registry

| signal_type | Tier | Description | Key Fields |
|------------|------|-------------|------------|
| `job_change` | 1 | Lead changed companies or roles | previous_company, previous_role |
| `funding` | 1 | Account raised funding | funding_amount |
| `headcount_growth` | 1 | Account headcount grew >20% | headcount_growth_pct, growth_department |
| `merger_acquisition` | 1 | Account involved in M&A | description |
| `content_share` | 2 | Lead posted or shared content on LinkedIn | content_topic, content_url |
| `profile_view` | 2 | Lead viewed your profile | - |
| `content_engagement` | 2 | Lead engaged with your content (like/comment) | content_url |
| `company_follow` | 2 | Lead started following your company | - |
| `senior_hire` | 2 | New senior person joined a saved account | - |
| `job_posting` | 3 | Account posted job listings (growth signal) | growth_department |
| `account_news` | 3 | General news about saved account | description |
| `preparing_to_grow` | 3 | Account shows growth preparation patterns | description |
| `promotion` | 2 | Lead promoted within same company | previous_role |

## ICP Fit Qualification Rules

```
PASS (4/4 checks):
  industry_match: Account industry is in target vertical list
  size_match: Account headcount is within ICP range (e.g., 51-2000)
  geo_match: Lead geography is target region (UAE, KSA, Qatar, etc.)
  role_match: Lead title/seniority matches buyer persona

PARTIAL (3/4 checks): Monitor, review next week
FAIL (<3/4 checks): Skip entirely
```

## Priority Scoring

```
P1 = Fit PASS + Tier 1 signal + recency < 7 days
P2 = Fit PASS + Tier 2 signal (any recency)
     OR Fit PASS + Tier 1 signal + recency 8-30 days
P3 = Fit PARTIAL + any signal
     OR Fit PASS + Tier 3 signal
```

## Downstream Routing Format

### To n8n Webhook (JSON POST)
Send the full SignalEvent object. n8n will handle routing based on priority and channel.

### To Clay (for enrichment before outreach)
```
full_name, linkedin_url, company_name, current_title, signal_type, signal_detail.description
```

### To HeyReach (LinkedIn outbound)
```
linkedin_url (with trailing /), first_name, company_name, current_title, signal_type (as tag)
```

### To Instantly (cold email)
```
first_name, last_name, company_name, current_title, email (from Clay enrichment), signal_type (as custom field)
```

### To GHL (CRM)
```
first_name, last_name, email, phone, company_name, current_title, signal_type (as tag), signal_detail.description (as note)
```

## Batch Processing Notes

- Daily triage typically produces 5-20 SignalEvents per session
- Weekly search extraction can produce 50-200 SignalEvents
- Always deduplicate by linkedin_url before sending downstream
- If same lead has multiple signals, create separate SignalEvents but flag in notes
- Dedup window: 30 days (don't re-signal same lead for same signal type within 30 days)
