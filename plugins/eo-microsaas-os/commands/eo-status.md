---
description: Check your MicroSaaS journey progress
allowed-tools: Read, Glob, Grep, Bash(ls:*), Bash(wc:*)
---

Display the founder's current progress through the EO MicroSaaS OS journey.

Read the navigator for the status detection protocol and progress display format:
@${CLAUDE_PLUGIN_ROOT}/skills/eo-os-navigator/SKILL.md

Scan the workspace for all progress markers:

1. Scorecard files (`**/SC[1-5]*.md`) - check each individually, report scores if found in file headers
2. Brain files (`**/project-brain/*.md`) - count how many of 12 exist, check each has 200+ chars of real content
3. GTM assets (`**/assets/`) - list what's been generated
4. Architecture docs (`**/architecture/`) - check for brd.md, tech-stack-decision.md, architecture-diagram.md (Phase 1, Cowork)
5. CLAUDE.md (`**/CLAUDE.md`) - check if workspace instructions exist (produced by eo-tech-architect in Cowork)
6. Source code (`**/src/`) - check if app scaffold exists
7. QA report (`**/qa-report.md`) - check for PASS/FAIL status
8. Security audit (`**/security-audit.md`) - check for CRITICAL findings count
9. Deployment (`**/Dockerfile`, `**/deployment-guide.md`) - check existence

Display the full progress dashboard. Highlight the next recommended action.

If the founder is in Cowork and has brain files but no architecture, nudge them toward Step 4: "Your brain files are ready. Next: run eo-tech-architect to produce your BRD, stack decisions, and CLAUDE.md. This is the last step before graduation."

If the founder has architecture + CLAUDE.md but hasn't graduated, nudge: "Architecture is done. Run /eo-graduate to get your handoff package and switch to Claude Code."

End with: estimated time remaining based on what's left to complete.
