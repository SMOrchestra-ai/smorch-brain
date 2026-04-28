# SMOrchestra Skills Distribution Plan
## Centralized AI Skill Registry & On-Demand Distribution

**Version:** 2.1 (Post-Execution + Operational Runbook)
**Date:** 2026-03-16
**Owner:** Mamoun Alamouri, Founder & CEO, SMOrchestra.ai
**Repo:** github.com/SMOrchestra-ai/smorch-brain (private)

---

## 1. Executive Summary

SMOrchestra operates 48 custom AI skills — the accumulated IP from months of building signal-based GTM engines, EO training products, and content systems. Today these skills live on one desktop. Servers running production workloads have zero access. Team members start from scratch.

This plan creates a central skill registry on GitHub with a single CLI tool (`smorch`) that gives any machine instant access to exactly the skills it needs. No automated background processes. No scheduled jobs. Full manual control over what moves where and when.

**Result:** One command to push skills. One command to pull them. Any machine, any time.

---

## 2. Business Requirements

These requirements come directly from the CEO:

| # | Requirement | Solution |
|---|-------------|----------|
| 1 | Skills created on desktop need IMMEDIATE availability on servers | `smorch push` + `smorch pull` — takes seconds |
| 2 | Not all skills on all projects — ability to SELECT per-project | Per-project CLAUDE.md declares required skills |
| 3 | Applies to: desktop, smo-brain, smo-dev, future production, team | Machine profiles + `smorch init` for new nodes |
| 4 | On-demand sync — user chooses WHEN and WHAT | No automation. Manual push/pull. |
| 5 | Central management from one place | GitHub repo as single source of truth |
| 6 | No bloat | One 550-line bash script replaces 4 scripts + n8n + cron |

---

## 3. Architecture Decision Record (ADR)

### ADR-001: On-Demand Pull vs Automated Sync

**Status:** Accepted
**Date:** 2026-03-16

**Context:**
The original plan used n8n workflows polling GitHub every 5 minutes on each server, plus a cron job on the desktop exporting skills every 30 minutes. Skills change approximately once per week. This created:
- 576 unnecessary GitHub API calls per day
- Dozens of empty "auto: skill sync" git commits
- Two n8n workflows consuming execution slots meant for business automation
- Background complexity with zero user control

**Decision:**
Replace all automated sync with on-demand `smorch` CLI commands. Git is the registry. The user pushes when ready. Each machine pulls what it needs, when told to.

**Rejected Alternatives:**

| Alternative | Why Rejected |
|-------------|-------------|
| n8n polling every 5 min | 576 wasted API calls/day. n8n is for business workflows, not git pulls. |
| Desktop cron every 30 min | Auto-commits for zero changes. Pollutes git history. |
| Daily cron at midnight/2AM | Still automated. Still no control over WHAT gets synced. |
| fswatch / launchd watchers | Fragile, hard to debug, OS-specific complexity for no real gain. |

**Consequences:**
- Sync happens only when user explicitly requests it — typically seconds after push
- For urgent changes: SSH to server → `smorch pull` → done in 10 seconds
- For routine updates: push from desktop, pull next time you work on that server
- No background processes to monitor, debug, or maintain

---

## 4. How It Works (For Operations / Agency Users)

### The Concept
Think of it as a skill library. You build skills on your Mac. When they're ready, you upload them to the library (`smorch push`). When a server needs the latest version, you download from the library (`smorch pull`). That's it.

Each server has a "profile" — a list of which skills it gets. Your desktop gets everything (48 skills). The EO server gets EO training + scoring skills (~22). The GTM dev server gets GTM + dev tools (~11).

Each project has a CLAUDE.md file that tells the AI "for THIS project, use THESE skills." So even though a server might have 22 skills installed, when working on eo-assessment-system, the AI focuses on the EO skills.

### Commands Cheat Sheet

