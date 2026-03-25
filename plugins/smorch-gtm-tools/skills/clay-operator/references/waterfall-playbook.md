# Waterfall Enrichment Playbook

## HOW WATERFALLS ACTUALLY WORK

Clay waterfalls cascade through providers sequentially:
1. **Stop-when-found:** Only charges the provider that succeeds
2. **Failed attempts still cost:** If a provider runs but finds nothing, you pay
3. **Validation failures continue:** If email found but validation fails, next provider fires
4. **Full exhaust = worst case:** If nothing found, all providers charged

**Rule #1:** Cheapest providers FIRST. Always.
**Rule #2:** Test on 10 rows before running 10,000.
**Rule #3:** Turn OFF auto-update to prevent runaway credit burn.
**Rule #4:** Use conditional runs (FREE) to pre-filter before paid enrichment.
**Rule #5:** Accept coverage gaps. 80% verified > 100% garbage.

---

## EMAIL WATERFALL BY REGION

### US/Canada (85-95% coverage target)

```
1. Datagma (1 credit) — ~30-35% hit rate
2. Hunter (2 credits) — ~60% cumulative
3. RocketReach (2 credits) — ~75% cumulative
4. People Data Labs (2 credits) — ~85-95% final
```

**Expected:** 850-950/1000 emails found
**Avg credits per success:** 2.5-3.0
**Cost per 1K leads on Explorer:** ~$87-105

### UK/Ireland (70-85% coverage target)

```
1. Hunter (2 credits) — ~55% hit rate
2. Prospeo (2 credits) — ~70% cumulative
3. Cognism (2-3 credits) — ~80-85% cumulative
```

**Expected:** 700-850/1000 emails found
**Avg credits per success:** 3.0-3.5

### Western Europe (60-80% coverage target)

```
1. Prospeo (2 credits) — ~40% hit rate (strong EU)
2. Hunter (2 credits) — ~60% cumulative
3. Cognism (2-3 credits) — ~75% cumulative
4. Findymail (2 credits) — ~80% final
```

**Notes:**
- Germany/France/Switzerland: Lower coverage, add Cognism
- Netherlands/Nordics: Hunter performs better (~55%)
- GDPR: Cognism is GDPR-compliant (important for EU)

### MENA/Gulf (20-40% coverage — REALITY CHECK)

```
1. Apollo (2 credits) — ~15-25% hit rate
2. Hunter (2 credits) — ~25-35% cumulative
3. Claygent research (5-20 credits) — ~35-45% cumulative
4. LinkedIn manual research — fills remaining gaps
```

**Expected:** 200-400/1000 emails found via waterfall
**Avg credits per success:** 8-15 (expensive)
**Critical:** Plan for HYBRID approach:
- Clay for what it finds (~30-40%)
- LinkedIn URL enrichment → HeyReach for outreach
- Phone + WhatsApp (via GHL) as PRIMARY channel for Gulf
- Manual research for top 50-100 high-value accounts

**Why MENA coverage is low:**
- Fewer public business directories
- Lower LinkedIn adoption in some markets
- Arabic names skipped/mangled by Western tools
- Many businesses use Gmail/Hotmail (no custom domain)
- Catch-all domains more common

### APAC (50-75% coverage target)

```
1. RocketReach (2 credits) — ~40% hit rate (strong APAC)
2. Apollo (2 credits) — ~55% cumulative
3. Hunter (2 credits) — ~65% cumulative
```

**Regional variance:**
- Japan/Singapore: 80%+ coverage
- India: 60-70%
- Southeast Asia: 40-50%
- China: Very limited (10-20%)

### Cost-Conscious Waterfall (Budget Mode)

```
1. Datagma (1 credit) — ~30% hit rate
2. Hunter (2 credits) — ~60% cumulative
3. Apollo (2 credits) — ~75% cumulative
```

Stops at 75% coverage. Saves 1,250+ credits per 1K leads vs full waterfall.

---

## PHONE NUMBER WATERFALL

Phone is EXPENSIVE and LOW COVERAGE. Use only for high-intent accounts.

