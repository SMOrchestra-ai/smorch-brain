# Analytics Patterns Reference

## Table of Contents
1. [Key Metrics & Benchmarks](#key-metrics--benchmarks)
2. [Analytics Data Schema](#analytics-data-schema)
3. [Performance Analysis Framework](#performance-analysis-framework)
4. [Cross-Campaign Comparison](#cross-campaign-comparison)
5. [Reporting Templates](#reporting-templates)

---

## Key Metrics & Benchmarks

### Cold Email Benchmarks (Text-Only Outbound)
| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Open Rate | >50% | 30-50% | <30% |
| Reply Rate | >5% | 2-5% | <2% |
| Bounce Rate | <2% | 2-5% | >5% |
| Unsubscribe Rate | <0.5% | 0.5-2% | >2% |
| Opportunities | >1% of sent | 0.5-1% | <0.5% |

### Metric Definitions
```
Open Rate = unique_opened / contacted × 100
Reply Rate = unique_replies / contacted × 100
Bounce Rate = bounced / sent × 100
Unsubscribe Rate = unsubscribed / contacted × 100
Reply-to-Open Ratio = unique_replies / unique_opened × 100
Auto-Reply Rate = unique_replies_automatic / unique_replies × 100
```

**Note on Open Rate:** With tracking disabled (recommended), you won't have open data. In this case, focus on reply rate as the primary metric. Open rate only available if `open_tracking: true`.

### Metric Hierarchy (What Matters Most)
1. **Reply Rate** — Primary metric, measures messaging effectiveness
2. **Bounce Rate** — Data quality indicator, must stay low
3. **Opportunity Rate** — Revenue impact, ultimate success metric
4. **Open Rate** — Only meaningful with tracking enabled (which we usually don't)
5. **Unsubscribe Rate** — Targeting quality indicator

---

## Analytics Data Schema

### Campaign Analytics Response
```json
{
  "date": "2026-02-21",
  "sent": 5421,
  "contacted": 5000,
  "new_leads_contacted": 200,
  "opened": 99,
  "unique_opened": 60,
  "replies": 60,
  "unique_replies": 55,
  "replies_automatic": 5,
  "unique_replies_automatic": 4,
  "clicks": 60,
  "unique_clicks": 60,
  "opportunities": 5,
  "unique_opportunities": 3
}
```

### Field Explanations
| Field | Meaning |
|-------|---------|
| `sent` | Total emails dispatched (includes retries) |
| `contacted` | Unique leads that received at least one email |
| `new_leads_contacted` | Leads contacted for the first time in this period |
| `opened` / `unique_opened` | Total opens vs unique lead opens (if tracking on) |
| `replies` / `unique_replies` | Total replies vs unique lead replies |
| `replies_automatic` | Auto-replies (OOO, bounce-backs) |
| `clicks` / `unique_clicks` | Link clicks (if tracking on) |
| `opportunities` | Marked as opportunity (positive reply) |

### Daily Analytics Fields
```json
{
  "campaign_id": "uuid",
  "date": "2026-02-21",
  "sent": 150,
  "opens": 45,
  "open_rate": 0.30,
  "clicks": 5,
  "click_rate": 0.033,
  "replies": 8,
  "reply_rate": 0.053,
  "bounces": 2
}
```

---

## Performance Analysis Framework

### Step-by-Step Analysis
When asked to analyze campaign performance:

#### Step 1: Pull Data
```
get_campaign_analytics for specific campaign
  OR
get_daily_campaign_analytics for trend data
  OR
get_campaign_analytics (via get_campaign first) for campaign-level overview
```

#### Step 2: Calculate Rates
```
open_rate = unique_opened / contacted
reply_rate = unique_replies / contacted
bounce_rate = (sent - contacted) / sent  [approximate]
auto_reply_pct = unique_replies_automatic / unique_replies
opportunity_rate = unique_opportunities / contacted
```

#### Step 3: Compare Against Benchmarks
Flag any metric in Warning or Critical zone.

#### Step 4: Diagnose Issues
Use the diagnostic decision tree from SKILL.md:

| Low Opens | Low Replies | High Bounces | High Unsubs |
|-----------|------------|--------------|-------------|
| Deliverability | Messaging | List quality | Targeting |
| Check warmup | Rewrite copy | Stop & clean | Narrow ICP |
| Check tracking | Check personalization | Verify emails | Check relevance |
| Check subject line | Check CTA | Check source | Check frequency |

#### Step 5: Recommend Actions
Always provide specific, prioritized actions:
- P1 (Do now): Issues that will compound if ignored (bounces, deliverability)
- P2 (Do this week): Issues affecting performance (messaging, targeting)
- P3 (Next cycle): Optimizations for next campaign (A/B tests, new angles)

---

## Cross-Campaign Comparison

### Comparison Framework
When comparing multiple campaigns:

```
1. list_campaigns → get all active campaigns
2. For each campaign: get_campaign_analytics with same date range
3. Build comparison table:

| Campaign | Contacted | Reply Rate | Bounce Rate | Opps | Status |
|----------|-----------|------------|-------------|------|--------|
| [MENA SaaS] - AI GTM - Feb A | 500 | 7.2% | 1.5% | 12 | ✅ Scale |
| [US RE] - Lead Gen - Feb A | 300 | 2.1% | 4.8% | 2 | ⚠️ Fix |
| [Gulf SME] - WhatsApp - Feb A | 200 | 3.5% | 1.0% | 3 | → Test |

4. Categorize each campaign:
   ✅ SCALE: Reply >5%, bounce <3%, opps >2%
   → TEST: Reply 3-5%, metrics stable, try variants
   ⚠️ FIX: Reply <3% OR bounce >3%, diagnose and fix
   🛑 PAUSE: Bounce >5% OR unsubscribe >2%, stop immediately
```

### Performance Ranking
Rank campaigns by reply rate (primary), then by opportunity rate (secondary):
```
Best performers → Increase daily limits, expand lead lists
Average performers → A/B test variants, refine personalization
Poor performers → Diagnose issue, rewrite or pause
```

### Week-over-Week Trends
Pull daily analytics and calculate rolling 7-day averages:
```
Improving: Week 2 reply rate > Week 1 → Keep running
Flat: Same rates → Consider sequence refresh
Declining: Week 2 < Week 1 → Investigate fatigue, list quality
```

---

## Reporting Templates

### Quick Campaign Report
```
## Campaign: [Name]
Period: [Date range]

### Key Metrics
- Contacted: [count]
- Reply Rate: [X]% ([benchmark status])
- Bounce Rate: [X]% ([benchmark status])
- Opportunities: [count] ([X]% of contacted)
- Active Sequences: [count] leads still in sequence

### Assessment
[1-2 sentences on overall health]

### Recommended Actions
1. [P1 action if any]
2. [P2 action]
3. [P3 optimization]
```

### Weekly Cold Email Report
```
## Weekly Cold Email Report — [Date Range]

### Overall Performance
- Total campaigns active: [count]
- Total emails sent: [count]
- Total replies: [count] (avg [X]% reply rate)
- Total opportunities: [count]
- Sending accounts: [X] GREEN, [Y] YELLOW, [Z] RED

### Campaign Breakdown
[Comparison table from Cross-Campaign section]

### Account Health
[Summary from account health check]

### Top Actions This Week
1. [highest priority action]
2. [second priority]
3. [third priority]

### Signals Routed to CRM
- Hot signals sent to GHL: [count]
- Warm signals for nurture: [count]
- Bounced leads flagged: [count]
```

### Monthly Performance Summary
Extend weekly with:
- Month-over-month comparison
- Best performing campaign and why
- Worst performing campaign and diagnosis
- Account scaling recommendations
- Lead source quality analysis (which Clay segments perform best)
- Budget impact (cost per reply, cost per opportunity)
