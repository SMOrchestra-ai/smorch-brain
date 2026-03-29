# Messaging Channels Reference

## Table of Contents
1. [Channel Selection Matrix](#channel-selection-matrix)
2. [WhatsApp (MENA Primary)](#whatsapp-mena-primary)
3. [SMS (US Primary)](#sms-us-primary)
4. [Warm Email (Both Markets)](#warm-email-both-markets)
5. [Channel Sequencing](#channel-sequencing)
6. [Message Templates](#message-templates)

---

## Channel Selection Matrix

The right channel depends on three factors: market, engagement stage, and contact preference.

### By Market
| Market | Primary | Secondary | Tertiary |
|--------|---------|-----------|----------|
| UAE | WhatsApp | Email | SMS |
| Saudi Arabia | WhatsApp | Email | SMS |
| Qatar | WhatsApp | Email | SMS |
| Kuwait | WhatsApp | Email | SMS |
| Jordan | WhatsApp | Email | SMS |
| United States | SMS | Email | LinkedIn |
| Europe | Email | LinkedIn | SMS |
| India | WhatsApp | Email | SMS |

### By Engagement Stage
| Stage | Channel Priority | Why |
|-------|-----------------|-----|
| Signal just detected | Email (warm follow-up) | Low friction, async |
| Qualified (score 7+) | WhatsApp (MENA) / SMS (US) | Personal, high response rate |
| Meeting follow-up | WhatsApp or Email | Confirmation + prep materials |
| Post-meeting | Email | Professional, documented |
| Proposal follow-up | WhatsApp (MENA) / Email (US) | Urgency without pressure |
| Re-engagement (30+ days cold) | Email | Non-intrusive, reactivation |

### Channel Detection
Check the contact record:
- Has `channel:whatsapp` tag → WhatsApp eligible
- Phone starts with MENA prefix (+971/+966/+974/+965) → Default WhatsApp
- Phone starts with +1 → Default SMS
- No phone → Email only
- Has `contact_preference:email` → Respect preference regardless of phone

---

## WhatsApp (MENA Primary)

WhatsApp is the default business communication channel in the Gulf. Response rates are 3-5x higher than email for MENA contacts.

### MCP Tool
```
Tool: mcp__ghl-mcp__send_sms
Note: GHL routes WhatsApp through the SMS API when the contact has WhatsApp enabled.
The same tool handles both SMS and WhatsApp depending on the contact's channel configuration.
```

### Compliance Rules
1. **24-hour window** — After a contact messages you, you have 24 hours to respond freely. Outside this window, you must use an approved template message.
2. **Opt-in required** — Only message contacts who have opted in via form, reply, or business relationship.
3. **No bulk unsolicited** — WhatsApp is for conversations, not blasts. Bulk messaging via WhatsApp Business API requires approved templates.
4. **Business hours** — Sunday-Thursday, 9AM-6PM Gulf time (GST, UTC+4). Friday-Saturday are weekend in MENA.

### Timing Guidelines
| Day | Best Window (GST) | Notes |
|-----|-------------------|-------|
| Sunday | 10AM-12PM, 2PM-5PM | Week starts in MENA |
| Monday | 9AM-12PM, 2PM-5PM | High engagement |
| Tuesday | 9AM-12PM, 2PM-5PM | Peak day |
| Wednesday | 9AM-12PM, 2PM-5PM | High engagement |
| Thursday | 9AM-12PM | Half day in some orgs |
| Friday | AVOID | Weekend in MENA |
| Saturday | AVOID | Weekend in MENA |

### Language Selection
- **Arabic-name contact** (Ahmed, Fatima, Mohammed, etc.) → Arabic message by default
- **Known English speaker** (from prior conversation or preference) → English
- **Mixed/uncertain** → English with Arabic greeting (e.g., "مرحبا Ahmed, ...")
- **Arabic style** → Conversational Gulf Arabic, NOT formal MSA. Mix English tech terms naturally.

### WhatsApp Message Principles
- Keep under 200 characters when possible
- One question per message (don't overwhelm)
- Use voice note style phrasing (conversational, not corporate)
- Include a specific, low-friction CTA
- Never use "Dear Sir/Madam" formality — WhatsApp is personal

### WhatsApp Templates

**Hot signal follow-up (Arabic):**
```
مرحبا [Name]، شكراً على اهتمامك.

عندي فكرة ممكن تساعدك في [specific problem]. تقدر نحكي 15 دقيقة هالأسبوع؟
```

**Hot signal follow-up (English):**
```
Hi [Name], noticed your interest in [topic].

Quick question — are you currently looking at [specific problem area]? Happy to share what's working for similar companies in the Gulf.
```

**Meeting confirmation:**
```
Hi [Name], confirming our call [day] at [time] GST.

I'll share a quick 3-min overview of [solution area] — no deck, just real examples. See you then.
```

**Post-meeting follow-up:**
```
[Name], great speaking with you today.

As discussed, I'll send over [specific deliverable] by [date]. Let me know if you need anything before then.
```

**Re-engagement (30+ days):**
```
Hi [Name], hope all is well.

Quick one — we just published [relevant content/case study]. Thought of you given your work in [area]. Worth a look: [link]
```

---

## SMS (US Primary)

### MCP Tool
```
Tool: mcp__ghl-mcp__send_sms
```

### Compliance Rules (TCPA)
1. **Express consent** — Only SMS contacts who have opted in or have an existing business relationship
2. **Opt-out** — Honor STOP/UNSUBSCRIBE immediately
3. **Identification** — Include your business name in first message
4. **Hours** — Never SMS before 8AM or after 9PM in the contact's local timezone
5. **Frequency** — No more than 2-3 SMS per week per contact

### Timing Guidelines
| Day | Best Window (Local) | Notes |
|-----|---------------------|-------|
| Monday | 10AM-12PM, 2PM-4PM | After morning rush |
| Tuesday | 10AM-12PM, 2PM-4PM | Peak day |
| Wednesday | 10AM-12PM, 2PM-4PM | High engagement |
| Thursday | 10AM-12PM | Before weekend wind-down |
| Friday | 10AM-12PM | Good for quick replies |
| Saturday-Sunday | AVOID | Unless contact expects it |

### SMS Principles
- Keep under 160 characters (single segment)
- Include clear CTA
- Always identify yourself: "Hi [Name], this is [Your Name] from SMOrchestra"
- Include opt-out: "Reply STOP to opt out"
- No links in first SMS (spam filters)

### SMS Templates

**Hot signal follow-up:**
```
Hi [Name], this is Mamoun from SMOrchestra. Saw your interest in [topic]. Quick call this week? I'll share what's working for [industry] companies.
```

**Meeting reminder:**
```
Hi [Name], reminder: we're set for [day] at [time] [timezone]. Looking forward to it. - Mamoun
```

---

## Warm Email (Both Markets)

### Important Distinction
**Warm email via GHL ≠ Cold email via Instantly**

| | GHL Email | Instantly Email |
|--|-----------|----------------|
| Purpose | Follow-up, nurture, relationship | First-touch, cold outreach |
| Who gets it | Engaged contacts (replied, visited, etc.) | Cold prospects, no prior engagement |
| Format | Can be HTML, rich media | Plain text only (deliverability) |
| Sending domain | Business domain (connected in GHL) | Separate sending domains |
| Trigger | Signal detected, meeting follow-up | Campaign sequence |

### MCP Tool
```
Tool: mcp__ghl-mcp__send_email
Parameters: contactId, subject, body (HTML or plain), from (optional)
```

### Email Use Cases in GHL
1. **Post-signal warm follow-up** — Contact replied to cold email, now warm
2. **Meeting confirmation and prep** — Calendar details + what to expect
3. **Proposal delivery** — Formal proposal with attachments
4. **Content sharing** — Case studies, relevant articles, thought leadership
5. **Nurture sequence** — Ongoing value delivery for warm-but-not-ready contacts
6. **Win/loss follow-up** — Thank you (won) or feedback request (lost)

### Email Principles
- Subject line: specific, not clickbait. "Re: [previous subject]" for continuity
- Open with reference to prior interaction
- Keep under 150 words for follow-ups
- One CTA per email
- Rich HTML for proposals/case studies, plain text for personal messages
- Always sign with name, title, and direct calendar link

---

## Channel Sequencing

### MENA Hot Lead Sequence
```
Day 0: WhatsApp (immediate follow-up after signal)
Day 1: Email (if no WhatsApp response)
Day 3: WhatsApp (follow-up with different angle)
Day 5: Email (share relevant content/case study)
Day 7: WhatsApp (last touch — specific CTA)
Day 14: Email (re-engagement with new value prop)
```

### US Hot Lead Sequence
```
Day 0: SMS (immediate follow-up after signal)
Day 1: Email (detailed follow-up)
Day 3: SMS (quick check-in)
Day 5: Email (case study or content share)
Day 7: Email (final touch with calendar link)
Day 14: Email (re-engagement)
```

### Warm Nurture Sequence (Both Markets)
```
Week 1: Email (value content — no ask)
Week 3: Email (case study relevant to their industry)
Week 5: WhatsApp/SMS (personal check-in)
Week 7: Email (industry insight or report)
Week 9: WhatsApp/SMS (direct meeting ask)
Week 12: Email (re-engagement or archive)
```

---

## Response Benchmarks

Track these to evaluate channel effectiveness:

| Channel | Market | Response Rate Target | Time to Response |
|---------|--------|---------------------|------------------|
| WhatsApp | MENA | >40% | <4 hours |
| WhatsApp | Global | >25% | <8 hours |
| SMS | US | >15% | <2 hours |
| Warm Email | All | >20% | <24 hours |
| Cold Email (Instantly) | All | >3% reply rate | <48 hours |

If a channel consistently underperforms these benchmarks, switch to the next priority channel for that market.
