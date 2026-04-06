# Session State Persistence - Full Reference

## JSON Schema

Save to `project-brain/eo-progress.json`:

```json
{
  "student_name": "string",
  "venture_name": "string",
  "started_at": "ISO date",
  "last_updated": "ISO date",
  "current_phase": "scoring | brain | gtm-assets | skill-extraction | architecture | build | qa | security | deploy",
  "completed_skills": [
    { "skill": "eo-score-1", "completed_at": "ISO date", "score": 96, "output_path": "SC1-*.md" },
    { "skill": "eo-brain-ingestion", "completed_at": "ISO date", "files_generated": 13, "output_path": "project-brain/" }
  ],
  "pending_skills": ["eo-gtm-asset-factory", "eo-skill-extractor"],
  "quality_gates": {
    "gate_0": { "status": "PASS", "timestamp": "ISO date" },
    "gate_1": { "status": "PASS", "files_count": 13, "timestamp": "ISO date" },
    "gate_2": { "status": "LOCKED" }
  },
  "scorecard_results": {
    "sc1": { "score": 96, "status": "PASS", "completed_at": "ISO date" },
    "sc2": { "score": 88, "status": "PASS", "completed_at": "ISO date" }
  },
  "coaching_flags": [
    { "flag": "SC3 market sizing weak", "context": "Pain cost evidence assumption-based", "action_recommended": "Run 5 more interviews", "status": "COACH_NOTED" }
  ],
  "next_action": "Run /eo-gtm-asset-factory",
  "estimated_completion_hours": 40
}
```

## Resume Display Template

```
EO MicroSaaS OS - Your Progress
=================================
Welcome back, [student_name]!
Building: [venture_name]
Started: [started_at] | Last updated: [last_updated]
Phase: [current_phase]

Completed:
  [x] SC1: Project Definition .... [score]/100
  [x] SC2: ICP Clarity ............ [score]/100
  [x] Brain Ingestion ............ COMPLETE ([N] files)

Next:
  [ ] GTM Asset Factory ........... READY
  [ ] Skill Extraction ............ LOCKED

Coaching Flags:
  [flag] -> [action_recommended]

Next Action: [next_action]
```

## Lifecycle Examples

### After SC1 completes
```json
{
  "current_phase": "scoring",
  "completed_skills": [{ "skill": "eo-score-1", "score": 96 }],
  "pending_skills": ["eo-score-2", "eo-score-3", "eo-score-4", "eo-score-5"],
  "next_action": "Run /eo-score 2 for SC2 (ICP Clarity)"
}
```

### After all scorecards
```json
{
  "current_phase": "brain",
  "completed_skills": [
    { "skill": "eo-score-1", "score": 96 },
    { "skill": "eo-score-2", "score": 88 },
    { "skill": "eo-score-3", "score": 91 },
    { "skill": "eo-score-4", "score": 92 },
    { "skill": "eo-score-5", "score": 85 }
  ],
  "next_action": "Run /eo-brain-ingestion to build project brain"
}
```

### After brain + GTM assets
```json
{
  "current_phase": "skill-extraction",
  "completed_skills": [
    { "skill": "eo-score-1", "score": 96 },
    { "skill": "eo-brain-ingestion", "files_generated": 13 },
    { "skill": "eo-gtm-asset-factory", "files_generated": 18 }
  ],
  "next_action": "Run /eo-skill-extractor"
}
```

## Resume Messaging

**After SC1 only:** "Welcome back! SC1 done (96/100). Next: SC2 (~20 min). Run /eo-score 2"

**After all scorecards:** "All 5 done! SC1:96 SC2:88 SC3:91 SC4:92 SC5:85. Next: brain ingestion (~2 hrs). Run /eo-brain-ingestion"

**After brain, stuck on architecture:** "Brain + GTM assets complete. Architecture blocked: CLAUDE.md missing. Run /eo-tech-architect (~45 min)"

## Update Rules

1. Append to completed_skills (never delete). Include: skill, timestamp, score, files_generated, output_path
2. Remove completed skill from pending_skills
3. Update current_phase at boundaries: scoring > brain > gtm-assets > skill-extraction > architecture > build > qa > security > deploy
4. Update quality_gates: PASS/FAIL with reason, unlock downstream when prerequisites met
5. Add coaching_flags: weak evidence, motion fit concerns, gate failures
6. Set next_action: exact command for next skill
