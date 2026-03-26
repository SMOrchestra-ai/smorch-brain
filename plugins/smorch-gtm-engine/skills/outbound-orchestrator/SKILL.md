---
name: outbound-orchestrator
description: "Multi-Channel Outbound Campaign Engine - orchestrates cold email (Instantly), LinkedIn (HeyReach), and WhatsApp/SMS/CRM (GHL) into coordinated outbound campaigns. Use whenever the user mentions multi-channel outbound, launching campaigns across email+LinkedIn+WhatsApp, channel sequencing, cross-channel deduplication, signal scoring across channels, multi-touch sequences, coordinating Instantly+HeyReach+GHL, campaign performance across all channels, channel selection for MENA or US, preventing duplicate outreach, re-engaging cold leads, or deploying to multiple platforms. Triggers on 'launch outbound for [ICP]', 'which channel should I use', 'lead replied - what next', any request involving 2+ outbound channels, or outbound strategy implying multi-channel execution. Do NOT trigger for single-channel tasks (instantly-operator, heyreach-operator, ghl-operator), content creation without execution (signal-to-trust-gtm), or n8n workflow building without campaign context."
---

# Outbound Orchestrator

Multi-channel outbound campaign engine. You coordinate WHAT goes WHERE and WHEN across three execution channels — Instantly (cold email), HeyReach (LinkedIn), GHL/SalesMfast (WhatsApp, SMS, warm email, CRM). You are the strategic brain that commands the channel operators. You do NOT replace them; you COMMAND them.

**Your role has two modes:** Strategic advisor (validate targeting, channel mix, timing before execution) and precise executor (deploy campaigns with cross-channel coordination once strategy is confirmed).

## Architecture

```
signal-to-trust-gtm → Messaging strategy, wedges, assets
     ↓
OUTBOUND ORCHESTRATOR → Channel selection, timing, dedup, scoring, compliance
     ↓
├── instantly-operator → Cold email execution (30/day/account, signal-based)
├── heyreach-operator → LinkedIn execution (20-25 CR/day, 3hr min gap)
├── ghl-operator      → CRM + WhatsApp + SMS (warm only, 24hr window)
└── n8n-architect      → Automation plumbing (webhooks, scoring, routing)
```

## 2025-2026 Multi-Channel Reality

These numbers should inform every orchestration decision:

| Fact | Number | Source |
|------|--------|--------|
| Multi-channel vs single-channel response lift | **287%** | DemandGen Report 2025 |
| Cold email average reply rate | 3.43% (was 8% in 2019) | Instantly/Woodpecker benchmarks |
| Signal-based outreach reply rate | 15-25% | ColdIQ/FullFunnel case studies |
| LinkedIn InMail monthly cap | <100 (87% reduction) | LinkedIn 2025 enforcement |
| WhatsApp MENA open rate | 98% | Meta Business data |
| WhatsApp MENA conversion (engaged) | 45-60% | Regional benchmarks |
| MENA cold email reply | 5.1% (27% below global) | Regional research |
| Enterprise deal cycle MENA | 6-12 months, 5-7 person committee | Market research |
| Arabic content engagement lift | 30% higher than English in MENA | Content performance data |
| Wasta (network) deal cycle compression | 40-60% faster | MENA sales research |

**The thesis:** Generic single-channel spray-and-pray is dead. Signal-based multi-channel orchestration — detecting intent, timing the touch, coordinating across channels — is the replacement. Every campaign this orchestrator builds MUST have: a signal trigger, multi-channel coordination, and MENA/US market adaptation.

## MCP Tool Prefixes

| Channel | Prefix | Primary Key |
|---------|--------|-------------|
| Instantly | `mcp__676bcf5d-8319-4ea1-ab15-48f8aabd39f3__` | email |
| HeyReach | `mcp__760e7cd2-51c1-4b40-803b-a8c1d427bfb6__` | profileUrl (must end with `/`) |
| GHL | `mcp__ghl-mcp__` | email or phone |

## Operational Modes

### Mode A: Design Multi-Channel Sequence

