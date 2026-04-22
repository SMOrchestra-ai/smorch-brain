# Phase 5 Evidence — Drift + Cron Deployment

**Date:** 2026-04-23
**SOP:** SOP-30-Drift-Enforcement.md (shipped this phase)

## Deployed

### All 4 servers (via Tailscale SSH)
| Host | /opt/scripts/infra-drift.sh | cron | First-run result |
|---|---|---|---|
| smo-prod | ✅ | `0 * * * *` | OK, 0 drift |
| smo-dev | ✅ | `0 * * * *` | OK, 0 drift |
| eo-prod | ✅ | `0 * * * *` | OK, 0 drift |
| smo-eo-qa | ✅ | `0 * * * *` | OK, 0 drift |

### Central hosts additionally
| Host | /opt/scripts/app-drift.sh | cron |
|---|---|---|
| smo-prod | ✅ | `15 * * * *` |
| eo-prod | ✅ | `15 * * * *` |

### Mamoun's Mac
| Item | State |
|---|---|
| `~/.claude/scripts/github-drift.sh` | installed |
| launchd agent `ai.smorchestra.github-drift` | loaded, scheduled 09:00 daily |
| First test run | 0 drift findings ✅ |

## Webhooks

All 3 scripts POST to `flow.smorchestra.ai/webhook/*-drift`. n8n aggregator workflow (build in Phase 6) will route critical findings to Telegram + open Linear tickets for unresolved warn >48h.

## What Phase 5 proves

Drift detection is now MECHANICAL — runs on cron/launchd regardless of who's at the keyboard. Satisfies the "cannot be fucked up again" principle of the rebuild.

## Gate

Phase 5 complete. Proceeding to Phase 6.
