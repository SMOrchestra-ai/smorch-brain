# AI-Native Organization — Execution Plan v1

**Date:** 2026-03-29
**Owner:** Mamoun Alamouri (Founder/Board)
**Score:** 9.1/10 (Architecture 9, Cost 9, Results 9, Agents 9, Complexity 9, Future 9.5, Battle-tested 9, Best-in-breed 9)
**Timeline:** 7 days (5 phases)

---

## Architecture Summary

```
MAMOUN (Founder/Board) ── Telegram + Paperclip Dashboard
        │
        ▼
HERMES (CEO Agent) ── smo-brain ── Persistent memory, plans, Telegram
        │
        ▼
n8n (Integration Bus) ── Battle-tested, visual debugging, fallback routing
        │
   ┌────┼────────────────┐
   ▼    ▼                ▼
PAPERCLIP  OPENCLAW      TELEGRAM
(Dashboard) (COO/Dispatch) (Notifications)
               │
        ┌──────┼──────┐
        ▼      ▼      ▼
   CC+VP Eng  CC+QA  CC+GTM   (Desktop: claude_local)
   CC+DevOps  CC+Content      (smo-dev: via OpenClaw)
   Codex+Data                 (smo-dev: via OpenClaw)
```

### Key Architectural Decisions

| Decision | Choice | Why |
|---|---|---|
| CEO Agent | Hermes v0.4.0 (planning-only) | Persistent memory + Honcho user modeling + Telegram + MCP + always-on |
| COO/Dispatch | OpenClaw | Battle-tested terminal dispatch, our 49 skills work as-is |
| Dashboard | Paperclip | Org chart + tickets + budget + mobile dashboard |
| Integration | n8n as single bus | One debugging surface, battle-tested, existing infra |
| Execution | Claude Code + Codex | Best coding model + cost-efficient data tasks |
| Methodology | Superpowers (build) + gstack (QA) + smorch (GTM) | Best-in-breed per function |
| Fallback | Every new component has battle-tested fallback | Graceful degradation = system never fully fails |

### Graceful Degradation Matrix

| Component | Fallback | Trigger | Impact |
|---|---|---|---|
| Hermes (CEO) | OpenClaw becomes COO+CEO | pm2 crash 3x in 10 min | Plans come from Mamoun via Telegram instead |
| Paperclip | Linear | Health check fail | Task tracking moves to Linear, dispatch unchanged |
| OpenClaw gateway | Direct SSH dispatch | WebSocket fail | Same agents, different trigger path |
| Agent SDK | Raw `claude -p` | SDK exception | Slightly less structured output |
| Codex | Claude Code (Haiku) | Codex timeout | Higher cost but same capability |

### Tiered Model Strategy

| Role | Model | Monthly Cap | Why |
|---|---|---|---|
| Hermes CEO (routine) | GPT-4o | $25 cap | Routine planning doesn't need Claude |
| Hermes CEO (strategy) | Claude Sonnet | included above | Complex decisions only |
| VP Engineering | Claude Sonnet | $150 cap | Complex coding |
| QA Lead | Claude Haiku | $50 cap | Mechanical testing |
| Content Lead | Claude Sonnet | $100 cap | Creative writing needs quality |
| GTM Specialist | Claude Sonnet | $100 cap | Campaign strategy |
| DevOps | Claude Haiku | $30 cap | Infrastructure commands |
| Data Engineer | Codex (GPT-4o-mini) | $30 cap | Scraping/enrichment |
| **TOTAL** | | **$485/month max** | Full AI dev org |

---

## Pre-Execution: Skill Sync

Before any phase begins, sync all skills across all nodes.

### Step 0.1: Integrate gstack + superpowers into smorch plugin system (Desktop)

```bash
# Add gstack skills to smorch registry
cd ~/Desktop/cowork-workspace/smorch-brain

# Create symlinks for gstack skills in the plugins directory
ln -s ~/Desktop/cowork-workspace/gstack ~/.claude/skills/gstack

# Create symlinks for superpowers skills
ln -s ~/Desktop/cowork-workspace/superpowers/skills ~/.claude/skills/superpowers

# Verify all skills accessible
ls ~/.claude/skills/gstack/
ls ~/.claude/skills/superpowers/
```

### Step 0.2: Update server profiles to include gstack + superpowers

Add to `smo-brain.txt` and `smo-dev.txt` profiles:
```
gstack/*
superpowers/*
```

### Step 0.3: Install Agent SDK (Desktop)

