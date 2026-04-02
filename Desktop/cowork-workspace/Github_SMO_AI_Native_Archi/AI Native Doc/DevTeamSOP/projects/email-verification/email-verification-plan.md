# SalesMfast Email Verification Module: Implementation Blueprint

## Document Purpose
This is the complete macro-to-micro implementation plan for building an automated email verification backend module into SalesMfast. Designed to be used as a direct instruction set for Claude Code.

---

## PART 1: MACRO PLAN - Strategic Architecture

### 1.1 The Problem We're Solving

When SalesMfast scrapes emails (via Apify, Clay, LinkedIn Helper, or manual import), bounce rates can reach 25-40%. This destroys sender reputation across Instantly campaigns, kills deliverability for all clients sharing those sending accounts, and wastes outreach budget on dead addresses. In MENA specifically, the problem is worse because:

- Gulf government and enterprise domains overwhelmingly use catch-all configurations
- Arabic name romanization creates duplicate/invalid email variations (Mohammed vs Muhammad vs Mohamed vs Mohamad)
- Many .ae, .sa, .qa corporate domains have non-standard mail server configurations
- Smaller MENA businesses frequently change email providers without updating public records

### 1.2 Strategic Decision: Why We Are NOT Building SMTP Verification From Scratch

This is the most important architectural decision in the entire module. Here's the full reasoning:

**The IP Reputation Problem**
SMTP verification works by opening a connection to the target mail server and asking "does this mailbox exist?" without sending an actual email. The moment you do this at scale (1000+ checks/day), Gmail, Microsoft 365, Outlook, and Yahoo start flagging your IP addresses. You need:
- Rotating pools of residential IPs (not datacenter IPs, those get blocked instantly)
- IP warm-up cycles for new verification IPs
- Geographic IP distribution (some mail servers block non-local IPs)
- Constant monitoring of IP reputation scores

This is a full-time infrastructure operation. Companies like ZeroBounce and MillionVerifier employ dedicated teams just to manage this. Building this ourselves would cost more in infrastructure and maintenance than the entire verification module is worth.

**The Greylisting Problem**
Many enterprise mail servers (especially Microsoft Exchange, which dominates MENA corporate email) use greylisting: they temporarily reject the first connection attempt from unknown senders. A proper SMTP verifier needs retry logic with exponential backoff, which means verification that should take milliseconds now takes 15-30 minutes per email. Building reliable retry infrastructure adds another layer of complexity.

**The Catch-All Problem (Critical for MENA)**
When a domain is configured as catch-all, the mail server responds "yes, this mailbox exists" for EVERY address, including completely fabricated ones. SMTP verification becomes useless. In MENA markets, this is not an edge case, it's the norm for:
- Government entities (.gov.ae, .gov.sa, .gov.qa, .gov.jo)
- Banks and financial institutions
- Large family conglomerates (Al Futtaim, Majid Al Futtaim, Al Ghurair, etc.)
- State-owned enterprises

No amount of SMTP infrastructure investment solves this problem. It requires a fundamentally different approach (our Layer 4).

**The Cost-Benefit Math**
- MillionVerifier: ~$0.50 per 1,000 verifications
- Reoon: ~$0.60 per 1,000 verifications
- Building our own: $2,000-5,000/month in infrastructure + 20-40 hours/month maintenance
- Break-even point: ~4-10 million verifications/month

We're nowhere near that volume. The smart play: build the intelligence layers (1, 2, 4) that no external API provides, and use a commodity API for Layer 3 SMTP checks.

**Our Actual Moat Is Not SMTP Pinging**
Our competitive advantage is:
- MENA-specific domain intelligence
- Arabic name normalization and deduplication
- Cross-client engagement verification (Layer 4 network effect)
- Intelligent routing: when email can't be verified, auto-route to WhatsApp/LinkedIn instead

None of these require building SMTP verification. They require building everything AROUND it.

