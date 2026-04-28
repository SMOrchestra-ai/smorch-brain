# Campaign Launch Checklist

Step-by-step workflow for launching a multi-channel outbound campaign.

## Table of Contents
1. Pre-Launch Requirements
2. Phase 1: GHL Contact Setup
3. Phase 2: Instantly Email Campaign
4. Phase 3: HeyReach LinkedIn Campaign
5. Phase 4: Webhook & Automation Setup
6. Phase 5: Cross-Channel Verification
7. Post-Launch Monitoring
8. Campaign Brief Output Template

---

## Pre-Launch Requirements

Before starting campaign setup, verify ALL of these:

### Data Requirements
- [ ] Lead list with emails (for Instantly)
- [ ] Lead list with LinkedIn URLs (for HeyReach) — normalized format: `https://www.linkedin.com/in/username/`
- [ ] Lead data: first_name, last_name, company, position (minimum)
- [ ] Phone numbers if WhatsApp channel planned (MENA campaigns)
- [ ] Location/timezone data for scheduling

### Content Requirements
- [ ] Email sequence (3-4 steps) — from signal-to-trust-gtm or asset-factory
- [ ] LinkedIn connection note (if Pattern A/C) — <300 chars, no links
- [ ] LinkedIn messages (2-3 follow-ups) — conversational, value-first
- [ ] WhatsApp template (if Pattern C) — Arabic + English variants
- [ ] Campaign wedge defined (single sentence value prop)

### Infrastructure Requirements
- [ ] Instantly accounts active and warmed (check warmup ≥95%)
- [ ] HeyReach sender accounts active (check via `get_all_linked_in_accounts`)
- [ ] GHL pipeline exists for this campaign's opportunities
- [ ] n8n webhook endpoints active and tested
- [ ] Campaign naming convention agreed: `[ICP] - [Wedge] - [Month]`

### Capacity Check
- [ ] Instantly: Calculate daily volume = (num_accounts × daily_limit_per_account)
  - Leads ÷ daily_volume = days to complete
  - If >14 days → either add accounts or reduce list
- [ ] HeyReach: Calculate daily volume = (num_senders × daily_connection_limit)
  - Same calculation, same 14-day max guideline
- [ ] Total leads manageable for response handling team

---

## Phase 1: GHL Contact Setup

GHL is the source of truth. Set up contacts FIRST, before any channel enrollment.

### Step 1.1: Create/Update GHL Contacts

For each lead in the list:

```
Use ghl-operator contact creation:

Required fields:
- email
- firstName, lastName
- companyName
- phone (if available)

Custom fields:
- linkedin_url: [normalized URL]
- signal_score: 0
- last_touch_date: null
- last_touch_channel: null
- active_channels: "" (will be populated during enrollment)
- paused_channels: ""
- opted_out_channels: ""
- campaign_source: [campaign_name]

Tags:
- campaign:[campaign-name]
- icp:[icp-segment]
- geo:[market]  (mena, us, eu)
- status:new
```

### Step 1.2: Deduplication Check

Before creating contacts:
1. Search GHL for each email — avoid duplicates
2. If contact exists: update with new data, add campaign tag
3. If contact exists AND in active campaign: FLAG — need manual decision
4. Log: "X new contacts created, Y existing updated, Z conflicts flagged"

### Step 1.3: Pipeline Preparation

```
Ensure GHL pipeline exists with stages:
1. New Lead
2. Contacted (first touch sent)
3. Engaged (signal detected)
4. Replied
5. Meeting Booked
6. Qualified
7. Proposal Sent
8. Won / Lost
```

---

## Phase 2: Instantly Email Campaign

### Step 2.1: Create Lead List in Instantly

```
Use instantly-operator:
- create_lead_list: name = "[ICP] - [Wedge] - [Month] Email Leads"
- add_leads_to_campaign_or_list_bulk:
  - email, first_name, last_name, company_name, custom variables
  - skip_if_in_campaign: true
```

