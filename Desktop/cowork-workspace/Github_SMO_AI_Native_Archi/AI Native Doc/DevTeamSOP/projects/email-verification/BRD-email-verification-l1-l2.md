# BRD: Email Verification Module — Layers 1-2

**Project:** Signal Sales Engine (SSE)
**Repo:** SMOrchestra-ai/Signal-Sales-Engine
**Branch base:** main
**Business Line:** SalesMfast Signal Engine
**Author:** Mamoun Alamouri
**Date:** 2026-04-01
**Purpose:** E2E test of the AI-Native Queue Engine + deliver real business value

---

## Business Problem

When SalesMfast scrapes emails (Apify, Clay, LinkedIn Helper, manual import), bounce rates reach 25-40%. This destroys sender reputation across Instantly campaigns, kills deliverability for all clients on shared sending accounts, and wastes outreach budget on dead addresses. MENA markets make this worse: catch-all government domains, Arabic name romanization variants, non-standard mail server configs.

## Scope — Layers 1-2 Only

This BRD covers the self-contained foundation: database schema + Layer 1 (syntax validation) + Layer 2 (DNS/MX intelligence). No external paid APIs required. Layers 3-4 (SMTP API + engagement intelligence) follow in a separate BRD after this proves out.

## Success Criteria

1. 4 SQL migrations run clean against Supabase (tables, indexes, RLS, seed data)
2. Layer 1 correctly rejects disposable domains, role-based addresses, invalid syntax
3. Layer 1 detects Arabic name romanization variants (Mohammed/Muhammad/Mohamed/Mohamad)
4. Layer 2 resolves MX records via Google DNS-over-HTTPS (no Deno.resolveDns)
5. Layer 2 detects SPF/DMARC presence, catch-all domains, provider type
6. Layer 2 caches domain intelligence to avoid redundant lookups
7. Orchestrator edge function wires L1+L2, processes verification queue
8. Test suite passes: 50 emails (10 corporate, 10 Gmail, 10 invalid, 10 MENA gov, 10 disposable)
9. All code on branch `agent/TASK-XXX-email-verification`, PR to dev

## Architecture Reference

See `EmailVerification/email-verification-plan.md` for full schema definitions and architecture diagrams.
See `EmailVerification/claude-code-build-plan.md` for condensed build instructions with 5 gap fixes.

Key architecture decision: We do NOT build SMTP verification. We use commodity APIs (Layer 3, future BRD). Our moat is MENA domain intelligence, Arabic name normalization, and engagement-based scoring.

---

## Task Decomposition

### TASK-101: Database Foundation
**Role:** data_engineer
**Server:** smo-brain
**Repo:** Signal-Sales-Engine
**Tier:** staged_hybrid (Claude plans, Codex executes)
**Blocked by:** none
**Declared files:**
- `supabase/migrations/001_email_verification_tables.sql`
- `supabase/migrations/002_indexes_and_rls.sql`
- `supabase/migrations/003_auto_queue_trigger.sql`
- `supabase/migrations/004_seed_data.sql`

**Goal:**
Create 4 SQL migration files for the email verification module:

1. **001_email_verification_tables.sql** — Create 6 tables:
   - `email_verifications` (primary results cache with L1-L4 columns, overall_score 0-100, organization_id for multi-tenant)
   - `domain_intelligence` (cached domain-level DNS data with expiry)
   - `bounce_signals` (with Gap 5 fix: `sending_account_age_days`, `is_warmup_period`, `bounce_weight`)
   - `verification_queue` (priority queue with retry logic)
   - `disposable_domains` (blocklist)
   - `arabic_name_mappings` (romanization variants)
   - Add `l4_data_confidence` column to email_verifications (Gap 4 fix)

2. **002_indexes_and_rls.sql** — All performance indexes + Row Level Security policies using `organization_id`

3. **003_auto_queue_trigger.sql** — Postgres trigger function `fn_auto_queue_verification()` that auto-queues new emails for verification

4. **004_seed_data.sql** — Seed data:
   - Top 50 Arabic name mappings (Mohammed/Muhammad/Mohamed/Mohamad etc.)
   - MENA government domains pre-flagged as catch-all (.gov.ae, .gov.sa, .gov.qa, .gov.jo, .gov.kw, .gov.bh, .gov.om)
   - Disposable domains blocklist (fetch from GitHub disposable-email-domains repo, INSERT top 500)

**Hard constraints:**
- Use exact schema from `EmailVerification/email-verification-plan.md` section 2.1
- Include Gap 4 and Gap 5 schema modifications from `EmailVerification/claude-code-build-plan.md`
- All tables in `public` schema
- UUIDs for primary keys
- TIMESTAMPTZ for all timestamps
- Do NOT run migrations against Supabase — just create the SQL files

**Tests:** SQL syntax validation (parse without errors). Schema matches plan exactly.

---

