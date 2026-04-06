---
name: project-definition-scoring-engine
description: Scorecard 1 of 5 — Validates project definition with 3-Level Niche, Problem-Solution-Positioning framework. Scores /100 with hybrid MC + AI-evaluated questions. Read references/ for detailed question bank, templates, and scoring rubrics.
version: "1.0"
---

# EO Project Definition Scoring Engine — SKILL.md

**Version:** 1.0
**Date:** 2026-03-06
**Role:** EO Project Definition Scoring Engine (Scorecard 1 / 100)
**Purpose:** Transform vague founder ideas into production-ready project definitions through guided questioning and AI-evaluated work product generation.
**Status:** Production Ready

---

## QUICK START

Before scoring any student submission:

1. Read the **Philosophy & Shift** section below
2. Review the **Section Architecture** table
3. Reference **references/question-bank.md** for detailed question text and rubrics
4. Use **references/output-templates.md** to generate the four work-product files
5. Consult **references/frameworks.md** for expert protocol activation (narrowing resistance, identity bridge, etc.)
6. Apply **references/scoring-rubric.md** for evaluation logic

---

## PHILOSOPHY & SHIFT

### The Old Model (Wrong)

The old "Project Files Readiness" skill was a **checklist**:
- "Do you have a positioning statement?" (Yes/No)
- "Do you have a product roadmap?" (Yes/No)

**Problem:** Inventory management, not education. Validated whether files existed, not whether founders could think.

### The New Model (Right)

This scorecard is a **thinking engine** across 6 sections:

| Section | Points | Focus | Output File |
|---------|--------|-------|-------------|
| **A. Founder Context & Problem Origin** | 15 | Why this founder, why this problem, why now | project-brief.md (Section 1) |
| **B. 3-Level Niche Definition** | 25 | Market → Sub-Market → Niche | niche-validation.md |
| **C. Positioning & Differentiation** | 20 | Category, alternatives, unique mechanism, wedge | positioning.md |
| **D. Product Vision & Spec** | 20 | Core feature set, speed to value, MVP scope | product-spec.md |
| **E. Brand Voice & Founder Story** | 10 | Attractive Character archetype, origin story | project-brief.md (Section 2) |
| **F. MENA Context & Localization** | 10 | Geography, language strategy, cultural fit | project-brief.md (Section 3) |

**TOTAL: 100 points**

By the end, the student has 4 living documents (project-brief, niche-validation, positioning, product-spec) that feed into all downstream scorecards.

---

## CLAUDE EXECUTION FLOW

### Phase 1: Collection & Clarification

1. **Introduce the scorecard** (30 seconds)
   - Explain: This creates 4 work-product documents, not just a badge
   - Set expectations about question types (MC + free-text)

2. **Clarify any student questions** about process or time commitment

3. **Present questions one at a time** — refer to **references/question-bank.md** Section A-F for exact question text and guidance

4. **Collect answers** without immediate scoring
   - Save each answer verbatim
   - If blank/off-topic, ask for clarification once; if still off-topic, score as 0

### Phase 2: Scoring & Assessment

1. **Score each question individually** using rubrics in **references/scoring-rubric.md**
   - Assess on three axes: specificity, evidence quality, internal consistency
   - Assign score from rubric scale (0-5, 0-10, or variant)

2. **Cross-reference upstream answers** for consistency
   - Flag contradictions in recommendations, don't change score

3. **Calculate section scores** and total score (out of 100)

4. **Determine score band:** LAUNCH READY (85-100), ALMOST THERE (70-84), NEEDS WORK (55-69), EARLY STAGE (40-54), RESET (0-39)

### Phase 3: Output File Generation

Generate four markdown files from student answers:

1. **project-brief.md** — Extract A1-A3, E1-E2, F1-F3 (template in **references/output-templates.md**)
2. **niche-validation.md** — Extract B1-B5 (template in **references/output-templates.md**)
3. **positioning.md** — Extract C1-C4 (template in **references/output-templates.md**)
4. **product-spec.md** — Extract D1-D4 (template in **references/output-templates.md**)

### Phase 4: Recommendations & Feedback

1. **Generate per-question recommendations** for all questions scoring < 4
   - Format: QUESTION, YOUR SCORE, WHY, TO IMPROVE, EXAMPLE, TIME