**Strategy:** Don't waterfall phone aggressively. Reserve for top 10-20% of accounts.

```
Step 1: Complete email waterfall first (get 70-85%)
Step 2: For TOP accounts only → Phone waterfall:
  - Apollo Phone (2 credits) — 25-35% coverage
  - ClearoutPhone (2 credits) — carrier & location validation
  - Selligence (13 credits) — highest accuracy, specialized
  - ContactOut (15 credits) — good for 1:1 research
```

**Coverage reality:**
| Region | Phone Coverage |
|--------|---------------|
| US | 15-25% |
| UK | 12-20% |
| Western EU | 8-15% |
| MENA | 2-5% |
| APAC | 5-10% |

**MENA phone strategy:** Use GHL WhatsApp as primary channel. Phone enrichment ROI is terrible for MENA.

---

## COMPANY DATA WATERFALL

```
1. Apollo (2 credits) — firmographics, tech stack, headcount
2. Clearbit (2 credits) — technology, industry categorization
3. Crunchbase (2 credits) — funding, investors, recent news
4. LinkedIn Company Research (2-3 credits) — headcount changes, recent hires
5. Claygent (5-20 credits) — custom web scraping for specific fields
```

**Use Claygent LAST and only for 5-10% of list** (spot-checks on high-value accounts).

---

## LINKEDIN URL WATERFALL

Critical for HeyReach integration (requires LinkedIn URL):

```
1. People Data Labs (2 credits) — ~85% coverage
2. Apollo (2 credits) — ~80% coverage
3. RocketReach (2 credits) — ~75% coverage
4. Hunter (2 credits) — ~70% coverage
```

**Common issue:** Clay returns WRONG LinkedIn company URL for generic names.
- Company "Zoe" → finds linkedin.com/company/zoe/ (generic, wrong)
- Should be: linkedin.com/company/joinzoe/ (correct)
- **Fix:** Add AI Formula validation step to cross-check domain vs LinkedIn URL

---

## EMAIL VERIFICATION WATERFALL

Run AFTER finding emails, BEFORE pushing to Instantly:

```
1. ZeroBounce (0.5-1 credit) — bounce detection + spam trap
2. Emaillistverify (0.5 credit) — cost-effective double-check
```

**Interpretation guide:**
| Status | Action |
|--------|--------|
| Valid + safe_to_send | Send normally |
| Valid + catch_all | Separate segment: low-volume, high-personalization only |
| Invalid | Remove from list |
| Do_not_mail | Remove from list |
| Unknown | Skip or recheck with second provider |

**Catch-all handling:**
- 40-60% of catch-all emails are wrong/inactive
- Create separate campaign: 1 email only, no follow-ups
- Send with lower frequency from warmed domains
- Track bounce rate separately; pause if >3%

---

## CREDIT MATH CALCULATOR

### Quick Reference: Cost Per 1K Leads

| Enrichment Level | Credits/Lead | Explorer Cost | Pro Cost |
|-----------------|-------------|--------------|---------|
| Email only (3-provider) | 3-5 avg | $105-175 | $48-80 |
| Email + Company | 5-7 avg | $175-245 | $80-112 |
| Email + Company + Phone | 9-12 avg | $315-420 | $144-192 |
| Full enrichment + Claygent | 12-20 avg | $420-700 | $192-320 |
| MENA full enrichment | 15-25 avg | $525-875 | $240-400 |

### Realistic Agency Scenarios

**Scenario 1: US SMB Cold Email (500 leads/week)**
- Email waterfall: 500 × 3 avg = 1,500 credits
- Company enrichment: 500 × 2 = 1,000 credits
- Verification: 500 × 0.5 = 250 credits
- **Weekly total: 2,750 credits**
- **Monthly: ~11,000 credits → Explorer plan sufficient**

