# Paperclip Deep Research: Architecture, Adapters, OpenClaw Integration, and SMOrchestra Deployment

**Date:** 2026-03-30
**Business Line:** SMOrchestra.ai (Infrastructure Layer)
**Source:** Local source code analysis of Paperclip v1 at `/Users/mamounalamouri/Desktop/cowork-workspace/paperclip/`
**Official Docs:** https://paperclip.ing/docs | GitHub: https://github.com/paperclipai/paperclip

---

## 1. What Paperclip Actually Is

Paperclip is **not** a dashboard, a chatbot, a workflow builder, or an agent framework. It is a **company operating system for AI agent workforces**.

The README states it clearly: *"If OpenClaw is an employee, Paperclip is the company."*

Paperclip is a Node.js server + React UI that provides:

### Core Primitives

| Primitive | Purpose | Implementation |
|-----------|---------|----------------|
| **Company** | Top-level isolation unit. Each company has its own agents, goals, budgets, issues, projects. One Paperclip deployment supports unlimited companies. | `Company` type: id, name, status (active/paused/archived), issuePrefix, budgetMonthlyCents, spentMonthlyCents, requireBoardApprovalForNewAgents |
| **Agent** | An employee in the company. Has a role, title, adapter type, budget, reporting chain. | `Agent` type: role (ceo/cto/cmo/cfo/engineer/designer/pm/qa/devops/researcher/general), reportsTo, adapterType, adapterConfig, budgetMonthlyCents, spentMonthlyCents, permissions |
| **Org Chart** | Hierarchical reporting structure. Agents have `reportsTo` fields and `chainOfCommand` ancestry. | `AgentChainOfCommandEntry[]` traces from agent up to CEO |
| **Goals** | Hierarchical goal tree: company > team > agent > task. Every task traces back to the mission. | `Goal` type: level (company/team/agent/task), parentId, ownerAgentId, status (planned/active/achieved/cancelled) |
| **Issues (Tickets)** | Work units assigned to agents. Statuses: backlog/todo/in_progress/in_review/done/blocked/cancelled. Atomic checkout prevents double-work. | Issue priorities: critical/high/medium/low. Single-assignee model with atomic checkout semantics. |
| **Projects** | Group issues under a project with workspaces (git repos). | Projects have statuses (backlog/planned/in_progress/completed/cancelled) and workspace directories |
| **Heartbeats** | Scheduled wake cycles that trigger agents to check for work. | Timer-based with configurable intervalSec per agent |
| **Budgets** | Cost control per agent, project, or company. Hard stops auto-pause agents. | BudgetPolicy with scopes, metrics (billed_cents), windows (calendar_month_utc/lifetime), warn/hard-stop thresholds |
| **Governance** | Approval gates for hires, strategy, budget overrides. You (the human) are the board. | ApprovalType: hire_agent, approve_ceo_strategy, budget_override_required |
| **Routines** | Scheduled recurring tasks (cron-like). | Trigger kinds: schedule/webhook/api. Concurrency policies: coalesce_if_active/always_enqueue/skip_if_active |

### Architecture: Control Plane + Execution Services

Paperclip has exactly two layers:

1. **Control Plane** (the Paperclip server): Manages the registry, org chart, task assignment, budgets, goals, governance, heartbeat scheduling, and monitoring.
2. **Execution Services** (adapters): Agents run externally. Adapters connect different runtimes to the control plane. The control plane does NOT run agents -- it orchestrates them.

---

## 2. Agent Adapters in Paperclip

Paperclip supports **10 adapter types** as of the current codebase:

### Adapter Registry (from `server/src/adapters/registry.ts`)

