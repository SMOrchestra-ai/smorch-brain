# Archetypes Reference -- Strategy Selector Engine

This file contains detailed archetype descriptions, scoring criteria, and expert framework additions referenced by SKILL.md.

---

## EARLY PATTERN OF INACTION CHECK

**Purpose:** Detect potential "Pattern of Inaction" early in SC4, before strategy recommendation. Pattern of Inaction is typically detected in SC5, but early detection allows intervention at strategy-selection phase.

**Activation Criteria (Check Before Proceeding to A1):**

Ask: Does the founder show EITHER of these signals?

1. **"Has the founder been thinking about this idea for >6 months without launching?"**
   - Extract from SC1: "When did you first start working on this idea?" and "What have you shipped/launched so far?"
   - If: Idea >6 months old AND no customer-facing launch (landing page, MVP, consulting client, first sale) -> Red flag

2. **"Has the founder completed SC1-SC3 with high scores but zero customer validation?"**
   - Extract scores: SC1 (Project Definition), SC2 (ICP Clarity), SC3 (Market Attractiveness)
   - If: All three >70 pts AND founder reports zero customer conversations, zero customer commitments, zero revenue -> Red flag

**If Pattern of Inaction Detected:**

Trigger the **72-Hour Validation Sprint** before proceeding with full strategy recommendation:

| Action | Timeline | Objective |
|---|---|---|
| **Pause SC4** | Now | Don't recommend a strategy; founder needs to prove they can execute ANY strategy |
| **Activate 72-Hour Sprint** | Next 3 days | Founder completes 1 of 3 rapid validation tests (pick the easiest given their constraints) |
| **Validation Options** | Pick ONE | (1) 10 customer interviews confirming pain exists, OR (2) 1 paying consulting client, OR (3) 10 pre-signups to landing page |
| **Re-Enter SC4** | Day 4 | With proof of execution, founder completes strategy recommendation with higher confidence |
| **Messaging to Founder** | Clear & Direct | "Your analysis is strong. Now let's validate it with real people. Pick ONE test from above; do it in 72 hours. This proves you can execute. Then we'll recommend your strategy." |

**Rationale:** High scorecards + high inaction risk = founder may have analysis paralysis or perfectionism. Forcing a small 3-day sprint builds momentum, proves founder execution capacity, and provides real market data to inform strategy selection.

**AI Processing Note:** If Pattern of Inaction is detected, Claude does NOT proceed to A1-A4. Instead, Claude presents the 72-hour sprint challenge, pauses SC4 scoring, and reschedules SC4 completion for post-validation.

---

## ATTRACTIVE CHARACTER MAPPING

