# VibeMicroSaaS Super AI — Execution Plan v1

> **STATUS: PARKED (2026-03-28)**
>
> This execution plan was created BEFORE the strategic decision to build an **Autonomous AI-Native Development Organization** as the primary priority. The AI-Native Org (documented in `AI-Native-Org/ai-native-org-vision-v1.md`) must be built and validated first.
>
> Once the AI org is operational, Super AI MicroSaaS Launcher becomes a **project assigned to the AI org** — not something the CEO builds manually. This plan will be revised to reflect that execution model.
>
> **What changed:** We realized that the dev-time orchestration layer (Paperclip + gstack + Superpowers + smorch skills + role CLAUDE.md) is not a setup task — it IS the primary product. Building an autonomous dev org where AI agents handle COO, CPO, Engineering, QA, GTM, and DevOps enables parallel execution of mega-projects while the CEO focuses on sales.
>
> **Self-assessment score: 5.5/10** — Key gaps identified before parking:
> - Mamoun assigned 23 coding tasks (should be CEO-only)
> - No parallel server allocation timeline
> - No skill-to-gate matrix
> - No founder user journey
> - No Paperclip dev-time layer integration
> - Phase 0 estimated at 0.5 days (grossly underestimated)

**Project:** VibeMicroSaaS Super AI Platform
**Date:** 2026-03-28
**Owner:** Mamoun Alamouri
**Based on:** BRD v1.2, Super Operator Audit, SSE Digest, ADR-006 through ADR-011
**Timeline:** 12 focused days (3 weeks realistic with review cycles) *(will be revised post AI-Native Org)*

---

## Architecture Summary (Post-ADR)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    VIBEMICROSAAAS SUPER AI ARCHITECTURE                  │
│                                                                         │
│  FOUNDER ←── Telegram ──→ OPENCLAW (COO Brain)                         │
│                                │                                        │
│                    ┌───────────┼───────────┐                            │
│                    │           │           │                            │
│                    ▼           ▼           ▼                            │
│              AGENT SDK    n8n WORKFLOWS  MCP SERVERS                    │
│              (sessions)   (execution)   (tools)                        │
│                    │                                                    │
│     ┌──────────────┼──────────────────────┐                            │
│     │              │                      │                            │
│     ▼              ▼                      ▼                            │
│  CC + VP Eng    CC + QA Lead         CC + GTM Spec                     │
│  (Superpowers)  (gstack /qa)         (GTM skills)                      │
│     │              │                      │                            │
│     ▼              ▼                      ▼                            │
│  CC + DevOps   CC + Content Lead     CC + Data Eng                     │
│  (deploy)      (asset-factory)       (scraper)                         │
│                                                                         │
│  Remote Control: --capacity 4 per node (4 nodes = 16 slots)            │
│  State: Supabase project_runs + stage_events                           │
│  Messaging: Telegram (Channels plugin + ACE callbacks)                 │
│  Monitoring: Remote Control web dashboards per node                    │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Dependency Graph

```
Phase 0 ─── Skill Install (gstack + Superpowers + Remote Control)
   │
   ├──→ Phase 1 ─── Foundation Wiring (SaaSFast v3 migration + fixes)
   │        │
   │        ├──→ Phase 2 ─── OpenClaw Brain MVP (Agent SDK + role CLAUDE.md)
   │        │        │
   │        │        ├──→ Phase 3 ─── Engine MCPs (EO MCP + SSE MCP)
   │        │        │        │
   │        │        │        └──→ Phase 4 ─── E2E Integration + QA
   │        │        │                 │
   │        │        │                 └──→ Phase 5 ─── Production Deploy
   │        │        │
   │        │        └──→ Phase 3b ─── GTM Skills Hardening (parallel)
   │        │
   │        └──→ Phase 1b ─── Repo Hygiene (parallel, non-blocking)
   │
   └──→ Phase 2b ─── Role CLAUDE.md Files (parallel with Phase 2)
```

---

## Phase 0: Skill Layer + Infrastructure Config (Day 1)