| Adapter Type | Category | How It Works | Local JWT | Session Support | Skills Support |
|-------------|----------|--------------|-----------|-----------------|----------------|
| `claude_local` | Local process | Spawns Claude Code CLI as a child process on the same machine. Manages sessions, skills, quotas. | Yes | Yes (session codec) | Yes (list + sync) |
| `codex_local` | Local process | Spawns OpenAI Codex CLI locally. Similar to claude_local. | Yes | Yes | Yes |
| `cursor` | Local process | Spawns Cursor editor agent locally. | Yes | Yes | Yes |
| `gemini_local` | Local process | Spawns Gemini CLI locally. | Yes | Yes | Yes |
| `opencode_local` | Local process | Spawns OpenCode CLI locally. | Yes | Yes | Yes |
| `pi_local` | Local process | Spawns Pi CLI locally. | Yes | Yes | Yes |
| `hermes_local` | Local process | Hermes agent adapter. | Yes | Yes | Yes |
| `openclaw_gateway` | **Remote WebSocket** | Connects to OpenClaw via WebSocket gateway protocol. Sends tasks over the wire. Does NOT spawn a local process. | **No** | Via gateway sessionKey | No skills sync |
| `process` | Generic process | Spawns any arbitrary process (shell command). Fallback for unknown types. | - | - | - |
| `http` | HTTP webhook | Sends HTTP requests to an external endpoint. | - | - | - |

### Key Distinction: Local vs. Remote Adapters

**Local adapters** (`claude_local`, `codex_local`, etc.):
- Spawn a child process on the SAME machine as Paperclip
- Use local JWT for authentication
- Support session persistence (agent resumes context across heartbeats)
- Support skill listing and syncing
- The set `SESSIONED_LOCAL_ADAPTERS` includes: claude_local, codex_local, cursor, gemini_local, opencode_local, pi_local

**Remote adapters** (`openclaw_gateway`, `http`):
- Connect to agents running on OTHER machines
- `openclaw_gateway` uses WebSocket protocol to talk to a remote OpenClaw instance
- `http` sends HTTP requests to an external URL
- No local process management -- agent lifecycle is managed by the remote system

---

## 3. OpenClaw Gateway Adapter: Deep Dive

The `openclaw_gateway` adapter is the bridge between Paperclip (company layer) and OpenClaw (agent execution layer). It lives at `packages/adapters/openclaw-gateway/`.

### How It Works

1. **Transport:** Always WebSocket (`ws://` or `wss://`). Never HTTP.

2. **Connection Flow (Gateway Protocol v3):**
   ```
   Paperclip                    OpenClaw Gateway
      |                              |
      |-------- WS Connect --------->|
      |<-- event connect.challenge --|  (gateway sends nonce)
      |-------- req connect -------->|  (protocol/client/auth/device payload, signed)
      |<-------- res connect --------|  (connection established)
      |-------- req agent ---------->|  (message + sessionKey + idempotencyKey)
      |<-- event agent (streaming) --|  (transcript/progress events)
      |-------- req agent.wait ----->|  (wait for completion)
      |<-------- res agent.wait -----|  (result payload)
      |-------- WS Close ----------->|
   ```

3. **What Paperclip Sends to OpenClaw:**
   - `message`: A structured wake text containing the full Paperclip context (run ID, agent ID, company ID, task ID, issue ID, wake reason, linked issues) PLUS workflow instructions telling the OpenClaw agent exactly what API calls to make back to Paperclip
   - `sessionKey`: Resolved from strategy (per-issue, per-run, or fixed)
   - `idempotencyKey`: The Paperclip run ID
   - `agentId`: Optional, to target a specific OpenClaw agent
   - `paperclip` object: Full structured context (workspace, runtime services, etc.)

4. **Wake Text Content:** The adapter builds a detailed instruction payload that tells the OpenClaw agent:
   - What environment variables to set (PAPERCLIP_RUN_ID, PAPERCLIP_AGENT_ID, etc.)
   - How to authenticate back to Paperclip (Bearer token from claimed API key)
   - The exact workflow: GET /api/agents/me, checkout issue, read comments, execute, mark done
   - Which API endpoints are valid (prevents hallucinated endpoints)

