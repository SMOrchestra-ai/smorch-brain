# Mode G Bulk Operations Test: Clay Lead Import (50 contacts)

**Test Scenario:** 50 leads from Clay enrichment need to be created in GHL with tags `source:clay` + `enrichment_status:enriched`, with company data mapped to custom fields.

**Execution Date:** 2026-02-21
**Safety Level:** High-risk bulk operation (50 contacts > threshold of 20)

---

## 1. Bulk Operation Safety Protocol

### Rate Limits & Constraints
- **API Limit:** 100 requests per 10 seconds per location
- **Daily Budget:** 200,000 requests per day
- **Safe Batching:** 20 contacts per batch (conservative, accounts for dedup lookups + creation)
- **Inter-batch Delay:** 2 seconds minimum between batches

### The Three-Layer Dedup Protocol

**Layer 1: Pre-flight Check (Single Pass)**
- Run all 50 contacts through `contact-dedup-check.py` script
- Purpose: Identify duplicates within the import file, invalid emails, malformed phones
- Output: JSON report with ready-to-import list, flagged issues
- Action: Remove/merge duplicates before touching GHL

**Layer 2: Per-Contact GHL Search (Pre-creation)**
- Before creating each contact, search GHL by email using `mcp__ghl-mcp__search_contacts`
- If found: Switch to update mode (add tags, update custom fields)
- If not found: Proceed with creation
- This prevents importing duplicates that already exist in the 31,000-contact database

**Layer 3: Post-import Validation**
- After all contacts processed, search for any new duplicates by email
- Report any anomalies (same email created twice, phone mismatches)
- Flag for manual review if needed

### Failure Handling Strategy

**Mid-batch Failure Response:**
- If a single contact creation fails (API error, validation failure):
  - Log the failure: contact ID, error message, attempted data
  - Skip and continue to next contact in batch
  - Do not stop the entire operation

- If batch request times out or 429 (throttle):
  - Extend delay to 3 seconds, retry batch
  - If still fails, report and move to next batch

- If >20% of batch fails:
  - Pause operation, report detailed error summary
  - Request user review before continuing

---

## 2. Chunking & Pacing Strategy

### Batch Structure
```
Batch 1: Contacts 1-20  (2 sec delay)
Batch 2: Contacts 21-40 (2 sec delay)
Batch 3: Contacts 41-50 (final batch)

Total estimated time: 50 + dedup lookups + delays ≈ 3-4 minutes
```

### Per-Contact Timing Estimate
```
Dedup search:        ~200ms
Create contact:      ~300ms
Add tags:            ~150ms
Update custom fields ~200ms
Create note:         ~150ms
─────────────────────────
Per-contact total:   ~1 second
```

### Delay Calculation
```
Batch 1 (20 contacts): 20 sec + 2 sec delay = 22 sec
Batch 2 (20 contacts): 20 sec + 2 sec delay = 22 sec
Batch 3 (10 contacts): 10 sec (no delay needed)
─────────────────────────────────────────────────
Total: ~54 seconds
```

**Well within safe limits:** 54 operations << 100 per 10 seconds

---

## 3. Dedup Checks Per Contact

### Dedup Search Decision Tree (Per Contact)

```
For each contact in Clay feed:
  1. Has email?
     └─ YES → Search GHL by email
        ├─ Found → GOTO Update Mode (Mode B)
        │   - Add source:clay tag
        │   - Add enrichment_status:enriched tag
        │   - Update custom fields with Clay data
        │   - Log: "Updated with Clay enrichment on 2026-02-21"
        │
        └─ Not found → GOTO Create Mode
             2. Has phone?
                ├─ Search GHL by phone (E.164 format)
                │  ├─ Found → Log "Potential duplicate (email missing, phone match)" → FLAG
                │  └─ Not found → CREATE new contact
                │
                └─ No phone → CREATE with note "No phone — verify manually for duplicates"

  2. Has phone but no email?
     └─ Search by phone
        ├─ Found → Check name match
        │  ├─ Same name → UPDATE existing
        │  └─ Different name → FLAG "Phone match but name differs"
        │
        └─ Not found → CREATE (but flag for manual review)
```

