# BRD Execution Pipeline — How to Feed Work to the AI-Native Org

**Date:** 2026-04-02 | **Status:** ACTIVE
**Purpose:** Answer "How does a BRD get from Mamoun to working code?"

---

## The Short Answer

```
Mamoun writes BRD → Sends to @SMOQueueBot (Telegram, CEO inbox)
→ Paperclip (Company OS) analyzes BRD, decomposes into tasks, assigns to agents
→ al-Jazari (VP Eng, OpenClaw :18790) receives CODE tasks
→ al-Jazari executes via Claude Code on smo-dev
→ If al-Jazari needs approval → sends back to @SMOQueueBot (CEO)
→ QA Lead scores → PR merged to dev branch
```

**Key distinction:** @SMOQueueBot is the CEO inbox — that's where BRDs enter. Paperclip (Layer 1) owns decomposition and assignment. al-Jazari (Layer 2) is VP Engineering — it receives and executes code tasks, it does NOT receive BRDs directly.

---

## Infrastructure Map

| Layer | What | Where | Port | Purpose |
|-------|------|-------|------|---------|
| **Layer 1: Paperclip** | Company OS | smo-brain | :3100 | Org chart, goals, task lifecycle, agent assignment |
| **Layer 2: OpenClaw** | Agent Gateway | smo-brain | :18789 (Sulaiman), :18790 (al-Jazari) | Agent personas, skill routing, Telegram, subagents |
| **Layer 3: Queue Engine** | Task Pipeline | smo-brain | n8n + SQLite + bash | Dispatch, dependencies, CI, PR creation |

---

## Step-by-Step: Executing a BRD

### Step 1: Write the BRD
- Format: Markdown with clear scope, acceptance criteria, target repo/branch
- Template: See `EmailVerification/BRD-email-verification-l1-l2.md` for example
- Must include: business problem, technical scope, success criteria, target branch

### Step 2: Send BRD to @SMOQueueBot via Telegram
- Bot: `@SMOQueueBot` (CEO inbox — decisions, BRD intake)
- Send the BRD as a message or file
- This is the ONLY entry point for BRDs. Never send BRDs directly to al-Jazari.

### Step 3: Paperclip (CEO Layer) Analyzes & Decomposes
- Paperclip receives BRD through @SMOQueueBot
- Analyzes scope, identifies tasks, sets dependencies
- Creates work items in Paperclip's issue tracker
- Assigns each task to the correct agent role

### Step 4: Agents Receive Assigned Tasks
- Each task assigned to an agent based on role:
  - **VP Engineering** → openclaw_gateway → al-Jazari (:18790) → Claude Code on smo-dev
  - **CEO** → claude_local → Direct OAuth on smo-brain
  - **QA Lead** → claude_local → Direct OAuth
  - **DevOps** → claude_local → Direct OAuth

### Step 5: Agent Executes
- Agent receives task context + methodology skills (123 total)
- Executes on target node (smo-dev for code, smo-brain for orchestration)
- Creates PRs to `dev` branch (never directly to `main`)

### Step 6: Quality Gate
- QA Lead scores output using smorch-dev-scoring skills
- Must pass quality gate before merge
- Results reported back to Paperclip

---

## Alternative: Direct Claude Code Execution (Testing/Ad-hoc)

For the soak test period or when agent pipeline isn't fully operational:

1. Open Claude Code session on smo-dev (SSH to 100.117.35.19)
2. Provide BRD content directly in the chat
3. Claude Code reads BRD, executes, creates PRs
4. This bypasses Telegram→OpenClaw→Paperclip but still uses the same codebase

**When to use:** Soak test validation, debugging agent failures, ad-hoc tasks
**When NOT to use:** Production work after soak test passes

---

## Key Files for Context

| File | What It Covers |
|------|---------------|
| `architecture-final-2026-03-30.md` | Full 3-layer architecture (LOCKED) |
| `build-progress-2026-04-01.md` | Current infra status, what's operational |
| `execution-plan-v3-2026-03-30.md` | Soak test plan (72h) |
| `SOP-Infrastructure-Node-Roles.md` | Which node does what |
| `skill-router-matrix.md` | 123 skills mapped to roles |
| `openclaw-agent-test-usecase.md` | E2E test flow examples |
| `ADR-014-three-layer-orchestration.md` | Why 3 layers |

---

## For the SSE V3 Chat Specifically

The SSE V3 project is the **soak test** for this infrastructure. The flow should be:

1. SSE V3 BRD written from requirements at `smorch-context/SalesMfastGTM/Project6-SSEngineTech/`
2. BRD sent to **@SMOQueueBot** via Telegram (CEO inbox, NOT al-Jazari)
3. Paperclip decomposes → al-Jazari (VP Eng) gets code tasks
4. If al-Jazari needs approval → routes back to @SMOQueueBot
5. If agent execution fails → diagnose and fix the pipeline (NOT bypass into manual coding)
6. If agent execution succeeds → validate output, score, merge

**Supabase for SSE:**
- Project: ozylyahdhuueozqhxiwz
- Management API token: sbp_7b833ee50849032742239debc16c7a611b1af236
- 53 tables live (47 SSE + 6 email verification)
- MCP Supabase tools linked to WRONG org — use Management API via curl
