---
description: Run scorecards or import scorecard results
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(wc:*)
argument-hint: [scorecard-number or "import"]
---

Entry point for Step 0: Scorecard Assessment. Supports three input paths.

Read the orchestrator for context:
@${CLAUDE_PLUGIN_ROOT}/skills/eo-os-navigator/SKILL.md

## Detect Which Path

### If $ARGUMENTS contains "import" or founder uploaded SC*.md files:
**Path A: Web Scorecard Import**
The founder completed scorecards at score.entrepreneursoasis.me and has markdown result files.

1. Scan workspace for SC*.md files using Glob
2. List what was found: "I found SC1 (96/100), SC3 (96/100). Missing: SC2, SC4, SC5."
3. If SC1 + SC2 exist: "You have enough to proceed to brain ingestion. Run /eo to continue."
4. If missing critical ones: "You need at least SC1 (Project Definition) and SC2 (ICP Clarity). Complete them at score.entrepreneursoasis.me or run /eo-score 1 to do SC1 right here."

### If $ARGUMENTS contains a number (1-5):
**Path C: In-Plugin Scoring**
Run the specified scorecard interactively right here in Claude.

Map to the right skill:
- 1 → project-definition-scoring-engine
- 2 → icp-clarity-scoring-engine (requires SC1 complete)
- 3 → market-attractiveness-scoring-engine (requires SC1 + SC2)
- 4 → strategy-selector-engine (requires SC1 + SC2 + SC3)
- 5 → gtm-fitness-scoring-engine (requires SC1 + SC2 + SC3 + SC4)

Before running any scorecard, check dependencies:
- Use Glob to find upstream SC results
- If upstream is missing, STOP: "SC2 requires SC1 to be completed first. Run /eo-score 1 or import your SC1 results."

When running the scorecard:
1. Invoke the corresponding scoring skill
2. The skill handles all questions, scoring, and output generation
3. Output gets saved as SC[N]-[venture-name]-[date].md in the workspace

### If $ARGUMENTS is empty or contains "docx":
**Path B: DOCX Import**
The founder has scoring DOCX files (downloadable Word documents with questions and answers).

1. Scan workspace for .docx files using Glob: `**/*.docx`
2. If DOCX files found with "scoring" or "scorecard" or "assessment" in the name:
   - Read the DOCX content
   - Extract the answers
   - Map answers to the corresponding scorecard engine
   - Run the scoring engine with the extracted answers (don't re-ask questions, just score)
   - Generate the standard SC output file
3. If no DOCX found, present the three paths:

"Three ways to get your scorecards done:

**Option 1: Web (Fastest)**
Complete them online at score.entrepreneursoasis.me
Upload the SC1-SC5 markdown results here.
→ Run: /eo-score import

**Option 2: DOCX (Offline)**
Upload your scoring Word documents.
I'll extract answers and score them.
→ Upload the files, then run: /eo-score docx

**Option 3: Right Here (Interactive)**
I'll walk you through each scorecard one question at a time.
Takes 30-60 minutes per scorecard.
→ Run: /eo-score 1 (starts with Project Definition)

Which path works for you?"

## After Any Scorecard Completes

1. Save the output file to the workspace
2. Check if more scorecards are needed
3. If all 5 done: "All scorecards complete. Run /eo to start brain ingestion."
4. If some done: "SC[N] complete ([score]/100 - [band]). Next: /eo-score [N+1]"

## Scorecard Dependency Chain

```
SC1 → SC2 → SC3 → SC4 → SC5
(each requires all previous to be complete)
```

SC4 (Strategy Selector) is special: it synthesizes SC1-SC3 data with AI, only asking 4 execution questions directly. SC5 (GTM Fitness) has 13 MC questions but scoring uses a 169-weight matrix that references all upstream data.
