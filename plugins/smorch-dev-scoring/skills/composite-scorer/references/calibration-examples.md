# Calibration Examples

Use these examples to anchor your scoring. Each shows a real-world pattern at three score levels so the scorer produces consistent results across sessions.

## Product Scorer Calibration

### Score ~4: "Feature Wish List"
- BRD says "Build a CRM for SMEs in MENA"
- No specific persona. No pain quantified. No "when does this hurt" trigger.
- Feature list: 25 items labeled "Phase 1" with no prioritization
- No competitive analysis. No validation evidence.
- **Why 4**: Problem exists but is generic. Scope is unbounded. Building on assumption.

### Score ~7: "Validated but Broad"
- BRD defines persona: "Real estate agency owner, 5-20 agents, Dubai/Riyadh, losing leads from delayed WhatsApp response"
- Pain quantified: "40% lead loss from >2hr response time" (from 5 interviews)
- MVP: 7 features with MoSCoW, 4 must-haves
- Competitive alternatives listed (GHL, Zoho CRM) with differentiation on Arabic WhatsApp automation
- No kill criteria. No explicit "not building" list. Success metrics vague ("grow users").
- **Why 7**: Solid foundation. Validated problem. But scope still slightly fat, metrics undefined, no decision gates.

### Score ~9: "Revenue-Validated Sniper Scope"
- Problem: "Beauty clinic chains in UAE lose AED 15K/month in no-show appointments because confirmation WhatsApp goes unanswered after booking"
- Validation: 8 clinic interviews, 3 have paid deposits for beta access, AED 500/month pricing tested
- MVP: 3 features only (booking sync, WhatsApp confirmation sequence, no-show prediction)
- "Not building" list: scheduling UI, payment processing, multi-location (Phase 2 contingent on 20 paid users)
- Kill criteria: <10 paid users by Week 8 = pivot to broader vertical
- North star: no-show rate reduction %. Instrumented pre-launch.
- **Why 9**: Narrow, validated, pre-sold. Every feature traces to revenue. Kill criteria prevent zombie projects.

## Architecture Scorer Calibration

### Score ~4: "Default Scaffold"
- `create-next-app` with no customization. Default folder structure.
- No schema file or migrations. Data stored in JSON files or raw Supabase calls with no types.
- API routes have no validation, no error format, no auth middleware.
- `.env` file committed to git. No `.env.example`.
- **Why 4**: Something exists but zero architectural thinking applied. Security is a hard stop risk.

### Score ~7: "Structured but Incomplete"
- Clear folder structure: `/app`, `/lib`, `/components`, `/types`
- Supabase schema with foreign keys, but no RLS policies
- API routes use Zod validation. Error responses follow a format but it's inconsistent (some return `{error}`, some `{message}`)
- Auth via Supabase Auth. Protected routes exist. No role-based access.
- `docker-compose.yml` for local dev. No staging/prod config.
- ADR for stack choice exists but no other decisions documented.
- **Why 7**: Real architectural thinking. Validation exists. But RLS gap is a security risk, error format inconsistent, no documentation beyond stack choice.

### Score ~9: "Production-Ready Architecture"
- Domain-driven folder structure: `/features/bookings`, `/features/clients`, `/features/notifications`
- Supabase schema with RLS per table, typed with generated types from `supabase gen types`
- Shared API response format: `{ data, error, meta }`. Error codes mapped to HTTP status.
- Auth + RBAC: admin, manager, staff roles with Supabase custom claims
- ADRs for: stack, auth approach, real-time strategy, file storage, deployment
- System diagram in README. Health check endpoint. Graceful degradation for Supabase outages.
- **Why 9**: Every decision documented, security layered, error handling consistent. Missing only load testing and cost projection for 10.

## Engineering Scorer Calibration

### Score ~4: "Works on My Machine"
- 1200-line `page.tsx` file mixing API calls, state management, and rendering
- Zero test files. No test framework installed.
- `any` appears 40+ times. `@ts-ignore` used to silence errors.
- No ESLint, no Prettier. Inconsistent formatting.
- Git history: single branch, commit messages like "fix", "update", "stuff"
- **Why 4**: Code runs but is unmaintainable. No quality tooling. No tests.