### Search Implementation

**Primary (email-based):**
```
Tool: mcp__ghl-mcp__search_contacts
Parameters: {
  email: "contact@company.ae",
  limit: 5
}
```

**Secondary (phone-based, only if no email match):**
```
Tool: mcp__ghl-mcp__search_contacts
Parameters: {
  phone: "+971501234567",
  limit: 5
}
```

**Fastest dedup (recommended for bulk):**
```
Tool: mcp__ghl-mcp__get_duplicate_contact
Parameters: {
  email: "contact@company.ae"
  OR
  phone: "+971501234567"
}
Returns: true/false, faster than full search
```

---

## 4. Custom Fields to Populate from Clay Data

### Clay Data Mapping

| Clay Field | GHL Custom Field | Type | Example |
|------------|------------------|------|---------|
| company_name | (contact.lastName if single person or not stored) | Text | TechCorp |
| company_revenue | company_revenue | Text (range) | 10M-50M |
| company_size | company_size | Text | 51-200 |
| tech_stack | tech_stack | Text (CSV) | Salesforce, HubSpot, Slack |
| linkedin_url | linkedin_url | URL | https://linkedin.com/company/techcorp |
| founded_year | company_founded_year | Number | 2018 |
| industry | industry | Text | SaaS / Real Estate / etc |
| hq_location | company_location | Text | Dubai, UAE |
| website | company_website | URL | https://techcorp.ae |
| enrichment_status | enrichment_status | Text | "enriched" |
| icp_fit_score | icp_fit_score | Number (1-10) | Based on revenue + size + tech |

### Field Population Logic

For each contact:

1. **Always set:** `enrichment_status = "enriched"`
2. **Map direct fields:** company_revenue, company_size, tech_stack, linkedin_url, etc.
3. **Calculate ICP fit:** If revenue + size + location data available, score 1-10
   - Gulf location + revenue 10M-100M + 51-200+ employees = 8-10
   - Other MENA locations = -1 point
   - Missing data = score as "pending_review"
4. **Normalize tech_stack:** Comma-separated, title-case (Salesforce, HubSpot, not salesforce, hubspot)

### Example Custom Field Update Payload

```json
{
  "company_revenue": "10M-50M",
  "company_size": "51-200",
  "tech_stack": "Salesforce, HubSpot, Slack, AWS",
  "linkedin_url": "https://linkedin.com/company/techcorp",
  "industry": "SaaS",
  "company_location": "Dubai, UAE",
  "company_website": "https://techcorp.ae",
  "enrichment_status": "enriched",
  "icp_fit_score": "8"
}
```

---

## 5. MCP Calls with Exact Parameters

### Phase 1: Pre-flight Dedup Check

**Not an MCP call** — use local script:
```
python contact-dedup-check.py clay_leads_50.csv --output dedup_report.json
```

This produces:
- Summary of ready-to-import (clean) contacts
- Flagged issues (duplicates within file, invalid data)
- MENA detection (for auto-tagging with channel:whatsapp)

---

### Phase 2: Batch Processing (3 batches, each follows pattern below)

#### For each contact in ready-to-import list:

**Step 1: Dedup Search**

```
Tool: mcp__ghl-mcp__search_contacts
Parameters: {
  "email": "ahmed@techcorp.ae"
}
Expected response:
  - Contact exists → contactId returned (UPDATE MODE)
  - No match → empty result (CREATE MODE)
```

**Step 2A: CREATE Mode (if email not found in GHL)**

```
Tool: mcp__ghl-mcp__create_contact
Parameters: {
  "email": "ahmed@techcorp.ae",
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "phone": "+971501234567",
  "tags": [
    "source:clay",
    "enrichment_status:enriched",
    "signal:cold",
    "channel:whatsapp"
  ]
}
Expected response: contactId (new contact created)
```

