# SOP-04: Infrastructure Node Roles & Deployment

**Version:** 1.0
**Date:** April 2026
**Owner:** Mamoun Alamouri
**Scope:** All repos in the SMOrchestra GitHub org
**Locked by:** Mamoun Alamouri, 2026-04-01

---

## Three-Node Architecture

SMOrchestra operates a 3-node distributed AI development environment. Each node has a dedicated role. Mixing roles degrades performance and wastes capacity.

```
┌─────────────────────────────────────────────────────────────┐
│  smo-brain (100.89.148.62)         ORCHESTRATION HUB        │
│  ────────────────────────────────────────────────────────── │
│  Queue Engine (n8n + SQLite + bash)                         │
│  OpenClaw Sulaiman :18789 (chat) + al-Jazari :18790 (code) │
│  Paperclip :3100 (Company OS)                               │
│  BRD decomposition, task scoring, dispatch decisions        │
│  Agent compute: Account A ($200), 3 slots                   │
│                                                              │
│  DOES NOT: deploy apps, run migrations, push to production  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  smo-dev (100.117.35.19)           BUILD + DEPLOY SERVER    │
│  ────────────────────────────────────────────────────────── │
│  Primary code execution (Claude Code + Codex)               │
│  App deployment: supabase functions deploy, db push         │
│  n8n-dev :5170 (workflow testing)                           │
│  All repos cloned to /workspaces/smo/                       │
│  Agent compute: Account B ($200), 3 slots                   │
│                                                              │
│  THIS IS WHERE APPS DEPLOY FROM. Period.                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  Desktop (100.100.239.103)         CLIENT + OVERFLOW        │
│  ────────────────────────────────────────────────────────── │
│  Paperclip UI browser access                                │
│  Telegram monitoring                                        │
│  Overflow agent compute: Account A (shared), Codex          │
│  Skills source of truth (desktop → rsync to servers)        │
│                                                              │
│  NOT a server. No services run here.                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Rule 1: Deployment Runs From smo-dev

All production deployment commands execute on smo-dev:

| Command | Target | Server |
|---------|--------|--------|
| `supabase functions deploy` | Supabase cloud | smo-dev |
| `supabase db push` | Supabase PostgreSQL | smo-dev |
| `supabase migrations apply` | Supabase PostgreSQL | smo-dev |
| `npm run deploy` / `vercel deploy` | Any hosting | smo-dev |
| Docker builds / pushes | Container registry | smo-dev |

smo-brain runs queue scripts and n8n workflows. It does NOT run deployment commands.

**Why:** Separation of concerns. smo-brain's CPU and memory are reserved for orchestration (n8n, OpenClaw, Paperclip, Queue DB). Deployment workloads (builds, uploads, CLI tools) compete for those resources. Mixing them creates cascading failures — a heavy deploy starves the queue, stalled queue blocks all agents.

---

## Rule 2: Agent Compute Uses ALL Nodes

Task execution (Claude Code, Codex) distributes across all 3 nodes:

| Node | OAuth Account | Max Concurrent | Monthly Cap |
|------|--------------|----------------|-------------|
| smo-brain | Account A (Mamoun) | 3 | $200 |
| smo-dev | Account B | 3 | $200 |
| Desktop | Account A (shared) | 3 | $200 shared with smo-brain |

**dispatch.sh routes tasks based on:**
1. `server_node` field in queue DB (set at BRD decomposition)
2. Account capacity (active sessions per account < max_concurrent)
3. Node availability (Tailscale reachable)

**Never consolidate all tasks to one node.** If a node is unreachable:
- Flag it to Mamoun via Telegram
- Route to available nodes temporarily
- Do NOT silently reroute everything and continue as normal

**Why:** Each OAuth account is a $200 billing boundary. One idle node = $200/month wasted capacity. The architecture was designed for parallel execution across nodes, not serial execution on one.

---

## Rule 3: PR Branch Targets Per Repo

| Repo | PR Base Branch | Flow |
|------|---------------|------|
| **Signal-Sales-Engine** | `dev` | `agent/TASK-XXX` → PR to `dev` → manual merge to `main` |
| **EO-Scorecard-Platform** | `dev` | Same pattern |
| **All other repos** | Check default branch | Use `gh repo view --json defaultBranchRef` before creating PR |

**Never PR directly to `main`** unless the repo has no `dev` branch.

In dispatch.sh / create-pr.sh, the base branch is configured per repo in the queue DB or derived from GitHub.

---

## Rule 4: Repo Affinity

Each repo has a primary build server. Tasks for that repo route there by default:

| Repo | Primary Node | Reason |
|------|-------------|--------|
| Signal-Sales-Engine | smo-dev | Supabase deployment lives here |
| EO-Scorecard-Platform | smo-dev | Same |
| SaaSFast / SaaSFast-v2 | smo-dev | Build artifacts here |
| smorch-brain | smo-brain | Skills management hub |
| Queue Engine scripts | smo-brain | Scripts live here |

Desktop is overflow only — takes tasks when both servers are at capacity.

---

## Rule 5: Skills Source of Truth

```
Desktop (source of truth)
    │
    ├── rsync → smo-brain:/root/.claude/skills/
    └── rsync → smo-dev:/root/.claude/skills/
