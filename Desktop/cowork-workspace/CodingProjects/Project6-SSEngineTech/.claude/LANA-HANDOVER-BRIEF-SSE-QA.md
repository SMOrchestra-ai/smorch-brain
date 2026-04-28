# SSE V3 Soak Test — Handover Brief for Lana

**Date:** 2026-04-08
**From:** Mamoun (via Claude Code)
**To:** Lana Al-Kurd (QA Lead)
**Linear Parent:** SMO-55

---

## What This Is

A full QA soak test of the Signal Sales Engine V3 — 8 test suites covering all 7 BRDs (Database, Signal Ingestion, Scoring, Activation, Learning, Dashboard, Security, E2E). All test cases are filed as child issues under SMO-55 in Linear, assigned to you.

## What Changed

An automated audit was run on 2026-04-08 checking:
- Supabase database schema (project: odjuqweiyzicqmcqozsu)
- n8n workflows on smo-dev (34 workflows) and smo-brain (74 workflows)
- Git repo for frontend/test code

## Known Issues (Start Here)

These are pre-identified. You'll likely hit them immediately:

| # | Issue | Severity | What to Do |
|---|-------|----------|------------|
| 1 | **RLS OFF on 31/36 tables** | CRITICAL | File bug, Telegram Mamoun immediately |
| 2 | **All tables have 0 rows** (no seed data) | HIGH | File bug — blocks all testing |
| 3 | **Schema naming differs from BRD** (`tenants` not `customers`) | MEDIUM | Document mapping, not necessarily a bug |
| 4 | **10+ SSE workflows INACTIVE on smo-dev** | HIGH | May need activation — check with Mamoun |
| 5 | **No frontend code in Git repo** | HIGH | Check if deployed on smo-dev:3000 first |
| 6 | **Zero test files in repo** | MEDIUM | Expected for now — testing is manual via these issues |

## Test Execution Order

**Must be sequential** — each depends on the previous:

```
SSE-QA-01 (Database) ← START HERE, blocks everything
    ↓
SSE-QA-02 (Signal Ingestion) ← needs seed data
    ↓
SSE-QA-03 (Scoring) ← needs signals
    ↓
SSE-QA-04 (Outreach) ← needs scores
    ↓
SSE-QA-05 (Learning) ← needs deals (may defer)
    ↓
SSE-QA-06 (Dashboard) ← needs all above for display
    ↓
SSE-QA-07 (Security) ← can run in parallel with QA-02+
    ↓
SSE-QA-08 (E2E Smoke) ← final, needs everything working
```

## Files to Read First

| Priority | File | Why |
|----------|------|-----|
| 1 | `.claude/LANA-PROJECT-CONTEXT.md` | Architecture, constraints, tech debt |
| 2 | `docs/SSE-V3-QA-Testing-Guide.md` | Existing test scenarios |
| 3 | `.claude/CLAUDE.md` | Full system spec (DB schema, workflows, rules) |
| 4 | `DevTeamSOP/final-sop/LANA-GUIDE.md` | Your operational reference |

## Servers

| Server | IP | What's There | n8n URL |
|--------|----|-------------|---------|
| smo-brain | 100.89.148.62 | CEO agent, core SSE workflows (enrichment, scraping, campaigns) | testflow.smorchestra.ai |
| smo-dev | 100.117.35.19 | VP Eng, SSE scoring/routing/senders, infra workflows | flows.smorchestra.ai |

## Database

- **Supabase project:** odjuqweiyzicqmcqozsu
- **Region:** ap-southeast-1
- **Tables:** 36 in public schema
- **Key mapping:** tenants=customers, company_entities=accounts, individual_entities=contacts, lead_scores_history=account_intent_scores, campaign_messages=activation_outreach

## Key n8n Workflows (smo-dev)

| Workflow | ID | Status | BRD |
|----------|----|--------|-----|
| 003 - Signal Scoring Engine | MkJ05NGfy32rdHkY | INACTIVE | BRD-3 |
| SSE Outreach Routing | JAundhHlxcM4JI5K | INACTIVE | BRD-4 |
| SSE Outreach Queue Processor | uXcZEqQBX3NpvGSY | INACTIVE | BRD-4 |
| SSE Send via Instantly (Email) | vk7RlI9I723xYyxO | INACTIVE | BRD-4 |
| SSE Send via HeyReach (LinkedIn) | fiYGIvmBkhuhfXtX | INACTIVE | BRD-4 |
| SSE Send via GHL (WhatsApp) | 1jVeiusuB4jsGa6L | INACTIVE | BRD-4 |
| SSE — GHL CRM Sync | 4Q6EJdfEyOn8ApN5 | INACTIVE | BRD-5 |
| SSE — Clay Enrichment Sync | 8s6735vNgZdpXk63 | INACTIVE | BRD-2 |
| SSE — Firecrawl Prospect Intelligence | tu662HydVsSGGOTP | INACTIVE | BRD-2 |
| SSE — Firecrawl Competitor Diff Monitor | Rg4b0N22C6P9AUiu | INACTIVE | BRD-2 |
| SSE — Webhook: Instantly | Rgd8sn9p8T7yxvLb | INACTIVE | BRD-2 |
| SSE — Webhook: HeyReach | roK6Rj1gcjKmiFIR | INACTIVE | BRD-2 |
| Clay Enrichment-test | -lQlw0onMdoIWjOIVkX-O | ACTIVE | BRD-2 |
| MENA Hiring Signal Detection | lP7WLybdKWzttK7nV4idS | ACTIVE | BRD-2 |
| outreach/activate | OeBcei0sDRUqaOIDqPrW7 | ACTIVE | BRD-4 |

## Decision Authority for This Test

| Decision | Who |
|----------|-----|
| Bug severity (critical/high/medium/low) | Lana decides alone |
| Test strategy adjustments | Lana decides alone |
| Skipping a test section (can't test) | Lana decides + notifies Mamoun |
| Activating inactive workflows | Mamoun decides |
| Schema migrations (RLS enable, seed data) | Mamoun decides |
| Declaring soak test PASSED/FAILED | Lana recommends, Mamoun approves |

## How to Report Results

For each test issue (SSE-QA-01 through SSE-QA-08):
1. Work through each checkbox
2. Mark PASS or FAIL next to each
3. For failures: file a separate bug issue in Linear, link to the QA issue
4. When done with all checkboxes: comment on the issue with summary
5. Mark issue as Done if all pass, or Blocked if critical failures

## Escalation

- **CRITICAL finding** (RLS off, data leak, injection) → Telegram Mamoun immediately + block the test
- **HIGH finding** (workflow broken, no seed data) → File bug, continue testing other areas
- **MEDIUM/LOW finding** → File bug, continue testing, include in final summary
