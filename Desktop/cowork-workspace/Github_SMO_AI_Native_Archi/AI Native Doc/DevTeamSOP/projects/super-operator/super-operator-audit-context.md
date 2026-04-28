# Super Operator Platform — Audit Context & System Map

**Purpose:** This file is the single source of truth for any Claude Code instance or OpenClaw agent working on the Super Operator Platform. Read this before doing anything.

**Last updated:** 2026-03-23 (v1.2 reconciliation)
**Owner:** Mamoun Alamouri, SMOrchestra.ai

---

## 1. What We're Building

A 10-stage autonomous pipeline that takes a non-technical MENA founder from "I have a micro-SaaS idea" to "my product is live, campaigns are running, leads are flowing."

**The 10 stages:**
1. INTAKE — Founder describes idea via Telegram (OpenClaw)
2. QUALIFICATION — 5-scorecard system validates viability
3. BRAIN BUILD — Scorecard output → 12 structured project files
4. ARCHITECTURE — BRD, tech stack, architecture diagrams
5. CODE BUILD — 5-phase dev pipeline via supervibes/Claude Code
6. QA + SECURITY — Code quality, tests, RTL Arabic, security
7. DEPLOY — VPS provisioning, Docker, domain/SSL
8. SAAS SHELL — SaaSFast-v2 wraps app with auth, payments, bilingual
9. GTM GENERATION — Landing pages, email sequences, LinkedIn/WhatsApp copy
10. CAMPAIGN LAUNCH — SignalSalesEngine: scrape → enrich → score → deploy campaigns

---

## 2. Orchestration Architecture

```
OpenClaw = BRAIN (decides what, when, why)
n8n = EXECUTION HORSES (does what it's told)
Claude Code = THINKING MUSCLE (coding, analysis, generation)
MCP Servers = TOOL ACCESS (programmatic interface to systems)
```

**OpenClaw** lives in Telegram. Backed by Claude Code on smo-brain. It:
- Converses with the founder (brainstorms, stress-tests ideas)
- Decides when to advance pipeline stages
- Triggers n8n workflows with structured context
- Invokes Claude Code on mesh nodes for heavy work
- Reports results back to founder in Telegram

**n8n** receives webhook triggers from OpenClaw. It:
- Processes scorecards (EO workflows)
- Deploys campaigns (ACE system)
- Runs scraping/enrichment (SCF/SignalSalesEngine)
- Handles deployment pipelines (Contabo MCP)
- Does NOT decide — only executes

**Claude Code** is invoked by OpenClaw via `claude -p` on mesh nodes. It:
- Builds brain files (brain-ingestion skill)
- Creates architecture docs (tech-architect skill)
- Generates code (microsaas-dev skill, supervibes)
- Produces GTM assets (GTM skills)
- Reviews code quality (qa-testing, security-hardener skills)

---

## 3. Infrastructure Map

### Compute Nodes (all connected via Tailscale + OpenClaw mesh)

| Node | Role | Tailscale IP | Claude Code | OpenClaw |
|------|------|-------------|-------------|----------|
| smo-brain | Gateway / brain server | 100.89.148.62 | ✅ v2.1.79 | ✅ Gateway |
| smo-dev | Primary dev environment | 100.117.35.19 | ✅ Active | ✅ Agent |
| Desktop (Mamoun) | Dev workstation | 100.100.239.103 | ✅ Active | ✅ Agent |
| Dev Desktop (developer) | Developer workstation | — | ✅ Active | ✅ Agent |

### n8n Instances

| Instance | Purpose | Active Workflows | Key Systems |
|----------|---------|-----------------|-------------|
| **n8n-dev** | Campaign engine + signal pipeline | 71 | ACE (19 workflows), SCF (10 workflows), MENA Hiring Signal |
| **n8n-mamoun** | Assessment + signal layer | 51 | EO Scorecards (6 workflows), SCF mirrors, Knowledge sync |
| **n8n-production** | Legacy (mostly obsolete) | 80 | Webinar workflows, early prototypes |

### Supabase Projects

