<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: gtm-fitness-scoring-engine
description: Scorecard 5 of 5 — Evaluates readiness across 13 GTM motions using composite scoring (Fit x 0.4 + Readiness x 0.3 + MENA x 0.3). Assigns PRIMARY/SECONDARY/CONDITIONAL/SKIP tiers.
version: "3.0"
---

# SKILL: GTM Fitness Scoring Engine v3.0

**Version:** 3.0 — Deep Matrix Integration
**Created:** 2026-03-06 | **Updated:** 2026-03-10
**Input Sources:** SC1 (Project Definition), SC2 (ICP Clarity), SC3 (Market Attractiveness), SC4 (Strategy Selector), GTM Matrix
**Output File:** `gtm-fitness.md`
**Execution Model:** 13 MC questions --> Weight Matrix scoring --> Motion composite ranking --> Tier assignment --> 72-Hour Commitment

---

## 1. STRATEGIC PURPOSE

GTM Fitness Scoring answers one question: **"Of all 13 go-to-market motions, which 2-3 should this founder activate FIRST?"**

This is NOT a general marketing assessment. It's a precision instrument that combines:
- **Upstream context** (SC1-SC4): niche, ICP, market conditions, strategy path, founder archetype
- **Founder's business reality** (13 MC questions): assets, infrastructure, capacity, market dynamics
- **Motion intelligence** (GTM Matrix): real examples, win/fail conditions, MENA execution playbooks
- **Weight matrix scoring**: each question influences each motion differently (169 weighted connections)

**Philosophy:** Every founder has 2-3 motions that are natural fits and 10 that will waste their time. The scoring engine finds the natural fits by cross-referencing what the founder HAS (assets, infra, capacity) with what each motion NEEDS (prerequisites, conditions, execution requirements).

**Reference files:**
- For detailed motion evaluations (definitions, examples, win/fail, MENA playbooks), see `motions.md`.
- For detailed scoring rubrics, upstream bonus calculations, and expert framework gates, see `scoring-rubrics.md`.
- For output templates and examples, see `templates.md`.

---

## 2. PREREQUISITES -- UPSTREAM DATA CONTRACT

### Required Upstream Scorecards

**SC1 (Project Definition) provides:**
- Niche definition (3-level: industry --> segment --> pain)
- Positioning statement (who + what + why different)
- Geography (MENA-first, global, US-first)
- ACV range and product scope
- Brand voice and attractive character type

**SC2 (ICP Clarity) provides:**
- ICP profile (who, title, company size, buying behavior)
- Top 10 pain statements (ranked by severity)
- Top 10 pleasure statements (ranked by desire)
- Congregation points (where ICP gathers: LinkedIn groups, events, communities)
- Payment method and budget range
- Hero Journey stage (Brunson framework)

**SC3 (Market Attractiveness) provides:**
- Pain reality evidence (how real and urgent is the problem)
- Purchasing power (can ICP actually pay)
- ICP accessibility (how easy to reach)
- Market growth signals (expanding, flat, contracting)
- Competitive landscape density

**SC4 (Strategy Selector) provides:**
- Primary strategy path: Replicate & Localize | Consulting-First SaaS | Boring Micro-SaaS | Hammering Deep
- Founder archetype (1 of 8)
- Core skill, capital range, weekly hours available, risk tolerance
- Attractive character mapping (Reporter | Leader | Reluctant Hero | Adventurer)

### Pre-Assessment Checks

**Before starting SC5, validate:**
1. All 4 upstream scorecards completed (SC1-SC4 scores available in localStorage)
2. If any upstream score < 40 (RESET band): flag warning -- GTM assessment may be premature
3. Load upstream scores to calculate fit bonuses and strategy path bonuses

---

## 3. THE 13 ASSESSMENT QUESTIONS

These are the MC questions the founder answers. Each has 4 options scored 1-4. The weight matrix determines how each answer influences each of the 13 motions.

### YOUR ASSETS (Q0-Q2)

**Q0: Email List Size** (`q_email_list`)
"How big is your email list or subscriber base?"
- No list yet (1)
- Under 500 subscribers (2)
- 500 to 2,000 subscribers (3)
- Over 2,000 subscribers (4)

*Why it matters:* Waitlist Heat (w=3), Authority Education (w=2), Value Trust Engine (w=2) all depend on having an owned audience. Build-in-Public (w=1) and Paid VSL (w=1) benefit less.

**Q1: Content Frequency** (`q_content_frequency`)
"How often do you publish content -- articles, videos, or podcasts?"
- Rarely or never (1)
- Once a month or less (2)
- Weekly (3)
- Multiple times per week (4)

