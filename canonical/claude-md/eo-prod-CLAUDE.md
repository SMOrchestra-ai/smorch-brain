# Server: eo-prod — EO Production
# IP: 89.117.62.131 | Tailscale: 100.89.148.62

## RULES (NON-NEGOTIABLE)
1. Never edit application code on this server. All changes: local -> GitHub -> git pull.
2. Never run destructive commands (bulk delete, DROP TABLE, force push, hard reset).
3. Never expose secrets in logs, commits, or console output.
4. Never restart services without confirming current state first (pm2 list, systemctl status).
5. Always verify health after any change (curl localhost:{port}/api/health).
6. Never modify nginx configs without running nginx -t before reload.

## Apps on this Server

| App | Path | PM2 | Port | Domain | Branch |
|-----|------|-----|------|--------|--------|
| eo-mena | /root/eo-mena-new/ | eo-main | 3000 | entrepreneursoasis.me | main |
| eo-scoring | /var/www/eo-scoring/ | eo-scoring | 3200 | score.entrepreneursoasis.me | dev |
| smorch-brain | /root/smorch-brain/ | N/A | N/A | N/A | dev |
| n8n (Docker) | Docker | N/A | 5678 | ai.mamounalamouri.smorchestra.com | N/A |

## Deploy Procedure
cd /root/eo-mena-new/ (or /var/www/eo-scoring/)
git pull origin main (or dev for eo-scoring)
npm ci && npm run build
pm2 reload eo-main (or eo-scoring)
curl -sf http://localhost:3000/api/health (verify)

## Health Checks
curl -sf http://localhost:3000/ (eo-mena)
curl -sf http://localhost:3200/ (eo-scoring)
pm2 list (all processes)

## Server Map
| Server | IP | Tailscale | Role |
|--------|----|-----------|------|
| eo-prod (THIS) | 89.117.62.131 | 100.89.148.62 | EO production |
| smo-dev | 62.171.165.57 | 100.83.242.99 | Dev/staging |
| smo-prod | 62.171.164.178 | 100.84.76.35 | SMO production |
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
