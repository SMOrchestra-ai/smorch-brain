# Signal Scoring Matrix

## Table of Contents
1. Base Signal Scores
2. Compound Signal Detection
3. Score Routing Thresholds
4. Decay Rules
5. Cross-Channel Signal Correlation
6. Scoring Implementation Guide

---

## Base Signal Scores

### Email Signals (Instantly)

| Signal | Points | Detection Method | Notes |
|--------|--------|-----------------|-------|
| Email sent | 0 | Campaign log | No score — outbound action, not signal |
| Email opened | +1 | Instantly analytics | Only first open counts per email |
| Email link clicked | +2 | Instantly analytics | Each unique link = +2 |
| Email replied | +8 | Instantly inbox | Auto-detect: positive vs negative |
| Email forwarded | +3 | Instantly tracking | Forward indicates internal sharing |
| Email bounced | -10 | Instantly analytics | Remove from all channels |
| Email unsubscribed | STOP | Instantly webhook | Opt out ALL channels immediately |

### LinkedIn Signals (HeyReach)

| Signal | Points | Detection Method | Notes |
|--------|--------|-----------------|-------|
| Connection request sent | 0 | Campaign log | Outbound action |
| Profile viewed | +1 | HeyReach webhook | VIEWED_PROFILE event |
| Connection accepted | +3 | HeyReach webhook | CONNECTION_REQUEST_ACCEPTED |
| Connection accepted <24hrs | +3 bonus | Timestamp delta | Speed indicates interest |
| Message sent | 0 | Campaign log | Outbound action |
| Message replied | +8 | HeyReach webhook | MESSAGE_REPLY_RECEIVED |
| InMail replied | +6 | HeyReach webhook | INMAIL_REPLY_RECEIVED |
| Post liked by lead | +2 | HeyReach webhook | LIKED_POST (if tracked) |
| Followed your profile | +2 | HeyReach webhook | FOLLOW_SENT by lead |

### WhatsApp/SMS/CRM Signals (GHL)

| Signal | Points | Detection Method | Notes |
|--------|--------|-----------------|-------|
| WhatsApp delivered | 0 | GHL webhook | Delivery confirmation only |
| WhatsApp read | +1 | GHL webhook | Read receipt |
| WhatsApp replied | +8 | GHL webhook | Any reply |
| SMS replied | +8 | GHL webhook | Any reply |
| Form submitted | +10 | GHL webhook | High intent — immediate route to sales |
| Meeting booked | +10 | GHL calendar | Highest intent signal |
| Called inbound | +10 | GHL phone | Immediate human follow-up required |

### External Signals (n8n webhooks)

| Signal | Points | Detection Method | Notes |
|--------|--------|-----------------|-------|
| Website visited | +2 | n8n webhook from tracking | Requires website tracking setup |
| Pricing page visited | +5 | n8n webhook, URL filter | High intent page |
| Content downloaded | +3 | n8n webhook from form/gated | Lead magnet engagement |
| Job posting published | +2 | n8n scraping workflow | Hiring = budget signal |
| Funding announcement | +4 | n8n scraping workflow | Funding = spend trigger |

---

## Compound Signal Detection

Compound signals occur when actions from DIFFERENT channels happen within a time window.
They indicate higher intent than isolated signals because the lead is actively engaging
across touchpoints.

### Compound Rules

| Signal A | + Signal B | Window | Bonus | Total Example |
|----------|-----------|--------|-------|---------------|
| Email opened | LinkedIn profile view | 48 hrs | +2 | 1+1+2 = 4 |
| Email opened | LinkedIn connection accepted | 48 hrs | +3 | 1+3+3 = 7 (auto-HOT) |
| LinkedIn connection | Email link click | 48 hrs | +3 | 3+2+3 = 8 (auto-HOT) |
| Email opened | Website visit | 48 hrs | +3 | 1+2+3 = 6 (WARM) |
| LinkedIn view | Website visit | 48 hrs | +3 | 1+2+3 = 6 (WARM) |
| Any outbound touch | Website visit <6hrs | 6 hrs | +3 | Strong correlation |
| Email reply | LinkedIn reply | 48 hrs | +5 | 8+8+5 = 21 (SUPER-HOT) |
| WhatsApp read | Website visit | 24 hrs | +4 | 1+2+4 = 7 (auto-HOT) |

### Detection Algorithm

```
For each lead, on every new signal event:
1. Fetch all signals for this lead from past 48 hours
2. Group by channel
3. If signals exist from 2+ different channels:
   a. Find the matching compound rule
   b. Apply bonus to aggregate_score
   c. Tag lead with signal:compound in GHL
   d. Log compound detection to GHL contact notes
4. If signals from 3+ channels within 48hrs:
   → Automatic HOT regardless of score
   → Create opportunity immediately
   → Alert: "Triple-channel engagement detected"
```

### Temporal Cluster Analysis

Beyond simple compound rules, look for engagement velocity:

- **Acceleration**: 3+ signals in 24 hours from any combination = priority escalation
- **Sustained interest**: Signals on 3+ consecutive days = nurture to meeting push
- **Dormant reactivation**: No activity for 14+ days, then sudden signal = re-engage immediately

---

## Score Routing Thresholds

