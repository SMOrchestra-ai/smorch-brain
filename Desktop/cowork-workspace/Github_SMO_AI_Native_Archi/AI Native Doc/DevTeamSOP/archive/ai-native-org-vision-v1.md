# Autonomous AI-Native Development Organization — Vision v1

**Date:** 2026-03-28
**Author:** Mamoun Alamouri, CEO — SMOrchestra.ai
**Status:** Active — Primary Strategic Priority
**Supersedes:** VibeMicroSaaS Super AI Execution Plan v1 (parked)

---

## Executive Summary

SMOrchestra.ai is building an **Autonomous AI-Native Development Organization** — a permanent operating structure where the CEO (Mamoun) operates exclusively at the strategic layer while AI agents autonomously handle COO, CPO, Engineering, QA, GTM, and DevOps functions across multiple concurrent projects.

This is not a tool. This is not an automation layer. This is building a company where the engineering workforce is AI-native, self-coordinating, quality-gated, and capable of executing mega-projects while the CEO focuses on sales, strategy, and client relationships.

**Once this organization is built and validated, every product (Super AI MicroSaaS Launcher, SalesMfast Signal Engine, CXMfast AI, EO MENA) becomes a project the org executes — not something the CEO builds.**

---

## The Problem

Today's reality:
- Mamoun operates as CEO + CTO + engineer + QA + DevOps
- Lana (single developer) is the bottleneck for all engineering output
- Multiple business lines compete for the same human capacity
- Context-switching between projects kills velocity
- No way to run parallel workstreams without Mamoun coding

The ceiling is human hours. Every hour Mamoun spends debugging is an hour not spent closing deals, validating ideas, or building the pipeline.

---

## The Vision: Two-Layer Orchestration Architecture

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                        CEO LAYER (Mamoun — Strategy Only)                        │
│                                                                                  │
│   Approvals · Sales · GTM Strategy · Architecture Decisions · Client Relations   │
│                                                                                  │
│   Interface: Mobile dashboard (Paperclip) + Telegram (OpenClaw)                  │
└──────────────────────────────┬───────────────────────────────────────────────────┘
                               │
               ┌───────────────┴───────────────┐
               │                               │
┌──────────────▼──────────────┐  ┌─────────────▼──────────────────┐
│   LAYER 1: DEV-TIME         │  │   LAYER 2: RUNTIME              │
│   Paperclip Orchestrator    │  │   OpenClaw + Agent SDK          │
│                             │  │                                  │
│   WHO does WHAT across      │  │   Customer-facing pipeline      │
│   multiple projects         │  │   (10-stage MicroSaaS launcher) │
│                             │  │                                  │
│   Multi-project dashboard   │  │   Founder conversations         │
│   Org chart + roles         │  │   Stage progression             │
│   Budget governance         │  │   Quality gates                 │
│   Heartbeat monitoring      │  │   Campaign deployment           │
│   Ticket system             │  │   Instance provisioning         │
│   Cost tracking per team    │  │                                  │
│   Crash recovery (pm2)      │  │   State: Supabase               │
│   Mobile-first management   │  │   Execution: n8n                │
│                             │  │   Tools: MCP servers             │
│   Scope: ALL projects       │  │   Scope: Customer pipeline only  │
└─────────────────────────────┘  └──────────────────────────────────┘
```

### Why Two Layers

| Concern | Dev-Time (Paperclip) | Runtime (OpenClaw) |
|---------|---------------------|-------------------|
| **Purpose** | Manage the engineering org | Manage customer delivery |
| **Uptime requirement** | Crash = retry (dev context) | Crash = customer impact |
| **Stability tolerance** | Pre-1.0 acceptable (pm2 restart) | Production-grade required |
| **Scope** | All SMOrchestra projects simultaneously | One pipeline at a time |
| **User** | Mamoun (CEO dashboard) | Founders (Telegram) |
| **State** | Paperclip DB + Supabase | Supabase project_runs |

---

## AI-Native Org Chart

```
┌─────────────────────────────────────────────────────────────┐
│                    MAMOUN (CEO)                               │
│        Strategy · Sales · Approvals · Architecture           │
│        Interface: Paperclip mobile + Telegram                │
└──────────────────────────┬──────────────────────────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
    ┌────▼────┐     ┌──────▼──────┐    ┌─────▼─────┐
    │OpenClaw │     │  Paperclip  │    │   Lana    │
    │  (COO)  │     │  (CTO/PM)   │    │ (Sr. Dev) │
    │Telegram │     │  Dashboard  │    │  Human    │
    │Pipeline │     │  Multi-proj │    │  Fallback │
    └────┬────┘     └──────┬──────┘    └─────┬─────┘
         │                 │                 │
    ┌────┴─────────────────┴─────────────────┴────┐
    │              AI Engineering Teams             │
    │                                              │
    │  ┌──────────────┐  ┌──────────────────────┐  │
    │  │ VP Eng       │  │ QA Lead              │  │
    │  │ CC+Superpwr  │  │ CC+gstack /qa        │  │
    │  │ TDD, builds  │  │ Browser QA, security │  │
    │  └──────────────┘  └──────────────────────┘  │
    │                                              │
    │  ┌──────────────┐  ┌──────────────────────┐  │
    │  │ GTM Spec     │  │ Content Lead         │  │
    │  │ CC+smorch-gtm│  │ CC+asset-factory     │  │
    │  │ Signals,camp │  │ Pages, decks, video  │  │
    │  └──────────────┘  └──────────────────────┘  │
    │                                              │
    │  ┌──────────────┐  ┌──────────────────────┐  │
    │  │ DevOps       │  │ Data Engineer         │  │
    │  │ CC+deploy    │  │ CC+scraper-layer     │  │
    │  │ Infra, Docker│  │ Enrichment, Clay     │  │
    │  └──────────────┘  └──────────────────────┘  │
    └──────────────────────────────────────────────┘

