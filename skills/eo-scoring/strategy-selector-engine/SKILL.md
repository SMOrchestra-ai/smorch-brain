<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: strategy-selector-engine
description: Scorecard 4 of 5 — Maps founders to strategy paths and archetypes based on founder DNA, market conditions, and resources.
version: "2.0"
---

# SKILL: Strategy Selector Engine

**Version:** 2.0
**Created:** 2026-03-06
**Input Sources:** SC1 (Project Definition) + SC2 (ICP Clarity) + SC3 (Market Attractiveness)
**Output File:** `strategy-recommendation.md`
**Execution Model:** AI-driven strategic recommendation based on upstream data

---

## 1. STRATEGIC PURPOSE

Strategy Selector synthesizes data from Scorecards 1-3 to recommend the optimal strategy path for the next 90 days. It answers: "Given my market, my ICP, my positioning, and my resources—what is the BEST way to validate and grow?"

**Philosophy:** No one-size-fits-all strategy. The right strategy depends on market conditions, founder resources, and ICP fit.

**Four Strategy Paths:**
1. **Replicate & Localize:** Take proven global product; adapt for specific MENA market/ICP
2. **Consulting-First SaaS:** Sell consulting/services first; transition to productized SaaS
3. **Boring Micro-SaaS:** Build minimal product; charge money immediately; optimize for unit economics
4. **Hammering Deep:** Go vertical/deep in one niche; own it completely before expanding

**Read more:** See `references/strategy-paths.md` for detailed path descriptions, 90-day roadmaps, and 30-day experiments.

---

## 2. PREREQUISITES

This scorecard requires completed data from Scorecards 1-3:
- **SC1 (Project Definition):** Niche, positioning, geography, product scope
- **SC2 (ICP Clarity):** ICP profile, pain statements, congregation points, budget range, buying behavior
- **SC3 (Market Attractiveness):** Pain intensity, purchasing power, accessibility, growth signals

**Pre-Admin Checklist:**
- Verify all three upstream scorecards are complete
- Load all data into recommendation engine
- If any scorecard <40 (RESET band), warn founder: "Upstream assessment shows significant gaps. Recommendation may suggest revisiting that scorecard."

---

## 3. SECTION ARCHITECTURE

| Section | Points | Focus | Scoring Model |
|---------|--------|-------|---|
| **A. Founder-Strategy Alignment** | 20 | Skills, capital, time, risk tolerance | MC (deterministic) |
| **B. Market-Strategy Fit** | 25 | MAS data + strategy path match | 4 AI-auto questions + 1 FT |
| **C. ICP-Strategy Fit** | 25 | ICP behavior + strategy path alignment | 4 AI-auto questions + 1 FT |
| **D. Execution Readiness** | 20 | Can founder execute recommended path | 4 path-specific MC questions |
| **E. MENA Strategy Fit** | 10 | Geographic/cultural alignment | 2 AI-auto questions |
| **TOTAL** | **100** | | |

**Output:** Recommended primary path + secondary path + 90-day roadmap + archetype classification

---

## 4. PATTERN OF INACTION CHECK (Early Detection)

**Activation Criteria (Before Section A):**

Ask: Does the founder show EITHER of these signals?

1. **Idea >6 months old with NO customer-facing launch** (landing page, MVP, consulting client, first sale)
2. **SC1-SC3 all >70 pts BUT zero customer conversations, commitments, or revenue**

**If Pattern Detected:**

Trigger **72-Hour Validation Sprint** (not full SC4):

| Action | Timeline | Objective |
|---|---|---|
| Pause SC4 | Now | Founder must prove execution capacity |
| Activate Sprint | Next 3 days | Pick ONE: 10 customer interviews OR 1 paying consulting client OR 10 pre-signups |
| Re-Enter SC4 | Day 4 | With proof of execution, complete strategy recommendation with higher confidence |