### 1.3 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    SCRAPER LAYER (Existing)                      │
│  Apify / Clay / LinkedIn Helper / Manual Import                 │
│  ↓ saves raw emails to Supabase                                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           │  [verification_enabled = true checkbox]
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│              VERIFICATION ORCHESTRATOR (New)                     │
│              Supabase Edge Function: verify-email                │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
│  │ Layer 1  │→ │ Layer 2  │→ │ Layer 3  │→ │   Layer 4    │   │
│  │ Syntax   │  │ DNS/MX   │  │ SMTP API │  │ Engagement   │   │
│  │ Pattern  │  │ Domain   │  │ External │  │ Intelligence │   │
│  │ FREE     │  │ FREE     │  │ PAID     │  │ FREE/MOAT    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘   │
│                                                                  │
│  Output: confidence_score (0-100) + verification_details JSON    │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DECISION ENGINE                               │
│                                                                  │
│  Score 90-100: ✅ Safe to email via Instantly                    │
│  Score 70-89:  ⚠️ Email with caution, monitor bounces            │
│  Score 50-69:  🔀 Route to WhatsApp/LinkedIn first               │
│  Score 0-49:   ❌ Do NOT email, enrich alternative contacts       │
└─────────────────────────────────────────────────────────────────┘
```

### 1.4 Integration Points with Existing Stack

| System | Integration | Direction |
|--------|------------|-----------|
| Supabase | Primary data store + Edge Functions | Read/Write |
| n8n | Trigger verification workflows, handle routing | Trigger + Process |
| Instantly | Pre-send verification check, bounce feedback loop | Read + Write |
| HeyReach | Alternative channel routing for low-confidence emails | Write |
| GHL (SalesMfast SME) | Contact enrichment, WhatsApp routing | Write |
| Clay | Enrichment source, waterfall data | Read |

---

## PART 2: MICRO PLAN - Implementation Details

### 2.1 Supabase Database Schema

#### Table: `email_verifications`
Primary verification results cache.

```sql
CREATE TABLE public.email_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL,
    email_normalized TEXT NOT NULL,  -- lowercase, trimmed
    
    -- Verification Results
    overall_score INTEGER NOT NULL DEFAULT 0,  -- 0-100 confidence
    overall_status TEXT NOT NULL DEFAULT 'pending',  -- pending, valid, risky, invalid, catch_all, unknown
    
    -- Layer 1: Syntax
    l1_syntax_valid BOOLEAN DEFAULT NULL,
    l1_is_disposable BOOLEAN DEFAULT NULL,
    l1_is_role_based BOOLEAN DEFAULT NULL,
    l1_is_free_provider BOOLEAN DEFAULT NULL,
    l1_arabic_name_variants JSONB DEFAULT NULL,  -- detected romanization variants
    
    -- Layer 2: DNS/MX
    l2_mx_valid BOOLEAN DEFAULT NULL,
    l2_mx_records JSONB DEFAULT NULL,
    l2_has_spf BOOLEAN DEFAULT NULL,
    l2_has_dmarc BOOLEAN DEFAULT NULL,
    l2_is_catch_all BOOLEAN DEFAULT NULL,
    l2_domain_age_days INTEGER DEFAULT NULL,
    
    -- Layer 3: SMTP (External API)
    l3_smtp_valid BOOLEAN DEFAULT NULL,
    l3_smtp_provider TEXT DEFAULT NULL,  -- 'millionverifier', 'reoon', etc.
    l3_smtp_raw_response JSONB DEFAULT NULL,
    l3_smtp_checked_at TIMESTAMPTZ DEFAULT NULL,
    
    -- Layer 4: Engagement Intelligence
    l4_has_engagement BOOLEAN DEFAULT NULL,
    l4_last_open_at TIMESTAMPTZ DEFAULT NULL,
    l4_last_click_at TIMESTAMPTZ DEFAULT NULL,
    l4_total_sends INTEGER DEFAULT 0,
    l4_total_bounces INTEGER DEFAULT 0,
    l4_bounce_rate DECIMAL(5,4) DEFAULT NULL,
    
    -- Metadata
    domain TEXT NOT NULL,  -- extracted domain
    verification_source TEXT DEFAULT NULL,  -- 'scraper_auto', 'manual', 'bulk_import'
    organization_id UUID DEFAULT NULL,  -- multi-tenant support
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    verified_at TIMESTAMPTZ DEFAULT NULL,  -- when full verification completed
    expires_at TIMESTAMPTZ DEFAULT NULL,  -- verification validity window
    
    CONSTRAINT unique_email_per_org UNIQUE (email_normalized, organization_id)
);

