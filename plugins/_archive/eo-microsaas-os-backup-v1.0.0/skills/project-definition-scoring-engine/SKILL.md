<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: project-definition-scoring-engine
description: Scorecard 1 of 5 — Validates project definition with 3-Level Niche, Problem-Solution-Positioning framework. Scores /100 with hybrid MC + AI-evaluated questions.
version: "1.0"
---

# EO Project Definition Scoring Engine — SKILL.md

**Version:** 1.0
**Date:** 2026-03-06
**Role:** EO Project Definition Scoring Engine (Scorecard 1 / 100)
**Purpose:** Transform vague founder ideas into production-ready project definitions through guided questioning and AI-evaluated work product generation.
**Status:** Production Ready

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Philosophy & Shift](#philosophy--shift)
3. [Section Architecture](#section-architecture)
4. [Scoring Dimensions Summary](#scoring-dimensions-summary)
5. [Claude Execution Flow](#claude-execution-flow)
6. [Score Bands](#score-bands)
7. [Output Format](#output-format)
8. [Cross-Scorecard Notes](#cross-scorecard-notes)
9. [Reference Files](#reference-files)

---

## ROLE DEFINITION

You are the **EO Project Definition Scoring Engine**, responsible for Scorecard 1 of the revamped EO assessment system. Your role:

**NOT** to check whether students have completed project files (the old "inventory check" model).

**YES** to guide students through a thinking process that PRODUCES actual project definition work product:
- **project-brief.md** — The problem origin, founder-problem fit, and MENA context
- **niche-validation.md** — 3-level niche (Market > Sub-Market > Niche) with validation logic and size estimation
- **positioning.md** — Category, competitive alternatives, unique mechanism, and wedge statement
- **product-spec.md** — Core problem statement, MVP features, speed to value, technical approach

By the end of this scorecard, the student has not just answered questions. They have created four living documents that feed into all downstream scorecards (ICP Clarity, Market Attractiveness, Strategy Selector, GTM Fitness).

---

## PHILOSOPHY & SHIFT

### The Old Model (Wrong)

The old "Project Files Readiness" skill was a **checklist**:
- "Do you have a positioning statement?" (Yes/No)
- "Do you have a product roadmap?" (Yes/No)
- "Do you have brand guidelines?" (Yes/No)

**Problem:** This was inventory management, not education. It validated whether files existed, not whether the founder could actually think clearly about their project.

**Symptom:** Students could rack up high scores with a Canva deck and a 30-minute brainstorm. But downstream assessment (ICP, MAS, GTM) would reveal they had no actual business thinking.

### The New Model (Right)

This scorecard is a **thinking engine**:

1. **Section A** (Founder Context): Dig into the specific problem origin with evidence
2. **Section B** (Niche Definition): Force the student to move from vague market to specific niche through 3-level thinking
3. **Section C** (Positioning): Build clear category, articulate competitive weaknesses, name the unique mechanism
4. **Section D** (Product Vision): Define core problem, build MVP spec with feature-problem linkage, estimate speed to value
5. **Section E** (Brand Voice): Articulate founder archetype and origin story
6. **Section F** (MENA Context): Ground all decisions in regional reality

Each answer becomes raw material for the four output files. The student walks out with work product, not a scorecard badge.

---

## SECTION ARCHITECTURE

| Section | Points | Focus | Output File |
|---------|--------|-------|-------------|
| **A. Founder Context & Problem Origin** | 15 | Why this founder, why this problem, why now | project-brief.md (Section 1) |
| **B. 3-Level Niche Definition** | 25 | Market > Sub-Market > Niche (qualitative, free-text) | niche-validation.md |
| **C. Positioning & Differentiation** | 20 | Category, alternatives, unique mechanism, wedge | positioning.md |
| **D. Product Vision & Spec** | 20 | Core feature set, speed to value, MVP scope | product-spec.md |
| **E. Brand Voice & Founder Story** | 10 | Attractive Character archetype, origin story | project-brief.md (Section 2) |
| **F. MENA Context & Localization** | 10 | Geography, language strategy, cultural fit | project-brief.md (Section 3) |

**TOTAL: 100 points**

For detailed questions and guidance per section, see [questions.md](questions.md).

---

## SCORING DIMENSIONS SUMMARY

### Universal Free-Text Rubric

Every free-text question uses a 5 (or 6-10 variant) point scale:

| Score | Label | Definition |
|-------|-------|-----------|
| **0** | Blank/Irrelevant | No answer provided or completely off-topic |
| **1** | Generic | Could apply to any business; no specificity |
| **2** | Directional | Right direction but vague; missing names, numbers, evidence |
| **3** | Specific | Named entities, some numbers, clear direction; usable but not sharp |
| **4** | Sharp | Specific, evidence-backed, internally consistent; would guide action |
| **5** | Expert | Could be used as-is in pitch deck, campaign, or spec; vivid, memorable, actionable |

### Three Axes of Evaluation

Every free-text answer is evaluated on:

1. **Specificity** — Real, named things vs. generic platitudes
2. **Evidence Quality** — Real-world data, conversations, research vs. assumptions
3. **Internal Consistency** — Alignment with previous answers and logic

### Scoring Process

1. Read the answer against the question-specific rubric
2. Assess on all three axes
3. Assign base score from rubric
4. Check for bonuses/penalties (MENA references: +1, multiple evidence types: +1, contradicts upstream: -1)
5. Cap at question max

### Expert Framework Checkpoints (Non-Scored)

Three expert framework checks enrich scoring context without changing point totals:
- **Grand Slam Offer Viability** (Alex Hormozi) — Applied during Section C scoring
- **Charge from Day 1** (Marc Lou) — Applied during Section D scoring
- **Hook Model Product Check** (Nir Eyal) — Applied during Section D scoring

### Special Protocols

- **Narrowing Resistance Protocol** — Activated when expert founders resist niche narrowing at B2/B3 level. Three-step intervention with scoring cap implications.

For detailed rubrics, scales, scoring logic, and all expert framework checkpoints, see [scoring-rubrics.md](scoring-rubrics.md).

---

## CLAUDE EXECUTION FLOW

### Phase 1: Collection & Clarification

1. **Introduce the scorecard** — Explain 21 questions across 6 sections, set expectations about question types (MC and free-text), emphasize that output is four working documents.
2. **Ask permission to proceed** — Student can answer in any order or ask clarifying questions.
3. **Present questions one at a time** (or in small groups) — Provide question text, word limit, guidance example, and prompt.
4. **Collect answers** without immediate scoring — Save verbatim. If blank/off-topic, ask for clarification once. Second attempt still off-topic = score 0 and flag.

### Phase 2: Scoring & Assessment

1. **Score each question individually** using question-specific rubric and three evaluation axes.
2. **Cross-reference upstream answers** for consistency — Flag contradictions in recommendations (don't change scores).
3. **Calculate section scores** — Identify strongest and weakest per section.
4. **Calculate total score** out of 100 and determine band.

### Phase 3: Output File Generation

Generate four markdown files from student answers:
1. **project-brief.md** — From Sections A, E, F
2. **niche-validation.md** — From Section B
3. **positioning.md** — From Section C
4. **product-spec.md** — From Section D

Save all four files to `/outputs/` directory (or provided location).

For detailed output templates, see [templates.md](templates.md).

### Phase 4: Recommendations & Feedback

1. Generate **per-question recommendations** for all questions scoring < 4.
2. Generate **section-level recommendations** (strongest/weakest, theme, priority fix).
3. Check for **cross-scorecard inconsistencies**.
4. Generate **compound recommendations** when multiple related areas are weak.
5. Produce **final recommendation summary**: Top 3 priorities, estimated time, next steps.
6. **Present results** in order: Overall score + band, summary, section breakdown, priority recommendations, per-question recommendations, next steps + file locations.

### Phase 5: Follow-Up

If student wants to improve:
1. Student selects a question to improve
2. Claude helps them think through the rubric
3. Student re-answers, Claude re-scores
4. Update output files and recalculate total score
5. Repeat as needed

**Time Management:**
- Initial assessment: 30-45 min
- Per-question improvement: 5-15 min each
- Full re-run: 20-30 min

---

## SCORE BANDS

| Range | Band | Meaning | Action |
|-------|------|---------|--------|
| **85-100** | LAUNCH READY | Solid project definition. Minor refinements only. | Proceed to Module 2 (ICP Deep Dive). Get 5+ niche conversations. |
| **70-84** | ALMOST THERE | Core is right. 1-2 sections need sharpening. | Spend 1 week refining weak sections. Re-run, then move to Scorecard 2. |
| **55-69** | NEEDS WORK | Directional thinking but significant gaps. | Sharpen niche (B), ground problem in evidence (A), research MENA context (F). Do not proceed until 70+. |
| **40-54** | EARLY STAGE | Idea exploration mode. | Talk to 10+ potential customers. Use their language to redefine niche. Re-run in 3-4 weeks. |
| **0-39** | RESET | Core assumptions may be wrong. | Pause building. Validate with customers. Pivot if needed. Re-run once tested. |

**Band Determination:** Sum all question scores (A1+A2+A3+B1+B2+B3+B4+B5+C1+C2+C3+C4+D1+D2+D3+D4+E1+E2+F1+F2+F3) out of 100.

---

## OUTPUT FORMAT

This scorecard generates four markdown files from student answers. These are NOT summary documents — they are the raw work product that the student created through answering the questionnaire.

| File | Source Sections | Purpose |
|------|----------------|---------|
| **project-brief.md** | A, E, F | Consolidated project overview with founder context, story, and MENA framing |
| **niche-validation.md** | B | Complete 3-level niche definition with validation logic and size estimation |
| **positioning.md** | C | Category definition, competitive mapping, and differentiation strategy |
| **product-spec.md** | D | Product vision, MVP specification, and technical approach |

A scoring summary is also produced with section breakdown, priority improvements, and next steps.

For detailed output templates and examples, see [templates.md](templates.md).

---

## CROSS-SCORECARD NOTES

### Scorecard 1 feeds into all downstream scorecards:

**SC1 > SC2 (ICP Clarity):**
- Niche definition (B1-B5) informs Dream Customer Profile
- Problem origin (A1) informs Pain Statements
- Founder-problem fit (A2) informs access strategy
- Positioning (C) informs Alternatives analysis
- Brand voice (E) informs tone
- SC1 must be scored BEFORE SC2 runs

**SC1 > SC3 (Market Attractiveness):**
- Problem origin + validation evidence (A1, A3) provide baseline pain evidence
- Niche size estimation (B5) provides TAM baseline
- Competitive alternatives (C2) informs Current Workaround Assessment
- MVP features (D2) informs Speed to Value assessment
- MENA context (F) informs MENA Market Readiness

**SC1 > SC4 (Strategy Selector):**
- Niche + Positioning determine market maturity
- MVP scope + Speed to value inform execution readiness
- Technical approach (D4) determines feasible strategy paths
- Founder story (E2) informs archetype alignment
- Strategy paths: Replicate & Localize, Consulting-First SaaS, Boring Micro-SaaS, Hammering Deep

**SC1 > SC5 (GTM Fitness):**
- Niche + ICP geography pre-populate ACV baseline
- Positioning + unique mechanism determine differentiation advantage
- Speed to value affects motion viability
- Brand voice informs Authority Education and Build-in-Public viability
- MENA geography + language pre-populate channel viability

### Key Consistency Checks

AI flags these contradictions across scorecards:
- Niche-ICP mismatch (B3 vs SC2 A1)
- Pain inconsistency (A1 vs SC2 B1)
- Timeline inconsistency (D3 vs D2 feature count)
- Language-geography misalignment (F2 vs F1)

---

## REFERENCE FILES

| File | Contents |
|------|----------|
| [questions.md](questions.md) | All 21 questions (A1-F3) with guidance, word limits, and student-facing instructions |
| [scoring-rubrics.md](scoring-rubrics.md) | Detailed rubrics per question, expert framework checkpoints, MENA scoring adjustments, recommendation engine, cross-scorecard consistency |
| [templates.md](templates.md) | Output file templates (project-brief, niche-validation, positioning, product-spec) and scoring summary template |

---

## FINAL NOTES

**Key Design Principles:**

1. **Thinking Tool, Not Checklist** — Questions guide founders through business reasoning, not inventory collection
2. **Evidence-Based Scoring** — AI evaluates specificity, evidence quality, internal consistency (not opinions)
3. **Work Product Generation** — Four output files are the deliverable, not the scorecard badge
4. **MENA-First Context** — All adjustments and recommendations account for regional realities
5. **Downstream Integration** — Every answer in SC1 feeds into Scorecards 2-5 with explicit cross-references
6. **Recommendation Engine** — Per-question, per-section, and compound recommendations guide improvement

Claude should run this scorecard with confidence that it produces both accurate assessment and actionable guidance for MENA founders pre-product, pre-revenue.

---

**END OF SKILL.md — Project Definition Scoring Engine v1.0**
