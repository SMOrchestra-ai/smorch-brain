# Phase Details Reference

Detailed instructions for each of the 9 campaign phases. The SKILL.md orchestrator
references this file. Read only the phase you're currently executing, not the whole file.

---

## Phase 1: Campaign Brief

**Owner:** Campaign Lead (Ruba) | **Day:** Sunday

Every campaign starts with a one-page brief. No brief = no campaign.

### Brief Template (All 11 Fields Required)

| # | Field | Source File | Example |
|---|-------|------------|---------|
| 1 | ICP definition | icp.md | VP Sales at B2B SaaS, 50-500 employees, Gulf HQ |
| 2 | Negative ICP | icp.md | Consulting firms, agencies, companies < 20 people |
| 3 | Target geography + language | gtm.md | UAE + Saudi Arabia, English primary |
| 4 | Offer + wedge angle | positioning.md | Signal Engine pilot: 15 meetings in 60 days or free extension |
| 5 | Signal set to activate | signals.md | Hiring VP Sales + funding round + competitor tech change |
| 6 | Proof assets | brandvoice.md | RSC case study (12 meetings in 30 days), Uniphore logo |
| 7 | Channels | gtm.md | Email (primary) + LinkedIn (secondary) |
| 8 | Suppression rules | Manual | Active customers, negative reply < 90 days, blacklist |
| 9 | Success thresholds | gtm.md | Reply rate > 5%, meeting rate > 2%, CPM < $200 |
| 10 | Budget cap | Manual | $3,000 total campaign cost |
| 11 | Accountable owner | Manual | Ruba |

### How to Generate

Invoke `smorch-gtm-engine:campaign-strategist`. It reads the project brain files
and generates the brief from context. The operator reviews and adjusts.

If the campaign-strategist skill is unavailable, walk the operator through filling
each field manually using the project brain files as source.

### Gate: Brief Completeness

Check all 11 fields. Any blank field = gate fail. Push back: "Field {N} ({name}) is
empty. What should it be?"

---

## Phase 2: Data Acquisition + QA

**Owner:** Data Operator (Ruba + Nour support) | **Day:** Sunday-Monday

### Step 1: Pull Data

Invoke in this order:

1. `smorch-gtm-tools:salesnav` - Mode B: Search & Extract
   - Build boolean search from ICP definition in the brief
   - Extract at 3-5 seconds per profile (respect LinkedIn limits)
   - Target: 500-2000 leads depending on ICP size

2. `smorch-gtm-tools:clay-operator` - Waterfall enrichment
   - Use FETE framework (Filter, Enrich, Transform, Export)
   - Cheapest provider first, stop when email found
   - Enrich: email, phone, company size, tech stack, funding data

3. First-party data check
   - Ask operator: "Any first-party data to include? (website visitors, past campaign
     engagers, CRM contacts from GHL)"
   - If yes, invoke `smorch-gtm-tools:ghl` to search existing contacts

### Step 2: QA the Data

Run these checks on the dataset:

| Check | Threshold | Action if Fail |
|-------|-----------|----------------|
| Duplicate rate | < 5% | Deduplicate before proceeding |
| Missing email | < 10% of records | Re-run enrichment or remove records |
| Invalid domains | 0% | Remove all invalid |
| Invalid LinkedIn URLs | 0% | Remove or fix |
| Stale signals (> 30 days) | Flag all | Apply freshness penalty or exclude |
| Enrichment completion | > 85% | Switch enrichment provider |

### Gate: Data Quality

All 6 thresholds must pass. If any fails, fix before advancing.
Output: clean prospect set with signal records attached.

---

## Phase 3: Signal Detection + Scoring

**Owner:** Signal Analyst (Ruba) | **Day:** Monday

### Invoke

`smorch-gtm-engine:signal-detector`

This skill validates ICP Fit and classifies signals into 4 types:
- **Fit**: Should we care? (industry, size, geography, tech stack)
- **Intent**: Are they in market? (competitor research, G2 visits, pricing page)
- **Trigger**: Why now? (new VP hired, funding, expansion)
- **Engagement**: Have they interacted with us? (email open, content download)

### Hard Stop Rules (Enforced)

1. **Fit = FAIL means NO outreach.** Bad fit poisons everything downstream.
2. **Signal > 90 days = EXCLUDE.** Stale signals produce irrelevant outreach.

### Scoring Formula

