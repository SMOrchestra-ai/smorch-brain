<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: signal-to-trust-gtm
description: Signal-to-Trust GTM orchestrator for complete outbound campaign management. Use whenever the user wants to create signal-based outreach campaigns, generate multi-channel assets (email/LinkedIn/WhatsApp/VSL), analyze campaign performance, calculate Digital Silence Index, build lead magnets, adapt messaging for geographic markets (MENA/US/EU), or deploy to GHL/Instantly/HeyReach. Triggers include "launch campaign", "generate weekly assets", "analyze performance", "signal-based outreach", "wedge generation", "silence type", "DSI calculator", or any mention of the Signal-to-Trust framework. This skill orchestrates 10 specialized sub-skills to handle the complete Q->M->W->D campaign hierarchy.
---

# Signal-to-Trust GTM Orchestrator

## Overview

This is the master orchestrator for the complete Signal-to-Trust GTM framework. It manages the hierarchical campaign flow from **Quarterly -> Monthly -> Weekly -> Daily** and coordinates 10 specialized sub-skills to produce complete multi-channel outbound campaigns.

**Core Philosophy**: "Your funnel is not broken. It is silent."

Every campaign is built on observed signals (not assumptions), wedges derived from those signals (not generic value props), and assets optimized for specific silence types.

## When to Use This Skill

This skill orchestrates EVERYTHING in the Signal-to-Trust framework:

1. **New Campaign Launch**: "Start monthly campaign for MENA SaaS founders targeting Proof Silence"
2. **Weekly Asset Generation**: "Generate this week's sequences for Week 2"
3. **Performance Analysis**: "Analyze last week's results and recommend pivot"
4. **Signal Detection**: "Validate these 200 prospects against Fit criteria"
5. **Wedge Generation**: "Create wedges for Intent signal: hiring sales team"
6. **DSI Calculation**: "Calculate Digital Silence Index for this landing page"
7. **Lead Magnet Creation**: "Build Signal Audit scorecard for real estate brokers"
8. **Geographic Adaptation**: "Adapt this message for MENA vs US markets"
9. **Integration Deployment**: "Deploy to GHL and Instantly"

## Strategic Questionnaire

Before executing ANY campaign work, run this questionnaire to determine execution path. Present as **multiple-choice** with context-aware defaults.

### Question 1: Invocation Mode
**What are you trying to do?**
- A) Launch new monthly campaign (full Q->M->W->D alignment)
- B) Generate this week's assets (existing campaign continuation)
- C) Analyze performance and recommend pivot
- D) One-off task (signal validation, wedge generation, DSI calc, etc.)

**Execution Logic:**
- A -> Questions 2-12, then full orchestration
- B -> Questions 2, 6-8, 11, then asset-factory + culture-adapter
- C -> Load campaign context, call performance-analyzer
- D -> Route to specific sub-skill based on task type

---

### Question 2: ICP Selection
**Which ICP are we targeting?**
- A) MENA SaaS Founders (B2B tech, 5-50 employees)
- B) US Real Estate Brokers (residential, 10-100 agents)
- C) MENA Beauty Clinics (derma/aesthetics, 2-20 staff)
- D) US eCommerce (DTC brands, $500k-$5M revenue)
- E) Other (describe: _________)

**This determines:**
- Fit criteria enforcement (ICP-specific hard stops)
- Wedge templates from wedge-sentence-map.md
- Culture Map application (MENA vs US messaging)
- Channel mix (WhatsApp for MENA, email/LinkedIn for US)

---

### Question 3: Quarterly Feature (Hammering Theme)
**What quarterly outcome/feature are we hammering?**
- A) Use existing quarterly theme: [display if campaign exists]
- B) Define new quarterly feature (one-sentence outcome)

**Examples:**
- "Capture 8x more revenue per contact than social followers"
- "Respond within 5 minutes for 21x higher conversion"
- "Nurture backend leads for 50x improvement in close rate"
- "Consolidate scattered sales data into unified dashboard"

**This becomes the North Star** for all downstream (M->W->D) derivation.

---

### Question 4: Monthly Narrowing Strategy
**How should we narrow from Quarterly -> Monthly?**
- A) By ICP segment (e.g., MENA SaaS -> vertical focus)
- B) By feature breakdown (e.g., Capture 8x -> 3 sub-wedges)
- C) By silence type (e.g., Proof Silence all month)
- D) Let skill decide based on signal density

**Examples:**
- Quarterly: "Capture 8x ROI" -> Monthly: "Instagram Follower Leakage" (ICP segment)
- Quarterly: "Capture 8x ROI" -> Monthly: "8x Capture" + "20x Response" + "50x Nurture" (feature breakdown)
- Quarterly: "Capture 8x ROI" -> Monthly: "Proof Silence" (silence type focus)

