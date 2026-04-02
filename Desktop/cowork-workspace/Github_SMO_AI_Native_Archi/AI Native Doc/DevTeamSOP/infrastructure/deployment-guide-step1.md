# Step 1 Deployment Guide — Methodology Layers + Skill Router

**Date:** 2026-03-28
**Scope:** Deploy gstack, Superpowers, and configure skill routing on all nodes
**Prerequisites:** Repos forked to smorchestraai-code and cloned locally
**Estimated time:** 2-3 hours

---

## 1. Deploy gstack (All Nodes)

### What gstack gives the AI org:
- `/office-hours` — Idea validation with 6 forcing questions (COO role)
- `/qa` — 3-tier browser-based QA with health scores (QA Lead role)
- `/benchmark` — Core Web Vitals + performance regression (QA Lead + DevOps)
- `/review` — Pre-landing PR review with SQL safety checks (QA Lead)
- `/careful` + `/freeze` + `/guard` — Safety guardrails (ALL roles)
- `/plan-ceo-review` — CEO-mode scope expansion review (COO role)
- `/canary` — Deployment canary testing (DevOps role)
- `/land-and-deploy` — PR landing + deployment (DevOps role)

### Installation (per node):

```bash
# On each node: smo-brain, smo-dev, Desktop

# 1. Clone our fork (already done on Desktop)
cd ~/Desktop/cowork-workspace
git clone https://github.com/smorchestraai-code/gstack.git
cd gstack

# 2. Install dependencies
npm install

# 3. Build
npm run build

# 4. Run setup to install skills into Claude Code
./bin/gstack setup

# This creates symlinks in ~/.claude/skills/gstack/
# Each skill folder contains SKILL.md with frontmatter + instructions

# 5. Verify installation
ls -la ~/.claude/skills/gstack/
# Should show: benchmark, careful, freeze, guard, office-hours, qa, qa-only,
# review, plan-ceo-review, plan-eng-review, canary, ship, etc.
```

### For smo-brain and smo-dev (remote nodes):
```bash
# SSH into each node via Tailscale
ssh smo-brain  # 100.89.148.62
ssh smo-dev    # 100.117.35.19

# Same installation steps as above
# Ensure Node.js 18+ is available
node --version

# Clone and install
cd ~/workspace
git clone https://github.com/smorchestraai-code/gstack.git
cd gstack && npm install && npm run build && ./bin/gstack setup
```

### Browser daemon setup (for QA + benchmark):
```bash
# gstack QA uses a headless browser daemon
# Ensure Chrome/Chromium is installed on each node

# On Ubuntu (smo-brain, smo-dev):
sudo apt-get install -y chromium-browser

# Start browse daemon for QA testing
# This runs in background, gstack /qa connects to it
```

### Verify gstack works:
```bash
# In Claude Code on any node:
# Type: /office-hours
# Should trigger the YC Office Hours skill with 6 forcing questions

# Type: /careful
# Should activate destructive command guardrails
```

---

## 2. Deploy Superpowers (All Nodes)

### What Superpowers gives the AI org:
- **TDD RED-GREEN-REFACTOR** — Mandatory for all VP Engineering work
- **writing-plans** — Granular implementation plans (2-5 min tasks)
- **subagent-driven-development** — Fresh subagent per task + 2-stage review
- **brainstorming** — HARD-GATE design approval before implementation
- **dispatching-parallel-agents** — Parallel task execution with safety
- **systematic-debugging** — Hypothesis-driven debugging methodology
- **verification-before-completion** — Pre-completion quality check

### Installation (per node):

**Method 1: Claude Code Plugin Marketplace (if available)**
```
# In Claude Code:
/plugin marketplace add obra/superpowers
```

**Method 2: Manual installation from our fork**
```bash
# On each node
cd ~/Desktop/cowork-workspace
git clone https://github.com/smorchestraai-code/superpowers.git
cd superpowers

# Create symlink to Claude Code skills directory
mkdir -p ~/.claude/skills
ln -s $(pwd)/skills ~/.claude/skills/superpowers

# Verify
ls ~/.claude/skills/superpowers/
# Should show: brainstorming, dispatching-parallel-agents, executing-plans,
# finishing-a-development-branch, receiving-code-review, requesting-code-review,
# subagent-driven-development, systematic-debugging, test-driven-development,
# using-git-worktrees, using-superpowers, verification-before-completion,
# writing-plans, writing-skills
```

