# ADR-010: Keep OpenClaw + Agent SDK as Brain (Defer Hermes to Post-MVP)

**Date:** 2026-03-28
**Status:** Accepted
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (VibeMicroSaaS Super AI — Phase 0)

## 1. Context

The VibeMicroSaaS pipeline uses OpenClaw as the "brain" — a conversational agent in Telegram that manages founder relationships, decides pipeline progression, and dispatches work to Claude Code instances and n8n workflows across a 3-node Tailscale mesh. The MicroSaaS Launcher Tech Audit proposed replacing OpenClaw with Hermes Agent (NousResearch/hermes-agent) for its persistent memory, self-improving skill library, and `hermes claw migrate` migration tool.

## 2. Options Considered

### Option A: Migrate to Hermes Agent immediately
- **Description:** Install Hermes Agent, migrate OpenClaw config via `hermes claw migrate`, use Hermes as the pipeline brain with persistent FTS5 memory and Honcho user modeling
- **Pros:** Persistent multi-level memory (solves "amnesia problem"); self-improving skill distillation; native MCP client; Telegram/Discord/Slack gateway; Honcho user modeling learns founder preferences over time
- **Cons:** **v0.4.0 (pre-1.0)** with 928 open issues and 153 labeled bugs; agent self-termination bugs; encryption failures; config parsing crashes; **`hermes claw migrate` does NOT exist in the codebase** (verified March 28 — zero code matches for "claw migrate"); single-maintainer risk (teknium1 has 2,011 of ~2,200 commits); our 49 skills are Claude Code markdown — Hermes uses agentskills.io format requiring full rewrite; OpenClaw mesh has custom ACE Telegram commands and Tailscale routing that won't migrate with a generic persona/memory import
- **Estimated effort:** 5-8 days (migration + skill rewrite + stability debugging)
- **Estimated cost:** High operational risk — pre-1.0 agent running production pipeline

### Option B: Keep OpenClaw + Claude Code Agent SDK (current architecture)
- **Description:** Retain OpenClaw as the pipeline brain on smo-brain. Upgrade its Claude Code integration from raw SSH + `claude -p` to the native Agent SDK (Python/TypeScript) for programmatic session control, structured output, cost tracking, and session resumption.
- **Pros:** OpenClaw mesh already works (3 nodes connected); ACE Telegram commands battle-tested; Agent SDK provides session IDs, cost tracking, structured JSON output, subagent spawning — covering the key capabilities that motivated the Hermes evaluation; 49 existing skills work as-is (no rewrite); zero migration risk
- **Cons:** No persistent cross-session memory (Agent SDK sessions are stateless); no self-improving skill distillation; must build "memory" via Supabase project_runs and brain files
- **Estimated effort:** 2-3 days (Agent SDK integration into OpenClaw)

## 3. Decision

We chose **Option B: Keep OpenClaw + Agent SDK** because:
1. `hermes claw migrate` — the claimed migration path — does not exist in the codebase
2. Hermes at v0.4.0 with 928 open issues and agent self-termination bugs is unacceptable for a production pipeline serving paying customers
3. Agent SDK provides the key capabilities (programmatic control, structured output, cost tracking) that motivated the Hermes evaluation
4. Rewriting 49 Claude Code skills to agentskills.io format is 3-5 days of work with no functional benefit

**Re-evaluation trigger:** When Hermes Agent reaches v1.0 with <100 open bugs AND `hermes claw migrate` actually ships, run a parallel comparison on one test project.

## 4. Trade-offs Accepted

- **No persistent cross-session memory:** We accept this limitation. Our workaround: project context lives in Supabase (`project_runs.brain_files`, `stage_events`) and is re-injected into each Agent SDK session via system prompt. This is explicit rather than implicit — the brain "remembers" because we tell it what to remember, not because it learned autonomously.
- **No self-improving skill distillation:** Skills improve through human iteration (skill-creator workflow), not autonomous learning. Acceptable for MVP.

## 5. Consequences

**Immediate actions required:**
- [ ] Install Claude Agent SDK (Python) on smo-brain: `pip install claude-agent-sdk` (Mamoun, Day 1)
- [ ] Refactor OpenClaw → Claude Code bridge from SSH + `claude -p` to Agent SDK `create_session()` + `query()` (Lana, Phase 2)
- [ ] Implement per-project context injection: load brain_files from Supabase → inject as system prompt in Agent SDK sessions (Lana, Phase 2)
- [ ] Set up cost tracking aggregation per project in Supabase (Phase 4)

**What changes as a result:**
- OpenClaw remains the brain on smo-brain
- Agent SDK replaces raw SSH + `claude -p` for all Claude Code invocations
- Per-session cost tracking enables budget visibility per project
- Session IDs enable resumption of interrupted builds
- Structured JSON output from Agent SDK replaces unstructured text parsing

**Reversal cost:** Medium (1-3 days) — migrating to Hermes would require installing Hermes, manually recreating persona/memory/skills (since `hermes claw migrate` doesn't exist), and rewiring all Agent SDK integration points
