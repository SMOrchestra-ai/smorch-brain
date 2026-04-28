# OpenClaw Multi-Agent Orchestration: Deep Research Report

**Business line:** SMOrchestra.ai -- AI-Native Architecture
**Date:** 2026-03-30
**Source:** Live server inspection (smo-brain @ 100.89.148.62), OpenClaw source code (moltbot repo)

---

## 1. OpenClaw Agent System

### Architecture Overview

OpenClaw is a **gateway-centric agent orchestration platform**. It runs a persistent gateway server (WebSocket + HTTP) that manages one or more AI agents, each with their own identity, workspace, model configuration, session history, and skill set.

### Agent Structure

Each agent is a logical entity defined in `openclaw.json` under `agents.list[]` or via the default agent (`agents.defaults`). Key properties per agent:

| Property | Purpose |
|----------|---------|
| `id` | Unique identifier (normalized to lowercase). Default agent ID is `"main"`. |
| `name` | Display name (e.g., "Sulaiman") |
| `workspace` | Filesystem directory the agent operates in (default: `~/.openclaw/workspace`) |
| `agentDir` | Per-agent persistent state directory (`~/.openclaw/agents/{id}/agent/`) |
| `model` | Primary model + fallbacks (e.g., `openai-codex/gpt-5.4` with Google fallbacks) |
| `skills` | Skill filter -- which skills this agent can use |
| `identity` | Path to IDENTITY.md file defining persona |
| `subagents` | Configuration for spawning child agents |
| `sandbox` | Sandboxing policy for code execution |
| `tools` | Tool allowlist/denylist |

### Current smo-brain Configuration

The server currently runs a **single default agent** named "main" (identity: Sulaiman):

- **Primary model:** `openai-codex/gpt-5.4`
- **Fallbacks:** `google/gemini-3-pro-preview`, `google/gemini-2.5-flash-lite`, `google/gemini-2.5-flash`
- **Workspace:** `~/.openclaw/workspace`
- **Agent dir:** `~/.openclaw/agents/main/agent/`
- **Max concurrent:** 4 sessions, 8 subagents
- **Heartbeat:** every 45m, active hours 08:00-22:00 Asia/Dubai, uses `google/gemini-2.5-flash-lite`

### Multi-Agent Support

OpenClaw supports multiple named agents in the `agents.list[]` array. Each gets:

- Its own workspace directory
- Its own session store (`~/.openclaw/agents/{id}/sessions/`)
- Its own model configuration (can override defaults)
- Its own skill filter
- Its own identity/persona file

The system resolves which agent handles a message via the **routing system** (see Section 6).

---

## 2. OpenClaw Gateway

### What It Does

The gateway is the central nervous system. It is a WebSocket + HTTP server that:

1. **Accepts connections** from clients (CLI nodes, mobile apps, browser control UI, channel plugins)
2. **Routes messages** from channels (Telegram, Discord, Slack, web) to the correct agent
3. **Manages sessions** -- each conversation gets a persistent session with history
4. **Coordinates subagents** -- tracks spawned child agents, their lifecycle, and completion announcements
5. **Exposes HTTP API** -- OpenAI-compatible `/v1/chat/completions` endpoint, hooks endpoint, health checks
6. **Runs cron jobs** -- scheduled agent tasks
7. **Manages plugins** -- channel plugins, auth plugins

### Gateway Configuration (current)

```json
"gateway": {
  "mode": "local",
  "bind": "tailnet",
  "auth": { "token": "..." },
  "controlUi": {
    "allowedOrigins": ["http://localhost:18789", "http://127.0.0.1:18789", "http://100.89.148.62:18789"]
  }
}
```

- **Bind:** `tailnet` -- exposed on Tailscale network (accessible at `100.89.148.62:18789`)
- **Auth:** Token-based authentication for WebSocket connections
- **Control UI:** Web interface for managing sessions, viewing chat

### WebSocket Protocol

The gateway uses a custom binary/JSON WebSocket protocol (`PROTOCOL_VERSION` constant in `gateway/protocol/index.ts`). Key frame types:

| Frame Type | Purpose |
|------------|---------|
| `ConnectParams` | Client authentication handshake |
| `HelloOk` | Server confirmation of connection |
| `RequestFrame` | Client-to-server method calls (chat.send, sessions.list, etc.) |
| `ResponseFrame` | Server response to requests |
| `EventFrame` | Server-pushed events (chat messages, agent events, status updates) |