5. **Auth Modes:**
   - `authToken` / `token` in adapter config
   - `headers.x-openclaw-token`
   - `headers.x-openclaw-auth` (legacy)
   - `password` (shared password mode)

6. **Device Auth (Ed25519):**
   - By default, the adapter sends a signed device payload with the connect request
   - Can use a configured `devicePrivateKeyPem` for a stable device identity
   - Otherwise generates an ephemeral Ed25519 keypair per run
   - Supports `autoPairOnFirstConnect` (default: true) for automatic device pairing

7. **Session Strategy:**
   - `issue`: Session key = `paperclip:issue:{issueId}` (default). Same issue = same session = context continuity.
   - `run`: Session key = `paperclip:run:{runId}`. Fresh session each run.
   - `fixed`: Uses configured `sessionKey` value.

### What OpenClaw Gateway Adapter Does NOT Do

- Does NOT list/sync skills (unlike local adapters)
- Does NOT support local agent JWT authentication
- Does NOT manage the OpenClaw process lifecycle
- Does NOT have visibility into OpenClaw's internal agent roster -- it sends a message and gets back a result

---

## 4. Hierarchy: Paperclip + OpenClaw Integration Model

### The Stack

```
+--------------------------------------------------+
|              YOU (Human Board Member)             |
|          Approve hires, override strategy,        |
|          set budgets, pause/terminate agents       |
+--------------------------------------------------+
                        |
+--------------------------------------------------+
|               PAPERCLIP (Company Layer)           |
|  - Company definition, goals, org chart           |
|  - Budget enforcement, governance, approvals      |
|  - Issue/ticket management, project tracking      |
|  - Heartbeat scheduling, cost tracking            |
|  - Activity audit log                             |
+--------------------------------------------------+
        |              |              |
   claude_local   openclaw_gw     http
   (local CLI)    (WebSocket)    (webhook)
        |              |              |
+------------+  +------------+  +----------+
| Claude Code|  | OpenClaw   |  | External |
| on same    |  | Gateway on |  | Service  |
| machine    |  | smo-brain  |  |          |
+------------+  +------------+  +----------+
                       |
                +------------+
                | OpenClaw   |
                | Internal   |
                | Agents     |
                | (multiple) |
                +------------+
```

### How Delegation Works

1. **Paperclip CEO Agent** (e.g., claude_local or openclaw_gateway adapter) receives a heartbeat wake
2. CEO checks for assigned issues or reviews company goals
3. CEO can create new issues and assign them to other Paperclip agents (engineer, designer, etc.)
4. Each Paperclip agent has its own adapter -- some are local CLIs, some point to OpenClaw
5. When a Paperclip agent with `openclaw_gateway` adapter gets a heartbeat, Paperclip:
   - Opens a WebSocket to the configured OpenClaw gateway URL
   - Sends the full context (issue details, wake reason, linked issues)
   - OpenClaw receives the message and routes it to the appropriate internal agent
   - The OpenClaw agent executes, calling back to Paperclip's API as needed
   - Results stream back over the WebSocket
   - Paperclip records the outcome (success/failure, cost, logs)

### Reporting/Accountability Flow

- **Up:** OpenClaw agent results flow back through the gateway WebSocket to Paperclip. Paperclip records run status, logs, cost, and updates the issue status.
- **Down:** Paperclip sends structured wake events with full context. The wake text includes explicit API workflow instructions.
- **Audit:** Every heartbeat run is tracked with: invocation source, trigger detail, status, start/finish times, exit code, usage (tokens), session IDs, log storage references, stdout/stderr excerpts.

### Visibility Limitation

**Paperclip CANNOT see inside OpenClaw's internal agent roster.** The `openclaw_gateway` adapter treats OpenClaw as a black box:
- Paperclip sends a message (optionally targeting a specific `agentId`)
- OpenClaw routes internally and returns results
- Paperclip sees the output, cost, and completion status -- but not which internal OpenClaw agent handled it or what sub-tasks were created inside OpenClaw

