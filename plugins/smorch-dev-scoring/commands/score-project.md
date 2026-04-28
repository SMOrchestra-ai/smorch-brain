---
name: score-project
description: Run the full 5-Hat Quality Scorecard on the current project
---

# /score-project

Run the complete 5-Hat Quality Scorecard System against the current codebase.

## What This Command Does

Triggers the `composite-scorer` skill, which orchestrates all 5 hat scorers sequentially:

1. **Product Scorer** (Hat 1) — scope, roadmap, product-market fit
2. **Architecture Scorer** (Hat 2) — data design, API, security architecture
3. **Engineering Scorer** (Hat 3) — code quality, testing, CI/CD
4. **QA Scorer** (Hat 4) — functional testing, edge cases, data integrity
5. **UX Frontend Scorer** (Hat 5) — visual quality, accessibility, RTL

Produces a weighted composite score with hard stop enforcement.

## Usage

```
/score-project
```

No arguments required.

### Prerequisite Check

Before scoring, verify:
1. **Codebase accessible**: Run `ls` on the working directory. If empty or no project files, ask the user to navigate to the project root or mount the correct folder.
2. **Phase determinable**: Check for phase signals (see composite-scorer Step 1). If ambiguous, ask the user: "Which phase is this project in? Pre-Build / During Build / Pre-Launch / Post-Launch"
3. **Project type**: If no `.tsx`/`.jsx` files exist, this may be a backend-only project. Inform the user that Hat 5 (UX Frontend) will be skipped and weights redistributed.

The scorer will:

1. Detect the project phase (or ask you)
2. Discover the codebase structure
3. Run each hat scorer with evidence collection
4. Calculate the phase-weighted composite
5. Check all hard stop quality gates
6. Output the full scorecard

## Before Running

For best results, ensure:

- You're in the project's root directory (or the project folder is mounted)
- A `CLAUDE.md` or BRD/PRD exists for product context
- The codebase has been committed (uncommitted work may not be fully discoverable)

## Output

A complete scorecard with:

- Composite score (X.X / 10) with letter grade
- Category breakdown (5 categories with weighted scores)
- Hard stop status (PASS/FAIL for each gate)
- Top 5 critical gaps ranked by impact
- Recommended next action

After scoring, run `/bridge-gaps` to generate the improvement plan.

## When to Use

- **Before shipping**: Pre-launch quality gate check
- **During sprint review**: Measure quality progress
- **After major refactor**: Verify quality didn't regress
- **New project onboarding**: Baseline assessment of inherited codebase
- **Client deliverable review**: Quality assurance before handoff
