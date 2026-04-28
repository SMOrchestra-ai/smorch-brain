# ADR-014: Three-Layer Orchestration Model

**Status:** ACCEPTED
**Date:** 2026-03-30
**Decision Maker:** Mamoun Alamouri

## Context

Multiple orchestration approaches were considered:
1. Paperclip as sole orchestrator (rejected: no internal OpenClaw visibility)
2. OpenClaw as sole orchestrator (rejected: no company-level governance, resets after 2h)
3. n8n + Queue Engine as sole orchestrator (rejected: no agent identity, no budgets)
4. Flat architecture where all components are peers (rejected: unclear authority)

The user explicitly corrected: "Paperclip is not just a view layer. Paperclip handles org-chart-level coordination, goals, governance, budgets, accountability, scheduled heartbeats, and assigning work across heterogeneous agents."

## Decision

**Three distinct orchestration layers, each owning a clear domain.**

```
Layer 1: Paperclip (Company OS)     — WHO does WHAT, WHEN, with WHAT BUDGET
Layer 2: OpenClaw (Agent Ecosystem) — HOW agents think, route, and collaborate
Layer 3: Queue Engine (Task Pipeline) — HOW code gets built, tested, and merged
```

### Separation of Concerns

| Concern | Owner | NOT owned by |
|---------|-------|-------------|
| Org chart, roles, reporting | Paperclip | OpenClaw, Queue |
| Budget enforcement | Paperclip | OpenClaw, Queue |
| Heartbeat scheduling | Paperclip | OpenClaw, Queue |
| Issue/ticket lifecycle | Paperclip | OpenClaw, Queue |
| Agent personas & conversation | OpenClaw | Paperclip, Queue |
| Telegram channel routing | OpenClaw | Paperclip, Queue |
| Skill invocation | OpenClaw | Paperclip, Queue |
| Subagent spawning (ACP) | OpenClaw | Paperclip, Queue |
| Task dispatch & dependency | Queue Engine | Paperclip, OpenClaw |
| File lock management | Queue Engine | Paperclip, OpenClaw |
| CI monitoring & PR creation | Queue Engine | Paperclip, OpenClaw |
| Quality scoring | Queue Engine | Paperclip, OpenClaw |

### Communication Patterns

- **Paperclip → OpenClaw:** `openclaw_gateway` adapter (WebSocket). Paperclip wakes agents, OpenClaw executes.
- **Paperclip → Claude Code:** `claude_local` adapter (process spawn). Direct execution for simple tasks.
- **OpenClaw → Queue Engine:** n8n webhook or bash script. OpenClaw requests task dispatch.
- **Queue Engine → Paperclip:** `paperclip-sync.sh` (HTTP API). Queue reports status back.
- **Queue Engine → Claude Code:** `dispatch.sh` (SSH + CLI). Direct execution.

## Consequences

### Positive
- Clear authority: each layer has unambiguous ownership.
- Resilience: if OpenClaw crashes, Paperclip still runs claude_local agents. If Paperclip crashes, running Queue tasks continue.
- Observability: Paperclip sees everything via adapters + sync.
- Extensibility: add new adapter types (HTTP, process) without changing OpenClaw or Queue.

### Negative
- Three systems to maintain (vs one monolith). Mitigation: all on same server, systemd-managed.
- Data sync latency (5min Paperclip Sync). Mitigation: acceptable for async autonomous work.
- Paperclip can't see inside OpenClaw's internal routing. Mitigation: create separate Paperclip agents per OpenClaw role if needed.

## Alternatives Considered

| Option | Why Rejected |
|--------|-------------|
| Paperclip-only | Can't handle agent personas, skills, Telegram routing |
| OpenClaw-only | Resets after 2h, no budget enforcement, no issue tracking |
| Queue-only | No governance, no agent identity, pure logic |
| Flat (all peers) | Unclear authority, budget leaks, no accountability |
