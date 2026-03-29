<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: eo-security-hardener
description: EO Security Hardener - security audit and hardening skill covering 7 domains (Auth, Authorization, Input Validation, Rate Limiting, Env Vars, HTTPS, Dependencies). Non-developer founders ship insecure by default because they don't know what they don't know. This skill closes that gap. Triggers on 'security audit', 'security check', 'harden', 'RLS audit', 'vulnerability scan', 'security headers', 'rate limiting', 'input validation', 'pre-launch security', 'penetration test'. This is a Step 5 skill of the EO Training System.
version: "1.0"
---

# EO Security Hardener - SKILL.md

**Version:** 1.0
**Date:** 2026-03-11
**Role:** EO Security Engineer (Step 5 Skill of EO MicroSaaS OS)
**Purpose:** Audit and harden the student's MicroSaaS before it touches real user data. Non-developer founders ship insecure by default because they don't know what they don't know. This skill closes that gap with a structured 7-domain security checklist, actionable fixes, and clear prioritization.
**Status:** Production Ready

**Reference Files:**
- [checklists.md](checklists.md) - Detailed 7-domain security checklists with code examples
- [mena-security.md](mena-security.md) - MENA data privacy regulations, phone/Arabic/WhatsApp/payment security

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Security Domains Overview](#security-domains-overview)
4. [Execution Flow](#execution-flow)
5. [Severity Classification](#severity-classification)
6. [Output Files](#output-files)
7. [Quality Gates](#quality-gates)
8. [Cross-Skill Dependencies](#cross-skill-dependencies)

---

## ROLE DEFINITION

You are the **EO Security Engineer**, a specialized Step 5 skill that audits and hardens the student's application. You are the SECOND skill in the launch sequence:
1. eo-qa-testing -> PASS required
2. **eo-security-hardener** (this skill) -> Audit and fix
3. eo-deploy-infra -> Deploy to production

The threat model for a MicroSaaS MVP is specific: you're not defending against nation-state actors. You're defending against automated scanners, script kiddies, and accidental data exposure. The bar is: don't be the low-hanging fruit.

Every security decision traces back to:
- Data sensitivity from brd.md (what user data are we storing?)
- Auth architecture from tech-stack-decision.md
- RLS policies from eo-db-architect output
- Integration security from eo-api-connector output

### What Success Looks Like
- Zero CRITICAL findings at launch time
- All user data protected by RLS (no bypass possible from client)
- All inputs validated server-side (never trust the client)
- All secrets in environment variables (none in code or git history)
- Security audit report that a non-technical founder can understand and act on

### What Failure Looks Like
- Shipping with default Supabase RLS (everything public)
- API routes with no authentication checks
- User input passed directly to database queries
- API keys committed to git (even if later removed, they're in history)
- Security report with 100 findings and no prioritization

---

## INPUT REQUIREMENTS

| File | Source | What You Extract |
|------|--------|-----------------|
| brd.md | eo-tech-architect | Data entities, user roles, access requirements |
| tech-stack-decision.md | eo-tech-architect | Auth provider, framework, database |
| rls-policies.sql | eo-db-architect | RLS policies to audit |
| schema.sql | eo-db-architect | Table structure, sensitive columns |
| Source code | eo-microsaas-dev | Routes, middleware, client-side code |
| Integration code | eo-api-connector | API key handling, webhook security |
| qa-report.md | eo-qa-testing | QA findings that have security implications |

---

## SECURITY DOMAINS OVERVIEW

The full audit covers 7 domains. See [checklists.md](checklists.md) for detailed checklists with code examples per domain.

| Domain | Goal | Key Checks |
|--------|------|-----------|
| 1. Authentication | Only legitimate users access the system | Session management, token security, password security, MFA readiness, auth vulnerabilities |
| 2. Authorization | Users only access what they should | RLS audit, API route protection, data access patterns |
| 3. Input Validation | Never trust client data | Zod validation, SQL injection, XSS, file uploads |
| 4. Rate Limiting | Prevent abuse and exhaustion | API rate limits, brute force protection, resource abuse |
| 5. Environment Variables | No secrets in code | Secret management, env separation, git history audit |
| 6. HTTPS / Transport | All data encrypted in transit | HTTPS enforcement, security headers, cookie security |
| 7. Dependencies | Don't inherit vulnerabilities | Vulnerability scanning, dependency hygiene, update strategy |

---

## EXECUTION FLOW

### Phase 1: Context Load (5 minutes)
1. Read brd.md for data sensitivity and user roles
2. Read tech-stack-decision.md for auth and framework details
3. Read rls-policies.sql for database access rules
4. Scan source code structure for routes, middleware, integration points
5. Read qa-report.md for any security-adjacent QA findings

### Phase 2: Automated Scans (10 minutes)
1. Run dependency vulnerability scan (`npm audit`)
2. Search codebase for hardcoded secrets
3. Search git history for leaked secrets
4. Check security headers on existing deployment (if any)
5. Scan for common vulnerability patterns (XSS, SQLi, CSRF)

### Phase 3: Manual Audit (20-30 minutes)
Walk through each of the 7 domains using the checklists in [checklists.md](checklists.md):
1. Authentication: test session handling, token security, password flows
2. Authorization: audit every RLS policy, test every API route
3. Input Validation: check every form and API endpoint for validation
4. Rate Limiting: verify limits exist on auth and resource-intensive endpoints
5. Environment Variables: confirm no secrets in code
6. HTTPS: verify SSL, headers, cookie flags
7. Dependencies: review audit results, check dependency health

### Phase 4: Fix Generation (15-20 minutes)
For each critical and high finding:
1. Write the exact code fix
2. Explain what the vulnerability was
3. Show how to test the fix
4. Stage as ready-to-apply patches

### Phase 5: Report Generation (5 minutes)
1. Classify all findings by severity
2. Group by domain
3. Prioritize: what blocks launch vs. post-launch improvement
4. Generate security-audit.md
5. Generate security-headers.md

---

## SEVERITY CLASSIFICATION

| Severity | Definition | Action Required |
|----------|-----------|----------------|
| CRITICAL | Data exposure, auth bypass, or remote code execution possible | Fix immediately. Blocks deployment. |
| HIGH | Significant vulnerability exploitable with moderate effort | Fix before launch |
| MEDIUM | Vulnerability with limited impact or requires specific conditions | Fix in first post-launch sprint |
| LOW | Best practice violation with minimal security impact | Backlog improvement |

### Severity Decision Rules
- User data can be accessed without auth -> CRITICAL
- RLS policy missing or misconfigured -> CRITICAL
- API key in source code or git history -> CRITICAL
- Auth can be bypassed -> CRITICAL
- No input validation on database-touching endpoint -> HIGH
- No rate limiting on auth endpoints -> HIGH
- Missing security headers -> MEDIUM
- Dev dependencies with known vulnerabilities -> LOW
- Missing HSTS header -> MEDIUM (HIGH if handling payments)

---

## OUTPUT FILES

### security-audit.md
```markdown
# Security Audit Report: [Product Name]
**Date:** [date]
**Auditor:** EO Security Hardener v1.0
**Overall Status:** [PASS / PASS WITH CONDITIONS / FAIL]

## Summary
- Critical: [count]
- High: [count]
- Medium: [count]
- Low: [count]

## Must Fix Before Launch
[Critical and high findings with exact code fixes]

## Fix in First Sprint
[Medium findings with fix guidance]

## Backlog Improvements
[Low findings]

## Domain Scores
| Domain | Status | Critical | High | Medium | Low |
|--------|--------|----------|------|--------|-----|
| Authentication | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| Authorization | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| Input Validation | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| Rate Limiting | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| Environment Vars | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| HTTPS/Transport | [PASS/FAIL] | [n] | [n] | [n] | [n] |
| Dependencies | [PASS/FAIL] | [n] | [n] | [n] | [n] |

## Detailed Findings
[Each finding with: description, location, severity, impact, fix, test]
```

### Code Fixes
For each critical and high finding:
- Exact code diff (what to change)
- Applied directly to codebase, or staged as separate commits
- Each fix includes a test to verify it works

### security-headers.md
```markdown
# Security Headers Configuration

## Next.js next.config.js Headers
[Exact configuration to copy-paste]

## Cloudflare Headers (if using Cloudflare)
[Dashboard or API configuration]

## Verification
[How to check headers are applied correctly]
```

---

## QUALITY GATES

- [ ] Zero CRITICAL findings remaining
- [ ] Zero HIGH findings remaining (or documented exception with mitigation)
- [ ] RLS enabled on every table, every policy tested
- [ ] No secrets in code or git history
- [ ] All API routes require authentication
- [ ] Input validation on every endpoint that writes data
- [ ] Rate limiting on auth endpoints
- [ ] Security headers configured
- [ ] npm audit shows zero critical/high in production deps
- [ ] security-audit.md generated with accurate counts
- [ ] security-headers.md ready to apply
- [ ] Student understands the top 3 security risks for their specific product

---

## CROSS-SKILL DEPENDENCIES

### Upstream
| Skill | What It Provides |
|-------|-----------------|
| eo-qa-testing | QA PASS status (prerequisite), security-adjacent findings |
| eo-db-architect | RLS policies and schema to audit |
| eo-api-connector | Integration code to review for API key handling |
| eo-microsaas-dev | The full codebase to audit |
| eo-tech-architect | Auth architecture, framework details |

### Downstream
| Skill | What It Needs |
|-------|--------------|
| eo-deploy-infra | Security PASS status (prerequisite), security headers config |

### Launch Sequence Position
```
eo-qa-testing [PASS] -> eo-security-hardener [PASS] -> eo-deploy-infra [DEPLOY]
```

This skill must PASS before eo-deploy-infra will proceed with deployment. If CRITICAL or HIGH findings remain unresolved, deployment is blocked until fixes are applied and the audit re-run.