CC = Claude Code instance with role-specific CLAUDE.md
Each role runs on Remote Control: --capacity N per node
Nodes: smo-brain, smo-dev, Desktop (3-node Tailscale mesh)
```

---

## Methodology-to-Role Mapping

The AI org doesn't just assign tasks — it enforces **methodology per role** through skill routing:

| Role | Primary Methodology | Skills Loaded | Quality Gate |
|------|-------------------|---------------|-------------|
| **OpenClaw (COO)** | gstack | `/office-hours`, `/plan-ceo-review` | Founder approval via Telegram |
| **VP Engineering** | Superpowers | TDD RED-GREEN-REFACTOR, subagent isolation, spec compliance, design-locking | All tests pass, Superpowers review |
| **QA Lead** | gstack + Superpowers | `/qa` (Playwright), `/benchmark` (Core Web Vitals), security-hardener | Zero critical bugs, CWV passing |
| **GTM Specialist** | smorch-gtm + eo | signal-to-trust, wedge-generator, outbound-orchestrator, gtm-scoring | GTM score > 8/10 |
| **Content Lead** | smorch-content + eo | asset-factory, youtube-deck, landing-page-gen | Content score > 8/10 |
| **DevOps** | smorch-deploy | deploy-infra, Contabo MCP, Docker, Coolify | Deployment health check pass |
| **Data Engineer** | smorch-data | scraper-layer, clay-operator, enrichment pipeline | Data quality validation pass |

---

## Skill-to-Gate Architecture

Skills aren't just instructions — they form a **quality enforcement chain**:

```
┌──────────────────────────────────────────────────────────────────┐
│                    SKILL ROUTING LAYER                            │
│                                                                  │
│  INPUT ──→ Guiding Skill (orchestrates process)                  │
│                │                                                 │
│                ├──→ Domain Skill (does the work)                 │
│                │         │                                       │
│                │         ▼                                       │
│                ├──→ Scoring Skill (rates the output)             │
│                │         │                                       │
│                │    Score < 8? ──→ Loop back to Domain Skill     │
│                │    Score >= 8? ──→ Pass to next gate            │
│                │                                                 │
│                └──→ QA Skill (validates before release)          │
│                          │                                       │
│                     Pass? ──→ SHIP                               │
│                     Fail? ──→ Auto-fix + regression test         │
└──────────────────────────────────────────────────────────────────┘
```

### Guiding Skills — The Innovation

**Guiding skills** are orchestrating skills that engage other skills and guide agents (and humans) to follow SOPs. They don't do the work — they **manage the workflow**:

- **smorch-gtm-orchestrator:** Engages signal-detector → wedge-generator → asset-factory → outbound-orchestrator in sequence, scoring at each step
- **smorch-dev-orchestrator:** Engages spec-writer → Superpowers TDD → security-hardener → gstack /qa in sequence
- **smorch-deploy-orchestrator:** Engages deploy-infra → health-check → gstack /benchmark → security audit

This pattern **wins over n8n** for process management because:
1. Skills carry context — they understand the domain, not just the trigger
2. Scoring skills teach AI to follow SOPs by rating compliance
3. Guiding skills can be version-controlled, improved, and shared
4. n8n handles the mechanical execution; guiding skills handle the judgment

**n8n + guiding skills = complete orchestration.** n8n fires the trigger, guiding skill manages the process, domain skill does the work, scoring skill validates.

---

## Infrastructure: Three-Node Parallel Execution

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   smo-brain     │  │    smo-dev      │  │    Desktop      │
│ 100.89.148.62   │  │ 100.117.35.19   │  │ 100.100.239.103 │
│                 │  │                 │  │                 │
│ OpenClaw (COO)  │  │ VP Eng (builds) │  │ QA Lead         │
│ Agent SDK       │  │ GTM Specialist  │  │ Content Lead    │
│ Paperclip       │  │ Data Engineer   │  │ DevOps          │
│ n8n-mamoun      │  │ n8n-dev         │  │ Overflow        │
│                 │  │                 │  │                 │
│ RC: --capacity 4│  │ RC: --capacity 4│  │ RC: --capacity 4│
└─────────────────┘  └─────────────────┘  └─────────────────┘
        │                    │                    │
        └────────── Tailscale Mesh ───────────────┘
                (Private network, no port exposure)
```