-- Indexes for performance
CREATE INDEX idx_email_verifications_email ON public.email_verifications(email_normalized);
CREATE INDEX idx_email_verifications_domain ON public.email_verifications(domain);
CREATE INDEX idx_email_verifications_score ON public.email_verifications(overall_score);
CREATE INDEX idx_email_verifications_status ON public.email_verifications(overall_status);
CREATE INDEX idx_email_verifications_org ON public.email_verifications(organization_id);
CREATE INDEX idx_email_verifications_expires ON public.email_verifications(expires_at);
```

#### Table: `domain_intelligence`
Cached domain-level data to avoid redundant DNS lookups.

```sql
CREATE TABLE public.domain_intelligence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain TEXT NOT NULL UNIQUE,
    
    -- DNS Records
    mx_records JSONB DEFAULT NULL,
    mx_valid BOOLEAN DEFAULT NULL,
    has_spf BOOLEAN DEFAULT NULL,
    spf_record TEXT DEFAULT NULL,
    has_dmarc BOOLEAN DEFAULT NULL,
    dmarc_record TEXT DEFAULT NULL,
    
    -- Domain Classification
    is_catch_all BOOLEAN DEFAULT NULL,
    is_disposable BOOLEAN DEFAULT NULL,
    is_free_provider BOOLEAN DEFAULT NULL,
    is_government BOOLEAN DEFAULT NULL,  -- .gov.ae, .gov.sa etc.
    is_corporate BOOLEAN DEFAULT NULL,
    provider_type TEXT DEFAULT NULL,  -- 'google_workspace', 'microsoft_365', 'exchange_onprem', 'other'
    
    -- MENA-Specific
    country_code TEXT DEFAULT NULL,  -- ae, sa, qa, jo, etc.
    region TEXT DEFAULT NULL,  -- 'gulf', 'levant', 'north_africa'
    catch_all_confidence INTEGER DEFAULT NULL,  -- 0-100 how sure are we it's catch-all
    
    -- Stats
    total_emails_checked INTEGER DEFAULT 0,
    total_bounces INTEGER DEFAULT 0,
    domain_bounce_rate DECIMAL(5,4) DEFAULT NULL,
    domain_age_days INTEGER DEFAULT NULL,
    
    -- Cache Management
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    dns_checked_at TIMESTAMPTZ DEFAULT NULL,
    dns_expires_at TIMESTAMPTZ DEFAULT NULL  -- re-check DNS after this
);

CREATE INDEX idx_domain_intel_domain ON public.domain_intelligence(domain);
CREATE INDEX idx_domain_intel_catch_all ON public.domain_intelligence(is_catch_all);
CREATE INDEX idx_domain_intel_country ON public.domain_intelligence(country_code);
```

#### Table: `bounce_signals`
Aggregate bounce data from Instantly, HeyReach, and direct sends.

```sql
CREATE TABLE public.bounce_signals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email_normalized TEXT NOT NULL,
    domain TEXT NOT NULL,
    
    bounce_type TEXT NOT NULL,  -- 'hard', 'soft', 'complaint', 'unsubscribe'
    bounce_source TEXT NOT NULL,  -- 'instantly', 'heyreach', 'ghl', 'direct'
    bounce_code TEXT DEFAULT NULL,  -- SMTP bounce code
    bounce_message TEXT DEFAULT NULL,
    
    campaign_id TEXT DEFAULT NULL,
    organization_id UUID DEFAULT NULL,
    
    bounced_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_bounce_email ON public.bounce_signals(email_normalized);
CREATE INDEX idx_bounce_domain ON public.bounce_signals(domain);
CREATE INDEX idx_bounce_type ON public.bounce_signals(bounce_type);
CREATE INDEX idx_bounce_source ON public.bounce_signals(bounce_source);
```

#### Table: `verification_queue`
Async processing queue for batch and real-time verification.

```sql
CREATE TABLE public.verification_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL,
    
    priority INTEGER DEFAULT 5,  -- 1=highest, 10=lowest
    status TEXT DEFAULT 'queued',  -- queued, processing, completed, failed, skipped
    
    -- What triggered this
    source TEXT DEFAULT NULL,  -- 'scraper_auto', 'bulk_import', 'manual', 're_verify'
    source_table TEXT DEFAULT NULL,  -- which table the email came from
    source_record_id UUID DEFAULT NULL,  -- record ID in source table
    
    -- Processing
    current_layer INTEGER DEFAULT 0,  -- 0=not started, 1-4=which layer
    layer_results JSONB DEFAULT '{}',
    error_message TEXT DEFAULT NULL,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    
    organization_id UUID DEFAULT NULL,
    
    queued_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ DEFAULT NULL,
    completed_at TIMESTAMPTZ DEFAULT NULL,
    
    CONSTRAINT unique_queue_email UNIQUE (email, status) 
        WHERE status IN ('queued', 'processing')  -- prevent duplicate queue entries
);

