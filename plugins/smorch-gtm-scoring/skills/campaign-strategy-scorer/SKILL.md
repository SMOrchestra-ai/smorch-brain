<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: campaign-strategy-scorer
description: Scores campaign strategy and GTM architecture against 10 weighted criteria (signal clarity, ICP precision, channel-market fit, wedge specificity, Q>M>W>D hierarchy, timing, multi-channel coordination, measurement, risk mitigation, MENA contextualization). Triggers on 'score campaign', 'rate my campaign strategy', 'campaign quality check', 'is this campaign ready', 'GTM strategy score', 'outbound strategy review', 'campaign architecture review'. Fires for ANY campaign strategy evaluation, even partial.
---

# Campaign Strategy Scorer

**System 1 of 6 — Battle-Tested Marketing & GTM Expert Hat**

**What this scores:** The strategic architecture of an outbound or inbound campaign before assets are produced. This is the blueprint, not the building. A 10/10 campaign strategy still needs 10/10 copy to work, but a 5/10 strategy will fail regardless of how polished the execution is.

**Benchmark sources:** ColdIQ methodology, Instantly.ai 2026 Benchmark Report, GTM Strategist B2B State of GTM, Signal-to-Trust framework. Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/benchmarks-2026.md` for current numbers.

**Scoring rules:** Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## The 10 Criteria

### C1: Signal Clarity — Weight: 15%

The foundation of signal-based GTM. Without clear, detectable buying signals, you're guessing. Signals are observable events that correlate with purchase intent: job changes, tech stack shifts, funding rounds, RFP publications, expansion announcements, hiring patterns.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Specific, detectable buying signals identified (job changes, tech stack shifts, funding rounds, RFP signals). Each signal has a detection method (Clay, LinkedIn alerts, news monitoring) and freshness window (<90 days). Signal-to-first-touch workflow documented. |
| 7/10 | Good | 3+ signals identified with detection methods. Freshness window defined but not strictly enforced. Some signals are inferred rather than directly observed. Workflow exists but may have manual gaps. |
| 5/10 | Mediocre | Generic "they might need our product" reasoning. Signals exist conceptually but no detection infrastructure. Relying on firmographic fit alone without behavioral triggers. |
| 1/10 | Failure | No signal identification. "Let's email everyone in the industry." Batch-and-blast mentality. Zero intent data. |

**Fix Action (when below 7.0):** Define 3 specific buying signals for your ICP. For each, document: what the signal is, where to detect it (tool/source), what freshness window qualifies (<90 days default), and what the first touch looks like when the signal fires. Takes 30 minutes.

---

### C2: ICP Precision — Weight: 15%

ICP precision is the difference between "mid-market SaaS companies in UAE" and "Series A-B SaaS companies in UAE with 20-100 employees, recently hired VP Sales or Head of Growth, currently using HubSpot or Salesforce, with annual revenue $2-20M." The second one is targetable. The first one is a wish.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3-Level Niche defined: Industry > Sub-segment > Trigger condition. Fit criteria include company size, tech stack, geography, budget authority. Hard Stop rules enforced (Fit=Fail means disqualify immediately). Negative criteria defined (who NOT to target). |
| 7/10 | Good | ICP defined at 2 levels with clear firmographic criteria. Some trigger conditions exist. Negative criteria partially defined. Fit/Fail distinction understood but not systematically enforced. |
| 5/10 | Mediocre | ICP defined at industry level only. "Mid-market SaaS companies in UAE." No trigger conditions. No negative criteria. Everyone in the industry is a "prospect." |
| 1/10 | Failure | No ICP. "B2B companies that could use our product." Zero segmentation. Spray and pray. |

**Fix Action:** Write the 3-level niche statement: "[Industry] > [Sub-segment] > [Trigger condition that makes them ready to buy NOW]." Then list 3 hard disqualifiers. Takes 20 minutes.

---

### C3: Channel-Market Fit — Weight: 12%

The channel must match where the ICP actually responds, not where you're comfortable operating. In MENA B2B: WhatsApp for warm/hot leads, LinkedIn for trust-building, cold email for volume at top of funnel. A US playbook applied to Dubai will underperform.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Channels selected based on where ICP actually responds in target market context. MENA: WhatsApp prioritized for warm touches, LinkedIn for trust, email for volume. Channel selection backed by data or tested hypothesis. Channel mix documented with volume targets per channel. |
| 7/10 | Good | Channels appropriate for the market. Mix includes 2-3 channels. Selection based on reasonable assumptions even if not data-backed. MENA basics respected (WhatsApp included for warm leads). |
| 5/10 | Mediocre | Default Western playbook applied. "Email + LinkedIn because that's what everyone does." No MENA adaptation. Single approach regardless of lead temperature. |
| 1/10 | Failure | Single channel only. Or channels chosen based on what tools are available, not where buyers are. Complete market-channel mismatch. |

**Fix Action:** Map your ICP's actual communication behavior: where do they check messages first? (WhatsApp in MENA, Email in US, LinkedIn for all professional). Then assign channels by lead temperature: cold = email, warm = WhatsApp/LinkedIn, hot = phone/WhatsApp. Takes 15 minutes.

---

### C4: Wedge Specificity — Weight: 12%

A wedge is a one-sentence message angle derived from a validated signal, sharp enough to make a busy VP stop scrolling. "We help companies improve their sales process" is not a wedge. "Your new VP Sales is inheriting a pipeline with 23% of contacts having stale data — here's how to clean it in 48 hours" is a wedge.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | One-sentence wedge per week that passes the "would this make a busy VP stop scrolling?" test. Wedge derived from validated signal, not generic value prop. Different wedge per persona/segment. Each wedge connects to a specific pain/trigger event. |
| 7/10 | Good | Wedges exist and are signal-informed. Mostly specific. Pass the scroll-stop test for 70%+ of the target audience. May reuse across segments without full customization. |
| 5/10 | Mediocre | Generic value proposition used as wedge. "We help companies improve their sales process." Not signal-derived. Same message to everyone. Would not stop a VP mid-scroll. |
| 1/10 | Failure | No wedge concept. Feature-dumping or company introduction approach. "Here's what our product does." |

**Fix Action:** Take your strongest buying signal + your ICP's biggest pain and compress into one sentence: "[Signal they just experienced] means [specific consequence they're facing] — [your mechanism] fixes it in [timeframe]." Test it: would YOU stop scrolling? Takes 20 minutes.

---

### C5: Q>M>W>D Hierarchy — Weight: 8%

The domino effect: Quarterly theme cascades to Monthly campaign, which produces Weekly wedges, which drive Daily execution. Each level derives from and amplifies the level above. Without this hierarchy, campaigns are random acts of outbound.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Clear domino effect documented: Quarterly theme > Monthly campaign > Weekly wedge > Daily execution. Each level derives from the one above. Compounding impact visible. Campaign brief shows the full hierarchy with rationale at each level. |
| 7/10 | Good | Monthly campaign aligns with quarterly theme. Weekly wedges exist but may not perfectly derive from monthly. Daily execution follows a pattern but hierarchy is somewhat loose. |
| 5/10 | Mediocre | Monthly plan exists but disconnected from quarterly strategy. Weekly execution is ad hoc. No visible cascade or compounding. |
| 1/10 | Failure | No hierarchy. Random campaigns launched when someone has an idea. No quarterly planning. No weekly rhythm. |

**Fix Action:** Write one sentence for each level: Q = "[Outcome we're hammering this quarter]", M = "[How we narrow Q for this month]", W = "[3 wedge angles for this month]", D = "[Channel cadence: Mon email, Tue LinkedIn, Wed WhatsApp]." Takes 15 minutes.

---

### C6: Timing & Velocity — Weight: 10%

Signal-to-first-touch speed is a competitive advantage. When a prospect publishes a hiring signal, the first vendor to respond with a relevant message wins disproportionately. 48-hour signal-to-touch is the target.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Signal-to-first-touch under 48 hours. Sequence cadence optimized per channel (email: 3-4 day gaps, LinkedIn: staggered with email, WhatsApp: only after engagement signal). Follow-up persistence: 4-7 touches. |
| 7/10 | Good | Signal-to-first-touch within one week. Cadence defined and reasonable. Follow-up sequence of 3-5 touches. Minor timing gaps between signal detection and outreach. |
| 5/10 | Mediocre | Reasonable cadence but no signal-speed requirement. "We'll reach out next week." No urgency in responding to buying signals. 2-3 follow-ups. |
| 1/10 | Failure | No timing strategy. Batch-and-blast monthly. No follow-up sequence. Signals detected weeks later or not at all. |

**Fix Action:** Set up a signal alert workflow (Clay, LinkedIn alerts, Google Alerts) that notifies within 24 hours. Create a pre-written first-touch template that can be personalized in 5 minutes. Goal: signal detected → personalized outreach within 48 hours.

---

### C7: Multi-Channel Coordination — Weight: 8%

Channels should be orchestrated, not running in parallel silos. LinkedIn warms before email hits. WhatsApp activates after engagement signal. Cross-channel deduplication ensures no prospect gets hit by 3 channels on the same day.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Channels orchestrated with clear sequencing logic. LinkedIn connection before email sequence. WhatsApp after engagement signal (reply, profile view, content engage). Cross-channel deduplication enforced. No prospect hit by 3 channels same day. Timing documented. |
| 7/10 | Good | Channels aware of each other. Some coordination (email and LinkedIn staggered). Deduplication mostly enforced. Minor overlap possible but not systematic. |
| 5/10 | Mediocre | Channels run independently. Marketing does email, sales does LinkedIn, no coordination. Some overlap/duplication. |
| 1/10 | Failure | Single channel or channels actively conflicting (same prospect, same day, different message). No deduplication. Prospects annoyed by multiple conflicting touchpoints. |

**Fix Action:** Create a simple channel sequence map: Day 1 = LinkedIn connect, Day 3 = Email 1, Day 6 = Email 2, Day 8 = LinkedIn message (if connected), Day 10 = WhatsApp (if warm signal). Map it on a timeline. Takes 15 minutes.

---

### C8: Measurement Framework — Weight: 8%

Pre-defined KPIs per stage with specific targets. If you can't measure it, you can't improve it. "We'll see how it goes" is not a measurement framework.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Pre-defined KPIs per stage: reply rate (>5% cold email, >15% LinkedIn), meeting book rate (>2%), pipeline velocity, channel-level CAC. Weekly review cadence built in. Attribution model defined. Dashboard or tracking system specified. |
| 7/10 | Good | KPIs defined for primary metrics (reply rate, meetings). Targets set based on benchmarks. Monthly review planned. Tracking method identified (spreadsheet or CRM). |
| 5/10 | Mediocre | Tracks opens and clicks. No stage-specific targets. Reviews "when we have time." No attribution model. |
| 1/10 | Failure | No measurement. "We'll see how it goes." Zero KPIs. No review cadence. Flying blind. |

**Fix Action:** Define 3 KPIs with targets: (1) Reply rate target per channel, (2) Meeting book rate target, (3) Pipeline value target per month. Set a weekly 15-minute review. Takes 10 minutes.

---

### C9: Risk Mitigation — Weight: 7%

Deliverability, sender reputation, compliance, and fallback planning. A campaign that triggers spam filters or burns domains is worse than no campaign.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Domain/sender reputation protection plan. Warmup strategy for new sending infrastructure. Fallback plan if primary channel underperforms. Compliance with Gmail/Microsoft 2026 sender requirements (DMARC, <0.1% spam complaints, <2% bounce). Backup domains ready. |
| 7/10 | Good | Deliverability basics covered (DMARC, warmup). Aware of compliance requirements. Fallback discussed but not formalized. One backup domain available. |
| 5/10 | Mediocre | Aware of deliverability but no proactive plan. "We'll watch the bounce rates." No warmup strategy. No backup domains. |
| 1/10 | Failure | No awareness of sender reputation, compliance, or fallback. Sending from brand new domain at full volume day one. No DMARC. |

**Fix Action:** Check 3 things: (1) Is DMARC/DKIM/SPF configured on sending domains? (2) Are new domains being warmed for 2+ weeks before full send? (3) Is there a backup domain if the primary gets flagged? Fix whichever is missing first.

---

### C10: MENA Contextualization — Weight: 5%

For MENA-targeted campaigns. A US playbook copy-pasted to Dubai underperforms a locally-built campaign by 40-60%. Trust mechanics, communication channels, timing, and social proof all differ structurally.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Arabic/bilingual messaging where appropriate. Gulf business culture timing respected (Sunday-Thursday work week, no campaigns during Ramadan peak hours without adjustment). WhatsApp prioritized for warm touches. Social proof from regional logos/references. Trust-first approach (education before pitch). |
| 7/10 | Good | MENA basics respected: WhatsApp included, Arabic option available, regional timing acknowledged. Some regional social proof. May not be fully localized. |
| 5/10 | Mediocre | English-only with minor localization. Standard Western business hours assumed. Saturday-Sunday treated as weekend (wrong for Gulf). |
| 1/10 | Failure | Zero MENA adaptation. US playbook copy-pasted. Monday-Friday assumed. No WhatsApp. No Arabic. No regional proof. |

**Fix Action:** Three quick wins: (1) Add WhatsApp as a warm channel, (2) Adjust send timing to Sunday-Thursday Gulf hours, (3) Include one MENA-specific case study or social proof point. Takes 20 minutes.

---

## Scoring Execution

### Input Required

To score a campaign strategy, you need:
1. The campaign brief or strategy document (text, file, or conversation context)
2. Target market (MENA, US, EU, multi)
3. Target ICP (who is this campaign aimed at)

If the user hasn't specified these, infer from context or ask briefly: "Scoring your campaign strategy. Quick: MENA-targeted? Which ICP?"

### Process

1. Read the campaign material
2. Score each of the 10 criteria on 1-10 scale
3. For any criterion below 7.0, include the Fix Action
4. Calculate weighted average
5. Check hard stops (any criterion below 5.0)
6. Assign verdict per `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md`
7. Present the score report
8. Offer to fix the top issues immediately

### Output Format

Use the standard score report format from `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md`. Quick reference:

```
SCORE REPORT: [Campaign Name]
System: Campaign Strategy
Date: [YYYY-MM-DD]