```
smorch push                              Upload skills from desktop to library
smorch pull                              Download latest skills for this machine
smorch pull --profile smo-brain          Download skills matching a specific profile
smorch install eo-training               Download just one category
smorch install eo-training/eo-brain-ingestion  Download just one skill
smorch remove eo-training                Remove a category from this machine
smorch list                              See everything in the library
smorch list --installed                  See what's on this machine
smorch list --available                  See what's NOT on this machine yet
smorch list --profiles                   See all available profiles
smorch diff                              See what changed since last sync
smorch status                            Current profile, skill count, last sync
smorch init --profile <name>             First-time setup on a new machine
```

### Common Workflows

**You just created a new skill in Cowork:**
1. `smorch push` on your Mac
2. SSH to server → `smorch pull`
3. Done.

**You downloaded a skill from GitHub/Smithery:**
1. Copy it to `~/smorch-brain/skills/<category>/`
2. `cd ~/smorch-brain && git add . && git commit -m "add: skill-name" && git push`
3. On any server: `smorch pull`

**New team member starting:**
1. They clone the repo: `smorch init --profile gtm-team`
2. Done. They have exactly the skills their role needs.

---

## 5. Technical Architecture

### 5.1 System Diagram

```
Desktop (macOS)                     GitHub                           Servers
┌──────────────────┐         ┌──────────────────────┐        ┌──────────────────┐
│  Cowork Desktop  │         │  SMOrchestra-ai/     │        │  smo-brain       │
│  (skill creation)│         │  smorch-brain        │        │  (EO products)   │
│                  │         │  (private)           │        │                  │
│  smorch push ────┼────────►│  skills/             │◄───────┼── smorch pull    │
│                  │         │    smorch-gtm/ (15)  │        │    --profile     │
│  Claude Code     │         │    eo-training/ (11) │        │    smo-brain     │
│  (all 48 skills) │         │    eo-scoring/ (5)   │        │  (~22 skills)    │
│                  │         │    content/ (7)      │        ├──────────────────┤
│  Skills from:    │         │    dev-meta/ (6)     │        │  smo-dev         │
│  - Cowork create │         │    tools/ (4)        │        │  (GTM products)  │
│  - GitHub        │         │  profiles/           │        │                  │
│  - Smithery      │         │  mcp-configs/        │◄───────┼── smorch pull    │
│  - Manual edit   │         │  scripts/smorch      │        │    --profile     │
└──────────────────┘         └──────────────────────┘        │    smo-dev       │
                                                              │  (~11 skills)    │
                                                              └──────────────────┘
```

### 5.2 Skill Inventory (48 User-Created Skills)

| Category | Count | Skills |
|----------|-------|--------|
| smorch-gtm | 15 | signal-to-trust-gtm, signal-detector, wedge-generator, asset-factory, campaign-strategist, positioning-engine, outbound-orchestrator, ghl-operator, instantly-operator, heyreach-operator, clay-operator, n8n-architect, scraper-layer, smorch-salesnav-operator, smorch-linkedin-intel |
| eo-training | 11 | eo-brain-ingestion, eo-gtm-asset-factory, eo-skill-extractor, eo-tech-architect, eo-microsaas-dev, eo-db-architect, eo-api-connector, eo-qa-testing, eo-security-hardener, eo-deploy-infra, eo-training-factory |
| content | 7 | eo-youtube-mamoun, smorch-perfect-webinar, smo-offer-assets, content-systems, movement-builder, engagement-engine, validation-sprint |
| dev-meta | 6 | smo-skill-creator, smorch-tool-super-admin-creator, systematic-debugging, requesting-code-review, receiving-code-review, using-superpowers |
| eo-scoring | 5 | project-definition-scoring-engine, icp-clarity-scoring-engine, market-attractiveness-scoring-engine, strategy-selector-engine, gtm-fitness-scoring-engine |
| tools | 4 | frontend-design, webapp-testing, get-api-docs, lead-research-assistant |

### 5.3 Machine Profiles

