# EO QA Testing - Testing Domain Details

Reference file for detailed test patterns, code examples, and UX review checklists across all 3 testing domains.

---

## Domain 1: Code Quality

5 automated checks that catch problems before they reach users.

### 1.1 Linting and Formatting Validation
```bash
# Check ESLint compliance
npx eslint . --ext .ts,.tsx --format json --output-file lint-report.json

# Check Prettier formatting
npx prettier --check "src/**/*.{ts,tsx,css}"
```

What to flag:
- Any `eslint-disable` comments (each needs justification)
- Inconsistent formatting that slipped past pre-commit hooks
- Missing ESLint rules for React hooks, accessibility, imports

### 1.2 TypeScript Type Safety Audit

Scan for:
- `any` type usage (each instance is a finding)
- Missing return types on exported functions
- Non-null assertions (`!`) without safety checks
- Type assertions (`as`) that bypass type checking
- Untyped API responses (should use Zod or typed clients)

```typescript
// BAD: type safety hole
const data = response.json() as any;

// GOOD: validated and typed
const data = ResponseSchema.parse(await response.json());
```

### 1.3 Dead Code Detection

Identify:
- Unused imports
- Unreachable code after returns/throws
- Unused variables and functions
- Commented-out code blocks (should be deleted, not commented)
- Unused dependencies in package.json

### 1.4 Dependency Vulnerability Scanning
```bash
# npm audit for known vulnerabilities
npm audit --json > audit-report.json

# Check for outdated packages with known issues
npx npm-check-updates --target minor
```

Classify findings:
- CRITICAL: Known exploit in production dependency
- HIGH: Vulnerability in production dependency, no known exploit
- MEDIUM: Vulnerability in dev dependency
- LOW: Outdated package, no known vulnerability

### 1.5 Code Complexity Analysis

Flag functions that need refactoring:
- Cyclomatic complexity > 10
- Functions longer than 50 lines
- Files longer than 300 lines
- Nesting depth > 3 levels
- More than 4 parameters on a function

Provide refactoring suggestions, not just flags.

---

## Domain 2: Functional Testing

5 test categories that validate the product actually works.

### 2.1 Unit Test Generation for Business Logic

For each business logic function:
- Happy path test
- Boundary value tests (min, max, zero, empty)
- Invalid input tests (wrong type, missing required fields)
- Edge cases specific to the domain

```typescript
// Example: test a pricing calculation function
describe('calculateSubscriptionPrice', () => {
  it('returns base price for standard tier', () => {
    expect(calculateSubscriptionPrice('standard', 'monthly')).toBe(49);
  });

  it('applies 20% discount for annual billing', () => {
    expect(calculateSubscriptionPrice('standard', 'annual')).toBe(470.4);
  });

  it('throws for invalid tier', () => {
    expect(() => calculateSubscriptionPrice('invalid', 'monthly')).toThrow();
  });

  it('handles currency conversion for AED', () => {
    expect(calculateSubscriptionPrice('standard', 'monthly', 'AED')).toBe(180);
  });
});
```

### 2.2 API Endpoint Testing

For each API route:
- **Happy path**: Valid request returns expected response
- **Auth required**: Unauthenticated request returns 401
- **Wrong role**: Unauthorized user returns 403
- **Invalid input**: Malformed request returns 400 with helpful message
- **Not found**: Invalid ID returns 404
- **Rate limit**: Excessive requests return 429

```typescript
describe('POST /api/projects', () => {
  it('creates project for authenticated user', async () => { /* ... */ });
  it('rejects unauthenticated request', async () => { /* ... */ });
  it('validates required fields', async () => { /* ... */ });
  it('prevents duplicate project names per org', async () => { /* ... */ });
});
```

### 2.3 Auth Flow Testing

Test every auth path:
- Email/password signup -> email verification -> login
- Social OAuth (Google, Apple) -> account creation -> login
- Phone OTP -> verification -> login
- Password reset flow (request -> email -> reset -> login with new)
- Session expiry and refresh token rotation
- Role-based access: test each role can only access what it should

### 2.4 Database Operation Testing

