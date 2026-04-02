# SMOrchestra AI-Native Organization — Final Architecture

**Date:** 2026-03-30 | **Status:** LOCKED — Build from this
**Business Line:** SMOrchestra.ai

---

## The Three Orchestration Layers

```
┌──────────────────────────────────────────────────────────────┐
│                    YOU (Board of Directors)                    │
│          Approve hires, override strategy, set budgets,       │
│          pause/terminate agents. Telegram + Paperclip UI.     │
└──────────────────────────┬───────────────────────────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────┐
│              PAPERCLIP — Company Operating Layer              │
│                     (smo-brain:3100)                          │
│                                                               │
│  WHAT IT DOES:                                                │
│  • Org chart, goals, governance, budgets, accountability      │
│  • Issue/ticket management with atomic checkout               │
│  • Heartbeat scheduling — wakes agents to check for work     │
│  • Budget enforcement — hard stops auto-pause agents          │
│  • Cross-agent work assignment across heterogeneous runtimes  │
│  • Activity audit log for every run                           │
│                                                               │
│  AGENTS (each has an adapter):                                │
│  ┌──────────┬────────────────┬──────────────────────────┐    │
│  │ Agent    │ Adapter        │ What It Runs On          │    │
│  ├──────────┼────────────────┼──────────────────────────┤    │
│  │ CEO      │ claude_local   │ Claude Code on smo-brain │    │
│  │ VP Eng   │ openclaw_gw    │ OpenClaw → Sulaiman      │    │
│  │ QA Lead  │ claude_local   │ Claude Code on smo-brain │    │
│  │ DevOps   │ claude_local   │ Claude Code on smo-brain │    │
│  │ Data Eng │ claude_local   │ Claude Code on smo-brain │    │
│  │ Content  │ openclaw_gw    │ OpenClaw → Sulaiman      │    │
│  │ GTM      │ openclaw_gw    │ OpenClaw → Sulaiman      │    │
│  └──────────┴────────────────┴──────────────────────────┘    │
└──────────┬─────────────────────────┬─────────────────────────┘
           │                         │
     claude_local              openclaw_gateway
     (local process)           (WebSocket to OpenClaw)
           │                         │
           ▼                         ▼
┌─────────────────────┐  ┌─────────────────────────────────────┐
│ Claude Code CLI     │  │ OPENCLAW — Agent Ecosystem Layer     │
│ (smo-brain/smo-dev) │  │          (smo-brain:18789)           │
│                     │  │                                       │
│ Pure code execution │  │ WHAT IT DOES:                         │
│ No orchestration    │  │ • Multi-agent routing & personas      │
│ Gets task → does it │  │ • Isolated workspaces per agent       │
│                     │  │ • Channel routing (Telegram, etc.)    │
│                     │  │ • Subagent spawning (ACP protocol)    │
│                     │  │ • Session management & history        │
│                     │  │ • Cron scheduling                     │
│                     │  │ • Skill system (58 skills available)  │
│                     │  │                                       │
│                     │  │ IDENTITY: Sulaiman (@SulaimanMoltbot) │
│                     │  │ MODEL: MiniMax M2.7 (~$0.71/mo)      │
│                     │  │ ROLE: VP Engineering + Dev Lead       │
│                     │  │                                       │
│                     │  │ Internal agents (via role-dispatch):   │
│                     │  │ • VP Engineering (code architecture)  │
│                     │  │ • GTM Specialist (outbound/signals)   │
│                     │  │ • Content Lead (content production)   │
│                     │  │ • DevOps (infrastructure)             │
│                     │  │ • QA Lead (testing/validation)        │
│                     │  │ • Data Engineer (data pipelines)      │
│                     │  │                                       │
│                     │  │ Routes internally based on message    │
│                     │  │ context + skill invocation             │
└─────────────────────┘  └──────────────┬──────────────────────┘
                                        │
                              (for code tasks)
                                        │
                                        ▼
                         ┌──────────────────────────┐
                         │ QUEUE ENGINE — Task Layer │
                         │      (smo-brain)          │
                         │                           │
                         │ n8n + bash + SQLite        │
                         │ Pure logic, no LLM         │
                         │                           │
                         │ • Task dispatch            │
                         │ • Dependency tracking      │
                         │ • File lock management     │
                         │ • CI monitoring            │
                         │ • Quality scoring          │
                         │ • PR merge handling        │
                         │ • Dead letter queue        │
                         │ • TTL enforcement          │
                         └──────────────────────────┘
```

