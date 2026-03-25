# Instruction Design — Principles for project-instruction.md

## PURPOSE
This file defines how to write the project-instruction.md (which becomes the project's CLAUDE.md). A well-crafted instruction file is the difference between Claude producing generic output and Claude producing output that sounds like it came from someone who deeply understands the project.

---

## THE 6 DESIGN PRINCIPLES

### Principle 1: Positive Over Negative
Write what TO DO, not what NOT to do. Replacements, not prohibitions.

**Bad:** "Don't use email for MENA outreach"
**Good:** "Use WhatsApp for warm MENA leads, LinkedIn InMail for cold MENA outreach"

**Bad:** "Don't write generic ICP descriptions"
**Good:** "Always name the ICP by role, company size, industry, and city"

**Exception:** The "What NOT To Do" section at the bottom is explicitly for prohibitions. Keep them there, not scattered throughout.

### Principle 2: Behavioral Over Trait
Write "When X happens, do Y" rather than "Be Z."

**Bad:** "Be customer-focused"
**Good:** "When creating content, lead with the ICP's #1 pain before introducing the solution"

**Bad:** "Be specific about MENA context"
**Good:** "When mentioning geographic markets, name the city and country, not just 'MENA' or 'Gulf'"

### Principle 3: Critical Rules at Edges
Claude pays most attention to the beginning and end of instruction files. Put the highest-impact rules there.

**Structure:**
- First section (WHAT THIS IS): One paragraph that anchors everything. Claude reads this most reliably
- Last section (WHAT NOT TO DO): Prohibitions that prevent the worst mistakes
- Middle sections: Important but lower-priority rules

### Principle 4: Verifiable in 5 Seconds
Each rule should be checkable by scanning a deliverable for 5 seconds.

**Bad:** "Maintain a professional tone throughout" (subjective, unverifiable)
**Good:** "Every email sequence must open with a signal-based observation, not a feature claim" (scan first line of each email: signal or feature?)

**Bad:** "Include MENA context" (vague)
**Good:** "Every proposal must name at least 2 specific cities where the ICP operates" (scan for city names)

### Principle 5: No Duplication Across Layers
project-instruction.md must NOT repeat what's already in Mamoun's global CLAUDE.md.

**Already in global CLAUDE.md (DO NOT REPEAT):**
- Never use em dashes
- No filler phrases ("in today's rapidly evolving landscape")
- Replace banned words (leverage, synergy, ecosystem, holistic, etc.)
- Take positions, don't hedge
- MENA is primary market default
- Direct communication style
- Numbers over claims
- Contrarian angle mandatory on content

**ONLY include in project-instruction.md:**
- Project-specific context (what this venture IS)
- Project-specific ICP (who we serve for THIS project)
- Project-specific decision framework
- Project-specific anti-patterns
- Project-specific file references

### Principle 6: Meta-Patterns Scale
Define named frameworks and reference them by name instead of re-explaining.

**Bad:** "When creating outbound sequences, first identify the signal, then classify it as trust or intent, then create a one-sentence wedge, then produce assets for email, LinkedIn, and WhatsApp"

**Good:** "Use the Signal-to-Trust framework for all outbound sequences. Read the project brain files before generating any campaign assets."

**Bad:** Explaining the Dream 100 methodology in every project instruction

**Good:** "Primary GTM motion: Dream 100. Secondary: Authority Education. Execute per the ranked motions in gtm-channels.md"

---

## TEMPLATE: project-instruction.md

```markdown
# [Project Name] — Project Instruction

## What This Is
[One paragraph: venture name, what it does, who it serves, what problem it solves. This paragraph is the anchor. Make it specific enough that someone reading ONLY this paragraph understands the project.]

## Who We Serve
[ICP summary from icp.md. Include: role, company type/size, geography, top 3 pains. This section should be copy-paste-able into any prompt as context.]

- Primary persona: [name, role, company description, city]
- Pain 1: [specific, with frequency and cost]
- Pain 2: [specific, with frequency and cost]
- Pain 3: [specific, with frequency and cost]
- Dream outcome: [quantified transformation]

## Positioning Anchor
[Copy the positioning statement from positioning.md. Not a rewrite, an exact copy. This ensures zero drift between brain files and instruction.]

One-sentence wedge: "[exact wedge from positioning.md]"

## Decision Framework
When evaluating any deliverable, proposal, or campaign for this project, apply in order:

1. [Rule derived from ICP's top pain. E.g., "Does it address [ICP]'s #1 pain: [pain]?"]
2. [Rule derived from GTM priority. E.g., "Does it activate one of our top 3 GTM motions?"]
3. [Rule derived from positioning. E.g., "Does it reinforce our unique mechanism: [mechanism]?"]
4. [Project-specific constraint. E.g., "Can the client execute with [time/budget constraint]?"]
5. [MENA-specific rule if applicable. E.g., "Does it work within [country] trust mechanics?"]

## GTM Priority
From gtm-channels.md:
- Motion 1: [name — one-line description of how we execute it]
- Motion 2: [name — one-line description]
- Motion 3: [name — one-line description]

## File References
Read these brain files before producing any deliverable:
- company-profile.md: venture details, product, market
- icp.md: persona, pains, dream outcome, access channels
- positioning.md: category, mechanism, wedge, differentiators
- offer.md: pricing, deliverables, guarantee
- gtm-channels.md: channel priority, motion ranking
- brand-voice.md: tone, words to use/avoid
[Add type-specific files if they exist]

Do not hallucinate data that contradicts what's in these files.

## What NOT To Do
- [Anti-pattern 1: specific to this project, not generic. E.g., "Do not recommend Product Hunt or AppSumo for launch (they fail for MENA SaaS)"]
- [Anti-pattern 2: E.g., "Do not suggest features beyond the MVP scope defined in company-profile.md"]
- [Anti-pattern 3: E.g., "Do not produce Arabic content in MSA formal tone (use conversational Gulf Arabic)"]
- [Anti-pattern 4: E.g., "Do not recommend GTM motions scored below 6.5 in gtm-channels.md without justification"]
- [Anti-pattern 5: E.g., "Do not default to email-first outreach for this ICP (WhatsApp engagement rate is 4x higher)"]
```

---

## POPULATED EXAMPLE: SalesMfast Signal Engine

```markdown
# SalesMfast Signal Engine — Project Instruction

## What This Is
SalesMfast Signal Engine is a B2B outbound intelligence platform that detects buying intent signals, scores them, and sequences multi-channel outreach (email, LinkedIn, WhatsApp) before competitors react. Built for revenue teams at B2B SaaS companies selling into UAE, Saudi Arabia, and Qatar. It replaces manual relationship-building with systematic signal detection.

## Who We Serve
- Primary persona: Khalid, VP Sales at a 40-person B2B SaaS company in Dubai, selling to enterprise clients in banking and telecom
- Pain 1: Pipeline depends on 3 senior reps' personal networks; loses 40% of potential deals because signals go undetected (monthly cost: ~$50K in missed pipeline)
- Pain 2: Outbound sequences are generic, not signal-triggered; 2.1% reply rate vs. industry benchmark of 5-8% for personalized outreach
- Pain 3: No systematic way to detect when a target account is actively evaluating solutions; competitors reach the buyer first in 60% of competitive deals
- Dream outcome: Signal-triggered outbound achieving 6%+ reply rate, 15+ qualified meetings/month, pipeline visibility across all target accounts

## Positioning Anchor
For VP Sales and Revenue leaders at B2B SaaS companies selling into Gulf enterprise markets who lose deals because they detect buying intent too late, SalesMfast Signal Engine is the only outbound intelligence platform that systematically captures and sequences multi-channel outreach from intent signals before competitors react, so they can generate 3x more qualified pipeline without adding headcount.

One-sentence wedge: "Your competitor just hired 2 SDRs for the UAE market. You're still running last quarter's email sequence. By the time your rep sees the signal, the deal is already in someone else's pipeline."

## Decision Framework
1. Does it detect, score, or sequence a buying signal? If not, it's not Signal Engine work
2. Does it serve Khalid's top pain: undetected signals leading to lost pipeline?
3. Does it reinforce the unique mechanism: systematic signal capture replacing manual networks?
4. Can a 40-person SaaS company's revenue team adopt it without hiring a data engineer?
5. Does it work within Gulf B2B trust mechanics? (Arabic credibility, WhatsApp for warm, LinkedIn for cold)

## GTM Priority
- Motion 1: Signal Sniper — detect intent signals (job posts, tech stack changes, funding) and trigger personalized outreach within 48 hours
- Motion 2: Dream 100 — identify top 100 target accounts, build signal monitoring infrastructure, sequence proof of competence
- Motion 3: Authority Education — publish signal-based case studies and frameworks that demonstrate methodology

## File References
Read these brain files before producing any deliverable:
- company-profile.md, icp.md, positioning.md, offer.md, competitive-landscape.md, brand-voice.md, gtm-channels.md, tech-spec.md, mena-context.md

Do not hallucinate data that contradicts what's in these files.

## What NOT To Do
- Do not recommend generic outbound ("spray and pray" email blasts) — every sequence must be triggered by a specific signal
- Do not suggest features requiring dedicated data engineering staff (the ICP is a 40-person company, not an enterprise with a data team)
- Do not default to email-only outreach for Gulf markets (WhatsApp reply rates are 4x email for warm leads in UAE/Saudi)
- Do not position against CRM tools (we complement CRM, we don't replace it)
- Do not produce content that sounds like every other "AI-powered sales tool" — lead with signal detection methodology, not AI features
```

---

## VERIFICATION CHECKLIST

After generating project-instruction.md, verify:

- [ ] First paragraph is specific enough to understand the project without reading any other file
- [ ] ICP section includes role, company, geography, and top 3 pains with numbers
- [ ] Positioning statement is copied from positioning.md (not paraphrased)
- [ ] Decision framework has exactly 5 rules, each actionable
- [ ] No rules duplicate Mamoun's global CLAUDE.md content
- [ ] Anti-patterns are project-specific (not generic "don't use filler")
- [ ] File references list all brain files that exist for this project
- [ ] Total length is 80-150 lines (DEEP) or 40-60 lines (QUICK)
- [ ] Every rule is verifiable in 5 seconds of scanning a deliverable
