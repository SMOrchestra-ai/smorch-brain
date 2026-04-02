# Email Verification Module — Team Guide

**Project:** Signal Sales Engine (SSE)
**Repo:** SMOrchestra-ai/Signal-Sales-Engine
**Module:** supabase/functions/verify-email/
**Last verified:** April 2, 2026
**Status:** DEPLOYED + ALL TESTS PASSING

---

## 1. Current State

The email verification module is **live and operational**.

- **Edge Function:** `verify-email` (deployed, active, 77KB)
- **Live URL:** `https://ozylyahdhuueozqhxiwz.supabase.co/functions/v1/verify-email`
- **Database:** 6 tables, 33 RLS policies, 486 disposable domains, 50 Arabic name mappings
- **Auth:** Accepts JWT anon/service_role keys via `Authorization: Bearer <key>`

### What's Built (L1 + L2)
- **Layer 1:** Syntax validation, disposable domain detection (486 domains), role-based address detection, free provider detection, Arabic name romanization (50 names)
- **Layer 2:** DNS/MX lookup via Google DNS-over-HTTPS, SPF/DMARC detection, catch-all heuristics, MENA government domain flagging (20 domains), 7-day domain cache

### What's NOT Built (by design)
- Layer 3: SMTP mailbox verification (MillionVerifier) — future BRD
- Layer 4: Engagement intelligence (Instantly bounce data) — future BRD
- Bulk CSV upload, n8n integration, frontend UI — future phases

---

## 2. How to Use It

### Single Email Verification
```bash
curl -X POST "https://ozylyahdhuueozqhxiwz.supabase.co/functions/v1/verify-email" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"mode": "single", "email": "test@example.com", "tenant_id": "00000000-0000-0000-0000-000000000001"}'
```

### Batch Processing
1. Insert emails into `verification_queue` table with tenant_id + priority
2. Call with `mode: "batch"`:
```bash
curl -X POST "https://ozylyahdhuueozqhxiwz.supabase.co/functions/v1/verify-email" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"mode": "batch", "batch_size": 10, "tenant_id": "00000000-0000-0000-0000-000000000001"}'
```

### Response Format
```json
{
  "success": true,
  "mode": "single",
  "score_breakdown": {
    "base": 50, "l1_syntax": 20, "l1_disposable": 5, "l1_role": 5,
    "l2_mx": 15, "l2_spf": 5, "l2_dmarc": 5, "l2_catch_all": 10,
    "total": 100, "status": "valid"
  },
  "result": {
    "email": "user@domain.com",
    "verdict": "deliverable|risky|undeliverable|disposable|catch_all",
    "risk_score": 0.00,
    "l1": { "syntax_valid": true, "is_disposable": false, "is_role_account": false, "is_free_provider": false, "arabic_name_matches": [] },
    "l2": { "domain_exists": true, "mx_records": [...], "mx_provider": "microsoft_365", "has_spf": true, "has_dmarc": true, "is_catch_all": false, "is_mena_gov": false }
  }
}
```

### Verdicts
| Verdict | Meaning | Action |
|---------|---------|--------|
| `deliverable` | Safe to send | Add to campaign |
| `risky` | Probably valid, some concerns | Send with caution |
| `catch_all` | Domain accepts all addresses | Verify manually or skip |
| `disposable` | Throwaway email | Never send |
| `undeliverable` | Bad email | Remove from list |

### Scoring (0-100)
| Component | Points |
|-----------|--------|
| Base | 50 |
| L1 syntax valid | +20 |
| L1 not disposable | +5 |
| L1 not role-based | +5 |
| L2 MX valid | +15 |
| L2 has SPF | +5 |
| L2 has DMARC | +5 |
| L2 not catch-all | +10 |
| L2 catch-all detected | -15 |
| Syntax invalid | total = 0 |
| Disposable | capped at 10 |

---

## 3. Test Results (April 2, 2026)

### All Tests: 22/22 PASS

| Test | Name | Result | Details |
|------|------|--------|---------|
| A1 | Tables exist | PASS | 6/6 tables found |
| A2 | Seed data | PASS | 486 disposable, 50 Arabic names |
| A3 | Auto-queue trigger | PASS | Row created with status=pending |
| A4 | RLS policies | PASS | 33 policies active |
| B1 | Valid corporate (smorchestra.com) | PASS | verdict=deliverable, risk=0.00, score=100, mx=microsoft_365, spf=true, dmarc=reject |
| B2 | Invalid syntax | PASS | verdict=undeliverable, risk=1.00, score=0 |
| B3 | Disposable (guerrillamail.com) | PASS | verdict=disposable, risk=0.90, score=10 |
| B4 | MENA gov (mof.gov.ae) | PASS | verdict=catch_all, risk=0.10, mena_gov=true, gov=true |
| B5 | Role-based (info@google.com) | PASS | role=true, role_type=info, verdict=catch_all |
| B6 | Arabic name (mohammed.ali) | PASS | 2 matches: mohammed + ali with arabic/gender/rank |
| B7 | Free provider (gmail.com) | PASS | free=true, provider=gmail, mx=google_workspace |
| B8 | Auth rejection (no token) | PASS | HTTP 401, error=Unauthorized |
| D1 | Domain cache created | PASS | smorchestra.com cached with MX/SPF/DMARC |
| D2 | Results persisted | PASS | All verifications stored in email_verifications table |
| E1 | Empty email | PASS | success=false, handled gracefully |
| E2 | Missing mode | PASS | error="Invalid mode" |
| E3 | Invalid JSON | PASS | HTTP 400, error="Invalid JSON body" |
| E4 | Unicode email | PASS | verdict=undeliverable, syntax_valid=false |
| E5 | 256-char email | PASS | verdict=undeliverable, syntax_valid=false |
| E6 | Domain cache populated | PASS | 5+ domains cached with TTL |
| E7 | Verification history | PASS | All test emails stored with correct verdicts |
| E8 | Scoring accuracy | PASS | All scores match formula within expected ranges |

