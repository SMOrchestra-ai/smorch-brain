# Guide 04 — Set up a new machine (Engineer or QA)

## Engineer Desktop (Mac/Linux)

### One-liner install

```bash
curl -fsSL https://raw.githubusercontent.com/SMOrchestra-ai/smorch-dev/main/install/eng-desktop.sh | bash
```

### What the script does (read before piping to bash)

1. **Prereqs** — verify/install: git, gh CLI, node 20+ LTS, python 3.11+, docker, Tailscale
2. **Auth prompts** — `gh auth login`, `tailscale up`, `claude auth login`
3. **Clone canonical tree** to `~/Desktop/repo-workspace/{smo,eo,shared,external-forks}/` via `gh repo clone` (17 active repos)
4. **Checkout `dev` branch** on every active clone
5. **Install Claude Code plugins**:
   - `smorch-dev` (default dev workflow)
   - `smorch-ops` (deploy/drift/secrets)
   - `eo-microsaas-dev` (if `--eo-flag` passed, for student demo machines)
6. **Install MCP servers** (edit `~/.claude/.mcp.json`):
   - Supabase (supabase-sse, supabase-cre, supabase-saasnew, supabase-eo)
   - Contabo + SSH MCPs (from contabo-mcp-server monorepo)
   - GHL MCP, Linear MCP, Exa, Playwright, Clay, Instantly
7. **Install git hooks** in `~/.config/git/hooks/` (via `git config --global core.hooksPath`):
   - destructive-blocker (rejects `rm -rf` on protected paths)
   - secret-scanner-v2 (gitleaks-style pattern match pre-commit)
   - branch-protection-enforcer (rejects direct commit to main/dev)
   - commit-msg-enforcer (conventional commits)
   - drift-flagger (warn on local-ahead >1 day or dirty >1 hour)
8. **Wire sync-from-github** — copy `sync-from-github.sh` to `~/.claude/scripts/` + install launchd agent `ai.smorchestra.sync-from-github` (runs every 1800s)
9. **Wire github-drift** — copy + launchd agent `ai.smorchestra.github-drift` (daily 09:00)
10. **Provision `~/.claude/secrets/`** dir (700 perms) — empty. User fills via 1Password lookup.
11. **Shell profile** — append to `~/.zshrc`:
    - `source ~/.claude/secrets/supabase-creds.env` (if present)
    - `export PROJECT_ROOT=~/Desktop/repo-workspace`
    - `alias cp='cd ~/Desktop/repo-workspace'` (optional convenience)

### Post-install manual steps (can't be scripted)

1. Populate `~/.claude/secrets/supabase-creds.env` with PATs + service_role keys (from 1Password vault `SMOrchestra Infrastructure`)
2. Populate `~/.claude/secrets/contabo-creds.env` (CONTABO_CLIENT_ID, CLIENT_SECRET, API_USER, API_PASSWORD)
3. Populate `~/.claude/secrets/ghl-creds.env` (GHL_API_KEY, GHL_LOCATION_ID)
4. Restart Claude Code to pick up new MCPs
5. Verify: `claude plugin list` shows smorch-dev + smorch-ops
6. Verify: `launchctl list | grep smorchestra` shows sync-from-github + github-drift
7. Test: `cd ~/Desktop/repo-workspace/smo/smorch-brain && git pull` succeeds
8. First-time Lana-only: run `/smo-qa-handover-score --dry-run` against a fake handover to ensure tooling wired

### Onboarding timebox: 15 min

If it takes longer, something's broken — file Linear ticket in `engineering-onboarding` project.

---

## QA Machine (Lana — Mac or Windows)

### Mac: same eng-desktop.sh with `--role qa`

Adds on top of engineer profile:
- `playwright install chromium firefox webkit` (full browser matrix)
- `npm install -g @axe-core/cli lighthouse`
- MENA checker CLIs: `arabic-rtl-checker`, `mena-mobile-check` (from smorch-dev plugin)
- Linear MCP (QA ticket management)
- Telegram CLI (for incident notifications)
- Skip MCP installs that engineer-only needs (contabo, ssh — QA doesn't deploy)
- Sets default branch for local clones to `main` (Lana QAs production builds, not dev)

### Windows: `qa-machine.ps1`

```powershell
iwr -useb https://raw.githubusercontent.com/SMOrchestra-ai/smorch-dev/main/install/qa-machine.ps1 | iex
```

Same outcome, PowerShell-native. Uses Chocolatey for prereqs. Installs Claude Desktop app + extension for Chrome.

### smo-eo-qa server provisioning (external QA environment)

Separate — not a personal machine. Run on the server itself:

```bash
ssh root@100.99.145.22  # Tailscale
curl -fsSL https://raw.githubusercontent.com/SMOrchestra-ai/smorch-dev/main/install/qa-machine.sh | bash
```

This installs:
- Playwright + axe + Lighthouse headless
- n8n (docker, for qa.smorchestra.ai — nightly smoke workflows)
- Caddy (reverse proxy for qa.smorchestra.ai)
- Drift + sync crons (same as other servers)
- Perfctl sentinel

---

## Server provisioning (new VPS for a production deploy)

```bash
ssh root@{new-vps-ip}
curl -fsSL https://raw.githubusercontent.com/SMOrchestra-ai/smorch-dev/main/install/prod-server.sh | bash
```

Runs Phase 0 hardening baseline + docker + pm2 + nginx + deploy user + perfctl sentinel + drift cron + sync cron. ~10 min on fresh Ubuntu 24.04.

Then register the server:
1. Add row to `smorch-brain/canonical/server-role-registry.md`
2. Add Tailscale IP
3. Update DNS for any domain that should resolve here
4. Run `/smo-drift --host {new-server}` to confirm baseline green

---

## Verification checklist (any machine, after install)

| Check | Command | Pass |
|---|---|---|
| Claude plugins loaded | `claude plugin list` | shows smorch-dev + smorch-ops |
| MCPs resolve | `cat ~/.claude/.mcp.json \| jq '.mcpServers \| keys'` | 12+ servers listed |
| Tailscale mesh | `tailscale status` | all 4 SMO servers show online |
| GitHub auth | `gh auth status` | logged in with admin:org + repo scopes |
| Secrets file perms | `ls -la ~/.claude/secrets/` | 700 on dir, 600 on files |
| Sync cron running | `launchctl list \| grep smorchestra` (Mac) or `crontab -l` (Linux/server) | both agents listed |
| Repo tree exists | `ls ~/Desktop/repo-workspace/smo` | 10 repos |
| Git hooks active | `cd ~/Desktop/repo-workspace/smo/smorch-brain && git commit --allow-empty -m "test"` | pre-commit runs |
| Drift check clean | `/smo-drift` | 0 findings |

## Enforcement

See `SOP-34 Desktop-Setup-Discipline` (created in this phase) which details which install script runs on which machine + verification gates.
