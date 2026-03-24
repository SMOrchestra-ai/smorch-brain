# Skill Management SOP — SMOrchestra.ai

**Version 1.0 | March 2026**
**CLI Version: smorch v2.0.0**

---

## Quick Reference

| Command | What | Who |
|---------|------|-----|
| `smorch push` | Export workspace skills to registry (dev branch) | Mamoun |
| `smorch pull --profile <name>` | Install profile-filtered skills from main | Any machine |
| `smorch audit` | Check for issues (unmapped, oversized, orphans) | Anyone |
| `smorch build-plugin <name>` | Build .plugin zip for distribution | Release |
| `smorch status` | Show profile, sync time, counts | Anyone |
| `smorch list` | Show all registry skills by category | Anyone |
| `smorch diff` | Show changes since last pull | Before pulling |

---

## Skill Lifecycle: 7 Steps

### Step 1: CREATE

**Location:** `~/Desktop/cowork-workspace/SKILLs/<skill-name>/`

1. Create directory: `mkdir -p ~/Desktop/cowork-workspace/SKILLs/<skill-name>`
2. Create `SKILL.md` with frontmatter:
```yaml
---
name: <skill-name>
description: "What it does + when it triggers"
---
```
3. Create `.smorch-category` file: `echo "smorch-gtm" > .smorch-category`
4. Create `.smorch-version` file: `echo "1.0.0" > .smorch-version`
5. Add reference files if SKILL.md exceeds 500 lines

**Naming rules:**
- SMOrch skills: `smorch-[category]-[specific]`
- EO skills: `eo-[step]-[component]`
- Lowercase, hyphens only, max 64 characters

**Categories:** `smorch-gtm`, `eo-training`, `eo-scoring`, `content`, `dev-meta`, `tools`, `personal`

### Step 2: TEST

Skill is immediately active via symlink (`~/.claude/skills/` -> workspace).

1. Open a new Claude Code session
2. Test contextually (say something that should trigger it)
3. Test with `/skill-name` if it has a command entrypoint
4. Verify output against CLAUDE.md quality standards
5. Test edge cases

### Step 3: PUSH TO REGISTRY

```bash
smorch push
```

This maps skills to categories via `.smorch-category` (or hardcoded fallback), copies to `smorch-brain/skills/<category>/<skill>/`, and commits to dev branch.

### Step 4: PROMOTE TO MAIN

```bash
gh pr create --base main --head dev --title "skills: weekly sync $(date +%Y-%m-%d)"
gh pr merge --squash
```

### Step 5: DEPLOY TO MACHINES

```bash
# On each target machine
smorch pull --profile <role>
```

### Step 6: VERSION

- Bump `.smorch-version` for significant changes
- Git tags for releases: `v2026.03.1`
- CHANGELOG.md tracks additions/changes

### Step 7: ARCHIVE

```bash
# Move to archive
mv smorch-brain/skills/<cat>/<skill> smorch-brain/skills/_archived/<cat>/<skill>
# Remove from all profiles, note in CHANGELOG
smorch push
```

---

## Best Practice Rules (12)

1. **Single Source of Truth**: `smorch-brain` GitHub repo is canonical
2. **Skills vs Commands**: Skill >50 lines. Command <20 lines. Never duplicate
3. **Categorize at creation**: `.smorch-category` file required
4. **Version at creation**: `.smorch-version` starting at `1.0.0`
5. **Profile-gated deployment**: Only mamoun profile gets `*`
6. **Plugin for distribution**: No repo access = plugin
7. **Never edit Layer 2 directly**: CLAUDE.md synced from repo
8. **SKILL.md under 500 lines**: Use progressive disclosure with reference files
9. **Description includes WHEN**: Third person, both what and when
10. **No duplicates across locations**: Plugin version takes precedence
11. **Test with multiple models**: Haiku, Sonnet, Opus
12. **No secrets in SKILL.md**: Use environment variables

---

## Profile Segmentation

| Profile | Who | Gets |
|---------|-----|------|
| `mamoun` | Mamoun's Mac | `*` (everything) |
| `smo-brain` | Brain server (Linux #1) | dev-meta, eo-training, eo-scoring, tools |
| `smo-dev` | Dev servers (#2, #3) | dev-meta, tools, operators |
| `gtm-team` | Agency team | smorch-gtm, content |
| `developer` | Tech team | dev-meta, tools |
| `eo-student` | EO community (plugin) | eo-training, eo-scoring |

---

## Decision Tree: What Goes Where

| Type | Storage |
|------|---------|
| Deep domain knowledge (>50 lines, needs refs) | **Skill** |
| User-triggered action (<50 lines) | **Command** |
| Behavioral rule (always apply) | **CLAUDE.md** |
| Bundle for distribution | **Plugin** |
| Automated/scheduled | **Scheduled Task** |

---

## EO Student Distribution

Students get skills via plugins (no repo access):

1. **Cowork Marketplace**: Publish plugin, students install via Customize > Plugins
2. **GitHub Release**: `smorch build-plugin eo-microsaas-os`, attach to release
3. **Direct share**: Share `.plugin` file via course materials

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `smorch push` silently skips a skill | Add `.smorch-category` file to the skill directory |
| Skill not triggering in Claude Code | Check description includes trigger words, restart session |
| Duplicate skill loading in Cowork | Remove standalone copy if plugin version exists |
| `smorch audit` shows orphan skills | Add skill to at least one profile in `profiles/*.txt` |
| Oversized SKILL.md warning | Split into SKILL.md (<500 lines) + reference files |
