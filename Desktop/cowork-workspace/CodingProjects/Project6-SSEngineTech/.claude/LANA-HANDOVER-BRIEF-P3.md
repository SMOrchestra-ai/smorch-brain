# SSE V3 Phase 3 — Handover Brief for Lana

**Date:** 2026-04-14
**From:** Mamoun Alamouri (via Claude Code)
**To:** Lana Al-Kurd (QA Lead)
**Linear Parent:** SMO-173 (10 child test cases: SMO-175 through SMO-184)

---

## READ THIS FIRST

This is your bootstrap file for Phase 3 QA testing. Open this project in Claude Code and read this file before doing anything else.

**What you are testing:** The live SSE V3 production system at https://sse.smorchestra.ai — a B2B signal intelligence platform that detects buying intent, scores it via AI, and orchestrates outreach.

**What changed since the last soak test (SMO-55):**
- Frontend rebuilt: Vite + React 18 + TypeScript (was incomplete Next.js rebuild)
- Production build deployed via systemd on smo-dev
- Supabase project fixed: now pointing to `ozylyahdhuueozqhxiwz` (the correct one)
- Phase 2 added: i18n (Arabic/English), accessibility (WCAG 2.1 AA), circuit breaker dashboard, Lighthouse CI, deploy pipeline, Storybook, load tests
- Test data seeded: 50 MENA companies, 100 contacts, signals, circuit breaker state
- Your account created with credentials below

---

## YOUR CREDENTIALS

| What | Value |
|------|-------|
| SSE Login URL | https://sse.smorchestra.ai/auth/login |
| Email | lana@smorchestra.ai |
| Password | SSE-P3-Lana-2026! |
| Role | client_admin |
| Tenant | SSE P3 Test Tenant (growth tier) |

**IMPORTANT:** The login route is `/auth/login`, NOT `/login`. The app uses its own `users` table with bcrypt password hashing — NOT Supabase Auth.

---

## SYSTEM ARCHITECTURE (What You Need to Know)

```
Browser --> https://sse.smorchestra.ai
               |
            Nginx (smo-dev: 100.117.35.19)
               |                    |
       :6002 (Frontend)       :6001 (Backend API)
       Vite + React 18        Express/Node
               |                    |
            Supabase (PostgreSQL + Realtime)
            Project: ozylyahdhuueozqhxiwz
```

### Key Facts

1. **Frontend** is a Vite production build served via `vite preview` on port 6002
2. **Backend API** runs on port 6001, proxied at `/api` path
3. **Database** is Supabase PostgreSQL with Row Level Security (RLS) enabled
4. **Auth** is custom (NOT Supabase Auth) — `users` table with bcrypt hashes
5. **12 pages:** Dashboard, Leads, Signals, Campaigns, Analytics, Reports, Settings, Credits, Scrapers, Triggers, Auth (login/signup), 404

### Database Name Mapping (BRD vs Actual)

The BRD documents use different names than the actual database. **Always use actual names:**

| BRD Name | Actual DB Table |
|----------|----------------|
| customers | `tenants` |
| accounts | `company_entities` |
| contacts | `individual_entities` |
| account_intent_scores | `lead_scores_history` |
| activation_outreach | `campaign_messages` |
| signals | `signals` (same name) |
| signal_weights | `signal_weights` (same name) |
| circuit_breaker_state | `circuit_breaker_state` (same name) |

BRD compatibility views exist (`accounts`, `contacts`, `customers`, etc.) that map to the actual tables.

---

## TEST EXECUTION PLAN

### Order (Sequential — Each Depends on Previous)

| # | Linear | Test | Time | Priority |
|---|--------|------|------|----------|
| 1 | SMO-175 | Authentication & Session | 15 min | HIGH (blocks all) |
| 2 | SMO-176 | Dashboard Data Rendering | 15 min | HIGH |
| 3 | SMO-177 | Leads Management & MENA Data | 20 min | HIGH |
| 4 | SMO-178 | Signals Display & Filtering | 15 min | HIGH |
| 5 | SMO-179 | Campaign Creation (Live) | 30 min | URGENT (core test) |
| 6 | SMO-180 | Analytics & Reporting | 15 min | MEDIUM |
| 7 | SMO-181 | Credits System | 15 min | HIGH |
| 8 | SMO-182 | Settings & Circuit Breakers | 15 min | MEDIUM |
| 9 | SMO-183 | i18n Arabic/English & RTL | 20 min | HIGH |
| 10 | SMO-184 | E2E Full Pipeline | 30 min | URGENT (final) |

**Total: ~3 hours**

### How to Execute Each Test

1. Open the Linear issue (each has detailed checkboxes)
2. Work through every checkbox in order
3. For each check: mark PASS or FAIL
4. If FAIL: file a separate bug issue in Linear with the bug template below
5. When done: comment summary on the issue
6. Mark issue as **Done** (all pass) or **Blocked** (critical failures)

---

## ESCALATION RULES

