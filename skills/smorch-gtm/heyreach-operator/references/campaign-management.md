# Campaign Management Reference

## Table of Contents
1. Campaign Lifecycle
2. Sender Account Strategy
3. Sender Capacity Planning
4. Sender-to-Lead Mapping
5. Campaign Status Management
6. Multi-Sender Rotation
7. Campaign Templates by Market

---

## 1. Campaign Lifecycle

### Campaign Statuses
| Status | Meaning | Actions Available |
|--------|---------|-------------------|
| DRAFT | Created but not started | Edit sequences, add leads, configure senders |
| STARTING | Transitioning to active | Wait — no actions |
| IN_PROGRESS | Actively sending | Pause, add/remove leads, monitor |
| PAUSED | Temporarily stopped | Resume, add/remove leads, edit sequences |
| FINISHED | All leads completed sequence | Archive, analyze, extract learnings |
| CANCELED | Manually stopped permanently | Analyze, archive |
| FAILED | System error | Diagnose via account status check |
| SCHEDULED | Set to start at future time | Edit, cancel |

### Lifecycle Flow
```
DRAFT → STARTING → IN_PROGRESS → FINISHED
            ↓              ↓
         FAILED         PAUSED → resume → IN_PROGRESS
                           ↓
                       CANCELED
```

### Campaign Health Indicators
- **Healthy**: Steady connection rate >25%, reply rate >10%, no account flags
- **Warning**: Connection rate 15-25% OR reply rate 5-10% OR sender approaching limits
- **Critical**: Connection rate <15% OR sender account flagged OR excessive failures

---

## 2. Sender Account Strategy

### Current Account Inventory
Call `get_all_linked_in_accounts()` to get current state. Known accounts:
- Account ID 140055: Sura Abdulaziz (Active, navigator capable)

### Account Health Checks
For each sender account, verify:
1. Auth status is valid (check `get_linked_in_account_by_id`)
2. No LinkedIn restrictions (connection request failures spike)
3. Daily activity within safe limits
4. Account has been warmed up (at least 2 weeks of manual activity before automation)

### Geographic Assignment
| Sender Location | Target Audience |
|----------------|-----------------|
| UAE-based accounts | MENA prospects (UAE, KSA, Qatar, Kuwait, Bahrain) |
| US-based accounts | US/Canada prospects |
| EU-based accounts | EU/UK prospects |

Geography matching increases acceptance rates because LinkedIn shows mutual connections and location proximity.

### Account Warmup Protocol
New sender accounts need 2-4 weeks of warmup before full automation:
- **Week 1-2**: Manual activity only (connect, post, comment). 5-10 connections/day.
- **Week 3**: Light automation. 10-15 connections/day via HeyReach.
- **Week 4+**: Full automation. 20-30 connections/day, scaling to 40 max.

---

## 3. Sender Capacity Planning

### Daily Limits (Non-Negotiable)
| Action | Safe Daily Limit per Account | Absolute Maximum |
|--------|------------------------------|------------------|
| Connection requests | 20-30 | 40 |
| Messages to connections | 50-80 | 150 |
| InMails (if premium) | 15-20 | 30 |
| Profile views | 50-80 | 100 |
| Post likes | 20-30 | 50 |

### Capacity Calculation
```
Total daily enrollment capacity = Σ(accounts × 30 conservative avg)

Example with 3 accounts:
  Account A: 30/day (fully warmed)
  Account B: 30/day (fully warmed)
  Account C: 15/day (still warming)
  Total: 75 leads/day capacity

If user wants to enroll 250 leads:
  250 ÷ 75 = 3.3 days
  Recommend: "I'll enroll in 3 daily batches of ~83 each to stay safe"
```

### Capacity Check Before Enrollment
1. Get all sender accounts
2. For each account, calculate: `daily_limit - already_enrolled_today`
3. If remaining capacity < number of leads to add → warn user
4. Propose batched enrollment with daily schedule

