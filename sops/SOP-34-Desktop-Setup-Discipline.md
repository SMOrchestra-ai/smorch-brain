# SOP-34 — Desktop Setup Discipline (enforced)

**Status:** Active 2026-04-23

## Rule

Every SMOrchestra machine (engineer, QA, server) is provisioned by ONE idempotent script. No hand-configured machines.

| Machine class | Install script | Runtime |
|---|---|---|
| Engineer Mac/Linux | `smorch-dev/install/eng-desktop.sh` | ~15 min |
| QA Mac | `smorch-dev/install/eng-desktop.sh --role qa` | ~15 min |
| QA Windows (Lana) | `smorch-dev/install/qa-machine.ps1` | ~20 min |
| Production VPS | `smorch-dev/install/prod-server.sh` | ~10 min on fresh Ubuntu 24.04 |
| Staging VPS | `smorch-dev/install/dev-server.sh` | ~10 min |
| QA VPS (smo-eo-qa) | `smorch-dev/install/qa-machine.sh` | ~15 min |

## Mandatory outcomes (verification gates)

Every install script MUST produce:

### All machine types
1. Git hooks active globally (`core.hooksPath` → `smorch-dev/scripts/hooks/`)
2. `~/.claude/secrets/` directory (700 perms)
3. Tailscale connected to SMO mesh
4. Sync-from-github scheduled (cron/launchd every 30min)
5. Perfctl sentinel running (every 30min) on server profiles

### Engineer + QA
6. Claude Code + marketplaces registered (smorch-dev + smorch-ops + eo-microsaas-training if --eo-flag)
7. `~/.claude/.mcp.json` with canonical MCP servers (Supabase × N, Contabo, SSH, GHL, Linear, Exa, Playwright)
8. `~/Desktop/repo-workspace/` tree with 21 active repos on `dev` branch
9. `gh auth status` shows admin:org + repo scopes

### QA only (adds to engineer)
10. Playwright + axe-core + Lighthouse installed
11. MENA checker CLIs installed
12. Default local branch = `main` on active repos (Lana QAs production builds)

### Server only
13. UFW + fail2ban + SSH key-only + unattended-upgrades + swap (Phase 0 hardening)
14. Docker + nginx (smo-prod, smo-dev, eo-prod) OR caddy (smo-eo-qa)
15. `/opt/apps/` + `/opt/config/` + `/opt/logs/` + `/opt/backups/` + `/opt/scripts/` dirs
16. Drift cron (infra-drift.sh hourly) + app-drift.sh (smo-prod + eo-prod)
17. Backup crons (backup-n8n.sh, backup-db.sh, backup-env.sh at 02:00-03:00 UTC)

## Verification script

Every install script ends with `verify-install.sh`. Fails loud if any gate above missing.

```bash
# Engineer machine post-install verification
verify-install.sh --role=engineer
# Output:
# ✓ git hooks active
# ✓ ~/.claude/secrets/ 700 perms
# ✓ tailscale connected (4 peers)
# ✓ launchd sync-from-github loaded
# ✓ claude plugins: smorch-dev smorch-ops
# ✓ mcp servers: 12 configured
# ✓ repo-workspace tree: 21 repos
# ✓ gh auth: admin:org repo workflow
# 8/8 gates PASSED
```

If any gate fails, machine is NOT considered provisioned. Flag in Linear + re-run install.

## Enforcement

- Install scripts versioned via smorch-dev tags. Running an old script against current canonical = warned + aborted.
- `/smo-drift --desktop` on any existing machine reports gaps vs SOP-34 baseline.
- `sync-from-github.sh` includes a `verify-install.sh` weekly self-check. Posts severity=critical to webhook if baseline regressed.

## Onboarding new hire (engineer)

1. CEO issues GitHub seat + Tailscale invite
2. New hire runs: `curl -fsSL https://raw.githubusercontent.com/SMOrchestra-ai/smorch-dev/main/install/eng-desktop.sh | bash`
3. Auth prompts: GitHub, Tailscale, Claude
4. Post-install: new hire fills secrets from 1Password shared vault access (CEO grants)
5. Verify: `/smo-drift --desktop` = 0 findings
6. First work: `cd ~/Desktop/repo-workspace/{tier}/{repo}` + `/smo-plan` any bug ticket

**Timebox: 30 min from GitHub seat → first commit. If longer, process is broken.**

## Onboarding new QA (Lana equivalent)

Same as engineer with `--role qa`. Additional 15 min for:
- Test run against smo-eo-qa environment
- `/smo-qa-handover-score --dry-run` against fake handover
- Telegram CLI login

## Decommissioning a machine (engineer leaves)

1. Revoke GitHub seat
2. Revoke Tailscale node
3. Revoke 1Password shared vault access
4. Rotate any credentials that touched `~/.claude/secrets/` on that machine (per SOP-16)
5. Audit: `/smo-secrets --audit --rotated-since {departure-date}`
6. Ensure no repos have that engineer as sole maintainer (reassign in GitHub)

## Exceptions

None. Every machine follows this SOP. If a use-case doesn't fit, update the install script — don't carve out per-person exceptions.
