# EO Security Hardener - Security Checklists

Reference file for the detailed 7-domain security checklist with code examples.

---

## Domain 1: Authentication

**Goal:** Ensure only legitimate users can access the system.

### 1.1 Session Management
- [ ] Session tokens are HttpOnly cookies (not accessible from JavaScript)
- [ ] Session expiry is configured (recommended: 7 days, refresh on activity)
- [ ] Sessions invalidated on password change
- [ ] Sessions invalidated on logout (server-side, not just client-side)
- [ ] No session data stored in localStorage (use HttpOnly cookies)

### 1.2 Token Security
- [ ] Access tokens expire in <= 1 hour
- [ ] Refresh tokens rotate on use (old token invalidated)
- [ ] Refresh tokens stored securely (HttpOnly cookie or server-side)
- [ ] Token validation checks expiry, issuer, and audience
- [ ] No JWT secrets hardcoded (use environment variable)

### 1.3 Password Security
- [ ] Minimum password length: 8 characters
- [ ] Passwords hashed with bcrypt/scrypt/argon2 (never SHA/MD5)
- [ ] Password reset tokens expire in <= 1 hour
- [ ] Password reset tokens are single-use
- [ ] No password displayed in logs or error messages

### 1.4 Multi-Factor Auth Readiness
- [ ] Architecture supports MFA addition (not required for MVP)
- [ ] Phone OTP flow secure (rate limited, expiry, single-use)
- [ ] Social OAuth properly validates state parameter

### 1.5 Common Auth Vulnerabilities
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

## Domain 2: Authorization

**Goal:** Ensure users can only access what they should.

### 2.1 Supabase RLS Audit
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

### 2.2 API Route Protection
- [ ] Every API route checks authentication (middleware)
- [ ] Role-based routes check role before processing
- [ ] No route relies solely on client-side role checks
- [ ] File download routes verify ownership before serving
- [ ] Admin API routes have separate auth middleware

### 2.3 Data Access Patterns
- [ ] Users cannot access other users' data through ID manipulation
- [ ] Sequential IDs not used (use UUIDs to prevent enumeration)
- [ ] API responses only include data the user is authorized to see
- [ ] Aggregation queries don't leak data across tenants
- [ ] Export/download functions respect access controls

---

## Domain 3: Input Validation

**Goal:** Never trust data from the client.

### 3.1 Zod Schema Validation
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

### 3.2 SQL Injection Prevention
- [ ] No raw SQL with string concatenation
- [ ] All database queries use parameterized queries or ORM
- [ ] Supabase client methods used correctly (not `.rpc()` with raw SQL)
- [ ] Search/filter inputs sanitized before database queries

### 3.3 XSS Protection
- [ ] React/Next.js JSX auto-escapes by default (verify no `dangerouslySetInnerHTML`)
- [ ] User-generated content sanitized before rendering (use DOMPurify if HTML allowed)
- [ ] Content-Security-Policy header configured
- [ ] No inline scripts in HTML templates

### 3.4 File Upload Validation
- [ ] File type validated by magic bytes (not just extension)
- [ ] Maximum file size enforced server-side
- [ ] Uploaded files stored with random names (not user-provided names)
- [ ] No uploaded files served from the same domain (use CDN/storage bucket)
- [ ] Image processing (resize) strips EXIF metadata

---

## Domain 4: Rate Limiting

**Goal:** Prevent abuse and resource exhaustion.

### 4.1 API Rate Limits
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

### 4.2 Brute Force Protection
- [ ] Login: lockout after 5 failed attempts (15-minute cooldown)
- [ ] Password reset: 3 requests per email per hour
- [ ] OTP verification: 5 attempts per phone number per hour
- [ ] API key generation: limited to prevent key farming

### 4.3 Resource Abuse Prevention
- [ ] File upload: limit per user per hour
- [ ] AI generation: token/request budget per user per day
- [ ] Export/download: rate limited to prevent data scraping
- [ ] Webhook endpoints: validate source before processing

---

## Domain 5: Environment Variables

**Goal:** No secrets in code, ever.

### 5.1 Secret Management
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

### 5.2 Environment Separation
- [ ] Development and production use different credentials
- [ ] Development uses sandbox/test API keys (not production)
- [ ] Production environment variables set in deployment platform (Coolify)
- [ ] No production credentials on developer machines

### 5.3 Git History Audit
- [ ] Search git history for accidentally committed secrets
- [ ] If found: rotate the secret immediately, then clean history
- [ ] Pre-commit hook installed to prevent future leaks

```bash
# Check git history for secrets
git log --all -p | grep -i "sk_live\|api_key\|secret_key\|password="
```

---

## Domain 6: HTTPS and Transport Security

**Goal:** All data encrypted in transit.

### 6.1 HTTPS Enforcement
- [ ] HTTPS forced on all routes (HTTP redirects to HTTPS)
- [ ] HSTS header configured: `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- [ ] No mixed content (all resources loaded over HTTPS)
- [ ] SSL certificate valid and auto-renewing

### 6.2 Security Headers
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 0
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

### 6.3 Cookie Security
- [ ] All cookies have `Secure` flag (HTTPS only)
- [ ] Session cookies have `HttpOnly` flag
- [ ] `SameSite=Lax` or `SameSite=Strict` on all cookies
- [ ] No sensitive data in cookies (use session ID, not user data)

---

## Domain 7: Dependencies

**Goal:** Don't inherit someone else's vulnerability.

### 7.1 Vulnerability Scanning
```bash
# npm audit for known vulnerabilities
npm audit

# More thorough check
npx better-npm-audit audit
```

- [ ] Zero critical vulnerabilities in production dependencies
- [ ] Zero high vulnerabilities in production dependencies (or documented exceptions)
- [ ] Medium/low vulnerabilities reviewed and accepted or fixed

### 7.2 Dependency Hygiene
- [ ] `package-lock.json` committed (deterministic builds)
- [ ] No wildcard versions in package.json (use exact or caret)
- [ ] Unused dependencies removed
- [ ] Dependencies from reputable sources (check npm download counts, maintenance)

### 7.3 Update Strategy
- [ ] Weekly automated dependency check (Dependabot or Renovate)
- [ ] Critical security updates applied within 24 hours
- [ ] Major version updates tested before applying
- [ ] CI pipeline fails on critical vulnerabilities
