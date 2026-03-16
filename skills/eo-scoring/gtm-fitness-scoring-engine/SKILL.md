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
**Execution Model:** 13 MC questions → Weight Matrix scoring → Motion composite ranking → Tier assignment → 72-Hour Commitment

---

## 1. STRATEGIC PURPOSE

GTM Fitness Scoring answers one question: **"Of all 13 go-to-market motions, which 2-3 should this founder activate FIRST?"**

This is NOT a general marketing assessment. It's a precision instrument that combines:
- **Upstream context** (SC1-SC4): niche, ICP, market conditions, strategy path, founder archetype
- **Founder's business reality** (13 MC questions): assets, infrastructure, capacity, market dynamics
- **Motion intelligence** (GTM Matrix): real examples, win/fail conditions, MENA execution playbooks
- **Weight matrix scoring**: each question influences each motion differently (169 weighted connections)

**Philosophy:** Every founder has 2-3 motions that are natural fits and 10 that will waste their time. The scoring engine finds the natural fits by cross-referencing what the founder HAS (assets, infra, capacity) with what each motion NEEDS (prerequisites, conditions, execution requirements).

---

## 2. PREREQUISITES — UPSTREAM DATA CONTRACT

### Required Upstream Scorecards

**SC1 (Project Definition) provides:**
- Niche definition (3-level: industry → segment → pain)
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
2. If any upstream score < 40 (RESET band): flag warning — GTM assessment may be premature
3. Load upstream scores to calculate fit bonuses and strategy path bonuses

### Upstream Bonus Calculation (from HTML scoring engine)

```
upstreamFitBonus = 0
if SC1 score > 70: +0.5
if SC2 score > 70: +0.5
if SC3 score > 70: +0.3
if SC4 score > 70: +0.3
Maximum upstream bonus: 1.6 (added to each motion's defaultFit)
```

### Strategy Path Bonus Matrix (from HTML scoring engine)

Each SC4 strategy path gives bonuses to specific motions:

| Motion | Replicate | Consulting | Micro-SaaS | Hammering |
|--------|-----------|------------|------------|-----------|
| 0. Waitlist Heat | +1 | 0 | +1 | 0 |
| 1. Build-in-Public | 0 | 0 | +2 | +1 |
| 2. Authority Education | +1 | +2 | 0 | 0 |
| 3. Wave Riding | 0 | 0 | +1 | 0 |
| 4. LTD Cash-to-MRR | 0 | 0 | +2 | 0 |
| 5. Signal Sniper | 0 | +1 | 0 | +2 |
| 6. Outcome Demo | +1 | +1 | +1 | +1 |
| 7. Hammering-Feature | 0 | 0 | +1 | +3 |
| 8. BOFU SEO | 0 | 0 | +2 | +1 |
| 9. Dream 100 | +1 | +2 | 0 | 0 |
| 10. 7x4x11 | 0 | +1 | 0 | +1 |
| 11. Value Trust Engine | +1 | +1 | +1 | 0 |
| 12. Paid VSL | 0 | 0 | 0 | 0 |

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
"How often do you publish content — articles, videos, or podcasts?"
- Rarely or never (1)
- Once a month or less (2)
- Weekly (3)
- Multiple times per week (4)

*Why it matters:* Build-in-Public (w=3), Authority Education (w=3), Wave Riding (w=2), BOFU SEO (w=2) are content-dependent. Signal Sniper (w=0), LTD (w=0) don't care.

**Q2: Founder Visibility** (`q_founder_visibility`)
"Are you comfortable being the public face of your business?"
- Not at all (1)
- Somewhat (2)
- Yes — I regularly show up on social media (3)
- Absolutely — I am already building a personal brand (4)

*Why it matters:* Build-in-Public (w=3), Authority Education (w=3), Waitlist Heat (w=2), Dream 100 (w=2), Value Trust Engine (w=2) need visible founders. Signal Sniper (w=0), LTD (w=0), Hammering-Feature (w=0) work behind the scenes.

### YOUR PRODUCT (Q3-Q4)

**Q3: Demo Ability** (`q_demo_ability`)
"Can you show a clear result or transformation from your product in under 5 minutes?"
- No — value takes time to show (1)
- Partially — some features show quick wins (2)
- Yes — I have a solid demo or walkthrough (3)
- Absolutely — the result is instantly visible and impressive (4)

*Why it matters:* Outcome Demo First (w=3), LTD Cash-to-MRR (w=3), Hammering-Feature (w=2), Paid VSL (w=2). If you can't show the value quickly, demo-dependent motions fail.

**Q4: Outbound Tools** (`q_outbound_tools`)
"What outreach tools do you have set up today?"
- Nothing set up yet (1)
- Basic — just a CRM or basic email (2)
- Decent stack — email sender + LinkedIn + CRM (3)
- Full stack — multi-channel outbound already running (4)

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
- Strong — 20+ active relationships (4)

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
- No — they don't know they need it yet (1)
- Some search — but low volume (2)
- Yes — clear search demand exists (3)
- High volume with strong buying intent (4)

*Why it matters:* BOFU SEO (w=3), Hammering-Feature (w=3), Paid VSL (w=2), Authority Education (w=1), Wave Riding (w=1). Without search demand, SEO and paid acquisition are pointless.

**Q10: Sales Capacity** (`q_sales_capacity`)
"Do you have capacity for one-on-one sales conversations?"
- No — everything needs to be self-serve (1)
- Limited — a few calls per week (2)
- Moderate — 10 to 20 calls per week (3)
- Strong — dedicated sales team or high capacity (4)

*Why it matters:* 7x4x11 (w=3), Signal Sniper (w=3), Dream 100 (w=2), Outcome Demo (w=2). Relationship-based motions die without conversation capacity.

### YOUR CAPACITY (Q11)

**Q11: Event Experience** (`q_event_experience`)
"Have you run webinars, workshops, or live events before?"
- Never (1)
- Once or twice (2)
- Several times — I know the format well (3)
- Regularly — it is part of how I sell (4)

*Why it matters:* Waitlist Heat (w=3), Value Trust Engine (w=3), Authority Education (w=2), 7x4x11 (w=2), Dream 100 (w=1). Webinar/event-dependent motions need presenters who can perform.

### YOUR MARKET — MENA (Q12)

**Q12: MENA Focus** (`q_mena_focus`)
"How much of your business targets the MENA region specifically?"
- MENA is not my focus at all (1)
- Some MENA but mostly global/US (2)
- MENA is a primary market (3)
- MENA-only or MENA-first (4)

*MENA Multiplier:*
- Not focused (1) → 0.3x MENA score
- Some MENA (2) → 0.6x MENA score
- Primary market (3) → 1.0x MENA score
- MENA-only (4) → 1.2x MENA score

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

## 5. SCORING ENGINE

### Motion Readiness Score (per motion)

For each of 13 motions, readiness is calculated from answers x weights:

