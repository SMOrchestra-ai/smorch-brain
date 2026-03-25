# Sequence Templates Reference

## Table of Contents
1. [Template Architecture](#template-architecture)
2. [MENA SaaS Sequence](#mena-saas-sequence)
3. [US B2B Sequence](#us-b2b-sequence)
4. [MENA SME Sequence](#mena-sme-sequence)
5. [Re-Engagement Sequence](#re-engagement-sequence)
6. [Sequence Customization Guide](#sequence-customization-guide)

---

## Template Architecture

### Sequence Design Principles
Every cold email sequence follows the same emotional arc:

```
Step 1: "I see you" — Show you understand their world (relevance)
Step 2: "Here's proof" — Demonstrate competence (credibility)
Step 3: "Others trust us" — Social proof from similar companies (validation)
Step 4: "No pressure" — Graceful exit that keeps door open (respect)
```

Each step has a distinct job. If a step doesn't earn its place, cut it.

### Technical Structure
```json
{
  "sequence_steps": [
    {
      "type": "email",
      "delay": 0,
      "variants": [{
        "subject": "Subject with {{personalization}}",
        "body": "Body text with \\n\\n for paragraphs"
      }]
    }
  ]
}
```

- `delay` is in days from previous step
- First step always `delay: 0`
- `\n\n` creates paragraph breaks
- `\n` creates line breaks
- Personalization: `{{firstName}}`, `{{companyName}}`, `{{personalization}}`, custom vars

---

## MENA SaaS Sequence

**Target:** SaaS founders, CxOs, VP Sales in UAE, KSA, Qatar, Kuwait
**Tone:** Direct, insight-driven, Gulf business culture aware. No fluff.
**CTA:** 15-min call. Low friction.

### Step 1 — Day 0: The Observation
```
Subject: {{firstName}}, noticed something about {{companyName}}

Hi {{firstName}},

{{personalization}}.

Most SaaS companies scaling in the Gulf hit the same wall — the GTM playbook from the US doesn't translate here. The trust mechanics are completely different.

We built a signal-based system that detects buying intent before it surfaces in conversations. Worth a quick 15-minute chat to see if it fits what you're doing?

Mamoun
```

### Step 2 — Day 3: The Insight
```
Subject: Re: {{firstName}}, noticed something about {{companyName}}

Hi {{firstName}},

Quick thought — we analyzed GTM patterns across 200+ B2B companies in the Gulf last quarter.

The ones growing fastest aren't doing more outbound. They're detecting signals earlier and responding faster than competitors.

One company in your space cut their sales cycle from 90 days to 35 using this approach.

Happy to share the specifics if useful.

Mamoun
```

### Step 3 — Day 6: The Proof
```
Subject: How [similar company] cut their sales cycle in half

{{firstName}},

[Company name] was spending $15K/month on SDRs and getting 3 meetings. Now they get 12 — with zero SDR headcount.

The shift: they stopped guessing who's ready and started detecting it.

Same market as {{companyName}}. Want me to show you the exact setup?

Mamoun
```

### Step 4 — Day 10: The Exit
```
Subject: Should I close this out, {{firstName}}?

{{firstName}},

I've reached out a couple times about signal-based GTM for {{companyName}}.

Totally get it if timing's off. I'll close this thread — but if things change, I'm always around.

Best,
Mamoun
```

---

## US B2B Sequence

**Target:** VP Marketing, Revenue leaders, Heads of Growth in US companies
**Tone:** Professional, data-driven, direct. Respect their time.
**CTA:** 15 minutes. Specific value proposition.

### Step 1 — Day 0: The Hook
```
Subject: {{firstName}} — quick question about {{companyName}}'s outbound

Hi {{firstName}},

{{personalization}}.

I work with B2B teams that want to scale outbound without adding headcount. The usual playbook (more SDRs, more calls, more spray-and-pray) has diminishing returns after a point.

We take a different approach — detecting buying signals before your competitors do and responding with precision instead of volume.

Would 15 minutes be worth it to see if this applies to {{companyName}}?

Mamoun
```

### Step 2 — Day 3: The Value Drop
```
Subject: Re: quick question about {{companyName}}'s outbound

Hi {{firstName}},

Following up with something concrete — we published a breakdown of how signal-based outbound outperforms traditional SDR models by 3x on reply rates.

The core idea: instead of more volume, detect the 5% who are actually in-market right now and hit them with precision.

Worth a look if you're thinking about Q2 pipeline.

Mamoun
```

### Step 3 — Day 7: Social Proof
```
Subject: What [company] did differently

{{firstName}},

[Company name] was running the standard playbook — 10 SDRs, 200 calls/day, 2% connect rate.

They switched to signal-based targeting last quarter. Result: 8x more qualified meetings with 60% less effort.

Happy to share the specifics if relevant to what {{companyName}} is building.

Mamoun
```

### Step 4 — Day 11: The Breakup
```
Subject: Closing the loop

{{firstName}},

I don't want to be that person who keeps emailing. If outbound optimization isn't a priority right now, no worries at all.

If it becomes one, I'm easy to find.

Mamoun
```

---

## MENA SME Sequence

**Target:** Small business owners in Gulf — real estate, beauty clinics, service businesses
**Tone:** Simpler language, focus on results, Arabic-friendly names
**CTA:** WhatsApp call or short demo

### Step 1 — Day 0
```
Subject: {{firstName}}, quick idea for {{companyName}}

Hi {{firstName}},

I noticed {{personalization}}.

Most businesses like {{companyName}} are still chasing leads manually — calling, texting, following up one by one. It works, but it doesn't scale.

We built an AI-powered system that captures leads, follows up automatically via WhatsApp, and books appointments — without you lifting a finger.

Worth a 10-minute demo to see if it fits?

Mamoun
```

### Step 2 — Day 3
```
Subject: Re: quick idea for {{companyName}}

{{firstName}},

Quick follow-up — a beauty clinic in Dubai was getting 50 inquiries a week but only converting 8.

After setting up automated WhatsApp follow-up, they hit 22 conversions/week. Same leads, same team — just faster response.

Would something like this help {{companyName}}?

Mamoun
```

### Step 3 — Day 7: Breakup
```
Subject: Last note, {{firstName}}

{{firstName}},

I know you're busy running {{companyName}}, so I'll keep this short — if automating your lead follow-up isn't a priority right now, totally understand.

If it becomes one, just reply to this email and we'll set up a quick call.

Mamoun
```

---

## Re-Engagement Sequence

**Target:** Leads who completed a sequence without replying (90+ days ago)
**Tone:** Fresh approach, new angle, acknowledge the gap
**Steps:** 2 emails only

### Step 1 — Day 0
```
Subject: Different approach this time, {{firstName}}

{{firstName}},

I reached out a while back about [original topic]. Didn't hear back — fair enough.

Since then, we've built something new that's getting [specific result] for companies like {{companyName}}.

Worth a fresh look?

Mamoun
```

### Step 2 — Day 5
```
Subject: Last one from me

{{firstName}},

Short version: [one sentence describing new value prop].

If interesting, I'm around. If not, no more emails from me on this topic.

Mamoun
```

---

## Sequence Customization Guide

### When to Modify Templates
- **Different ICP:** Adjust language, references, and case studies to match audience
- **Different wedge/angle:** Replace the value proposition while keeping the structure
- **A/B testing:** Change ONE element (subject, opening line, CTA) per variant
- **Performance feedback:** If reply rate <3%, try a completely different opening approach

### Customization Points (in priority order)
1. `{{personalization}}` line — Most impact. Make it specific.
2. Subject line — Second most impact. Test variations.
3. CTA — Third. Test framing (question vs statement, time vs open-ended).
4. Social proof — Swap case studies to match ICP.
5. Timing/delay — Test 2-day vs 3-day gaps between steps.

### What NOT to Customize
- Keep emails under 150 words (non-negotiable)
- Keep to 3-4 steps maximum (more = diminishing returns + spam risk)
- Keep breakup email as final step (works consistently)
- Keep `stop_on_reply: true` (always)
- Keep plain text format (deliverability requirement)
