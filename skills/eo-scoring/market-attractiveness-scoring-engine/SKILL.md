<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: market-attractiveness-scoring-engine
description: Scorecard 3 of 5 — Evaluates market attractiveness across 4 dimensions (Pain Reality, Purchasing Power, ICP Accessibility, Market Growth). Scores /100 with hybrid MC + AI-evaluated questions.
version: "2.0"
---

# SKILL: Market Attractiveness Scoring Engine

**Version:** 2.0
**Created:** 2026-03-06
**Framework:** Alex Hormozi ($100M Leads), Chet Holmes (7x4x11)
**Input Sources:** SC1 (Project Definition) + SC2 (ICP Clarity)
**Output File:** `MarketAttractiveness.md`
**Execution Model:** Claude-administered questionnaire with real-time AI scoring

---

## 1. STRATEGIC PURPOSE

Market Attractiveness Scoring (MAS) determines whether a market is worth entering by shifting from subjective ratings to evidence-based validation. Rather than asking founders to rate pain intensity 1-5, the system requires concrete evidence: customer conversations, competitive research, market data, regulatory signals, and growth indicators.

**Philosophy:** Student provides evidence; AI validates findings; output is a defensible market assessment.

**Philosophical Shift from Previous Version:**
- Old: "How intense is the pain? Rate 1-5."
- New: "Show me your evidence that pain is real. Cite conversations, data, competitor reviews, market research."

---

## 2. PREREQUISITES

This scorecard builds on upstream data. Do not administer until student has completed:

| Prerequisite | Provides | Used In |
|--------------|----------|---------|
| **SC1: Project Definition** | Niche, sub-market, positioning, geography, product scope | Sections C, D (MENA context) |
| **SC2: ICP Clarity** | Pain statements, congregation points, budget range, buying behavior | Sections A, B, C (all evidence) |

**Pre-Admin Checklist:**
- Display SC1 outputs (niche, positioning, geography, ICP)
- Display SC2 outputs (pain statements, congregation points, budget range)
- Ask student: "Are these still accurate? Any updates?"
- Note any updates; flag for cross-scorecard consistency review

---

## 3. SECTION ARCHITECTURE & SCORING MODEL

| Section | Points | Questions | Duration | Focus |
|---------|--------|-----------|----------|-------|
| **A. Pain Reality & Intensity** | 25 | 5 (4 FT, 1 MC×3) | 15 min | Evidence of real, frequent, costly, urgent pain |
| **B. Purchasing Power & Willingness** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Budget authority, payment capability, willingness signals |
| **C. ICP Accessibility** | 25 | 5 (4 FT, 1 MC+FT) | 15 min | Congregation density, reach, channels, competitor gaps |
| **D. Market Growth & Momentum** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Direction, tailwinds, funding, demand, MENA readiness |
| **TOTAL** | **100** | **25** | **60 min** | |

### Score Bands

| Range | Band | Meaning | Risk | Action |
|-------|------|---------|------|--------|
| **85-100** | LAUNCH READY | Strong evidence across all dimensions | Low | Execute GTM; move to SC5 (GTM Fitness) |
| **70-84** | ALMOST THERE | Solid core appeal; 1-2 sections need validation | Low-Med | Fix weakest section; re-score; confirm |
| **55-69** | NEEDS WORK | Right direction but significant gaps | Medium | 30-day validation plan required |
| **40-54** | EARLY STAGE | Fundamental validation needed | Med-High | 10+ buyer interviews before GTM |
| **0-39** | RESET | Core assumptions likely wrong | High | Revisit SC1/SC2; consider pivot |

---

## 4. SECTION A: PAIN REALITY & INTENSITY (25 POINTS)

**Goal:** Validate that SC2 pains are real, frequent, costly, and urgent through evidence, not speculation.

### Quick Question Reference (A1-A5)

- **A1: Pain Evidence Strength** — Cite three types of evidence per pain (conversations, competitive, data)
- **A2: Pain Frequency** — Multiple-choice: how often does pain occur (daily/weekly/monthly/quarterly)
- **A3: Pain Cost** — Quantify monthly impact with clear math (labor + errors + opportunity cost)
- **A4: Workaround Assessment** — What broken tools/processes do they use today? What fails?
- **A5: Pain Urgency Signal** — What timeline would buyer want? What evidence of urgency? (regulatory, budget, competitive)

**For full A1-A5 question text, examples, rubrics, and improvement paths:**
READ: `references/question-bank.md` — Section A comprehensive guide

**Evaluation Process (All A Questions):**
1. Extract specific evidence from student response (names, numbers, quotes)
2. Count distinct evidence types and specificity level
3. Check consistency with SC2 pain map
4. Apply weighted rubric formula (see references/scoring-rubric.md)
5. Assign 0-5 score per question