- **Remote Control:** `claude remote-control --spawn worktree --capacity N` per node
- **Total capacity:** 12+ concurrent Claude Code instances across 3 nodes
- **Crash recovery:** pm2 auto-restart on all nodes
- **Monitoring:** Paperclip dashboard + Remote Control web UI per node

---

## OpenClaw Terminal Control Model

**Critical architectural detail:** OpenClaw controls Claude Code and Codex on servers via **TERMINAL LOGIN**, not API. This means:

- OpenClaw SSH-es into smo-brain / smo-dev and runs `claude -p` or Agent SDK calls
- Throttling is per-terminal-session, not per-API-key (different rate limit regime)
- This enables higher effective concurrency than pure API access
- Agent SDK upgrade replaces raw SSH + `claude -p` with programmatic session control while maintaining the terminal-based execution model

---

## n8n Federation Strategy

Currently two separate n8n instances:
- **n8n-mamoun:** Production workflows (ACE campaigns, SCF enrichment, SSE deployment)
- **n8n-dev:** Development and testing workflows

**Strategy:** Keep separate for now. Federate only if cross-instance workflow triggers become necessary (e.g., n8n-dev testing needs to trigger n8n-mamoun campaign deployment). Federation mechanism: webhook-to-webhook bridging over Tailscale.

---

## Multi-Project Capability

Once the AI org is built, it handles **any project** — not just Super AI:

| Project | Team Allocation | Key Skills |
|---------|----------------|------------|
| **Super AI MicroSaaS Launcher** | VP Eng + QA + GTM + DevOps | Full stack — builds + deploys + campaigns |
| **SalesMfast Signal Engine** | VP Eng + Data Eng + GTM | Signal detection + enrichment + campaign |
| **SalesMfast AI SME** | VP Eng + Content + DevOps | GHL integration + Arabic content |
| **CXMfast AI** | VP Eng + QA + DevOps | Contact center build + security |
| **EO MENA Platform** | Content + GTM + DevOps | Training content + directory + funnel |
| **YouTube Channel** | Content Lead | Script generation + asset production |

The same org chart, same skill routing, same quality gates — applied to any project Mamoun assigns via the Paperclip dashboard.

---

## CEO Engagement Model

### What Mamoun Does
- Validates ideas (Telegram + gstack `/office-hours`)
- Approves architecture decisions (ADRs via PR review)
- Reviews quality gate failures that need human judgment
- Manages client relationships and sales
- Sets priorities and allocates projects to teams via Paperclip
- Monitors cost and progress via mobile dashboard

