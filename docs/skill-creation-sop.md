# Skill Creation SOP — Zero Duplication Guaranteed

**Version 2.0 | March 2026**
**Platforms: macOS, Linux, Windows**

---

## Before You Create: The 5-Check Protocol

Run these checks BEFORE creating any new skill. This prevents the #1 problem — duplicates.

### Check 1: Does it already exist as a skill?

```bash
smorch list | grep -i "<keyword>"
# Example: smorch list | grep -i "linkedin"
```

### Check 2: Does it exist in a plugin?

```bash
# Check all plugin skills
for plugin in ~/smorch-brain/plugins/*/; do
  echo "=== $(basename $plugin) ==="
  ls "$plugin/skills/" 2>/dev/null
done | grep -i "<keyword>"
```

### Check 3: Does it exist as an Anthropic built-in?

Check the skill list in any Claude Code session — Anthropic skills show with the `anthropic-skills:` prefix. Common ones: `frontend-design`, `webapp-testing`, `docx`, `pdf`, `xlsx`, `pptx`, `skill-creator`.

**Rule: NEVER duplicate an Anthropic built-in. Use the built-in directly.**

### Check 4: Is it really a skill, or should it be something else?

| If it is... | Make it a... |
|-------------|-------------|
| Deep domain knowledge (>50 lines, needs references) | **Skill** (SKILL.md + refs) |
| Quick action (<20 lines, user-triggered) | **Command** (.md in commands/) |
| Behavioral rule that always applies | **CLAUDE.md** entry (Layer 2 or 3) |
| Bundle for team distribution | **Plugin** containing skills |
| Tool connection config | **MCP config** (.mcp.json) |

### Check 5: Does a similar skill exist that should be extended instead?

Sometimes the right move is to add a reference file to an existing skill rather than create a new one. Example: instead of creating `smorch-linkedin-content-writer`, add a `content-templates.md` reference to `smorch-linkedin-intel`.

---

## Creation: Step-by-Step

### Step 1: Create the Skill Directory

```bash
mkdir -p ~/Desktop/cowork-workspace/SKILLs/<skill-name>
```

**Naming rules:**
- Lowercase letters, numbers, hyphens only
- Max 64 characters
- Prefixes: `smorch-` (agency), `eo-` (training), `smo-` (internal)
- Be specific: `smorch-cold-email-auditor` not `email-tool`

### Step 2: Create SKILL.md

```markdown
---
name: <skill-name>
description: "Third person. What it does AND when to use it. Include trigger words."
---

# [Skill Title]

## Purpose
[Business problem this solves — 1-2 sentences]

## When To Use
[Trigger conditions — what user says or context that activates this]

## When NOT To Use
[Skills that handle adjacent cases — prevents wrong-skill firing]

## Instructions
[The actual domain knowledge, steps, quality gates]
[Keep under 500 lines — move details to reference files]

## Cross-Skill Dependencies
[Other skills this references or chains to]
```

### Step 3: Add Metadata Files

```bash
# Category determines where it goes in the registry
echo "smorch-gtm" > ~/Desktop/cowork-workspace/SKILLs/<skill-name>/.smorch-category

# Version tracking
echo "1.0.0" > ~/Desktop/cowork-workspace/SKILLs/<skill-name>/.smorch-version
```

**Categories:** `smorch-gtm`, `eo-training`, `eo-scoring`, `content`, `dev-meta`, `tools`, `personal`

### Step 4: Add Reference Files (if >500 lines)

Split using progressive disclosure:
- `SKILL.md` — Overview, purpose, key logic (<500 lines)
- `templates.md` — Output templates, examples
- `reference-data.md` — Lookup tables, rubrics, detailed criteria
- `patterns.md` — Integration patterns, workflow details

Reference from SKILL.md: "For detailed templates, see templates.md"

### Step 5: Test Immediately

Skill is live instantly via the symlink (`~/.claude/skills/` → workspace).

