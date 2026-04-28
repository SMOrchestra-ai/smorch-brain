# SOP-08: Project Kickoff Pre-Dev Check

**Version:** 1.0
**Date:** 2026-04-04
**Owner:** Mamoun Alamouri
**Scope:** All Paperclip pipeline projects (SSE, CXMfast, SalesMfast, EO)

---

## Purpose

Before any BRD execution begins, complete ALL items below. Every blocker we've hit in SSE V3 (April 2026) came from skipping one of these checks. This SOP prevents 4-8 hour delays per missed item.

---

## Checklist

### 1. Auth & Access — All Servers

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| Claude Code auth on smo-brain | `ssh root@100.89.148.62 'claude --version'` | Returns version, no auth error |
| Claude Code auth on smo-dev | `ssh root@100.117.35.19 'claude --version'` | Returns version, no auth error |
| Codex auth on smo-brain | `ssh root@100.89.148.62 'codex --version'` | Returns version, no auth error |
| claude_local root fix | Verify `dangerouslySkipPermissions: false` + `extraArgs: ["--permission-mode", "acceptEdits"]` in ALL claude_local agent configs | All 5 agents patched |
| Root test | `echo "say hello" \| timeout 15 claude --print - --permission-mode acceptEdits` | Returns response, no permission error |

**Blocker hit (SSE V3):** `--dangerously-skip-permissions` crashes as root. All 5 claude_local agents failed until patched with `acceptEdits` mode.

---

### 2. Tailscale Network — Cross-Server Communication

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| smo-brain → smo-dev SSH | `ssh root@100.89.148.62 'ssh root@100.117.35.19 hostname'` | Returns `smo-dev` |
| smo-dev → smo-brain SSH | `ssh root@100.117.35.19 'ssh root@100.89.148.62 hostname'` | Returns `smo-brain` |
| Tailscale status | `tailscale status` on both servers | Both nodes online, no "approval needed" |
| Approve pending sessions | Check https://login.tailscale.com/admin/machines | No pending approvals |

**Blocker hit (SSE V3):** Al-Jazari couldn't SSH to smo-dev — Tailscale session needed manual approval. Blocked BRD-0 execution for ~30 minutes until Mamoun clicked the approve link.

---

### 3. Database Access — Supabase / Postgres

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| Supabase URL configured | `grep SUPABASE_URL .env` | URL present |
| Supabase ANON_KEY | `grep SUPABASE_ANON_KEY .env` | Key present |
| Supabase SERVICE_ROLE_KEY | `grep SUPABASE_SERVICE_ROLE_KEY .env` | Key present |
| Supabase ACCESS_TOKEN | `grep SUPABASE_ACCESS_TOKEN .env` | Token present (for CLI) |
| DB Password | `grep SUPABASE_DB_PASSWORD .env` | Password present |
| DB Connection test | `psql -h db.<project>.supabase.co -U postgres -c "SELECT 1;"` | Returns 1 |
| IP Allowlist | Check Supabase Dashboard > Settings > Database > Network Restrictions | Server IPs (smo-dev: 89.117.62.131, smo-brain: check) are allowed |
| Supabase CLI installed | `supabase --version` on smo-dev | Version returned |
| Supabase MCP linked | Verify project appears in `list_projects` via Supabase MCP | Project visible |

**Blocker hit (SSE V3):** SERVICE_ROLE_KEY and DB_PASSWORD missing from .env. Blocked BRD-1 for ~3 hours. Server IP not in Supabase allowlist — psql connection refused. Supabase MCP linked to wrong org (mamoun@smorchestra.com, not lana@smorchestra.com).

---

### 4. Environment Variables & API Keys

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| .env file exists | `ls -la /workspaces/smo/<project>/.env` | File exists |
| .env has all required vars | Compare .env against .env.example | No missing vars |
| REDIS_URL | `grep REDIS_URL .env` | URL present |
| API keys validated | `node -e "require('dotenv').config(); console.log(Object.keys(process.env).filter(k => k.startsWith('SUPABASE')))"` | All keys listed |
| .env NOT in git | `grep .env .gitignore` | .env is gitignored |

**Blocker hit (SSE V3):** Multiple rounds of credential requests to Mamoun because .env wasn't populated upfront. Each round = 30-60 min delay.

---

### 5. n8n Connection

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| n8n running on smo-dev | `curl -s http://localhost:5170/healthz` | Returns healthy |
| n8n running on smo-brain | `curl -s http://localhost:5170/healthz` | Returns healthy |
| n8n MCP accessible | Test via `mcp__n8n-smo-dev__n8n_health_check` | Returns OK |
| Webhook URLs configured | Check n8n workflows for correct server URLs | URLs match |

---

### 6. Ping-Link Protocol — Agent Communication Paths