### For remote nodes:
```bash
ssh smo-brain
cd ~/workspace
git clone https://github.com/smorchestraai-code/superpowers.git
mkdir -p ~/.claude/skills
ln -s $(pwd)/superpowers/skills ~/.claude/skills/superpowers

ssh smo-dev
# Same steps
```

### Verify Superpowers works:
```bash
# In Claude Code, ask it to build something
# It should enforce: brainstorming → design approval → writing-plans → TDD
# If it skips TDD, the installation needs debugging
```

---

## 3. Configure Skill Router (Per-Role Loading)

The skill router ensures each AI role only loads its assigned skills (from skill-router-matrix.md).

### Approach: Role-specific CLAUDE.md files

Each role gets a CLAUDE.md that explicitly declares which skills to load:

```bash
# Create roles directory in AI-Native-Org repo
mkdir -p ~/Desktop/cowork-workspace/Github_SMO_AI_Native_Archi/AI-Native-Org/roles
```

### Role CLAUDE.md Structure:

Each role CLAUDE.md follows this pattern:
```markdown
# Role: [ROLE NAME]
# Methodology: [PRIMARY METHODOLOGY]
# Node: [ASSIGNED NODE]

## Skills Available
[List of skills this role can use]

## Skills NOT Available
[Explicitly list skills this role must NOT use to prevent conflicts]

## Quality Gates
[Scoring thresholds this role must meet before marking work complete]

## Workflow
[Step-by-step process this role follows]
```

### Creating role files:
See `AI-Native-Org/roles/` directory for each role CLAUDE.md (created separately).

---

## 4. smorch Skills Verification

All 79 smorch skills should already be available via smorch-brain. Verify:

```bash
# Check smorch-brain is installed
ls ~/.claude/skills/smorch* 2>/dev/null || ls ~/Desktop/cowork-workspace/smorch-brain/ 2>/dev/null

# Check skill count
find ~/.claude/skills/ -name "*.md" -type f | wc -l
# Expected: 79 smorch + 30 gstack + 14 superpowers = ~123 skill files
```

### If smorch skills are missing on remote nodes:
```bash
ssh smo-brain
cd ~/workspace
git clone https://github.com/SMOrchestra-ai/smorch-brain.git
# Follow smorch-brain installation instructions to link skills
```

---

## 5. Conflict Prevention Setup

### Create a skill-conflict guard:

The key conflicts to prevent (from skill-router-matrix.md):
- gstack `/office-hours` vs superpowers `brainstorming`
- gstack `/review` vs superpowers `requesting-code-review`
- gstack `/qa` vs superpowers `verification-before-completion`

**Resolution is by pipeline stage:**
- Stages 1-4: gstack skills active, superpowers inactive
- Stages 5-6: superpowers active, gstack QA skills inactive (gstack safety skills stay)
- Stages 6-8: both active but scoped (superpowers for code, gstack for browser QA)
- Stages 9-10: smorch-gtm active, both methodologies inactive

This is enforced via the role CLAUDE.md files — each role only loads non-conflicting skills.

---

## 6. Post-Deployment Validation Checklist

- [ ] gstack installed on Desktop (`ls ~/.claude/skills/gstack/`)
- [ ] gstack installed on smo-brain
- [ ] gstack installed on smo-dev
- [ ] Superpowers installed on Desktop (`ls ~/.claude/skills/superpowers/`)
- [ ] Superpowers installed on smo-brain
- [ ] Superpowers installed on smo-dev
- [ ] smorch skills accessible on all nodes
- [ ] `/office-hours` tested with sample idea
- [ ] `/qa` tested on a live URL
- [ ] `/benchmark` tested for CWV
- [ ] TDD enforcement tested (ask Claude to build something — should require tests first)
- [ ] `/careful` activated and tested (try `rm -rf /` — should be blocked)
- [ ] Skill count verified: ~123 total across all sources

---

## Next Steps After Step 1

- **Step 2:** Deploy Paperclip on smo-brain (dev-time orchestrator)
- **Step 3:** Upgrade OpenClaw → Agent SDK bridge (runtime orchestrator)
- **Step 4:** Validate autonomous execution on a real project
- **Step 5:** Hermes experiment (post-validation)
