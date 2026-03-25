# Campaign Creation Reference

## Table of Contents
1. [3-Stage Creation Workflow](#3-stage-creation-workflow)
2. [Pre-Flight Checklist](#pre-flight-checklist)
3. [Campaign Parameters](#campaign-parameters)
4. [Sequence Building](#sequence-building)
5. [Scheduling Configuration](#scheduling-configuration)
6. [A/B Testing](#ab-testing)

---

## 3-Stage Creation Workflow

The `create_campaign` tool enforces a 3-stage process. Follow it — don't skip stages.

### Stage 1: Prerequisite Check
Call `create_campaign` with `stage: "prerequisite_check"` (or let auto-detection handle it).

This verifies:
- At least one sending account exists and is eligible
- Account warmup status is acceptable
- No configuration blockers

If prerequisites fail, fix the issues before proceeding.

### Stage 2: Preview
After prerequisites pass, the tool generates a preview of what will be created:
- Campaign name, settings
- Sequence structure with subjects/bodies
- Assigned sender accounts
- Schedule and timing

Review the preview carefully. This is your last checkpoint before creation.

### Stage 3: Create
Confirm creation. The campaign is created in **draft** state — it won't start sending until you call `activate_campaign`.

---

## Pre-Flight Checklist

Before calling `create_campaign`, execute these checks manually:

### 1. Account Validation
```
Tool: list_accounts
Check for each account:
  - status == 1 (Active)
  - warmup running and score >= 95
  - Not in error state (-1, -2, -3)
  - setup_pending == false
```

### 2. Warmup Verification
```
Tool: get_warmup_analytics
Input: array of account emails ["account1@domain.com", "account2@domain.com"]
Check:
  - Warmup score >= 95 for each
  - Inbox placement rate > 90%
  - No recent spam rate spikes
```

### 3. Market Determination
Ask the user or infer from context:
- MENA campaign → Gulf timezone, Sun-Thu schedule, direct Arabic-aware tone
- US campaign → CT/ET timezone, Mon-Fri schedule, professional US tone

### 4. Lead Availability
Confirm leads exist or will be added:
- Lead list already created?
- CSV/data ready for bulk upload?
- Clay enrichment completed?

---

## Campaign Parameters

### Required Parameters
```json
{
  "name": "[ICP] - [Wedge] - [Month] [Variant]",
  "email_list": ["sender1@domain.com", "sender2@domain.com"],
  "subject": "{{firstName}}, quick question about [topic]",
  "body": "Hi {{firstName}},\n\n[2-3 sentence opener with personalization]\n\n[Value proposition — 1-2 sentences]\n\n[Specific, low-friction CTA]\n\nBest,\nMamoun"
}
```

### Recommended Settings
```json
{
  "daily_limit": 30,
  "email_gap_minutes": 10,
  "stop_on_reply": true,
  "stop_on_auto_reply": true,
  "open_tracking": false,
  "link_tracking": false,
  "text_only": true
}
```

### Daily Limit Guide
| Account Age | Warmup Score | Recommended Daily Limit |
|------------|-------------|------------------------|
| <2 weeks | <90 | DO NOT send cold |
| 2-4 weeks | 90-94 | 10-15 per account |
| 1-2 months | 95-97 | 20-30 per account |
| 2+ months | 98-100 | 30-50 per account |

With 5 accounts at 30/day = 150 emails/day total. Scale gradually.

### Campaign Naming Convention
Format: `[ICP] - [Wedge] - [Month] [Variant]`

Examples:
- `[MENA SaaS CTOs] - AI Adoption - Feb A`
- `[MENA SaaS CTOs] - AI Adoption - Feb B` (A/B test variant)
- `[US Real Estate] - Lead Gen Automation - Mar A`
- `[Gulf SME Founders] - WhatsApp Sales - Feb A`

---

## Sequence Building

### Instantly API V2 Sequence Structure
Each sequence step must have:
```json
{
  "type": "email",
  "delay": 3,
  "variants": [
    {
      "subject": "Subject line with {{firstName}} personalization",
      "body": "Email body text.\n\nParagraph break.\n\nSign off."
    }
  ]
}
```

**Delay** is in **days** (not hours or minutes).
**Body** uses `\n` for line breaks — auto-converted to HTML on send.
**Variants** array supports A/B testing (multiple variants per step).

### Standard 4-Step Sequence

**Step 1 — Initial Outreach (Day 0)**
Purpose: Pattern interrupt. Show you know them. Make a specific ask.
```json
{
  "type": "email",
  "delay": 0,
  "variants": [{
    "subject": "{{firstName}}, quick thought on [specific topic]",
    "body": "Hi {{firstName}},\n\nNoticed {{companyName}} is [specific observation].\n\nWe helped [similar company] achieve [specific result] using [approach].\n\nWorth 15 minutes this week to see if it could work for you?\n\nMamoun"
  }]
}
```

**Step 2 — Value Add (Day 3)**
Purpose: Provide value, don't just follow up. Share an insight or resource.
```json
{
  "type": "email",
  "delay": 3,
  "variants": [{
    "subject": "Re: {{firstName}}, quick thought on [specific topic]",
    "body": "Hi {{firstName}},\n\nQuick follow-up — I put together a short breakdown of how [similar companies] are handling [problem].\n\nThe key insight: [one-sentence takeaway].\n\nHappy to walk you through how this applies to {{companyName}}.\n\nMamoun"
  }]
}
```

**Step 3 — Social Proof (Day 6)**
Purpose: Case study or specific result that builds credibility.
```json
{
  "type": "email",
  "delay": 3,
  "variants": [{
    "subject": "How [company] solved [problem]",
    "body": "Hi {{firstName}},\n\n[Company name] was facing [same problem]. In [timeframe], they [specific result with numbers].\n\nThe approach was [brief method — 1 sentence].\n\nWould something similar be useful for {{companyName}}?\n\nMamoun"
  }]
}
```

**Step 4 — Breakup (Day 10)**
Purpose: Final touch. Low pressure. Leave door open.
```json
{
  "type": "email",
  "delay": 4,
  "variants": [{
    "subject": "Should I close this out?",
    "body": "Hi {{firstName}},\n\nI've reached out a few times about [topic]. Totally understand if the timing isn't right.\n\nIf things change, happy to pick this up whenever it makes sense.\n\nBest,\nMamoun"
  }]
}
```

---

## Scheduling Configuration

### MENA Campaign Schedule
```json
{
  "timezone": "Asia/Singapore",
  "timing_from": "08:00",
  "timing_to": "16:00",
  "days": [0, 1, 2, 3, 4]
}
```
Days: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday
Note: `Asia/Singapore` (UTC+8) is used as Instantly's closest proxy to Gulf time (UTC+4). Adjust send window if needed — the actual delivery time in Gulf will be 4 hours earlier.

### US Campaign Schedule
```json
{
  "timezone": "America/Chicago",
  "timing_from": "09:00",
  "timing_to": "17:00",
  "days": [1, 2, 3, 4, 5]
}
```
Days: 1=Monday through 5=Friday

### Schedule Notes
- `email_gap_minutes: 10` means minimum 10 minutes between sends from the same account
- With 5 accounts and 10-min gap, theoretical max is 30 emails/hour/account = ~240/hour total in the send window
- Keep actual daily limits well below theoretical max for deliverability

---

## A/B Testing

### Subject Line A/B Test
Add multiple variants to the same step:
```json
{
  "type": "email",
  "delay": 0,
  "variants": [
    {
      "subject": "{{firstName}}, saw this about {{companyName}}",
      "body": "[same body]"
    },
    {
      "subject": "Quick question about [topic], {{firstName}}",
      "body": "[same body]"
    }
  ]
}
```

### A/B Testing Rules
1. Only change ONE variable per test (subject OR body, not both)
2. Minimum 200 sends per variant for statistical significance
3. Run for at least 5 business days before drawing conclusions
4. Reply rate is the primary metric (not opens — tracking is off)
5. Name campaigns with variant suffix: `...Feb A` vs `...Feb B`

### What to A/B Test (Priority)
1. Subject line personalization ({{firstName}} vs {{companyName}} vs specific reference)
2. CTA style (question vs statement, time-bound vs open)
3. Opening line approach (observation vs question vs stat)
4. Sequence length (3 steps vs 4 steps)
5. Step delay timing (2-day vs 3-day gaps)
