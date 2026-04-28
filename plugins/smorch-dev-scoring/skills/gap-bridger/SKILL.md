<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: gap-bridger
description: >-
  Takes scorecard results and generates a prioritized improvement plan with specific, actionable tasks. Calculates effort-to-impact ratio for each gap and produces a sprint-ready backlog. Triggers on "bridge gaps", "improvement plan", "how do I get to 8", "fix the scores", "what should I improve first", "remediation plan", "upgrade quality".
---

# Gap Bridger — Score-to-Action Converter

Transform scorecard gaps into a prioritized, sprint-ready improvement plan. Skill 7 of the 5-Hat Quality Scorecard System.

The core question: **What's the highest-impact thing to fix right now to move the composite score up?**

## Process

### Step 1: Ingest Scores

Accept scores from one of three sources:

1. **Previous composite-scorer run in same session**: Read the scores directly from context
2. **User-provided scores**: Parse a table or list of category + dimension scores
3. **Fresh scoring run**: If no scores exist, prompt user to run `/score-project` first

Required data per dimension:
- Current score (1-10)
- Category it belongs to (Hat 1-5)
- Phase weight of that category

### Step 2: Identify All Gaps

A gap is any dimension scoring below **target threshold**:

| Current Score | Gap Priority | Target |
|---------------|-------------|--------|
| 1-3 | CRITICAL | Reach 5 (minimum viable) |
| 4-5 | HIGH | Reach 7 (acceptable) |
| 6-7 | MEDIUM | Reach 8 (strong) |
| 8-9 | LOW | Reach 10 (elite, optional) |

Hard stop violations are always CRITICAL regardless of score bucket.

### Step 3: Calculate Impact Score

For each gap, calculate the impact of bridging it:

```
Impact = (target_score - current_score) × dimension_weight × category_weight

Example:
  Security Architecture: current 3, target 8
  Dimension weight: 15% (0.15)
  Category weight (During Build): 25% (0.25)
  Impact = (8 - 3) × 0.15 × 0.25 = 0.1875 composite points
```

This tells you exactly how many composite points you gain by fixing each gap.

### Step 4: Estimate Effort

Read `references/effort-matrix.md` for typical effort estimates per dimension.

Classify each remediation as:

| Effort | Definition | Typical Time |
|--------|-----------|-------------|
| XS | Config change, single file edit | < 1 hour |
| S | Add a pattern to 2-5 files | 1-4 hours |
| M | New feature or refactor across a module | 4-16 hours |
| L | Architectural change, major refactor | 2-5 days |
| XL | Fundamental rethink, system redesign | 1-2 weeks |

### Step 5: Prioritize by Impact/Effort Ratio

```
Priority Score = Impact / Effort_hours

Rank all gaps by priority score, descending.
Hard stop violations always sort to the top regardless of ratio.
```

### Step 6: Generate Action Plan

For each gap, produce a specific, actionable task:

**Bad**: "Improve error handling"
**Good**: "Add React ErrorBoundary components around Dashboard, Settings, and Reports sections. Create a shared `<ErrorFallback>` component with retry button and error reporting to Sentry."

Each task must include:
1. **What**: Specific files, components, or systems to change
2. **Why**: How this impacts the score and user experience
3. **How**: Concrete implementation steps (not vague guidance)
4. **Acceptance criteria**: How to verify the gap is bridged
5. **Score impact**: Expected composite point gain

### Step 7: Output Format

```
# Gap Bridge Plan — [Project Name]
Phase: [phase] | Current Composite: X.X | Target: X.X | Date: [date]

## Hard Stop Resolutions (DO FIRST)
[If any hard stop violations exist, list them here with full remediation]

### HS-1: [Dimension] — Score: X → Target: 5+
**What**: [specific change]
**Files**: [specific files to modify]
**Steps**:
1. [concrete step]
2. [concrete step]
**Acceptance**: [how to verify]
**Impact**: Removes hard stop block + X.XX composite points

## Priority Queue (Ranked by Impact/Effort)

| # | Category > Dimension | Current | Target | Impact | Effort | Priority |
|---|---------------------|---------|--------|--------|--------|----------|
| 1 | [Cat] > [Dim] | X | 8 | +X.XX | [S/M/L] | [score] |
| 2 | ... | ... | ... | ... | ... | ... |

### Task 1: [Descriptive Title]
**Gap**: [Category] > [Dimension] — Score X → 8
**Impact**: +X.XX composite points
**Effort**: [XS/S/M/L/XL] (~X hours)
**What**: [specific change]
**Files**: [specific files]
**Steps**:
1. [step]
2. [step]
3. [step]
**Acceptance**: [verification criteria]

### Task 2: ...
[repeat for top 10 gaps]

## Sprint Recommendation
Default sprint velocity: 40 dev-hours per week (solo founder) or 80 dev-hours per week (2-person team). Adjust based on actual capacity.

Based on effort estimates, a realistic sprint plan:

**Sprint 1 (this week)**: Tasks 1-3 → Expected composite: X.X (+X.X)
**Sprint 2 (next week)**: Tasks 4-7 → Expected composite: X.X (+X.X)
**Sprint 3 (week 3)**: Tasks 8-10 → Expected composite: X.X (+X.X)

## Quick Wins (< 1 hour each)
- [task that takes <1 hour and moves a score]
- [task that takes <1 hour and moves a score]
```

### MENA Priority Boost

For MENA-targeted products, boost priority of these gaps regardless of impact/effort ratio:

- **RTL/Bilingual (Hat 5)**: Any score below 7 gets priority boost. Broken Arabic layout is a trust-killer in the Gulf; users leave before they evaluate your features.
- **Arabic input handling (QA: Edge Case Coverage)**: Form inputs that break with Arabic text are show-stoppers for Arabic-first products.
- **WhatsApp integration (QA: Functional Completeness)**: If WhatsApp is a channel, message template compliance and media handling gaps are revenue-blocking.

### Using with Scoring History

If previous scores exist, the gap bridger should show delta:
- Which gaps were addressed since last scoring
- Which gaps are new (regression)
- Velocity: composite points gained per sprint
