# Lead Operations Reference

## Table of Contents
1. Lead Data Schema
2. URL Normalization
3. Adding Leads to Lists
4. Adding Leads to Campaigns
5. Deduplication Protocol
6. Tag Taxonomy & Routing
7. Lead Lifecycle
8. Cross-Platform Matching

---

## 1. Lead Data Schema

### Required Fields (Minimum Viable Lead)
```json
{
  "profileUrl": "https://www.linkedin.com/in/username/",
  "firstName": "string"
}
```

### Recommended Fields (Full Lead)
```json
{
  "profileUrl": "https://www.linkedin.com/in/username/",
  "firstName": "string",
  "lastName": "string",
  "companyName": "string",
  "position": "string",
  "location": "string",
  "emailAddress": "string",
  "about": "string (LinkedIn headline/summary)",
  "customUserFields": [
    {"name": "signal_source", "value": "clay_enrichment"},
    {"name": "company_size", "value": "50-200"},
    {"name": "tech_stack", "value": "hubspot,salesforce"},
    {"name": "icp_tier", "value": "tier_1"},
    {"name": "signal_type", "value": "hiring_vp_sales"},
    {"name": "enrichment_date", "value": "2026-02-21"}
  ]
}
```

### Custom Field Rules
- Names: alphanumeric and underscores ONLY (no spaces, no special characters)
- Valid: `signal_source`, `company_size`, `tech_stack`
- Invalid: `signal source`, `company-size`, `tech.stack`
- Values: strings only in the customUserFields array

### Standard Custom Fields
| Field Name | Purpose | Example Values |
|-----------|---------|----------------|
| `signal_source` | Where this lead came from | `clay_enrichment`, `linkedin_search`, `event_attendee` |
| `company_size` | Employee count range | `1-10`, `11-50`, `51-200`, `201-500`, `500+` |
| `tech_stack` | Known tools they use | `hubspot,salesforce`, `zoho`, `pipedrive` |
| `icp_tier` | ICP fit classification | `tier_1`, `tier_2`, `tier_3` |
| `signal_type` | What signal triggered outreach | `hiring_vp_sales`, `funding_round`, `tech_adoption` |
| `enrichment_date` | When data was enriched | `2026-02-21` |
| `geo_market` | Geographic market | `uae`, `ksa`, `qatar`, `us`, `eu` |
| `revenue_range` | Estimated company revenue | `1m-5m`, `5m-20m`, `20m-100m` |

---

## 2. URL Normalization

LinkedIn profile URLs MUST follow exact format: `https://www.linkedin.com/in/username/`

