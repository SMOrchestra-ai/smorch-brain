# SMOrch GTM Scoring: Universal Score Bands & Rules

## Score Calculation Formula

```
Final Score = Sum(Criterion_Score x Criterion_Weight) / Sum(All_Weights)
```

Each criterion is scored 1-10. Weights are expressed as percentages summing to 100%.

## Score Bands

| Band | Range | Verdict | Action |
|------|-------|---------|--------|
| ELITE | 9.0-10.0 | Ship immediately | Top 5% of market. No changes needed. |
| STRONG | 7.5-8.9 | Ship with minor tweaks | Targeted refinements on lowest criteria, then ship. |
| ACCEPTABLE | 6.0-7.4 | Improve then ship | Specific criteria need work. Address before deployment. |
| BELOW STANDARD | 4.0-5.9 | Rework required | Fundamental issues. Do not ship. Rework weakest areas. |
| FAILED | Below 4.0 | Start over | Strategic or execution failure. Rebuild from scratch. |

## Hard Stop Rules

These override the overall score. A deliverable can score 9.0 overall and still fail if a hard stop triggers.

### Rule 1: Criterion Floor
Any single criterion scoring below 5.0 triggers mandatory rework on that dimension, regardless of overall score. A campaign with 9.0 average but 4.0 on Spam Filter Survival will fail in practice.

### Rule 2: Channel-Critical Failures
For channel-specific scoring (email, LinkedIn, WhatsApp), if the primary channel scores below 6.0, the entire asset is blocked from deployment. Secondary channels follow the standard Rule 1.

### Rule 3: MENA Context Floor
For MENA-targeted deliverables, the MENA Contextualization criterion (where present) must score 6.0+. A US-playbook copy-paste fails regardless of how polished the execution is.

## Score Descriptor Levels

Every criterion in the system uses 4 descriptor levels:

| Level | Score | Meaning |
|-------|-------|---------|
| 10/10 | What excellence looks like | The standard to aim for |
| 7/10 | What good-but-not-great looks like | Acceptable for shipping with tweaks |
| 5/10 | What mediocre looks like | The minimum before rework triggers |
| 1/10 | What failure looks like | Common mistakes to avoid |

## Fix Actions

Every criterion includes a specific Fix Action: the single most impactful correction when that criterion scores below 7.0. Fix Actions are designed to be actionable within 30 minutes, not aspirational goals.

## Rapid Score Protocol

For daily use when scoring many assets quickly, use the Rapid Score format:

```
RAPID SCORE: [Deliverable Name]
System: [1-6] | Subsystem: [A/B/C/D if applicable]
Date: [YYYY-MM-DD] | Scorer: [Name/AI]

Criteria (abbreviated):
C1: [score]/10 | C2: [score]/10 | C3: [score]/10 | ...

OVERALL: [weighted average]/10
HARD STOPS: [None / List criteria below 5.0]
VERDICT: [SHIP / TWEAK / IMPROVE / REWORK / RESTART]
TOP FIX: [Highest-impact improvement needed]
```

## JSON Output Format

When saving scores programmatically (for composite scoring), use this structure:

```json
{
  "system": "campaign-strategy",
  "subsystem": null,
  "deliverable": "Q2-MENA-SaaS-Campaign",
  "date": "2026-03-26",
  "scorer": "claude",
  "criteria": [
    {
      "id": "C1",
      "name": "Signal Clarity",
      "weight": 15,
      "score": 8.5,
      "fix_action": null
    }
  ],
  "overall_score": 7.8,
  "hard_stops": [],
  "verdict": "STRONG",
  "top_fix": "Improve multi-channel coordination timing",
  "timestamp": "2026-03-26T14:30:00Z"
}
```

## Interpolation Guide

The 4 descriptor levels (10/7/5/1) are anchors, not the only valid scores. Use this guide to score between levels:

### Score Interpolation Rules

| Score | How to Assign |
|-------|--------------|
| 10 | Matches the 10/10 descriptor with zero caveats. Nothing to improve. |
| 9 | Matches 10/10 in spirit but has 1 minor gap that doesn't affect performance. Example: email copy at 48 words instead of 50-80 sweet spot, but every word earns its place. |
| 8 | Clearly better than 7/10 descriptor. Exceeds "good" in most dimensions but falls short of excellence on 1-2 elements. Example: strong hook but social proof could be from a more relevant case study. |
| 7 | Matches the 7/10 descriptor. Solid work. Would perform in market but won't stand out. |
| 6 | Between 7/10 and 5/10. Has the bones of good work but 2-3 elements drag it down. Salvageable with targeted fixes. |
| 5 | Matches the 5/10 descriptor. Mediocre. Won't fail spectacularly but won't succeed either. |
| 4 | Between 5/10 and 1/10. Has one redeeming element but fundamental approach is wrong. |
| 3 | Closer to 1/10 than 5/10. Multiple fundamental issues. Requires rework, not fixes. |
| 2 | Nearly matches 1/10. One element keeps it from total failure. |
| 1 | Matches the 1/10 descriptor. Complete miss. |

### The "Would a VP Stop?" Test

When uncertain between two adjacent scores, apply this quick test:

- **For copy/content criteria:** Would a busy VP of Sales at a Series B SaaS company in Dubai stop what they're doing to read/watch/respond to this? If yes with enthusiasm → 9-10. If yes with mild interest → 7-8. If maybe → 5-6. If no → 1-4.
- **For strategy/positioning criteria:** Would this survive a 30-minute review by a GTM strategist who has run 200+ campaigns? If they'd approve with minor notes → 9-10. If they'd approve with changes → 7-8. If they'd send it back → 5-6. If they'd question the approach → 1-4.
- **For technical criteria (spam, deliverability, compliance):** Does this meet 2026 platform requirements? Pass = 7+. Mostly pass = 5-6. Fail = 1-4.

## Re-Scoring Protocol

After implementing fix actions, re-score using these rules:

### When to Re-Score

| Trigger | Action |
|---------|--------|
| Hard stop fixed (criterion was <5.0) | Re-score that criterion + any criterion it feeds via cross-system dependencies |
| Top fix implemented | Re-score the improved criterion + recalculate overall |
| Full rework completed | Re-score all criteria in the affected system |
| Campaign-level composite below 7.0 | Re-score all systems after upstream fixes |

### Re-Scoring Rules

1. **Score the new version independently.** Do not anchor to the previous score. Read the new deliverable fresh.
2. **Do not inflate for effort.** A rework that went from 4.0 to 5.5 is still below standard, even if the improvement was significant.
3. **Check upstream first.** If the original low score traced to an upstream dependency, verify the upstream fix landed before re-scoring the downstream criterion.
4. **Document the delta.** In the score JSON, include a `previous_score` field so trends are trackable.
5. **Re-check hard stops.** After re-scoring, run all 3 hard stop rules again. A fix on one criterion can shift another.

### Re-Score JSON Extension

```json
{
  "re_score": true,
  "previous_score": 5.5,
  "previous_date": "2026-03-26",
  "fix_applied": "Rewrote opening line with timeline hook referencing verified signal",
  "delta": "+2.5"
}
```
