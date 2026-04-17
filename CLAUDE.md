# CLAUDE.md - smorch-brain

## What This Project Is
Central knowledge layer for SMOrchestra.ai. Contains all skills, SOPs, agent definitions, plugins, server profiles, prompts, and operational specs. This is NOT an application -- it is the single source of truth for how SMOrchestra operates, builds, and deploys.

## Git Info
- **Repo:** SMOrchestra-ai/smorch-brain
- **Branch:** dev
- **Server:** smo-brain (89.117.62.131 / Tailscale 100.89.148.62)
- **Server Path:** /root/smorch-brain/
- **PM2 Process:** N/A (no running application)
- **Deploy Command:** `cd /root/smorch-brain && git pull origin dev` (sync only, no build step)

## Tech Stack
- Content: Markdown files (skills, SOPs, docs, specs)
- Scripts: Bash (smorch CLI tools, deployment, sync)
- Plugins: Claude Code plugin format (JSON + MD skill files)
- Agents: Claude Code agent definitions + OpenClaw agent configs
- No application runtime -- this is a knowledge repo

## Project Structure
```
skills/                 # 62+ Claude Code skills (the skill library)
  content/              # Content creation skills
  dev-meta/             # Development meta-skills
  eo-scoring/           # EO assessment scoring skills
  eo-training/          # EO training factory skills
  personal/             # Personal/founder skills
  smorch-gtm/           # GTM operation skills (signal detection, campaigns, etc.)
  tools/                # Tool operator skills (GHL, Clay, HeyReach, etc.)
plugins/                # Claude Code plugins (bundled skill sets)
  smorch-dev/           # Development plugin (debug, build, review, test, validate)
  smorch-gtm-engine/    # GTM engine plugin (campaigns, signals, assets, LinkedIn)
  smorch-gtm-tools/     # GTM tool operators (GHL, Clay, Instantly, HeyReach, SalesNav)
  eo-microsaas-os/      # EO MicroSaaS OS plugin (scorecards + dev pipeline)
  eo-scoring-suite/     # EO scoring plugin (5 scorecards + composite)
  eo-training-factory/  # EO training content factory
  engineering/          # Engineering plugin
  product-management/   # Product management plugin
sops/                   # Standard Operating Procedures (13+ SOPs)
  SOP-01 to SOP-13      # QA, scoring, GitHub, infra, roles, onboarding, etc.
  onboarding/           # Onboarding SOPs for new team/agents
  skills/               # Skill-specific SOPs
docs/                   # Documentation and guides
  agents-templates/     # Agent instruction templates
  audits/               # Audit reports
  ci-templates/         # CI/CD templates
  rules-templates/      # Rules file templates
  templates/            # General templates
  sops/                 # Additional SOP docs
  skill-management-sop.md   # How to create, audit, push skills
  skill-creation-sop.md     # Skill creation workflow
  team-operations-guide.md  # Team ops guide
agents/                 # Agent definitions
  claude/               # Claude Code agent configs
  openclaw/             # OpenClaw agent configs
profiles/               # Server and role profiles
  developer.txt, mamoun.txt, smo-brain.txt, smo-dev.txt, etc.
prompts/                # Prompt templates
  codegen/              # Code generation prompts
  review/               # Code review prompts
scripts/                # CLI tools and deployment scripts
  smorch                # Main smorch CLI (audit, push, sync)
  smorch-context        # Context gathering script
  smorch-sync-all       # Full sync across all machines
  smorch-install-plugins # Plugin installation script
  smorch-server-setup   # Server provisioning script
  smorch-cleanup        # Cleanup utilities
  deploy-skills.sh      # Skill deployment to servers
specs/                  # Project and feature specs
  tasks/                # Task specifications
hooks/                  # Git hooks
mcp-configs/            # MCP server configuration files
```

## Build Instructions
No build step. This is a knowledge repo. Key operations:
```bash
# Sync skills to Claude Code global directory
cp -r skills/* ~/.claude/skills/

# Install plugins locally
claude plugin add ./plugins/smorch-gtm-engine
claude plugin add ./plugins/eo-microsaas-os

# Audit skills before pushing
./scripts/smorch audit

# Push skills to server
./scripts/smorch push

# Sync all machines
./scripts/smorch-sync-all

# Deploy skills to a specific server
./scripts/deploy-skills.sh
```

## Environment Variables Required
None. This repo contains no application code and no secrets. Server connections use SSH keys configured in profiles/.

## Required Skills/Plugins
N/A -- this repo IS the skill and plugin source. All other projects consume from here.

## Quality Gates
- `smorch audit` must pass before any push (checks SKILL.md line count < 500, structure validity)
- Skills follow naming convention: smorch-[category]-[specific]
- SKILL.md files must be under 500 lines
- SOPs must follow numbered format (SOP-NN-Title.md)
- Never edit skills directly on remote machines -- all changes go through this repo
- Plugin changes must be tested locally before push

## Skill Management Rules
1. smorch-brain is the SINGLE SOURCE OF TRUTH for all skills
2. Never edit skills directly on smo-brain, smo-dev, or any other machine
3. Workflow: edit locally -> audit -> commit -> push to GitHub -> pull on servers
4. Run `smorch audit` before every commit
5. See `docs/skill-management-sop.md` for full workflow

## Server Sync Targets
- **smo-brain** (89.117.62.131): Primary brain server, skills + context
- **smo-dev** (62.171.165.57): Dev/staging server, receives skill deploys
- **contabo-main** (62.171.164.178): Production server, receives production skills only

## Key SOPs
- SOP-01: QA Protocol
- SOP-03: GitHub Standards
- SOP-04: Infrastructure Node Roles
- SOP-07: Agentic Coding Orchestration
- SOP-08: Project Kickoff Pre-Dev Check
- SOP-09: Skill Injection Registry
- SOP-10: Session Start/Finish + Incident Response
- SOP-12: Project Onboarding Auto
- SOP-13: Lana Handover Protocol
