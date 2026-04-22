# Product Architecture — Repo Map & Future Vision

**Version:** 1.0
**Date:** 2026-04-17
**Owner:** Mamoun Alamouri
**Purpose:** Single source of truth for how products map to repos, what's canonical, and where things are going.

---

## Product Lines

### 1. Entrepreneurs Oasis (EO) — MicroSaaS Movement for MENA

| Product | Repo | Purpose | Status |
|---------|------|---------|--------|
| **EO MENA Platform** | `SMOrchestra-ai/eo-mena` | Curated SaaS directory + AI assessment + GTM recommendations | Live |
| **EO Scorecard Platform** | `SMOrchestra-ai/EO-Scorecard-Platform` | Deep assessment (70+ questions, AI-scored) | Live |
| **EO Quick Scorer** | Part of `eo-mena` at `/assess` | 35 MC quick assessment, client-side scoring | Live (9.8/10) |
| **EO MicroSaaS Plugin** | `SMOrchestra-ai/eo-microsaas-plugin` | Claude Code plugin for EO development | Active |

### 2. SaaSFast — MicroSaaS Launcher Platform

| Product | Repo | Purpose | Status |
|---------|------|---------|--------|
| **SaaSFast (v2)** | `SMOrchestra-ai/SaaSFast` | The gate/launcher for all MicroSaaS. Becoming Super-AI-MicroSaaS platform. Internal tool that spawns, manages, and distributes MicroSaaS products. | Active, transforming |
| **SaaSfast-ar** | `SMOrchestra-ai/SaaSfast-ar` | Standalone Arabic/bilingual SaaS boilerplate. One-time purchase product — buyers get the repo. This is a PRODUCT, not internal tool. | Live, sold as-is |

**Key distinction:**
- `SaaSFast` = Internal platform (Super-AI-MicroSaaS launcher). Will become the factory.
- `SaaSfast-ar` = Standalone product for sale. Buyers get the repo as a boilerplate.

**Future (Super-AI-MicroSaaS):**
SaaSFast evolves into the central launcher platform. When a MicroSaaS is created by the system, SaaSFast is the gate. All EO-assessed MicroSaaS, all internally-built MicroSaaS, and future third-party MicroSaaS route through it.

### 3. Signal Sales Engine (SSE) — B2B Signal Intelligence Stack

| Product | Repo | Purpose | Status |
|---------|------|---------|--------|
| **Signal Sales Engine v3** | `SMOrchestra-ai/Signal-Sales-Engine` | Consolidated platform: Scraping + Scoring + Autonomous Campaigns | Active (v3 on main) |

**SSE v3 is ONE repo containing THREE logical modules:**

```
Signal-Sales-Engine/
├── ScrapMfast/           ← Module 1: Lead Scraping (Apollo-like)
│   └── Waterfall scraping, signal detection, lead enrichment
├── scrapmfast_frontend/  ← Frontend for the scraper dashboard
├── ace-workflows/        ← Module 3: Autonomous Campaign Engine (ACE)
│   └── n8n workflow templates for multi-channel campaigns
├── supabase/             ← Shared database layer
├── docs/                 ← Architecture docs
└── tests/                ← E2E + unit tests
```

**Three modules, current plan = ONE repo with tier-based feature gating:**

| Module | What It Does | Standalone Potential | Tier |
|--------|-------------|---------------------|------|
| **ScrapMfast** (Scraping) | Waterfall lead scraping + signal detection. Apollo-like. Credit-based. | HIGH — can sell separately to people who only want leads | Tier 1 (Basic) |
| **Scoring Engine** | Lead scoring + signal mapping. Prioritizes leads by buying intent. | MEDIUM — adds value on top of scraping | Tier 2 (Pro) |
| **ACE** (Autonomous Campaigns) | Multi-channel autonomous campaigns from CSV + BRD upload. | HIGH — can sell separately to people with their own lists | Tier 3 (Enterprise) |

