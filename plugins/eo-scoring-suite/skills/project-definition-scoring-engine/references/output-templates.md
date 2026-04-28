# Output File Templates

Claude generates four markdown files from student answers. These templates show the exact structure and placeholders.

---

## File 1: project-brief.md

**Source:** Sections A, E, F
**Purpose:** Consolidated project overview with founder context, story, and MENA framing
**How to Generate:** Extract answers from A1-A3, E1-E2, F1-F3 and structure per template below

```markdown
# Project Brief
**Generated:** [TODAY'S DATE]
**Scorecard:** Project Definition (Scorecard 1)
**Project Name:** [From student conversation or generic if not provided]

---

## Section 1: The Problem & Origin

### Problem Origin Story
[A1 answer verbatim]

### Founder-Problem Fit
[A2 answer verbatim]

### Validation Evidence
[A3 answer verbatim]

---

## Section 2: Founder Story & Brand Voice

### Founder Archetype
[E1 selected option + name]

### Origin Story
[E2 answer verbatim]

---

## Section 3: MENA Context

### Launch Geography
[F1 selected option]

### Language Strategy
[F2 selected option]

### Cultural Fit Assessment
[F3 answer verbatim]

---

## Assessment

**Total Points (Sections A, E, F):** [A1+A2+A3+E1+E2+F1+F2+F3]
**Maximum Points:** 30
**Score Band:** [LAUNCH READY / ALMOST THERE / NEEDS WORK / EARLY STAGE / RESET]

---

## Next Steps

This brief is referenced in:
- **Module 1 (Project Setup):** Use this brief to introduce your project to your mentor
- **Downstream Scorecards:** ICP Clarity will reference your founder story; MAS will reference your problem origin

---
```

---

## File 2: niche-validation.md

**Source:** Section B
**Purpose:** Complete 3-level niche definition with validation logic and size estimation
**How to Generate:** Extract answers from B1-B5 and structure per template below

```markdown
# Niche Validation
**Generated:** [TODAY'S DATE]
**Scorecard:** Project Definition (Scorecard 1)
**Niche Score:** [B1+B2+B3+B4+B5]/25

---

## 3-Level Niche Definition

### Market Level (Broad Market)
[B1 answer verbatim]

**AI Assessment:** [Specificity, recognition, scope]

---

### Sub-Market Level
[B2 answer verbatim]

**AI Assessment:** [Narrowing from B1, identifiability, specificity]

---

### Niche Level (Exact Target)
[B3 answer verbatim]

**AI Assessment:** [Presence of all 4 elements: specific person, situation, problem, outcome]

---

## Niche Validation Logic

### Why This Niche?
[B4 answer verbatim]

**AI Assessment:** [Economic reasoning, expansion path clarity, competitive advantage articulation]

---

### Niche Size Estimation
[B5 answer verbatim]

**AI Assessment:** [Methodology clarity, use of sources, bottom-up vs. assumption]

---

## Score Breakdown

| Question | Points | Score | Assessment |
|----------|--------|-------|-----------|
| B1 Market Level | 3 | [X] | [Feedback] |
| B2 Sub-Market Level | 4 | [X] | [Feedback] |
| B3 Niche Level | 10 | [X] | [Feedback] |
| B4 Validation Logic | 5 | [X] | [Feedback] |
| B5 Size Estimation | 3 | [X] | [Feedback] |
| **Section Total** | **25** | **[X]** | — |

---

## Recommendations

### Strongest Answer
[Identify which of B1-B5 scored highest; explain why]

### Weakest Answer
[Identify which scored lowest; explain what's missing]

### Priority Fix
[If total < 20, what's the highest-impact improvement?]

---

## Next Steps

This niche definition is referenced in:
- **Module 1 (Niche Refinement):** Use this to validate with 5+ real prospects in your target market
- **Scorecard 2 (ICP Clarity):** Your niche defines the dream customer profile
- **Scorecard 3 (Market Attractiveness):** Your niche size estimation becomes the TAM baseline

---
```