**Goal:** Install methodology frameworks and configure parallel execution. No code changes.

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 0.1 | Install gstack skills on all nodes: clone `garrytan/gstack` → `~/.claude/skills/gstack/` | Mamoun | 30 min | — | gstack `/office-hours`, `/qa`, `/review`, `/benchmark` available |
| 0.2 | Install Superpowers on all nodes: `/plugin marketplace add obra/superpowers-marketplace` | Mamoun | 30 min | — | Superpowers TDD, subagent isolation, spec compliance available |
| 0.3 | Configure Remote Control on all Contabo nodes: `claude remote-control --spawn worktree --capacity 4` with pm2/systemd auto-start | Mamoun | 2 hrs | — | 4 nodes × 4 capacity = 16 concurrent Claude Code slots |
| 0.4 | Test concurrent session spawning — verify API throttling, identify practical concurrency per key | Lana | 1 hr | 0.3 | Documented max concurrent sessions per node |
| 0.5 | Install Claude Agent SDK (Python) on smo-brain: `pip install claude-agent-sdk` | Mamoun | 30 min | — | Agent SDK ready for Phase 2 |
| 0.6 | Resolve CLAUDE.md conflicts: audit gstack + Superpowers directives vs existing project CLAUDE.md, merge non-conflicting rules | Mamoun | 1 hr | 0.1, 0.2 | Clean instruction hierarchy |
| 0.7 | Test gstack `/office-hours` with sample MicroSaaS idea against 13 GTM Matrix | Mamoun | 1 hr | 0.1 | Validated idea stress-testing flow |

**Phase 0 Total: ~4 hours (Day 1 morning)**

---

## Phase 1: Foundation Wiring (Days 1-3)

**Goal:** Make SaaSFast v3 production-ready and establish canonical state management.

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 1.1 | Apply SaaSFast v3 Supabase migration to `entrepreneursoasis` project: `001_product_catalog.sql` (project_runs, stage_events, products, purchases, template_configs + RLS + indexes) | Lana | 2 hrs | — | 6 tables live in Supabase with RLS |
| 1.2 | Verify schema against pipeline needs: confirm project_runs.stages JSONB structure matches 10-stage pipeline, confirm stage_events captures all audit data | Lana | 2 hrs | 1.1 | Schema validation report |
| 1.3 | Seed reference data: products table with 3 tiers (Starter $499, Builder $1,499, Launcher $2,999), admin profile for Mamoun | Lana | 1 hr | 1.1 | Platform catalog populated |
| 1.4 | Fix SaaSFast v3 locale persistence: implement localStorage/cookie-based locale storage so language choice survives page reload | Lana | 4 hrs | — | Arabic/English toggle persists |
| 1.5 | Fix or remove hreflang routing: SEO references `/en/` but no `[locale]` routes exist. Remove hreflang alternates until proper i18n routing is implemented | Lana | 2 hrs | — | No broken SEO signals |
| 1.6 | Add Arabic pricing fields to storefront config: `nameAr`, `descriptionAr`, `currencyAr` in `config/storefront.js` | Lana | 2 hrs | — | Bilingual storefront |
| 1.7 | Enforce admin auth in middleware: add middleware guard for `/admin/*` routes (not just API-level check) | Lana | 2 hrs | — | Admin panel secured |
| 1.8 | Wire dashboard to live Supabase project_runs: replace mock data in customer dashboard with real-time queries to `project_runs` + `stage_events` | Lana | 4 hrs | 1.1 | Live pipeline tracking visible to founders |
| 1.9 | Merge SaaSFast main ← dev (main is 6 commits behind) | Mamoun | 30 min | 1.4-1.8 | Branches aligned |
| 1.10 | Create SaaSFast CLAUDE.md with project context + coding conventions | Mamoun | 1 hr | — | Claude Code has full SaaSFast context |

**Phase 1 Total: ~3 days**

### Phase 1b: Repo Hygiene (Parallel, Day 1)

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 1b.1 | Archive EO-Build repo on GitHub | Mamoun | 15 min | — | Deprecated repo archived |
| 1b.2 | Merge smorch-brain PR #3 (smorch-github-ops skill) | Mamoun | 30 min | — | Skills registry updated |
| 1b.3 | Delete stale `arabic-rtl` branch on SaaSFast | Mamoun | 5 min | — | Branch cleanup |
| 1b.4 | Rotate ScrapMfast Supabase anon key (committed .env) | Lana | 30 min | — | Security fix |
| 1b.5 | Add .env to ScrapMfast .gitignore | Lana | 5 min | — | Prevent future key leaks |

**Phase 1b Total: ~1.5 hours (non-blocking)**

---

## Phase 2: OpenClaw Brain MVP (Days 3-6)