```
readinessRaw = SUM(answer_value[q] x weight[motion][q]) for q = 0..11
readinessMax = SUM(4 x weight[motion][q]) for q = 0..11  // max possible
readiness = (readinessRaw / readinessMax) x 10   // scaled 0-10
```

If a motion has zero total weight (impossible with current matrix), default readiness = 5.

### Motion Fit Score

```
fit = defaultFit + upstreamFitBonus + pathBonus[motion]
fit = min(10, fit)  // cap at 10
```

Where:
- `defaultFit` is the motion's baseline fit (from MOTIONS array)
- `upstreamFitBonus` comes from SC1-SC4 scores > 70
- `pathBonus` comes from SC4 strategy path

### Motion MENA Score

```
mena = min(10, baseMena x menaMultiplier)
```

Where `menaMultiplier` = [0.3, 0.6, 1.0, 1.2] based on Q12 answer.

### Composite Score (per motion)

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

### Overall Score (0-100)

```
raw = ((sum_of_answers - num_answered) / (num_answered x 3)) x 85
bonus = SC1>70? +3 : 0 + SC2>70? +3 : 0 + SC3>70? +2 : 0 + SC4>70? +2 : 0
bonus += Q12 answer >= 3? +3 : (>= 2? +1 : 0)
overall = min(100, max(0, round(raw + bonus)))
```

### Score Bands

| Band | Score | Meaning |
|------|-------|---------|
| **Launch Ready** | 85-100 | Strong across all dimensions — execute the plan |
| **Almost There** | 70-84 | Good foundation, fill 1-2 gaps |
| **Needs Work** | 55-69 | Multiple capability gaps to address |
| **Early Stage** | 40-54 | Build fundamentals before GTM activation |
| **Reset** | 0-39 | Return to upstream scorecards |

---

## 6. THE 13 SMOrchestra GTM MOTIONS — DEEP INTELLIGENCE

Each motion below contains: definition, real examples from the GTM Matrix, default scoring parameters, best fit conditions, win/fail conditions, MENA execution intelligence, and the 72-hour launch commitment.

---

### Motion 0: Waitlist Heat-to-Webinar Close

**Default Fit:** 5 | **Base MENA:** 8 | **Weekly Hours:** 6

**What it is:** Controlled launch with scarcity mechanics — waitlist captures demand, webinar converts it. Works because the webinar lets you teach, demonstrate credibility, and close in a single session.

**Best Fit For:**
- Offers that need explanation and trust before purchase
- Founders comfortable on camera
- Products with a transformation story (before/after)
- Stage: pre-launch to $500K ARR
- ACV: $500-$10K

**Real Examples (from GTM Matrix):**
- **Kleo** — Reached 61K MRR. Launched Product Hunt, built waitlist from viral post, hosted limited-seat webinar. Conversion rate spiked because waitlist created FOMO + webinar built trust simultaneously.
- **Copy.ai** — $2.4M ARR in 11 months. Used waitlist to demo webinar sequence where they showed live AI writing. Attendees converted at 3x the rate of cold landing page visitors.
- **Jasper AI** — Built massive waitlist via affiliate-powered referral loops. Each webinar batch converted at 15-22% because the waitlist pre-qualified interest.

**When This Wins:**
- Offer genuinely needs explanation (complex transformation)
- Founder can present well (energy, confidence, storytelling)
- Email list or social following provides initial waitlist seed
- Scarcity is real (limited seats, limited-time pricing)

**When This Fails:**
- Product is self-explanatory (no need for webinar)
- Founder is uncomfortable presenting live
- No existing audience to seed the waitlist
- Fake scarcity — audience sees through it immediately

**MENA Execution Intelligence:**
One of the strongest motions for MENA because it matches how trust is built here — personal demonstration by a credible expert in a group setting. MENA buyers respond to: (1) live interaction (Q&A builds trust faster than async content), (2) the teacher-student dynamic (authority positioning), (3) community proof (seeing other attendees validates interest).

**MENA Week-by-Week Execution:**
- Week 1: Build bilingual landing page (Arabic headline, English details). Set up waitlist form with WhatsApp follow-up automation.
- Week 2: Announce on LinkedIn (Arabic post) and WhatsApp groups. Target 100+ signups.
- Week 3: Run first webinar (evening Gulf time, 7-9pm). Arabic primary, English slides.
- Week 4: Follow up via WhatsApp (not email) with recording + limited-time offer.

**Critical Weight Dependencies:** Q0-email list (w=3), Q11-event experience (w=3), Q2-visibility (w=2), Q6-network (w=2)

**72-Hour Launch Commitment:** Launch a landing page with waitlist form; drive 50+ signups via your network; announce 3 webinar topics to your list.

---

### Motion 1: Build-in-Public Trust Flywheel

**Default Fit:** 4 | **Base MENA:** 5 | **Weekly Hours:** 4

**What it is:** Transparent founder journey shared publicly — revenue numbers, build decisions, failures, wins. Creates trust through vulnerability and consistency, not credentials.

**Best Fit For:**
- Solo founders or small teams
- Products where the founder IS the brand
- Early stage (pre-revenue to $100K ARR)
- Needs trust more than features
- ACV: <$2K (consumer/prosumer)

**Real Examples (from GTM Matrix):**
- **Pieter Levels (NomadList)** — $2.5M ARR built entirely through public building on Twitter/X. No ads, no outbound. Pure transparency to trust to conversion.
- **Marc Lou** — Ships products in 48-72 hours and documents everything. Revenue screenshots drive credibility. Each public launch creates its own distribution.
- **Tony Dinh (TypingMind)** — Shared every milestone publicly. Community formed around the journey, not the product. Retention driven by feeling "part of the story."

**When This Wins:**
- Founder has authentic personality and is comfortable being vulnerable
- Product development is fast enough to show weekly progress
- Target audience hangs out on Twitter/X or LinkedIn
- The journey itself is interesting (novel problem, unique approach)

**When This Fails:**
- Founder is private or corporate-trained (can't share revenue, struggles, decisions)
- Product has slow development cycles (nothing to show weekly)
- Target buyer doesn't consume founder content (enterprise buyers don't care about your build log)
- Founder treats it as marketing tactic rather than authentic practice

**MENA Execution Intelligence:**
Trust is relationship-first in MENA. Build-in-public works but needs adaptation: (1) Negative feedback is often indirect in Arab culture — sharing "failures" publicly can feel uncomfortable and audience may not engage with vulnerability the same way Western audiences do. (2) Revenue sharing is culturally unusual in MENA — consider sharing growth percentages rather than absolute numbers. (3) Arabic content on LinkedIn gets higher organic reach in Gulf markets.