| Profile | Skills | Target Machine | Repos Served |
|---------|--------|----------------|-------------|
| mamoun | 48 (all) | Desktop Claude Code | All repos |
| smo-brain | ~22 | Personal Server | eo-assessment-system, EO-Build |
| smo-dev | ~11 | SMO Dev Server | SaaSFast, ScrapMfast |
| gtm-team | ~22 | GTM team laptops | N/A |
| eo-student | ~16 | EO student laptops | N/A |
| developer | ~10 | Dev team laptops | N/A |

### 5.4 Per-Project Skill Selection

Each project repo's `.claude/CLAUDE.md` declares required skills:

```markdown
# Required Skills
When working on this project, use these skills:
- eo-training/* (all EO training skills)
- eo-scoring/* (all scoring engines)
- dev-meta/systematic-debugging
- tools/webapp-testing
```

Claude Code reads CLAUDE.md at session start. The skills are installed on the machine (via profile), but Claude Code knows which ones are relevant to THIS project. No additional tooling needed.

### 5.5 MCP Configuration (Base + Overlay Merge)

| Config File | MCPs Included | Used By |
|-------------|--------------|---------|
| base.mcp.json | n8n, Apify, Linear, Exa | All machines |
| smo-brain.mcp.json | + Contabo, Playwright | smo-brain server |
| smo-dev.mcp.json | + Contabo, Playwright | smo-dev server |
| desktop.mcp.json | + Clay, Common Room, Playwright | Desktop |

`smorch pull` auto-merges base + overlay using `jq`. Each server's `.env` has different API keys (n8n Instance 1 vs Instance 2).

### 5.6 Repository Structure

```
github.com/SMOrchestra-ai/smorch-brain (private)
├── skills/
│   ├── smorch-gtm/     (15 skills — GTM engine IP)
│   ├── eo-training/    (11 skills — EO product IP)
│   ├── eo-scoring/     (5 skills — scoring engines)
│   ├── content/        (7 skills — content & education)
│   ├── dev-meta/       (6 skills — dev workflow)
│   └── tools/          (4 skills — utilities)
├── plugins/
│   ├── smorch-gtm-engine/     (v1.0.0)
│   ├── eo-microsaas-os/       (v3.1.0)
│   └── eo-scoring-suite/      (v1.0.0)
├── mcp-configs/
│   ├── base.mcp.json
│   ├── smo-brain.mcp.json
│   ├── smo-dev.mcp.json
│   └── desktop.mcp.json
├── profiles/
│   ├── mamoun.txt          (all skills)
│   ├── smo-brain.txt       (EO + scoring + dev)
│   ├── smo-dev.txt          (GTM + dev + tools)
│   ├── gtm-team.txt
│   ├── eo-student.txt
│   └── developer.txt
├── scripts/
│   └── smorch              (CLI tool, ~550 lines bash)
├── .env.template
├── CLAUDE.md
└── .gitignore
```

### 5.7 The `smorch` CLI Tool

Single bash script (~550 lines). Core commands:

| Command | What It Does |
|---------|-------------|
| `push` | Discovers Cowork skills path, copies user-created skills (skips 14 Anthropic built-ins), sorts into categories, git commit + push |
| `pull [--profile]` | Git pull, reads profile .txt, backs up current skills, installs matching skills, merges MCP configs |
| `install <path>` | Git pull, installs single category or skill without touching others |
| `remove <path>` | Removes category or skill from local machine |
| `list [--installed/--available/--profiles]` | Shows registry, installed, or gap between them |
| `diff` | Git fetch + diff showing what changed since last pull |
| `status` | Profile name, last sync time, installed count, registry count, git status |
| `init --profile <name>` | First-time setup: clone repo + pull profile |

Profile resolution supports: `*` (all), `category/*` (all in category), `category/skill` (specific skill).

---

## 6. Execution Plan