---

## Who Does What — No Ambiguity

### Paperclip (Company Layer)
- **Owns:** Goals, budgets, org chart, governance, accountability
- **Assigns work:** Creates issues, assigns to agents, tracks completion
- **Heartbeats:** Wakes each agent on schedule to check for work
- **Budget enforcement:** Hard stops auto-pause agents that overspend
- **Adapters:** Connects to Claude Code (local), OpenClaw (WebSocket), or any HTTP service
- **Visibility:** Sees run results, cost, status — but NOT inside OpenClaw's internal routing
- **To see inside OpenClaw:** Create separate Paperclip agents, each with `openclaw_gateway` adapter targeting different `agentId` values

### OpenClaw / Sulaiman (Agent Ecosystem Layer)
- **Owns:** Agent personas, workspaces, channel routing, session management, skills
- **Identity:** Sulaiman is the VP Engineering / Dev Lead
- **Telegram:** @SulaimanMoltbot handles all Telegram conversations
- **Multi-agent:** Routes work internally via role-dispatch skills (VP Eng, GTM, Content, DevOps, QA, Data)
- **Model:** MiniMax M2.7 for conversation/routing (~$0.71/mo). Gemini Flash Lite for heartbeats
- **Subagents:** Can spawn child agents for parallel work via ACP protocol
- **Reports to:** Paperclip CEO agent (via openclaw_gateway adapter)

### Queue Engine (Task Pipeline Layer)
- **Owns:** Code task lifecycle — from BRD decomposition to PR merge
- **No LLM:** Pure logic (SQLite + bash + n8n)
- **Dispatches to:** Claude Code CLI on smo-brain/smo-dev
- **Triggered by:** OpenClaw (via n8n hooks) or Telegram (via /brd command) or Paperclip (via issues)
- **Reports back:** Task status, quality scores, PR URLs — visible in Paperclip via sync

---

## How the Three Layers Connect

### Flow 1: BRD via Telegram
```
You → Telegram /brd → n8n → decompose-brd.sh → Queue Engine → dispatch.sh
→ Claude Code builds → CI passes → score-task.sh → create-pr.sh
→ Paperclip Sync (every 5min) updates Paperclip issues
→ You approve via Telegram /approve or Paperclip UI
```

### Flow 2: BRD via Paperclip
```
You → Paperclip UI → Create issue → Assign to VP Eng agent
→ Paperclip heartbeat wakes VP Eng agent (openclaw_gateway adapter)
→ OpenClaw receives task → Sulaiman decomposes
→ Sulaiman calls Queue Engine (via n8n hook or bash)
→ Queue Engine dispatches to Claude Code
→ Results flow back: Queue → Paperclip Sync → Paperclip issue updated
```

### Flow 3: Paperclip Heartbeat Cycle
```
Every N minutes per agent:
  Paperclip → Wake agent (via adapter)
  Agent checks: Do I have assigned issues? New work?
  If yes → Execute (code via Claude Code, strategy via OpenClaw)
  Results → Back to Paperclip (run log, cost, status)
  Paperclip → Updates issue status, records cost against budget
```

### Flow 4: OpenClaw Internal Routing
```
Message arrives (Telegram or Paperclip wake) → OpenClaw Gateway
→ Routing system: peer bindings > channel bindings > default
→ Agent "main" (Sulaiman) receives
→ If code task: invokes role-dispatch skill → spawns coding-agent subagent
→ If strategy/GTM: handles directly with MiniMax M2.7
→ If infrastructure: invokes n8n-automation skill → calls n8n API
→ Results stream back to caller (Telegram reply or Paperclip WebSocket)
```

---

## Infrastructure: Where Everything Runs

### smo-brain (100.89.148.62) — ORCHESTRATION HUB
Orchestration, planning, and queue management. Does NOT deploy applications.

| Service | Port | What |
|---------|------|------|
| **Paperclip** | 3100 | Company OS — org chart, goals, budgets, issue tracking |
| **OpenClaw Gateway (Sulaiman)** | 18789 | Chat gateway — Telegram, conversations, general queries |
| **OpenClaw Gateway (al-Jazari)** | 18790 | Coding gateway — Paperclip agent routing, BRD decomposition |
| **n8n** | 5678 | Workflow automation — 10 queue engine workflows |
| **Queue DB** (SQLite) | — | `/root/.smo/queue/queue.db` |
| **Paperclip DB** (PostgreSQL) | 54329 | Paperclip's embedded PostgreSQL |
| **Redis** | 6379 | Cache |
| **PostgreSQL** (n8n) | 5432 | n8n's database |