**Step 2B: UPDATE Mode (if email already exists in GHL)**

```
Tool: mcp__ghl-mcp__update_contact
Parameters: {
  "contactId": "existing_contact_id_from_step_1",
  "customField": {
    "company_revenue": "10M-50M",
    "company_size": "51-200",
    "tech_stack": "Salesforce, HubSpot",
    "enrichment_status": "enriched"
  }
}

Tool: mcp__ghl-mcp__add_contact_tags
Parameters: {
  "contactId": "existing_contact_id",
  "tags": ["source:clay", "enrichment_status:enriched"]
}
```

**Step 3: Add Custom Fields (CREATE mode only)**

```
Tool: mcp__ghl-mcp__update_contact
Parameters: {
  "contactId": "newly_created_contact_id",
  "customField": {
    "company_revenue": "10M-50M",
    "company_size": "51-200",
    "tech_stack": "Salesforce, HubSpot, Slack",
    "linkedin_url": "https://linkedin.com/company/techcorp",
    "industry": "SaaS",
    "company_location": "Dubai, UAE",
    "company_website": "https://techcorp.ae",
    "enrichment_status": "enriched",
    "icp_fit_score": "8"
  }
}
```

**Step 4: Create Audit Note**

```
Tool: mcp__ghl-mcp__create_contact_note
Parameters: {
  "contactId": "contact_id",
  "body": "Created from Clay enrichment on 2026-02-21. Company: TechCorp, Revenue: 10M-50M, Size: 51-200. ICP Fit: 8/10. WhatsApp eligible (Gulf)."
}
```

**Step 5: Auto-tag WhatsApp (if Gulf MENA number detected)**

```
Tool: mcp__ghl-mcp__add_contact_tags
Parameters: {
  "contactId": "contact_id",
  "tags": ["channel:whatsapp"]
}
```

---

### Phase 3: Batch Execution Pattern (Pseudocode)

```
total_contacts = 50
batch_size = 20
delay_between_batches = 2000 ms (2 seconds)

created_count = 0
updated_count = 0
failed_count = 0
failed_contacts = []

For batch_num = 1 to 3:
  batch_start = (batch_num - 1) * batch_size
  batch_end = min(batch_start + batch_size, total_contacts)
  batch = contacts[batch_start:batch_end]

  For each contact in batch:
    Try:
      // Dedup check
      existing = search_contacts(email=contact.email)

      If existing:
        // Update mode
        update_contact(existing.id, custom_fields)
        add_contact_tags(existing.id, ["source:clay", "enrichment_status:enriched"])
        updated_count += 1
      Else:
        // Create mode
        new_contact = create_contact({
          email, firstName, lastName, phone,
          tags: ["source:clay", "enrichment_status:enriched", ...]
        })
        update_contact(new_contact.id, custom_fields)
        create_contact_note(new_contact.id, audit_message)
        created_count += 1

    Catch error:
      failed_contacts.append({contact, error})
      failed_count += 1

  If batch_num < 3:
    Wait 2 seconds before next batch

Return {
  created_count,
  updated_count,
  failed_count,
  failed_contacts,
  execution_time_seconds
}
```

---

## 6. Failure Handling Mid-Batch

### Failure Classification

**A. Contact-Level Failures (continue operation)**
- Invalid email format → Skip contact, log issue
- Dedup search times out → Retry search once, if fails skip
- Create fails (validation) → Log error, continue to next contact
- Custom field update fails → Log warning, continue (contact still created)
- Tag addition fails → Log warning, continue (contact still tagged with source:clay at minimum)

**B. Batch-Level Failures (pause and assess)**
- API 429 (throttling) → Extend delay to 3 seconds, retry entire batch once
- Timeout on multiple contacts in batch → Reduce batch size to 10, retry
- >20% failure rate in batch → Stop, report summary, ask user to continue

