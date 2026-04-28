# Server: eo-dev — EO Oasis Dev VPS (replica of smo-dev)
# IP: 84.247.172.113 | Tailscale: 100.99.145.22
# Renamed: 2026-04-29 (was smo-eo-qa). Reclassified as EO dev VPS per SOP-37.

## ROLE
EO Oasis development server — replica of smo-dev. Used for EO MicroSaaS staging,
EO-Brain deployments, and any pre-prod EO work. Full L3 stack (gstack +
superpowers + smorch-dev v1.5.0 + smorch-ops v1.1.0) installed; strict mode.

This server is NOT the QA runner anymore. Lana QA continues from her Windows
laptop. The legacy `qa` n8n container at `qa.smorchestra.ai` (vhost still
pending) remains for backwards compat but is not actively maintained.

## RULES (NON-NEGOTIABLE)
1. Never edit application code directly on this server. Local → GitHub → server pull.
2. Pull tags only, never branches. Restart PM2 to deploy.
3. Strict L3 mode: `SMORCH_STRICT_L3=1` set in `/root/.bashrc`. Sessions refuse
   to start if gstack or superpowers are missing (per SOP-36).
4. No paid-resource creates from server (RULE 0 in global CLAUDE.md is inherited).
5. Branch protection: SOP-31/33/34 validators must be enforced.
6. Server discipline: SOP-14 (plugin workflow), SOP-15 (cross-machine sync),
   SOP-37 (server-side parity).

## L3 stack on this server (per SOP-37)
- `~/.claude/skills/gstack/` — 29 skills
- `~/.claude/skills/superpowers/` (symlink) — 14 skills
- `~/.claude/plugins/cache/smorch-dev/smorch-dev/1.5.0/` — 15 commands
- `~/.claude/plugins/cache/smorch-dev/smorch-ops/1.1.0/` — 7 commands
- `bash ~/.claude/plugins/cache/smorch-dev/smorch-dev/1.5.0/scripts/l3-health-check.sh --strict`
  → must return `L3 ✓ gstack(29/29) superpowers(14/14)`

## Dev workflow on this server
The same 18-command sequence works here as on the laptop. Most flows happen on
the laptop and deploy here via `/smo-deploy --target eo-dev`. Direct sessions
on the server are for incident triage or emergency fixes only.

## Server map (canonical)
| Server | Public IP | Tailscale | Role |
|--------|-----------|-----------|------|
| eo-prod | 89.117.62.131 | 100.89.148.62 | EO production |
| smo-dev | 62.171.165.57 | 100.83.242.99 | SMO dev/staging |
| smo-prod | 62.171.164.178 | 100.108.44.127 | SMO production |
| **eo-dev (THIS)** | 84.247.172.113 | 100.99.145.22 | EO dev/staging (replica of smo-dev) |

## Backups + sentinel
- Perfctl sentinel: `/opt/scripts/perfctl-sentinel.sh` every 30 min
- nightly n8n backup: per L-001 (back up `.env*` before any destructive maintenance)