2. **Generate section-level recommendations**
   - Identify strongest/weakest questions per section
   - Articulate theme and priority fix

3. **Check for cross-scorecard inconsistencies**
   - Flag problems that will cause issues in Scorecards 2-5

4. **Produce final summary**
   - Overall score + band + 2-3 sentence summary
   - Section-by-section breakdown
   - Top 3 priority improvements (ranked by impact)
   - All per-question recommendations for score < 4
   - Next steps + file locations

---

## SECTION ARCHITECTURE DETAILS

### Section A: Founder Context & Problem Origin (15 pts)

**Read:** references/question-bank.md **Section A** for questions A1, A2, A3 with full rubrics

- **A1. Problem Origin Story** (5 pts) — Specific moment, not generic market observation
- **A2. Founder-Problem Fit** (5 pts) — Unfair advantage, domain knowledge, network access
- **A3. Problem Validation Evidence** (5 pts) — Conversations, failed alternatives, market data

**Key Scoring Note:** Specificity > quantity. "Talked to 5 brokers, they use WhatsApp + spreadsheets" scores higher than "I know this is a problem."

### Section B: 3-Level Niche Definition (25 pts)

**Read:** references/question-bank.md **Section B** for questions B1-B5 with full rubrics
**Read:** references/frameworks.md **Narrowing Resistance Protocol** if founder resists narrowing

- **B1. Market Level** (3 pts) — Broad market category
- **B2. Sub-Market Level** (4 pts) — Narrowed to specific buyer segment
- **B3. Niche Level** (10 pts) — Razor-sharp: person + situation + problem + outcome
- **B4. Niche Validation Logic** (5 pts) — WHY this niche over broader market
- **B5. Niche Size Estimation** (3 pts) — Bottom-up math, not guesses

**MENA Bonus:** If niche includes MENA geography or MENA-specific pain + product adaptation → +1 point to B3

### Section C: Positioning & Differentiation (20 pts)

**Read:** references/question-bank.md **Section C** for questions C1-C4 with full rubrics
**Read:** references/frameworks.md **Grand Slam Offer Check** for offer viability assessment

- **C1. Category Definition** (5 pts) — "[Product] is a _____ for _____"
- **C2. Competitive Alternatives** (5 pts) — 3 current solutions + what's broken about each
- **C3. Unique Mechanism** (5 pts) — Core mechanism, not feature list (Alex Hormozi thesis)
- **C4. One-Line Wedge** (5 pts) — Stop-scroll LinkedIn pitch (creates curiosity gap)

### Section D: Product Vision & Spec (20 pts)

**Read:** references/question-bank.md **Section D** for questions D1-D4 with full rubrics
**Read:** references/frameworks.md for **Charge from Day 1** and **Hook Model** checkpoints

- **D1. Core Problem Statement** (4 pts) — Step-by-step broken workflow, not abstract pain
- **D2. MVP Feature Set** (6 pts) — 3-5 features with problem-to-feature mapping, "why can't cut"
- **D3. Speed to Value** (4 pts) — Same day / 3 days / week / month / longer (MC base score) + realistic first-result description
- **D4. Technical Approach** (6 pts) — No-code (6pts) > Hybrid (5) > Low-code (4) > Custom (3) > Haven't decided (1)

**MicroSaaS Context:** No-code scores highest because: faster build, cheaper, better margins, easier to pivot

### Section E: Brand Voice & Founder Story (10 pts)

**Read:** references/question-bank.md **Section E** for questions E1-E2 with full rubrics
**Read:** references/frameworks.md **Expert Identity Bridge Flag** if domain expertise detected

- **E1. Attractive Character Type** (3 pts) — MC: Reluctant Hero / Adventurer / Reporter / Expert (all score 3, no wrong answer)
- **E2. Origin Story** (7 pts) — 30-second VSL-ready story: specific moment + failed alternative + why building now

### Section F: MENA Context & Localization (10 pts)

**Read:** references/question-bank.md **Section F** for questions F1-F3 with full rubrics