| Project | Purpose | Tables | Key Features |
|---------|---------|--------|-------------|
| **entrepreneursoasis** | EO directory + assessments + pipeline state | 10 (profiles, countries, categories, submissions, assessments, scoring_rubrics, products, playbooks, interests, newsletter_subscribers) | pgvector, RLS on all tables, GHL integration fields, AI traceability |
| **ScrapMfast (separate)** | Signal/campaign data | 6 (scraper_runs, scraper_results, campaigns, leads, campaign_triggers, campaign_leads) | Multi-tenant (tenant_id), full campaign lifecycle tracking |

### MCP Servers

| MCP Server | Status | What It Wraps |
|------------|--------|---------------|
| **Contabo MCP** | ⚠️ Created, NOT TESTED | Server lifecycle: create, manage, destroy VPS, snapshots, DNS, networking |
| **EO MCP** | ❌ NOT BUILT (Domino 2) | Full eo-mena app: assessments, submissions, directory, interests, profiles |
| **SignalSalesEngine MCP** | ❌ NOT BUILT (Domino 6) | Unified scraping, enrichment, scoring, campaign launch |
| **Supabase MCP** | ✅ Active | Direct Supabase access (exists as standard MCP) |
| **GitHub MCP** | ✅ Active | Repo management (exists as standard MCP) |

---

## 4. GitHub Org Inventory (Reconciled March 23)

9 repos in SMOrchestra-ai org:

| # | Repo | Purpose | Status | Notes |
|---|------|---------|--------|-------|
| 1 | **EO-Scorecard-Platform** | SaaSFast v3 + gated EO scorecards | NEW — Most active repo | Auth callback fix + purchase confirmation email PRs merged today |
| 2 | **eo-mena** | THE production repo | v2 scaffold added | Stages 2, 8 |
| 3 | **ship-fast** | Original ShipFast source | Reference only | — |
| 4 | **ScrapMfast** | SignalSalesEngine | v2 scaffold added, merging with ACE/SCF | Stage 10 |
| 5 | **EO-Build** | DEPRECATED | **STILL NOT ARCHIVED — needs archival action** | — |
| 6 | **smorch-brain** | Skills registry (49 skills) | Active | Open PR #3 (smorch-github-ops skill) |
| 7 | **SaaSFast** | Renamed from SaaSFast-v2 | v3.0.0 "MicroSaaS Launcher Platform" on dev | Stage 8 |
| 8 | **SaaSFast-v1-archived** | Legacy SaaSFast | Properly archived | — |
| 9 | **eo-assessment-system** | 5 scorecards + AI analysis | Public, live | Stage 2 |

Plus **supervibes** under smorchestraai-code account (parallel Claude Code orchestrator, Node.js/tmux/macOS).

---

## 5. n8n Workflow Inventory (Active Only)

### ACE System (n8n-dev) — Campaign Engine

| Workflow | Purpose | Reusability |
|----------|---------|-------------|
| ACE — Claude Brain | AI copywriting for campaigns | HIGH |
| ACE — Deploy Master | Campaign deployment orchestration | HIGH |
| ACE — Deploy Emails | Email → Instantly | HIGH |
| ACE — Deploy LinkedIn | LinkedIn → HeyReach | HIGH |
| ACE — Deploy WhatsApp | WhatsApp → GHL | HIGH |
| ACE — Deploy Social | Social media deployment | HIGH |
| ACE — Campaign Orchestrator | Master campaign conductor | HIGH |
| ACE — Reply Router | Routes inbound replies | HIGH |
| ACE — Status Sync | Syncs status across channels | MEDIUM |
| ACE — Telegram Commands | Telegram bot commands | HIGH (extend for project intake) |
| ACE — Telegram Callbacks | Telegram inline buttons | HIGH |
| ACE — CSV Upload | Bulk lead upload | MEDIUM |
| ACE — Dashboard Generator | Campaign performance | MEDIUM |
| ACE — Error Handler | Centralized errors | HIGH |
| ACE — Weekly Optimization | Auto campaign optimization | MEDIUM |
| ACE — Metrics GHL | GHL metrics | HIGH |
| ACE — Metrics Instantly | Instantly metrics | HIGH |
| ACE — Metrics HeyReach | HeyReach metrics | HIGH |
| ACE — BRD Intake | BRD processing (INACTIVE) | HIGH (reactivate) |

