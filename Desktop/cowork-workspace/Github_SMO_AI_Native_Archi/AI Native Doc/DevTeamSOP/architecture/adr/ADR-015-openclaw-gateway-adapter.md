# ADR-015: OpenClaw Gateway Adapter Strategy

**Status:** ACCEPTED
**Date:** 2026-03-30
**Decision Maker:** Mamoun Alamouri

## Context

Paperclip needs to communicate with OpenClaw-hosted agents (VP Eng, Content, GTM). Paperclip has 10 adapter types. The `openclaw_gateway` adapter connects via WebSocket to OpenClaw's gateway protocol v3.

Key challenge: Paperclip treats each agent as a separate entity. OpenClaw routes internally via role-dispatch to a single "main" agent (Sulaiman). How to bridge?

## Decision

**Use `openclaw_gateway` adapter with `agentId: "main"` for all OpenClaw-routed agents. Differentiate via wake message context.**

### Configuration

All three OpenClaw-backed Paperclip agents (VP Eng, Content, GTM) connect to the same OpenClaw agent (`main` = Sulaiman). The wake message includes the role and task context, and OpenClaw's role-dispatch skill routes internally.

```yaml
# VP Engineering agent in Paperclip
adapter: openclaw_gateway
config:
  gatewayUrl: "ws://127.0.0.1:18789"
  authToken: "${OPENCLAW_GATEWAY_TOKEN}"
  agentId: "main"
  sessionStrategy: "issue"
```

### Why Not Separate OpenClaw Agents Per Role

OpenClaw supports multiple agents, but:
1. Each agent needs its own config, workspace, and model allocation.
2. Sulaiman's role-dispatch skill already routes by context — this is how OpenClaw is designed to work.
3. Creating 6 separate OpenClaw agents would be wasteful when one agent with skills handles routing.

### Future Option: Per-Role agentId

If Sulaiman becomes overloaded (>50 concurrent sessions), create dedicated OpenClaw agents:
- `agentId: "vp-eng"` — handles only engineering tasks
- `agentId: "content"` — handles only content tasks
- `agentId: "gtm"` — handles only GTM tasks

This is a scaling decision, not an architectural one. The adapter config changes; the architecture doesn't.

## Consequences

### Positive
- Simple: one OpenClaw agent handles all routing.
- Efficient: single model context window, shared skills.
- Cost: one MiniMax session, not three.

### Negative
- Paperclip can't see individual role execution times (only aggregate Sulaiman response).
- If Sulaiman misroutes, wrong role handles the task. Mitigation: wake message explicitly names the role.

## Session Strategy

| Strategy | When to Use |
|----------|------------|
| `issue` | Default. One session per Paperclip issue. Context preserved across wakes. |
| `run` | Stateless health checks or status queries. |
| `fixed` | Long-running persistent context (e.g., sprint planning). |
