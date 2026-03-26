---
description: Generate a signal-based wedge with outreach sequence
argument-hint: "[signal-description]"
allowed-tools: Read, Write, Task, AskUserQuestion
---

Quick wedge generation from a described signal. This is the fast-path for when you spot a signal and want to turn it into outreach immediately.

**Argument:** `$ARGUMENTS` — Description of the signal (e.g., "VP Sales hired at Acme Corp", "competitor raised prices 30%", "prospect posted about CRM frustration on LinkedIn")

**If no argument:** Ask the user to describe the signal they observed.

**Execution:**

1. **Parse the Signal**
   - Extract: who (person/company), what (the event), when (recency), where (source)
   - If information is incomplete, ask targeted follow-up questions

2. **Classify the Signal**
   - **Trust Signal**: Awards, case studies, speaking engagements, certifications, content creation
   - **Intent Signal**: Job postings, funding, tech changes, competitor mentions, pricing research
   - Assign strength: Strong / Moderate / Weak
   - Check freshness: <30 days = hot, 30-60 = warm, 60-90 = cool, >90 = stale (Hard Stop)

3. **Generate 3 Wedge Variants**
   Using the wedge-generator core formula:

   Each wedge must:
   - Be exactly ONE sentence
   - Reference the specific signal (not generic value prop)
   - Connect signal to a business outcome the prospect cares about
   - Pass Hard Stop Rule 3: one-sentence test
   - Pass Hard Stop Rule 4: Intent signals should lead the sequence, Trust signals support

   Variants should differ in:
   - Angle (direct vs indirect reference to signal)
   - Tone (data-driven vs conversational vs provocative)
   - CTA (meeting vs resource vs question)

4. **Rank Variants**
   Present all 3 ranked by expected impact with reasoning:
   - Which one creates the strongest pattern interrupt?
   - Which one is most likely to get a reply?
   - Which one builds the most trust?

5. **Generate Quick Sequence** (for the top-ranked wedge)
   - **Email**: Subject line + 3-line email using the wedge
   - **LinkedIn**: Connection note (under 300 chars) using the wedge
   - **WhatsApp**: Short conversational message using the wedge

   Apply culture adapter based on detected geography (MENA = Gulf Arabic tone, US = direct English).

6. **Ask Next Steps**
   - "Want me to add this to an active campaign?"
   - "Want me to deploy this as a one-off outreach?"
   - "Want me to generate a full week of assets around this wedge angle?"