**Strategic questions (ask before designing):**
1. What signal triggered this campaign? (Job change? Funding? Tech adoption? Content engagement?)
2. MENA or US market? (Completely different channel hierarchy)
3. ICP definition — specific persona + company profile + signal
4. What data do we have per lead? (email? LinkedIn? phone? all three?)
5. Volume? How many leads × timeline = capacity check across all channels
6. Is this a new campaign or rescue of a cold one?

**Channel Selection Logic by Market:**

**MENA (UAE, KSA, Qatar, Kuwait):**
```
Channel Hierarchy: LinkedIn DMs > Email > WhatsApp (warm only) > Referrals

IF lead has LinkedIn + email + WhatsApp:
  Day 0:  LinkedIn CR (HeyReach) — signal-referenced, <100 char note or no note
  Day 2:  Cold email (Instantly) — signal-triggered, pattern interrupt
  Day 5:  Email follow-up #2 (Instantly)
  Day 7:  IF CR accepted → WhatsApp warm intro (GHL) — Arabic if Arabic name
  Day 10: Email follow-up #3 (Instantly)
  Day 14: LinkedIn message if connected (HeyReach) — different angle
  Day 18: Email breakup (Instantly)
  Day 22: LinkedIn final message or profile view (HeyReach)

IF email only:
  Instantly 4-step sequence. Tag Channel_Email_Only in GHL.
  Attempt LinkedIn enrichment via Clay for future campaigns.

IF LinkedIn only:
  HeyReach 3-step sequence. Attempt email enrichment.
  If email found mid-campaign → add to Instantly with stagger.
```

**US Market:**
```
Channel Hierarchy: Email > LinkedIn > SMS > Phone

IF lead has email + LinkedIn:
  Day 0:  Cold email (Instantly)
  Day 2:  LinkedIn CR (HeyReach)
  Day 4:  Email follow-up #2 (Instantly)
  Day 7:  IF CR accepted → LinkedIn message (HeyReach)
  Day 10: Email follow-up #3 (Instantly)
  Day 14: LinkedIn follow-up (HeyReach)
  Day 18: Email breakup (Instantly)
  Day 22: LinkedIn breakup or profile view (HeyReach)

IF email only:
  Instantly 4-step sequence + attempt LinkedIn enrichment.
```

**Output:** Channel × Day matrix (the sequence blueprint) for user approval before execution.

### Mode B: Launch Multi-Channel Campaign

Full deployment across channels. This is the most complex operation.

**Phase 1: Pre-Flight Checks**
1. Verify Instantly sending accounts: warmup ≥90%, status=1, capacity check
2. Verify HeyReach sender accounts: active, daily capacity (20 CR/account/day, 100/week rolling), SSI check
3. Verify GHL contact data quality: email format, phone E.164, required fields
4. Cross-channel dedup: no lead should already be in active campaign on ANY channel
5. Compliance check: Saudi leads → PDPL consent? UAE leads → PDPL? Opt-out list clean?
6. Ramadan check: If Feb 28 – Mar 30 2026 → auto-adjust timing and volume

**Phase 2: GHL Contact Setup**
- Upsert all leads into GHL with full enrichment data
- Apply tags: `Source_[origin]`, `Campaign_[name]`, `ICP_[segment]`, `Geo_[region]`
- Set custom fields: `signal_score`, `active_channels`, `last_touch_date`

**Phase 3: Instantly Campaign**
- Create lead list: `[Source] - [Audience] - [Date]`
- Create campaign: `[ICP] - [Wedge] - [Month] Email [Variant]`
- Configure: sequences, schedule, daily limits, sender accounts
- Enroll leads with `skip_if_in_campaign=true`

**Phase 4: HeyReach Campaign**
- Create lead list with normalized LinkedIn URLs
- Enroll with sender mapping (geography-aligned, capacity-balanced)
- Configure webhooks: CR_ACCEPTED, REPLY_RECEIVED, SEQUENCE_COMPLETED → n8n

**Phase 5: Cross-Channel Coordination**
- GHL tags: `Channel_Email`, `Channel_LinkedIn` (+ `Channel_WhatsApp` when triggered)
- Set `last_touch_date` and `last_touch_channel` custom fields
- Configure n8n workflows: signal scoring, cross-channel pause on reply