---

## File 3: positioning.md

**Source:** Section C
**Purpose:** Category definition, competitive mapping, and differentiation strategy
**How to Generate:** Extract answers from C1-C4 and structure per template below

```markdown
# Positioning Statement
**Generated:** [TODAY'S DATE]
**Scorecard:** Project Definition (Scorecard 1)
**Positioning Score:** [C1+C2+C3+C4]/20

---

## Category Definition

### The One-Liner
[C1 answer verbatim]

**AI Assessment:** [Crispness, specificity, clarity of both blanks]

---

## Competitive Alternatives

### Current Buyer Behavior
[C2 answer verbatim, restructured as:
- Alternative 1: [Tool/Process]
  - What's broken: [Weakness]
- Alternative 2: [Tool/Process]
  - What's broken: [Weakness]
- Alternative 3: [Tool/Process]
  - What's broken: [Weakness]
]

**AI Assessment:** [Reality of alternatives, weakness articulation, status-quo inclusion]

---

## Unique Mechanism

### How We're Different
[C3 answer verbatim]

**AI Assessment:** [Mechanism vs. feature distinction, differentiation strength, defensibility]

---

## Wedge Statement

### The Stop-Scroll Pitch
[C4 answer verbatim]

**AI Assessment:** [Specificity to niche, curiosity gap, emotional resonance]

---

## Score Breakdown

| Question | Points | Score | Assessment |
|----------|--------|-------|-----------|
| C1 Category Definition | 5 | [X] | [Feedback] |
| C2 Competitive Alternatives | 5 | [X] | [Feedback] |
| C3 Unique Mechanism | 5 | [X] | [Feedback] |
| C4 Wedge Statement | 5 | [X] | [Feedback] |
| **Section Total** | **20** | **[X]** | — |

---

## Recommendations

### Strongest Answer
[Which question scored highest; why]

### Weakest Answer
[Which needs sharpening; why]

### Competitive Positioning Priority
[If alternatives aren't clear, recommend "Map competitors in your niche on 2x2: Price vs. Ease"]

---

## Next Steps

This positioning is referenced in:
- **Module 2 (Positioning Deep Dive):** Use this to build campaign messaging and ad copy
- **Module 3 (Building):** Your unique mechanism guides MVP feature prioritization
- **All Downstream Scorecards:** ICP/MAS/GTM all reference your positioning

---
```

---

## File 4: product-spec.md

**Source:** Section D
**Purpose:** Product vision, MVP specification, and technical approach
**How to Generate:** Extract answers from D1-D4 and structure per template below

