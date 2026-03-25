# Clay Troubleshooting Guide

## COMMON ERRORS & FIXES

| Error | Cause | Fix |
|-------|-------|-----|
| "Rate limit exceeded" | API provider rate cap hit | Reduce batch size to 50-100 rows; add 500ms delay between requests |
| "Webhook 50K limit reached" | Cumulative submission cap per table | Create new webhook table; archive old rows to external DB |
| "Enrichment timeout" | Complex query or slow API endpoint | Simplify formula; reduce waterfall depth; break into smaller batches |
| "Column limit reached" | 72 columns per table (hard limit) | Delete unused columns; archive to external DB; split into multiple tables |
| "No results" on valid leads | Provider coverage gap for that region | Add second/third provider to waterfall; check if region is covered |
| "Wrong LinkedIn URL" | Fuzzy name matching → false positive | Add AI Formula to validate company name vs LinkedIn company; use domain cross-check |
| "Row limit exceeded" | 50K rows per table max | Archive processed rows; split by date range or region |
| "Enrichment columns full" | 30 enrichment column limit | Delete completed enrichments; use fewer waterfall steps; consolidate columns |
| 400 Bad Request (HTTP API) | Missing required fields in POST body | Check all required fields present; test with single row first |
| 401 Unauthorized (HTTP API) | Invalid or expired API key | Regenerate API key; verify Bearer token format in headers |
| 429 Too Many Requests (HTTP API) | Rate limit on destination API | Add 2-second delay; batch to 100/minute; use n8n for throttling |
| Empty cells after enrichment | Provider found nothing; OR conditional run blocked | Check "Run Info" to see if provider ran; verify conditional logic |
| Credits burning faster than expected | Auto-update on; OR failed lookups still costing | Turn off auto-update; add pre-filter AI Formula; check for duplicate enrichment runs |

---

## CATCH-ALL EMAIL HANDLING

### What Are Catch-All Emails?

A catch-all domain accepts mail to ANY address (anyone@domain.com, garbage@domain.com). The email "exists" but the person may not.

### Detection

ZeroBounce returns:
- Status: "valid"
- Sub-status: "catch_all"

### Risk Level

40-60% of catch-all emails are wrong/inactive. Sending to them:
- Increases bounce rate (domain damage)
- Wastes Instantly sending capacity
- Can trigger spam filters

### Handling Strategy

**Option A: Skip (Conservative)**
- Filter out all catch-all emails
- Only send to "valid + NOT catch_all"
- Safest for sender reputation
- Loses 10-20% of potential contacts

**Option B: Separate Segment (Recommended)**
- Create separate Instantly campaign for catch-all emails
- Settings: 1 email only (no follow-ups)
- Lower daily send volume (5-10/day per domain)
- Monitor bounce rate separately
- If bounce rate >3%, pause immediately
- Use most-warmed domains only

**Option C: Verify with Second Provider**
- Run catch-all emails through a second verification tool
- If both say "valid" → send cautiously
- If second says "invalid" → skip
- Extra cost: 0.5-1 credit per email
- Reduces risk but doesn't eliminate it

### Clay Implementation

```
Step 1: Email waterfall (find emails)
Step 2: ZeroBounce verification
Step 3: AI Formula:
  - If status = "valid" AND sub_status != "catch_all" → "safe_to_send"
  - If status = "valid" AND sub_status = "catch_all" → "catch_all_risky"
  - If status = "invalid" → "do_not_send"
Step 4: Conditional push:
  - "safe_to_send" → Instantly Campaign A (normal)
  - "catch_all_risky" → Instantly Campaign B (low volume, 1 touch)
  - "do_not_send" → Skip
```

---

## LINKEDIN URL MISMATCH FIXES

### The Problem

Clay's LinkedIn URL matching uses fuzzy name matching. Generic company names cause false positives:
- "Zoe" → finds linkedin.com/company/zoe/ (wrong)
- Should find: linkedin.com/company/joinzoe/ (correct)

### Detection

AI Formula to flag mismatches:

```
"Compare these two data points:
- Company name: {{company_name}}
- Company domain: {{company_domain}}
- LinkedIn URL: {{linkedin_url}}

Check: Does the LinkedIn URL plausibly belong to this company?
Signs of mismatch:
- LinkedIn URL contains a completely different company name
- LinkedIn company has <10 employees but company claims 500+
- Industry mismatch between LinkedIn page and company website

Return: 'match' or 'mismatch' or 'uncertain'"
```

### Fix Options

1. **Manual override:** If you know the correct LinkedIn URL, paste it and "Lock" the column to prevent overwrite
2. **Claygent verification:** Use Claygent to visit company website, find their actual LinkedIn page
3. **Domain-based lookup:** Use LinkedIn company search by domain instead of name
4. **Skip enrichment:** If LinkedIn URL is uncertain, skip LinkedIn-based enrichments to avoid wrong data

### Prevention

- Always validate LinkedIn URLs BEFORE using them for HeyReach campaigns
- Never auto-push to HeyReach without URL validation step
- For generic company names, manual research is more reliable than automated matching

---

## CLAYGENT HALLUCINATION MITIGATION

### Common Hallucinations

| What Claygent Invents | How Often | Impact |
|----------------------|-----------|--------|
| LinkedIn URLs | Very common | Wrong person contacted |
| Company revenue figures | Common | Bad qualification decisions |
| Employee counts | Occasional | Incorrect ICP scoring |
| Executive names | Occasional | Embarrassing personalization |
| Funding amounts | Occasional | Wrong signal classification |
| Email addresses | Rare but dangerous | Bounced emails, reputation damage |

### Mitigation Strategy

**Layer 1: Prompt Engineering**
- Always include source URL (company website) in prompt
- Ask for source citation: "Provide the URL where you found this information"
- Use structured output formats (pipe-delimited) to force concise answers
- Add explicit instruction: "If you cannot verify this, return 'unknown'. Do NOT guess."

**Layer 2: Post-Enrichment Validation**
- Run AI Formula (FREE) to cross-check Claygent output against known data
- Flag rows where Claygent confidence seems low
- Sample 10% of Claygent-enriched rows for manual verification

**Layer 3: Never Use Unverified Data in Outreach**
- Claygent data should feed SCORING, not PERSONALIZATION directly
- For personalization hooks: verify the specific data point is real
- For contact data (email, phone): always run through verification waterfall

**Layer 4: Limit Claygent Usage**
- Use Claygent for 5-10% of list (high-value accounts only)
- Use traditional enrichment providers for the other 90-95%
- Claygent is a research tool, not a bulk enrichment tool

---

## PERFORMANCE AT SCALE (10K+ ROWS)

### Symptoms of Performance Degradation

- Table takes 5-15 seconds to load
- Enrichment runs take 10-30+ minutes
- Browser becomes sluggish
- Formulas timeout on large datasets
- Multiple enrichment runs queuing and blocking each other

### Root Causes

1. **Too many rows in one table** (>10K = noticeable, >50K = limit)
2. **Too many enrichment columns** (>20 = slow, >30 = limit)
3. **Complex conditional logic** on large datasets
4. **Multiple simultaneous enrichment runs**
5. **Auto-update enabled** (runs on every new row)

### Fixes

**Fix 1: Split Tables by Purpose**
Instead of one mega-table:
```
Master Accounts (firmographic data only) — 50K max
  ↓ Filter: ICP fit > 60
Contact Discovery (people at qualified accounts) — 10K batches
  ↓ Filter: email found + verified
Campaign Routing (ready for outbound) — 5K batches
  ↓ Push to Instantly/HeyReach
Results Tracking (reply data from webhooks) — rolling
```

**Fix 2: Archive Processed Rows**
- Export completed enrichment batches to Google Sheets, Retool, or Supabase
- Delete from Clay table after export
- Keep Clay tables lean (<10K rows for best performance)