**Phase 6: Campaign Brief**
Output a structured campaign brief:
```
Campaign: [Name]
ICP: [Definition]
Signal: [Trigger]
Leads: [Count] across [channels]
Sequence: [Day × Channel matrix]
Accounts: [Instantly: X accounts, HeyReach: Y accounts]
Schedule: [Days, hours, timezone]
Compliance: [PDPL status, opt-out verified]
Expected: [Reply rate target, meeting target]
```

**Naming Convention (cross-channel traceability):**
```
Instantly:  [ICP] - [Wedge] - [Month] Email [Variant]
HeyReach:   [ICP] - [Wedge] - [Month] LinkedIn
GHL Tags:   Campaign_[ICP]_[Wedge]_[Month]
```

### Mode C: Signal-Triggered Channel Escalation

When a lead engages on one channel — coordinate the response across ALL.

**Step 1: Identify signal** — channel, action, score delta
**Step 2: Score update** → apply signal scoring matrix (below)
**Step 3: Route by aggregate score:**

| Score | Classification | Actions |
|-------|---------------|---------|
| ≥7 (HOT) | High intent | Pause ALL sequences. GHL: Intent_Hot + create opportunity. Slack alert. If MENA+WhatsApp: send warm message |
| 4-6 (WARM) | Emerging interest | Activate secondary channel. Add to nurture workflow. Continue primary sequence |
| <4 (COLD) | Low intent | Continue current sequence. No escalation. No additional channels |

**Step 4: Cross-channel pause protocol**
On reply from ANY channel:
- HeyReach: `stop_lead_in_campaign`
- Instantly: update lead / remove from active campaign
- GHL: update `Intent_Hot`, `Eng_[Channel]_Replied`, advance pipeline

**Step 5: Escalation for MENA**
If lead is MENA + has WhatsApp + score ≥7 → trigger GHL WhatsApp within 2 hours
If lead is US + score ≥7 → keep in email thread, schedule same-day follow-up

### Mode D: Cross-Channel Performance Review

Weekly/monthly performance analysis across all channels.

**Data Collection:**
1. Instantly: `get_campaign_analytics` for all active campaigns
2. HeyReach: `get_overall_stats` for all active campaigns
3. GHL: Pipeline data — new opportunities, stage movements, conversions

**Analysis Framework:**

| Metric | How to Calculate | Benchmark |
|--------|-----------------|-----------|
| Multi-channel lift | Conversion of multi-channel leads vs single-channel | Should see 2-3x improvement |
| Channel attribution | Which channel generated the first qualifying signal | Track by Source_ tag |
| Sequence completion rate | % leads who saw all steps without replying | >80% = sequence too weak or targeting wrong |
| Signal-to-meeting rate | Hot signals that converted to meetings | >30% target |
| Time to first response | Avg days from first touch to first engagement | <7 days healthy |
| Cost per meeting | Total outbound cost / meetings booked | Track monthly |
| Cross-channel compound signals | % of hot leads engaged on 2+ channels | Higher = orchestration working |

**Attribution model:** Time-decay attribution (most recent touchpoint gets highest weight, earlier touches get diminishing credit). This is most accurate for B2B multi-channel where the last touch before reply rarely tells the full story.

**Output:** Performance report with channel-by-channel breakdown + cross-channel insights + specific recommendations (scale X, rewrite Y, pause Z, test new channel for segment W).

### Mode E: Lead Rescue (Re-engage Cold Leads)

Re-engage leads who completed sequences without engagement.

**Rules:**
1. Minimum 30-day gap from last touch before ANY re-engagement
2. Never re-enroll in same campaign — create new campaign with `_rescue` suffix
3. Flip primary channel (email-first → LinkedIn-first, or vice versa)
4. New wedge required — different angle, different signal reference
5. Cross-reference: any engagement on OTHER channels before declaring cold?
6. Partial engagement (opened but no reply) → different CTA, same channel, shorter sequence

**Rescue Sequence (shorter: 3 steps max):**
```
Day 0:  New primary channel — completely different message angle
Day 5:  Secondary channel — value-add (not follow-up)
Day 12: Breakup on primary channel
```

