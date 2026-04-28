# Server: smo-dev — Dev/Staging
# IP: 62.171.165.57 | Tailscale: 100.83.242.99

## RULES (NON-NEGOTIABLE)
1. Never edit application code on this server. All changes: local -> GitHub -> git pull.
2. Never commit from this server except emergency hotfixes (immediately push and notify Mamoun).
3. Never run destructive commands without Mamoun approval.
4. After any deploy: verify git log --oneline -1 matches GitHub HEAD.
5. After any restart: verify health endpoint returns 200.
6. This is a DEV server. Test here before promoting to production.

## Apps on this server
| App | Port | Path | PM2 name |
|-----|------|------|----------|
| scrapmfast | — | /root/scrapmfast | — |
| moltbot | — | /root/moltbot | — |
| n8n (Docker) | 5678 | Docker | testflow.smorchestra.ai |

NOTE: Signal-Sales-Engine and content-automation are NOT deployed here yet. SSE and content dirs will be created when migration happens.
## Server map
| Server | IP | Tailscale | Role |
|--------|----|-----------|------|
| eo-prod | 89.117.62.131 | 100.89.148.62 | EO production |
| smo-dev | 62.171.165.57 | 100.83.242.99 | Dev/staging (THIS SERVER) |
| smo-prod | 62.171.164.178 | 100.108.44.127 | SMO production |
| eo-dev | 84.247.172.113 | 100.99.145.22 | EO Oasis dev VPS (replica of smo-dev) |

## Dev Tools (installed at ~/.claude/skills/)

| When | Run | Why |
|------|-----|-----|
| Start coding | superpowers: test-driven-development | TDD cycle |
| Every commit | gstack: /review | 4-dimension code review |
| Before PR | /score-project | 5-hat quality gate (90+ to ship) |
| Score < 90 | /bridge-gaps | Fix plan + auto-fix |
| Bug | superpowers: systematic-debugging | Root cause analysis |
| Multi-file | superpowers: subagent-driven-development | Parallel agents |
| Ready to merge | gstack: /ship | Clean PR with artifacts |
| Sprint end | gstack: /retro | What shipped stats |

Workflow: Plan -> TDD -> /review -> /score-project (90+ required) -> /bridge-gaps if needed -> /ship -> /qa -> deploy -> /retro
