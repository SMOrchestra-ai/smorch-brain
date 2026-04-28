# SSE V3 — Schema Mapping (BRD vs Actual Database)

**Last Updated:** 2026-04-08
**Supabase Project:** odjuqweiyzicqmcqozsu (ap-southeast-1)
**Total Tables:** 38 in `public` schema

---

## Authoritative Rule

**The database is authoritative.** All code, workflows, queries, and tests MUST use actual DB table names. BRD names are documentation-only. If you see `customers` in a BRD, use `tenants` in code.

---

## BRD → Actual DB Mapping

### Tables That Exist (mapped)

| BRD Name | Actual DB Table | tenant_id? | Notes |
|----------|----------------|------------|-------|
| customers | `tenants` | No (IS the tenant) | workspace_name, subscription_tier, monthly_limits (jsonb) |
| accounts | `company_entities` | Yes | company_name, website, industry, company_size, country, city |
| contacts | `individual_entities` | Yes | first_name, last_name, job_title, email, phone, is_decision_maker |
| account_intent_scores | `lead_scores_history` | Yes | fit_score, engagement_score, total_score, score_reason |
| activation_outreach | `campaign_messages` | Yes | channel, subject, body, status, sent_at, external_id |
| audit_log (BRD) | `audit_logs` | Yes | Tenant-scoped audit. Separate `audit_log` table exists for EO (student-scoped) |

### Tables That DO NOT Exist (BRD gaps)

| BRD Name | Status | Closest Equivalent | Action Required |
|----------|--------|-------------------|-----------------|
| signals | **CREATED** (2026-04-08) | `signals` — tenant_id, account_id, lead_id, signal_type, source, signal_value (jsonb), confidence_score, dedup_key (unique). RLS enabled. | Done |
| signal_weights | **MISSING** | None | CREATE TABLE (customer_id, signal_type, weight, last_optimized_at) |
| signal_sources | **CREATED** (2026-04-08) | `signal_sources` — tenant_id, source_type, source_tool, config (jsonb), metadata (jsonb), monitored_url, is_active, last_sync_at. RLS enabled. | Done |
| outreach_templates | **MISSING** | Inline in `campaigns.message_templates` (jsonb) | CREATE TABLE or keep in campaigns jsonb |
| feedback_events | **MISSING** | Partial in `campaign_engagements` (event_type: reply, click, etc.) | CREATE TABLE for deal-level feedback (deal_won, meeting_booked) |

### Recommendation

**Keep actual DB names. Update BRDs to reference actual names.** Migration risk is too high — 36 tables with FK chains, 74+ n8n workflows referencing table names, RLS policies just deployed. The cost of renaming exceeds the cost of documenting the mapping.

---

## Full Table Inventory (38 tables)

### SSE Core Tables (tenant-scoped, 27 tables)