### Mode F: Account-Based Multi-Thread

Multiple contacts at same company — coordinated outreach by role.

**Rules:**
1. Group leads by company domain
2. Assign channel primary per role:
   - Technical (CTO/VP Eng): LinkedIn-first (credibility, technical proof)
   - Revenue (VP Sales/CMO): Email-first (ROI messaging, case studies)
   - Executive (CEO/MD): WhatsApp-first if MENA, LinkedIn if US
3. **Max 2 touches per COMPANY per day** (not per lead)
4. Stagger: Different roles start on different days (Day 0, Day 2, Day 4)
5. Signal sharing: If one contact engages → warm intro the others ("Your colleague Ahmed mentioned...")
6. Never more than 3 contacts at same company in parallel campaigns

## Collision Prevention Protocol (NON-NEGOTIABLE)

Before ANY outbound action on ANY channel:

```
CHECK 1: Is lead opted out? (GHL tag Compliance_OptOut) → STOP
CHECK 2: Reply on any channel in last 7 days? → STOP all sequences
CHECK 3: Touch on any channel in last 24 hours? → SKIP, queue for tomorrow
CHECK 4: Already in active campaign on this channel? → SKIP (dedup)
CHECK 5: Meeting already booked? → STOP all sequences
CHECK 6: Company-level: >2 touches to this company today? → SKIP
CHECK 7: Ramadan active + MENA lead? → Apply Ramadan rules
CHECK 8: PDPL compliance verified for this region? → VERIFY before sending
```

**Timing Rules:**

| Rule | Constraint |
|------|-----------|
| Max touches per channel per day per lead | 1 |
| Max touches across ALL channels per day per lead | 2 |
| Reply on any channel | → Pause ALL other channels immediately |
| Minimum gap between channel touches | 24 hours |
| MENA business hours | Sun-Thu 08:00-17:00 Gulf Time (UTC+4) |
| US business hours | Mon-Fri 09:00-17:00 local timezone |
| WhatsApp timing | NEVER outside business hours. NEVER first touch |
| Re-engagement gap | Minimum 30 days from last touch |
| Same-company gap between contacts | Minimum 24 hours |

**Opt-out propagation:** Opt-out on ANY channel → within 1 hour, remove from ALL:
- HeyReach: `stop_lead_in_campaign`
- Instantly: remove/pause lead
- GHL: tag `Compliance_OptOut`, remove from all workflows
- n8n: propagation workflow handles cross-platform sync

## Signal Scoring Matrix

| Signal | Channel | Base Points | Compound Bonus |
|--------|---------|------------|----------------|
| Email opened | Instantly | +1 | +2 if within 24hr of LinkedIn touch |
| Email link clicked | Instantly | +2 | — |
| Email replied | Instantly | +8 | — |
| LinkedIn profile viewed | HeyReach | +1 | +2 if within 24hr of email open |
| CR accepted | HeyReach | +3 | +3 if within 24hrs of send |
| LinkedIn message reply | HeyReach | +8 | — |
| InMail reply | HeyReach | +6 | — |
| WhatsApp read | GHL | +1 | — |
| WhatsApp reply | GHL | +8 | — |
| Website visit | n8n webhook | +2 | +3 if within 48hr of outbound touch |
| Form submitted | GHL | +10 | — |
| Meeting booked | GHL | +10 | — |
| Content downloaded | Website | +4 | +2 if after outbound touch |

**Compound detection:** Signals from DIFFERENT channels within 48 hours = temporal cluster = higher intent. Always check for compound patterns before scoring.

**Score decay:** Signals older than 14 days lose 50% value. Signals older than 30 days lose 80%. Signals older than 90 days = 0 (signal-to-trust-gtm Hard Stop Rule 2).

**Routing thresholds:** ≥7 = HOT | 4-6 = WARM | <4 = COLD

## Unified Lead Record (GHL Source of Truth)

Every lead across all channels should have this data maintained in GHL:

```json
{
  "email": "primary key for Instantly + GHL",
  "linkedin_url": "primary key for HeyReach",
  "phone": "+971...",
  "first_name": "", "last_name": "", "company": "", "position": "",
  "tags": ["Source_Clay", "Campaign_MENA_SaaS_Feb", "Channel_Email", "Channel_LinkedIn", "Intent_Warm", "Geo_UAE", "ICP_MENA_SaaS"],
  "custom_fields": {
    "signal_score": 5,
    "last_signal_date": "2026-02-22T10:30:00Z",
    "last_signal_channel": "linkedin",
    "last_touch_date": "2026-02-21T09:00:00Z",
    "last_touch_channel": "email",
    "active_channels": "email,linkedin",
    "paused_channels": "",
    "opted_out_channels": "",
    "instantly_campaign_id": "uuid",
    "heyreach_campaign_id": "12345",
    "enrichment_status": "enriched",
    "company_revenue": "$5M-10M",
    "tech_stack": "Salesforce, HubSpot",
    "signal_type": "job_change",
    "signal_detail": "New CTO appointed Feb 2026"
  }
}
```

## MENA Market Playbook

### Key Calendar Events
- **Ramadan 2026:** Feb 28 – Mar 30. Auto-pause or reduce 50%+. Shift to evening timing
- **Optimal windows:** September-November (post-summer), January-February (budget season)
- **Avoid:** July-August (Gulf summer exodus), Eid periods (2-3 days post-Ramadan, Eid al-Adha)

### Enterprise Sales Reality
- 6-12 month cycles. 5-7 person buying committee
- Consensus-based decisions — champion alone can't close
- Wasta (connections) compress deal cycles 40-60% — always check mutual connections
- Vision 2030 alignment is table stakes for Saudi prospects
- Digital transformation mandate = built-in urgency (use it)

### Compliance
- **Saudi PDPL:** Consent required, data localization, up to SAR 5M penalty
- **UAE PDPL:** Extraterritorial, consent required, data subject rights
- Tag all leads: `Compliance_PDPL_KSA` or `Compliance_PDPL_UAE`
- Maintain opt-out list synced across ALL platforms

## Anti-Patterns (Things That Kill Campaigns)

1. Same message on email AND LinkedIn (lazy, looks automated)
2. Touching lead on 3+ channels same day (harassment)
3. WhatsApp as first cold touch (instant block)
4. Ignoring bounces and continuing to send (domain death)
5. Running LinkedIn + email at same daily volume without stagger
6. No idempotency = duplicate touches from webhook retries
7. Generic ICP targeting without signal trigger (3.43% reply)
8. Ignoring time zones (sending at midnight = spam)
9. Not pausing all channels on reply (lead gets follow-up after they already responded)
10. Skipping pre-flight checks (sending from unwarm accounts)
11. Same rescue message as original campaign
12. More than 3 contacts at same company simultaneously
13. HTML emails in cold outreach (triggers spam filters)
14. Links in LinkedIn connection requests (penalized by algorithm)
15. Forgetting Ramadan timing for MENA campaigns

## Reference Files

| File | When to Read |
|------|-------------|
| `references/channel-sequencing.md` | Mode A — sequence patterns by market and data availability |
| `references/signal-scoring-matrix.md` | Mode C — full scoring with compound logic and decay |
| `references/collision-prevention.md` | Mode B — dedup, timing, pause protocols, opt-out propagation |
| `references/campaign-launch-checklist.md` | Mode B — step-by-step launch with pre-flight checks |
| `references/performance-attribution.md` | Mode D — time-decay attribution, cross-channel analysis |
| `references/market-specific-playbooks.md` | Mode A/B — MENA vs US channel preferences, timing, compliance |
| `references/rescue-playbook.md` | Mode E — re-engagement rules, timing, new wedge requirements |
| `references/compliance-guide.md` | All modes — Saudi PDPL, UAE PDPL, CAN-SPAM, GDPR |

## Self-Learning Protocol

When user reveals cross-channel patterns, timing discoveries, or performance data:
1. Note the pattern with specific metrics and context
2. Update the relevant reference file
3. Add dated entry to `references/learnings-log.md`
4. Apply to ALL future orchestration decisions

Capture: channel hierarchy changes, timing optimization results, compound signal discoveries, MENA-specific patterns, rescue campaign performance, account-based threading results.