**Purpose:** Map each strategy path to recommended Attractive Character archetypes (Russell Brunson's 4 types) to guide brand voice and content positioning.

**Character-to-Path Mapping:**

| Strategy Path | Primary Archetype | Brand Voice | Narrative |
|---|---|---|---|
| **Replicate & Localize** | Reporter | "I discovered something working elsewhere; let me bring it here" | Credibility through proven model validation; you're introducing a tested solution to a new market |
| **Consulting-First SaaS** | Leader | "I've solved this at scale; follow my system" | Authority through results; you position as the expert who has worked with many clients and refined a process |
| **Boring Micro-SaaS** | Reluctant Hero | "I never wanted to build this, but the market needed it" | Humility through necessity; you're solving a real problem that frustrated you enough to act |
| **Hammering Deep** | Adventurer | "I'm going deeper than anyone; come with me" | Exploration through specialization; you're inviting others into a specialized domain where you're the guide |

**Expert Without a Stage Archetype Override:**
If founder is classified as "Expert Without a Stage" (deep domain expertise, no platform), the default positioning is **Leader or Reluctant Hero**, depending on founder's communication style:
- **Leader archetype if:** Founder leads with authority, has published work, or explicit credentials
- **Reluctant Hero if:** Founder leads with humility, problem-first framing, or reluctance ("I didn't plan to be the expert, but...")

**AI Processing:** Store character selection in upstream `brand-voice.md` for use in SC5 (GTM) and content strategy development.

---

## 8 FOUNDER ARCHETYPES -- DETAILED DESCRIPTIONS

### 1. Launcher
**Profile:** Ambitious + resources. Has capital, time, and drive. Wants to move fast.
**Default Path:** Replicate & Localize
**Why:** Resources enable localization investment; ambition drives fast market entry.

### 2. Market Hunter
**Profile:** Sales-focused. Strong closer, relationship builder, deal-maker.
**Default Path:** Consulting-First SaaS
**Why:** Sales skills monetize immediately through consulting; client relationships inform productization.

### 3. Channel Seeker
**Profile:** Distribution advantage. Has access to audience, platform, or channel.
**Default Path:** Boring Micro-SaaS
**Why:** Existing distribution reduces CAC; product-led growth leverages channel.

### 4. Solution Seeker
**Profile:** Product-focused. Wants to build the best solution in a specific space.
**Default Path:** Hammering Deep
**Why:** Product obsession drives depth; specialization creates defensible moat.

### 5. Expert Without a Stage
**Profile:** Domain expertise; no platform. Deep knowledge from corporate/industry experience but no personal brand, audience, or distribution.
**Default Path:** Hammering Deep or Consulting-First SaaS
**Why:** Expertise is the asset; needs a vehicle to monetize it. See detailed playbook below.

### 6. Ghost
**Profile:** Stealth; unknown. No public presence, no network in target market, starting from zero visibility.
**Default Path:** Micro-SaaS
**Why:** Product-led growth doesn't require personal brand; let the product speak.

### 7. Operator
**Profile:** Operations-focused. Strong at systematizing, process design, efficiency.
**Default Path:** Replicate & Localize
**Why:** Operations skill is the localization advantage; can operationalize proven models efficiently.

### 8. Scrambler
**Profile:** Early-stage; figuring out. No clear advantage yet; exploring options.
**Default Path:** Consulting-First SaaS (revenue fast)
**Why:** Consulting generates revenue while building clarity; client work reveals product opportunities.

---

## EXPERT WITHOUT A STAGE -- STRATEGY PATH GUIDANCE

**Primary Archetype for this training.** When founder is classified as "Expert Without a Stage," Claude provides enhanced strategy path guidance.

**Default Recommendation: Consulting-First SaaS**

**Why this path is the expert's natural fit:**
- They already HAVE the expertise -- they don't need to build it
- Consulting generates revenue in 30 days (vs 6+ months for product-first)
- Consulting clients BECOME the product advisory board -- they tell you exactly what to build
- The expert's corporate network provides warm leads for consulting (no cold outreach needed for first 3-5 clients)
- Consulting proof -> SaaS credibility. "I've solved this for 10 companies manually" is the strongest possible positioning for a SaaS launch

**Path-Specific Playbook for Expert Archetype:**

```
MONTH 1: Package Expertise as Service
- Define ONE service offering based on narrowed niche (from SC1)
- Price at $2K-5K/month or $5K-15K/project (NOT $500 -- expert pricing)
- Reach out to 20 warm contacts from corporate network
- Close 2-3 consulting clients
- Deliver manually (this IS the product research phase)

MONTH 2: Systematize & Document
- Document every workflow you repeat across clients
- Identify the 3-5 tasks that should be software, not manual
- Start building MVP of the repeatable workflow
- Continue consulting (revenue funds the build)

MONTH 3: Productize the Pattern
- Launch MVP to existing consulting clients as "beta" of the SaaS product
- Price SaaS at $200-500/month (consulting clients get lifetime discount)
- Use consulting case studies as proof for SaaS marketing
- Begin GTM motions from SC5 (with proof, credibility, and revenue already in hand)
```

**When to OVERRIDE the default (recommend different path):**
- If founder has ZERO corporate network in target geography -> Boring Micro-SaaS (need product-led growth)
- If founder's expertise is in a commodity space (no differentiation) -> Hammering Deep (niche deeper first)
- If founder explicitly refuses services ("I only want to build product") -> Boring Micro-SaaS, but flag: "Building without consulting first means you're guessing what the market wants. Consulting is the fastest validation path for your expertise level."

**Advisory note for Section D (Execution Readiness):**
When Expert archetype is detected, D1-D4 should use the **Consulting-First SaaS** question set by default. If founder chose a different path in B5, Claude should surface this: "Based on your profile -- deep domain expertise, corporate background, strong network -- the natural strategy path is Consulting-First SaaS. You selected [other path]. Let me ask: is there a specific reason you want to skip the consulting phase? Most experts who skip it end up spending 6 months building something the market doesn't want."

---

## PORTFOLIO VS. SINGLE PRODUCT FRAMEWORK

**Context:** John Rush and Marc Lou have both published frameworks for building portfolios of 20+ products as solopreneurs, with compounding revenue across multiple micro-SaaS products or ventures.

**Applicability by Strategy Path:**

For founders selected into **Boring Micro-SaaS** or **Hammering Deep** paths, Claude presents a secondary opportunity assessment:

**PORTFOLIO OPTION: Post-Validation Product Expansion**

After validating Product 1 through the 30-day experiment (and reaching initial traction), consider launching Product 2 in parallel IF all three conditions are met:

| Condition | Specification | Evaluation |
|---|---|---|
| **(a) Product 1 is self-serve with minimal maintenance** | Product 1 requires <2 hours/week of your active time (no service delivery, support is automated/community-driven, or outsourced) | Boring Micro-SaaS is ideal here; Hammering Deep requires more founder time initially |
| **(b) Adjacent ICP pain identified in SC2** | During SC2 ICP deep-dive, founder identified 2-3 adjacent pain points the same ICP suffers (not solved by Product 1) | Example: Product 1 solves invoicing; Product 2 opportunity is expense tracking for same ICP |
| **(c) Technical skill allows rapid shipping** | Founder can build MVP for Product 2 in <4 weeks using same tech stack/skills as Product 1 | Requires either founder technical skill or access to co-builder/contractor already on payroll |

**Portfolio Revenue Compounding Example:**
- Month 3: Product 1 generates $500/month (5 customers x $100 MRR)
- Month 6: Product 1 at $1500/month; Product 2 launches at $300/month -> $1800 MRR total
- Month 9: Product 1 at $2500/month; Product 2 at $1000/month; Product 3 launches -> $3500/month total
- By Month 12: 3 products x moderate ACV = $5000+/month with solo founder (vs. single product plateauing at $2500)

**When to OVERRIDE (recommend single-product focus instead):**
- If Product 1 is still <$1000/month MRR -> Optimize before expanding; compounding only works if first product is stable
- If Hammering Deep niche is not yet "dominated" (founder is still building authority) -> Depth first; breadth later
- If founder is explicitly anti-portfolio ("I want to go deep on ONE product") -> Respect preference; note that portfolio approach compounds faster but requires systems/delegation

**AI Processing:** At end of 30-day experiment, if conditions (a), (b), (c) are met and Product 1 shows strong traction, Claude flags "Portfolio Opportunity Detected" and recommends assessment: "You've validated Product 1. You've identified adjacent pain in SC2 (condition b). Do you have the capacity to build Product 2 in parallel? If yes, we can sequence your 90-day roadmap to include Product 2 MVP launch alongside Product 1 optimization."
