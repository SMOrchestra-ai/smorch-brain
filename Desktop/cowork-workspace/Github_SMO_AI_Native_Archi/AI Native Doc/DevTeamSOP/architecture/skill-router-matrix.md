# Skill Router Matrix — AI-Native Organization

**Date:** 2026-03-28
**Purpose:** Maps every available skill to its AI org role, methodology layer, and quality gate.
**Sources:** gstack (30 skills), superpowers (14 skills), smorch (79 skills) = 123 total skills

---

## Role-to-Skill Assignment

### OpenClaw (COO) — Pipeline Brain
**Methodology:** gstack (CEO/COO mode)
**Node:** smo-brain
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `/office-hours` | gstack | Stress-test founder ideas with 6 forcing questions (Stages 1-2) |
| `/plan-ceo-review` | gstack | CEO/founder-mode plan review, scope expansion (Stage 1) |
| `campaign-guide` | smorch-gtm | Orchestrate 9-phase campaign process (Stage 9-10) |
| `campaign-strategist` | smorch-gtm | Align quarterly → daily campaign hierarchy |
| `scoring-orchestrator` | smorch-gtm-scoring | Route to correct scorer per deliverable |
| `linear-operator` | smorch-gtm-tools | Manage sprints and tickets in Linear |
| `smorch-project-brain` | smorch-context | Create project brain files from raw inputs |
| `eo-guide` | eo | Navigate the EO MicroSaaS OS pipeline |
| `eo-os-navigator` | eo | Route founders through the 10-stage pipeline |

**Quality gate:** Founder approval via Telegram inline buttons

---

### VP Engineering — Core Builder
**Methodology:** Superpowers (TDD mandatory)
**Node:** smo-dev (primary), overflow to Desktop
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `test-driven-development` | superpowers | **MANDATORY** — RED-GREEN-REFACTOR on all code |
| `writing-plans` | superpowers | Create granular implementation plans (2-5 min tasks) |
| `subagent-driven-development` | superpowers | Execute plans with fresh subagent per task |
| `brainstorming` | superpowers | Design-first before implementation (HARD-GATE) |
| `executing-plans` | superpowers | Sequential task execution within single session |
| `dispatching-parallel-agents` | superpowers | Parallel task execution with safety gates |
| `using-git-worktrees` | superpowers | Isolated workspace creation |
| `finishing-a-development-branch` | superpowers | Final code review and branch completion |
| `requesting-code-review` | superpowers | Request structured code review |
| `receiving-code-review` | superpowers | Process review feedback |
| `systematic-debugging` | superpowers | Hypothesis-driven debugging |
| `verification-before-completion` | superpowers | Pre-completion quality check |
| `eo-microsaas-dev` | eo | 5-phase MicroSaaS build pipeline |
| `eo-api-connector` | eo | Third-party API integrations |
| `eo-db-architect` | eo | Supabase schema, RLS, multi-tenant patterns |
| `eo-tech-architect` | eo | Tech architecture from project brain |
| `mcp-builder` | smorch-dev | Create MCP servers |
| `n8n-architect` | smorch-dev | n8n workflow design |
| `get-api-docs` | smorch-dev | Fetch API documentation |
| `validation-sprint` | smorch-dev | Build-Measure-Learn validation |

**Quality gates:**
1. All tests pass (Superpowers TDD verification)
2. Spec compliance review (subagent reviewer)
3. Code quality review (subagent reviewer)
4. `engineering-scorer` > 8/10
5. `architecture-scorer` > 8/10

---

### QA Lead — Quality Enforcement
**Methodology:** gstack (QA mode) + Superpowers (review)
**Node:** Desktop (primary), overflow to smo-dev
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `/qa` | gstack | 3-tier QA (Quick/Standard/Exhaustive) with health scores |
| `/qa-only` | gstack | QA without code review gates |
| `/benchmark` | gstack | Core Web Vitals + performance regression detection |
| `/review` | gstack | Pre-landing PR review (SQL safety, LLM trust, side effects) |
| `/careful` | gstack | Destructive command safety guardrails |
| `/freeze` | gstack | Restrict edits to specific directory |
| `/guard` | gstack | Full safety mode (careful + freeze combined) |
| `/canary` | gstack | Deployment canary testing |
| `eo-qa-testing` | eo | Code quality + functional + Arabic RTL validation |
| `eo-security-hardener` | eo | Security audit (auth, RLS, input validation, rate limiting) |
| `qa-scorer` | smorch-dev-scoring | Score QA completeness |
| `composite-scorer` | smorch-dev-scoring | Aggregate all dev scores |
| `gap-bridger` | smorch-dev-scoring | Identify and close quality gaps |