### What Mamoun Does NOT Do
- Write code
- Debug builds
- Run deployments
- Create content assets
- Configure campaigns
- Manage sprint tasks

### Escalation Protocol
```
Agent hits blocker ──→ QA Lead reviews ──→ VP Eng reviews ──→
    ──→ OpenClaw (COO) summarizes ──→ Telegram to Mamoun (CEO)
    ──→ Mamoun decides ──→ OpenClaw dispatches resolution
```

Maximum 2-3 CEO touch-points per project per day.

---

## Build Sequence (Preliminary)

> **Note:** Detailed execution plan will be built after architecture evaluation is complete. This is the macro sequence only.

### Step 1: Deploy Methodology Layers
- Install gstack on all nodes
- Install Superpowers on all nodes
- Configure skill router with all smorch skills
- Validate skill-to-role mapping works

### Step 2: Deploy Paperclip (Dev-Time Orchestrator)
- Install Paperclip on smo-brain
- Configure org chart with AI roles
- Set up pm2 crash recovery
- Validate mobile dashboard access
- Test ticket creation → agent dispatch → completion flow

### Step 3: Upgrade OpenClaw (Runtime Orchestrator)
- Replace SSH + `claude -p` with Agent SDK
- Implement per-project context injection from Supabase
- Implement cost tracking per session
- Test Telegram ↔ Agent SDK bidirectional flow

### Step 4: Validate Autonomous Execution
- Assign a real project to the AI org
- Monitor: Did it complete without Mamoun coding?
- Measure: How many CEO touch-points were needed?
- Score: Quality of output vs human-built equivalent

### Step 5: Hermes Experiment (Post-Validation)
- Install Hermes on test node
- Run parallel comparison vs OpenClaw
- Evaluate persistent memory and self-improving skills
- Decide: migrate, hybrid, or stay with OpenClaw

---

## Supervibes Re-Evaluation

The custom Supervibes (Node.js/tmux) built by the team has reusable components worth evaluating for Paperclip integration:

- **Controller/worker pattern:** Could complement Paperclip's agent dispatch
- **tmux session management:** May provide more granular control than Remote Control
- **Current limitation:** macOS-only — needs Linux port for server deployment
- **Decision:** Evaluate after Step 2 (Paperclip deployed). If Paperclip's built-in agent management is sufficient, Supervibes becomes redundant. If not, port the useful components.

---

## Success Metrics

| Metric | Target | How Measured |
|--------|--------|-------------|
| CEO coding hours per week | 0 | Self-reported time tracking |
| Concurrent projects in flight | 3+ | Paperclip dashboard |
| Agent completion rate (tasks assigned → tasks shipped) | > 80% | Paperclip ticket metrics |
| Quality gate pass rate (first attempt) | > 70% | Scoring skill logs |
| CEO touch-points per project per day | < 3 | Telegram message count |
| Mean time from idea to deployed MVP | < 5 days | Supabase project_runs timestamps |
| Cost per project | < $150 in API credits | Agent SDK cost tracking |

---

## What This Changes

**Before (current):**
- 1 CEO doing everything
- 1 developer as bottleneck
- Sequential project execution
- Manual quality checks
- Context-switching kills productivity

**After (target):**
- 1 CEO doing CEO things only
- 6+ AI agents as engineering workforce
- 3+ projects running in parallel
- Automated quality gates with skill-based scoring
- Each project gets a dedicated team from the org chart
- Lana focuses on infrastructure and complex integrations only
- The org scales by adding nodes, not hiring humans

---

## Relationship to Super AI MicroSaaS Launcher

The Super AI MicroSaaS Launcher (10-stage pipeline, BRD v1.2) is **PARKED** — not cancelled. Once the AI-Native Org is built and validated (Steps 1-4 above), building Super AI becomes:

1. A **project assigned to the AI org** via Paperclip
2. The VP Eng, QA Lead, GTM Specialist, and DevOps roles execute the build
3. OpenClaw (COO) manages the customer-facing pipeline
4. Mamoun approves architecture and reviews quality gates

The execution plan will be revised once the AI org is operational.

---

*This document captures the macro vision. Detailed architecture evaluation, execution plan, and deployment steps follow as separate deliverables.*

**Document Version:** v1
**Last Updated:** 2026-03-28
**Classification:** SMOrchestra Internal — Strategic