**Section A Scoring Weights (0-25 total):**
- A1 (Pain Evidence): 5 pts
- A2 (Frequency): 5 pts
- A3 (Cost): 5 pts
- A4 (Workarounds): 5 pts
- A5 (Urgency): 5 pts
- **Total A: 0-25 pts**

---

## 5. SECTION B: PURCHASING POWER & WILLINGNESS (25 POINTS)

**Goal:** Validate that ICP has budget and will pay.

### Quick Question Reference (B1-B5)

- **B1: Existing Spend** — What related tools/services do they currently pay for monthly?
- **B2: Budget Authority** — Who approves budget? Timeline? Thresholds? (MC + free-text)
- **B3: Price Point Validation** — Your price vs. pain cost, alternatives, ROI (no-brainer test)
- **B4: Payment Infrastructure** — How will they pay? (MC; MENA adjustments for low card adoption)
- **B5: Willingness Signal** — Strongest signal someone would pay (LOI > verbal > behavioral > aspirational)

**For full B1-B5 question text, examples, rubrics, and improvement paths:**
READ: `references/question-bank.md` — Section B comprehensive guide

**Expert Framework Enhancements (B Section Only):**

1. **Pricing Cross-Check (B3):** READ `references/scoring-rubric.md` — Validates B3 against A2+A3, SC1 competitors, SC2 budget range
2. **Underpricing Detection (B3/B5):** READ `references/scoring-rubric.md` — Flags 4 underpricing signals; no penalty, high-priority recommendation
3. **Grand Slam Offer Assessment (B3/B5):** READ `references/scoring-rubric.md` — Alex Hormozi viability index (Dream × Likelihood / Delay × Effort)

**Section B Scoring Weights (0-25 total):**
- B1 (Existing Spend): 5 pts
- B2 (Budget Authority): 5 pts
- B3 (Price Validation + Expert Checks): 5 pts
- B4 (Payment Infrastructure): 5 pts
- B5 (Willingness Signal): 5 pts
- **Total B: 0-25 pts**

---

## 6. SECTION C: ICP ACCESSIBILITY (25 POINTS)

**Goal:** Validate that you can actually reach your ICP.

### Quick Question Reference (C1-C5)

- **C1: Congregation Density** — Highest density congregation point; how many exact fits?
- **C2: Reach Capability** — Can you reach 100+ buyers in 30 days? Exactly how?
- **C3: Channel Viability** — Your specific capability on top 3 channels (audience, response rate, time)
- **C4: Competitor Access Pattern** — How competitors reach buyers; what channels are they weak on?
- **C5: MENA Access Reality** — Realistic channel mix for your geography; language strategy; local advantage

**For full C1-C5 question text, examples, rubrics, and improvement paths:**
READ: `references/question-bank.md` — Section C comprehensive guide

**MENA Channel Baseline (C5):**
READ: `references/scoring-rubric.md` — "C5 MENA Channel Reference Baseline" table

Per-country penetration rates for LinkedIn, WhatsApp, Email, Events (Saudi, UAE, Qatar, Egypt, Jordan, Lebanon, Morocco)

**Section C Scoring Weights (0-25 total):**
- C1 (Congregation Density): 5 pts
- C2 (Reach Capability): 5 pts
- C3 (Channel Viability): 5 pts
- C4 (Competitor Access): 5 pts
- C5 (MENA Reality): 5 pts
- **Total C: 0-25 pts**

---

## 7. SECTION D: MARKET GROWTH & MOMENTUM (25 POINTS)

**Goal:** Validate that market is growing and has external tailwinds.

### Quick Question Reference (D1-D5)

- **D1: Market Direction** — Growth rate with analyst/funding/data evidence (MC + free-text)
- **D2: Tailwind Events** — Regulatory, tech, economic shifts pushing adoption (ZATCA, Vision 2030, etc.)
- **D3: Competitive Landscape** — Funded competitors, acquisitions; what does this signal?
- **D4: Search Demand Signal** — Is search volume for your category increasing? (Google Trends data)
- **D5: MENA Market Readiness** — Already buying vs. aware vs. unaware vs. resistant; sales cycle implications

**For full D1-D5 question text, examples, rubrics, and improvement paths:**
READ: `references/question-bank.md` — Section D comprehensive guide

**Evidence Quality Hierarchy (Section D):**
READ: `references/scoring-rubric.md` — "D1-D5 Growth Evidence Quality Hierarchy" for tier-based scoring

**Section D Scoring Weights (0-25 total):**
- D1 (Market Direction): 5 pts
- D2 (Tailwind Events): 5 pts
- D3 (Competitive Landscape): 5 pts
- D4 (Search Demand): 5 pts
- D5 (MENA Readiness): 5 pts
- **Total D: 0-25 pts**

