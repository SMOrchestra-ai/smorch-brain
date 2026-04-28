# Server: smo-prod — SMO Production
# IP: 62.171.164.178 | Tailscale: 100.84.76.35

## RULES (NON-NEGOTIABLE)
1. Never edit application code on this server. All changes: local -> GitHub -> git pull.
2. Never commit from this server except emergency hotfixes (immediately push and notify Mamoun).
3. Never run destructive commands without Mamoun approval.
4. After any deploy: verify git log --oneline -1 matches GitHub HEAD.
5. After any restart: verify health endpoint returns 200.
6. Never expose app ports directly. All apps behind nginx reverse proxy.

## Apps on this server
| App | Port | Path | Health URL | PM2 name |
|-----|------|------|-----------|----------|
| digital-revenue-score | 3100 | /opt/apps/digital-revenue-score | localhost:3100/RevenueOS/api/health | digital-revenue-score |
| gtm-fitness-scorecard | 3200 | /opt/apps/gtm-fitness-scorecard | localhost:3200/matrix/api/health | gtm-fitness-scorecard |
| n8n (Docker) | 5678 | Docker | localhost:5678/healthz | Docker container |

## Deploy procedure (per app)
Deploying eo-mena...
HEAD is now at 606c60a feat: add auto-deploy job to CI — deploys on push via SSH

added 38 packages, and audited 39 packages in 5s

5 packages are looking for funding
  run `npm fund` for details

1 high severity vulnerability

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.

> src-app@0.1.0 build
> next build

  ▲ Next.js 14.2.35
  - Environments: .env.local

   Creating an optimized production build ...
Deploy script does: save rollback point -> git pull -> npm ci -> build (rollback on fail) -> pm2 reload -> health check (3 retries, rollback on fail).

## Monitoring
- Health check: /opt/scripts/health-check.sh (every 15 min, Telegram alert on failure)
- Drift detection: /opt/scripts/drift-check.sh (every 6h)
- Resource monitor: /opt/scripts/resource-monitor.sh (every 5 min)
- Logrotate: /etc/logrotate.d/smo-apps (daily, 14 day retention)
- Backup: /opt/scripts/backup.sh (daily at 3am Dubai)

## Server map
| Server | IP | Tailscale | Role |
|--------|----|-----------|------|
| eo-prod | 89.117.62.131 | 100.89.148.62 | EO production |
| smo-dev | 62.171.165.57 | 100.83.242.99 | Dev/staging |
| smo-prod | 62.171.164.178 | 100.84.76.35 | SMO production (THIS SERVER) |
| eo-dev | 84.247.172.113 | 100.99.145.22 | EO Oasis dev VPS (replica of smo-dev) |

## Dev Tools (installed at ~/.claude/skills/)

| When | Run | Why |
|------|-----|-----|
| Start coding | superpowers: test-driven-development | TDD cycle |
| Every commit | gstack: /review | 4-dimension code review |
| Before PR | /score-project | 5-hat quality gate (90+ to ship) |
| Score < 90 | /bridge-gaps | Fix plan + auto-fix |
| Bug | superpowers: systematic-debugging | Root cause analysis |
| Ready to merge | gstack: /ship | Clean PR with artifacts |

Workflow: Plan -> TDD -> /review -> /score-project (90+ required) -> /bridge-gaps if needed -> /ship -> /qa -> deploy -> /retro