### Normalization Rules
1. Always HTTPS (never HTTP)
2. Always `www.` prefix
3. Always trailing slash
4. Strip query parameters (?locale=, ?trk=, etc.)
5. Strip fragments (#)
6. Lowercase the username portion
7. Handle Sales Navigator URLs: extract the vanity name

### Common Input Formats → Normalized
| Input | Normalized |
|-------|-----------|
| `linkedin.com/in/john-doe` | `https://www.linkedin.com/in/john-doe/` |
| `https://linkedin.com/in/john-doe/` | `https://www.linkedin.com/in/john-doe/` |
| `https://www.linkedin.com/in/John-Doe?trk=abc` | `https://www.linkedin.com/in/john-doe/` |
| `http://www.linkedin.com/in/john-doe` | `https://www.linkedin.com/in/john-doe/` |
| `www.linkedin.com/in/john-doe/` | `https://www.linkedin.com/in/john-doe/` |

Use the `scripts/normalize-linkedin-url.py` utility for batch processing.

---

## 3. Adding Leads to Lists

### Workflow
1. Create list if needed: `create_empty_list(listName, listType="USER_LIST")`
2. Normalize all profile URLs
3. Chunk leads into batches of 100
4. For each batch: `add_leads_to_list_v2(listId, leads)`
5. Check response for added/updated/failed counts
6. Report summary

### Naming Convention
Format: `[Source] - [Audience] - [Date]`
Examples:
- `[Clay] - MENA SaaS CTOs - 2026-02-21`
- `[Event] - WebSummit Attendees - 2026-02`
- `[LinkedIn Search] - US VP Marketing - 2026-02-21`

### Batch Processing Pattern
```
Total leads: 250
Batch 1: leads[0:100] → add_leads_to_list_v2 → check counts
Batch 2: leads[100:200] → add_leads_to_list_v2 → check counts
Batch 3: leads[200:250] → add_leads_to_list_v2 → check counts
Report: Total added: X, Updated: Y, Failed: Z
```

---

## 4. Adding Leads to Campaigns

### Pre-Enrollment Checklist
Before adding ANY leads to a campaign:

1. **Campaign validation**
   - `get_campaign(campaignId)` → verify status is DRAFT or IN_PROGRESS
   - Check campaign has sequences configured

2. **Sender validation**
   - `get_all_linked_in_accounts()` → list available senders
   - Verify sender auth is valid
   - Calculate remaining daily capacity per sender

3. **Deduplication**
   - For each lead: `get_campaigns_for_lead(profileUrl=url)`
   - If lead is in ANY active campaign → SKIP (never enroll in multiple concurrent campaigns)

4. **Sender mapping**
   - Map leads to senders based on rules (see Campaign Management reference)
   - Distribute evenly across senders
   - Respect daily capacity limits

### accountLeadPairs Structure
```json
{
  "campaignId": 336673,
  "accountLeadPairs": [
    {
      "linkedInAccountId": 140055,
      "lead": {
        "profileUrl": "https://www.linkedin.com/in/prospect-one/",
        "firstName": "Ahmed",
        "lastName": "Hassan",
        "companyName": "TechCorp",
        "position": "VP Sales",
        "location": "Dubai, UAE",
        "emailAddress": "ahmed@techcorp.com",
        "customUserFields": [
          {"name": "signal_source", "value": "clay_enrichment"},
          {"name": "geo_market", "value": "uae"}
        ]
      }
    }
  ]
}
```

---

## 5. Deduplication Protocol

### Before Adding to Campaign
```
For each lead:
  1. get_campaigns_for_lead(profileUrl=lead.profileUrl)
  2. If result contains ANY campaign with status IN_PROGRESS or PAUSED:
     → SKIP this lead
     → Log: "Lead [name] already in campaign [ID] - skipping"
  3. If result is empty or all campaigns FINISHED/CANCELED:
     → OK to enroll
```

### Cross-Platform Dedup
When the same prospect exists in both HeyReach and Instantly:
- This is OK — they're different channels
- Coordinate timing via n8n: LinkedIn Day 1, Email Day 3 (or vice versa)
- If prospect replies on either channel → signal to n8n → pause the other channel

---

## 6. Tag Taxonomy & Routing

### Tag Categories
| Category | Purpose | Examples |
|----------|---------|----------|
| `signal` | Engagement signals from LinkedIn | `signal:connection_accepted`, `signal:replied_positive`, `signal:replied_negative`, `signal:viewed_profile`, `signal:liked_post` |
| `geo` | Geographic market | `geo:mena`, `geo:uae`, `geo:ksa`, `geo:us`, `geo:eu` |
| `score` | Lead temperature | `score:hot`, `score:warm`, `score:cold` |
| `source` | Lead origin | `source:clay`, `source:linkedin_search`, `source:event`, `source:referral` |
| `icp` | ICP classification | `icp:saas_founder`, `icp:vp_sales`, `icp:cto` |
| `status` | Current lifecycle status | `status:new`, `status:engaged`, `status:meeting_booked`, `status:not_interested` |
| `campaign` | Campaign tracking | `campaign:mena_saas_feb26`, `campaign:webinar_feb25` |

### Signal-to-Tag Mapping (Automated via Webhooks)
| LinkedIn Event | Tag Applied | Score Impact |
|---------------|-------------|-------------|
| Connection request accepted | `signal:connection_accepted` | → `score:warm` |
| Message reply received (positive) | `signal:replied_positive` | → `score:hot` |
| Message reply received (negative) | `signal:replied_negative` | → `score:cold` |
| Profile viewed | `signal:viewed_profile` | No score change |
| Post liked | `signal:liked_post` | No score change |
| Finished sequence without reply | `signal:sequence_complete_no_reply` | → `score:cold` |
| InMail reply | `signal:inmail_replied` | → `score:hot` |

### Tag Operations
- **add_tags_to_lead**: Appends tags. Existing tags preserved. Use `createTagIfNotExisting: true`.
- **replace_tags**: REPLACES all tags. Destructive. Only use when explicitly resetting tags.
- **get_tags_for_lead**: Read current tags before modifying.

---

## 7. Lead Lifecycle

```
NEW → SEQUENCED → ENGAGED → MEETING → CONVERTED
                      ↓
              NOT_INTERESTED → DORMANT (90 days) → RE-ENGAGE
```

### Status Transitions
| From | To | Trigger |
|------|-----|---------|
| new | sequenced | Added to campaign |
| sequenced | engaged | Connection accepted or reply received |
| engaged | meeting | Meeting booked (manual or via n8n) |
| meeting | converted | Deal created in GHL |
| sequenced | not_interested | Negative reply or explicit rejection |
| not_interested | dormant | 90 days elapsed |
| dormant | re-engage | New signal detected |

### Stop Lead Protocol
When a lead replies with "not interested" or similar:
1. `stop_lead_in_campaign(campaignId, leadMemberId, leadUrl)`
2. `add_tags_to_lead(tags=["signal:replied_negative", "score:cold", "status:not_interested"])`
3. Notify n8n to pause any email sequences for this lead in Instantly

---

## 8. Cross-Platform Matching

Leads exist across HeyReach, Instantly, and GHL. Matching keys:
- **Primary**: Email address (shared across all platforms)
- **Secondary**: LinkedIn profile URL (HeyReach-specific but stored in GHL custom field)
- **Tertiary**: Full name + company (fuzzy match, use with caution)

### Sync Pattern (via n8n)
```
HeyReach webhook → n8n → Match by email → Update GHL contact
                              → Match by email → Update Instantly lead tags
```

Always include `emailAddress` when adding leads to HeyReach for cross-platform matching.