**MENA Week-by-Week Execution:**
- Week 1: Choose primary channel (LinkedIn for B2B, Twitter for tech). Post first build update in Arabic.
- Week 2: Commit to 3 posts/week cadence. Share one "lesson learned" (not "failure" — reframe for cultural fit).
- Week 3: Engage 10 comments/day on other Arabic builders' posts. Build reciprocal audience.
- Week 4: Share a milestone post (users, revenue %, feature shipped). Ask community what to build next.

**Critical Weight Dependencies:** Q1-content frequency (w=3), Q2-visibility (w=3), Q8-speed to ship (w=2)

**72-Hour Launch Commitment:** Ship a public launch post with pricing, timeline, and 1 working feature. Commit to 3 posts/week for 30 days.

---

### Motion 2: Authority Education Engine

**Default Fit:** 7 | **Base MENA:** 8 | **Weekly Hours:** 8

**What it is:** Expert positioning through educational content — frameworks, courses, guides, workshops. You teach the problem space so well that buyers trust you to solve it.

**Best Fit For:**
- Founders with deep domain expertise (10+ years in the field)
- Markets where the buyer needs to believe you understand the problem better than anyone
- Consulting-First SaaS strategy path
- ACV: $2K-$50K (expertise justifies premium pricing)
- Stage: any (works from 0 to $10M ARR)

**Real Examples (from GTM Matrix):**
- **SparkToro (Rand Fishkin)** — $800K first year. Rand's authority from Moz + Whiteboard Friday gave him instant credibility. The product launched to an audience that already trusted his judgment.
- **Gong** — Used "Revenue Intelligence" category creation through relentless educational content (data studies, benchmarks, teardowns). Buyers came pre-educated and pre-sold.
- **Drift (David Cancel)** — Created "Conversational Marketing" category through book, podcast, and conference. Educational moat made competitors look like followers.

**When This Wins:**
- Founder genuinely has 10+ years of expertise worth teaching
- ICP respects credentials and intellectual depth
- Problem space is complex enough that education = differentiation
- Founder can create content consistently (weekly minimum)

**When This Fails:**
- Founder doesn't actually have unique expertise (generic "thought leadership")
- ICP doesn't consume educational content (they want solutions, not lessons)
- Content is sporadic (authority requires consistency)
- Founder teaches without connecting to their product (education without conversion path)

**MENA Execution Intelligence:**
MENA is higher context and more hierarchical. Authority content builds trust faster than feature lists. Arab buyers respect demonstrated expertise — if you can teach them something they didn't know, you've earned the right to sell. Arabic educational content is massively undersupplied in B2B SaaS categories.

**MENA Week-by-Week Execution:**
- Week 1: Write your core framework as an Arabic LinkedIn article (2,000+ words). Pin it to your profile.
- Week 2: Create a lead magnet PDF distilling the framework into actionable steps. Gate behind WhatsApp or email.
- Week 3: Launch a weekly content cadence — 1 long post + 2 short insights per week, alternating Arabic/English.
- Week 4: Host first live workshop (Zoom, 45 min, Arabic). Record and repurpose as 5 content clips.

**Critical Weight Dependencies:** Q1-content frequency (w=3), Q2-visibility (w=3), Q0-email list (w=2), Q11-event experience (w=2)

**72-Hour Launch Commitment:** Publish 3 authority posts (LinkedIn, blog, or Medium) on your core framework. Each post must teach something specific, not just state opinions.

---

### Motion 3: Wave Riding Distribution

**Default Fit:** 4 | **Base MENA:** 5 | **Weekly Hours:** 3

**What it is:** Attaching to real trends, events, or news cycles to ride distribution waves you didn't create. Requires speed and relevance.

**Best Fit For:**
- Teams that can ship fast (same-day turnaround)
- Products that can be reframed for trending contexts
- Founders who monitor trends and can react quickly
- Stage: any, but especially effective for getting noticed early

**Real Examples (from GTM Matrix):**
- **Notion** — Rode the "remote work" wave during COVID. Every productivity trend got a Notion template. They didn't create the wave — they surfed it better than anyone.
- **Calendly** — Rode Zoom's explosion. As everyone scrambled to schedule video calls, Calendly became the default scheduling link. Perfect wave attachment.
- **Deel** — Rode the "hire anywhere" wave post-COVID. International hiring became mainstream; Deel positioned as THE solution for that specific moment.

**When This Wins:**
- You monitor trends actively (alerts, social listening, industry events)
- Your product can be reframed for trending contexts quickly
- You can ship content or features in hours, not weeks
- The wave has real buyer intent (not just chatter)

