<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: product-scorer
description: >-
  Scores product strategy across 8 dimensions: Problem Clarity, Scope Discipline, Requirements Quality, Roadmap Strategy, Market Validation, Success Metrics, Competitive Positioning, Resource-Scope Fit. Triggers on "score product", "evaluate scope", "product quality check", "is our product strategy solid", "rate our roadmap", "product scorecard". Also fires when composite-scorer orchestrates a full project scoring run.
---

# Product / CPO Scorer

Score product strategy, scope discipline, and execution readiness. This is Hat 1 of the 5-Hat Quality Scorecard System.

The core question: **Is the right thing being built, for the right market, at the right scope?**

## When This Fires

- User asks to evaluate product strategy, scope, or roadmap
- composite-scorer orchestrates a full project scoring run
- User is about to start building and wants a pre-build quality gate

## Scoring Process

### Step 1: Gather Context

Determine the project phase. Ask if not obvious:
- **Pre-Build**: Idea/spec stage, no code yet
- **During Build**: Active development
- **Pre-Launch**: Code complete, preparing for release
- **Post-Launch**: Live product, iterating

Search the codebase for product context files. Read in this priority order:

1. `**/BRD*`, `**/PRD*`, `**/spec*`, `**/requirements*` (formal docs)
2. `**/CLAUDE.md`, `**/README.md` (project context)
3. `**/package.json` (project metadata, dependencies as scope signal)
4. `**/roadmap*`, `**/TODO*`, `**/TASKS*` (planning artifacts)

If no formal product docs exist, that itself is a data point (Problem Clarity and Requirements Quality will score low).

### Step 2: Score Each Dimension

Read the anchor rubrics from `references/product-anchors.md` before scoring. For calibration reference, see `../composite-scorer/references/calibration-examples.md` (Product section). For each dimension:

1. State what evidence you found (or didn't find)
2. Cite specific files and lines
3. Assign a score 1-10 using the anchor rubrics
4. Note the gap between current and target (8+)

The 8 dimensions and their weights:

| Dimension | Weight | What to Look For |
|-----------|--------|-----------------|
| Problem Clarity | 15% | Specificity of problem statement. WHO + WHAT pain + WHEN |
| Scope Discipline | 15% | MVP tightness. Feature count. "Not building" list |
| Requirements Quality | 10% | Testable acceptance criteria. User story format |
| Roadmap Strategy | 15% | Phase logic. Decision gates. Kill criteria |
| Market Validation | 15% | Evidence of customer conversations, pre-sales, revenue |
| Success Metrics | 10% | KPIs defined pre-build. North star metric |
| Competitive Positioning | 10% | Differentiation strategy. Category definition |
| Resource-Scope Fit | 10% | Scope vs team size. Timeline realism |

### Step 3: Calculate Category Score

Category Score = Sum of (dimension_score x dimension_weight) / total_weight

### Step 4: Output Format

Produce a structured assessment:

```
## Product Scorecard — [Project Name]
Phase: [phase] | Date: [date]

### Category Score: X.X / 10 ([grade])

| Dimension | Score | Evidence |
|-----------|-------|----------|
| Problem Clarity | X/10 | [brief evidence] |
| ... | ... | ... |

### Critical Gaps
- [Dimension]: Currently X, needs Y. Specific improvement: [action]

### Hard Stops
- Problem Clarity < 4: [PASS/FAIL] — [explanation if fail]
```

Grade thresholds: A+ (9.0-10.0), A (8.0-8.9), B (7.0-7.9), C (6.0-6.9), D (5.0-5.9), F (below 5.0).

## MENA-Specific Considerations

When evaluating products targeting MENA markets, weight these factors:

- **Market Validation**: WhatsApp conversations count more than email surveys. Coffee meeting commitments are real signals.
- **Competitive Positioning**: "Arabic-first" is a positioning axis, not just a language feature. Score higher if the product is native to the region, not adapted.
- **Resource-Scope Fit**: Solo founders with AI (Claude/Cursor) can ship faster than traditional estimates suggest. Adjust timeline expectations accordingly.

## Skip Conditions

Do NOT run this scorer when:
- **Pure infrastructure/DevOps project**: No product scope to evaluate. Return "N/A: infrastructure project."
- **Design system or component library**: Product strategy doesn't apply to UI toolkits. Skip to Hat 5.
- **Hotfix or bugfix branch**: Scoring product strategy on a patch branch is meaningless. Score the main branch instead.

## System Context

This scorer feeds into the composite-scorer (Hat 1 of 5). Product scores at Pre-Build phase carry 30% weight. After scoring, the gap-bridger converts low-scoring dimensions into specific improvement tasks.