**Gateway methods** include (from `server-methods-list.ts`):
- `chat.send`, `chat.inject`, `chat.abort` -- message handling
- `sessions.list`, `sessions.patch`, `sessions.reset`, `sessions.delete` -- session management
- `agents.list`, `agents.create`, `agents.update`, `agents.delete` -- agent CRUD
- `agents.files.get`, `agents.files.set`, `agents.files.list` -- agent file management
- `config.get`, `config.set`, `config.patch`, `config.apply` -- live config changes
- `cron.add`, `cron.remove`, `cron.run`, `cron.list` -- scheduled tasks
- `node.invoke`, `node.describe`, `node.list` -- remote node management
- `models.list` -- available model catalog

### Node Registry

Connected clients register as "nodes" in a `NodeRegistry`. Each node has:
- Client name and version
- Capabilities/commands it supports
- Scopes and permissions
- Platform and device family

This is critical for **multi-node orchestration** -- OpenClaw can dispatch work to specific connected nodes (e.g., "run this on Desktop" vs "run this on smo-dev").

---

## 3. External System Integration

### HTTP Hooks System

OpenClaw has a built-in **hooks system** (`gateway/hooks.ts`) that accepts inbound HTTP POST requests and injects them as agent messages:

```json
"hooks": {
  "enabled": true,
  "token": "secret-token",
  "path": "/hooks",
  "mappings": [
    {
      "match": { "header": "X-Source", "value": "n8n" },
      "agentId": "main",
      "sessionKey": "hook:n8n"
    }
  ]
}
```

**This is the primary mechanism for n8n integration.** An n8n workflow can POST to `http://100.89.148.62:18789/hooks` with a bearer token, and the message gets routed to the specified agent and session.

### OpenAI-Compatible HTTP API

The gateway exposes `/v1/chat/completions` (see `gateway/openai-http.ts`), making OpenClaw act as an **OpenAI-compatible API server**. Any system that speaks the OpenAI API can send messages to OpenClaw agents. This supports:
- Streaming (SSE) and non-streaming responses
- Image inputs (base64 and URL)
- Model selection
- Auth via bearer token

### Bash Tool Execution

Agents can execute arbitrary shell commands via the bash tool system (`agents/bash-tools.exec.ts`). This means an agent can:
- Call external APIs via `curl`
- Trigger n8n webhooks
- Interact with any CLI tool
- Run scripts that interface with queue engines

### Subagent Spawning (ACP)

The **Agent Communication Protocol (ACP)** system (`src/acp/`) enables agents to spawn child agents:
- `acp-spawn.ts` -- spawn a new agent session (can target specific nodes)
- Supports "run" mode (one-shot task) and "session" mode (persistent)
- Can bind spawned agents to channel threads (Discord, Telegram)
- Parent agents receive completion announcements when children finish
- Subagents can stream output back to parent

### Gateway Call API

Internal code can invoke gateway methods programmatically via `callGateway()` from `gateway/call.ts`. Skills and agents use this to:
- Send messages to other sessions
- Manage cron jobs
- Query node status
- Trigger agent runs

---

## 4. OpenClaw + Paperclip Integration

### Current State

Searching the OpenClaw codebase reveals **no direct Paperclip references in the core source code**. The references found are in the UI layer only (`ui/src/ui/views/chat.ts`, `ui/src/ui/icons.ts`, `ui/src/ui/tool-display.ts`), suggesting Paperclip appears as a display/branding element in the control UI but is not a protocol-level integration.

### How Paperclip Should Connect

Based on the architecture, Paperclip (the company orchestration layer at localhost:3100) should integrate with OpenClaw via these mechanisms:

**Option A: Gateway WebSocket Client (Recommended)**

Paperclip acts as a gateway client node, connecting via WebSocket to `ws://100.89.148.62:18789`:

1. Paperclip opens a WebSocket connection with auth token
2. Sends `ConnectParams` with `clientName: "paperclip"`, appropriate scopes
3. Receives `HelloOk` confirming registration as a node
4. Uses `chat.send` to dispatch work to specific agent sessions
5. Receives `EventFrame` messages with agent responses
6. Can invoke `node.invoke` to run tools on other connected nodes