### Score ~7: "Professional Baseline"
- Components under 200 lines. Shared hooks for data fetching.
- 12 test files covering auth flow and main CRUD operations. Coverage ~45%.
- `tsconfig.json` strict mode on. ~8 `any` remaining in third-party integration code.
- ESLint + Prettier configured. Pre-commit hook runs lint.
- Git: feature branches, descriptive commit messages. CI runs build + lint + test.
- **Why 7**: Maintainable code. Testing exists but coverage gaps. Tooling in place. CI covers basics but no type-check or security scan.

### Score ~9: "Engineering Excellence"
- Domain modules with clear boundaries. Barrel exports. No circular dependencies.
- 45 test files. Coverage >80% on business logic. Integration tests for API routes. E2E with Playwright for critical flows.
- Zero `any`. Discriminated unions for state machines. Zod schemas shared between client and server.
- Full CI: lint → type-check → unit test → integration test → build → bundle size check
- Git: conventional commits, PR template with checklist, branch protection on main.
- **Why 9**: Would confidently onboard a new developer. Missing only property-based testing and performance budgets for 10.

## QA Scorer Calibration

### Score ~4: "Trust Me It Works"
- No test files. QA is "I clicked through it."
- Forms accept any input. No validation messages.
- Empty states show blank white page. Loading states missing on half the pages.
- No error boundaries. API failure = white screen.
- **Why 4**: Happy path probably works (for the developer). No edge case consideration. No regression safety net.

### Score ~7: "Systematically Tested"
- 15 test files. Core flows tested: auth, CRUD, main business logic.
- Edge cases partially covered: empty states handled, null checks on API responses.
- Loading spinners on all async operations. Error messages user-friendly.
- Cross-browser tested manually on Chrome + Safari. Mobile responsive verified.
- Data integrity: foreign keys enforced, Zod validation on API input, unique constraints on email.
- **Why 7**: Functional quality is solid. Missing: security testing, systematic edge cases, automated visual regression, performance testing.

### Score ~9: "Confidence to Ship"
- 35 test files. Feature-to-test traceability. Coverage >75% on critical paths.
- Edge cases: Arabic text input tested, Gulf phone formats validated, max-length boundaries, concurrent edit handling.
- Security tests: auth boundary tests, role escalation prevented, SQL injection test, XSS prevention verified.
- Lighthouse CI: performance budget enforced. Core Web Vitals tracked.
- Error recovery: retry on transient failures, form state preserved on error, offline queue for actions.
- **Why 9**: Would deploy on Friday afternoon. Missing only chaos testing and full OWASP suite for 10.

## UX Frontend Scorer Calibration

### Score ~4: "Developer UI"
- No typography scale. Font sizes: 12px, 14px, 16px, 20px, 24px used randomly.
- No responsive design. Desktop-only. Horizontal scroll on mobile.
- No hover states. No transitions. Buttons look like divs.
- Zero ARIA labels. No alt text. Tab order broken.
- Hardcoded `margin-left: 16px` everywhere. No RTL consideration.
- **Why 4**: Functional but visually unfinished. Accessibility and responsive are absent.

### Score ~7: "Polished Baseline"
- Tailwind config with custom color palette, 3 font sizes for hierarchy.
- Mobile-first breakpoints. All pages responsive. Touch targets 44px+.
- Hover/focus states on all interactive elements. Transitions on state changes (200ms ease).
- ARIA labels on form inputs and buttons. Alt text on images. Semantic HTML (nav, main, section).
- `dir="rtl"` works. Most layout uses logical properties. Arabic font loaded. 2-3 places still use `margin-left`.
- **Why 7**: Looks professional. Accessible enough. RTL mostly works. Missing: design system consistency, micro-interactions, full RTL audit, performance optimization.

### Score ~9: "Design-Led Frontend"
- Design tokens: colors, spacing, typography defined in Tailwind config and referenced everywhere. Zero arbitrary values.
- Component library: Button, Input, Card, Modal, Table with size/variant props. Consistent API.
- Micro-interactions: form submit feedback, success toasts, skeleton screens, drag-and-drop with animation.
- Full a11y: keyboard navigation tested, focus management on modals/route changes, screen reader tested with VoiceOver.
- RTL: all logical properties, Arabic font with 1.7 line-height, bidirectional text handling, icon direction flipped where semantic.
- Code splitting per route. next/image everywhere. Bundle analyzed and optimized.
- **Why 9**: A designer would claim this as their work. Missing only visual regression testing and container queries for 10.
