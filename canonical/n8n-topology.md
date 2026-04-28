# Canonical n8n Topology

**Last updated:** 2026-04-23 (live counts verified via SSH)

---

| Instance | Host | Container | Internal port | External domain | Workflows | Purpose |
|---|---|---|---|---|---|---|
| **flow** | smo-prod | `n8n` (n8nio/n8n:latest) | 5678 | flow.smorchestra.ai | **270** | Production orchestration — ACE, content-automation, customer workflows |
| **flows** | smo-dev | `n8n` | 5170→5678 | flows.smorchestra.ai ⚠️ vhost pending | 235 | Dev primary |
| **testflow** | smo-dev | (alias of `flows` container) | 5170 | testflow.smorchestra.ai | 235 | Dev alias |
| **smo-brain** | eo-prod | `n8n` (n8n-docker-n8n) | 5678 | ai.mamounalamouri.smorchestra.com | **89** | EO orchestration — assessments, content vNext, ACE telegram, drift |
| **qa** | eo-dev | `n8n-n8n-1` via caddy | 5678 | qa.smorchestra.ai ⚠️ legacy vhost pending | 0 (new) | Legacy slot — server reclassified 2026-04-29 to eo-dev (EO Oasis dev VPS replica of smo-dev) |

---

## Retired

| Instance | Status | ADR |
|---|---|---|
| **devflow** | Container not running; 56 workflows (stale Feb 25) not recoverable per L-009 | ADR-003 to formalize retirement |

---

## Rules

1. **Docker only.** Host-level `n8n` systemd is banned (confirmed `inactive` across all 4 servers — correct state).
2. **Workflows live in git** too. Every workflow that hits production gets exported to its home repo (`docs/architecture/n8n-workflows/` OR `ace-workflows/` per Signal-Sales-Engine convention) and committed. Import-only on server is L-009 violation.
3. **Encryption keys** captured in `env-manifest.md` (P1 — pending).
4. **Workflow count drift** detected by `/smo-drift --n8n`. Expected +/- 5/week baseline; spikes = investigate.

---

## Backup (Phase H.2)

Nightly at 02:00 UTC per host via `/opt/scripts/backup-n8n.sh`:
1. `n8n export:workflow --all --separate` into `/opt/backups/n8n/{container}-{date}-workflows/`
2. `tar czf` the SQLite DB
3. 14-day daily retention, 12-week weekly archive offsite
4. Heartbeat `https://flow.smorchestra.ai/webhook/n8n-backup-heartbeat`
