---
description: Get the 8 brain templates for manual entry
allowed-tools: Read, Write, Bash(cp:*), Bash(mkdir:*)
---

The founder wants the manual brain templates (Path B - no scorecards).

Copy all 8 brain templates from the plugin's reference directory to the founder's workspace:

1. Create a `brain-templates/` directory in the workspace root
2. Copy these files from `${CLAUDE_PLUGIN_ROOT}/skills/eo-os-navigator/references/brain-templates/`:
   - problem.md
   - icp.md
   - features.md
   - competitors.md
   - positioning.md
   - my-background.md
   - my-resources.md
   - my-goals.md

After copying, tell the founder:

"Here are your 8 brain templates. Fill them in this order:

**About your project (fill first):**
1. problem.md - the pain you're solving
2. icp.md - your ideal customer in detail
3. features.md - MVP features only (max 5)
4. competitors.md - who else solves this and their weaknesses
5. positioning.md - why you're the better choice

**About you (fill second):**
6. my-background.md - your experience and skills
7. my-resources.md - budget, time, tools you have
8. my-goals.md - what success looks like and your timeline

Rules: be specific, use real numbers, name real people. If your ICP section says 'SMEs in GCC', I'll send you back. When all 8 are filled, say '/eo' and I'll process them into your project brain."
