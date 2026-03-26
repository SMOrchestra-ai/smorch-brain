# Saved Search Strategy for Sales Navigator Core

## Budget: 50 Lead Searches + 50 Account Searches

Don't waste these on throwaway searches. Every saved search must answer one question: "Which signal will this catch that my daily triage would otherwise miss?"

## The Monitoring Stack Framework

A "monitoring stack" is a Fit filter set + one Signal filter that maps directly to an outbound play.

Think of it like fishing nets. Each net catches a specific fish in a specific location. You don't need 50 nets - you need 8-12 well-placed nets that cover your ICP + signal combinations.

### Recommended Allocation

| Category | Lead Searches | Account Searches | Purpose |
|---------|--------------|-----------------|---------|
| Core ICP - Signal Combos | 15-20 | 5-8 | Daily signal detection |
| MENA Bilingual Splits | 8-12 | 4-6 | Arabic/English parallel runs |
| Vertical-Specific | 6-8 | 4-6 | Industry-focused targeting |
| Competitive Intelligence | 4-6 | 3-4 | Monitor competitor accounts |
| Reserve (New Campaigns) | 5-10 | 5-10 | Keep buffer for new ICPs |

### Core ICP Monitoring Stacks

**Stack 1: Revenue Leaders - Job Changes (UAE)**
```
Lead Search:
  Geography: UAE
  Seniority: VP, CXO
  Function: Sales
  Spotlight: Changed jobs in past 90 days
  Profile language: English
→ Alert value: Tier 1 (new leader = vendor evaluation window)
```

**Stack 2: Revenue Leaders - Job Changes (KSA)**
```
Same as Stack 1, Geography: Saudi Arabia
→ Split by country for cleaner data
```

**Stack 3: Revenue Leaders - Active Posters (UAE)**
```
Lead Search:
  Geography: UAE
  Seniority: VP, CXO, Director
  Function: Sales, Marketing
  Spotlight: Posted on LinkedIn in 30 days
  Profile language: English
→ Alert value: Tier 2 (content = conversation permission)
```

**Stack 4: Revenue Leaders - Arabic Profiles (UAE+KSA)**
```
Lead Search:
  Geography: UAE, Saudi Arabia
  Seniority: VP, CXO, Director
  Profile language: Arabic
  Keyword: ("مدير مبيعات" OR "نائب الرئيس" OR "تطوير الأعمال")
→ Alert value: Tier 2 (Arabic ICP segment, route to Arabic sequences)
```

**Stack 5: Growing Companies - Job Postings**
```
Account Search:
  HQ: UAE, Saudi Arabia
  Headcount: 51-500
  Headcount growth: Positive
  Job opportunities: Yes
→ Alert value: Tier 1 (budget expansion signal)
```

**Stack 6: Scale-ups - RevOps Hiring**
```
Lead Search:
  Seniority: Director, VP
  Title Boolean: ("RevOps" OR "Revenue Operations" OR "Sales Operations")
  Spotlight: Changed jobs in 90 days
→ Alert value: Tier 1 (ops hire = infrastructure investment)
```

## Naming Convention

Use this pattern for saved searches so you can quickly identify them in the list:

```
[GEO]-[ROLE]-[SIGNAL]-[LANG]

Examples:
UAE-RevLeaders-JobChange-EN
KSA-RevLeaders-JobChange-EN
UAE-RevLeaders-Active-EN
MENA-RevLeaders-Arabic-AR
UAE-Growth51-500-Jobs
Global-RevOps-JobChange-EN
```

## Weekly Refresh Protocol

Every Friday (or Thursday end-of-day for MENA timing):

### 1. Performance Audit (10 minutes)
Open each saved search and note:
- **Result count this week vs last week**: Growing? Shrinking? Stable?
- **New results quality**: Are the top 10 results actually in ICP? Or noise?
- **False positive rate**: What percentage are NOT your target? If >30%, tighten filters

### 2. Clean Underperformers (5 minutes)
- Searches producing 0 new results for 2+ consecutive weeks: Delete or broaden
- Searches producing >80% false positives: Delete and rebuild with tighter filters
- Searches capped at 2,500 results: Segment (split by country, seniority, or industry)

### 3. Add New Stacks (5 minutes)
- New campaign launching? Add its monitoring stack
- Pipeline deal progressing? Add account-specific search for multi-threading
- ICP shifted? Update Personas and corresponding saved searches

### 4. Document Changes
Log what you changed and why in `learnings-log.md`

## Persona Strategy (5 Persona Slots)

Personas save time by pre-loading filter sets. Core plan gives you 5.

### Recommended Persona Setup for SMOrchestra ICP

| Persona | Function | Seniority | Title Keywords | Geography |
|---------|----------|-----------|---------------|-----------|
| 1: MENA Rev Leader EN | Sales | VP, CXO | Sales Director, CRO, Head of Sales | UAE, KSA, Qatar |
| 2: MENA Rev Leader AR | Sales | VP, CXO, Director | مدير مبيعات, نائب الرئيس | UAE, KSA, Qatar |
| 3: RevOps / SalesOps | Operations | Director, VP | RevOps, Sales Ops, Sales Enablement | Global |
| 4: Marketing Ops | Marketing | Director, VP | Demand Gen, Marketing Ops, Growth | UAE, KSA + US, UK |
| 5: IT / Channel Sales | IT, BD | Manager, Director | Channel Sales, Partner Manager, IT Director | UAE, KSA |

### Persona + Saved Search Coordination
Each Persona should have at least 2 saved searches mapped to it:
- One with "Changed jobs" spotlight (catch movers)
- One with "Posted in 30 days" spotlight (catch active people)

## Advanced: Account List as Search Accelerator

You can use saved account lists as a filter in lead searches. This means:

1. Build an account list of your top 100-200 target accounts
2. Create a lead search: "All leads at [account list] + Director+ seniority"
3. Save this search - you'll get alerts when NEW senior people join or leave these accounts

This is one of the most underused features on Core plan. It gives you something close to "Buyer Intent" for a curated account list.

## Retirement Rules

Delete a saved search when:
- Campaign it was built for has ended
- ICP definition changed and search no longer matches
- Result quality degraded below 50% relevance for 3+ consecutive weeks
- You need the slot for a higher-priority monitoring stack

Never let dead searches sit - they consume your 50-search budget and generate noise in your alerts feed.