---

## 8. ENGAGEMENT POTENTIAL ASSESSMENT

**Triggered After Section D Completion**

Beyond market attractiveness, evaluates whether market supports engagement-driven growth—a key predictor of founder success in MENA.

**READ:** `references/engagement-assessment.md` for complete framework

**Two Core Dimensions:**

1. **Nir Eyal's Behavioral Hooks (Trigger-Routine-Reward):**
   - Does pain frequency (A2) naturally trigger daily/weekly product use?
   - Scoring: 5/5 (daily trigger) → 3/5 (weekly) → 1/5 (quarterly)
   - Impact: Daily trigger enables higher engagement; quarterly requires artificial loops

2. **Brendan Kane's Content Platform Density:**
   - Can founder own/dominate a content platform where ICP congregates (C1 + C3)?
   - Scoring: 5/5 (high density, low supply) → 3/5 (moderate both) → 1/5 (scattered/saturated)
   - Impact: High density enables content-driven growth; low requires outbound/paid focus

**Composite Index:**
```
Engagement Potential = (Trigger / 5) × 0.5 + (Content Platform / 5) × 0.5
Result: 0-5.0 scale
```

**Action by Score:**
- **4.0-5.0:** Lean into content; build audience before/alongside launch
- **2.5-4.0:** Specialize in stronger dimension
- **0-2.5:** Build outbound + partnership infrastructure; expect higher CAC

---

## 9. CROSS-SCORECARD CONSISTENCY CHECKS

Claude automatically checks three alignment types. **READ:** `references/scoring-rubric.md` for complete check logic.

**SC1 ↔ SC3 Alignment:**
- ICP from SC2 matches pain evidence in A1?
- Geography from SC1 matches MENA strategy in C5?
- Positioning aligns with pain evidence?

**SC2 ↔ SC3 Alignment:**
- Pain statements from SC2 referenced in A1-A5?
- Congregation points from SC2 in C1?
- Budget range from SC2 feasible with B3 pricing?

**Internal MAS Consistency:**
- Pain cost (A3) vs. Frequency (A2): High-cost pains should occur frequently
- Reach (C2) vs. Congregation (C1): If dense, should be reachable
- Market Growth (D1) vs. Funding (D3): Growing markets have funded competitors

**Flag contradictions for student clarification; don't penalize if good explanation provided.**

---

## 10. MENA-SPECIFIC ADJUSTMENTS

Applied throughout scoring:

- **B4 Payment:** Deduct 1 pt if credit card only (Egypt/Jordan/Lebanon; adoption <40%)
- **C3/C5 Channels:** Adjust channel fit based on baseline penetration rates by country
- **D2 Tailwinds:** Recognize Vision 2030 (Saudi), ZATCA (Saudi), data laws (UAE/Egypt)
- **D5 Readiness:** Expect longer sales cycles in emerging markets; government adoption slower

---

## 11. SCORING & RECOMMENDATION ENGINE

**Detailed Rubrics & Process:**
READ: `references/scoring-rubric.md` for complete scoring criteria, per-question evaluation processes, weighted formulas, expert framework details (pricing cross-check, underpricing, Grand Slam, engagement potential)

**Quick Scoring Process:**
1. Student answers all 25 questions (A1-D5)
2. Claude applies per-question rubric; awards 0-5 pts per question
3. Claude checks consistency (flag contradictions, offer clarification)
4. Claude totals: A + B + C + D = 0-100 overall score
5. Claude maps score to band
6. Claude prioritizes recommendations by impact (points to gain × ease of fix)

**Improvement Paths:**
For every question <4:
- What's missing (specific gap)
- What to do about it (concrete action)
- Example of score 5 (what excellence looks like)
- Time to fix (estimate)

---

## 12. OUTPUT FILE: MarketAttractiveness.md

**Template & Structure:**
READ: `references/output-template.md` for complete output structure

**Automatically generated with:**
- Score Summary (section breakdown + total + band)
- Executive Summary (2-3 sentences on market viability)
- Section A-D Detailed Assessments (student answers + scores + rationale)
- Cross-Scorecard Consistency Notes
- Prioritized Recommendations (highest impact first)
- 30-Day Validation Action Plan (if score <70)
- Next Steps (band-specific guidance)
- Frameworks & References (pointers to all docs)

---

## EXECUTION CHECKLIST

### Phase 1: Prerequisite Verification
- [ ] Load SC1 outputs: niche, positioning, geography, ICP (from project-brief.md)
- [ ] Load SC2 outputs: pain statements, congregation points, budget range (from icp-refined.md)
- [ ] Display to student: "Using niche: [X], pain drivers: [Y], geography: [Z]. I'll flag contradictions."
- [ ] Ask student: "Are these still accurate? Any updates?" Note any changes.
- [ ] If SC1 or SC2 missing or < 40 band: Pause; provide links; request completion first