---

### Question 5: Signal Collection Status
**Do you have signals collected, or should we gather them?**
- A) Signals already collected (provide CSV/list)
- B) Need to scrape signals (use Apify/Relevance)
- C) Manual signal observation (I'll provide examples)

**If B selected:**
- Call signal-detector with scraping mode
- Tools: Apify (LinkedIn/web scraping), Relevance (enrichment)
- Output: CSV with Fit/Trigger/Signal Type/Subtype/Raw Data

---

### Question 6: Weekly Wedge Strategy
**How should we derive 3 weekly wedges from monthly theme?**
- A) Different angles on same monthly wedge (default)
- B) Sequential story (Week 1->2->3 builds narrative)
- C) A/B/C test variants (same core message, different psychology)

**Critical Rule**: Weekly wedges are DIFFERENT (not A/B test variants), but derivative from monthly theme.

**Example (Monthly: "Instagram Follower Leakage"):**
- Week 1: "Rented Land Risk" (algorithm changes, account suspension)
- Week 2: "8x Revenue Gap" (owned contacts vs social followers)
- Week 3: "Capture Infrastructure" (funnel + AI solution)

---

### Question 7: Lead Magnet Selection
**What lead magnet should we create for this monthly campaign?**
- A) DSI Scorecard (interactive assessment)
- B) Signal Library (curated list of triggers)
- C) Wedge Calculator (outcome estimator)
- D) Case Study Library (proof-based stories)
- E) Battle Card (one-page framework)
- F) None (link directly to booking)

**Tied to silence types:**
- Positioning Silence -> Battle Card
- Proof Silence -> Case Study Library
- Objection Silence -> DSI Scorecard with Q&A
- Channel Silence -> Signal Library
- Step Silence -> Wedge Calculator
- Response Silence -> Battle Card
- Friction Silence -> DSI Scorecard

---

### Question 8: VSL Strategy
**What VSL(s) should we create?**
- A) 5-minute monthly master VSL (Problem-Agitation-Solution-Proof-Offer)
- B) 1-2 minute weekly wedge-specific VSLs (3 total)
- C) Both monthly + weekly
- D) None (text-based campaign only)

**Default recommendation**: C (both) for first month, B (weekly only) for subsequent months.

---

### Question 9: Channel Mix
**Which channels should we use?**
- A) Email + LinkedIn (default for US/EU)
- B) Email + LinkedIn + WhatsApp (default for MENA)
- C) Email only (high-volume, low-touch)
- D) LinkedIn only (executive outreach)
- E) Custom (specify: _________)

**Weekly output volumes:**
- Email: 3 sequences x 2 variants = 6 emails
- LinkedIn: 2 sequences x 2 variants = 4 messages
- WhatsApp: 1 sequence x 3 variants = 3 messages
- Social posts: 3 posts (LinkedIn/Twitter)
- VSLs: 1-2 videos

---

### Question 10: Geographic Market
**Which geographic market(s)?**
- A) MENA (trust-first, high-context, relationship-driven)
- B) US (intent-first, direct, data-driven)
- C) Germany (data-first, structured, formal)
- D) Multi-market (specify regions)

**This triggers culture-adapter sub-skill** using Erin Meyer's Culture Map framework.

---

### Question 11: Integration Mode
**How should we deploy assets?**
- A) Manual (just give me the assets)
- B) Hybrid (assets + workflow triggers)
- C) Full automation (deploy to GHL/Instantly/HeyReach)

**If B or C selected:**
- Calls integration-orchestrator
- Outputs: GHL workflow JSONs, Instantly campaign configs, HeyReach sequences
- Tools: GHL API, Instantly API, HeyReach CSV exports

---

### Question 12: Performance Tracking
**Should we set up self-improvement loop?**
- A) Yes, track performance and suggest optimizations
- B) No, one-time campaign generation

**If A selected:**
- Calls performance-analyzer after Week 1
- Tracks: Reply rate, meeting rate, objection patterns, winning templates
- Suggests: Wedge pivots, new signal discovery, template evolution

---

## Sub-Skill Orchestration (High-Level)

Based on questionnaire answers, the orchestrator routes to one of four execution modes. Each mode calls sub-skills in a specific sequence.

For detailed sub-skill orchestration sequences, dependencies, and input/output specs, see **sub-skill-refs.md**.

### Mode A: New Monthly Campaign (Full Q->M->W->D)
Calls all 10 sub-skills in sequence: campaign-strategist -> signal-detector -> wedge-generator -> asset-factory -> lead-magnet-builder -> dsi-calculator -> landing-page-architect -> culture-adapter -> integration-orchestrator -> performance-analyzer