*Why it matters:* Build-in-Public (w=3), Authority Education (w=3), Wave Riding (w=2), BOFU SEO (w=2) are content-dependent. Signal Sniper (w=0), LTD (w=0) don't care.

**Q2: Founder Visibility** (`q_founder_visibility`)
"Are you comfortable being the public face of your business?"
- Not at all (1)
- Somewhat (2)
- Yes -- I regularly show up on social media (3)
- Absolutely -- I am already building a personal brand (4)

*Why it matters:* Build-in-Public (w=3), Authority Education (w=3), Waitlist Heat (w=2), Dream 100 (w=2), Value Trust Engine (w=2) need visible founders. Signal Sniper (w=0), LTD (w=0), Hammering-Feature (w=0) work behind the scenes.

### YOUR PRODUCT (Q3-Q4)

**Q3: Demo Ability** (`q_demo_ability`)
"Can you show a clear result or transformation from your product in under 5 minutes?"
- No -- value takes time to show (1)
- Partially -- some features show quick wins (2)
- Yes -- I have a solid demo or walkthrough (3)
- Absolutely -- the result is instantly visible and impressive (4)

*Why it matters:* Outcome Demo First (w=3), LTD Cash-to-MRR (w=3), Hammering-Feature (w=2), Paid VSL (w=2). If you can't show the value quickly, demo-dependent motions fail.

**Q4: Outbound Tools** (`q_outbound_tools`)
"What outreach tools do you have set up today?"
- Nothing set up yet (1)
- Basic -- just a CRM or basic email (2)
- Decent stack -- email sender + LinkedIn + CRM (3)
- Full stack -- multi-channel outbound already running (4)

*Why it matters:* Signal Sniper (w=3), 7x4x11 (w=2), Dream 100 (w=1), Outcome Demo (w=1). Infrastructure-dependent motions score zero without tooling.

### YOUR INFRASTRUCTURE (Q5-Q7)

**Q5: Marketing Budget** (`q_budget`)
"What is your monthly marketing and growth budget?"
- Under $500/month (1)
- $500 to $2,000/month (2)
- $2,000 to $5,000/month (3)
- Over $5,000/month (4)

*Why it matters:* Paid VSL (w=3), 7x4x11 (w=2), Signal Sniper (w=1), Wave Riding (w=1). Budget-heavy motions become SKIP without spend.

**Q6: Network Strength** (`q_network`)
"How strong is your network with influencers, partners, or industry leaders?"
- Very weak (1)
- Some contacts (2)
- Good network (3)
- Strong -- 20+ active relationships (4)

*Why it matters:* Dream 100 (w=3), 7x4x11 (w=2), Waitlist Heat (w=2), Outcome Demo (w=0). Dream 100 is literally impossible without network leverage.

**Q7: Deal Size** (`q_deal_size`)
"What is your average deal size or price point per year?"
- Under $500/year (1)
- $500 to $2,000/year (2)
- $2,000 to $10,000/year (3)
- Over $10,000/year (4)

*Why it matters:* 7x4x11 (w=3), Signal Sniper (w=2), Outcome Demo (w=1), Paid VSL (w=1). High-touch motions like 7x4x11 only make economic sense at high ACV.

### YOUR MARKET (Q8-Q10)

**Q8: Speed to Ship** (`q_speed_to_ship`)
"When a relevant trend or opportunity appears, how fast can you ship something?"
- Weeks to months (1)
- About a week (2)
- A few days (3)
- Same day or next day (4)

*Why it matters:* Wave Riding (w=3), LTD Cash-to-MRR (w=3), Hammering-Feature (w=3), Build-in-Public (w=2), BOFU SEO (w=2). Speed-dependent motions need founders who can ship fast.

**Q9: Search Demand** (`q_search_demand`)
"Do your target buyers actively search Google for solutions like yours?"
- No -- they don't know they need it yet (1)
- Some search -- but low volume (2)
- Yes -- clear search demand exists (3)
- High volume with strong buying intent (4)

*Why it matters:* BOFU SEO (w=3), Hammering-Feature (w=3), Paid VSL (w=2), Authority Education (w=1), Wave Riding (w=1). Without search demand, SEO and paid acquisition are pointless.

**Q10: Sales Capacity** (`q_sales_capacity`)
"Do you have capacity for one-on-one sales conversations?"
- No -- everything needs to be self-serve (1)
- Limited -- a few calls per week (2)
- Moderate -- 10 to 20 calls per week (3)
- Strong -- dedicated sales team or high capacity (4)