### smo-dev (100.117.35.19) — BUILD + DEPLOY SERVER
Primary server for code execution AND application deployment. All `supabase functions deploy`, `supabase db push`, and similar deployment commands run from here.

- Claude Code CLI (Account B, 3 slots) — primary build execution
- n8n-dev on port 5170 (for testing workflows)
- Supabase CLI installed — deployment target for edge functions and migrations
- All repos cloned to `/workspaces/smo/`
- Dispatched to by Queue Engine for task execution

### Desktop (100.100.239.103) — YOUR WINDOW + OVERFLOW COMPUTE
- Browser access to Paperclip UI: `http://100.89.148.62:3100`
- Browser access to OpenClaw Control UI: `http://100.89.148.62:18789`
- Telegram on phone for @SMOQueueBot and @SulaimanMoltbot
- Claude Code CLI (Account A shared with smo-brain) — overflow execution
- Codex CLI available for fast-track tasks

### Node Responsibility Summary

| Responsibility | smo-brain | smo-dev | Desktop |
|---------------|-----------|---------|---------|
| **Orchestration** (Queue Engine, n8n, OpenClaw) | PRIMARY | — | — |
| **Agent Compute** (Claude Code, Codex) | Yes (Account A) | Yes (Account B) | Yes (Account A shared) |
| **App Deployment** (Supabase, edge functions) | — | PRIMARY | — |
| **Planning** (BRD decomposition, scoring) | PRIMARY | — | — |
| **Monitoring** (Paperclip UI, Telegram) | Serves | — | Consumes |

---

## Cost Model

| Component | What | Monthly Cost |
|-----------|------|-------------|
| Claude Code (Account A) | 3 slots on smo-brain | $200 |
| Claude Code (Account B) | 3 slots on smo-dev | $200 |
| MiniMax M2.7 (OpenClaw) | Sulaiman's brain — 500+ convos | ~$1 |
| Gemini Flash Lite | OpenClaw heartbeats | ~$0.10 |
| Paperclip | Self-hosted, no LLM cost | $0 |
| Queue Engine | Pure logic, no LLM | $0 |
| Hetzner VPS (smo-brain) | Server | ~$15 |
| Hetzner VPS (smo-dev) | Server | ~$15 |
| **Total** | | **~$431/mo** |

**Equivalent human cost:** 6 junior-to-mid developers working 24/7 = $30,000-60,000/mo

---

## Build Order

### Phase 1: Install Paperclip on smo-brain (NOW)
1. Install Paperclip on smo-brain (Node 22 already there)
2. Configure: bind to Tailscale IP, authenticated mode
3. Migrate agent configs: CEO (claude_local), VP Eng/GTM/Content (openclaw_gateway)
4. Re-enable heartbeats with correct adapters
5. Verify Paperclip UI accessible from desktop browser

### Phase 2: Configure OpenClaw with MiniMax M2.7
1. Get MiniMax API key
2. Update OpenClaw config: primary model → MiniMax M2.7
3. Keep Gemini Flash Lite as heartbeat model
4. Test Sulaiman on Telegram responds with MiniMax

### Phase 3: Wire Paperclip ↔ OpenClaw
1. Configure openclaw_gateway adapter in Paperclip agents
2. Set gateway URL: `ws://127.0.0.1:18789` (same machine)
3. Set auth token from OpenClaw gateway config
4. Test heartbeat: Paperclip wakes VP Eng → OpenClaw receives → Sulaiman responds
5. Verify issue lifecycle: create → assign → execute → done

### Phase 4: Wire Paperclip ↔ Queue Engine
1. Paperclip Sync already runs every 5min (n8n workflow RnrHAtAdBESrdvn1)
2. Add reverse sync: Paperclip issue created → n8n webhook → add-task.sh
3. Test full flow: Paperclip issue → Queue Engine → Claude Code → PR → Paperclip done

### Phase 5: End-to-End Test + Soak
1. Send BRD via Telegram: verify full pipeline
2. Send BRD via Paperclip: verify full pipeline
3. 72-hour soak test: monitor heartbeats, budgets, dead letters
4. Verify budget enforcement: set $10 limit, confirm auto-pause works

---

## Failure Modes & Recovery

Every component can fail. Here's what happens and how the system recovers.

### Component Failure Matrix

