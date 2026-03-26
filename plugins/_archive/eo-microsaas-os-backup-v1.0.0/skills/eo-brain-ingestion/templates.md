# EO Brain Ingestion - Templates & Extraction Maps

This file contains detailed field-by-field extraction tables, output file templates, and gap-fill question scripts for all 12 output files. Referenced from SKILL.md.

---

## DATA EXTRACTION MAP

### companyprofile.md

| Field | Source |
|-------|--------|
| Venture Name | SC1 header: `**Venture:**` |
| One-Line Description | SC1 Q1 first paragraph (extract core problem statement) |
| Problem Statement | SC1 Q1 full answer (the specific problem being solved) |
| Product Category | SC1 Q4 "Category Definition" or SC1 positioning section |
| Target Market | SC1 Q3 "3-Level Niche" Market level |
| Sub-Market | SC1 Q3 Sub-Market level |
| Niche | SC1 Q3 Niche level |
| Niche Size | SC1 Q3 estimated niche size |
| MVP Features | SC1 Q5 core features list |
| Technical Approach | SC1 Q5 technical stack |
| Pricing Tiers | SC1 Q5 pricing section |
| Launch Geography | SC1 Q7 countries |
| Overall Readiness | Founder Brief overall score, or average of SC1-SC5 |
| Assessment Scores | All 5 scorecard scores in table format |

### founderprofile.md

| Field | Source |
|-------|--------|
| Founder Name | SC1 header or student input |
| Background | SC1 Q2 founder-problem fit (professional history) |
| Domain Expertise | SC1 Q2 specific experience relevant to the problem |
| Unfair Advantage | SC1 Q2 "Triple Assessment" or unique qualification |
| Archetype | SC4 "Founder Archetype" field |
| Strongest Skill | SC4 Q1 answer |
| Risk Profile | SC4 Q4 answer |
| Time Commitment | SC4 Q3 answer |
| Investment Capacity | SC4 Q2 answer |
| Network Strength | SC5 Q7 answer |
| Content Comfort | SC5 Q3 answer |
| MENA Experience | SC1 Q7 + SC4 Q10 MENA execution advantage |

### brandvoice.md

| Field | Source |
|-------|--------|
| Attractive Character Archetype | SC1 Q6 (Reluctant Hero, Leader, Adventurer, etc.) |
| Origin Story | SC1 Q6 founder story arcs |
| Brand Personality Traits | EXTRACT from SC1 Q6 tone + SC1 Q1 writing style |
| Language Defaults | SC1 Q7 language strategy |
| Tone Guidelines | **GAP-FILL** (ask 2-3 questions) |
| Content Voice Examples | **GAP-FILL** (ask 1-2 questions) |
| Words to Use | **GAP-FILL** (derive from scorecard writing style + ask) |
| Words to Avoid | **GAP-FILL** (derive from scorecard writing style + ask) |

### niche.md

| Field | Source |
|-------|--------|
| Market Level | SC1 Q3 Level 1 |
| Sub-Market Level | SC1 Q3 Level 2 |
| Niche Level | SC1 Q3 Level 3 |
| Niche Demographics | SC1 Q3 (age, geography, role, stage) |
| Niche Size Estimate | SC1 Q3 number |
| Validation Evidence | SC1 Q1 validation data (interviews, waitlist, etc.) |
| Niche Selection Rationale | SC1 Q3 reasoning for narrowing |
| Adjacent Niches | EXTRACT from SC1 Q3 if mentioned, otherwise note as expansion path |

### icp.md