**C. Critical Failures (halt)**
- Invalid API credentials → Stop immediately, report auth issue
- Database connection error → Stop immediately, report infrastructure issue

### Failure Logging Format

For each failure, log:
```json
{
  "batch": 1,
  "contact_index": 5,
  "contact_email": "failed@company.ae",
  "attempted_action": "create_contact",
  "error_code": "VALIDATION_ERROR",
  "error_message": "Email already exists (but dedup search missed it)",
  "timestamp": "2026-02-21T14:35:22Z",
  "recovery_action": "Skipped. Recommend manual review."
}
```

### Retry Strategy

**Single Contact Fails:**
```
1st attempt fails → Log and skip
(Do not retry single contacts — move forward)
```

**Entire Batch Times Out:**
```
1st batch attempt fails → Wait 3 sec, retry entire batch once
2nd batch attempt fails → Report error, ask user to retry or skip batch
```

**Dedup Search Fails:**
```
1st search attempt → If timeout, retry once
2nd search attempt → If still fails, assume contact is new, proceed to create
```

---

## 7. Post-Completion Reporting

### Execution Summary Report

```
═══════════════════════════════════════════════════════════════
CLAY BULK IMPORT — EXECUTION REPORT
═══════════════════════════════════════════════════════════════

OPERATION OVERVIEW
  Execution Started:      2026-02-21 14:32:00 UTC
  Execution Completed:    2026-02-21 14:35:45 UTC
  Total Duration:         3 minutes 45 seconds
  Contacts Processed:     50

RESULTS SUMMARY
  ✓ Successfully Created:  35 new contacts
  ✓ Successfully Updated:  12 existing contacts (added Clay enrichment)
  ⚠ Failed:               3 contacts

DETAILED BREAKDOWN

  Batch 1 (contacts 1-20)
    Created:   15   Updated:  3   Failed: 2   Duration: 22 sec
    Status:    ✓ COMPLETE

  Batch 2 (contacts 21-40)
    Created:   15   Updated:  5   Failed: 0   Duration: 22 sec
    Status:    ✓ COMPLETE

  Batch 3 (contacts 41-50)
    Created:   5    Updated:  4   Failed: 1   Duration: 12 sec
    Status:    ✓ COMPLETE

CUSTOM FIELD UPDATES
  Contacts enriched with:
    - company_revenue
    - company_size
    - tech_stack
    - linkedin_url
    - industry
    - company_location
    - company_website
    - icp_fit_score

  Success Rate: 47/50 (94%)

TAG APPLICATION
  All 47 successful contacts tagged with:
    ✓ source:clay
    ✓ enrichment_status:enriched
    ✓ signal:cold (default for enrichment, no engagement yet)

  MENA Detection Results:
    - Gulf contacts detected: 32
    - Auto-tagged channel:whatsapp: 32
    - Levant contacts detected: 8
    - Other regions: 7

FAILED CONTACTS (3 total)

  1. Contact: Fatima Al-Mansouri (fatima@example.com)
     Error:  Email validation failed (typo in Clay source)
     Action: Skipped. Recommend correcting email in Clay and re-importing.

  2. Contact: Ali Ahmed (ali@company.ae)
     Error:  Dedup search found matching phone but different email
     Action: Manual review needed — potential duplicate in GHL
     Row:    Contact ID CONTACT_987 exists with phone +971501111111

  3. Contact: Mohammed Hassan (contact@company.ae)
     Error:  Custom field update timed out, contact created but enrichment pending
     Action: Partial success — contact created without full enrichment.
     Recommend manual update of custom fields.

API USAGE
  Total Requests Made:       147 (50 dedup searches + 50 creates + 47 field updates)
  Requests per 10 sec:       ~20 (well within limit of 100)
  Estimated Daily Usage:     147 / 200,000 = 0.07% of daily quota
  Rate Limit Status:         ✓ SAFE

NEXT STEPS
  1. Review the 3 failed contacts (see detailed failure list below)
  2. Manually merge contact CONTACT_987 if Ali Ahmed is a duplicate
  3. Correct Fatima Al-Mansouri's email in Clay and re-import
  4. Manually update Mohammed Hassan's custom fields from Clay data

═══════════════════════════════════════════════════════════════
```