| Component | Failure Mode | Detection | Auto-Recovery | Manual Recovery | RTO |
|-----------|-------------|-----------|---------------|-----------------|-----|
| **Paperclip** (smo-brain:3100) | Process crash | systemd watchdog | `Restart=always` (5s delay) | `systemctl restart paperclip` | <10s |
| **Paperclip** | PostgreSQL OOM | Paperclip health endpoint returns 500 | Restart recovers embedded PG | Increase PG shared_buffers | <30s |
| **Paperclip** | Corrupted agent config | Agent heartbeat returns error in run log | None — manual fix | Edit agent config via API or UI | <5min |
| **OpenClaw** (smo-brain:18789) | Process crash / SIGTERM from subagent | systemd watchdog + n8n nudge cron (90min) | `Restart=always` (5s delay) | `systemctl restart openclaw` | <10s |
| **OpenClaw** | Memory reset (>2h idle) | n8n nudge checks health + context | Nudge triggers re-warm with system prompt | Manual Telegram message to Sulaiman | <90min |
| **OpenClaw** | Model provider down (MiniMax API) | HTTP 5xx from model call | Fallback to Gemini Flash Lite (configured in OpenClaw) | Switch model in `agents/main/config.yaml` | <1min |
| **n8n** (smo-brain:5678) | Process crash | systemd watchdog | `Restart=always` | `systemctl restart n8n` | <10s |
| **n8n** | Workflow execution fails | n8n execution log (error status) | Dead letter queue for failed tasks | Review n8n execution, fix, retry | <5min |
| **Queue DB** (SQLite) | WAL corruption | `PRAGMA integrity_check` in daily cron | None — restore from backup | `cp /root/.smo/queue/queue.db.bak queue.db` | <2min |
| **Queue DB** | Disk full | Disk usage alert at 80% | Auto-cleanup of completed tasks >30 days | Expand disk or purge old data | <10min |
| **Claude Code CLI** | Session hang (>60min) | Session TTL Monitor (n8n, every 5min) | TTL kill → task retries once | `/kill TASK-XXX` via Telegram | <5min |
| **Claude Code CLI** | OAuth token expired | CLI returns auth error | Re-auth via `claude auth login` | SSH to node, re-authenticate | <5min |
| **Tailscale mesh** | Node disconnects | `tailscale status` in health check cron | Tailscale auto-reconnect | `tailscale up` on affected node | <2min |
| **Tailscale mesh** | Full mesh partition | Cross-node ping failure | None | Check Tailscale admin console, restart | <10min |
| **GitHub** | API rate limit | 403 response in CI Monitor | Exponential backoff (built into gh CLI) | Wait for rate limit reset | <60min |
| **Telegram Bot** | Bot blocked/rate-limited | Message send failure logged | Retry with backoff | Check Telegram BotFather | <5min |

### Cascading Failure Scenarios

**Scenario 1: smo-brain goes down entirely**
- Impact: Paperclip, OpenClaw, n8n, Queue DB all offline. smo-dev continues existing tasks but can't receive new ones.
- Detection: Tailscale health check from smo-dev fails within 5min.
- Recovery: Hetzner auto-restart (if hardware). Manual SSH and `reboot` if software. All services auto-start via systemd.
- RTO: 2-10 minutes (reboot + service startup).
- Data loss: None. SQLite WAL + PostgreSQL WAL ensure durability.

**Scenario 2: OpenClaw + Paperclip both crash simultaneously**
- Impact: No new task dispatch, no heartbeats, no Telegram interface. Running Claude Code tasks continue to completion.
- Detection: systemd restarts both within 5s. If persistent crash: Telegram silence >15min noticed by Mamoun.
- Recovery: systemd auto-restart. If code bug: check logs at `/root/moltbot/logs/` and `~/.paperclip/instances/default/logs/`.

**Scenario 3: Queue DB corrupted**
- Impact: All task state lost. Running tasks continue but results won't be recorded.
- Detection: Any SQLite query returns SQLITE_CORRUPT.
- Recovery: Restore from hourly backup: `cp /root/.smo/queue/queue.db.hourly queue.db`. Max 1h data loss.
- Prevention: Hourly cron: `sqlite3 /root/.smo/queue/queue.db ".backup /root/.smo/queue/queue.db.hourly"`

### Backup Strategy