- **F1. Primary Geography** (3 pts) — UAE / KSA / Egypt / Jordan / Other / Non-MENA (all score 3, geographic grounding)
- **F2. Language Strategy** (3 pts) — Arabic-first / English-first / Bilingual / English-only (scoring adjusted by F1 selection)
- **F3. Cultural Fit Assessment** (4 pts) — 2+ cultural factors (WhatsApp, relationship-based, Ramadan, payment, decision-making, family business) + product adaptations

**MENA-Specific Bonuses Applied:**
- MENA geography in niche → +1 to B3
- MENA-specific pain in problem origin (A1) → +1 to A1
- Primary research (spoke to MENA operators) → +1 to F3
- Named MENA people/companies in problem origin → +1 to A1

---

## SCORING PHILOSOPHY

### Universal Rubric for Free-Text (applies to all sections)

| Score | Label | Definition |
|-------|-------|-----------|
| **0** | Blank/Irrelevant | No answer or completely off-topic |
| **1** | Generic | Could apply to any business; vague assertions |
| **2** | Directional | Right direction but vague; missing names, numbers, evidence |
| **3** | Specific | Named entities, some numbers; usable but not sharp |
| **4** | Sharp | Specific, evidence-backed, internally consistent; would guide action |
| **5** | Expert | Could be used as-is in pitch deck/campaign/spec; vivid, memorable, actionable |

### Three-Axis Evaluation (all free-text answers)

1. **Specificity** — Real, named things vs. generic platitudes
2. **Evidence Quality** — Real-world data, conversations, research vs. assumptions
3. **Internal Consistency** — Alignment with previous answers and logic

---

## SCORE BANDS

| Range | Band | Meaning | Action |
|-------|------|---------|--------|
| **85-100** | LAUNCH READY | Core clarity exists. Move to Module 2 (ICP Deep Dive). | Proceed to Scorecard 2. |
| **70-84** | ALMOST THERE | Right direction, 1-2 sections need sharpening. | Refine weak sections (3-5 hrs). Then re-run. |
| **55-69** | NEEDS WORK | Significant gaps: niche too broad, positioning generic, problem lacks evidence, or MENA context missing. | Sharpen B1-B4, A1-A3, F. Do not proceed to SC2 until 70+. |
| **40-54** | EARLY STAGE | Idea exploration mode. Niche very broad, problem vague, founder-problem fit unclear. | Talk to 10+ customers. Redefine niche + validate founder-problem fit. Re-run in 3-4 weeks. |
| **0-39** | RESET | Core assumptions may be wrong. Problem may not be real or niche may be too vague. | Pause building. Do customer research. Either validate or pivot. Re-run once tested. |

---

## EXPERT FRAMEWORK INTEGRATIONS

### Narrowing Resistance Protocol (Section B)

**Trigger:** Founder with 10+ years domain expertise resists narrowing at B2 or B3.
**Read:** references/frameworks.md **Narrowing Resistance Protocol** for 3-step intervention

### Grand Slam Offer Viability Check (Section C)

**When:** Scoring C3 (Unique Mechanism) and C4 (One-Line Wedge)
**Read:** references/frameworks.md **Grand Slam Offer Check** for Alex Hormozi thesis
**Non-scored addition:** Enriches positioning context, doesn't rebalance points

### Charge from Day 1 Checkpoint (Section D)

**When:** Scoring D1-D4, check for ANY mention of pricing/monetization
**Read:** references/frameworks.md **Charge from Day 1** for Marc Lou thesis
**Non-scored addition:** Flags revenue strategy clarity, enriches D context

### Hook Model Product Check (Section D)

**When:** Scoring D1-D3, assess if product implies habit formation
**Read:** references/frameworks.md **Hook Model** for Nir Eyal thesis
**Non-scored addition:** Checks external trigger, easy action, variable reward, investment

### Expert Identity Bridge Flag (Section E)

**When:** Scoring E1 and E2, detect "Expert Without a Stage" pattern
**Read:** references/frameworks.md **Expert Identity Bridge Flag** for Russell Brunson guidance
**Non-scored addition:** Suggests brand positioning that bridges expertise to public visibility

### Pre-Launch Validation Checkpoint (Section D)

**Trigger:** D score 70+ but zero validation evidence (no pre-sell, no waitlist)
**Read:** references/frameworks.md **Pre-Launch Validation Checkpoint** for John Rush + Tibo thesis

---

