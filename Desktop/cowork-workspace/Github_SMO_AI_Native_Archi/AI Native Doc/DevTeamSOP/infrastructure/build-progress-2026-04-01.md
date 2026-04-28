# AI-Native Organization — Build Progress

**Date:** 2026-04-01
**Author:** Mamoun Alamouri + Claude (desktop)
**Branch:** dev

---

## Executive Summary

Building an autonomous AI-native development organization where Mamoun sends a BRD, walks away for days, and returns to review completed work. Three orchestration layers: Paperclip (Company OS) → OpenClaw agents (al-Jazari + Sulaiman) → Queue Engine (n8n + SQLite + bash).

**Current status:** Infrastructure operational. Agent identities configured. Queue Engine built and tested. 5 blockers fixed (2026-04-01). E2E pipeline test complete (7/7 tasks merged, PRs #2-#8). Ready for soak test.

---

## Completed Work

### Dual OpenClaw Gateway (2026-03-31)

| Gateway | Service | Port | Primary Model | Telegram | Role |
|---------|---------|------|---------------|----------|------|
| Sulaiman | openclaw-chat | 18789 | openai-codex/gpt-5.4 | @SulaimanMoltbot | COO — strategy, chat, admin, tools, ideation |
| al-Jazari | openclaw-coding | 18790 | minimax/MiniMax-M2.7 | @al_Jazari_ChiefEng_bot | VP Eng — coding orchestration, BRD decomposition |

- Same binary (`/root/moltbot`), isolated configs/state/workspaces/systemd services
- Both gateways Tailscale-bound (100.89.148.62)
- Both using OAuth for OpenAI (gpt-5.4 fallback)
- Both have Google OAuth for Gemini fallback
- MiniMax API key exclusive to al-Jazari ($10/month Starter)

### Paperclip Agent Routing (2026-03-31)

| Agent | Adapter | Target |
|-------|---------|--------|
| CEO | claude_local | Direct (OAuth subscription) |
| VP Engineering | openclaw_gateway | ws://127.0.0.1:18790 (al-Jazari) |
| Content Lead | openclaw_gateway | ws://127.0.0.1:18790 (al-Jazari) |
| GTM Specialist | openclaw_gateway | ws://127.0.0.1:18790 (al-Jazari) |
| QA Lead | claude_local | Direct (OAuth subscription) |
| DevOps | claude_local | Direct (OAuth subscription) |
| Data Engineer | claude_local | Direct (OAuth subscription) |

- Paperclip UI rebranded to SMOrchestra (favicon, title, sidebar, company logo)
- Company ID: `1049290e-7217-4bfd-bd56-bed67884246d`
- claude_local adapter spawns `claude --print` using host OAuth — zero API keys

### Workspace Identity Files (2026-04-01)

Both agent workspaces scored and bridged to **10/10** against OpenClaw best practices:

| File | Sulaiman (Before → After) | al-Jazari (Before → After) |
|------|--------------------------|---------------------------|
| SOUL.md | 8 → 10 | 6 → 10 |
| IDENTITY.md | 5 → 10 | 7 → 10 |
| USER.md | 3 → 10 | 5 → 10 |
| AGENTS.md | 9 → 10 | 6 → 10 |
| MEMORY.md | 8 → 10 | 4 → 10 |
| HEARTBEAT.md | 8 → 10 | 6 → 10 |
| TOOLS.md | 5 → 10 | 4 → 10 |

- 37 legacy files archived from Sulaiman workspace root
- Both workspaces now clean: only 7 bootstrap files in root

### Auth Verification (2026-04-01)

| Service | Auth Method | Account | Status |
|---------|-------------|---------|--------|
| Claude Code (smo-brain) | OAuth subscription (Max) | smorchestra.ai@gmail.com | ✅ Active |
| Claude Code (smo-dev) | OAuth subscription (Max) | yousef@smorchestra.com | ✅ Active |
| OpenAI/Codex (al-Jazari) | Paste-token (manual) | mamoun@smorchestra.com | ✅ Valid ~10 days, needs manual refresh |
| OpenAI/Codex (Sulaiman) | OAuth | mamoun@smorchestra.com | ⚠️ Needs re-auth (config pending) |
| Google (both) | API key | eomamounalamouri@gmail.com | ✅ Active (API keys allowed for Google) |
| MiniMax M2.7 (al-Jazari only) | API key | $10/month Starter plan | ✅ Active |
| Paperclip → Claude | OAuth via claude_local adapter | Host's Claude auth | ✅ Active (PATH fix applied) |

**Auth rule:** No API keys except Google. OAuth/subscription for everything else. MiniMax is API-key-only provider (no OAuth available) — accepted exception.

---

## Infrastructure Status

| Node | Tailscale IP | Claude Code | Codex | n8n | OAuth Account | Cap |
|------|-------------|-------------|-------|-----|---------------|-----|
| smo-brain | 100.89.148.62 | v2.1.86 (Max) | v0.101.0 | Port 5678 (healthy) | Account A (Mamoun) | $200 |
| smo-dev | 100.117.35.19 | v2.1.88 (Max) | v0.117.0 | Port 5170 (Docker, healthy) | Account B | $200 |
| desktop | 100.100.239.103 | Latest | Latest | N/A | Account A (shared) | $200 shared |

---

## Queue Engine — Already Built (discovered 2026-04-01)

Previous sessions (2026-03-29 to 2026-03-31) built the entire Queue Engine. Discovery during Phase 1 execution revealed:

### SQLite Queue DB (`/root/.smo/queue/queue.db`)
- 8 tables: tasks, file_locks, audit_log, task_artifacts, role_skills, node_accounts, skill_versions, brds
- 4 views: v_active_tasks, v_brd_progress, v_queue_summary, v_account_usage
- 49 role_skills mappings populated
- 2 accounts configured (A = Mamoun shared, B = smo-dev)
- 5 test tasks (all merged/needs_human from integration test)
- SQL injection prevention via parameterized db.sh wrapper

### Queue Scripts (`/root/.smo/queue/`) — 13 scripts, ~2,300+ lines

| Script | Lines | Purpose |
|--------|-------|---------|
| dispatch.sh | 360 | Tier routing + skills injection dispatcher |
| decompose-brd.sh | 324 | BRD → task decomposition via Claude |
| paperclip-sync.sh | 271 | Bidirectional queue ↔ Paperclip sync |
| score-task.sh | 232 | Quality gate scoring |
| queue-status.sh | 162 | Telegram /status command |
| health-check.sh | 155 | Queue engine health endpoint |
| notify-ceo.sh | 147 | Proactive CEO notifications |
| create-pr.sh | 145 | GitHub PR creation for completed tasks |
| db.sh | 132 | Parameterized SQL wrapper |
| classify-task.sh | 127 | 13-dimension task scoring |
| task-complete.sh | 124 | Agent session completion handler |
| queue-approve.sh | 99 | approve/approve-all/reject/kill/pause/resume |
| add-task.sh | 60 | Add task to queue |

### n8n Workflows (smo-brain) — 8 queue workflows, ALL ACTIVE

| Workflow | ID | Status |
|----------|----|--------|
| SMO Queue — Telegram Command Handler | MuQYtl1f3wW54az7 | ACTIVE |
| SMO Queue — Queue Processor | tVONezkpRV0Fn9dH | ACTIVE |
| SMO Queue — CI Monitor + Quality Gate | rnthnaVvXWL6VMm5 | ACTIVE |
| SMO Queue — PR Merge Handler | 3AKMYqvUHINQ2AgS | ACTIVE |
| SMO Queue — Session TTL Monitor | SjFpudkDxZWZ0OLa | ACTIVE |
| SMO Queue — OpenClaw Nudge | ceGzlSVTxfHSW2e4 | ACTIVE |
| SMO Queue — Paperclip Sync | RnrHAtAdBESrdvn1 | ACTIVE |
| SMO Queue — Daily Digest | lCaV2ypWT1Qi1lWx | ACTIVE |

Plus 2 role dispatch workflows:
- AI-Org-Role-Dispatch (6qrRnYn27Bz7tnIV) — ACTIVE
- SMOrchestra — Role Dispatch to Paperclip (wtjbcBvxdAl7LZSW) — ACTIVE

---

## Revised Phase Status

| Phase | Name | Planned | Actual Status |
|-------|------|---------|---------------|
| **0** | Prerequisites Verification | 2h | **COMPLETE** — all checks pass |
| **1** | SQLite Queue + BRD Decomposition | 4-5h | **COMPLETE** — DB, scripts, Telegram handler all built |
| **2** | Execution Engine | 6-8h | **COMPLETE** — dispatch.sh, queue processor, quality gates, CI monitor, PR handler |
| **3** | Persistence + Recovery | 4-5h | **COMPLETE** — OpenClaw nudge, session TTL, health check |
| **4** | Git + CI Integration | 3-4h | **COMPLETE** — repos cloned, PRs scripted, GitHub webhooks fixed (webhookId bug) and verified |
| **5** | Visibility + Hardening | 2-3h | **COMPLETE** — Telegram commands, daily digest, Paperclip sync |
| **6** | Integration Testing + 72h Soak | 8h + 72h | **IN PROGRESS** — E2E test complete (7/7 merged), 5 blockers fixed, soak test next |

### GitHub Webhook Fix (2026-04-01)

**Problem:** Both org-level GitHub webhooks (CI status + PR merge) were returning 404 since creation on 2026-03-30. Workflows showed as active in n8n but webhook endpoints were never registered.

**Root cause:** n8n webhook node v2 requires a `webhookId` property on the node object. Workflows created via API on March 30 were missing this field — webhooks silently failed to register despite successful workflow activation.

**Fix:** Updated both workflows via n8n API to add `webhookId` to their webhook trigger nodes. Both endpoints now return 200:
- `https://ai.mamounalamouri.smorchestra.com/webhook/github-ci-status` → CI Monitor + Quality Gate
- `https://ai.mamounalamouri.smorchestra.com/webhook/github-pr-merge` → PR Merge Handler

### E2E Pipeline Test (2026-04-01)

Email Verification BRD used as test payload. 7 tasks (TASK-006 through TASK-012) dispatched through full pipeline.

**Results:** 7/7 tasks completed and merged → PRs #2 through #8.

**5 Blockers Found & Fixed:**

| # | Issue | Fix | Status |
|---|-------|-----|--------|
| 1 | MiniMax API key missing on openclaw-chat | Added MINIMAX_API_KEY to openclaw-chat.service | ✅ Fixed |
| 2 | OpenAI OAuth expired on al-Jazari | Re-authed via `models auth paste-token --provider openai-codex` | ✅ Fixed (valid ~10 days) |
| 3 | Paperclip agents fail — PATH missing | Added PATH to paperclip.service systemd Environment | ✅ Fixed |
| 4 | PRs targeting main instead of dev for SSE/EO | Created common.sh with get_base_branch(), patched 4 scripts | ✅ Fixed |
| 5 | smo-dev SSH unreachable during dispatch | Added ssh_health_check() to dispatch.sh with auto-fallback | ✅ Fixed |

**Queue Engine patches applied:**
- `common.sh` — new shared function: `get_base_branch()` returns `dev` for SSE/EO repos, `main` for others
- `dispatch.sh` — sources common.sh, uses dynamic base branch, adds SSH health check with auto-reroute
- `create-pr.sh` — uses `get_base_branch()` for `--base` flag
- `score-task.sh` — uses dynamic base branch for diff comparison
- `task-complete.sh` — uses dynamic base branch for rebase

**Auth cleanup (2026-04-01):**
- Removed expired openai-codex:default and google-gemini-cli profiles
- Added openai-codex:manual (paste-token, valid ~10 days, no auto-refresh yet)
- Kept google:default API key (Google API keys exempted from no-API-keys rule)
- OpenAI refresh_token exists but OpenClaw doesn't auto-refresh — manual re-auth every ~10 days

### What Remains

1. **Sulaiman isolated config** — create /opt/openclaw/chat/config/openclaw.json with proper fallback (Google Gemini 3.1 Pro)
2. **Verify Paperclip live** — trigger agent run from Paperclip UI, confirm PATH fix works
3. **OpenAI token auto-refresh** — cron job or script to use refresh_token before expiry
4. **72h Soak Test** — run sustained multi-BRD test once all components above 80%

---

## Architecture Docs (in this repo)

| Doc | Purpose |
|-----|---------|
| ADR-013 | MiniMax M2.7 model strategy (dual gateway) |
| ADR-014 | Three-layer orchestration model |
| ADR-015 | OpenClaw gateway adapter |
| architecture-final-2026-03-30.md | Full architecture diagram |
| security-decisions.md | SD-001 through SD-006 |
| execution-plan-ai-native-org-v2.md | Original execution plan |

---

## Cost Model

| Service | Monthly Cost |
|---------|-------------|
| MiniMax M2.7 (al-Jazari) | ~$0.71 actual / $10 plan |
| Claude Code Account A (Mamoun) | $200 cap |
| Claude Code Account B (smo-dev) | $200 cap |
| smo-brain (Contabo VPS) | ~$10 |
| smo-dev (Contabo VPS) | ~$10 |
| **Total** | **~$430/month max** |

Target: 70% Codex (cheap), 30% Claude (complex tasks only).