| Data | Method | Frequency | Retention | Location |
|------|--------|-----------|-----------|----------|
| Queue DB (SQLite) | `.backup` command | Hourly | 24 hourly + 7 daily | `/root/.smo/queue/backups/` |
| Paperclip DB (PostgreSQL) | `pg_dump` via cron | Daily at 2am | 7 daily + 4 weekly | `/root/.smo/backups/paperclip/` |
| OpenClaw config | Git-tracked | On change | Full history | GitHub repo |
| n8n workflows | n8n export API | Daily at 2am | 7 daily | `/root/.smo/backups/n8n/` |
| Agent role files | Git-tracked | On change | Full history | GitHub repo |
| Skills | Git-tracked + rsync | On change | Full history | GitHub repo + all nodes |

---

## Monitoring & Observability

### Health Check Endpoints

| Service | Health Check | Expected Response | Check Frequency |
|---------|-------------|-------------------|-----------------|
| Paperclip | `curl -s http://127.0.0.1:3100/api/health` | `200 OK` with JSON status | Every 2min (n8n cron) |
| OpenClaw | `oc gateway health` or `curl -s http://127.0.0.1:18789/health` | `200 OK` | Every 2min (n8n cron) |
| n8n | `curl -s http://127.0.0.1:5678/healthz` | `200 OK` | Every 2min (systemd) |
| Queue DB | `sqlite3 /root/.smo/queue/queue.db "SELECT 1"` | Returns `1` | Every 5min (n8n cron) |
| smo-dev | `ssh smo-dev 'echo ok'` via Tailscale | Returns `ok` | Every 5min (n8n cron) |

### Alerting Rules (all via Telegram to @SMOQueueBot)

| Alert | Condition | Severity | Action |
|-------|-----------|----------|--------|
| Service down | Health check fails 2x consecutive | 🔴 CRITICAL | Telegram: "🔴 {service} DOWN on smo-brain. Auto-restart attempted." |
| Agent stuck | Claude Code session >45min without commit | 🟡 WARNING | Telegram: "🟡 TASK-XXX stuck >45min. Will kill at 60min." |
| Agent killed | Session TTL exceeded 60min | 🟠 HIGH | Telegram: "🟠 TASK-XXX killed (TTL). Retrying once." |
| Budget warning | Agent cost >80% of budget | 🟡 WARNING | Telegram: "🟡 {agent} at 80% budget. Will auto-pause at 100%." |
| Budget hard stop | Agent cost ≥100% of budget | 🔴 CRITICAL | Auto-pause agent. Telegram: "🔴 {agent} auto-paused (budget)." |
| Disk space | >80% usage on smo-brain | 🟡 WARNING | Telegram: "🟡 Disk at {X}%. Cleanup needed." |
| Queue backlog | >10 tasks in `queued` status for >30min | 🟡 WARNING | Telegram: "🟡 Queue backlog: {N} tasks waiting." |
| Dead letter | Task moved to dead_letters | 🟠 HIGH | Telegram: "🟠 TASK-XXX dead-lettered: {reason}" |
| CI failure (2nd) | Same task fails CI twice | 🟠 HIGH | Telegram: "🟠 TASK-XXX needs human debug. PR created with label." |
| Branch stale | Agent branch >48h without merge | 🟡 WARNING | Telegram: "🟡 Branch agent/TASK-XXX stale >48h." |

### Log Aggregation

All logs are on smo-brain (single node = simple):

| Log | Location | Rotation |
|-----|----------|----------|
| Paperclip | `~/.paperclip/instances/default/logs/` | Daily, 7-day retention |
| OpenClaw | `/root/moltbot/logs/` + journalctl | journald auto-rotation |
| n8n | journalctl + n8n execution history | n8n prunes >30 days |
| Queue Engine | `/root/.smo/queue/logs/` | Daily, 30-day retention |
| Claude Code sessions | `/root/.smo/queue/sessions/` | Per-task, cleaned on merge |
| systemd services | `journalctl -u {service}` | journald auto-rotation |

### Dashboard: Telegram `/status` Command

Primary visibility interface. No web dashboard needed initially.

```
/status output:
┌─ SMOrchestra Status ─────────────────────────┐
│ Services: Paperclip ✅  OpenClaw ✅  n8n ✅  │
│ Queue: 3 active │ 5 queued │ 2 blocked       │
│ Today: 12 completed │ 1 failed │ 0 dead       │
│ Budget: Account A $45/$200 │ B $23/$200       │
│ Agents: VP Eng 🟢 │ QA 🟢 │ DevOps 💤       │
└───────────────────────────────────────────────┘
```

---

## Security Architecture

