# Team Operations Guide — SMOrchestra.ai

**Version 2.0 | March 2026**
**Platforms: macOS, Linux, Windows**
**Audience:** Team members, server admins, EO students, anyone operating within the smorch-brain ecosystem

> **Cross-Platform Note:** All commands in this guide show Mac/Linux (bash) syntax. For Windows, replace `smorch <command>` with `.\smorch.ps1 <command>`, `smorch-cleanup` with `.\smorch-cleanup.ps1`, and `smorch-context --folder` with `.\smorch-context.ps1 -Folder`. Scripts are in `smorch-brain/scripts/`.

> **Repository Path Note:** The `smorch-brain` repo location varies by machine:
> - **Mac (Mamoun):** `~/Desktop/cowork-workspace/smorch-brain`
> - **Linux servers:** `~/smorch-brain`
> - **Windows:** `C:\Users\<you>\smorch-brain` or `C:\Users\<you>\Desktop\cowork-workspace\smorch-brain`
>
> The `smorch` CLI scripts auto-detect the correct location. When this document shows `~/smorch-brain`, substitute your machine's actual path. The first-time setup commands clone to `~/smorch-brain` by default; on Mac you may need to adjust the clone target.
>
> **Windows Setup (first time):**
> ```powershell
> # Windows: Run in PowerShell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  # One-time only
> git clone https://github.com/SMOrchestra-ai/smorch-brain.git $env:USERPROFILE\smorch-brain
> cd $env:USERPROFILE\smorch-brain\scripts
> .\smorch.ps1 pull -Profile <your-profile>
> ```

---

## Table of Contents

