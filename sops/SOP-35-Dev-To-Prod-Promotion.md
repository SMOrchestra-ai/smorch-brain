# SOP-35 — Dev → Prod Promotion (App Code + n8n Workflows)

**Status:** Active 2026-04-23
**Scope:** Every new major version of an app (SSE V4, content-automation V2, etc.). Also applies to n8n workflow promotion.

---

## Canonical server mapping (enforced)

| Domain tag | Dev/Staging box | Production box | Rule |
|---|---|---|---|
| `smo` | **smo-dev** (62.171.165.57 / 100.83.242.99) | **smo-prod** (62.171.164.178 / 100.108.44.127) | All SMO apps + new/shared apps under development start here |
| `eo` | smo-dev OR eo-prod staging path | **eo-prod** (89.117.62.131 / 100.89.148.62) | All EO apps (eo-mena, eo-scoring, eo-scorecard, saasfast-page-online, moltbot, openclaw) |
| `shared` | **smo-dev** | host determined by which ecosystem consumes it first | Start on smo-dev until primary consumer is clear |

## n8n instance mapping

| n8n | Host | Domain | Role |
|---|---|---|---|
| **flow** / flows | smo-prod | flows.smorchestra.ai + flow.smorchestra.ai | Production SMO orchestration (SSE V3 ACE, content-automation, campaigns) |
| **testflow** | smo-dev | testflow.smorchestra.ai | Dev/staging + shared + new apps under development |
| **smo-brain** | eo-prod | ai.mamounalamouri.smorchestra.com | EO production orchestration (eo-mena, eo-scorecard, student assessment, etc.) |
| **qa** | smo-eo-qa | qa.smorchestra.ai | Lana's QA environment |

**Rule:** smo app n8n workflows live on smo-prod `flow`. EO app workflows live on eo-prod `smo-brain`. New/experimental on smo-dev `testflow`.

---

## The dev→prod promotion loop (applies to SSE V4, content-automation V2, any new major version)

### Stage 1 — start v{N+1} on smo-dev

```bash
cd ~/Desktop/repo-workspace/smo/{repo}
git checkout dev && git pull --ff-only
git checkout -b feat/v{N+1}-{slug}
```

1. **Write ADR** at `architecture/adrs/ADR-NNN-v{N+1}-{slug}.md` — breaking changes + migration plan
2. **Update BRD** `architecture/brd.md` — new ACs, preserve old AC numbers tagged DEPRECATED
3. **Write migration script** `scripts/migrate-v{N}-to-v{N+1}.{sh,sql}` — idempotent + reversible
4. **Deploy to smo-dev** `/root/{repo}` (staging path per L-003):
   ```bash
   /smo-deploy --env staging
   # = rsync to smo-dev /root/{repo}, npm install + build, pm2/docker-compose start
   ```
5. **Provision staging subdomain** (e.g., `staging-{repo}.smorchestra.ai`) via nginx vhost on smo-dev + certbot
6. **n8n workflows for v{N+1}** live on **smo-dev `testflow`** during development. Export to `{repo}/ace-workflows/` OR `{repo}/n8n-workflows/` AS YOU BUILD (L-009 — commit them before end of work unit).

### Stage 2 — smo-dev dev loop (regular `/smo-*` chain)

```
/smo-plan AC-N.N → /smo-code → /smo-score (≥92) → /smo-bridge-gaps → /smo-handover → Lana /smo-qa-handover-score → /smo-qa-run (staging URL)
```

All scored. All handed to Lana. All QA'd on staging (smo-dev). Boris + scorer + drift checks enforce.

### Stage 3 — promote app code to smo-prod

Pre-flight check (hard gates, see SOP-32):
- `/smo-score` composite ≥92, every top-3 hat ≥8.5
- Lana `/smo-qa-run --env staging` = all pass
- staging `/api/health` 200
- `.smorch/project.json:deploy.production.host` = correct smo-prod target
- Migration script dry-run succeeded on staging
- Rollback path documented + tested

