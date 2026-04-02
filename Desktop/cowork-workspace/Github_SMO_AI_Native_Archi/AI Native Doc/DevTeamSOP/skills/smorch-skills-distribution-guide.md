# SMOrchestra Skills Distribution System
## Architecture Decision Record + Implementation Guide

**Version:** 1.0
**Date:** 2026-03-16
**Author:** Mamoun Alamouri, Founder & CEO, SMOrchestra.ai
**Status:** Implemented

---

## 1. Business Context

SMOrchestra.ai runs AI agents across multiple servers and a desktop to power its consulting, SaaS products, and content operations. These agents use "skills" — specialized instruction sets that make Claude Code productive for specific tasks (GTM campaigns, EO training products, scoring engines, dev workflows).

**The problem:** 48 custom skills lived only on one desktop. Servers running AI agents had zero access. Team members starting from scratch. No central registry. No version control. No way to select which skills apply to which project.

**What this solves:**
- Central skill registry (GitHub) accessible from any node
- On-demand sync — you choose when and what moves where
- Per-machine profiles — servers only get skills relevant to their repos
- Per-project selection — each project declares which skills it needs
- Source-agnostic — skills from Cowork, GitHub, Smithery, or hand-written all go through the same pipeline

---

## 2. Why This Approach (ADR — Architecture Decision Record)

### Decision: On-Demand CLI + Git Registry vs Automated Sync

**Context:** The initial plan proposed automated continuous sync — n8n workflows polling GitHub every 5 minutes, cron jobs exporting skills every 30 minutes, multiple scripts for different operations.

**Problem with automated sync:**

| Issue | Impact |
|-------|--------|
| Skills change maybe once a week | 576 wasted GitHub API calls/day |
| No granularity — sync everything or nothing | Bloated servers with irrelevant skills |
| Cron/n8n adds moving parts that break silently | Maintenance overhead for zero value |
| Lag between edit and deploy (even daily has hours of delay) | Not "immediate" as required |
| Only handles Cowork as skill source | Ignores GitHub/Smithery downloads |

**Decision:** Replace all automation with a single CLI tool (`smorch`) that executes on-demand. Git remains the registry. You push when ready. Each machine pulls what it needs, when you say so.

**Consequences:**
- Zero background processes — nothing to monitor or debug
- Instant — create skill, push, pull, deployed in 60 seconds
- Granular — install one skill, one category, or a full profile
- Source-agnostic — any skill source feeds the same git repo
- Simple — one bash script replaces 4 scripts + 3 cron jobs + 2 n8n workflows
- Requires manual trigger — you must remember to push/pull (intentional trade-off)

**Alternatives considered:**

1. **n8n polling every 5 min** — Rejected. Over-engineered for weekly changes.
2. **Daily cron at midnight/2AM** — Rejected. Still has lag, still automated for no reason.
3. **Git webhooks triggering server pull** — Considered for future. Good middle ground but requires webhook infrastructure. Not needed at current scale.
4. **Cowork plugin auto-sync** — Not feasible. Cowork skills are read-only inside the VM.

---

## 3. For Business Users (Non-Technical Overview)

### What Are Skills?

Skills are instruction files that tell AI agents how to do specific jobs. Think of them as the "training manual" for each agent. Without skills, the AI starts from scratch every time. With skills, it knows your processes, tools, terminology, and quality standards.

### What Changed?

Before: Skills lived on one laptop. Agents on servers couldn't access them.
After: Skills live in a central registry (like a shared drive, but with version control). Any machine can pull exactly the skills it needs.

### How It Works (Simple Version)

1. Mamoun creates or updates a skill on his desktop
2. He runs `smorch push` — skills upload to the central registry
3. On any server, run `smorch pull` — that server gets the latest skills
4. Each project has a list of which skills it uses — no bloat, no confusion

### Business Impact