For each table's CRUD operations:
- Create with valid data succeeds
- Create with missing required fields fails with clear error
- Read respects RLS policies (user A cannot see user B's data)
- Update only modifies allowed fields
- Delete cascades correctly (or prevents if referenced)
- Concurrent access doesn't cause data corruption

```typescript
describe('RLS: projects table', () => {
  it('user can only read own org projects', async () => {
    const { data } = await supabaseAsUserA.from('projects').select('*');
    expect(data?.every(p => p.organization_id === userA.org_id)).toBe(true);
  });

  it('user cannot read other org projects', async () => {
    const { data } = await supabaseAsUserA
      .from('projects')
      .select('*')
      .eq('organization_id', userB.org_id);
    expect(data).toHaveLength(0);
  });
});
```

### 2.5 Integration Test Scaffolding

For each external service integration:
- Mock the external service response
- Test success path with expected response
- Test timeout handling
- Test rate limit handling
- Test invalid/unexpected response format
- Test network failure recovery

---

## Domain 3: UX Review

6 validation areas that catch user-facing problems.

### 3.1 Responsive Design Validation

Test at 3 breakpoints:
- **Mobile**: 375px width (iPhone SE baseline)
- **Tablet**: 768px width (iPad baseline)
- **Desktop**: 1280px width

For each breakpoint, verify:
- No horizontal scrolling
- Touch targets >= 44px on mobile
- Navigation is accessible (hamburger menu on mobile)
- Tables either scroll horizontally or reflow to cards
- Images and media scale correctly
- Font sizes are readable (minimum 14px on mobile)

### 3.2 Loading State Audit

**Every async operation must have a loading indicator.** Check:
- Page initial load: skeleton or spinner
- Form submission: button shows loading state, prevents double-submit
- Data fetching: skeleton placeholders matching content shape
- File upload: progress indicator
- Navigation: page transition indicator

Finding template:
```
LOCATION: [page/component]
OPERATION: [what triggers the async action]
CURRENT STATE: [nothing / spinner / skeleton / custom]
REQUIRED: [what the loading state should look like]
SEVERITY: [high if user might think app is broken]
```

### 3.3 Error State Audit

**Every failure must show a user-friendly message.** Check:
- Network errors: "Connection lost. Retrying..." not "TypeError: fetch failed"
- Form validation: inline errors next to the field, not alert boxes
- 404 pages: helpful message with navigation options
- Permission errors: clear explanation of why access is denied
- Server errors: "Something went wrong. Try again." with retry button
- No raw error codes or stack traces visible to users

### 3.4 Empty State Audit

**Every list, table, and dashboard needs an empty state.** Check:
- First-time user sees helpful empty state, not a blank page
- Empty state includes a call-to-action (create first item, import data)
- Empty search results show helpful message
- Empty filter results offer to clear filters
- Dashboard widgets with no data show placeholder, not broken charts

### 3.5 Accessibility Basics

Minimum checks (not full WCAG audit, that's for later):
- Color contrast ratio >= 4.5:1 for text (use browser dev tools or axe)
- All interactive elements focusable via keyboard (Tab navigation)
- Focus order follows visual order
- All images have alt text (decorative images: alt="")
- Form inputs have associated labels
- Error messages announced to screen readers (aria-live)
- No information conveyed by color alone

### 3.6 Arabic RTL Layout Validation

**For any product targeting MENA users, RTL is not optional.** Check:
- `dir="rtl"` set correctly on Arabic content sections
- Tailwind logical properties used (`ms-4` not `ml-4`, `ps-2` not `pl-2`)
- Icons that imply direction are flipped (arrows, back buttons)
- Numbers remain LTR within RTL context
- Text alignment follows content language, not fixed direction
- Form fields accept and display Arabic text correctly
- Mixed Arabic/English content renders without breaking

```
RTL FINDING TEMPLATE:
LOCATION: [page/component]
ELEMENT: [what's broken]
EXPECTED: [correct RTL behavior]
ACTUAL: [what happens now]
FIX: [specific code change]
```

---

## MENA UX Considerations

### Arabic Text in Testing
- Seed test data must include Arabic strings (names, descriptions, addresses)
- Test with actual Arabic content, not Latin placeholder text
- Verify text truncation doesn't break mid-word in Arabic
- Check that sorting works correctly for Arabic strings

### Device and Network Context
- MENA users frequently on mobile (test mobile-first)
- Network conditions vary: test on simulated 3G/4G
- WhatsApp share buttons should work on mobile
- Phone number input should default to country code (+971, +966, etc.)

### Payment Flow Testing
- If using regional payment gateways (Tap, HyperPay, MADA):
  - Test sandbox mode for each gateway
  - Verify currency display (AED, SAR with Arabic formatting)
  - Test webhook handling for delayed confirmations
  - Verify refund flow

### Cultural UX Patterns
- Calendar inputs: test with both Gregorian and Hijri dates if applicable
- Name fields: test with Arabic names (no first/last split assumption)
- Address fields: test with Arabic addresses and MENA postal code formats
- Weekend consideration: Friday-Saturday in GCC, not Saturday-Sunday