```bash
# Python Agent SDK
pip3 install claude-agent-sdk

# TypeScript Agent SDK
npm install -g @anthropic-ai/claude-agent-sdk

# Verify
python3 -c "import claude_agent_sdk; print('Python SDK OK')"
npx claude-agent-sdk --version
```

### Step 0.4: Sync ALL skills to all nodes

```bash
# From Desktop, run the existing sync mechanism
cd ~/Desktop/cowork-workspace/smorch-brain
./scripts/smorch-sync-all
```

This pushes: 49 smorch skills + gstack (30 skills) + superpowers (14 skills) = 93 skills to both smo-brain and smo-dev.

### Step 0.5: Install Agent SDK on servers

**PROMPT FOR smo-brain (SSH from Desktop):**
```
ssh smo-brain

# Install Python Agent SDK
pip3 install claude-agent-sdk

# Install TypeScript Agent SDK
npm install -g @anthropic-ai/claude-agent-sdk

# Verify Claude Code CLI
claude --version

# Verify skills synced
ls ~/.claude/skills/gstack/
ls ~/.claude/skills/superpowers/
ls ~/.claude/skills/smorch*/

# Verify Agent SDK
python3 -c "import claude_agent_sdk; print('Python SDK: OK')"
```

**PROMPT FOR smo-dev (SSH from Desktop):**
```
ssh smo-dev

# Same steps as smo-brain
pip3 install claude-agent-sdk
npm install -g @anthropic-ai/claude-agent-sdk
claude --version
ls ~/.claude/skills/gstack/
ls ~/.claude/skills/superpowers/
python3 -c "import claude_agent_sdk; print('Python SDK: OK')"
```

---

## Phase 1: Battle-Tested Foundation (Day 1)

**Goal:** Prove the execution layer works using ONLY proven components.
**New components:** ZERO. Everything here already works.

### Step 1.1: Verify OpenClaw is running (smo-brain)

**PROMPT FOR smo-brain:**
```
ssh smo-brain

# Check OpenClaw status
pm2 status

# If not running:
cd ~/openclaw  # or wherever OpenClaw lives
pm2 start openclaw --name openclaw

# Verify Telegram connection
# Send test message via Telegram to OpenClaw bot

# Check OpenClaw can dispatch to smo-dev
ssh smo-dev "claude --version"
```

### Step 1.2: Test Claude Code dispatch from OpenClaw (smo-brain → smo-dev)

**PROMPT FOR smo-brain:**
```
# From OpenClaw, dispatch a test task to smo-dev
# Via Telegram: send OpenClaw a message like:
# "Run a test: ask Claude Code on smo-dev to create a file /tmp/ai-org-test.txt with content 'AI Native Org Phase 1 test - [timestamp]'"

# Verify on smo-dev:
ssh smo-dev "cat /tmp/ai-org-test.txt"
```

### Step 1.3: Test Claude Code with Superpowers on Desktop

Run locally on Desktop:
```bash
# Start a Claude Code session with superpowers loaded
cd ~/Desktop/cowork-workspace/Github_SMO_AI_Native_Archi
claude

# Inside Claude Code, test:
# "Using the superpowers methodology, write a plan for a simple hello-world Node.js app"
# Expected: It should invoke writing-plans skill, produce a granular plan with TDD steps
```

### Step 1.4: Test gstack /qa on Desktop

```bash
# In Claude Code session:
# "/qa https://entrepreneursoasis.com"
# Expected: gstack runs 3-tier QA, produces health score
```

### Step 1.5: Test Codex on smo-dev

**PROMPT FOR smo-dev:**
```
ssh smo-dev

# Verify Codex is installed
codex --version

# Run a test task
codex "Create a file /tmp/codex-test.txt with the text 'Codex Data Engineer test'"
cat /tmp/codex-test.txt
```

### Step 1.6: Verify n8n instances running

```bash
# n8n-dev
curl -s http://100.117.35.19:5678/healthz && echo "n8n-dev: OK" || echo "n8n-dev: DOWN"

# n8n-mamoun
curl -s http://100.89.148.62:5678/healthz && echo "n8n-mamoun: OK" || echo "n8n-mamoun: DOWN"
```

### Phase 1 Validation Checklist

