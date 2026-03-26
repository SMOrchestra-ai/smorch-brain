# QA Scorer — Anchor Rubrics

## 1. Functional Completeness (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | Major user flows broken or untested. Happy path fails. Core features missing test coverage entirely. |
| 4-5 | Happy path works but alternative paths untested. Some features have partial test coverage. Manual QA only. |
| 6-7 | All primary flows have at least one test. Coverage >50% on critical paths. Both success and failure cases tested. |
| 8-9 | Every user story has corresponding tests. Coverage >80% on business logic. Edge flows (cancel, back, timeout) tested. |
| 10 | Feature-to-test traceability matrix. Every acceptance criterion has a test. Regression suite catches breaking changes. |

**Evidence to look for**: Map routes/pages to test files. Check if form submissions, auth flows, CRUD operations, and payment flows all have tests. Count untested features.

## 2. Edge Case Coverage (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No boundary testing. Empty states crash. Zero/null inputs cause errors. No Unicode handling. |
| 4-5 | Some null checks but inconsistent. Empty arrays handled in a few places. No systematic boundary testing. |
| 6-7 | Null/undefined handling consistent. Empty states display properly. Boundary values tested for critical inputs. |
| 8-9 | Systematic edge case strategy: empty, null, max length, special characters, concurrent operations, Arabic text. |
| 10 | Property-based/fuzz testing for critical paths. Every input field tested with boundary values, Unicode, injection strings, max+1 length. |

**Evidence to look for**: Search for tests with "empty", "null", "undefined", "boundary", "max", "min". Check if Arabic text (RTL + mixed direction) is tested as input. Look for edge case test files or describe blocks.

## 3. Cross-Browser/Device (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | Developed and tested on one browser only. No responsive design. No viewport meta tag. |
| 4-5 | Viewport meta exists. Some responsive breakpoints but untested. Works on Chrome desktop only verified. |
| 6-7 | Responsive breakpoints defined and tested visually. Touch targets adequate (44px+). Works on major browsers. |
| 8-9 | Automated visual regression across viewports. BrowserStack or similar multi-browser testing. Touch interactions tested. |
| 10 | Cross-browser CI matrix. Visual regression automated. Device lab testing. Progressive enhancement for older browsers. |

**Evidence to look for**: Check for `viewport` meta tag, Tailwind breakpoint usage, media queries, touch target sizes, Playwright/Cypress viewport configs, BrowserStack config files.

## 4. Real-World Performance (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No loading indicators. API calls with no timeout. No pagination. Full dataset loaded at once. |
| 4-5 | Some loading spinners but inconsistent. No skeleton screens. Pagination exists but no virtual scrolling for large lists. |
| 6-7 | Loading states on all async operations. Pagination implemented. Images lazy-loaded. API timeouts configured. |
| 8-9 | Skeleton screens. Optimistic updates where appropriate. Virtual scrolling for large datasets. Performance budgets defined. |
| 10 | Lighthouse CI in pipeline. Core Web Vitals tracked. Performance regression tests. Offline-first patterns where relevant. |

**Evidence to look for**: Grep for `isLoading`, `skeleton`, `Skeleton`, `spinner`, `Suspense`, `lazy()`. Check for pagination patterns, infinite scroll, image optimization (next/image, srcset), API timeout configs.

## 5. Data Integrity (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No DB constraints beyond primary key. No validation on writes. Cascade deletes without safeguards. No transactions. |
| 4-5 | Basic constraints (NOT NULL on some columns). Client-side validation only. No server-side validation on API. |
| 6-7 | Foreign keys enforced. Server-side validation (Zod/Yup). Unique constraints on logical keys. Soft deletes for important data. |
| 8-9 | Transactions for multi-step operations. Optimistic locking for concurrent edits. Audit trail on critical tables. Data migration tested. |
| 10 | Referential integrity verified in tests. Data corruption recovery plan. Backup/restore tested. Point-in-time recovery configured. |

**Evidence to look for**: Check schema/migrations for constraints (UNIQUE, NOT NULL, FOREIGN KEY, CHECK). Search for transaction usage. Look for Zod/Yup/Valibot validation schemas. Check for soft delete patterns (`deleted_at`). Verify RLS policies exist per table.

## 6. Error Recovery (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | Errors crash the app. White screen of death. No error boundaries. Form data lost on error. |
| 4-5 | Basic error boundary at app level. Generic "something went wrong" message. Form state lost on submission error. |
| 6-7 | Error boundaries per feature section. User-friendly error messages. Form state preserved on validation failure. Retry button on network errors. |
| 8-9 | Granular error recovery: auto-retry for transient failures, draft preservation for forms, offline queue for actions. Errors classified by type. |
| 10 | Resilience testing (chaos engineering lite). Every error path has a recovery strategy. User can always get back to a working state. Dead letter queue for failed operations. |

**Evidence to look for**: Count `ErrorBoundary` components. Check for retry logic (`react-query` retries, custom retry). Search for form state preservation patterns. Look for toast/notification on errors vs silent failures.

## 7. Security Testing (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No auth tests. No role boundary tests. No input sanitization tests. XSS possible through user input. |
| 4-5 | Auth flow has basic tests (login/logout). No authorization boundary tests. SQL injection not tested. |
| 6-7 | Auth + authorization tested. Role escalation tests exist. Input validation prevents basic injection. CSRF protection verified. |
| 8-9 | Systematic security tests: auth, authz, injection, XSS, CSRF, file upload validation. RLS policies tested with different roles. |
| 10 | Automated security scanning in CI. OWASP Top 10 test suite. Penetration test plan. Dependency vulnerability scanning. |

**Evidence to look for**: Search test files for "auth", "role", "permission", "unauthorized", "forbidden", "injection", "xss", "csrf". Check if RLS policies have corresponding tests. Look for security-focused test files.

## 8. Usability (Target User) (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No onboarding. No empty states. No tooltips. User must guess how features work. No feedback on actions. |
| 4-5 | Some empty states but generic ("No data"). Basic form labels. No contextual help. Success/error feedback inconsistent. |
| 6-7 | Meaningful empty states with CTAs. Form validation messages are helpful. Loading feedback consistent. Basic keyboard navigation. |
| 8-9 | Onboarding flow for new users. Contextual tooltips on complex features. Undo support for destructive actions. Confirmation dialogs. ARIA labels on interactive elements. |
| 10 | User testing feedback incorporated. Accessibility audit passed (WCAG 2.1 AA). Multi-language support tested. First-time user experience designed and validated. |

**Evidence to look for**: Search for empty state components, tooltip usage, onboarding/tour libraries, confirmation dialogs, `aria-label`, `role=` attributes. For MENA: check RTL layout, Arabic placeholder text, Gulf phone format validation patterns.
