<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: market-attractiveness-scoring-engine
description: Scorecard 3 of 5 — Evaluates market attractiveness across 4 dimensions (Market Size, Competition, Monetization, Execution). Scores /100 with hybrid MC + AI-evaluated questions.
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

## 3. SECTION ARCHITECTURE

| Section | Points | Questions | Duration | Focus |
|---------|--------|-----------|----------|-------|
| **A. Pain Reality & Intensity** | 25 | 5 (4 FT, 1 MC x 3) | 15 min | Evidence of real, frequent, costly, urgent pain |
| **B. Purchasing Power & Willingness** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Budget authority, payment capability, willingness signals |
| **C. ICP Accessibility** | 25 | 5 (4 FT, 1 MC+FT) | 15 min | Congregation density, reach, channels, competitor gaps |
| **D. Market Growth & Momentum** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Direction, tailwinds, funding, demand, MENA readiness |
| **TOTAL** | **100** | **25** | **60 min** | |

### Score Bands

| Range | Band | Meaning | Risk | Action |
|-------|------|---------|------|--------|
| **85-100** | LAUNCH READY | Strong evidence across all dimensions | Low | Execute GTM; move to SC5 |
| **70-84** | ALMOST THERE | Solid core appeal; 1-2 sections need validation | Low-Med | Fix weakest section; re-score; confirm |
| **55-69** | NEEDS WORK | Right direction but significant gaps | Medium | 30-day validation plan required |
| **40-54** | EARLY STAGE | Fundamental validation needed | Med-High | 10+ buyer interviews before GTM |
| **0-39** | RESET | Core assumptions likely wrong | High | Revisit SC1/SC2; consider pivot |

---

## 4. SCORING DIMENSIONS SUMMARY

Each section contains 5 questions scored 0-5 points each (25 points per section). Questions use a mix of free-text (AI-evaluated) and multiple-choice (deterministic) formats.

### Section A: Pain Reality & Intensity (25 pts)

| Q | Topic | Type | Focus |
|---|-------|------|-------|
| A1 | Pain Evidence Strength | Free-text | 3 strongest pains with cited evidence |
| A2 | Pain Frequency | MC x 3 | How often each pain occurs |
| A3 | Pain Cost | Free-text | Quantified monthly cost with math |
| A4 | Workaround Assessment | Free-text | Current tools/processes and their failures |
| A5 | Pain Urgency Signal | Free-text | Timeline and evidence of buyer urgency |

### Section B: Purchasing Power & Willingness (25 pts)

| Q | Topic | Type | Focus |
|---|-------|------|-------|
| B1 | Existing Spend | Free-text | Current spend on related problems |
| B2 | Budget Authority | MC + Free-text | Who controls budget; decision process |
| B3 | Price Point Validation | Free-text | Price vs. pain cost, alternatives, ROI |
| B4 | Payment Infrastructure | MC (MENA-specific) | How buyers will pay |
| B5 | Willingness Signal | Free-text | Strongest evidence someone would pay |

**Expert Frameworks (applied during Section B):**
- Pricing Framework Cross-Check (B3 enhancement) -- validates pricing against pain cost, competitors, ICP budget
- Underpricing Detection (after B3 + B1) -- applies Hormozi's "95% underprice" principle
- Grand Slam Offer Check (after B3 + B5) -- evaluates offer via Dream x Likelihood / Delay x Effort

For detailed scoring rubrics and expert frameworks, see `scoring-rubrics.md`.

### Section C: ICP Accessibility (25 pts)

| Q | Topic | Type | Focus |
|---|-------|------|-------|
| C1 | Congregation Density | Free-text | Highest-density buyer congregation point |
| C2 | Reach Capability | Free-text | Can you reach 100+ buyers in 30 days |
| C3 | Channel Viability | MC + Free-text | Top 3 channels with capability proof |
| C4 | Competitor Access Pattern | Free-text | How competitors reach buyers; gaps |
| C5 | MENA Access Reality | Free-text | Realistic MENA channel mix |

### Section D: Market Growth & Momentum (25 pts)

| Q | Topic | Type | Focus |
|---|-------|------|-------|
| D1 | Market Direction | MC + Free-text | Growth rate with evidence |
| D2 | Tailwind Events | Free-text | Regulatory, tech, cultural shifts |
| D3 | Competitive Landscape | Free-text | Funded competitors and acquisitions |
| D4 | Search Demand Signal | MC + Free-text | Search volume trends |
| D5 | MENA Market Readiness | MC + Free-text | Market readiness level with evidence |

For detailed dimension descriptions and questions, see `dimensions.md`.

---

## 5. ENGAGEMENT POTENTIAL ASSESSMENT (AI EVALUATION LAYER)