- [ ] OpenClaw running on smo-brain (pm2 status)
- [ ] OpenClaw dispatches to smo-dev successfully
- [ ] Claude Code + Superpowers works on Desktop
- [ ] gstack /qa runs on Desktop
- [ ] Codex runs on smo-dev
- [ ] n8n-dev running
- [ ] n8n-mamoun running
- [ ] All 93 skills synced to all nodes
- [ ] Agent SDK installed on all 3 nodes

**DO NOT proceed to Phase 2 until ALL checkboxes pass.**

---

## Phase 2: Paperclip Dashboard — Read-Only (Day 2-3)

**Goal:** Paperclip shows the org. Does NOT dispatch yet.
**New components:** Paperclip (one component, read-only = low risk)

### Step 2.1: Install Paperclip on Desktop

```bash
cd ~/Desktop/cowork-workspace/paperclip
pnpm install
```

### Step 2.2: Start Paperclip in local_trusted mode

```bash
# Set environment
export ANTHROPIC_API_KEY="your-key-here"
export PAPERCLIP_DEPLOYMENT_MODE=local_trusted
export PAPERCLIP_PORT=3100

# Start
pnpm dev

# Access dashboard at http://localhost:3100
```

### Step 2.3: Create the AI-Native Org in Paperclip

Via Paperclip dashboard (or onboarding CLI):

```bash
npx paperclipai onboard --yes
```

Configure org chart:
```
Company: SMOrchestra AI-Native Org
Goal: Build and operate autonomous AI development teams across multiple projects

CEO: Hermes (placeholder — will wire in Phase 3)
  ├── COO: OpenClaw (openclaw_gateway adapter — read-only for now)
  │   ├── VP Engineering (claude_local, Sonnet)
  │   ├── QA Lead (claude_local, Haiku)
  │   ├── GTM Specialist (claude_local, Sonnet)
  │   ├── Content Lead (claude_local, Sonnet)
  │   ├── DevOps (claude_local, Haiku)
  │   └── Data Engineer (codex_local)
```

### Step 2.4: Build n8n "Status Sync" workflow (one-directional)

On n8n-mamoun, create workflow: **"AI-Org-Status-Sync"**

```
Trigger: Webhook (receives status updates from OpenClaw)
    │
    ├─→ HTTP Request: POST to Paperclip REST API
    │   URL: http://100.100.239.103:3100/api/companies/{companyId}/issues
    │   Body: { title, status, assignee, description }
    │
    └─→ Error handler: Log failure, don't retry (read-only, non-critical)
```

### Step 2.5: Test Paperclip displays org correctly

- [ ] Dashboard loads at localhost:3100
- [ ] Org chart shows all 7 agents in correct hierarchy
- [ ] Creating a manual ticket works
- [ ] Assigning a ticket to an agent works (in UI, not dispatching)

### Phase 2 Validation Checklist

- [ ] Paperclip running on Desktop
- [ ] Org chart displays correctly
- [ ] Manual ticket creation works
- [ ] n8n status sync workflow fires on OpenClaw activity
- [ ] Paperclip receives and displays status updates
- [ ] Paperclip crash → restart → data intact (test: kill process, restart, verify tickets exist)

---

## Phase 3: Hermes CEO — Shadow Mode (Day 4-5)

**Goal:** Hermes plans but does NOT execute. Plans go to review channel.
**New components:** Hermes (planning-only, shadow mode)

### Step 3.1: Install Hermes on smo-brain

**PROMPT FOR smo-brain:**
```
ssh smo-brain

# Install Hermes
pip3 install hermes-agent

# Or from source for latest:
cd ~/workspace
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
pip3 install -e .

# Run setup (auto-detects OpenClaw if ~/.openclaw exists)
hermes setup

# Configure Telegram bot
# You'll need: BotFather token for a NEW bot (separate from OpenClaw's bot)
# Set allowed users to Mamoun's Telegram ID only

# Configure planning-only mode — disable execution tools
hermes tools disable execute_code
hermes tools disable file_write
hermes tools disable shell_command

# Verify planning tools remain:
hermes tools list
# Should show: plan, analyze, search, read_file (read-only), memory tools

# Configure providers (tiered)
# Edit ~/.hermes/config.yaml:
cat > ~/.hermes/config.yaml << 'HERMES_CONFIG'
providers:
  default:
    type: openai
    model: gpt-4o
    api_key: ${OPENAI_API_KEY}
  strategy:
    type: anthropic
    model: claude-sonnet-4-20250514
    api_key: ${ANTHROPIC_API_KEY}

memory:
  backend: sqlite
  path: ~/.hermes/state.db

telegram:
  bot_token: ${HERMES_TELEGRAM_BOT_TOKEN}
  allowed_users:
    - MAMOUN_TELEGRAM_ID

mcp_servers: {}
HERMES_CONFIG

# Start Hermes with pm2
pm2 start "hermes serve --gateway telegram" --name hermes

# Verify running
pm2 status
```

