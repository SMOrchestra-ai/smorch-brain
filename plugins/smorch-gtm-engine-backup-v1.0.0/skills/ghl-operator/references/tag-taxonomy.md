# Tag Taxonomy Reference

## Table of Contents
1. [Tag Architecture](#tag-architecture)
2. [Signal Tags](#signal-tags)
3. [Source Tags](#source-tags)
4. [ICP Tags](#icp-tags)
5. [Channel Tags](#channel-tags)
6. [Status Tags](#status-tags)
7. [Campaign Tags](#campaign-tags)
8. [Tag Automation Triggers](#tag-automation-triggers)
9. [Tag Lifecycle Rules](#tag-lifecycle-rules)

---

## Tag Architecture

Tags in GHL/SalesMfast follow the `{category}:{value}` naming convention. This is critical for consistency across GHL, Instantly, HeyReach, and n8n workflows.

### Category Hierarchy
```
signal:    → Engagement/intent level (hot, warm, cold)
source:    → Where the contact came from
icp:       → Which ideal customer profile they match
channel:   → Which communication channels are available
status:    → Current lifecycle status
campaign:  → Which campaign generated them
enrichment: → Enrichment-related flags
```

### MCP Tools for Tags
```
Add tags:    mcp__ghl-mcp__add_contact_tags
Remove tags: mcp__ghl-mcp__remove_contact_tags
```

Tags are passed as arrays: `["signal:hot", "source:instantly", "icp:mena_saas"]`

---

## Signal Tags

Signal tags represent the contact's current engagement/intent level. These are the most important tags because they drive routing, nurture sequences, and pipeline movement.

| Tag | Meaning | Criteria | GHL Workflow Trigger |
|-----|---------|----------|---------------------|
| `signal:hot` | High intent, ready for direct outreach | Signal score >= 7, or replied with clear interest | Immediate WhatsApp/SMS + Slack alert + move to Qualified |
| `signal:warm` | Some engagement, needs nurturing | Signal score 4-6, opened/clicked but no reply | Add to nurture sequence (email + periodic WhatsApp) |
| `signal:cold` | Low/no engagement | Signal score <= 3, or >90 days since last signal | Remove from active sequences, add to monthly re-score batch |
| `signal:meeting_booked` | Meeting confirmed | Calendar appointment created | Move to "Meeting Booked" pipeline stage |
| `signal:no_show` | Missed scheduled meeting | Meeting time passed, no attendance | Trigger re-engagement sequence (WhatsApp follow-up) |
| `signal:replied` | Contact replied to any channel | Any inbound message detected | Re-score based on sentiment, upgrade signal if warranted |

### Signal Tag Rules
- **Mutually exclusive for levels:** A contact should only have ONE of `signal:hot`, `signal:warm`, `signal:cold` at a time. When upgrading, remove the old level before adding the new one.
- **Additive for events:** `signal:replied`, `signal:meeting_booked`, `signal:no_show` can coexist with level tags.
- **Never remove signal:replied** — it's a permanent audit marker.

---

## Source Tags

Source tags track where the contact originated. They are permanent — never removed — because a contact can have multiple sources over time.

| Tag | Meaning | When Applied |
|-----|---------|-------------|
| `source:instantly` | Came from cold email campaign | n8n workflow detects Instantly reply/engagement |
| `source:heyreach` | Came from LinkedIn outreach | n8n workflow detects HeyReach connection/reply |
| `source:website` | Came from website form | GHL form submission webhook |
| `source:clay` | Enriched via Clay | n8n workflow after Clay enrichment |
| `source:referral` | Warm referral | Manual tag on referred contacts |
| `source:event` | Met at conference/event | Manual tag |
| `source:inbound` | Inbound inquiry (non-form) | Manual tag for direct emails/calls |
| `source:manual` | Manually added | Default for manually created contacts |

### Multi-Source Contacts
A contact tagged `source:instantly` + `source:clay` means they were first contacted via cold email and later enriched via Clay. This is normal and expected — source tags accumulate.

---

## ICP Tags

ICP (Ideal Customer Profile) tags route contacts to the correct pipeline and determine messaging approach.

| Tag | Pipeline | Market | Deal Size Range |
|-----|----------|--------|-----------------|
| `icp:mena_saas` | MENA SaaS Pipeline | UAE, KSA, Qatar, Kuwait | $25K-$100K |
| `icp:us_realestate` | US Real Estate Pipeline | United States | $5K-$20K |
| `icp:mena_sme` | MENA SME Pipeline | UAE, KSA | $2K-$10K |
| `icp:cxmfast` | CXMfast Pipeline | MENA + Global | $50K-$500K |
| `icp:beauty_clinic` | Beauty Clinics Pipeline | UAE, KSA | $3K-$15K |
| `icp:unclassified` | No pipeline assignment | Any | Unknown |

### ICP Assignment Logic
ICP tags should be assigned based on enrichment data (company revenue, industry, size, geography):

```python
def assign_icp(contact):
    if contact.country in ['UAE', 'KSA', 'Qatar', 'Kuwait']:
        if contact.industry == 'SaaS' and contact.company_size > 50:
            return 'icp:mena_saas'
        elif contact.industry in ['Beauty', 'Wellness', 'Salon']:
            return 'icp:beauty_clinic'
        elif contact.company_size < 50:
            return 'icp:mena_sme'
    elif contact.country == 'US':
        if contact.industry == 'Real Estate':
            return 'icp:us_realestate'
    if contact.industry in ['Contact Center', 'BPO', 'Customer Service']:
        return 'icp:cxmfast'
    return 'icp:unclassified'
```

---

## Channel Tags

Channel tags indicate which communication channels are available for this contact.

| Tag | Meaning | Auto-Applied When |
|-----|---------|------------------|
| `channel:whatsapp` | Has WhatsApp-enabled phone | Phone matches MENA prefix (+971/+966/+974/+965) |
| `channel:sms` | Has SMS-capable phone | Phone matches US prefix (+1) |
| `channel:email` | Has verified email | Email field populated and not bounced |
| `channel:linkedin` | Has LinkedIn profile | linkedin_url custom field populated |
| `channel:phone` | Accepts phone calls | Phone field populated + tag not `channel:no_call` |

### Channel Preference Tags
| Tag | Meaning | Source |
|-----|---------|--------|
| `channel_pref:whatsapp` | Prefers WhatsApp | Contact requested or consistently responds via WA |
| `channel_pref:email` | Prefers email | Contact requested or ignores WA/SMS |
| `channel_pref:phone` | Prefers calls | Contact requested |

---

## Status Tags

Status tags track the contact's lifecycle position.

| Tag | Meaning | When Applied |
|-----|---------|-------------|
| `status:new` | Just created, not yet engaged | Contact creation |
| `status:engaged` | Has interacted at least once | First signal detected |
| `status:meeting_booked` | Meeting scheduled | Appointment created |
| `status:proposal_sent` | Proposal delivered | Proposal email sent |
| `status:negotiating` | In active negotiation | Manual move |
| `status:closed_won` | Deal closed successfully | Manual confirmation |
| `status:closed_lost` | Deal lost | Manual with loss reason |
| `status:nurture` | In long-term nurture | Not ready now, check later |
| `status:dormant` | No activity >90 days | Automated based on last_signal_date |
| `status:disqualified` | Doesn't fit ICP | Manual disqualification |
| `status:duplicate` | Duplicate record | Merge process |
| `status:needs_review` | Data conflict, needs human check | Dedup found ambiguous match |
| `status:do_not_contact` | Opted out or requested no contact | Manual or automated opt-out |

---

## Campaign Tags

Campaign tags link contacts to specific outbound campaigns for attribution.

### Naming Convention
`campaign:{campaign_slug}`

Examples:
- `campaign:gulf_saas_q1_2026`
- `campaign:us_realestate_feb_2026`
- `campaign:mena_beauty_launch`
- `campaign:cxmfast_enterprise_q1`

Campaign tags are permanent — they track which campaigns have touched this contact over time.

---

## Tag Automation Triggers

These tags trigger GHL workflows when added:

| Tag Added | GHL Workflow Triggered | What Happens |
|-----------|----------------------|-------------|
| `signal:hot` | Hot Lead Alert | WhatsApp/SMS follow-up + Slack notification + pipeline move to Qualified |
| `signal:warm` | Warm Nurture Enrollment | Add to email nurture sequence |
| `signal:cold` | Cold Lead Processing | Remove from active sequences, add to monthly re-score |
| `signal:meeting_booked` | Meeting Prep | Send calendar confirmation + prep materials |
| `signal:no_show` | No-Show Recovery | WhatsApp follow-up + reschedule offer |
| `status:closed_won` | Win Celebration | Remove from outbound, add to client nurture, Slack celebration |
| `status:closed_lost` | Loss Processing | Capture loss reason, add to 90-day re-engagement pool |
| `status:do_not_contact` | DNC Processing | Remove from ALL sequences immediately |

---

## Tag Lifecycle Rules

### Adding Tags
1. Always use the `{category}:{value}` format
2. Multiple tags can be added in a single API call
3. Adding an existing tag is a no-op (safe to re-add)
4. Log tag additions in contact notes for audit trail

### Removing Tags
1. Only remove when explicitly reclassifying
2. When changing signal levels: remove old level, then add new level
3. Source tags are NEVER removed
4. Campaign tags are NEVER removed
5. Log tag removals in contact notes

### Tag Cleanup Protocol
Periodically audit tags for:
- Contacts with conflicting signal tags (both hot and cold)
- Contacts with no signal tag at all
- Contacts with `icp:unclassified` that have enrichment data (should be classifiable)
- Contacts with `status:dormant` that have recent signals (status needs updating)
