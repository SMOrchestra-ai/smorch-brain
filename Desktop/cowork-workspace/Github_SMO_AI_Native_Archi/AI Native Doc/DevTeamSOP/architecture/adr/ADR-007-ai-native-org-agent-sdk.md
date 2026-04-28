# ADR-007: AI-Native Organization — Two-Layer Orchestration (Paperclip Dev-Time + OpenClaw Runtime)

**Date:** 2026-03-28
**Status:** Accepted (Revised v2 — OpenClaw CEO+COO, Hermes deferred)
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (AI-Native Org — Phase 0)
**Revision History:** Original version rejected Paperclip entirely. Revised v1 after strategic pivot to Autonomous AI-Native Dev Org. Revised v2 (2026-03-29): Hermes dropped from MVP — OpenClaw serves as both CEO and COO. Paperclip remains for optional dashboard. Agent SDK confirmed as Claude Code CLI (not separate package).

## 1. Context

SMOrchestra.ai is building an Autonomous AI-Native Development Organization where the CEO operates at the strategy layer only, while AI agents handle COO, Engineering, QA, GTM, DevOps, and Content functions across multiple concurrent projects. This requires two distinct orchestration concerns:

1. **Dev-time orchestration:** WHO does WHAT across multiple projects, with org chart, budget governance, heartbeat monitoring, mobile dashboard, and crash recovery. This is the "company management" layer.
2. **Runtime orchestration:** Customer-facing pipeline execution — founder conversations, stage progression, quality gates, campaign deployment. This is the "product delivery" layer.

The original ADR-007 evaluated Paperclip for both concerns and rejected it due to stability risk. The revised evaluation separates these concerns and applies different risk tolerances.

## 2. Options Considered

### Option A: Paperclip for EVERYTHING (rejected)
- **Description:** Use Paperclip as both dev-time org manager AND runtime pipeline orchestrator
- **Verdict:** Rejected. Paperclip at 26 days old with OOM/crash bugs is unacceptable for a customer-facing production pipeline. A crash during a customer's Stage 7 deployment could lose data.

### Option B: Agent SDK for EVERYTHING (original ADR-007 decision — revised)
- **Description:** Build the entire AI-native org structure using Agent SDK + role CLAUDE.md + Supabase + n8n. No Paperclip.
- **Verdict:** Revised. This works for runtime but misses the dev-time management layer. Building a multi-project org chart, ticket system, budget governance, heartbeat monitoring, and mobile dashboard from scratch is 2-3 weeks of engineering — exactly the kind of work the AI org should do, not what blocks its creation.

### Option C: Two-Layer Architecture — Paperclip (dev-time) + OpenClaw/Agent SDK (runtime)  **CHOSEN**
- **Description:** Paperclip manages the development organization (multi-project dashboard, agent teams, budget tracking). OpenClaw + Agent SDK manages the customer-facing pipeline (founder conversations, stage progression, quality gates).
- **Pros:**
  - Paperclip provides pre-built org chart, ticket system, budget caps, heartbeat, mobile dashboard — exactly what's needed for dev-time management
  - Paperclip crashes during development = restart with pm2 (acceptable risk)
  - OpenClaw + Agent SDK for runtime = production-grade with zero third-party stability risk
  - Each layer can evolve independently
  - Mobile dashboard from Paperclip enables CEO-only management from phone
- **Cons:**
  - Two systems to maintain
  - Must define clear boundaries between layers
  - Paperclip bugs still require debugging (mitigated by pm2 auto-restart)

## 3. Decision

We chose **Option C: Two-Layer Orchestration** because:

1. **Different risk profiles demand different tools.** Dev-time crashes are restartable. Customer-facing crashes lose trust and data.
2. **Paperclip provides exactly what a dev-time org needs** — org chart, tickets, budget, heartbeat, mobile dashboard — without building it from scratch.
3. **OpenClaw + Agent SDK is battle-tested** for the runtime pipeline (3-node Tailscale mesh, ACE Telegram commands, Agent SDK session control).
4. **The CEO engagement model requires mobile-first management.** Paperclip's dashboard enables this out-of-the-box.

### Boundary Definition

| Concern | Dev-Time (Paperclip) | Runtime (OpenClaw + Agent SDK) |
|---------|---------------------|-------------------------------|
| **Scope** | All SMOrchestra projects | Customer pipeline (10 stages) |
| **Users** | Mamoun (CEO dashboard) | Founders (Telegram) |
| **Uptime** | Best-effort (pm2 restart) | Production-grade |
| **State** | Paperclip DB + Supabase | Supabase project_runs + stage_events |
| **Crash impact** | Retry task | Customer sees error |
| **Agent dispatch** | Paperclip tickets → CC instances | OpenClaw → Agent SDK sessions |
| **Budget tracking** | Per-project, per-team | Per-customer, per-stage |
| **Communication** | Paperclip UI + mobile | Telegram (ACE commands) |

