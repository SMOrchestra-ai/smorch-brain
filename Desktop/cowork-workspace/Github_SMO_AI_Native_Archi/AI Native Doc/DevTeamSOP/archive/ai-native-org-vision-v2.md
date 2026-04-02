# Autonomous AI-Native Development Organization — Vision v2.1

**Date:** 2026-03-30
**Author:** Mamoun Alamouri, CEO — SMOrchestra.ai
**Status:** Active — Primary Strategic Priority — Phase 6 Integration Tested, Production Ready
**Supersedes:** ai-native-org-vision-v1.md, ai-native-org-vision-v2.md, VibeMicroSaaS Super AI Execution Plan v1 (parked)

---

## Executive Summary

SMOrchestra.ai is building an **Autonomous AI-Native Development Organization** — a permanent operating structure where the CEO (Mamoun) operates exclusively at the Founder/Board layer while AI agents autonomously handle CEO+COO, Engineering, QA, GTM, Content, DevOps, and Data Engineering functions across multiple concurrent projects.

**The breakthrough insight:** We don't need 5 orchestration layers. OpenClaw — already running on smo-brain with persistent memory, Telegram, multi-model dispatch, and 10 active sessions — is the CEO and COO. Everything else is execution.

---

## The Problem

Today's reality:
- Mamoun operates as CEO + CTO + engineer + QA + DevOps
- Multiple business lines compete for the same human capacity
- Context-switching between projects kills velocity
- No way to run parallel workstreams without Mamoun coding

The ceiling is human hours. Every hour Mamoun spends debugging is an hour not spent closing deals, validating ideas, or building the pipeline.

---

## Architecture: BRD → Queue → Dispatch → Score → Merge

**What was actually built (March 2026):**

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                   MAMOUN (Founder/Board — Strategy Only)                      │
│                                                                              │
│   Approvals · Sales · GTM Strategy · Architecture Decisions · Clients       │
│   Interface: Telegram (@SMO-AI-CEO) + Paperclip Dashboard (optional)       │
└──────────────────────────────┬───────────────────────────────────────────────┘
                               │
                    /brd "Build X for Y"
                               │
                ┌──────────────▼──────────────┐
                │   n8n TELEGRAM HANDLER       │
                │   smo-brain · 16 nodes       │
                │                              │
                │   /brd → decompose-brd.sh    │
                │   /status /active /queue     │
                │   /approve /approve_all      │
                │   /reject /kill /extend      │
                │   /pause /resume             │
                │   better-sqlite3 → queue.db  │
                └──────────────┬───────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   SQLite QUEUE (queue.db)    │
                │   smo-brain:/root/.smo/queue │
                │                              │
                │   tasks · file_locks         │
                │   audit_log · role_skills    │
                │   skill_versions             │
                │   node_accounts              │
                │   task_artifacts             │
                └──────────────┬───────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   n8n QUEUE PROCESSOR        │
                │   Cron: every 2 minutes      │
                │                              │
                │   ✅ Concurrency gates        │
                │   ✅ Dependency checking      │
                │   ✅ File conflict detection  │
                │   ✅ Node capacity check      │
                │   ✅ Skill verification       │
                │   ✅ classify-task.sh routing │
                └──────────────┬───────────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
   ┌──────────▼─────┐  ┌──────▼──────┐  ┌──────▼──────────┐
   │  smo-brain      │  │  smo-dev    │  │  desktop        │
   │  Planning node  │  │  Build node │  │  QA + Content   │
   │                 │  │             │  │                 │
   │  dispatch.sh    │  │  Claude Code│  │  Claude Code    │
   │  score-task.sh  │  │  + Codex    │  │  Paperclip      │
   │  create-pr.sh   │  │  Primary    │  │  (optional)     │
   │  task-complete.sh│  │  executor  │  │                 │
   └─────────────────┘  └─────────────┘  └─────────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   GitHub (Source of Truth)    │
                │                              │
                │   agent/TASK-XXX-* branches  │
                │   PRs with risk tier labels  │
                │   CI → scoring → merge       │
                └──────────────────────────────┘
