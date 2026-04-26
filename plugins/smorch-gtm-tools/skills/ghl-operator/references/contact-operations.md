# Contact Operations Reference

> **v2 migration banner — 2026-04-26.** Bare tool names in this doc (e.g., `search_contacts`, `create_contact`) are now **operation names** under the new `mcp__salesmfast-ops__ghl-contacts-reader` and `ghl-contacts-updater` routers. Call shape: `{ selectSchema: { operation, params } }`. See `SKILL.md → MCP Tools Reference` or `salesmfast-ops-mcp/docs/MIGRATION.md` for the full mapping.

## Table of Contents
1. [Deduplication Protocol](#deduplication-protocol)
2. [Contact Creation](#contact-creation)
3. [Contact Updates](#contact-updates)
4. [Custom Field Management](#custom-field-management)
5. [Bulk Operations](#bulk-operations)
6. [Cross-Platform Matching](#cross-platform-matching)

---

## Deduplication Protocol

Duplicates are the #1 data quality issue in a CRM with 31,000+ contacts. Every contact creation must pass through dedup first.

### Search Order
1. **Email** (primary key) — `mcp__ghl-mcp__search_contacts` with email parameter
2. **Phone** (secondary) — Search by phone in E.164 format
3. **Name + Company** (tertiary) — Only if neither email nor phone available

### Dedup Decision Tree
```
Has email? → Search by email
  ├─ Found → UPDATE existing contact (Mode B)
  └─ Not found → Has phone?
       ├─ Search by phone
       │   ├─ Found → Check if same person (name match?) → UPDATE or FLAG for review
       │   └─ Not found → CREATE new contact
       └─ No phone → CREATE with note "No dedup key — verify manually"
```

### Using the Dedup Tool
```
Tool: mcp__ghl-mcp__get_duplicate_contact
Purpose: Check if a contact with this email/phone already exists
Use BEFORE: Every create_contact call
```

### Merge Duplicates
When duplicates are discovered:
1. Identify the "primary" record (older, more complete, more pipeline activity)
2. Copy missing fields from secondary to primary
3. Move all tags from secondary to primary
4. Move opportunities from secondary to primary
5. Add note to primary: "Merged with duplicate contact [ID] on [date]"
6. Delete secondary (or tag as `status:duplicate` for audit trail)

---

## Contact Creation

### Required Fields
```json
{
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "email": "ahmed@techcorp.ae",
  "phone": "+971501234567",
  "tags": ["source:instantly", "signal:hot", "icp:mena_saas"],
  "customField": {
    "signal_score": "8",
    "signal_source": "instantly_reply",
    "last_signal_date": "2026-02-21T14:30:00Z",
    "enrichment_status": "pending"
  }
}
```

### Phone Number Formatting
All phone numbers must be stored in E.164 format (international standard).

| Country | Prefix | Example |
|---------|--------|---------|
| UAE | +971 | +971501234567 |
| Saudi Arabia | +966 | +966551234567 |
| Qatar | +974 | +97441234567 |
| Kuwait | +965 | +96551234567 |
| Bahrain | +973 | +97331234567 |
| Oman | +968 | +96891234567 |
| Jordan | +962 | +962791234567 |
| Egypt | +20 | +201001234567 |
| US | +1 | +12125551234 |
| UK | +44 | +447911123456 |

### MENA Phone Detection Pattern
```
Gulf: /^\+?(971|966|974|965|973|968)/
Levant: /^\+?(962|961|963)/
North Africa: /^\+?(20|212|216)/
```

If a phone matches a MENA pattern, auto-add `channel:whatsapp` tag (WhatsApp penetration in MENA is >90%).

### Contact Creation Workflow
```
1. Dedup check (search by email)
2. Format phone to E.164
3. Detect MENA number → add channel:whatsapp tag
4. Create contact with all fields
5. Add source tag (source:instantly / source:heyreach / source:clay / source:website)
6. Add signal tag (signal:hot / signal:warm / signal:cold)
7. Add ICP tag if known
8. Create audit note: "Created from [source] on [date]. Signal: [type]. Score: [X]."
9. If hot signal → create opportunity (see pipeline-management.md)
```

---

## Contact Updates

### Update Patterns

**Signal update** — New engagement detected:
```
1. Update signal_score custom field
2. Update last_signal_date to now
3. Upgrade signal tag if warranted (cold→warm, warm→hot)
4. Add note: "[Signal type] detected on [date]. Score updated [old]→[new]."
5. If now hot → check if opportunity exists → create or advance stage
```

**Enrichment update** — Clay data received:
```
1. Update custom fields: company_revenue, tech_stack, linkedin_url, etc.
2. Set enrichment_status = "enriched"
3. Add note: "Enriched via Clay on [date]. Company: [name], Revenue: [range]."
4. Re-evaluate ICP fit based on new data
```

**Tag updates** — Tags are the routing mechanism. Key rules:
- Tags are additive by default — add new tags, don't remove old ones (preserves history)
- Only remove tags when explicitly reclassifying (e.g., removing `signal:cold` when upgrading to `signal:warm`)
- When changing signal tags, remove the old level first, then add the new one
- Source tags never get removed — a contact can have multiple sources

### Update via MCP
```
Tool: mcp__ghl-mcp__update_contact
Required: contactId
Fields: Any contact field can be updated

Tool: mcp__ghl-mcp__add_contact_tags
Required: contactId, tags (array)

Tool: mcp__ghl-mcp__remove_contact_tags
Required: contactId, tags (array)
```

---

## Custom Field Management

### Standard Custom Fields

| Field Name | Type | Description | Example Values |
|------------|------|-------------|----------------|
| `signal_score` | Number (1-10) | Current engagement/intent score | 1, 5, 8, 10 |
| `signal_source` | Text | What triggered the latest signal | instantly_reply, heyreach_connection, website_visit, form_submit |
| `last_signal_date` | Date (ISO 8601) | When the last signal was detected | 2026-02-21T14:30:00Z |
| `enrichment_status` | Text | Clay enrichment state | pending, enriched, failed, not_applicable |
| `company_revenue` | Text | Annual revenue range from Clay | <1M, 1M-10M, 10M-50M, 50M-100M, 100M+ |
| `tech_stack` | Text | Comma-separated tech from Clay | Salesforce, HubSpot, Slack, AWS |
| `linkedin_url` | URL | LinkedIn profile for cross-matching | https://linkedin.com/in/ahmedhassan |
| `budget_range` | Text | Estimated budget for solution | <10K, 10K-50K, 50K-100K, 100K+ |
| `company_size` | Text | Employee count range | 1-10, 11-50, 51-200, 201-500, 500+ |
| `icp_fit_score` | Number (1-10) | How well contact matches ICP | Based on revenue + tech + size + geo |
| `campaign_name` | Text | Which campaign generated this lead | gulf_saas_q1_2026, us_realestate_feb |
| `meeting_date` | Date | Scheduled meeting date | 2026-02-25T10:00:00Z |
| `deal_size` | Number | Estimated deal value in USD | 25000, 100000 |
| `loss_reason` | Text | Why deal was lost (if applicable) | budget, timing, competitor, no_response |

### Reading Custom Fields
Custom fields come back in the contact object under `customFields` or as top-level fields depending on how they were created. When reading a contact, check both locations.

### Writing Custom Fields
Use `mcp__ghl-mcp__update_contact` with the `customField` parameter. Field names must match exactly (case-sensitive, snake_case).

---

## Bulk Operations

### Safety Rules for Bulk
1. **Always chunk** — Max 20 contacts per batch
2. **Pace between batches** — 2-second delay between batches (well within 100/10sec limit but safe)
3. **Track progress** — Log which contacts were processed
4. **Dedup every contact** — Search by email before creating, even in bulk
5. **Dry run first** — For >100 contacts, do a dry run on the first 5 to verify field mapping

### Bulk Creation Pattern
```python
for batch in chunks(contacts, size=20):
    for contact in batch:
        # Step 1: Dedup check
        existing = search_contacts(email=contact.email)
        if existing:
            update_contact(existing.id, new_data)
        else:
            create_contact(contact)
    # Pause between batches
    wait(2_seconds)
```

### Bulk Tagging Pattern
```python
for batch in chunks(contact_ids, size=20):
    for contact_id in batch:
        add_contact_tags(contact_id, tags)
    wait(2_seconds)
```

---

## Cross-Platform Matching

Contacts flow in from multiple sources. Matching them correctly prevents duplicates and ensures signal data converges.

### Matching Keys (Priority Order)
1. **Email** — Most reliable. Same email = same person.
2. **LinkedIn URL** — Stored in `linkedin_url` custom field. Match contacts from HeyReach to GHL.
3. **Phone** — E.164 format. Same phone = likely same person (verify name).
4. **Company + Name** — Weakest match. Use only as a hint, not a definitive match.

### Cross-Platform Flow
```
Instantly → email is the key → search GHL by email
HeyReach → linkedin_url is the key → search GHL by linkedin_url custom field
Clay → email is the key → search GHL by email, update enrichment fields
Website → email from form → search GHL by email
```

### When Match is Ambiguous
If a contact exists but some fields conflict (different phone, slightly different name):
1. Don't auto-merge
2. Add note: "Potential duplicate found — email matches [ID] but phone differs. Manual review needed."
3. Tag as `status:needs_review`
4. Present both records to user for decision
