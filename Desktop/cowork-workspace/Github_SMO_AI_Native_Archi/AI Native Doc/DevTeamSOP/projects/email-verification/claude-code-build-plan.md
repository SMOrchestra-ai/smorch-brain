# SalesMfast Email Verification: Claude Code Build Plan

**Purpose**: Condensed, actionable build plan for Claude Code. Backend only. Incorporates 5 architecture gap fixes identified during review. Reference `email-verification-plan.md` for full schema definitions and scoring logic.

**Stack**: Supabase (Postgres + Edge Functions/Deno) + n8n (orchestration) + Instantly (cold email) + GHL (warm/CRM)

**Benchmarks** (industry 2025-2026, used until real data calibrates Layer 4):
- Target bounce rate: <2%
- Emergency stop threshold: >5%
- Average cold email reply rate: 3.43%
- Catch-all prevalence in MENA enterprise: ~60-70%

---

## 5 ARCHITECTURE GAPS: WHAT CHANGED FROM ORIGINAL PLAN

### Gap 1: Deno DNS Limitation
**Problem**: `Deno.resolveDns()` is NOT available in Supabase Edge Functions (network restricted).
**Fix**: Use Google DNS-over-HTTPS API instead.
```
GET https://dns.google/resolve?name={domain}&type=MX
GET https://dns.google/resolve?name={domain}&type=TXT  (for SPF/DMARC)
```
**Impact**: Layer 2 DNS function must use `fetch()` to Google DNS API, not `Deno.resolveDns()`. All DNS code in the original plan needs rewriting.

### Gap 2: MillionVerifier Bulk API is Async
**Problem**: Original plan assumes synchronous bulk verification. MillionVerifier bulk API (`/bulkapi/v2/upload`) is async: you upload a CSV, get a `file_id`, then poll or receive webhook callback.
**Fix**: Two-mode Layer 3:
- **Single email** (real-time queue): Use synchronous `GET /verify?api={key}&email={email}` - works fine
- **Bulk import** (100+ emails): Upload CSV to bulk API, create n8n webhook receiver for callback, poll status at `/bulkapi/v2/status/{file_id}`
**Impact**: New Edge Function `verify-bulk-callback` + n8n workflow for bulk status polling.

### Gap 3: Instantly Bounce Webhook Inconsistency
**Problem**: Instantly doesn't reliably fire webhooks for all bounce events. Some bounces only appear in campaign analytics, not webhooks.
**Fix**: Dual ingestion strategy:
- **Primary**: Instantly webhook (when it works) for real-time bounce capture
- **Backup**: n8n scheduled job (daily) pulls bounce data via Instantly API `GET /campaigns/{id}/analytics` and cross-references against `bounce_signals` table to backfill missed webhooks
**Impact**: New n8n workflow "Instantly Bounce Backfill" runs daily.

### Gap 4: Layer 4 Bootstrapping (Chicken-and-Egg)
**Problem**: Layer 4 scores based on historical engagement/bounce data. On day 1, there's zero data, so Layer 4 returns neutral modifiers for everything, making it useless.
**Fix**: Bootstrap sequence:
1. **Day 1-7**: Layer 4 returns `engagement_score_modifier: 0` for all (neutral). Scoring relies on L1+L2+L3 only.
2. **Task in plan**: Pull historical Instantly bounce/delivery data via API and backfill into `bounce_signals` + `email_verifications` tables. This seeds Layer 4 with real data.
3. **Week 2+**: Layer 4 starts contributing meaningful modifiers as bounce_signals table populates from live webhook + daily backfill.
4. **Scoring function**: Add `l4_data_confidence` field. If <10 data points for domain, cap L4 modifier at +/-5. If 10-50, cap at +/-15. If 50+, full range +/-30.
**Impact**: New column `l4_data_confidence` in `email_verifications`. Modified scoring function. Calibration task embedded in Phase 4.

### Gap 5: Warm-up vs Invalid Bounce Correlation
**Problem**: When Instantly sending accounts are warming up, bounces happen because of sender reputation (not recipient invalidity). These false-signal bounces corrupt Layer 4 scoring.
**Fix**: Tag bounce context:
- Add `sending_account_age_days` and `is_warmup_period` fields to `bounce_signals`
- Bounces from accounts <30 days old or in active warmup get `bounce_weight: 0.3` instead of `1.0`
- Bounces from mature accounts (>90 days, warmup complete) get full `bounce_weight: 1.0`
- Layer 4 engagement modifier calculation uses weighted bounces, not raw count
**Impact**: Schema change to `bounce_signals`. Modified Layer 4 scoring logic.