### Step 3.2: Build n8n "Shadow Plan" workflow

On n8n-mamoun, create workflow: **"AI-Org-Shadow-Plan"**

```
Trigger: Webhook (receives plans from Hermes)
    │
    ├─→ Post plan to Telegram "Shadow Plans" channel
    │   (Mamoun reviews: "Would I have assigned the same tasks?")
    │
    ├─→ Log plan to Supabase (shadow_plans table) for tracking
    │
    └─→ DO NOT dispatch to OpenClaw. Shadow only.
```

### Step 3.3: Connect Hermes to n8n webhook

**PROMPT FOR smo-brain:**
```
# Add n8n as MCP server in Hermes config
# Edit ~/.hermes/config.yaml, add:

mcp_servers:
  n8n_shadow:
    type: http
    url: "http://100.89.148.62:5678/webhook/hermes-shadow-plan"

# Restart Hermes
pm2 restart hermes
```

### Step 3.4: Test Hermes planning

Send Telegram message to Hermes bot:
```
"Plan the implementation of a landing page for SalesMfast Signal Engine.
Consider: Next.js 15, Supabase auth, Arabic RTL support, Stripe payments.
Break into tasks for VP Engineering, QA Lead, and DevOps."
```

Expected: Hermes produces a plan, posts to shadow channel. Does NOT execute anything.

### Step 3.5: Chaos Testing

**PROMPT FOR smo-brain:**
```
# Test 1: Kill Hermes, verify memory survives
pm2 stop hermes
sqlite3 ~/.hermes/state.db "SELECT count(*) FROM memory;"
# Should show > 0 entries

pm2 start hermes
# Send Telegram: "What did we discuss earlier?"
# Hermes should remember the planning conversation

# Test 2: Kill Hermes, verify OpenClaw continues
pm2 stop hermes
# Dispatch a task via OpenClaw Telegram (existing flow)
# Task should execute normally — OpenClaw is independent

# Test 3: Restart Hermes, verify it picks up
pm2 start hermes
# Send Telegram: "What's the status of the landing page plan?"
# Should remember from persistent memory
```

### Step 3.6: Measure shadow mode metrics (run for 48 hours)

| Metric | Target | How to Measure |
|---|---|---|
| Hermes uptime | > 95% | `pm2 logs hermes --lines 1000 \| grep restart` |
| Plan quality | 80%+ agreement | Mamoun reviews shadow plans |
| Memory persistence | Remembers yesterday | Ask "What did we plan yesterday?" |
| Crash recovery | Memory intact | Kill + restart + verify |
| Planning latency | < 5 min | Timestamp delta on plans |

### Phase 3 Validation Checklist

- [ ] Hermes installed and running on smo-brain (pm2)
- [ ] Telegram bot responds to Mamoun
- [ ] Execution tools disabled (cannot write files, run code)
- [ ] Plans posted to shadow channel
- [ ] Memory survives pm2 restart
- [ ] 48-hour uptime > 95%
- [ ] Plan quality acceptable (Mamoun review)
- [ ] OpenClaw unaffected by Hermes presence

**DO NOT proceed to Phase 4 until shadow mode passes 48-hour validation.**

---

## Phase 4: Full Pipeline Wiring (Day 6)

**Goal:** Hermes plans → n8n → Paperclip tickets → OpenClaw executes.
**Risk level:** Medium — but every component validated individually in Phases 1-3.

### Step 4.1: Build n8n "CEO-to-Execution" master workflow

On n8n-mamoun, create workflow: **"AI-Org-CEO-to-Execution"**

