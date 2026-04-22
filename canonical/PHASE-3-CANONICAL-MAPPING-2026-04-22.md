# Phase 3 Evidence — Canonical Mapping (Repo → Server → DB → n8n)

**Date:** 2026-04-22 21:45 UTC
**Evidence source:** SSH to 4 Tailscale hosts + Supabase MCP + local repo `.smorch/project.json` scan + MASTER-PLAN.md Phases B/D/E/F

---

## Section 1 — Server role registry

| Server | Tailscale IP | Public IP | Canonical role | Apps | n8n | Disk | Perfctl sentinel | Uptime |
|---|---|---|---|---|---|---|---|---|
| **smo-prod** | 100.108.44.127 | 62.171.164.178 | Production apps + prod n8n | pm2: `digital-revenue-score` (3100), `gtm-fitness-scorecard` (3200) | `flow` docker (5678) flow.smorchestra.ai | 16G/193G (8%) | **MISSING** | 5h |
| **smo-dev** | 100.83.242.99 | 62.171.165.57 | Dev/staging + dev n8n | **pm2 empty** | `n8n` docker (5170) testflow.smorchestra.ai | 13G/193G (7%) | **MISSING** | 5h |
| **eo-prod** | 100.89.148.62 | 89.117.62.131 | EO-MENA + smo-brain n8n | docker: eo-mena, coolify; pm2: eo-main, eo-scorecard, eo-scoring | `smo-brain` docker (5678) ai.mamounalamouri.smorchestra.com | 60G/96G (62%) | **MISSING** | 23d |
| **smo-eo-qa** | 100.99.145.22 | 84.247.172.113 | External QA | pm2 empty; caddy reverse-proxy | `n8n-n8n-1` via caddy | 12G/193G (6%) | **MISSING** | 3d 22h |

**Perfctl sentinel inactive on all 4 servers — P0 gap (the very reason for this rebuild).**

---

## Section 2 — Repo → Server canonical mapping

13 of 17 active repos are missing `.smorch/project.json`. Only eo-mena + signal-sales-engine have overlays, and SSE's overlay **contradicts MASTER-PLAN** by declaring smo-dev for production.

| Repo | Prod host | Prod path | Staging | Orchestration | Domain | Supabase | `.smorch` |
|---|---|---|---|---|---|---|---|
| eo-mena | eo-prod ✅ | /opt/apps/eo-mena | smo-dev (absent) | docker (coolify) + pm2 eo-main ⚠️ dual | entrepreneursoasis.me | lhmrqdvwtahpgunoyxso | ✅ |
| eo-scoring | eo-prod ✅ | /opt/apps/eo-scoring | — | pm2 (spec says docker) | score.entrepreneursoasis.me | lhmrqdvwtahpgunoyxso | ❌ |
| eo-scorecard | eo-prod ✅ | /opt/apps/eo-scorecard | — | pm2 | score.entrepreneursoasis.me? | lhmrqdvwtahpgunoyxso | ❌ |
| digital-revenue-score | smo-prod ✅ | /opt/apps/digital-revenue-score | smo-dev (absent) | pm2 | score.smorchestra.ai | N/A | ❌ |
| gtm-fitness-scorecard | smo-prod ✅ | /opt/apps/gtm-fitness-scorecard | smo-dev (absent) | pm2 | gtm.smorchestra.ai | N/A | ❌ |
| signal-sales-engine | smo-prod (target) | /opt/apps/signal-sales-engine | smo-dev | pm2 | sse.smorchestra.ai | ozylyahdhuueozqhxiwz | ⚠️ wrong |
| content-automation | smo-prod (target) | /opt/apps/content-automation | smo-dev | docker-compose | content.smorchestra.ai | ozylyahdhuueozqhxiwz | ❌ NOT DEPLOYED |
| saasfast | smo-prod (target) | /opt/apps/saasfast | smo-dev | pm2 | saasfast.smorchestra.ai | MongoDB | ❌ NOT DEPLOYED |
| openclaw-chat | eo-prod ✅ | /opt/openclaw/chat | — | systemd (port 18789) | sulaiman.smorchestra.com | — | N/A |
| openclaw-coding | eo-prod ✅ | /opt/openclaw/coding | — | systemd | openclaw-coding.smorchestra.ai ⚠️ vhost missing | — | N/A |
| moltbot | eo-prod ✅ | /root/moltbot | — | pm2 | — | — | N/A |
| smorchestra-web | Netlify ✅ | — | — | netlify | smorchestra.ai | N/A | N/A |

---

## Section 3 — Supabase registry

