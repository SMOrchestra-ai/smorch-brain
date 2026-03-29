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

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Security Checklist: 7 Domains](#security-checklist)
4. [Execution Flow](#execution-flow)
5. [Severity Classification](#severity-classification)
6. [Output Files](#output-files)
7. [Quality Gates](#quality-gates)
8. [MENA Security Considerations](#mena-security-considerations)
9. [Cross-Skill Dependencies](#cross-skill-dependencies)

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

## SECURITY CHECKLIST: 7 DOMAINS

### Domain 1: Authentication

**Goal:** Ensure only legitimate users can access the system.

#### 1.1 Session Management
- [ ] Session tokens are HttpOnly cookies (not accessible from JavaScript)
- [ ] Session expiry is configured (recommended: 7 days, refresh on activity)
- [ ] Sessions invalidated on password change
- [ ] Sessions invalidated on logout (server-side, not just client-side)
- [ ] No session data stored in localStorage (use HttpOnly cookies)

#### 1.2 Token Security
- [ ] Access tokens expire in <= 1 hour
- [ ] Refresh tokens rotate on use (old token invalidated)
- [ ] Refresh tokens stored securely (HttpOnly cookie or server-side)
- [ ] Token validation checks expiry, issuer, and audience
- [ ] No JWT secrets hardcoded (use environment variable)

#### 1.3 Password Security
- [ ] Minimum password length: 8 characters
- [ ] Passwords hashed with bcrypt/scrypt/argon2 (never SHA/MD5)
- [ ] Password reset tokens expire in <= 1 hour
- [ ] Password reset tokens are single-use
- [ ] No password displayed in logs or error messages

#### 1.4 Multi-Factor Auth Readiness
- [ ] Architecture supports MFA addition (not required for MVP)
- [ ] Phone OTP flow secure (rate limited, expiry, single-use)
- [ ] Social OAuth properly validates state parameter

#### 1.5 Common Auth Vulnerabilities
- [ ] Login doesn't reveal whether email exists ("Invalid credentials" not "User not found")
- [ ] Account lockout after 5 failed attempts (temporary, 15 minutes)
- [ ] Registration prevents email enumeration
- [ ] Password reset doesn't reveal whether email exists

```typescript
// GOOD: Generic error message
throw new AuthError('Invalid email or password');

// BAD: Reveals account existence
throw new AuthError('No account found with this email');
```

---

### Domain 2: Authorization

**Goal:** Ensure users can only access what they should.

#### 2.1 Supabase RLS Audit
- [ ] RLS enabled on EVERY table (no exceptions)
- [ ] Every table has at least SELECT and INSERT policies
- [ ] No policy uses `true` as the USING clause (that's public access)
- [ ] Organization-scoped data uses org membership check (not just org_id parameter)
- [ ] Admin operations verified through role check, not client-side flag

```sql
-- BAD: Trusts client-provided org_id
CREATE POLICY "view org data" ON projects
  FOR SELECT USING (organization_id = current_setting('app.org_id')::uuid);

-- GOOD: Verifies through membership table
CREATE POLICY "view org data" ON projects
  FOR SELECT USING (
    organization_id IN (
      SELECT organization_id FROM user_organizations
      WHERE user_id = auth.uid()
    )
  );
```

#### 2.2 API Route Protection
- [ ] Every API route checks authentication (middleware)
- [ ] Role-based routes check role before processing
- [ ] No route relies solely on client-side role checks
- [ ] File download routes verify ownership before serving
- [ ] Admin API routes have separate auth middleware

#### 2.3 Data Access Patterns
- [ ] Users cannot access other users' data through ID manipulation
- [ ] Sequential IDs not used (use UUIDs to prevent enumeration)
- [ ] API responses only include data the user is authorized to see
- [ ] Aggregation queries don't leak data across tenants
- [ ] Export/download functions respect access controls

---

### Domain 3: Input Validation

**Goal:** Never trust data from the client.

#### 3.1 Zod Schema Validation
- [ ] Every API route validates request body with Zod
- [ ] Every URL parameter validated (not just type-cast)
- [ ] Query parameters validated and sanitized
- [ ] File upload type and size validated server-side
- [ ] Validation errors return helpful messages (not stack traces)

```typescript
// Every API route starts with validation
export async function POST(request: Request) {
  const body = await request.json();

  // Validate BEFORE any processing
  const result = CreateProjectSchema.safeParse(body);
  if (!result.success) {
    return Response.json(
      { error: 'Invalid input', details: result.error.flatten() },
      { status: 400 }
    );
  }

  // Now safe to use result.data
  const project = await createProject(result.data);
}
```

#### 3.2 SQL Injection Prevention
- [ ] No raw SQL with string concatenation
- [ ] All database queries use parameterized queries or ORM
- [ ] Supabase client methods used correctly (not `.rpc()` with raw SQL)
- [ ] Search/filter inputs sanitized before database queries

#### 3.3 XSS Protection
- [ ] React/Next.js JSX auto-escapes by default (verify no `dangerouslySetInnerHTML`)
- [ ] User-generated content sanitized before rendering (use DOMPurify if HTML allowed)
- [ ] Content-Security-Policy header configured
- [ ] No inline scripts in HTML templates

#### 3.4 File Upload Validation
- [ ] File type validated by magic bytes (not just extension)
- [ ] Maximum file size enforced server-side
- [ ] Uploaded files stored with random names (not user-provided names)
- [ ] No uploaded files served from the same domain (use CDN/storage bucket)
- [ ] Image processing (resize) strips EXIF metadata

---

### Domain 4: Rate Limiting

**Goal:** Prevent abuse and resource exhaustion.

#### 4.1 API Rate Limits
- [ ] Global rate limit on all API routes (e.g., 100 requests/minute per IP)
- [ ] Stricter limits on auth endpoints (e.g., 10 login attempts/minute)
- [ ] Stricter limits on resource-intensive endpoints (AI, export, search)
- [ ] Rate limit headers returned (X-RateLimit-Limit, X-RateLimit-Remaining)
- [ ] 429 response includes Retry-After header

```typescript
// Rate limiting middleware example
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(100, '1 m'), // 100 per minute
});

// Stricter for auth
const authRatelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '1 m'), // 10 per minute
});
```

#### 4.2 Brute Force Protection
- [ ] Login: lockout after 5 failed attempts (15-minute cooldown)
- [ ] Password reset: 3 requests per email per hour
- [ ] OTP verification: 5 attempts per phone number per hour
- [ ] API key generation: limited to prevent key farming

#### 4.3 Resource Abuse Prevention
- [ ] File upload: limit per user per hour
- [ ] AI generation: token/request budget per user per day
- [ ] Export/download: rate limited to prevent data scraping
- [ ] Webhook endpoints: validate source before processing

---

### Domain 5: Environment Variables

**Goal:** No secrets in code, ever.

#### 5.1 Secret Management
- [ ] All API keys in environment variables
- [ ] No secrets in source code (search for patterns: `sk_`, `api_key`, `secret`)
- [ ] `.env` file in `.gitignore`
- [ ] `.env.example` maintained with placeholder values
- [ ] No secrets in git history (if found, rotate ALL compromised keys)

```bash
# Search for potential secrets in codebase
grep -r "sk_" src/ --include="*.ts" --include="*.tsx"
grep -r "api_key" src/ --include="*.ts" --include="*.tsx"
grep -r "secret" src/ --include="*.ts" --include="*.tsx"
grep -r "password" src/ --include="*.ts" --include="*.tsx"
```

#### 5.2 Environment Separation
- [ ] Development and production use different credentials
- [ ] Development uses sandbox/test API keys (not production)
- [ ] Production environment variables set in deployment platform (Coolify)
- [ ] No production credentials on developer machines

#### 5.3 Git History Audit
- [ ] Search git history for accidentally committed secrets
- [ ] If found: rotate the secret immediately, then clean history
- [ ] Pre-commit hook installed to prevent future leaks

```bash
# Check git history for secrets
git log --all -p | grep -i "sk_live\|api_key\|secret_key\|password="
```

---

### Domain 6: HTTPS and Transport Security

**Goal:** All data encrypted in transit.

#### 6.1 HTTPS Enforcement
- [ ] HTTPS forced on all routes (HTTP redirects to HTTPS)
- [ ] HSTS header configured: `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- [ ] No mixed content (all resources loaded over HTTPS)
- [ ] SSL certificate valid and auto-renewing

#### 6.2 Security Headers
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 0
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

#### 6.3 Cookie Security
- [ ] All cookies have `Secure` flag (HTTPS only)
- [ ] Session cookies have `HttpOnly` flag
- [ ] `SameSite=Lax` or `SameSite=Strict` on all cookies
- [ ] No sensitive data in cookies (use session ID, not user data)

---

### Domain 7: Dependencies

**Goal:** Don't inherit someone else's vulnerability.

#### 7.1 Vulnerability Scanning
```bash
# npm audit for known vulnerabilities
npm audit

# More thorough check
npx better-npm-audit audit
```

- [ ] Zero critical vulnerabilities in production dependencies
- [ ] Zero high vulnerabilities in production dependencies (or documented exceptions)
- [ ] Medium/low vulnerabilities reviewed and accepted or fixed

#### 7.2 Dependency Hygiene
- [ ] `package-lock.json` committed (deterministic builds)
- [ ] No wildcard versions in package.json (use exact or caret)
- [ ] Unused dependencies removed
- [ ] Dependencies from reputable sources (check npm download counts, maintenance)

#### 7.3 Update Strategy
- [ ] Weekly automated dependency check (Dependabot or Renovate)
- [ ] Critical security updates applied within 24 hours
- [ ] Major version updates tested before applying
- [ ] CI pipeline fails on critical vulnerabilities

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
Walk through each of the 7 domains:
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

## MENA SECURITY CONSIDERATIONS

### Data Privacy Regulations
- **UAE**: Federal Decree-Law No. 45 of 2021 (Personal Data Protection Law)
  - Consent required for data collection
  - Right to access, rectify, delete personal data
  - Data breach notification within "a reasonable time"
- **Saudi Arabia**: Personal Data Protection Law (PDPL, effective Sept 2023)
  - Stricter than UAE: explicit consent for data processing
  - Data localization requirements for certain categories
  - Heavy penalties for non-compliance
- **Egypt**: Law No. 151 of 2020 (Personal Data Protection Law)
  - Consent-based processing
  - Cross-border data transfer restrictions

**Minimum compliance for MVP:**
- Privacy policy page (required)
- Cookie consent banner
- Data deletion capability (user can delete their account and data)
- Encrypted data in transit (HTTPS) and at rest (Supabase encryption)

### Phone Number Security
- Phone numbers are more sensitive in MENA (tied to national ID in some countries)
- Store in hashed form if only used for verification
- Never expose full phone numbers in API responses (mask: +971***1234)
- Phone OTP: use short expiry (5 minutes) and single-use tokens

### Arabic Content Security
- XSS payloads can use Arabic characters and RTL override characters
- Sanitize Arabic text input same as English (DOMPurify handles both)
- Watch for Unicode direction override characters (U+202E) in user input
- Bidirectional text can be used to disguise malicious URLs

### WhatsApp Security
- WhatsApp Business API tokens: treat as critical secrets
- Webhook payloads from WhatsApp: verify signature before processing
- Template messages: only use pre-approved templates (prevents injection)
- Message content: validate before displaying in product UI

### Payment Security for MENA Gateways
- PCI DSS compliance: use hosted payment pages (never handle raw card data)
- Tap Payments, HyperPay: use their hosted checkout (redirect model)
- Webhook verification: each gateway has its own signature method
- Refund authorization: require admin role, log all refund operations
- MADA transactions: follow mada-specific security requirements

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
