# Clay Integration Patterns

## CLAY → INSTANTLY.AI (Native Integration)

### Setup Steps

1. **In Clay:**
   - Create table with enriched prospect data
   - Required columns: email, first_name, last_name, company
   - Optional: personalization_variable_1, personalization_variable_2, job_title, buying_signal
   - Add action: "Add Lead to Campaign" (Instantly native)

2. **In Instantly:**
   - Create campaign, copy Campaign ID
   - Set up email sequences with variable placeholders

3. **In Clay (mapping):**
   - Paste Campaign ID into Clay's Instantly integration
   - Map Clay columns → Instantly lead fields

### Field Mapping Template

```
Clay Column              → Instantly Field
─────────────────────────────────────────
email                    → email (REQUIRED)
first_name               → first_name (REQUIRED)
last_name                → last_name (REQUIRED)
company_name             → company_name (REQUIRED)
job_title                → custom_variable_1
buying_signal            → custom_variable_2
personalization_hook     → custom_variable_3
company_size             → custom_variable_4
linkedin_url             → custom_variable_5
```

### Instantly Auto-Deduplication

Instantly automatically deduplicates on email + campaign level:
- If lead already in campaign → Won't re-add
- If lead on blocklist → Won't add
- No additional Clay logic needed for dedupe

### Common Integration Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Leads not appearing in Instantly | Empty email field in Clay row | Add conditional: only push if email is not empty |
| Bounce rate spikes | Enrichment returning false positives | Add verification waterfall BEFORE Instantly push |
| Field mapping failures | Mismatched column names | Test export on 5 rows first; check spelling exactly |
| Campaign not receiving leads | Wrong Campaign ID | Double-check Campaign ID copied from Instantly |
| Personalization variables empty | Clay column name mismatch | Ensure Clay column names match Instantly variable names exactly |

### Validation Before Push (MANDATORY)

```
Clay Table Flow:
1. Run email waterfall (find emails)
2. Run verification waterfall (ZeroBounce/Emaillistverify)
3. AI Formula: Filter → "valid" AND "safe_to_send" only
4. Conditional run: Only push rows where filter = PASS
5. Push to Instantly campaign
```

Never push unverified emails to Instantly. Bounce rate >2% = campaign pause = domain damage.

---

## CLAY → HEYREACH (Native Integration)

### Setup Requirements

- HeyReach API key (configured in Clay integrations)
- Active HeyReach campaign
- **LinkedIn URL column in Clay table (REQUIRED)**
- Optional: first_name, last_name, company_name

### Setup Steps

1. **In Clay:**
   - Ensure LinkedIn URL column is populated (use LinkedIn URL waterfall)
   - Add action: "Add Lead to HeyReach Campaign"
   - Map fields

2. **In HeyReach:**
   - Create campaign with connection request + follow-up messages
   - Copy Campaign ID

3. **Field Mapping:**

```
Clay Column              → HeyReach Field
─────────────────────────────────────────
linkedin_url             → LinkedIn URL (REQUIRED)
first_name               → First Name
last_name                → Last Name
company_name             → Company Name
job_title                → custom field
personalization_hook     → custom field
```

### HeyReach Auto-Deduplication

HeyReach auto-deduplicates on LinkedIn URL:
- Won't re-add if already in any campaign
- No additional Clay logic needed

### Limitations

- No native way to pull HeyReach reply data back to Clay
- Requires webhook or API polling for two-way sync
- HeyReach doesn't provide conversation history in Clay
- For reply tracking: use HeyReach webhook → n8n → Clay/GHL

### Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| "LinkedIn URL not found" error | Empty or malformed LinkedIn URL | Validate URL format before push; check for trailing slashes |
| Wrong person matched | LinkedIn URL mismatch (generic company name) | Add AI Formula to cross-check name + company vs LinkedIn URL |
| Lead not added to campaign | Campaign paused or full | Check HeyReach campaign status |
| Duplicate connection requests | Multiple Clay tables pushing same leads | Use HeyReach's built-in dedupe; don't push from multiple tables |

---

## CLAY → GOHIGHLEVEL (HTTP API — No Native Integration)