**Option B: OpenAI-Compatible HTTP API**

Paperclip calls `POST http://100.89.148.62:18789/v1/chat/completions` with the gateway auth token. Simpler but loses real-time streaming and session management.

**Option C: HTTP Hooks**

Paperclip POSTs to the hooks endpoint for fire-and-forget task dispatch. Good for async workflows but no response streaming.

**Recommended Architecture:**

```
Paperclip (localhost:3100)
    |
    |-- WebSocket --> OpenClaw Gateway (100.89.148.62:18789)
    |                     |
    |                     |-- Agent "main" (Sulaiman)
    |                     |     |-- Subagent: VP Engineering
    |                     |     |-- Subagent: GTM Specialist
    |                     |     |-- Subagent: Content Lead
    |                     |
    |                     |-- Telegram channel plugin
    |                     |-- Cron scheduler
    |
    |-- HTTP webhook --> n8n (workflow triggers)
```

---

## 5. OpenClaw Agent Configuration Details

### Configured Auth Profiles

| Profile | Provider | Mode |
|---------|----------|------|
| `openai-codex:default` | OpenAI Codex | OAuth |
| `google-gemini-cli:eomamounalamouri@gmail.com` | Google Gemini CLI | OAuth |
| `google:default` | Google | API Key |

### Agent Model Configuration

The `agents/main/agent/models.json` file contains per-agent model overrides. The default stack:

- **Primary:** `openai-codex/gpt-5.4` (best quality)
- **Fallback 1:** `google/gemini-3-pro-preview`
- **Fallback 2:** `google/gemini-2.5-flash-lite` (also used for heartbeats)
- **Fallback 3:** `google/gemini-2.5-flash`

### Workspace Skills (Agent-Level)

The `~/.openclaw/agents/main/skills/` directory contains **role dispatch definitions**:

| Skill File | Role | Model | Purpose |
|------------|------|-------|---------|
| `vp-engineering.md` | VP Engineering | Claude Sonnet | Coding, architecture, TDD |
| `content-lead.md` | Content Lead | Claude Sonnet | Asset creation, copywriting |
| `gtm-specialist.md` | GTM Specialist | Claude Sonnet | Campaign strategy, outbound |
| `devops-dispatch.md` | DevOps | Claude Haiku | Deployment, security |
| `qa-lead.md` | QA Lead | Claude Haiku | Testing, quality assurance |
| `data-engineer.md` | Data Engineer | Codex/Haiku | Scraping, enrichment, pipelines |

These are **dispatch instructions** -- when the main agent receives a task matching a role, it spawns a subagent (via the coding-agent skill) with the appropriate model, skills, and quality gates.

---

## 6. Channel Routing

### How It Works

The routing engine (`src/routing/resolve-route.ts`) determines which agent handles each inbound message. The resolution follows a **tiered priority system**:

1. **Peer binding** -- exact match on channel + peer (specific chat/group/user)
2. **Parent peer binding** -- thread inherits parent's binding
3. **Guild + roles** -- Discord server + member roles
4. **Guild only** -- Discord server
5. **Team** -- Slack workspace
6. **Account** -- specific bot account
7. **Channel** -- fallback per channel type
8. **Default** -- the default agent

### Binding Configuration

Bindings are defined in `openclaw.json` under `bindings[]`:

```json
"bindings": [
  {
    "match": {
      "channel": "telegram",
      "peer": { "kind": "group", "id": "-1001234567890" }
    },
    "agentId": "sales-agent"
  },
  {
    "match": {
      "channel": "discord",
      "guildId": "123456",
      "roles": ["engineer"]
    },
    "agentId": "engineering-agent"
  }
]
```

### Current Channel Config

Only Telegram is enabled:

```json
"channels": {
  "telegram": {
    "enabled": true,
    "dmPolicy": "pairing",
    "groupPolicy": "allowlist",
    "streaming": "partial"
  }
}
```

**Warning from doctor:** `groupPolicy` is `"allowlist"` but `groupAllowFrom` is empty, so all group messages are silently dropped. Only DMs work currently.

### Session Routing

