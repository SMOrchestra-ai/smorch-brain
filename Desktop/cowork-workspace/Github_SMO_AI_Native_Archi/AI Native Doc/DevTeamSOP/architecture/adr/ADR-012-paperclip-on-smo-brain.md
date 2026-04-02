# ADR-012: Paperclip Runs on smo-brain, Not Desktop

**Status:** ACCEPTED
**Date:** 2026-03-30
**Decision Maker:** Mamoun Alamouri

## Context

Paperclip was initially installed on the desktop Mac (localhost:3100). The `claude_local` adapter spawns Claude Code CLI processes. Desktop doesn't run Claude Code in headless mode reliably, and closing the laptop lid stops all heartbeats and agent execution.

The existing plan (in `distributed-percolating-moore.md`) correctly identified this: "Paperclip runs on desktop (laptop). Lid close = everything stops."

## Decision

**Paperclip runs on smo-brain (100.89.148.62:3100), bound to the Tailscale IP.**

Rationale:
1. smo-brain runs 24/7 (Hetzner VPS, systemd). No lid-close risk.
2. Claude Code CLI is already installed on smo-brain (v2.1.81+, Account A OAuth).
3. OpenClaw runs on smo-brain — the `openclaw_gateway` adapter connects via `ws://127.0.0.1:18789` (localhost, zero latency).
4. n8n runs on smo-brain — Paperclip Sync and heartbeat workflows reach Paperclip on localhost.
5. Queue DB (SQLite) is on smo-brain — all coordination is local.

## Consequences

### Positive
- All three layers (Paperclip + OpenClaw + Queue Engine) co-located on one server = simplest possible deployment.
- Heartbeats fire 24/7 regardless of desktop state.
- `claude_local` adapter has direct access to repos in `/workspaces/smo/`.
- Desktop becomes a pure client (browser to Paperclip UI via Tailscale).

### Negative
- smo-brain is now a single point of failure for ALL layers. Mitigation: systemd auto-restart, hourly backups, Hetzner auto-recovery.
- Desktop cannot run Paperclip agents locally. Mitigation: not needed — desktop is the CEO's observation window, not an execution node.
- Paperclip UI accessible only via Tailscale (not plain localhost from any browser). Mitigation: this is a security feature, not a bug.

### Security Impact
- SD-002 (unauthenticated API) is now higher risk — Paperclip API is on Tailscale network, not just localhost. Must use Paperclip OAuth mode, not `local_trusted`.
- SD-005 (network exposure) updated: Paperclip on Tailscale IP, but Tailscale mesh is trusted.

## Alternatives Considered

| Option | Why Rejected |
|--------|-------------|
| Keep on desktop | Lid close = system dies. Not viable for 24/7 autonomous operation. |
| Run on smo-dev | Would split layers across two servers unnecessarily. smo-dev is overflow for Claude Code execution. |
| Run in Docker on smo-brain | Adds complexity. Paperclip's embedded PostgreSQL works fine with systemd. |
