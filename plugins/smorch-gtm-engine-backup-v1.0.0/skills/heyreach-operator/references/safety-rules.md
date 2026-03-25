# LinkedIn Safety Rules Reference

## Table of Contents
1. Daily Limits by Action Type
2. Account Protection Protocol
3. Deduplication Rules
4. Sender Rotation Safety
5. Content Safety
6. Risk Detection & Response
7. Emergency Procedures

---

## 1. Daily Limits by Action Type

### Hard Limits (Never Exceed)
| Action | Per Account/Day | Notes |
|--------|----------------|-------|
| Connection requests | 40 max | LinkedIn's known threshold. Stay at 20-30 for safety. |
| Messages (to connections) | 150 max | Stay at 50-80 for sustained campaigns |
| InMails | 30 max | Depends on subscription tier. Stay at 15-20. |
| Profile views | 100 max | Lower priority signal, but still tracked |
| Post likes/comments | 50 max | Soft engagement, lower risk |

### Conservative Targets (Recommended)
| Action | Per Account/Day | Why |
|--------|----------------|-----|
| Connection requests | 25-30 | Sweet spot for volume + safety |
| Messages | 60-80 | Leaves headroom for manual activity |
| InMails | 15 | Quality over quantity |
| Profile views | 50 | Natural browsing level |

### Warmup Period Limits
| Week | Connection Requests/Day | Messages/Day |
|------|------------------------|-------------|
| 1-2 | 5-10 (manual only) | 10-15 |
| 3 | 10-15 (light automation) | 20-30 |
| 4 | 15-25 | 40-60 |
| 5+ | 25-35 (full automation) | 60-80 |
| 8+ | 30-40 (max sustainable) | 80-100 |

---

## 2. Account Protection Protocol

### Before Any Automated Action
1. Verify account auth is valid
2. Check current day's activity count
3. Calculate remaining capacity: `daily_limit - today_sent`
4. If remaining < 20% of daily limit → skip this account for today

### Account Health Indicators
| Indicator | Healthy | Warning | Critical |
|-----------|---------|---------|----------|
| Connection acceptance rate | >25% | 15-25% | <15% |
| Request failure rate | <5% | 5-15% | >15% |
| Account auth status | Valid | — | Invalid/Expired |
| Days since last restriction | >30 | 14-30 | <14 |

### When LinkedIn Sends Warnings
If a sender account receives LinkedIn warnings or restrictions:
1. **Immediately** pause all HeyReach campaigns using this sender
2. Wait minimum **72 hours** (not 48 — extra caution)
3. After 72h: resume with **50% of previous daily volume**
4. If no further warnings for 7 days: gradually increase back to normal
5. Log the incident in learnings-log.md with date and circumstances

### Account Suspension Recovery
If an account gets temporarily suspended:
1. Do NOT try to automate anything for **2 weeks minimum**
2. Sender should use LinkedIn manually only during this period
3. After 2 weeks: restart at Week 1 warmup levels
4. Full recovery to normal automation: 4-6 weeks

---

## 3. Deduplication Rules

### Rule 1: Never Enroll in Multiple Active Campaigns
A lead should be in exactly ONE active HeyReach campaign at a time.

Check before enrollment:
```
get_campaigns_for_lead(profileUrl=lead_url)
→ If ANY campaign has status IN_PROGRESS or PAUSED → SKIP
→ If all campaigns are FINISHED/CANCELED → OK to enroll
```

### Rule 2: Cross-Channel Awareness
Same lead can be in both HeyReach (LinkedIn) and Instantly (email) — that's fine.
But coordinate timing:
- Option A: LinkedIn first (Day 1), email follow-up (Day 3-4)
- Option B: Email first (Day 1), LinkedIn connection (Day 2-3)
- Never send both channels on the same day

### Rule 3: List-Level Dedup
Before adding leads to a list:
- Check if lead already exists via `get_leads_from_list` with keyword search
- Or use `add_leads_to_list_v2` which handles duplicates gracefully (reports "updated" count)

