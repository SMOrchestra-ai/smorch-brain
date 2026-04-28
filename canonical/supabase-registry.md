# Canonical Supabase Project Registry

**Last updated:** 2026-04-23
**Source of truth.** Any project reference in code must map to a row here.

---

## Active projects

| project_ref | Name | Region | Purpose | Consumer apps | Status |
|---|---|---|---|---|---|
| `ozylyahdhuueozqhxiwz` | SSE | ap-southeast-1 | Signal Sales Engine (canonical prod) + ACE tables + email-verification edge function | signal-sales-engine | **KEEP — primary prod** |
| `lhmrqdvwtahpgunoyxso` | entrepreneursoasis | ap-northeast-1 | EO-MENA + EO-Scoring + EO-Scorecard + EO-Assessment | eo-mena, eo-scoring, eo-scorecard, eo-assessment-system | **KEEP — DO NOT TOUCH** |
| `kyxiyvmqqohxpfuoansv` | content-engine | (IPv6-only direct, no Supavisor pooler) | Content automation runtime — `content_engine.{content_assets,content_runs,content_templates,dead_letter_queue}` schema + `public.{error_logs,idempotency_registry,provenance_log,dead_letter_queue}` ops tables. Migrations 001-005 applied 2026-04-28. | content-automation | **KEEP — primary canonical** (drift-fix shipped 2026-04-28) |
| `cuzpbpegrqwsqomsrtye` | SAASNew | TBD | new SaaS product (pre-launch, discovery 2026-04-23) | TBD | KEEP — flag for Phase 6 inventory |

---

## Slated for removal

| project_ref | Name | Region | Reason | Owner action |
|---|---|---|---|---|
| `odjuqweiyzicqmcqozsu` | SSE-Temp | ap-southeast-1 | Briefly used as catch-all; 49 tables overlap with canonical SSE. Not referenced by any live app. | ✅ **PAUSED 2026-04-23** (CEO GO). Data dump + schema at `~/Desktop/smo-recovery-2026-04-21/supabase-sse-temp/`. Permanently delete via Supabase dashboard after 7-day verification window (hard-delete by ~2026-04-30). |

---

## MongoDB (not Supabase)

| Database | Purpose | Consumer |
|---|---|---|
| saasfast MongoDB | SaaSFast-Page-Online + SaaSfast-ar auth + user data | saasfast repo (MONGODB_URI env var) |
| MongoDB URI stored in | 1Password vault `SMOrchestra Infrastructure` → `SaaSfast-Prod-MongoDB` |

---

## MCP wiring (as of 2026-04-28)

Supabase MCP servers configured at `~/.claude/.mcp.json`:
- `supabase-sse` → ozylyahdhuueozqhxiwz (uses `${SUPABASE_PAT}`)
- `supabase-cre` → kyxiyvmqqohxpfuoansv (renamed mentally to "content-engine"; MCP key kept for backward compat)
- `supabase-saasnew` → cuzpbpegrqwsqomsrtye
- `supabase-eo` → lhmrqdvwtahpgunoyxso (pre-existing)

## Drift-fix history

- **2026-04-28** content-automation runtime was talking to a local docker Postgres (`content-automation-postgres-1` on smo-prod) instead of canonical Supabase `kyxiyvmqqohxpfuoansv`. Root cause: `docker-compose.yml` constructed `DATABASE_URL` from legacy `POSTGRES_*` vars when `DATABASE_URL` was absent in `.env`. Fix: explicit `DATABASE_URL` in `docker-compose.override.yml:runtime.environment`, `network_mode: host` so container can reach Supabase IPv6 endpoint, migrations 001-005 applied to Supabase. Local Postgres container + volume torn down 2026-04-28. See `content-automation/docs/qa/2026-04-28-v1-stress-test-claude-self-qa.md` §4 for full chronicle.

Credentials live at `~/.claude/secrets/supabase-creds.env` (600 perms, sourced via `~/.zshrc`). **NOT committed anywhere.**

🚨 **PAT rotation required**: `sbp_7b833...` currently rejected by Supabase Management API. Rotate at https://supabase.com/dashboard/account/tokens after restart confirms MCP works.

---

## Backup policy (per MASTER-PLAN Phase F.3)

All active Supabase projects: nightly `pg_dump` at 02:00 UTC via `/opt/scripts/backup-db.sh` on smo-prod (centralized). Retention: 14 days daily + 12 weekly. Offsite archive weekly to Contabo Object Storage.

Heartbeat webhook: `https://flow.smorchestra.ai/webhook/db-backup-heartbeat`. Alert to Telegram if any project fails.
