# Effort Matrix — Typical Remediation Estimates

## How to Use This Matrix

Each dimension has common remediation patterns. Use this matrix to estimate effort when bridging gaps. Actual effort varies by codebase size and complexity; these are baselines for a typical MicroSaaS/B2B SaaS project (10-50 pages, Supabase + Next.js stack).

## Hat 1: Product Scorer

| Dimension | Score 3→5 | Score 5→7 | Score 7→9 |
|-----------|-----------|-----------|-----------|
| Problem Clarity | S: Write problem statement doc | M: Customer interviews + validation | L: Pivot/refine based on data |
| Target User Definition | S: Write ICP document | M: Create 2-3 personas with jobs-to-be-done | M: Validate personas with real users |
| Solution-Problem Fit | S: Map features to problems | M: Remove features that don't map | L: Redesign solution around validated problems |
| Scope Discipline | S: Cut scope to MVP | M: Create prioritized backlog with RICE | M: Enforce scope through process |
| Success Metrics | XS: Define 3 north star metrics | S: Implement analytics tracking | M: Build dashboard + review cadence |
| Competitive Awareness | S: Write competitive landscape doc | M: Feature comparison matrix | L: Positioning strategy with differentiation |
| Roadmap Clarity | S: Create Now/Next/Later roadmap | M: Quarter-level roadmap with dependencies | L: Roadmap with resource allocation |
| Stakeholder Alignment | S: Write one-pager with vision | M: Regular stakeholder updates | M: Decision log + RACI matrix |

## Hat 2: Architecture Scorer

| Dimension | Score 3→5 | Score 5→7 | Score 7→9 |
|-----------|-----------|-----------|-----------|
| BRD Traceability | S: Write basic ADR for stack choice | M: ADRs for all major decisions | L: Full traceability matrix |
| Data Architecture | M: Add missing constraints + indexes | M: Normalize schema + migration strategy | L: Performance-test query plans |
| API & Integration | S: Standardize error format | M: Document all endpoints + versioning | L: Contract tests + circuit breakers |
| Security Architecture | M: Implement auth + secrets in env | M: Add RLS + OWASP basics | L: Threat model + pen test plan |
| Scalability Design | S: Identify primary bottleneck | M: Add caching + connection pooling | L: Load testing + auto-scaling |
| Failure Mode Design | S: Add health check endpoint | M: Error handling + basic monitoring | L: Runbooks + automated recovery |
| Cost Architecture | XS: Document current monthly cost | S: Right-size resources | M: Cost-per-user projection |
| Documentation Quality | S: Write README + setup guide | M: System diagram + ADRs | L: Full documentation suite |

## Hat 3: Engineering Scorer

| Dimension | Score 3→5 | Score 5→7 | Score 7→9 |
|-----------|-----------|-----------|-----------|
| Code Organization | M: Create folder structure, extract god files | M: Domain-based organization | L: Enforce architectural boundaries |
| TypeScript Quality | S: Enable strict mode, fix `any` | M: Type API responses + core interfaces | L: Discriminated unions + runtime validation |
| Error Handling | S: Add try/catch on API calls | M: Error boundaries + structured logging | L: Error classification + observability |
| Testing Strategy | M: Add tests for core business logic | L: Coverage >60%, testing pyramid | L: TDD + property-based tests |
| Performance | S: Add lazy loading + image optimization | M: Bundle analysis + React.memo | L: Performance budgets in CI |
| Security Practices | S: Zod validation + .env setup | M: CORS + auth middleware + npm audit | L: CSP + rate limiting + security scanning |
| DRY / Duplication | S: Extract shared utilities | M: Custom hooks for repeated patterns | M: Correct abstractions (rule of three) |
| Git & CI/CD | S: Branch strategy + CI build | M: CI: build + lint + test. PR template | L: Full pipeline + auto-deploy |

## Hat 4: QA Scorer

| Dimension | Score 3→5 | Score 5→7 | Score 7→9 |
|-----------|-----------|-----------|-----------|
| Functional Completeness | M: Test all primary user flows | L: Coverage >50% on critical paths | L: Feature-to-test traceability |
| Edge Case Coverage | S: Add null/empty checks | M: Systematic boundary testing | L: Property-based/fuzz testing |
| Cross-Browser/Device | XS: Add viewport meta + touch targets | S: Test at 3 breakpoints | M: Automated visual regression |
| Real-World Performance | S: Add loading states everywhere | M: Pagination + API timeouts | L: Lighthouse CI + skeleton screens |
| Data Integrity | M: Add foreign keys + server validation | M: Transactions + unique constraints | L: Audit trail + backup testing |
| Error Recovery | S: App-level error boundary | M: Per-feature boundaries + retry | L: Resilience testing + dead letter queues |
| Security Testing | M: Auth flow tests + role tests | M: Injection + XSS prevention tests | L: OWASP test suite + scanning |
| Usability | S: Add empty states + form labels | M: Onboarding + contextual help | L: User testing + a11y audit |

## Hat 5: UX Frontend Scorer

| Dimension | Score 3→5 | Score 5→7 | Score 7→9 |
|-----------|-----------|-----------|-----------|
| Visual Hierarchy | S: Define typography scale + spacing | M: Apply consistently across all pages | M: Design token system |
| Responsive Layout | S: Mobile-first breakpoints | M: All pages responsive + thumb-friendly | L: Fluid typography + container queries |
| Component Architecture | M: Extract reusable components | M: Composition patterns + typing | L: Atomic design + Storybook |
| Interaction Design | S: Add hover/focus states | M: Transitions + loading feedback | L: Micro-interactions + motion system |
| Accessibility | S: Alt text + ARIA labels + semantic HTML | M: Keyboard navigation + focus management | L: axe-core in CI + screen reader testing |
| RTL / Bilingual | M: dir="rtl" + logical properties | M: Arabic font + bidirectional text | L: Full bilingual UI + visual regression |
| Design System Consistency | S: Define Tailwind theme config | M: Shared UI components + no arbitrary values | L: Living design system + documentation |
| Frontend Performance | S: Route-based code splitting | M: next/image + bundle analysis | L: Performance budget in CI |

## Effort Size Reference

| Size | Hours | Typical Examples |
|------|-------|-----------------|
| XS | < 1h | Config change, add a meta tag, update .env.example |
| S | 1-4h | Write a utility, add validation to 3 forms, create error boundary |
| M | 4-16h | Refactor a module, add tests for a feature, implement auth middleware |
| L | 2-5 days | Major refactor, new testing strategy, architectural change |
| XL | 1-2 weeks | System redesign, migrate database, rewrite auth layer |