Each route resolution produces a `sessionKey` that determines session persistence. The session key encodes: agent ID + channel + account + peer. This means:
- Same user on Telegram gets the same session across messages
- Different channels get different sessions
- Different agents get different sessions
- DM scope can be `"main"` (all DMs share one session) or `"per-peer"` (each user gets their own)

---

## 7. Skill System

### Architecture

Skills are markdown files (`SKILL.md`) with YAML frontmatter that define capabilities the agent can use. Skills are loaded from multiple locations:

1. **Bundled skills** -- shipped with OpenClaw (58 total, 18 ready on this server)
2. **Workspace skills** -- in `~/.openclaw/workspace/skills/`
3. **Agent-specific skills** -- in `~/.openclaw/agents/{id}/skills/`
4. **Extra dirs** -- from `skills.load.extraDirs` config
5. **Plugin skills** -- from installed plugins
6. **ClawHub** -- remote skill marketplace (`npx clawhub`)

### Key Ready Skills on smo-brain

| Skill | Source | Capabilities |
|-------|--------|-------------|
| `coding-agent` | bundled | Spawn Claude Code/Codex/Pi for coding tasks |
| `github` | bundled | GitHub operations via `gh` CLI |
| `gh-issues` | bundled | Fetch issues, spawn agents to fix, open PRs |
| `notion` | bundled | Notion API for pages, databases, blocks |
| `n8n-automation` | workspace | Manage n8n workflows via REST API |
| `role-dispatch` | workspace | Route tasks to role-specific agents |
| `data-analyst` | workspace | Data visualization and SQL |
| `sales` | workspace | CRM integration and pipeline management |
| `engineering-scorer` | workspace | Score engineering deliverables |
| `skill-creator` | bundled | Create and audit AgentSkills |

### How Skills Invoke External Systems

Skills are **instructions for the agent**, not executable code. The agent reads the skill's markdown and uses its tools (bash, file read/write, gateway calls) to execute. For example:

- **n8n-automation skill** teaches the agent to use `curl` with the n8n REST API
- **coding-agent skill** teaches the agent to spawn subagents via ACP
- **notion skill** uses the Notion API key from `skills.entries.notion.apiKey`

Skills can invoke external systems by:
1. Shell commands (`curl`, API calls)
2. Gateway method calls (via internal `callGateway()`)
3. Spawning subagents that run on remote nodes
4. Using MCP tools (via the `mcporter` skill)

### Skill Watch System

Skills are hot-reloaded. The `skills/refresh.ts` module watches for `SKILL.md` file changes using `chokidar` and triggers skill re-discovery without gateway restart.

---

## 8. MiniMax M2.7 as OpenClaw Model

### MiniMax Support Status

OpenClaw has **first-class MiniMax provider support**. The relevant code is in:

- `src/commands/onboard-auth.config-minimax.ts` -- MiniMax onboarding configuration
- `src/secrets/provider-env-vars.ts` -- `MINIMAX_API_KEY` environment variable mapping

### Provider Configuration

MiniMax is configured as a custom provider using the **Anthropic Messages API format** (MiniMax exposes an Anthropic-compatible endpoint):

```
baseUrl: "https://platform.minimax.io/anthropic"  (Global)
baseUrl: "https://api.minimaxi.com/anthropic"      (China)
api: "anthropic-messages"
authHeader: true
```

### Currently Supported Models

The codebase references:
- `MiniMax-M2.5`
- `MiniMax-M2.5-highspeed`

**M2.7 is NOT in the current codebase.** The default model ID is `"MiniMax-M2.5"`. However, because MiniMax uses the same API format, adding M2.7 requires only a configuration change:

### How to Configure MiniMax M2.7

Add to `openclaw.json`:

```json
{
  "models": {
    "providers": {
      "minimax": {
        "baseUrl": "https://platform.minimax.io/anthropic",
        "api": "anthropic-messages",
        "authHeader": true,
        "apiKey": "YOUR_MINIMAX_API_KEY",
        "models": [
          { "id": "MiniMax-M2.7", "name": "MiniMax M2.7", "reasoning": true }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.7",
        "fallbacks": ["openai-codex/gpt-5.4", "google/gemini-2.5-flash"]
      },
      "models": {
        "minimax/MiniMax-M2.7": { "alias": "Minimax" }
      }
    }
  }
}
```

Or run: `openclaw configure` and select MiniMax during the auth setup wizard.

