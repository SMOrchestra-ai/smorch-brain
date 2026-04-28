# SOP-21 — GitHub Tag Taxonomy

**Status:** Canonical, 2026-04-22
**Scope:** Every SMOrchestra repo across both orgs (27 total)

## 3 required dimensions (every active repo MUST have one tag from each)

### Dimension 1 — Ownership / Domain

| Tag | Meaning |
|---|---|
| `smo` | SMOrchestra flagship (B2B GTM stack) |
| `eo` | Entrepreneurs Oasis MENA (students + training + distribution chain) |
| `shared` | Used by both SMO + EO (e.g., SaaSFast v2 gating layer) |
| `external-fork` | Upstream open-source fork |

### Dimension 2 — Lifecycle / Environment

| Tag | Meaning |
|---|---|
| `status-production` | Live prod traffic. `main` = what customers use. |
| `status-beta` | Public beta, controlled rollout. |
| `status-dev` | Development only, no prod deploy. |
| `status-archived` | Retired. GitHub archived flag ON. |

Flipping lifecycle requires CEO PR approval. Post-flip QA report cites PR.

### Dimension 3 — Distribution

| Tag | Meaning |
|---|---|
| `distribution-internal` | Private, team only. |
| `distribution-customer` | Sold / shipped to customers or students. |
| `distribution-fork` | External open-source fork tracking. |

## Optional tech/capability tags

Keep existing: `nextjs`, `supabase`, `mongodb`, `arabic`, `rtl`, `mena`, `ai-native`, `claude-code`, `claude-sdk`, `mcp`, `plugins`, `skills`, `scoring`, `assessment`, `b2b`, `gtm`, `outbound`, `signal-intelligence`, `content`, `automation`, `scraping`, `revenue`, `training`, `lead-magnet`, `dashboard`, `orchestration`, `saas`, `saasfast`, `product-site`, `context`, `project-brain`, `ai-agent`, `infrastructure`, `vps`.

## Application

`gh repo edit {org}/{repo} --add-topic {tag}` — additive, idempotent. `smorch-dev/scripts/github-audit/phase-1-apply.sh` drives.

See `canonical/repo-registry.md` for per-repo canonical tags.
