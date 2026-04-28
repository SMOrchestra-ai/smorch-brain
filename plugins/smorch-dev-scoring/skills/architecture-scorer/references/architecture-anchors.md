# Architecture Scorer — Anchor Rubrics

## 1. BRD Traceability (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | Architecture in someone's head. Tech chosen by familiarity, not fit. No written decisions. |
| 4-5 | Some documentation but decisions not linked to requirements. "We chose Next.js because popular." |
| 6-7 | Architecture Decision Records exist for major choices. Most link back to requirements. |
| 8-9 | Every significant decision has ADR with context, decision, consequences, and BRD reference. |
| 10 | Full traceability matrix. Every BRD requirement maps to an architectural component. Gap analysis documented. |

## 2. Data Architecture (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No schema design. Tables created ad hoc. No indexing strategy. No RLS. |
| 4-5 | Schema exists but over/under-normalized. No migration strategy. RLS as afterthought. |
| 6-7 | Reasonable schema. Indexes on obvious columns. RLS policies defined. Migration path exists. |
| 8-9 | Schema optimized for query patterns. Composite indexes. RLS tested. Seed data strategy. Backup plan. |
| 10 | Schema versioning, migration rollback plan, data retention policy, performance-tested query plans for top queries. |

## 3. API & Integration (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No API design. Frontend calls database directly. No error handling contracts. |
| 4-5 | APIs exist but inconsistent. Mixed REST conventions. No standard error format. |
| 6-7 | Consistent REST or RPC patterns. Standard error responses. Basic rate limiting. |
| 8-9 | Documented APIs. OpenAPI spec. Versioning strategy. Retry logic for external integrations. |
| 10 | API-first design. Contract tests. Circuit breaker patterns. Idempotency keys. API monitoring. |

## 4. Security Architecture (Weight: 15%) — HARD STOP if < 5

| Score | Anchor |
|-------|--------|
| 1-3 | Auth afterthought. API keys hardcoded. No authorization beyond "logged in or not." |
| 4-5 | Auth implemented but authorization flat. Secrets in env but no rotation. HTTPS exists. |
| 6-7 | Proper auth flow (OAuth2/JWT). Role-based access. Secrets in vault/env. Input validation on most endpoints. |
| 8-9 | Defense in depth. RLS + API auth + row-level filtering. OWASP Top 10 addressed. CSP policies. |
| 10 | Threat model documented. Penetration test plan. Audit logging. Data classification. Incident response plan. |

## 5. Scalability Design (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No consideration of scale. Single-server assumption. No caching. |
| 4-5 | Some awareness but no concrete plan. "We'll add caching later." |
| 6-7 | Primary bottleneck identified. Caching for hot paths. DB connection pooling. |
| 8-9 | Load testing plan. Horizontal scaling path documented. CDN for static assets. |
| 10 | Capacity planning with cost projections. Auto-scaling rules. Performance budgets. Graceful degradation. |

## 6. Failure Mode Design (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No error handling strategy. Unhandled exceptions crash the app. No health checks. |
| 4-5 | Basic try/catch. Some error logging. No structured error handling. |
| 6-7 | Consistent error handling. Health check endpoints. Basic monitoring. Recovery documented. |
| 8-9 | Circuit breakers for external services. Dead letter queues. Structured logging. Alerting rules. |
| 10 | Runbooks for top 5 failure scenarios. Automated recovery for common failures. RTO/RPO defined. |

## 7. Cost Architecture (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No cost awareness. Enterprise-tier services for MVP. |
| 4-5 | Some awareness but no optimization. Over-provisioned resources. |
| 6-7 | Right-sized for current needs. Free tiers used wisely. Cost estimate documented. |
| 8-9 | Cost-per-user calculated. Scaling cost projections. Free tiers maximized. |
| 10 | Unit economics modeled. Infrastructure cost as percentage of revenue tracked. |

## 8. Documentation Quality (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No documentation. Architecture lives in the builder's head. |
| 4-5 | README exists but outdated or incomplete. No architecture diagrams. |
| 6-7 | System diagram exists. Major decisions documented. Setup instructions work. |
| 8-9 | C4 diagrams (context + container). ADRs. Dependency map. Working setup guide. |
| 10 | Full documentation suite: overview, decision log, dependency map, runbook, onboarding guide. All current. |