### TASK-102: Layer 1 — Syntax & Pattern Validation
**Role:** vp_engineering
**Server:** smo-brain
**Repo:** Signal-Sales-Engine
**Tier:** staged_hybrid
**Blocked by:** TASK-101
**Declared files:**
- `supabase/functions/verify-email/index.ts`
- `supabase/functions/verify-email/layer1.ts`
- `supabase/functions/verify-email/types.ts`
- `supabase/functions/verify-email/utils.ts`

**Goal:**
Build Layer 1 verification logic as a Deno/Supabase Edge Function module:

1. **RFC 5322 email syntax validation** — regex + structural checks
2. **Disposable domain detection** — query `disposable_domains` table
3. **Role-based address detection** — check prefixes: info@, sales@, support@, admin@, noreply@, webmaster@, postmaster@, plus MENA Arabic equivalents
4. **Free provider detection** — gmail.com, yahoo.com, hotmail.com, outlook.com, protonmail.com, etc.
5. **Arabic name variant detection** — query `arabic_name_mappings` table, return detected variants for the local part
6. **Type definitions** — shared types for all layers (Layer1Result, Layer2Result, VerificationResult, etc.)
7. **Utility functions** — email normalization (lowercase, trim), domain extraction

**Hard constraints:**
- Deno/TypeScript (Supabase Edge Function runtime)
- Import Supabase client from `https://esm.sh/@supabase/supabase-js@2`
- Layer 1 is pure logic + DB queries — zero external API calls
- Export functions, do not create HTTP handler yet (orchestrator handles that)
- Follow structure from `EmailVerification/claude-code-build-plan.md` Phase 2

**Tests:** Unit test file with 50 test emails covering all categories.

---

### TASK-103: Layer 2 — DNS/MX Domain Intelligence
**Role:** vp_engineering
**Server:** smo-brain
**Repo:** Signal-Sales-Engine
**Tier:** staged_hybrid
**Blocked by:** TASK-101
**Declared files:**
- `supabase/functions/verify-email/layer2.ts`

**Goal:**
Build Layer 2 DNS/MX verification using Google DNS-over-HTTPS (Gap 1 fix — NO Deno.resolveDns):

1. **MX record lookup** — `GET https://dns.google/resolve?name={domain}&type=MX`
2. **SPF record check** — TXT record lookup, detect `v=spf1`
3. **DMARC record check** — lookup `_dmarc.{domain}` TXT record
4. **Provider detection** — match MX exchanges against known patterns:
   - Google Workspace: `*.google.com`, `*.googlemail.com`
   - Microsoft 365: `*.outlook.com`, `*.protection.outlook.com`
   - Zoho: `*.zoho.com`
   - Yahoo: `*.yahoodns.net`
   - On-premise Exchange: no match + specific MX patterns
5. **Catch-all detection heuristics:**
   - MENA government TLDs (.gov.ae, .gov.sa, etc.) → auto-flag catch-all
   - On-premise Exchange → higher catch-all probability
   - Known catch-all corporate domains from `domain_intelligence` table
6. **Domain intelligence caching** — check `domain_intelligence` table first, skip DNS if `dns_expires_at > NOW()`. Cache new results with 7-day expiry.
7. **Domain age estimation** — from SOA record or WHOIS (best effort)

**Hard constraints:**
- Use `fetch()` for all DNS lookups (Google DNS-over-HTTPS API)
- Cache aggressively in `domain_intelligence` table
- Handle DNS timeouts gracefully (5s timeout, return partial results)
- Export functions, do not create HTTP handler
- Follow structure from `EmailVerification/claude-code-build-plan.md` Phase 2

**Tests:** Test against known domains: google.com (valid MX, Google provider), microsoft.com (valid MX, MS provider), nonexistent-domain-xyz.com (no MX), gov.ae (catch-all).

---

### TASK-104: Verification Orchestrator
**Role:** vp_engineering
**Server:** smo-brain
**Repo:** Signal-Sales-Engine
**Tier:** staged_hybrid
**Blocked by:** TASK-102, TASK-103
**Declared files:**
- `supabase/functions/verify-email/index.ts` (update — add HTTP handler + orchestration)
- `supabase/functions/verify-email/scoring.ts`

**Goal:**
Wire Layer 1 + Layer 2 into the orchestrator edge function with scoring:

1. **HTTP handler** — Deno.serve with two modes:
   - `POST { mode: 'single', email: 'test@example.com' }` → verify one email, return result
   - `POST { mode: 'batch', batch_size: 10 }` → pick from `verification_queue` WHERE status='queued' ORDER BY priority, queued_at