### Phase 1: Bootstrap (Desktop) — ✅ COMPLETE
- 48 skills exported from Cowork into 6 categories
- smorch CLI built and tested (~556 lines bash)
- 6 profiles created (mamoun, smo-brain, smo-dev, gtm-team, eo-student, developer)
- 4 MCP configs created (base + 3 overlays)
- Pushed to github.com/SMOrchestra-ai/smorch-brain
- smorch symlinked to ~/bin/smorch

**Execution Result:**
```
smorch status
──────────────────────────────────
Profile:    mamoun
Skills dir: /Users/mamounalamouri/.claude/skills
Installed:  48 skills
Registry:   48 skills
Git branch: main
──────────────────────────────────
```

**Fix applied during execution:** `cmd_pull()` was deleting Anthropic read-only skills. Fixed to only clean managed categories:
```bash
local -a MANAGED_CATS=(smorch-gtm eo-training eo-scoring content dev-meta tools)
```

### Phase 2: Server Setup (Both servers, parallel) — ✅ COMPLETE

**smo-brain (vmi3051702) — Execution Result:**
```bash
git clone git@github.com:SMOrchestra-ai/smorch-brain.git ~/smorch-brain
chmod +x ~/smorch-brain/scripts/smorch
ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch
smorch pull --profile smo-brain
```
```
smorch status
──────────────────────────────────
Profile:    smo-brain
Last sync:  2026-03-16T13:59:27Z
Registry:   /root/smorch-brain
Skills dir: /root/.claude/skills
Installed:  22 skills
Registry:   48 skills
Git branch: main (0 commits behind)
──────────────────────────────────
```

**smo-dev (vmi3071952) — Execution Result:**
```bash
git clone git@github.com:SMOrchestra-ai/smorch-brain.git ~/smorch-brain
chmod +x ~/smorch-brain/scripts/smorch
ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch
smorch pull --profile smo-dev
```
```
smorch status
──────────────────────────────────
Profile:    smo-dev
Last sync:  2026-03-16T14:00:36Z
Registry:   /root/smorch-brain
Skills dir: /root/.claude/skills
Installed:  14 skills (11 from profile + 3 pre-existing)
Registry:   48 skills
Git branch: main (0 commits behind)
──────────────────────────────────
```

### Phase 3: Per-Project CLAUDE.md Updates — ✅ COMPLETE
Added "Required Skills" section to each project's `.claude/CLAUDE.md`:

