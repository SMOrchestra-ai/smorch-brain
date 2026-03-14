# Collision Prevention Protocol

## Table of Contents
1. Core Rules
2. Pre-Action Check Sequence
3. Cross-Channel Deduplication
4. Reply Handling (The Most Critical Protocol)
5. Opt-Out Propagation
6. Daily Touch Tracking
7. Company-Level Throttling
8. Edge Cases

---

## Core Rules

These are non-negotiable. Every outbound action must respect them.

| # | Rule | Rationale |
|---|------|-----------|
| 1 | Max 1 outbound touch per channel per day per lead | Avoid spam feeling |
| 2 | Max 2 touches per lead per day across ALL channels | Even staggered, too many = stalker |
| 3 | Reply on any channel → pause ALL other channels immediately | Worst outcome: cold email to someone in warm WhatsApp convo |
| 4 | 24-hour minimum gap before activating second channel | Simultaneous multi-channel feels automated |
| 5 | Respect timezone — never send outside business hours | MENA: Sun-Thu 08:00-17:00 Gulf | US: Mon-Fri 09:00-17:00 local |
| 6 | WhatsApp: NEVER outside business hours, NEVER as first touch | WhatsApp is personal — earn the right |
| 7 | Opt-out on one channel → respect across ALL channels | Legal and ethical requirement |
| 8 | Max 2 touches per company per day (enterprise/ABM) | Company-level throttle for multi-thread |

---

## Pre-Action Check Sequence

Before executing ANY outbound action (email send, LinkedIn message, WhatsApp), run this check:

```
FUNCTION: can_touch_lead(lead_id, channel, action_type)

1. CHECK: Is lead opted out of this channel?
   → GHL custom field: opted_out_channels
   → If channel in opted_out → BLOCK, reason: "opted out"

2. CHECK: Is lead opted out of ALL channels?
   → GHL tag: status:opted_out
   → If tagged → BLOCK, reason: "global opt-out"

3. CHECK: Has lead replied on ANY channel in last 48 hours?
   → GHL custom field: last_reply_date
   → If <48hrs → BLOCK, reason: "active conversation — do not interrupt"

4. CHECK: Was lead touched on THIS channel today?
   → GHL custom field: last_touch_date, last_touch_channel
   → If same channel + same day → BLOCK, reason: "already touched today on this channel"

5. CHECK: Total touches today across ALL channels?
   → Count today's touches from GHL notes
   → If ≥2 → BLOCK, reason: "daily touch limit reached"

6. CHECK: Was another channel activated in last 24 hours?
   → GHL custom field: last_touch_date
   → If <24hrs AND different channel → BLOCK, reason: "24hr channel gap not met"

7. CHECK: Company-level throttle (if ABM/enterprise)
   → Count touches to ALL contacts at same company today
   → If ≥2 → BLOCK, reason: "company daily limit reached"

8. CHECK: Is this within business hours for lead's timezone?
   → GHL custom field: timezone or derive from location
   → If outside hours → QUEUE for next business hour

ALL CHECKS PASS → PROCEED with action
```

### Implementation Notes

- Checks 1-7 are blocking — action must not proceed
- Check 8 is queuing — action proceeds but is scheduled
- Every check failure should be logged: `[timestamp] COLLISION_PREVENTED: [lead] [channel] [reason]`
- The GHL contact is the single source of truth for all touch tracking

---

## Cross-Channel Deduplication

### Matching Leads Across Platforms

| Platform | Primary Key | Secondary Key |
|----------|------------|---------------|
| Instantly | email | — |
| HeyReach | linkedin_url | email (if enriched) |
| GHL | email | phone, linkedin_url (custom fields) |

**Matching Priority:**
1. Email match (exact) — most reliable
2. LinkedIn URL match (normalized) — `https://www.linkedin.com/in/username/`
3. Name + Company match — fuzzy, use as last resort only with manual review

