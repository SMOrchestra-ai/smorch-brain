---
description: Run composite scoring across all applicable systems for a full campaign. Produces Campaign Health score with improvement priority matrix.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(wc:*), Bash(mkdir:*)
argument-hint: '[campaign-name]'
---

# /score-all — Full Campaign Composite Scoring

Scores every applicable system for a campaign and computes the Campaign Health composite score.

## When to Use

Use when scoring an entire campaign end-to-end, not a single deliverable. This command runs multiple scorers and produces the composite Campaign Health report.

## Execution Flow

### Step 1: Identify Campaign Assets

Ask or scan workspace for campaign deliverables:

"To run a full campaign score, I need to identify which assets exist. Point me to:
1. Campaign strategy document (System 1)
2. Offer/positioning materials (System 2)
3. Email sequences (System 3A)
4. VSL script (System 3B) — if applicable
5. LinkedIn DM sequences (System 3C) — if applicable
6. WhatsApp messages (System 3D) — if applicable
7. Social media posts (System 4) — if applicable
8. YouTube content (System 5) — if applicable
9. LinkedIn brand posts (System 6) — if applicable"

If $ARGUMENTS contains a campaign name, search workspace for assets matching that campaign.

### Step 2: Score Each System

Run each applicable scorer sequentially. For each:
1. Load the content
2. Score against all criteria
3. Save individual score JSON
4. Track for composite calculation

### Step 3: Compute Campaign Health

Read `references/composite-formula.md` for the formula:

```
Campaign Health = (Campaign Strategy x 0.25) +
                  (Offer/Positioning x 0.20) +
                  (Best Copywriting Subsystem x 0.25) +
                  (Social Media x 0.15) +
                  (YouTube OR LinkedIn x 0.15)
```

Normalize weights for systems not scored.

### Step 4: Assign Improvement Priority

Using the 7-level matrix from `references/composite-formula.md`:

```
P0: EMERGENCY — hard stop triggered
P1: CRITICAL — overall < 6.0
P2: HIGH — highest-weighted criterion below 7.0
P3: MEDIUM — 2+ criteria below 7.0
P4: LOW — overall 7.0-7.5
P5: OPTIMIZATION — overall 7.5-8.5
P6: MAINTENANCE — overall 8.5+
```

### Step 5: Check Cross-System Dependencies

From `references/composite-formula.md`, check whether low scores in one system indicate upstream causes:

| Weak System | Check First |
|-------------|-------------|
| Copywriting personalization low | Campaign Strategy: Signal Clarity |
| Social media authority low | LinkedIn Branding: Authority Signal |
| Email reply rate low | Offer: Dream Outcome Clarity |
| YouTube retention low | Offer: Unique Mechanism |

### Step 6: Present Campaign Health Report

```
CAMPAIGN HEALTH REPORT: [Campaign Name]
Date: [YYYY-MM-DD]

SYSTEM SCORES:
| System | Score | Weight | Weighted | Hard Stops |
|--------|-------|--------|----------|------------|
| Campaign Strategy | X.X | 25% | Y.Y | [None/List] |
| Offer/Positioning | X.X | 20% | Y.Y | [None/List] |
| Copywriting (best) | X.X | 25% | Y.Y | [None/List] |
| Social Media | X.X | 15% | Y.Y | [None/List] |
| YouTube/LinkedIn | X.X | 15% | Y.Y | [None/List] |

CAMPAIGN HEALTH: X.X / 10
STATUS: [GREEN / YELLOW / ORANGE / RED]
PRIORITY: [P0-P6]

WEAKEST LINK: [System] at X.X
STRONGEST ASSET: [System] at X.X
CROSS-SYSTEM ISSUES: [Dependencies identified]

IMPROVEMENT ROADMAP:
1. [Priority]: [Fix] — [Impact estimate]
2. [Priority]: [Fix] — [Impact estimate]
3. [Priority]: [Fix] — [Impact estimate]

DEPLOYMENT RECOMMENDATION:
[Deploy / Deploy with monitoring / Fix first / Major rework]
```

### Step 7: Save Composite

Save the composite score to `scores/campaign-health-[name]-[date].json` in the workspace.
