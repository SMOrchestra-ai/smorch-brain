# Account Management Reference

## Table of Contents
1. [Account Health Monitoring](#account-health-monitoring)
2. [Warmup Management](#warmup-management)
3. [Daily Limit Strategy](#daily-limit-strategy)
4. [Domain Rotation](#domain-rotation)
5. [Troubleshooting](#troubleshooting)

---

## Account Health Monitoring

### Account Status Codes
| Code | Status | Action |
|------|--------|--------|
| 1 | Active | Good — eligible for sending |
| 2 | Paused | Investigate why, resume if healthy |
| -1 | IMAP Error | Test vitals, check credentials |
| -2 | SMTP Error | Test vitals, check credentials |
| -3 | General Error | Test vitals, may need re-setup |

### Health Check Workflow
```
1. list_accounts → get all accounts
2. For each account:
   a. Check status (must be 1)
   b. Check setup_pending (must be false)
   c. Call get_warmup_analytics with email array
   d. Evaluate warmup score, inbox rate, spam rate
3. Categorize:
   - GREEN: status=1, warmup ≥95, inbox rate >90%
   - YELLOW: status=1, warmup 85-94, or inbox rate 80-90%
   - RED: status≠1, or warmup <85, or spam rate >5%
```

### Health Report Template
```
## Sending Account Health Report — [Date]

| Account | Status | Warmup | Inbox Rate | Spam Rate | Daily Limit | Verdict |
|---------|--------|--------|------------|-----------|-------------|---------|
| acct1@domain.com | Active | 99 | 95% | 1% | 30 | ✅ GREEN |
| acct2@domain.com | Active | 97 | 92% | 2% | 25 | ✅ GREEN |
| acct3@domain.com | Active | 88 | 82% | 8% | 15 | ⚠️ YELLOW |

Summary: X accounts GREEN, Y YELLOW, Z RED
Recommended total daily capacity: [sum of safe limits]
```

---

## Warmup Management

### Warmup Score Interpretation
| Score | Status | Action |
|-------|--------|--------|
| 98-100 | Excellent | Safe for full daily limit |
| 95-97 | Good | Safe for moderate sending |
| 90-94 | Warming | Reduce daily limits, monitor closely |
| 80-89 | Needs work | Minimal cold sending, keep warmup active |
| <80 | Critical | DO NOT send cold, warmup only |

### Warmup Analytics Fields
```json
{
  "warmup_emails_sent": 145,
  "warmup_emails_received": 140,
  "inbox_placement_rate": 0.95,
  "spam_rate": 0.02,
  "reply_rate": 0.15,
  "daily_progress": [...]
}
```

### Warmup Rules
1. **Never disable warmup** — Keep it running even during active campaigns
2. **New accounts need 2+ weeks** of warmup before any cold sending
3. **Monitor daily** during first month of cold sending
4. **If spam rate >5%** → Immediately pause cold sends, keep warmup running
5. **If inbox rate drops <85%** → Reduce daily limit by 50%

### Warmup Recovery Protocol
If an account gets flagged:
```
1. Pause all cold campaigns on this account
2. Keep warmup running at full capacity
3. Monitor daily for 1 week
4. If scores recover to >95: re-enable cold at 50% of previous limit
5. If scores don't recover: test vitals, check DNS/SPF/DKIM
6. If persistent: retire the account, bring up replacement
```

---

## Daily Limit Strategy

### Conservative Scaling Approach
```
Week 1-2: 10 emails/day/account (just started cold)
Week 3-4: 20 emails/day/account (warmup holding)
Week 5-8: 30 emails/day/account (stable metrics)
Week 9+:  40-50 emails/day/account (proven deliverability)
```

### Total Capacity Calculation
```
Total daily capacity = Sum(account_daily_limit × account_health_weight)

Health weights:
  GREEN:  1.0
  YELLOW: 0.5
  RED:    0.0

Example: 5 accounts at 30/day, 4 GREEN + 1 YELLOW
= (4 × 30 × 1.0) + (1 × 30 × 0.5) = 135 effective emails/day
```

### When to Scale Up
- All accounts GREEN for 2+ consecutive weeks
- Reply rate >5% (messaging is working)
- Bounce rate <2% (list quality is good)
- No deliverability warnings

### When to Scale Down
- Any account drops below 95 warmup
- Bounce rate creeps above 3%
- Open rates declining week over week
- Spam complaints received

---

## Domain Rotation

### Why Rotate
Sending all cold emails from one domain risks burning that domain's reputation. Rotation distributes the risk across multiple domains.

### Rotation Strategy
- Minimum 3 domains for active cold outreach
- Each domain has 1-2 sending accounts
- Assign campaigns to rotate across accounts from different domains
- If one domain gets flagged, others continue sending

### Domain Health Check
Beyond account-level warmup, monitor:
- SPF record: Properly configured for sending service
- DKIM: Signed correctly
- DMARC: Policy set (at least `p=none` initially)
- Blacklist status: Check against major blacklists weekly
- Google Postmaster: Monitor domain reputation if using Google Workspace

---

## Troubleshooting

### Account Won't Send
```
Symptom: Campaign active but no emails going out
Check:
1. Account status = 1?
2. setup_pending = false?
3. Daily limit not reached?
4. Schedule window — is it currently within sending hours?
5. Leads assigned to campaign?
6. Test vitals: manage_account_state with action "test_vitals"
```

### Warmup Score Dropping
```
Symptom: Score was 99, now 85 and falling
Check:
1. DNS records (SPF, DKIM, DMARC) still valid?
2. IP reputation (shared vs dedicated)?
3. Cold email volume too high vs warmup ratio?
4. Content triggering spam filters?
Action:
1. Pause cold sends immediately
2. Reduce daily limit to warmup-only
3. Monitor for 5-7 days
4. If recovery: resume at 50% limit
5. If no recovery: check DNS, consider new account
```

### High Bounce Rate
```
Symptom: Bounce rate >5%
Check:
1. List quality — where did leads come from?
2. Email verification — were they verified before import?
3. Catch-all domains — common in MENA (returns false valid)
Action:
1. STOP campaign immediately
2. Remove bounced leads
3. Verify remaining leads (use verify_email tool)
4. Resume with clean list at reduced daily limit
```

### Emails Going to Spam
```
Symptom: Sent count high but open rate <10%
Check:
1. Tracking enabled? (turn OFF for cold)
2. Links in email? (minimize or remove)
3. Spam trigger words in subject/body?
4. Sending domain reputation?
5. Warmup score and inbox placement rate?
Action:
1. Turn off open_tracking and link_tracking
2. Remove all links except unsubscribe
3. Rewrite subject line (remove spam triggers)
4. Reduce daily limit by 50%
5. Monitor for 1 week
```