### Rule 4: Campaign Re-Enrollment
- If a lead was in a FINISHED campaign and didn't reply → OK to enroll in new campaign after 14-day cooling period
- If a lead replied negatively → Never re-enroll. Tag as `status:not_interested`.
- If a lead replied positively → Never re-enroll. They should be in manual follow-up.

---

## 4. Sender Rotation Safety

### Rotation Rules
- Distribute leads evenly across senders
- Never give one sender >40% of total campaign volume
- If a sender's connection rate drops below 15%, reduce their allocation
- Keep at least 20% capacity buffer per sender per day

### Multi-Sender Campaign Checks
Before launching a multi-sender campaign:
1. Verify all senders have valid auth
2. Verify all senders are warmed up (minimum 4 weeks of activity)
3. Calculate total daily capacity across all senders
4. Ensure total enrolled leads don't exceed 3 days of total capacity
5. Map leads to senders (geographic match preferred)

### Sender Health Monitoring
Weekly check for each sender:
1. Pull per-sender stats from `get_overall_stats` filtered by account
2. Compare connection rate to campaign average
3. Flag senders performing 30%+ below average
4. Investigate: profile issue? audience mismatch? LinkedIn throttling?

---

## 5. Content Safety

### Connection Request Notes
- Max 300 characters (LinkedIn hard limit)
- No links (LinkedIn may not deliver or may flag)
- No pitch or sales language
- Do: reference mutual connection, shared industry, recent post
- Don't: mention products, services, pricing, or "I'd love to connect to sell you..."

### Follow-Up Messages
- Keep under 500 characters for best engagement
- No more than 1 link per message (and only after connection established)
- No attachments in first 2 messages
- Conversational tone — LinkedIn is not email
- Never use email templates on LinkedIn (different platform, different norms)

### InMail Rules
- Subject line: <100 chars, question format works best
- Body: 3-5 sentences max
- Personalization mandatory (reference their work, company, recent activity)
- CTA: question, not demand

### What NOT to Send
- Mass promotional messages (LinkedIn will flag)
- Same message to >50 people without variation (pattern detection)
- Links to external pages in connection requests
- Generic "I'd like to add you to my network" (low acceptance, wastes quota)
- Anything that sounds automated (templates without personalization)

---

## 6. Risk Detection & Response

### Early Warning Signs
| Signal | Risk Level | Action |
|--------|-----------|--------|
| Connection rate drops >10 points in a week | High | Pause sender, investigate |
| >5 "I don't know this person" flags in a day | Critical | Pause immediately |
| Account auth expires | High | Re-authenticate, pause all campaigns |
| LinkedIn sends "unusual activity" email | Critical | Stop all automation 72h minimum |
| Failure rate >15% on a campaign | Medium | Check lead data quality |

### Response Escalation
| Level | Trigger | Response |
|-------|---------|----------|
| Level 1 | Single metric in warning range | Monitor closely, no immediate action |
| Level 2 | Multiple metrics in warning OR single in critical | Pause the affected sender/campaign |
| Level 3 | Account warning from LinkedIn | Full stop on account, 72h minimum |
| Level 4 | Account restriction/suspension | 2-week manual-only period, then slow re-warmup |

---

## 7. Emergency Procedures

### DEFCON 1: Account Restricted by LinkedIn
1. `pause_campaign` for ALL campaigns using this sender
2. Remove sender from all active campaign assignments
3. Notify user immediately
4. Do NOT attempt to re-authenticate or resume for minimum 2 weeks
5. Log incident with date, activity level, and possible cause

### DEFCON 2: Connection Rate Crash (<10%)
1. `pause_campaign` for campaigns using this sender
2. Check lead data quality (are profile URLs valid? Is audience right?)
3. Review connection note content (is it triggering spam flags?)
4. Wait 48 hours minimum
5. Resume at 50% volume if rate recovers

### DEFCON 3: High Failure Rate (>20%)
1. Stop adding new leads to affected campaign
2. Check lead data: are profile URLs valid and properly formatted?
3. Test a few leads manually via `get_lead` to verify data
4. If data issue: clean list and re-enroll with valid data
5. If account issue: check auth and account status