**Messaging:** "Your analysis is strong. Now validate with real people. Pick ONE test above; do it in 72 hours. This proves execution. Then we recommend your strategy."

**Rationale:** High scorecards + inaction = analysis paralysis. A 3-day sprint builds momentum, proves execution capacity, and provides real market data to inform strategy selection.

---

## 5. QUESTION BANK & SCORING

**Reference:** See `references/question-bank.md` for complete question inventory with all scoring rubrics.

### Section A: Founder-Strategy Alignment (20 pts)

**A1-A4:** Multiple choice (deterministic scoring)
- A1: Core skill (5 pts)
- A2: Available capital (5 pts)
- A3: Time commitment (5 pts)
- A4: Risk tolerance (5 pts)

### Sections B-E: AI-Auto Questions + Free-Text

**B1-B4 (Market Fit):** Pull MAS data; generate 4 alignment questions (16 pts)
**B5 (Hypothesis):** Free-text strategy choice + reasoning (9 pts)

**C1-C4 (ICP Fit):** Pull ICP data from SC2; generate 4 alignment questions (16 pts)
**C5 (Synthesis):** Free-text synthesis of ICP behavior + strategy alignment (9 pts)

**D1-D4 (Execution Readiness):** Path-specific questions based on B5 selection (20 pts)

**E1-E2 (MENA Fit):** Geographic/cultural alignment questions (10 pts)

---

## 6. OVERALL SCORE & READINESS

**Scoring Formula:**
```
Total = A (0-20) + B (0-25) + C (0-25) + D (0-20) + E (0-10) = 0-100
```

**Readiness Score (Different from Section Total):**
```
Readiness = (MAS Score × 0.35) + (ICP Clarity Score × 0.35) + (GTM Potential × 0.30)
```

| Readiness | Assessment | Meaning |
|-----------|-----------|---------|
| 80-100 | READY | Strong execution confidence; move to GTM immediately |
| 60-79 | CONFIDENT | Good foundation; execution readiness strong; minor gaps |
| 40-59 | CAUTIOUS | Some gaps; either market/ICP unclear OR execution weak |
| 20-39 | UNCERTAIN | Significant gaps; validate before executing strategy |
| 0-19 | NOT READY | Major gaps; return to foundational scorecards |

---

## 7. STRATEGY PATH RECOMMENDATION ENGINE

**Primary Path Selection Logic:**

1. **If B5 + C5 agree on path (strong alignment):**
   - Award primary path with confidence level
   - Secondary path = next-best fit

2. **If B5 ≠ C5 (misalignment):**
   - Surface contradiction to founder
   - Recommend: "Market analysis suggests [Path A] but ICP analysis suggests [Path B]. Which takes priority?"

3. **If either B5 or C5 <5 pts (weak reasoning):**
   - Surface as concern: "Your strategy choice isn't strongly grounded. Re-evaluate using [specific data]."

---

## 8. ARCHETYPE CLASSIFICATION & POSITIONING

**System classifies founder into 1 of 8 archetypes based on strategy choice + founder profile:**

1. **Launcher** (Ambitious + Resources) → Replicate & Localize
2. **Market Hunter** (Sales-Focused) → Consulting-First SaaS
3. **Channel Seeker** (Distribution Advantage) → Boring Micro-SaaS
4. **Solution Seeker** (Product-Focused) → Hammering Deep
5. **Expert Without a Stage** (Domain Expertise, No Platform) → Consulting-First SaaS
6. **Ghost** (Stealth, Unknown) → Boring Micro-SaaS
7. **Operator** (Operations-Focused) → Replicate & Localize
8. **Scrambler** (Early-Stage, Figuring It Out) → Consulting-First SaaS

**Read more:** See `references/archetypes.md` for detailed archetype profiles, coaching strategies, and Attractive Character positioning.

---

## 9. ATTRACTIVE CHARACTER MAPPING

Each strategy path maps to a specific character archetype (Russell Brunson):