**Normalization Rules:**
- Email: lowercase, trim whitespace
- LinkedIn URL: lowercase, strip query params, ensure trailing slash, ensure www
- Company: lowercase, strip Inc/LLC/Ltd suffixes for matching

### Pre-Enrollment Dedup

Before enrolling a lead in ANY new campaign:

```
1. Search GHL contacts by email
   → If found: Check active_channels field
   → If lead already in same-channel campaign → BLOCK enrollment
   → If lead in different-channel campaign → OK (orchestrator manages timing)

2. Check Instantly campaigns for this email
   → Use search_campaigns_by_contact or list_leads with email filter
   → If in active campaign on same channel → BLOCK

3. Check HeyReach campaigns for this LinkedIn URL
   → Use get_campaigns_for_lead with profileUrl
   → If in active campaign → BLOCK

4. All clear → Proceed with enrollment
   → Update GHL active_channels field
   → Add GHL note: "[timestamp] ENROLLED: [campaign_name] [channel]"
```

### Cross-Platform Sync on Enrollment

When enrolling a lead in a multi-channel campaign:

1. **GHL is always first** — Create/update GHL contact before any channel enrollment
2. **GHL gets ALL data** — Even if only using email channel, store LinkedIn URL in GHL
3. **Tag consistently** — `campaign:{name}` tag in GHL, HeyReach, and Instantly (where supported)
4. **Populate cross-references** — GHL custom fields: instantly_campaign_id, heyreach_campaign_id

---

## Reply Handling (The Most Critical Protocol)

When a lead replies on ANY channel, this is the highest-priority event.

### Immediate Actions (within seconds via n8n automation)

```
TRIGGER: Lead replies on [channel]

1. UPDATE GHL:
   - Tag: signal:hot (or signal:replied)
   - Custom field: last_reply_date = now()
   - Custom field: last_reply_channel = [channel]
   - Custom field: signal_score += 8
   - Note: "[timestamp] REPLY: [channel] — pausing all sequences"

2. PAUSE INSTANTLY:
   - If lead is in active Instantly campaign:
     → Move lead to "paused" or remove from active sequence
     → Do NOT delete — preserve history

3. PAUSE HEYREACH:
   - If lead is in active HeyReach campaign:
     → stop_lead_in_campaign(campaignId, leadMemberId, leadUrl)
     → Add tag: status:replied

4. PAUSE GHL AUTOMATIONS:
   - If lead is in GHL workflow/automation:
     → Remove from active workflow
     → Tag: status:in_conversation

5. CREATE OPPORTUNITY:
   - If no opportunity exists for this lead:
     → Create in GHL pipeline
     → Stage: "Replied" or "Engaged"
     → Source: [channel]

6. ALERT:
   - Webhook to Slack/team channel
   - Include: lead name, company, channel, reply content preview
```

### What NOT To Do on Reply

- NEVER auto-reply. Human takes over.
- NEVER send a different channel message ("saw your LinkedIn reply, emailing too")
- NEVER continue any automated sequence
- NEVER update the lead's campaign status in other channels to "completed" — they are PAUSED, not done

### Negative Reply Handling

If the reply is negative ("not interested", "remove me", "stop"):
1. All immediate actions above PLUS
2. Tag: status:not_interested
3. Remove from ALL active campaigns across all channels
4. Add to suppression list in Instantly
5. Do NOT re-enroll for minimum 90 days
6. If explicitly requests removal from all communication → permanent suppression

---

## Opt-Out Propagation

### Opt-Out Sources
| Source | Detection |
|--------|----------|
| Email unsubscribe | Instantly webhook |
| Email "remove me" reply | Instantly inbox + manual flag |
| LinkedIn "not interested" | HeyReach conversation |
| WhatsApp block | GHL webhook |
| Verbal request (call/meeting) | Manual entry in GHL |
| Legal/compliance request | Manual entry, highest priority |

