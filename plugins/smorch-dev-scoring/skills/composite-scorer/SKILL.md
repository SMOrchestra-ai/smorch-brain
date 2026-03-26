---
name: composite-scorer
description: >-
  Orchestrates all 5 hat scorers (Product, Architecture, Engineering, QA, UX Frontend) into a weighted composite score with phase-based weighting and hard stop quality gates. Triggers on "score this project", "full quality audit", "composite score", "5-hat review", "quality scorecard", "ship readiness check", "is this ready to ship".
---

# Composite Scorer — 5-Hat Orchestrator

Run the complete 5-Hat Quality Scorecard System. Orchestrates product-scorer, architecture-scorer, engineering-scorer, qa-scorer, and ux-frontend-scorer into a single weighted composite with hard stop enforcement.

The core question: **What is the true quality of this project, measured from every angle that matters?**

## Orchestration Process

### Step 1: Detect Project Phase

Determine the current phase to apply correct category weights. Ask the user or infer from signals:

| Phase | Signals | Typical State |
|-------|---------|---------------|
| Pre-Build | BRD/PRD exists, no `src/` directory, package.json has no dependencies | Planning and design |
| During Build | Active `src/`, <80% features complete, frequent commits, failing tests OK | Development in progress |
| Pre-Launch | Feature-complete, focus on testing/polish, CI passing, staging deployed | Preparing for production |
| Post-Launch | Production URL exists, monitoring configured, users active | Live and iterating |

If phase is ambiguous, **ask the user**. Phase selection changes weight distribution significantly.

### Step 2: Apply Phase-Based Category Weights

Read `references/phase-weights.md` for the weight matrix.

| Category | Pre-Build | During Build | Pre-Launch | Post-Launch |
|----------|-----------|-------------|------------|-------------|
| Product (Hat 1) | 30% | 20% | 15% | 20% |
| Architecture (Hat 2) | 30% | 25% | 15% | 15% |
| Engineering (Hat 3) | 15% | 25% | 25% | 25% |
| QA (Hat 4) | 10% | 15% | 25% | 25% |
| UX Frontend (Hat 5) | 15% | 15% | 20% | 15% |

### Step 3: Run Each Scorer Sequentially

Execute each hat scorer in order. For each:

1. Announce: `"## Running Hat X: [Name] Scorer..."`
2. Follow that scorer's SKILL.md process completely
3. Capture the category score (weighted average of its 8 dimensions)
4. Record any hard stop violations
5. Note the top 3 critical gaps per category

**Execution order matters**: Product → Architecture → Engineering → QA → UX Frontend. Earlier hats provide context that informs later scoring (e.g., product scope informs what QA should test).

### Step 4: Calculate Composite Score

```
Composite = Σ (category_score × category_weight)

Example (During Build phase):
  Product: 7.2 × 0.20 = 1.44
  Architecture: 8.1 × 0.25 = 2.025
  Engineering: 6.5 × 0.25 = 1.625
  QA: 5.0 × 0.15 = 0.75
  UX Frontend: 7.0 × 0.15 = 1.05
  Composite = 6.89 / 10
```

### Step 5: Enforce Hard Stop Gates

Read `references/hard-stops.md` for the complete hard stop rules.

These dimension-level scores trigger a FAIL regardless of composite:

| Hard Stop | Trigger | Scope |
|-----------|---------|-------|
| Security Architecture (Hat 2) | Score < 5 | All phases |
| Security Practices (Hat 3) | Score < 5 | All phases |
| Security Testing (Hat 4) | Score < 5 | Pre-Launch, Post-Launch |
| Data Integrity (Hat 4) | Score < 5 | All phases |
| Problem Clarity (Hat 1) | Score < 4 | Pre-Build |
| Functional Completeness (Hat 4) | Score < 5 | Pre-Launch, Post-Launch |
| RTL/Bilingual (Hat 5) | Score < 5 | All phases (MENA products only) |

Hard stop triggered = project cannot advance to next phase until resolved.

### Step 6: Grade Assignment