**Fix 3: Batch Processing**
```
Instead of: 10,000 rows enriched at once
Better: 5 batches × 2,000 rows

Benefits:
- Faster per-batch processing
- Easier error identification
- Can pause between batches
- Won't timeout
```

**Fix 4: Reduce Column Count**
- Delete columns from completed enrichment steps
- Consolidate related data into single columns (pipe-delimited)
- Use AI Formula to merge columns, then delete originals
- Target: <50 columns per active table

**Fix 5: Disable Auto-Update**
- Turn OFF "auto-update" on all enrichment columns
- Run enrichment manually when you're ready
- Prevents surprise credit burns on new rows
- Only re-enable for specific scheduled runs

---

## DATA FRESHNESS ISSUES

### The Problem

Clay's data sources have varying refresh cycles:

| Source | Freshness | Impact |
|--------|-----------|--------|
| LinkedIn profiles | 1-7 day lag | Job titles may be outdated |
| Company employee lists | 2 weeks | May show departed employees |
| Job change signals | 7-30 day lag | Late detection vs competitors |
| LinkedIn job posts | 30+ days stale | Hiring data often outdated |
| Company firmographics | 30-60 days | Revenue/headcount estimates lag |
| Third-party databases | 30-90 days | Contact data decays ~2.5%/month |

### Mitigation

1. **Don't rely on Clay for real-time signals** — combine with intent tools (RB2B, Warmly) for live buying signals
2. **Re-verify before outreach** — run verification waterfall on any data >30 days old
3. **Use Claygent for spot-checks** — verify job title/company for high-value accounts before outreach
4. **Accept decay rate** — B2B contact data decays ~2.5% per month (30% per year). Budget for re-enrichment quarterly.
5. **Timestamp everything** — add "enrichment_date" column to every table. Filter out data older than 90 days for outreach.

---

## WEBHOOK 50K LIMIT MANAGEMENT

### The Problem

Clay webhook tables have a 50K cumulative submission limit. This is LIFETIME, not rolling. Once hit, the webhook stops accepting data.

### Detection

- Check table row count in Clay UI
- If approaching 50K total submissions (including deleted rows), plan migration

### Prevention Strategy

```
Monthly rotation:
1. Create new webhook table at start of each month
2. Update webhook URL in source tools (n8n, Instantly, etc.)
3. Archive previous month's table to external database
4. Delete old table from Clay (or keep as read-only reference)

Naming convention: webhook_leads_2026_02, webhook_leads_2026_03, etc.
```

### If You Hit the Limit

1. Create new table with same column structure
2. Create new webhook URL
3. Update all source tools with new webhook URL
4. Archive old table data
5. Document the rotation in your SOP

---

## CREDIT BURN DIAGNOSTICS

### "Why Are My Credits Disappearing?"

**Step 1: Check Run History**
- Click any enrichment column → "Run Info"
- Shows credits consumed per run
- Identify which columns are most expensive

**Step 2: Check for Auto-Update**
- Settings on each enrichment column
- If auto-update = ON, every new row triggers enrichment
- Turn OFF immediately if unexpected

**Step 3: Check for Duplicate Runs**
- Same enrichment column running multiple times?
- Conditional logic not working → enriching rows that should be skipped?
- Multiple users triggering same enrichment?

**Step 4: Check Failed Enrichments**
- Failed lookups STILL COST credits
- If waterfall is failing on 50%+ of rows → wrong provider for your region
- Reorder waterfall or remove underperforming providers

**Step 5: Audit Claygent Usage**
- Claygent at 5-20 credits per query burns fast
- Running Claygent on 100% of rows = budget destroyer
- Limit to 5-10% of list (high-value accounts only)

### Quick Fix Checklist

- [ ] Auto-update disabled on all enrichment columns
- [ ] BYO OpenAI API key configured
- [ ] Conditional runs filtering before paid enrichment
- [ ] Waterfall ordered cheapest-first
- [ ] Claygent limited to <10% of rows
- [ ] Verification running BEFORE Instantly push
- [ ] Tables under 10K rows for performance
- [ ] Monthly webhook table rotation scheduled