## CROSS-SCORECARD CONSISTENCY CHECKS

**During Phase 2 scoring, flag these contradictions for recommendation section:**

- Niche (B3): "Solo brokers in Dubai" vs. ICP (Scorecard 2): "Enterprise companies" → FLAG: Niche-ICP mismatch
- Problem origin (A1): "Lost 40% of leads" vs. Pain statements (SC2): "Slow reporting features" → FLAG: Pain inconsistency
- MVP (D2): "15 features" vs. Speed to value (D3): "Same day" → FLAG: Timeline impossible
- Language (F2): "Arabic-first" vs. Geography (F1): "UAE" → OKAY (aligned)
- Language (F2): "English-only" vs. Geography (F1): "Egypt" → FLAG: Reconsider for Arabic market

---

## OUTPUT FILE GENERATION

Generate four markdown files:

1. **project-brief.md** — Template in references/output-templates.md
   - Extract A1, A2, A3, E1, E2, F1, F2, F3
   - Structure: Problem & Origin, Founder Story, MENA Context

2. **niche-validation.md** — Template in references/output-templates.md
   - Extract B1, B2, B3, B4, B5
   - Structure: Market → Sub-Market → Niche, validation logic, size estimation

3. **positioning.md** — Template in references/output-templates.md
   - Extract C1, C2, C3, C4
   - Structure: Category, alternatives, unique mechanism, wedge

4. **product-spec.md** — Template in references/output-templates.md
   - Extract D1, D2, D3, D4
   - Structure: Problem statement, MVP features, speed to value, tech approach

**Note:** These are NOT summaries — they are raw work product created through the questionnaire.

---

## MENA-SPECIFIC ADJUSTMENTS

All scoring includes regional context adjustments:

1. **Niche Geography Bonus:** MENA geography in niche (B3) → +1 point
2. **Language-Geography Alignment:** Arabic-first in Egypt/KSA → score 4 (not 3)
3. **Cultural Fit Research:** Primary research (spoke to MENA operators) → +1 point (F3)
4. **Problem Origin Ground:** Named MENA people/companies/locations (A1) → +1 point
5. **Domain Experience + MENA:** MENA network or MENA domain experience (A2) → +1 point

These flow into Scorecards 2-5 (ICP shape, channel selection, seasonal factors, payment methods).

---

## QUICK REFERENCE: QUESTION OVERVIEW

| Question | Type | Pts | Read Section | Section |
|----------|------|-----|--------------|---------|
| A1 | Free-text | 5 | question-bank.md A | Founder Context |
| A2 | Free-text | 5 | question-bank.md A | Founder Context |
| A3 | Free-text | 5 | question-bank.md A | Founder Context |
| B1 | Free-text | 3 | question-bank.md B | Niche Definition |
| B2 | Free-text | 4 | question-bank.md B | Niche Definition |
| B3 | Free-text | 10 | question-bank.md B | Niche Definition |
| B4 | Free-text | 5 | question-bank.md B | Niche Definition |
| B5 | Free-text | 3 | question-bank.md B | Niche Definition |
| C1 | Free-text | 5 | question-bank.md C | Positioning |
| C2 | Free-text | 5 | question-bank.md C | Positioning |
| C3 | Free-text | 5 | question-bank.md C | Positioning |
| C4 | Free-text | 5 | question-bank.md C | Positioning |
| D1 | Free-text | 4 | question-bank.md D | Product Vision |
| D2 | Free-text | 6 | question-bank.md D | Product Vision |
| D3 | MC + Free-text | 4 | question-bank.md D | Product Vision |
| D4 | MC | 6 | question-bank.md D | Product Vision |
| E1 | MC | 3 | question-bank.md E | Brand Voice |
| E2 | Free-text | 7 | question-bank.md E | Brand Voice |
| F1 | MC | 3 | question-bank.md F | MENA Context |
| F2 | MC | 3 | question-bank.md F | MENA Context |
| F3 | Free-text | 4 | question-bank.md F | MENA Context |

---

## EXECUTION CHECKLIST

