# Performance Attribution

Cross-channel attribution methodology for multi-channel outbound campaigns.

## Table of Contents
1. Attribution Models
2. Multi-Channel Lift Calculation
3. Channel Effectiveness Metrics
4. Campaign Comparison Framework
5. Reporting Templates

---

## Attribution Models

### The Problem with Single-Touch Attribution

In multi-channel outbound, a lead might:
1. Receive cold email (Day 0)
2. See LinkedIn connection request (Day 2)
3. Open the email (Day 3)
4. Accept LinkedIn connection (Day 3)
5. Visit website (Day 4)
6. Reply to LinkedIn message (Day 5)

Who gets credit? Single-touch models are misleading:
- **First-touch** would credit Email → but the reply came on LinkedIn
- **Last-touch** would credit LinkedIn → but email opened first and drove awareness
- Neither captures the compound effect of multi-channel

### Recommended: Weighted Multi-Touch

Allocate credit based on signal contribution:

```
Attribution Weight = (signal_score_delta / total_lead_score) × 100%

Example for the lead above:
- Email sent: 0 points → 0% credit
- LinkedIn connection request: 0 points → 0% credit
- Email opened: +1 point → 8% credit
- LinkedIn connection accepted: +3 points → 25% credit
- Compound bonus (email+LinkedIn): +2 points → 17% credit
- Website visit: +2 points → 17% credit
- LinkedIn message reply: +8 points → 67% ... wait, that's >100%
```

**Adjusted formula** — normalize to 100%:
```
Total raw points for this lead: 1 + 3 + 2 + 2 + 8 = 16
Email open: 1/16 = 6.25%
Connection accepted: 3/16 = 18.75%
Compound bonus: 2/16 = 12.5%
Website visit: 2/16 = 12.5%
LinkedIn reply: 8/16 = 50%
```

Channel summary: Email gets 6.25%, LinkedIn gets 81.25%, Web gets 12.5%.

### Simplified Attribution for Reporting

For weekly/monthly reports, use this simplified model:

| Conversion Event | Primary Attribution | Secondary Attribution |
|-----------------|--------------------|-----------------------|
| Reply on Channel X | 60% to Channel X | 40% split across other channels that touched lead |
| Meeting booked from Channel X | 70% to Channel X | 30% split |
| Form submission | 50% to last outbound touch | 50% split across all touches |
| Inbound call | 40% to last outbound touch | 60% split (brand lift) |

### Campaign-Level Attribution

At campaign level, roll up individual lead attributions:

```
Campaign Email Attribution = Sum(each lead's email attribution) / Total leads converted
Campaign LinkedIn Attribution = Sum(each lead's LinkedIn attribution) / Total leads converted
Campaign WhatsApp Attribution = Sum(each lead's WhatsApp attribution) / Total leads converted
```

---

## Multi-Channel Lift Calculation

The key question: **Does multi-channel outreach outperform single-channel?**

### Calculation Method

```
Multi-Channel Lift = (Multi-Channel Conversion Rate / Single-Channel Conversion Rate) - 1

Where:
- Multi-Channel Conversion Rate = Leads touched on 2+ channels who converted / Total multi-channel leads
- Single-Channel Conversion Rate = Leads touched on 1 channel who converted / Total single-channel leads
```

### Segmented Lift Analysis

Calculate lift for each channel combination:

| Combination | Conversion Rate | Lift vs Email-Only |
|------------|----------------|-------------------|
| Email only | X% | Baseline |
| LinkedIn only | X% | X% |
| Email + LinkedIn | X% | X% |
| Email + LinkedIn + WhatsApp | X% | X% |

### Interpreting Lift

- Lift >50%: Strong multi-channel effect, scale this combination
- Lift 20-50%: Meaningful, worth the operational complexity
- Lift <20%: Marginal, evaluate if second channel is worth the effort
- Negative lift: Channel conflict — too many touches or wrong timing. Fix immediately.

### Control Group Best Practice

For rigorous measurement, hold back 10-15% of leads as single-channel control:
- Randomly assign 10-15% of leads to email-only
- Run the same wedge/messaging
- Compare conversion rates after full sequence completion
- This proves (or disproves) multi-channel value with your specific audience

---

## Channel Effectiveness Metrics

### Per-Channel Metrics

**Instantly (Email):**
| Metric | Formula | Healthy Benchmark |
|--------|---------|------------------|
| Open Rate | Opens / Delivered | >40% |
| Click Rate | Clicks / Delivered | >3% |
| Reply Rate | Replies / Delivered | >2% |
| Positive Reply Rate | Positive Replies / Total Replies | >50% |
| Bounce Rate | Bounces / Sent | <3% |
| Unsubscribe Rate | Unsubs / Delivered | <1% |

