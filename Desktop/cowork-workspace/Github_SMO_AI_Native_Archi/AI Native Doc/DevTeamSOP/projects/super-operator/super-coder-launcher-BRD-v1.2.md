# Business Requirements Document (BRD)

**Project:** Super MicroSaaS Coder & Launcher (GTM Included)
**Parent Initiative:** Super Operator Platform
**Version:** 1.2 (Asset Reconciliation + Claude Code Capabilities Update)
**Date:** 2026-03-23
**Owner:** Mamoun Alamouri, Founder & CEO, SMOrchestra.ai
**Status:** READY FOR APPROVAL

---

## Section 0: Document Status & Approval Gates

### Version History

| Version | Date | Status | Description |
|---------|------|--------|-------------|
| 0.9 | 2026-03-19 | Superseded | Pre-audit draft. Assumptions flagged with `[PENDING AUDIT]`. |
| 1.0 | 2026-03-19 | Superseded | Post-audit. All flags resolved. 8 repos audited, 3 n8n instances inventoried, Supabase schema confirmed, 49 skills cataloged. |
| 1.1 | 2026-03-20 | Superseded | Architecture revision: OpenClaw as brain (Telegram), n8n as execution. SignalSalesEngine naming. Contabo MCP status corrected. EO MCP scope expanded. GTM skills reclassified. Onboarding interface added. SaaSFast v2 dual-purpose clarified. |
| 1.2 | 2026-03-23 | Current | **Asset reconciliation + Claude Code capabilities update.** SaaSFast v3.0.0 already built (onboarding, admin, dashboard, project_runs migration, template system). New repo EO-Scorecard-Platform identified. SuperVibes positioned as Stage 5 engine. Claude Code Agent Teams, Channels (Telegram plugin), Remote Control, Agent SDK incorporated. Domino sequence re-assessed — multiple dominoes partially complete. |

### Approval Gates

| Gate | Approver | Trigger | Status |
|------|----------|---------|--------|
| Structural Approval (v0.9) | Mamoun Alamouri | BRD structure and strategy validated | ✅ PASSED |
| Audit Complete | Mamoun Alamouri | All repos, n8n, Supabase audited | ✅ COMPLETE |
| Execution Approval (v1.0) | Mamoun Alamouri | This document reviewed and approved | **⏳ PENDING** |

### What Changed from v0.9 → v1.0