**Goal:** OpenClaw becomes the COO — dispatches work via Agent SDK, manages pipeline state, reports to founder in Telegram.

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 2.1 | Refactor OpenClaw → Claude Code bridge: replace SSH + `claude -p` with Agent SDK `create_session()` + `query()`. Implement: session creation with role-specific system prompts, structured JSON output parsing, cost tracking per project, session resumption via session IDs | Lana | 2 days | 0.5, 1.1 | Programmatic Claude Code control |
| 2.2 | Implement Pipeline State Manager: Supabase client in OpenClaw that reads/writes `project_runs` + `stage_events`. Functions: `create_project_run()`, `advance_stage()`, `get_current_state()`, `log_event()` | Lana | 4 hrs | 1.1 | State management for all 10 stages |
| 2.3 | Build OpenClaw → n8n bridge: webhook trigger function with structured payloads + callback URL registration. Reuse existing ACE Telegram Commands webhook pattern | Lana | 4 hrs | — | OpenClaw triggers n8n on demand |
| 2.4 | Implement Quality Gate Logic: rules engine that decides auto-advance vs pause-for-approval vs loop-back per stage. Telegram inline buttons for founder approvals (extend ACE Telegram Callbacks) | Lana | 4 hrs | 2.3 | Autonomous progression with human checkpoints |
| 2.5 | Build Stages 1-3 flow: Intake (Telegram conversation → brainstorm → viability check → project_run creation) → Qualification (trigger scorecards via n8n → wait for completion → store results) → Brain Build (invoke Claude Code with brain-ingestion skill via Agent SDK → store 12 files) | Lana | 1 day | 2.1-2.4 | MVP demo: idea → scorecards → brain files in Telegram |
| 2.6 | Configure Claude Code Channels (Telegram plugin) on smo-brain for bidirectional Telegram messaging in sessions: `--channels plugin:telegram@claude-plugins-official` | Mamoun | 2 hrs | — | Direct Telegram-to-session push |

**Phase 2 Total: ~4.5 days**

### Phase 2b: Role CLAUDE.md Files (Parallel with Phase 2)

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 2b.1 | Create `roles/vp-engineering.md`: Superpowers TDD enforcement, code quality standards, Stage 5-6 scope, Supabase/Next.js conventions | Mamoun | 2 hrs | 0.2 | VP Eng persona |
| 2b.2 | Create `roles/qa-lead.md`: gstack /qa + /benchmark, security-hardener skill, RTL Arabic validation, Stage 6-8 scope | Mamoun | 2 hrs | 0.1 | QA Lead persona |
| 2b.3 | Create `roles/gtm-specialist.md`: signal-to-trust GTM skills, HeyReach/Instantly/GHL operators, Stage 9-10 scope | Mamoun | 2 hrs | — | GTM Specialist persona |
| 2b.4 | Create `roles/content-lead.md`: asset-factory, youtube-deck, landing page generation, Stage 9 scope | Mamoun | 1 hr | — | Content Lead persona |
| 2b.5 | Create `roles/devops.md`: deploy-infra skill, Contabo MCP, Docker, Coolify, Stage 7 scope | Mamoun | 1 hr | — | DevOps persona |
| 2b.6 | Create `roles/data-engineer.md`: scraper-layer, clay-operator, enrichment pipeline, Stage 10 scope | Mamoun | 1 hr | — | Data Engineer persona |

**Phase 2b Total: ~9 hours (can be done evenings/parallel)**

---

## Phase 3: Engine MCPs + GTM Hardening (Days 5-8)

**Goal:** Build the programmatic interfaces that let OpenClaw invoke EO and SSE capabilities.

### Phase 3a: EO MCP Server

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 3a.1 | Scaffold EO MCP Server (Node.js/TypeScript): project structure, MCP server boilerplate, Supabase client setup | Lana | 4 hrs | — | MCP server skeleton |
| 3a.2 | Implement assessment tools: `trigger_scorecard()`, `get_scores()`, `get_consolidated_score()` (wraps `/webhook/eo-full`), `subscribe_completion()` | Lana | 1 day | 3a.1 | Scorecard automation |
| 3a.3 | Implement submission tools: `create_submission()`, `get_submission()`, `get_founder_profile()` | Lana | 4 hrs | 3a.1 | Intake automation |
| 3a.4 | Implement directory tools: `create_product_listing()`, `capture_interest()` | Lana | 4 hrs | 3a.1 | Stage 8 + 10 support |
| 3a.5 | Cross-check with EO-Scorecard-Platform repo for API overlap (may already have endpoints we can reuse) | Mamoun | 2 hrs | — | Deduplication |
| 3a.6 | Deploy EO MCP server to smo-brain, register in Claude Code MCP config | Lana | 2 hrs | 3a.2-3a.4 | EO MCP live |