- **Faster agent setup:** New servers get all skills in 60 seconds
- **Consistency:** All agents use the same version of each skill
- **Control:** You decide exactly which skills each server gets
- **Team-ready:** When hiring, new team members get role-specific skills instantly

---

## 4. For Agency Users (Operations Overview)

### Skill Categories (48 Total)

| Category | Count | Purpose | Used By |
|----------|-------|---------|---------|
| **smorch-gtm/** | 15 | Signal-based GTM engine — ICP validation, campaign sequencing, outbound orchestration, CRM operations | GTM campaigns, client projects |
| **eo-training/** | 11 | EO Training product — scorecard processing, tech architecture, MicroSaaS dev pipeline, QA, deployment | eo-assessment-system, EO-Build |
| **eo-scoring/** | 5 | 5-scorecard evaluation system — project definition, ICP clarity, market attractiveness, strategy, GTM fitness | Scoring engagements, consulting |
| **content/** | 7 | YouTube scripts, webinar assets, offer creation, content systems, engagement | YouTube channel, course funnels |
| **dev-meta/** | 6 | Development workflows — debugging, code review, skill creation | All dev projects |
| **tools/** | 4 | Utility — frontend design, webapp testing, API docs, lead research | Cross-project |

### Machine Profiles

| Machine | Profile | Skills Installed | Repos Served |
|---------|---------|-----------------|-------------|
| Desktop (Mamoun's Mac) | `mamoun` | All 48 | Everything |
| Personal Server (smo-brain) | `smo-brain` | ~22 (EO + scoring + dev) | eo-assessment-system, EO-Build |
| SMO Dev Server (smo-dev) | `smo-dev` | ~11 (GTM + dev + tools) | SaaSFast, ScrapMfast |
| GTM Team member | `gtm-team` | 22 (GTM + content) | Campaign work |
| EO Student | `eo-student` | 16 (EO training + scoring) | EO coursework |
| Developer | `developer` | 10 (dev + tools + n8n) | Code projects |

### Daily Workflow

1. **Creating a skill:** Build in Cowork, then `smorch push` — available everywhere
2. **Downloading a skill:** Copy to `~/smorch-brain/skills/<category>/`, then `git add`, `git commit`, `git push`
3. **Deploying to server:** SSH to server, then `smorch pull` — done
4. **Installing one category:** `smorch install eo-training` on any machine
5. **Checking what's installed:** `smorch list --installed`

---

## 5. For Technical/Developer Team

### Architecture

```
                         ┌─────────────────────────────┐
                         │  GitHub: smorch-brain repo   │
                         │  (private skill registry)    │
                         │                              │
                         │  skills/                     │
                         │    smorch-gtm/ (15)          │
                         │    eo-training/ (11)         │
                         │    eo-scoring/ (5)           │
                         │    content/ (7)              │
                         │    dev-meta/ (6)             │
                         │    tools/ (4)                │
                         │  profiles/                   │
                         │  mcp-configs/                │
                         │  scripts/smorch              │
                         └──────────┬──────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
              ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
              │  Desktop   │  │ smo-brain │  │  smo-dev  │
              │            │  │           │  │           │
              │ smorch push│  │ smorch    │  │ smorch    │
              │ (creates + │  │ pull      │  │ pull      │
              │  exports)  │  │ --profile │  │ --profile │
              │            │  │ smo-brain │  │ smo-dev   │
              └────────────┘  └───────────┘  └───────────┘
```

### Repository Structure

```
~/smorch-brain/
├── skills/
│   ├── smorch-gtm/          # 15 GTM skills
│   │   ├── signal-to-trust-gtm/
│   │   ├── signal-detector/
│   │   ├── wedge-generator/
│   │   ├── asset-factory/
│   │   ├── campaign-strategist/
│   │   ├── positioning-engine/
│   │   ├── outbound-orchestrator/
│   │   ├── ghl-operator/
│   │   ├── instantly-operator/
│   │   ├── heyreach-operator/
│   │   ├── clay-operator/
│   │   ├── n8n-architect/
│   │   ├── scraper-layer/
│   │   ├── smorch-salesnav-operator/
│   │   └── smorch-linkedin-intel/
│   ├── eo-training/          # 11 EO training skills
│   │   ├── eo-brain-ingestion/
│   │   ├── eo-gtm-asset-factory/
│   │   ├── eo-skill-extractor/
│   │   ├── eo-tech-architect/
│   │   ├── eo-microsaas-dev/
│   │   ├── eo-db-architect/
│   │   ├── eo-api-connector/
│   │   ├── eo-qa-testing/
│   │   ├── eo-security-hardener/
│   │   ├── eo-deploy-infra/
│   │   └── eo-training-factory/
│   ├── eo-scoring/           # 5 scoring engines
│   │   ├── project-definition-scoring-engine/
│   │   ├── icp-clarity-scoring-engine/
│   │   ├── market-attractiveness-scoring-engine/
│   │   ├── strategy-selector-engine/
│   │   └── gtm-fitness-scoring-engine/
│   ├── content/              # 7 content skills
│   │   ├── eo-youtube-mamoun/
│   │   ├── smorch-perfect-webinar/
│   │   ├── smo-offer-assets/
│   │   ├── content-systems/
│   │   ├── movement-builder/
│   │   ├── engagement-engine/
│   │   └── validation-sprint/
│   ├── dev-meta/             # 6 dev workflow skills
│   │   ├── smo-skill-creator/
│   │   ├── smorch-tool-super-admin-creator/
│   │   ├── systematic-debugging/
│   │   ├── requesting-code-review/
│   │   ├── receiving-code-review/
│   │   └── using-superpowers/
│   └── tools/                # 4 utility skills
│       ├── frontend-design/
│       ├── webapp-testing/
│       ├── get-api-docs/
│       └── lead-research-assistant/
├── plugins/
│   ├── eo-microsaas-os/
│   └── smorch-gtm-engine/
├── profiles/
│   ├── mamoun.txt            # All skills (desktop)
│   ├── smo-brain.txt         # EO + scoring + dev (~22 skills)
│   ├── smo-dev.txt           # GTM + dev + tools (~11 skills)
│   ├── gtm-team.txt          # GTM + content (team)
│   ├── eo-student.txt        # EO training + scoring (team)
│   └── developer.txt         # Dev + tools (team)
├── mcp-configs/
│   ├── base.mcp.json         # Shared MCPs: n8n, linear, exa
│   ├── smo-brain.mcp.json    # Server overlay: playwright, contabo
│   ├── smo-dev.mcp.json      # Server overlay: playwright, contabo
│   └── desktop.mcp.json      # Desktop overlay: playwright, clay
├── scripts/
│   └── smorch                # CLI tool (bash, 556 lines)
├── .env.template             # Environment variable template
├── .gitignore
├── CLAUDE.md
└── README.md
```

### `smorch` CLI Reference

```bash
# === PUSH (Desktop Only) ===
smorch push
# Exports user-created skills from Cowork app to registry
# Automatically categorizes, skips 14 Anthropic built-in skills
# Commits and pushes to GitHub

# === PULL (Any Machine) ===
smorch pull                     # Pull + install using saved profile
smorch pull --profile mamoun    # Pull + install specific profile (saves as default)
smorch pull --profile smo-brain # Pull + install server profile

# === INSTALL (Granular) ===
smorch install eo-training                      # Install entire category
smorch install eo-training/eo-brain-ingestion   # Install single skill

# === REMOVE ===
smorch remove eo-scoring                        # Remove category from machine
smorch remove tools/lead-research-assistant     # Remove single skill

# === LIST ===
smorch list                    # All skills in registry, by category
smorch list --installed        # Skills on this machine
smorch list --available        # Skills in registry but NOT installed
smorch list --profiles         # Available profiles with skill counts

# === INFO ===
smorch diff                    # Changes on GitHub since last pull
smorch status                  # Profile, last sync, skill counts, git status

# === FIRST-TIME SETUP ===
smorch init --profile smo-brain  # Clone repo + install profile (new machine)
```

### Profile Format

Profiles are simple text files listing skill paths. Supports wildcards.

```
# profiles/smo-brain.txt
# Skills for Personal Server (eo-assessment-system, EO-Build)
dev-meta/systematic-debugging
dev-meta/requesting-code-review
dev-meta/receiving-code-review
eo-training/*
eo-scoring/*
smorch-gtm/n8n-architect
tools/webapp-testing
tools/get-api-docs
```

Pattern resolution:
- `*` — all skills in all categories
- `category/*` — all skills in a category
- `category/skill-name` — specific skill

### MCP Config Layering

Each machine gets `base.mcp.json` merged with a machine-specific overlay:

| Machine | Base | Overlay | Result |
|---------|------|---------|--------|
| Desktop | base.mcp.json | desktop.mcp.json | n8n, linear, exa, playwright, clay |
| smo-brain | base.mcp.json | smo-brain.mcp.json | n8n, linear, exa, playwright, contabo |
| smo-dev | base.mcp.json | smo-dev.mcp.json | n8n, linear, exa, playwright, contabo |

**CRITICAL:** smo-brain and smo-dev have DIFFERENT n8n instances. The N8N_BASE_URL and N8N_API_KEY in each server's `.env` point to different n8n installations. The MCP config uses env vars, so the same base config works for both — the `.env` file provides the server-specific values.

### Per-Project Skill Selection

Each project's `.claude/CLAUDE.md` declares which skills are relevant:

```markdown
# Required Skills
When working on this project, use these skills:
- eo-training/* (all EO training skills)
- eo-scoring/* (all scoring engines)
- dev-meta/systematic-debugging
- tools/webapp-testing
```

This doesn't filter the filesystem — all profile skills remain installed. It tells Claude Code which skills to prioritize for this specific project context.

### Environment Variables

Copy `.env.template` to `~/.claude/.env` on each machine. Fill in per-machine values:

```
# Shared
LINEAR_API_KEY=
EXA_API_KEY=
GITHUB_TOKEN=

# Per-server (different for smo-brain vs smo-dev)
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=

# Servers only
CONTABO_CLIENT_ID=
CONTABO_CLIENT_SECRET=
CONTABO_API_USER=
CONTABO_API_PASSWORD=

# Desktop only
CLAY_API_KEY=
```

**Never commit `.env` with real values.** The `.gitignore` blocks it.

### Adding a Skill From External Source

```bash
# Example: downloaded a skill from GitHub
cd ~/smorch-brain
cp -r ~/Downloads/my-new-skill skills/tools/my-new-skill
git add skills/tools/my-new-skill
git commit -m "skills: add my-new-skill to tools"
git push origin main

# Deploy to a server
ssh smo-brain "smorch pull"
```

### Backup & Rollback

`smorch pull` creates a timestamped backup before installing:

```bash
~/.claude/skills.bak.20260316143022/   # auto-created

# Rollback:
rm -rf ~/.claude/skills/
cp -a ~/.claude/skills.bak.20260316143022/ ~/.claude/skills/
```

---

## 6. Execution Plan (Micro Steps)

### Phase 1: Bootstrap (DONE — executed 2026-03-16)

| Step | What | Status |
|------|------|--------|
| 1.1 | Reorganize 48 skills into 6 categories | Done |
| 1.2 | Remove 14 Anthropic built-in skills from repo | Done |
| 1.3 | Build `scripts/smorch` CLI (556 lines) | Done |
| 1.4 | Create 6 profiles (mamoun, smo-brain, smo-dev, gtm-team, eo-student, developer) | Done |
| 1.5 | Create 4 MCP configs (base, smo-brain, smo-dev, desktop) | Done |
| 1.6 | Create .env.template | Done |
| 1.7 | Push to GitHub | Executing |

### Phase 2: Desktop + Server Setup

| Step | What | Machine | Time |
|------|------|---------|------|
| 2.1 | Symlink smorch to /usr/local/bin | Desktop | 1 min |
| 2.2 | `smorch pull --profile mamoun` | Desktop | 1 min |
| 2.3 | Clone repo + `smorch init --profile smo-brain` | smo-brain (SSH) | 5 min |
| 2.4 | Clone repo + `smorch init --profile smo-dev` | smo-dev (SSH) | 5 min |
| 2.5 | Create `.env` on each server | Each server | 5 min |

### Phase 3: Per-Project CLAUDE.md

| Step | What | Project | Skills Referenced |
|------|------|---------|-------------------|
| 3.1 | Add Required Skills section | eo-assessment-system | eo-training/*, eo-scoring/*, dev-meta/* |
| 3.2 | Add Required Skills section | EO-Build | eo-training/*, eo-scoring/*, dev-meta/* |
| 3.3 | Add Required Skills section | SaaSFast | smorch-gtm/*, tools/*, dev-meta/* |
| 3.4 | Add Required Skills section | ScrapMfast | smorch-gtm/*, tools/*, dev-meta/* |

### Phase 4: Verification

| Test | Command | Expected |
|------|---------|----------|
| Desktop skills | `smorch status` | 48 skills, mamoun profile |
| smo-brain skills | `smorch status` | ~22 skills, smo-brain profile |
| smo-dev skills | `smorch status` | ~11 skills, smo-dev profile |
| End-to-end | Edit skill, push, pull on server | Skill arrives |
| Profile isolation | smo-dev shouldn't have eo-training/ | Confirmed |

### Phase 5: Team Distribution (Deferred)

**Trigger:** First team hire (GTM, EO student, or developer)

**Process:**
1. Team member installs Claude Code
2. Runs: `smorch init --profile gtm-team` (or appropriate role)
3. Gets exactly the skills their role needs
4. Updates: Mamoun says "run `smorch pull`" — they get latest

---

## 7. Infrastructure Reference

### Node Map

| Node | Tailscale IP | Public IP | Role | OpenClaw | n8n |
|------|-------------|-----------|------|----------|-----|
| smo-brain | 100.89.148.62 | 89.117.62.131 | Gateway + orchestrator | v2026.3.14 (gateway) | Instance 1 |
| smo-dev | 100.117.35.19 | — | Agent node | v2026.3.13 (node) | Instance 2 |
| smo-desktop | 100.100.239.103 | — | Agent node | v2026.3.13 (node) | N/A |

### GitHub

| Item | Value |
|------|-------|
| Org | SMOrchestra-ai |
| Account | smorchestraai-code (sole admin) |
| Skills repo | smorch-brain (private) |
| Auth | SSH key on all 3 nodes |

---

## 8. Appendix: What Was Removed From Original Plan

| Original Component | Why Removed |
|-------------------|-------------|
| n8n sync workflow (every 5 min) | Over-engineered. Skills change weekly, not every 5 min |
| Export cron job (every 30 min) | Noisy. Creates empty commits. Wrong model |
| Daily midnight/2AM scheduling | Still has lag. On-demand is better for this use case |
| 4 separate scripts (export, install, sync, build-plugins) | Replaced by single `smorch` CLI |
| fswatch file watcher | Unnecessary complexity |
| launchd plist for sync | Unnecessary complexity |

**What was kept:**
- Git repo as skill registry
- Machine profiles
- Skill categorization (6 categories)
- MCP config layering (base + overlay)
- Team plugin packaging (deferred)
- Account A/B separation on servers

---

*Document generated 2026-03-16. Source: github.com/SMOrchestra-ai/smorch-brain*
