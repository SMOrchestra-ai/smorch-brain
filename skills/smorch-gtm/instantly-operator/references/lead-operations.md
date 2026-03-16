# Lead Operations Reference

## Table of Contents
1. [Lead Creation](#lead-creation)
2. [Bulk Operations](#bulk-operations)
3. [Lead Lists](#lead-lists)
4. [Custom Variables](#custom-variables)
5. [Lead Lifecycle](#lead-lifecycle)
6. [Cross-Platform Coordination](#cross-platform-coordination)

---

## Lead Creation

### Individual Lead
```
Tool: create_lead
Required: email
Recommended: firstName, lastName, companyName, campaign_id or list_id
Optional: custom_variables, skip_if_in_campaign (ALWAYS true)
```

### Lead Data Structure
```json
{
  "email": "ahmed@techcorp.ae",
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "companyName": "TechCorp",
  "phone": "+971501234567",
  "website": "techcorp.ae",
  "campaign_id": "campaign-uuid-here",
  "skip_if_in_campaign": true,
  "custom_variables": {
    "industry": "SaaS",
    "company_size": "50-200",
    "signal_source": "clay_enrichment",
    "icp": "mena_saas",
    "personalization": "Saw TechCorp's Series A announcement"
  }
}
```

### Pre-Creation Checks
1. **Email format valid** — Basic regex check
2. **Not already in campaign** — Use `skip_if_in_campaign: true` (always)
3. **Not bounced previously** — Check if email has bounced in other campaigns
4. **Email verified** — Ideally through Clay or Instantly's verify_email

---

## Bulk Operations

### Bulk Add (up to 1,000 leads)
```
Tool: add_leads_to_campaign_or_list_bulk
Provide EITHER campaign_id OR list_id (not both)
Always: skip_if_in_campaign = true
```

### Bulk Add Structure
```json
{
  "campaign_id": "uuid",
  "skip_if_in_campaign": true,
  "leads": [
    {
      "email": "lead1@company.com",
      "firstName": "Ahmed",
      "lastName": "Hassan",
      "companyName": "TechCorp",
      "custom_variables": {
        "industry": "SaaS",
        "personalization": "specific data point"
      }
    },
    {
      "email": "lead2@company.com",
      "firstName": "Fatima",
      "lastName": "Al-Rashid",
      "companyName": "Gulf Solutions",
      "custom_variables": {
        "industry": "Consulting",
        "personalization": "specific data point"
      }
    }
  ]
}
```

### Bulk Operation Safety
- Maximum 1,000 leads per call
- For larger lists, chunk into batches of 500-1,000
- Wait for background job completion between batches
- Track via `get_background_job` and `list_background_jobs`
- Always verify lead count after import matches expected

### Moving Leads Between Campaigns
```
Tool: move_leads_to_campaign_or_list
Options:
  - By IDs: specific lead IDs to move
  - By search: filter + campaign_id
  - By filter: status-based (contacted, not_contacted, etc.)

copy_leads=true to copy instead of move
```

---

## Lead Lists

### Creating Lead Lists
```
Tool: create_lead_list
Parameters: name, has_enrichment_task (optional)
```

### List Naming Convention
Format: `[Source] - [Audience] - [Date]`
- `[Clay] - Dubai Tech Founders - 2026-02-21`
- `[LinkedIn] - SaaS CTOs Gulf - 2026-02`
- `[Manual] - Event Contacts STEP Conf - 2026-02`
- `[Apify] - G2 Reviewers CRM Tools - 2026-02`

### List Management Best Practices
1. One list per source + audience + date combination
2. Lists are reusable — can assign to multiple campaigns
3. Keep lists focused (one ICP per list)
4. Archive old lists quarterly (rename with `[ARCHIVE]` prefix)
5. Track list-level verification stats via `get_verification_stats_for_lead_list`

---

## Custom Variables

### Rules
- Keys: string only, no special characters, use camelCase or snake_case
- Values: string, number, boolean, or null ONLY — **no arrays or objects**
- Used in email body as `{{variableName}}`
- **CRITICAL:** `update_lead` custom_variables REPLACES the entire object. To add a field, first `get_lead`, merge, then update.

### Standard Variables for SMOrchestra Campaigns
| Variable | Type | Purpose | Example |
|----------|------|---------|---------|
| `industry` | string | Vertical targeting | "SaaS", "Real Estate" |
| `company_size` | string | Size segment | "50-200", "500+" |
| `signal_source` | string | Where lead came from | "clay_enrichment", "apify_scrape" |
| `icp` | string | ICP classification | "mena_saas", "us_realestate" |
| `personalization` | string | Custom first-line data | "Saw TechCorp's Series A" |
| `tech_stack` | string | Key technologies | "Salesforce, HubSpot" |
| `region` | string | Geographic region | "UAE", "KSA", "US" |
| `job_title` | string | Contact's title | "CTO", "VP Sales" |
| `revenue_range` | string | Company revenue | "10M-50M" |
| `linkedin_url` | string | LinkedIn profile | "linkedin.com/in/ahmed" |

### Personalization Priority
In the email body, reference these in priority order:
1. `{{personalization}}` — Most specific, most impactful (custom observation)
2. `{{companyName}}` — Shows you know who they are
3. `{{firstName}}` — Basic but expected

Avoid: using only `{{firstName}}` with no other personalization. It's table stakes, not a differentiator.

---

## Lead Lifecycle

### Status Values
| Status | Meaning | Action |
|--------|---------|--------|
| Not contacted | In queue, not yet sent | Wait for campaign send |
| Contacted | At least one email sent | Monitor for opens/replies |
| Completed | Full sequence sent, no reply | Move to re-engagement pool or archive |
| Active | Currently receiving sequence | Monitor engagement |
| Replied | Responded to email | **Signal!** Route to GHL via n8n |
| Bounced | Email bounced | Remove from campaign, flag in GHL |
| Unsubscribed | Opted out | Remove from all campaigns, DNC in GHL |

### Post-Reply Flow
When a lead replies:
```
1. Instantly marks as "replied" (auto, stop_on_reply=true)
2. n8n webhook captures reply event
3. n8n sends to Claude API for sentiment analysis
4. Score assigned (1-10)
5. GHL contact created/updated with score + tags
6. If score ≥7: signal:hot → immediate WhatsApp follow-up
7. If score 4-6: signal:warm → email nurture sequence
8. If score ≤3: signal:cold → log and monitor
```

### Post-Bounce Flow
When an email bounces:
```
1. Instantly marks as "bounced"
2. n8n webhook captures bounce event
3. GHL contact flagged: enrichment_status = "email_invalid"
4. Lead removed from all Instantly campaigns
5. If bounce rate >5% in campaign: ALERT → review list quality
```

---

## Cross-Platform Coordination

### Avoiding Overlap with HeyReach
A lead should not receive cold email AND LinkedIn outreach on the same day. Stagger:

**Option A — Email First:**
```
Day 0: Instantly email (initial outreach)
Day 2: HeyReach LinkedIn connection request
Day 3: Instantly email (follow-up)
Day 5: HeyReach LinkedIn message
Day 6: Instantly email (social proof)
Day 10: Instantly breakup email
```

**Option B — LinkedIn First:**
```
Day 0: HeyReach LinkedIn connection request
Day 2: Instantly email (reference LinkedIn)
Day 4: HeyReach LinkedIn message
Day 6: Instantly email (follow-up)
Day 9: Instantly breakup email
```

### Checking Cross-Platform Status
```
Tool: search_campaigns_by_contact
Input: contact email
Returns: all campaigns this email is enrolled in

Use this to:
- Check if lead is already in another Instantly campaign
- Avoid enrolling in competing campaigns
- Coordinate with HeyReach data (check GHL tags)
```

### Lead Data Flow
```
Clay enrichment → JSON with fields
  ↓
Split into:
  → Instantly lead list (for email)
  → HeyReach lead list (for LinkedIn, if linkedin_url present)
  → GHL contact (master record)
  ↓
n8n orchestrates the split and enrichment sync
```