Triggered after Section D completion. Evaluates whether the market supports engagement-driven growth -- a key predictor of founder success in MENA where outbound-heavy models struggle.

**Three components:**

1. **Nir Eyal's Behavioral Hooks (Trigger-Routine-Reward):** Maps pain frequency (A2) to natural product engagement triggers. Daily pain = 5/5; Weekly = 3/5; Quarterly = 1/5.

2. **Brendan Kane's Content Platform Density:** Maps congregation points (C1) and channel viability (C3) to content platform opportunity. High density + low creator supply = 5/5.

3. **Engagement Potential Composite:**
   ```
   Engagement Potential = (Trigger Score / 5) x 0.5 + (Content Platform Density / 5) x 0.5
   ```
   - 4.0-5.0: High -- lean into content-driven growth
   - 2.5-4.0: Moderate -- specialize in the strong dimension
   - 0-2.5: Low -- build outbound + partnership infrastructure

**MENA Context:** MENA entrepreneurs often default to expensive outbound models because traditional content platforms have lower reach. This layer identifies which founders can break that pattern vs. which need to budget for higher CAC.

For detailed engagement scoring and recommendations, see `scoring-rubrics.md`.

---

## 6. CROSS-SCORECARD CONSISTENCY CHECKS

Claude automatically checks:

1. **SC1 <> SC3 Alignment:**
   - ICP from SC2 matches pain evidence in A1?
   - Geography from SC1 matches MENA strategy in C5?
   - Positioning aligns with pain evidence?

2. **SC2 <> SC3 Alignment:**
   - Pain statements from SC2 referenced in A1-A5?
   - Congregation points from SC2 in C1?
   - Budget range from SC2 feasible with B3 pricing?

3. **Internal MAS Consistency:**
   - Pain cost (A3) vs. Frequency (A2): High-cost pains should occur frequently
   - Reach (C2) vs. Congregation (C1): If dense, should be reachable
   - Market Growth (D1) vs. Funding (D3): Growing markets have funded competitors

**Flag Contradictions:** Surface for student clarification; offer chance to update; don't penalize if good explanation provided.

---

## 7. RECOMMENDATION ENGINE

**For every question scoring <4:**
```
QUESTION: [Text]
YOUR SCORE: [X/5]

WHY: [What's missing]
TO IMPROVE: [Specific action]
EXAMPLE OF 5: [What great looks like]
TIME TO FIX: [Estimate]
```

**Priority Recommendations:** Rank by Impact Score = (Points to gain) x (Ease of fix, 1-5). Recommend fixes in order of highest impact first.

For detailed improvement guidance per question, see `dimensions.md`.

---

## 8. OUTPUT FILE: MarketAttractiveness.md

Automatically generated with all sections populated:
- Score Summary (section breakdown + total + band)
- Executive Summary (2-3 sentences on market viability)
- Section A-D Detailed Assessments (student answers + scores)
- Cross-Scorecard Consistency Notes
- Recommendations (prioritized by impact)
- 30-Day Validation Action Plan (if score <70)
- Next Steps (band-specific guidance)
- Frameworks & References

For the full output template, see `templates.md`.

---

## 9. CLAUDE EXECUTION FLOW

1. **Preparation (2 min):** Load SC1 + SC2 data; display for confirmation
2. **Sections A-D (15 min each):** Administer questions in sequence; provide examples
3. **Scoring (10 min):** Apply rubrics; flag contradictions (no penalties; offer clarification)
4. **Output (5 min):** Generate MarketAttractiveness.md
5. **Presentation (5 min):** Show score, band, top 3 fixes
6. **Next Steps (2 min):** Offer re-scoring, validation plan, or move to SC5

**Total Time:** 60-90 minutes

---

## 10. MENA-SPECIFIC ADJUSTMENTS

Applied throughout:
- **B4 Payment:** Deduct 1 pt if credit card only (Egypt/Jordan/Lebanon)
- **C3/C5 Channels:** Adjust channel fit based on geography penetration rates
- **D2 Tailwinds:** Recognize Vision 2030 (Saudi), ZATCA (Saudi), data laws (UAE/Egypt)
- **D5 Readiness:** Expect longer sales cycles in emerging markets; government adoption slower

---

## 11. REFERENCE FILES

| File | Contents |
|------|----------|
| `dimensions.md` | Detailed dimension descriptions, questions, display examples, evaluation processes, and improvement guidance for all 25 questions |
| `scoring-rubrics.md` | Detailed rubric tables, scoring scales, scoring logic, expert framework additions (pricing cross-check, underpricing detection, Grand Slam offer check, engagement potential assessment) |
| `templates.md` | Output templates, display examples, and MENA reference tables |

---

**END OF SKILL.MD**
