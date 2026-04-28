---
name: architecture-scorer
description: >-
  Scores solution architecture across 8 dimensions: BRD Traceability, Data Architecture, API Design, Security Architecture, Scalability, Failure Modes, Cost Architecture, Documentation. Triggers on "score architecture", "evaluate our tech stack", "architecture review", "is our architecture solid", "rate the system design", "architecture scorecard".
---

# Solution Architecture Scorer

Score architecture decisions, data design, and production readiness. This is Hat 2 of the 5-Hat Quality Scorecard System.

The core question: **Will this architecture survive production, scale, and the inevitable change requests?**

## Scoring Process

### Step 1: Discover Architecture

Search the codebase for architecture signals. Read in priority order:

1. **Schema**: `**/schema*`, `**/migrations/**`, `**/prisma/**`, `**/supabase/**/*.sql`, `**/drizzle/**`
2. **API layer**: `**/api/**`, `**/routes/**`, `**/trpc/**`, `**/graphql/**`
3. **Config**: `**/docker*`, `**/nginx*`, `**.env.example`, `**/vercel.json`, `**/next.config*`
4. **Auth**: `**/auth/**`, `**/middleware*`, `**/lib/auth*`
5. **Docs**: `**/architecture*`, `**/ADR*`, `**/decisions/**`, `**/docs/**`
6. **Infra**: `**/terraform/**`, `**/cloudformation/**`, `**/Dockerfile*`

Also check `package.json` for the dependency graph (framework, ORM, auth library, etc.)

### Step 2: Score Each Dimension

Read `references/architecture-anchors.md` for detailed rubrics. For calibration reference, see `../composite-scorer/references/calibration-examples.md` (Architecture section). For each dimension:

1. State what evidence you found (or didn't)
2. Cite specific files, configs, and patterns observed
3. Assign score 1-10 using anchor rubrics
4. Identify the specific gap to reach 8+

| Dimension | Weight | What to Investigate |
|-----------|--------|-------------------|
| BRD Traceability | 15% | Can architecture decisions be traced to requirements? ADRs exist? |
| Data Architecture | 15% | Schema design, normalization, indexes, RLS, migrations, relationships |
| API & Integration | 15% | Endpoint consistency, error format, versioning, external service patterns |
| Security Architecture | 15% | Auth flow, authorization model, secrets management, OWASP coverage |
| Scalability Design | 10% | Bottleneck awareness, caching strategy, connection pooling |
| Failure Mode Design | 10% | Error strategy, health checks, retry logic, graceful degradation |
| Cost Architecture | 10% | Hosting cost awareness, free tier usage, cost-per-user modeling |
| Documentation Quality | 10% | System diagrams, ADRs, setup guides, dependency documentation |

### Step 3: Stack-Specific Heuristics

For **Supabase** projects, check specifically:
- RLS policies on every table (`grep -r "CREATE POLICY" or check supabase/migrations`)
- Real-time subscriptions design (which tables, what triggers)
- Edge functions vs server-side patterns
- Database function usage (any business logic in postgres functions?)

For **Next.js** projects, check:
- Server vs client component split (look for 'use client' directives)
- API route organization (route handlers vs server actions)
- Middleware usage (auth, redirects, headers)
- ISR/SSG/SSR strategy per route

For **n8n** integrations, check:
- Webhook endpoints and security (auth headers, IP filtering)
- Error workflow patterns (do workflows have error handlers?)
- Credential management approach

### Step 4: Output Format

```
## Architecture Scorecard — [Project Name]
Phase: [phase] | Date: [date] | Stack: [detected stack]

### Category Score: X.X / 10 ([grade])

| Dimension | Score | Key Finding |
|-----------|-------|-------------|
| BRD Traceability | X/10 | [evidence] |
| ... | ... | ... |

### Architecture Strengths
- [specific strength with file reference]

### Critical Gaps
- [Dimension]: Currently X, target 8+. Action: [specific fix]

### Hard Stops
- Security Architecture < 5: [PASS/FAIL]
```

### Security Hard Stop

Security Architecture scoring below 5 is a **hard stop** regardless of composite score. Check:
- API keys not in source code (grep for patterns: `sk-`, `api_key`, `secret`, `password`)
- Auth middleware on protected routes
- RLS policies active (not disabled)
- CORS configuration restrictive (not `*`)
- Input validation present on API endpoints

### Skip Conditions

Do NOT run this scorer when:
- **No codebase exists (pure ideation stage)**: No architecture to evaluate. Return "N/A: pre-code phase. Run product-scorer only."
- **Content-only project** (markdown docs, course materials): Architecture scoring doesn't apply.
- **Single static HTML file**: No architectural decisions to evaluate.