### Propagation Protocol

```
TRIGGER: Opt-out detected on [channel]

1. GHL: Tag opted_out_channels += [channel]
2. GHL: Note "[timestamp] OPT-OUT: [channel] — [reason]"

IF channel-specific opt-out:
  - Remove from campaigns on THAT channel only
  - Other channels continue IF lead hasn't explicitly asked for full removal
  - Monitor: if lead opts out of 2+ channels → upgrade to full opt-out

IF full opt-out (explicit "stop all contact"):
  - GHL: Tag status:opted_out
  - Instantly: Add to global suppression list
  - HeyReach: Stop in all campaigns, tag status:opted_out
  - GHL: Remove from all automations
  - PERMANENT: Do not re-enroll ever unless lead re-initiates contact
```

---

## Daily Touch Tracking

### GHL Custom Fields for Tracking

| Field | Type | Purpose |
|-------|------|---------|
| `last_touch_date` | DateTime | Most recent outbound touch timestamp |
| `last_touch_channel` | Text | Channel of most recent touch |
| `last_reply_date` | DateTime | Most recent reply timestamp |
| `last_reply_channel` | Text | Channel of most recent reply |
| `touches_today` | Number | Running count, reset daily |
| `active_channels` | Text | Comma-separated: "email,linkedin,whatsapp" |
| `paused_channels` | Text | Comma-separated channels on hold |
| `opted_out_channels` | Text | Comma-separated opted-out channels |
| `signal_score` | Number | Aggregate signal score |

### Touch Log Format (GHL Notes)

Every outbound action appends to GHL notes:
```
[2026-02-22 09:15 UTC] TOUCH: email_sent | Campaign: MENA-SaaS-Feb-Email | Step: 1
[2026-02-22 10:30 UTC] TOUCH: linkedin_connection_request | Campaign: MENA-SaaS-Feb-LinkedIn
[2026-02-23 08:45 UTC] SIGNAL: email_opened | Score: +1 | Aggregate: 1
[2026-02-23 14:00 UTC] SIGNAL: linkedin_connection_accepted | Score: +3 | Compound: +2 | Aggregate: 6
[2026-02-23 14:00 UTC] ROUTING: Score 6 → WARM | Activate WhatsApp channel
```

---

## Company-Level Throttling

For ABM campaigns (Pattern D), throttle at the company level:

### Rules
1. Max 2 touches per company per day
2. Space contacts: if touching CTO and VP Sales, gap by 4+ hours
3. If one contact at a company replies → flag entire account as engaged
4. If one contact opts out → do NOT stop others unless they share the opt-out context

### Implementation
- Group leads by company domain in GHL
- Before touching any lead: count today's touches to other contacts at same company
- Use GHL search by company name to find related contacts
- Track company-level engagement in GHL opportunity notes

---

## Edge Cases

### Lead exists in multiple campaigns (same channel)
→ BLOCK. A lead should never be in two active campaigns on the same channel.
→ If discovered during audit: keep the newer campaign, remove from older.

### Lead data incomplete (email but no LinkedIn, or vice versa)
→ Single-channel only. Tag: `channel:email_only` or `channel:linkedin_only`
→ Attempt enrichment to find missing data before next campaign

### Lead replies on a channel they're not enrolled in
Example: Lead gets email via Instantly, but replies via LinkedIn DM
→ Treat as a reply. Pause all channels. The channel doesn't matter — the signal does.

### Lead changes companies mid-sequence
→ If detected (LinkedIn update, email bounce at old domain):
→ Pause all sequences
→ Update GHL contact with new company
→ Evaluate: is new company still ICP fit? If yes, new campaign. If no, archive.

### Timezone ambiguity
→ Default to lead's location field in GHL
→ If unknown: MENA names/companies → Gulf Time (UTC+4)
→ If truly unknown: default to sender's timezone, conservative hours (10:00-15:00)
