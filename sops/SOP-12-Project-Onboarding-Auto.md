---
status: active
last_reviewed: 2026-04-19
---

# SOP-12: Project Onboarding -- Automated Pre-Flight Check

**Version:** 1.0 | **Date:** April 2026
**Scope:** Every new project or major feature before the first line of code
**Locked by:** Mamoun Alamouri, 2026-04-06

---

## Purpose

Verify ALL dependencies before the first line of code ships. Every blocker discovered mid-build costs 30-60 minutes of context-switching, debugging, and Telegram escalation. This pre-flight catches them upfront.

**Trigger:** Automatically on project kickoff (Sulaiman dispatches after BRD approval), or manually via `/project-onboard`.

---

## Issue Categories

| Category | Meaning | Action |
|---|---|---|
| **BLOCKER** | Cannot proceed. Needs Mamoun's intervention (credentials, access, billing). | Telegram to Mamoun immediately with action link. |
| **WARNING** | Degrades experience but work can continue. | Log in Linear, fix in parallel. |
| **AUTO-FIX** | Agent can resolve without human input. | Fix immediately, log what was done. |

---

## Pre-Flight Checklist (17 Sections)

### 1. Auth & Access

Verify Claude Code and Codex are authenticated on both servers.

```bash
# On smo-brain (100.89.148.62)
claude --version          # Confirm installed
claude auth status        # Confirm authenticated

# On smo-dev (100.117.35.19)
claude --version
claude auth status

# Root permission fix (if needed)
sudo chown -R $(whoami) /workspaces/smo/[repo-name]
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Claude Code on smo-brain | Auth status returns valid session | BLOCKER |
| Claude Code on smo-dev | Auth status returns valid session | BLOCKER |
| Repo write permission | Agent can create files in repo dir | AUTO-FIX |

### 2. Network / Tailscale

Cross-server SSH and Tailscale mesh connectivity.

```bash
# From smo-brain
ssh smo-dev "echo ok"                    # Cross-server SSH
tailscale status                          # Mesh network status
tailscale ping 100.117.35.19             # Ping smo-dev

# From smo-dev
ssh smo-brain "echo ok"
tailscale ping 100.89.148.62
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| SSH smo-brain -> smo-dev | Returns "ok" | BLOCKER |
| SSH smo-dev -> smo-brain | Returns "ok" | BLOCKER |
| Tailscale session | Status shows both nodes online | BLOCKER |
| Session expiry | Tailscale key not expiring within 7 days | WARNING |

### 3. Database / Supabase

```bash
# Verify Supabase CLI and connection
supabase --version
supabase status                          # Project status
supabase db ping                         # Database reachable

# Check env vars
grep SUPABASE_URL .env
grep SUPABASE_ANON_KEY .env
grep SUPABASE_SERVICE_ROLE_KEY .env
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Supabase URL in .env | Non-empty, matches project | BLOCKER |
| Supabase keys in .env | Both anon and service role present | BLOCKER |
| DB ping | Responds within 5s | BLOCKER |
| IP allowlist | smo-dev IP whitelisted in Supabase dashboard | BLOCKER |
| MCP linking | Supabase MCP connector responds to test query | WARNING |

### 4. Environment Variables

```bash
# Check .env exists
[ -f .env ] && echo "EXISTS" || echo "MISSING"

# Compare with example
diff <(grep -oP '^[A-Z_]+' .env.example | sort) <(grep -oP '^[A-Z_]+' .env | sort)

# Check for secrets in git
git log --all --diff-filter=A -- '*.env' '.env*'
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| .env exists | File present in repo root | BLOCKER |
| .env matches .env.example | All keys present (values may differ) | WARNING |
| No secrets in git | No .env files in git history | BLOCKER (if found) |

### 5. n8n Connection

```bash
# smo-brain n8n (orchestration)
curl -s http://100.89.148.62:5678/healthz

# smo-dev n8n (workflow testing)
curl -s http://100.117.35.19:5170/healthz

# MCP accessible
# Test via n8n MCP connector
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| n8n on smo-brain | Health returns 200 | BLOCKER |
| n8n on smo-dev | Health returns 200 | WARNING |
| Webhook URLs | Base URLs resolve correctly | WARNING |

### 6. Agent Communication

```bash
# Paperclip health
curl -s http://100.89.148.62:3100/health

# Agent wake test (via OpenClaw)
# Verify Sulaiman responds to ping
# Verify al-Jazari responds to ping

# Issue dispatch test
# Create test issue in Linear, verify Sulaiman picks it up
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Paperclip health | Returns 200 | BLOCKER |
| Sulaiman wake | Responds within 30s | BLOCKER |
| al-Jazari wake | Responds within 30s | BLOCKER |
| Issue dispatch | Test issue routed correctly | WARNING |

### 7. MCP Connectors

```bash
# Linear MCP
# Verify: can list issues, create issue, add comment

# n8n MCP
# Verify: can list workflows, get workflow details

# Playwright MCP
# Verify: browser launch, page navigation

# Supabase MCP
# Verify: can query test table
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Linear MCP | List issues returns results | WARNING |
| n8n MCP | List workflows returns results | WARNING |
| Playwright MCP | Browser launches headless | WARNING |
| Supabase MCP | Test query returns data | BLOCKER |

### 8. Model Usage Status

```bash
# Claude Max quota
# Check remaining tokens / rate limit status

# Codex active
# Verify Codex API responds

# OpenAI token refresh
# Verify token not expired