```bash
# Open new Claude Code session and test:
# 1. Say something that should trigger the skill
# 2. Test with /skill-name if it has a command
# 3. Verify output quality
# 4. Test edge cases (wrong input, missing context)
```

### Step 6: Run Audit

```bash
# Mac/Linux
smorch audit

# Windows
.\smorch.ps1 audit
```
Should show: "All clear! No issues found." Fix any issues before pushing.

### Step 7: Push to Registry

```bash
# Mac/Linux
smorch push

# Windows
.\smorch.ps1 push
```
Commits to dev branch, maps to correct category.

### Step 8: Decide Placement

Use this decision tree:

```
Q1: Will this skill be shared with team or EO students?
├── YES → Which group?
│   ├── EO students → Add to eo-microsaas-os plugin
│   ├── GTM/Agency team → Add to smorch-gtm-engine plugin
│   ├── Dev team → Add to smorch-dev-toolkit plugin
│   └── Agency content team → Add to smorch-agency-tools plugin
└── NO → Keep in registry only (deployed via profiles)
    ├── Personal workflow → Category: personal
    └── Project-specific → .claude/skills/ in that repo
```

### Step 9: If Adding to Plugin

```bash
# Copy to plugin
cp -a ~/Desktop/cowork-workspace/SKILLs/<skill-name> \
      ~/smorch-brain/plugins/<plugin-name>/skills/<skill-name>

# Rebuild plugin
smorch build-plugin <plugin-name>

# Upload to Cowork: Customize > Plugins > Upload
# Remove standalone from: Customize > Skills (if it was there)
```

### Step 10: Deploy

```bash
# Promote to main
gh pr create --base main --head dev --title "skills: add <skill-name>"
gh pr merge --squash

# Deploy to all servers
smorch-sync-all
# Or per-server: ssh server "smorch pull"
```

---

## Cowork vs Claude Code: Where to Create?

| Scenario | Create In | Why |
|----------|-----------|-----|
| Building something complex with Cowork (3+ steps) | **Cowork** → then move to workspace | Cowork auto-offers skill creation |
| Technical/dev skill needing file I/O | **Claude Code** (workspace) | Direct access to SKILL.md, instant testing |
| Modifying existing skill | **Claude Code** (workspace) | Edit the file directly |
| Quick prototype to test an idea | **Cowork** | Faster iteration |

### When You Create in Cowork:

1. Cowork creates the skill in the session VM
2. `smorch push` pulls it from the Cowork session automatically
3. It lands in the workspace via the pull mechanism
4. Add `.smorch-category` and `.smorch-version` manually
5. Continue editing in workspace (Claude Code)

### When You Create in Claude Code:

1. Create directly in `~/Desktop/cowork-workspace/SKILLs/<name>/`
2. Add SKILL.md + metadata files
3. Test in the same session
4. `smorch push` to registry

---

## Syncing Skills Across Servers

### After Creating or Modifying a Skill:

```bash
# Mac/Linux:
smorch push                    # 1. Push to registry
gh pr create --base main --head dev --title "skills: add <skill-name>"  # 2. Promote
smorch-sync-all                # 3. Deploy to all servers

# Windows:
.\smorch.ps1 push              # 1. Push to registry
# Then promote via GitHub web UI or gh CLI
```

### Automatic Sync (Optional — Set Up Cron)

On each server, add to crontab:
```bash
# Sync skills daily at 6 AM
0 6 * * * cd ~/smorch-brain && git pull origin main --rebase && ~/smorch-brain/scripts/smorch pull 2>&1 >> /var/log/smorch-sync.log
```

---

## Anti-Duplication Checklist (Run Before Every Push)

```
[ ] Ran smorch audit — no issues
[ ] Skill name doesn't match any existing skill in smorch list
[ ] Skill name doesn't match any plugin skill
[ ] Skill is NOT a copy of an Anthropic built-in
[ ] If skill was in Cowork session AND added to plugin → removed from session
[ ] SKILL.md is under 500 lines
[ ] .smorch-category and .smorch-version files exist
[ ] Description includes both WHAT and WHEN (third person)
```