*Why it matters:* 7x4x11 (w=3), Signal Sniper (w=3), Dream 100 (w=2), Outcome Demo (w=2). Relationship-based motions die without conversation capacity.

### YOUR CAPACITY (Q11)

**Q11: Event Experience** (`q_event_experience`)
"Have you run webinars, workshops, or live events before?"
- Never (1)
- Once or twice (2)
- Several times -- I know the format well (3)
- Regularly -- it is part of how I sell (4)

*Why it matters:* Waitlist Heat (w=3), Value Trust Engine (w=3), Authority Education (w=2), 7x4x11 (w=2), Dream 100 (w=1). Webinar/event-dependent motions need presenters who can perform.

### YOUR MARKET -- MENA (Q12)

**Q12: MENA Focus** (`q_mena_focus`)
"How much of your business targets the MENA region specifically?"
- MENA is not my focus at all (1)
- Some MENA but mostly global/US (2)
- MENA is a primary market (3)
- MENA-only or MENA-first (4)

*MENA Multiplier:*
- Not focused (1) --> 0.3x MENA score
- Some MENA (2) --> 0.6x MENA score
- Primary market (3) --> 1.0x MENA score
- MENA-only (4) --> 1.2x MENA score

*Note: Q12 does NOT feed into the weight matrix (all weights = 0). It acts as a global multiplier on the MENA dimension of every motion's composite score.*

---

## 4. THE WEIGHT MATRIX

This is the heart of the scoring engine. Each cell (0-3) determines how much a question answer influences a motion's readiness score.

```
                   Q0   Q1   Q2   Q3   Q4   Q5   Q6   Q7   Q8   Q9  Q10  Q11  Q12
                  list cont  vis  demo outb budg netw deal ship srch sale evnt mena
0  Waitlist        3    1    2    1    0    1    2    0    1    0    1    3    0
1  Build-Public    1    3    3    1    0    0    1    0    2    0    0    0    0
2  Authority Ed    2    3    3    0    0    0    1    0    0    1    0    2    0
3  Wave Riding     0    2    1    1    0    1    1    0    3    1    0    0    0
4  LTD             1    0    0    3    0    0    0    0    3    1    0    0    0
5  Signal Sniper   0    0    0    0    3    1    0    2    0    1    3    0    0
6  Outcome Demo    0    0    1    3    1    0    0    1    0    0    2    0    0
7  Hammering       0    0    0    2    1    0    0    0    3    3    0    0    0
8  BOFU SEO        0    2    0    1    0    1    0    0    2    3    0    0    0
9  Dream 100       0    1    2    0    1    0    3    1    0    0    2    1    0
10 7x4x11          0    0    0    0    2    2    2    3    0    0    3    2    0
11 Value Trust     2    1    2    1    0    1    0    0    0    0    1    3    0
12 Paid VSL        1    0    0    2    0    3    0    1    0    2    0    0    0
```

**Reading the matrix:** Weight 3 = critical dependency. Weight 2 = strong influence. Weight 1 = moderate. Weight 0 = irrelevant.

**Example:** Signal Sniper Outbound (row 5) has weight-3 on Q4 (outbound tools) and Q10 (sales capacity). If a founder has no tools (Q4=1) and no sales capacity (Q10=1), Signal Sniper gets crushed regardless of other answers.

---

## 5. SCORING ENGINE -- SUMMARY

For complete scoring formulas, upstream bonus calculations, strategy path bonus matrix, and upstream-to-motion fit mapping, see `scoring-rubrics.md`.

### Composite Score Formula (per motion)

```
composite = (fit x 0.4) + (readiness x 0.3) + (mena x 0.3)
Range: 0.0 to 10.0
```

### Motion Tier Assignment

| Tier | Composite Score | Action | Meaning |
|------|----------------|--------|---------|
| **PRIMARY** | >= 6.5 | Deploy now | High fit + high readiness + favorable MENA = fastest ROI path |
| **SECONDARY** | 5.0 - 6.4 | Build capacity | Good fit but needs some capability building = next quarter |
| **CONDITIONAL** | 3.5 - 4.9 | Needs prerequisites | Fit exists but gaps are real = fix gaps first, then activate |
| **SKIP** | < 3.5 | Deprioritize | Low fit or low readiness = not worth effort now |

### Score Bands (Overall 0-100)

| Band | Score | Meaning |
|------|-------|---------|
| **Launch Ready** | 85-100 | Strong across all dimensions -- execute the plan |
| **Almost There** | 70-84 | Good foundation, fill 1-2 gaps |
| **Needs Work** | 55-69 | Multiple capability gaps to address |
| **Early Stage** | 40-54 | Build fundamentals before GTM activation |
| **Reset** | 0-39 | Return to upstream scorecards |