### Safety Threshold
If a sender has used >80% of daily capacity:
- Skip this sender for current batch
- Assign remaining leads to other senders
- If all senders at >80% → stop and schedule for next day

---

## 4. Sender-to-Lead Mapping

### Mapping Priority Order
1. **Geographic match** — Same region sender to same region prospect
2. **Industry knowledge** — Sender's LinkedIn profile aligns with prospect's industry
3. **Connection overlap** — Sender has mutual connections with prospect (highest acceptance)
4. **Even distribution** — Balance load across senders to stay within limits

### Mapping Algorithm
```
For each lead:
  1. Check lead.location → determine market (MENA, US, EU)
  2. Filter senders by matching market
  3. Among matching senders, pick the one with most remaining capacity
  4. If no geographic match, use sender with most remaining capacity
  5. Track assignments: sender_assignments[senderId] += 1
  6. If sender_assignments[senderId] >= daily_limit → mark sender as full
```

### When Only One Sender Available
With a single account (current state: account 140055):
- All leads map to this sender
- Daily limit becomes the bottleneck
- Calculate: total_leads ÷ 30/day = enrollment days needed
- Warn user if >3 days of backlog

---

## 5. Campaign Status Management

### When to Pause
- Sender account showing signs of LinkedIn restriction (connection failure spike)
- Connection rate drops below 15% sustained over 3+ days
- User reports receiving LinkedIn warnings
- Lead quality issue detected (wrong audience, outdated data)
- Switching sequences or messaging mid-campaign

### When to Resume
- Issue has been resolved (sender unblocked, list cleaned, sequence updated)
- Paused for minimum 48 hours after a restriction scare
- Verified remaining leads are still valid and not stale

### Campaign Archival Criteria
Move to "finished/archived" when:
- All leads have completed the sequence
- Campaign has been paused for >30 days without resumption
- Campaign metrics show it's not worth continuing (reply rate <2% after 500+ sends)

---

## 6. Multi-Sender Rotation

### Why Rotation Matters
- Distributes LinkedIn's attention across accounts (lower restriction risk)
- Different senders may have different connection overlap with prospects
- If one sender gets restricted, others keep running

### Rotation Strategy
- **Round-robin**: Assign lead 1 → sender A, lead 2 → sender B, lead 3 → sender C, repeat
- **Weighted**: Higher-performing senders get more leads (proportional to their connection rate)
- **Geographic**: Route by market alignment (preferred for SMOrchestra)

### Performance-Based Rebalancing
Monthly review:
1. Pull stats per sender via `get_overall_stats` filtered by account
2. Calculate per-sender connection rate and reply rate
3. Senders with <15% connection rate → reduce allocation by 50%
4. Senders with >30% connection rate → increase allocation by 25%
5. Investigate underperformers: profile quality? audience mismatch? timing?

---

## 7. Campaign Templates by Market

### MENA SaaS Campaign
- **Senders**: MENA-based accounts
- **Timing**: Sun-Thu, 9 AM - 5 PM GST
- **Connection note**: Brief, no pitch, Arabic cultural reference OK
- **Follow-up**: After connection accepted, wait 24h before first message
- **Message style**: Warm, relationship-aware, mention shared geography
- **Sequence**: Connection request → Welcome message → Value message → CTA

### US B2B Campaign
- **Senders**: US-based accounts (or neutral global accounts)
- **Timing**: Mon-Fri, 9 AM - 5 PM Central
- **Connection note**: Brief, reference their recent activity/post
- **Follow-up**: After connection accepted, wait 12-24h
- **Message style**: Direct, value-first, data-driven
- **Sequence**: Connection request → Insight message → Proof message → Soft CTA

### Event Follow-Up Campaign
- **Senders**: Account that attended the event (for mutual connection signal)
- **Timing**: Within 48h of event for first touch
- **Connection note**: Reference the specific event
- **Follow-up**: Same-day connection note, Day 2 value message
- **Message style**: Event-specific context, shared experience
- **Sequence**: Connection with event mention → Recap value → Meeting CTA
