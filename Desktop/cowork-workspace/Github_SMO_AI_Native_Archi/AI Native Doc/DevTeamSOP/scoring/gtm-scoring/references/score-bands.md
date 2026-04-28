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