**Quality gates:**
1. gstack `/qa` health score > 85
2. gstack `/benchmark` — no regressions, CWV passing
3. `qa-scorer` > 8/10
4. `eo-security-hardener` — zero critical findings
5. Ship-readiness summary: GREEN

---

### GTM Specialist — Signal-to-Campaign
**Methodology:** smorch-gtm + eo scoring
**Node:** smo-dev (shared with VP Eng)
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `signal-detector` | smorch-gtm | Validate ICP fit, classify Trust vs Intent signals |
| `signal-to-trust-gtm` | smorch-gtm | Orchestrate complete outbound across channels |
| `wedge-generator` | smorch-gtm | Create one-sentence wedges from validated signals |
| `asset-factory` | smorch-gtm | Multi-channel campaign assets (email, LinkedIn, VSL, pages) |
| `outbound-orchestrator` | smorch-gtm | Multi-channel outbound (email + LinkedIn + WhatsApp) |
| `positioning-engine` | smorch-gtm | Business positioning (Dunford + Brunson + Hormozi) |
| `lead-research-assistant` | smorch-gtm | High-quality lead identification |
| `scraper-layer` | smorch-gtm | Signal ingestion (Apify, Firecrawl, Playwright) |
| `smorch-linkedin-intel` | smorch-gtm | LinkedIn intelligence monitoring |
| `smorch-perfect-webinar` | smorch-gtm | Perfect Webinar (23-slide deck + scripts) |
| `eo-gtm-asset-factory` | eo | GTM asset bundles matched to scoring |
| `campaign-strategy-scorer` | smorch-gtm-scoring | Score strategy against 10 GTM criteria |
| `copywriting-scorer` | smorch-gtm-scoring | Score copy across channels |
| `offer-positioning-scorer` | smorch-gtm-scoring | Score offer structure |
| `scorecard-effectiveness` | smorch-gtm-scoring | Score lead magnets and scorecards |

**Quality gates:**
1. `campaign-strategy-scorer` > 8/10
2. `copywriting-scorer` > 8/10
3. `offer-positioning-scorer` > 8/10
4. Signal validation pass rate > 70%

**Tool operators loaded:**
| Operator | Purpose |
|----------|---------|
| `instantly-operator` | Cold email campaigns |
| `heyreach-operator` | LinkedIn outbound |
| `ghl-operator` | CRM + WhatsApp nurture |
| `clay-operator` | Enrichment + waterfall |
| `smorch-salesnav-operator` | LinkedIn Sales Navigator |

---

### Content Lead — Asset Production
**Methodology:** smorch-content + eo
**Node:** Desktop
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `asset-factory` | smorch-gtm | Multi-channel campaign assets |
| `smo-offer-assets` | smorch-gtm | Landing page + deck + one-pager |
| `smorch-perfect-webinar` | smorch-gtm | Webinar decks with scripts |
| `eo-youtube-mamoun` | personal | Bilingual PPTX slide decks for YouTube |
| `linkedin-ar-creator` | personal | Arabic LinkedIn posts (Sun/Mon) |
| `linkedin-en-gtm` | personal | English B2B GTM LinkedIn posts (Tue/Thu) |
| `content-systems` | personal | Multi-framework content strategy |
| `engagement-engine` | personal | Hook Model + Pattern Interrupts |
| `movement-builder` | personal | Community building (Brunson framework) |
| `eo-training-factory` | eo | Complete training products (6 engines) |
| `eo-production-renderer` | eo | Inject content into frozen templates |
| `frontend-design` | smorch-design | Production-grade frontend interfaces |
| `canvas-design` | smorch-design | Visual art in PNG/PDF |
| `web-artifacts-builder` | smorch-design | React + Tailwind HTML artifacts |
| `doc-coauthoring` | smorch-design | Structured doc co-authoring |
| `linkedin-branding-scorer` | smorch-gtm-scoring | Score LinkedIn posts |
| `social-media-scorer` | smorch-gtm-scoring | Score social posts (TOFU/MOFU/BOFU) |
| `youtube-scorer` | smorch-gtm-scoring | Score YouTube content |

**Quality gates:**
1. `linkedin-branding-scorer` > 8/10 (per track)
2. `youtube-scorer` > 8/10
3. `social-media-scorer` > 8/10
4. `copywriting-scorer` > 8/10

---

### DevOps — Infrastructure + Deployment
**Methodology:** smorch-deploy + gstack
**Node:** smo-brain (infra access)
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `eo-deploy-infra` | eo | VPS, Docker, Coolify, CI/CD pipeline |
| `/setup-deploy` | gstack | Deployment pipeline initialization |
| `/land-and-deploy` | gstack | PR landing + automatic deployment |
| `/canary` | gstack | Canary testing post-deploy |
| `/benchmark` | gstack | Performance validation post-deploy |
| `eo-security-hardener` | eo | Security audit on deployed instances |
| `n8n-architect` | smorch-dev | n8n workflow deployment |
| `mcp-builder` | smorch-dev | MCP server deployment |

