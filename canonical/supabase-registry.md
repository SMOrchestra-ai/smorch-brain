# Canonical Supabase Project Registry

**Last updated:** 2026-04-23
**Source of truth.** Any project reference in code must map to a row here.

---

## Active projects

| project_ref | Name | Region | Purpose | Consumer apps | Status |
|---|---|---|---|---|---|
| `ozylyahdhuueozqhxiwz` | SSE | ap-southeast-1 | Signal Sales Engine (canonical prod) + content_engine schema + ACE tables + email-verification edge function | signal-sales-engine, content-automation | **KEEP — primary prod** |
| `lhmrqdvwtahpgunoyxso` | entrepreneursoasis | ap-northeast-1 | EO-MENA + EO-Scoring + EO-Scorecard + EO-Assessment | eo-mena, eo-scoring, eo-scorecard, eo-assessment-system | **KEEP — DO NOT TOUCH** |
| `kyxiyvmqqohxpfuoansv` | Content Repurposing Engine | TBD | content repurposing pipeline (separate from content-automation) | TBD (inventory pending) | KEEP pending inventory |
| `cuzpbpegrqwsqomsrtye` | SAASNew | TBD | new SaaS product (pre-launch, discovery 2026-04-23) | TBD | KEEP — flag for Phase 6 inventory |

---

## Slated for removal

| project_ref | Name | Region | Reason | Owner action |
|---|---|---|---|---|
| `odjuqweiyzicqmcqozsu` | SSE-Temp | ap-southeast-1 | Briefly used as catch-all; 49 tables overlap with canonical SSE. Not referenced by any live app. | CEO decision: "REMOVE no grace". Export schema+data to `~/Desktop/smo-recovery-2026-04-21/supabase-sse-temp/` first, then pause via Supabase panel, delete after 24h verification window. |

---

## MongoDB (not Supabase)

| Database | Purpose | Consumer |
|---|---|---|
| saasfast MongoDB | SaaSFast-Page-Online + SaaSfast-ar auth + user data | saasfast repo (MONGODB_URI env var) |
| MongoDB URI stored in | 1Password vault `SMOrchestra Infrastructure` → `SaaSfast-Prod-MongoDB` |

---

## MCP wiring (as of 2026-04-23)

Supabase MCP servers configured at `~/.claude/.mcp.json`:
- `supabase-sse` → ozylyahdhuueozqhxiwz (uses `${SUPABASE_PAT}`)
- `supabase-cre` → kyxiyvmqqohxpfuoansv
- `supabase-saasnew` → cuzpbpegrqwsqomsrtye
- `supabase-eo` → lhmrqdvwtahpgunoyxso (pre-existing)

Credentials live at `~/.claude/secrets/supabase-creds.env` (600 perms, sourced via `~/.zshrc`). **NOT committed anywhere.**

🚨 **PAT rotation required**: `sbp_7b833...` currently rejected by Supabase Management API. Rotate at https://supabase.com/dashboard/account/tokens after restart confirms MCP works.

---

## Backup policy (per MASTER-PLAN Phase F.3)

All active Supabase projects: nightly `pg_dump` at 02:00 UTC via `/opt/scripts/backup-db.sh` on smo-prod (centralized). Retention: 14 days daily + 12 weekly. Offsite archive weekly to Contabo Object Storage.

Heartbeat webhook: `https://flow.smorchestra.ai/webhook/db-backup-heartbeat`. Alert to Telegram if any project fails.