### Mode B: Weekly Asset Generation
Calls 5 sub-skills: performance-analyzer -> wedge-generator -> asset-factory -> culture-adapter -> integration-orchestrator

### Mode C: Performance Analysis
Calls 2-3 sub-skills: performance-analyzer -> campaign-strategist -> wedge-generator (if pivot needed)

### Mode D: One-Off Tasks
Routes directly to a single sub-skill based on task type:
- "Validate signals" -> signal-detector
- "Generate wedge" -> wedge-generator
- "Calculate DSI" -> dsi-calculator
- "Build lead magnet" -> lead-magnet-builder
- "Adapt for MENA" -> culture-adapter
- "Deploy to GHL" -> integration-orchestrator

---

## Hard Stop Rules

**CRITICAL**: Before ANY execution, validate these non-negotiable rules:

1. **Fit = FAIL -> No Outreach**: If prospect fails ICP Fit criteria, STOP immediately. Do not generate assets.
2. **Signal Age > 90 Days -> Exclude**: Signals older than 90 days are stale. Skip them.
3. **Cannot Name Signal in One Sentence -> Skip**: If you cannot articulate the signal clearly in one sentence, it is not actionable.
4. **Intent > Trust (Priority Rule)**: When both Trust AND Intent signals are present, Intent takes priority for wedge generation.

For detailed validation logic, scoring criteria, and quality gates, see **scoring-rubrics.md**.

---

## Output Formats (Summary)

Each execution mode produces specific deliverables:

- **Mode A (New Campaign)**: Campaign brief, asset folder (emails, LinkedIn, WhatsApp, VSLs, social posts), lead magnet, landing page, GHL/Instantly/HeyReach deployment configs, performance tracking baseline
- **Mode B (Weekly Assets)**: Weekly asset bundle with performance context, refined wedges, updated deployment configs
- **Mode C (Performance Analysis)**: Performance report with metrics, pattern discovery, pivot recommendations (Double Down / Pivot / Hybrid)
- **Mode D (One-Off)**: Sub-skill-specific output

For complete output templates, folder structures, and worked examples, see **templates.md**.

---

## Framework Knowledge Base

The skill references these knowledge files (located in `references/`):

### 1. signal-hierarchy.md
Complete taxonomy: **Fit -> Trigger -> Signal Type (Trust/Intent) -> Signal Subtype -> Wedge**

**Critical distinctions:**
- **Fit** = ICP criteria (company size, geography, industry) -> NOT used for wedges
- **Trigger** = Timing/event (funding, hiring, expansion) -> NOT used for wedges
- **Trust Signal** = Community, authority, visibility behaviors -> CAN be used for wedges
- **Intent Signal** = Active buying behaviors -> PRIORITIZED for wedges

### 2. 7-silence-types.md
The complete taxonomy:
1. **Positioning Silence**: They don't understand what you solve
2. **Proof Silence**: They don't believe you can deliver
3. **Objection Silence**: They have unaddressed concerns
4. **Channel Silence**: They're on wrong platform for your message
5. **Step Silence**: Your process is unclear/overwhelming
6. **Response Silence**: You're not responding fast enough
7. **Friction Silence**: Too many barriers to take action

Each silence type maps to specific DSI scoring dimensions and lead magnet types.

### 3. wedge-sentence-map.md
ICP-specific wedge templates. **Template**: "[Observed Signal] is costing you [Specific Outcome]. Here's the [One-Line Solution]."

### 4. hard-stop-rules.md
Non-negotiable enforcement rules. See also scoring-rubrics.md for detailed validation logic.

### 5. culture-map-framework.md
Erin Meyer's 8 dimensions applied to GTM messaging across MENA, US, and Germany markets.

### 6. battle-cards/ Folder
Proven templates from previous campaigns: email subject lines, LinkedIn openers, WhatsApp psychology variants, VSL hooks, objection handling scripts.

---

## Conclusion

This meta skill orchestrates the entire Signal-to-Trust GTM framework, coordinating 10 specialized sub-skills to transform observed signals into complete multi-channel campaigns with performance tracking and continuous improvement.

**Key principles:**
1. **Always start with the questionnaire** (12 questions determine execution path)
2. **Enforce hard stop rules** (Fit=Fail, Signal>90d, one-sentence test, Intent>Trust)
3. **Derive hierarchically** (Q->M->W->D domino alignment)
4. **Track and evolve** (performance loop -> template refinement -> signal discovery)
5. **Adapt culturally** (MENA != US != Germany messaging)
6. **Integrate fully** (GHL/Instantly/HeyReach deployment-ready)

The framework is self-improving: every campaign generates data, every data point refines templates, every pattern discovered expands the signal library.