### Why HTTP API (Not Native)

GoHighLevel has NO native Clay integration. Must use HTTP API or middleware (n8n/Zapier).

### Setup: Direct HTTP API (Recommended)

1. **In GHL:**
   - Get API key: Settings → API → Generate Key
   - Create custom fields FIRST (before Clay mapping)
   - Note: firstName, lastName, email are standard fields
   - Custom fields: buying_signal, signal_type, enrichment_source, lead_score, region

2. **In Clay:**
   - Add HTTP Request action
   - Method: POST
   - URL: `https://api.gohighlevel.com/v1/contacts/`
   - Headers:
     ```
     Authorization: Bearer YOUR_GHL_API_KEY
     Content-Type: application/json
     ```

3. **Body Template:**

```json
{
  "firstName": "{{first_name}}",
  "lastName": "{{last_name}}",
  "email": "{{email}}",
  "phone": "{{phone}}",
  "companyName": "{{company_name}}",
  "tags": ["clay_enriched", "{{signal_type}}", "{{region}}"],
  "customField": {
    "buying_signal": "{{buying_signal}}",
    "lead_score": "{{lead_score}}",
    "enrichment_source": "clay_waterfall",
    "signal_detected_date": "{{signal_date}}",
    "linkedin_url": "{{linkedin_url}}",
    "job_title": "{{job_title}}"
  }
}
```

### Dedupe Pattern (CRITICAL)

GHL does NOT auto-dedupe from API. You must build dedupe logic:

```
Step 1: HTTP GET → Search contacts by email
  URL: https://api.gohighlevel.com/v1/contacts/lookup?email={{email}}

Step 2: AI Formula → Check if contact exists
  If found → Use contact ID for PUT (update)
  If not found → Use POST (create new)

Step 3: Conditional run
  If exists → HTTP PUT to update with new enrichment data
  If not exists → HTTP POST to create new contact
```

### GHL Custom Field Setup

Create these custom fields in GHL BEFORE Clay mapping:

| Field Name | Type | Purpose |
|-----------|------|---------|
| buying_signal | Text | Signal that triggered outreach |
| signal_type | Dropdown | job_change, funding, hiring, tech_adoption |
| lead_score | Number | 0-100 composite score |
| enrichment_source | Text | clay_waterfall, clay_claygent, manual |
| enrichment_date | Date | When enrichment ran |
| linkedin_url | URL | For manual research reference |
| region | Dropdown | mena, us, eu, apac |
| tier | Dropdown | tier_1, tier_2, tier_3 |
| icp_fit_score | Number | 0-100 firmographic match |

### Common GHL API Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| 400 Bad Request | Missing required fields | Make firstName/lastName/email mandatory in Clay conditional |
| 401 Unauthorized | Invalid API key | Regenerate GHL API key; verify Bearer token format |
| 429 Too Many Requests | Rate limit exceeded | Add 2-second delay between calls; batch to 100/minute max |
| Duplicate contacts | No dedupe logic | Implement GET-before-POST pattern above |
| Custom fields not mapping | Field not created in GHL first | Create ALL custom fields in GHL settings before pushing |
| Tags not applying | Wrong tag format | Tags must be array of strings; verify JSON format |
| Phone format errors | International format mismatch | Standardize to E.164 format in Clay AI Formula before push |

### Setup via n8n (Alternative)

If HTTP API feels complex, use n8n as middleware:

```
Clay webhook → n8n receives data
  → n8n: Check GHL for existing contact (HTTP GET)
  → n8n: If exists → Update contact (HTTP PUT)
  → n8n: If new → Create contact (HTTP POST)
  → n8n: Add tags, assign to pipeline
  → n8n: Trigger GHL automation (if configured)
  → n8n: Log result back to Clay or Google Sheets
```

**Advantage:** n8n handles error retry, rate limiting, and complex routing better than Clay's HTTP action alone.

---

## CLAY → N8N (Webhook + HTTP)

### Integration Methods

**Method 1: Clay Webhook → n8n (Push)**
- Clay sends enriched data to n8n webhook URL
- n8n processes, transforms, routes to multiple destinations
- Best for: Real-time routing after enrichment