```

### Architecture Evolution

| v1 Plan (9.1/10) | v2 Vision (9.4/10) | v2.1 Reality (Built) | Why Changed |
|---|---|---|---|
| Hermes CEO + OpenClaw COO | OpenClaw CEO+COO | n8n + SQLite queue + shell scripts | OpenClaw handles strategic COO layer; execution is queue-driven for reliability |
| Agent SDK (separate install) | Claude Code CLI | `dispatch.sh` calls `claude -p` | Shell scripts = debuggable, testable, zero dependencies |
| 5 components in critical path | 3 components | 4 components (n8n, SQLite, shell scripts, Claude Code) | Queue adds persistence + concurrency that OpenClaw alone can't guarantee |
| No task persistence | In-memory dispatch | SQLite queue with full audit trail | Tasks survive reboots, crashes, network blips |
| No BRD decomposition | OpenClaw decomposes | Claude Code via decompose-brd.sh | Deterministic decomposition with role/tier routing |
| No quality scoring | Planned | score-task.sh with retry loop | Automated quality gates per role |

---

## AI-Native Org Chart

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    MAMOUN (Founder/Board)                                │
│        Strategy · Sales · Approvals · Architecture                      │
│        Interface: Telegram @SMO-AI-CEO + Paperclip (optional)          │
└──────────────────────────┬──────────────────────────────────────────────┘
                           │
              ┌────────────▼─────────────────┐
              │   QUEUE ENGINE (COO Layer)    │
              │   n8n + SQLite + Shell Scripts│
              │   smo-brain · 24/7            │
              │                               │
              │   Telegram Handler (16 nodes) │
              │   Queue Processor (2min cron) │
              │   dispatch.sh + score-task.sh │
              └────────────┬──────────────────┘
                           │
              ┌────────────▼────────────┐
              │   OPENCLAW (CEO/Advisor) │
              │   smo-brain · systemd    │
              │   Memory · Telegram      │
              │   Strategic decisions     │
              └────────────┬─────────────┘
                           │
    ┌──────────┬───────────┼───────────┬──────────┬──────────┐
    │          │           │           │          │          │
┌───▼───┐ ┌───▼───┐ ┌─────▼────┐ ┌────▼───┐ ┌───▼──┐ ┌────▼────┐
│VP Eng │ │QA Lead│ │GTM Spec  │ │Content │ │DevOps│ │Data Eng │
│Sonnet │ │Sonnet │ │Sonnet    │ │Sonnet  │ │Sonnet│ │Codex    │
│Super- │ │gstack │ │smorch-gtm│ │smorch- │ │gstack│ │smorch-  │
│powers │ │/qa    │ │signals   │ │content │ │safety│ │data     │
│TDD    │ │/bench │ │campaigns │ │assets  │ │deploy│ │scraping │
└───────┘ └───────┘ └──────────┘ └────────┘ └──────┘ └─────────┘
  desktop   desktop   smo-dev     desktop   smo-dev   smo-dev

CC = Claude Code with role-specific methodology + skills
All models: Sonnet via OAuth (Haiku unavailable via OAuth subscription)
Budget: 2 OAuth accounts × $200/month = $400/month max
```

---

## Methodology-to-Role Mapping

| Role | Methodology | Key Skills | Quality Gate | Node |
|------|-------------|------------|-------------|------|
| **VP Engineering** | Superpowers (TDD) | writing-plans, spec-first, architecture-scorer | engineering-scorer >= 8/10 | Desktop |
| **QA Lead** | gstack | /qa, /benchmark, /canary, security-hardener | qa-scorer >= 8/10, CWV green | Desktop |
| **GTM Specialist** | smorch-gtm + eo | campaign-strategist, signal-detector, outbound-orchestrator | campaign-strategy-scorer >= 8/10 | smo-dev |
| **Content Lead** | smorch-content | asset-factory, linkedin-en-gtm, eo-youtube-mamoun | copywriting-scorer >= 8/10 | Desktop |
| **DevOps** | gstack safety | eo-deploy-infra, /careful, /guard | /benchmark CWV green, zero critical | smo-dev |
| **Data Engineer** | smorch-data | scraper-layer, clay-operator, n8n-architect | data completeness >= 90% | smo-dev |

---

## Execution Pipeline (What Was Built)

The queue engine implements a **persistent, auditable execution pipeline**:

```
/brd "Build X" (Telegram)
    │
    ▼
decompose-brd.sh (Claude Code decomposes BRD into tasks)
    │
    ▼
SQLite queue.db (tasks with role, tier, dependencies, server_node)
    │
    ▼
/approve_all (Telegram) → status: pending_approval → queued
    │
    ▼
Queue Processor (n8n cron 2min)
    ├── Concurrency check (per-account limits)
    ├── Dependency check (blocked_by)
    ├── File conflict check (file_locks)
    ├── classify-task.sh → tier routing:
    │     fast_track (S<8)  → Codex auto-edit
    │     staged_hybrid (8-15) → Claude plans + Codex executes + Claude reviews
    │     agent_team (S>15) → Claude Code full session
    │     forbidden → HALT + Telegram alert
    └── dispatch.sh → Claude Code/Codex on target node
              │
              ▼
        score-task.sh (quality gate per role)
              │
              ├── Score >= 8 → create-pr.sh (PR with risk labels)
              ├── Score < 8, attempts < 2 → retry with feedback
              └── Score < 8, attempts >= 2 → PR with needs-quality-review label
                    │
                    ▼
              task-complete.sh (unblock dependents, release locks, audit)
```

