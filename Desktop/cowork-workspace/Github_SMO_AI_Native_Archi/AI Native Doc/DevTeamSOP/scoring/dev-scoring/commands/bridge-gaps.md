---
name: bridge-gaps
description: Generate a prioritized improvement plan from scorecard results
---

# /bridge-gaps

Transform scorecard gaps into a prioritized, sprint-ready improvement plan. Run this after `/score-project` or `/score-hat`.

## Usage

```
/bridge-gaps
```

No arguments required.

### Prerequisite Check

The gap-bridger needs scores to work with. It checks in this order:
1. **Same-session scores**: Were scores produced by `/score-project` or `/score-hat` earlier in this conversation? Use those.
2. **Stored scores**: Check for `.scores/latest.json` in the project root. If found, load and use.
3. **User-provided scores**: If neither exists, ask the user to either run `/score-project` first or provide scores manually (see format below).

Do NOT generate a gap bridge plan without actual scores. Guessing defeats the purpose.

The gap-bridger will:

1. Read scores from the most recent scoring run in this session
2. Identify all dimensions below target threshold
3. Calculate impact-to-effort ratio for each gap
4. Generate specific, actionable remediation tasks
5. Organize into a sprint plan

## What You Get

- **Hard stop resolutions** (always first): tasks that must be done before shipping
- **Priority queue**: all gaps ranked by (impact on composite score) / (effort to fix)
- **Specific tasks**: not "improve testing" but "add Jest tests for auth flow in `src/lib/auth.ts` covering login, logout, and role-based access"
- **Sprint plan**: which tasks to tackle this week, next week, week after
- **Quick wins**: tasks under 1 hour that move a score

## When to Use

- **Immediately after `/score-project`**: the natural next step
- **Sprint planning**: prioritize quality work alongside features
- **After a scoring regression**: identify what broke and how to fix it
- **Before a deadline**: focus on highest-impact improvements with limited time

## Providing Scores Manually

If scores aren't from a recent session run, you can provide them:

```
/bridge-gaps
Scores:
- Product: 7.2
- Architecture: 8.1
- Engineering: 6.5
- QA: 5.0
- UX: 7.0
Phase: During Build
```

The gap-bridger will work with whatever score data you provide. More detail (dimension-level scores) produces more specific task recommendations.