**Scenario 2: Enterprise ABM (100 accounts, 5 contacts each)**
- Find 500 contacts: 500 × 2 = 1,000 credits
- Email waterfall: 500 × 4 = 2,000 credits
- Phone (top 100): 100 × 5 = 500 credits
- Company enrichment: 100 × 3 = 300 credits
- Claygent research (top 50): 50 × 10 = 500 credits
- **Total: 4,300 credits → Explorer plan covers ~2 campaigns/month**

**Scenario 3: MENA Outbound (1,000 leads/month)**
- Email waterfall: 1,000 × 8 avg = 8,000 credits (lower hit rate = more attempts)
- Company data: 1,000 × 2 = 2,000 credits
- Claygent (top 200): 200 × 15 = 3,000 credits
- LinkedIn URL: 1,000 × 2 = 2,000 credits
- **Total: 15,000 credits → Pro plan needed**
- **Per-lead cost: ~$2.40 (Pro)**

**Scenario 4: Agency managing 5 clients (10K leads/month total)**
- Email waterfall: 10,000 × 4 = 40,000 credits
- Company: 10,000 × 2 = 20,000 credits
- Verification: 10,000 × 0.5 = 5,000 credits
- **Total: 65,000 credits → Pro plan + overage OR Enterprise**

---

## WATERFALL OPTIMIZATION TACTICS

### Tactic 1: Pre-Filter with FREE AI Formulas

Before running paid enrichment:
```
AI Formula: "If company_size < 10 employees, return 'skip'. Otherwise return 'enrich'."
```
Conditional run: Only enrich rows where AI Formula = "enrich"
**Savings:** 30-50% credit reduction on disqualified rows.

### Tactic 2: Reorder by Regional Performance

Don't use one waterfall for all regions. Segment by geography:
- Create separate tables or conditional runs per region
- US table → Datagma-first waterfall
- EU table → Prospeo-first waterfall
- MENA table → Apollo-first + Claygent fallback

### Tactic 3: "Only Run If" Conditions

Set conditions on each enrichment column:
- "Only run if email is empty" (prevents re-enriching)
- "Only run if company_size > 50" (focus on ICP)
- "Only run if region = US" (geo-targeting)

### Tactic 4: Test in Sandbox Mode

**Before running full table:**
1. Add 10 rows in Sandbox view
2. Build complete waterfall
3. Click "Run" — check cost estimate
4. Look at "Run Info" after completion
5. Calculate: cost per successful result
6. Extrapolate to full list: (rows × per-lead cost)
7. Compare to budget threshold
8. Reorder providers if first provider underperforms

### Tactic 5: BYO API Keys (Biggest Lever)

| Action | Clay Credits | BYO API Cost | Savings |
|--------|------------|-------------|---------|
| Claygent research | ~1¢/call | ~$0.0003/call | 30-35x |
| Prospeo direct API | 2 credits | ~1/8 price | 8x |
| Any AI enrichment | 1-10 credits | OpenAI API direct | 10-50x |

**Setup:** Workspace Settings → Integrations → Add OpenAI API key.
This takes 5 minutes and saves $50-200/month immediately.

---

## PROVIDER ACCURACY BENCHMARKS

| Provider | NA Quality | EMEA Quality | NA Coverage | EMEA Coverage |
|----------|-----------|-------------|------------|--------------|
| Hunter | 97.6% | 85-90% | 70% | 45% |
| RocketReach | 96%+ | 90%+ | 65% | 55% |
| Prospeo | 88.9% | 92%+ | 40% | 65% |
| PDL | 95%+ | 88% | 55% | 48% |
| Datagma | 90% | 75% | 35% | 28% |

**Data Freshness:**
| Provider | Refresh Cycle | Freshness |
|----------|--------------|-----------|
| Hunter | Weekly | 30-60 days |
| RocketReach | Weekly | 15-45 days |
| Apollo | Bi-weekly | 30-90 days |
| LinkedIn Scrape | Per lookup | Real-time |
| Clearbit | As-crawled | 45-60 days |
| ZoomInfo | Varies | 30-90 days |

**Freshness rule:** LinkedIn scrapes = newest. Third-party databases lag 30-90 days. For time-sensitive outreach, layer LinkedIn profile lookups + Claygent verification.