```
TRIGGER: Webhook from Hermes (plan approved by Mamoun)
    │
    ├─→ PARSE: Extract tasks, roles, priorities from plan
    │
    ├─→ FOR EACH TASK:
    │   │
    │   ├─→ TRY: Create Paperclip ticket
    │   │   ├─ SUCCESS → continue
    │   │   └─ FAIL → Create Linear issue (fallback)
    │   │
    │   ├─→ ROUTE by role:
    │   │   ├─ VP Eng / QA / Content → Paperclip claude_local (Desktop)
    │   │   └─ GTM / DevOps / Data → OpenClaw webhook (smo-dev dispatch)
    │   │
    │   ├─→ WAIT: Completion callback (timeout: 30 min)
    │   │
    │   ├─→ UPDATE: Paperclip ticket status (or Linear fallback)
    │   │
    │   └─→ SCORE: Trigger scoring skill → evaluate output
    │       ├─ Score >= 8 → mark DONE
    │       └─ Score < 8 → loop back (max 2 retries)
    │
    └─→ REPORT: Telegram to Mamoun
        "Plan executed. 5/6 tasks passed. 1 in retry. Dashboard: localhost:3100"
```

### Step 4.2: Enable Paperclip dispatch for Desktop agents

```bash
# On Desktop, restart Paperclip with dispatch enabled
cd ~/Desktop/cowork-workspace/paperclip

export ANTHROPIC_API_KEY="your-key"
export PAPERCLIP_DEPLOYMENT_MODE=local_trusted
export PAPERCLIP_PORT=3100

pnpm dev
```

Test: Create a ticket in Paperclip UI → assign to VP Engineering → verify Claude Code spawns and executes.

### Step 4.3: Wire OpenClaw gateway in Paperclip

Configure openclaw_gateway adapter for server-side agents:

In Paperclip agent config, update GTM Specialist, DevOps, Data Engineer:
```json
{
  "name": "DevOps",
  "adapterType": "openclaw_gateway",
  "adapterConfig": {
    "gatewayUrl": "ws://100.89.148.62:PORT",
    "authToken": "openclaw-auth-token"
  }
}
```

**If gateway doesn't work (fallback):** Use n8n webhook to trigger OpenClaw directly:
```
n8n → HTTP POST to OpenClaw webhook → OpenClaw dispatches via SSH
```

### Step 4.4: End-to-end test

1. Send Hermes (Telegram): "Build a simple health check API endpoint for SalesMfast"
2. Hermes plans → posts to n8n webhook
3. Mamoun approves plan (Telegram inline button)
4. n8n creates Paperclip tickets
5. VP Engineering (Desktop, claude_local) builds the code with Superpowers TDD
6. QA Lead (Desktop, claude_local) runs gstack /qa
7. DevOps (smo-dev, via OpenClaw) deploys
8. Scoring skill rates output
9. Telegram report to Mamoun

### Phase 4 Validation Checklist

- [ ] n8n "CEO-to-Execution" workflow deployed
- [ ] Hermes plan → n8n → Paperclip ticket (end-to-end)
- [ ] Desktop agents dispatch via Paperclip claude_local
- [ ] Server agents dispatch via OpenClaw (gateway or n8n fallback)
- [ ] Scoring gate works (loops back on < 8)
- [ ] Telegram reports arrive
- [ ] Fallback to Linear tested (kill Paperclip during test)
- [ ] Fallback to SSH tested (kill gateway during test)

---

## Phase 5: Harden + Validate (Day 7)

**Goal:** Run a real project. Fix everything that breaks.

### Step 5.1: Assign a real project to the AI org

Choose a small, real deliverable. Suggested:
- "Build a landing page for EO MENA training program"
- Or: "Create cold email campaign for SalesMfast Signal Engine launch"

Send to Hermes via Telegram: full brief.

### Step 5.2: Monitor full execution

Watch in parallel:
- Paperclip dashboard (org activity, ticket flow)
- n8n execution logs (integration health)
- Telegram (Hermes CEO updates, Mamoun notifications)
- pm2 logs on smo-brain (Hermes + OpenClaw stability)

### Step 5.3: Chaos testing round 2

| Test | During real project execution |
|---|---|
| Kill Hermes | Verify queued tasks continue executing |
| Kill Paperclip | Verify n8n falls back to Linear |
| Kill OpenClaw | Verify Desktop agents continue working |
| Kill one Claude Code agent | Verify Paperclip shows failure, other agents continue |

### Step 5.4: Measure and score

| Metric | Target |
|---|---|
| CEO touch-points during project | < 5 |
| Agent task completion rate | > 80% |
| Quality gate pass rate (first attempt) | > 60% |
| Total project cost (API) | < $50 |
| Time from brief to delivered | < 8 hours |
| System crashes during project | < 3 (all auto-recovered) |

### Step 5.5: Fix issues and document

- Document every bug found
- Fix integration issues in n8n workflows
- Update role CLAUDE.md files based on agent behavior
- Update this plan with lessons learned