# Gemini heartbeat (if used)
# Verify Gemini API responds
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Claude Max quota | > 20% remaining or unlimited | WARNING |
| Codex active | API responds to health check | WARNING |
| OpenAI token | Not expired | AUTO-FIX (refresh) |
| Gemini | Responds to ping (if configured) | WARNING |

### 9. Git & Repo

```bash
# Repo cloned on smo-dev
ls /workspaces/smo/[repo-name]/.git

# Correct branch
git -C /workspaces/smo/[repo-name] branch --show-current

# Remote auth
git -C /workspaces/smo/[repo-name] fetch --dry-run

# Tags
git -C /workspaces/smo/[repo-name] tag -l
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Repo cloned | .git directory exists on smo-dev | BLOCKER |
| Correct branch | On dev or feature branch (not main) | AUTO-FIX |
| Remote auth | Fetch succeeds without auth prompt | BLOCKER |
| Tags | Latest release tag matches expected | WARNING |

### 10. Browser Dependencies

```bash
# Playwright browsers
npx playwright install --dry-run
npx playwright install chromium   # If missing
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Chromium installed | Playwright can launch headless Chrome | AUTO-FIX |
| Dependencies | System deps for headless browser present | AUTO-FIX |

### 11. Redis / Cache

```bash
# If project uses Redis
redis-cli ping
redis-cli info memory | head -5
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Redis running | PONG response | BLOCKER (if required) |
| Memory | < 80% used | WARNING |

### 12. OpenClaw Config

```bash
# Gateway settings
cat /etc/openclaw/gateway.yaml | head -20

# Agent configs
ls /etc/openclaw/agents/

# Hooks
cat /etc/openclaw/hooks.yaml

# Cron
crontab -l | grep openclaw
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Gateway config | Valid YAML, correct ports | BLOCKER |
| Agent configs | All 7 agents have config files | WARNING |
| Hooks | Pre/post hooks registered | WARNING |
| Cron | Health check cron active | AUTO-FIX |

### 13. Deployment Infrastructure

```bash
# smo-dev is the deploy server
ssh smo-dev "docker ps"                   # Running containers
ssh smo-dev "systemctl status nginx"      # Reverse proxy
ssh smo-dev "df -h /"                     # Disk space
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| smo-dev for deploys | SSH accessible, docker running | BLOCKER |
| smo-brain for orchestration | Paperclip + OpenClaw + n8n running | BLOCKER |
| Disk space | > 20% free on both servers | WARNING |

### 14. Security

```bash
# Scan for API keys in .env (only Google allowed per policy)
grep -E '(OPENAI|ANTHROPIC|STRIPE|AWS)_.*KEY' .env

# Secret scanning
git secrets --scan 2>/dev/null || echo "git-secrets not installed"

# .gitignore includes .env
grep '.env' .gitignore
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| No unauthorized API keys | Only Google API key in .env | BLOCKER (if others found) |
| Secret scanning | No secrets in git history | BLOCKER (if found) |
| .gitignore | .env listed | AUTO-FIX |

### 15. Team Communication

```bash
# Telegram blocker pipeline
# Verify: n8n workflow "Blocker Alert to Mamoun" is active
# Test: Send test message, confirm delivery
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Telegram pipeline active | n8n blocker alert workflow enabled | BLOCKER |
| Test delivery | Test message received by Mamoun | WARNING |

### 16. Service Health

```bash
# smo-brain services
ssh smo-brain "systemctl is-active paperclip openclaw n8n"

# smo-dev services
ssh smo-dev "systemctl is-active docker nginx"
# Or if using docker:
ssh smo-dev "docker ps --format '{{.Names}}: {{.Status}}'"
ssh smo-brain "docker ps --format '{{.Names}}: {{.Status}}'"
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| Paperclip | Active/running | BLOCKER |
| OpenClaw | Active/running | BLOCKER |
| n8n (brain) | Active/running | BLOCKER |
| Docker (dev) | Active/running | BLOCKER |
| nginx (dev) | Active/running | WARNING |

### 17. Lana Access

```bash
# GitHub org membership
gh api orgs/SMOrchestra/members --jq '.[].login' | grep lana

# Linear access
# Verify Lana can view project board

# Repo access
gh api repos/SMOrchestra/[repo-name]/collaborators --jq '.[].login' | grep lana
```

| Check | Pass Criteria | Fail Category |
|---|---|---|
| GitHub org member | Lana's account listed | BLOCKER |
| Linear access | Can view and comment on project | BLOCKER |
| Repo access | Read + write on active repos | BLOCKER |

---

## Output: Consolidated Report

After all 17 sections complete, generate a consolidated report:

```markdown
# Pre-Flight Report: [Project Name]
**Date:** YYYY-MM-DD HH:MM UTC+4
**Run by:** [Agent name]

## Summary
- BLOCKERS: [count]
- WARNINGS: [count]
- AUTO-FIXED: [count]
- PASSED: [count] / 17 sections

## Blockers (Needs Mamoun)
1. [Section #] [Description] -- [Action Mamoun must take]

## Warnings (Degraded but Workable)
1. [Section #] [Description] -- [Parallel fix plan]

## Auto-Fixed
1. [Section #] [Description] -- [What was fixed]

## All Clear Sections
[List of sections that passed all checks]

## Recommendation
[PROCEED / HOLD -- with reasoning]
```

**Delivery:** Report is sent to Mamoun via Telegram if any BLOCKERS exist. If all clear, posted as Linear comment on the project kickoff issue.

---

## When to Re-Run

- After every Mamoun-resolved blocker (confirm it's actually fixed)
- After server maintenance or restart
- After Tailscale re-authentication
- After OpenClaw or Paperclip config changes
- Weekly as a health check (automated via cron)