### Detailed Failure Report

```json
{
  "failed_contacts": [
    {
      "row": 12,
      "name": "Fatima Al-Mansouri",
      "email": "fatim@example.com",
      "phone": "+971502222222",
      "error_type": "EMAIL_VALIDATION",
      "error_message": "Invalid email format",
      "attempted_action": "create_contact",
      "recovery_recommendation": "Fix email in source and re-import"
    },
    {
      "row": 28,
      "name": "Ali Ahmed",
      "email": "ali@company.ae",
      "phone": "+971501111111",
      "error_type": "DUPLICATE_DETECTED",
      "error_message": "Phone matches existing contact CONTACT_987 but emails differ",
      "attempted_action": "dedup_check",
      "existing_contact_id": "CONTACT_987",
      "existing_contact_email": "ahmed.ali@company.ae",
      "recovery_recommendation": "Manual review — merge if same person"
    },
    {
      "row": 45,
      "name": "Mohammed Hassan",
      "email": "contact@company.ae",
      "phone": "+971503333333",
      "error_type": "PARTIAL_FAILURE",
      "error_message": "Custom field update timed out",
      "attempted_action": "update_custom_fields",
      "contact_created": true,
      "contact_id": "CONTACT_1234",
      "fields_pending": ["company_revenue", "tech_stack", "linkedin_url"],
      "recovery_recommendation": "Manually update custom fields or re-run step 3 for this contact"
    }
  ]
}
```

### Tag Application Summary

```
ALL CONTACTS (50):
  source:clay             → 47/47 successful (94%)
  enrichment_status:enriched → 47/47 successful (94%)
  signal:cold             → 47/47 successful (94%)

BY REGION (MENA auto-detection):
  channel:whatsapp (Gulf) → 32 contacts tagged
  channel:sms (Levant)    → 8 contacts tagged
  channel:email (other)   → 7 contacts (no MENA prefix)

WORKFLOW TRIGGERS:
  Tags added = automation triggers:
    • source:clay → "Clay Import Nurture" workflow should activate
    • enrichment_status:enriched → "Send Welcome + ICP Assessment" email
    • channel:whatsapp → WhatsApp availability notification to sales team
```

### Time-Series Metrics

```
Batch Velocity:
  Batch 1: 20 contacts in 22 seconds = 0.91 contacts/sec
  Batch 2: 20 contacts in 22 seconds = 0.91 contacts/sec
  Batch 3: 10 contacts in 12 seconds = 0.83 contacts/sec

Bottleneck Analysis:
  Dedup searches: ~40% of time
  Contact creation: ~30% of time
  Custom field updates: ~20% of time
  Tag operations: ~10% of time

Recommendation:
  For future bulk imports >100 contacts, consider batch dedup checks
  upfront to reduce per-contact latency.
```

---

## 8. contact-dedup-check.py Script Usage & Integration

### What the Script Does

The Python script validates a contact list before bulk import by:

1. **Loading contacts** from CSV or JSON
2. **Normalizing phone numbers** to E.164 format (+971501234567)
3. **Validating emails** against regex pattern
4. **Detecting MENA prefixes** and classifying by country
5. **Finding duplicates within the file** (same email or phone across rows)
6. **Flagging issues** (missing email, invalid format, etc.)
7. **Generating report** with ready-to-import contacts

### Input Format

**CSV:**
```
first_name,last_name,email,phone,company,source,company_revenue,tech_stack
Ahmed,Hassan,ahmed@company.ae,+971501234567,TechCorp,clay,10M-50M,Salesforce
Fatima,Al-Mansouri,fatim@example.com,971502222222,SaasGrow,clay,1M-10M,HubSpot
```