Priority Score = (Fit x 0.30) + (Intent x 0.30) + (Trigger x 0.20) + (Engagement x 0.20)

Multipliers:
- Signal < 7 days: 1.2x freshness boost
- Signal 15-30 days: 0.8x penalty
- Signal > 30 days: 0.5x penalty
- 3+ stakeholders: 1.3x buying committee boost
- Matching proof asset: 1.1x boost
- Recent negative reply from same domain: SUPPRESS

### Routing Tiers

| Tier | Score | Action |
|------|-------|--------|
| 0: Discard | < 30 | Suppress. Do not contact. |
| 1: Monitor | 30-50 | Watchlist. Re-score next week. |
| 2: Nurture | 50-70 | Light-touch: content share, LinkedIn engage. |
| 3: Launch | 70+ | Full outbound campaign sequence. |

### Gate: Signal Validation

All Tier 3 accounts must have Fit = PASS. No signals older than 90 days in Tier 3.
Output: scored, routed prospect list with Tier 3 accounts ready for message assembly.

---

## Phase 4: Offer Scoring

**Owner:** Campaign Lead (Ruba) | **Day:** Monday

### Why Score the Offer Before Writing Copy

Most agencies blame copy when campaigns fail. Often the copy was fine; the offer was
weak, vague, or badly timed. Scoring the offer first prevents wasting time on messages
that can't convert because the proposition isn't strong enough.

### Invoke

`smorch-gtm-scoring:score` with the offer content. Routes to offer-positioning-scorer.

The scorer evaluates 10 dimensions (Hormozi Value Equation + Dunford 5-Component):

1. Dream Outcome Clarity (15%)
2. Perceived Likelihood of Achievement (12%)
3. Time to Value (10%)
4. Effort & Sacrifice Minimization (10%)
5. Unique Mechanism (12%)
6. Competitive Alternative Clarity (8%)
7. Price-to-Value Gap (10%)
8. Risk Reversal (8%)
9. ICP-Offer Alignment (8%)
10. Positioning Statement Clarity (7%)

Plus Dunford Completeness Check (5 components must be present).

### Gate: Offer Strength

- Offer Score >= 6.0 to proceed
- If < 6.0: STOP. Fix the offer. Do not write outreach for a weak offer.
- Tell operator which dimensions scored lowest and how to improve them.

---

## Phase 5: Wedge Generation + Message Assembly

**Owner:** Content Operator (Ruba + Nour) | **Day:** Tuesday

### Step 1: Generate Wedges

Invoke `smorch-gtm-engine:wedge-generator`

Wedge formula: "[Observed Signal] is costing you [Specific Outcome]. [One-Line Solution]."

Hard stops:
- Every wedge must pass the one-sentence test
- Intent signals produce wedges before Trust signals

### Step 2: Generate Campaign Assets

Invoke `smorch-gtm-engine:asset-factory`

The factory produces per campaign:
- 18 emails (3-email sequences x 2 A/B variants x 3 weeks)
- 12 LinkedIn messages (connection note + 2-step sequence x 3 weeks)
- 9 WhatsApp messages (3 psychology variants x 3 weeks) - only if approved
- 3 supporting social posts

### Message Rules

- Email: < 80 words. One signal, one outcome, one proof, one CTA.
- First line: pattern interrupt. No "I hope this finds you well."
- Personalization: signal-based, not name-merge fluff.
- LinkedIn connection note: < 300 characters. No pitch.
- A/B testing: mandatory. Test subject line OR CTA each week.
- Follow-ups: 3-4 steps max. Each adds new value.

### Gate: Message Quality

- Every message references an actual signal (not generic copy)
- All emails under 80 words
- A/B variants exist for primary channel
- LinkedIn notes under 300 characters

---

## Phase 6: Score Everything Before Launch

**Owner:** Campaign Lead (Ruba) | **Day:** Tuesday-Wednesday

### Invoke

`smorch-gtm-scoring:score-all`

This runs composite scoring across all applicable systems:

| What Gets Scored | Scoring System |
|-----------------|----------------|
| Campaign strategy | campaign-strategy-scorer (10 criteria) |
| Offer/positioning | offer-positioning-scorer (10 + Dunford) |
| Cold email copy | copywriting-scorer: cold email (9 criteria) |
| LinkedIn DM copy | copywriting-scorer: LinkedIn DM (7 criteria) |
| WhatsApp copy (if used) | copywriting-scorer: WhatsApp (8 criteria) |

