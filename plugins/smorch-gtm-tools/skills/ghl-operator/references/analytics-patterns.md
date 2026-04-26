# Analytics Patterns Reference

> **v2 migration banner — 2026-04-26.** Bare tool names in this doc (e.g., `get_pipelines`, `search_opportunities`, `search_contacts`) are now **operation names** under the new `mcp__salesmfast-ops__ghl-{contacts,opportunities,...}-{reader,updater}` routers. Call shape: `{ selectSchema: { operation, params } }`. See `SKILL.md → MCP Tools Reference` or `salesmfast-ops-mcp/docs/MIGRATION.md` for the full mapping.

## Table of Contents
1. [Reporting Framework](#reporting-framework)
2. [Pipeline Analytics](#pipeline-analytics)
3. [Contact Analytics](#contact-analytics)
4. [Channel Performance](#channel-performance)
5. [Signal Attribution](#signal-attribution)
6. [Reporting Templates](#reporting-templates)

---

## Reporting Framework

When asked to "analyze," "report on," or "check stats" for GHL/SalesMfast, follow this 6-step framework:

### Step 1: Pull Contact Distribution
Search contacts by tag to understand the current state:
```
mcp__ghl-mcp__search_contacts with tag filters:
- signal:hot → Count active hot leads
- signal:warm → Count nurture pool
- signal:cold → Count dormant leads
- source:instantly → Count email-sourced
- source:heyreach → Count LinkedIn-sourced
- source:website → Count inbound
- source:clay → Count enriched
```

### Step 2: Pull Pipeline Data
```
mcp__ghl-mcp__get_pipelines → List all pipelines and stages
mcp__ghl-mcp__search_opportunities → Get opportunities per pipeline
```

### Step 3: Calculate Conversion Rates
For each pipeline, calculate stage-to-stage conversion:
```
Conversion Rate(Stage A → Stage B) = Count(moved to B) / Count(entered A) × 100
```

### Step 4: Identify Stale Opportunities
Search for opportunities with no activity in:
- Signal Detected: >7 days
- Qualified: >5 days
- Meeting Booked: >2 days past meeting date
- Proposal Sent: >7 days
- Negotiation: >14 days

### Step 5: Channel Distribution
Count contacts by channel availability:
- Has WhatsApp (channel:whatsapp tag)
- Has email only
- Has phone only
- Multi-channel (WhatsApp + email)

### Step 6: Recommendations
Based on the data, provide 3-5 specific action items:
- "Follow up on 12 stale hot leads in the Qualified stage"
- "Re-score 45 cold leads that haven't been touched in 30 days"
- "3 opportunities in MENA SaaS Pipeline have been in Proposal Sent for 10+ days — send WhatsApp follow-up"

---

## Pipeline Analytics

### Pipeline Velocity
How fast deals move through the pipeline.

```
Velocity = Average days from first stage to Closed Won

Break down by stage:
- New Lead → Signal Detected: Avg X days
- Signal Detected → Qualified: Avg X days
- Qualified → Meeting Booked: Avg X days
- Meeting Booked → Proposal Sent: Avg X days
- Proposal Sent → Negotiation: Avg X days
- Negotiation → Closed Won: Avg X days
Total Pipeline Velocity: X days
```

**Benchmarks:**
| Pipeline | Target Velocity | Alert If > |
|----------|----------------|------------|
| MENA SaaS | 30 days | 45 days |
| US Real Estate | 14 days | 21 days |
| MENA SME | 7 days | 14 days |
| CXMfast | 60 days | 90 days |

### Stage Conversion Rates

**Target conversion rates (outbound-sourced leads):**
```
New Lead → Signal Detected:   30% (most leads never engage)
Signal Detected → Qualified:  40% (signals that qualify)
Qualified → Meeting Booked:   50% (half of qualified get meetings)
Meeting Booked → Proposal:    70% (most meetings lead to proposals)
Proposal → Negotiation:       60% (proposals that generate discussion)
Negotiation → Closed Won:     50% (half of negotiations close)

Overall: 30% × 40% × 50% × 70% × 60% × 50% = 1.26% end-to-end
(This is realistic for outbound — 1 in ~80 new leads becomes a customer)
```

### Weighted Pipeline Value
```python
stage_weights = {
    'New Lead': 0.05,
    'Signal Detected': 0.10,
    'Qualified': 0.20,
    'Meeting Booked': 0.40,
    'Proposal Sent': 0.60,
    'Negotiation': 0.80,
    'Closed Won': 1.00,
    'Closed Lost': 0.00
}

weighted_value = sum(opp.monetary_value * stage_weights[opp.stage]
                     for opp in open_opportunities)
```

---

## Contact Analytics

### Contact Distribution Report
```
Total contacts: [number]

By Signal Level:
  Hot:  [count] ([%])
  Warm: [count] ([%])
  Cold: [count] ([%])
  None: [count] ([%])

By Source:
  Instantly (cold email): [count] ([%])
  HeyReach (LinkedIn):    [count] ([%])
  Website (inbound):      [count] ([%])
  Clay (enrichment):      [count] ([%])
  Manual:                 [count] ([%])

By ICP:
  MENA SaaS:       [count]
  US Real Estate:  [count]
  MENA SME:        [count]
  Beauty Clinics:  [count]
  CXMfast:         [count]
  Unclassified:    [count]

By Enrichment Status:
  Enriched:  [count] ([%])
  Pending:   [count] ([%])
  Failed:    [count] ([%])
  N/A:       [count] ([%])
```

### Signal Freshness
Contacts with stale signals (last_signal_date > 90 days) should be considered for re-engagement or archival:
```
Fresh signals (<7 days):     [count]
Recent signals (7-30 days):  [count]
Aging signals (30-90 days):  [count]
Stale signals (>90 days):    [count]
No signal data:              [count]
```

### Contact Growth
Track weekly/monthly net new contacts by source to measure top-of-funnel health.

---

## Channel Performance

### WhatsApp Performance (MENA)
```
Messages sent:      [count]
Messages delivered: [count] (delivery rate: [%])
Messages read:      [count] (read rate: [%])
Replies received:   [count] (response rate: [%])
Meetings from WA:   [count] (meeting rate: [%])

Benchmark: >40% response rate for MENA warm contacts
```

### SMS Performance (US)
```
Messages sent:      [count]
Messages delivered: [count] (delivery rate: [%])
Replies received:   [count] (response rate: [%])
Opt-outs:           [count] (opt-out rate: [%])

Benchmark: >15% response rate
Alert if opt-out rate > 5%
```

### Warm Email Performance
```
Emails sent:        [count]
Emails opened:      [count] (open rate: [%])
Emails clicked:     [count] (click rate: [%])
Replies received:   [count] (reply rate: [%])

Benchmark: >20% reply rate for warm contacts
```

---

## Signal Attribution

### Source-to-Closed Won Analysis
For each source channel, track the full funnel:

```
Source: Instantly (Cold Email)
  Leads generated:      [count]
  Signals detected:     [count] ([%] signal rate)
  Qualified:            [count] ([%] qualification rate)
  Meetings booked:      [count] ([%] meeting rate)
  Closed Won:           [count] ([%] win rate)
  Revenue attributed:   $[amount]
  Cost per lead:        $[amount] (Instantly subscription / leads)
  CAC:                  $[amount] (total cost / customers acquired)
  ROI:                  [X]x

Source: HeyReach (LinkedIn)
  [same structure]

Source: Website (Inbound)
  [same structure]
```

### Best-Performing ICP
Compare ICPs by win rate and average deal size to focus resources:

```
| ICP | Leads | Won | Win Rate | Avg Deal | Total Revenue |
|-----|-------|-----|----------|----------|---------------|
| MENA SaaS | X | Y | Z% | $A | $B |
| US Real Estate | X | Y | Z% | $A | $B |
```

---

## Reporting Templates

### Weekly CRM Report
When asked for a weekly report, use this structure:

```
# SalesMfast Weekly Report — [Date Range]

## Pipeline Snapshot
- Total open opportunities: [count] ($[weighted value])
- New opportunities this week: [count]
- Opportunities closed won: [count] ($[value])
- Opportunities closed lost: [count] ($[value])

## Hot Lead Activity
- Hot leads currently: [count]
- New hot signals this week: [count]
- Hot leads with meetings booked: [count]
- Hot leads needing follow-up: [count] ⚠️

## Stale Opportunities (Action Required)
[List of opportunities with no activity for >threshold days]

## Channel Performance
- WhatsApp response rate: [%]
- SMS response rate: [%]
- Email response rate: [%]

## Top Actions This Week
1. [specific action based on data]
2. [specific action based on data]
3. [specific action based on data]
```

### Monthly CRM Report
Extend the weekly report with:
- Month-over-month trends
- Pipeline velocity changes
- Source attribution analysis
- ICP performance comparison
- Channel effectiveness trends
- Contact growth rate