**Phase 3a Total: ~3.5 days**

### Phase 3b: SignalSalesEngine MCP

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 3b.1 | Scaffold SSE MCP Server: project structure, MCP boilerplate, dual Supabase client (entrepreneursoasis + ScrapMfast) | Lana | 4 hrs | SSE merge complete | MCP server skeleton |
| 3b.2 | Implement signal tools: `detect_signals(icp_criteria)`, `score_signal(lead_data)`, `get_signal_feed(filters)` | Lana | 1 day | 3b.1 | Signal detection automation |
| 3b.3 | Implement enrichment tools: `enrich_lead(lead_id)`, `get_enrichment_status()` (wraps SCF Enrichment Pipeline n8n workflow) | Lana | 4 hrs | 3b.1 | Enrichment automation |
| 3b.4 | Implement campaign tools: `create_campaign(config)`, `deploy_campaign(campaign_id)`, `get_campaign_metrics()` (wraps ACE Deploy Master) | Lana | 1 day | 3b.1 | Campaign deployment automation |
| 3b.5 | Deploy SSE MCP server, register in Claude Code MCP config | Lana | 2 hrs | 3b.2-3b.4 | SSE MCP live |

**Phase 3b Total: ~3 days**

### Phase 3c: GTM Skills Hardening (Parallel)

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 3c.1 | Define structured output schemas per GTM asset type: email sequence JSON, LinkedIn message JSON, WhatsApp template JSON, landing page copy JSON, social post JSON | Mamoun | 4 hrs | — | Output schemas |
| 3c.2 | Update 5 core GTM skills (asset-factory, wedge-generator, signal-detector, signal-to-trust, outbound-orchestrator) to output structured JSON matching schemas | Mamoun | 1 day | 3c.1 | Structured GTM output |
| 3c.3 | Build quality validation gate: scoring function that rates GTM output on 5 dimensions before allowing push to channels | Mamoun | 4 hrs | 3c.1 | Quality gate |
| 3c.4 | Implement channel push integration: n8n sub-workflows that receive structured GTM JSON and push to GHL (WhatsApp), Instantly (email), HeyReach (LinkedIn) via their APIs | Lana | 1 day | 3c.2, 3c.3 | Automated channel deployment |

**Phase 3c Total: ~3 days (runs parallel with 3a/3b)**

---

## Phase 4: End-to-End Integration + QA (Days 9-11)

**Goal:** Full pipeline test from idea to live campaigns. Fix everything that breaks.

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 4.1 | Contabo MCP testing sprint: test VPS provisioning, SSH key injection, DNS management, snapshot creation via MCP tools | Lana | 1 day | — | Contabo MCP validated |
| 4.2 | E2E test — Stages 1-3: Submit test idea via Telegram → OpenClaw brainstorms → triggers scorecards → brain files generated | Mamoun + Lana | 4 hrs | 2.5, 3a.6 | Stages 1-3 verified |
| 4.3 | E2E test — Stages 4-6: Architecture generation → code build (Superpowers TDD) → QA (gstack /qa) | Lana | 4 hrs | 4.2 | Stages 4-6 verified |
| 4.4 | E2E test — Stages 7-8: Contabo VPS provisioning → Docker deploy → SaaSFast template clone + inject → customer app live | Lana | 4 hrs | 4.1, 4.3 | Stages 7-8 verified |
| 4.5 | E2E test — Stages 9-10: GTM asset generation (structured JSON) → quality gate → deploy to Instantly/HeyReach/GHL → campaign live | Mamoun | 4 hrs | 3c.4, 4.4 | Stages 9-10 verified |
| 4.6 | gstack `/qa` browser validation: run against SaaSFast storefront URL, EO Scorecard Platform URL, and test customer instance URL | Lana | 4 hrs | 4.4 | Visual QA report |
| 4.7 | gstack `/benchmark`: Core Web Vitals check on all URLs | Lana | 2 hrs | 4.6 | Performance report |
| 4.8 | Security audit: run eo-security-hardener skill on SaaSFast v3 + customer template | Lana | 4 hrs | 4.4 | Security report |
| 4.9 | Fix all issues found in 4.2-4.8 | Both | 1 day | 4.2-4.8 | All tests passing |

**Phase 4 Total: ~3 days**

---

## Phase 5: Production Deploy (Day 12)

