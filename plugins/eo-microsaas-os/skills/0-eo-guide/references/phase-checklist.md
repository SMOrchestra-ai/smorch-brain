# Phase Completion Checklist

**Used by:** 0-eo-guide when scanning directory to determine phase status.

## Phase 0: Scorecards

**Status: Complete when:**
- [ ] 5 scorecard files exist in 0-Scorecards/ (SC1 through SC5)
- [ ] Each scorecard has a parseable score (pattern: `XX/100` or `Score: XX`)
- [ ] Founder brief exists (optional but expected)

**How to detect scores:**
Search each file for patterns:
- `Clarity Score: XX/100`
- `Score: XX/100`
- `Overall Score: XX`
- Table rows with score values

**Files to look for:**
- `SC1-*` or `*Project-Definition*`
- `SC2-*` or `*ICP-Clarity*`
- `SC3-*` or `*Market-Attractiveness*`
- `SC4-*` or `*Strategy-Selector*`
- `SC5-*` or `*GTM-Fitness*`
- `eo-founder-brief-*` (bonus)

---

## Phase 1: Business Brain

**Status: Complete when:**
- [ ] 6 About-Me files exist in 1-ProjectBrain/About-Me/
- [ ] 10+ Project brain files exist in 1-ProjectBrain/Project/
- [ ] profile-settings.md exists in 1-ProjectBrain/
- [ ] cowork-instructions.md exists in 1-ProjectBrain/
- [ ] project-instruction.md exists in 1-ProjectBrain/
- [ ] At least 3 templates in 1-ProjectBrain/templates/

**Key files to verify (not empty):**
- 1-ProjectBrain/Project/icp.md
- 1-ProjectBrain/Project/positioning.md
- 1-ProjectBrain/Project/gtm.md
- 1-ProjectBrain/Project/brandvoice.md
- 1-ProjectBrain/profile-settings.md

**Status: In progress when:**
- Some files exist but key outputs missing (e.g., brain files exist but no profile-settings)

---

## Phase 2: GTM Assets

**Status: Complete when:**
- [ ] 2-GTM/output/preGTM/ has at least 3 files
- [ ] 2-GTM/output/GTM/ has at least 1 playbook file

**Status: In progress when:**
- preGTM output exists but no GTM playbook selected

**Prerequisites to check:**
- 2-GTM/Templates/preGTM/ has template files (should be pre-loaded)
- 2-GTM/Templates/GTM/ has template files (should be pre-loaded)
- If templates missing: flag to student, do not proceed

---

## Phase 3: Custom Skills

**Status: Complete when:**
- [ ] At least 1 SKILL.md file exists anywhere in 3-Newskills/ subfolders

**Status: In progress when:**
- Student has started skill creation but no completed SKILL.md

**Note:** This phase is "soft complete": 1 skill is the minimum. Students should create more over time.

---

## Phase 4: Architecture

**Status: Complete when:**
- [ ] 4-Architecture/tech-stack-decision.md exists (not empty)
- [ ] 4-Architecture/brd.md exists (not empty)
- [ ] 4-Architecture/mcp-integration-plan.md exists
- [ ] 4-Architecture/db-architecture.md exists

**Status: In progress when:**
- Some files exist but BRD missing

---

## Phase 5: Code Handover

**Status: Complete when:**
- [ ] 5-CodeHandover/INDEX.md exists with file manifest
- [ ] 5-CodeHandover/README.md exists with setup instructions

**Status: Not applicable until:**
- Phase 4 is complete (architecture + BRD must exist before handover)