| Strategy Path | Character | Brand Voice |
|---|---|---|
| **Replicate & Localize** | Reporter | "I discovered something working elsewhere; let me bring it here" |
| **Consulting-First SaaS** | Leader | "I've solved this at scale; follow my system" |
| **Boring Micro-SaaS** | Reluctant Hero | "I never wanted to build this, but the market needed it" |
| **Hammering Deep** | Adventurer | "I'm going deeper than anyone; come with me" |

**Character selection feeds:** `brand-voice.md` for SC5 (GTM) and content strategy development.

---

## 10. 30-DAY VALIDATION EXPERIMENTS

Each path includes a path-specific 30-day experiment to validate core hypothesis before full 90-day execution:

**REPLICATE & LOCALIZE:** Validate local pain exists (10 interviews + landing page)
**CONSULTING-FIRST SAAS:** Close 3 consulting clients (50 outreach + 15 conversations)
**BORING MICRO-SAAS:** Get 5 pre-pays in 14 days (landing page + paid acquisition test)
**HAMMERING DEEP:** Publish 10 authority pieces + close 1 pilot customer

**Read more:** See `references/strategy-paths.md` for detailed Build-Measure-Learn specifications for each path.

---

## 11. OUTPUT FILE: strategy-recommendation.md

**Automatically generated with all sections populated:**

