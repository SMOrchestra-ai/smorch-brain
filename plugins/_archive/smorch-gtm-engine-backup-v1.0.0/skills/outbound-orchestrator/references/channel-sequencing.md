# Channel Sequencing Patterns

## Table of Contents
1. Pattern A: Email-First → LinkedIn Follow
2. Pattern B: LinkedIn-First → Email Follow
3. Pattern C: Signal-Triggered Multi-Touch (MENA)
4. Pattern D: Account-Based Multi-Thread (Enterprise)
5. Pattern Selection Guide
6. Timing Grid Template
7. Custom Pattern Builder

---

## Pattern A: Email-First → LinkedIn Follow (Parallel Warm-Up)

Best for: US market, leads with verified email, high email deliverability.

**Timing Grid:**
```
Day  0: [EMAIL]    Instantly Step 1 — cold email, pattern interrupt opener
Day  1: [LINKEDIN] HeyReach profile view (soft touch, creates familiarity)
Day  2: [LINKEDIN] HeyReach connection request with note (reference value prop, NOT the email)
Day  3: [EMAIL]    Instantly Step 2 — follow-up, add proof point
Day  5: [LINKEDIN] IF connected → HeyReach message with value asset
         IF NOT connected → skip, email carries the sequence
Day  6: [EMAIL]    Instantly Step 3 — different angle, social proof
Day  8: [LINKEDIN] IF connected → HeyReach follow-up message
Day 10: [EMAIL]    Instantly Step 4 — breakup email ("closing the loop")
```

**Signal Triggers Within Pattern A:**
- Email open + LinkedIn view within 24hrs → Score +3 compound, flag as warm
- Connection accepted at any point → Shift primary to LinkedIn, reduce email frequency
- Email reply → STOP all LinkedIn touches immediately
- LinkedIn reply → STOP all email touches immediately

**Channel-Specific Content Rules:**
- Email: Can include links, case studies, data points
- LinkedIn connection note: <300 chars, no links, no pitch — pure curiosity hook
- LinkedIn message: Conversational, reference the connection, offer value before ask
- Never reference "I emailed you" in LinkedIn — feels automated

**Variant A1: Compressed (5-day sprint)**
For time-sensitive campaigns (event-based, funding announcements):
```
Day 0: Email + LinkedIn profile view
Day 1: Connection request (no note)
Day 2: Email Step 2
Day 3: IF connected → LinkedIn message
Day 4: Email breakup
```

---

## Pattern B: LinkedIn-First → Email Follow (Authority Build)

Best for: MENA market, C-suite targets, when your LinkedIn presence is strong.

**Timing Grid:**
```
Day  0: [LINKEDIN] HeyReach connection request (NO note — higher accept rate)
Day  1: [LINKEDIN] IF accepted → Message with value (insight, not pitch)
         IF NOT accepted → wait
Day  2: [EMAIL]    Instantly Step 1 — reference "we connected on LinkedIn"
Day  4: [LINKEDIN] Follow-up message — share relevant content/insight
Day  6: [EMAIL]    Instantly Step 2 — different angle, proof point
Day  8: [LINKEDIN] IF engaged → direct ask for 15-min call
Day 10: [EMAIL]    Breakup email
```

**Why No Note on Connection Request:**
Data consistently shows that naked connection requests (no note) get 15-25% higher
acceptance rates than requests with notes. The note often triggers sales-defense mode.
A no-note request feels like organic networking. The follow-up message after acceptance
is where you deliver the value hook.

**Signal Triggers Within Pattern B:**
- Connection accepted within 24hrs → Score +6 (base +3, speed bonus +3)
- Connection accepted + email open → Score compound, upgrade to HOT watch
- LinkedIn message reply → STOP email sequence, continue LinkedIn conversation
- Email reply → Shift primary to email, pause LinkedIn messages

**MENA-Specific Adjustments:**
- LinkedIn message can be slightly longer than US (Gulf professionals expect substance)
- Reference mutual connections or shared geography ("fellow Dubai-based founder")
- Arabic name detection → consider Arabic content variant in GHL WhatsApp follow-up
- Sunday is a working day — Pattern B can start on Sunday for MENA

---

## Pattern C: Signal-Triggered Multi-Touch (MENA Specific)

Best for: MENA market with WhatsApp access, leads who have both email and LinkedIn.

**Timing Grid:**
```
Day  0: [LINKEDIN] Connection request + [EMAIL] Instantly Step 1 (parallel launch)
         → GHL: Create contact with all data, tag campaign:{name}

SIGNAL WATCH (continuous):
  Connection accepted OR email opened →
    → GHL: Tag signal:warm, update signal_score
    → GHL: Trigger WhatsApp via automation
    → WhatsApp language: Arabic if name pattern matches, else English

  Reply on ANY channel →
    → GHL: Tag signal:hot, create opportunity
    → PAUSE all sequences for this lead across ALL channels
    → Slack/webhook alert to sales team

  NO SIGNAL by Day 3:
    Day  3: [EMAIL] Instantly Step 2
    Day  5: [LINKEDIN] IF connected → message | IF NOT → InMail consideration
    Day  7: [EMAIL] Instantly Step 3

  NO SIGNAL by Day 7:
    → Move to nurture sequence (30-day drip, content-only, no hard ask)
    → Tag status:nurture
    → Remove from active campaign tracking
```

