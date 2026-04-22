# SMOrchestra Repo Registry — Canonical

**Last updated:** 2026-04-22
**Source of truth for:** which repos exist, which org, what tags, what branch model, deploy target

## SMOrchestra-ai org — 15 repos (PRIMARY / INTERNAL / CANONICAL)

| Repo | Domain | Lifecycle | Distribution | Default | Has main | Has dev | Description |
|---|---|---|---|---|---|---|---|
| smorch-dev | smo | status-dev | distribution-internal | main | ✅ | — need create | Internal dev+ops plugins for Claude Code |
| smorch-brain | smo | status-dev | distribution-internal | **→ main** | ✅ | ✅ | Skills registry, 48+ skills, MCP configs, canonical source |
| Signal-Sales-Engine | smo | status-beta | distribution-internal | main | ✅ | ✅ | SSE V3 — signal-based B2B stack (scrape+score+campaign) |
| smorchestra-web | smo | status-production | distribution-internal | main | ✅ | — need create | Marketing site smorchestra.ai (Netlify) |
| contabo-mcp-server | eo | status-dev | distribution-internal | **→ main** | — need create | ✅ | EO Infrastructure Platform — Contabo + SSH MCP + Student Dashboard monorepo |
| eo-microsaas-plugin | eo | status-production | distribution-customer | main | ✅ | — need create | EO MicroSaaS OS one-line install plugin |
| eo-mena | eo | status-production | distribution-internal | **→ main** | ✅ | ✅ | EO MENA regional platform + training content |
| smorch-dist | smo | status-dev | distribution-internal | main | ✅ | — need create | Pre-built .plugin bundles for team install |
| gtm-fitness-scorecard | smo | status-production | distribution-internal | main | ✅ | ✅ | GTM Fitness Scorecard lead magnet |
| digital-revenue-score | smo | status-production | distribution-internal | **→ main** | — need create | ✅ | 8-question B2B revenue assessment |
| content-automation | smo | status-dev | distribution-internal | **→ main** | ✅ | ✅ | Content Engine vNext — Claude Code subprocess content generation |
| EO-Scorecard-Platform | eo | status-beta | distribution-customer | **→ main** | ✅ | ✅ | EO Assessment Scorecard — SaaSFast v3 + gated scorecards |
| SaaSFast | shared | status-dev | distribution-internal | **→ main** | ✅ | ✅ | SaaSFast v2 — PRIMARY gating layer for all SMO+EO microsaas |
| super-ai-agent | smo | status-dev | distribution-internal | main | ✅ | — need create | Super AI Agent — idea→deployed Phase 7 |
| smorch-context | smo | status-dev | distribution-internal | **→ main** | ✅ | ✅ | Business context files for all SMO AI agents |

## smorchestraai-code org — 12 repos (DISTRIBUTION / SOLD / FORKS / ARCHIVES)

| Repo | Domain | Lifecycle | Distribution | Default | Has main | Has dev | Description |
|---|---|---|---|---|---|---|---|
| eo-microsaas-training | eo | status-production | distribution-customer | main | ✅ | — need create | EO Student Claude Code bundle (shipped to students) |
| SaaSfast-Page-Online | eo | status-production | distribution-customer | main | ✅ | — need create | SaaSFast deployment — EO distribution chain (sold) |
| SSE-latest | smo | status-archived | — | main | ✅ | — | 📦 Superseded by SMOrchestra-ai/Signal-Sales-Engine |
| SaaSfast-ar | eo | status-archived | — | main | ✅ | ✅ | 📦 Older bilingual SaaSFast (EO chain) |
| eo-dashboard | eo | status-archived | — | main | ✅ | — | 📦 Merged into contabo-mcp-server monorepo |
| ssh-mcp-server | eo | status-archived | — | main | ✅ | — | 📦 Merged into contabo-mcp-server monorepo |
| supervibes | external-fork | status-dev | distribution-fork | main | ✅ | — | SuperVibes parallel Claude Code orchestration |
| gstack | external-fork | status-dev | distribution-fork | main | ✅ | — | Garry Tan's Claude Code setup (fork) |
| paperclip | external-fork | status-dev | distribution-fork | master | — | — | Zero-human company orchestration (upstream uses master) |
| superpowers | external-fork | status-dev | distribution-fork | main | ✅ | ✅ | Agentic skills framework (fork) |
| Signal-Sales-Engine-v1 | smo | status-archived | — | dev | ✅ | ✅ | 📦 Old ScrapMfast |
| Signal-Based- | smo | status-archived | — | main | ✅ | — | 📦 v0 prototype |

## Phase 1 Actions Required

### Default branch flips (dev → main)
- smorch-brain, contabo-mcp-server, eo-mena, digital-revenue-score, content-automation, EO-Scorecard-Platform, SaaSFast, smorch-context

### Create missing `main` branches (from `dev`)
- contabo-mcp-server (default dev, no main)
- digital-revenue-score (default dev, no main)

### Create missing `dev` branches (from `main`) — for active non-fork repos
- smorch-dev
- smorchestra-web
- eo-microsaas-plugin
- smorch-dist
- super-ai-agent
- eo-microsaas-training
- SaaSfast-Page-Online

### Apply branch protection to all 17 active non-fork repos
- Rules per SOP-20 + SOP-22

### Apply canonical topics (domain + lifecycle + distribution) to all 27 repos
- Per SOP-21

### External forks — leave alone (keep upstream-matching defaults)
- supervibes, gstack, paperclip, superpowers

### Archives — no changes needed
- SSE-latest, SaaSfast-ar, eo-dashboard, ssh-mcp-server, Signal-Sales-Engine-v1, Signal-Based-