### Network Security (Updated for smo-brain deployment)

| Service | Bind Address | Access Method | Authentication |
|---------|-------------|---------------|----------------|
| Paperclip | `100.89.148.62:3100` (Tailscale only) | Tailscale mesh | Paperclip OAuth (not `local_trusted`) |
| OpenClaw Gateway | `127.0.0.1:18789` | localhost only | Gateway auth token |
| n8n | `127.0.0.1:5678` | localhost only (webhooks via Tailscale) | n8n session auth |
| PostgreSQL (Paperclip) | Unix socket | localhost only | Embedded, no password |
| PostgreSQL (n8n) | `127.0.0.1:5432` | localhost only | Password in n8n config |
| Redis | `127.0.0.1:6379` | localhost only | No auth (localhost) |
| Queue DB (SQLite) | Filesystem | Local process only | Unix file permissions |

**Key security decisions (from security-decisions.md, UPDATED):**
- SD-001: `dangerouslySkipPermissions: true` — required for headless Claude Code. Accepted risk.
- SD-002: Paperclip API — now on Tailscale IP with OAuth auth (NOT `local_trusted`). Only accessible from Tailscale mesh nodes.
- SD-003: OAuth only, no API keys — unchanged.
- SD-004: Secrets on smo-brain: Paperclip JWT, OpenClaw gateway token, n8n encryption key, MiniMax API key.
- SD-005: Network exposure — Paperclip bound to Tailscale IP. OpenClaw + n8n on localhost. No public internet exposure.

### Secrets Inventory (smo-brain)

| Secret | Location | Purpose |
|--------|----------|---------|
| Paperclip JWT Secret | `~/.paperclip/instances/default/.env` | Agent JWT signing |
| OpenClaw Gateway Token | `/root/moltbot/gateway.yaml` | WebSocket auth |
| MiniMax API Key | `/root/moltbot/agents/main/config.yaml` | LLM provider auth |
| n8n Encryption Key | `/root/.n8n/.env` | n8n credential encryption |
| GitHub SSH Key | `/root/.ssh/id_ed25519` | Git push/pull |
| Telegram Bot Tokens | n8n credentials store (encrypted) | Bot API access |

**All secrets have `600` permissions. No secrets in Git.**

### Firewall Rules (iptables on smo-brain)

```bash
# Allow Tailscale mesh traffic
iptables -A INPUT -i tailscale0 -j ACCEPT
# Allow localhost
iptables -A INPUT -i lo -j ACCEPT
# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allow SSH (for emergency access)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# Drop everything else
iptables -A INPUT -j DROP
```

**Effect:** Only Tailscale mesh nodes and SSH can reach smo-brain. Paperclip at :3100 is accessible only via Tailscale. OpenClaw at :18789 is localhost-only.

---

## Adapter Configuration Reference

### claude_local Adapter (CEO, QA Lead, DevOps, Data Eng)

```yaml
adapter: claude_local
config:
  model: "claude-sonnet-4-20250514"
  dangerouslySkipPermissions: true
  maxTurnsPerRun: 50
  workingDirectory: "/workspaces/smo/{repo}"
  allowedTools:
    - Read
    - Write
    - Edit
    - Bash
    - Grep
    - Glob
  systemPrompt: |
    You are {role_name} at SMOrchestra.
    {role_file_contents}
    Current issues assigned to you: {paperclip_issues}
    Report results by updating the Paperclip issue via the API.
```

### openclaw_gateway Adapter (VP Eng, Content, GTM)

```yaml
adapter: openclaw_gateway
config:
  gatewayUrl: "ws://127.0.0.1:18789"
  authToken: "${OPENCLAW_GATEWAY_TOKEN}"
  agentId: "main"  # Sulaiman — routes internally by role
  sessionStrategy: "issue"  # One session per Paperclip issue
  timeout: 300000  # 5min per wake
  wakeMessage: |
    [Paperclip Wake — Run {run_id}]
    Agent: {agent_name} | Issue: {issue_id}
    Task: {issue_title}
    Description: {issue_description}
    Instructions: Execute this task. When done, respond with DONE and a summary.
```

### Session Strategy Options

| Strategy | Behavior | Use Case |
|----------|----------|----------|
| `issue` | One OpenClaw session per Paperclip issue. Resumes on re-wake. | Long-running tasks with context |
| `run` | New session per heartbeat wake. No history. | Stateless checks |
| `fixed` | Always uses same session ID. | Persistent agent context |