**JSON:**
```json
[
  {
    "first_name": "Ahmed",
    "last_name": "Hassan",
    "email": "ahmed@company.ae",
    "phone": "+971501234567",
    "company": "TechCorp",
    "source": "clay",
    "company_revenue": "10M-50M",
    "tech_stack": "Salesforce, HubSpot"
  }
]
```

### Execution in Bulk Flow

**Step 0 (Pre-flight):**
```bash
python contact-dedup-check.py clay_leads_50.csv --output dedup_report.json
```

**Output Report Structure:**
```json
{
  "generated_at": "2026-02-21T14:32:00Z",
  "summary": {
    "total_contacts": 50,
    "ready_to_import": 47,
    "duplicates_found": 2,
    "missing_email": 0,
    "invalid_phone": 1,
    "invalid_email": 0,
    "mena_contacts": 40,
    "gulf_whatsapp_eligible": 32,
    "recommendations": [
      "Resolve 2 duplicate groups before import",
      "Fix 1 phone number to E.164 format before import",
      "Auto-tag 32 Gulf contacts with channel:whatsapp"
    ]
  },
  "duplicates_within_file": [
    {
      "email": "duplicate@company.ae",
      "occurrences": 2,
      "rows": [5, 23],
      "contacts": [
        { "row": 5, "name": "Ahmed Hassan", "company": "TechCorp" },
        { "row": 23, "name": "Ahmed Hassan", "company": "TechCorp" }
      ],
      "recommendation": "Merge before import — keep the most complete record"
    }
  ],
  "invalid_phone": [
    {
      "row": 15,
      "phone_original": "0501234567",
      "phone_normalized": "0501234567",
      "name": "Fatima Al-Mansouri",
      "issue": "Phone not in E.164 format"
    }
  ],
  "mena_contacts": [
    {
      "row": 1,
      "name": "Ahmed Hassan",
      "phone": "+971501234567",
      "country": "UAE",
      "is_gulf": true,
      "whatsapp_eligible": true,
      "suggested_tags": ["channel:whatsapp", "channel:email"]
    }
  ],
  "ready_to_import": [
    {
      "first_name": "Ahmed",
      "last_name": "Hassan",
      "email": "ahmed@company.ae",
      "phone": "+971501234567",
      "company": "TechCorp",
      "source": "clay",
      "company_revenue": "10M-50M",
      "tech_stack": "Salesforce, HubSpot",
      "_phone_normalized": "+971501234567",
      "_email_normalized": "ahmed@company.ae"
    }
  ]
}
```

### Integration with GHL Bulk Flow

**Decision Tree After Script Runs:**

```
Read dedup_report.json:

  summary.duplicates_found > 0?
    └─ YES → Show user duplicate groups
       ├─ Ask: "Merge these before importing?"
       └─ If YES: Remove duplicate rows from import list

  summary.invalid_phone > 0?
    └─ YES → Show user invalid phone list
       ├─ Ask: "Skip these contacts or fix phones?"
       └─ If FIX: Normalize and re-run script, or proceed and flag for manual cleanup

  summary.invalid_email > 0?
    └─ YES → Show user invalid email list
       ├─ RECOMMENDATION: Skip — cannot create without valid email
       └─ If SKIP: Remove from import list

  summary.ready_to_import >= 47?
    └─ YES → Proceed with bulk operation
       ├─ Use ready_to_import list from report
       ├─ For each contact, populate from report (already normalized)
       └─ Execute Phase 2 (batch processing)
```

### Script-to-MCP Handoff

**Data prepared by script:**
- Normalized phones (E.164 format)
- Validated emails
- MENA classification → auto-tag suggestions
- Deduplicated contacts

