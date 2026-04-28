# Canonical Server Role Registry

**Last updated:** 2026-04-23
**Source of truth.** Any divergence between this file and actual server state = drift, alerted by `/smo-drift`.

---

## The 4-server fleet

| Server | Tailscale IP | Public IP | Canonical role | Domain(s) hosted |
|---|---|---|---|---|
| **smo-prod** | 100.108.44.127 | 62.171.164.178 | Production apps + prod n8n | flow.smorchestra.ai, score.smorchestra.ai, gtm.smorchestra.ai, sse.smorchestra.ai, content.smorchestra.ai, saasfast.smorchestra.ai |
| **smo-dev** | 100.83.242.99 | 62.171.165.57 | Dev / staging + dev n8n | flows.smorchestra.ai, testflow.smorchestra.ai, staging-*.smorchestra.ai |
| **eo-prod** | 100.89.148.62 | 89.117.62.131 | EO-MENA prod + smo-brain n8n + openclaw | entrepreneursoasis.me, score.entrepreneursoasis.me, ai.mamounalamouri.smorchestra.com, sulaiman.smorchestra.com |
| **eo-dev** | 100.99.145.22 | 84.247.172.113 | EO Oasis dev VPS (replica of smo-dev), renamed 2026-04-29 from smo-eo-qa | qa.smorchestra.ai (legacy), eo-staging.* (planned) |

---

## What lives on each server

### smo-prod (production apps hub)
- **pm2 apps:** digital-revenue-score (3100), gtm-fitness-scorecard (3200), signal-sales-engine (TBD), content-automation (TBD), saasfast (TBD)
- **n8n:** `flow` container on 5678 — 270 workflows — production orchestration
- **Path discipline:** `/opt/apps/{repo-kebab}` only (L-003)
- **Perfctl sentinel:** `/opt/scripts/perfctl-sentinel.sh` every 30 min ✅ (shipped 2026-04-23)

### smo-dev (dev + staging)
- **pm2 apps:** staging clones in `/root/{repo}` — empty as of 2026-04-23 (phase 3 deploys pending)
- **n8n:** `n8n` container on 5170 → internal 5678 — 235 workflows — alias `testflow` + `flows` (vhost pending)
- **Perfctl sentinel:** ✅

### eo-prod (EO-MENA + orchestration)
- **docker:** eo-mena (coolify stack)
- **pm2:** eo-main, eo-scorecard, eo-scoring
- **n8n:** `smo-brain` container on 5678 — 89 workflows — EO orchestration + assessments + ACE telegram
- **systemd:** openclaw-chat (18789), openclaw-coding (port pending vhost)
- **Perfctl sentinel:** ✅

### eo-dev (EO Oasis dev VPS, formerly smo-eo-qa)
- **Renamed:** 2026-04-29 (hostname + Tailscale + canonical registry). Replica of smo-dev for EO Oasis development.
- **pm2:** empty (EO dev tooling pending provisioning)
- **n8n:** `n8n-n8n-1` via caddy — 0 workflows (legacy QA staging)
- **Perfctl sentinel:** ✅
- **L3 stack:** gstack(29) + superpowers(14) + smorch-dev v1.5.0 + smorch-ops v1.1.0, strict mode (`SMORCH_STRICT_L3=1`) since 2026-04-29 (per SOP-37)

---

## Hardening baseline (Phase 0 — all 4 servers)

UFW + fail2ban + SSH key-only + unattended-upgrades + swap + perfctl-sentinel. Evidence: `docs/infra/hardening-2026-04-22.md`.

---

## Canonical app → server mapping (2026-04-23 CEO-corrected)

**SMO apps → smo-prod (production) + smo-dev (dev/staging + shared/new)**
**EO apps → eo-prod (production) + smo-dev (staging when needed)**

### smo-prod production apps
| App | Path | Ports | Domain |
|---|---|---|---|
| digital-revenue-score | /opt/apps/digital-revenue-score | pm2 3100 | score.smorchestra.ai |
| gtm-fitness-scorecard | /opt/apps/gtm-fitness-scorecard | pm2 3200 | gtm.smorchestra.ai |
| signal-sales-engine (V3) | /opt/apps/signal-sales-engine | 6001 backend + 6002 frontend | sse.smorchestra.ai |
| content-automation (V1) | /opt/apps/content-automation | docker 3300 gui + 3301 runtime + 5433 pg | app.smorchestra.ai |
| n8n `flow` | docker | 5678 | flows.smorchestra.ai + flow.smorchestra.ai (318 workflows) |

### smo-dev staging + shared/new apps
- `/root/{repo}` for staging clones (L-003)
- n8n `testflow` at testflow.smorchestra.ai (235 workflows, dev + shared)
- Used for: SSE V4 / content-automation V2 / any new product under development

### eo-prod production apps
| App | Path | Domain |
|---|---|---|
| eo-mena | /opt/apps/eo-mena (docker coolify) | entrepreneursoasis.me |
| eo-scoring | /opt/apps/eo-scoring (pm2) | score.entrepreneursoasis.me |
| eo-scorecard | /opt/apps/eo-scorecard (pm2) | (internal) |
| saasfast-page-online | /opt/apps/saasfast-page-online (pm2 3400 + mongo-saasfast docker) | saasfast.entrepreneursoasis.me |
| openclaw-chat | systemd port 18789 | sulaiman.smorchestra.com |
| openclaw-coding | systemd port 18790 | openclaw-coding.smorchestra.ai (vhost pending) |
| moltbot | /root/moltbot pm2 | — |
| n8n `smo-brain` | docker 5678 | ai.mamounalamouri.smorchestra.com (89 workflows — EO orchestration only) |

### eo-dev (formerly smo-eo-qa)
- EO Oasis dev VPS (replica of smo-dev). Caddy + n8n on legacy qa.smorchestra.ai vhost (unprovisioned).
- L3 stack matches smo-dev + laptop. Used for EO Oasis development per SOP-37 (server-side parity).
- Old role: external QA env / Lana's playground per SOP-13. Reclassified 2026-04-29 — Lana QA continues from her Windows laptop.

---

## Dev→Prod promotion path: see SOP-35

---

## Canonical subdomain-per-app pattern (2026-04-23)

Every app gets its own subdomain. Basepath routing is an anti-pattern (rejected by SOP-35).

| App | Prod subdomain | Host |
|---|---|---|
| signal-sales-engine | sse.smorchestra.ai | smo-prod |
| content-automation | **contentengine.smorchestra.ai** | smo-prod |
| digital-revenue-score | score.smorchestra.ai | smo-prod |
| gtm-fitness-scorecard | gtm.smorchestra.ai | smo-prod |
| saasfast-page-online | saasfast.entrepreneursoasis.me | eo-prod |
| n8n flow | flows.smorchestra.ai + flow.smorchestra.ai | smo-prod |
| n8n testflow | testflow.smorchestra.ai | smo-dev |
| n8n smo-brain | ai.mamounalamouri.smorchestra.com | eo-prod |

Staging: prefix with `staging-` (e.g., `staging-sse.smorchestra.ai`) on smo-dev. See SOP-35.

**Retired:** `app.smorchestra.ai/contentengine` basepath pattern — replaced by subdomain 2026-04-23.