| Project | Required Skills | Status |
|---------|----------------|--------|
| eo-assessment-system | eo-training/*, eo-scoring/*, dev-meta/systematic-debugging, dev-meta/requesting-code-review, dev-meta/receiving-code-review, tools/webapp-testing, tools/get-api-docs | ✅ |
| salesmfast-signal (SaaSFast) | smorch-gtm/*, tools/*, dev-meta/* | ✅ |
| salesmfast-sme | ghl-operator, n8n-architect, instantly-operator, heyreach-operator, frontend-design, webapp-testing, systematic-debugging | ✅ |
| cxmfast | n8n-architect, frontend-design, webapp-testing, get-api-docs, systematic-debugging, requesting-code-review | ✅ |

### Phase 4: Verification — ✅ COMPLETE

| Test | Command | Result |
|------|---------|--------|
| Desktop status | `smorch status` | 48 skills, mamoun profile ✅ |
| smo-brain status | `smorch status` | 22 skills, smo-brain profile ✅ |
| smo-dev status | `smorch status` | 11 skills, smo-dev profile ✅ |
| Push test skill | `smorch push` (desktop) | test-skill pushed to GitHub ✅ |
| Pull respects profile | `smorch pull` (smo-brain) | test-skill NOT installed (not in profile) ✅ |
| Granular install | `smorch install tools/test-skill` (smo-brain) | test-skill installed on demand ✅ |
| Cleanup | Remove test skill + push | Cleaned from repo ✅ |

**Key verification insight:** Profile filtering works exactly as designed. `smorch pull` only installs skills declared in the profile. Skills outside the profile require explicit `smorch install` — giving full control over what lands on each machine.

### Phase 5: Team Distribution — Deferred (trigger: first hire)
- `smorch init --profile gtm-team` for team Claude Code
- OR .plugin file for team Cowork installs

**Total execution time: ~1.5 hours**

---

## 7. What Was Removed (vs Previous Plan)

| Removed Component | Reason |
|-------------------|--------|
| n8n sync workflow on smo-brain | Skills change weekly. n8n is for business workflows. |
| n8n sync workflow on smo-dev | Same. Independent polling was overkill. |
| Desktop cron export (every 30 min) | Auto-commits for zero changes. Git noise. |
| Server cron sync (every 5 min) | 576 wasted GitHub API calls per day. |
| Daily midnight/2AM cron option | Still automated. User wants control over when and what. |
| fswatch / launchd watchers | OS-specific fragility for no real benefit. |
| 4 separate scripts (export, install, sync, build-plugins) | Consolidated into 1 `smorch` CLI. |

**Net result:** Removed 2 n8n workflows, 3 cron jobs, 3 extra scripts, and all background automation. Replaced with one bash script and manual git operations.

---

## 8. Dependencies

| Dependency | Status |
|-----------|--------|
| Git + SSH access to SMOrchestra-ai org | Verified on both servers |
| Node.js v22+ on all nodes | v22.22.0 everywhere |
| OpenClaw multi-node mesh | 3 nodes connected |
| Tailscale VPN mesh | smo-brain, smo-dev, smo-desktop |
| jq (for MCP config merge) | Verify on each machine during Phase 2 |

---

## 9. Future Considerations

| Item | When | Effort |
|------|------|--------|
| Add production server | When launched | 2 min (`smorch init --profile production`) |
| New skill categories | When needed | Add folder + update profiles |
| Team scaling | First hire | Build .plugin files (30 min/role) |
| Optional nightly backup | If desired | Single cron: `smorch push` as insurance |
| Skill usage analytics | When team grows | Track invocation rates per profile |

---

## 10. Operational Runbook — Step-by-Step Guides

### 10.1 Create a New Skill (in Cowork/Claude Code)

**When:** You build a new skill through conversation or the skill creator.

| Step | Action | Where |
|------|--------|-------|
| 1 | Create the skill in Cowork/Claude Code as normal | Desktop |
| 2 | Run `smorch push` | Desktop terminal |
| 3 | Verify: `smorch list` — new skill appears in registry | Desktop terminal |
| 4 | (Optional) SSH to server → `smorch pull` | Server terminal |

**What `smorch push` does behind the scenes:**
- Discovers Cowork skills path (`~/.claude/skills/`)
- Copies user-created skills (skips 14 Anthropic built-ins)
- Sorts into categories under `~/smorch-brain/skills/`
- Runs `git add`, `git commit`, `git push`

### 10.2 Edit / Update an Existing Skill

**When:** You modify a skill's instructions, add examples, or fix behavior.

| Step | Action | Where |
|------|--------|-------|
| 1 | Edit the skill in Cowork or directly in `~/smorch-brain/skills/<category>/<skill-name>/` | Desktop |
| 2 | Run `smorch push` (if edited in Cowork) OR `cd ~/smorch-brain && git add . && git commit -m "update: <skill-name>" && git push` (if edited directly) | Desktop terminal |
| 3 | On any server that needs the update: `smorch pull` | Server terminal |

**Tip:** If you only need the update on one server, just SSH there and pull. No need to update all servers every time.

### 10.3 Download a Skill from GitHub / Smithery

**When:** You find a useful skill online and want it in your registry.

| Step | Action | Where |
|------|--------|-------|
| 1 | Download or clone the skill | Desktop |
| 2 | Copy it to the right category: `cp -r <skill-folder> ~/smorch-brain/skills/<category>/` | Desktop terminal |
| 3 | Commit and push: `cd ~/smorch-brain && git add skills/<category>/<skill-name> && git commit -m "add: <skill-name> from <source>" && git push` | Desktop terminal |
| 4 | On servers: `smorch pull` (if in profile) or `smorch install <category>/<skill-name>` (if not) | Server terminal |

**Categories to choose from:**
- `smorch-gtm/` — GTM, outbound, signal detection, CRM operators
- `eo-training/` — EO product skills (ingestion, architecture, dev)
- `eo-scoring/` — Scoring engines
- `content/` — Content creation, YouTube, webinars
- `dev-meta/` — Development workflow, debugging, code review
- `tools/` — Utilities (testing, API docs, research, design)

### 10.4 Delete / Retire a Skill

| Step | Action | Where |
|------|--------|-------|
| 1 | Remove from registry: `rm -rf ~/smorch-brain/skills/<category>/<skill-name>` | Desktop terminal |
| 2 | Commit and push: `cd ~/smorch-brain && git add -A && git commit -m "retire: <skill-name>" && git push` | Desktop terminal |
| 3 | Remove from any profile that references it: edit `~/smorch-brain/profiles/<profile>.txt` | Desktop terminal |
| 4 | Remove from any project CLAUDE.md that references it | Relevant project |
| 5 | On servers: `smorch pull` — the skill will be removed | Server terminal |

### 10.5 Create a New Skill Category

**When:** You need a new grouping (e.g., `analytics/`, `client-ops/`).

| Step | Action | Where |
|------|--------|-------|
| 1 | Create the folder: `mkdir ~/smorch-brain/skills/<new-category>` | Desktop terminal |
| 2 | Add skills into it | Desktop terminal |
| 3 | Update `scripts/smorch` — add the new category to `MANAGED_CATS` array | Desktop terminal |
| 4 | Update relevant profiles in `~/smorch-brain/profiles/` to include the new category | Desktop terminal |
| 5 | Commit and push: `cd ~/smorch-brain && git add . && git commit -m "add: <new-category> category" && git push` | Desktop terminal |

**Important:** The `MANAGED_CATS` array in `scripts/smorch` controls which directories `smorch pull` manages. If you don't add the category there, pull won't clean/install it.

### 10.6 Add a New Plugin

**When:** You bundle multiple skills into a distributable plugin (for team or Cowork installs).

| Step | Action | Where |
|------|--------|-------|
| 1 | Create plugin folder: `mkdir ~/smorch-brain/plugins/<plugin-name>` | Desktop terminal |
| 2 | Add plugin manifest and skill references | Desktop terminal |
| 3 | Commit and push | Desktop terminal |

**Plugin structure:**
```
plugins/<plugin-name>/
├── manifest.json        (name, version, description, skills list)
├── CLAUDE.md            (instructions for Claude Code when plugin is active)
└── skills/              (bundled skill files if self-contained)
```

### 10.7 Start a New Project (Add Skill Selection)

**When:** You create a new repo or project and want Claude Code to use specific skills.

| Step | Action | Where |
|------|--------|-------|
| 1 | Create `.claude/CLAUDE.md` in the project root (if it doesn't exist) | Project repo |
| 2 | Add a `## Required Skills` section listing the skills this project needs | Project repo |
| 3 | Ensure the server running this project has those skills installed (check profile) | Server terminal |

**Template for the Required Skills section:**
```markdown
## Required Skills
When working on this project, use these skills from the smorch-brain registry:
- <category>/* (all skills in category)
- <category>/<specific-skill>
- <category>/<specific-skill>
```

**Example — new EO product:**
```markdown
## Required Skills
When working on this project, use these skills from the smorch-brain registry:
- eo-training/* (all EO training skills)
- eo-scoring/* (all scoring engines)
- dev-meta/systematic-debugging
- dev-meta/requesting-code-review
- tools/webapp-testing
- tools/get-api-docs
```

**Example — new GTM campaign project:**
```markdown
## Required Skills
When working on this project, use these skills from the smorch-brain registry:
- smorch-gtm/* (all GTM skills)
- content/content-systems
- content/movement-builder
- tools/lead-research-assistant
```

### 10.8 Add a New Server / Machine

**When:** You spin up a production server, add a team laptop, or onboard someone.

| Step | Action | Where |
|------|--------|-------|
| 1 | Decide which profile fits (or create a new one — see 10.9) | — |
| 2 | On the new machine: `smorch init --profile <name>` | New machine |
| 3 | Create `~/.claude/.env` with machine-specific API keys | New machine |
| 4 | Verify: `smorch status` | New machine |

**That's it.** The init command clones the repo, installs the profile's skills, and merges MCP configs.

### 10.9 Create a New Profile

**When:** A new role or machine type needs a different skill mix.

| Step | Action | Where |
|------|--------|-------|
| 1 | Create profile file: `~/smorch-brain/profiles/<profile-name>.txt` | Desktop terminal |
| 2 | Add skill references, one per line | Desktop terminal |
| 3 | (Optional) Create matching MCP overlay: `~/smorch-brain/mcp-configs/<profile-name>.mcp.json` | Desktop terminal |
| 4 | Commit and push | Desktop terminal |

**Profile syntax:**
```
*                           # all skills (mamoun profile)
eo-training/*               # all skills in a category
eo-scoring/*                # all skills in a category
dev-meta/systematic-debugging   # specific skill
tools/webapp-testing            # specific skill
```

### 10.10 Change Which Skills a Server Gets

**When:** A server's role changes or you want to add/remove skills from its profile.

| Step | Action | Where |
|------|--------|-------|
| 1 | Edit the profile: `~/smorch-brain/profiles/<profile-name>.txt` | Desktop terminal |
| 2 | Commit and push: `cd ~/smorch-brain && git add profiles/ && git commit -m "update: <profile-name> profile" && git push` | Desktop terminal |
| 3 | On the server: `smorch pull` — it re-reads the updated profile | Server terminal |

### 10.11 Quick Install a Skill Outside Your Profile

**When:** You need a skill on a server that isn't in its profile (one-off, testing, client work).

```bash
smorch install <category>/<skill-name>
```

This pulls from the registry and installs without changing the profile. Next `smorch pull` will NOT remove it — it only cleans managed category folders and reinstalls from profile.

**To make it permanent:** Add it to the server's profile (see 10.10).

### 10.12 Check What's Available vs What's Installed

```bash
smorch list                    # Everything in the registry (48 skills)
smorch list --installed        # What's on THIS machine
smorch list --available        # What's in the registry but NOT on this machine
smorch list --profiles         # All available profiles
smorch diff                    # What changed since last sync
smorch status                  # Profile, skill count, last sync, git status
```

### 10.13 Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `smorch pull` says "Already up to date" but skills are old | Git pulled but no new commits | Run `smorch push` on desktop first |
| Skill not installed after `smorch pull` | Skill not in this machine's profile | Add to profile (10.10) or use `smorch install` (10.11) |
| `smorch push` fails with permission error | SSH key not authorized on GitHub | Use HTTPS: `git remote set-url origin https://github.com/SMOrchestra-ai/smorch-brain.git` |
| `smorch pull` deletes non-smorch skills | Category added to `MANAGED_CATS` but shouldn't be | Check `MANAGED_CATS` in `scripts/smorch` — only list categories smorch manages |
| MCP config not merging | Missing overlay file | Create `mcp-configs/<profile>.mcp.json` or use base only |
| `smorch: command not found` | Symlink missing or PATH issue | `ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch` or `~/bin/smorch` |

---

## 11. Contact & Ownership

| Role | Person |
|------|--------|
| Architecture owner | Mamoun Alamouri |
| GitHub org admin | smorchestraai-code |
| Executor | Claude Code (on each node) |
| Approval for all changes | Mamoun |