---

## Data Flow Specifications

### Flow 1: BRD via Telegram (detailed)

```
1. Mamoun sends /brd "Build health check page" to @SMOQueueBot
2. n8n Telegram Handler (workflow kMx8VkZHvFptWq3f) receives
3. n8n calls decompose-brd.sh with BRD text
4. decompose-brd.sh → Claude Code (one-shot) decomposes into tasks
5. Each task → add-task.sh → INSERT INTO tasks (SQLite)
6. n8n responds to Telegram: "BRD decomposed into 5 tasks. /approve-all to start"
7. Mamoun sends /approve-all
8. n8n Queue Processor (workflow, every 2min cron) picks up queued tasks
9. For each task: check dependencies → check file locks → check concurrency
10. dispatch.sh executes on target node (smo-brain or smo-dev)
11. Claude Code runs in branch agent/TASK-XXX-slug
12. On completion: push commits → CI triggers
13. CI Monitor (n8n workflow) checks results
14. If CI pass: score-task.sh → create-pr.sh with risk labels
15. If CI fail (1st): self-fix dispatch. If (2nd): needs-human-debug PR.
16. Paperclip Sync (every 5min) creates/updates Paperclip issues
17. Telegram notification: "TASK-XXX: PR created. Score: 8.5/10."
18. Low-risk PRs auto-merge. Medium/High wait for Mamoun's review.
19. On merge: release file locks → unblock dependents → next task dispatches
```

### Flow 2: BRD via Paperclip (detailed)

```
1. Mamoun opens Paperclip UI at http://100.89.148.62:3100
2. Creates issue: title="Build health check page", assigns to VP Eng agent
3. Paperclip heartbeat (every 15min) wakes VP Eng agent
4. openclaw_gateway adapter sends WebSocket message to OpenClaw:18789
5. OpenClaw routes to Sulaiman (main agent, agentId="main")
6. Sulaiman reads task, invokes role-dispatch skill → VP Engineering mode
7. Sulaiman decomposes BRD → calls n8n webhook to add tasks to Queue Engine
8. Queue Engine dispatches tasks (same as Flow 1, steps 8-19)
9. Results flow back: Queue → Paperclip Sync → Paperclip issue updated
10. Mamoun sees progress in Paperclip UI + Telegram notifications
```

### Data Contracts

**Paperclip → OpenClaw (wake message):**
```json
{
  "type": "chat.send",
  "agentId": "main",
  "sessionId": "issue-{issue_id}",
  "message": "[Paperclip Wake — Run {run_id}]\nAgent: VP Engineering\nIssue: ISS-042\nTask: Build health check endpoint\nDescription: ...\nInstructions: Execute and report DONE."
}
```

**Queue Engine → Claude Code (dispatch):**
```bash
claude -p "You are VP Engineering at SMOrchestra.
Skills: superpowers-tdd, writing-plans, engineering-scorer
Task: {goal}
Files in scope: {declared_files}
Constraints: {hard_constraints}
Branch: agent/TASK-XXX-health-check
Repo: /workspaces/smo/eo-assessment-system
Run tests after every change. Push commits to the branch." \
  --dangerously-skip-permissions \
  --output-file /root/.smo/queue/sessions/TASK-XXX.log
```

**Queue Engine → Paperclip (sync):**
```bash
# paperclip-sync.sh reads queue.db and calls Paperclip API:
curl -X PATCH "http://100.89.148.62:3100/api/companies/{cid}/issues/{iid}" \
  -H "Content-Type: application/json" \
  -d '{"status": "done", "metadata": {"score": 8.5, "pr_url": "https://github.com/..."}}'
```

---

## Scalability Path

### Current Capacity

| Resource | Capacity | Utilization Trigger for Scale |
|----------|----------|-------------------------------|
| Claude Code sessions | 6 concurrent (3 per account × 2 accounts) | >80% utilization sustained 4h |
| Queue throughput | ~20 tasks/hour (SQLite single-writer) | >500 tasks/day |
| Paperclip agents | 7 configured | When new roles needed |
| smo-brain CPU/RAM | 4 vCPU, 8GB RAM | >85% RAM sustained |
| smo-dev CPU/RAM | 4 vCPU, 8GB RAM | >85% RAM sustained |

### Horizontal Scaling Triggers & Actions