1. [Per-Persona Sync Guide](#1-per-persona-sync-guide)
2. [Profile Management Guide](#2-profile-management-guide)
3. [Skill Creation SOP (No Duplication)](#3-skill-creation-sop-no-duplication)
4. [Plugin Management](#4-plugin-management)
5. [Multi-Server Sync](#5-multi-server-sync)
6. [Moving Session Skills to Plugins](#6-moving-session-skills-to-plugins)

---

## 1. Per-Persona Sync Guide

### GTM Team — EO Focus

**Cowork plugins (6):** smorch-context-brain, smorch-gtm-tools, smorch-gtm-engine, smorch-design, mamoun-personal-branding, eo-microsaas-os
**Claude Code plugins:** None
**Context:** EntrepreneurOasis

**First-time setup:**

```bash
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain && \
  chmod +x ~/smorch-brain/scripts/*
~/smorch-brain/scripts/smorch-install-plugins --role gtm-eo
~/smorch-brain/scripts/smorch-context --folder EntrepreneurOasis
~/smorch-brain/scripts/smorch init --profile gtm-eo-team
```

Load plugins into Cowork Desktop:
1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory
4. Cowork scans and discovers all plugins automatically
5. Click Save -- plugins are now active

Your role gets these plugins:
- smorch-context-brain
- smorch-gtm-tools
- smorch-gtm-engine
- smorch-design
- mamoun-personal-branding
- eo-microsaas-os

> **Windows:** `.\smorch-install-plugins.ps1 -Role gtm-eo`

### GTM Team — SMO Focus

**Cowork plugins (5):** smorch-context-brain, smorch-gtm-tools, smorch-gtm-engine, smorch-design, mamoun-personal-branding
**Claude Code plugins:** None
**Context:** SalesMfastGTM + CC_CX

**First-time setup:**

```bash
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain && \
  chmod +x ~/smorch-brain/scripts/*
~/smorch-brain/scripts/smorch-install-plugins --role gtm-smo
~/smorch-brain/scripts/smorch-context --folder SalesMfastGTM
~/smorch-brain/scripts/smorch-context --folder CC_CX
~/smorch-brain/scripts/smorch init --profile gtm-smo-team
```

Load plugins into Cowork Desktop:
1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory
4. Cowork scans and discovers all plugins automatically
5. Click Save -- plugins are now active

Your role gets these plugins:
- smorch-context-brain
- smorch-gtm-tools
- smorch-gtm-engine
- smorch-design
- mamoun-personal-branding

> **Windows:** `.\smorch-install-plugins.ps1 -Role gtm-smo`

### GTM Daily & Weekly (Both EO and SMO)

**Daily routine:**

```bash
smorch pull
smorch-context --update
```

**Weekly routine:**

```bash
smorch diff          # See what changed since last pull
smorch pull          # Pull changes
smorch audit         # Check for issues on your machine
```

**What you should NOT do:**
- Do not edit skills directly in `~/.claude/skills/`. Your changes will be overwritten on next `smorch pull`.
- Do not run `smorch push`. Only Mamoun pushes to the registry.
- Do not add skills from other profiles manually. Request a profile change instead.
- Do not modify `.smorch-category` or `.smorch-version` files.

---

### Dev Team

**Cowork plugins (1):** smorch-dev
**Claude Code plugins (7):** typescript-lsp, pyright-lsp, rust-analyzer-lsp, gopls-lsp, code-review, frontend-design, github
**Context:** EntrepreneurOasis + SalesMfastGTM

**First-time setup:**

```bash
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain && \
  chmod +x ~/smorch-brain/scripts/*
~/smorch-brain/scripts/smorch-install-plugins --role dev
~/smorch-brain/scripts/smorch-context --folder EntrepreneurOasis
~/smorch-brain/scripts/smorch-context --folder SalesMfastGTM
~/smorch-brain/scripts/smorch init --profile developer
```

The script installs 7 Code dev tools. Then load plugins into Cowork Desktop:
1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory
4. Cowork scans and discovers all plugins automatically
5. Click Save -- plugins are now active

Your role gets this plugin:
- smorch-dev

> **Windows:** `.\smorch-install-plugins.ps1 -Role dev`

**Daily routine:**

```bash
smorch pull
smorch-context --update
```

**Weekly routine:**

```bash
smorch diff
smorch pull
smorch audit
```

**What you should NOT do:**
- Do not push skills. Only Mamoun's machine runs `smorch push`.
- Do not install GTM or content skills outside your profile. If you need temporary access, use `smorch install smorch-gtm/ghl-operator` (it will be removed on next `smorch pull`).
- Do not delete or rename skill directories manually.

---

### EO Student

**Cowork plugins (2):** eo-microsaas-os, smorch-dev
**Claude Code plugins (7):** typescript-lsp, pyright-lsp, rust-analyzer-lsp, gopls-lsp, code-review, frontend-design, github
**Context:** None

**Setup (with repo access):**

```bash
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain && \
  chmod +x ~/smorch-brain/scripts/*
~/smorch-brain/scripts/smorch-install-plugins --role eo-student
~/smorch-brain/scripts/smorch init --profile eo-student
```

The script installs 7 Code dev tools. Then load plugins into Cowork Desktop:
1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory
4. Cowork scans and discovers all plugins automatically
5. Click Save -- plugins are now active

Your role gets these plugins:
- eo-microsaas-os
- smorch-dev

> **Windows:** `.\smorch-install-plugins.ps1 -Role eo-student`

**Without repo access (plugin only):**
1. Download `.plugin` file from course materials
2. Open Claude Desktop (Cowork) > Customize > Workspace
3. Point workspace to the directory containing the downloaded plugin
4. Cowork scans and discovers the plugin automatically
5. Click Save -- skills are immediately available

**Sync routine:**
- Plugin users: Re-download and re-upload when a new version is announced in the course channel
- Registry users: `smorch pull` weekly

**What you should NOT do:**
- Do not modify plugin skills. If something is broken, report it in the course channel.
- Do not attempt to access GTM or internal skills. They are not in your profile.
- Do not share `.plugin` files outside the EO community.
- Do not run `smorch push` even if you have repo access.

---

### Server Admin

**What you get depends on which server:**

| Server | Profile | Skills |
|--------|---------|--------|
| smo-brain (Linux #1) | `smo-brain` | dev-meta (select), eo-training/*, eo-scoring/*, n8n-architect, webapp-testing, get-api-docs |
| smo-dev (Linux #2, #3) | `smo-dev` | dev-meta (select), smorch-gtm operators, tools (select) |

**First-time server setup (one command):**

```bash
# Bootstrap: clones repo, cleans duplicates, installs profile, adds to PATH
# On Mac, replace ~/smorch-brain with ~/Desktop/cowork-workspace/smorch-brain
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain && \
  chmod +x ~/smorch-brain/scripts/* && \
  ~/smorch-brain/scripts/smorch-server-setup --profile smo-brain
# Change profile to smo-dev for dev servers (#2, #3)
```

> **Optional:** Install jq for MCP config merging: `sudo apt install jq`

**Daily routine:**

```bash
smorch pull
```

Automate with cron for unattended servers:

```bash
# Add to crontab: crontab -e
0 6 * * * cd ~/smorch-brain && /usr/local/bin/smorch pull >> /var/log/smorch-sync.log 2>&1
```

**Weekly routine:**

```bash
smorch status         # Check profile and sync status
smorch audit          # Check for issues
smorch diff           # See pending changes before pulling
```

**What you should NOT do:**
- Do not run `smorch push` from servers. Push only happens from Mamoun's Mac.
- Do not edit `~/.claude/settings.json` directly. Use the alignment instructions to merge from the reference file.
- Do not grant additional profiles to servers without Mamoun's approval.
- Do not store secrets in skill files. Use environment variables.
- Do not manually `git checkout` branches on the server. `smorch pull` always pulls from main.

---

## 2. Profile Management Guide

### Viewing Available Profiles

```bash
smorch list --profiles
```

Output shows each profile name and how many skills it resolves to:

```
Available Profiles
  mamoun (55 skills)
  smo-brain (11 skills)
  smo-dev (14 skills)
  gtm-eo-team (26 skills)
  gtm-smo-team (20 skills)
  developer (17 skills)
  eo-student (20 skills)
```

### Creating a New Profile

Profiles are `.txt` files in `smorch-brain/profiles/`. Each line specifies which skills to include.

**Step 1:** Create the file.

```bash
# Use your machine's smorch-brain path (see Path Note at top)
touch ~/smorch-brain/profiles/agency-junior.txt
```

**Step 2:** Edit the file with skill specifications.

### Profile File Syntax

Each line is one of four types:

| Syntax | Meaning | Example |
|--------|---------|---------|
| `*` | All skills in all categories | `*` |
| `category/*` | All skills in a category | `smorch-gtm/*` |
| `category/specific-skill` | One specific skill | `content/arabic-localizer` |
| `# comment` | Ignored line | `# Added 2026-03-24` |

Empty lines are ignored. Whitespace is trimmed.

### Example: Creating an "agency-junior" Profile

This profile gives a junior agency team member content skills plus select GTM skills, without access to operator-level tools or EO content.

Create `~/smorch-brain/profiles/agency-junior.txt` (adjust path for your machine):

```
# Agency Junior Profile
# Content creation skills (full access)
content/*

# Core GTM strategy (read-only understanding)
smorch-gtm/signal-to-trust-gtm
smorch-gtm/positioning-engine
smorch-gtm/wedge-generator
smorch-gtm/asset-factory
smorch-gtm/campaign-strategist

# Basic dev tooling
dev-meta/smorch-github-ops
dev-meta/changelog-generator
```

This gives the junior 15 skills: all 8 content skills, 5 GTM strategy skills, and 2 dev-meta skills. They do NOT get operator skills (ghl-operator, instantly-operator, etc.) or any EO/scoring skills.

### Customizing Which Skills Go to a Profile

Edit the `.txt` file directly. Add or remove lines.

To add a skill:
```
smorch-gtm/outbound-orchestrator
```

To remove a skill: delete the line or comment it out:
```
# smorch-gtm/outbound-orchestrator
```

To switch from specific skills to full category access:
```
# Replace individual lines with:
smorch-gtm/*
```

### Testing a Profile Before Deploying

Test in a temporary directory to see what would be installed without affecting any machine:

```bash
# 1. See what the profile resolves to (dry run)
smorch list --profiles

# 2. Pull into a test environment
mkdir -p /tmp/smorch-test
cd /tmp/smorch-test
smorch pull --profile agency-junior

# 3. Check what was installed
smorch list --installed

# 4. Clean up
rm -rf /tmp/smorch-test
```

Note: `smorch pull --profile <name>` saves that profile as the default for the machine. If testing on your actual machine, remember to switch back:

```bash
smorch pull --profile <your-actual-profile>
```

### Committing a New Profile

After creating and testing:

```bash
# Use your machine's smorch-brain path (see Path Note at top)
cd ~/smorch-brain
git add profiles/agency-junior.txt
git commit -m "profiles: add agency-junior profile"
git push origin dev
```

Then promote via PR: dev -> main.

---

## 3. Skill Creation SOP (No Duplication)

### Step-by-Step Process

**Step 1: Check if the skill already exists.**

```bash
smorch list | grep -i <keyword>
```

Example: Before creating a "linkedin-operator" skill:

```bash
smorch list | grep -i linkedin
# Output:
#   smorch-linkedin-intel
#   heyreach-operator        (heyreach IS LinkedIn automation)
```

If a match exists, enhance the existing skill instead of creating a new one.

**Step 2: Check if a similar skill exists in plugins.**

```bash
# Use your machine's smorch-brain path (see Path Note at top)
ls ~/smorch-brain/plugins/*/skills/ | grep -i <keyword>
```

Plugin skills take precedence over standalone skills (Best Practice Rule #10). If the skill exists in a plugin, either enhance the plugin version or confirm the standalone version serves a different purpose.

**Step 3: Create the skill in your workspace.**

```bash
mkdir -p ~/Desktop/cowork-workspace/SKILLs/<skill-name>
```

Required files:

```
<skill-name>/
  SKILL.md              # Main skill file (under 500 lines)
  .smorch-category      # Category: smorch-gtm, eo-training, eo-scoring, content, dev-meta, tools, personal
  .smorch-version       # Semver: 1.0.0
  references/           # Optional: detailed docs split from SKILL.md
  scripts/              # Optional: helper scripts
  assets/               # Optional: templates, schemas, JSON configs
```

Create the metadata files:

```bash
echo "smorch-gtm" > ~/Desktop/cowork-workspace/SKILLs/<skill-name>/.smorch-category
echo "1.0.0" > ~/Desktop/cowork-workspace/SKILLs/<skill-name>/.smorch-version
```

**Step 4: Test in a Claude Code session.**

1. Open a new Claude Code session (skill loads via symlink from `~/.claude/skills/`)
2. Test contextually: say something that should trigger the skill
3. Test with `/skill-name` if it has a command entrypoint
4. Test with multiple models if possible (Haiku, Sonnet, Opus)
5. Verify SKILL.md is under 500 lines

**Step 5: Push to registry.**

```bash
smorch push
```

This copies the skill to `smorch-brain/skills/<category>/<skill-name>/` and commits to the dev branch.

**Step 6: Run audit.**

```bash
smorch audit
```

Fix any reported issues:
- `UNMAPPED`: Missing `.smorch-category` file
- `NO VERSION`: Missing `.smorch-version` file
- `OVERSIZED`: SKILL.md over 500 lines, split into reference files
- `ORPHAN`: Skill not included in any profile (add to at least one profile)

**Step 7: Promote dev to main.**

```bash
gh pr create --base main --head dev --title "skills: add <skill-name>"
gh pr merge --squash
```

After merge, all machines pulling from main will get the new skill on their next `smorch pull`.

### Decision Flowchart: Where Does This Skill Belong?

```
START: You have a new skill to create
  |
  v
Is it related to 3+ existing skills that share a distribution target?
  |
  +-- YES --> Does a plugin already exist for that group?
  |             |
  |             +-- YES --> Add to the existing plugin (Section 4)
  |             |
  |             +-- NO  --> Create a new plugin (Section 4)
  |
  +-- NO  --> Is it something only Mamoun uses?
                |
                +-- YES --> Keep as standalone skill, category: personal
                |
                +-- NO  --> Is it for EO students who have no repo access?
                              |
                              +-- YES --> Must go in eo-microsaas-os plugin
                              |
                              +-- NO  --> Is it for the whole team or just one role?
                                            |
                                            +-- WHOLE TEAM --> Standalone skill,
                                            |                   add to all relevant profiles
                                            |
                                            +-- ONE ROLE --> Standalone skill,
                                                             add only to that role's profile
```

### When to Use Cowork Customize vs Plugin vs Standalone

```
Cowork Customize (session skills):
  - Prototyping a new skill
  - Personal experimental skills
  - Skills that change frequently during development
  --> Move to standalone or plugin once stable

Plugin:
  - Distributing to users WITHOUT repo access (EO students)
  - Bundling 3+ related skills as a coherent package
  - Skills that need commands, hooks, or MCP configs bundled together
  --> Use when the audience is external or the bundle is self-contained

Standalone (smorch-brain/skills/):
  - Internal team skills
  - Skills that are profile-gated (different teams get different skills)
  - Skills that update frequently and need instant sync via git pull
  --> Default choice for anything internal
```

---

## 4. Plugin Management

### When to Create a New Plugin

Create a new plugin when:
- You have 3 or more related skills intended for the same audience
- The audience does not have (or should not have) access to the smorch-brain repo
- The skills benefit from being bundled with commands, hooks, or MCP configs

Current plugins:
- `smorch-gtm-engine` — GTM operators, commands, MCP configs for the full GTM workflow
- `eo-microsaas-os` — EO training, scoring, commands, hooks for students

### How to Add a Skill to an Existing Plugin

```bash
# All ~/smorch-brain paths below: use your machine's actual path (see Path Note at top)
# 1. Copy the skill directory to the plugin
cp -r ~/smorch-brain/skills/<category>/<skill-name> \
      ~/smorch-brain/plugins/<plugin-name>/skills/<skill-name>

# 2. Update the plugin's README.md to document the new skill

# 3. Update plugin.json if the skill adds new commands
#    Located at: plugins/<plugin-name>/.claude-plugin/plugin.json

# 4. Rebuild the plugin
smorch build-plugin <plugin-name>

# 5. Test: Load the plugin in a test Cowork session
#    Cowork > Customize > Workspace > point to smorch-brain directory > Save
#    Cowork will discover all plugins in plugins/ automatically

# 6. If the standalone version should be removed (plugin takes precedence):
#    Remove from smorch-brain/skills/<category>/<skill-name>
#    Update all profiles that referenced it
```

### How to Build a Plugin

```bash
smorch build-plugin <plugin-name>
```

This creates a `.plugin` zip file at `~/smorch-brain/dist/<plugin-name>.plugin`.

What it does:
- Zips the entire `plugins/<plugin-name>/` directory
- Excludes `.DS_Store`, `node_modules`, `__pycache__`, `.git`
- Reports the output file path and size

### How to Load Plugins into Cowork

1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory (e.g., `~/Desktop/cowork-workspace/smorch-brain`)
4. Cowork scans the directory and discovers all plugins in `plugins/` automatically
5. Click Save -- plugins are now active in all Cowork sessions

### How to Publish to Marketplace

If the plugin is ready for public distribution:

1. Ensure the plugin has a complete `README.md` and `.claude-plugin/plugin.json`
2. Test thoroughly with multiple models
3. Submit via the Cowork marketplace submission process (when available)
4. For now, distribute via GitHub Releases:

```bash
# Build the plugin
smorch build-plugin eo-microsaas-os

# Create a GitHub release
cd ~/smorch-brain
gh release create v2026.03.1 \
  dist/eo-microsaas-os.plugin \
  --title "EO MicroSaaS OS v2026.03.1" \
  --notes "Updated EO training skills and scoring engines"
```

### How to Move Cowork Session Skills into Plugins

When skills were created in Cowork Desktop sessions and need to be moved into a plugin:

**Step 1:** Identify session skills. They live in:
```
~/Library/Application Support/Claude/local-agent-mode-sessions/<session-id>/.claude/skills/
```

`smorch push` already pulls these into your workspace automatically (Phase 0 of the push command).

**Step 2:** After `smorch push`, the skills are in `~/smorch-brain/skills/<category>/`. Copy them to the target plugin:

```bash
cp -r ~/smorch-brain/skills/<category>/<skill-name> \
      ~/smorch-brain/plugins/<plugin-name>/skills/<skill-name>
```

**Step 3:** If the skill should ONLY exist in the plugin (not standalone), remove the standalone copy:

```bash
rm -rf ~/smorch-brain/skills/<category>/<skill-name>
```

Update profiles that referenced it directly (e.g., remove `category/skill-name` lines).

**Step 4:** Rebuild and upload:

```bash
smorch build-plugin <plugin-name>
# Load in Cowork: Customize > Workspace > point to smorch-brain > Save
```

### Plugin Directory Structure Reference

```
plugins/<plugin-name>/
  .claude-plugin/
    plugin.json           # Plugin metadata: name, version, description
  README.md               # What the plugin does, installation instructions
  skills/
    <skill-name>/
      SKILL.md            # Skill content
      references/         # Optional reference files
      scripts/            # Optional scripts
      assets/             # Optional assets
  commands/
    <command-name>.md     # Slash commands (e.g., /weekly-review)
  hooks/
    hooks.json            # Plugin-level hooks (optional)
  CONNECTORS.md           # External service connections (optional)
  .mcp.json               # MCP server configuration (optional)
```

---

## 5. Multi-Server Sync

### Architecture Overview

```
Mamoun's Mac (source of truth)
  |
  |-- smorch push --> GitHub (dev branch)
  |-- gh pr merge --> GitHub (main branch)
  |
  +-- smo-brain pulls from main
  +-- smo-dev pulls from main
  +-- Team machines pull from main
```

All changes flow one direction: Mamoun's Mac -> GitHub -> all other machines.

### Server Setup

**New server first-time setup:**

```bash
# 1. Ensure SSH key is configured for GitHub
ssh -T git@github.com

# 2. Clone the registry
# On Mac, replace ~/smorch-brain with ~/Desktop/cowork-workspace/smorch-brain
git clone git@github.com:SMOrchestra-ai/smorch-brain.git ~/smorch-brain

# 3. Install CLI
chmod +x ~/smorch-brain/scripts/smorch
sudo ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch

# 4. Install jq (required for MCP config merging)
sudo apt install -y jq    # Debian/Ubuntu
# or
brew install jq            # macOS

# 5. Initialize with the correct profile
smorch init --profile <profile-name>

# 6. Run the full alignment (hooks, agents, rules)
# Follow ~/smorch-brain/docs/server-alignment-instructions.md
```

### Daily Sync

**Manual:**

```bash
smorch pull
```

**Automated via cron:**

```bash
crontab -e
# Add this line (runs at 6:00 AM server time daily):
0 6 * * * cd ~/smorch-brain && /usr/local/bin/smorch pull >> /var/log/smorch-sync.log 2>&1
```

**Verify cron is working:**

```bash
tail -20 /var/log/smorch-sync.log
```

### Push from Mamoun's Mac

After making changes (new skills, updated skills, profile changes):

```bash
# 1. Push to dev
smorch push

# 2. Verify on dev
smorch audit

# 3. Promote to main
gh pr create --base main --head dev --title "skills: weekly sync $(date +%Y-%m-%d)"
gh pr merge --squash

# 4. All servers will pick up changes on their next smorch pull
```

**To trigger immediate sync on all servers:**

```bash
# SSH into each server and pull
ssh smo-brain "cd ~/smorch-brain && smorch pull"
ssh smo-dev "cd ~/smorch-brain && smorch pull"
```

Or create a convenience script at `~/bin/smorch-sync-all`:

```bash
#!/usr/bin/env bash
set -euo pipefail
echo "Syncing smo-brain..."
ssh smo-brain "cd ~/smorch-brain && /usr/local/bin/smorch pull" 2>&1
echo "Syncing smo-dev..."
ssh smo-dev "cd ~/smorch-brain && /usr/local/bin/smorch pull" 2>&1
echo "All servers synced."
```

Make it executable: `chmod +x ~/bin/smorch-sync-all`

### Troubleshooting

**SSH issues:**

| Problem | Fix |
|---------|-----|
| `Permission denied (publickey)` | SSH key not added to GitHub or server. Run `ssh-add ~/.ssh/id_ed25519` or check `~/.ssh/config` |
| `Connection timed out` | Server is down or firewall blocking port 22. Check with `ping <server-ip>` |
| `Host key verification failed` | Server was rebuilt. Remove old key: `ssh-keygen -R <server-ip>` |

**Merge conflicts:**

Merge conflicts should not happen because only Mamoun's Mac pushes changes. If they do:

```bash
cd ~/smorch-brain

# Option A: Accept remote version (recommended for servers)
git fetch origin main
git reset --hard origin/main

# Option B: Inspect and resolve manually
git status
git diff
# Fix conflicts, then:
git add .
git commit -m "fix: resolve merge conflict on $(hostname)"
```

**Stale locks:**

If `smorch pull` hangs or reports a lock:

```bash
# Remove git lock
rm -f ~/smorch-brain/.git/index.lock

# Remove smorch state lock (if exists)
rm -f ~/smorch-brain/.smorch-state.lock

# Retry
smorch pull
```

**Skill not appearing after pull:**

1. Check profile includes the skill: `cat ~/smorch-brain/profiles/<profile>.txt`
2. Check the skill exists in the registry: `ls ~/smorch-brain/skills/<category>/<skill-name>`
3. Check skill was properly mapped: `smorch audit`
4. Restart the Claude Code session (skills load at session start)

---

## 6. Moving Session Skills to Plugins

### Context

Cowork Desktop session skills are created interactively during Cowork sessions (Customize > Skills > Add). They live in:

```
~/Library/Application Support/Claude/local-agent-mode-sessions/<session-id>/.claude/skills/
```

These are ephemeral — tied to a specific session. To make them permanent and distributable, they need to be moved into either standalone skills (in smorch-brain/skills/) or plugins (in smorch-brain/plugins/).

### Step 1: Identify Session Skills

Run `smorch push`. Phase 0 of the push command automatically scans all Cowork sessions and copies new custom skills (not Anthropic built-ins, not plugin skills) into your workspace at `~/.claude/skills/`.

After push, check what was pulled:

```bash
smorch push 2>&1 | grep "Pulled from Cowork"
```

### Step 2: Decide Which Plugin Each Belongs To

For each session skill, answer these questions:

```
1. Is this a GTM/outbound/operator skill?
   --> smorch-gtm-engine plugin

2. Is this an EO training or scoring skill?
   --> eo-microsaas-os plugin

3. Is this a content creation skill?
   --> Consider: new content plugin, or keep standalone

4. Is this a dev/tooling skill?
   --> Keep standalone in smorch-brain/skills/dev-meta/ or tools/

5. Is this personal to Mamoun only?
   --> Keep standalone in smorch-brain/skills/personal/
```

Decision matrix for the most common cases:

| Skill type | Destination | Reason |
|------------|-------------|--------|
| GHL, Instantly, HeyReach, Clay, n8n operator | `smorch-gtm-engine` plugin | Operators bundle together |
| Signal detection, scoring, wedge generation | `smorch-gtm-engine` plugin | Core GTM workflow |
| EO student-facing (brain, scoring, training) | `eo-microsaas-os` plugin | Students use plugin, no repo access |
| Content (YouTube, LinkedIn, webinar) | Standalone `content/*` | Internal team, repo-synced |
| Dev tooling (debugging, testing, CI) | Standalone `dev-meta/*` or `tools/*` | Internal, profile-gated |

### Step 3: Move Skill to Plugin

```bash
# A. Copy skill directory to the target plugin
cp -r ~/smorch-brain/skills/<category>/<skill-name> \
      ~/smorch-brain/plugins/<plugin-name>/skills/<skill-name>

# B. If the skill has a slash command, create it in the plugin
# Example: if the skill responds to /detect-signals
cat > ~/smorch-brain/plugins/<plugin-name>/commands/<command-name>.md << 'EOF'
---
name: <command-name>
description: "What this command does"
---

<Command instructions here>
EOF

# C. Remove the standalone version (plugin takes precedence)
rm -rf ~/smorch-brain/skills/<category>/<skill-name>

# D. Update any profiles that referenced the skill directly
# Edit profiles/*.txt to remove lines like: <category>/<skill-name>
# Skills in plugins are loaded by the plugin, not by smorch pull
```

### Step 4: Rebuild the Plugin

```bash
smorch build-plugin <plugin-name>
```

### Step 5: Load into Cowork and Test

1. Open Claude Desktop (Cowork) > Customize > Workspace
2. Point workspace to your smorch-brain directory > Click Save
3. Cowork discovers updated plugins automatically
4. Open a new session
5. Test that the migrated skill works:
   - Test contextual triggers (say something that should activate it)
   - Test slash commands if applicable
   - Verify output quality matches the standalone version

### Step 6: Clean Up

```bash
# Run audit to catch orphans or issues
smorch audit

# Commit the changes
cd ~/smorch-brain
git add plugins/ skills/ profiles/
git commit -m "skills: migrate <skill-name> to <plugin-name> plugin"
git push origin dev
```

### Batch Migration Checklist

When migrating multiple skills at once, track progress:

```
For each skill:
[ ] Identified target plugin
[ ] Copied to plugins/<plugin>/skills/
[ ] Created command file (if applicable)
[ ] Removed standalone copy
[ ] Updated profiles
[ ] Rebuilt plugin: smorch build-plugin <name>
[ ] Tested in Cowork session
[ ] Committed to dev branch
```

After all migrations:

```bash
smorch audit          # Verify no orphans or issues
smorch build-plugin smorch-gtm-engine
smorch build-plugin eo-microsaas-os
# Load plugins in Cowork: Customize > Workspace > point to smorch-brain > Save
# Create PR: dev -> main
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| See all skills in registry | `smorch list` |
| See what is installed on this machine | `smorch list --installed` |
| See what you could install but have not | `smorch list --available` |
| See all profiles | `smorch list --profiles` |
| Pull latest skills for your profile | `smorch pull` |
| Switch to a different profile | `smorch pull --profile <name>` |
| Check sync status | `smorch status` |
| See pending changes | `smorch diff` |
| Health check | `smorch audit` |
| Build a plugin for distribution | `smorch build-plugin <name>` |
| Install one skill outside your profile | `smorch install <category/skill>` |
| Remove a skill | `smorch remove <category/skill>` |
| Push skills to registry (Mamoun only) | `smorch push` |

---

## Key Rules (Do Not Violate)

1. **smorch-brain is the single source of truth.** Never edit skills directly on target machines.
2. **Only Mamoun runs `smorch push`.** Everyone else only runs `smorch pull`.
3. **Plugin version takes precedence** over standalone version. Do not have both.
4. **Every skill must have `.smorch-category` and `.smorch-version` files.**
5. **SKILL.md must be under 500 lines.** Use reference files for overflow.
6. **Run `smorch audit` before every `smorch push`** to catch issues early.
7. **No secrets in skill files.** Use environment variables.
8. **Profile `*` (all skills) is reserved for Mamoun's profile only.**
