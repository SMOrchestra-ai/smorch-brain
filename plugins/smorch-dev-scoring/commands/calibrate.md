---
name: calibrate
description: Record a calibration example from a real scoring run to improve future scoring consistency
---

# /calibrate

Record a real-world scoring run as a calibration example. Over time, calibration examples make scoring more consistent across sessions by anchoring scores to concrete projects.

## Usage

```
/calibrate
```

Run this after completing a `/score-project` or `/score-hat` run when you want to capture the scoring as a reference point.

## What This Command Does

1. **Reads the most recent scoring run** from the current session or `.scores/latest.json`
2. **Asks the user to confirm**: "Do these scores accurately reflect this project's quality? Any dimension you'd adjust?"
3. **Captures a calibration snapshot**:
   - Project name and type (SaaS, API, component library, etc.)
   - Phase at time of scoring
   - Stack (Next.js + Supabase, Express + PostgreSQL, etc.)
   - MENA-targeted: yes/no
   - All category and dimension scores with evidence summaries
   - Any user adjustments with rationale
4. **Appends to calibration library**: Writes to `.scores/calibration/[project-name]-[date].json`

## Calibration Snapshot Schema

```json
{
  "project": "salesmfast-sme",
  "type": "SaaS",
  "phase": "during-build",
  "stack": "Next.js 14, Supabase, Tailwind, n8n",
  "mena_targeted": true,
  "date": "2026-03-26",
  "composite": 7.2,
  "categories": {
    "product": { "score": 7.5, "key_evidence": "BRD validated with 5 ICP interviews, MVP 4 features" },
    "architecture": { "score": 8.1, "key_evidence": "Supabase RLS per table, typed API responses, ADRs exist" },
    "engineering": { "score": 6.5, "key_evidence": "Strict TS, 45% coverage, 8 any remaining, no CI security scan" },
    "qa": { "score": 5.0, "key_evidence": "12 test files, no edge case strategy, no security tests" },
    "ux-frontend": { "score": 7.0, "key_evidence": "Tailwind tokens, RTL partial, no design system docs" }
  },
  "user_adjustments": [
    { "category": "engineering", "dimension": "testing-strategy", "original": 5, "adjusted": 6, "rationale": "Tests are few but cover the highest-risk flows" }
  ],
  "lessons": "Coverage percentage misleading for early-stage: quality of test targets matters more than quantity"
}
```

## Why This Matters

Calibration solves the biggest weakness of LLM-based scoring: **session-to-session variance**. Without calibration anchors, the same codebase could score 6.5 in one session and 7.8 in another based on which evidence gets weighted more.

Each calibration example adds a concrete anchor. Over time, the calibration library becomes a scoring standard unique to your projects, stack, and quality expectations.

## When to Use

- After any scoring run where you reviewed and confirmed the scores
- When you disagree with a score and want to record the correction (captures your judgment)
- After a major quality improvement to capture the "before and after"
- When onboarding a new project type (first scoring of a mobile app, first scoring of a CLI tool) to establish baseline expectations

## Current Status

**This command collects data.** The calibration examples are stored but not yet auto-loaded by scorers. Future enhancement: scorers will read the calibration library and use the closest matching project as a scoring anchor.

For now, the calibration file at `../composite-scorer/references/calibration-examples.md` contains hand-written examples. As you run `/calibrate` on real projects, the stored snapshots will eventually replace those static examples with your actual project data.
