# SMOrchestra AI-Native Org — API Reference

**Date:** 2026-03-29
**Base URLs:**
- Paperclip: `http://localhost:3100` (local only, no auth required)
- n8n Role Dispatch: `https://ai.mamounalamouri.smorchestra.com/webhook/smo-role-dispatch`

---

## 1. Paperclip Agent APIs

### List All Agents
```
GET /api/companies/{companyId}/agents
```
**Response:** Array of agent objects with `id`, `name`, `status`, `adapterConfig`, `reportsTo`

### Get Single Agent
```
GET /api/agents/{agentId}
```
**Response:** Full agent object

### Update Agent Config
```
PATCH /api/agents/{agentId}
Content-Type: application/json

{
  "adapterConfig": {
    "model": "claude-sonnet-4-20250514",
    "maxTurnsPerRun": 50,
    "dangerouslySkipPermissions": true
  },
  "status": "idle"
}
```

### Wake Up Agent (Dispatch Task)
```
POST /api/agents/{agentId}/wakeup
Content-Type: application/json

{
  "message": "Your task description here",
  "forceFreshSession": true
}
```
**Response:** Run object with `id`, `status: "queued"`, `agentId`

**Critical:** Always include `forceFreshSession: true` to prevent context bloat from resumed sessions.

### List Company Issues
```
GET /api/companies/{companyId}/issues
```

---

## 2. n8n Role Dispatch Webhook

### Dispatch Task to Role
```
POST /webhook/smo-role-dispatch
Content-Type: application/json

{
  "role": "engineering",
  "task": "Build a health check endpoint with TDD"
}
```

**Valid roles:** `ceo`, `engineering`, `qa`, `content`, `gtm`, `devops`, `data`

**Success Response (200):**
```json
{
  "dispatched": true,
  "role": "engineering",
  "agentId": "a370cf96-be5e-42a4-bdd2-0d591b37d58c",
  "run": { ... }
}
```

**Error Response (400):**
```json
{
  "error": "Unknown role: cfo",
  "validRoles": ["ceo", "engineering", "qa", "content", "gtm", "devops", "data"]
}
```

---

## 3. Agent ID Reference

| Role | Agent ID | Model |
|------|----------|-------|
| CEO | `5f16f639-6cd3-425d-a320-6b9ec1caabfc` | claude-sonnet-4-20250514 |
| VP Engineering | `a370cf96-be5e-42a4-bdd2-0d591b37d58c` | claude-sonnet-4-20250514 |
| QA Lead | `8105403a-9504-4976-ad88-e6f42e4e236c` | claude-sonnet-4-20250514 |
| Content Lead | `cd46d003-7aa4-41dc-8c4e-21a9c9a37eb6` | claude-sonnet-4-20250514 |
| GTM Specialist | `f39d02c9-8886-4207-8a45-3251c373a6e1` | claude-sonnet-4-20250514 |
| DevOps | `e84f4270-70ae-4980-b379-ed8fde374e83` | claude-sonnet-4-20250514 |
| Data Engineer | `0db9f389-5bb6-42df-81f0-5c23c1125bc2` | claude-sonnet-4-20250514 |

**Company ID:** `1fd08eca-f681-468c-a468-9db41fa1425f`

---

## 4. Standard Error Format

All Paperclip API errors return:
```json
{
  "error": "Human-readable error message"
}
```

Common errors:
- `404`: Agent or company not found
- `400`: Invalid request body (missing required fields)
- `409`: Agent already running (concurrent run limit)

---

## 5. Authentication

| Endpoint | Auth | Notes |
|----------|------|-------|
| Paperclip API (localhost:3100) | None | Local-only, no network exposure |
| n8n Webhook | None | Public webhook, secured by obscure path |
| Agent execution (Claude CLI) | OAuth | Claude subscription auth, no API keys |

**Policy:** No API keys in configuration. All AI services authenticate via OAuth/subscription.

---

## 6. Rate Limits & Concurrency

| Constraint | Limit | Mitigation |
|------------|-------|------------|
| Claude OAuth concurrent sessions | ~5-6 | `maxTurnsPerRun: 50` keeps sessions short |
| Paperclip agent concurrent runs | 1 per agent | Queue additional requests |
| n8n webhook | Unlimited | n8n handles queuing |

---

## 7. Workspace & Log Paths

| Data | Path Pattern |
|------|-------------|
| Agent workspace | `~/.paperclip/instances/default/workspaces/{agentId}/` |
| Run logs | `~/.paperclip/instances/default/data/run-logs/{companyId}/{agentId}/{runId}.ndjson` |
| Agent instructions | `~/.paperclip/instances/default/companies/{companyId}/agents/{agentId}/instructions/AGENTS.md` |
| Paperclip .env | `~/.paperclip/instances/default/.env` |
| PostgreSQL data | `~/.paperclip/instances/default/data/` |