---

## BUILD PHASES

### Phase 1: Database Foundation (Day 1)

All SQL migrations. Run in order via Supabase SQL Editor or CLI.

**Migration 1: Core tables**
```
File: supabase/migrations/001_email_verification_tables.sql
```
Create all 6 tables from original plan (email_verifications, domain_intelligence, bounce_signals, verification_queue, disposable_domains, arabic_name_mappings) with these modifications:

Schema changes from gap fixes:
- `email_verifications`: Add `l4_data_confidence INTEGER DEFAULT 0` after `l4_bounce_rate`
- `bounce_signals`: Add `sending_account_age_days INTEGER DEFAULT NULL`, `is_warmup_period BOOLEAN DEFAULT false`, `bounce_weight DECIMAL(3,2) DEFAULT 1.0`

**Migration 2: Indexes + RLS**
```
File: supabase/migrations/002_indexes_and_rls.sql
```
All indexes from original plan + RLS policies using `organization_id`.

**Migration 3: Auto-queue trigger**
```
File: supabase/migrations/003_auto_queue_trigger.sql
```
`fn_auto_queue_verification()` trigger function - exact code from original plan.

**Migration 4: Seed data**
```
File: supabase/migrations/004_seed_data.sql
```
- Disposable domains: fetch from `https://raw.githubusercontent.com/disposable-email-domains/disposable-email-domains/master/disposable_email_blocklist.conf` and INSERT
- Arabic name variants: top 50 names from original plan seed data
- Known MENA government domains: `.gov.ae`, `.gov.sa`, `.gov.qa`, `.gov.jo`, `.gov.kw`, `.gov.bh`, `.gov.om` pre-flagged as catch-all in `domain_intelligence`

**Validation**: Run `SELECT count(*) FROM disposable_domains;` (expect ~33k), `SELECT count(*) FROM arabic_name_mappings;` (expect 50).

---

### Phase 2: Layer 1 + Layer 2 Edge Functions (Day 2-3)

**Edge Function 1: `verify-email/index.ts`** (Orchestrator)
```
File: supabase/functions/verify-email/index.ts
```
- Accepts: `{ mode: 'single' | 'batch', email?: string, batch_size?: number }`
- Single mode: verify one email, return result
- Batch mode: pick `batch_size` items from `verification_queue` WHERE status='queued' ORDER BY priority, queued_at
- Runs L1 -> L2 -> L3 (if not catch-all) -> L4 sequentially
- Writes results to `email_verifications`
- Updates queue status to 'completed' or 'failed'
- Retry logic: on error, increment `retry_count`, reset to 'queued' if retries < max_retries

**Edge Function 2: `verify-layer-dns/index.ts`** (Layer 2)
```
File: supabase/functions/verify-layer-dns/index.ts
```
**GAP 1 FIX**: Uses Google DNS-over-HTTPS, NOT `Deno.resolveDns()`.

Core logic:
```typescript
async function lookupMX(domain: string): Promise<MXRecord[]> {
  const resp = await fetch(
    `https://dns.google/resolve?name=${domain}&type=MX`,
    { headers: { 'Accept': 'application/dns-json' } }
  );
  const data = await resp.json();
  if (data.Status !== 0 || !data.Answer) return [];
  return data.Answer
    .filter((a: any) => a.type === 15)
    .map((a: any) => {
      const parts = a.data.split(' ');
      return { priority: parseInt(parts[0]), exchange: parts[1].replace(/\.$/, '') };
    });
}

