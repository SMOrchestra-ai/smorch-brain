# ADR-011: Multi-Deployment Architecture for Customer MicroSaaS Instances

**Date:** 2026-03-28
**Status:** Accepted
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (VibeMicroSaaS Super AI — Phase 0)

## 1. Context

The VibeMicroSaaS platform launches customer MicroSaaS apps at Stage 8 (SaaS Shell). Each customer's app needs auth, payments, database, and hosting. The architectural question: should all customers share one database/deployment (multi-tenant) or should each customer get their own isolated instance (multi-deployment)?

This decision was already made and documented in `SaaSFast/docs/adr/001-multi-deployment-vs-multi-tenant.md`. This ADR ratifies that decision at the platform level and documents the SSE (SignalSalesEngine) integration implications.

## 2. Options Considered

### Option A: Multi-Tenant (shared infrastructure)
- **Description:** All customers share one Supabase project with `tenant_id` column on every table. Single deployment serves all customers.
- **Pros:** Lower infrastructure cost (~$45/month total); simpler deployment; easier to push updates
- **Cons:** One missed RLS policy = cross-tenant data leak; schema changes affect all tenants; noisy neighbor problem; customers cannot customize schema; single point of failure; **MENA compliance risk** — some countries require data residency within borders
- **Estimated cost:** $45/month (1 Supabase Pro + 1 VPS)

### Option B: Multi-Deployment (isolated instances)
- **Description:** Each customer gets their own cloned SaaSFast codebase, own Supabase project, own Stripe account, own domain, own VPS deployment via Coolify. Already implemented in SaaSFast v3 via `template-clone.sh` + `template-inject.js`.
- **Pros:** Complete data isolation by design; MENA compliance (data stays in requested region); schema flexibility per customer; independent scaling; failure isolation; customer can migrate away with their infrastructure
- **Cons:** Per-customer infrastructure cost ($5-15/month passed to customer); update propagation requires centralized patch mechanism (v4 roadmap); more VPS management
- **Estimated cost:** $5-15/month per customer (Supabase Free + shared Coolify VPS), billed to customer

## 3. Decision

We chose **Option B: Multi-Deployment** because MENA data residency requirements and the risk profile of cross-tenant data leaks in an autonomous pipeline make multi-tenant unacceptable. The per-customer cost ($5-15/month) is passed to the customer as part of their hosting fee, not absorbed by SMOrchestra.

This ratifies the existing SaaSFast v3 ADR-001 decision.

## 4. Trade-offs Accepted

- **Update propagation complexity:** Pushing patches to N customer instances requires a centralized update mechanism (planned for v4). For MVP, manual `git pull + rebuild` on each instance.
- **Infrastructure management overhead:** Managing N VPS instances is more complex than one. Coolify and Contabo MCP (ADR in BRD v1.2) mitigate this.

## 5. Consequences

**Immediate actions required:**
- [ ] Verify `template-clone.sh` and `template-inject.js` work end-to-end on a test instance (Lana, Phase 1)
- [ ] Test Coolify deployment pipeline for cloned instances (Lana, Phase 3)
- [ ] Document per-customer provisioning SOP for OpenClaw Stage 8 automation (Phase 3)

**What changes as a result:**
- Stage 8 of the pipeline uses `template-clone.sh` to create isolated customer instances
- Each customer's `template_configs` record in Supabase tracks their brand, domain, colors, locale
- Contabo MCP provisions VPS per customer (or shared Coolify node for cost efficiency)
- SignalSalesEngine campaigns are scoped per customer via `tenant_id` in ScrapMfast tables

**SSE Integration:**
- Customer-specific campaign data lives in ScrapMfast Supabase (separate from platform Supabase)
- `campaign_triggers.tenant_id` ensures campaigns only fire for the correct customer
- SignalSalesEngine MCP exposes per-tenant campaign management

**Reversal cost:** Hard (> 1 week) — migrating from multi-deployment to multi-tenant would require database consolidation, RLS policy creation, and customer data migration