2. **Orchestration flow:** L1 → if syntax invalid, stop and score → L2 → compute score → write to `email_verifications`
3. **Scoring function** (Layers 1-2 only, L3/L4 placeholders):
   - Start at 50 (neutral)
   - L1 syntax valid: +20
   - L1 not disposable: +5
   - L1 not role-based: +5
   - L2 MX valid: +15
   - L2 has SPF: +5
   - L2 has DMARC: +5
   - L2 not catch-all: +10
   - L2 catch-all detected: -15
   - L1 syntax invalid: set to 0, status='invalid'
   - L1 disposable: cap at 10, status='invalid'
   - Map score to status: 80-100='valid', 60-79='risky', 40-59='unknown', 0-39='invalid'
4. **Queue processing** — update `verification_queue` status, retry on error (max 3 retries)
5. **Error handling** — graceful degradation if L2 DNS fails (score with L1 only, flag as partial)

**Hard constraints:**
- Single Deno.serve entry point
- Auth via Supabase anon key in Authorization header
- Return JSON response with full verification result
- L3 and L4 scoring slots exist but return neutral values (0 modifier) — ready for future BRD
- Follow scoring logic from `EmailVerification/email-verification-plan.md` section on scoring

**Tests:** End-to-end test: POST 10 emails via HTTP, verify scores and statuses make sense.

---

### TASK-105: Integration Test Suite
**Role:** qa_lead
**Server:** smo-brain
**Repo:** Signal-Sales-Engine
**Tier:** fast_track (Codex)
**Blocked by:** TASK-104
**Declared files:**
- `supabase/functions/verify-email/tests/layer1.test.ts`
- `supabase/functions/verify-email/tests/layer2.test.ts`
- `supabase/functions/verify-email/tests/orchestrator.test.ts`
- `supabase/functions/verify-email/tests/test-emails.json`

**Goal:**
Comprehensive test suite for the email verification module:

1. **test-emails.json** — 50 test emails:
   - 10 valid corporate (mix of .com, .ae, .sa, .co.uk)
   - 10 free providers (gmail, yahoo, hotmail, outlook, protonmail)
   - 10 invalid syntax (missing @, double dots, spaces, unicode abuse)
   - 10 MENA government domains (.gov.ae, .gov.sa, .gov.qa, .gov.jo)
   - 10 disposable domains (guerrillamail, tempmail, throwaway)

2. **layer1.test.ts** — Unit tests for:
   - Syntax validation (valid/invalid cases)
   - Disposable detection (should flag all 10 disposable)
   - Role-based detection (info@, sales@, support@)
   - Arabic name variant detection (test with "mohammed.ali@" variations)
   - Free provider detection

3. **layer2.test.ts** — Integration tests for:
   - MX lookup for known domains (google.com → MX exists)
   - SPF/DMARC detection
   - Provider detection accuracy
   - Catch-all heuristic for MENA gov domains
   - Domain intelligence caching (second call should use cache)

4. **orchestrator.test.ts** — E2E tests:
   - Single mode: verify one valid email → score > 70
   - Single mode: verify disposable → score < 20
   - Single mode: verify invalid syntax → score = 0
   - Batch mode: queue 5 emails, process batch, verify all completed
   - Scoring accuracy: verify scores match expected ranges for each category

**Hard constraints:**
- Use Deno test runner (`Deno.test`)
- Tests must be runnable standalone (mock Supabase for unit tests, real Supabase for integration)
- Include both unit tests (mocked) and integration tests (real DB)
- Test file naming: `*.test.ts`

---

## Dependency Graph

```
TASK-101 (DB)
    ├──→ TASK-102 (Layer 1)
    └──→ TASK-103 (Layer 2)
              │
              ├──→ TASK-104 (Orchestrator) ←── TASK-102
              │
              └──→ TASK-105 (Test Suite) ←── TASK-104
```

## Estimated Complexity Scores (13-dimension)

| Task | Score | Tier | Agent |
|------|-------|------|-------|
| TASK-101 | 6 | staged_hybrid | Claude plans → Codex executes |
| TASK-102 | 9 | staged_hybrid | Claude plans → Codex executes |
| TASK-103 | 10 | staged_hybrid | Claude plans → Codex executes |
| TASK-104 | 12 | staged_hybrid | Claude plans → Codex executes |
| TASK-105 | 5 | fast_track | Codex |

## Risk Flags

- **MENA catch-all detection is heuristic** — false positives possible. Acceptable for L1-L2, Layer 4 engagement data (future BRD) will calibrate.
- **Google DNS-over-HTTPS rate limits** — unlikely at our volume, but add retry with backoff.
- **No Supabase CLI on servers** — migrations are SQL files only, manual apply via dashboard or `psql`. Edge functions deploy via `supabase functions deploy` (verify CLI is installed or use API).

## Out of Scope (Future BRD)

- Layer 3: SMTP verification via MillionVerifier/Reoon API
- Layer 4: Engagement intelligence from Instantly bounce data
- Bulk verification mode (CSV upload + async processing)
- n8n workflow for queue processing automation
- Frontend UI for verification results
- WhatsApp/LinkedIn routing for low-confidence emails