**When This Fails:**
- Slow reaction time (by the time you respond, the wave is over)
- Forced relevance (product doesn't genuinely relate to the trend)
- No distribution channel ready (wave comes but you can't reach anyone)
- Trend-chasing without substance (audience sees through it)

**MENA Execution Intelligence:**
Trends in MENA are often driven by events, seasons, and business cycles. Key waves: Ramadan (consumer behavior shifts), GITEX (tech buying season in Dubai), Saudi Vision 2030 announcements, COP/sustainability events, regional IPOs. Arabic-first content on trending topics gets significantly higher engagement because competition is lower.

**MENA Week-by-Week Execution:**
- Week 1: Set up Google Alerts in Arabic and English for your niche. Monitor MENA business news daily.
- Week 2: Draft 3 template responses for predictable trends (seasonal events, regulation changes, major conferences).
- Week 3: When a wave hits, ship content within 4 hours. Publish in Arabic first, English second.
- Week 4: Build a rapid-response workflow: spot to draft to review to publish in under 2 hours.

**Critical Weight Dependencies:** Q8-speed to ship (w=3), Q1-content frequency (w=2)

**72-Hour Launch Commitment:** Identify 5 relevant waves (trends, events, news); create 1 hook/angle for each; publish content for the most timely one within 72 hours.

---

### Motion 4: LTD Cash-to-MRR Ladder

**Default Fit:** 3 | **Base MENA:** 4 | **Weekly Hours:** 5

**What it is:** Launch with a Lifetime Deal to generate cash and users, then transition buyers to monthly/annual subscriptions. Cash injection funds development; user base provides feedback and social proof.

**Best Fit For:**
- Simple tools that deliver obvious value with low support burden
- Products that can handle LTD users without drowning in support
- Early stage (0-$100K) where cash is more important than MRR
- ACV: <$500 initial, transitioning to $500-$2K MRR

**Real Examples (from GTM Matrix):**
- **AppSumo ecosystem** — Thousands of SaaS products use LTD launches as initial distribution. Winners (like Frase.io, Jasper early) used the LTD cash to fund development, then gradually raised prices.
- **Tally.so** — Used LTD to build initial user base, then transitioned to MRR. LTD users became advocates and testimonial providers.

**When This Wins:**
- Product is genuinely useful enough that LTD buyers become advocates
- LTD-to-MRR transition path is designed upfront (tier limits, feature gating)
- Support burden is manageable (self-serve product)
- Cash is more valuable than MRR at this stage

**When This Fails:**
- LTD attracts deal hunters who never use the product or refer others
- Support burden overwhelms small team
- No conversion path to MRR (LTD buyers stay on LTD forever)
- Product is too complex for self-serve LTD buyers

**MENA Execution Intelligence:**
Price sensitivity exists, but trust still matters. LTD alone does not build trust in MENA. Combine LTD with: Arabic support (even basic WhatsApp response), local case studies, and a clear upgrade path. AppSumo-style platforms have lower penetration in MENA — consider launching on Arabic deal sites or WhatsApp groups instead.

**MENA Week-by-Week Execution:**
- Week 1: Define LTD tier structure ($49/$99/$199 lifetime). Set feature limits per tier.
- Week 2: Create Arabic landing page with demo video. List on AppSumo + announce in Arabic tech communities.
- Week 3: Drive traffic via Arabic LinkedIn posts and WhatsApp groups. Target 100 LTD sales.
- Week 4: Begin LTD-to-MRR conversion outreach. Offer upgrade incentives to active LTD users.

**Critical Weight Dependencies:** Q3-demo ability (w=3), Q8-speed to ship (w=3)

**72-Hour Launch Commitment:** Launch LTD offer with 1-month deadline; announce to audience via email + social + WhatsApp.

---

### Motion 5: Signal Sniper Outbound

**Default Fit:** 6 | **Base MENA:** 6 | **Weekly Hours:** 8

**What it is:** Targeted outbound where every email is triggered by an observable event (signal) — job change, funding announcement, tech adoption, expansion, hiring pattern. You reach the right person at the right moment with the right message.

**Best Fit For:**
- B2B SaaS with observable buying triggers and clear ICP
- Founders with outbound infrastructure (CRM + email sender + LinkedIn)
- Works from 0 to billions in ARR
- ACV: $2K-$100K+ (justifies the per-lead effort)
- Teams with sales conversation capacity

**Real Examples (from GTM Matrix):**
- **Deel** — Gold standard for signal-based outbound. Tracked companies posting remote job listings, expanding to new countries, or hiring compliance roles. Each signal triggered a specific message sequence that felt helpful, not salesy.
- **Gong** — Monitored when companies hired new VP Sales or expanded SDR teams. Reached out with data-driven insights about conversation intelligence.
- **Clay + Instantly stack** — Modern signal sniper stack: Clay detects signals (job changes, tech installs, funding), enriches contacts, Instantly delivers personalized sequences at scale.

**When This Wins:**
- Signals are observable and reliable (not every industry has visible triggers)
- Message is genuinely helpful (not just "saw you raised money, want to chat?")
- Outbound infrastructure is set up (email warmed, LinkedIn active, CRM tracking)
- Sales capacity exists to handle replies
- ICP is narrow enough that signals are meaningful

**When This Fails:**
- Signals are generic or stale (>90 days old)
- Message doesn't connect signal to pain point
- No infrastructure (cold emailing from Gmail gets flagged)
- No sales capacity to handle conversations
- ICP is too broad (signals don't differentiate)

**MENA Execution Intelligence:**
Signals are less visible in MENA than the US. Funding rounds are not always publicly announced. Job changes may not be updated on LinkedIn. Compensation: (1) Monitor Arabic business news for expansion signals, (2) Track GITEX exhibitors and attendees, (3) Use WhatsApp as follow-up channel (much higher response rate than email in Gulf). LinkedIn InMail response rates in MENA are actually higher than US because the channel is less saturated.

**MENA Week-by-Week Execution:**
- Week 1: Define 10 triggers per vertical (hiring, funding, expansion, tech change, event attendance, regulation change). Set up monitoring in Clay or manual alerts.
- Week 2: Create 3 message patterns per trigger. Arabic opening line + English body (or full Arabic for Gulf ICP).
- Week 3: Launch first 50 signals to personalized sequences. Route replies to calendar booking.
- Week 4: Measure response rates. Refine signal definitions based on which triggers generate replies.

**Critical Weight Dependencies:** Q4-outbound tools (w=3), Q10-sales capacity (w=3), Q7-deal size (w=2)

**72-Hour Launch Commitment:** Send 50 personalized cold emails (minimum 3 custom lines per email referencing a specific signal).

---

### Motion 6: Outcome Demo First

**Default Fit:** 7 | **Base MENA:** 8 | **Weekly Hours:** 5

**What it is:** Lead with the result, not the pitch. Show the prospect exactly what your product does FOR THEM — a custom report, audit, lead list, dashboard, or analysis — before asking for anything.

**Best Fit For:**
- Tools where the output is visible and valuable on its own (leads, audits, reports, dashboards, designs)
- Products with clear before/after transformation
- Founders who can demo confidently
- ACV: $2K-$50K (demo effort justified by deal size)

**Real Examples (from GTM Matrix):**
- **SEMrush / Ahrefs** — "Enter your URL and see your SEO issues" = outcome demo that hooks you before you pay. The free audit IS the sales pitch.
- **Gong** — Demo calls showed prospects their OWN conversation data with AI insights. Impossible to ignore.
- **HubSpot Website Grader** — Free tool that grades your website. The grade IS the outcome demo. Low score = natural conversion to HubSpot tools.

**When This Wins:**
- Output is visually impressive and immediately useful
- Demo can be personalized to each prospect (not generic)
- Product genuinely solves a visible problem
- Founder can present the demo with energy and confidence

**When This Fails:**
- Product value is abstract or long-term (hard to demo in 5 minutes)
- Demo requires too much setup per prospect (not scalable)
- Output looks unimpressive compared to competitors
- Founder can't present confidently

**MENA Execution Intelligence:**
Strong in MENA. Trust is built by proof, not promises. Outcome demos reduce the trust gap that typically requires months of relationship building. Arabic-language demos get significantly higher engagement. Pro tip: record a 3-minute demo in Arabic and send via WhatsApp before a formal meeting — this pre-sells the meeting itself.

**MENA Week-by-Week Execution:**
- Week 1: Build a 3-minute demo showing the outcome (before vs after). Record in Arabic and English.
- Week 2: Create personalized demo for 5 target accounts using their actual data (public info).
- Week 3: Share demos via WhatsApp and LinkedIn DM. Track who watches and follows up.
- Week 4: Convert watchers to meetings. Use the demo as meeting opener.

**Critical Weight Dependencies:** Q3-demo ability (w=3), Q10-sales capacity (w=2), Q2-visibility (w=1)

**72-Hour Launch Commitment:** Record and publish a 5-10 minute outcome demo (showing clear result) using real data. Share in 3 relevant communities.

---

### Motion 7: Hammering-Feature-First Launches

**Default Fit:** 5 | **Base MENA:** 5 | **Weekly Hours:** 6

**What it is:** Ship one differentiated feature at a time, make noise about each one, and let the feature be the marketing. Product updates become content; each launch creates its own distribution moment.

**Best Fit For:**
- MicroSaaS or narrow-ICP products with a clear differentiator
- Founders who ship fast (weekly/biweekly releases)
- Products in competitive markets where feature differentiation matters
- Hammering Deep strategy path
- ACV: $500-$5K

**Real Examples (from GTM Matrix):**
- **Linear** — Every feature release became a design statement. Feature launches doubled as brand moments. "We shipped [X]" posts consistently went viral in dev communities.
- **Superhuman** — "The fastest email experience" positioned around ONE feature (speed). Every update reinforced the core differentiator.
- **Lemon Squeezy** — Competitive market (payment processing), won by hammering features competitors lacked. Each feature = content = distribution.

**When This Wins:**
- Product has genuinely unique features worth highlighting
- Development velocity is high (something new to show every 1-2 weeks)
- Target community is feature-hungry (developers, designers, power users)
- Competitor comparison is favorable

**When This Fails:**
- Features are incremental, not interesting enough to create content about
- Development is slow (nothing to hammer on weekly basis)
- Target buyer doesn't care about features (wants outcomes, not capabilities)
- The product is a clone without real differentiation

**MENA Execution Intelligence:**
Feature-first launches need localization to land in MENA: (1) Feature comparison pages in Arabic, (2) "vs competitor" content needs local competitors, (3) GITEX and similar events are perfect stages for feature demos.

**MENA Week-by-Week Execution:**
- Week 1: Identify your ONE differentiated feature. Create a comparison page vs alternatives.
- Week 2: Write 5 use-case stories around that feature. Arabic and English versions.
- Week 3: Launch the feature publicly. Post on Product Hunt, Arabic tech forums, LinkedIn.
- Week 4: Collect user feedback. Start building next feature to hammer.

**Critical Weight Dependencies:** Q8-speed to ship (w=3), Q9-search demand (w=3), Q3-demo ability (w=2)

**72-Hour Launch Commitment:** Identify your ONE differentiated feature; create a comparison page vs alternatives; write 5 use-case stories around that feature.

---

### Motion 8: MicroSaaS BOFU SEO Strike

**Default Fit:** 6 | **Base MENA:** 5 | **Weekly Hours:** 6

**What it is:** Dominate bottom-of-funnel search keywords where buyers are actively looking for solutions. "Best [category] tool," "[competitor] alternative," "[category] for [use case]" pages.

**Best Fit For:**
- MicroSaaS or narrow ICP where buyers search for solutions directly
- Products with clear competitor alternatives
- Markets with existing search demand (not category creation)
- Long-term play (SEO compounds over 3-6 months)
- ACV: $500-$5K

**Real Examples (from GTM Matrix):**
- **Ahrefs** — Built authority through BOFU content: "best SEO tools," "Moz alternative," "keyword research tools." Each page targets buyers with credit card in hand.
- **Zapier** — "How to connect [X] to [Y]" pages for every integration. Pure BOFU intent: the reader wants to DO the thing Zapier enables.
- **Monday.com** — Aggressive "[competitor] alternative" pages. Capturing buyers who are ready to switch.

**When This Wins:**
- Clear search demand exists (tools like Ahrefs/SEMrush confirm volume)
- Your product genuinely compares favorably to alternatives
- You can produce high-quality comparison/alternative content
- You have patience (SEO takes 3-6 months to compound)

**When This Fails:**
- No search demand (buyers don't know the category exists)
- Product can't honestly win comparison (your alternative page looks weak)
- Content quality is low (thin "vs" pages don't rank anymore)
- Impatient founder wants results in weeks, not months

**MENA Execution Intelligence:**
BOFU SEO must do more than rank in MENA — add Arabic content, local case studies, and WhatsApp CTAs. Arabic BOFU content is massively underserved. Few competitors create Arabic comparison pages. If you rank for "[category] in Arabic" or "[tool] with Arabic" you capture an almost uncontested market.

**MENA Week-by-Week Execution:**
- Week 1: Research 20 bottom-of-funnel keywords (English + Arabic variations). Use Ahrefs/SEMrush for English, Google autocomplete for Arabic.
- Week 2: Write your first comparison/alternative page (English). Add local proof points.
- Week 3: Create Arabic version of top 5 BOFU pages. Add WhatsApp CTA instead of email opt-in.
- Week 4: Set up basic on-page SEO and tracking. Submit to Google Search Console.

**Critical Weight Dependencies:** Q9-search demand (w=3), Q1-content frequency (w=2), Q8-speed to ship (w=2)

**72-Hour Launch Commitment:** Identify and outline 5 bottom-of-funnel keywords; publish 1 pillar article targeting your highest-intent keyword.

---

### Motion 9: Dream 100 Strategy

**Default Fit:** 7 | **Base MENA:** 9 | **Weekly Hours:** 5

**What it is:** Identify 100 individuals/companies who already have your dream audience. Build relationships with them. Get introduced, promoted, or partnered. Leverage their distribution instead of building your own from scratch.

**Best Fit For:**
- Founders who want leverage through distribution, not grind
- Any stage — but especially powerful at 0-$500K where you lack your own audience
- Products where trust/credibility matters (enterprise, consulting, high-ticket)
- Founders with relationship skills and patience
- Strategy paths: Consulting-First, Replicate & Localize

**Real Examples (from GTM Matrix):**
- **Chet Holmes (original creator)** — The Dream 100 concept from "The Ultimate Sales Machine." Holmes's company grew from $0 to $300M by relentlessly targeting the top 100 potential customers with multi-touch campaigns.
- **Alex Hormozi** — Before launching Acquisition.com, Hormozi identified the 100 business owners he most wanted to acquire. He offered free value until they became believers. Then he acquired their businesses.
- **Russell Brunson** — Built ClickFunnels to $100M by identifying the top 100 influencers in marketing. He interviewed them, promoted them, collaborated with them — and they promoted ClickFunnels to their audiences.

**When This Wins:**
- You can identify 100 people who genuinely have your ICP's attention
- You're willing to provide value first (months of relationship building)
- Your product/service is genuinely valuable enough to warrant collaboration
- You have patience (Dream 100 is a 90-day minimum play)

**When This Fails:**
- List is too generic (random influencers, not ICP-relevant)
- Outreach is transactional ("hey, want to promote my product?")
- No value to offer in exchange (just asking for favors)
- Impatient execution (gives up after 2 weeks of no response)

**MENA Execution Intelligence:**
Extremely strong in MENA because networks and introductions compound here. Arab business culture is built on relationships and trust circles. A warm introduction from a respected contact is worth 100 cold emails. Dream 100 in MENA should prioritize: (1) Identifying regional industry leaders and conference speakers, (2) Engaging at GITEX, Arabnet, and regional events, (3) WhatsApp is the relationship maintenance channel (not LinkedIn DMs), (4) Arabic language outreach for Gulf targets.

**MENA Week-by-Week Execution:**
- Week 1: List your Dream 100 influencers and partners. Prioritize MENA-based contacts. Research each one.
- Week 2: Engage with their content for 2 weeks — thoughtful Arabic comments on their LinkedIn posts, share their content with added insight.
- Week 3: Propose a specific collaboration or value exchange (not "let's chat" — something concrete).
- Week 4: Follow up via WhatsApp (if you have the relationship). Nurture, don't sell.

**Critical Weight Dependencies:** Q6-network (w=3), Q2-visibility (w=2), Q10-sales capacity (w=2)

**72-Hour Launch Commitment:** Send personalized outreach to 10 named dream accounts/individuals with specific value proposition for each.

---

### Motion 10: 7x4x11 Strategy (Chet Holmes)

**Default Fit:** 5 | **Base MENA:** 7 | **Weekly Hours:** 10

**What it is:** Systematic multi-touch cadence: 7 different types of touches x 4 different media x 11 touches per month to your target list. Frequency creates familiarity; familiarity creates trust; trust creates conversion.

**Best Fit For:**
- High-ticket offers ($10K+ ACV) where persistence pays off
- Service-to-SaaS bridges where relationships drive deals
- Founders/teams with sales capacity for 1-on-1 conversations
- Consulting-First and Replicate & Localize strategy paths

**Real Examples (from GTM Matrix):**
- **Chet Holmes (originator)** — Built the methodology at Berkshire Hathaway. Targeted the top 167 advertisers with relentless multi-channel touches. 6 of those 167 became clients that represented $300M+ in revenue.
- **Salesforce (early days)** — Multi-touch cadence to enterprise prospects: email to event invite to content to call to physical gift to another event. Frequency of high-quality touches wore down resistance.
- **Outreach.io** — Practices what it preaches. Their sales team uses multi-step, multi-channel sequences that mirror the 7x4x11 philosophy.

**When This Wins:**
- Target list is well-defined and small enough for personalized touches (100-500 accounts)
- Multiple channels are available (email, LinkedIn, phone, events, content, WhatsApp)
- Deal size justifies the touch investment ($10K+ ACV)
- Team has capacity for sustained cadence (10+ hours/week)

**When This Fails:**
- Target list is too broad (can't personalize at scale)
- Only one channel available (email-only is not 7x4x11)
- Low ACV doesn't justify the touch investment
- No sales capacity to handle conversations from multi-touch

**MENA Execution Intelligence:**
Events, webinars, and roundtables work very well in the Gulf because they simulate in-person trust. The 7x4x11 in MENA should emphasize: (1) WhatsApp as a primary touch channel, (2) Event invitations (breakfast meetings, roundtables, iftar dinners during Ramadan), (3) Physical gestures (Arabic books, quality gifts — still culturally powerful in Gulf business), (4) Arabic voice notes via WhatsApp (more personal than text).

**MENA Week-by-Week Execution:**
- Week 1: Identify target list of 100 accounts. Map 7 touch types (email, LinkedIn, WhatsApp, event invite, content share, voice note, physical gift).
- Week 2: Create content assets for each touch type. Arabic and English versions.
- Week 3: Begin cadence. 4 touches per account per week across different channels.
- Week 4: Track which touches generate replies. Double down on highest-response channels.

**Critical Weight Dependencies:** Q7-deal size (w=3), Q10-sales capacity (w=3), Q4-outbound tools (w=2), Q5-budget (w=2), Q6-network (w=2), Q11-event experience (w=2)

**72-Hour Launch Commitment:** Complete full 7x4x11 mapping and execute first week of touches (minimum 20 contacts across at least 3 channels).

---

### Motion 11: Value Trust Engine

**Default Fit:** 6 | **Base MENA:** 8 | **Weekly Hours:** 7

**What it is:** Build trust through a low-ticket entry product (course, workshop, template, audit) that delivers massive value. Buyers experience your expertise at low risk, then upgrade to high-ticket services/software.

**Best Fit For:**
- SaaS founders coming from consulting, training, or agency backgrounds
- Products where trust is the primary buying barrier (not price)
- Strategy paths: Consulting-First, Replicate & Localize
- ACV: $97-$497 entry to $2K-$50K upgrade
- Stage: 0-$500K (trust-building phase)

**Real Examples (from GTM Matrix):**
- **Alex Hormozi (Gym Launch)** — $6.7B net worth started with a free "Gym Turnaround" offer. Gym owners got results then trusted Hormozi then paid $42K for licensing. Value first, price second.
- **Russell Brunson** — $108/year DotComSecrets book to ClickFunnels $297/month to Inner Circle $25K/year. Each rung builds trust for the next.
- **Sam Ovens** — Free training to $997 course to $30K coaching. The free training IS the sales pitch because it genuinely helps.

**When This Wins:**
- Your expertise can be packaged into a standalone low-ticket product
- The low-ticket product delivers genuine results (not a teaser)
- Clear upgrade path from low-ticket to high-ticket
- You have proof assets (case studies, testimonials, metrics)

**When This Fails:**
- Low-ticket product is a watered-down version (no real value)
- No upgrade path (people buy the $97 thing and leave)
- Too much effort per low-ticket customer (economics don't work)
- No proof to build on (trust engine needs evidence)

**MENA Execution Intelligence:**
Works very well in MENA. Almost no one does this in the SaaS arena here. The "give value first" model aligns with Arabic business culture where generosity builds status. Consider: (1) Arabic workshops/courses as entry products, (2) WhatsApp community as trust-building environment, (3) Case studies from MENA companies, (4) Pricing in AED/SAR for regional trust.

**MENA Week-by-Week Execution:**
- Week 1: Create a low-ticket training ($47-$197) that solves ONE painful step for your ICP.
- Week 2: Build a 3-email nurture sequence (Arabic) from purchase to testimonial request to upgrade offer.
- Week 3: Add social proof to every touchpoint. Collect 3+ testimonials from early buyers.
- Week 4: Launch upgrade offer to low-ticket buyers. Personal WhatsApp outreach for high-ticket conversion.

**Critical Weight Dependencies:** Q11-event experience (w=3), Q0-email list (w=2), Q2-visibility (w=2)

**72-Hour Launch Commitment:** Create 1 case study or proof asset (documented, 500+ words); publish publicly.

---

### Motion 12: Paid VSL Value Ladder

**Default Fit:** 4 | **Base MENA:** 5 | **Weekly Hours:** 8

**What it is:** Run paid ads to a Video Sales Letter (VSL) that educates, builds desire, and drives to a CTA. The VSL does the selling; ads provide the traffic. Only works after message-market fit is proven.

**Best Fit For:**
- Offers with strong economics and proven conversion
- Products with clear ROI story (quantifiable transformation)
- Founders with $2K+/month ad budget
- Ideally deployed AFTER organic motions have validated messaging
- ACV: $500-$10K (economics must justify ad spend)

**Real Examples (from GTM Matrix):**
- **Russell Brunson** — Pioneered VSL-to-funnel model. $10M+ in ClickFunnels revenue driven through VSL ads on YouTube and Meta.
- **Sam Ovens** — YouTube VSL ads to free training to $997 course. The VSL pre-qualified and pre-sold.
- **Tai Lopez** — Controversial but effective. VSL ads on YouTube drove massive top-of-funnel. Conversion happened through the education sequence that followed.

**When This Wins:**
- Message-market fit is already proven (organic sales validate the pitch)
- VSL is genuinely educational and valuable (not just a pitch)
- Unit economics work (CAC < 1/3 of first-year ACV)
- Landing page and follow-up sequence are optimized

**When This Fails:**
- No message-market fit (throwing ad dollars at an unproven pitch)
- VSL is pure pitch without value (viewers drop off in 30 seconds)
- Unit economics are negative (spending more to acquire than you earn)
- No follow-up sequence (traffic comes, nobody converts)

**MENA Execution Intelligence:**
Paid traffic does not solve trust. It only buys attention. In high-trust markets like MENA, pair VSL with trust assets: (1) Arabic VSL with subtitles (not dubbed), (2) Include MENA-specific proof points, (3) WhatsApp CTA (not just email), (4) Retarget with educational content before hard sell, (5) Meta and YouTube are primary ad platforms in Gulf — LinkedIn ads for B2B.

**MENA Week-by-Week Execution:**
- Week 1: Script a 10-minute VSL (Arabic or English with Arabic subtitles). Focus on transformation, not features.
- Week 2: Set up landing page with video embed. Add WhatsApp CTA alongside email form.
- Week 3: Test with $50/day ad spend on Meta or YouTube. Arabic targeting for Gulf audiences.
- Week 4: Measure CPL and conversion. Kill if CPL > $50 for B2B or > $15 for B2C in MENA.

**Critical Weight Dependencies:** Q5-budget (w=3), Q3-demo ability (w=2), Q9-search demand (w=2)

**72-Hour Launch Commitment:** Record VSL script; set up sales page with CTA; launch to audience (email list or social).

---

## 7. EXPERT FRAMEWORK GATES

These are non-scoring diagnostic frameworks that add strategic context to the motion recommendations. They don't change scores but may reorder priorities, add prerequisites, or trigger interventions.

### Gate 1: Pattern of Inaction Early Check

**Trigger:** Founder has been working on idea >6 months AND has zero launches/products shipped to market.

**Detection signals during assessment:**
- High capability answers (Q1-Q6 averaging 3+) but no evidence of execution
- Answers include phrases like "still researching," "want to get it right," "building first"
- Expert archetype from SC4 with zero launched products

**Output (added to gtm-fitness.md):**

```
WARNING: PATTERN OF INACTION DETECTED

Your capability scores are strong, but your execution history shows zero GTM
motion activation in the past 90 days. This is the #1 failure mode for domain
experts entering entrepreneurship.

ROOT CAUSE: You're optimizing for CERTAINTY before action. In corporate, that's
rewarded. In entrepreneurship, it's fatal.

PRESCRIPTION — The 72-Hour Rule:
Your first GTM motion should be activated within 72 HOURS of completing this
assessment. Not 72 days. Not "after I finish building."

RECOMMENDED FIRST MOTION: [Lowest-friction motion from top 3]
```

**Impact:** Does NOT reduce scores. Adds a prerequisite gate. Prioritizes SPEED over comprehensiveness in motion sequencing.

### Gate 2: Content Systems Check (Matt Gray Framework)

**Applied when:** Any content-dependent motion (Authority Education, Build-in-Public, Wave Riding) scores as PRIMARY.

**Evaluation:**
| System Status | Implication | Action |
|---|---|---|
| System exists (batch creation, scheduling, repurposing) | Can sustain 2-3 content motions | Proceed |
| Ad-hoc creation | High burnout risk; 1 motion max | Add "Build 30-in-30 content batch" as pre-launch task |
| No system | Must build first | 1-week content system design before launching motion |

### Gate 3: Solo Founder Bandwidth Calculator

**Input:** Weekly hours available (from SC4 A3 or inferred from answers)

**Bandwidth Rules (Non-Negotiable):**
- **20+ hours/week:** PRIMARY + 1 SECONDARY = 2 motions max
- **10-19 hours/week:** PRIMARY only; sequence SECONDARY to week 5+
- **<10 hours/week:** Part-time GTM; recommend Consulting-First or Dream 100 (lower friction)

**Motion Load Model:**
| Motion Type | Weekly Hours Required |
|---|---|
| PRIMARY motion | ~10 hrs/week |
| SECONDARY motion | ~5 hrs/week |
| Tertiary (simultaneous) | NOT recommended |

### Gate 4: Pattern Interrupt Readiness (Brendan Kane Framework)

**Applied to:** Authority Education, Build-in-Public, Wave Riding when scored as PRIMARY or SECONDARY.

**Brendan Kane's 5 Hook Point Formulas:**
1. Contrarian Take — Challenges conventional wisdom
2. Data Disruption — Surprising stats or findings
3. Behind-the-Curtain — Insider perspective
4. Challenge/Dare — Actionable challenge
5. Story Hook — Personal narrative that builds curiosity

**Evaluation:**
- **Green Flag (Readiness up):** Founder's planned content includes hook structures = proceed
- **Red Flag (Readiness down):** Content is generic/educational with no hooks = recommend 2-hour Pattern Interrupt training before activation, or delay 1 week for content reframing

### Gate 5: Engagement Audit (Nir Eyal Hook Model)

**Applied to:** Top 3 recommended motions before final ranking.

**Hook Model Components per Motion:**
1. **Trigger** — What brings customers back?
2. **Action** — What's the minimal next step?
3. **Reward** — What's the variable payoff?
4. **Investment** — What deepens engagement over time?

**Scoring:**
- 3-4/4 components: STRONG LOOP = boost priority
- 0-2/4 components: WEAK LOOP = lower priority; recommend adding engagement hooks

---

## 8. UPSTREAM DATA TO MOTION FIT MAPPING

This section defines how upstream scorecard data translates into motion fit adjustments. This is the intelligence layer that makes SC5 more than a standalone questionnaire.

### SC1 (Project Definition) to Motion Fit

| SC1 Signal | Motion Impact |
|---|---|
| Niche = 3-level defined | Boost: Signal Sniper (+1), BOFU SEO (+1) — narrow niche enables precise targeting |
| Positioning = category creator | Boost: Authority Education (+2), Build-in-Public (+1) — category creators need education-led GTM |
| Geography = MENA-first | Boost: Dream 100 (+1), Waitlist (+1), Value Trust (+1) — MENA-native motions |
| Geography = US/Global | Boost: BOFU SEO (+1), Paid VSL (+1), Build-in-Public (+1) — Western-native motions |
| ACV > $10K | Boost: 7x4x11 (+2), Dream 100 (+1), Signal Sniper (+1) — high-touch justified |
| ACV < $500 | Boost: LTD (+2), Build-in-Public (+1), BOFU SEO (+1) — self-serve motions |

### SC2 (ICP Clarity) to Motion Fit

| SC2 Signal | Motion Impact |
|---|---|
| ICP congregates on LinkedIn | Boost: Signal Sniper (+1), Build-in-Public (+1), Authority Education (+1) |
| ICP congregates at events | Boost: 7x4x11 (+1), Waitlist Heat (+1), Value Trust (+1) |
| ICP buying behavior = research-heavy | Boost: Authority Education (+2), BOFU SEO (+1) |
| ICP buying behavior = relationship-driven | Boost: Dream 100 (+2), 7x4x11 (+1) |
| ICP budget = low (<$1K) | Boost: LTD (+1), Build-in-Public (+1); Penalize: Paid VSL (-1) |
| ICP budget = high (>$10K) | Boost: 7x4x11 (+1), Signal Sniper (+1), Dream 100 (+1) |

### SC3 (Market Attractiveness) to Motion Viability

| SC3 Signal | Motion Impact |
|---|---|
| Pain reality = urgent | Boost: Signal Sniper (+1), Outcome Demo (+1) — urgency enables outbound |
| Pain reality = latent | Boost: Authority Education (+1) — need to educate market |
| Market growth = expanding | Boost: Wave Riding (+1), BOFU SEO (+1) — riding growth wave |
| Competition = high | Boost: Hammering-Feature (+1), BOFU SEO (+1) — differentiation motions |
| Competition = low | Boost: Authority Education (+1), Build-in-Public (+1) — category creation |
| Purchasing power = strong | Boost: Paid VSL (+1), 7x4x11 (+1) — budget for premium motions |

### SC4 (Strategy Selector) to Motion Selection

| SC4 Path | PRIMARY Motions | SECONDARY Motions | CONDITIONAL |
|---|---|---|---|
| **Replicate & Localize** | Authority Education, Value Trust, Dream 100 | Waitlist Heat, Outcome Demo | Signal Sniper, BOFU SEO |
| **Consulting-First SaaS** | Authority Education, Dream 100, 7x4x11 | Signal Sniper, Outcome Demo, Value Trust | Waitlist Heat |
| **Boring Micro-SaaS** | Build-in-Public, BOFU SEO, LTD | Hammering-Feature, Waitlist Heat, Outcome Demo | Wave Riding |
| **Hammering Deep** | Signal Sniper, Hammering-Feature, BOFU SEO | Build-in-Public, Outcome Demo | Wave Riding |

| SC4 Archetype | Motion Affinity |
|---|---|
| The Domain Expert | Authority Education (high), Dream 100 (high) |
| The Connector | Dream 100 (high), 7x4x11 (high), Waitlist Heat (medium) |
| The Builder | Hammering-Feature (high), Build-in-Public (high), BOFU SEO (medium) |
| The Operator | Signal Sniper (high), 7x4x11 (high), Outcome Demo (medium) |

---

## 9. OUTPUT FILE: gtm-fitness.md

**Automatically generated with all sections populated:**

```markdown
# GTM Fitness Assessment — [Venture Name]
**Date:** [Date] | **Score:** [X]/100 | **Band:** [Band]

## Overall Assessment
[1-paragraph summary: What the score means, key strengths, primary gaps]

## All 13 Motions Ranked
| Rank | Motion | Fit | Readiness | MENA | Composite | Tier |
|------|--------|-----|-----------|------|-----------|------|
| 1 | [Name] | X.X | X.X | X.X | X.X | PRIMARY |
| ... | ... | ... | ... | ... | ... | ... |

## PRIMARY Motions (Deploy Now)
### [Motion Name] — Composite: X.X
- **Why it fits:** [Specific reasoning from upstream data + answer analysis]
- **30-Day Activation Plan:** [Week-by-week from MENA Execution Guide]
- **Required Infrastructure:** [What founder needs to set up]
- **Expected Output:** [Measurable outcomes in 30 days]

## SECONDARY Motions (Build Capacity)
[Same structure, shorter detail]

## CONDITIONAL Motions (Fix Gaps First)
[Gap identification + fix timeline]

## Motions to SKIP
[Brief reason per skipped motion]

## 72-HOUR LAUNCH COMMITMENT
**Primary Motion:** [Name]
**Your Commitment:** [Specific action from 72-hour table]
**Deadline:** [Date + 72 hours]

## Capability Gap Analysis
| Gap | Impact | Fix | Timeline | Priority |
|-----|--------|-----|----------|----------|
| [Missing capability] | [How it limits] | [What to do] | [How long] | High/Med/Low |

## 90-Day Motion Sequence
- **Weeks 1-4:** [PRIMARY motion activation]
- **Weeks 5-8:** [SECONDARY motion + PRIMARY optimization]
- **Weeks 9-12:** [Scale or pivot based on data]

## MENA Execution Adaptations
[Specific regional adjustments for top 3 motions]

## Re-Assessment Triggers
- Re-score after 30 days of PRIMARY motion execution
- Re-score if strategy path changes
- Re-score if new capabilities are built
```

---

## 10. CLAUDE EXECUTION FLOW

When running this scorecard conversationally (outside the HTML):

1. **Load Upstream Data (2 min):** Confirm SC1-SC4 are complete; load scores and key outputs
2. **Run Pattern of Inaction Check (1 min):** Validate execution history
3. **Ask 13 MC Questions (10 min):** Present each question with context; record answers
4. **Compute Scores (auto):** Apply weight matrix, upstream bonuses, strategy path bonuses, MENA multiplier
5. **Rank All 13 Motions (auto):** Sort by composite score; assign tiers
6. **Apply Expert Gates (5 min):** Content Systems Check, Bandwidth Calculator, Pattern Interrupt Readiness, Engagement Audit
7. **Generate Motion Intelligence (5 min):** For top 3 motions, pull GTM Matrix intelligence (examples, win/fail, MENA execution guide)
8. **Assign 72-Hour Commitment (2 min):** Tied to PRIMARY motion
9. **Generate Output File (3 min):** Complete gtm-fitness.md
10. **Present Results (5 min):** Show primary motions, 90-day plan, capability gaps

**Total Time:** 30-35 minutes (shorter than v2.0 because MC-only removes free-text wait time)

---

## 11. CROSS-REFERENCE: HTML SCORING vs. SKILL SCORING

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

## 12. MOTION DEFAULT PARAMETERS (QUICK REFERENCE)

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
| 10 | 7x4x11 Strategy | 5 | 7 | 10 |
| 11 | Value Trust Engine | 6 | 8 | 7 |
| 12 | Paid VSL Value Ladder | 4 | 5 | 8 |

---

**END OF SKILL v3.0**
