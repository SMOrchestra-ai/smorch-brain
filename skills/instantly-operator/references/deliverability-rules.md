# Deliverability Rules Reference

## Table of Contents
1. [Core Deliverability Principles](#core-deliverability-principles)
2. [Content Rules](#content-rules)
3. [Technical Setup](#technical-setup)
4. [Warmup Protocol](#warmup-protocol)
5. [Spam Trigger Avoidance](#spam-trigger-avoidance)
6. [Diagnostic Procedures](#diagnostic-procedures)
7. [Emergency Protocols](#emergency-protocols)

---

## Core Deliverability Principles

These rules exist because cold email reputation is fragile and compound — one bad week can take months to recover.

### The 5 Pillars of Cold Email Deliverability
1. **Sender reputation** — Warmup score, domain age, sending patterns
2. **Content quality** — No spam triggers, proper formatting, personalization
3. **List quality** — Verified emails, low bounce rate, targeted audience
4. **Sending patterns** — Conservative limits, proper pacing, consistent volume
5. **Technical setup** — SPF, DKIM, DMARC, proper DNS configuration

### Non-Negotiable Rules
- **ALWAYS** `stop_on_reply: true`
- **ALWAYS** `stop_on_auto_reply: true`
- **DEFAULT** `open_tracking: false` (tracking pixels trigger spam filters)
- **DEFAULT** `link_tracking: false` (link wrapping is a spam signal)
- **DEFAULT** `text_only: true` (plain text performs better for cold)
- **NEVER** send from accounts with warmup score <95
- **NEVER** exceed 50 emails/day/account for cold outreach
- **NEVER** continue sending if bounce rate >5%

---

## Content Rules

### Email Length
- **Maximum 150 words** per email for cold outreach
- Shorter is almost always better (80-120 words is the sweet spot)
- If you can't say it in 150 words, your value prop isn't clear enough

### Formatting for Cold
- Plain text only — no HTML formatting, images, or embedded media
- Use `\n\n` for paragraph breaks (auto-converted on send)
- No bold, italic, colors, or font changes
- No tables, bullet points, or numbered lists in cold emails
- Short paragraphs: 1-3 sentences each
- Maximum 3 paragraphs + sign-off

### Personalization Requirements
- **First line MUST be personalized** — reference something specific to the recipient
- Subject line MUST include at least one personalization variable
- `{{firstName}}` alone is not enough — combine with company-specific context
- `{{personalization}}` custom variable should contain the strongest hook

### CTA Rules
- ONE call-to-action per email (not two, not three — ONE)
- Low friction: "15 minutes this week?" not "Let's schedule a comprehensive discovery session"
- Question format works best: "Worth a quick chat?" "Can I send you more details?"
- Never "Let me know if you're interested" — too passive
- Never "Book a time here [link]" in first email — save for follow-ups

### Signature
- First name only: "Mamoun" or "Best,\nMamoun"
- No full signature blocks with title, company, phone, social links
- No HTML signature with images
- Keep it human — cold emails should feel like one person reaching out

---

## Technical Setup

### DNS Requirements
Every sending domain must have properly configured:

| Record | Purpose | Check |
|--------|---------|-------|
| SPF | Authorizes sending servers | `v=spf1 include:[provider] ~all` |
| DKIM | Signs emails cryptographically | Valid DKIM signature on sent emails |
| DMARC | Policy for failed authentication | `v=DMARC1; p=none; rua=mailto:...` |
| MX | Mail exchange records | Points to valid mail server |
| PTR | Reverse DNS for IP | Matches sending domain |

### Domain Age
- New domains need 2-4 weeks of warmup before any cold sending
- Domains <3 months old should stay under 20 emails/day/account
- Established domains (6+ months) with clean history can handle 50/day/account

---

## Warmup Protocol

### New Account Setup Timeline
```
Week 1: Warmup only, 0 cold emails
Week 2: Warmup only, 0 cold emails (building reputation)
Week 3: 10 cold emails/day (warmup continues)
Week 4: 15-20 cold emails/day (if metrics healthy)
Week 5-6: 25-30 cold emails/day (scaling)
Week 7+: 30-50 cold emails/day (full capacity if healthy)
```

### Warmup-to-Cold Ratio
- Always keep warmup running alongside cold sends
- Warmup emails provide positive engagement signals that counterbalance cold sending
- If you pause warmup, reputation will degrade faster during cold campaigns

### Monitoring Schedule
- **Daily** (first 2 weeks of cold sending): Check warmup scores, bounce rates
- **Every other day** (weeks 3-4): Check key metrics
- **Weekly** (ongoing): Full health report + analytics review

---

## Spam Trigger Avoidance

### Subject Line Triggers
**NEVER use in subject lines:**
```
Free, Guaranteed, Limited time, Act now, Urgent, Important,
Last chance, Don't miss, Exclusive offer, Special promotion,
Deal, Discount, Save, Earn, Winner, Congratulations,
100%, Best price, Lowest price, No cost, No obligation,
RE: (when not a real reply), FW: (when not a real forward)
```

**GOOD subject patterns:**
```
"{{firstName}}, quick question about [specific topic]"
"Thought about {{companyName}} and [observation]"
"[Mutual connection] suggested I reach out"
"Question about [specific initiative at their company]"
"Idea for {{companyName}}'s [specific challenge]"
```

### Body Content Triggers
**Avoid:**
- Excessive caps: "AMAZING OFFER"
- Exclamation marks: More than 1 per email is risky
- Dollar amounts: "$50,000 in revenue"
- Percentage claims: "300% increase"
- Time pressure: "This week only", "limited spots"
- Superlatives: "best", "#1", "leading", "top"
- Generic openers: "I hope this email finds you well"
- Overly salesy language: "revolutionize", "transform", "game-changer"

**Safe patterns:**
- Specific observations about their company
- Questions (not statements of how great you are)
- Short sentences, conversational tone
- References to shared context (industry, geography, mutual connections)

### Link Rules
- **Cold Email Step 1:** Zero links ideally. If you must, maximum 1 (and it will hurt deliverability)
- **Follow-up emails:** Maximum 1 link per email
- **Total across sequence:** Maximum 3 links across all sequence steps
- **Never use:** URL shorteners (bit.ly, etc.) — major spam signal
- **Never use:** Tracking links (link wrapping = spam signal)
- **Safe links:** Direct company URL, calendar booking link (in later steps only)

---

## Diagnostic Procedures

### Full Deliverability Audit
Run when any metric is in Warning or Critical zone:

```
1. ACCOUNT LEVEL
   - list_accounts → check all statuses
   - get_warmup_analytics → scores, inbox rate, spam rate
   - Any accounts with score <95? Flag them.

2. CAMPAIGN LEVEL
   - get_campaign → check settings
     - open_tracking on? Should be off.
     - link_tracking on? Should be off.
     - text_only? Should be true.
   - get_campaign_analytics → bounce rate, reply rate
   - Bounce rate >3%? List quality issue.

3. CONTENT LEVEL
   - Review subject lines for spam triggers
   - Review body for spam triggers
   - Check email length (<150 words?)
   - Check personalization quality
   - Check link count

4. LIST LEVEL
   - How were leads sourced? (Clay = usually clean)
   - Were emails verified?
   - What's the bounce rate per list?
   - Are leads in the right ICP?

5. TECHNICAL LEVEL
   - DNS records valid? (SPF, DKIM, DMARC)
   - Domain age sufficient?
   - IP blacklisted?
   - Shared vs dedicated IP?
```

### Root Cause Matrix
| Symptom | Most Likely Cause | Check First |
|---------|------------------|-------------|
| Opens <30% (if tracked) | Inbox placement | Warmup score, DNS |
| Replies <2% | Messaging | Content, personalization |
| Bounces >3% | List quality | Lead source, verification |
| Unsubs >1% | Targeting | ICP fit, relevance |
| Sent >> Contacted | Scheduling/capacity | Daily limits, time windows |
| Auto-replies >20% | OOO or role emails | Lead data quality |

---

## Emergency Protocols

### DEFCON 1: Bounce Rate >5%
```
IMMEDIATE:
1. Pause ALL campaigns using affected accounts
2. Identify which lead list/segment is causing bounces
3. Remove bounced leads
4. Do NOT resume until bounce rate analyzed and fixed

RECOVERY:
1. Run email verification on remaining leads
2. Reduce daily limits by 50%
3. Resume with verified leads only
4. Monitor daily for 1 week
5. Gradually scale back if metrics stabilize
```

### DEFCON 2: Warmup Score Drop >10 Points
```
IMMEDIATE:
1. Pause cold sending on affected accounts
2. Keep warmup running
3. Check DNS records — any changes?
4. Check if domain is on any blacklists

RECOVERY:
1. Warmup only for 5-7 days
2. If score recovers >95: resume at 50% daily limit
3. If no recovery: test vitals, consider DNS investigation
4. If persistent: retire account, set up replacement
```

### DEFCON 3: Spam Complaints Received
```
IMMEDIATE:
1. Stop sending immediately from affected domain
2. Review content for spam triggers
3. Remove complaining contacts + similar profiles

RECOVERY:
1. Rewrite all email content
2. Reduce volume by 70%
3. Monitor reputation for 2 weeks
4. Slowly scale back if clean
```