### SCF System (n8n-dev + mamoun) — Signal Pipeline

| Workflow | Purpose | Reusability |
|----------|---------|-------------|
| SCF — YouTube Scraper | YouTube lead scraping via Apify | HIGH |
| SCF — LinkedIn Scraper | LinkedIn lead scraping | HIGH |
| SCF — Google Maps Scraper | Google Maps business scraping | HIGH |
| SCF — Enrichment Pipeline | Lead enrichment waterfall | HIGH |
| SCF — Campaign Trigger Evaluator | Signal-based campaign routing | HIGH |
| SCF — Message Generator | AI message generation | HIGH |
| SCF — Campaign Executor | Execute campaign sequences | HIGH |
| SCF — Webhook Handlers | Inbound webhook processing | HIGH |
| MENA Hiring Signal Detection | Hiring intent signals | HIGH |

### EO Scorecards (n8n-mamoun)

| Workflow | Purpose |
|----------|---------|
| EO — Project Definition Assessment | Scorecard 1 of 5 |
| EO — ICP Assessment | Scorecard 2 of 5 |
| EO — MAS Assessment | Scorecard 3 of 5 |
| EO — GTM Assessment | Scorecard 4 of 5 |
| EO — Strategy Selector | Scorecard 5 of 5 |
| EO — Consolidated Assessment | All scores combined |

---

## 6. Skills Library (smorch-brain)

**49 skills total.** All are markdown instruction files. NOT APIs. They guide Claude Code behavior.

| Category | Count | Key Skills | Pipeline Stages |
|----------|-------|-----------|----------------|
| eo-scoring | 5 | project-definition, icp-clarity, market-attractiveness, strategy-selector, gtm-fitness | 2 |
| eo-training | 12 | brain-ingestion, gtm-asset-factory, tech-architect, microsaas-dev, db-architect, qa-testing, security-hardener, deploy-infra, api-connector, skill-extractor | 3-7 |
| smorch-gtm | 15 | signal-to-trust, outbound-orchestrator, ghl-operator, instantly-operator, heyreach-operator, clay-operator, n8n-architect, scraper-layer, wedge-generator | 9-10 |
| content | 7 | youtube-deck-builder, perfect-webinar, movement-builder, content-systems, engagement-engine | 9 |
| dev-meta | 6 | skill-creator, tool-super-admin, systematic-debugging, code-review | Support |
| tools | 4 | api-docs-fetcher, webapp-testing, frontend-design, lead-research | Support |

**Plugins:**
- `smorch-gtm-engine` (v1.0.0) — 13 skills, 8 commands
- `eo-microsaas-os` (v1.0.0) — 16 skills, 5 commands

**How to use skills:** OpenClaw invokes Claude Code with `claude -p "use skill [skill-name] to [task]"` on the appropriate mesh node. Output is captured and stored as artifacts.

---

## 7. Supabase Schema Detail (entrepreneursoasis)

### Tables

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| **profiles** | User accounts | id, email, full_name, user_role (visitor/founder/admin), ghl_contact_id |
| **countries** | 22 MENA countries | name_en, name_ar, code, region |
| **categories** | Product categories (bilingual) | name_en, name_ar, slug |
| **submissions** | 5-step intake wizard | founder_id, status (draft→submitted→reviewed→approved→rejected), answers (jsonb) |
| **assessments** | AI scoring results | submission_id, gtm_fitness_score, market_alignment_score, icp_clarity_score, total_score, improvement_recommendations (jsonb), claude_model, token_usage |
| **scoring_rubrics** | Assessment criteria (versioned) | type, version, criteria (jsonb) |
| **products** | Published directory listings | founder_id, name, description, status, pgvector embedding |
| **playbooks** | AI-generated GTM playbooks | product_id, content (jsonb), claude_model |
| **interests** | Buyer leads / interest capture | product_id, buyer_data (jsonb), action |
| **newsletter_subscribers** | Email list | email, ghl_contact_id |

### Key Features
- pgvector installed (semantic search)
- RLS enabled on all 10 tables
- GHL integration fields on profiles, submissions, interests, newsletter
- AI traceability on assessments + playbooks (claude_model, token_usage, processing_time_ms)

### Missing Table (Domino 1)