Run ALL checks before first BRD dispatch. Each must return a successful response.

| Path | Check | Command |
|------|-------|---------|
| Sulaiman (CEO) <-> Paperclip | Wake CEO agent | `POST /agents/<ceo-id>/wakeup` with `source: "on_demand"` |
| Al-Jazari (VP Eng) <-> Paperclip | Wake VP Eng agent | `POST /agents/<vpeng-id>/wakeup` with `source: "on_demand"` |
| Sulaiman → Al-Jazari | CEO creates issue, VP Eng gets woken | Create test issue, verify VP Eng receives it |
| Al-Jazari → smo-dev | SSH execution | VP Eng agent SSHs and runs a command |
| QA Lead <-> Paperclip | Wake QA agent | `POST /agents/<qa-id>/wakeup` with `source: "on_demand"` |
| Blocker → Telegram | Test escalation | Agent hits blocker, verify Telegram message to Mamoun |

**Test Script:**
```bash
# 1. CEO ping
curl -X POST "http://127.0.0.1:3100/api/agents/<ceo-id>/wakeup" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"source": "on_demand", "triggerDetail": "ping"}'

# 2. VP Eng ping
curl -X POST "http://127.0.0.1:3100/api/agents/<vpeng-id>/wakeup" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"source": "on_demand", "triggerDetail": "ping"}'

# 3. QA Lead ping
curl -X POST "http://127.0.0.1:3100/api/agents/<qa-id>/wakeup" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"source": "on_demand", "triggerDetail": "ping"}'

# 4. Cross-server SSH
ssh root@100.89.148.62 'ssh root@100.117.35.19 echo "smo-dev reachable"'

# 5. Verify agent statuses
curl -s "http://127.0.0.1:3100/api/companies/<company-id>/agents" \
  -H "Authorization: Bearer <token>" | python3 -c "
import json,sys
for a in json.load(sys.stdin):
    if a.get('status') != 'terminated':
        print(f\"{a['name']:25s} {a['status']:10s} {a.get('adapterType','?')}\")
"
```

**Blocker hit (SSE V3):** VP Eng wake events kept routing to CEO port (18789) instead of Al-Jazari (18790). Agent returned "No reply" on stale sessions. Not caught until mid-execution.

---

### 7. Git & Branch Setup

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| Repo cloned on smo-dev | `ls /workspaces/smo/<project>` | Repo exists |
| On correct branch | `git branch --show-current` | `dev` or designated base branch |
| V2/stable tag pushed | `git tag v2-stable && git push origin v2-stable` | Tag exists for rollback |
| Remote configured | `git remote -v` | Origin points to correct GitHub repo |
| Git auth working | `git push --dry-run` | No auth error |

---

### 8. Paperclip Pipeline Validation

| Check | Command / Action | Pass Criteria |
|-------|-----------------|---------------|
| Paperclip running | `curl -s http://127.0.0.1:3100/api/health` | Returns OK |
| All agents active | Check agent statuses | No agents in `error` or `paused` (except archived) |
| No duplicate agents | List agents, check for duplicates | One agent per role |
| Issue status rule | Verify issues created with `status: "todo"` not `backlog` | `backlog` skips dispatch |
| Agent timeout adequate | VP Eng `timeoutSec >= 1800` | 30min minimum for BRD execution |
| MEMORY.md under limit | `wc -c <workspace>/MEMORY.md` | Under 10000 chars |

**Blocker hit (SSE V3):** QA Lead stuck in `error` status from prior runs. VP Eng timed out at 300s (5min). Issues created with `backlog` status were silently skipped. Duplicate Al-Jazari agents caused confusion. MEMORY.md over 10000 chars caused truncation warnings on every wake.

---

## Execution Protocol

1. **Before first BRD:** Run through ALL 8 sections. Fix every failure.
2. **Document failures:** Add to this SOP if a new blocker type is discovered.
3. **Sign-off:** Mamoun confirms "Pre-dev check PASS" before pipeline starts.
4. **Estimated time:** 30-45 minutes for full check, 15 minutes if all green.

---

## Quick Reference — Agent Registry

| Agent | ID (short) | Adapter | Port |
|-------|-----------|---------|------|
| CEO (Sulaiman) | ceeb7fb5 | openclaw_gateway | 18789 |
| Al-Jazari (VP Eng) | ef01184f | openclaw_gateway | 18790 |
| QA Lead | 8b397285 | claude_local | -- |
| GTM Specialist | 6d6db366 | claude_local | -- |
| Content Lead | 21b11d37 | claude_local | -- |
| DevOps | 3ca940cc | claude_local | -- |
| Data Engineer | 74a770c0 | claude_local | -- |

---

## Revision Log

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-04-04 | Initial — all blockers from SSE V3 BRD-0 through BRD-2 documented |