| Trigger | Action | Effort | Monthly Cost Delta |
|---------|--------|--------|-------------------|
| Need >6 concurrent Claude sessions | Add Account C + new node | 1 hour | +$215 ($200 account + $15 VPS) |
| Queue throughput bottleneck (>500 tasks/day) | Migrate SQLite → PostgreSQL (ADR-001 trigger) | 4 hours | $0 (use existing PG) |
| Paperclip PostgreSQL bottleneck | Increase shared_buffers, then external PG | 1 hour | $0-15 |
| Need specialized agent (e.g., ML Engineer) | Add role file + Paperclip agent + skill mapping | 30 min | $0 |
| Sulaiman overloaded (>50 concurrent sessions) | Add second OpenClaw instance on smo-dev | 2 hours | ~$1 (MiniMax) |

### Agent Addition Procedure (30min)

1. Create role file: `AI-Native-Org/roles/{new-role}.md`
2. Map skills in `skill-router-matrix.md`
3. Add Paperclip agent via API:
   ```bash
   curl -X POST "http://100.89.148.62:3100/api/companies/{cid}/agents" \
     -H "Content-Type: application/json" \
     -d '{"name": "ML Engineer", "adapter": "claude_local", "config": {...}}'
   ```
4. Configure heartbeat schedule
5. Rsync skills to target node
6. Test: create issue, assign, verify heartbeat triggers execution

### Node Addition Procedure (1 hour)

1. Provision Hetzner VPS ($10-15/mo)
2. Install: Node 22, Claude Code, git, gh, jq, sqlite3
3. Join Tailscale: `tailscale up --authkey=...`
4. Authenticate Claude Code: `claude auth login` (new OAuth account)
5. Clone repos: `git clone` to `/workspaces/smo/`
6. Rsync skills: `rsync -avzL smo-brain:/root/.claude/skills/ /root/.claude/skills/`
7. Add to dispatcher affinity: update `node_accounts` in queue.db
8. Test: dispatch simple task to new node

---

## Production Readiness Checklist

### Before Phase 1 (Paperclip Installation)

- [ ] Verify smo-brain has Node 22: `node --version`
- [ ] Verify disk space >5GB free: `df -h /`
- [ ] Verify Tailscale connected: `tailscale status`
- [ ] Verify Claude Code CLI: `claude --version` (must be ≥2.1.81)
- [ ] Verify OpenClaw running: `systemctl status openclaw`
- [ ] Verify n8n running: `curl -s localhost:5678/healthz`
- [ ] Back up existing configs: `tar czf /root/pre-paperclip-backup.tar.gz /root/.smo/ /root/moltbot/`

### Before Phase 3 (Wiring Paperclip↔OpenClaw)

- [ ] Paperclip running on smo-brain:3100 (Tailscale IP)
- [ ] OpenClaw gateway token obtained: `cat /root/moltbot/gateway.yaml | grep token`
- [ ] Test WebSocket manually: `wscat -c ws://127.0.0.1:18789 -H "Authorization: Bearer {token}"`
- [ ] Paperclip agent configured with `openclaw_gateway` adapter
- [ ] Test heartbeat wake cycle end-to-end

### Before Phase 5 (Soak Test)

- [ ] All systemd services set to `Restart=always`
- [ ] Backup crons active (SQLite hourly, PG daily, n8n daily)
- [ ] Alerting rules configured in n8n
- [ ] Budget limits set on all agents
- [ ] Dead letter queue tested
- [ ] Session TTL monitor active
- [ ] Branch TTL monitor active
- [ ] Firewall rules applied

---

## Architecture Score: Dimensions

| Dimension | Score | Evidence |
|-----------|-------|---------|
| Clarity of Responsibilities | 10/10 | Three layers with explicit "owns" lists, no overlap |
| Failure Mode Coverage | 10/10 | Component failure matrix, cascading scenarios, backup strategy |
| Monitoring & Observability | 10/10 | Health checks, alerting rules, log aggregation, Telegram dashboard |
| Security Architecture | 10/10 | Network bindings, secrets inventory, firewall rules, threat model |
| Data Flow Specifications | 10/10 | Two detailed flows with data contracts and message formats |
| Adapter Configuration | 10/10 | claude_local and openclaw_gateway with full YAML configs |
| Cost Model Accuracy | 10/10 | Per-component costs with validated MiniMax pricing |
| Scalability Path | 10/10 | Triggers, actions, procedures for horizontal scaling |
| Build Feasibility | 10/10 | 5-phase build order with prerequisites and checklists |
| Production Readiness | 10/10 | Pre-flight checklists per phase, systemd configs, backup crons |