| Composite | Grade | Meaning |
|-----------|-------|---------|
| 9.0 - 10.0 | A+ | Elite. Ship with confidence. |
| 8.0 - 8.9 | A | Strong. Minor polish needed. |
| 7.0 - 7.9 | B | Solid. Known gaps have clear remediation path. |
| 6.0 - 6.9 | C | Acceptable with caveats. Gaps need active work. |
| 5.0 - 5.9 | D | Below bar. Significant gaps before shipping. |
| < 5.0 | F | Critical. Major rework required. |

### Step 7: Output Format

```
# 5-Hat Quality Scorecard — [Project Name]
Phase: [phase] | Date: [date] | Scored by: Claude (smorch-dev-scoring v1.0)

## Composite Score: X.X / 10 — Grade: [grade]
Hard Stops: [X PASS / Y FAIL]

## Category Breakdown

| # | Category | Score | Weight | Weighted | Hard Stops |
|---|----------|-------|--------|----------|------------|
| 1 | Product | X.X | XX% | X.XX | [PASS/FAIL details] |
| 2 | Architecture | X.X | XX% | X.XX | [PASS/FAIL details] |
| 3 | Engineering | X.X | XX% | X.XX | [PASS/FAIL details] |
| 4 | QA / Testing | X.X | XX% | X.XX | [PASS/FAIL details] |
| 5 | UX Frontend | X.X | XX% | X.XX | [PASS/FAIL details] |

## Hard Stop Status
- Security Architecture: [PASS ✓ / FAIL ✗ (score: X)]
- Security Practices: [PASS ✓ / FAIL ✗ (score: X)]
- Data Integrity: [PASS ✓ / FAIL ✗ (score: X)]
- [additional applicable hard stops...]

## Top 5 Critical Gaps (Prioritized by Impact)
1. [Category] > [Dimension]: Score X → Target 8. Impact: [why this matters most]
2. ...

## Score History (if previous scores exist)
| Date | Composite | Grade | Delta |
|------|-----------|-------|-------|
| [previous] | X.X | [grade] | — |
| [current] | X.X | [grade] | +/-X.X |

## Next Action
[Single most impactful action to take right now, based on gap analysis]
→ Run `/bridge-gaps` for the full prioritized improvement plan.
```

### Step 8: Persist Scores

Read `references/score-storage.md` for the full schema.

1. Create `.scores/` in the project root if it doesn't exist
2. Write the full score JSON to `.scores/[ISO-date].json`
3. Copy to `.scores/latest.json`
4. Read `history.json`, append summary with delta, write back
5. If previous scores exist, calculate and display the delta in the output

### Step 9: Cross-Hat Consistency Check

Before finalizing, verify scores are consistent across related dimensions:

| Dimension Pair | Contradiction Signal |
|---------------|---------------------|
| Architecture Security (Hat 2) vs Security Practices (Hat 3) | Gap > 3 points = likely scoring error |
| Data Architecture (Hat 2) vs Data Integrity (Hat 4) | Gap > 3 points = re-examine evidence |
| Component Architecture (Hat 5) vs Code Organization (Hat 3) | Gap > 3 points = different standards applied |
| Requirements Quality (Hat 1) vs Functional Completeness (Hat 4) | Gap > 3 points = scope drift or undertesting |
| Scalability Design (Hat 2) vs Frontend Performance (Hat 5) | Gap > 3 points = one layer optimized, other neglected |

If a contradiction is found:
1. Re-examine evidence for both dimensions
2. Adjust the score that has weaker evidence
3. Note the adjustment in the output: `"Adjusted [dimension] from X to Y: consistency check with [related dimension]"`

### Running Individual Hats

If a user wants to run only one scorer, redirect them to `/score-hat [hat-name]` instead. The composite-scorer always runs all 5 hats.

### Skip Conditions

Do NOT run the composite-scorer when:
- **Pure API/backend project with no frontend**: Skip Hat 5 (ux-frontend-scorer). Redistribute its weight equally across Hats 3 and 4.
- **No codebase exists yet (pure ideation)**: Only run Hat 1 (product-scorer). Other hats have nothing to evaluate.
- **Infrastructure/DevOps project**: Skip Hat 1 (product-scorer) and Hat 5 (ux-frontend-scorer). Focus on Hats 2, 3, 4.
- **Design system/component library**: Skip Hat 1 (product-scorer). Run Hats 2-5 with extra weight on Hat 5.

When skipping hats, redistribute their weight proportionally across remaining hats. Document which hats were skipped and why in the output.