**Quality gates:**
1. Health check pass on deployed URL
2. `/benchmark` — CWV green
3. `/canary` — canary test pass
4. `eo-security-hardener` — zero critical findings

---

### Data Engineer — Enrichment + Scraping
**Methodology:** smorch-data
**Node:** smo-dev
**Skills loaded:**

| Skill | Source | Purpose in Role |
|-------|--------|----------------|
| `scraper-layer` | smorch-gtm | Signal ingestion (Apify, Firecrawl, Playwright) |
| `clay-operator` | smorch-gtm-tools | Clay.com enrichment + waterfall |
| `lead-research-assistant` | smorch-gtm | Lead identification |
| `signal-detector` | smorch-gtm | ICP fit validation |
| `eo-db-architect` | eo | Database design for data pipelines |
| `n8n-architect` | smorch-dev | n8n workflow for data flows |

**Quality gates:**
1. Data quality validation (completeness, accuracy)
2. Enrichment waterfall success rate > 60%
3. No PII leaks in outputs

---

## Guiding Skills (Orchestrators)

These skills don't do work — they **manage workflows** by engaging other skills in sequence:

| Guiding Skill | Engages | Purpose |
|---------------|---------|---------|
| `campaign-guide` | signal-detector → wedge-generator → asset-factory → outbound-orchestrator | Full B2B campaign lifecycle |
| `scoring-orchestrator` | Routes to correct scorer per deliverable type | Unified quality gate |
| `eo-guide` | Routes founders through EO pipeline stages | Student journey management |
| `eo-os-navigator` | eo-brain-ingestion → eo-tech-architect → eo-microsaas-dev → eo-deploy-infra | Full MicroSaaS build lifecycle |
| `eo-training-factory` | content engine → GTM assets → tools builder → YouTube prep → webinar → arabization | Training product lifecycle |
| `composite-scorer` | architecture-scorer + engineering-scorer + product-scorer + qa-scorer + ux-frontend-scorer | Aggregate dev quality score |
| `gap-bridger` | Reads composite-scorer output → identifies weakest dimensions → generates fix plan | Quality gap remediation |

---

## Skill Conflict Prevention

### Never load simultaneously:
- gstack `/office-hours` + superpowers `brainstorming` (both claim idea exploration phase)
- gstack `/review` + superpowers `requesting-code-review` (both claim review phase)
- gstack `/qa` + superpowers `verification-before-completion` (both claim validation phase)

### Resolution:
- **Stages 1-4 (Idea → Qualification):** gstack dominates (CEO/COO methodology)
- **Stages 5-6 (Build → QA):** Superpowers dominates (TDD engineering methodology)
- **Stages 6-8 (QA → Deploy):** gstack `/qa` + `/benchmark` for browser testing; Superpowers for code review
- **Stages 9-10 (GTM → Growth):** smorch-gtm dominates

---

## Safety Skills (Always Active)

These skills are loaded on ALL roles:

| Skill | Source | Why Always Active |
|-------|--------|-------------------|
| `/careful` | gstack | Prevent destructive commands on any node |
| `eo-security-hardener` | eo | Available for security checks by any role |

Optional per-session:
| Skill | When to Load |
|-------|-------------|
| `/freeze` | When working on production code — restrict edits to project dir |
| `/guard` | During deployment — full safety mode |

---

## Scoring Gate Thresholds

| Scorer | Minimum Pass | Used By Role |
|--------|-------------|--------------|
| `architecture-scorer` | 8/10 | VP Engineering |
| `engineering-scorer` | 8/10 | VP Engineering |
| `product-scorer` | 8/10 | VP Engineering |
| `qa-scorer` | 8/10 | QA Lead |
| `ux-frontend-scorer` | 8/10 | QA Lead |
| `composite-scorer` | 8/10 aggregate | QA Lead (final gate) |
| `campaign-strategy-scorer` | 8/10 | GTM Specialist |
| `copywriting-scorer` | 8/10 | GTM Specialist + Content Lead |
| `offer-positioning-scorer` | 8/10 | GTM Specialist |
| `linkedin-branding-scorer` | 8/10 | Content Lead |
| `youtube-scorer` | 8/10 | Content Lead |
| `social-media-scorer` | 8/10 | Content Lead |
| `scorecard-effectiveness` | 8/10 | GTM Specialist |

**If any scorer returns < 8/10:** Loop back → domain skill fixes → re-score → repeat until pass.

---

*This matrix is the operating manual for the AI-Native Org's skill routing layer.*