### Re-evaluation Triggers
- **Paperclip reaches v1.0:** Re-evaluate for runtime use (lower risk profile)
- **Paperclip crashes > 3x/day with pm2:** Evaluate custom replacement for dev-time layer
- **Agent SDK adds native org management:** Evaluate consolidating to single layer

## 4. Trade-offs Accepted

- **Two systems to maintain:** We accept the operational overhead of managing Paperclip (dev-time) and OpenClaw (runtime) because they serve fundamentally different risk profiles.
- **Paperclip instability:** OOM kills, DB backup crashes at ~250MB, WebSocket close crashes are known bugs. We mitigate with pm2 auto-restart and by scoping Paperclip to dev-time only where crashes are recoverable.
- **No unified dashboard:** Dev-time (Paperclip UI) and runtime (SaaSFast admin panel) are separate views. Acceptable for MVP. Unification is a v2 concern.
- **Paperclip is 26 days old:** We accept this risk for dev-time use because (a) the alternative is building from scratch, which delays the AI org by weeks, and (b) crashes in dev context are recoverable.

## 5. Consequences

**Immediate actions required:**
- [ ] Install Paperclip on smo-brain with pm2 crash recovery (Mamoun, Step 2)
- [ ] Configure Paperclip org chart: OpenClaw (COO), VP Eng, QA Lead, GTM Spec, Content Lead, DevOps, Data Engineer (Mamoun, Step 2)
- [ ] Validate Paperclip mobile dashboard access over Tailscale (Mamoun, Step 2)
- [ ] Refactor OpenClaw → Claude Code bridge from SSH + `claude -p` to Agent SDK (Lana, Step 3)
- [ ] Create role-specific CLAUDE.md files for all AI org roles (Mamoun, Step 1)
- [ ] Implement per-project context injection from Supabase into Agent SDK sessions (Lana, Step 3)
- [ ] Define skill routing rules: which skills load for which role (Mamoun, Step 1)
- [ ] Test end-to-end: Paperclip ticket → agent dispatch → Claude Code session → completion → Paperclip update (Both, Step 4)

**What changes as a result:**
- Paperclip becomes the CEO's primary management interface for development work
- OpenClaw remains the COO brain for customer-facing pipeline
- Agent SDK replaces raw SSH + `claude -p` for all Claude Code invocations
- Each Claude Code instance operates under a role-specific CLAUDE.md with scoped methodology and skills
- Budget governance per project via Paperclip + per customer via Agent SDK cost tracking
- The AI org can manage 3+ concurrent projects across 3 server nodes

**AI-Native Org Chart (Target Architecture — v2):**
```
Mamoun (Founder/Board) — strategy, sales, approvals
  │
  ├── OpenClaw (CEO + COO) — smo-brain
  │     ├── Memory (19 files, 117 chunks, FTS)
  │     ├── Telegram gateway
  │     ├── coding-agent dispatch (Claude Code + Codex)
  │     ├── Role skills (vp-eng, qa, gtm, content, devops, data)
  │     └── 10 active sessions (Sonnet + Codex)
  │
  ├── Paperclip (Optional Dashboard) — Desktop
  │     ├── Org chart visualization
  │     ├── Ticket tracking (read-only)
  │     └── NOT in critical path
  │
  └── Execution (3 nodes, 85+ skills)
        ├── Claude Code + vp-engineering.md (Superpowers TDD)
        ├── Claude Code + qa-lead.md (gstack /qa + security)
        ├── Claude Code + gtm-specialist.md (signals, campaigns)
        ├── Claude Code + content-lead.md (assets, pages)
        ├── Claude Code + devops.md (Contabo, Docker, deploy)
        └── Claude Code + data-engineer.md (enrichment, scraping)
```

**Note (v2):** Hermes was planned as CEO agent but OpenClaw already provides persistent memory, Telegram, multi-model dispatch, and always-on operation. Hermes deferred to post-MVP for Honcho user modeling in multi-client scenarios.

**Reversal cost:**
- Removing Paperclip: Easy (< 1 day) — it's a standalone dev-time tool
- Removing Agent SDK: Medium (1-3 days) — revert to SSH + `claude -p`
- Swapping Paperclip for custom: Medium (2-3 weeks) — must rebuild org chart, tickets, budget, dashboard
