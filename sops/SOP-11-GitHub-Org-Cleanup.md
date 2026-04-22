# SOP-11: GitHub Organization Cleanup & Governance

**Version:** 1.0
**Date:** 2026-04-17
**Owner:** Mamoun Alamouri
**Trigger:** One-time cleanup + ongoing 4-week review cycle

---

## Current State Audit (2026-04-17)

### SMOrchestra-ai (Org) — 19 repos

| Repo | Status | Verdict | Action |
|------|--------|---------|--------|
| eo-mena | Active, deployed | KEEP | ✅ |
| SaaSFast | Active, deployed | KEEP | ✅ |
| contabo-mcp-server | Active | KEEP | ✅ |
| Signal-Sales-Engine | Active, deployed | KEEP | ✅ |
| content-automation | Active, deployed | KEEP | ✅ |
| smorch-brain | Active | KEEP | ✅ |
| EO-Scorecard-Platform | Active, deployed | KEEP | ✅ |
| digital-revenue-score | Active | KEEP | ✅ |
| smorchestra-web | Website | KEEP | ✅ |
| eo-microsaas-plugin | Claude Code plugin | KEEP | ✅ |
| smorch-context | Business context | KEEP | ✅ |
| smorch-dist | Plugin distribution | KEEP | ✅ |
| ssh-mcp-server | MCP tool | KEEP | ✅ |
| **gtm-fitness-scorecard** | DUPLICATE — also on smorchestraai-code | **ARCHIVE on org** | Repo belongs on user account per SOP-03 (parking/lead magnet). Delete org copy after confirming user copy is current. |
| **Our-SaaSFast** | DUPLICATE of SaaSFast | **ARCHIVE** | Rename or delete. Only ONE SaaSFast repo should exist. |
| **SSE-latest** | DUPLICATE of Signal-Sales-Engine | **ARCHIVE** | Old version dump. Signal-Sales-Engine is the canonical repo. |
| **SaaSfast-ar** | DUPLICATE — also on smorchestraai-code | **ARCHIVE one copy** | Keep the org copy if it's production. Archive user copy. |
| **super-ai-agent** | Unclear purpose | **REVIEW** | Check if active. If not, archive. |
| **eo-dashboard** | Separate from eo-mena? | **REVIEW** | May be superseded by eo-mena. Check and archive if redundant. |

### smorchestraai-code (User) — 7 repos

| Repo | Status | Verdict | Action |
|------|--------|---------|--------|
| gstack | Fork | KEEP | ✅ Correct location |
| paperclip | Fork | KEEP | ✅ Correct location |
| superpowers | Fork | KEEP | ✅ Correct location |
| Signal-Sales-Engine-v1 | Archived | KEEP archived | ✅ Per SOP-03 lifecycle |
| Signal-Based- | Archived | DELETE | Stale, no value. Confirm with Mamoun. |
| **SaaSfast-ar** | DUPLICATE of org copy | **ARCHIVE** | Org copy is canonical. |
| **supervibes** | Production tool? | **MOVE TO ORG** | If it's a production tool, it belongs in SMOrchestra-ai per SOP-03. |

---

## Cleanup Execution Plan

### Phase 1: Archive Duplicates (safe, reversible)

```bash
# 1. Archive duplicates on org
gh repo archive SMOrchestra-ai/Our-SaaSFast --yes
gh repo archive SMOrchestra-ai/SSE-latest --yes

# 2. Archive user-side duplicate
gh repo archive smorchestraai-code/SaaSfast-ar --yes

# 3. Decide on gtm-fitness-scorecard
# If smorchestraai-code version is current and it's still "parking":
gh repo archive SMOrchestra-ai/gtm-fitness-scorecard --yes
# OR if it graduated to production:
gh repo archive smorchestraai-code/gtm-fitness-scorecard --yes
```

### Phase 2: Review Unclear Repos (needs Mamoun input)

| Repo | Question |
|------|----------|
| super-ai-agent | Is this active? What product is it for? |
| eo-dashboard | Is this superseded by eo-mena? |
| supervibes (user) | Move to org or keep as parking? |

### Phase 3: Transfer supervibes to org (if production)

```bash
# Transfer repo from user to org
gh api repos/smorchestraai-code/supervibes/transfer \
  -f new_owner=SMOrchestra-ai --method POST
```

---

## Post-Cleanup Target State

### SMOrchestra-ai (Org) — Production Only

| Repo | Product | Status |
|------|---------|--------|
| eo-mena | EO MENA Platform | Live |
| SaaSFast | MicroSaaS Launcher | Live |
| Signal-Sales-Engine | B2B Signal Intelligence | Live |
| EO-Scorecard-Platform | EO Assessment Scorecards | Live |
| content-automation | Content Pipeline | Live |
| digital-revenue-score | Digital Revenue Scoring | Active |
| contabo-mcp-server | Contabo MCP Tool | Active |
| ssh-mcp-server | SSH MCP Tool | Active |
| smorch-brain | Skills + SOPs + Agents | Active |
| smorch-context | Business Context | Active |
| smorch-dist | Plugin Distribution | Active |
| eo-microsaas-plugin | Claude Code Plugin | Active |
| smorchestra-web | Company Website | Active |
| SaaSfast-ar | Arabic SaaSFast | Active |
| supervibes | Parallel Orchestration | Active (transferred) |

### smorchestraai-code (User) — Forks + Archive Only

| Repo | Type |
|------|------|
| gstack | Fork |
| paperclip | Fork |
| superpowers | Fork |
| gtm-fitness-scorecard | Parking (if not production) |
| Signal-Sales-Engine-v1 | Archived |

### Archived on Org (cleanup pending 4-week review)

| Repo | Why |
|------|-----|
| Our-SaaSFast | Duplicate of SaaSFast |
| SSE-latest | Duplicate of Signal-Sales-Engine |

---

## Ongoing Governance (every 4 weeks)

### First Monday of each month:

```bash
# List all repos across both accounts
echo "=== ORG ===" && gh repo list SMOrchestra-ai --limit 50 --json name,isArchived,pushedAt \
  --jq '.[] | "\(.name) | archived:\(.isArchived) | last push:\(.pushedAt)"'
echo "=== USER ===" && gh repo list smorchestraai-code --limit 50 --json name,isArchived,pushedAt \
  --jq '.[] | "\(.name) | archived:\(.isArchived) | last push:\(.pushedAt)"'
```

### Review criteria:
1. Any repo not pushed in 30+ days → flag for review
2. Any archived repo older than 4 weeks → recommend delete
3. Any repo on user account that's production → flag for transfer
4. Any duplicate repos → flag for consolidation