| project_ref | name | region | purpose | tables | RLS | status |
|---|---|---|---|---|---|---|
| `lhmrqdvwtahpgunoyxso` | entrepreneursoasis | ap-northeast-1 | EO-MENA + EO-Scoring | 16 | all RLS-on ✅ | **KEEP (DO NOT TOUCH)** |
| `odjuqweiyzicqmcqozsu` | SSE-Temp | ap-southeast-1 | legacy experiments | 49 | all RLS-on ✅ | **REMOVE after export** |
| `ozylyahdhuueozqhxiwz` | SSE (canonical) | ap-southeast-1 | SSE prod + content_engine + ACE | NOT MCP-VISIBLE | — | **KEEP — MCP cred gap P0** |
| `kyxiyvmqqohxpfuoansv` | Content Repurposing Engine | TBD | content repurposing | NOT MCP-VISIBLE | — | KEEP pending inventory |

**Finding:** the 2 canonical prod DBs aren't reachable via current MCP creds — P0 gap.

---

## Section 4 — n8n topology

| Instance | Host | Port | Domain | Workflows | Status |
|---|---|---|---|---|---|
| flow | smo-prod | 5678 | flow.smorchestra.ai | **270** | KEEP (prod) |
| flows | smo-dev | 5170 | flows.smorchestra.ai ⚠️ **nginx vhost missing** | 235 | KEEP + provision vhost |
| testflow | smo-dev | 5170 | testflow.smorchestra.ai (alias of flows) | 235 | KEEP as alias |
| devflow | smo-dev | — | devflow.smorchestra.ai | 0 (not running) | **RETIRE** (ADR needed) |
| smo-brain | eo-prod | 5678 | ai.mamounalamouri.smorchestra.com | 89 | KEEP |
| qa | smo-eo-qa | 5678 | qa.smorchestra.ai ⚠️ not provisioned | 0 (new) | KEEP + provision |

---

## Section 5 — Gap analysis

### P0 gaps (block Phase 4)
1. Perfctl sentinel missing on ALL 4 servers
2. Canonical SSE Supabase (`ozylyahdhuueozqhxiwz`) not MCP-accessible
3. SSE-Temp still ACTIVE_HEALTHY — export + pause + delete
4. 6 prod repos missing `.smorch/project.json`
5. SSE overlay contradicts MASTER-PLAN (points prod at smo-dev)
6. content-automation + saasfast + signal-sales-engine NOT DEPLOYED anywhere
7. `project-registry.md` + `supabase-registry.md` not committed to smorch-brain/canonical/

### P1 gaps
- `flows.smorchestra.ai` nginx vhost missing on smo-dev
- `qa.smorchestra.ai` not provisioned
- openclaw-coding nginx vhost missing on eo-prod
- eo-mena dual orchestration (docker + pm2)
- n8n encryption keys not captured in env-manifest
- HTTPS cert gap on score.smorchestra.ai + gtm.smorchestra.ai

### P2 gaps
- ADR-003 retiring devflow not written
- Host-level n8n systemd should be explicitly banned (docker-only)

---

## Section 6 — Phase 3 action plan

### P0 — blocks Phase 4

| # | Action | Est. | CEO approval? |
|---|---|---|---|
| 1 | Deploy perfctl-sentinel.sh + systemd to all 4 servers | 45m | no |
| 2 | Export SSE-Temp schema+data locally | 20m | no |
| 3 | Pause SSE-Temp Supabase project | 5m | **YES** (data delete) |
| 4 | Wire Supabase MCP for SSE + Content Repurposing orgs | 15m | no |
| 5 | Rewrite Signal-Sales-Engine `.smorch/project.json` (fix smo-dev → smo-prod for prod) | 20m | no |
| 6 | Create `.smorch/project.json` for 5 prod repos (drs, gtm, eo-scoring, eo-scorecard, content-automation) | 90m | no |
| 7 | Commit `project-registry.md` to smorch-brain/canonical/ | 30m | no |
| 8 | Commit `supabase-registry.md` to smorch-brain/canonical/ | 15m | no |

### P1 — before Phase 4 cutover

| # | Action | Est. | CEO? |
|---|---|---|---|
| 9 | Deploy signal-sales-engine to /opt/apps/ on smo-prod | 60m | **YES (smo-prod touch)** |
| 10 | Deploy content-automation to both servers | 60m | **YES** |
| 11 | Relocate saasfast to canonical paths | 45m | **YES** |
| 12 | Provision flows.smorchestra.ai nginx vhost on smo-dev | 10m | no |
| 13 | Provision qa.smorchestra.ai on smo-eo-qa | 15m | no |
| 14 | Resolve eo-mena dual orchestration | 30m | **YES (eo-prod)** |
| 15 | Add openclaw-coding nginx vhost on eo-prod | 10m | no |
| 16 | Capture n8n encryption keys → env-manifest + 1Password | 30m | **YES (secrets)** |