**Environment variable:** Set `MINIMAX_API_KEY` in the shell or `.env`.

**Important:** The model ID string (`MiniMax-M2.7`) must match what MiniMax's API actually accepts. Verify the exact model identifier from MiniMax's documentation before configuring.

---

## 9. Integration Architecture: OpenClaw + Paperclip at the Company Layer

### Recommended Architecture

```
                    PAPERCLIP (Company Orchestrator)
                    localhost:3100
                         |
          +--------------+--------------+
          |              |              |
    WebSocket       HTTP Hooks      n8n MCP
    (real-time)     (async tasks)   (workflows)
          |              |              |
          v              v              v
    OPENCLAW GATEWAY (100.89.148.62:18789)
          |
    +-----+-----+-----+-----+-----+
    |     |     |     |     |     |
   Main  VP-E  GTM  Content DevOps Data
   Agent  sub  sub   sub    sub   sub
    |
    +--- Telegram Channel
    +--- Cron Scheduler
    +--- Node Registry (Desktop, smo-dev)
```

### Integration Points

| Integration | Mechanism | Use Case |
|-------------|-----------|----------|
| Paperclip -> OpenClaw chat | WebSocket `chat.send` | Real-time task dispatch, get streaming responses |
| Paperclip -> OpenClaw agent management | WebSocket `agents.*` methods | Create/configure agents dynamically |
| n8n -> OpenClaw | HTTP hooks (`/hooks`) | Workflow-triggered agent tasks |
| OpenClaw -> n8n | Agent bash tool (`curl`) | Trigger n8n webhooks from agent actions |
| OpenClaw -> external APIs | Agent bash tool | Any HTTP API call |
| Paperclip -> specific node | WebSocket `node.invoke` | Run commands on Desktop or smo-dev |
| Paperclip -> cron | WebSocket `cron.add/run` | Schedule recurring agent tasks |

### Key Decisions for Implementation

1. **Single agent with subagent dispatch vs. multiple configured agents:** Current setup uses one "main" agent that spawns role-based subagents. For Paperclip integration, consider defining named agents in `agents.list[]` so Paperclip can address them directly via routing bindings.

2. **Session management:** Paperclip should maintain stable session keys for ongoing work (e.g., `paperclip:project-alpha:engineering`). This preserves conversation context across multiple interactions.

3. **Authentication:** The gateway token (`gateway.auth.token`) is currently a static string. For production Paperclip integration, consider device-pair authentication for stronger security.

4. **Hooks vs. WebSocket:** Use WebSocket for interactive work requiring streaming responses. Use hooks for fire-and-forget triggers (e.g., "n8n detected a signal, tell the GTM agent").

5. **Model routing:** Different agents/roles can use different models. MiniMax M2.7 could be configured as the default for cost-sensitive roles while keeping GPT-5.4 for premium tasks.

---

## 10. Summary of Findings

| Question | Answer |
|----------|--------|
| How does OpenClaw manage multiple agents? | Via `agents.list[]` config. Each agent has its own workspace, identity, model, skills, and session store. Currently 1 agent ("main") with 6 role-dispatch subagent definitions. |
| What does the gateway do? | Central WebSocket + HTTP server. Routes messages, manages sessions, coordinates subagents, exposes OpenAI-compatible API, runs cron, manages plugins. |
| Can agents call external APIs? | Yes, via bash tool (curl), MCP tools (mcporter), or gateway hooks. |
| How does Paperclip integrate? | Should connect as a WebSocket gateway client. No native Paperclip adapter exists in OpenClaw core -- the "openclaw-gateway" adapter would be on the Paperclip side. |
| What agents are configured? | 1 agent ("main"), identity "Sulaiman", model GPT-5.4, with 6 role-dispatch skills for subagent spawning. |
| How does channel routing work? | Tiered binding system: peer > parent-peer > guild+roles > guild > team > account > channel > default. Currently only Telegram enabled (DMs only, groups blocked by empty allowlist). |
| How do skills work? | Markdown instruction files loaded from multiple directories, hot-reloaded. Agents use their tools to execute skill instructions. 58 available, 18 ready. |
| Can MiniMax M2.7 be used? | OpenClaw has first-class MiniMax provider support. M2.5 is built in. M2.7 requires adding the model ID to provider config -- straightforward config change. |