### Composite Campaign Health Score

Campaign Strategy (25%) + Offer/Positioning (20%) + Best Copywriting (25%) +
Social Media (15%) + Supporting (15%)

### Hard Stops

- Any single criterion < 5.0 = fix before launch
- Primary channel score < 6.0 = rewrite
- MENA context score must be > 6.0

### Gate: Composite Score

Campaign Health Score >= 7.0 to proceed.
If < 7.0: identify the weakest system using cross-system dependency tracing.
Low copy often traces to weak signal clarity or ICP precision (upstream fix needed).

### Self-Scoring

After the automated score, ask the operator:
"Score this campaign 1-10. What makes it 10/10? Bridge the gap."
Do not proceed below 9.

---

## Phase 7: Compliance + Deliverability Gate

**Owner:** Technical Operator (Ruba + Lana) | **Day:** Wednesday

### Invoke

`smorch-gtm-tools:instantly` - Mode C: Account Health
`smorch-gtm-tools:heyreach` - check LinkedIn account status

### Checks

| Check | Pass Criteria | How to Verify |
|-------|--------------|---------------|
| SPF/DKIM/DMARC | All pass | Domain DNS + Instantly settings |
| Mailbox warmup | > 80% all accounts | `get_warmup_analytics` |
| Bounce threshold | < 3% on last campaign | `get_campaign_analytics` |
| Spam complaint rate | < 0.3% | `get_campaign_analytics` |
| Daily sending volume | Within safe limits | `list_accounts` |
| LinkedIn health | No restrictions | `get_all_linked_in_accounts` |
| Opt-out handling | Present and functional | Manual email test |

### Gate: Infrastructure Health

All 7 checks must pass. Any failure = do not launch.
Good copy on broken infrastructure = wasted campaign.

---

## Phase 8: Launch

**Owner:** Campaign Operator (Ruba) | **Day:** Wednesday

### Invoke

`smorch-gtm-engine:outbound-orchestrator` - Mode B: Launch

### Launch Sequence (Batched)

1. Seed batch: 50-100 leads. Deploy to Instantly + HeyReach.
2. Monitor 24 hours: deliverability, bounces, workflow errors, routing accuracy.
3. If clean: expand to 500. Monitor 24 hours.
4. If clean: scale to full list.
5. If ANY metric is red: STOP. Diagnose before scaling.

### Deployment Commands

- Email: `smorch-gtm-tools:instantly` (create_campaign, add leads, activate)
- LinkedIn: `smorch-gtm-tools:heyreach` (create list, add leads, enroll)
- CRM: `smorch-gtm-tools:ghl` (create contacts with tags, add to pipeline)

### Cross-Channel Coordination

- LinkedIn connection request BEFORE cold email (build familiarity)
- Email follows LinkedIn by 1-2 days
- WhatsApp ONLY after engagement signal
- Never hit same person on 3 channels same day

### Gate: Seed Batch Clean

First 50-100 leads must show: zero critical failures, zero duplicates,
zero routing errors, deliverability > 95%.

---

## Phase 9: Daily Monitoring + Weekly Review

**Owner:** Ruba (daily) + Mamoun (Friday review) | **Days:** Wed-Friday

### Daily Monitoring (Wed-Thu)

Invoke `smorch-gtm-engine:campaign-dashboard`

Track:
- Email: sends, delivered, bounced, opens, replies, positive replies, meetings
- LinkedIn: CRs sent, accepted, messages sent, replies
- CRM: new contacts, pipeline movement
- System: workflow failures, AI errors, sync failures

### Weekly Review (Friday)

Invoke `smorch-gtm-engine:weekly-review`
Then invoke `smorch-gtm-scoring:score` on the campaign results.

Answer these 6 questions:

1. What happened this week? (facts, not feelings)
2. Which layer failed? Infrastructure / Data / Offer / Message / Routing / Channel?
3. Which scorecard dimensions dragged performance?
4. What is the single highest-leverage fix for next week?
5. What should be stopped immediately?
6. What should be scaled?

### Gate: Review Complete

All 6 questions answered with evidence. Root cause identified.
Next-week plan documented. Linear ticket updated with results.

### Cycle Complete

After Phase 9 passes, announce:
"Campaign cycle complete. Results logged.
Next cycle starts Sunday with Phase 1 (new brief or brief revision).
Want to start the next cycle, or pause?"