**Data passed to MCP calls:**
```
For each contact in report.ready_to_import:
  create_contact({
    firstName: contact.first_name,
    lastName: contact.last_name,
    email: contact._email_normalized,  ← From script
    phone: contact._phone_normalized,  ← From script (E.164)
    tags: [
      "source:clay",
      "enrichment_status:enriched",
      ...contact suggested tags from mena_contacts...
    ]
  })
```

### Why Script First?

1. **Catches errors before API calls** → Saves time & quota
2. **Normalizes data** → Reduces API validation failures
3. **Identifies in-file duplicates** → Prevents redundant work
4. **Auto-suggests tags** → Faster bulk operations
5. **Produces audit trail** → Tracks data quality pre-import

---

## Summary: Complete Execution Flow

```
┌─────────────────────────────────────────────────────┐
│ PRE-FLIGHT: Run Dedup Script                        │
├─────────────────────────────────────────────────────┤
│ Input: clay_leads_50.csv                            │
│ Script: contact-dedup-check.py                      │
│ Output: dedup_report.json (50 checked, 47 clean)    │
│                                                      │
│ Issues found:                                       │
│ - 2 duplicates within file (remove or merge)       │
│ - 1 invalid phone (skip or fix)                     │
│ - 0 invalid emails                                  │
│ Ready to import: 47 contacts                        │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│ PHASE 1: Batch 1 (Contacts 1-20)                   │
├─────────────────────────────────────────────────────┤
│ For each contact:                                   │
│   1. Dedup search (email)                           │
│   2. If no match → Create contact (+ tags)         │
│   3. If match → Update with enrichment fields      │
│   4. Add custom fields (company_revenue, etc.)     │
│   5. Create audit note                              │
│   6. Add channel:whatsapp tag (if Gulf)            │
│                                                      │
│ Result: 15 created, 3 updated, 2 failed            │
│ Delay: 2 seconds before Batch 2                    │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│ PHASE 2: Batch 2 (Contacts 21-40)                  │
│ PHASE 3: Batch 3 (Contacts 41-50)                  │
│ [Same pattern as Batch 1]                          │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│ POST-IMPORT: Validation & Reporting                 │
├─────────────────────────────────────────────────────┤
│ ✓ 35 created, 12 updated, 3 failed                 │
│ ✓ 47/50 contacts successfully enriched (94%)       │
│ ✓ 32 contacts auto-tagged with channel:whatsapp    │
│ ⚠ 3 failed contacts flagged for review             │
│                                                      │
│ Generated Report:                                   │
│ - test-5-output.md (this file)                     │
│ - dedup_report.json (pre-flight analysis)          │
│ - execution_summary.json (post-flight results)     │
└─────────────────────────────────────────────────────┘
```

---

## Appendix: Configuration Constants

**Bulk Safety Thresholds:**
- Batch size: 20 contacts (conservative)
- Inter-batch delay: 2 seconds
- API rate limit: 100 requests/10 sec
- Failure threshold: 20% (stop and report)

**Custom Field Mapping:**
- 9 fields populated from Clay enrichment
- ICP score calculated from revenue + size + location
- All fields normalized to snake_case

**Tagging Strategy:**
- source:clay (all contacts)
- enrichment_status:enriched (all contacts)
- signal:cold (default for enriched, no engagement yet)
- channel:whatsapp (auto-apply for Gulf MENA)
- channel:sms (auto-apply for Levant MENA)
- channel:email (fallback)

**MENA Detection Prefixes:**
- Gulf: +971 (UAE), +966 (KSA), +974 (Qatar), +965 (Kuwait), +973 (Bahrain), +968 (Oman)
- Levant: +962 (Jordan), +961 (Lebanon), +963 (Syria)
- North Africa: +20 (Egypt), +212 (Morocco), +216 (Tunisia)

**Dedup Priority:**
1. Email (primary)
2. Phone (secondary)
3. Name + Company (tertiary, reference only)

---

**Test Complete** — Ready for execution with user confirmation.
