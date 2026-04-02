# Engineering Scorer — Anchor Rubrics

## 1. Code Organization (Weight: 15%)
| Score | Anchor |
|-------|--------|
| 1-3 | Flat structure. Business logic mixed into UI components. God files (500+ lines). |
| 4-5 | Some structure but inconsistent. Components handle data fetching AND rendering AND logic. |
| 6-7 | Clear folder structure. Components separated from logic. API routes organized. Utilities extracted. |
| 8-9 | Feature/domain-based organization. Clean layer separation (UI, hooks, services, API). Barrel exports. |
| 10 | Architectural boundaries enforced. Could extract any feature into a separate package. Dependency rules clear. |

## 2. TypeScript Quality (Weight: 10%)
| Score | Anchor |
|-------|--------|
| 1-3 | TypeScript used as JavaScript. `any` everywhere. `@ts-ignore` suppressing errors. |
| 4-5 | Some types defined but inconsistent. API responses untyped. Mix of any and proper types. |
| 6-7 | Core interfaces defined. API responses typed. Minimal any usage. Props properly typed. |
| 8-9 | Comprehensive coverage. Discriminated unions for state. Zod/Valibot for runtime validation. |
| 10 | Type-driven development. DB types auto-generated. Zero any in production code. |

## 3. Error Handling (Weight: 15%)
| Score | Anchor |
|-------|--------|
| 1-3 | No error handling. Unhandled promise rejections. console.log debugging. White screen on errors. |
| 4-5 | Basic try/catch but errors swallowed. `catch(e) { console.log(e) }`. No user feedback. |
| 6-7 | Errors caught and logged. User sees error messages. React error boundaries exist. |
| 8-9 | Error classification system. Structured logging. Error boundaries per feature. Retry logic. |
| 10 | Observability-first. Every error classified, logged with context. Auto-recovered or surfaced with guidance. |

## 4. Testing Strategy (Weight: 15%)
| Score | Anchor |
|-------|--------|
| 1-3 | No tests. Manual testing only. |
| 4-5 | Some tests but brittle or test implementation details. Testing the wrong things. |
| 6-7 | Unit tests for core business logic. Integration tests for main API routes. Coverage >50%. |
| 8-9 | Testing pyramid respected. Unit >80% for business logic. Tests in CI. Test data factories. |
| 10 | TDD for business logic. Property-based tests. Visual regression. Performance tests. |

## 5. Performance (Weight: 10%)
| Score | Anchor |
|-------|--------|
| 1-3 | No performance awareness. Every component re-renders. No query optimization. 5MB bundle. |
| 4-5 | Some awareness but no action. Known issues not fixed. |
| 6-7 | React.memo/useMemo where appropriate. Select only needed columns. Images optimized. Lazy loading. |
| 8-9 | Performance budgets defined. Bundle analysis done. Lighthouse tracked. Server components used. |
| 10 | Core Web Vitals green. Bundle budget enforced in CI. Performance regression tests. |

## 6. Security Practices (Weight: 10%) — HARD STOP if < 5
| Score | Anchor |
|-------|--------|
| 1-3 | Raw SQL with string concatenation. No input validation. Secrets in code. CORS: *. |
| 4-5 | Parameterized queries. Some validation. Secrets in .env but might be in git. |
| 6-7 | Input validation with Zod/Yup. Proper CORS. .env in .gitignore. Auth middleware. |
| 8-9 | Defense in depth: client + server validation + RLS. CSP. Rate limiting. npm audit in CI. |
| 10 | Security linting enforced. OWASP at code level. Dependency scanning automated. Secret rotation. |

## 7. DRY / Duplication (Weight: 10%)
| Score | Anchor |
|-------|--------|
| 1-3 | Rampant duplication. Same API call pattern in 20 files. Same validation logic everywhere. |
| 4-5 | Some shared utilities but major duplication remains. Copy-paste development visible. |
| 6-7 | Common patterns extracted. Shared hooks for data fetching. Utility functions for repeated logic. |
| 8-9 | Pragmatic abstraction. Custom hooks for complex state logic. Configuration centralized. |
| 10 | Rule of three followed. Abstractions correct (not premature). Zero business logic duplication. |

## 8. Git & CI/CD (Weight: 15%)
| Score | Anchor |
|-------|--------|
| 1-3 | All commits on main. Messages: "fix", "update". No CI. Manual deployment. |
| 4-5 | Branches exist but inconsistent strategy. Basic CI (build only). |
| 6-7 | Branch-per-feature. Reasonable messages. CI: build + lint. Manual deploy with process. |
| 8-9 | Conventional commits. PR template. CI: build + lint + test. Preview deploys. Branch protection. |
| 10 | Trunk-based with feature flags. Full pipeline: lint, type-check, test, build, security scan, auto-deploy. |

## MENA-Specific Engineering Notes

When scoring MENA-targeted codebases, additionally check:

- **RTL CSS patterns**: Logical properties (`margin-inline-start`) vs hardcoded `margin-left` in stylesheets. Hardcoded physical properties = engineering debt for RTL.
- **Arabic string handling**: Template literals with Arabic text. String comparison with Arabic collation. Search/filter functions that handle Arabic diacritics.
- **Timezone-aware code**: Date operations using UTC or timezone-aware libraries (dayjs with tz plugin, date-fns-tz). Hardcoded timezone offsets = fragile.
- **i18n architecture**: Translation keys separated from components. Pluralization rules (Arabic has 6 plural forms). ICU MessageFormat or equivalent.
