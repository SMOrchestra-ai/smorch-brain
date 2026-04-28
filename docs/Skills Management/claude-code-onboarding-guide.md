# Claude Code Onboarding Guide — SMOrchestra.ai
## How to Set Up Any New Machine to Match Our Architecture

**Version:** 1.0
**Date:** 2026-03-22
**For:** Any Claude Code instance running on any machine (server, desktop, laptop, team member's device)
**Time to complete:** 15 minutes

---

## What This Guide Does

This guide takes a fresh Claude Code installation and configures it to match SMOrchestra's AI-Native GitHub Architecture exactly. After running these steps, your Claude Code will:

- Have the correct skills for your role (from 48 available)
- Enforce conventional commits on every commit
- Follow the correct branch model (main/dev/human/agent)
- Know when to create releases, changelogs, and documentation
- Understand what it can do automatically vs what requires Mamoun's approval
- Match every other Claude Code instance in the organization

---

## What We've Built (Context for New Sessions)

SMOrchestra runs an **AI-Native GitHub Architecture** — a system where AI agents and humans work in the same repos with strict coordination rules. Here's what exists:

### The Organization
- **GitHub Org:** [SMOrchestra-ai](https://github.com/SMOrchestra-ai)
- **Admin Account:** smorchestraai-code
- **Active Repos:** 7 (SaaSFast, eo-assessment-system, smorch-brain, EO-Build, ScrapMfast, ship-fast, eo-mena)
- **Archived:** 1 (SaaSFast-v1-archived)
- **Teams:** engineering, agents, reviewers

### The Skills Registry
- **Repo:** [smorch-brain](https://github.com/SMOrchestra-ai/smorch-brain)
- **51 skills** organized in 6 categories
- **Profiles** control which skills each machine gets
- **smorch CLI** handles push/pull/install operations

### The Enforcement Stack
1. **smorch-github-ops skill** — loaded by Claude Code, enforces branch naming, commits, releases, documentation
2. **commit-msg git hook** — rejects non-conventional commits at git level
3. **Global CLAUDE.md SOPs** — rules Claude Code follows every session
4. **Per-project CLAUDE.md** — project-specific skill requirements

---

## Prerequisites

Before starting, ensure:
- [ ] Claude Code is installed (`claude --version` returns a version)
- [ ] Git is installed (`git --version`)
- [ ] SSH key added to the smorchestraai-code GitHub account OR HTTPS access configured
- [ ] `jq` is installed (`jq --version`) — needed for MCP config merging
- [ ] You know which **profile** this machine should use (see Profiles section below)

---

## Step 1: Clone the Skills Registry

```bash
git clone git@github.com:SMOrchestra-ai/smorch-brain.git ~/smorch-brain
```

If SSH fails, use HTTPS:
```bash
git clone https://github.com/SMOrchestra-ai/smorch-brain.git ~/smorch-brain
```

**Verify:**
```bash
ls ~/smorch-brain/skills/
# Should show: content  dev-meta  eo-scoring  eo-training  smorch-gtm  tools
```

---

## Step 2: Install the smorch CLI

```bash
chmod +x ~/smorch-brain/scripts/smorch

# Linux servers:
sudo ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch

# macOS (if /usr/local/bin needs sudo and terminal can't prompt):
mkdir -p ~/bin
ln -sf ~/smorch-brain/scripts/smorch ~/bin/smorch
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc on macOS
source ~/.bashrc  # or source ~/.zshrc
```

**Verify:**
```bash
smorch --help
# Should show: smorch — SMOrchestra Skills Manager
```

---

## Step 3: Choose and Apply Your Profile

### Available Profiles

| Profile | Skills | Use For |
|---------|--------|---------|
| `mamoun` | ALL 51 skills | Mamoun's desktop — full access |
| `smo-brain` | 24 skills | Gateway server — EO + scoring + dev-meta + github-ops |
| `smo-dev` | 13 skills | Dev server — GTM + dev-meta + github-ops + tools |

### Custom Profiles

If none of the above fit, create a new one:
```bash
nano ~/smorch-brain/profiles/YOUR-PROFILE.txt
```

Profile syntax (one entry per line):
```
*                                    # ALL skills
eo-training/*                        # All skills in a category
dev-meta/smorch-github-ops           # Specific skill
dev-meta/changelog-generator         # Specific skill
tools/webapp-testing                 # Specific skill
```

**IMPORTANT:** Every profile MUST include these two skills at minimum:
```
dev-meta/smorch-github-ops
dev-meta/changelog-generator
```
These enforce the GitHub architecture. Without them, this machine won't follow the org's standards.

### Apply the Profile

```bash
smorch pull --profile YOUR-PROFILE
```

Example:
```bash
smorch pull --profile smo-brain
```

**Verify:**
```bash
smorch status
# Should show:
#   Profile: smo-brain
#   Installed: 24 skills
#   Registry: 51 skills
#   Git branch: dev (0 commits behind)
```

---

## Step 4: Install Git Hooks

The commit-msg hook rejects non-conventional commits. Install it in every repo you work on:

```bash
# Install into a specific repo:
~/smorch-brain/hooks/install-hooks.sh
# (Run this from inside the repo directory)

# Or manually:
cp ~/smorch-brain/hooks/commit-msg /path/to/repo/.git/hooks/commit-msg
chmod +x /path/to/repo/.git/hooks/commit-msg
```

**Test it:**
```bash
cd /path/to/any/repo
echo "bad message" | git commit --allow-empty -F -
# Should output: ❌ COMMIT REJECTED — Invalid commit message format

echo "feat: test hook" | git commit --allow-empty -F -
# Should succeed
git reset HEAD~1  # Clean up test commit
```

---

## Step 5: Set Up Global CLAUDE.md

The global CLAUDE.md tells Claude Code how to behave across all projects. Copy it from smorch-brain:

```bash
mkdir -p ~/.claude
cp ~/smorch-brain/docs/claude-md-template.md ~/.claude/CLAUDE.md
```

**If the template doesn't exist yet**, create `~/.claude/CLAUDE.md` with this minimum content:

```markdown
GITHUB & VERSION CONTROL SOPs (ENFORCE EVERY SESSION)

These rules apply whenever working in or with any GitHub repository.

OWNERSHIP LEGEND:
- CLAUDE-AUTO = Claude does this automatically, no human needed
- MAMOUN-REQUIRED = Claude MUST stop and ask Mamoun before proceeding
- CLAUDE-PREPARES = Claude prepares it, Mamoun approves

Branch discipline:
- CLAUDE-AUTO: Pull latest dev before creating any new branch
- CLAUDE-AUTO: Create branches with correct naming (human/mamoun/TASK-XXX-slug, feature/name, agent/TASK-XXX-slug)
- CLAUDE-AUTO: NEVER push directly to main or dev. Always use PRs.
- MAMOUN-REQUIRED: Merging PRs to main — Claude creates the PR, Mamoun reviews and approves
- CLAUDE-AUTO: Merging PRs to dev — Claude can merge after CI passes

Commit discipline:
- CLAUDE-AUTO: Use conventional commits: type(scope): description
- CLAUDE-AUTO: Types: feat, fix, refactor, test, docs, chore, agent, hotfix
- CLAUDE-AUTO: Git hooks enforce format (installed from smorch-brain/hooks/commit-msg)

Version control:
- CLAUDE-AUTO: SemVer tags (vX.Y.Z), NEVER version-numbered repos
- MAMOUN-REQUIRED: MAJOR version bumps (v1 to v2) — Claude proposes, Mamoun decides
- CLAUDE-AUTO: MINOR and PATCH bumps — Claude decides based on change scope

Release protocol:
- CLAUDE-PREPARES: 1. Create PR dev to main with release title and notes. STOP — ask Mamoun to review.
- MAMOUN-REQUIRED: 2. Mamoun reviews and approves the merge PR.
- CLAUDE-AUTO: 3. After merge — create tag, GitHub Release, update CHANGELOG on dev
- CLAUDE-AUTO: NEVER skip the GitHub Release — tags without releases are invisible

Documentation enforcement:
- CLAUDE-AUTO: Every repo MUST have: README, CHANGELOG, AGENTS.md, CLAUDE.md, CODEOWNERS, PR template, issue templates
- CLAUDE-AUTO: When ANY are missing, flag it and offer to create them
- CLAUDE-AUTO: Update CHANGELOG with every release
- CLAUDE-AUTO: Install git hooks in any new repo clone

New repo setup:
- MAMOUN-REQUIRED: Naming the repo and confirming its purpose
- CLAUDE-AUTO: Everything else (dev default branch, main protection, docs, scaffold, topics, initial tag + release, hooks)

Architecture decisions:
- MAMOUN-REQUIRED: Creating new repos, archiving repos, renaming repos
- CLAUDE-AUTO: Adding scaffold, creating ADRs, adding documentation

PR management:
- CLAUDE-PREPARES: High-risk PRs (>200 lines, infra/, auth/, out-of-scope) — flag for Mamoun
- CLAUDE-AUTO: Low-risk PRs (tests, docs, prompts) — async review acceptable

Repo hygiene (Claude checks at session start):
- CLAUDE-AUTO: Branches older than 48 hours unmerged? Flag them.
- CLAUDE-AUTO: CHANGELOG up to date? Flag if not.
- CLAUDE-AUTO: All required docs present? Flag if missing.
- CLAUDE-AUTO: Commit hook installed? Install if not.
- CLAUDE-AUTO: Local remote URL correct? Fix if stale.

GitHub org: SMOrchestra-ai
Admin account: smorchestraai-code
Teams: engineering, agents, reviewers
Hooks source: smorch-brain/hooks/commit-msg
Hook installer: smorch-brain/hooks/install-hooks.sh
```

---

## Step 6: Configure Per-Project CLAUDE.md (If Working in a Specific Repo)

Each project repo should have a CLAUDE.md with a `Required Skills` section. If it's missing, create it:

```markdown
## Required Skills
When working on this project, use these skills from the smorch-brain registry:
- dev-meta/smorch-github-ops
- dev-meta/changelog-generator
- dev-meta/systematic-debugging
- [add project-specific skills here]
```

### Existing project skill assignments:

| Project | Required Skills |
|---------|----------------|
| **eo-assessment-system** | eo-training/*, eo-scoring/*, dev-meta/*, tools/webapp-testing, tools/get-api-docs |
| **SaaSFast** | smorch-gtm/*, tools/*, dev-meta/* |
| **salesmfast-sme** | smorch-gtm/ghl-operator, smorch-gtm/n8n-architect, smorch-gtm/instantly-operator, smorch-gtm/heyreach-operator, tools/frontend-design, tools/webapp-testing, dev-meta/* |
| **cxmfast** | smorch-gtm/n8n-architect, tools/frontend-design, tools/webapp-testing, tools/get-api-docs, dev-meta/* |

---

## Step 7: Verify Everything

Run this checklist to confirm the setup is correct:

```bash
echo "=== VERIFICATION ==="

# 1. smorch CLI
echo -n "smorch CLI: " && smorch --help >/dev/null 2>&1 && echo "✅" || echo "❌ — install smorch"

# 2. Profile
echo -n "Profile active: " && smorch status 2>/dev/null | grep "Profile:" || echo "❌ — run: smorch pull --profile YOUR-PROFILE"

# 3. Skills count
echo -n "Skills installed: " && smorch status 2>/dev/null | grep "Installed:" || echo "❌"

# 4. GitHub ops skill present
echo -n "github-ops skill: " && ls ~/.claude/skills/dev-meta/smorch-github-ops/SKILL.md 2>/dev/null && echo "✅" || echo "❌ — run: smorch install dev-meta/smorch-github-ops"

# 5. Changelog skill present
echo -n "changelog skill: " && ls ~/.claude/skills/dev-meta/changelog-generator/SKILL.md 2>/dev/null && echo "✅" || echo "❌ — run: smorch install dev-meta/changelog-generator"

# 6. Global CLAUDE.md
echo -n "Global CLAUDE.md: " && ls ~/.claude/CLAUDE.md 2>/dev/null && echo "✅" || echo "❌ — create from Step 5"

# 7. Git hooks (check in current repo if in one)
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo -n "Commit hook: " && ls "$(git rev-parse --git-dir)/hooks/commit-msg" 2>/dev/null && echo "✅" || echo "❌ — run: ~/smorch-brain/hooks/install-hooks.sh"
fi

echo "=== DONE ==="
```

All items should show ✅. If any show ❌, follow the fix command shown.

---

## Ongoing Operations

### Updating Skills (When Registry Changes)

When Mamoun pushes new skills or updates from his desktop:

```bash
smorch pull
```

This pulls the latest from GitHub and re-installs your profile's skills. Run it whenever you're told the registry has been updated, or whenever you want to check.

### Installing a Skill Outside Your Profile (One-Off)

```bash
smorch install category/skill-name
```

Example: `smorch install smorch-gtm/clay-operator`

### Checking What's Available

```bash
smorch list                 # Everything in the registry
smorch list --installed     # What's on this machine
smorch status               # Profile, sync status, git status
smorch diff                 # Changes since last sync
```

### When Cloning a New Repo

After cloning any SMOrchestra-ai repo:
```bash
cd /path/to/new-repo
~/smorch-brain/hooks/install-hooks.sh
```

---

## Quick Reference — The Rules Claude Code Must Follow

### Always Do (Every Session)
1. Check current branch — never work on main or dev directly
2. Use conventional commits — `type(scope): description`
3. Follow SemVer for tags — `vMAJOR.MINOR.PATCH`
4. Create GitHub Releases for every tag — never just a tag
5. Update CHANGELOG.md with every release
6. Flag missing documentation (README, CHANGELOG, AGENTS.md, CLAUDE.md, templates)

### Always Ask Mamoun Before
1. Merging anything to main
2. Bumping major version (v1 → v2)
3. Creating, renaming, or archiving a repo
4. Any PR touching infra/, auth/, billing/, security/

### Never Do
1. Push directly to main or dev
2. Create a `product-v2` as a separate repo
3. Create tags without GitHub Releases
4. Skip the PR template
5. Modify CI/CD config without approval
6. Leave branches unmerged >48 hours without flagging

---

## Architecture Diagram

```
SMOrchestra-ai (GitHub Org)
├── SaaSFast              (v3.0.0) — MicroSaaS Launcher Platform
├── eo-assessment-system  (v1.0.0) — 5 Scorecard Assessment
├── smorch-brain          (v0.1.0) — Skills Registry + CLI
├── EO-Build              (v0.1.0) — Student Build Pipeline
├── ScrapMfast            (v0.1.0) — Signal Scraping Toolkit
├── ship-fast             (v0.1.0) — Template Baseline
├── eo-mena               (v0.1.0) — MENA Training Platform
└── SaaSFast-v1-archived  (archived)

Each repo has:
├── .github/CODEOWNERS
├── .github/PULL_REQUEST_TEMPLATE.md
├── .github/ISSUE_TEMPLATE/ (bug, feature, task)
├── .github/workflows/ci.yml
├── AGENTS.md
├── CHANGELOG.md
├── CLAUDE.md
├── README.md
├── agents/ (openclaw, claude, experiments)
├── prompts/ (codegen, review, specs)
├── specs/ (tasks, features)
├── product/
├── tests/
├── infra/
└── docs/adr/

Branch model:
main (protected, tagged releases)
  ↑
dev (protected, default, integration)
  ↑
human/[name]/TASK-XXX-slug | agent/TASK-XXX-slug | feature/[name]
```

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `smorch: command not found` | Not in PATH | `sudo ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch` |
| `smorch pull` says already up to date | No new commits on GitHub | Normal — registry hasn't changed |
| Skills not appearing after pull | Not in your profile | Add to profile or use `smorch install category/skill` |
| Commit rejected by hook | Not conventional format | Use: `type(scope): description` |
| Permission denied on git push | SSH key not configured | Switch to HTTPS: `git remote set-url origin https://github.com/SMOrchestra-ai/REPO.git` |
| `smorch pull` errors on Anthropic skills | Read-only system skills | Normal — smorch only manages its 6 categories |
| No CLAUDE.md in `~/.claude/` | First setup | Copy from Step 5 of this guide |
| Claude Code doesn't follow the SOPs | Global CLAUDE.md missing or incomplete | Verify `~/.claude/CLAUDE.md` has the GitHub SOPs section |

---

## Files Reference

| File | Location | Purpose |
|------|----------|---------|
| `smorch` CLI | `~/smorch-brain/scripts/smorch` | Skill management tool |
| Commit hook | `~/smorch-brain/hooks/commit-msg` | Conventional commit enforcer |
| Hook installer | `~/smorch-brain/hooks/install-hooks.sh` | Installs hook into current repo |
| Profiles | `~/smorch-brain/profiles/*.txt` | Machine-specific skill lists |
| Skills | `~/smorch-brain/skills/` | The 51-skill registry |
| MCP base config | `~/smorch-brain/mcp-configs/base.mcp.json` | Base MCP server configuration |
| Global instructions | `~/.claude/CLAUDE.md` | Claude Code behavior rules |
| Installed skills | `~/.claude/skills/` | Active skills on this machine |

---

---

## Current Architecture Score — 10/10

This is where the org stands as of 2026-03-22. Every new machine must maintain this score.

| # | Dimension | Score | What It Means |
|---|-----------|-------|---------------|
| 1 | **Org metadata** (name, desc, email, URL, location) | 10/10 | All fields configured on the org profile |
| 2 | **Repo descriptions + topics** (7/7 active repos) | 10/10 | Every repo has a clear description and searchable topic tags |
| 3 | **Branch model** (main + dev + human/* + agent/*) | 10/10 | Protected branches, correct naming conventions, namespace separation |
| 4 | **Branch protection** (main + dev, all repos) | 10/10 | 1 required reviewer on both main and dev, enforced |
| 5 | **Architecture scaffold** (product repos) | 10/10 | All product repos have: agents/, prompts/, specs/, product/, tests/, infra/, docs/adr/ |
| 6 | **Version control** (SemVer tags + GitHub Releases) | 10/10 | Every active repo has at least v0.1.0 tag + GitHub Release |
| 7 | **CHANGELOGs** (7/7 repos) | 10/10 | Every repo has CHANGELOG.md following Keep a Changelog format |
| 8 | **AGENTS.md** (7/7 repos) | 10/10 | Every repo has AI agent behavior rules documented |
| 9 | **PR templates** (7/7 repos) | 10/10 | Standardized template with summary, testing, risk assessment |
| 10 | **Issue templates** (7/7 repos x 3) | 10/10 | Bug, feature, task templates in every repo |
| 11 | **Commit conventions** (hook + skill + SOP) | 10/10 | Triple enforcement: git hook rejects bad commits, skill validates, SOP documents |
| 12 | **Release protocol** (skill + SOP + Releases) | 10/10 | Full protocol: PR → merge → tag → GitHub Release → CHANGELOG |
| 13 | **Documentation** (README + CHANGELOG + AGENTS + ADR) | 10/10 | All required docs present in every repo |
| 14 | **Teams** (engineering, agents, reviewers) | 10/10 | Role-based access control configured |

### How We Got Here (The Journey)

| Date | Score | What Changed |
|------|-------|-------------|
| 2026-03-01 | 2.7/10 | Starting state — repos existed with basic branch model, no docs, no releases, no enforcement |
| 2026-03-22 AM | 9.6/10 | Added: org metadata, descriptions, topics, AGENTS.md x8, CHANGELOG x8, PR templates x7, issue templates x24, GitHub Releases x2, architecture scaffold, smorch-github-ops skill, SOPs in CLAUDE.md |
| 2026-03-22 PM | 10/10 | Fixed: SaaSFast repo consolidation (renamed, archived old), v0.1.0 releases for 5 remaining repos, git commit-msg hook, ownership markers in SOPs |

### What Maintains the 10/10

The score stays at 10/10 automatically because:

1. **smorch-github-ops skill** — Claude Code enforces branch naming, commits, releases, documentation in every session
2. **commit-msg git hook** — non-conventional commits are rejected at git level before they reach GitHub
3. **Global CLAUDE.md SOPs** — every Claude Code session loads these rules and follows them
4. **Per-project CLAUDE.md** — each project has its own skill requirements
5. **smorch CLI** — profile-based skill distribution ensures every machine has the right skills

If any dimension drops below 10/10 (e.g., a new repo is created without docs), the smorch-github-ops skill will flag it in the next session and fix it automatically.

### Your Responsibility as a New Machine

When this guide is followed, you inherit the 10/10 score. To maintain it:
- Run `smorch pull` when told the registry updated
- Install git hooks in every new repo clone
- Never bypass the SOPs — they exist because each rule prevents a specific failure mode
- If Claude Code flags a missing doc or stale branch, fix it immediately

---

*This guide is version-controlled in smorch-brain. If something doesn't work, check for a newer version: `cd ~/smorch-brain && git pull`*
