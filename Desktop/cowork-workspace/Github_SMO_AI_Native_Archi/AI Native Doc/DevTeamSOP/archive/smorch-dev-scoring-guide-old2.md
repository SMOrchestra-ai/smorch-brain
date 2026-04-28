# smorch-dev-scoring — Usage Guide

**The 5-Hat Quality Scorecard System for Coding Projects**
Version 1.1.0 | SMOrchestra.ai

---

## What This Plugin Does

Scores any coding project from 5 expert perspectives (hats), each evaluating 8 dimensions. Produces a weighted composite score, enforces hard stop quality gates, and generates sprint-ready improvement plans.

The five hats:

1. **Product** (CPO hat): Is the right thing being built, for the right market, at the right scope?
2. **Architecture** (SA hat): Will this survive production, scale, and change requests?
3. **Engineering** (Dev Lead hat): Would you maintain this code at 3am when it breaks?
4. **QA** (Testing hat): Would a paying customer trust this product?
5. **UX Frontend** (Designer hat): Would a designer be proud to claim this as their work?

Each hat scores 8 dimensions on a 1-10 scale using anchor rubrics (not vibes). Phase-based weighting adjusts which hats matter most depending on project stage.

---

## Quick Start

### Score your full project

```
/score-project
```

This runs all 5 hats sequentially, applies phase-based weights, checks hard stops, and produces the composite score. Takes 3-5 minutes depending on codebase size.

### Score a single area

```
/score-hat engineering
/score-hat qa
/score-hat ux
/score-hat arch
/score-hat product
```

Quick focus on one quality dimension. Useful after making changes in a specific area.

### Generate improvement plan

```
/bridge-gaps
```

Run after scoring. Converts gaps into prioritized tasks ranked by impact/effort ratio, organized into sprints.

### Record calibration data

```
/calibrate
```

Run after a scoring session you've reviewed. Captures the scores as a calibration anchor for future consistency.

---

## Understanding the Composite Score

### Phase-Based Weighting

The plugin detects (or asks) which phase your project is in, then adjusts category weights:

| Category | Pre-Build | During Build | Pre-Launch | Post-Launch |
|----------|-----------|-------------|------------|-------------|
| Product | **30%** | 20% | 15% | 20% |
| Architecture | **30%** | **25%** | 15% | 15% |
| Engineering | 15% | **25%** | **25%** | **25%** |
| QA | 10% | 15% | **25%** | **25%** |
| UX Frontend | 15% | 15% | **20%** | 15% |

Why this matters: scoring a pre-build project harshly on QA test coverage is unfair. Scoring a pre-launch project leniently on security is dangerous.

### Grade Scale

| Composite | Grade | What It Means |
|-----------|-------|---------------|
| 9.0-10.0 | A+ | Ship with confidence. Elite quality. |
| 8.0-8.9 | A | Strong. Minor polish needed. |
| 7.0-7.9 | B | Solid. Known gaps have clear remediation path. |
| 6.0-6.9 | C | Acceptable with caveats. Active work needed. |
| 5.0-5.9 | D | Below bar. Significant gaps before shipping. |
| < 5.0 | F | Critical. Major rework required. |

### Hard Stop Quality Gates

Seven dimension-level scores that trigger a FAIL regardless of composite:

| Hard Stop | Threshold | When Enforced |
|-----------|-----------|---------------|
| Security Architecture (Hat 2) | Score < 5 | All phases |
| Security Practices (Hat 3) | Score < 5 | All phases |
| Security Testing (Hat 4) | Score < 5 | Pre-Launch + Post-Launch |
| Data Integrity (Hat 4) | Score < 5 | All phases |
| Problem Clarity (Hat 1) | Score < 4 | Pre-Build only |
| Functional Completeness (Hat 4) | Score < 5 | Pre-Launch + Post-Launch |
| RTL/Bilingual (Hat 5) | Score < 5 | All phases (MENA products) |

A project scoring 8.5 composite but 3 on Security Architecture still FAILS. Hard stops exist because certain quality dimensions have non-linear risk.

---

## When to Use Each Command

### /score-project — Full Quality Audit

Use when:

- **Before shipping**: Pre-launch quality gate. Run this before any production deployment.
- **Sprint review**: Measure quality progress. Compare scores to last run.
- **After major refactor**: Verify quality didn't regress.
- **New project onboarding**: Baseline assessment of inherited or new codebase.
- **Client deliverable**: Quality assurance before handoff.

### /score-hat [name] — Focused Check

Use when:

- **After writing new code**: `/score-hat engineering` to check code quality
- **After schema changes**: `/score-hat arch` to verify data design
- **After adding tests**: `/score-hat qa` to measure coverage improvement
- **After UI work**: `/score-hat ux` to check frontend quality
- **During planning**: `/score-hat product` to verify scope and clarity

### /bridge-gaps — Improvement Plan

Use when:

- **Immediately after scoring**: The natural next step
- **Sprint planning**: Prioritize quality work alongside features
- **Before a deadline**: Focus on highest-impact improvements with limited time
- **After regression**: Identify what broke and how to fix it

### /calibrate — Build Scoring Memory

Use when:

