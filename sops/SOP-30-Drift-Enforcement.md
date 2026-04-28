# SOP-30 — Drift Enforcement (infra | app | github)

**Status:** Active 2026-04-23
**Phase 5 of April 22 Clean-Slate rebuild**
**Supersedes:** any ad-hoc drift checks prior to 2026-04-23

---

## Why drift matters

Drift is the gap between CANONICAL (what `smorch-brain/canonical/*.md` declares) and ACTUAL (what's running on servers / in GitHub / on desktops). Every hour the gap stays open, risk compounds:
- Wrong version of code running in prod
- Secrets in git history nobody noticed
- Perfctl/crypto-mining reinstalled without alert (see Apr 18 incident)
- L-009 violations accumulating silently

---

## The 3 layers

### 1. Infra drift — hourly per server
Script: `/opt/scripts/infra-drift.sh` (shipped from `smorch-dev/scripts/drift-cron/infra-drift.sh`).
Cron: `0 * * * *` on all 4 servers (smo-prod, smo-dev, eo-prod, smo-eo-qa).

Checks:
- Disk usage <85%
- Services up: docker, fail2ban, nginx (except smo-eo-qa which uses caddy)
- UFW active
- No perfctl IOCs (`/etc/ld.so.preload`, `/lib/libgcwrap.so`)
- Swap present
- SSH password auth disabled
- `unattended-upgrades` installed
- n8n container running where expected

Severity: info (0 drift) / warn (1-3) / critical (4+). Critical posts to Telegram alert channel.

Webhook: `https://flow.smorchestra.ai/webhook/infra-drift`
Log: `/var/log/infra-drift.log`

### 2. App drift — hourly on central hosts
Script: `/opt/scripts/app-drift.sh` (from `smorch-dev/scripts/drift-cron/app-drift.sh`).
Cron: `15 * * * *` on smo-prod + eo-prod (hosts that carry `/opt/apps/*`).

For each `/opt/apps/{repo}/`:
- Local HEAD vs `origin/main` (or `origin/master`) — any divergence = drift
- No uncommitted local modifications on prod (L-009 violation)
- `.env.local` or `.env` present (L-001 baseline)

Webhook: `https://flow.smorchestra.ai/webhook/app-drift`
Log: `/var/log/app-drift.log`

### 3. GitHub drift — daily on Mamoun's Mac
Script: `~/.claude/scripts/github-drift.sh` (from `smorch-dev/scripts/drift-cron/github-drift.sh`).
Scheduler: launchd agent `ai.smorchestra.github-drift` — runs daily at 09:00 local.

For every active repo (17 in registry):
- Default branch is `main`
- `main` has branch protection (1-review PR)
- 3 canonical topics present (domain + lifecycle + distribution)
- Org-wide Dependabot critical alert count = 0

Webhook: `https://flow.smorchestra.ai/webhook/github-drift`
Log: `~/.claude/logs/github-drift.log`

---

## How alerts propagate

All 3 scripts POST to n8n webhooks. The `flow` n8n instance on smo-prod has workflows (TBD — to be built in Phase 6) that:
1. Aggregate findings into a daily digest
2. Route `critical` severity to Telegram ops channel immediately
3. Open Linear tickets for unresolved `warn` drift lasting >48h

---

## What users do when drift fires

### Infra drift critical
Halt all deploys. Investigate: `journalctl -u {service}` on affected host. If perfctl IOCs → incident protocol (isolate server via Tailscale block, reinstall from clean OS baseline per Phase 0 hardening).

### App drift warn
If `behind-N` on `/opt/apps/{repo}` → someone deployed but didn't sync git. Run `git pull --ff-only` or rebuild. If `local-modified` → someone edited on the server (prohibited per MASTER-PLAN rule 1). Restore from git + investigate.

### GitHub drift warn
Branch protection or default branch changed = someone bypassed SOP-20. Restore immediately via `gh api PATCH`. Missing topics = run `scripts/github-audit/phase-1-apply.sh --apply`.

---

## Decommissioning manual drift checks

Before SOP-30, drift was caught by manual `/smo-drift` invocation (engineer's discretion). That's insufficient — drift doesn't wait for someone to remember to check.

SOP-30 makes drift detection mechanical. The `/smo-drift` command still exists for on-demand checks (SOP-14 workflow), but the cron + launchd agents run whether anyone remembers or not.

---

## Evidence

- Scripts: `smorch-dev/scripts/drift-cron/{infra,app,github}-drift.sh`
- SOP: this file
- Deployment evidence: commit `phase-5-drift-cron-deploy-2026-04-23.md` in `smorch-brain/docs/infra/`
