---
name: score-hat
description: Run a single hat scorer (product, architecture, engineering, qa, ux-frontend)
---

# /score-hat

Run a single hat scorer against the current codebase. Use when you want to focus on one quality dimension without the full 5-hat audit.

## Usage

```
/score-hat [hat-name]
```

### Available Hats

| Hat | Skill | Shortcut Names |
|-----|-------|---------------|
| Hat 1 | product-scorer | `product`, `prod`, `pm` |
| Hat 2 | architecture-scorer | `architecture`, `arch`, `sa` |
| Hat 3 | engineering-scorer | `engineering`, `eng`, `code` |
| Hat 4 | qa-scorer | `qa`, `testing`, `test` |
| Hat 5 | ux-frontend-scorer | `ux`, `frontend`, `fe`, `ui` |

### Examples

```
/score-hat engineering
/score-hat qa
/score-hat ux
/score-hat arch
/score-hat product
```

### Prerequisite Check

Before running, verify:
1. **Hat name provided**: If no hat name given, show the available hats table and ask: "Which hat do you want to run?"
2. **Codebase accessible**: Run `ls` on the working directory. If empty, ask the user to navigate to the project.
3. **Hat applicability**: If user requests `ux` on a backend-only project (no `.tsx`/`.jsx` files), warn: "This project has no frontend files. UX Frontend scoring won't produce meaningful results. Did you mean `engineering` or `architecture`?"

## What Happens

1. The specified hat scorer runs its full process:
   - Discovery phase (finds relevant files)
   - Scores all 8 dimensions with evidence
   - Runs automated checks where applicable
   - Checks hat-specific hard stops
2. Outputs the category scorecard with dimension breakdown
3. Lists critical gaps for that category only

## When to Use Individual Hats

- **After writing new code**: Run `engineering` to check code quality
- **After schema changes**: Run `architecture` to verify data design
- **After adding tests**: Run `qa` to measure coverage improvement
- **After UI changes**: Run `ux` to check frontend quality
- **During planning**: Run `product` to verify scope and clarity
- **Quick check**: When you don't need the full composite but want to spot-check one area

## Limitations

- Individual hat scores are **unweighted** (no phase-based weighting applied)
- Hard stops are checked for the hat but not cross-hat (e.g., `qa` checks its own hard stops but not architecture security)
- No composite calculation: use `/score-project` for the full weighted picture

For the complete quality audit with composite scoring, use `/score-project` instead.