| Field | Source |
|-------|--------|
| Persona Name | SC2 Q1 named persona |
| Demographics | SC2 Q1 (age, location, role, company size) |
| Psychographics | SC2 Q1 (motivations, fears, daily routine) |
| Current Workflow | SC2 Q1 "How he solves it today" section |
| Pain #1 | SC2 Q2 Pain 1 (urgency, frequency, cost) |
| Pain #2 | SC2 Q2 Pain 2 (urgency, frequency, cost) |
| Pain #3 | SC2 Q2 Pain 3 (urgency, frequency, cost) |
| Additional Pains | SC2 Q2 Pains 4-5 if present |
| Dream Outcome - Business | SC2 Q3 business metrics transformation |
| Dream Outcome - Emotional | SC2 Q3 emotional/identity shift |
| Buyer Journey - Current State | SC2 Q4 "Current State" section |
| Buyer Journey - Obstacles | SC2 Q4 obstacles list |
| Buyer Journey - Solution Bridge | SC2 Q4 "Solution Bridge" section |
| Access Channels - Online | SC2 Q5 online congregation points |
| Access Channels - Offline | SC2 Q5 offline gathering spots |
| Validation Plan | SC2 Q6 30-day reach plan |
| Validation Evidence | SC2 Q1 validation marker (interviews, survey, pilot) |

### positioning.md

| Field | Source |
|-------|--------|
| Category Definition | SC1 Q4 category statement |
| Competitive Alternatives | SC1 Q4 list of alternatives |
| Unique Mechanism | SC1 Q4 unique mechanism name + description |
| One-Line Wedge | SC1 Q4 wedge statement |
| Positioning Statement | SYNTHESIZE from SC1 Q4 (Category + For + Unlike + Because) |
| Value Proposition | SYNTHESIZE from SC1 Q4 + SC2 Q3 (problem + solution + dream outcome) |
| Key Differentiators | SC1 Q4 + SC4 Q10 (execution advantages) |
| Positioning Against Free | SC2 Q2 Pain 3 if about "free alternatives" |

### competitor-analysis.md

| Field | Source |
|-------|--------|
| Direct Competitors | SC1 Q4 competitive alternatives (extract names) |
| Competitor Weaknesses | SC1 Q4 "why each fails" reasoning |
| Regional Competitors | **GAP-FILL** (ask 2-3 questions about MENA-specific alternatives) |
| Feature Comparison | **GAP-FILL** (ask about specific feature gaps) |
| Pricing Comparison | SC3 B2 competitor pricing data if present |
| Positioning Gap | SYNTHESIZE from SC1 Q4 unique mechanism vs competitors |

### market-analysis.md

| Field | Source |
|-------|--------|
| Pain Reality Evidence | SC3 B1 full answer (proof stack) |
| Purchasing Power Evidence | SC3 B2 full answer (pricing benchmarks) |
| Evidence Grade | SC3 B3 selected option |
| TAM | SC3 C1 TAM section |
| SAM | SC3 C1 SAM section |
| SOM | SC3 C1 SOM section |
| Year 1 Revenue Projection | SC3 C1 SOM revenue range |
| Growth Signals | SC3 C2 full answer (all cited signals) |
| Competitive Moat | SC3 C3 selected option |
| MENA Market Dynamics | SC1 Q7 + SC3 C2 MENA-specific signals |

### strategy.md

| Field | Source |
|-------|--------|
| Recommended Path | SC4 "Recommended Path" field |
| Path Rationale | SC4 Q5 full answer (why this path) |
| Backup Path | SC4 "Backup Path" field |
| Backup Trigger | SC4 "Activate if" condition |
| Founder Archetype | SC4 "Founder Archetype" field |
| 90-Day Roadmap | SC4 "90-Day Roadmap" section |
| All Paths Comparison | SC4 "All 4 Paths Compared" section |
| Execution Advantage | SC4 Q10 MENA execution advantage |
| Biggest Challenge | SC4 Q10 biggest challenge + mitigation |

### gtm.md

| Field | Source |
|-------|--------|
| GTM Motions Ranked | SC5 full 13-motion table with scores and tiers |
| Top 5 Motions Detail | SC5 top 5 descriptions (Fit, Readiness, MENA, Best For, MENA Note) |
| PRIMARY Motions | SC5 all motions with tier = PRIMARY |
| SECONDARY Motions | SC5 all motions with tier = SECONDARY |
| CONDITIONAL Motions | SC5 all motions with tier = CONDITIONAL |
| SKIP Motions | SC5 all motions with tier = SKIP |
| 72-Hour Launch Commitment | SC5 "72-Hour Launch Commitment" section |
| How to Start Top 3 | SC5 "How to Start Your Top 3 Motions" section |
| Access Channels | SC2 Q5 (cross-reference for channel alignment) |
| Monthly Budget | SC5 Q6 answer |
| Outreach Stack | SC5 Q5 answer |
| Content Cadence | SC5 Q2 answer |