`project_runs` — tracks a project through all 10 pipeline stages. Schema defined in BRD v1.1 Section 5.1 Gap 1.

---

## 8. SaaSFast v3.0.0 Status

**Repo:** `SMOrchestra-ai/SaaSFast` (renamed from SaaSFast-v2). v3.0.0 "MicroSaaS Launcher Platform" on dev branch.
**Supabase deps:** @supabase/ssr ^0.5.2, @supabase/supabase-js ^2.46.2

### What's Already Built
- ✅ Onboarding wizard (5 steps)
- ✅ Admin panel
- ✅ Customer dashboard
- ✅ Product catalog
- ✅ 10-stage pipeline tracker
- ✅ Template clone/inject scripts
- ✅ Supabase migration SQL (project_runs, stage_events, products, purchases, template_configs + RLS)
- ✅ CI workflow
- ✅ Multi-mode config (storefront/template)
- ✅ Full Arabic/RTL bilingual layer (from v2)

### Issues (v3.0.0)
- ❌ Migration not applied to Supabase
- ❌ Locale persistence missing
- ❌ hreflang routing broken
- ❌ Arabic pricing fields missing in storefront config
- ❌ Admin auth middleware not enforced
- ❌ No tests
- ❌ Missing CLAUDE.md
- ❌ main 6 commits behind dev

### Dual Purpose
**(A)** SMOrchestra's own storefront — sells Super Coder & Launcher service
**(B)** Customer app template — Stage 8 forks SaaSFast per customer, injects their brand/domain/config

---

## 9. Channel Integrations

| Channel | Tool | Integration Point | Status |
|---------|------|-------------------|--------|
| Email (cold) | Instantly.ai | ACE — Deploy Emails (n8n) | ✅ Working |
| LinkedIn | HeyReach | ACE — Deploy LinkedIn (n8n) | ✅ Working |
| WhatsApp | GHL (GoHighLevel) | ACE — Deploy WhatsApp (n8n) | ✅ Working |
| Social media | Various | ACE — Deploy Social (n8n) | ✅ Working |
| CRM | GHL | ACE — Metrics GHL (n8n) + eo-mena GHL fields | ✅ Working |
| Scraping | Apify | SCF scrapers (n8n) + ScrapMfast Edge Functions | ✅ Working |
| Email (transactional) | Resend | SaaSFast-v2 + eo-mena | ✅ Configured |
| Payments | Stripe | SaaSFast-v2 checkout | ✅ Configured (needs testing) |
| Auth | Supabase Auth | SaaSFast-v2 + eo-mena | ✅ Working |
| Auth (Google OAuth) | Supabase Auth providers | SaaSFast-v2 | ✅ Configured |

---

## 10. What Must Be Built (10 Dominoes)

| # | Domino | Effort | Node | Day | Status | v1.2 Update |
|---|--------|--------|------|-----|--------|-------------|
| 1 | Project state schema (`project_runs`) | **2-3 hrs** (was 2-3 hrs) | A | 1 | ❌ | Migration SQL exists in SaaSFast v3 — reduced from 1-2 days to 2-3 hours |
| 2 | EO MCP (full eo-mena app) | 1-1.5 days | A | 2-3 | ❌ | — |
| 3 | OpenClaw Brain MVP (stages 1-3) | **4-5 days** (was 5-7) | A | 3-5 | ❌ | Agent SDK simplifies implementation |
| 4 | Brain Build + Architecture automation | 1 day | A | 5-6 | ❌ | — |
| 5 | Code Build pipeline | 1.5-2 days | A | 6-8 | ❌ | — |
| 6 | SignalSalesEngine MCP | 1-1.5 days | B | 2-3 | ❌ (blocked by merge ~March 28) | — |
| 7 | Deploy + SaaS Shell (Contabo testing) | 1.5-2 days | B/C | 3-6 | ⚠️ SaaS shell done, deploy untested | — |
| 8 | GTM Skills hardening | 2 days | B | 1-3 | ❌ | — |
| 9 | Onboarding Interface (SaaSFast) | **1.5-2 days** (was 4-5) | B | 6-8 | ❌ | UI already built in SaaSFast v3 |
| 10 | End-to-end integration test | 1-1.5 days | All | 8-9 | ❌ | — |