**HeyReach (LinkedIn):**
| Metric | Formula | Healthy Benchmark |
|--------|---------|------------------|
| Connection Rate | Accepted / Requests Sent | >25% |
| Message Reply Rate | Replies / Messages Sent | >10% |
| InMail Reply Rate | Replies / InMails Sent | >15% |
| Accept Speed | Avg time to acceptance | <48hrs = good |

**GHL (WhatsApp/SMS):**
| Metric | Formula | Healthy Benchmark |
|--------|---------|------------------|
| Delivery Rate | Delivered / Sent | >95% |
| Read Rate | Read / Delivered | >70% |
| Reply Rate | Replies / Delivered | >15% |

### Cross-Channel Metrics

| Metric | Formula | What It Tells You |
|--------|---------|------------------|
| Multi-Channel Engagement Rate | Leads engaging on 2+ channels / Total multi-channel leads | Are leads noticing your multi-channel presence? |
| Compound Signal Rate | Leads with compound signals / Total leads | How often does multi-channel create synergy? |
| Channel Conflict Rate | Leads who received 2+ touches same day / Total leads | Is collision prevention working? Should be <1% |
| Cross-Channel Conversion Rate | Leads who converted with multi-channel touch / Total converted | What % of conversions had multi-channel influence? |
| Time to Engagement | Avg days from first touch to first signal | How fast does each pattern generate signals? |
| Time to Conversion | Avg days from first touch to meeting/reply | End-to-end cycle time |

---

## Campaign Comparison Framework

### Comparing Across Patterns

When running multiple campaigns (Pattern A vs B vs C), compare:

| Dimension | Pattern A | Pattern B | Pattern C | Pattern D |
|-----------|-----------|-----------|-----------|-----------|
| Total leads | — | — | — | — |
| Engagement rate | — | — | — | — |
| Reply rate | — | — | — | — |
| Meeting rate | — | — | — | — |
| Avg signal score | — | — | — | — |
| Time to first signal | — | — | — | — |
| Time to meeting | — | — | — | — |
| Cost per meeting | — | — | — | — |
| Multi-channel lift | — | — | — | — |

### Categorizing Campaign Performance

| Category | Criteria | Action |
|----------|---------|--------|
| SCALE | Reply rate >5%, Meeting rate >2% | Increase lead volume, add accounts |
| OPTIMIZE | Reply rate 2-5%, some meetings | Test different wedges or timing |
| FIX | Reply rate <2%, high open rate | Message resonates but CTA weak |
| PAUSE | Reply rate <1%, low engagement | Wrong audience or channel |
| KILL | Bounce rate >5% or spam complaints | Data quality issue, stop immediately |

---

## Reporting Templates

### Weekly Cross-Channel Performance Report

```markdown
# Weekly Outbound Performance — Week of [date]

## Executive Summary
- Total outbound touches: X (Email: X, LinkedIn: X, WhatsApp: X)
- New signals detected: X (Hot: X, Warm: X)
- Meetings booked: X
- Pipeline value created: $X
- Multi-channel lift: X%

## Channel Performance
### Email (Instantly)
- Campaigns active: X
- Emails sent: X | Opens: X (X%) | Replies: X (X%)
- Top performing campaign: [name] — X% reply rate
- Action needed: [specific recommendation]

### LinkedIn (HeyReach)
- Campaigns active: X
- Connection requests: X | Accepted: X (X%) | Replies: X (X%)
- Top performing campaign: [name] — X% connection rate
- Action needed: [specific recommendation]

### WhatsApp/CRM (GHL)
- WhatsApp messages triggered: X | Read: X (X%) | Replied: X (X%)
- Opportunities created: X | Pipeline stage movements: X
- Action needed: [specific recommendation]

## Cross-Channel Insights
- Compound signals detected: X (X% of active leads)
- Most effective combination: [channels] — X% conversion
- Channel conflict incidents: X (should be <1%)
- Leads rescued from cold: X

## Recommendations
1. [Specific action with expected impact]
2. [Specific action with expected impact]
3. [Specific action with expected impact]
```

### Monthly Attribution Report

```markdown
# Monthly Attribution Report — [Month Year]

## Conversion Attribution by Channel
| Channel | Primary Credit | Secondary Credit | Total Influence |
|---------|---------------|-----------------|-----------------|
| Email | X% | X% | X% |
| LinkedIn | X% | X% | X% |
| WhatsApp | X% | X% | X% |

## Multi-Channel Lift Analysis
| Combination | Leads | Conversions | Rate | Lift vs Single |
|------------|-------|-------------|------|----------------|
| Email only | X | X | X% | Baseline |
| LinkedIn only | X | X | X% | — |
| Email + LinkedIn | X | X | X% | +X% |
| All channels | X | X | X% | +X% |

## Pattern Performance
[Pattern comparison table]

## Key Learnings
1. [Insight to capture in learnings-log.md]
2. [Insight to capture in learnings-log.md]

## Next Month Recommendations
1. [Strategic recommendation]
2. [Tactical adjustment]
```