---

## OUTPUT FILE TEMPLATES

### project-instruction.md

This file is formatted as a **ready-to-paste system prompt** for any AI tool. No explanatory sections, no commentary. Pure instruction format.

```markdown
# Project Context - [Venture Name]

## What We Build
[One-line from companyprofile.md]

## Who We Serve
[ICP persona summary from icp.md - 3-4 sentences max]

## Core Problem
[Problem statement from companyprofile.md]

## Our Solution
[Product description + unique mechanism from positioning.md]

## Positioning
[Full positioning statement from positioning.md]

## Key Differentiators
[Bullet list from positioning.md]

## Target Markets
[Geography + niche from niche.md]

## Pricing
[Tiers from companyprofile.md]

## Current Stage
[Strategy path + 90-day focus from strategy.md]

## GTM Priority
[Top 3 motions from gtm.md with one-line each]

## Language
[Language defaults from brandvoice.md]

## Voice
[Tone guidelines from brandvoice.md - 3 rules max]
```

### cowork-instruction.md

This file is formatted as a **ready-to-paste CLAUDE.md** for Cowork/Claude Code. No explanatory sections. Pure instruction format following the CLAUDE.md convention.

```markdown
# [Venture Name] - Cowork Instructions

## WHO I AM
[Founder name] - [Role]. [One-line background from founderprofile.md]
Building [venture name]: [one-line description]

## WHAT I BUILD
[Product description from companyprofile.md]
Target: [ICP summary from icp.md]
Stage: [Current stage from strategy.md]

## MY TOOL STACK
[Technical approach from companyprofile.md]
[GTM tools if mentioned in scorecards]

## HOW I WORK
1. Ask questions when: [derived from strategy path and complexity]
2. Output quality: [derived from brandvoice.md tone guidelines]
3. MENA context: [derived from SC1 Q7 cultural dynamics]

## WHAT NOT TO DO
- Do not ignore MENA cultural context
- Do not default to Western/US market assumptions
- Do not use generic SaaS positioning language
- [Additional rules derived from positioning.md differentiators]

## LANGUAGE DEFAULTS
[From brandvoice.md]

## FILE NAMING
[Venture-specific convention derived from venture name]
```

---

## GAP-FILL PROTOCOL

Two output files require data beyond what the scorecards provide: **brandvoice.md** and **competitor-analysis.md**.

### brandvoice.md Gap-Fill

After extracting everything available from SC1 Q6 (founder story) and SC1 writing style, ask these questions:

**Q1:** "I have your origin story and archetype from the scorecards. Now I need your brand voice. When you write content (LinkedIn, YouTube, emails), which 3 words describe your tone? Examples: direct, provocative, educational, warm, technical, conversational, formal."

**Q2:** "Give me an example of something you have written that you think represents your best voice. A LinkedIn post, email, YouTube intro, anything. Paste it here."

**Q3:** "What words or phrases should I NEVER use when writing for your brand? Things that make you cringe or feel off-brand."

Maximum 3 questions. If the student gives short answers, work with what you have. Do not over-ask.

### competitor-analysis.md Gap-Fill

SC1 Q4 gives competitive alternatives, but the analysis needs more depth. Ask:

**Q1:** "The scorecards mention these competitors: [list from SC1 Q4]. Are there any MENA-specific competitors or alternatives I should add? Anyone operating in the same space in Saudi, UAE, Egypt, or Jordan?"

**Q2:** "For your top 2 competitors: what is their biggest weakness that your ICP complains about? What do they get wrong?"

**Q3 (optional, only if pricing data is missing from SC3):** "Do you know what your top competitors charge? Rough pricing is fine."

Maximum 3 questions. If SC3 already has competitor pricing data, skip Q3.

---

*Reference file for EO Brain Ingestion Engine v1.0*