CREATE INDEX idx_queue_status ON public.verification_queue(status);
CREATE INDEX idx_queue_priority ON public.verification_queue(priority, queued_at);
CREATE INDEX idx_queue_source ON public.verification_queue(source_record_id);
```

#### Table: `disposable_domains`
Reference table for known disposable/temporary email providers.

```sql
CREATE TABLE public.disposable_domains (
    domain TEXT PRIMARY KEY,
    source TEXT DEFAULT 'manual',  -- 'manual', 'github_list', 'detected'
    added_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Table: `arabic_name_mappings`
MENA-specific: romanization variants for Arabic names.

```sql
CREATE TABLE public.arabic_name_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    arabic_name TEXT NOT NULL,  -- Original Arabic
    variants JSONB NOT NULL,  -- ["mohammed", "muhammad", "mohamed", "mohamad", "muhammed"]
    frequency_rank INTEGER DEFAULT NULL,  -- how common is this name
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_arabic_names ON public.arabic_name_mappings USING GIN (variants);
```

### 2.2 Database Trigger: Auto-Queue on Scrape

This is the key integration point. When the scraper saves a new email and `verification_enabled` is true, automatically queue it for verification.

```sql
-- Function to auto-queue emails for verification
CREATE OR REPLACE FUNCTION fn_auto_queue_verification()
RETURNS TRIGGER AS $$
BEGIN
    -- Only queue if verification is enabled for this record
    -- The frontend checkbox sets this field
    IF NEW.verification_enabled = true AND (
        TG_OP = 'INSERT' OR 
        (TG_OP = 'UPDATE' AND OLD.verification_enabled = false)
    ) THEN
        INSERT INTO public.verification_queue (
            email,
            priority,
            source,
            source_table,
            source_record_id,
            organization_id
        ) VALUES (
            NEW.email,
            CASE 
                WHEN NEW.source = 'manual' THEN 1      -- manual imports get highest priority
                WHEN NEW.source = 'scraper' THEN 3     -- scraper is normal priority
                ELSE 5                                   -- everything else is lower
            END,
            'scraper_auto',
            TG_TABLE_NAME,
            NEW.id,
            NEW.organization_id
        )
        ON CONFLICT DO NOTHING;  -- skip if already queued
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger to your scraped emails table
-- IMPORTANT: Replace 'scraped_contacts' with your actual table name
CREATE TRIGGER trg_auto_verify_email
    AFTER INSERT OR UPDATE OF verification_enabled
    ON public.scraped_contacts  -- << YOUR TABLE NAME HERE
    FOR EACH ROW
    EXECUTE FUNCTION fn_auto_queue_verification();
```

### 2.3 Edge Functions Architecture

#### Edge Function 1: `verify-email` (Main Orchestrator)

This is the primary Edge Function that processes the verification queue.

```
File: supabase/functions/verify-email/index.ts

Purpose: 
- Picks items from verification_queue
- Runs them through Layers 1 → 2 → 3 → 4 sequentially
- Writes results to email_verifications
- Updates the source record with verification score

Trigger options:
- pg_cron: every 30 seconds for real-time processing
- n8n webhook: for batch processing
- Direct invocation: for single email verification

Logic flow:
1. SELECT from verification_queue WHERE status = 'queued' ORDER BY priority, queued_at LIMIT 10
2. SET status = 'processing' 
3. For each email:
   a. Check email_verifications cache (verified in last 30 days? skip)
   b. Run Layer 1 (syntax) - if FAIL, score = 0, done
   c. Run Layer 2 (DNS/MX) - if domain invalid, score = 0, done
   d. Check domain_intelligence cache for catch-all status
   e. Run Layer 3 (external API) - only if NOT catch-all
   f. Run Layer 4 (engagement check) - always run
   g. Calculate composite score
   h. Write to email_verifications
   i. Update source record
   j. SET status = 'completed'
4. On error: increment retry_count, SET status = 'queued' if retries remain
```

#### Edge Function 2: `verify-layer-dns` (DNS/MX Lookup)

```
File: supabase/functions/verify-layer-dns/index.ts

Purpose: DNS and MX record verification
- Uses Deno's built-in DNS resolver
- Checks MX, SPF, DMARC records
- Detects catch-all domains
- Caches results in domain_intelligence (24hr TTL)

Key MENA logic:
- Auto-flag .gov.ae/.gov.sa/.gov.qa as likely catch-all
- Special handling for known Gulf enterprise domains
- Country code extraction from TLD
```

#### Edge Function 3: `verify-layer-smtp` (External API Wrapper)

```
File: supabase/functions/verify-layer-smtp/index.ts

Purpose: Wrapper around external SMTP verification API
- Primary: MillionVerifier API
- Fallback: Reoon API (if MillionVerifier is down)
- Rate limiting: max 100 requests/minute to avoid API limits
- Cost tracking: log every API call with cost
- Batch support: MillionVerifier supports batch of 50

API keys stored in Supabase Vault (edge function secrets)
```

#### Edge Function 4: `verify-layer-engagement` (Network Intelligence)

```
File: supabase/functions/verify-layer-engagement/index.ts

Purpose: Cross-reference email against engagement history
- Query bounce_signals for this email and domain
- Query Instantly webhook data for open/click events
- Check if this email has been successfully delivered to before
- Calculate engagement-based confidence modifier

This is the moat layer. Every email verified across all SalesMfast 
customers improves the database for everyone.
```

#### Edge Function 5: `verification-webhook` (Bounce Feedback)

```
File: supabase/functions/verification-webhook/index.ts

Purpose: Receive bounce notifications from Instantly/HeyReach/GHL
- Instantly webhook → parse bounce data → write to bounce_signals
- Auto-update email_verifications score when bounces detected
- If 3+ hard bounces for same domain → flag domain in domain_intelligence
- Alert via n8n if bounce rate spikes (possible list quality issue)
```

### 2.4 Layer Implementation Details

#### Layer 1: Syntax + Pattern Validation

```typescript
// Core validation logic (runs in verify-email Edge Function)

interface Layer1Result {
  valid: boolean;
  is_disposable: boolean;
  is_role_based: boolean;
  is_free_provider: boolean;
  arabic_name_variants: string[] | null;
  failure_reason: string | null;
}

function validateLayer1(email: string): Layer1Result {
  // 1. Basic RFC 5322 regex
  // 2. Check against disposable_domains table
  // 3. Check role-based prefixes: info@, sales@, support@, admin@, contact@, 
  //    noreply@, hr@, marketing@, billing@, office@
  // 4. Check free providers: gmail, yahoo, hotmail, outlook, protonmail
  // 5. Arabic name detection:
  //    - Extract local part (before @)
  //    - Check against arabic_name_mappings
  //    - Flag potential duplicates
  // 6. MENA-specific patterns:
  //    - firstname.lastname@ (Western style)
  //    - firstnamelastname@ (no separator)
  //    - f.lastname@ (initial style)
  //    - firstname@ (first name only, common in SMEs)
}
```

**Role-based email list (expanded for MENA):**
```
info, sales, support, admin, contact, noreply, hr, marketing,
billing, office, reception, enquiry, enquiries, careers, jobs,
webmaster, postmaster, abuse, security, legal, compliance,
procurement, purchasing, accounts, finance, it, helpdesk,
customerservice, press, media, pr, communications,
// MENA-specific
istiqbal (reception), mabiat (sales), daam (support),
tawzeef (recruitment), muhasaba (accounting)
```

**Arabic name romanization variants (seed data):**
```json
{
  "محمد": ["mohammed", "muhammad", "mohamed", "mohamad", "muhammed", "mohmad"],
  "أحمد": ["ahmed", "ahmad", "ahmd"],
  "عبدالله": ["abdullah", "abdallah", "abd-allah", "abdulla"],
  "خالد": ["khaled", "khalid", "kalid"],
  "عمر": ["omar", "omer", "umar"],
  "فاطمة": ["fatima", "fatma", "fatimah", "fatemah"],
  "عائشة": ["aisha", "aysha", "aesha", "aicha"],
  "سارة": ["sara", "sarah", "saara"],
  "نور": ["noor", "nour", "nur", "nora", "noura"],
  "ياسمين": ["yasmine", "yasmeen", "yasmin", "jasmine"]
}
```

#### Layer 2: DNS/MX Verification

```typescript
interface Layer2Result {
  mx_valid: boolean;
  mx_records: string[];
  has_spf: boolean;
  has_dmarc: boolean;
  is_catch_all: boolean;
  catch_all_confidence: number;
  domain_age_days: number | null;
  provider_type: string;  // google_workspace, microsoft_365, exchange_onprem, other
  failure_reason: string | null;
}

// Provider detection via MX records:
// Google Workspace:    *.google.com, *.googlemail.com
// Microsoft 365:      *.outlook.com, *.protection.outlook.com
// Exchange On-Prem:   custom MX pointing to company IP
// Yahoo:              *.yahoodns.net
// Zoho:               *.zoho.com

// Catch-all detection heuristic:
// 1. Known catch-all patterns (Gulf gov domains)
// 2. If we have bounce data: domain bounce rate < 1% with 50+ sends = likely catch-all
// 3. If provider is Exchange On-Prem = higher catch-all probability
// 4. Government TLDs (.gov.*) = assume catch-all until proven otherwise
```

#### Layer 3: External SMTP API

```typescript
interface Layer3Result {
  smtp_valid: boolean;
  provider: string;
  quality_score: string;  // from API: 'good', 'risky', 'bad', 'unknown'
  raw_response: object;
  cost_usd: number;
}

// MillionVerifier API integration
// Endpoint: https://api.millionverifier.com/api/v3/
// Single: GET /verify?api={key}&email={email}
// Bulk: POST /bulkapi/v2/upload (CSV file, async)
//
// Response mapping:
// "ok"        → smtp_valid: true,  quality: 'good'
// "catch_all" → smtp_valid: null,  quality: 'risky'  (flag in our system)
// "unknown"   → smtp_valid: null,  quality: 'unknown'
// "disposable"→ smtp_valid: false, quality: 'bad'
// "invalid"   → smtp_valid: false, quality: 'bad'
//
// CRITICAL: Skip Layer 3 entirely if Layer 2 detected catch-all
// This saves money: no point paying to verify an address on a catch-all domain
```

#### Layer 4: Engagement Intelligence

```typescript
interface Layer4Result {
  has_engagement: boolean;
  last_open_at: Date | null;
  last_click_at: Date | null;
  total_sends: number;
  total_bounces: number;
  bounce_rate: number;
  engagement_score_modifier: number;  // -30 to +30 adjustment
  domain_health: number;  // 0-100 based on aggregate domain data
}

// Scoring modifiers:
// Recent open (< 30 days):     +25
// Recent click (< 30 days):    +30
// Older open (30-90 days):     +15
// Older click (30-90 days):    +20
// No engagement, no bounces:    0
// Soft bounce (1x):            -10
// Hard bounce (1x):            -40
// Multiple bounces:            -80 (basically dead)
// Domain bounce rate > 20%:    -20
// Domain bounce rate > 50%:    -40
```

### 2.5 Composite Score Calculation

```typescript
function calculateCompositeScore(
  l1: Layer1Result,
  l2: Layer2Result, 
  l3: Layer3Result | null,
  l4: Layer4Result
): { score: number; status: string } {
  
  // Layer 1 is binary gate
  if (!l1.valid) return { score: 0, status: 'invalid' };
  
  // Layer 2 base scoring
  let score = 0;
  if (!l2.mx_valid) return { score: 5, status: 'invalid' };
  
  // Start with base
  score = 40;  // Valid syntax + valid MX = 40 baseline
  
  // SPF/DMARC bonus
  if (l2.has_spf) score += 5;
  if (l2.has_dmarc) score += 5;
  
  // Catch-all handling
  if (l2.is_catch_all) {
    // Can't verify via SMTP, max score capped at 65
    score = Math.min(score + 15, 65);
    // But engagement data can push it higher
    score += l4.engagement_score_modifier;
    score = Math.max(0, Math.min(100, score));
    return { score, status: score >= 50 ? 'catch_all' : 'risky' };
  }
  
  // Layer 3 SMTP verification
  if (l3) {
    if (l3.smtp_valid === true) score += 30;
    else if (l3.smtp_valid === false) score -= 35;
    // null (unknown) adds nothing
  }
  
  // Layer 4 engagement intelligence
  score += l4.engagement_score_modifier;
  
  // Role-based penalty
  if (l1.is_role_based) score -= 15;
  
  // Free provider slight penalty for B2B
  if (l1.is_free_provider) score -= 5;
  
  // Clamp
  score = Math.max(0, Math.min(100, score));
  
  // Status mapping
  let status: string;
  if (score >= 90) status = 'valid';
  else if (score >= 70) status = 'valid';
  else if (score >= 50) status = 'risky';
  else if (score >= 20) status = 'risky';
  else status = 'invalid';
  
  return { score, status };
}
```

### 2.6 Routing Decision Matrix

| Score | Status | Email (Instantly) | LinkedIn (HeyReach) | WhatsApp (GHL) | Action |
|-------|--------|:-----------------:|:-------------------:|:--------------:|--------|
| 90-100 | Valid | ✅ Primary | Optional | Optional | Full email sequence |
| 70-89 | Valid | ✅ With monitoring | Parallel | Optional | Email + LinkedIn touch |
| 50-69 | Risky/Catch-all | ❌ Hold | ✅ Primary | ✅ Secondary | LinkedIn first, email later if engaged |
| 20-49 | Risky | ❌ No | ✅ Try | ✅ Try | Alternative channels only |
| 0-19 | Invalid | ❌ Never | ✅ If available | ✅ If available | Re-enrich for new email |

### 2.7 Caching & Expiration Strategy

| Data Type | Cache Duration | Reasoning |
|-----------|---------------|-----------|
| Layer 1 (syntax) | Permanent | Syntax doesn't change |
| Layer 2 (DNS/MX) | 7 days | DNS records change infrequently |
| Layer 2 (catch-all status) | 14 days | Catch-all config rarely changes |
| Layer 3 (SMTP verification) | 30 days | Mailboxes can be created/deleted |
| Layer 4 (engagement) | Real-time | Always check latest data |
| Full verification score | 30 days | After 30 days, re-verify before sending |

### 2.8 n8n Workflow Integration

#### Workflow 1: Queue Processor (Scheduled)
```
Trigger: Cron (every 1 minute)
→ HTTP Request: Call verify-email Edge Function with batch_size=20
→ IF: Any failures with retry_count < max_retries
  → Wait: 30 seconds
  → HTTP Request: Retry failed items
→ IF: Score < 50 for any email
  → Supabase: Update source record with "needs_enrichment" flag
  → Optional: Trigger Clay enrichment for alternative email
```

#### Workflow 2: Bounce Feedback Processor
```
Trigger: Webhook from Instantly (bounce notification)
→ Code: Parse bounce payload
→ Supabase: Insert into bounce_signals
→ Supabase: Update email_verifications score
→ IF: Hard bounce
  → Supabase: Update domain_intelligence bounce stats
  → IF: Domain bounce rate > 30%
    → Slack/Telegram: Alert "Domain {domain} flagged as problematic"
```

#### Workflow 3: Bulk Re-verification (Weekly)
```
Trigger: Cron (every Sunday 2am)
→ Supabase: SELECT emails WHERE verified_at < NOW() - INTERVAL '30 days'
  AND used_in_active_campaign = true
→ Loop: Insert each into verification_queue with priority = 8
→ Telegram: Notify "Re-verification queued: {count} emails"
```

---

## PART 3: IMPLEMENTATION SEQUENCE (Claude Code Task List)

### Phase 1: Database Foundation (Day 1)
**Task list for Claude Code:**
1. Create migration: `email_verifications` table
2. Create migration: `domain_intelligence` table
3. Create migration: `bounce_signals` table
4. Create migration: `verification_queue` table
5. Create migration: `disposable_domains` table with seed data
6. Create migration: `arabic_name_mappings` table with seed data
7. Create migration: auto-queue trigger function
8. Create migration: RLS policies for multi-tenant access
9. Seed disposable domains list (use open-source list from GitHub)
10. Seed Arabic name variants (top 50 names)

### Phase 2: Layer 1 + 2 Implementation (Day 2-3)
**Task list for Claude Code:**
1. Create Edge Function: `verify-email` (orchestrator skeleton)
2. Implement Layer 1 validation logic in orchestrator
3. Create Edge Function: `verify-layer-dns`
4. Implement MX record lookup
5. Implement SPF/DMARC detection
6. Implement catch-all detection heuristics
7. Implement provider type detection (Google/Microsoft/etc.)
8. Add domain_intelligence caching logic
9. Wire Layer 1 → Layer 2 pipeline
10. Test with 50 sample emails (mix of valid, invalid, MENA domains)

### Phase 3: Layer 3 External API (Day 4)
**Task list for Claude Code:**
1. Create Edge Function: `verify-layer-smtp`
2. Implement MillionVerifier API integration
3. Implement Reoon API as fallback
4. Add rate limiting (100 requests/minute)
5. Add cost tracking per verification
6. Wire into orchestrator with catch-all skip logic
7. Test with 20 emails that passed Layers 1+2

### Phase 4: Layer 4 Engagement + Scoring (Day 5)
**Task list for Claude Code:**
1. Create Edge Function: `verify-layer-engagement`
2. Implement bounce history lookup
3. Implement engagement history lookup (opens/clicks from Instantly data)
4. Implement domain health scoring
5. Implement composite score calculation
6. Wire Layer 4 into orchestrator
7. Implement score → status mapping
8. Test full pipeline end-to-end

### Phase 5: Queue Processing + Webhooks (Day 6)
**Task list for Claude Code:**
1. Implement queue processor in orchestrator (batch pickup)
2. Create Edge Function: `verification-webhook` for bounce intake
3. Create n8n workflow: queue processor (scheduled)
4. Create n8n workflow: bounce feedback processor
5. Create n8n workflow: weekly re-verification
6. Add pg_cron job for queue processing (fallback if n8n is down)
7. Test: scrape → queue → verify → score → route

### Phase 6: MENA Intelligence Layer (Day 7)
**Task list for Claude Code:**
1. Expand Arabic name variants to top 100 names
2. Add Gulf government domain patterns
3. Add known corporate domain patterns (Al Futtaim, Emaar, ADNOC, etc.)
4. Implement Arabic transliteration normalization
5. Add country-specific catch-all patterns
6. Test with 100 MENA-specific emails

### Phase 7: Integration + Hardening (Day 8-9)
**Task list for Claude Code:**
1. Add Instantly bounce webhook integration
2. Add HeyReach bounce/reply webhook integration
3. Implement routing decision engine (score → channel selection)
4. Add monitoring: verification success/failure rates
5. Add monitoring: API cost tracking dashboard data
6. Add monitoring: domain health alerts
7. Add error handling and retry logic throughout
8. Add rate limiting on all Edge Functions
9. Performance testing: 1000 emails batch verification

---

## PART 4: CONFIGURATION & SECRETS

### Supabase Vault Secrets Needed
```
MILLIONVERIFIER_API_KEY=mv_xxxxx
REOON_API_KEY=re_xxxxx
SMTP_VERIFICATION_PROVIDER=millionverifier  # or 'reoon'
VERIFICATION_BATCH_SIZE=20
VERIFICATION_CACHE_DAYS=30
DOMAIN_CACHE_HOURS=168  # 7 days
MAX_RETRY_COUNT=3
COST_ALERT_THRESHOLD_USD=50  # alert if daily cost exceeds this
```

### Environment Variables
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...  # for Edge Functions
N8N_WEBHOOK_URL=https://your-n8n.com/webhook/verification-complete
TELEGRAM_BOT_TOKEN=xxx  # for alerts
TELEGRAM_CHAT_ID=xxx
```

---

## PART 5: SUCCESS METRICS

| Metric | Target | Measurement |
|--------|--------|-------------|
| Bounce rate reduction | < 3% (from current ~25-40%) | Instantly campaign analytics |
| Layer 1+2 rejection rate | 40-50% of scraped emails | Verification dashboard |
| Layer 3 API cost per 1000 | < $0.30 (after L1+2 filtering) | Cost tracking table |
| Verification throughput | 1000 emails/hour | Queue processing logs |
| Cache hit rate | > 60% after 90 days | Verification cache stats |
| MENA catch-all detection | > 85% accuracy | Manual audit of Gulf domains |
| False positive rate | < 2% (emails marked valid that bounce) | Bounce correlation analysis |
| Cross-client intelligence | Measurable after 5+ clients | Network effect metrics |

---

## APPENDIX: Key Technical Notes for Claude Code

1. **Deno DNS in Edge Functions**: Supabase Edge Functions run on Deno. Use `Deno.resolveDns()` for MX/TXT record lookups. This is free and doesn't require external APIs.

2. **Edge Function timeout**: Default 60 seconds. For batch processing, process 10-20 emails per invocation and use pg_cron to call repeatedly.

3. **RLS Policies**: All tables need row-level security. Use `organization_id` to scope data. Edge Functions use service_role key to bypass RLS for cross-tenant engagement intelligence (Layer 4).

4. **Disposable domain list source**: https://github.com/disposable-email-domains/disposable-email-domains (maintained list, ~33k domains). Import as seed data.

5. **No frontend changes described here**: The only frontend change is a single checkbox (`verification_enabled`) on the scraper settings. The backend handles everything via the database trigger.

6. **Cost optimization**: The entire architecture is designed so that Layers 1 and 2 (free) eliminate as many bad emails as possible before we ever pay for Layer 3. Target: only 50-60% of scraped emails should reach Layer 3.
