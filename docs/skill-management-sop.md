# Skill Management SOP — SMOrchestra.ai

**Version 2.0 | March 2026**
**CLI Version: smorch v2.0.0**
**Platforms: macOS, Linux, Windows**

> **Repository Path Note:** The `smorch-brain` repo location varies by machine:
> - **Mac (Mamoun):** `~/Desktop/cowork-workspace/smorch-brain`
> - **Linux servers:** `~/smorch-brain`
> - **Windows:** `C:\Users\<you>\smorch-brain` or `C:\Users\<you>\Desktop\cowork-workspace\smorch-brain`
>
> The `smorch` CLI scripts auto-detect the correct location. When this document references `smorch-brain/` paths, use your machine's full path.

---

## Quick Reference — All Commands

### Mac / Linux (bash)

| Command | What | Who |
|---------|------|-----|
| `smorch push` | Export workspace skills to registry (dev branch) | Mamoun |
| `smorch pull --profile <name>` | Install profile-filtered skills from main | Any machine |
| `smorch audit` | Check for issues (unmapped, oversized, orphans) | Anyone |
| `smorch build-plugin <name>` | Build .plugin zip for distribution | Release |
| `smorch status` | Show profile, sync time, counts | Anyone |
| `smorch list` | Show all registry skills by category | Anyone |
| `smorch diff` | Show changes since last pull | Before pulling |
| `smorch-cleanup` | Remove duplicate skills + bloated commands | Run once per machine |
| `smorch-server-setup --profile <name>` | One-command machine setup | New machines |
| `smorch-sync-all` | Push + deploy to all servers via SSH | Mamoun only |
| `smorch-context --folder <name>` | Download business context files | Any team member |

### Windows (PowerShell)

| Command | What |
|---------|------|
| `.\smorch.ps1 push` | Export workspace skills to registry |
| `.\smorch.ps1 pull -Profile <name>` | Install profile-filtered skills |
| `.\smorch.ps1 audit` | Check for issues |
| `.\smorch.ps1 build-plugin -Name <name>` | Build .plugin zip |
| `.\smorch.ps1 status` | Show profile, sync time, counts |
| `.\smorch.ps1 list` | Show all registry skills |
| `.\smorch-cleanup.ps1` | Remove duplicates |
| `.\smorch-server-setup.ps1 -Profile <name>` | One-command setup |
| `.\smorch-context.ps1 -Folder <name>` | Download business context files |

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
# Mac/Linux
smorch push

# Windows
.\smorch.ps1 push
```

Maps skills to categories, copies to registry, commits to dev branch.

### Step 4: PROMOTE TO MAIN

```bash
gh pr create --base main --head dev --title "skills: weekly sync $(date +%Y-%m-%d)"
gh pr merge --squash
```

### Step 5: DEPLOY TO MACHINES

```bash
# Mac/Linux — single machine
smorch pull --profile <role>

# Mac/Linux — all servers at once
smorch-sync-all

# Windows
.\smorch.ps1 pull -Profile <role>
```

### Step 6: VERSION

- Bump `.smorch-version` for significant changes
- Git tags for releases: `v2026.03.1`
- CHANGELOG.md tracks additions/changes

### Step 7: ARCHIVE

```bash
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

| Profile | Who | Gets | Context Folders |
|---------|-----|------|----------------|
| `mamoun` | Mamoun's Mac | `*` (everything) | all |
| `smo-brain` | Brain server (Linux #1) | dev-meta, eo-training, eo-scoring, tools | — |
| `smo-dev` | Dev servers (#2, #3) | dev-meta, tools, operators | — |
| `gtm-team` (EO) | GTM - EO team | smorch-gtm, content | EntrepreneurOasis |
| `gtm-team` (SMO) | GTM - SMO team | smorch-gtm, content | SalesMfastGTM + CC_CX |
| `developer` | Tech team | dev-meta, tools | EntrepreneurOasis + SalesMfastGTM |
| `eo-student` | EO community (plugin) | eo-training, eo-scoring | — |

---

## Decision Tree: What Goes Where

| Type | Storage |
|------|---------|
| Deep domain knowledge (>50 lines, needs refs) | **Skill** |
| User-triggered action (<50 lines) | **Command** |
| Behavioral rule (always apply) | **CLAUDE.md** |
| Bundle for distribution | **Plugin** |
| Automated/scheduled | **Scheduled Task** |
| Business context (ICP, brand voice, team) | **smorch-context repo** |

---

## Two Repos

| Repo | What | Access |
|------|------|--------|
| `smorch-brain` | Skills, scripts, profiles, plugins, SOPs | All team (via profiles) |
| `smorch-context` | Business context files (ICP, positioning, team profiles) | Per business line |

### Context Access Per Role

```bash
# GTM - EO team:
smorch-context --folder EntrepreneurOasis

# GTM - SMO team:
smorch-context --folder SalesMfastGTM
smorch-context --folder CC_CX

# Dev team:
smorch-context --folder EntrepreneurOasis
smorch-context --folder SalesMfastGTM

# Windows: replace smorch-context with .\smorch-context.ps1 -Action download -Folder
```

---

## EO Student Distribution

Students get skills via plugins (no repo access):

1. **Cowork Marketplace**: Publish plugin, students install via Customize > Plugins
2. **GitHub Release**: `smorch build-plugin eo-microsaas-os`, attach to release
3. **Direct share**: Share `.plugin` file via course materials

---

## Automated Monitoring

Two scheduled tasks run daily in Claude Code:

| Task | Schedule | What |
|------|----------|------|
| `smorch-push` | 9:07 AM daily | Audit, push, rebuild stale plugins, check servers, track trends |
| `smorch-daily-audit` | 8:06 AM daily | GitHub org (14 dims) + skills health (10 checks) + server sync |

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `smorch push` skips a skill with UNMAPPED warning | Add `.smorch-category` file to the skill directory |
| Skill not triggering in Claude Code | Check description includes trigger words, restart session |
| Duplicate skill loading in Cowork | Remove standalone copy if plugin version exists |
| `smorch audit` shows orphan skills | Add skill to at least one profile in `profiles/*.txt` |
| Oversized SKILL.md warning | Split into SKILL.md (<500 lines) + reference files |
| Windows script won't run | Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` first |
| SSH timeout on `smorch-sync-all` | Check server is reachable, verify SSH key is configured |