```markdown
# Product Specification
**Generated:** [TODAY'S DATE]
**Scorecard:** Project Definition (Scorecard 1)
**Product Vision Score:** [D1+D2+D3+D4]/20

---

## Problem Statement

### Current Workflow (Broken Today)
[D1 answer verbatim, with workflow steps]

**AI Assessment:** [Specificity of workflow, clarity of failure points, inclusion of existing tools]

---

## MVP Feature Set

### Core Features & Justification
[D2 answer, restructured as:
1. **Feature Name**
   - Problem Solved: [What breakdown does this fix?]
   - Why Can't Cut: [Why is this essential for MVP?]

2. **Feature Name**
   - Problem Solved: [...]
   - Why Can't Cut: [...]

...repeat for all features
]

**AI Assessment:** [Problem-feature mapping, scope discipline (3-5 features), no superfluous features]

---

## Speed to Value

### Time to First Result
**Selected:** [Same day / Within 3 days / Within a week / Within a month / Longer than a month]

### First Result Description
[D3 free-text answer verbatim]

**AI Assessment:** [Realism of timeline, clarity of first result, user action + experience included]

---

## Technical Approach

### Build Method
**Selected:** [No-code / Low-code / Custom code / Hybrid / Haven't decided]

**Reasoning:**
[If custom code was selected: Why custom code? Do you have a technical co-founder? What's the timeline?]

**AI Assessment:** [Alignment with MicroSaaS tempo (30-90 day revenue goal), realistic for founder skillset]

---

## Score Breakdown

| Question | Points | Score | Assessment |
|----------|--------|-------|-----------|
| D1 Problem Statement | 4 | [X] | [Feedback] |
| D2 MVP Feature Set | 6 | [X] | [Feedback] |
| D3 Speed to Value | 4 | [X] | [Feedback] |
| D4 Technical Approach | 6 | [X] | [Feedback] |
| **Section Total** | **20** | **[X]** | — |

---

## Recommendations

### Strongest Answer
[Which element scored highest]

### Weakest Answer
[Which needs development]

### Execution Priority
[If D4 is "Haven't decided," recommend picking one ASAP. If D3 is >1 week, recommend simplifying MVP.]

---

## Next Steps

This spec is referenced in:
- **Module 3 (Building):** Use this as your MVP specification for Claude Desktop build sessions
- **Scorecard 3 (Market Attractiveness):** Your speed to value and technical approach affect market timing assessment
- **Scorecard 5 (GTM Fitness):** Your tech stack affects channel viability

---
```

---

## Summary Template (Final Results Document)

Generate this summary after all four files are created:

```markdown
# PROJECT DEFINITION SCORECARD — RESULTS

**Founder:** [Name]
**Project:** [Project Name]
**Date:** [Today]
**Total Score:** [X]/100
**Score Band:** [LAUNCH READY / ALMOST THERE / NEEDS WORK / EARLY STAGE / RESET]

---

## SCORE BREAKDOWN

| Section | Score | Max | % |
|---------|-------|-----|---|
| A. Founder Context | [X] | 15 | [X]% |
| B. Niche Definition | [X] | 25 | [X]% |
| C. Positioning | [X] | 20 | [X]% |
| D. Product Vision | [X] | 20 | [X]% |
| E. Brand Voice | [X] | 10 | [X]% |
| F. MENA Context | [X] | 10 | [X]% |
| **TOTAL** | **[X]** | **100** | **[X]%** |

---

## SUMMARY

[2-3 sentence executive summary of what's strong and what needs work]

---

## PRIORITY IMPROVEMENTS (Ranked by Impact)

1. **[Improvement #1]** — Estimated time: [X] hours — Impact: [+X points]
2. **[Improvement #2]** — Estimated time: [X] hours — Impact: [+X points]
3. **[Improvement #3]** — Estimated time: [X] hours — Impact: [+X points]

---

## OUTPUT FILES GENERATED

✓ **project-brief.md** — Saved to [location]
✓ **niche-validation.md** — Saved to [location]
✓ **positioning.md** — Saved to [location]
✓ **product-spec.md** — Saved to [location]

---

## NEXT STEPS

**If LAUNCH READY (85-100):**
Proceed directly to Scorecard 2 (ICP Clarity). Use your four output files as reference documents.

**If ALMOST THERE (70-84):**
Spend 1 week refining weak sections (see recommendations above). Re-run Scorecard 1. Once 70+, proceed to Scorecard 2.

**If NEEDS WORK (55-69):**
Spend 2 weeks on foundational work (problem validation, niche research, MENA context). Do not proceed to Scorecard 2 until score improves to 70+.

**If EARLY STAGE (40-54):**
Conduct 10+ customer interviews. Use their language and pain statements to refine niche and problem origin. Validate founder-problem fit with real experience or network. Re-run Scorecard 1 in 3-4 weeks.

**If RESET (0-39):**
Pause building. Validate core assumptions with customers. Either validate your problem + niche, or pivot to one that resonates more. Re-run once assumptions are tested.

---
```

---

END OF OUTPUT TEMPLATES
