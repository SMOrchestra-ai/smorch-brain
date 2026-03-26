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
4. Architecture docs (`**/architecture/`) - check for brd.md, tech-stack-decision.md, architecture-diagram.md
5. Source code (`**/src/`) - check if app scaffold exists
6. QA report (`**/qa-report.md`) - check for PASS/FAIL status
7. Security audit (`**/security-audit.md`) - check for CRITICAL findings count
8. Deployment (`**/Dockerfile`, `**/deployment-guide.md`) - check existence

Display the full progress dashboard. Highlight the next recommended action.

If the founder is stuck between phases (has brain files but no GTM assets and no architecture), suggest which parallel path to take based on their goals: "If you want to start building, go to /eo architect. If you want to start marketing while building, go to /eo gtm."

End with: estimated time remaining based on what's left to complete.