**Revised timeline (v1.2): MVP Day 4 | Beta Day 7 | Production Day 10-12**
**Total focused: 7-8 days (was 10)**

---

## 11. Key Decisions Made

1. **eo-mena is THE repo.** EO-Build is deprecated, will be archived.
2. **SaaSFast-v2 uses Supabase natively.** Re-cloned from ShipFast `supabase-clean` branch. MongoDB eliminated.
3. **OpenClaw = brain, n8n = execution.** OpenClaw decides, n8n does. Claude Code thinks.
4. **ScrapMfast + ACE + SCF → SignalSalesEngine.** Single system, single DB, single interface. Merging by ~March 28.
5. **Skills stay as markdown.** OpenClaw invokes Claude Code with skills. No API conversion.
6. **Single-user approval** for MVP (Mamoun + Lana). Multi-user later.
7. **ScrapMfast Supabase stays separate** from entrepreneursoasis project. Cross-project queries via Edge Functions if needed.
8. **Contabo MCP created but needs testing sprint** before deployment pipeline is production-ready.

---

## 12. Security Notes

- ⚠️ **ScrapMfast has committed .env with Supabase keys.** Rotate anon key. Add .env to .gitignore.
- All Supabase tables have RLS enabled.
- SaaSFast-v2 uses @supabase/ssr for secure server-side auth.
- Stripe webhook secrets must be configured per environment.
- OpenClaw mesh communicates over Tailscale (encrypted WireGuard).

---

## 13. For OpenClaw Agents

When you receive a task related to the Super Operator Platform:

1. **Check which stage** the task maps to (1-10)
2. **Check which domino** needs to be built or is already built
3. **Use the right skill** from smorch-brain for the task
4. **Report to smo-brain gateway** with structured output
5. **Update project_runs** in Supabase (once Domino 1 is built)

**Your role as an OpenClaw agent:** Execute what the brain tells you. Return structured results. Don't make pipeline decisions — that's the brain's job on smo-brain.

---

## 14. Claude Code Capabilities (v2.1.81, March 2026)

| Capability | Description |
|------------|-------------|
| **Agent Teams** | Parallel sessions within a node. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
| **Channels** | Telegram plugin pushes messages into sessions. `--channels plugin:telegram@claude-plugins-official` |
| **Remote Control** | Web dashboard per node. `claude remote-control --spawn worktree --capacity N` |
| **Agent SDK** | Python (`claude-agent-sdk`) + TypeScript (`@anthropic-ai/claude-agent-sdk`). Programmatic control. |
| **--bare flag** | Faster headless execution for automation |
| **HTTP Hooks** | POST to webhooks for cross-node notification |
| **/loop** | Periodic tasks within sessions |
| **Worktree improvements** | Isolation per session, sparse checkout |

---

## 15. SuperVibes Assessment

- Stage 5 code build engine. 6 files, zero deps, macOS only.
- Controller/worker delegation via tmux.
- Partially superseded by Agent Teams (within-node) and Remote Control (monitoring).
- Still valuable for complex multi-file code builds with tech-lead pattern.

---

## 16. Impact on BRD (v1.2 Reconciliation)

| Domino | Change | Reason |
|--------|--------|--------|
| 1 (project_runs) | 1-2 days → 2-3 hours | Migration SQL already exists in SaaSFast v3 |
| 3 (OpenClaw Brain) | 5-7 days → 4-5 days | Agent SDK simplifies implementation |
| 9 (Onboarding) | 4-5 days → 1.5-2 days | UI already built in SaaSFast v3 |

**Timeline compressed:** MVP Day 4, Beta Day 7, Production Day 10-12. Total focused: 7-8 days (was 10).

---

## 17. For Claude Code Instances

When working on any Super Operator component:

1. **Read this file first** for full context
2. **Check the BRD** at `super-coder-launcher-BRD-v1.2.md` for detailed requirements
3. **Use skills from smorch-brain** — they contain proven patterns and instructions
4. **Output structured results** — JSON where possible, markdown for docs
5. **Push to the right repo** — check Section 4 for which repo owns what
6. **Test against Supabase** — the entrepreneursoasis project is the canonical data store