### Step 2.2: Create Email Campaign

```
Use instantly-operator:
- create_campaign:
  - name: "[ICP] - [Wedge] - [Month] Email [Variant]"
  - sequences: 3-4 step email sequence with delays
  - schedule: market-appropriate timezone and days
    - MENA: Sun-Thu, 08:00-16:00, Asia/Dubai
    - US: Mon-Fri, 09:00-17:00, America/Chicago (or local)
  - email_list: assign sending accounts (rotate across domains)
  - daily_limit: conservative start (15-25 per account)
  - link_tracking: true (for signal detection)
  - open_tracking: true
```

### Step 2.3: Account Assignment

```
Distribute sending accounts:
- MENA campaigns: prioritize smorchestra.com accounts
- US campaigns: mix across .com, .io, .tech
- Never assign >40% of volume to single account
- Verify warmup score ≥95% for each assigned account
```

### Step 2.4: Do NOT Activate Yet

Campaign stays in draft until Phase 5 verification is complete.

---

## Phase 3: HeyReach LinkedIn Campaign

### Step 3.1: Create Lead List in HeyReach

```
Use heyreach-operator:
- create_empty_list: name = "[ICP] - [Wedge] - [Month] LinkedIn Leads"
  - listType: USER_LIST
- add_leads_to_list_v2: batch of 100 max per call
  - Required: profileUrl (normalized)
  - Recommended: firstName, lastName, companyName, position, emailAddress
```

### Step 3.2: Create/Select LinkedIn Campaign

HeyReach campaigns are typically pre-configured in the UI with sequence steps.

```
Verify:
- Campaign exists with correct sequence steps
- Sender accounts assigned and active
- Daily limits set conservatively (20-30 connections/day)
- Schedule: MENA Sun-Thu / US Mon-Fri, business hours
```

### Step 3.3: Enroll Leads

```
Use heyreach-operator:
- add_leads_to_campaign_v2:
  - campaignId: [campaign ID]
  - accountLeadPairs: map leads to sender accounts
    - Geographic matching: MENA senders → MENA leads
    - Even distribution across senders
  - Batch: max 100 per API call
```

### Step 3.4: Webhook Setup

```
Use heyreach-operator:
- create_webhook for each critical event:
  1. CONNECTION_REQUEST_ACCEPTED → n8n signal endpoint
  2. MESSAGE_REPLY_RECEIVED → n8n signal endpoint
  3. INMAIL_REPLY_RECEIVED → n8n signal endpoint
  4. LEAD_FINISHED_SEQUENCE_WITHOUT_REPLYING → n8n nurture endpoint
  5. VIEWED_PROFILE → n8n signal endpoint (optional, high volume)

Webhook URL: https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-signal
Scope: campaign-specific (pass campaignIds array)
Naming: "hr-[event-short]-[campaign-short]" (max 25 chars)
```

---

## Phase 4: Webhook & Automation Setup

### Step 4.1: n8n Workflow Verification

Verify these n8n workflows are active:

| Workflow | Purpose | Webhook URL |
|----------|---------|-------------|
| Signal Scorer | Receives signals, updates GHL scores | /webhook/heyreach-signal |
| Reply Handler | Detects replies, pauses all channels | /webhook/instantly-signal |
| WhatsApp Trigger | Fires WhatsApp on warm signal | Internal GHL trigger |
| Slack Alerter | Notifies team on hot signals | Internal n8n trigger |

### Step 4.2: Cross-Channel Signal Flow

```
Instantly email open/reply → Instantly webhook → n8n → GHL score update
HeyReach connection/reply → HeyReach webhook → n8n → GHL score update
GHL WhatsApp reply → GHL native → GHL score update (direct)
Any score ≥7 → n8n → Create GHL opportunity + Slack alert
Any reply → n8n → Pause other channels (Instantly + HeyReach)
```

### Step 4.3: GHL Automation Triggers