**WhatsApp Escalation Rules:**
- Only trigger WhatsApp AFTER a positive signal (open, view, connect)
- Never WhatsApp as first touch — feels invasive
- WhatsApp message must feel personal, not templated
- Include sender's name and photo context
- Single message only — no WhatsApp sequence. If no reply, don't follow up on WhatsApp
- Business hours ONLY: Sun-Thu 09:00-16:00 Gulf Time

**Arabic Name Detection Heuristic:**
If first_name or last_name matches common Arabic name patterns AND location contains
UAE/Saudi/Qatar/Kuwait/Bahrain/Oman/Jordan/Egypt → default to Arabic WhatsApp template.
Let GHL automation handle the language routing based on tags.

---

## Pattern D: Account-Based Multi-Thread (Enterprise)

Best for: Enterprise deals, 3+ contacts at same company, different roles.

**Role-Channel Matrix:**
| Role | Primary Channel | Secondary | Messaging Angle |
|------|----------------|-----------|-----------------|
| CTO/VP Engineering | LinkedIn | Email | Technical credibility, architecture |
| VP Sales/CRO | Email | LinkedIn | ROI, pipeline impact, revenue metrics |
| CEO/MD (MENA) | WhatsApp | LinkedIn | Strategic vision, peer-level positioning |
| CEO/MD (US) | LinkedIn | Email | Strategic vision, industry insight |
| CMO | Email | LinkedIn | Brand impact, customer acquisition cost |

**Coordination Rules:**
1. Max 2 touches per COMPANY per day (across all contacts)
2. Stagger start days: Contact 1 starts Day 0, Contact 2 starts Day 2, Contact 3 starts Day 4
3. Share signals: If CTO engages → warm intro the VP Sales with context
4. If ANY contact replies → flag entire account as engaged
5. Never pitch different value props — unified story, role-appropriate framing
6. Track at company level in GHL: opportunity per company, contacts as associated

**Thread Coordination Example (3 contacts at TechCorp):**
```
Day 0: CTO → LinkedIn connection request
Day 1: CTO → IF accepted, LinkedIn message (technical insight)
Day 2: VP Sales → Email Step 1 (ROI angle)
Day 3: CTO → Email Step 1 (reference LinkedIn exchange if connected)
Day 4: CEO → WhatsApp if MENA / LinkedIn if US
Day 5: VP Sales → LinkedIn connection request
Day 6: CTO → LinkedIn follow-up OR Email Step 2
Day 7: VP Sales → Email Step 2
Day 8: CEO → Follow-up on initial channel
Day 10: Company-wide assessment — any engagement? Route accordingly.
```

---

## Pattern Selection Guide

| Factor | Pattern A | Pattern B | Pattern C | Pattern D |
|--------|-----------|-----------|-----------|-----------|
| Market | US/EU | MENA | MENA | Any |
| Deal size | SMB-Mid | Mid-Enterprise | SMB-Mid | Enterprise only |
| Lead data | Email required | LinkedIn required | Both required | Both + phone |
| LinkedIn presence | Optional | Strong required | Moderate | Multiple contacts |
| WhatsApp access | Not used | Optional | Required | MENA roles only |
| Sequence length | 10 days | 10 days | 7 days + nurture | 10-14 days |
| Best for | Volume plays | Relationship build | Signal detection | Named accounts |

**Decision Tree:**
```
Is this enterprise (>$50K deal)?
  YES → Pattern D (Account-Based)
  NO →
    Is this MENA market?
      YES →
        Has WhatsApp number?
          YES → Pattern C (Signal-Triggered)
          NO  → Pattern B (LinkedIn-First)
      NO →
        Is LinkedIn presence strong?
          YES → Pattern B (LinkedIn-First)
          NO  → Pattern A (Email-First)
```

---

## Timing Grid Template

Use this template when designing custom sequences:

```
Campaign: [name]
Pattern: [A/B/C/D/Custom]
Market: [MENA/US/EU]
Duration: [X days]
Channels: [Email, LinkedIn, WhatsApp]

Day | Channel   | Action              | Content Key      | Fallback
----|-----------|---------------------|------------------|------------------
 0  | Email     | Cold email Step 1   | Pattern interrupt | —
 1  | LinkedIn  | Profile view        | —                | —
 2  | LinkedIn  | Connection request  | No note          | —
 3  | Email     | Follow-up Step 2    | Proof point      | —
...

Signal Triggers:
- [signal] → [action]
- [signal] → [action]
```

---

## Custom Pattern Builder

When none of the 4 standard patterns fit, build a custom sequence:

1. Start with the Pattern Selection Guide to find closest match
2. Adjust timing based on:
   - Urgency (compress for time-sensitive, expand for relationship)
   - Data completeness (fewer channels if missing data)
   - Past performance (check learnings-log.md)
3. Always preserve the non-negotiable timing rules:
   - Max 1 touch per channel per day
   - Max 2 touches per lead per day total
   - 24-hour minimum gap between first and second channel
   - Reply on any channel → pause all others
4. Document the custom pattern in the campaign brief