CRITERIA BREAKDOWN:
| # | Criterion | Weight | Score | Status |
[10 rows]

OVERALL: [X.X] / 10
VERDICT: [SHIP / TWEAK / IMPROVE / REWORK / RESTART]
HARD STOPS: [None / List]
TOP 3 FIXES: [by impact, with estimated lift]
```

For partial campaigns where only 6-8 of 10 criteria apply (e.g., single-channel campaign skips C7 Multi-Channel Coordination), normalize weights: `Adjusted Weight = Original Weight / Sum of Applicable Weights`. Flag which criteria were excluded and why.

### Scoring Mindset

Think like a GTM strategist who has run 200+ campaigns in MENA markets. You've seen what works and what fails. You know that:
- Signal clarity is the #1 predictor of campaign success
- Most campaigns fail not on copy quality but on targeting and timing
- MENA campaigns that respect trust mechanics outperform adapted Western playbooks by 2-3x
- Measurement without action is vanity; measurement with weekly reviews is management

Score honestly. An 8.0 with clear fix actions is more useful than a generous 9.0 that hides gaps.

---

## Calibration Anchor: Scored Example

**Scenario:** Q2 2026 campaign for SalesMfast Signal Engine targeting Series A-B SaaS companies in UAE/Saudi expanding sales teams.

| # | Criterion | Weight | Score | Rationale |
|---|-----------|--------|-------|-----------|
| C1 | Signal Clarity | 15% | 9.0 | 4 signals defined (VP Sales hire, funding round, headcount growth >20%, tech stack change). Detection via Clay + LinkedIn alerts. Freshness <60 days. Missing: signal-to-touch workflow not fully automated (manual step between Clay alert and Instantly sequence). |
| C2 | ICP Precision | 15% | 9.5 | 3-Level Niche: SaaS > Series A-B with 20-100 employees > Recently hired VP Sales or expanded to new Gulf market. Hard disqualifiers: <$1M ARR, no English-speaking decision maker, already using agency for outbound. |
| C3 | Channel-Market Fit | 12% | 8.5 | Email for cold (Instantly), LinkedIn for trust (HeyReach), WhatsApp for warm (GHL). WhatsApp only after engagement signal. Minor gap: no phone channel for hot leads from MENA enterprise. |
| C4 | Wedge Specificity | 12% | 8.0 | "Your new VP Sales inherited a pipeline built on relationship-selling. In the Gulf, that means 47 coffee meetings before the first deal. Here's a faster path." Strong but same wedge used across 2 segments. |
| C5 | Q>M>W>D Hierarchy | 8% | 7.5 | Q: "Signal-based GTM replaces relationship-selling in Gulf." M: "VP Sales hires as entry signal." W: 3 wedge angles. D: Email Mon/Wed, LinkedIn Tue/Thu, WhatsApp Fri (warm only). Monthly and weekly connected; daily execution slightly ad hoc. |
| C6 | Timing & Velocity | 10% | 8.0 | Signal-to-first-touch target: 72 hours (not 48). Clay alerts daily. First-touch template ready. Gap: LinkedIn connection request can add 3-5 day delay before DM. |
| C7 | Multi-Channel Coordination | 8% | 7.5 | Channels staggered: LinkedIn Day 1, Email Day 3, Email 2 Day 6. WhatsApp only after email reply or LinkedIn accept. Minor gap: no formal cross-channel deduplication beyond manual check. |
| C8 | Measurement Framework | 8% | 8.5 | KPIs defined: reply rate >5% email, >15% LinkedIn, meeting book rate >2%. Weekly review scheduled Friday 2pm. Tracking in GHL + Instantly dashboards. Gap: no unified dashboard; attribution requires manual reconciliation. |
| C9 | Risk Mitigation | 7% | 9.0 | 3 sending domains warmed 4 weeks. DMARC/DKIM/SPF confirmed. Backup domain ready. Instantly spam checker passed. Bounce monitoring active. |
| C10 | MENA Contextualization | 5% | 9.0 | Sunday-Thursday send schedule. Arabic greeting in WhatsApp. Regional logos in social proof (Careem, Talabat ecosystem). Ramadan timing plan documented. WhatsApp voice notes for warm leads. |

**OVERALL: 8.52 / 10 — VERDICT: STRONG (Ship with minor tweaks)**
**HARD STOPS: None**
**TOP FIX: C7 Multi-Channel Coordination — add automated deduplication rule in n8n: if prospect exists in HeyReach active campaign, exclude from Instantly list. Estimated lift: +1.0 point on C7.**

This example demonstrates: a real campaign can score 8.5 and still have clear improvements. A 9.0+ requires zero manual gaps in any criterion.

---

## Cross-System Dependencies

Campaign Strategy is the upstream system: it feeds every downstream deliverable. When other systems score poorly, check here first.

| Downstream Weakness | Likely Root Cause Here | Check This Criterion |
|---------------------|----------------------|---------------------|
| Copywriting personalization low | Weak signal definition | C1: Signal Clarity |
| Social media posts lack audience fit | ICP too broad | C2: ICP Precision |
| Email sent on wrong channel for market | No channel-market mapping | C3: Channel-Market Fit |
| All copy sounds the same across segments | No weekly wedge rotation | C4: Wedge Specificity |
| Campaign feels random, no compounding | No hierarchy documented | C5: Q>M>W>D Hierarchy |
| Prospects already chose a competitor | Signal-to-touch too slow | C6: Timing & Velocity |
| Prospect hit by 3 channels same day | No coordination map | C7: Multi-Channel Coordination |
| Can't tell what's working | No KPIs or review cadence | C8: Measurement Framework |

If a downstream scorer flags an upstream dependency, this system should be re-scored and fixed first. Fixing copy when the strategy is broken is polishing a broken engine.