### Shell Scripts (10 deployed to smo-brain:/root/.smo/queue/)

| Script | Purpose |
|--------|---------|
| `decompose-brd.sh` | BRD → task decomposition via Claude Code |
| `add-task.sh` | Insert task into SQLite queue |
| `classify-task.sh` | Score task complexity → route to tier |
| `dispatch.sh` | SSH to target node, run Claude Code/Codex |
| `score-task.sh` | Run quality gate scorer per role |
| `create-pr.sh` | Create GitHub PR with risk tier labels |
| `task-complete.sh` | Mark complete, unblock dependents, release locks |
| `queue-status.sh` | CLI status board |
| `queue-approve.sh` | CLI task approval |
| `routing-sop.yaml` | Machine-readable routing policy |

### n8n Workflows (smo-brain)

| Workflow | Type | Purpose |
|----------|------|---------|
| SMO Queue — Telegram Command Handler | Webhook (Telegram) | 11 commands via @SMO-AI-CEO |
| SMO Queue — Queue Processor | Cron (2min) | Dispatch queued tasks |

---

## Infrastructure: Three-Node Tailscale Mesh

```
smo-brain (100.89.148.62) — SSH: root@ — ORCHESTRATION NODE
├── Queue Engine
│   ├── SQLite queue.db (/root/.smo/queue/)
│   ├── 10 shell scripts (dispatch, score, decompose, etc.)
│   └── routing-sop.yaml
├── n8n-mamoun (Docker) — https://ai.mamounalamouri.smorchestra.com
│   ├── SMO Queue — Telegram Command Handler (16 nodes, @SMO-AI-CEO)
│   ├── SMO Queue — Queue Processor (cron 2min)
│   └── better-sqlite3 mounted at /queue/queue.db
├── OpenClaw v2026.3.14 (CEO/Advisor) — systemd
│   ├── Memory — 19 files, 117 chunks, FTS
│   └── Telegram gateway
├── Claude Code v2.1.81
└── Skills: 87

smo-dev (100.117.35.19) — SSH: root@ — PRIMARY BUILD NODE
├── Claude Code v2.1.85
│   ├── GTM Specialist execution
│   ├── DevOps execution
│   └── Data Engineer execution (Codex)
├── n8n-dev — https://testflow.smorchestra.ai
└── Skills: 85

Desktop (100.100.239.103) — local — QA + CONTENT NODE
├── Paperclip — localhost:3100 (optional dashboard)
├── Claude Code v2.0.61
│   ├── VP Engineering execution (Sonnet)
│   ├── QA Lead execution (Sonnet)
│   └── Content Lead execution (Sonnet)
└── Skills: 80 (source of truth)

Tailscale mesh: private network, no port exposure
Skill sync: rsync -avzL from Desktop to servers
OAuth accounts: Account A (smo-brain+desktop, $200), Account B (smo-dev, $200)
```

---

## Graceful Degradation

| Component | Fallback | Impact |
|---|---|---|
| n8n crash | Queue persists in SQLite. Restart n8n, tasks resume. | < 1 min recovery |
| Queue Processor stuck | Telegram `/status` still works. Manual dispatch via CLI. | Dispatch paused, no data loss |
| OpenClaw crash | systemd auto-restart. Queue engine independent. | CEO/Advisor layer offline, execution continues |
| Paperclip crash | Not in critical path. Telegram is primary interface. | Dashboard only |
| Claude Code agent OOM | dispatch.sh retry or reassign to different node | Other agents unaffected |
| Codex timeout | Fall back to Claude Code | Higher cost, same capability |
| Tailscale disconnect | Auto-reconnect. Tasks for disconnected node queue. | Brief pause per node |
| SQLite corruption | WAL mode + regular backups. Audit log preserves history. | Recoverable |

---

## Multi-Project Capability

| Project | Team Allocation | Key Skills |
|---------|----------------|------------|
| **Super AI MicroSaaS Launcher** | VP Eng + QA + GTM + DevOps | Full stack |
| **SalesMfast Signal Engine** | VP Eng + Data Eng + GTM | Signals + enrichment + campaigns |
| **SalesMfast AI SME** | VP Eng + Content + DevOps | GHL + Arabic content |
| **CXMfast AI** | VP Eng + QA + DevOps | Contact center + security |
| **EO MENA Platform** | Content + GTM + DevOps | Training + directory + funnel |
| **YouTube Channel** | Content Lead | Scripts + asset production |

Same org chart, same skill routing, same quality gates — applied to any project.

---

## CEO Engagement Model

### What Mamoun Does
- Send BRDs via Telegram `/brd` to @SMO-AI-CEO
- Approve task batches via `/approve_all`
- Review quality gate failures via `/status`
- Kill/extend sessions via `/kill` `/extend`
- Manage client relationships and sales
- Monitor via Telegram commands (+ optional Paperclip dashboard)