| v0.9 Assumption | Audit Finding | Impact |
|-----------------|---------------|--------|
| "Scorecards have or can easily get API endpoints" | Scorecards are static HTML posting to n8n webhooks. `/webhook/eo-full` fetches scores. No REST API in repo. | Domino 2 effort increased. Must wrap n8n webhooks + add Supabase queries. |
| "ScrapMfast is the signal engine with APIs" | ScrapMfast has Express APIs + Supabase Edge Functions for scraper runs, leads, campaigns. But actual scraping, enrichment, and sending delegated to n8n. No Instantly/HeyReach/GHL code in repo. | ScrapMfast is an orchestration UI, not the engine. Real engine = n8n SCF + ACE workflows. MCP wraps both. |
| "SaaSFast integrates with Supabase" | SaaSFast uses MongoDB + Mongoose + NextAuth. Zero Supabase. | ✅ RESOLVED — Re-cloned from Marc-Lou-Org/ship-fast `supabase-clean` branch. Configured with Supabase auth + DB. Arabic/RTL bilingual layer applied. Pushed as [SMOrchestra-ai/SaaSFast-v2](https://github.com/SMOrchestra-ai/SaaSFast-v2) (`arabic-rtl` branch). |
| "ACE may serve as master orchestrator" | ACE orchestrates campaigns only (stages 9-10). 19 workflows, all campaign-scoped. No project lifecycle or build pipeline logic. | ACE cannot be extended as master orchestrator. New orchestrator needed. ACE remains the campaign engine. |
| "One EO directory repo" | Two parallel repos exist: EO-Build and eo-mena. **Decision: eo-mena is THE repo. EO-Build is deprecated and will be removed.** | Domino 0 eliminated. No merge needed. |
| "eo-scoring-suite plugin exists" | No such plugin. 5 scoring engines are standalone skills in `skills/eo-scoring/`. Also bundled in `eo-microsaas-os` plugin. | Minor correction. No functional impact. |
| "Skills can be invoked programmatically" | All 49 skills are markdown instruction files. Zero programmatic interface. They guide Claude Code behavior, not expose APIs. | Skills work for human-in-the-loop Claude Code sessions. For autonomous pipeline, each skill's logic must be encoded as n8n sub-workflows or API endpoints. |
| "16-26 days focused execution" | Based on actual codebase state, significant integration work needed. SaaSFast DB mismatch, two competing repos, no orchestration layer exists. | Revised to 22-35 days focused execution (5-8 weeks realistic). |

### What Changed from v1.0 → v1.1

| v1.0 Statement | v1.1 Correction | Impact |
|----------------|-----------------|--------|
| "Master Orchestrator lives in n8n" (ADR-1) | **OpenClaw is the brain. n8n is the execution layer.** OpenClaw lives in Telegram, converses with the founder, decides what to trigger and when. n8n executes on command. Claude Code does heavy lifting (coding, analysis, generation). | ADR-1 rewritten. Domino 3 redesigned. Orchestrator architecture fundamentally different. |
| "ScrapMfast + ACE/SCF merge into unified system" | Renamed to **SignalSalesEngine**. Same technical merge, new product name. | Naming alignment across all references. |
| "Contabo MCP — ✅ Active" | **Contabo MCP: created but NOT YET TESTED.** Server provisioning tools exist but deployment pipeline untested. | Domino 7 effort may increase. Testing sprint needed. |
| "Scorecard API/MCP" (Gap 2) scoped to assessments only | **EO MCP** covers the full eo-mena app: assessments, submissions, directory listings, interest capture, newsletter. | Gap 2 scope expanded. MCP tool list grows. |
| "GTM skills: ✅ WORKS manually" | **GTM skills: ⚠️ NEEDS WORK.** Output not structured for autonomous use. No channel API integration. Quality inconsistent for unattended generation. | Adds new gap. GTM stage effort increases. |
| No onboarding interface in pipeline | **New: Onboarding interface on SaaSFast-v2** for post-purchase project configuration + OpenClaw setup + pipeline kickoff. | New deliverable. SaaSFast-v2 scope expands beyond boilerplate to platform frontend. |
| SaaSFast = SaaS boilerplate template only | **SaaSFast-v2 serves dual purpose:** (1) SMOrchestra's own storefront selling the Super Coder service, (2) template for customer microSaaS apps at Stage 8. | Architecture shift. SaaSFast-v2 needs admin dashboard, onboarding wizard, project status tracking. |
| "22-35 days focused, 5-8 weeks realistic" | **10 days focused, 2 weeks realistic.** AI-native execution: 4 Claude Code nodes building in parallel via OpenClaw mesh + Tailscale. Supervibes multi-terminal. n8n 24/7. Not one-developer-one-screen. | Timeline compressed 3x. Build plan restructured for parallel agent execution across nodes. |

### What Changed from v1.1 → v1.2

| v1.1 Statement | v1.2 Finding | Impact |
|----------------|-------------|--------|
| "SaaSFast-v2 repo with arabic-rtl branch — foundation done, platform features needed" | **SaaSFast is now at v3.0.0** on dev branch. Repo renamed from SaaSFast-v2 to SaaSFast. Onboarding wizard (5 steps), admin panel, customer dashboard, product catalog, 10-stage pipeline tracker, template clone/inject scripts, Supabase migration (project_runs + stage_events + template_configs) — ALL ALREADY BUILT. arabic-rtl branch is stale (merged into dev). | **Domino 1 (project_runs schema) and Domino 9 (onboarding interface) are partially DONE.** Effort shifts from building to validating + applying migration + fixing remaining issues (locale persistence, hreflang routing, Arabic pricing fields, admin auth). |
| "SuperVibes for multi-terminal coordination" | **SuperVibes is a valid Stage 5 engine** but Claude Code now has Agent Teams (parallel within-node), Remote Control (web dashboard per node, --spawn worktree --capacity 32), and Agent SDK (Python/TypeScript programmatic control). | SuperVibes useful but **partially superseded** by native Claude Code features. Agent Teams replace within-node parallelism. Remote Control replaces monitoring dashboard. SuperVibes still valuable for its controller/worker delegation pattern for code builds. |
| "OpenClaw as brain in Telegram" | **Claude Code Channels (Telegram plugin)** now pushes Telegram messages directly into running Claude Code sessions. Two-way communication. | OpenClaw still needed for **cross-node routing** (which node gets the task), but per-node Telegram dispatch can use native Channels plugin. Simplifies OpenClaw to a router, not a full message handler. |
| "claude -p on mesh nodes for heavy lifting" | **Agent SDK (Python/TypeScript)** provides programmatic Claude Code control with session IDs, structured output, cost tracking, subagent spawning, MCP connections. `--bare` flag for faster headless execution. `--fallback-model` for failover. | Agent SDK is the proper orchestration layer. OpenClaw can use Agent SDK instead of raw SSH + `claude -p`. Better error handling, session resumption, cost control. |
| "7 repos in GitHub org" | **9 repos now exist.** New: EO-Scorecard-Platform (SaaSFast v3 + gated scorecards, MOST ACTIVE), SaaSFast-v1-archived (properly archived). EO-Build still NOT archived (was supposed to be deprecated). smorch-brain has stale PR #3. | Repo inventory updated. EO-Scorecard-Platform is a critical new asset — may overlap or extend SaaSFast v3. EO-Build needs archival action. |
| "Domino 8 (GTM hardening) — 2 days, start Day 1" | No change to GTM skills status — still needs hardening. | No impact. |
| "Contabo MCP: created but NOT YET TESTED" | No change. Still untested. | No impact. |

---

## Section 1: Executive Summary

### What We're Building

A 10-stage autonomous pipeline that takes a non-technical MENA founder from "I have an idea for a micro-SaaS" to "my product is live, campaigns are running, leads are flowing" — with minimal human intervention.

This is the first domino of the Super Operator Platform. Once the Coder & Launcher path works, the same architecture supports Super Coach, Super Assistant, and Super Agency operator profiles.

### The 10-Stage Pipeline

```
[1] INTAKE ............. User describes idea (Telegram/WhatsApp)
[2] QUALIFICATION ...... 5-scorecard system validates idea, ICP, market, strategy, GTM fitness
[3] BRAIN BUILD ........ Ingests scorecard output → 12 structured project files
[4] ARCHITECTURE ....... Produces BRD, tech stack, architecture diagrams, MCP plan
[5] CODE BUILD ......... 5-phase dev pipeline (BRD → scaffold → core → integration → deploy-ready)
[6] QA + SECURITY ...... Code quality, tests, RTL Arabic, security hardening
[7] DEPLOY ............. VPS provisioning, Docker, Coolify, domain/SSL, CI/CD
[8] SAAS SHELL ......... SaaSFast wraps app with auth, payments, launch pages, AR/EN
[9] GTM GENERATION ..... Landing pages, email sequences, LinkedIn, WhatsApp copy
[10] CAMPAIGN LAUNCH ... Scraper + enrichment → signal scoring → autonomous multi-channel outbound
```

### Paying Customer

Non-technical founders in MENA who want to build and launch a MicroSaaS without hiring a dev team.

### Current State (v1.2 — Reconciled March 23)

- **75% of Legos exist.** Scorecards work. ACE campaign engine works. SCF signal pipeline works. Infrastructure is set up. Skills library is comprehensive. **SaaSFast v3.0.0 has onboarding wizard, admin panel, customer dashboard, product catalog, and pipeline tracker already built.** project_runs Supabase migration exists (not yet applied). EO-Scorecard-Platform is actively shipping (auth fixes, purchase confirmation emails as of today).
- **~15% of connective tissue exists.** OpenClaw mesh exists but no pipeline logic. SaaSFast v3 has platform UI but migration not applied and some components need finishing. Claude Code now has Agent Teams, Channels (Telegram), Remote Control, and Agent SDK — native capabilities that simplify orchestration.
- **The problem has shifted from "build everything" to "wire, validate, and connect."** The UI layer exists (SaaSFast v3). The execution layer exists (n8n ACE/SCF). The tool layer exists (MCP servers). What's missing: applying the migration, wiring OpenClaw brain logic, connecting SaaSFast dashboard to live project_runs, and hardening GTM skills for autonomous use.

### MVP-Critical Gaps (6)

| # | Gap | What Exists Today | What Must Be Built | Effort |
|---|-----|-------------------|-------------------|--------|
| 1 | Canonical Project State | **Migration SQL exists** in SaaSFast v3 (`supabase/migrations/001_product_catalog.sql`) with `project_runs`, `stage_events`, `products`, `purchases`, `template_configs` + RLS. **NOT YET APPLIED** to any Supabase project. Also assumes `profiles` table exists. | Apply migration. Verify schema against pipeline needs. Add missing fields if needed. Seed reference data. | **4-6 hours** (was 1-2 days) |
| 2 | EO MCP (full eo-mena app) | n8n webhooks exist (`/webhook/eo-full`), no programmatic trigger. **EO-Scorecard-Platform** repo is new and active — may have additional API surface. | MCP server wrapping assessments + submissions + directory + interests. Cross-check with EO-Scorecard-Platform for overlap. | 3-4 days |
| 3 | OpenClaw Brain (Orchestrator) | OpenClaw 3-node mesh exists. ACE Telegram commands exist. **Claude Code Channels (Telegram plugin)** can push messages directly into sessions. **Agent SDK** provides programmatic control. | OpenClaw as cross-node router using Agent SDK. Per-node Telegram Channels for direct dispatch. Pipeline state manager reading/writing project_runs. Quality gate logic. | 4-5 days (was 5-7 — Agent SDK simplifies) |
| 4 | SignalSalesEngine MCP | ScrapMfast + ACE/SCF merging into unified system (one interface, one DB) by ~March 28. | MCP server wrapping signal detection, enrichment, campaign launch, scoring | 2-3 days (after merge) |
| 5 | GTM Skills Hardening | 13 GTM skills work for guided sessions. Output unstructured. No channel integration. | Structured output schemas, quality validation, channel API push (GHL/Instantly/HeyReach) | 3-4 days |
| 6 | Onboarding Interface | **PARTIALLY BUILT.** SaaSFast v3 has: 5-step onboarding wizard (`/app/onboarding/`), customer dashboard (`/app/dashboard/`), admin panel (`/app/admin/`), product catalog (`/app/products/`), 10-stage pipeline tracker components. **Issues:** migration not applied, locale persistence missing, hreflang routing broken (SEO references `/en/` but no locale routing exists), Arabic pricing fields missing in storefront config, admin auth not enforced in middleware, no tests. | Apply migration. Fix locale persistence (localStorage/cookie). Fix or remove hreflang alternates. Add `nameAr` fields to storefront config. Add middleware auth guard for `/admin/*`. Wire dashboard to live Supabase project_runs. | **2-3 days** (was 4-5 — most UI is built) |

### Timeline (AI-Native Execution — v1.2 Revised)

**Infrastructure:** 4 Claude Code instances (smo-brain, smo-dev, desktop, developer desktop) connected via Tailscale + OpenClaw mesh. **Claude Code Agent Teams** for within-node parallelism. **Remote Control** for web-accessible session management per node. **Agent SDK** for programmatic orchestration. **SuperVibes** for Stage 5 code build delegation. n8n executing 24/7.

**v1.2 acceleration:** SaaSFast v3 already has onboarding, admin, dashboard, and project_runs migration built. Multiple dominoes partially complete before Day 1.

- **Focused execution:** 7-8 days (reduced from 10 — SaaSFast v3 head start)
- **Realistic with review + iteration:** 10-12 days
- **MVP demo (stages 1-3 via OpenClaw in Telegram):** Day 4
- **Full pipeline beta:** Day 7
- **Production with web onboarding:** Day 10-12

---

## Section 2: Target Customer & Commercial Model

### Primary Customer

| Attribute | Value |
|-----------|-------|
| Who | Non-technical founders in MENA (UAE, Saudi, Qatar, Kuwait, Jordan, Egypt) |
| Pain | Want to build a micro-SaaS but can't code, can't afford dev teams, don't know GTM |
| Current alternative | Hire freelancers ($5K-$20K, 3-6 months) or agencies ($20K-$50K) |
| What they get | Working SaaS app + live GTM campaigns + customer acquisition running |
| Entry point | Telegram bot or WhatsApp → guided qualification → autonomous execution |

### Revenue Model (Planned)

| Tier | Price | What's Included |
|------|-------|-----------------|
| Starter | $499/mo | Scorecard + Brain + Architecture (stages 1-4) |
| Builder | $1,499/mo | Starter + Code Build + QA + Deploy (stages 1-7) |
| Launcher | $2,999/mo | Full pipeline including SaaS shell + GTM + Campaigns (stages 1-10) |
| Enterprise | Custom | Dedicated infrastructure + custom integrations |

---

## Section 3: Pipeline — Stage-by-Stage Specification

### Stage 1: INTAKE

**What happens:** Founder messages OpenClaw in Telegram with their idea. OpenClaw brainstorms with the founder — asks clarifying questions, stress-tests the concept, identifies weak spots. Goal: raise the idea's viability before spending pipeline resources.

| Aspect | Detail |
|--------|--------|
| **Entry channels** | Telegram (primary, via OpenClaw), Web onboarding (SaaSFast-v2, future), WhatsApp (future) |
| **Current asset** | OpenClaw 3-node mesh (smo-brain gateway), ACE — Telegram Commands (n8n-dev, active), ACE — Telegram Callbacks (n8n-dev, active) |
| **Orchestration** | **OpenClaw (brain)** handles the conversation. When it decides the idea is ready for scoring, it **triggers n8n** with the structured context. n8n creates the project_run and sends scorecard link. |
| **Data captured** | User ID, raw idea description, brainstorm transcript, operator type (defaults to "coder"), timestamp |
| **Output** | Creates project_run record in Supabase, sends scorecard link or continues brainstorming if viability is low |
| **Status** | ⚠️ PARTIAL — ACE Telegram works for campaign intake. OpenClaw mesh exists. Must wire OpenClaw as conversational brain for project intake + connect to n8n execution. |
| **Gap** | No OpenClaw-to-n8n bridge for project intake. No brainstorm-to-scorecard handoff. No project_run creation. No viability pre-check logic. |

### Stage 2: QUALIFICATION

**What happens:** 5-scorecard system validates the idea across multiple dimensions.

| Aspect | Detail |
|--------|--------|
| **Scorecards** | Project Definition → ICP Clarity → Market Attractiveness → Strategy Selector → GTM Fitness |
| **Current asset** | 5 HTML scorecards at score.entrepreneursoasis.me + 6 EO n8n workflows (mamoun instance) |
| **Tech reality** | Static HTML + vanilla JS. Posts results to n8n webhooks. n8n calls Claude API for AI scoring. Results returned to browser. |
| **Data stored** | Supabase `assessments` table (via n8n). Schema confirmed: gtm_fitness_score, market_alignment_score, icp_clarity_score, total_score, improvement_recommendations (jsonb), claude_model, token_usage. |
| **Programmatic access** | `/webhook/eo-full` (POST with email) returns consolidated scores. Dashboard already uses this. |
| **Status** | ✅ WORKING for manual use. ❌ NOT API-READY for autonomous pipeline. |
| **Gap** | Need: (1) programmatic scorecard trigger, (2) MCP wrapper for score retrieval, (3) webhook/event on completion to trigger stage 3. |

### Stage 3: BRAIN BUILD

**What happens:** Scorecard outputs are ingested into 12 structured project files that become the source of truth for all downstream stages.

| Aspect | Detail |
|--------|--------|
| **12 files** | problem-definition.md, icp-profile.md, competitive-landscape.md, value-proposition.md, feature-spec.md, tech-stack.md, architecture.md, data-model.md, integration-plan.md, gtm-strategy.md, content-plan.md, launch-plan.md |
| **Current asset** | `eo-brain-ingestion` skill (markdown instructions for Claude Code) |
| **Tech reality** | Skill is a prompt that tells Claude Code how to generate the 12 files from scorecard data. Works in interactive Claude Code sessions. Not callable via API. |
| **Status** | ✅ WORKS manually in Claude Code. ❌ NOT automatable without orchestrator invoking Claude Code. |
| **Gap** | Need orchestrator to: (1) pull scorecard data from Supabase, (2) invoke Claude Code with brain-ingestion prompt, (3) store outputs in artifact registry, (4) update project_run state. |

### Stage 4: ARCHITECTURE

**What happens:** Brain files are analyzed to produce BRD, tech stack decisions, architecture diagrams, and MCP plan.

| Aspect | Detail |
|--------|--------|
| **Current asset** | `eo-tech-architect` skill + `eo-db-architect` skill (markdown instructions) |
| **Tech reality** | Skills guide Claude Code through architecture decisions. Output: BRD markdown, Supabase migration SQL, API route specs, MCP design docs. |
| **Status** | ✅ WORKS manually. ❌ NOT automatable. |
| **Gap** | Same as Stage 3: needs orchestrator + Claude Code invocation + artifact storage. |

### Stage 5: CODE BUILD

**What happens:** 5-phase development pipeline executes against the architecture.

| Aspect | Detail |
|--------|--------|
| **5 phases** | BRD interpretation → Scaffold → Core logic → Integration layer → Deploy-ready |
| **Current assets** | `eo-microsaas-dev` skill (markdown), `supervibes` tool (parallel Claude Code orchestration), Claude Code **Agent Teams** (native parallel sessions), Claude Code **Agent SDK** (programmatic control) |
| **SuperVibes** | Node.js server, tmux-based, macOS only, zero deps. Controller decomposes tasks → workers build in parallel → controller reviews. Web dashboard at localhost:3456. **Best for:** complex multi-file code builds where a "tech lead" delegates to "developers." |
| **Agent Teams** | Native Claude Code feature (experimental, v2.1.32+). Multiple sessions share task list, claim work, message each other. **Best for:** within-node parallelism without tmux management. Enable via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. |
| **Agent SDK** | Python/TypeScript SDK for programmatic Claude Code control. Session IDs, structured JSON output, cost tracking, subagent spawning, MCP connections. **Best for:** OpenClaw invoking Claude Code builds with full control. |
| **Remote Control** | Web dashboard per node via `claude remote-control --spawn worktree --capacity N`. Manage sessions from phone/browser. **Best for:** monitoring builds across nodes. |
| **Recommended approach** | **Cross-node:** OpenClaw uses Agent SDK to dispatch builds to specific nodes. **Within-node:** Agent Teams for parallel work. **Stage 5 specifically:** SuperVibes controller pattern (tech lead → workers) invoked via Agent SDK. **Monitoring:** Remote Control on each node. |
| **Status** | ✅ WORKS for human-supervised builds. ⚠️ SuperVibes + Agent Teams + Agent SDK give multiple automation paths. |
| **Gap** | Need: (1) OpenClaw triggers build via Agent SDK with architecture files, (2) SuperVibes or Agent Teams execute parallel build, (3) output pushed to GitHub repo, (4) human approval via Telegram, (5) state update on completion. |

### Stage 6: QA + SECURITY

**What happens:** Code quality review, test generation, RTL Arabic support, security hardening.

| Aspect | Detail |
|--------|--------|
| **Current asset** | `eo-qa-testing` skill + `eo-security-hardener` skill (markdown) |
| **Status** | ✅ WORKS manually. ❌ NOT automatable. |
| **Gap** | Need automated test runner + security scan triggered by orchestrator. |

### Stage 7: DEPLOY

**What happens:** VPS provisioning, Docker containerization, domain/SSL setup, CI/CD.

| Aspect | Detail |
|--------|--------|
| **Current asset** | `eo-deploy-infra` skill + Contabo MCP (server lifecycle) + eo-mena Docker support |
| **Contabo MCP** | Can create/manage/destroy VPS instances, snapshots, images, DNS, networking — all via MCP tools |
| **Docker** | eo-mena has production Dockerfile (multi-stage, node:22-alpine) |
| **Status** | ⚠️ PARTIAL — Contabo MCP works for provisioning. Docker exists in one repo. No CI/CD pipeline. |
| **Gap** | Need: (1) orchestrator triggers Contabo MCP for VPS, (2) automated Docker build + push, (3) Coolify or similar for zero-downtime deploy, (4) domain/SSL automation. |

### Stage 8: SAAS SHELL

**What happens:** SaaSFast wraps the built app with auth, payments, launch pages, bilingual support. Also serves as the platform frontend for selling the Super Coder service itself.

| Aspect | Detail |
|--------|--------|
| **Current asset** | **SaaSFast v3.0.0** (`SMOrchestra-ai/SaaSFast`, dev branch) — **MAJOR PROGRESS since v1.1** |
| **Tech reality** | ShipFast Supabase edition. Next.js 14, @supabase/ssr, Stripe, full Arabic/RTL bilingual layer. **Multi-mode config** (`NEXT_PUBLIC_APP_MODE`): `storefront` mode (sells Super Coder service) vs `template` mode (customer app shell). |
| **Dual purpose** | **(A) Platform storefront:** ✅ Product catalog, 3-tier pricing ($499/$1,499/$2,999), onboarding wizard, pipeline tracker — ALL BUILT. **(B) Customer template:** ✅ Template clone/inject scripts exist (`scripts/template-clone.sh`, `scripts/template-inject.js`). |
| **What's built (v3.0.0)** | ✅ Supabase auth/DB + Arabic/RTL bilingual (i18n, LocaleProvider, LanguageToggle) ✅ 5-step onboarding wizard (`/app/onboarding/`) ✅ Customer dashboard with pipeline tracking (`/app/dashboard/`) ✅ Admin panel (`/app/admin/` — customers, projects, stats) ✅ Product catalog (`/app/products/`, `/app/products/[slug]/`) ✅ 10-stage pipeline tracker components ✅ Supabase migration (`001_product_catalog.sql` — project_runs, stage_events, products, purchases, template_configs + RLS) ✅ Template clone/inject/seed scripts ✅ CI workflow (`.github/workflows/ci.yml`) ✅ AGENTS.md, CODEOWNERS, PR template, issue templates |
| **What's NOT done** | ❌ Migration not applied to Supabase ❌ Locale persistence (resets on page reload — needs localStorage/cookie) ❌ hreflang routing broken (SEO references `/en/` but no `/[locale]/` routes exist) ❌ Arabic pricing fields missing in storefront config (no `nameAr` in `config/storefront.js`) ❌ Admin auth not enforced in middleware (only API-level check) ❌ No tests (empty `tests/.gitkeep`) ❌ Missing CLAUDE.md ❌ main branch 6 commits behind dev |
| **Status** | ✅ **80% DONE.** UI is built. Remaining is validation, fixes, and wiring to live data. |
| **ShipFast latest** | ShipFast main branch has Next.js 15 + Tailwind 4 + DaisyUI 5 + Clerk v5 with Organizations + `claude-instructions.md` (652-line AI coding guide). Worth cherry-picking Clerk Organizations for team features later. |

### Stage 9: GTM GENERATION

**What happens:** Landing pages, email sequences, LinkedIn copy, WhatsApp messages generated from brain files.

| Aspect | Detail |
|--------|--------|
| **Current asset** | `smorch-gtm-engine` plugin (13 skills), `eo-gtm-asset-factory` skill, `asset-factory` skill |
| **GTM engine commands** | `/launch-campaign`, `/generate-assets`, `/deploy-campaign`, `/detect-signals`, `/wedge` |
| **Output types** | Email sequences (AR/EN), LinkedIn connection + follow-up messages, WhatsApp templates, landing page copy, social media posts |
| **Status** | ⚠️ NEEDS WORK — Skills produce good output in guided sessions but are NOT ready for autonomous use. |
| **Specific issues** | (1) Output is unstructured prose — no JSON/schema that downstream systems can parse. (2) No quality validation gate — output quality varies without human review. (3) No direct channel API integration — skills produce text but don't push to GHL/Instantly/HeyReach. (4) MENA-specific templates need refinement. |
| **Gap** | Need: (1) structured output schemas per asset type, (2) quality scoring/validation before push, (3) OpenClaw triggers Claude Code with GTM skills + brain files, (4) n8n receives structured assets and pushes to channel tools via their APIs, (5) artifacts stored in registry. |

### Stage 10: CAMPAIGN LAUNCH

**What happens:** SignalSalesEngine finds leads matching ICP, enriches contact data, scores signals, deploys campaigns across channels.

| Aspect | Detail |
|--------|--------|
| **Current assets** | **SignalSalesEngine** (merging by ~March 28): ACE system (19 active workflows on n8n-dev) + SCF system (10 workflows on n8n-dev + mamoun) + ScrapMfast app → unified system with one interface, one DB |
| **ACE capabilities** | Claude Brain for copywriting, Deploy Master for orchestration, channel deployers (Email/LinkedIn/WhatsApp/Social), metrics collection (Instantly/HeyReach/GHL), Telegram command interface, error handling, weekly optimization |
| **SCF capabilities** | YouTube/LinkedIn/Google Maps scrapers, Enrichment Pipeline, Campaign Trigger Evaluator, Message Generator, Campaign Executor, Webhook Handlers |
| **ScrapMfast capabilities** | REST APIs for scraper runs + leads + campaigns. Multi-tenant Supabase schema. n8n webhook triggers for actual scraping. Campaign trigger conditions (fit_score, priority_class, platform, region). |
| **Channel integrations** | Instantly (email sending via ACE), HeyReach (LinkedIn via ACE), GHL (CRM + WhatsApp via ACE), Apify (scraping via SCF n8n workflows) |
| **Status** | ✅ ACE + SCF are the most mature assets. Working in production for manual campaign management. Merging into SignalSalesEngine by ~March 28. |
| **Gap** | Need: (1) SignalSalesEngine MCP wrapping the unified API, (2) OpenClaw triggers n8n with ICP data from brain files → n8n invokes SignalSalesEngine, (3) automated lead-to-campaign routing via campaign triggers, (4) signal scoring exposed as MCP tool. |

---

## Section 4: Complete Asset Inventory (Audit-Confirmed)

### 4.1 GitHub Repositories (v1.2 — Reconciled March 23)

| Repo | Purpose | Tech Stack | Status | Pipeline Stages |
|------|---------|------------|--------|-----------------|
| **SMOrchestra-ai/smorch-brain** | Skills library + plugins (48 skills). Open PR #3 (smorch-github-ops skill, created Mar 22). | 48 MD files, 2 plugins | ✅ Active | All stages (instructions) |
| **SMOrchestra-ai/eo-assessment-system** | 5 HTML scorecards + dashboard | Vanilla HTML/JS/CSS | ✅ Live (public repo) | Stage 2 |
| **SMOrchestra-ai/eo-mena** | EO directory (Arabic-first) — **THE production repo**. v2 scaffold added Mar 22-23. | Next.js 14, TS, Supabase, Claude API, GHL, Docker | 75% | Stages 2, 8 |
| **SMOrchestra-ai/EO-Build** | ~~EO directory (dev workspace)~~ **DEPRECATED — STILL NOT ARCHIVED.** Action needed. | Next.js 14, TS, Supabase | ⚠️ Needs archival | — |
| **SMOrchestra-ai/EO-Scorecard-Platform** | **NEW.** "SaaSFast v3 + gated EO scorecards." **Most active repo** — auth callback fix, purchase confirmation email PRs merged today (Mar 23). | Unknown (needs audit) | ✅ Very Active | Stages 2, 8 |
| **SMOrchestra-ai/SaaSFast** | **Renamed from SaaSFast-v2.** Now at **v3.0.0 "MicroSaaS Launcher Platform."** Multi-mode config (storefront/template), onboarding wizard, admin panel, customer dashboard, product catalog, 10-stage pipeline tracker, template clone/inject, Supabase migration. `arabic-rtl` branch stale (merged into dev). | Next.js 14, JS, Supabase, @supabase/ssr, Stripe | ✅ Active (dev branch) | Stages 1, 6, 8, 9 |
| **SMOrchestra-ai/SaaSFast-v1-archived** | Original ShipFast-based SaaS starter. | Next.js | ✅ Archived | — |
| **SMOrchestra-ai/ScrapMfast** | **SignalSalesEngine** — merging with ACE/SCF n8n workflows. v2 scaffold added Mar 22-23. | React 18, Express, Supabase Edge Functions + n8n | Merging | Stage 10 |
| **SMOrchestra-ai/ship-fast** | Original ShipFast source (reference). CHANGELOG auto-fix Mar 22-23. | Next.js | Reference only | — |
| **smorchestraai-code/supervibes** | Parallel Claude Code orchestrator. **Stage 5 code build engine.** Initial commit only (Mar 19). | Node.js, tmux, macOS-only, zero deps | ✅ Working | Stage 5 |

**New since v1.1:** EO-Scorecard-Platform (needs audit — may overlap or extend SaaSFast v3 + eo-assessment-system). SaaSFast-v1-archived (clean archival).

**Action items:**
1. Archive EO-Build (still pending from v1.0 decision)
2. Audit EO-Scorecard-Platform — understand relationship to SaaSFast v3 and eo-assessment-system
3. Merge smorch-brain PR #3 (approaching 48hr stale threshold)
4. Delete stale `arabic-rtl` branch on SaaSFast (merged into dev)

### 4.2 n8n Workflows (Active Only)

#### n8n-dev (Campaign Engine Layer)

| Workflow | Purpose | Stage | Reusability |
|----------|---------|-------|-------------|
| ACE — Claude Brain | AI copywriting for campaigns | 9-10 | HIGH |
| ACE — Deploy Master | Campaign deployment orchestration | 10 | HIGH |
| ACE — Deploy Emails | Email campaign deployment to Instantly | 10 | HIGH |
| ACE — Deploy LinkedIn | LinkedIn campaign deployment to HeyReach | 10 | HIGH |
| ACE — Deploy WhatsApp | WhatsApp campaign deployment to GHL | 10 | HIGH |
| ACE — Deploy Social | Social media deployment | 10 | HIGH |
| ACE — Campaign Orchestrator | Master campaign conductor | 10 | HIGH |
| ACE — Reply Router | Routes inbound replies to handlers | 10 | HIGH |
| ACE — Status Sync | Syncs campaign status across channels | 10 | MEDIUM |
| ACE — Telegram Commands | Telegram bot command interface | 1, 10 | HIGH (extend for project intake) |
| ACE — Telegram Callbacks | Handles Telegram inline button responses | 1, 10 | HIGH |
| ACE — CSV Upload | Bulk lead upload | 10 | MEDIUM |
| ACE — Dashboard Generator | Campaign performance dashboards | 10 | MEDIUM |
| ACE — Error Handler | Centralized error handling | All | HIGH |
| ACE — Weekly Optimization | Automated campaign optimization | 10 | MEDIUM |
| ACE — Metrics GHL | GHL performance metrics | 10 | HIGH |
| ACE — Metrics Instantly | Instantly performance metrics | 10 | HIGH |
| ACE — Metrics HeyReach | HeyReach performance metrics | 10 | HIGH |
| ACE — BRD Intake | BRD processing (INACTIVE) | 4 | HIGH (reactivate) |
| MENA Hiring Signal Detection | Hiring intent signals | 10 | HIGH |
| SCF — YouTube Scraper | YouTube lead scraping | 10 | HIGH |
| SCF — LinkedIn Scraper | LinkedIn lead scraping | 10 | HIGH |
| SCF — Google Maps Scraper | Google Maps business scraping | 10 | HIGH |
| SCF — Enrichment Pipeline | Lead enrichment waterfall | 10 | HIGH |
| SCF — Campaign Trigger Evaluator | Signal-based campaign routing | 10 | HIGH |
| SCF — Message Generator | AI message generation | 9 | HIGH |
| SCF — Campaign Executor | Executes campaign sequences | 10 | HIGH |
| SCF — Webhook Handlers | Inbound webhook processing | 10 | HIGH |

#### n8n-mamoun (Assessment + Signal Layer)

| Workflow | Purpose | Stage | Reusability |
|----------|---------|-------|-------------|
| EO — Project Definition Assessment | Scorecard 1 of 5 | 2 | HIGH |
| EO — ICP Assessment | Scorecard 2 of 5 | 2 | HIGH |
| EO — MAS Assessment | Scorecard 3 of 5 | 2 | HIGH |
| EO — GTM Assessment | Scorecard 4 of 5 | 2 | HIGH |
| EO — Strategy Selector | Scorecard 5 of 5 | 2 | HIGH |
| EO — Consolidated Assessment | All scores combined | 2 | HIGH |
| SCF mirrors | Same as dev instance SCF | 10 | Duplicate |
| Knowledge sync (6 workflows) | Gotchas KB ↔ Notion | Support | LOW |

#### n8n-production (Legacy — Mostly Obsolete)

| Notable | Purpose | Reusable? |
|---------|---------|-----------|
| Webinar workflows (5) | Event automation | Maybe later |
| Pepsi demo workflows | Client demo | No |
| scraper test / score card | Early prototypes | No |

### 4.3 Supabase Schema (entrepreneursoasis)

| Table | Rows | Purpose | Pipeline Stage |
|-------|------|---------|---------------|
| profiles | 0 | User accounts (visitor/founder/admin) | 1 |
| countries | 22 | MENA country reference | 1, 2 |
| categories | 5 | Product categories (bilingual) | 2 |
| submissions | 0 | 5-step intake wizard | 1, 2 |
| assessments | 0 | AI scoring results (GTM/MAS/ICP) | 2 |
| scoring_rubrics | 3 | Assessment criteria (versioned) | 2 |
| products | 0 | Published directory listings | 8 |
| playbooks | 0 | AI-generated GTM playbooks | 9 |
| interests | 0 | Buyer leads / interest capture | 10 |
| newsletter_subscribers | 0 | Email list | Support |

**Key schema features:**
- pgvector installed (semantic search on product descriptions)
- RLS enabled on all 10 tables
- GHL integration fields on profiles, submissions, interests, newsletter
- AI traceability on assessments + playbooks (claude_model, token_usage, processing_time_ms)
- Enums: user_role, submission_status, payment_status, product_status, assessment_status, interest_action

**ScrapMfast Supabase (separate project, not identified in MCP):**
- 6 tables: scraper_runs, scraper_results, campaigns, leads, campaign_triggers, campaign_leads
- Multi-tenant (tenant_id on every table)
- Full campaign lifecycle tracking (pending → sent → delivered → opened → clicked → replied)

### 4.4 Skills Library (smorch-brain)

| Category | Count | Key Skills | Pipeline Stages |
|----------|-------|-----------|----------------|
| eo-scoring | 5 | project-definition, icp-clarity, market-attractiveness, strategy-selector, gtm-fitness | 2 |
| eo-training | 12 | brain-ingestion, gtm-asset-factory, tech-architect, microsaas-dev, db-architect, qa-testing, security-hardener, deploy-infra, api-connector, skill-extractor | 3-7 |
| smorch-gtm | 15 | signal-to-trust, outbound-orchestrator, ghl-operator, instantly-operator, heyreach-operator, clay-operator, n8n-architect, scraper-layer, wedge-generator | 9-10 |
| content | 7 | youtube-deck-builder, perfect-webinar, movement-builder, content-systems, engagement-engine | 9 |
| dev-meta | 6 | skill-creator, tool-super-admin, systematic-debugging, code-review | Support |
| tools | 4 | api-docs-fetcher, webapp-testing, frontend-design, lead-research | Support |

**Plugins:**
- `smorch-gtm-engine` (v1.0.0) — 13 skills, 8 commands. Campaign lifecycle from brief to deployment.
- `eo-microsaas-os` (v1.0.0) — 16 skills, 5 commands. 7-gated journey from idea to live product.
- `eo-scoring-suite` — **DOES NOT EXIST** (v0.9 assumption was wrong). Scoring lives in standalone skills.

### 4.5 Infrastructure (v1.2 — Updated with Claude Code Capabilities)

| Asset | Status | Detail |
|-------|--------|--------|
| OpenClaw 3-node mesh | ✅ Active | smo-brain (gateway) + smo-dev (agent) + desktop (agent) + developer desktop |
| Tailscale VPN | ✅ Active | smo-brain: 100.89.148.62, smo-dev: 100.117.35.19, desktop: 100.100.239.103 |
| Contabo MCP | ⚠️ Created, NOT TESTED | Server lifecycle tools exist but deployment pipeline untested. |
| Claude Code (all nodes) | ✅ v2.1.81 | Headless (`claude -p --bare`), Agent Teams, Remote Control, Channels, Agent SDK available |
| **Claude Code Agent Teams** | 🆕 Available | Parallel sessions within a single node. Enable: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Teammates share task list, claim work, message each other. |
| **Claude Code Channels** | 🆕 Available (research preview) | Telegram plugin pushes messages directly into running sessions. Two-way. `--channels plugin:telegram@claude-plugins-official`. |
| **Claude Code Remote Control** | 🆕 Available | Web dashboard per node at claude.ai/code. `claude remote-control --spawn worktree --capacity N`. Manage from phone/browser. |
| **Claude Agent SDK** | 🆕 Available | Python (`claude-agent-sdk`) + TypeScript (`@anthropic-ai/claude-agent-sdk`). Programmatic session control, structured output, cost tracking, subagent spawning. |
| SuperVibes | ✅ Working | Parallel Claude Code via tmux. Stage 5 engine. macOS only. |
| n8n-dev | ✅ 71 workflows | ACE + SCF engines |
| n8n-mamoun | ✅ 51 workflows | EO scorecards + SCF mirror |
| n8n-production | ⚠️ Legacy | 80 workflows, mostly obsolete |
| GitHub org | ✅ Team plan | SMOrchestra-ai org, **9 repos** (was 7 in v1.1) |
| Supabase (EO) | ✅ Active | entrepreneursoasis project, 10 tables. SaaSFast v3 migration exists but not applied. |

---

## Section 5: Gap Analysis (Audit-Confirmed)

### 5.1 MVP-Critical Gaps

#### Gap 0: ELIMINATED — EO Repo Decision

**Decision:** eo-mena is THE production repo. EO-Build is deprecated and will be removed from the org.
**Rationale:** eo-mena has Claude AI assessment, GHL integration, n8n webhooks, Docker — the critical backend integrations. EO-Build's cleaner UI/schema can be incrementally ported if needed.
**Action:** Archive `SMOrchestra-ai/EO-Build`. No merge work required.

#### Gap 1: Canonical Project State Schema

**Problem:** No single table tracks a project's journey through all 10 stages. Supabase has `submissions` (intake) and `assessments` (scoring) but nothing for stages 3-10.

**What to build:** New `project_runs` table in Supabase:

```sql
CREATE TABLE project_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  founder_id uuid REFERENCES profiles(id),
  submission_id uuid REFERENCES submissions(id),
  operator_type text NOT NULL DEFAULT 'coder', -- coder, coach, assistant, agency

  -- Stage status tracking
  stage_current int NOT NULL DEFAULT 1,
  stage_1_intake jsonb DEFAULT '{}',
  stage_2_qualification jsonb DEFAULT '{}',
  stage_3_brain jsonb DEFAULT '{}',
  stage_4_architecture jsonb DEFAULT '{}',
  stage_5_build jsonb DEFAULT '{}',
  stage_6_qa jsonb DEFAULT '{}',
  stage_7_deploy jsonb DEFAULT '{}',
  stage_8_saas_shell jsonb DEFAULT '{}',
  stage_9_gtm jsonb DEFAULT '{}',
  stage_10_campaign jsonb DEFAULT '{}',

  -- Cross-stage references
  github_repo_url text,
  deployment_url text,
  supabase_project_id text,
  campaign_ids text[] DEFAULT '{}',

  -- Artifacts
  brain_files jsonb DEFAULT '{}',  -- { "problem-definition": "url", ... }
  gtm_assets jsonb DEFAULT '{}',   -- { "landing-page": "url", "email-sequence": "url", ... }

  -- Approvals
  approvals jsonb DEFAULT '[]',    -- [{ stage, approved_by, approved_at, notes }]

  -- Meta
  status text NOT NULL DEFAULT 'active', -- active, paused, completed, failed, cancelled
  error_log jsonb DEFAULT '[]',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
```

**Effort:** 1-2 days (schema + RLS + helper functions)
**Blocks:** Master Orchestrator, Approval Framework, all state-dependent stages

#### Gap 2: EO MCP (Full eo-mena App)

**Problem:** The eo-mena web app has assessments, submissions, directory listings, interest capture, and newsletter — but none of it is programmatically accessible. Scorecards are HTML forms posting to n8n webhooks. The orchestrator needs to interact with ALL of this, not just assessments.

**What already works:**
- 5 HTML scorecards collecting structured input
- 6 n8n workflows processing submissions via Claude API
- `/webhook/eo-full` returns consolidated scores (Dashboard uses this)
- Supabase tables: assessments, submissions, products, interests, newsletter_subscribers, profiles

**What to build:**
1. **EO MCP Server** (Node.js/TypeScript) exposing:
   - `trigger_scorecard(founder_id, scorecard_type)` → returns session URL
   - `get_scores(founder_id)` → returns all assessment results from Supabase
   - `get_consolidated_score(founder_id)` → calls `/webhook/eo-full`
   - `subscribe_completion(founder_id, webhook_url)` → notifies when all 5 complete
   - `create_submission(founder_id, data)` → creates intake submission
   - `get_submission(submission_id)` → retrieves submission details
   - `create_product_listing(project_data)` → publishes to EO directory (Stage 8)
   - `capture_interest(product_id, buyer_data)` → logs buyer lead (Stage 10)
   - `get_founder_profile(founder_id)` → retrieves profile with all related data
2. **n8n webhook addition:** After scoring completes, POST to a "stage complete" webhook that updates `project_runs.stage_2_qualification`

**Effort:** 3-4 days
**Blocks:** Brain Build automation (stage 3), product listing (stage 8), buyer interest tracking (stage 10)

#### Gap 3: OpenClaw Brain (Orchestrator)

**Problem:** No system conducts the full 10-stage pipeline. ACE conducts campaigns (stages 9-10 only). Skills guide Claude Code but can't self-invoke. Each stage runs in isolation.

**Architecture: OpenClaw = Brain, n8n = Execution, Claude Code = Heavy Lifting**

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORCHESTRATION ARCHITECTURE                    │
│                                                                 │
│  FOUNDER ←──── Telegram ────→ OPENCLAW (Brain)                 │
│                                    │                            │
│                    ┌───────────────┼───────────────┐            │
│                    │               │               │            │
│                    ▼               ▼               ▼            │
│              CLAUDE CODE      n8n WORKFLOWS    MCP SERVERS      │
│              (thinking)       (executing)      (connecting)     │
│                                                                 │
│  • Brainstorm     • Score processing   • EO MCP                │
│  • Brain build    • Campaign deploy    • SignalSalesEngine MCP  │
│  • Architecture   • Scraping/enrich    • Contabo MCP            │
│  • Code build     • Email/LinkedIn     • GitHub MCP             │
│  • GTM generation • Deploy pipeline    • Supabase MCP           │
│  • QA review      • Webhook handling                            │
│                                                                 │
│  OpenClaw DECIDES what, when, why.                              │
│  n8n and tools EXECUTE on command.                              │
│  Claude Code does the THINKING work.                            │
│  OpenClaw backed by Claude Code = the secret of Super Agents.   │
│  n8n and other tools = execution horses.                        │
└─────────────────────────────────────────────────────────────────┘
```

**How it works:**

1. **OpenClaw lives in Telegram.** Founder messages their idea. OpenClaw (backed by Claude Code on smo-brain) engages in conversation — asks questions, stress-tests the concept, identifies weak spots, brainstorms improvements. Goal: raise the idea's viability score before spending pipeline resources.

2. **When OpenClaw decides the idea is ready,** it triggers n8n with structured context (founder ID, refined idea, conversation transcript). n8n creates the `project_run` and fires the scorecard sequence.

3. **For each pipeline stage,** OpenClaw:
   - Evaluates readiness (checks project_run state in Supabase)
   - Triggers the right execution path (n8n workflow, Claude Code session, or MCP tool)
   - Receives output and validates quality
   - Updates the founder in Telegram with progress/results
   - Decides whether to advance, retry, or pause for human approval

4. **n8n workflows execute on command:** They don't decide what to do — OpenClaw tells them. n8n handles: scorecard processing, campaign deployment, scraping/enrichment, email sending, deployment pipelines, webhook handling.

5. **Claude Code does heavy lifting:** Brain build, architecture, code generation, GTM asset creation, QA review — all invoked by OpenClaw via `claude -p` on the mesh nodes.

**What to build (v1.2 — with Claude Code native capabilities):**

| Component | Purpose | Implementation Path |
|-----------|---------|-------------------|
| `OpenClaw Project Brain` | Conversational agent in Telegram. Manages founder relationship. Decides pipeline progression. | Telegram bot on smo-brain. Uses Claude Code **Agent SDK** (Python) for reasoning. |
| `OpenClaw → n8n Bridge` | Triggers n8n workflows with structured payloads, receives callbacks. | n8n webhook triggers + callback URLs. Existing pattern from ACE. |
| `OpenClaw → Claude Code Bridge` | Invokes Claude Code on mesh nodes for heavy work. | **Agent SDK** `query()` calls over Tailscale. Structured JSON output. Session IDs for resumption. Cost tracking per project. Replaces raw SSH + `claude -p`. |
| `Per-Node Telegram Channel` | Direct Telegram-to-session push for monitoring. | Claude Code **Channels (Telegram plugin)** on each node. `--channels plugin:telegram@claude-plugins-official`. |
| `Pipeline State Manager` | Reads/writes `project_runs` in Supabase. Tracks all 10 stages. | Supabase client in OpenClaw. Migration from SaaSFast v3 applied. |
| `Quality Gate Logic` | When to auto-advance, pause for approval, or loop back. | Rules engine in OpenClaw. Telegram inline buttons for approvals (extend ACE Telegram Callbacks). |
| `n8n — SUPER Execution Workflows` | Suite of n8n sub-workflows (one per stage) that execute on command. No decision logic. | 6 new n8n workflows (see below). |
| `Remote Control Dashboard` | Web-accessible session monitoring per node. | `claude remote-control --spawn worktree --capacity 8` on each Contabo node (pm2/systemd). |

**n8n Execution Workflows (triggered by OpenClaw):**

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `SUPER — Create Project Run` | OpenClaw webhook | Creates project_run in Supabase |
| `SUPER — Score Processing` | OpenClaw webhook | Invokes EO MCP → scorecard sequence → stores results |
| `SUPER — Artifact Storage` | OpenClaw webhook | Stores brain files, GTM assets, build artifacts in Supabase Storage |
| `SUPER — Deploy Pipeline` | OpenClaw webhook | Contabo MCP → Docker build → deploy → domain/SSL |
| `SUPER — Campaign Launch` | OpenClaw webhook | SignalSalesEngine MCP → scraping → enrichment → deploy to channels |
| `SUPER — Notification` | OpenClaw webhook | Sends Telegram updates, approval requests, error alerts |

**Effort:** 5-7 days
**Blocks:** Everything. This is the backbone.

#### Gap 4: SignalSalesEngine MCP

**Problem:** ScrapMfast (UI + APIs) and n8n campaign workflows (ACE + SCF) are currently separate systems with separate databases. No MCP layer for OpenClaw to invoke.

**What's happening NOW:** ScrapMfast + ACE + SCF are merging into **SignalSalesEngine** — unified system with one interface and one database. Target completion: ~2026-03-28.

**What the merged SignalSalesEngine will have:**
- Unified API for scraper runs, leads, enrichment, campaigns
- Single Supabase database for all signal/campaign data
- n8n workflows handling execution (scraping via Apify, deployment to Instantly/HeyReach/GHL)
- One UI for campaign management

**What to build (after merge completes):**
1. **SignalSalesEngine MCP Server** (Node.js/TypeScript) wrapping the unified API:
   - `create_scraper_run(type, platform, filters, target_count)`
   - `get_scraper_status(run_id)` → progress tracking
   - `get_run_results(run_id)` → enriched leads
   - `score_leads(lead_ids[], scoring_criteria)` → signal scoring and prioritization
   - `search_leads(filters)` → query lead database
   - `get_enriched_lead(lead_id)` → full lead profile with enrichment data
   - `evaluate_campaign_triggers(lead_ids[])` → which leads are ready for which channels
   - `create_campaign(name, type, channels, templates)`
   - `launch_campaign(campaign_id)`
   - `get_campaign_metrics(campaign_id)`
   - `import_leads(campaign_id, leads[])`
2. **Webhook bridge:** Campaign completion → updates `project_runs.stage_10_campaign`
3. **OpenClaw integration:** OpenClaw invokes SignalSalesEngine MCP tools directly or triggers n8n workflows that call the MCP

**Effort:** 2-3 days (after unified system is ready)
**Dependency:** SignalSalesEngine merge (completing by ~March 28)
**Blocks:** Autonomous campaign launch (stage 10)

#### Gap 5: GTM Skills Hardening

**Problem:** The 13 GTM skills in `smorch-gtm-engine` work for human-guided Claude Code sessions but are NOT ready for autonomous pipeline use. Output is unstructured prose. No quality validation. No direct channel API integration.

**What works today:**
- Skills produce high-quality marketing assets when a human guides the session
- Email sequences, LinkedIn messages, WhatsApp templates, landing page copy, social posts
- Arabic and English output supported

**What's broken for autonomous use:**
1. **Unstructured output** — Skills produce markdown/text. No JSON schema, no structured format that n8n or channel APIs can consume.
2. **No quality gate** — Output quality varies without human review. Some runs produce excellent copy, others are generic.
3. **No channel push** — Skills produce text files. No integration with GHL (WhatsApp), Instantly (email), HeyReach (LinkedIn) APIs.
4. **MENA template gaps** — Some templates default to Western market assumptions. Need Gulf-specific messaging patterns.

**What to build:**
1. **Structured output schemas** per asset type: email sequence → JSON with subject/body/variant/channel; LinkedIn → JSON with connection note/follow-ups/InMail; landing page → HTML template + copy blocks
2. **Quality scoring module** — Claude evaluates output against ICP fit, tone consistency, CTA clarity, cultural appropriateness. Reject if below threshold.
3. **Channel adapters** — n8n sub-workflows that take structured GTM assets and push to: GHL (via GHL API), Instantly (via Instantly API), HeyReach (via HeyReach API)
4. **MENA template library** — Curated prompt enhancements for Gulf business culture, Arabic formality levels, bilingual mixing patterns

**Effort:** 3-4 days
**Dependency:** None — can start anytime
**Blocks:** Autonomous GTM generation (stage 9) and campaign launch (stage 10)

#### Gap 6: Onboarding Interface (SaaSFast-v2)

**Problem:** The pipeline starts only via Telegram (OpenClaw). There's no web-based interface for customers who purchase the Super Coder service to configure their project, track progress, or manage their build.

**What SaaSFast-v2 has today:** Supabase auth, Arabic/RTL bilingual, pricing page, Stripe checkout. A SaaS boilerplate — not a platform.

**What SaaSFast-v2 needs to become:**

1. **Post-purchase onboarding wizard:**
   - Step 1: Describe your idea (rich text + structured fields)
   - Step 2: Select operator type (Coder/Coach/Assistant/Agency)
   - Step 3: Configure preferences (language, target market, budget tier)
   - Step 4: Connect Telegram (link their account to OpenClaw)
   - Step 5: Review and launch pipeline
   - Output: Creates `project_run` in Supabase + triggers OpenClaw to begin brainstorming

2. **Project status dashboard:**
   - 10-stage pipeline visualization
   - Current stage highlighted, past stages show completion status
   - Artifacts accessible per stage (brain files, BRD, code repo, GTM assets)
   - Real-time updates from OpenClaw/n8n

3. **Admin panel (for Mamoun/team):**
   - All active project_runs
   - Pipeline health: stage durations, failure rates, bottlenecks
   - Customer management: profiles, subscription status, support tickets
   - Approval queue: pending approvals across all projects

4. **Template fork system (for Stage 8):**
   - When pipeline reaches Stage 8, system forks SaaSFast-v2 for the customer's app
   - Injects: customer branding (name, logo, colors), domain, Supabase project, Stripe keys
   - Deploys via Contabo MCP

**Effort:** 4-5 days (onboarding wizard + dashboard MVP), 3-4 days (admin panel), 2-3 days (template fork)
**Dependency:** Gap 1 (project_runs schema) + SaaSFast-v2 foundation (✅ done)
**Blocks:** Web-based customer experience. Without this, everything is Telegram-only.

### 5.2 Production-Critical Gaps (Post-MVP)

| Gap | Description | Effort |
|-----|-------------|--------|
| **Approval Framework** | Formal Telegram-based approval gates with timeout, auto-approve rules, rollback. Extend ACE Telegram Commands. | 2-3 days |
| **Artifact Registry** | S3-compatible storage (Supabase Storage or MinIO) for brain files, GTM assets, build artifacts. Linked to project_runs. | 2 days |
| **~~SaaSFast Replacement~~** | ✅ COMPLETE — Re-cloned as SaaSFast-v2 from ShipFast `supabase-clean` branch. Supabase auth/DB configured. Full Arabic/RTL bilingual layer: i18n system, LocaleProvider, LanguageToggle, hreflang SEO, all components translated (Header, Footer, Pricing, Hero, signin). Repo: `SMOrchestra-ai/SaaSFast-v2` (`arabic-rtl` branch). | Done |
| **Error Recovery + Resumability** | Checkpointing in project_runs. Deterministic reruns per stage. Partial completion handling. | 2-3 days |
| **Observability** | Centralized logging. Stage timing metrics. Cost tracking (API calls, compute). Dashboard. | 2-3 days |
| **Security: .env rotation** | ScrapMfast has committed .env with Supabase keys. Rotate and add to .gitignore. | 0.5 days |

### 5.3 Can-Wait Gaps (Future)

| Gap | Description |
|-----|-------------|
| **Multi-tenant identity** | User workspace isolation, repo permissions, billing per tenant |
| **WhatsApp intake** | Extend from Telegram-only to WhatsApp Business API |
| **Operator type routing** | Super Coach, Super Assistant, Super Agency profiles (all use same backbone) |
| **Commercial packaging** | Plans, usage limits, credits, onboarding flow |
| **n8n federation** | Distribute workloads across instances based on load |

---

## Section 6: Integration Map (v1.1 — Target Architecture)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   TARGET INTEGRATION MAP (v1.1)                         │
│          OpenClaw = Brain | n8n = Execution | Claude Code = Thinking    │
└─────────────────────────────────────────────────────────────────────────┘

  FOUNDER ◄────── Telegram ──────► OPENCLAW (Brain on smo-brain)
       │                               │
       │                    ┌──────────┼──────────────┐
       │                    │          │              │
       │                    ▼          ▼              ▼
       │             CLAUDE CODE   n8n-dev         MCP SERVERS
       │             (mesh nodes)  (execution)     (tool access)
       │                    │          │              │
  ┌────┴────────────────────┴──────────┴──────────────┴───────────┐
  │                                                                │
  │  STAGE 1 — INTAKE                                              │
  │  OpenClaw ← Telegram → brainstorms with founder                │
  │  OpenClaw → n8n: create project_run                            │
  │                                                                │
  │  STAGE 2 — QUALIFICATION                                       │
  │  OpenClaw → EO MCP: trigger scorecards                         │
  │  n8n-mamoun: processes scorecards via Claude API                │
  │  EO MCP → OpenClaw: scores complete, viability confirmed       │
  │                                                                │
  │  STAGE 3 — BRAIN BUILD                                         │
  │  OpenClaw → Claude Code (smo-brain): brain-ingestion skill     │
  │  Claude Code → 12 brain files → artifact storage               │
  │  OpenClaw → n8n: store artifacts, update project_run           │
  │                                                                │
  │  STAGE 4 — ARCHITECTURE                                        │
  │  OpenClaw → Claude Code: tech-architect + db-architect skills   │
  │  Claude Code → BRD + specs → artifact storage                  │
  │                                                                │
  │  STAGE 5 — CODE BUILD                                          │
  │  OpenClaw → Claude Code / supervibes: microsaas-dev skill      │
  │  Code → GitHub repo → OpenClaw notifies founder for approval   │
  │                                                                │
  │  STAGE 6 — QA + SECURITY                                       │
  │  OpenClaw → Claude Code: qa-testing + security-hardener skills  │
  │  Results → OpenClaw → approval gate                            │
  │                                                                │
  │  STAGE 7 — DEPLOY                                              │
  │  OpenClaw → n8n → Contabo MCP: VPS provisioning                │
  │  n8n: Docker build + push + deploy + domain/SSL                │
  │                                                                │
  │  STAGE 8 — SAAS SHELL                                          │
  │  OpenClaw → n8n: fork SaaSFast-v2 template                     │
  │  n8n: inject customer branding/config → deploy                  │
  │  OR: Founder uses SaaSFast-v2 onboarding wizard (web)          │
  │                                                                │
  │  STAGE 9 — GTM GENERATION                                      │
  │  OpenClaw → Claude Code: GTM skills with structured output     │
  │  Claude Code → structured assets (JSON schemas)                │
  │  OpenClaw → n8n: push assets to GHL/Instantly/HeyReach         │
  │                                                                │
  │  STAGE 10 — CAMPAIGN LAUNCH                                    │
  │  OpenClaw → SignalSalesEngine MCP: create scraper run           │
  │  n8n (ACE): deploy to channels                                 │
  │  n8n (ACE): metrics collection → OpenClaw → founder            │
  │                                                                │
  └────────────────────────────────────────────────────────────────┘

  SAASFAST-V2 (Web Interface — parallel to Telegram)
       │
       ├── Storefront: sells Super Coder service
       ├── Onboarding wizard: post-purchase project config
       ├── Dashboard: 10-stage pipeline status per project
       └── Admin panel: all projects, approvals, health metrics
```

**Summary:** OpenClaw is the brain — it brainstorms with founders, decides what to trigger, invokes Claude Code for thinking work, triggers n8n for execution, and reports back via Telegram. SaaSFast-v2 provides a web interface for the same pipeline (onboarding, status tracking, admin). All dashed lines from v1.0 are closed by: OpenClaw (brain) + n8n execution workflows + 3 MCP servers (EO, SignalSalesEngine, Contabo).

---

## Section 7: Build Sequence (10 Dominoes)

### Domino 1: Apply + Validate Project State Schema
**Scope:** Apply SaaSFast v3 migration (`001_product_catalog.sql`) to Supabase. Validate `project_runs`, `stage_events`, `products`, `purchases`, `template_configs` tables + RLS. Add any missing fields for pipeline needs (e.g., `brain_files`, `gtm_assets` jsonb if not present). Verify `profiles` table compatibility.
**Effort:** 2-3 hours (Day 1) — **migration SQL already exists, just needs applying + validation**
**Dependencies:** None — start immediately
**Output:** Supabase migration applied, project lifecycle trackable, SaaSFast v3 dashboard can connect to live data

### Domino 2: EO MCP (Full eo-mena App)
**Scope:** MCP server wrapping assessments + submissions + directory + interests + profiles
**Effort:** 1-1.5 days (Day 2-3, Node A)
**Dependencies:** Domino 1 (needs project_runs to update)
**Output:** Full eo-mena app accessible programmatically via MCP

### Domino 3: OpenClaw Brain (MVP — Stages 1-3)
**Scope:** OpenClaw as conversational brain in Telegram. MVP: brainstorm with founder → trigger scorecard → receive scores → invoke Claude Code for brain build.
**Effort:** 2 days (Day 3-4, Node A — **reduced from 2-3 days: Agent SDK simplifies Claude Code invocation, Channels plugin handles per-node Telegram dispatch**)
**Dependencies:** Domino 1 + Domino 2
**Output:** First automated path: Telegram → OpenClaw brainstorms → Scorecard → Brain files
**Key components:** OpenClaw→n8n bridge (webhooks), OpenClaw→Claude Code bridge (**Agent SDK**), pipeline state manager (Supabase client), quality gate logic, per-node **Channels (Telegram plugin)**
**New capability:** Agent SDK provides session IDs for resumption, structured JSON output for reliable parsing, cost tracking per project run, `--fallback-model` for failover when primary model is overloaded.

### Domino 4: Brain Build + Architecture Automation
**Scope:** OpenClaw invokes Claude Code with brain-ingestion + tech-architect skills. n8n stores artifacts.
**Effort:** 1 day (Day 5-6, Node A)
**Dependencies:** Domino 3
**Output:** Scorecard → 12 brain files → BRD + architecture automatically

### Domino 5: Code Build Pipeline
**Scope:** OpenClaw triggers code build via **Agent SDK** → SuperVibes controller pattern or **Agent Teams** for parallel work → GitHub push → approval gate via Telegram.
**Effort:** 1.5-2 days (Day 5-6, Node A)
**Dependencies:** Domino 3 + Domino 4
**Output:** Architecture → working code → GitHub repo → human approval
**Build engine options:** (A) SuperVibes controller/worker pattern for complex multi-file builds, (B) Agent Teams for within-node parallelism, (C) Agent SDK direct invocation for simpler builds. OpenClaw decides based on complexity.

### Domino 6: SignalSalesEngine MCP
**Scope:** MCP wrapping the unified SignalSalesEngine (ScrapMfast + ACE/SCF merged, one interface, one DB)
**Effort:** 1-1.5 days (Day 2-3, Node B — parallel with Domino 2)
**Dependencies:** SignalSalesEngine merge (completing ~March 28). Can parallel with Dominoes 2-5.
**Output:** Signal detection, enrichment, scoring, campaign launch invokable via MCP

### Domino 7: Deploy + SaaS Shell
**Scope:** Contabo MCP testing + Docker deployment pipeline + SaaSFast-v2 template fork system
**Effort:** 1.5-2 days (Day 3-6, Node B/C — SaaS shell foundation ✅ DONE, remaining work in parallel)
**Dependencies:** Domino 5 (needs built code for full test)
**Output:** Code → deployed app + SaaS shell (Supabase-native, bilingual)

**Progress (v1.2 — reconciled March 23):**
- ✅ **SaaSFast v3.0.0** live on dev branch (`SMOrchestra-ai/SaaSFast`)
- ✅ Supabase auth + DB (@supabase/ssr, @supabase/supabase-js)
- ✅ Full Arabic/RTL bilingual layer (i18n, LocaleProvider, LanguageToggle)
- ✅ Multi-mode config system (storefront vs template via `NEXT_PUBLIC_APP_MODE`)
- ✅ 5-step onboarding wizard, customer dashboard, admin panel, product catalog — ALL BUILT
- ✅ 10-stage pipeline tracker components
- ✅ Template clone/inject scripts + seed scripts
- ✅ Supabase migration SQL exists (project_runs, stage_events, products, purchases, template_configs)
- ✅ CI workflow, AGENTS.md, CODEOWNERS, PR/issue templates
- ⚠️ Migration NOT YET APPLIED to Supabase
- ⚠️ Locale persistence missing (resets on reload)
- ⚠️ hreflang routing broken (references `/en/` but no locale routes)
- ⚠️ Arabic pricing fields missing in storefront config
- ⚠️ Admin auth middleware not enforced
- ⚠️ Contabo MCP: created but NOT YET TESTED
- ⏳ Remaining: apply migration, fix locale/hreflang/Arabic fields, add admin middleware auth, Contabo MCP testing, Docker pipeline, Stripe checkout testing

### Domino 8: GTM Skills Hardening
**Scope:** Structured output schemas for GTM skills + quality validation + channel API adapters
**Effort:** 2 days (Day 1-3, Node B — runs in parallel from the start)
**Dependencies:** None — can parallel with everything
**Output:** GTM skills produce structured JSON output → n8n pushes to GHL/Instantly/HeyReach

### Domino 9: SaaSFast v3 Validation + Wiring
**Scope:** ~~Build onboarding wizard + dashboard + admin panel~~ → **Already built in v3.0.0.** Remaining: (1) Apply Supabase migration, (2) Fix locale persistence, (3) Fix/remove hreflang routing, (4) Add `nameAr` fields to storefront config, (5) Add admin middleware auth guard, (6) Wire dashboard to live project_runs data, (7) Test Stripe checkout flow, (8) Create CLAUDE.md for repo, (9) Merge dev → main.
**Effort:** 1.5-2 days (Day 5-7, Node B — **reduced from 2-3 days: UI is built, remaining is fixes + wiring**)
**Dependencies:** Domino 1 (migration applied)
**Output:** Production-ready web interface: onboarding → pipeline tracking → admin monitoring → Stripe payments working

### Domino 10: GTM + Campaign Connection (End-to-End)
**Scope:** Wire GTM generation → SignalSalesEngine → campaign launch. Full pipeline test.
**Effort:** 1-1.5 days (Day 8-9, all nodes for integration test)
**Dependencies:** Domino 6 + Domino 7 + Domino 8
**Output:** End-to-end: idea → deployed product → running campaigns

### Build Timeline (v1.2 — AI-Native Parallel Agent Execution)

**Execution model:** 4 Claude Code nodes (smo-brain, smo-dev, desktop, dev-desktop) working in parallel via OpenClaw mesh + Tailscale. **Agent Teams** for within-node parallelism. **Remote Control** for web-accessible monitoring per node. **Agent SDK** for programmatic orchestration. **SuperVibes** for Stage 5 code build delegation. n8n running 24/7. This is not one-developer-one-screen — this is a coordinated AI factory.

```
DAY 1:   Node A: [Domino 1 — apply + validate migration ████] (2-3 hrs)
         Node B: [Domino 8 — GTM skills hardening START ████████]
         Node C: [Domino 9 — SaaSFast v3 fixes (locale, hreflang, Arabic fields) ████████]
         [SignalSalesEngine merge continuing — team work]

DAY 2-3: Node A: [Domino 2 — EO MCP ████████████████]
         Node B: [Domino 6 — SignalSalesEngine MCP ████████████████]
         Node C: [Domino 8 — GTM hardening CONT ████████]
         Node D: [Domino 9 — SaaSFast v3 admin auth + Stripe testing ████████]

DAY 3-4: Node A: [Domino 3 — OpenClaw Brain MVP (Agent SDK) ████████████████]
         Node B: [Domino 8 — GTM hardening FINISH ████]
         Node C: [Domino 7 — Contabo MCP testing ████████]
         Node D: [Domino 9 — Wire dashboard to live project_runs ████████]

  ──── DAY 4: MVP DEMO ─── Telegram → OpenClaw brainstorms → Scorecard → Brain Build ────

DAY 4-5: Node A: [Domino 4 — Brain + Architecture automation ████████]
         Node B: [Domino 7 — Deploy pipeline + template fork ████████]

DAY 5-6: Node A: [Domino 5 — Code Build pipeline (SuperVibes + Agent Teams) ████████████]
         Node B: [Domino 7 — Docker build+push ████████]

DAY 7:   All nodes: [Domino 10 — End-to-end integration test ████████████████]

  ──── DAY 7: FULL PIPELINE BETA ─── idea → deployed product → running campaigns ────

DAY 8-10: [Polish + iteration ████████] [Admin refinement ████████]

  ──── DAY 10-12: PRODUCTION ─── with web onboarding + admin dashboard ────
```

**MVP Demo (Stages 1-3 via OpenClaw in Telegram):** Day 4
**Full Pipeline Beta (all 10 stages connected):** Day 7
**Production-Ready (with web onboarding + admin):** Day 10-12

**Why this is 7-8 days, not 10 weeks:**
- 4 Claude Code agents building in parallel (not 1 developer sequentially)
- **Agent Teams** enable within-node parallelism without tmux management
- **Agent SDK** gives OpenClaw programmatic control with structured output — no SSH screen-scraping
- **Remote Control** provides web dashboard per node — monitor everything from phone
- **SaaSFast v3.0.0 head start:** onboarding, admin, dashboard, pipeline tracker, migration SQL — all exist. Domino 1 and 9 are validate+fix, not build-from-scratch
- n8n workflows execute instantly — no waiting for humans to trigger
- MCP servers are boilerplate patterns — Claude Code generates them in hours, not days
- Every domino has clear input/output — agents don't need meetings to align

---

## Section 8: Architecture Decision Records

### ADR-1: OpenClaw = Brain, n8n = Execution Horses, Claude Code = Thinking *(Revised in v1.1, enhanced in v1.2)*

**Decision:** OpenClaw (backed by Claude Code) is the orchestration brain. n8n and other tools are execution horses. OpenClaw decides what to do, when, and why. n8n executes on command.

**Rationale:**
- OpenClaw already lives in Telegram — the primary founder interaction channel
- OpenClaw backed by Claude Code can reason about complex decisions: should we advance to the next stage? Is this output good enough? What questions should we ask the founder to improve viability?
- n8n is excellent at execution: trigger webhooks, call APIs, process data, deploy campaigns. But n8n cannot think, brainstorm, or make nuanced quality judgments.
- Separating brain (OpenClaw) from execution (n8n) means: each can be optimized independently, n8n workflows stay simple/debuggable, and the AI reasoning layer can evolve without touching execution plumbing.

**Architecture (v1.2 — with Claude Code native capabilities):**
- **OpenClaw** → lives in Telegram → uses **Agent SDK (Python)** to invoke Claude Code programmatically → reasons, decides, converses with founder
- **Claude Code Channels (Telegram plugin)** → per-node direct Telegram dispatch for monitoring and simple tasks → reduces OpenClaw's message handling burden
- **Agent SDK** → programmatic session control with structured JSON output, session IDs for resumption, cost tracking per project, `--fallback-model` for failover → replaces raw SSH + `claude -p`
- **Agent Teams** → within-node parallelism for complex tasks (Stage 5 code build, Stage 9 GTM generation) → enable via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- **Remote Control** → `claude remote-control --spawn worktree --capacity 8` on each node → web dashboard at claude.ai/code → monitor all nodes from phone
- **n8n** → receives webhook triggers from OpenClaw → executes workflows → returns results via callback
- **MCP Servers** → tools that both OpenClaw and n8n can invoke (EO MCP, SignalSalesEngine MCP, Contabo MCP)
- **SuperVibes** → Stage 5 engine: controller/worker delegation pattern for complex multi-file code builds → invoked by OpenClaw via Agent SDK

**Tradeoff:** OpenClaw is a newer, less battle-tested orchestration layer than n8n. Mitigation: keep execution logic in n8n (proven), keep only decision/reasoning in OpenClaw. Agent SDK provides structured error handling and session resumption if Claude Code fails. If OpenClaw fails, n8n workflows still run independently with manual triggers.

**Previous decisions:** v1.0: ~~"Master Orchestrator lives in n8n."~~ v1.1: OpenClaw as brain, `claude -p` via SSH. v1.2: **Agent SDK replaces raw SSH**, Channels/Remote Control/Agent Teams add native capabilities.

### ADR-2: MCP Over Pure API for AI Agent Access

**Decision:** Build MCP servers (not just REST APIs) for Scorecard and Signal Engine.
**Rationale:** The platform's AI agents (Claude Code, OpenClaw) consume tools via MCP. MCP servers let any Claude Code instance invoke scorecard or signal engine capabilities directly. REST APIs would require custom integration code in every agent.
**Tradeoff:** MCP adds ~20% more development effort vs. REST-only. Worth it for agent composability.

### ADR-3: Supabase as Canonical Data Store

**Decision:** All pipeline state lives in Supabase PostgreSQL (entrepreneursoasis project).
**Rationale:** 10 tables already exist. RLS is enabled. pgvector is installed. Assessment data is already here. n8n connects natively. Edge Functions available. One database to rule them all.
**Exception:** ~~SaaSFast currently uses MongoDB.~~ ✅ RESOLVED — SaaSFast-v2 uses Supabase natively. ScrapMfast/SignalSalesEngine has a separate Supabase project — evaluate merging into entrepreneursoasis during Domino 6.

### ADR-4: ACE Stays as Campaign Engine, New Orchestrator for Pipeline

**Decision:** Do not extend ACE to orchestrate the 10-stage pipeline. Build SUPER workflow suite separately.
**Rationale:** ACE is a mature, working campaign engine with 19 workflows. It does one thing well: manage multi-channel campaigns. Overloading it with project lifecycle management would break its clean architecture. SUPER conducts; ACE executes stages 9-10.

### ADR-5: Skills Remain Instructions, OpenClaw Invokes Claude Code *(Refined in v1.1)*

**Decision:** Do not convert the 49 skills into APIs. OpenClaw invokes Claude Code with the right skill prompt on the right mesh node.
**Rationale:** Skills are designed for Claude Code consumption. Converting them to APIs would require rewriting the logic in a completely different format. The faster path: OpenClaw → SSH to mesh node → `claude -p` with skill prompt → capture output → store artifacts → report back to founder.
**Tradeoff:** Depends on Claude Code being available and responsive. Add fallback/retry logic. OpenClaw manages the session lifecycle.
**GTM skills exception:** GTM skills (Gap 5) need structured output schemas added so n8n can parse results and push to channel APIs. The skill itself stays as markdown instructions, but output format is constrained.

---

## Section 9: Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Claude Code API latency causes stage timeouts | Medium | High | Generous timeouts (30min per stage). Async execution. Retry with backoff. |
| n8n workflow complexity makes orchestrator hard to debug | Medium | Medium | Break into small sub-workflows. Extensive logging. Error Handler pattern from ACE. |
| ~~SaaSFast MongoDB migration breaks payment flows~~ | ~~Low~~ | ~~High~~ | ✅ MITIGATED — SaaSFast v2 uses ShipFast Supabase edition natively. No migration needed. Stripe integration preserved from ShipFast. Checkout testing still required before production. |
| Two Supabase projects (EO + ScrapMfast) create data silos | Medium | Medium | Evaluate merge during Domino 6. If separate, build cross-project queries via Edge Functions. |
| Founder abandons mid-pipeline (stage 3-5 are long) | High | Medium | Telegram progress updates every stage. Pause/resume capability. 48-hour timeout with nudge. |
| .env with Supabase keys committed in ScrapMfast | Already happened | High | Rotate keys immediately. Add to .gitignore. Security audit all repos. |

---

## Section 10: Success Criteria

### MVP (Stages 1-3 Connected)

| Metric | Target |
|--------|--------|
| Telegram message → scorecard link delivered | < 30 seconds |
| 5 scorecards completed → brain files generated | < 10 minutes |
| Brain files stored and accessible | 100% reliability |
| Project run state accurately tracked | All 3 stages reflected in Supabase |

### Beta (Full Pipeline)

| Metric | Target |
|--------|--------|
| Idea → deployed product | < 48 hours (with approvals) |
| Idea → running campaigns | < 72 hours |
| Autonomous stages (no human intervention) | Stages 1, 2, 3, 9, 10 |
| Human-in-the-loop stages | Stages 4, 5, 6, 7, 8 (approval gates) |
| Pipeline success rate | > 70% (first attempt) |
| Cost per pipeline run | < $50 (API calls + compute) |

### Production

| Metric | Target |
|--------|--------|
| Concurrent pipeline runs | 5+ |
| Monthly pipeline completions | 20+ |
| Revenue per completion | $1,500+ avg |
| NPS from founders | > 60 |

---

## Section 11: Approval Request

### What You're Approving

1. **The 10-stage pipeline architecture** as defined in Section 3
2. **The orchestration model:** OpenClaw = brain (Telegram) + Agent SDK + n8n = execution + Claude Code = thinking (ADR-1 v1.2)
3. **The 10-domino build sequence** as defined in Section 7 (revised for SaaSFast v3 head start)
4. **The 6 MVP-critical gaps** and their proposed solutions in Section 5.1 (Gap 1 and 6 reduced — SaaSFast v3 partially addresses both)
5. **The 5 architecture decisions** in Section 8 (ADR-1 enhanced with Agent SDK, Channels, Remote Control, Agent Teams)
6. **SaaSFast v3 dual purpose:** storefront + customer app template (v3.0.0 already built, needs validation + wiring)
7. **The timeline:** MVP demo Day 4, full pipeline beta Day 7, production Day 10-12 (AI-native parallel execution, accelerated by SaaSFast v3 head start)
8. **New:** Claude Code Agent SDK as the programmatic orchestration layer (replaces raw SSH + `claude -p`)
9. **New:** EO-Scorecard-Platform audit needed (most active repo, may overlap SaaSFast v3 + eo-assessment-system)

### What Happens After Approval

1. **Day 1:** Domino 1 (apply migration) + Domino 8 (GTM hardening) + Domino 9 (SaaSFast v3 fixes) — parallel on 3 nodes
2. **Day 2-3:** Domino 2 (EO MCP) + Domino 6 (SignalSalesEngine MCP) + Domino 8 cont. + Domino 9 cont. — 4 nodes in parallel
3. **Day 3-4:** Domino 3 (OpenClaw Brain MVP with Agent SDK) + Domino 7 (Contabo testing) + Domino 9 (wire dashboard to live data)
4. **Day 4:** MVP Demo: Telegram → OpenClaw brainstorms → Scorecard → Brain Build (automated)
5. **Day 4-7:** Dominoes 4, 5, 7, 10 — continue parallel execution across all nodes
6. **Day 7:** Full pipeline beta test — end-to-end
7. **Day 8-12:** Polish, iteration, admin refinement → production

### Open Questions for Your Decision

1. **SaaSFast DB migration:** ✅ DONE — Re-cloned from `Marc-Lou-Org/ship-fast` (`supabase-clean` branch). Configured Supabase auth + DB. Applied full Arabic/RTL bilingual layer (i18n system, LocaleProvider, LanguageToggle, hreflang SEO, all components). Pushed as [`SMOrchestra-ai/SaaSFast-v2`](https://github.com/SMOrchestra-ai/SaaSFast-v2) on `arabic-rtl` branch. Completed in 1 session. Remaining: Contabo deployment + Stripe checkout testing.

2. **ScrapMfast Supabase:** ✅ DECIDED — Keep separate. ScrapMfast stays on its own Supabase project. Cross-project queries via Edge Functions if needed later.

3. **Approval gates:** ✅ DECIDED — Mamoun Alamouri + Lana (team member). Single-user approval flow for MVP. Multi-user approval delegation is a future enhancement.

4. **ScrapMfast .env rotation:** ✅ ACKNOWLEDGED — Rotate committed Supabase anon key. Add .env to .gitignore.

---

### Open Items for Resolution

1. **EO-Scorecard-Platform:** New repo, most active in the org. Described as "SaaSFast v3 + gated EO scorecards." **Needs audit** to understand relationship to SaaSFast v3 and eo-assessment-system. May consolidate the scorecard + platform story.
2. **EO-Build archival:** Still not archived. Blocking action from v1.0. Execute during Day 1.
3. **smorch-brain PR #3:** Open since Mar 22 (smorch-github-ops skill). Approaching 48hr stale threshold. Review and merge or close.
4. **SaaSFast `arabic-rtl` branch:** Stale (merged into dev via feature/config-refactor). Delete.

---

**This BRD v1.2 is ready for your approval. Say "approved" and I'll start executing Day 1: Domino 1 (apply migration) + Domino 8 (GTM hardening) + Domino 9 (SaaSFast v3 fixes) in parallel.**