---

## 6. THE 13 GTM MOTIONS -- OVERVIEW

Each motion has detailed intelligence (definition, real examples, win/fail conditions, MENA execution playbooks, 72-hour commitments) in `motions.md`.

| # | Motion | Default Fit | Base MENA | Weekly Hours |
|---|--------|------------|-----------|-------------|
| 0 | Waitlist Heat-to-Webinar Close | 5 | 8 | 6 |
| 1 | Build-in-Public Trust Flywheel | 4 | 5 | 4 |
| 2 | Authority Education Engine | 7 | 8 | 8 |
| 3 | Wave Riding Distribution | 4 | 5 | 3 |
| 4 | LTD Cash-to-MRR Ladder | 3 | 4 | 5 |
| 5 | Signal Sniper Outbound | 6 | 6 | 8 |
| 6 | Outcome Demo First | 7 | 8 | 5 |
| 7 | Hammering-Feature-First Launches | 5 | 5 | 6 |
| 8 | MicroSaaS BOFU SEO Strike | 6 | 5 | 6 |
| 9 | Dream 100 Strategy | 7 | 9 | 5 |
| 10 | 7x4x11 Strategy (Chet Holmes) | 5 | 7 | 10 |
| 11 | Value Trust Engine | 6 | 8 | 7 |
| 12 | Paid VSL Value Ladder | 4 | 5 | 8 |

---

## 7. EXPERT FRAMEWORK GATES -- SUMMARY

Non-scoring diagnostic frameworks that add strategic context. Full details in `scoring-rubrics.md`.

| Gate | Trigger | Purpose |
|------|---------|---------|
| **Pattern of Inaction** | Founder >6 months, zero launches | Detect analysis paralysis; prescribe 72-hour rule |
| **Content Systems Check** | Content-dependent motion is PRIMARY | Validate sustainable content production |
| **Solo Founder Bandwidth** | Always applied | Cap concurrent motions by available hours |
| **Pattern Interrupt Readiness** | Content motion is PRIMARY/SECONDARY | Validate hook-based content capability |
| **Engagement Audit** | Top 3 motions | Validate engagement loop completeness |

---

## 8. CLAUDE EXECUTION FLOW

When running this scorecard conversationally (outside the HTML):

1. **Load Upstream Data (2 min):** Confirm SC1-SC4 are complete; load scores and key outputs
2. **Run Pattern of Inaction Check (1 min):** Validate execution history
3. **Ask 13 MC Questions (10 min):** Present each question with context; record answers
4. **Compute Scores (auto):** Apply weight matrix, upstream bonuses, strategy path bonuses, MENA multiplier
5. **Rank All 13 Motions (auto):** Sort by composite score; assign tiers
6. **Apply Expert Gates (5 min):** Content Systems Check, Bandwidth Calculator, Pattern Interrupt Readiness, Engagement Audit
7. **Generate Motion Intelligence (5 min):** For top 3 motions, pull GTM Matrix intelligence (examples, win/fail, MENA execution guide)
8. **Assign 72-Hour Commitment (2 min):** Tied to PRIMARY motion
9. **Generate Output File (3 min):** Complete gtm-fitness.md (see `templates.md`)
10. **Present Results (5 min):** Show primary motions, 90-day plan, capability gaps

**Total Time:** 30-35 minutes (shorter than v2.0 because MC-only removes free-text wait time)

---

## 9. CROSS-REFERENCE: HTML SCORING vs. SKILL SCORING

The HTML file (EO-GTM-Fitness-Scoring.html) implements the automated version. This skill provides the conversational version + strategic intelligence layer.

| Feature | HTML (Automated) | Skill (Conversational) |
|---|---|---|
| Questions | 13 MC, self-serve | 13 MC + follow-up probes |
| Scoring | Weight matrix + composite formula | Same formula + upstream data deep mapping |
| Motion intelligence | Short descriptions, howToStart | Full GTM Matrix data (examples, win/fail, MENA execution) |
| Expert gates | Not implemented | 5 diagnostic frameworks |
| Output | Results page + webhook to n8n | gtm-fitness.md file |
| Upstream integration | localStorage scores | Full upstream output analysis |
| 72-Hour commitment | Displayed on results page | Detailed with accountability mechanism |
| MENA execution | Brief notes per motion | Week-by-week playbooks |

---

**END OF SKILL v3.0**