**Method 2: n8n → Clay HTTP API (Pull)**
- n8n calls Clay API to read enriched data
- n8n processes and sends downstream
- Best for: Scheduled batch processing

**Method 3: Bidirectional (Full Sync)**
- Clay → n8n: Push enriched leads
- n8n → Clay: Push reply data, conversion updates
- Best for: Closed-loop reporting

### Typical n8n Workflow

```
Trigger: Clay webhook (new enriched lead)
  → n8n: Receive webhook data
  → n8n: Check for duplicates (query your database)
  → n8n: Route based on rules:
    - If tier_1 + email valid → Push to Instantly campaign A
    - If tier_1 + linkedin_url → Push to HeyReach campaign B
    - If tier_2 → Push to GHL nurture sequence
    - If tier_3 → Add to GHL with "nurture" tag only
  → n8n: Push contact to GHL (always, for CRM record)
  → n8n: Update Clay table with sync status
  → n8n: Send Slack notification for tier_1 leads
```

### n8n Rate Limit Handling

Set request delays between Clay API calls:
- 500ms between calls for standard endpoints
- 2000ms for GHL API (strict rate limits)
- Use n8n's built-in "Wait" node between batches

### Webhook 50K Limit

Clay has a 50K cumulative submission limit per webhook table. This is NOT rolling — it's total lifetime.

**Mitigation:**
- Create new webhook tables periodically (monthly)
- Archive processed rows to external database
- Use n8n to manage table rotation

---

## TAG TAXONOMY (Shared Across All Skills)

Use these tags consistently across Clay → Instantly → HeyReach → GHL:

### Signal Type Tags
- `signal_type:job_change`
- `signal_type:funding`
- `signal_type:hiring`
- `signal_type:tech_adoption`
- `signal_type:expansion`
- `signal_type:leadership_change`

### Enrichment Status Tags
- `enrichment_status:complete`
- `enrichment_status:partial`
- `enrichment_status:failed`
- `enrichment_status:manual_needed`

### Region Tags
- `region:mena`
- `region:us`
- `region:eu`
- `region:uk`
- `region:apac`

### Tier Tags (from signal scoring)
- `tier:1` (Score 80+ → personalized outreach)
- `tier:2` (Score 60-79 → templated outreach)
- `tier:3` (Score <60 → automated nurture)

### Source Tags
- `source:clay_waterfall`
- `source:clay_claygent`
- `source:clay_manual`
- `source:linkedin_research`
- `source:referral`

### Channel Tags (set by outbound-orchestrator)
- `channel:email_cold`
- `channel:linkedin`
- `channel:whatsapp`
- `channel:phone`
- `channel:multi`

---

## REPLY HANDLING WORKFLOW

### Instantly Replies → CRM

```
1. Instantly detects reply (automatic)
2. Instantly webhook → n8n
3. n8n: Parse reply text + contact data
4. n8n: Update GHL contact (add tag: "replied", update pipeline stage)
5. n8n: Create GHL task for SDR follow-up (within 1 hour)
6. n8n: Send Slack notification to sales team
7. Optional: n8n → Clay: Update results tracking table
```

### HeyReach Replies → CRM

```
1. HeyReach detects LinkedIn reply
2. HeyReach webhook → n8n
3. n8n: Parse reply + lead data
4. n8n: Match to GHL contact by LinkedIn URL or email
5. n8n: Update GHL contact (add tag: "linkedin_replied")
6. n8n: Create GHL task for follow-up
7. n8n: Send Slack notification
```

### Bidirectional Sync Architecture

```
Clay (enrichment) ──webhook──→ n8n (routing)
                                  ├──→ Instantly (cold email)
                                  ├──→ HeyReach (LinkedIn)
                                  └──→ GHL (CRM + nurture)

Instantly (replies) ──webhook──→ n8n ──→ GHL (update contact)
HeyReach (replies)  ──webhook──→ n8n ──→ GHL (update contact)
GHL (status change) ──webhook──→ n8n ──→ Clay (update results table)
```