- Strategy Selector Score (/100)
- Readiness Score (formula-based)
- Recommended Primary Path (+ reasoning)
- Secondary Path (+ trigger conditions for switching)
- Founder Archetype Classification
- Attractive Character Positioning
- 30-Day Validation Experiment (path-specific)
- Top 5 Bottleneck Analysis (cross-pillar)
- 90-Day Strategic Roadmap (month-by-month)
- Movement Brief (founder's larger purpose)
- Re-Assessment Triggers

**Read more:** See `references/output-template.md` for complete output structure and variable fields.

---

## 12. CONTENT-TO-PAID PIPELINE (12-Month Horizon)

Each path monetizes differently across 4 phases (Months 1-12):

**Phase 1 (Months 1-3):** Free Education — Build trust & authority
**Phase 2 (Months 4-6):** Lead Magnets — Identify warm leads ready to transact
**Phase 3 (Months 7-9):** Paid Transaction — Monetize (consulting, SaaS, training)
**Phase 4 (Months 10-12):** Premium/Retainer — Scale to high-value recurring revenue

**Read more:** See `references/strategy-paths.md` for path-specific Phase 1-4 implementation details.

---

## 13. PORTFOLIO VS. SINGLE PRODUCT FRAMEWORK

For **Boring Micro-SaaS** or **Hammering Deep** founders who demonstrate strong traction:

**Portfolio Opportunity** becomes viable if all 3 conditions met:
1. Product 1 requires <2 hrs/week active time (self-serve, minimal maintenance)
2. Adjacent ICP pain identified in SC2 (Product 2 opportunity exists)
3. Technical skill allows Product 2 MVP in <4 weeks

**Compounding revenue example:** Product 1 ($500→$1500/mo) → Products 2+3 launch alongside → $5000+/mo by Month 12 (vs single product plateau at $2500).

**Read more:** See `references/archetypes.md` (Portfolio section) for conditions, override triggers, and post-validation assessment logic.

---

## EXECUTION CHECKLIST

### Phase 1: Load Upstream Data
- [ ] Retrieve SC1, SC2, SC3 scores; confirm all >= 40 band (else pause and flag gaps)
- [ ] Load niche, positioning, ICP, pain statements, congregation, market growth signals
- [ ] Display summary: "Your market shows [tailwind level], ICP is [clarity level], strategy fit is [path match]"

### Phase 2: Pattern of Inaction Detection
- [ ] Ask: "How long has this idea been in development?" and "What have you shipped/sold so far?"
- [ ] TRIGGER: If idea > 6 months old AND zero customer-facing launch (MVP, landing page, 1st sale, consulting client)
  - Activate **72-Hour Validation Sprint** (see Section 4 description)
  - Pause SC4; ask founder to pick ONE: 10 interviews OR 1 paying client OR 10 pre-signups
  - Re-enter SC4 after proof of execution
- [ ] If no inaction pattern → Continue to Phase 3

### Phase 3: Administer Sections A-E
- [ ] **Section A (Founder-Strategy Alignment):** 4 MC questions (deterministic) (5 min)
  - A1-A4: Core skill, capital, time, risk tolerance
  - No interpretation needed; tally answers for section score
- [ ] **Section B (Market-Strategy Fit):** 4 AI-auto questions + 1 free-text (10 min)
  - B1-B4 generated from SC3 data; pull pain intensity, purchasing power, accessibility, growth
  - B5: Ask free-text: "Based on market signals, which strategy makes most sense? Why?"
  - DECISION: If B5 poorly reasoned (< 5 pts) → Surface concern; ask for evidence
- [ ] **Section C (ICP-Strategy Fit):** 4 AI-auto questions + 1 free-text (10 min)
  - C1-C4 generated from SC2 data; pull ICP identity, pain urgency, hero journey, buying behavior
  - C5: Ask free-text: "How does this ICP's behavior shape strategy? What does your customer need from you?"
  - DECISION: If C5 scoring differs from B5 → Surface contradiction; ask which takes priority
- [ ] **Section D (Execution Readiness):** Path-specific 4 MC questions (5 min)
  - Questions determined by B5 path selection
  - Assess founder's ability to execute recommended path
- [ ] **Section E (MENA Strategy Fit):** 2 AI-auto questions (5 min)
  - Geographic/cultural alignment with recommended path
  - Language strategy, payment method, sales cycle, seasonal factors

### Phase 4: Determine Primary + Secondary Path
- [ ] Calculate strategy recommendation score (A + B + C + D + E = 0-100)
- [ ] Compare B5 vs. C5 alignment:
  - If **agree on path** → Award with confidence; secondary = next-best fit
  - If **disagree on path** → Surface contradiction; ask founder to reconcile
- [ ] Assign archetype (from references/archetypes.md) based on strategy path + founder profile
- [ ] Calculate Readiness Score formula: (MAS × 0.35) + (ICP Clarity × 0.35) + (GTM Potential × 0.30)

### Phase 5: Output Generation
- [ ] Generate strategy-recommendation.md using references/output-template.md
- [ ] Populate: primary path, secondary path, founder archetype, 30-day validation experiment, 90-day roadmap
- [ ] Include: "Why This Path" explanation + character positioning (Reporter/Leader/Reluctant Hero/Adventurer)
- [ ] Include: Top 5 bottleneck analysis + movement brief

### Phase 6: Handoff
- [ ] Display overall score + Readiness Score + recommended path + archetype
- [ ] Present 30-day validation experiment (path-specific)
- [ ] Confirm: "SC4 complete ([score]/100). Readiness: [level]. Ready for SC5: GTM Fitness. Run /eo-score 5"
- [ ] If Readiness < 60 → "Recommend refining [identified gaps] before SC5. Offer re-assessment."

---

## 15. NOTES FOR DEVELOPERS

- Section A questions are deterministic MC (no interpretation)
- Sections B, C, E use AI auto-generation from upstream data
- Section D questions are path-specific (system determines path from B5)
- Output includes explicit "Why This Path" explanation for founder education
- Readiness Score formula can be adjusted based on weighting research
- All reference files in `references/` are authoritative sources for detailed content

---

**END OF SKILL.MD**

**References Directory:**
- `references/question-bank.md` — All questions with scoring rubrics (Sections A-E)
- `references/strategy-paths.md` — Path descriptions, 90-day roadmaps, 30-day experiments
- `references/archetypes.md` — 8 archetypes with coaching strategies and character mapping
- `references/output-template.md` — strategy-recommendation.md output file template