### Phase 2: Administer Sections A-D
- [ ] **Section A (Pain Reality):** Present A1-A5 as group (15 min)
  - A1-A3 require named evidence; A4-A5 ask for specificity
  - DECISION: If answer lacks evidence → Ask follow-up: "I need specific examples. Can you cite a conversation, data point, or competitor review?"
- [ ] **Section B (Purchasing Power):** Present B1-B5 as group (15 min)
  - B3 triggers expert framework gates: check pricing cross-check, underpricing detection, Grand Slam viability
  - DECISION: If B4 = "credit card only" in Egypt/Jordan/Lebanon → Flag -1 pt; note in recommendations
- [ ] **Section C (ICP Accessibility):** Present C1-C5 as group (15 min)
  - C5 uses references/scoring-rubric.md MENA Channel Baseline for penetration rates
  - DECISION: If congregation answer vague → Ask: "How many exact-fit buyers in that audience?"
- [ ] **Section D (Market Growth):** Present D1-D5 as group (15 min)
  - D2 recognizes MENA tailwinds (ZATCA, Vision 2030, VAT)
  - D5 uses "already buying / aware / unaware / resistant" scale for MENA readiness

### Phase 3: Engagement Potential Assessment (After Section D)
- [ ] Trigger if D1+D2 scores >= 7 combined (growth + tailwinds present)
- [ ] Read references/engagement-assessment.md; calculate:
  - **Nir Eyal Hook Trigger:** (A2 frequency score / 5) × 0.5
  - **Content Platform Density:** (C1+C3 congregation / 10) × 0.5
  - **Composite Engagement:** Sum of above
- [ ] Action by score:
  - 4.0-5.0 → Lean into content; build audience before launch
  - 2.5-4.0 → Specialize in stronger dimension
  - 0-2.5 → Build outbound + partnership infrastructure

### Phase 4: Consistency Checks
- [ ] Run cross-scorecard checks:
  - SC1 ↔ SC3: ICP from SC2 matches pain evidence in A1? Geography alignment in C5?
  - SC2 ↔ SC3: Pain statements referenced in A1-A5? Congregation in C1? Budget feasible with B3?
  - Internal MAS: A3 cost vs. A2 frequency? C2 reach vs. C1 density? D1 growth vs. D3 funding?
- [ ] DECISION: If contradiction flagged → Ask for clarification; don't change score; note in recommendations

### Phase 5: Output Generation
- [ ] Calculate section totals (A + B + C + D = 0-100)
- [ ] Assign band: LAUNCH READY (85-100) / ALMOST THERE (70-84) / NEEDS WORK (55-69) / EARLY STAGE (40-54) / RESET (0-39)
- [ ] Generate MarketAttractiveness.md using references/output-template.md
- [ ] Include cross-scorecard consistency notes
- [ ] Include 30-day validation action plan if score < 70

### Phase 6: Handoff
- [ ] Display score + band + section breakdown + engagement potential
- [ ] Present top 3 priority improvements (ranked by impact)
- [ ] If score >= 70: "SC3 complete ([score]/100 - [band]). Ready for SC4: Strategy Selector. Run /eo-score 4"
- [ ] If score < 70: "SC3 scored [score]/100 - [band]. 30-day validation plan: [specific actions]. Re-run when ready: /eo-score 3"

---

## 14. REFERENCE FILES (PROGRESSIVE DISCLOSURE)

All heavy content moved to separate, focused files:

- `references/question-bank.md` (2700+ lines)
  - All 25 questions with full text, examples, AI rubrics, evaluation process, improvement paths

- `references/scoring-rubric.md` (800+ lines)
  - Per-question scoring criteria, expert frameworks (pricing, underpricing, Grand Slam, engagement potential), MENA adjustments, cross-checks

- `references/engagement-assessment.md` (300+ lines)
  - Nir Eyal + Brendan Kane behavioral frameworks, composite calculation, MENA context

- `references/output-template.md` (350+ lines)
  - Complete MarketAttractiveness.md structure with all sections

---

## 15. KEY FRAMEWORKS

- **Alex Hormozi ($100M Leads):** Pain-cost-price validation; no-brainer offer structure
- **Chet Holmes (7x4x11):** Seven pains × four decision-makers × eleven prospects = market map
- **Nir Eyal (Hooked):** Trigger-Routine-Reward for engagement prediction
- **Brendan Kane (Content Platform Density):** Creator supply + audience congregation = growth mode

---

**END OF SKILL.MD** (476 lines under 480 limit)