To get finer control, you would create **separate Paperclip agents** (one per logical role) each pointing to the same OpenClaw gateway but with different `agentId` values in their adapter config.

---

## 5. Where Should Paperclip Run?

### Current Local Config (Your Desktop)

Your Paperclip is currently configured at `/Users/mamounalamouri/.paperclip/instances/default/config.json`:
- **Deployment mode:** `local_trusted` (no auth required, trusts all local requests)
- **Host:** `127.0.0.1:3100` (localhost only)
- **Exposure:** `private`
- **Database:** Embedded PostgreSQL on port 54329
- **Storage:** Local disk at `~/.paperclip/instances/default/data/storage`

### Can Paperclip Manage Remote Agents?

**Yes, absolutely.** This is the core design:

- **Local adapters** (claude_local, codex_local, etc.) spawn processes on the same machine. These REQUIRE Paperclip to run on the same machine as the agent runtime.
- **Remote adapters** (openclaw_gateway, http) connect over the network. These work across machines, across Tailscale, across the internet.
- **Mixed mode** is the intended use: some agents are local (CEO on your desktop), some are remote (engineers on smo-brain).

### Deployment Options

| Option | Paperclip Location | Local Agents | Remote Agents | Access |
|--------|-------------------|--------------|---------------|--------|
| **Desktop (current)** | Your Mac | Claude Code, Cursor on desktop | OpenClaw on smo-brain via Tailscale | localhost:3100 |
| **smo-brain** | Hetzner VPS | Claude Code on smo-brain | OpenClaw on same machine (localhost) | Tailscale IP:3100 |
| **Dedicated node** | Any server | None | All agents via openclaw_gateway/http | Tailscale or public URL |

### For Tailscale Access

If you want to access Paperclip from your phone or other machines:
1. Change `server.host` from `127.0.0.1` to `0.0.0.0`
2. Paperclip will be accessible on your Tailscale IP
3. For production: switch `deploymentMode` to `authenticated` and set `auth.publicBaseUrl`
4. The FAQ specifically mentions: *"If you're a solo-entrepreneur you can use Tailscale to access Paperclip on the go."*

---

## 6. Heartbeat System: Deep Dive

### What a Heartbeat Is

A heartbeat is a scheduled wake cycle for an agent. It is NOT a health check -- it is an execution trigger. When a heartbeat fires, the agent wakes up, checks for work, and acts.

### Heartbeat Policy (Per-Agent Configuration)

Stored in `agent.runtimeConfig.heartbeat`:

```json
{
  "heartbeat": {
    "enabled": true,
    "intervalSec": 3600,
    "cooldownSec": 10,
    "wakeOnOnDemand": true,
    "wakeOnAssignment": true,
    "wakeOnAutomation": true,
    "maxConcurrentRuns": 1
  }
}
```

| Field | Purpose | Default |
|-------|---------|---------|
| `enabled` | Whether heartbeats fire for this agent | `true` |
| `intervalSec` | Seconds between scheduled heartbeats | `0` (disabled unless set) |
| `wakeOnDemand` | Wake when manually triggered or on task assignment | `true` |
| `maxConcurrentRuns` | Max simultaneous runs for this agent (1-10) | `1` |

### What `schedulerActive` Means

From the source code (`server/src/routes/agents.ts` line 908):

```typescript
schedulerActive: statusEligible && policy.enabled && policy.intervalSec > 0
```

`schedulerActive` is `true` when ALL of:
1. Agent status is NOT paused, terminated, or pending_approval
2. Heartbeat is enabled in the agent's runtime config
3. intervalSec is greater than 0

This is a computed field shown in the UI -- it means "this agent will receive scheduled heartbeat ticks."

### How the Scheduler Tick Works

The server (`server/src/index.ts`) runs a `setInterval` loop:

1. **Every tick** (default interval from the server loop), `heartbeat.tickTimers(now)` is called
2. `tickTimers` queries ALL agents from the database
3. For each agent:
   - Skip if status is paused/terminated/pending_approval
   - Parse heartbeat policy; skip if disabled or intervalSec <= 0
   - Calculate elapsed time since `lastHeartbeatAt` (or `createdAt` if never run)
   - If `elapsed >= intervalSec * 1000`, enqueue a wakeup request
4. The wakeup request creates a heartbeat run record and triggers the adapter's `execute()` function
5. For local adapters: spawns the CLI process
6. For openclaw_gateway: opens WebSocket and sends the task

### Heartbeat Run Lifecycle

```
queued -> running -> succeeded | failed | cancelled | timed_out
```

Each run tracks:
- Invocation source: `timer` | `assignment` | `on_demand` | `automation`
- Trigger detail: `manual` | `ping` | `callback` | `system`
- Session continuity: `sessionIdBefore` / `sessionIdAfter`
- Cost: token usage (input/output/cached), cost in cents
- Logs: stored in run log store with SHA256 integrity hashes
- Process details: PID, start time, exit code, signal

### Wakeup Request Sources

| Source | When It Fires |
|--------|--------------|
| `timer` | Scheduled heartbeat interval elapsed |
| `assignment` | A new task was assigned to the agent |
| `on_demand` | Manual trigger from the UI or API |
| `automation` | Routine or webhook trigger |

---

## 7. Budget/Governance System

### How Budgets Work

Paperclip has a real budget enforcement system, not just a display counter.

### Budget Policies

A `BudgetPolicy` can be scoped to:
- **Company** level: total spend across all agents
- **Agent** level: individual agent spend cap
- **Project** level: spend limit for a project

Each policy defines:
- `metric`: Currently only `billed_cents` (cost in USD cents)
- `windowKind`: `calendar_month_utc` (resets monthly) or `lifetime` (cumulative)
- `amount`: Budget limit in the metric unit
- `warnPercent`: Threshold for warning (default soft alert)
- `hardStopEnabled`: When true, agent is AUTO-PAUSED when budget is exceeded
- `notifyEnabled`: Send notifications on threshold breach

### Budget Enforcement Flow

1. After each heartbeat run, Paperclip calculates normalized token usage and cost
2. Cost is recorded as a `costEvent` in the database
3. Budget service checks all applicable policies for the scope
4. If `observedAmount >= amount` and `hardStopEnabled`:
   - Agent status is set to `paused`
   - `pauseReason` is set to `budget`
   - A `BudgetIncident` is created with status `open`
   - Active work for the agent is cancelled
5. You (board member) can resolve the incident by:
   - `keep_paused`: Agent stays paused
   - `raise_budget_and_resume`: Increase budget and unpause

### Legacy Budget (Agent-Level)

Each agent also has a simpler `budgetMonthlyCents` / `spentMonthlyCents` field directly on the agent record. This predates the full policy system but is still tracked.

### Governance Approvals

Three approval types exist:
- `hire_agent`: When `requireBoardApprovalForNewAgents` is true on the company, new agent hires require your approval
- `approve_ceo_strategy`: CEO strategy changes require board approval
- `budget_override_required`: Budget overrides need approval

Approval statuses: pending > revision_requested > approved | rejected | cancelled

### What This Means Practically

Paperclip ACTUALLY tracks spend. It is not decorative. When an agent runs, the adapter reports token usage, Paperclip calculates cost based on model pricing, and the budget system enforces limits. This is critical for SMOrchestra because it means you can set a $50/month budget on an engineer agent and it will auto-pause rather than burning through tokens.

---

## 8. Recommended Architecture: 3-Node Tailscale Mesh

Based on all the above analysis, here is how Paperclip and OpenClaw should work together across your infrastructure.

### Node Roles

| Node | Tailscale Name | IP (example) | Role |
|------|---------------|--------------|------|
| **Desktop (Mac)** | `desktop` | 100.x.x.1 | Paperclip server (control plane), CEO agent (claude_local), dev workspace |
| **smo-brain** | `smo-brain` | 100.x.x.2 | OpenClaw gateway (agent execution), n8n, production services |
| **smo-dev** | `smo-dev` | 100.x.x.3 | Dev/staging OpenClaw instance, CI/CD, testing |

