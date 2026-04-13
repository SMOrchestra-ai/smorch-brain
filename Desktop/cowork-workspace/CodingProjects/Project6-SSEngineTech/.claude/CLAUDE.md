# Signal Sales Engine V3 (SSE V3) - Project CLAUDE.md

**Last Updated:** 2026-04-07
**Maintained by:** al-Jazari (Architecture), Mamoun Alamouri (Product/Strategy)
**Status:** Phase 3 Optimization (Soak Test Active)

This is the single source of truth for all Signal Sales Engine V3 work. Auto-loads when this folder is opened as a project in Cowork.

---

## PROJECT IDENTITY

**What:** B2B outbound signal intelligence automation platform. Detects buying intent signals from 15+ sources, scores them via Claude API, and orchestrates multi-channel outreach (email, LinkedIn, WhatsApp) before competitors react.

**Owner:** Mamoun Alamouri, SMOrchestra.ai
**Business Line:** SalesMfast Signal Engine
**Repository:** github.com/SMOrchestra-ai/Signal-Sales-Engine (branch: `dev` only)
**Market:** MENA primary (UAE, Saudi Arabia, Qatar, Kuwait); English-speaking secondary
**Revenue Model:** SaaS $4K-$50K/month + professional services $3K+ retainers
**Year 1 Targets:** 8-12 customers, $100K+ MRR, <10% churn, 40%+ gross margin

**Core Thesis:** Signal-based trust engineering replaces relationship-heavy selling. Automation detects intent at the moment it surfaces and delivers proof of competence via the right channel at the right time.

---

## ARCHITECTURE: FOUR-LAYER NERVOUS SYSTEM

### Layer 1: Signal Sensory (Data Ingestion)

**15+ Signal Sources:**
- Web behavior tracking (Clay, pixel-based)
- Email engagement (Instantly webhooks: opens, clicks, replies)
- LinkedIn activity (HeyReach: profile views, connection requests, engagement)
- Job change data (news feeds, LinkedIn crawler)
- Funding/investment events (news aggregation)
- Company growth indicators (revenue trends, hiring, expansion)
- Technographics (tool adoption, version upgrades)
- News and press mentions (automated monitoring)
- Social signals (Twitter, industry forums)
- Direct API feeds (GHL data, Apify scrapers)
- Event attendance and webinar registrations
- Customer data imports (via Supabase bulk APIs)
- MENA-specific signals (local news sources, MENA tech communities)

**Storage & Refresh:**
- Supabase PostgreSQL `signals` table (100+ signals per account on average)
- Refresh cycle: every 4 hours via n8n cron (workflow: Signal-Ingestion-Master)
- Retention policy: 13-month rolling window (oldest signals auto-purged)
- Deduplication: `dedup_key` = signal_type + account_id + timestamp (day-level)

### Layer 2: Signal Interpretation (AI Scoring)

**Scoring Engine:**
- Primary: Claude 3.5 Sonnet API with structured reasoning (system prompt emphasizes signal-based trust)
- Fallback: Gemini API (cost optimization) + rule-based heuristics for failures
- Output: intent_score (0-100), reasoning (text), next_action_signal (string), recommended_channel (email|linkedin|whatsapp|phone)

**Score Tiers (Drive Routing):**
- Hot (80-100): immediate multi-channel sequence
- Warm (60-79): steady nurture sequence
- Cool (40-59): weekly nurture only
- Cold (<40): quarterly re-score

**Scoring Frequency:**
- Trigger: new signal arrives (via webhook)
- Batch: daily minimum re-score at 02:00 UTC (workflow: Scoring-Daily-Batch)
- Workflow: Scoring-Master controls orchestration