- **After reviewing scores**: Confirm accuracy, record corrections
- **New project type**: First scoring of a mobile app, CLI tool, etc.
- **Quality milestone**: Capture before/after of a major improvement

---

## How Scoring Works (Under the Hood)

### The 40 Dimensions

Each hat evaluates 8 weighted dimensions. Every dimension has a 5-level anchor rubric:

| Level | Score Range | Meaning |
|-------|------------|---------|
| Critical | 1-3 | Fundamental problems. Missing or broken. |
| Below Standard | 4-5 | Exists but insufficient. Major gaps. |
| Acceptable | 6-7 | Meets minimum bar. Known gaps documented. |
| Strong | 8-9 | Professional quality. Minor improvements possible. |
| Elite | 10 | Best-in-class. Exceeds expectations. |

### Evidence-Based Scoring

The scorer doesn't guess. For each dimension, it:

1. **Discovers** relevant files (schema, tests, components, configs)
2. **Runs automated checks** where possible (grep for `any`, count test files, check ARIA labels)
3. **Matches evidence** to anchor rubrics
4. **Cites specific files** and patterns observed
5. **Assigns score** with justification

### MENA-Specific Scoring

For Arabic/MENA-targeted products, extra considerations apply:

- **RTL layout** is a hard stop, not a nice-to-have. Broken Arabic UI = trust destroyer.
- **Arabic typography** needs specific fonts (Cairo, Tajawal, IBM Plex Arabic) with adjusted line-height (1.6-1.8x).
- **WhatsApp patterns** matter if WhatsApp is a touchpoint.
- **Gulf timezone handling** in date operations.
- **Arabic input** in form validation (diacritics, bidirectional text, phone formats).

### Cross-Hat Consistency

The composite-scorer checks 5 dimension pairs across hats for contradictions. Example: if Architecture Security scores 8 but Engineering Security Practices scores 4, that's flagged and one score gets adjusted based on evidence strength.

### Score Persistence

Scores are saved to `.scores/` in the project root:

```
.scores/
├── latest.json              # Most recent run
├── 2026-03-26T14-30.json    # Timestamped runs
└── history.json             # Delta tracking
```

This enables trend tracking: is quality improving, stable, or regressing?

---

## Integration with Development Workflow

### Recommended Cadence

| Event | Action |
|-------|--------|
| Project kickoff | `/score-hat product` to validate scope |
| Architecture locked | `/score-hat arch` to verify design |
| Every sprint review | `/score-project` for full audit |
| Before staging deploy | `/score-project` + verify no hard stops |
| Before production deploy | `/score-project` must pass all hard stops |
| After deploy | `/calibrate` to record baseline |

### Skip Conditions

The plugin is smart about what doesn't apply:

- **Pure API/backend**: Hat 5 (UX) skipped, weight redistributed
- **Pure ideation**: Only Hat 1 (Product) runs
- **Infrastructure project**: Hats 1 and 5 skipped
- **Design system**: Hat 1 skipped, extra weight on Hat 5

### Working with /bridge-gaps Output

The gap bridger produces sprint-ready tasks. Each task includes:

- **What**: Specific files and components to change
- **Why**: Impact on composite score
- **How**: Concrete implementation steps
- **Acceptance criteria**: How to verify the gap is bridged
- **Effort estimate**: XS (<1hr), S (1-4hr), M (4-16hr), L (2-5 days), XL (1-2 weeks)

Tasks are ranked by impact/effort ratio. Hard stop violations always sort to the top.

---

## Plugin Architecture

7 skills, 4 commands, 12 reference documents.

```
smorch-dev-scoring/
├── .claude-plugin/plugin.json
├── skills/
│   ├── product-scorer/          # Hat 1: scope, roadmap, market
│   │   ├── SKILL.md
│   │   └── references/product-anchors.md
│   ├── architecture-scorer/     # Hat 2: data, API, security design
│   │   ├── SKILL.md
│   │   └── references/architecture-anchors.md
│   ├── engineering-scorer/      # Hat 3: code quality, testing, CI
│   │   ├── SKILL.md
│   │   └── references/engineering-anchors.md
│   ├── qa-scorer/               # Hat 4: testing, edge cases, data
│   │   ├── SKILL.md
│   │   └── references/qa-anchors.md
│   ├── ux-frontend-scorer/      # Hat 5: visual, a11y, RTL
│   │   ├── SKILL.md
│   │   └── references/ux-frontend-anchors.md
│   ├── composite-scorer/        # Orchestrator: runs all 5, weights, gates
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── phase-weights.md
│   │       ├── hard-stops.md
│   │       ├── score-storage.md
│   │       └── calibration-examples.md
│   └── gap-bridger/             # Score-to-action converter
│       ├── SKILL.md
│       └── references/effort-matrix.md
└── commands/
    ├── score-project.md         # /score-project
    ├── score-hat.md             # /score-hat [name]
    ├── bridge-gaps.md           # /bridge-gaps
    └── calibrate.md             # /calibrate
```

---

## Installation

Upload `smorch-dev-scoring.plugin` to your Claude Desktop marketplace ("My Uploads"). The plugin will appear in your available skills and commands immediately.

After installation, verify by running `/score-hat product` on any project.