---

## 4. Database Schema

### Tables
| Table | Purpose | Rows (as of test) |
|-------|---------|-------------------|
| `email_verifications` | Primary results cache with L1-L4 data | 10+ |
| `domain_intelligence` | Cached domain DNS data (7-day TTL) | 5+ |
| `bounce_signals` | Bounce tracking (L4 future) | 0 |
| `verification_queue` | Priority queue with retry logic | varies |
| `disposable_domains` | Blocklist of throwaway domains | 486 |
| `arabic_name_mappings` | Arabic name romanization variants | 50 |

### Key Indexes
- `email_verifications`: email, tenant_id, verdict, verified_at
- `domain_intelligence`: domain (unique), dns_expires_at
- `verification_queue`: tenant_id + status + priority (composite)

### RLS
All tenant-scoped tables have row-level security. Queries filter by `tenant_id` matching the JWT claim.

---

## 5. Architecture

```
Client Request
    |
    v
Deno.serve (index.ts)
    |-- Auth check (JWT payload validation)
    |
    v
Mode Router
    |-- "single" --> verify single email
    |-- "batch"  --> pull from verification_queue, process N
    |
    v
Layer 1 (layer1.ts)
    |-- RFC 5322 syntax
    |-- Disposable domain check (DB lookup)
    |-- Role-based address check
    |-- Free provider detection
    |-- Arabic name variant matching (DB lookup)
    |
    v
Layer 2 (layer2.ts)
    |-- Domain cache check (domain_intelligence, 7-day TTL)
    |-- If cache miss: Google DoH for MX, TXT (SPF), TXT (_dmarc)
    |-- Catch-all heuristic (single MX, MENA gov list)
    |-- Provider detection (google, microsoft, etc.)
    |
    v
Scoring (scoring.ts)
    |-- 0-100 composite score
    |-- Verdict assignment
    |
    v
Persist to DB --> Return JSON response
```

---

## 6. Known Limitations

| # | Issue | Severity | Workaround |
|---|-------|----------|------------|
| 1 | Auth has hardcoded project ref | Low | Works for current project. Extract to env for multi-project |
| 2 | No rate limiting on edge function | Medium | Supabase has built-in limits. Add custom if needed |
| 3 | `expires_at` never set on verifications | Low | Results accumulate. Add TTL cleanup job later |
| 4 | Missing index on `dns_expires_at` | Low | Add when domain_intelligence > 10K rows |
| 5 | No DKIM verification (only SPF/DMARC) | Low | DKIM requires complex DNS parsing. Out of L2 scope |
| 6 | Catch-all detection is heuristic, not SMTP-based | Medium | Acceptable for L2. L3 will add SMTP confirmation |

---

## 7. Supabase Access

| What | Value |
|------|-------|
| Project ref | ozylyahdhuueozqhxiwz |
| Dashboard | https://supabase.com/dashboard/project/ozylyahdhuueozqhxiwz |
| Edge function URL | https://ozylyahdhuueozqhxiwz.supabase.co/functions/v1/verify-email |
| Management API | `POST https://api.supabase.com/v1/projects/ozylyahdhuueozqhxiwz/database/query` with Bearer token |

**Note:** MCP Supabase tools are linked to the wrong org. Use Management API via curl or Supabase CLI with `SUPABASE_ACCESS_TOKEN` env var instead.

---

## 8. For Developers

### Running Tests Locally
Tests can be re-run using the curl commands in Section 3. All you need is the anon key (in Supabase Dashboard → Settings → API).

### Deploying Changes
```bash
# On smo-dev
cd /workspaces/smo/Signal-Sales-Engine
supabase functions deploy verify-email --project-ref ozylyahdhuueozqhxiwz
```

### Code Location
- Edge function: `supabase/functions/verify-email/index.ts`
- Layer 1: `supabase/functions/verify-email/layer1.ts`
- Layer 2: `supabase/functions/verify-email/layer2.ts`
- Scoring: `supabase/functions/verify-email/scoring.ts`
- Migrations: `supabase/migrations/` (6 files, already applied)

### Auth Fix (applied 2026-04-02)
Supabase edge runtime injects new-format keys (`sb_secret_*`, `sb_publishable_*`) as env vars, not JWT-format keys. The function was patched to validate JWT payload (iss, ref, role) as fallback when token doesn't match env vars. Commit `c05c438` on smo-dev main.