### CRITICAL (Telegram Mamoun IMMEDIATELY + Stop Testing)
- Login shows blank white screen (system down)
- Real messages sent to real people via Instantly/HeyReach/GHL
- Data leaks cross-tenant (see another tenant's data)
- Security: XSS, injection, or credential exposure

### HIGH (File Linear Bug + Continue Testing)
- Page crashes or shows blank content
- Data doesn't match what was seeded
- Campaign saves but data is corrupted
- Credits deducted unexpectedly
- RLS not filtering by tenant

### MEDIUM (File Linear Bug + Continue Testing)
- Feature is placeholder/empty
- Translation missing or incorrect dialect
- Minor data inconsistencies
- UI glitches that don't block functionality

### LOW (File Linear Bug + Continue Testing)
- Cosmetic issues (alignment, spacing)
- Missing tooltips or help text
- Delete button missing (not blocking)

---

## WHEN TO FIX vs WHEN TO ESCALATE

### You CAN Fix Directly (No Approval Needed)
- Nothing. Phase 3 is a READ-ONLY test. You observe, document, and file bugs.
- You do NOT fix code, change config, or modify the database.
- Every finding becomes a Linear bug or a PASS note on the test case.

### You Escalate to Mamoun
- Any CRITICAL finding (Telegram immediately)
- Any finding that requires code changes, DB changes, or server config
- Recommending Phase 3 verdict (PASS/FAIL)
- Activating workflows or changing infrastructure

### The Rule is Simple
**Test. Document. File bugs. Report verdict. Don't fix.**

---

## DECISION AUTHORITY

### You Decide Alone
- Bug severity classification (critical/high/medium/low)
- Test strategy adjustments (skip a section, reorder non-dependent tests)
- Whether a finding is a bug vs. expected behavior

### You Decide + Notify Mamoun (Telegram)
- Skipping a test section entirely
- Blocking the entire Phase 3 test
- Recommending a feature is not production-ready

### Mamoun Decides
- Activating inactive n8n workflows
- Database schema or RLS changes
- Server/infrastructure changes
- Deploying fixes
- Declaring Phase 3 PASSED/FAILED (you recommend, he decides)

### You NEVER Do
- Deploy to production
- Push to `main` or `dev` directly
- Modify CI/CD pipelines
- Change environment variables on servers
- Share credentials or tokens

---

## BUG REPORT TEMPLATE

When filing bugs in Linear:

```
Title: [P3-TC-XX] Brief description

Severity: Critical / High / Medium / Low
Environment: sse.smorchestra.ai, Chrome XX, logged in as lana@smorchestra.ai
Test Case: SMO-XXX (link to parent test case)

Steps to Reproduce:
1. Navigate to [page]
2. Click [element]
3. Observe [behavior]

Expected: [what should happen]
Actual: [what actually happened]

Evidence: [screenshot, console error, network trace]
Console Errors: [paste any JS errors from DevTools]
```

Labels to use: `Bug`, `testing`, and one of: `frontend`, `backend`, `database`, `integration`

---

## SEEDED TEST DATA REFERENCE

### Companies (50 total)
- UAE: 20 | KSA: 15 | Qatar: 8 | Kuwait: 7
- Industries: tech, finance, real estate, consulting

### Contacts (100 total)
- 50 decision-makers (C-level, VP, Director)
- 50 individual contributors (Manager, Senior, Lead)
- Phone: +971 (UAE), +966 (KSA), +974 (Qatar), +965 (Kuwait)

### Circuit Breaker State (7 APIs)
- clay, instantly, heyreach, ghl, claude, gemini, apify
- All `closed` (healthy), `failure_count = 0`

---

## KNOWN ISSUES (Don't Re-File These)

1. **SMO-162:** deploy.yml staging/production deploy to same host (CRITICAL, known)
2. **SMO-164:** CI tests hit production URL (HIGH, known)
3. **SMO-166:** Playwright config has 4 browsers, CI only installs Chromium (HIGH, known)
4. Incomplete Next.js dashboard at `/workspaces/smo/Signal-Sales-Engine/dashboard/` — NOT the live frontend. Ignore.

---

## FILES TO READ (In Order)

| Priority | File | What It Tells You |
|----------|------|-------------------|
| 1 | This file | Session bootstrap, credentials, rules |
| 2 | `.claude/CLAUDE.md` | Full architecture, DB schema, constraints |
| 3 | `DevTeamSOP/milestones/PHASE2-CHECKPOINT-2026-04-14.md` | What Phase 2 delivered |
| 4 | `DevTeamSOP/final-sop/lana/DECISION-AUTHORITY-MATRIX.md` | Your authority boundaries |
| 5 | `.claude/LANA-ONBOARDING-BRIEF.md` | Your role definition |

---

## SESSION STARTUP CHECKLIST

Before running any test:

- [ ] Read this file completely
- [ ] Verify https://sse.smorchestra.ai loads (not blank, not error)
- [ ] Open DevTools console — note any errors before login
- [ ] Log in with credentials above
- [ ] Verify you see the dashboard after login
- [ ] Open Linear — confirm you can see SMO-173 and child issues
- [ ] Start with SMO-175 (Authentication)

---

## WHEN YOU'RE DONE

1. Comment on each child issue with PASS/FAIL summary
2. Comment on SMO-173 (parent) with:
   - Overall verdict: **PASS** / **CONDITIONAL PASS** / **FAIL**
   - Count: X/10 tests passed, Y blocked, Z failed
   - List of bugs filed (with Linear IDs)
   - Recommendation: proceed to Phase 4 or fix blockers first
3. Telegram Mamoun with one-line summary + link to SMO-173

---

*Generated 2026-04-14. Supersedes LANA-HANDOVER-BRIEF-SSE-QA.md for Phase 3.*
