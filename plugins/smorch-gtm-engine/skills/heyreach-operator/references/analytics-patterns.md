# Analytics Patterns Reference

## Table of Contents
1. Key Metrics & Benchmarks
2. get_overall_stats Response Schema
3. Performance Analysis Framework
4. Per-Sender Analysis
5. Campaign Comparison & Categorization
6. Anomaly Detection
7. Reporting Templates

---

## 1. Key Metrics & Benchmarks

### Primary Metrics
| Metric | Calculation | Healthy | Warning | Critical |
|--------|------------|---------|---------|----------|
| Connection Rate | accepted / requests sent | >25% | 15-25% | <15% |
| Reply Rate | unique replies / messages sent | >10% | 5-10% | <5% |
| InMail Response Rate | replies / InMails sent | >15% | 8-15% | <8% |
| Sequence Completion (no reply) | finished without reply / total enrolled | <60% | 60-80% | >80% |
| Profile View Rate | views / total actions | Informational | — | — |

### Secondary Metrics
| Metric | Calculation | Target |
|--------|------------|--------|
| Connection-to-Reply Ratio | replies / connections accepted | >30% |
| Time to First Reply | avg days from first message to reply | <5 days |
| Meeting Booking Rate | meetings / positive replies | >25% |
| Sender Utilization | actual sends / daily capacity | 60-80% |

### Benchmarks by Market
| Market | Connection Rate | Reply Rate | Notes |
|--------|----------------|------------|-------|
| MENA (Gulf) | 30-40% | 12-18% | Higher acceptance, relationship culture |
| US | 20-30% | 8-12% | More saturated, need sharper personalization |
| EU | 25-35% | 10-15% | GDPR-aware, privacy-conscious |

---

## 2. get_overall_stats Response Schema

The `get_overall_stats` tool returns aggregated campaign data.

Parameters:
```json
{
  "accountIds": [140055],       // Filter by sender accounts (empty = all)
  "campaignIds": [336673],      // Filter by campaigns (empty = all)
  "startDate": "2026-01-22T00:00:00.000Z",  // ISO 8601 UTC
  "endDate": "2026-02-22T00:00:00.000Z"
}
```

Expected response fields:
- Connection requests sent
- Connections accepted
- Messages sent
- Replies received
- InMails sent
- InMail replies
- Profile views
- Post likes
- Leads in progress / pending / finished / failed

### Calculating Rates from Stats
```
connection_rate = connections_accepted / connection_requests_sent
reply_rate = replies_received / messages_sent
inmail_rate = inmail_replies / inmails_sent
completion_rate = leads_finished / total_leads
failure_rate = leads_failed / total_leads
```

---

## 3. Performance Analysis Framework

### 5-Step Analysis Process
When asked to "analyze" or "report on" campaigns:

**Step 1: Gather Data**
- `get_overall_stats` with date range (default: last 30 days)
- `get_all_campaigns` to get campaign list
- `get_campaign` for each active/recent campaign

**Step 2: Calculate Rates**
For each campaign and overall:
- Connection rate
- Reply rate
- Completion rate (without reply)
- Per-sender rates (if multiple senders)

**Step 3: Benchmark Comparison**
Compare each metric against benchmarks (see table above).
Flag anything in Warning or Critical range.

**Step 4: Identify Patterns**
- Which campaigns outperform? Why? (audience? messaging? timing?)
- Which senders outperform? Why? (profile quality? network overlap?)
- Any week-over-week trends? (improving or declining?)
- Correlation between lead source and performance?

**Step 5: Recommend Actions**
Prioritized recommendations:
- P1 (Immediate): Pause underperformers, fix broken sequences
- P2 (This week): Rebalance sender allocation, update messaging
- P3 (Next cycle): Test new audiences, optimize sequences

---

## 4. Per-Sender Analysis

### Why Per-Sender Matters
Different senders get different results because:
- Profile strength varies (headline, photo, connections count)
- Network overlap with target audience differs
- LinkedIn algorithm treats accounts differently
- Geographic proximity signals to LinkedIn

### Sender Scorecard Template
```
Sender: [Name] (ID: [accountId])
Period: [date range]

Connection Requests Sent: XXX
Connections Accepted: XXX (XX%)
Messages Sent: XXX
Replies Received: XXX (XX%)
InMails Sent: XXX
InMail Replies: XXX (XX%)

Daily Average Activity: XX/day
Capacity Utilization: XX%

Status: [HEALTHY / WARNING / CRITICAL]
Recommendation: [Continue / Reduce load / Pause / Investigate]
```

### Red Flags Per Sender
- Connection rate drops >10 points week-over-week → possible LinkedIn restriction
- Failure rate >20% → account issue or data quality issue
- Zero activity for >48 hours → check account auth
- Connection rate <15% sustained → profile may need optimization

---

## 5. Campaign Comparison & Categorization

### Category Definitions
| Category | Criteria | Action |
|----------|----------|--------|
| SCALE | Connection >25%, Reply >10%, no sender issues | Increase lead volume |
| TEST | Connection 15-25%, Reply 5-10%, metrics stable | Keep running, iterate messaging |
| FIX | Connection <15% OR Reply <5% | Diagnose and fix before continuing |
| PAUSE | Sender flagged OR failure rate >20% | Pause immediately, investigate |

### Comparison Table Template
```
| Campaign | Leads | Conn. Rate | Reply Rate | Completion | Category |
|----------|-------|-----------|------------|------------|----------|
| [name]   | XXX   | XX%       | XX%        | XX%        | SCALE    |
| [name]   | XXX   | XX%       | XX%        | XX%        | FIX      |
```

---

## 6. Anomaly Detection

### What to Watch For
| Anomaly | Possible Cause | Investigation |
|---------|---------------|---------------|
| Sudden connection rate drop (>10pts) | LinkedIn restriction on sender | Check account status, pause for 48h |
| Reply rate spike (positive) | Message resonance with segment | Identify what changed, replicate |
| High failure rate (>20%) | Invalid profiles, account issue | Check lead data quality, account auth |
| Zero activity despite IN_PROGRESS | Sender auth expired | `get_linked_in_account_by_id` to verify |
| All leads finishing without reply | Weak sequence or wrong audience | Review messaging, check ICP alignment |

### Weekly Health Check Protocol
1. Pull `get_overall_stats` for current week vs previous week
2. Calculate week-over-week delta for each metric
3. Flag any metric with >15% negative change
4. Check each sender account status
5. Review any campaigns approaching completion (>80% finished)

---

## 7. Reporting Templates

### Weekly Report
```
## LinkedIn Outbound Weekly Report
Period: [start] to [end]

### Overall Performance
- Connection Requests Sent: XXX
- Connections Accepted: XXX (XX%) [↑/↓ X% vs last week]
- Messages Sent: XXX
- Replies Received: XXX (XX%) [↑/↓ X% vs last week]
- Meetings Booked: XX

### Campaign Breakdown
[Campaign comparison table]

### Sender Health
[Sender scorecard for each account]

### Top Performers
- Best campaign: [name] — XX% connection rate, XX% reply rate
- Best sender: [name] — XX% connection rate

### Issues & Actions
- [Issue 1]: [Action taken or recommended]
- [Issue 2]: [Action taken or recommended]

### Next Week Plan
- Scale: [campaigns to scale]
- Test: [new sequences or audiences to test]
- Fix: [issues to resolve]
```

### Monthly Report (Extended)
Adds to weekly template:
- Month-over-month trends
- Sender performance ranking
- Lead source quality analysis (which sources produce highest reply rates)
- Cross-channel correlation (LinkedIn engagement → email response lift)
- Recommendations for next month's strategy