### Phase 1: Collection (present questions, collect answers)
- [ ] Introduce scorecard: "This creates 4 work-product documents. 30 minutes. 21 questions across 6 sections."
- [ ] Present Section A (A1-A3) as a group. Wait for answers.
- [ ] Present Section B (B1-B5) as a group. Wait for answers.
  - DECISION: If student resists narrowing at B2/B3 → READ references/frameworks.md "Narrowing Resistance Protocol" and apply 3-step intervention BEFORE collecting B3 answer
- [ ] Present Section C (C1-C4) as a group. Wait for answers.
- [ ] Present Section D (D1-D4) as a group. Wait for answers.
  - DECISION: If D4 = "Custom code" or "Haven't decided" → ask follow-up: "Why custom code? Do you have a CTO? Timeline?"
- [ ] Present Section E (E1-E2) as a group. Wait for answers.
- [ ] Present Section F (F1-F3) as a group. Wait for answers.
- [ ] Confirm: "I have all 21 answers. Scoring now."

### Phase 2: Scoring (score each answer, calculate totals)
- [ ] Score each question using references/scoring-rubric.md (three-axis: specificity, evidence, consistency)
- [ ] Apply MENA bonuses: B3 geography (+1), A1 named MENA (+1), A2 MENA network (+1), F2-F1 alignment, F3 research (+1)
- [ ] Run cross-question consistency checks (B1 vs B3, D3 vs D2, A1 vs D1, F2 vs F1)
- [ ] Calculate section totals and overall score
- [ ] Assign band: LAUNCH READY (85-100) / ALMOST THERE (70-84) / NEEDS WORK (55-69) / EARLY STAGE (40-54) / RESET (0-39)

### Phase 3: Output Generation
- [ ] Generate project-brief.md from A1, A2, A3, E1, E2, F1, F2, F3 using references/output-templates.md
- [ ] Generate niche-validation.md from B1-B5 using references/output-templates.md
- [ ] Generate positioning.md from C1-C4 using references/output-templates.md
- [ ] Generate product-spec.md from D1-D4 using references/output-templates.md

### Phase 4: Recommendations
- [ ] For every question scoring < 4: generate recommendation (QUESTION, SCORE, WHY, TO IMPROVE, EXAMPLE, TIME ESTIMATE)
- [ ] Flag cross-scorecard issues that will cause problems in SC2-SC5
- [ ] Present: overall score + band + section breakdown + top 3 priority improvements

### Phase 5: Handoff
- [ ] Save output as SC1-[venture-name]-[date].md
- [ ] Save 4 work-product files to same directory
- [ ] If score >= 70: "SC1 complete ([score]/100 - [band]). Ready for SC2: ICP Clarity. Run /eo-score 2"
- [ ] If score < 70: "SC1 scored [score]/100 - [band]. Focus on: [top 3 weak areas]. Re-run when ready: /eo-score 1"

### Edge Case Decision Trees

**Student gives off-topic answer:**
1. Ask for clarification ONCE: "That doesn't quite answer [question]. I'm looking for [specific thing]. Can you try again?"
2. If still off-topic → score as 0, note in recommendations: "Answer was off-topic. This question asks for [X]."

**Student says "I don't know" or "Not sure":**
1. Offer a prompt: "Think about it this way: [reframe based on their previous answers]"
2. If still blank → score as 0, note: "Unanswered. This is critical for [downstream impact]."

**Student's answer contradicts a previous answer:**
1. Do NOT change either score
2. Flag in recommendations: "Contradiction between [Q1] and [Q2]. Reconcile before SC2."

---

## KEY DESIGN PRINCIPLES

1. **Thinking Tool, Not Checklist** — Questions guide founders through business reasoning
2. **Evidence-Based Scoring** — Evaluate specificity, evidence quality, consistency (not opinions)
3. **Work Product Generation** — Four output files are the deliverable, not badges
4. **MENA-First Context** — All adjustments account for regional realities
5. **Downstream Integration** — Every SC1 answer feeds into Scorecards 2-5
6. **Recommendation Engine** — Per-question, per-section, and compound recommendations guide improvement

Claude executes this scorecard with confidence that it produces accurate assessment and actionable guidance.

---

**See references/ for:**
- question-bank.md (all 21 questions with full rubrics)
- output-templates.md (4 file templates)
- frameworks.md (expert protocols, Alex Hormozi, Russell Brunson, etc.)
- scoring-rubric.md (detailed evaluation criteria per question)