Promotion:
```bash
# Final PR on GitHub: dev → main
gh pr create --base main --head dev --title "release v{N+1}.0.0 — {slug}"
# CEO approves
gh pr merge --squash --admin
git tag v{N+1}.0.0 && git push origin v{N+1}.0.0
# Deploy
/smo-deploy --env production
# = SSH to smo-prod, pull tag, migrate DB, build, pm2/docker-compose reload, verify /api/health 200
```

Auto-triggered drift check post-deploy. Telegram heartbeat `🚀 {repo} v{N+1}.0.0 deployed`.

### Stage 4 — promote n8n workflows smo-dev `testflow` → smo-prod `flow`

n8n workflows don't auto-deploy. Manual promotion:

```bash
# 1. Export from smo-dev testflow
ssh root@100.83.242.99 'for id in $(docker exec n8n n8n list:workflow --onlyId); do docker exec n8n n8n export:workflow --id=$id --output=/tmp/wf-$id.json; done'
ssh root@100.83.242.99 'tar czf /tmp/dev-wf.tar.gz -C /tmp wf-*.json' 
# 2. Commit to repo (source of truth)
# copy into {repo}/n8n-workflows/ or ace-workflows/, commit, push
# 3. Clean JSONs (strip shared/versionId/tags/webhookId — see /opt/scripts/n8n-clean-for-import.py)
# 4. Import to smo-prod flow
ssh root@100.108.44.127 '... docker exec n8n n8n import:workflow --separate --input=/tmp/wf-clean'
# 5. Activate on smo-prod ONLY AFTER:
#    - verifying smo-dev copies are deactivated (prevents double execution)
#    - credentials exist on smo-prod n8n (may need reconnection — credentials don't transfer cleanly)
#    - any webhooks reconfigured on third-party services (Instantly, GHL, HeyReach) to point at prod URLs
```

**Prod activation checklist per workflow:**
- [ ] Credentials linked on smo-prod n8n
- [ ] Webhook URLs re-pointed in vendor dashboard (Instantly, GHL, HeyReach)
- [ ] Equivalent workflow on smo-dev testflow set to inactive
- [ ] Manual test trigger → expected result
- [ ] Then set active=true

### Stage 5 — decommission v{N} on smo-prod

