# Score Storage & History

## Storage Location

Scores are stored in the project directory at:

```
[project-root]/.scores/
├── latest.json              # Most recent scoring run (symlink or copy)
├── 2026-03-26T14-30.json    # Timestamped score files
├── 2026-03-20T09-15.json
└── history.json             # Aggregated history for delta tracking
```

## Score File Schema (per run)

```json
{
  "version": "1.0",
  "project": "project-name",
  "date": "2026-03-26T14:30:00Z",
  "phase": "during-build",
  "scorer_version": "smorch-dev-scoring@1.0.0",
  "composite": {
    "score": 7.2,
    "grade": "B",
    "hard_stops_passed": 6,
    "hard_stops_failed": 1,
    "hard_stops_na": 0
  },
  "categories": {
    "product": {
      "score": 7.5,
      "weight": 0.20,
      "weighted": 1.50,
      "dimensions": {
        "problem-clarity": { "score": 8, "evidence": "BRD defines WHO + pain + trigger moment" },
        "scope-discipline": { "score": 7, "evidence": "MVP has 4 features, no explicit not-building list" },
        "requirements-quality": { "score": 7, "evidence": "User stories exist, acceptance criteria on 60%" },
        "roadmap-strategy": { "score": 8, "evidence": "3 phases with decision gates" },
        "market-validation": { "score": 8, "evidence": "5 ICP interviews documented" },
        "success-metrics": { "score": 7, "evidence": "North star defined, no baselines yet" },
        "competitive-positioning": { "score": 7, "evidence": "2 differentiators identified" },
        "resource-scope-fit": { "score": 8, "evidence": "Solo founder + AI, 4-week timeline realistic" }
      }
    },
    "architecture": {
      "score": 8.1,
      "weight": 0.25,
      "weighted": 2.025,
      "dimensions": { }
    },
    "engineering": {
      "score": 6.5,
      "weight": 0.25,
      "weighted": 1.625,
      "dimensions": { }
    },
    "qa": {
      "score": 5.0,
      "weight": 0.15,
      "weighted": 0.75,
      "dimensions": { }
    },
    "ux-frontend": {
      "score": 7.0,
      "weight": 0.15,
      "weighted": 1.05,
      "dimensions": { }
    }
  },
  "hard_stops": {
    "security-architecture": { "status": "pass", "score": 7 },
    "security-practices": { "status": "pass", "score": 6 },
    "security-testing": { "status": "na", "reason": "during-build phase, not enforced" },
    "data-integrity": { "status": "pass", "score": 6 },
    "problem-clarity": { "status": "na", "reason": "not pre-build phase" },
    "functional-completeness": { "status": "na", "reason": "during-build phase, not enforced" },
    "rtl-bilingual": { "status": "fail", "score": 3, "mena_product": true }
  },
  "top_gaps": [
    { "category": "ux-frontend", "dimension": "rtl-bilingual", "score": 3, "target": 8, "impact": 0.375 },
    { "category": "qa", "dimension": "functional-completeness", "score": 4, "target": 8, "impact": 0.30 }
  ]
}
```

## History File Schema

The `history.json` file is an append-only array of summary entries:

```json
{
  "entries": [
    {
      "date": "2026-03-20T09:15:00Z",
      "phase": "during-build",
      "composite": 6.2,
      "grade": "C",
      "hard_stops_failed": 2,
      "category_scores": { "product": 7.0, "architecture": 7.5, "engineering": 5.5, "qa": 4.0, "ux-frontend": 6.0 }
    },
    {
      "date": "2026-03-26T14:30:00Z",
      "phase": "during-build",
      "composite": 7.2,
      "grade": "B",
      "hard_stops_failed": 1,
      "category_scores": { "product": 7.5, "architecture": 8.1, "engineering": 6.5, "qa": 5.0, "ux-frontend": 7.0 },
      "delta": {
        "composite": +1.0,
        "improved": ["engineering", "qa", "ux-frontend"],
        "regressed": [],
        "hard_stops_resolved": ["data-integrity"]
      }
    }
  ]
}
```

## How Scorers Should Use This

### Writing Scores (composite-scorer)

After completing a scoring run:

1. Create `.scores/` directory if it doesn't exist: `mkdir -p .scores`
2. Write the full score JSON to `.scores/[ISO-date].json`
3. Copy to `.scores/latest.json`
4. Read existing `history.json`, append summary entry with delta calculation, write back
5. Include the delta in the output report

### Reading Scores (gap-bridger)

1. Check for `.scores/latest.json` first
2. If not found, check if scores are in the current conversation context
3. If neither exists, prompt user to run `/score-project`

### Reading History (composite-scorer output)

1. Read `.scores/history.json`
2. Show last 5 entries in the Score History table
3. Calculate trend: improving, stable, or regressing based on last 3 composite scores

## Git Integration

Add to `.gitignore` recommendation:
```
# Score history is project-specific, include in repo for team visibility
# Do NOT gitignore .scores/ — it's valuable team context
```

Score files are small JSON, safe to commit. They provide team-wide visibility into quality trends without any external tool dependency.
