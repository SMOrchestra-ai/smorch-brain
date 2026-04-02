# Architecture Decision Records — Index

| ADR | Title | Status | Date | Decision |
|-----|-------|--------|------|----------|
| [ADR-001](ADR-001-sqlite-vs-postgresql.md) | SQLite over PostgreSQL for Queue Engine | ACCEPTED | 2026-03-30 | Use SQLite (WAL mode) now. Migrate to PostgreSQL at >500 tasks or multi-dispatcher. |
| ADR-002 | Parameterized SQL Wrapper (db.sh) | ACCEPTED | 2026-03-30 | All scripts source db.sh. No raw sqlite3 with user input. Positional :1,:2,:3 placeholders. |
| ADR-003 | CEO/COO Bot Separation | ACCEPTED | 2026-03-30 | @SMO-AI-CEO = CEO inbox (decisions). @SulaimanMoltbot = COO voice (strategy). Queue Engine = COO brain. |
| ADR-004 | OAuth Account-Based Cost Control | ACCEPTED | 2026-03-30 | Each OAuth account = $200 hard cap. Scale by adding accounts + nodes. No API keys. |
| ADR-005 | Paperclip as Core Visual Command Center | ACCEPTED | 2026-03-30 | Paperclip is NOT optional. Dual BRD entry (Telegram + Paperclip). Real-time agent status. Productization enabler. |

| [ADR-006](ADR-006-parallel-execution-remote-control.md) | Parallel Execution + Remote Control | ACCEPTED | 2026-03-29 | Agents run on smo-dev + desktop in parallel. SSH dispatch from smo-brain. |
| [ADR-007](ADR-007-ai-native-org-agent-sdk.md) | AI-Native Org Agent SDK | ACCEPTED | 2026-03-29 | Claude Agent SDK for agent orchestration. OpenClaw as gateway. |
| [ADR-008](ADR-008-superpowers-engineering-methodology.md) | Superpowers Engineering Methodology | ACCEPTED | 2026-03-29 | Each agent gets one superpower. Depth over breadth. |
| [ADR-009](ADR-009-gstack-ceo-qa-methodology.md) | Gstack CEO/QA Methodology | ACCEPTED | 2026-03-29 | CEO defines quality gates. Automated scoring before merge. |
| [ADR-010](ADR-010-keep-openclaw-defer-hermes.md) | Keep OpenClaw, Defer Hermes | ACCEPTED | 2026-03-29 | OpenClaw stays as agent gateway. Hermes deferred until scale requires it. |
| [ADR-011](ADR-011-multi-deployment-architecture.md) | Multi-Deployment Architecture | ACCEPTED | 2026-03-29 | Apps deploy on smo-dev. Orchestration on smo-brain. Desktop for dev + overflow. |
| [ADR-012](ADR-012-paperclip-on-smo-brain.md) | Paperclip Runs on smo-brain, Not Desktop | ACCEPTED | 2026-03-30 | smo-brain 24/7 server. Desktop = client only. Tailscale IP binding + OAuth auth. |
| ADR-013 | MiniMax M2.7 as OpenClaw Primary Model | ACCEPTED | 2026-03-30 | MiniMax M2.7 ($0.71/mo) for routing/conversation. Gemini Flash Lite fallback. Independent of Claude OAuth. |
| ADR-014 | Three-Layer Orchestration Model | ACCEPTED | 2026-03-30 | Paperclip (Company OS) → OpenClaw (Agent Ecosystem) → Queue Engine (Task Pipeline). Clear ownership per layer. |
| ADR-015 | OpenClaw Gateway Adapter Strategy | ACCEPTED | 2026-03-30 | All OpenClaw agents use `agentId: "main"` (Sulaiman). Role-dispatch via wake message context. Session strategy per use case. |

## Pending Decisions

- PostgreSQL migration trigger (revisit at 500 tasks)
- Multi-node dispatcher (when single smo-brain dispatcher bottlenecks)
- Codex CLI integration (currently hangs in SSH; Claude Code only for now)