### Phase 5 Validation Checklist

- [ ] Real project completed by AI org
- [ ] Mamoun operated as Board only (no coding)
- [ ] All agents visible in Paperclip throughout
- [ ] Chaos tests passed (graceful degradation confirmed)
- [ ] Metrics meet targets
- [ ] Lessons learned documented

---

## Server Topology (Final State)

```
smo-brain (100.89.148.62)
├── Hermes (CEO) — pm2, planning-only, Telegram bot
├── OpenClaw (COO) — pm2, terminal dispatch, ACE Telegram
├── n8n-mamoun — integration bus, CEO-to-Execution workflow
├── Agent SDK (Python + TypeScript)
└── Skills: 93 (49 smorch + 30 gstack + 14 superpowers)

smo-dev (100.117.35.19)
├── Claude Code: GTM Specialist (dispatched by OpenClaw)
├── Claude Code: DevOps (dispatched by OpenClaw)
├── Codex: Data Engineer (dispatched by OpenClaw)
├── n8n-dev — development/testing workflows
├── Agent SDK (Python + TypeScript)
└── Skills: 93 (synced via smorch-sync-all)

Desktop (100.100.239.103)
├── Paperclip — org dashboard, local agent dispatch
├── Claude Code: VP Engineering (claude_local, Sonnet)
├── Claude Code: QA Lead (claude_local, Haiku)
├── Claude Code: Content Lead (claude_local, Sonnet)
├── Agent SDK (Python + TypeScript)
└── Skills: 93 (source of truth, syncs to servers)
```

---

## Skill Sync Procedure

Before each phase and whenever skills are updated:

```bash
# On Desktop (source of truth)
cd ~/Desktop/cowork-workspace/smorch-brain

# Verify local skills
ls ~/.claude/skills/gstack/        # 30 skills
ls ~/.claude/skills/superpowers/    # 14 skills
ls ~/.claude/skills/smorch*/        # 49 skills

# Push to all servers
./scripts/smorch-sync-all

# Verify on servers
ssh smo-brain "ls ~/.claude/skills/gstack/ && ls ~/.claude/skills/superpowers/"
ssh smo-dev "ls ~/.claude/skills/gstack/ && ls ~/.claude/skills/superpowers/"
```

---

## Risk Register

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Hermes crashes frequently | Medium | Low | pm2 restart. Memory survives. OpenClaw continues. |
| Paperclip OOM on large org | Low | Low | Read-only until Phase 4. Linear fallback. |
| OpenClaw gateway adapter fails | Medium | Medium | n8n fallback to direct SSH dispatch |
| Skills out of sync between nodes | Medium | Medium | smorch-sync-all before each phase |
| Agent SDK not compatible with Claude 2.1.86 | Low | High | Fall back to `claude -p` (raw CLI) |
| n8n workflow errors in routing | Medium | Medium | Visual debugging + retry logic |
| Hermes plans are low quality | Medium | Medium | Shadow mode catches this in Phase 3 |
| Budget overrun from agent costs | Low | Medium | Hard caps in Paperclip per agent |

---

## Decision Log

| # | Decision | Date | Rationale |
|---|---|---|---|
| 1 | Hermes as CEO, not Claude Code | 2026-03-29 | Persistent memory, always-on, user modeling. Claude Code is a tool, not an entity. |
| 2 | OpenClaw stays as COO | 2026-03-29 | Battle-tested dispatch, 49 skills work, Codex support |
| 3 | n8n as integration bus | 2026-03-29 | One debugging surface, battle-tested, replaces 5 custom seams |
| 4 | Hermes on smo-brain (same as OpenClaw) | 2026-03-29 | Always-on server, lowest latency to COO, pm2 manages both |
| 5 | Supervibes NOT needed | 2026-03-29 | Paperclip replaces 100% of functionality + adds org management |
| 6 | Phased rollout with shadow mode | 2026-03-29 | Battle-tests each component before trusting it |
| 7 | Graceful degradation architecture | 2026-03-29 | Every new component has battle-tested fallback |
| 8 | Tiered model strategy | 2026-03-29 | GPT-4o for routine planning, Haiku for mechanical tasks, Sonnet for quality |
| 9 | Agent SDK on all nodes | 2026-03-29 | Programmatic control replaces raw SSH + claude -p |

---

*This plan scores 9.1/10. The 0.9 gap closes with time as Hermes and Paperclip mature.*

**Document Version:** v1
**Last Updated:** 2026-03-29