**CPO recommendation: Keep as one repo, use tier/module gating.**
Reasons:
- Shared Supabase schema (leads, signals, campaigns all reference each other)
- Shared auth/billing layer (one subscription, feature flags per tier)
- n8n workflows bridge all three modules
- Splitting creates sync nightmares between 3 repos sharing the same DB
- Tier gating is cleaner: env vars or feature flags control what's exposed per plan

**If you do spin off later**, the cleanest extraction points are:
- ScrapMfast scraper → extract `ScrapMfast/` + relevant `supabase/` migrations
- ACE campaigns → extract `ace-workflows/` + campaign-specific frontend
- Keep the scoring engine embedded (it touches everything)

### 4. Content & Tools

| Product | Repo | Purpose | Status |
|---------|------|---------|--------|
| **Content Automation** | `SMOrchestra-ai/content-automation` | YouTube + LinkedIn content pipeline | Active |
| **Digital Revenue Score** | `SMOrchestra-ai/digital-revenue-score` | B2B digital revenue assessment | Active |
| **GTM Fitness Scorecard** | `smorchestraai-code/gtm-fitness-scorecard` | GTM readiness lead magnet (parking) | Active (parking) |

### 5. Infrastructure & Tools

| Repo | Purpose | Status |
|------|---------|--------|
| `SMOrchestra-ai/smorch-brain` | Skills, SOPs, agents, plugins, specs | Active |
| `SMOrchestra-ai/smorch-context` | Business context files for AI agents | Active |
| `SMOrchestra-ai/smorch-dist` | Plugin distribution system | Active |
| `SMOrchestra-ai/contabo-mcp-server` | MCP server for Contabo VPS management | Active |
| `SMOrchestra-ai/ssh-mcp-server` | MCP server for SSH operations | Active |
| `SMOrchestra-ai/supervibes` | Parallel Claude Code orchestration | Active |
| `SMOrchestra-ai/smorchestra-web` | Company website | Active |

---

## Local Workspace Map

All repos live at: `~/Desktop/cowork-workspace/CodingProjects/`

| Folder | Repo | .git at root |
|--------|------|-------------|
| `EO-MENA/` | SMOrchestra-ai/eo-mena | ✅ |
| `EO-Scorecard-Platform/` | SMOrchestra-ai/EO-Scorecard-Platform | ✅ |
| `Signal-Sales-Engine/` | SMOrchestra-ai/Signal-Sales-Engine | ✅ |
| `SaaSFast/` | SMOrchestra-ai/SaaSFast | ✅ |
| `SaaSfast-ar/` | SMOrchestra-ai/SaaSfast-ar | ✅ |
| `content-automation/` | SMOrchestra-ai/content-automation | ✅ |
| `digital-revenue-score/` | SMOrchestra-ai/digital-revenue-score | ✅ |
| `gtm-fitness-scorecard/` | smorchestraai-code/gtm-fitness-scorecard | ✅ |
| `contabo-mcp-server/` | SMOrchestra-ai/contabo-mcp-server | ✅ |
| `freepik-mcp/` | freepik-company/freepik-mcp | ✅ |
| `smorch-brain/` | SMOrchestra-ai/smorch-brain | ✅ |

---

## GitHub Account Rules (from SOP-03)

| Account | What Goes Here |
|---------|---------------|
| **SMOrchestra-ai** (org) | ALL production code, internal tools, team collaboration |
| **smorchestraai-code** (user) | Forks, parking/lead magnets, archived repos ONLY |

**No production code on the user account. Ever.**

---

## Deployment Map

| Product | Server | Path | PM2 | URL |
|---------|--------|------|-----|-----|
| EO MENA | contabo-main | /root/eo-mena-new/ | eo-main | entrepreneursoasis.me |
| EO Scorecard | contabo-main | /var/www/eo-scoring/ | eo-scoring | score.entrepreneursoasis.me |
| SSE v3 | smo-dev | TBD | TBD | TBD |
| SaaSFast | TBD | TBD | TBD | TBD |
| Content Auto | smo-dev | /root/content-automation/ | content | TBD |