async function lookupTXT(domain: string): Promise<string[]> {
  const resp = await fetch(
    `https://dns.google/resolve?name=${domain}&type=TXT`,
    { headers: { 'Accept': 'application/dns-json' } }
  );
  const data = await resp.json();
  if (data.Status !== 0 || !data.Answer) return [];
  return data.Answer
    .filter((a: any) => a.type === 16)
    .map((a: any) => a.data.replace(/"/g, ''));
}
```

SPF check: look for TXT record starting with `v=spf1`
DMARC check: lookup `_dmarc.{domain}` TXT record
Provider detection: match MX exchanges against known patterns (google, outlook, zoho, yahoo)
Catch-all detection: MENA government TLDs auto-flagged, Exchange on-prem = higher probability
Cache: check `domain_intelligence` first, skip DNS if `dns_expires_at > NOW()`

Layer 1 logic lives inside the orchestrator (`verify-email/index.ts`), not a separate function:
- RFC 5322 regex validation
- Disposable domain check (query `disposable_domains` table)
- Role-based prefix check (info@, sales@, support@, etc. + MENA Arabic equivalents)
- Free provider check
- Arabic name variant detection (query `arabic_name_mappings`)

**Validation**: Test with 50 emails: 10 valid corporate, 10 Gmail/Yahoo, 10 invalid syntax, 10 MENA gov domains, 10 disposable. Verify L1 rejects ~20, L2 correctly identifies MX/catch-all.

---

### Phase 3: Layer 3 External API (Day 4)

**Edge Function 3: `verify-layer-smtp/index.ts`**
```
File: supabase/functions/verify-layer-smtp/index.ts
```

**GAP 2 FIX**: Two verification modes.

**Single email mode** (called from queue processor):
```typescript
async function verifySingle(email: string): Promise<Layer3Result> {
  const apiKey = Deno.env.get('MILLIONVERIFIER_API_KEY');
  const resp = await fetch(
    `https://api.millionverifier.com/api/v3/verify?api=${apiKey}&email=${encodeURIComponent(email)}`
  );
  const data = await resp.json();
  // Map: "ok" -> true, "catch_all" -> null, "unknown" -> null, "disposable"/"invalid" -> false
  return mapMillionVerifierResponse(data);
}
```

**Bulk mode** (called from n8n for large imports):
```typescript
async function verifyBulk(emails: string[]): Promise<{ fileId: string }> {
  // 1. Create CSV in memory
  // 2. POST to https://api.millionverifier.com/api/v3/bulkapi/v2/upload
  // 3. Return file_id for status polling
}

async function checkBulkStatus(fileId: string): Promise<BulkStatus> {
  // GET https://api.millionverifier.com/api/v3/bulkapi/v2/status/{fileId}
  // Returns: { status: 'processing' | 'completed', percent: number }
}

async function downloadBulkResults(fileId: string): Promise<BulkResult[]> {
  // GET https://api.millionverifier.com/api/v3/bulkapi/v2/download/{fileId}
  // Parse CSV results, map to Layer3Result[]
}
```

**Fallback**: If MillionVerifier returns 5xx or timeout, retry once, then fall back to Reoon:
```
GET https://api.reoon.com/api/v1/verify?email={email}&key={key}&mode=quick
```

Rate limiting: Track API calls in memory, max 100/minute for MillionVerifier.
Cost tracking: After each API call, INSERT into a `verification_costs` tracking query (or just log to `l3_smtp_raw_response` with cost field).
Skip rule: If `domain_intelligence.is_catch_all = true`, skip Layer 3 entirely (save money).

**New Edge Function for bulk callback**:
```
File: supabase/functions/verify-bulk-callback/index.ts
```
- Webhook endpoint that MillionVerifier calls when bulk job completes
- Parses results, updates `email_verifications` for each email
- Updates `verification_queue` status to 'completed'

**Validation**: Verify 20 emails via single mode. Confirm MillionVerifier response mapping is correct. Test fallback by temporarily using wrong API key.

---

### Phase 4: Layer 4 Engagement + Scoring + Calibration (Day 5-6)

**Edge Function 4: `verify-layer-engagement/index.ts`**
```
File: supabase/functions/verify-layer-engagement/index.ts
```

**GAP 4 FIX**: Confidence-gated scoring.
**GAP 5 FIX**: Weighted bounce calculation.

```typescript
async function checkEngagement(email: string, domain: string): Promise<Layer4Result> {
  // 1. Query bounce_signals for this email
  const bounces = await supabase
    .from('bounce_signals')
    .select('bounce_type, bounce_weight, bounced_at')
    .eq('email_normalized', normalizeEmail(email));

  // 2. Calculate WEIGHTED bounce count (Gap 5 fix)
  const weightedBounces = bounces.reduce((sum, b) => sum + (b.bounce_weight || 1.0), 0);
  const hardBounces = bounces.filter(b => b.bounce_type === 'hard');
  const weightedHardBounces = hardBounces.reduce((sum, b) => sum + (b.bounce_weight || 1.0), 0);

  // 3. Query domain-level stats
  const domainStats = await supabase
    .from('domain_intelligence')
    .select('total_emails_checked, total_bounces, domain_bounce_rate')
    .eq('domain', domain)
    .single();

  // 4. Calculate data confidence (Gap 4 fix)
  const dataPoints = (domainStats?.total_emails_checked || 0) + bounces.length;
  let confidenceCap: number;
  if (dataPoints < 10) confidenceCap = 5;       // Very low data: cap modifier at +/-5
  else if (dataPoints < 50) confidenceCap = 15;  // Some data: cap at +/-15
  else confidenceCap = 30;                        // Good data: full range

  // 5. Calculate raw modifier using scoring table from original plan
  let rawModifier = 0;
  // ... (apply engagement scoring rules from original plan)
  // Recent open (<30d): +25, Recent click: +30, etc.
  // Hard bounce: -40 * bounce_weight, Multiple bounces: -80 * avg_bounce_weight

  // 6. Cap modifier by confidence
  const engagement_score_modifier = Math.max(-confidenceCap, Math.min(confidenceCap, rawModifier));

  return {
    has_engagement: bounces.length > 0 || /* has opens/clicks */,
    engagement_score_modifier,
    l4_data_confidence: dataPoints,
    // ... rest of fields
  };
}
```

**Composite scoring function**: Same as original plan but saves `l4_data_confidence` to `email_verifications`.

**CALIBRATION TASK (embedded)**: Pull historical Instantly bounce data.

This is the task we deferred from data-gathering. Execute as part of Phase 4:

```
n8n Workflow: "Instantly Historical Bounce Backfill"
1. Trigger: Manual (run once during build)
2. HTTP Request: GET /api/v2/campaigns (list all campaigns)
3. Loop: For each campaign:
   a. GET /api/v2/campaigns/{id}/analytics
   b. Extract: bounced leads with email, bounce type, timestamp
   c. GET /api/v2/campaigns/{id}/leads?status=bounced
4. Code Node: Transform to bounce_signals format
   - Set bounce_source = 'instantly'
   - Set bounce_type = 'hard' or 'soft' based on Instantly data
   - Set is_warmup_period based on campaign age vs account creation date
   - Set bounce_weight: 0.3 if warmup, 1.0 if mature
5. Supabase: Bulk INSERT into bounce_signals
6. Supabase: UPDATE domain_intelligence aggregate stats
7. Log: Total bounces imported, domains affected
```

If Instantly MCP tools are still broken at build time, use Instantly REST API directly from n8n HTTP Request nodes (API key auth).

**Also pull**: Campaign-level delivery/open data to seed `email_verifications` L4 fields for emails that have been previously sent to successfully.

**Validation**: After backfill, run `SELECT domain, count(*), avg(bounce_weight) FROM bounce_signals GROUP BY domain ORDER BY count(*) DESC LIMIT 20;` to verify data quality. Check that warmup-period bounces have weight 0.3.

---

### Phase 5: Queue Processing + Webhook Infrastructure (Day 7)

**Edge Function 5: `verification-webhook/index.ts`** (Bounce intake)
```
File: supabase/functions/verification-webhook/index.ts
```
- Accepts POST from Instantly, HeyReach, GHL with bounce/delivery events
- Validates webhook signature/source
- Parses payload per source format
- **GAP 5**: Enriches with `sending_account_age_days` and `is_warmup_period`:
  - Query Instantly account data to get account creation date
  - If account age <30 days OR warmup_status=active: `bounce_weight = 0.3`
  - Else: `bounce_weight = 1.0`
- INSERTs into `bounce_signals`
- Updates `email_verifications` score for affected email
- Updates `domain_intelligence` aggregate stats
- If domain bounce rate spikes >30%: trigger alert

**n8n Workflows to build:**

**Workflow 1: Queue Processor** (replaces pg_cron)
```
Trigger: Cron every 1 minute
-> HTTP Request: POST verify-email Edge Function { mode: 'batch', batch_size: 20 }
-> IF response has failures with retry_count < max
   -> Wait 30s -> Retry
-> IF any score < 50
   -> Flag for alternative channel routing
```

**Workflow 2: Bounce Feedback (Real-time)**
```
Trigger: Webhook (Instantly calls this)
-> Code: Parse Instantly bounce payload
-> HTTP Request: POST verification-webhook Edge Function
-> IF hard bounce
   -> Check domain stats
   -> IF domain bounce rate >30%: Send Telegram alert
```

**Workflow 3: Instantly Bounce Backfill (Daily)** - GAP 3 FIX
```
Trigger: Cron daily at 3am
-> HTTP Request: GET Instantly campaigns list
-> Loop each active campaign:
   -> GET campaign analytics (last 24h)
   -> Compare bounces against bounce_signals table
   -> INSERT any missing bounce records
-> Log: "Backfilled {n} missed bounces"
```

**Workflow 4: Weekly Re-verification**
```
Trigger: Cron Sunday 2am
-> Supabase: SELECT emails WHERE verified_at < NOW() - 30 days AND in active campaign
-> Loop: INSERT into verification_queue with priority=8
-> Telegram: "Re-verification queued: {count} emails"
```

**Workflow 5: Bulk Verification Status Poller** - GAP 2 FIX
```
Trigger: Webhook (called when bulk upload initiated)
-> Wait 60s
-> Loop:
   -> HTTP Request: GET MillionVerifier bulk status
   -> IF status = 'completed': download results, update DB, break
   -> IF percent < 100: Wait 120s, continue loop
-> Process results: update email_verifications + verification_queue
```

**Validation**:
- Import 100 test emails via scraper trigger
- Verify they auto-queue (trigger fires)
- Watch queue processor pick them up
- Confirm L1->L2->L3->L4 pipeline runs
- Confirm results appear in `email_verifications`
- Simulate a bounce webhook, verify it lands in `bounce_signals`

---

### Phase 6: MENA Intelligence + Routing Engine (Day 8)

**MENA Intelligence** (extend existing Edge Functions):

1. Expand `arabic_name_mappings` to top 100 names
2. Add Gulf corporate domain patterns to `domain_intelligence`:
   - Al Futtaim Group, Majid Al Futtaim, Emaar, ADNOC, Saudi Aramco, QatarEnergy, SABIC, Etisalat, du, STC, Zain, etc.
   - Pre-classify as corporate, set expected provider_type
3. Add Arabic transliteration normalization function:
   ```typescript
   function normalizeArabicEmail(localPart: string): string[] {
     // Given "m.alamouri" check against arabic_name_mappings
     // Return all possible variants: ["m.alamouri", "m.alamori", "mamoun.alamouri", ...]
   }
   ```
4. Country-specific catch-all heuristics:
   - UAE `.ae` government: 95% catch-all confidence
   - Saudi `.sa` government: 90% catch-all confidence
   - Qatar `.qa` government: 95% catch-all confidence
   - Jordan `.jo` government: 70% catch-all confidence

**Routing Decision Engine** (new Edge Function or add to orchestrator):
```
File: supabase/functions/route-decision/index.ts (or add to verify-email)
```

```typescript
function routeEmail(score: number, status: string, domain_intel: DomainIntel): RoutingDecision {
  if (score >= 90) return {
    channels: ['instantly'],
    priority: 'high',
    action: 'full_email_sequence'
  };
  if (score >= 70) return {
    channels: ['instantly', 'heyreach'],
    priority: 'medium',
    action: 'email_with_linkedin_parallel'
  };
  if (score >= 50) return {
    channels: ['heyreach', 'ghl_whatsapp'],
    priority: 'medium',
    action: 'linkedin_first_email_after_engagement'
  };
  if (score >= 20) return {
    channels: ['heyreach', 'ghl_whatsapp'],
    priority: 'low',
    action: 'alternative_channels_only'
  };
  return {
    channels: ['re_enrich'],
    priority: 'low',
    action: 'find_alternative_contact'
  };
}
```

After routing decision, write result to `email_verifications` (add `routing_decision JSONB` column) so downstream n8n workflows can read it and push to the right platform.

**Validation**: Run 100 MENA-specific emails through full pipeline. Check:
- Government domains get catch-all flag
- Arabic name variants detected
- Corporate domains classified correctly
- Routing decisions match expected score->channel mapping

---

### Phase 7: Integration Hardening + Monitoring (Day 9)

1. **Error handling**: Every Edge Function gets try/catch with structured error logging to a `verification_errors` table (or just JSONB field in queue)
2. **Rate limiting**: Add rate limit middleware to all Edge Functions (use Deno KV or simple in-memory counter)
3. **Cost monitoring**: After each L3 API call, track cumulative daily cost. If >$50/day, pause queue processing and alert.
4. **Monitoring n8n workflow**:
   ```
   Trigger: Cron every 6 hours
   -> Query: SELECT overall_status, count(*) FROM email_verifications WHERE created_at > NOW() - 24h GROUP BY overall_status
   -> Query: SELECT avg(overall_score), min(overall_score), max(overall_score) FROM email_verifications WHERE created_at > NOW() - 24h
   -> Query: SELECT sum(cost) FROM verification costs WHERE created_at > NOW() - 24h
   -> Telegram: Daily verification stats summary
   ```
5. **Performance test**: Batch 1000 emails through queue, measure throughput. Target: 1000/hour.
6. **Edge Function timeout handling**: If verification takes >50s (approaching 60s limit), save partial results and re-queue remaining layers.

---

## QUICK REFERENCE: FILES TO CREATE

```
supabase/
  migrations/
    001_email_verification_tables.sql
    002_indexes_and_rls.sql
    003_auto_queue_trigger.sql
    004_seed_data.sql
  functions/
    verify-email/index.ts              # Main orchestrator + L1 logic
    verify-layer-dns/index.ts          # L2: Google DNS-over-HTTPS
    verify-layer-smtp/index.ts         # L3: MillionVerifier + Reoon
    verify-layer-engagement/index.ts   # L4: Weighted engagement scoring
    verification-webhook/index.ts      # Bounce intake from Instantly/HeyReach/GHL
    verify-bulk-callback/index.ts      # MillionVerifier bulk job callback
    route-decision/index.ts            # Score -> channel routing (optional, can be in orchestrator)
```

```
n8n workflows (5):
  1. verification-queue-processor      # Cron 1min: picks from queue, calls verify-email
  2. bounce-feedback-realtime          # Webhook: Instantly bounce -> bounce_signals
  3. instantly-bounce-backfill-daily   # Cron 3am: backfill missed bounces from API
  4. weekly-reverification             # Cron Sunday 2am: re-queue stale verifications
  5. bulk-verification-poller          # Webhook-triggered: poll MillionVerifier bulk status
  + CALIBRATION (run once):
  6. instantly-historical-backfill     # Manual: pull all historical bounce data to seed L4
```

## CONFIGURATION NEEDED BEFORE BUILD

```
Supabase Vault Secrets:
  MILLIONVERIFIER_API_KEY=mv_xxxxx
  REOON_API_KEY=re_xxxxx

Environment Variables:
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_SERVICE_ROLE_KEY=eyJ...
  INSTANTLY_API_KEY=xxx              # For bounce backfill workflows
  N8N_WEBHOOK_URL=https://your-n8n/webhook/...
  TELEGRAM_BOT_TOKEN=xxx
  TELEGRAM_CHAT_ID=xxx
```

## BUILD ORDER FOR CLAUDE CODE

Start here. Each phase depends on the previous:

1. **Phase 1** -> Run migrations, verify tables exist, verify seed data
2. **Phase 2** -> Build + deploy verify-email + verify-layer-dns, test L1+L2 with sample emails
3. **Phase 3** -> Build + deploy verify-layer-smtp + verify-bulk-callback, test L3 with real MillionVerifier API
4. **Phase 4** -> Build + deploy verify-layer-engagement, run Instantly historical backfill, test L4 scoring
5. **Phase 5** -> Build + deploy verification-webhook, create all n8n workflows, test full pipeline
6. **Phase 6** -> Expand MENA data, build routing engine, test with MENA emails
7. **Phase 7** -> Error handling, monitoring, performance test at scale

Total: 9 days if full-time. Can parallelize Phase 6 with Phase 5.