After v{N+1} running green on prod for 7 days:
- Tag v{N} as `{N}-legacy` (don't delete — rollback safety)
- Archive v{N} branch: `git branch -m {branch} archive/v{N}-{date}`
- Update `.smorch/project.json` default version pointer if applicable
- Update `smorch-brain/canonical/server-role-registry.md` if path changed

---

## Examples

### SSE V4 (future)

```bash
cd ~/Desktop/repo-workspace/smo/Signal-Sales-Engine
git checkout dev && git pull --ff-only
git checkout -b feat/v4-{feature-slug}
# Build v4 on smo-dev /root/signal-sales-engine (staging)
# Its n8n workflows live on smo-dev testflow.smorchestra.ai while building
# When ready: PR dev→main, CEO approves, /smo-deploy --env production 
# Export v4 n8n workflows from testflow, commit to repo, import to smo-prod flow
# Deactivate old V3 workflows on smo-prod flow as V4 replaces them (keep inactive for 30 days as rollback)
```

### content-automation V2 (future)

```bash
cd ~/Desktop/repo-workspace/smo/content-automation
git checkout dev && git pull --ff-only
git checkout -b feat/v2-{slug}
# V1 keeps running on smo-prod /opt/apps/content-automation port 3300/3301
# V2 deploys to smo-dev /root/content-automation on staging ports
# Staging domain: staging-app.smorchestra.ai on smo-dev
# n8n workflows for V2 on smo-dev testflow
# When ready: release PR dev→main, deploy to smo-prod
# Export V2 workflows testflow → flow, deactivate V1 ones, activate V2 ones
```

---

## Enforcement

- Branch protection on `main`: only release PRs from `dev` OR `hotfix/PROD-SEV*` can merge (SOP-20, SOP-32)
- `/smo-ship` blocks if migration script missing for major version (Architecture hat caps at 6)
- `/smo-deploy --env production` reads `.smorch/project.json:deploy.production.host` — rejects if doesn't match canonical per server mapping above
- `/smo-drift --n8n` reports workflows active on both testflow AND flow — flags as "dual-active" SEV2 alert

## Anti-patterns (blocked)

1. ❌ Deploying new version directly to smo-prod without smo-dev staging first
2. ❌ Having the SAME workflow active on testflow + flow simultaneously (double execution, webhook collision)
3. ❌ Editing workflows directly on smo-prod n8n UI without exporting back to repo (L-009)
4. ❌ Copying credentials between n8n instances manually — re-create them on the target instance
5. ❌ Skipping the CEO release PR approval for `dev → main`

## See also

- SOP-20 Branch Model — main protected, hotfix path
- SOP-22 Commit/Push Discipline — L-009
- SOP-23 Weighted Scoring — 92+ ship gate
- SOP-32 Patching + Versioning — semver + hotfix flow
- SOP-30 Drift Enforcement — cron-based drift detection across all 4 servers

---

## 2026-04-23 UPDATE — Subdomain-per-app is the canonical pattern

**Rule: every app gets its own subdomain. No basepaths.**

### Why (learned the hard way 2026-04-23)
Content-automation was initially configured with `basePath: '/contentengine'` in `next.config.mjs` and deployed at `app.smorchestra.ai/contentengine`. This caused:
- Next.js mixed asset paths (`/_next/*` + `/contentengine/_next/*` served inconsistently)
- 404 on `/contentengine/generate` etc despite pages existing in the build
- Harder nginx routing (per-path location blocks that can conflict)
- Harder dev→prod promotion (staging vs prod path collisions on same box)

### Canonical subdomain pattern
| Existing apps | Subdomain |
|---|---|
| SSE V3 | sse.smorchestra.ai |
| content-automation | contentengine.smorchestra.ai |
| digital-revenue-score | score.smorchestra.ai |
| gtm-fitness-scorecard | gtm.smorchestra.ai |
| saasfast-page-online | saasfast.entrepreneursoasis.me |
| n8n (prod SMO) | flows.smorchestra.ai |
| n8n (dev) | testflow.smorchestra.ai |
| n8n (EO) | ai.mamounalamouri.smorchestra.com |

### New-app checklist — subdomain per app
1. Pick subdomain: `{app-name}.smorchestra.ai` (SMO) or `{app-name}.entrepreneursoasis.me` (EO)
2. Add A-record at domain.com → server IP (62.171.164.178 smo-prod, 89.117.62.131 eo-prod)
3. Next.js config: NO `basePath`, NO `assetPrefix` (serve at root)
4. nginx vhost binds to specific IP + listens 80 + 443
5. certbot `--nginx` or `--webroot -w /var/www/certbot`
6. Update `.smorch/project.json` `deploy.production.health_url` to match

### Forbidden anti-pattern
Deploying multiple apps on the same domain via path-based routing (`app.smorchestra.ai/one`, `app.smorchestra.ai/two`). Rejected by `/smo-drift --desktop` as SEV3 drift.

### Staging subdomain pattern (dev→prod promotion)
- Prod: `{app}.smorchestra.ai` → smo-prod
- Staging: `staging-{app}.smorchestra.ai` → smo-dev
- Each gets its own cert, its own vhost on the matching server, same env structure but with staging-tier values

### Existing `app.smorchestra.ai`
Retired 2026-04-23 (nginx symlink removed on smo-prod). DNS still points to smo-prod. Future use: repurpose as a hub/launcher landing page linking to all subdomains.