Set up GHL workflow triggers:
- Tag `signal:warm` added → Trigger WhatsApp sequence (if phone exists + MENA)
- Tag `signal:hot` added → Create opportunity, assign to sales
- Tag `status:replied` added → Remove from all automated workflows

---

## Phase 5: Cross-Channel Verification

Before activating any campaign, verify:

### Timing Alignment
- [ ] Email sequence Day 0 matches intended first-touch date
- [ ] LinkedIn sequence starts on correct day per pattern (same day or +1/+2)
- [ ] WhatsApp only triggers AFTER signal, never as first touch
- [ ] No channel fires on the same day for the same lead (check pattern timing)

### Data Integrity
- [ ] All Instantly leads have valid emails (no bounced domains)
- [ ] All HeyReach leads have normalized LinkedIn URLs
- [ ] GHL contacts exist for ALL leads in both channel campaigns
- [ ] GHL custom fields populated: linkedin_url, campaign_source, active_channels
- [ ] Tags consistent across platforms: campaign:{name}

### Dedup Verification
- [ ] No lead appears in multiple active campaigns on same channel
- [ ] Run `scripts/cross-channel-audit.py` for conflict detection
- [ ] Review flagged conflicts, resolve before launch

### Activation Sequence

After ALL verifications pass:

1. **Activate Instantly campaign** (email starts first in Pattern A, or simultaneously in Pattern C)
2. **Resume/Start HeyReach campaign** (per pattern timing)
3. **Update GHL contacts**: active_channels = "email,linkedin"
4. **Log**: Campaign launch timestamp, all campaign IDs, lead count
5. **Set monitoring alert**: Check performance after 24hrs, 48hrs, and 1 week

---

## Post-Launch Monitoring

### First 24 Hours
- Check Instantly: Any bounces? Open rate trending?
- Check HeyReach: Connection requests sending? Any account warnings?
- Check GHL: Contacts updating? Tags applying?
- Check n8n: Webhooks firing? Signal scores updating?

### First 48 Hours
- Review first signals: Any opens? Views? Connections?
- Check collision prevention: Any leads touched on wrong day?
- Verify WhatsApp triggers: Firing only on signal, not prematurely?

### First Week
- Pull cross-channel analytics (Mode D)
- Compare channel performance against benchmarks
- Identify any pattern adjustments needed
- Check: Are compound signals being detected?

---

## Campaign Brief Output Template

After completing all phases, produce this deliverable:

```markdown
# Multi-Channel Campaign Brief

## Campaign Overview
- **Name:** [ICP] - [Wedge] - [Month]
- **Pattern:** [A/B/C/D]
- **Market:** [MENA/US/EU]
- **Launch Date:** [date]
- **Duration:** [X days]

## Lead Summary
- **Total Leads:** X
- **Email-only:** X | **LinkedIn-only:** X | **Multi-channel:** X
- **GHL Contacts Created:** X | **Updated:** X | **Conflicts:** X

## Channel Campaigns
| Channel | Platform | Campaign ID | Leads Enrolled | Daily Volume |
|---------|----------|-------------|---------------|-------------|
| Email | Instantly | [uuid] | X | X/day |
| LinkedIn | HeyReach | [id] | X | X/day |
| WhatsApp | GHL | Auto-trigger | On signal | — |

## Sequence Timing
[Paste channel × day matrix from pattern]

## Webhooks Active
| Event | Webhook | Status |
|-------|---------|--------|
| CONNECTION_ACCEPTED | hr-conn-[campaign] | Active |
| MESSAGE_REPLY | hr-reply-[campaign] | Active |
| [etc] | | |

## Monitoring Schedule
- 24hr check: [date]
- 48hr check: [date]
- Week 1 review: [date]

## Tags Applied
- campaign:[name]
- icp:[segment]
- geo:[market]
- channel:email, channel:linkedin
```

→ Save as `assets/campaign-brief-template.md` for reuse.