**Signal Weights (Per-Customer Customization):**
- Base weights set during onboarding (signal importance for customer's ICP)
- Stored in `signal_weights` table (customer_id, signal_type, weight)
- Optimized monthly (1st Sunday, 02:00 UTC via Feedback-Loop-Monthly)
- Accuracy target: >85% intent prediction vs. closed deals

### Layer 3: Signal Activation (Multi-Channel Orchestration)

**Routing Rules by Score Tier:**

| Score | Day 0 | Day 2 | Day 4 | Day 7 | Day 14 | Notes |
|-------|-------|-------|-------|-------|--------|-------|
| Hot (80+) | Warm Email | LinkedIn | WhatsApp | Phone Call | - | Immediate action |
| Warm (60-79) | Email | - | - | LinkedIn | Nurture | Steady cadence |
| Cool (40-59) | - | - | - | - | Weekly Nurture | Low-touch only |
| Cold (<40) | - | - | - | - | Quarterly Re-score | Inactive |

**Channels & Integration:**
- Email: Instantly.ai (API + webhooks for delivery tracking)
- LinkedIn: HeyReach (API + webhooks for engagement)
- WhatsApp: GoHighLevel (GHL API for WhatsApp/SMS)
- Phone: Manual trigger (workflow sends Slack alert to rep)
- Nurture: GoHighLevel email sequencing

**Anti-Spam Rules:**
- No duplicate touches within 24 hours (check `activation_outreach` table)
- Channel affinity: respect prospect's preferred contact method (stored in `contact_preferences`)
- Whitespace detection: skip prospects on DNLs or customer's existing deals
- Timezone-aware scheduling: send during 9am-5pm local prospect timezone
- Fatigue prevention: max 3 touches per 14-day window per contact
- Supress list: cross-check against customer's internal opt-outs and GDPR denials

**Outreach Execution Workflows:**
- Outreach-Queue-Processor (15-min cron): fetches pending outreach, executes sends, updates status
- Channel-Sender-Instantly (triggered): sends cold email via Instantly.ai API
- Channel-Sender-HeyReach (triggered): sends LinkedIn connection + message via HeyReach API
- Channel-Sender-GHL (triggered): sends WhatsApp/SMS via GHL API

### Layer 4: Signal Learning (Feedback & Optimization)

**Feedback Loop (Monthly, 1st Sunday 02:00 UTC):**
1. Pull closed deals from GHL (status = "won" in last 30 days)
2. Retroactively score those accounts using their signal history
3. Calculate accuracy: (correct_predictions / total_predictions) × 100
4. Identify which signals predicted wins, which were noise
5. Reweight signal_weights table with new importance scores
6. Deploy updated weights to production (automatic, no downtime)

**Customer Dashboard Metrics:**
- Closed deals (count, value, cycle time vs. historical)
- Signal attribution (which signals predicted this deal)
- Cycle compression (avg days from cold → won)
- Scoring accuracy (% of hot leads that closed)
- Channel performance (opens, clicks, replies, meetings booked by channel)
- Credit consumption (leads processed, signals ingested, outreach sent)

**Optimization Targets (12-Month Horizon):**
- Intent prediction accuracy: 85%+
- Zero duplicate touches across channels (0% rate)
- Cycle compression: 30-40% faster than baseline
- Cost per lead: <$3 in credits
- Channel ROI: email >15% reply rate, LinkedIn >8% engagement, WhatsApp >25% reply rate

---

## TECH STACK (INTEGRATION MAP)

| Layer | Technology | Purpose | Deployment | Auth |
|-------|-----------|---------|------------|------|
| **Orchestration** | n8n (self-hosted) | 14+ workflows: ingestion, scoring, routing, sending, feedback | 100.89.148.62:5170 (smo-brain) | Internal key |
| **Frontend (LIVE)** | Vite + React 18 + TypeScript | Dashboard, campaigns, leads, signals, analytics, reports, settings, credits, scrapers, triggers | smo-dev :6002 → sse.smorchestra.ai | Supabase Auth |
| **Backend API** | Express/Node | REST API | smo-dev :6001 → sse.smorchestra.ai/api | Supabase Service key |
| **Database** | Supabase (PostgreSQL) | Core data store, RLS enforced | Cloud (supabase.co) | Service key + RLS |
| **Auth** | Supabase Auth | User identity, JWT, MFA support | Cloud (supabase.co) | Supabase Auth provider |
| **Realtime** | Supabase Realtime | Dashboard live updates (signal scores, outreach status) | Cloud (supabase.co) | Supabase token |
| **AI Scoring** | Claude API (3.5 Sonnet) | Intent reasoning, structured output | API endpoint | API key (cost capped) |
| **AI Fallback** | Gemini API | Backup scoring if Claude fails | API endpoint | API key |
| **Enrichment** | Clay API | Data enrichment (company size, industry, tech) | API endpoint | API key + credits |
| **Enrichment** | Clearbit API | Domain/company data enrichment | API endpoint | API key |
| **Web Scraping** | Apify actors | LinkedIn profiles, Google Maps, YouTube channels | Cloud (apify.com) | API token + credits |
| **Cold Email** | Instantly.ai | Email sending + delivery tracking + reply parsing | API endpoint | API key + credits |
| **Email Webhooks** | Instantly.ai | Delivery, open, click, reply events → n8n | Webhook URL | Signed payload (HMAC) |
| **LinkedIn Outreach** | HeyReach API | Connection requests, message sending, activity tracking | API endpoint | API key + credits |
| **LinkedIn Webhooks** | HeyReach | Engagement events → n8n | Webhook URL | Signed payload |
| **CRM & WhatsApp** | GoHighLevel (GHL) API | CRM sync, WhatsApp sending, SMS, warm email | API endpoint | API key |
| **Error Tracking** | Sentry | Exception logging, performance monitoring | Cloud (sentry.io) | DSN |
| **Analytics** | PostHog | Product analytics, feature flags, session replays | Cloud (posthog.com) | API key |
| **Compute Host** | Contabo VPS | Ubuntu 22.04, 4 CPU, 8GB RAM, 100GB SSD | 100.89.148.62 | SSH key, managed by al-Jazari |

---

## DATABASE SCHEMA (11 CORE TABLES)

### Schema Name Translation (BRD → Actual DB)

**IMPORTANT:** BRD documents use idealized names. The actual database uses different names. Always use actual DB names in code, SQL, and n8n workflows. Full mapping: `DevTeamSOP/database/SCHEMA-MAPPING.md`

| BRD Name | Actual DB Table | Notes |
|----------|----------------|-------|
| customers | `tenants` | Root entity |
| accounts | `company_entities` | B2B target companies |
| contacts | `individual_entities` | People at companies |
| account_intent_scores | `lead_scores_history` | Scoring output |
| activation_outreach | `campaign_messages` | Outreach records |
| signals | `signals` | Created 2026-04-08. tenant_id, account_id, lead_id, signal_type, source, signal_value (jsonb), dedup_key |
| signal_sources | `signal_sources` | Created 2026-04-08. tenant_id, source_type, source_tool, config (jsonb), monitored_url |
| signal_weights | `signal_weights` | Created 2026-04-09. tenant_id, signal_type, weight, last_optimized_at. 52 rows seeded (4 tenants × 13 types). RLS enforced. |
| circuit_breaker_state | `circuit_breaker_state` | Created 2026-04-09. api_name, failure_count, state (closed/open/half_open), cooldown. 7 API entries seeded. |
| outreach_templates | **DOES NOT EXIST** | Inline in campaigns.message_templates jsonb |
| feedback_events | **DOES NOT EXIST** | Partial in campaign_engagements |

**BRD Compatibility Views (Created 2026-04-09, Migration 009):**
- `accounts` view → `company_entities` (denormalized)
- `account_intent_scores` view → `lead_scores_history` + `company_entities` (computed intent_tier, denormalized account data)
- `contacts` view → `individual_entities` (computed full_name)
- `activation_outreach` view → `campaign_messages` + joins (denormalized contact/account data)
- `customers` view → `tenants` (filtered deleted_at IS NULL)
All views use `security_invoker = true` for RLS enforcement. Dashboard queries use `select("*")` on views — no `!inner` joins needed.

All tables in `public` schema. RLS enforced on all 40 tables + 5 views (deployed 2026-04-08, views 2026-04-09).

### 1. `customers`
- id (UUID, primary key)
- name (text)
- email (text)
- plan_tier (enum: starter | growth | enterprise)
- credit_balance (integer)
- api_key (text, hashed)
- created_at, updated_at
- RLS: authenticated users can only access their own customer record

### 2. `accounts`
- id (UUID, primary key)
- customer_id (FK: customers.id)
- company_name (text)
- domain (text, unique per customer)
- icp_match_score (integer 0-100, computed)
- revenue_estimate (text)
- employee_count (integer)
- industry (text)
- last_signal_at (timestamp)
- created_at, updated_at
- RLS: restrict to customer_id

### 3. `contacts`
- id (UUID, primary key)
- account_id (FK: accounts.id)
- name (text)
- email (text)
- linkedin_url (text)
- job_title (text)
- phone (text, E.164 format)
- decision_maker (boolean)
- preferred_channel (enum: email | linkedin | whatsapp | phone)
- do_not_contact (boolean, GDPR)
- created_at, updated_at
- RLS: restrict to account's customer

### 4. `signals`
- id (UUID, primary key)
- account_id (FK: accounts.id)
- signal_type (text: job_change, funding, tech_adoption, web_visit, email_open, etc.)
- source (text: clay, instantly, heyreach, news_api, etc.)
- signal_value (jsonb, flexible data structure)
- confidence_score (integer 0-100)
- dedup_key (text, unique: signal_type + account_id + date)
- created_at, updated_at
- RLS: restrict to account's customer
- Index on: account_id, signal_type, created_at

### 5. `signal_sources`
- id (UUID, primary key)
- customer_id (FK: customers.id)
- source_type (text: clay, instantly, heyreach, apify, etc.)
- config (jsonb, API credentials, scraper settings)
- is_active (boolean)
- last_sync_at (timestamp)
- created_at, updated_at
- RLS: restrict to customer_id

### 6. `signal_weights`
- id (UUID, primary key)
- customer_id (FK: customers.id)
- signal_type (text: job_change, funding, etc.)
- weight (numeric 0-1, default 0.5)
- last_optimized_at (timestamp)
- accuracy_contribution (numeric, feedback from Feedback-Loop-Monthly)
- created_at, updated_at
- RLS: restrict to customer_id
- Purpose: customize signal importance per customer's ICP

### 7. `account_intent_scores`
- id (UUID, primary key)
- account_id (FK: accounts.id)
- intent_score (integer 0-100)
- intent_tier (enum: hot | warm | cool | cold)
- reasoning (text, Claude's explanation)
- next_action_signal (text, recommended next step)
- recommended_channel (enum: email | linkedin | whatsapp | phone)
- scored_at (timestamp)
- input_signals_snapshot (jsonb, which signals drove this score)
- created_at, updated_at
- RLS: restrict to account's customer
- Index on: account_id, scored_at DESC (for latest score)

### 8. `activation_outreach`
- id (UUID, primary key)
- contact_id (FK: contacts.id)
- account_id (FK: accounts.id)
- channel (enum: email | linkedin | whatsapp | phone)
- message_id (text, Instantly/HeyReach external ID)
- status (enum: pending | sent | delivered | opened | clicked | replied | bounced | failed)
- recipient (text, email or phone)
- scheduled_at (timestamp)
- sent_at (timestamp)
- opened_at (timestamp, if applicable)
- clicked_at (timestamp, if applicable)
- replied_at (timestamp, if applicable)
- reply_text (text, captured reply)
- credits_spent (integer)
- created_at, updated_at
- RLS: restrict to account's customer
- Index on: account_id, channel, status, sent_at DESC

### 9. `outreach_templates`
- id (UUID, primary key)
- customer_id (FK: customers.id)
- template_name (text)
- channel (enum: email | linkedin | whatsapp)
- subject_line (text, for email)
- body (text, may contain {{merge_tags}})
- cta_text (text, call-to-action)
- is_active (boolean)
- usage_count (integer, auto-increment on send)
- created_at, updated_at
- RLS: restrict to customer_id

### 10. `feedback_events`
- id (UUID, primary key)
- outreach_id (FK: activation_outreach.id)
- account_id (FK: accounts.id)
- event_type (enum: reply | click | meeting_booked | call_completed | deal_won)
- event_data (jsonb)
- created_at
- RLS: restrict to account's customer
- Purpose: track which outreach led to conversion

### 11. `audit_log`
- id (UUID, primary key)
- customer_id (FK: customers.id)
- entity_type (text: account, contact, signal, outreach, etc.)
- entity_id (UUID)
- action (text: create, update, delete)
- changes (jsonb, before/after values)
- actor (text, user ID or system)
- created_at
- RLS: restrict to customer_id
- Purpose: compliance, audit trail for GDPR/DPA

---

## DEPLOYMENT TOPOLOGY

### Production Instances

**n8n Orchestration (smo-brain):**
- Host: 100.89.148.62 (Contabo VPS, Ubuntu 22.04, 4 CPU, 8GB RAM, 100GB SSD)
- UI: testflow.smorchestra.ai (port 5170, behind Cloudflare)
- Credentials: stored in n8n's encrypted credential store (AES-256)
- 14+ workflows active, running cron jobs and webhook triggers
- Contact: al-Jazari (architecture, deployment, SSH access)

**SSE V3 Frontend + Backend (smo-dev):**
- Host: 100.117.35.19 (Contabo VPS)
- Frontend (LIVE): :6002 (Vite + React 18), source: `/root/signal_project_v3/scrapmfast_frontend`, systemd: `scrapmfast-frontend.service`
- Backend API: :6001, systemd: `scrapmfast-backend.service`
- Nginx: sse.smorchestra.ai → :6002 (frontend) + :6001 (/api)
- SaaSFast (separate product): :3000 (`/opt/SaaSFast`) — NOT SSE V3
- Supabase Edge Functions: on demand
- Contact: al-Jazari (deployment), Mamoun (product decisions)
- **NOTE:** `/workspaces/smo/Signal-Sales-Engine/dashboard/` is an incomplete Next.js rebuild — NOT live, NOT production

**Supabase (Cloud):**
- Project: SMOrchestra (smorchestra.co domain)
- PostgreSQL version: 15
- Backup: automatic daily, 7-day retention
- RLS: enforced on all customer tables
- Auth: Supabase Auth provider (JWT-based)

### Monitoring & Alerting

- Sentry: error tracking, performance monitoring (dashboards for frontend, n8n, API)
- PostHog: product analytics, feature flags, session replays
- n8n: built-in execution logs (per workflow), 30-day retention
- Manual checks: Slack alerts for critical workflow failures

---

## N8N WORKFLOWS (14+ PRODUCTION)

### Signal Ingestion Layer

1. **Signal-Ingestion-Master** (4-hour cron)
   - Orchestrates all signal source syncs
   - Calls Signal-Ingest-Clay, Signal-Ingest-Instantly, Signal-Ingest-HeyReach, Signal-Ingest-News, Signal-Ingest-Apify
   - Manages deduplication and storage in `signals` table
   - Error handling: retry 3x before marking source as degraded

2. **Signal-Ingest-Clay** (triggered by master or on demand)
   - Polls Clay API for enrichment data (technographics, company growth)
   - Maps to `signals` table with signal_type = 'technographics' or 'company_growth'
   - Dedup key: signal_type + account_id + date (avoids re-storing stale data)

3. **Signal-Ingest-Instantly** (triggered by master or webhook)
   - Webhook endpoint: receives email events (open, click, reply, bounce)
   - Parses Instantly signature (HMAC), validates request
   - Inserts into `signals` table with signal_type = 'email_open' / 'email_click' / 'email_reply' / 'email_bounce'

4. **Signal-Ingest-HeyReach** (triggered by master or webhook)
   - Webhook endpoint: receives LinkedIn events (profile view, connection sent, message replied)
   - Validates HeyReach signature
   - Inserts into `signals` table with signal_type = 'linkedin_profile_view' / 'linkedin_connection' / 'linkedin_message_reply'

5. **Signal-Ingest-News** (4-hour cron)
   - Polls news APIs (NewsData, MENA-specific sources) for company mentions
   - Filters for keywords: customer's ICP companies, funding, hiring
   - Inserts into `signals` table with signal_type = 'news_mention'

6. **Signal-Ingest-Apify** (on demand or 24-hour cron)
   - Triggers Apify actors for LinkedIn profile scraping, Google Maps scraping, YouTube channel data
   - Stores results in Supabase, signals table

### Scoring Layer

7. **Scoring-Master** (webhook trigger on new signal, daily batch 02:00 UTC)
   - Receives new signal event
   - Fetches account's full signal history (last 30 days)
   - Calls Claude API with structured prompt (signal-based trust reasoning)
   - Updates `account_intent_scores` table with new score, reasoning, recommended channel
   - Publishes Supabase Realtime event for dashboard update

8. **Scoring-Daily-Batch** (02:00 UTC cron, minimum daily re-score)
   - Fetches all accounts without a score in last 24 hours
   - Batch scores them (calls Claude API per 10-account batch)
   - Updates `account_intent_scores` table

### Routing Layer

9. **Routing-Master** (webhook trigger from scoring workflow)
   - Receives account_id and new intent_score
   - Looks up outreach strategy from campaign settings
   - Routes to Outreach-Queue-Processor with action = email | linkedin | whatsapp | phone

### Activation Layer

10. **Outreach-Queue-Processor** (15-min cron)
    - Fetches pending outreach from `activation_outreach` table (status = pending, scheduled_at <= now)
    - Calls appropriate channel sender (Instantly, HeyReach, GHL)
    - Updates status to sent, sent_at timestamp
    - Deducts credits from customer's balance
    - Handles failures: retry up to 3x, mark as failed after 3 retries, add to error queue

11. **Channel-Sender-Instantly** (triggered by Outreach-Queue-Processor)
    - Receives outreach record
    - Fetches template, renders merge tags ({{first_name}}, {{company_name}}, etc.)
    - Calls Instantly.ai API to send email
    - Stores external message_id in `activation_outreach`
    - Logs in audit_log

12. **Channel-Sender-HeyReach** (triggered by Outreach-Queue-Processor)
    - Receives outreach record
    - Fetches contact's LinkedIn URL from `contacts` table
    - Calls HeyReach API to send connection + message
    - Stores external message_id
    - Logs in audit_log

13. **Channel-Sender-GHL** (triggered by Outreach-Queue-Processor)
    - Receives outreach record
    - Calls GHL API to send WhatsApp or SMS
    - Stores external message_id
    - Logs in audit_log

### Feedback & Learning Layer

14. **Feedback-Loop-Monthly** (1st Sunday of month, 02:00 UTC)
    - Pulls closed deals from GHL (status = won in last 30 days)
    - For each deal, fetches the account's signal score at time of close
    - Compares predicted score tier vs. actual outcome
    - Calculates accuracy: (correct_predictions / total_predictions) × 100
    - Reweights `signal_weights` table based on prediction accuracy
    - Generates report in Slack
    - Logs all changes to audit_log

### Supporting Workflows (Helper Functions)

15. **Nurture-Email-Sequencer** (daily cron)
    - Fetches warm accounts (intent_score 60-79) without recent outreach
    - Schedules low-touch nurture emails (weekly cadence)

16. **Competitor-Monitoring** (weekly cron)
    - Scrapes competitor websites, news sources for MENA market activity
    - Alerts Mamoun in Slack if competitor activity detected

---

## CRITICAL CONSTRAINTS & RULES

### 1. Code & PR Standards

- **Branch Rule:** All PRs target `dev` branch. Never push to `main` directly. Enforce via GitHub branch protection.
- **Quality Gate:** SOP-02 - every PR must score >= 8/10 on composite quality scorecard before merge. Use smorch-dev-scoring plugin (5 hats: engineering, architecture, UX/frontend, product, QA).
- **Code Review:** al-Jazari (architecture) or Mamoun (product) approval required.
- **Testing:** Unit tests (Jest) + E2E tests (Playwright) for all new features. No PR merges without >80% coverage for changed files.

### 2. MENA Market Compliance

- **Language:** Arabic NLP required for all signal interpretation from Arabic sources. Use Claude for Arabic parsing.
- **RTL Support:** Frontend must handle RTL layouts (contact names, addresses, etc.).
- **Phone Formats:** Accept +971 (UAE), +966 (Saudi), +974 (Qatar), +965 (Kuwait), normalize to E.164.
- **Currency:** Support AED, SAR, QAR, KWD. Default to customer's home currency.
- **Holidays:** Respect Friday/Saturday weekends. Schedule outreach for Sun-Thu 9am-5pm local time.

### 3. Credit System

- **Per-Operation Costs:**
  - Signal ingestion: 0.1 credit per signal
  - Enrichment query (Clay, Clearbit): 0.5 credit per query
  - Email send (Instantly): 1 credit per send
  - LinkedIn action (HeyReach): 2 credits per send
  - WhatsApp send (GHL): 1.5 credits per send
  - API call (custom enrichment): 0.2 credit per call

- **Balance Checks:** Before any operation that costs credits, fetch customer's `credit_balance` and verify balance >= cost. Fail gracefully with error message: "Insufficient credits. Current balance: X, required: Y."

- **Credit Refunds:** If send fails after 3 retries, automatically refund the credit to customer's balance (log in audit_log as "refund").

### 4. Supabase RLS & Auth

- **Enforcement:** Row-level security policies MUST be enabled on all customer-scoped tables (accounts, contacts, signals, activation_outreach, etc.).
- **Testing:** Every DB query must be tested with proper Supabase auth context (authenticated user with customer_id in JWT).
- **No Bypass:** Never use service key for customer operations. Service key only for admin tasks (seed, migrations).
- **Policy Review:** Before any schema change, audit RLS policies (see /DevTeamSOP/ADRs/ADR-002-RLS-Policies.md).

### 5. API Integration Reliability

- **Target:** <1% failure rate across all third-party API calls.
- **Retry Logic:** Exponential backoff (3x retry, 2s → 4s → 8s) for transient failures (5xx, timeout).
- **Circuit Breaker:** If an API fails 5x in a row, disable that signal source for 1 hour, alert in Slack.
- **Webhooks:** Implement timeout (30s), verify signature (HMAC), log all requests (for debugging).
- **Fallbacks:** Claude API fails → try Gemini API; both fail → use rule-based scoring.

### 6. Cost Management

- **Claude API Budget:** $5K/month max for 50 customers. Monitor spend weekly via Sentry/n8n logs.
- **Clay/Clearbit Budget:** $2K/month max. Prioritize enrichment for hot/warm accounts only.
- **Apify Budget:** $1K/month max. Run LinkedIn scrapers on-demand, not continuous.
- **Overall:** Track cost per lead (target <$3 in API credits). Alert Mamoun if spend exceeds 110% of budget.

### 7. Uptime & SLA

- **Production Uptime Target:** >99.5% (max 3.6 hours downtime per month)
- **Monitored Components:** Supabase, n8n, frontend, API
- **Incident Response:** Critical failure → Slack alert within 5 min, Mamoun + al-Jazari notified, status page update
- **Recovery Time Objective (RTO):** <15 min for most failures

### 8. Data Retention & GDPR

- **Signal Retention:** 13-month rolling window (oldest signals auto-deleted)
- **Outreach Records:** Keep for 2 years (for analytics, compliance)
- **GDPR Right to Erasure:** If contact requests deletion, soft-delete from `contacts` table (set `do_not_contact = true`), hard-delete after 90 days
- **Privacy Policy:** Reference in footer, link to /docs/PRIVACY-POLICY.md
- **DPA:** EU customers require Data Processing Addendum (template in /docs/)

---

## FILE STRUCTURE & KEY PATHS

```
/Signal-Sales-Engine/
├── .claude/
│   ├── CLAUDE.md (this file)
│   ├── LANA-PROJECT-CONTEXT.md (QA-specific context)
│   ├── LANA-ONBOARDING-BRIEF.md (Lana's onboarding notes)
│   └── settings.local.json (local Cowork config)
├── Project/
│   ├── company-profile.md (business, market, positioning)
│   ├── tech-spec.md (detailed architecture, API specs)
│   └── project-instructions.md (feature roadmap, milestones)
├── DevTeamSOP/
│   ├── ADRs/ (Architecture Decision Records)
│   │   ├── ADR-001-Signal-Nervous-System.md
│   │   ├── ADR-002-RLS-Policies.md
│   │   ├── ADR-003-Credit-System-Design.md
│   │   └── ... (more ADRs)
│   ├── workflows/ (n8n workflow documentation, architecture)
│   ├── database/ (schema diagrams, migration history)
│   └── deployment/ (runbooks, incident response, deployment procedures)
├── docs/
│   ├── SSE-V3-QA-Testing-Guide.md (Lana's testing checklist)
│   ├── PRIVACY-POLICY.md
│   └── API-Documentation.md (OpenAPI/Swagger)
├── Output/
│   ├── BRD-*.md (Business Requirements Documents, 7 total)
│   └── Scoring-Reports/ (monthly feedback loop reports)
└── README.md (quick start, links to docs)
```

### LIVE Frontend (on smo-dev, NOT in this repo)

```
/root/signal_project_v3/scrapmfast_frontend/   ← LIVE at sse.smorchestra.ai
├── src/
│   ├── components/ (auth, campaigns, leads, signals, navigation, ui, etc.)
│   ├── pages/ (12 pages: dashboard, leads, signals, campaigns, analytics, reports, settings, credits, scrapers, triggers, auth, 404)
│   ├── lib/ (Supabase client, sentry.ts, posthog.ts)
│   ├── hooks/
│   ├── store/
│   ├── types/
│   ├── utils/
│   ├── main.tsx (app entry, initializes Sentry + PostHog)
│   └── App.tsx (routing, pageview capture)
├── .env (VITE_SENTRY_DSN, VITE_POSTHOG_KEY, VITE_SUPABASE_URL, etc.)
└── package.json (Vite + React 18 + TypeScript)

Port: 6002 (systemd: scrapmfast-frontend.service)
Nginx: sse.smorchestra.ai → :6002 (frontend) + :6001 (API)
```

**NOTE:** `/workspaces/smo/Signal-Sales-Engine/dashboard/` contains an incomplete Next.js rebuild (3 pages). It is NOT live and NOT the production frontend. All frontend work targets the Vite app above.
```

---

## TEAM ROLES & ESCALATION

**Mamoun Alamouri (Founder, Product/Strategy)**
- Product decisions, ICP definition, feature prioritization
- Client relationships, pricing, revenue decisions
- Escalation: any change to signal weights, pricing logic, new integrations, MENA market positioning

**al-Jazari (VP Engineering, Architecture)**
- n8n workflows, Supabase schema, deployment, infrastructure
- Code review (architecture), PR approval
- Escalation: database schema migrations, RLS policy changes, deployment to production, third-party API integrations

**Lana (QA Tester)**
- Soak test execution (full E2E testing)
- Bug triage, signal data quality verification
- No escalation authority, reports to Mamoun + al-Jazari

**Developers (TBD: 1-2 needed)**
- Frontend (React, Next.js), backend (API routes, Edge Functions)
- Feature implementation, bug fixes
- Escalation: architecture questions, cross-system changes

---

## HOW TO WORK IN THIS CODEBASE

### For New Features

1. **Start with the BRD:** Read relevant BRD in /Output/ (e.g., BRD-Campaign-Builder.md)
2. **Understand the architecture:** Review related ADR in /DevTeamSOP/ADRs/
3. **Check database schema:** Verify table structure in /DevTeamSOP/database/
4. **Write code on `dev` branch:** Never commit to `main`
5. **Test thoroughly:** Unit tests (>80% coverage), E2E tests (happy path + edge cases)
6. **Request code review:** Tag al-Jazari (architecture) + Mamoun (product)
7. **Score your PR:** Use smorch-dev-scoring plugin, target >= 8/10 composite
8. **Merge to `dev`:** Approval from al-Jazari + Mamoun required
9. **Deploy to staging:** Manual step (contact al-Jazari)
10. **QA sign-off:** Lana tests in staging
11. **Merge to `main`:** Only after staging QA passes

### For Bug Fixes

1. **Create Linear issue:** smorch-gtm-tools:linear plugin
2. **Repro steps:** Include environment, exact steps, expected vs. actual
3. **Assign to developer:** Tag owner, link to related BRD/ADR
4. **Test in `dev` first:** Write test that catches the bug
5. **Fix and PR:** Same review + score process as new features
6. **Verify in staging:** QA retest on staging
7. **Deploy to production:** al-Jazari controls

### For Database Changes

1. **Escalate to Mamoun + al-Jazari:** Schema changes require approval
2. **Write migration in Supabase console:** Test on staging first
3. **Update ADR:** Document reasoning in /DevTeamSOP/ADRs/
4. **Backup production:** al-Jazari handles pre-migration backup
5. **Run migration in prod:** al-Jazari monitors
6. **Update this CLAUDE.md:** Reflect new tables/columns

### For n8n Workflow Changes

1. **Escalate to al-Jazari:** Workflow changes are architecture decisions
2. **Test in n8n's test mode:** Verify with real (or mocked) data
3. **Document changes:** Update /DevTeamSOP/workflows/workflow-name.md
4. **Deploy to production:** al-Jazari controls via testflow.smorchestra.ai UI
5. **Monitor execution logs:** Check /logs/ in n8n for first 24 hours

### For Scoring Logic Changes

1. **Document signal weights change:** Which signals are being reweighted, why
2. **A/B test if possible:** Compare old vs. new weights on historical data
3. **Coordinate with feedback loop:** Monthly refresh (1st Sunday) is the safest time
4. **Alert customers:** Email customers if their signal settings are affected
5. **Monitor accuracy:** Track intent prediction accuracy after change

---

## KNOWN TECH DEBT

**High Priority (Fix Before Phase 4):**
- LinkedIn scraper has duplicate detection edge cases (name variations, title changes) - TODO: implement fuzzy matching
- Enrichment pipeline retry logic is basic (single retry) - TODO: exponential backoff + circuit breaker
- GHL webhook signature verification is custom HMAC, not standard - TODO: validate against GHL's official method
- Campaign trigger evaluator doesn't handle timezone-aware scheduling - TODO: use moment-timezone or date-fns

**Medium Priority (Plan for Q2 2026):**
- n8n workflows have "copy" variants that should be consolidated (e.g., Signal-Ingest-Clay-Copy) - TODO: delete copies, use variables
- Supabase Edge Function cold starts add 500ms latency on first call per day - TODO: consider pre-warming or moving to Cloud Functions
- PostHog analytics not integrated for all customer events - TODO: add event tracking to frontend

**Low Priority (Nice to Have):**
- Sentry error messages could be more specific (some are generic) - TODO: improve error messages in API layer
- CLI tool for local development could be better documented - TODO: create script for setup.sh

---

## SCORING EXCELLENCE STANDARDS

Every PR, feature, and n8n workflow in this codebase is held to a composite quality standard. Use the smorch-dev-scoring plugin (5-hat system):

**Engineering Hat (Code Quality):**
- Does the code follow TypeScript strict mode?
- Are there type definitions for all function params/returns?
- Is there proper error handling (try-catch or async/await)?
- Are there >80% unit test coverage for changed files?
- Is the code testable (DI, minimal side effects)?

**Architecture Hat (System Design):**
- Does this change align with the four-layer nervous system?
- Does it introduce any new third-party dependencies (discuss with al-Jazari first)?
- Is the change modular (can it be deployed independently)?
- Does it handle the full data flow (signal → interpretation → activation → learning)?

**UX/Frontend Hat (User Experience):**
- Does the UI respect RTL for Arabic?
- Are form validations clear (error messages)?
- Does the dashboard load in <2 seconds?
- Is accessibility considered (WCAG 2.1 AA)?
- Does it work on mobile (responsive)?

**Product Hat (Business Value):**
- Does this feature directly reduce customer's sales cycle?
- Does it increase signal prediction accuracy?
- Does it consume credits efficiently?
- Does it align with MENA market needs?
- Can we charge for it (or does it reduce churn)?

**QA Hat (Testing & Reliability):**
- Are E2E test scenarios written (happy path + edge cases)?
- Have edge cases been tested (empty data, errors, timeouts)?
- Is there a rollback plan if deployed to production?
- Are webhooks tested with invalid signatures?
- Have rate limits been tested?

**Target:** >= 8/10 composite (all hats >= 7/10, with no hat below 6/10).

---

## MONTHLY OPERATIONS CHECKLIST

**1st Sunday (Feedback Loop Day):**
- Feedback-Loop-Monthly workflow runs 02:00 UTC
- Monitor Slack for completion alert
- Review monthly accuracy report
- Check if signal weights changed significantly (>10% reweight)
- Alert customers if their signal settings were reweighted

**Weekly (Tuesdays):**
- Check n8n execution logs for failures
- Review Sentry errors (any spikes?)
- Review credit consumption (are customers on track?)
- Check uptime dashboard (any downtime events?)

**Monthly (Last Friday):**
- Review LTV, churn, CAC metrics (Mamoun, al-Jazari)
- Plan next month's feature/bug priorities
- Update roadmap in /Project/project-instructions.md
- Send internal status report (team + investors)

**Quarterly (End of Q):**
- Full codebase audit (tech debt assessment)
- Review and update ADRs (/DevTeamSOP/ADRs/)
- Security review (dependencies, API integrations)
- Plan next quarter's architecture changes

---

## CONTACT & ESCALATION

**Emergency (Critical Production Outage):**
- Slack: @al-jazari (smo-brain, Supabase, n8n)
- Slack: @mamoun (business decisions, customer comms)
- Response time target: <30 min

**Feature Questions:**
- Slack: @mamoun (what to build, positioning)
- Slack: @al-jazari (how to build, architecture)

**QA Issues / Testing Questions:**
- Slack: @lana (test scenarios, bug reports)
- Linear: create issue with label `qasoak-test`

**Database / Deployment:**
- Slack: @al-jazari (schema changes, production deploys)
- Require Mamoun approval for major changes

**Integrations (Clay, Instantly, HeyReach, GHL):**
- Check credentials in n8n's credential store (al-Jazari has access)
- Update credentials if API key rotates
- Document integration issues in /DevTeamSOP/integrations/

---

## SUCCESS METRICS (12-MONTH TARGETS)

By end of 2026, SSE V3 should achieve:

| Metric | Target | Owner |
|--------|--------|-------|
| Customer count | 8-12 | Mamoun |
| MRR | $100K+ | Mamoun |
| Monthly churn | <10% | Mamoun |
| Gross margin | >40% | Mamoun |
| Intent prediction accuracy | >85% | al-Jazari, Lana |
| Duplicate touch rate | <0.1% | al-Jazari, Lana |
| Cycle compression vs. baseline | >30-40% | Mamoun (measure with customers) |
| API integration failure rate | <1% | al-Jazari |
| Production uptime | >99.5% | al-Jazari |
| Code test coverage | >80% | al-Jazari |
| PR quality score | >= 8/10 | Team |

---

## APPENDIX: QUICK REFERENCE

**Useful Slack Channels:**
- #sse-v3-dev (development, technical questions)
- #sse-v3-alerts (n8n failures, Sentry errors, uptime alerts)
- #sse-v3-product (roadmap, feature requests, business metrics)

**Key URLs:**
- SSE V3 Dashboard (LIVE): https://sse.smorchestra.ai
- n8n UI (smo-brain): https://testflow.smorchestra.ai:5170
- n8n (smo-dev): SSE workflows, 29 total
- Supabase Dashboard: https://app.supabase.co
- GitHub: https://github.com/SMOrchestra-ai/Signal-Sales-Engine
- Linear (issues): https://linear.app/smorchestra
- Sentry (errors): https://sentry.io/organizations/smorchestra (project: javascript-nextjs)
- PostHog (analytics): https://posthog.com

**Common Commands (LIVE Vite frontend on smo-dev):**
```bash
# SSH to smo-dev
ssh 100.117.35.19

# Frontend source
cd /root/signal_project_v3/scrapmfast_frontend

# Dev server
npm run dev -- --host 0.0.0.0 --port 6002

# Run tests
npm run test              # Vitest
npm run test:coverage    # Coverage report

# Code quality
npm run lint             # ESLint
npx tsc --noEmit         # TypeScript strict check

# Build for prod
npm run build
npm run preview -- --host 0.0.0.0 --port 6002

# Systemd services
systemctl status scrapmfast-frontend.service
systemctl status scrapmfast-backend.service
systemctl restart scrapmfast-frontend.service
```

---

**This document is the source of truth. Update it whenever architecture, constraints, or processes change. Last updated: 2026-04-07.**