### Architecture Diagram

```
                    TAILSCALE MESH (100.x.x.0/24)
  +------------------------------------------------------------+
  |                                                            |
  |  DESKTOP (100.x.x.1)          smo-brain (100.x.x.2)      |
  |  +----------------------+     +------------------------+   |
  |  | PAPERCLIP            |     | OPENCLAW GATEWAY       |   |
  |  | localhost:3100        |     | ws://smo-brain:4200    |   |
  |  |                      |     |                        |   |
  |  | Company: SMOrchestra |     | Agents:                |   |
  |  |                      |     |  - smo-engineer        |   |
  |  | CEO Agent            |     |  - smo-researcher      |   |
  |  |  type: claude_local  |     |  - smo-devops          |   |
  |  |  (runs on desktop)   |     |  - smo-content         |   |
  |  |                      |     +------------------------+   |
  |  | Engineer Agent       |              ^                   |
  |  |  type: openclaw_gw   |              |                   |
  |  |  url: ws://smo-brain |   WebSocket  |                   |
  |  |  :4200               +--------------+                   |
  |  |                      |                                  |
  |  | Researcher Agent     |     smo-dev (100.x.x.3)         |
  |  |  type: openclaw_gw   |     +------------------------+  |
  |  |  url: ws://smo-dev   |     | OPENCLAW (staging)     |  |
  |  |  :4200               +---->| ws://smo-dev:4200      |  |
  |  |                      |     |                        |  |
  |  | QA Agent             |     | Agents:                |  |
  |  |  type: claude_local  |     |  - smo-qa-runner       |  |
  |  |  (runs on desktop)   |     |  - smo-staging-test    |  |
  |  +----------------------+     +------------------------+  |
  |                                                            |
  +------------------------------------------------------------+
```

### Configuration: Paperclip Server

Update `/Users/mamounalamouri/.paperclip/instances/default/config.json`:

```json
{
  "server": {
    "deploymentMode": "authenticated",
    "exposure": "private",
    "host": "0.0.0.0",
    "port": 3100,
    "allowedHostnames": ["smo-brain", "smo-dev", "desktop"],
    "serveUi": true
  },
  "auth": {
    "baseUrlMode": "explicit",
    "publicBaseUrl": "http://100.x.x.1:3100"
  }
}
```

This makes Paperclip accessible from any Tailscale node while requiring authentication.

### Configuration: OpenClaw Gateway Agent in Paperclip

For each Paperclip agent that delegates to OpenClaw, configure:

```json
{
  "adapterType": "openclaw_gateway",
  "adapterConfig": {
    "url": "ws://smo-brain:4200",
    "authToken": "<openclaw-gateway-token>",
    "agentId": "smo-engineer",
    "sessionKeyStrategy": "issue",
    "timeoutSec": 300,
    "autoPairOnFirstConnect": true,
    "paperclipApiUrl": "http://100.x.x.1:3100"
  },
  "runtimeConfig": {
    "heartbeat": {
      "enabled": true,
      "intervalSec": 1800,
      "maxConcurrentRuns": 1
    }
  }
}
```

Key fields:
- `url`: WebSocket URL of the OpenClaw gateway on smo-brain (over Tailscale)
- `agentId`: Which OpenClaw agent should handle this Paperclip agent's tasks
- `paperclipApiUrl`: How the OpenClaw agent calls back to Paperclip (Tailscale IP)
- `sessionKeyStrategy: "issue"`: Same issue = same session = context continuity

### Configuration: CEO Agent (Local)

The CEO agent runs locally on your desktop as `claude_local`:

```json
{
  "adapterType": "claude_local",
  "adapterConfig": {
    "model": "claude-sonnet-4-20250514"
  },
  "runtimeConfig": {
    "heartbeat": {
      "enabled": true,
      "intervalSec": 3600,
      "maxConcurrentRuns": 1
    }
  }
}
```

### Data Flow

1. **Heartbeat fires** for CEO agent -> Paperclip spawns Claude Code locally
2. CEO reviews company goals, checks for new issues, creates tasks for engineers
3. **Heartbeat fires** for Engineer agent -> Paperclip opens WebSocket to smo-brain OpenClaw
4. OpenClaw receives the task, routes to `smo-engineer` agent
5. `smo-engineer` executes, calling Paperclip API over Tailscale to read issue details, post comments, update status
6. Result streams back over WebSocket to Paperclip
7. Paperclip records cost, updates issue status, logs activity

### Security Considerations

- **Tailscale** provides encrypted, authenticated mesh networking -- no public exposure needed
- `ws://` (not `wss://`) is acceptable over Tailscale since the tunnel is already encrypted
- However, the adapter warns about plaintext ws:// to non-loopback hosts -- this is cosmetic over Tailscale
- Use `authenticated` deployment mode for Paperclip so agents need API keys
- OpenClaw gateway auth uses token-based authentication

### Scaling Considerations

- **Desktop off:** If your Mac is asleep/off, Paperclip stops. Heartbeats stop. For 24/7 operation, move Paperclip to smo-brain.
- **Multiple OpenClaw instances:** You can point different Paperclip agents to different OpenClaw gateways (smo-brain for production, smo-dev for staging).
- **Budget isolation:** Set separate budgets per agent to prevent runaway costs on any single agent.
- **Multi-company:** You can run multiple companies in one Paperclip instance (e.g., one per client engagement).

---

## 9. Summary: What You Need to Know

| Question | Answer |
|----------|--------|
| What is Paperclip? | Company operating layer for AI agent workforces. Not a dashboard. |
| Can Paperclip manage OpenClaw? | Yes, via the `openclaw_gateway` adapter over WebSocket. |
| Does Paperclip see inside OpenClaw? | No. It sends tasks and gets results. OpenClaw is a black box. |
| Where should Paperclip run? | Your desktop for now (local_trusted). smo-brain for 24/7. |
| Do agents need to be on the same machine? | Local adapters: yes. openclaw_gateway/http: no, works over network. |
| Does Paperclip actually track costs? | Yes. Real budget enforcement with auto-pause on hard stops. |
| How do heartbeats work? | Timer loop checks intervalSec, enqueues wakeup, adapter executes. |
| What is schedulerActive? | Computed: agent not paused + heartbeat enabled + intervalSec > 0. |
| Can Paperclip run multiple companies? | Yes, with complete data isolation per company. |

---

## 10. Key Source Files Reference

| File | Purpose |
|------|---------|
| `packages/shared/src/constants.ts` | All enums: adapter types, roles, statuses, budget types |
| `packages/shared/src/types/agent.ts` | Agent type definition |
| `packages/shared/src/types/heartbeat.ts` | HeartbeatRun, AgentRuntimeState, WakeupRequest types |
| `packages/shared/src/types/budget.ts` | BudgetPolicy, BudgetIncident, BudgetOverview types |
| `packages/shared/src/types/goal.ts` | Goal hierarchy type |
| `packages/shared/src/config-schema.ts` | Paperclip server configuration schema (Zod) |
| `packages/adapters/openclaw-gateway/src/server/execute.ts` | OpenClaw gateway adapter execution logic |
| `packages/adapters/openclaw-gateway/README.md` | Gateway protocol documentation |
| `server/src/adapters/registry.ts` | Adapter registration and routing |
| `server/src/services/heartbeat.ts` | Core heartbeat scheduler, run management, session handling |
| `server/src/services/budgets.ts` | Budget policy enforcement, incident creation, auto-pause |
| `AGENTS.md` | Repository contribution and architecture guide |
| `doc/GOAL.md` | Paperclip vision and architecture overview |