| Score Range | Status | Action |
|-------------|--------|--------|
| ≥10 | SUPER-HOT | Immediate human follow-up, create opportunity, pause all automation |
| 7-9 | HOT | Pause cold sequences, create opportunity, escalate to warm channel |
| 4-6 | WARM | Activate secondary channel, increase touch frequency, add to nurture |
| 1-3 | COLD | Continue sequence as planned, no escalation |
| 0 | UNTOUCHED | Not yet in sequence or no engagement |
| <0 | BOUNCED/INVALID | Remove from all campaigns, clean data |

### Routing Actions by Score

**SUPER-HOT (≥10):**
1. Pause ALL automated sequences immediately
2. Create GHL opportunity, stage: "Hot Lead"
3. Send Slack alert with full signal history
4. Assign to sales rep for manual follow-up within 2 hours
5. Prepare call brief with all touchpoint history

**HOT (7-9):**
1. Pause cold sequences (Instantly, HeyReach outbound)
2. Create GHL opportunity, stage: "Qualified"
3. If MENA + WhatsApp available → send personalized WhatsApp
4. If US → send personalized email from senior team member
5. Book meeting CTA — reduce friction to zero

**WARM (4-6):**
1. Keep primary channel active
2. Activate secondary channel if not already
3. Increase content sharing (case studies, insights)
4. Tag signal:warm in GHL
5. Add to weekly review list

**COLD (1-3):**
1. Continue sequence as designed
2. No escalation or channel changes
3. Monitor for compound signals

---

## Decay Rules

Signals lose value over time. Recalculate scores weekly.

| Signal Age | Multiplier | Rationale |
|-----------|-----------|-----------|
| 0-7 days | 1.0x (full value) | Fresh signal, high relevance |
| 8-14 days | 0.75x | Recent but cooling |
| 15-30 days | 0.5x | Warm memory, declining intent |
| 31-60 days | 0.25x | Stale, needs re-engagement |
| 60+ days | 0x (expired) | Remove from scoring, archive |

**Exception:** Meeting booked and form submitted signals do NOT decay. They represent
concrete conversion actions.

**Weekly Recalculation:**
Every Monday (or Sunday for MENA), recalculate all lead scores:
1. Fetch all signals per lead
2. Apply decay multiplier based on signal age
3. Recalculate compound bonuses (only if both signals still within 48hr window)
4. Update GHL custom field `signal_score`
5. Re-route leads whose status changed (e.g., WARM → COLD)

---

## Cross-Channel Signal Correlation

### Which signals predict conversion?

Based on general B2B outbound benchmarks (update with actual data as campaigns run):

| Signal Combination | Conversion Likelihood | Recommended Action |
|-------------------|----------------------|-------------------|
| Email open → LinkedIn connect (same week) | 3-5x baseline | LinkedIn message with value asset |
| LinkedIn connect → Website visit (48hrs) | 5-7x baseline | WhatsApp or direct email from founder |
| Email reply (positive) | 10x baseline | Immediate call/meeting booking |
| Triple channel (email+LinkedIn+web) in 1 week | 8-12x baseline | VIP treatment, personal outreach |
| Email opens but never replies (3+ opens) | 2x baseline | Try different channel entirely |
| LinkedIn connect but ignores messages | 1.5x baseline | Switch to email, reference connection |

### Anti-Signals (Negative Indicators)

| Signal | Score Impact | Action |
|--------|-------------|--------|
| Email bounce | -10 | Remove from email, keep LinkedIn if active |
| Unsubscribe | STOP ALL | Respect across every channel |
| LinkedIn "I'm not interested" | -5 | Pause LinkedIn, email only if already engaged |
| WhatsApp block | STOP ALL | Full opt-out |
| No engagement after full sequence | 0 (neutral) | 30-day cool-off, then rescue campaign |

---

## Scoring Implementation Guide

### Where Scores Live

Primary source of truth: **GHL contact custom field `signal_score`**

Each channel feeds signals to GHL via n8n webhooks:
```
Instantly webhook → n8n → GHL update contact (score += delta)
HeyReach webhook → n8n → GHL update contact (score += delta)
GHL native events → direct update (WhatsApp, forms, meetings)
External events → n8n → GHL update contact (score += delta)
```

### Signal Log Format in GHL Notes

Every signal event should append to GHL contact notes:
```
[2026-02-22 10:34 UTC] SIGNAL: email_opened | Channel: instantly | Score: +1 | Aggregate: 4
[2026-02-22 14:12 UTC] SIGNAL: linkedin_connection_accepted | Channel: heyreach | Score: +3 | Compound: +2 (email_open 48hr) | Aggregate: 9
[2026-02-22 14:12 UTC] ROUTING: Score 9 → HOT | Action: Pause sequences, create opportunity
```

### n8n Webhook Endpoints for Scoring

| Source | Webhook URL Pattern | Events |
|--------|-------------------|--------|
| Instantly | `https://ai.mamounalamouri.smorchestra.com/webhook/instantly-signal` | Reply, open, click, bounce |
| HeyReach | `https://ai.mamounalamouri.smorchestra.com/webhook/heyreach-signal` | Connection, reply, view |
| GHL | Native triggers | WhatsApp, form, meeting |
| Website | `https://ai.mamounalamouri.smorchestra.com/webhook/web-signal` | Page visit, pricing view |
