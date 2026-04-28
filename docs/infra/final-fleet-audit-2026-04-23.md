# Final Fleet Audit — 2026-04-23

## Servers (SSH-audited via Tailscale)

| Server | Sentinel (*/30) | Infra drift (hourly) | App drift (hourly) | Sync (*/30) | smorch-dev clone | smorch-brain SOPs | UFW/fail2ban/docker |
|---|---|---|---|---|---|---|---|
| **smo-prod** | ✅ | ✅ | ✅ | ✅ | `3985d0b` ✅ | 29 ✅ | active/active/active |
| **smo-dev** | ✅ | ✅ | N/A | ✅ | `3985d0b` ✅ | 29 ✅ | active/active/active |
| **eo-prod** | ✅ | ✅ | ✅ | ✅ | `3985d0b` ✅ | 🟡 0 (local main diverged 15 commits from origin, needs CEO-approved reset) | active/active/active |
| **smo-eo-qa** | ✅ | ✅ | N/A | ✅ | `3985d0b` ✅ | 29 ✅ | active/active/active |

All 4 servers: Phase 0 hardening baseline holds (UFW + fail2ban + SSH key-only + unattended-upgrades + swap). All perfctl sentinels passing clean.

## `/opt/scripts/` per server

| Script | smo-prod | smo-dev | eo-prod | smo-eo-qa |
|---|---|---|---|---|
| perfctl-sentinel.sh | ✅ | ✅ | ✅ | ✅ |
| infra-drift.sh | ✅ | ✅ | ✅ | ✅ |
| app-drift.sh | ✅ | N/A (dev/staging) | ✅ | N/A (QA box) |
| sync-from-github.sh | ✅ | ✅ | ✅ | ✅ |
| health-check.sh | ✅ | — | ✅ | — |
| backup.sh / post-deploy-probe.sh / resource-monitor.sh | ✅ | — | ✅ | — |

eo-prod additionally has legacy ops scripts (config-guardian, daily-pipeline-summary, alert-node-down, check-oauth-expiry) — all predate this rebuild, still useful.

## Mamoun's Mac (Claude Code client)

### Plugins (enabled)
- `smorch-dev@smorch-dev` ✅
- `smorch-ops@smorch-dev` ✅
- `eo-microsaas-dev@eo-microsaas-training` ✅ (student demo plugin)
- `eo-microsaas-os@eo-microsaas-plugin` ✅
- `github@claude-plugins-official` ✅
- gtm-agents marketplace installed (7 plugins available, disabled by default)

### Plugins (available but disabled — enable per-project as needed)
campaign-orchestration, code-review, content-marketing, customer-analytics, email-marketing, frontend-design, growth-experiments, pyright-lsp, revenue-analytics, sales-enablement, sales-pipeline, sales-prospecting, typescript-lsp

### gstack
Not a Claude Code plugin — it's a standalone SKILL (SKILL.md at repo root). Cloned to `~/Desktop/repo-workspace/external-forks/gstack/` per canonical workspace structure. Reference as a skill from any repo that wants it; not a plugin install.

### MCP servers (21 wired in `~/.claude/.mcp.json`)
airtable, chrome-control, clay, contabo-server, exa, figma, ghl-mcp, instantly, linear, ms-office-excel/powerpoint/word, n8n, notes, osascript, pdf-filler, playwright, ssh-mcp, **supabase-sse, supabase-cre, supabase-saasnew** (new today)

Also pre-configured: `supabase-eo` (via existing MCP registration) for `lhmrqdvwtahpgunoyxso` (EO DB).

### Git hooks path (global)
`git config --global core.hooksPath ~/Desktop/repo-workspace/smo/smorch-dev/scripts/hooks` — SET ✅

Active hooks:
- `validate-new-app-structure.sh` (SOP-31)
- `validate-plugin-overlay.sh` (SOP-33)

### launchd agents
- `ai.smorchestra.sync-from-github` (30 min)
- `ai.smorchestra.github-drift` (daily 09:00)

### Secrets
- `~/.claude/secrets/supabase-creds.env` (600 perms, sourced from ~/.zshrc)
- Other secrets (Contabo, GHL, Linear) pending 1Password sync

## Gaps flagged

### P0 (blocks something)
1. **eo-prod smorch-brain divergence** — local `main` at `07107f5` with 15 commits not on origin + 31 commits behind origin. Can't fast-forward. Needs CEO approval for destructive reset (`git reset --hard origin/main`). Until fixed, eo-prod can't read latest SOPs/canonical docs locally. Workaround: all `/opt/scripts/` are current so enforcement runs fine.

### P1 (convenience)
2. **Lana's Mac not audited** (separate device; run `/smo-drift --desktop` on it when she's online).
3. **Secrets populate from 1Password** — Contabo/GHL/Linear env files not yet populated beyond defaults.
4. **HTTPS cert check** on `score.smorchestra.ai` + `gtm.smorchestra.ai` — both returned 000 externally per Phase 3 audit. Investigate nginx vhost.

### P2 (defer)
5. **eng-desktop.sh** currently references scripts shipped to smorch-dev — rerun end-to-end on a fresh test Mac to validate.
6. **Server-side pre-commit hooks** — `core.hooksPath` is a Mac/engineer concern; servers don't commit. Hooks don't need to propagate there.

## Verification commands you can run anytime

```bash
# Servers (from your Mac)
for host in 100.108.44.127 100.83.242.99 100.89.148.62 100.99.145.22; do
  ssh root@$host 'bash /root/smorch-dev/scripts/install/verify-install.sh --role=server-prod 2>&1 | tail -5'
done

# Your Mac
bash ~/Desktop/repo-workspace/smo/smorch-dev/scripts/install/verify-install.sh --role=engineer

# Drift across everything
/smo-drift
```
