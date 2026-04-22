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
| **smo-eo-qa** | 100.99.145.22 | 84.247.172.113 | External QA environment | qa.smorchestra.ai |

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

### smo-eo-qa (Lana's QA)
- **pm2:** empty (QA tooling pending provisioning — Phase L)
- **n8n:** `n8n-n8n-1` via caddy — 0 workflows (new, for QA smoke/nightly)
- **Perfctl sentinel:** ✅

---

## Hardening baseline (Phase 0 — all 4 servers)

UFW + fail2ban + SSH key-only + unattended-upgrades + swap + perfctl-sentinel. Evidence: `docs/infra/hardening-2026-04-22.md`.