| # | Table | Key Columns | FK Dependencies |
|---|-------|-------------|-----------------|
| 1 | `tenants` | workspace_name, subscription_tier, monthly_limits | — (root) |
| 2 | `users` | tenant_id, email, password_hash, first_name, last_name, role | tenants.id |
| 3 | `leads` | tenant_id, lead_type, platform, name, email, phone, company_name, fit_score, hiring_signals, growth_signals | tenants.id |
| 4 | `company_entities` | tenant_id, lead_id, company_name, website, industry, company_size, country, city | tenants.id, leads.id |
| 5 | `individual_entities` | tenant_id, lead_id, company_id, first_name, last_name, job_title, email, phone, is_decision_maker | tenants.id, leads.id, company_entities.id |
| 6 | `campaigns` | tenant_id, name, campaign_type, status, channels, language, region, created_by | tenants.id, users.id |
| 7 | `campaign_leads` | tenant_id, campaign_id, lead_id, status, lead_email, engagement_score | tenants.id, campaigns.id, leads.id |
| 8 | `campaign_messages` | tenant_id, campaign_lead_id, channel, subject, body, status, sent_at | tenants.id, campaign_leads.id |
| 9 | `campaign_engagements` | tenant_id, campaign_lead_id, event_type, event_data, source_tool | tenants.id, campaign_leads.id |
| 10 | `campaign_analytics` | tenant_id, campaign_id, leads_targeted/sent/opened/clicked/replied, roi | tenants.id, campaigns.id |
| 11 | `campaign_triggers` | tenant_id, campaign_id, name, conditions, enabled, priority | tenants.id, campaigns.id, users.id |
| 12 | `lead_scores_history` | tenant_id, lead_id, campaign_id, fit_score, engagement_score, total_score, score_reason | tenants.id, leads.id, campaigns.id |
| 13 | `enrichment_results` | tenant_id, lead_id, layer1_gemini, scoring, class_rating, final_priority_score | tenants.id, leads.id |
| 14 | `enrichment_logs` | tenant_id, lead_id, enrichment_result_id, layer, status, api_provider, tokens_used | tenants.id, leads.id, enrichment_results.id |
| 15 | `tenant_credits` | tenant_id, balance, last_updated | tenants.id |
| 16 | `credit_transactions` | tenant_id, action_id, amount, context_type, reason | tenants.id, users.id |
| 17 | `runs` | tenant_id, name, scraper_type, platform, status, collected_count | tenants.id, users.id |
| 18 | `scraper_jobs` | tenant_id, scraper_run_id, campaign_id, entity_type, platform, status | tenants.id, scraper_runs.id |
| 19 | `scraper_runs` | tenant_id, scraper_type_id, status, leads_found, credits_used | tenants.id, scraper_types.id, users.id |
| 20 | `tenant_leads` | tenant_id, lead_id, source_run_id | tenants.id, leads.id, runs.id |
| 21 | `ghl_integrations` | tenant_id, ghl_workspace_id, ghl_access_token, is_active | tenants.id |
| 22 | `heyreach_integrations` | tenant_id, heyreach_api_key, is_active, daily_limit | tenants.id |
| 23 | `instantly_integrations` | tenant_id, instantly_api_key, is_active, daily_limit | tenants.id |
| 24 | `integrations_audit` | tenant_id, action, integration_type, status | tenants.id, users.id |
| 25 | `influencer_entities` | tenant_id, lead_id, platform, handle, youtube_followers, engagement_rate | tenants.id, leads.id |
| 26 | `signals` | tenant_id, account_id, lead_id, signal_type, source, signal_value (jsonb), confidence_score, dedup_key (unique) | tenants.id, company_entities.id, leads.id |
| 27 | `signal_sources` | tenant_id, source_type, source_tool, config (jsonb), metadata (jsonb), monitored_url, is_active, last_sync_at | tenants.id |

### Auth & Access Tables (3 tables)

| # | Table | Key Columns | Scope |
|---|-------|-------------|-------|
| 28 | `user_roles` | user_id, role, granted_by | User-scoped (join to users.tenant_id) |
| 29 | `invitations` | tenant_id, email, role, token, status | Tenant-scoped |
| 30 | `audit_logs` | tenant_id, action, resource_type, user_id | Tenant-scoped |

### Reference Tables (3 tables, no tenant scope)

| # | Table | Key Columns | Access |
|---|-------|-------------|--------|
| 31 | `industries` | label, hierarchy, description | Public read (any authenticated user) |
| 32 | `scraper_types` | name, category, platforms, entity_table | Public read |
| 33 | `credit_actions` | name, cost_per_action, active | Public read |

### EO Platform Tables (5 tables, student-scoped)

| # | Table | Key Columns | Scope |
|---|-------|-------------|-------|
| 34 | `eo_assessments` | assessment_type, contact_email, total_score, band | Email-matched |
| 35 | `students` | full_name, eo_cohort, max_servers | auth.uid() |
| 36 | `provisions` | student_id, package, region, server_ip | student_id |
| 37 | `servers` | student_id, server_ip, health_status | student_id |
| 38 | `audit_log` | student_id, action, resource_type | student_id |

---

## RLS Status (Post-Fix)

All 38 tables have RLS enabled. 6 migrations applied on 2026-04-08 + 2 new tables created same day:
1. Enable RLS on all 31 previously-exposed tables
2. Tenant isolation policies on 25 SSE tables (via `get_user_tenant_id()` helper)
3. Auth-scoped policies on users, user_roles, tenants
4. Reference + EO policies (industries, scraper_types, credit_actions, eo_assessments)
5. Fix SECURITY DEFINER view (eo_founder_readiness)
6. Fix function search_paths (3 functions)

**Security advisor result:** 0 CRITICAL, 0 ERROR