### What Mamoun Does NOT Do
- Write code
- Debug builds
- Run deployments
- Create content assets
- Configure campaigns

### Escalation Protocol
```
Agent hits blocker → score-task.sh flags → Telegram alert →
  → Mamoun reviews via /status → /approve or /reject → Queue dispatches fix
```

Target: < 3 CEO touch-points per project per day.

---

## Macro Execution Plan (Updated 2026-03-30)

```
✅ PHASE 0: Skill Sync + Prerequisites (COMPLETE)
   ├── Skills synced to all 3 nodes (rsync)
   ├── Claude Code verified on all nodes
   ├── OpenClaw verified running + dispatch tested
   ├── n8n-mamoun verified
   └── SSH access confirmed (root@ on both servers)

✅ PHASE 1: Battle-Tested Foundation (COMPLETE)
   ├── 17/18 tests PASSED
   ├── OpenClaw dispatch → Claude Code confirmed
   └── Skills visible on all nodes

✅ PHASE 2: SQLite Queue + BRD Decomposition (COMPLETE)
   ├── SQLite queue.db created with 7 tables
   ├── 10 shell scripts deployed to smo-brain
   ├── BRD decomposition via Claude Code working
   ├── Telegram approval flow working
   └── classify-task.sh tier routing operational

✅ PHASE 3: Execution Engine (COMPLETE)
   ├── n8n Queue Processor (cron 2min) dispatching tasks
   ├── dispatch.sh executing on smo-brain + smo-dev
   ├── score-task.sh quality gates operational
   ├── create-pr.sh generating PRs with risk labels
   └── task-complete.sh cascading dependencies

✅ PHASE 4: Telegram Interface (COMPLETE)
   ├── @SMO-AI-CEO with 11 commands
   ├── n8n Telegram Handler (16 nodes, better-sqlite3)
   ├── Webhook fix: renamed node to avoid %20 encoding
   └── New credential: SMO Queue Bot v2

✅ PHASE 5: Paperclip Dashboard (COMPLETE — Optional)
   ├── Running on localhost:3100
   ├── 7 agents created and tested
   └── OAuth auth (zero API cost)

✅ PHASE 6: Integration Testing (COMPLETE)
   ├── 4/5 tasks completed autonomously
   ├── SQL injection fixes deployed
   ├── Worktree isolation working
   └── Timeout handling validated

→ PHASE 7: Production Hardening + 72h Soak ← CURRENT
   ├── QA fixes (indexes, locks, zombie cleanup)
   ├── Docs alignment (this update)
   ├── OpenClaw nudge cron (90min keep-alive)
   ├── Real multi-day BRD test
   └── Chaos testing + metrics
```

---

## Success Metrics

| Metric | Target |
|--------|--------|
| CEO coding hours per week | 0 |
| Concurrent projects in flight | 3+ |
| Agent completion rate | > 80% |
| Quality gate first-attempt pass | > 60% |
| CEO touch-points per project/day | < 3 |
| Mean time from brief to deployed | < 5 days |
| Monthly cost | < $360 API credits |

---

## Upgrade Paths (Post-MVP)

| Upgrade | When | What Changes |
|---------|------|-------------|
| Hermes as CEO | Multi-client scenarios | Honcho user modeling per client. OpenClaw → COO only. |
| Paperclip dispatch | Dashboard proven stable | Direct agent dispatch from UI. |
| Claude Code Remote Control | Scale beyond 3 nodes | `claude rc` with 32 concurrent sessions/node. |
| n8n-production integration | Customer pipeline ready | Customer workflows connect to AI org. |

---

## Key Files

| File | Purpose |
|------|---------|
| `AI-Native-Org/execution-plan-ai-native-org-v2.md` | Detailed phase-by-phase plan |
| `AI-Native-Org/skill-router-matrix.md` | 123 skills mapped to 6 roles |
| `AI-Native-Build/` | All shell scripts, SQL schema, routing SOP |
| `AI-Native-Build/queue-schema.sql` | SQLite schema (7 tables) |
| `AI-Native-Build/routing-sop.yaml` | Machine-readable task routing policy |
| `AI-Native-Build/dispatch.sh` | Core dispatcher (SSH to target, run Claude/Codex) |
| `AI-Native-Build/decompose-brd.sh` | BRD → task decomposition |
| `smo-brain:/root/.smo/queue/queue.db` | Live SQLite queue database |
| `smo-brain:/root/.smo/queue/*.sh` | Deployed scripts (identical to AI-Native-Build/) |

---

*Built with SQLite + shell scripts + n8n + Claude Code. Every piece running in production.*

**Document Version:** v2.1
**Last Updated:** 2026-03-30
**Classification:** SMOrchestra Internal — Strategic