**Goal:** SaaSFast storefront live, pipeline accepting first test customer.

| # | Task | Owner | Effort | Depends On | Output |
|---|------|-------|--------|------------|--------|
| 5.1 | Deploy SaaSFast v3 storefront to production (follow SaaSFast Gating SOP) | Lana | 4 hrs | 4.9 | smorch storefront live |
| 5.2 | Configure production Stripe webhooks + products | Mamoun | 2 hrs | 5.1 | Payments working |
| 5.3 | Configure production Resend domain + Supabase SMTP | Mamoun | 1 hr | 5.1 | Transactional emails working |
| 5.4 | Run first real customer through full pipeline (internal test — Mamoun's test idea) | Mamoun | 4 hrs | 5.1-5.3 | First end-to-end customer journey |
| 5.5 | Document operational runbook: how to monitor pipeline, handle failures, approve stages | Mamoun | 2 hrs | 5.4 | Ops runbook |

**Phase 5 Total: ~1.5 days**

---

## Timeline Summary

| Phase | Days | Calendar | Key Milestone |
|-------|------|----------|---------------|
| **Phase 0** | 0.5 | Day 1 AM | gstack + Superpowers + Remote Control configured |
| **Phase 1** | 2.5 | Days 1-3 | SaaSFast v3 production-ready, Supabase migration applied |
| **Phase 2** | 4.5 | Days 3-6 | OpenClaw COO brain live, Stages 1-3 demo in Telegram |
| **Phase 3** | 3.5 | Days 5-8 | EO MCP + SSE MCP + GTM hardening (parallel tracks) |
| **Phase 4** | 3 | Days 9-11 | Full E2E test, all 10 stages verified |
| **Phase 5** | 1.5 | Day 12 | Production storefront live, first customer through pipeline |

**Critical path:** Phase 0 → Phase 1 → Phase 2 → Phase 4 → Phase 5
**Parallel tracks:** Phase 1b, Phase 2b, Phase 3a/3b/3c can run concurrently

---

## Risk Register

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| API rate limits cap concurrent Claude Code sessions below plan | Medium | Medium | Distribute across 4 nodes; implement queue in OpenClaw |
| Contabo MCP fails testing sprint (untested since creation) | Medium | High | Fallback: manual VPS provisioning for MVP; fix MCP in Phase 5+ |
| EO-Scorecard-Platform repo overlaps with SaaSFast v3 functionality | Low | Medium | Audit in Phase 3a.5; consolidate if overlap found |
| n8n workflow modifications break existing ACE/SCF campaigns | Medium | High | Test in n8n-dev before touching n8n-mamoun; never modify n8n-production |
| Agent SDK experimental features change or break between versions | Low | Medium | Pin SDK version; test before upgrading |
| GTM skill structured output doesn't match channel API requirements | Medium | Medium | Build adapter layer in n8n sub-workflows |

---

## Success Criteria

| Metric | Target | How to Verify |
|--------|--------|---------------|
| Stages 1-3 automated via Telegram | Working | Submit idea in Telegram → brain files generated without human intervention |
| SaaSFast storefront live with payments | Working | Purchase Launcher tier → project_run created → onboarding form accessible |
| Customer dashboard shows real pipeline status | Working | Log into dashboard → see live stage progression from Supabase |
| At least one full E2E run (idea → live app → campaigns) | Complete | Test customer MicroSaaS accessible at domain, campaigns firing |
| gstack /qa passes on all URLs | Passing | No critical bugs found by browser automation |
| All code built via Superpowers TDD | Enforced | Test coverage > 0 on all Stage 5 output |

---

## Post-MVP Roadmap (Week 3+)

| Item | Priority | Notes |
|------|----------|-------|
| Hermes Agent evaluation | P2 | Install on test node, run parallel comparison vs OpenClaw + Agent SDK (ADR-010) |
| Paperclip evaluation | P3 | Revisit when v1.0 ships (estimated 6+ months) |
| Port supervibes to Linux | P3 | Only if controller/worker pattern proves necessary for Stage 5 |
| Centralized customer instance update mechanism | P1 | Push patches to N deployed instances (SaaSFast v4 roadmap) |
| Multi-currency support for MENA markets | P2 | AED, SAR, QAR, KWD in storefront config |
| WhatsApp as intake channel (parallel to Telegram) | P2 | GHL WhatsApp → OpenClaw bridge |
| Automated cost tracking dashboard | P2 | Agent SDK cost data → admin dashboard visualization |