```

Skills are authored on desktop (smorch-brain repo), then synced to servers via `rsync`. Servers never author skills. Before dispatch, `dispatch.sh` verifies required skills exist on the target node via hash check in `skill_versions` table.

---

## Services Inventory

| Service | Node | Port | Restarts |
|---------|------|------|----------|
| Paperclip | smo-brain | 3100 | systemd `Restart=always` |
| OpenClaw (Sulaiman) | smo-brain | 18789 | systemd `Restart=always` |
| OpenClaw (al-Jazari) | smo-brain | 18790 | systemd `Restart=always` |
| n8n (production) | smo-brain | 5678 | systemd `Restart=always` |
| Queue DB (SQLite) | smo-brain | file | N/A |
| n8n (dev) | smo-dev | 5170 | Docker `restart: always` |

---

## Verification Checklist

Run this after any infrastructure change:

```bash
# smo-brain — orchestration services
ssh root@100.89.148.62 'systemctl is-active openclaw-chat openclaw-coding paperclip n8n'
ssh root@100.89.148.62 'sqlite3 /root/.smo/queue/queue.db "SELECT count(*) FROM tasks;"'

# smo-dev — build readiness
ssh root@100.117.35.19 'claude --version && which supabase && ls /workspaces/smo/'

# Desktop — skills sync
ls ~/.claude/skills/ | wc -l  # should match server counts
```

---

## Rule 6: Auth — No API Keys Except Google

| Provider | Auth Method | Allowed |
|----------|------------|---------|
| Claude Code | OAuth subscription (Max plan) | Yes |
| OpenAI Codex | OAuth or paste-token | Yes |
| Google Gemini | API key | Yes (exception) |
| MiniMax | API key | Yes (no OAuth available) |
| Any other AI service | OAuth/subscription only | No API keys |

**Why Google exception:** Google OAuth requires localhost callback which doesn't work on remote servers (smo-brain, smo-dev). Google API keys are the only practical auth method for Gemini on headless nodes.

**Why MiniMax exception:** MiniMax has no OAuth flow. API key is the only option.

---

## What This SOP Does NOT Cover

- Queue Engine internals (see `build-progress-2026-04-01.md`)
- Agent role definitions (see `SOP-Dev-Roles-Hierarchy.md`)
- GitHub branch protection and merge rules (see `SOP-Github-Standards.md`)
- Security decisions (see `AI-Native-Org/security-decisions.md`)
- Cost model details (see `AI-Native-Org/architecture-final-2026-03-30.md`)
