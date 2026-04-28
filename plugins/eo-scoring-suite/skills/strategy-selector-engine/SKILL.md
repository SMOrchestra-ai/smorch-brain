<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: strategy-selector-engine
description: Scorecard 4 of 5 — Maps founders to one of 4 strategy paths and 8 archetypes based on founder DNA, market conditions, and resource profile. Scores /100.
version: "2.0"
---

# SKILL: Strategy Selector Engine

**Version:** 2.0
**Created:** 2026-03-06
**Input Sources:** SC1 (Project Definition) + SC2 (ICP Clarity) + SC3 (Market Attractiveness)
**Output File:** `strategy-recommendation.md`
**Execution Model:** AI-driven strategic recommendation based on upstream data

---

## 1. STRATEGIC PURPOSE

Strategy Selector synthesizes data from Scorecards 1-3 to recommend the optimal strategy path for the next 90 days. It answers: "Given my market, my ICP, my positioning, and my resources—what is the BEST way to validate and grow?"

**Philosophy:** No one-size-fits-all strategy. The right strategy depends on market conditions, founder resources, and ICP fit.

**Four Strategy Paths:**
1. **Replicate & Localize:** Take proven global product; adapt for specific MENA market/ICP
2. **Consulting-First SaaS:** Sell consulting/services first; transition to productized SaaS
3. **Boring Micro-SaaS:** Build minimal product; charge money immediately; optimize for unit economics
4. **Hammering Deep:** Go vertical/deep in one niche; own it completely before expanding

---

## 2. PREREQUISITES

This scorecard requires completed data from Scorecards 1-3:
- **SC1 (Project Definition):** Niche, positioning, geography, product scope
- **SC2 (ICP Clarity):** ICP profile, pain statements, congregation points, budget range, buying behavior
- **SC3 (Market Attractiveness):** Pain intensity, purchasing power, accessibility, growth signals

**Pre-Admin Checklist:**
- Verify all three upstream scorecards are complete
- Load all data into recommendation engine
- If any scorecard <40 (RESET band), warn founder: "Upstream assessment shows significant gaps. Recommendation may suggest revisiting that scorecard."

---

## 3. SECTION ARCHITECTURE

| Section | Points | Focus | Scoring Model |
|---------|--------|-------|---|
| **A. Founder-Strategy Alignment** | 20 | Skills, capital, time, risk tolerance | MC (deterministic) |
| **B. Market-Strategy Fit** | 25 | MAS data + strategy path match | 4 AI-auto questions + 1 FT |
| **C. ICP-Strategy Fit** | 25 | ICP behavior + strategy path alignment | 4 AI-auto questions + 1 FT |
| **D. Execution Readiness** | 20 | Can founder execute recommended path | 4 path-specific MC questions |
| **E. MENA Strategy Fit** | 10 | Geographic/cultural alignment | 2 AI-auto questions |
| **TOTAL** | **100** | | |

**Output:** Recommended primary path + secondary path + 90-day roadmap + archetype classification

---

## 4. SECTION A: FOUNDER-STRATEGY ALIGNMENT (20 POINTS)

**Goal:** Understand founder's starting position and constraints.

### EXPERT FRAMEWORK ADDITION: EARLY PATTERN OF INACTION CHECK

**Purpose:** Detect potential "Pattern of Inaction" early in SC4, before strategy recommendation. Pattern of Inaction is typically detected in SC5, but early detection allows intervention at strategy-selection phase.

**Activation Criteria (Check Before Proceeding to A1):**

Ask: Does the founder show EITHER of these signals?

1. **"Has the founder been thinking about this idea for >6 months without launching?"**
   - Extract from SC1: "When did you first start working on this idea?" and "What have you shipped/launched so far?"
   - If: Idea >6 months old AND no customer-facing launch (landing page, MVP, consulting client, first sale) → Red flag

2. **"Has the founder completed SC1-SC3 with high scores but zero customer validation?"**
   - Extract scores: SC1 (Project Definition), SC2 (ICP Clarity), SC3 (Market Attractiveness)
   - If: All three >70 pts AND founder reports zero customer conversations, zero customer commitments, zero revenue → Red flag

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

### A1. Core Skill (5 pts)
**Type:** Multiple Choice
**Question:** What's your strongest skill set?

**Options (Deterministic Scoring):**
- Technical (can build) (5 pts) → Favors: Hammering Deep, Boring Micro-SaaS
- Sales (can close) (5 pts) → Favors: Consulting-First SaaS, Replicate & Localize
- Content (can teach/write) (4 pts) → Favors: Authority-driven paths (Consulting-First, Hammering Deep)
- Operations (can systematize) (5 pts) → Favors: Replicate & Localize, Boring Micro-SaaS
- Relationships (deep network) (5 pts) → Favors: Consulting-First SaaS, Replicate & Localize

**Scoring:** Award points directly per option. Multiple answers allowed; score highest.

**AI Processing:** Store selection for strategy path weighting (Section B).

### EXPERT FRAMEWORK ADDITION: ATTRACTIVE CHARACTER MAPPING

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

### A2. Available Capital (5 pts)
**Type:** Multiple Choice
**Question:** How much can you invest in the next 90 days?

**Options:**
- $0 (time only) (5 pts) → Favors: Consulting-First SaaS, Micro-SaaS (no build cost)
- $500-2K (5 pts) → Favors: Micro-SaaS (lean build)
- $2K-10K (5 pts) → Favors: Hammering Deep (dedicated build time)
- $10K-50K (4 pts) → Favors: Replicate & Localize (localiz​ation costs), Consulting-First (service delivery)
- $50K+ (3 pts) → Favors: Replicate & Localize (all paths viable)

**Note:** Paradox in scoring: $0 and $50K+ both score high because: $0 forces lean/service-based paths (high creativity); $50K enables any path (all viable).

---

### A3. Time Commitment (5 pts)
**Type:** Multiple Choice
**Question:** How much time weekly?

**Options:**
- <10 hrs/week (side project) (5 pts) → Favors: Micro-SaaS (lean), Consulting-First (project-based)
- 10-20 hrs/week (serious side) (5 pts) → Favors: Boring Micro-SaaS, Hammering Deep (part-time founder)
- 20-40 hrs/week (part-time founder) (4 pts) → Favors: Hammering Deep, Consulting-First SaaS
- 40+ hrs/week (full-time) (5 pts) → Favors: All paths viable

**Note:** All bands score well if matched correctly. <10 hrs requires different path than 40+ hrs.

---

### A4. Risk Tolerance (5 pts)
**Type:** Multiple Choice
**Question:** What's your risk profile?

**Options:**
- Conservative (revenue in 30 days) (5 pts) → Favors: Consulting-First SaaS, Micro-SaaS (fastest revenue)
- Moderate (90 days to revenue) (5 pts) → Favors: Boring Micro-SaaS, Hammering Deep (balanced)
- Aggressive (6+ months runway) (4 pts) → Favors: Replicate & Localize (longer build)
- Already have other income (5 pts) → Favors: Hammering Deep, Replicate & Localize (can wait longer)

**Scoring:** Award points per option. Finance the 4 options and their strategy affinity.

**Section A Total:** A1+A2+A3+A4 = 20 pts (all deterministic)

---

## 5. SECTION B: MARKET-STRATEGY FIT (25 POINTS)

**Goal:** Assess which strategy path aligns with market conditions from SC3 (Market Attractiveness).

### B1-B4: AI-Generated Questions (16 pts)

**System Behavior:**
1. **Pull MAS Data:** Extract section scores and findings from SC3
2. **Generate 4 Key Market Indicators:** Map to strategy path implications
3. **For Each Indicator:** Generate MC question (4 options); student selects best fit
4. **Score:** Each correct match = 4 pts (0-4 for each B1-B4)

**Example Questions (Auto-Generated from MAS Data):**

**B1. Pain Intensity vs. Market Maturity (4 pts)**
"Your MAS shows pain intensity of [X/25]. This suggests the market is:"
- Very early stage; buyers don't know the problem exists (1 pt) → Favors: Authority-driven, long sales cycle
- Emerging; buyers know the pain but limited solutions exist (3 pts) → Favors: Hammering Deep, Consulting-First
- Mature; multiple solutions exist; buyers are deciding between options (2 pts) → Favors: Replicate & Localize, Micro-SaaS (price competition)
- Saturated; many competitors; price-driven (1 pt) → Favors: Niche Hammering Deep

**B2. Purchasing Power Assessment (4 pts)**
"Your MAS shows budget authority/pricing as [X/25]. This suggests:"
- Simple decision (user/manager approval; fast cycle) (4 pts) → All paths viable; favors Micro-SaaS (simplicity)
- Complex decision (committee/C-suite; slow cycle) (2 pts) → Favors: Replicate & Localize, Consulting-First (relationship-based)
- Budget-constrained (low willingness to pay) (1 pt) → Favors: Micro-SaaS (low price), Consulting-First (value-based)
- High purchasing power (premium pricing viable) (3 pts) → Favors: Replicate & Localize (assumes premium positioning)

**B3. ICP Accessibility Assessment (4 pts)**
"Your MAS shows accessibility as [X/25]. Reach capability suggests:"
- High density; easy reach (own congregation points) (4 pts) → Favors: Boring Micro-SaaS, Hammering Deep (fast customer acquisition)
- Medium density; reachable but requires marketing (3 pts) → Favors: Consulting-First SaaS, Hammering Deep
- Low density; hard to reach; fragmented (2 pts) → Favors: Replicate & Localize (partnership-based reach), Consulting-First (referral-based)
- Very low density; custom reach required per customer (1 pt) → Favors: Consulting-First SaaS (service model), not Micro-SaaS

**B4. Market Growth & Momentum (4 pts)**
"Your MAS shows market direction as [growing/stable/declining]. This suggests:"
- Rapidly growing market; tailwinds present (4 pts) → Favors: Micro-SaaS (ride the wave), Hammering Deep (own the wave)
- Stable/slow growth; limited tailwinds (3 pts) → Favors: Consulting-First SaaS (sustainable revenue), Replicate & Localize (proven demand)
- Declining; few tailwinds; competitive pressure (1 pt) → Favors: Micro-SaaS (lean, rapid pivot), Consulting-First (recurring revenue)
- Unknown/unclear market direction (0 pts) → Flag for more MAS validation

**AI Evaluation Process:**
1. Extract MAS section scores
2. Map each score to market condition category (early, emerging, mature, saturated)
3. Generate 4 MC questions pulling actual data (e.g., "Your pain score is 18/25, which means...")
4. Student selects best-fit answer
5. Score: 4 pts if answer aligns with market data; 3 pts if reasonable but less optimal; 0-2 pts if misaligned

---

### B5. Strategy Path Hypothesis (9 pts)

**Type:** Free-text, 100-word limit
**Question:** Based on your market, which of the 4 strategy paths feels most natural? Why?

**Paths (Reference):**
1. **Replicate & Localize:** Take proven global product; adapt for [geography]/[ICP]
2. **Consulting-First SaaS:** Sell consulting first; productize later
3. **Boring Micro-SaaS:** Build lean product; charge from day 1; optimize unit economics
4. **Hammering Deep:** Go vertical in one niche; own it before expanding

**Display Example:** "I think Consulting-First SaaS is best because: (1) My ICP is in Egypt where business relationships are critical; consulting build trust first. (2) Market is emerging (competitors aware but not many); early adopters willing to pay for guidance. (3) I have sales skills but not technical skills. (4) Conservative risk tolerance; need revenue in 90 days; consulting is fastest path."

**AI Scoring Rubric (0-9 pts):**

| Score | Criteria |
|-------|----------|
| 0-2 | No hypothesis or completely misaligned with upstream data (MAS, ICP, Founder profile) |
| 3-4 | Names a path but reasoning is weak or misaligned with data |
| 5-6 | Names a path with reasonable reasoning; some alignment with data; minor gaps |
| 7-8 | Strong reasoning; clear alignment with MAS, ICP, and founder profile from Sections A-B1-B4 |
| 9 | Expert hypothesis; reasoning demonstrates deep understanding of strategy-market fit; could defend in investor pitch |

**Evaluation Process:**
1. Extract student's selected path (name it explicitly: Replicate / Consulting / Micro / Hammering)
2. Extract reasoning (3-5 points they mention)
3. Cross-check against Section A (founder skills, capital, time, risk) → Do they align?
4. Cross-check against B1-B4 (market data) → Do they align?
5. Cross-check against SC2 (ICP) → Does chosen path match ICP buying behavior?
6. Award points:
   - Path Clarity: 3 pts (did they name a path clearly?)
   - Reasoning Quality: 3 pts (is reasoning sound?)
   - Data Alignment: 3 pts (does reasoning match upstream data?)

**Improvement Recommendation (if <7):**
- Score 0-3: "You haven't clearly chosen a path or your reasoning doesn't match your data. Review your MAS and ICP scores. Which path aligns best with: your strongest skill (Section A), your market conditions (B1-B4), and your ICP's buying behavior (C)?"
- Score 4-6: "You have a path but reasoning is incomplete. Strengthen by: Explicitly stating why this path vs. the other 3. Reference specific data (MAS score, ICP behavior, market condition)."
- Score 7-8: "Strong reasoning. Final check: Would this path work given your founder constraints (A1-A4)? If not, reconsider."

**Section B Total:** B1+B2+B3+B4+B5 = 0-25 pts

### EXPERT FRAMEWORK ADDITION: CONTENT-TO-PAID PIPELINE PER PATH

**Purpose:** Map Alex Hormozi's 4-phase content-to-paid pipeline to each strategy path, showing how each path monetizes differently across 12 months.

**4-Phase Pipeline Structure (12-Month Horizon):**

| Phase | Timeline | Focus | Objective |
|---|---|---|---|
| **Phase 1** | Months 1-3 | Free Education | Build trust & authority; demonstrate expertise without asking for payment |
| **Phase 2** | Months 4-6 | Lead Magnets | Capture intent; identify warm leads ready to transact |
| **Phase 3** | Months 7-9 | Paid Training/Product | Monetize; move leads to first transaction (consulting project, SaaS subscription, course) |
| **Phase 4** | Months 10-12 | Premium/Retainer | Scale; move transacted customers to high-value recurring revenue (retainer, premium tier, managed service) |

**Path-Specific Implementation:**

**REPLICATE & LOCALIZE (4-Phase Adaptation)**
- Phase 1 (Months 1-3): Free content about global product + local adaptation trends → Blog, LinkedIn, webinars
- Phase 2 (Months 4-6): Lead magnet = free localization audit or feasibility assessment → Capture leads interested in the product
- Phase 3 (Months 7-9): Paid = SaaS subscription at localized pricing (e.g., $200-500/month vs. global $1000+) → First 10-20 customers
- Phase 4 (Months 10-12): Premium = white-glove onboarding or dedicated support for enterprise customers → Expand ACV

**CONSULTING-FIRST SAAS (4-Phase Adaptation)**
- Phase 1 (Months 1-3): Free education = thought leadership (LinkedIn, case studies, frameworks) showing your methodology → Build authority
- Phase 2 (Months 4-6): Lead magnet = free mini-audit, assessment, or workshop → Identify companies with acute pain
- Phase 3 (Months 7-9): Paid = consulting project ($5K-20K) or service engagement → Generate revenue + productization insights
- Phase 4 (Months 10-12): Premium = productized SaaS ($300-1000/month) or retainer consulting → Graduate best clients to software; land new clients at product level

**BORING MICRO-SAAS (4-Phase Adaptation)**
- Phase 1 (Months 1-3): Free education = "how-to" content, templates, checklists → Build awareness of problem + your solution existence
- Phase 2 (Months 4-6): Lead magnet = free tool, template, or short course → Capture early adopters' emails
- Phase 3 (Months 7-9): Paid = SaaS subscription ($29-99/month) → Monetize at low friction, high volume
- Phase 4 (Months 10-12): Premium = upsell to pro tier ($99-299/month) or add-on modules → Increase LTV; expand across product family

**HAMMERING DEEP (4-Phase Adaptation)**
- Phase 1 (Months 1-3): Free education = niche-specific content (deep-dive articles, niche community participation, podcast interviews) → Establish authority in vertical
- Phase 2 (Months 4-6): Lead magnet = niche-specific resource, assessment, or workshop → Build owned audience of niche members
- Phase 3 (Months 7-9): Paid = consulting project, niche-specific SaaS, or training course → Establish paid transaction with niche; deepen positioning
- Phase 4 (Months 10-12): Premium = retainer consulting, premium SaaS tier, or certification program → Become irreplaceable expert; highest ACV in niche

**AI Processing Note:** Track which phase the founder is executing in; recommend next-phase actions based on timeline and current progress. Update monthly in GTM Fitness (SC5).

---

## 6. SECTION C: ICP-STRATEGY FIT (25 POINTS)

**Goal:** Assess which strategy path aligns with ICP behavior from SC2.

### C1-C4: AI-Generated Questions (16 pts)

**System Behavior:** Similar to Section B. Pull ICP data; generate 4 alignment questions.

**Example Questions (Auto-Generated from ICP Data):**

**C1. Buying Behavior & Decision Complexity (4 pts)**
"Your ICP profile shows [X] buying behavior. This suggests:"
- Individual decision-maker (1 person); fast buying cycle (4 pts) → Favors: Micro-SaaS, Boring SaaS (quick close)
- Small team decision (2-3 people); moderate cycle (3 pts) → Favors: Consulting-First (relationship-heavy)
- Committee/complex decision (4+ approvers; slow cycle) (2 pts) → Favors: Replicate & Localize (trust-based), Consulting-First (long relationship)
- Highly political/complex (1 pt) → Favors: Consulting-First SaaS, Hammering Deep (need advocates)

**C2. Pain Urgency & Purchase Timeline (4 pts)**
"Your ICP shows pain urgency of [X]. This suggests:"
- Extreme urgency (solve within 1 week) (4 pts) → Favors: Micro-SaaS (instant solution), Boring SaaS
- High urgency (solve within 1 month) (3 pts) → Favors: Boring Micro-SaaS, Consulting-First (30-day implementation)
- Moderate urgency (solve within 3 months) (2 pts) → Favors: Replicate & Localize, Consulting-First SaaS
- Low/aspirational urgency (timeline flexible) (1 pt) → Favors: Hammering Deep (long-term positioning)

**C3. Budget Level & Payment Willingness (4 pts)**
"Your ICP shows budget authority of [X] and payment willingness of [X]. This suggests:"
- Low budget; looking for cheap solution (1 pt) → Favors: Micro-SaaS (low price), Consulting-First (project-based, not subscription)
- Mid-range budget; ROI-focused (4 pts) → Favors: All paths viable; match to other factors
- High budget; willing to invest; relationship-driven (3 pts) → Favors: Replicate & Localize (premium), Consulting-First SaaS (white-glove)
- Varies by buyer; mixed willingness (2 pts) → Favors: Boring Micro-SaaS (multiple tiers), Hammering Deep (own the niche)

**C4. Accessibility & Channel Strength (4 pts)**
"Your ICP shows congregation points of [X] and channel viability of [X]. This suggests:"
- High density; easy to reach via specific channels (4 pts) → Favors: Micro-SaaS, Boring SaaS (fast scaling via channels)
- Medium reach; requires marketing mix (3 pts) → Favors: Consulting-First SaaS, Hammering Deep (content + direct)
- Low reach; hard to reach at scale (2 pts) → Favors: Consulting-First SaaS (client-by-client), Replicate & Localize (partnership reach)
- Fragmented; no clear access pattern (1 pt) → Favors: Consulting-First SaaS, Hammering Deep (build network over time)

---

### C5. ICP-Strategy Synthesis (9 pts)

**Type:** Free-text, 100-word limit
**Question:** Looking at your ICP's buying behavior, pain urgency, and budget—does your chosen strategy (from B5) still make sense? Or would you reconsider?

**Display Example:** "My ICP (finance managers at mid-market Saudi companies) show: Complex decision (finance team + CFO); 1-month urgency (ZATCA deadline); $150-500/month budget; reachable via LinkedIn + WhatsApp. My Consulting-First path still makes sense because: (1) Complex decisions require relationship building that consulting provides. (2) ZATCA urgency means they want expert guidance, not DIY SaaS. (3) Mid-market budget supports $200-300/month consulting model. (4) LinkedIn + WhatsApp are perfect channels for direct outreach."

**AI Scoring Rubric (0-9 pts):**

| Score | Criteria |
|-------|----------|
| 0-2 | Strategy contradicts ICP behavior; misaligned (e.g., chose Micro-SaaS for complex, low-tech ICP) |
| 3-4 | Strategy is reasonable but has some tension with ICP behavior (e.g., Micro-SaaS for complex decision) |
| 5-6 | Strategy aligns with most ICP factors; minor concerns |
| 7-8 | Strong alignment; strategy clearly matches ICP behavior; demonstrates understanding |
| 9 | Expert synthesis; explicitly addresses buying complexity, urgency, budget, and accessibility; could defend strategy to investors |

**Evaluation Process:**
1. Extract student's stated ICP characteristics (buying behavior, urgency, budget, accessibility)
2. Extract their strategy choice from B5
3. Cross-check alignment: Does strategy match buyer profile?
   - Consulting-First → needs complex buying process, high trust need, relationship-driven → Good fit
   - Micro-SaaS → needs simple buying, low implementation, self-service → Poor fit for complex buyers
   - Replicate & Localize → needs proven demand, relationship-based reach, trust needed → Good fit for some
   - Hammering Deep → needs niche-able problem, high specialization need → Good fit
4. Assess reasoning quality: Does student demonstrate understanding of strategy-ICP fit?
5. Award points: (Strategy Clarity × 2) + (ICP Understanding × 2) + (Alignment Reasoning × 5)

**Improvement Recommendation (if <7):**
- Score 0-3: "Your strategy contradicts your ICP profile. Review: If your ICP requires complex decision-making, Micro-SaaS won't work. If ICP is self-service oriented, Consulting-First is too expensive. Match strategy to buying behavior."
- Score 4-6: "Your strategy mostly works but has tension. Example: You chose [path] but your ICP shows [behavior]. How will you handle that tension?"
- Score 7-8: "Good alignment. Final validation: Ask 1-2 ICPs 'Does [strategy] match how you'd want to buy?' Validate with real feedback."

**Section C Total:** C1+C2+C3+C4+C5 = 0-25 pts

---

## 7. SECTION D: EXECUTION READINESS (20 POINTS)

**Goal:** Assess founder's ability to execute the recommended path.

**System Behavior:** Based on emerging primary path recommendation (B5 + C5), ask 4 path-specific execution readiness questions.

### D1-D4: Path-Specific Questions (20 pts, 5 pts each)

**System Logic:**
1. By end of B5, student has chosen a primary path: Replicate / Consulting / Micro / Hammering
2. System generates 4 MC questions specific to that path
3. Each question = 5 pts (deterministic scoring)

**Question Sets by Path:**

**If PRIMARY PATH = REPLICATE & LOCALIZE:**

D1. Global Product Source (5 pts)
"Which global product will you replicate?"
- Options: Named product (5), Researched but not named (3), Not yet identified (0)

D2. Localization Barriers (5 pts)
"What's your localization advantage?"
- Options: Cultural expertise (5), Language (5), Existing network (4), Unsure (0)

D3. Launch Timeline (5 pts)
"When can you launch localized version?"
- Options: <3 months (5), 3-6 months (4), 6-12 months (3), >1 year (1), Unknown (0)

D4. Market Entry Channel (5 pts)
"How will you reach first customers?"
- Options: Partnership with global vendor (5), Direct sales team (4), Community/network (5), Unsure (0)

---

**If PRIMARY PATH = CONSULTING-FIRST SAAS:**

D1. Service Definition (5 pts)
"What service will you sell first?"
- Options: Defined, priced, 3 pilots lined up (5), Defined, pricing rough (3), Vague idea (1), Not defined (0)

D2. Founder Capacity (5 pts)
"Can you personally deliver the service?"
- Options: Yes, for 20+ clients/month (5), Yes, for 5-10 clients/month (4), Need to hire help (2), Can't deliver (0)

D3. Productization Timeline (5 pts)
"When will you start building the SaaS product?"
- Options: Month 4-6 (consulting funded the build) (5), Year 2 (consulting stabilized) (4), Unknown (0), Won't productize (1)

D4. First Consulting Client (5 pts)
"Do you have a signed client for month 1?"
- Options: Yes, signed LOI (5), Verbal commitment (4), Warm lead (3), Cold outreach (1), None (0)

---

**If PRIMARY PATH = BORING MICRO-SAAS:**

D1. MVP Scope (5 pts)
"What is your MVP (minimal viable product)?"
- Options: 1-3 core features, definable in 2 weeks (5), Clear features but needs 4-6 weeks (4), Vague scope (1), Undefined (0)

D2. Technical Capability (5 pts)
"Can you build the MVP?"
- Options: Myself, in <4 weeks (5), With 1 co-founder/partner (5), Need to hire (3), Can't build (0)

D3. Launch Timeline (5 pts)
"When will you charge customers?"
- Options: <4 weeks (5), <8 weeks (4), <12 weeks (3), >12 weeks (0), Unknown (0)

D4. Acquisition Plan (5 pts)
"How will you get first 10 paying customers?"
- Options: Defined channel + 20 outreach attempts in pipeline (5), Rough plan (3), Untested channel (1), No plan (0)

---

**If PRIMARY PATH = HAMMERING DEEP:**

D1. Niche Definition (5 pts)
"How deep is your niche?"
- Options: Specific role + company size + geography (e.g., "Finance managers at 50-500 person companies in Saudi") (5), Specific role + geography (3), Broad role (1), Undefined (0)

D2. Deep Differentiation (5 pts)
"What's your unique advantage in this niche?"
- Options: Domain expertise + network (5), 1-2 specific advantages (4), Unclear (1), Generic (0)

D3. Niche Depth Timeline (5 pts)
"How long will you focus on this niche before expanding?"
- Options: 12+ months (5), 6-12 months (4), <6 months (2), Will expand immediately (0)

D4. Niche Proof (5 pts)
"Do you have proof this niche is winnable?"
- Options: Customers, advisors, or advocates in niche (5), Conversations with 5+ niche people (4), Research done (3), Assumption (0)

---

**Section D Total:** D1+D2+D3+D4 = 0-20 pts

---

## 8. SECTION E: MENA STRATEGY FIT (10 POINTS)

**Goal:** Assess geographic and cultural alignment with selected strategy.

### E1-E2: AI-Generated Questions (10 pts, 5 pts each)

**System Behavior:** Pull geography from SC1; generate 2 MENA-specific questions.

**Example Questions:**

**E1. Strategy & MENA Culture Alignment (5 pts)**
"Your strategy is [PATH] in [GEOGRAPHY]. This aligns with MENA culture because:"
- Options (Deterministic; system generates based on path + geography):
  - Replicate & Localize in UAE: High tech adoption, proven demand for SaaS → Strong fit (5)
  - Consulting-First in Egypt: Relationship-based business culture, trust important → Strong fit (5)
  - Micro-SaaS in Saudi: Growing SaaS adoption, price sensitivity moderate → Good fit (4)
  - Hammering Deep in Jordan: Opportunity to own vertical before competition arrives → Good fit (4)
  - etc.

**E2. Execution Feasibility in MENA (5 pts)**
"What's your biggest execution challenge in [GEOGRAPHY]?"
- Options:
  - None (confident) (5)
  - Payment infrastructure (BNPL, bank transfer setup) (3)
  - Hiring/team building (1)
  - Regulatory/compliance (1)
  - Language/localization (2)
  - [Other] (varies)

**Section E Total:** E1+E2 = 0-10 pts

---

## 9. OVERALL SCORE & STRATEGY RECOMMENDATION

**Formula:**
- Section A (Founder Alignment): 0-20 pts
- Section B (Market Fit): 0-25 pts
- Section C (ICP Fit): 0-25 pts
- Section D (Execution Readiness): 0-20 pts
- Section E (MENA Fit): 0-10 pts
- **TOTAL: 0-100 pts**

**Recommendation Readiness Score (Different from Section Total):**
```
Readiness = (MAS Score × 0.35) + (ICP Clarity Score × 0.35) + (GTM Potential × 0.30)
```
Where:
- MAS Score = SC3 total (0-100)
- ICP Clarity Score = SC2 total (0-100)
- GTM Potential = Section D + E (0-30, normalized to 0-100)

**Readiness Interpretation:**
| Readiness | Assessment | Meaning |
|-----------|-----------|---------|
| 80-100 | READY | Strong execution confidence; move to GTM immediately |
| 60-79 | CONFIDENT | Good foundation; execution readiness strong; minor gaps in market/ICP |
| 40-59 | CAUTIOUS | Some gaps; either market/ICP unclear OR execution readiness weak |
| 20-39 | UNCERTAIN | Significant gaps; validate before executing strategy |
| 0-19 | NOT READY | Major gaps; return to foundational scorecards before strategy execution |

---

## 10. STRATEGY PATH RECOMMENDATION ENGINE

**Primary Path Selection Logic:**

System evaluates student's B5 choice against data alignment:

1. **If B5 + C5 agree on path (strong alignment):**
   - Award primary path with confidence level
   - Secondary path = next-best fit
   - Trigger confidence threshold for execution

2. **If B5 ≠ C5 (misalignment):**
   - Surface contradiction to student
   - Recommend: "Your market analysis suggests [Path A] but your ICP analysis suggests [Path B]. Which takes priority? If [ICP attribute] is critical, use [Path B]."

3. **If either B5 or C5 = <5 pts (weak reasoning):**
   - Surface as concern
   - Recommend: "Your strategy choice isn't strongly grounded. Re-evaluate using [specific data]."

### Four Strategy Paths (Detailed)

**1. REPLICATE & LOCALIZE** (0-25 pt rubric)
- **Definition:** Global product exists; you adapt for [geography] or [ICP niche]
- **Best For:** Proven demand, limited local competition, founder has localization advantage
- **Execution Requirements:**
  - Identify & validate global product fit (5 pts)
  - Define localization (language, pricing, feature prioritization) (5 pts)
  - Secure rights/partnership with global vendor (5 pts)
  - Launch go-to-market in target geography (5 pts)
  - Scale to 20+ customers in 90 days (5 pts)
- **90-Day Roadmap:**
  - Month 1: Research global products; secure partnership; plan localization
  - Month 2: Customize product; build landing page; start sales conversations
  - Month 3: Launch; acquire 10-20 first customers; validate product-market fit
- **Risk Profile:** Medium (product proven; market proven; localization is unknown)

**2. CONSULTING-FIRST SAAS** (0-25 pt rubric)
- **Definition:** Sell consulting/services first; productize SaaS in parallel or post-revenue
- **Best For:** Complex ICP, high trust needed, founder has expertise/network, fast revenue needed
- **Execution Requirements:**
  - Define service offering (what problem + solution) (5 pts)
  - Price service ($X/month or $X/project) (5 pts)
  - Land first 3-5 clients (5 pts)
  - Deliver & gather productization insights (5 pts)
  - Plan SaaS build alongside consulting (5 pts)
- **90-Day Roadmap:**
  - Month 1: Define service; price it; outreach to 50 warm prospects
  - Month 2: Close 2-3 consulting clients; start service delivery
  - Month 3: Deliver results; gather feedback; plan SaaS roadmap
- **Risk Profile:** Low (fast revenue; repeatable service; proof of demand before SaaS investment)

**3. BORING MICRO-SAAS** (0-25 pt rubric)
- **Definition:** Build minimal product; charge from day 1; optimize unit economics
- **Best For:** Clear problem, simple solution, self-serve buyers, founder can build
- **Execution Requirements:**
  - Define MVP (3-5 core features) (5 pts)
  - Build & launch MVP (<8 weeks) (5 pts)
  - Acquire 10 first paying customers (<12 weeks) (5 pts)
  - Optimize unit economics (CAC, churn, LTV) (5 pts)
  - Scale repeatable acquisition channel (5 pts)
- **90-Day Roadmap:**
  - Month 1: Define MVP; start building
  - Month 2: Launch; acquire 5-10 first customers; iterate
  - Month 3: Optimize for profitability; test scaling on 1 channel
- **Risk Profile:** Medium-High (product-market fit unknown; fast pivot required if not working)

**4. HAMMERING DEEP** (0-25 pt rubric)
- **Definition:** Go vertical in one specific niche; dominate before expanding
- **Best For:** Defensible niche, founder has domain expertise, willing to move slowly
- **Execution Requirements:**
  - Define niche precisely (role + company size + geography + industry) (5 pts)
  - Build reputation in niche (content, community, relationships) (5 pts)
  - Acquire first customers in niche (5 pts)
  - Become known expert (authority + network) (5 pts)
  - Expand only after niche dominance proven (5 pts)
- **90-Day Roadmap:**
  - Month 1: Define niche; build reputation (content, community, networking)
  - Month 2: Acquire 3-5 niche customers; deepen relationships
  - Month 3: Cement niche position; plan expansion strategy
- **Risk Profile:** Medium (slower revenue; higher retention; defensible moat; long build)

---

## 11. ARCHETYPE CLASSIFICATION

**System Classifies Student Into 8 Archetypes (OPTIONAL)**

Based on strategy choice + founder profile:

1. **Launcher** (Ambitious + resources) → Replicate & Localize
2. **Market Hunter** (Sales-focused) → Consulting-First SaaS
3. **Channel Seeker** (Distribution advantage) → Boring Micro-SaaS
4. **Solution Seeker** (Product-focused) → Hammering Deep
5. **Expert Without a Stage** (Domain expertise; no platform) → Hammering Deep or Consulting
6. **Ghost** (Stealth; unknown) → Micro-SaaS
7. **Operator** (Operations-focused) → Replicate & Localize
8. **Scrambler** (Early-stage; figuring out) → Consulting-First SaaS (revenue fast)

### EXPERT FRAMEWORK ADDITION: FIRST EXPERIMENT DESIGN (BUILD-MEASURE-LEARN)

**Purpose:** For each strategy path, define the default 30-day validation experiment that tests core hypotheses before full execution. Follows Build-Measure-Learn model.

**Path-Specific 30-Day Experiments:**

**REPLICATE & LOCALIZE — Validate Local Pain Exists**

| Element | Specification |
|---|---|
| **Hypothesis** | "The #1 pain point from the global product is equally acute in [target geography/ICP]" |
| **MVP Test** | 10 customer interviews (15-min discovery calls) + 1 landing page testing localized messaging |
| **Build Activities** | Create landing page with localized value prop; set up calendar for interviews |
| **Measure Metrics** | Interview % who confirm pain is #1 priority (target: 8/10); landing page CTR to "learn more" (target: >5%) |
| **Success Criteria** | ≥7/10 interviews confirm pain; ≥20% express interest in solution |
| **Pivot Criteria** | <5/10 confirm pain OR <2% landing page interest → Pain may not be #1 locally; revisit SC2 or consider different niche |

**CONSULTING-FIRST SAAS — Validate Service Offering & Closability**

| Element | Specification |
|---|---|
| **Hypothesis** | "I can close 3 consulting clients in 30 days using warm network + LinkedIn with service offering of [description] at price $[X]" |
| **MVP Test** | 50 personalized outreach messages (LinkedIn + email) to warm network; 15-20 sales conversations; 3 target closes (LOI/contract) |
| **Build Activities** | Define service scope (5-page document); create one-pager with pricing; develop 10-call pitch script |
| **Measure Metrics** | Outreach-to-conversation rate (target: 30%+); conversation-to-close rate (target: 15%+); average deal size ($X) |
| **Success Criteria** | ≥3 signed LOIs or contracts; average deal size within 10% of target pricing |
| **Pivot Criteria** | <2 closes OR conversation-to-close <10% → Service offering may lack clarity or price point is misaligned; refine positioning and retry |

**BORING MICRO-SAAS — Validate Product-Market Fit at Speed**

| Element | Specification |
|---|---|
| **Hypothesis** | "I can launch a landing page + basic pricing, and get 5 pre-pays (customers willing to pay before product launch) in 14 days, demonstrating product-market fit" (Marc Lou / John Rush playbook) |
| **MVP Test** | Landing page + basic SaaS onboarding flow; email outreach to 100 warm contacts; 2 weeks of paid acquisition testing |
| **Build Activities** | Create landing page (value prop, pricing tiers, signup); minimal onboarding flow; prepare FAQ/support responses |
| **Measure Metrics** | Pre-pays acquired (target: 5); landing page conversion (target: 2-5%); CAC from paid channels (vs. organic) |
| **Success Criteria** | ≥5 customers willing to pre-pay for product; LTV estimate >3x CAC |
| **Pivot Criteria** | <3 pre-pays after 14 days → Kill the feature/niche; use learning from 100 conversations to identify adjacent micro-SaaS opportunity and retest |

**HAMMERING DEEP — Validate Niche Authority & Demand**

| Element | Specification |
|---|---|
| **Hypothesis** | "I can establish credibility and prove niche demand by publishing 10 authority pieces + measuring engagement, then closing 1 pilot customer" |
| **MVP Test** | 10 pieces of niche-specific content (LinkedIn posts, blog articles, forum answers); engagement tracking; 1 pilot customer on consulting/trial product |
| **Build Activities** | Content calendar for 10 pieces; participate in 5 niche communities; prepare case study template for first pilot |
| **Measure Metrics** | Content engagement (likes, shares, comments; target: avg 10+ engagement per piece); pilot customer value validation; positioning clarity in niche feedback |
| **Success Criteria** | ≥100 cumulative engagement across 10 pieces; 1 niche customer pilots offering; feedback confirms positioning resonates |
| **Pivot Criteria** | <50 cumulative engagement OR no pilot interest after 30 days → Niche may be too narrow or positioning unclear; widen niche or adjust messaging and retest |

**AI Processing:** At the end of strategy recommendation, Claude presents the 30-day experiment template aligned to the selected path. Founder executes for 30 days; results inform whether to proceed to full 90-day roadmap or revisit strategy.

**Measurement Cadence:** Check progress weekly; adjust outreach/content production based on early feedback (Days 7, 14, 21). Full pivot decision at Day 30.

---

### EXPERT WITHOUT A STAGE — Strategy Path Guidance (Activated by R1 Expert Signal)

**Primary Archetype for this training.** When founder is classified as "Expert Without a Stage," Claude provides enhanced strategy path guidance:

**Default Recommendation: Consulting-First SaaS**

**Why this path is the expert's natural fit:**
- They already HAVE the expertise — they don't need to build it
- Consulting generates revenue in 30 days (vs 6+ months for product-first)
- Consulting clients BECOME the product advisory board — they tell you exactly what to build
- The expert's corporate network provides warm leads for consulting (no cold outreach needed for first 3-5 clients)
- Consulting proof → SaaS credibility. "I've solved this for 10 companies manually" is the strongest possible positioning for a SaaS launch

### EXPERT FRAMEWORK ADDITION: PORTFOLIO VS. SINGLE PRODUCT

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
- Month 3: Product 1 generates $500/month (5 customers × $100 MRR)
- Month 6: Product 1 at $1500/month; Product 2 launches at $300/month → $1800 MRR total
- Month 9: Product 1 at $2500/month; Product 2 at $1000/month; Product 3 launches → $3500/month total
- By Month 12: 3 products × moderate ACV = $5000+/month with solo founder (vs. single product plateauing at $2500)

**When to OVERRIDE (recommend single-product focus instead):**
- If Product 1 is still <$1000/month MRR → Optimize before expanding; compounding only works if first product is stable
- If Hammering Deep niche is not yet "dominated" (founder is still building authority) → Depth first; breadth later
- If founder is explicitly anti-portfolio ("I want to go deep on ONE product") → Respect preference; note that portfolio approach compounds faster but requires systems/delegation

**AI Processing:** At end of 30-day experiment, if conditions (a), (b), (c) are met and Product 1 shows strong traction, Claude flags "Portfolio Opportunity Detected" and recommends assessment: "You've validated Product 1. You've identified adjacent pain in SC2 (condition b). Do you have the capacity to build Product 2 in parallel? If yes, we can sequence your 90-day roadmap to include Product 2 MVP launch alongside Product 1 optimization."

---

**Path-Specific Playbook for Expert Archetype:**

```
MONTH 1: Package Expertise as Service
- Define ONE service offering based on narrowed niche (from SC1)
- Price at $2K-5K/month or $5K-15K/project (NOT $500 — expert pricing)
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
- If founder has ZERO corporate network in target geography → Boring Micro-SaaS (need product-led growth)
- If founder's expertise is in a commodity space (no differentiation) → Hammering Deep (niche deeper first)
- If founder explicitly refuses services ("I only want to build product") → Boring Micro-SaaS, but flag: "Building without consulting first means you're guessing what the market wants. Consulting is the fastest validation path for your expertise level."

**Advisory note for Section D (Execution Readiness):**
When Expert archetype is detected, D1-D4 should use the **Consulting-First SaaS** question set by default. If founder chose a different path in B5, Claude should surface this: "Based on your profile — deep domain expertise, corporate background, strong network — the natural strategy path is Consulting-First SaaS. You selected [other path]. Let me ask: is there a specific reason you want to skip the consulting phase? Most experts who skip it end up spending 6 months building something the market doesn't want."

---

## 12. OUTPUT FILE: strategy-recommendation.md

**Automatically generated with all sections populated:**
- Strategy Selector Score (/100)
- Readiness Score (formula-based)
- Recommended Primary Path (+ reasoning)
- Secondary Path (+ trigger conditions for switching)
- Demand-First Quadrant (from BRD)
- Archetype Classification
- Top 5 Bottleneck Analysis (cross-pillar)
- 90-Day Strategic Roadmap (month-by-month)
- Re-Assessment Triggers

### EXPERT FRAMEWORK ADDITION: MOVEMENT BRIEF OUTPUT

**New Output Section:** Include a "Movement Brief" that articulates the founder's larger purpose and positioning narrative. This section feeds from the Conversational Advisor Framework's movement-brief.md deliverable.

**Movement Brief Prompts (to populate in output):**

| Question | Purpose | Example Output |
|---|---|---|
| **What cause does this founder champion?** | Identify the larger mission beyond the product | "Democratize financial compliance for MENA SMEs" or "Return autonomy to finance teams over-burdened by manual processes" |
| **What's the New Opportunity (vs. Improvement Offer)?** | Distinguish if founder is improving existing category or opening new market | New Opportunity: "MENA founders now can scale without hiring FP&A teams" vs. Improvement: "Faster ZATCA reporting than competitors" |
| **Who's the enemy?** | Identify the specific problem or system the founder opposes | "Manual spreadsheet workflows that consume 20 hours/week" or "Global SaaS vendors who don't understand MENA tax requirements" |
| **What future are they building?** | Vision for how the world changes if their product wins | "MENA companies compete globally without compliance overhead" or "Finance teams spend time on strategy, not data entry" |

**AI Processing:** Movement Brief is synthesized from:
1. Founder's stated purpose in SC1 (if available)
2. ICP pain + amplification from SC2
3. Market opportunity positioning from SC3
4. Strategy path selection + Attractive Character archetype (from SC4)

Store Movement Brief in `strategy-recommendation.md` as narrative framing for all downstream GTM activities (SC5).

---

---

## 13. CLAUDE EXECUTION FLOW

1. **Load Upstream Data (2 min):** SC1, SC2, SC3 complete
2. **Administer Sections A-E (25 min):** Questions in sequence
3. **Generate Strategy Recommendation (10 min):** Process all data; identify primary + secondary paths
4. **Create Output File (5 min):** strategy-recommendation.md with full analysis
5. **Present Recommendation (3 min):** Show primary path, readiness score, 90-day roadmap
6. **Next Steps (2 min):** Offer GTM Fitness (SC5) or refinement

**Total Time:** 45-50 minutes

---

## 14. NOTES FOR DEVELOPERS

- All Section A questions are deterministic MC (no interpretation)
- Sections B, C, E use AI auto-generation from upstream data
- Section D questions are path-specific (system determines path from B5)
- Output includes explicit "Why This Path" explanation for founder education
- Readiness Score formula can be adjusted based on weighting research

---

**END OF SKILL.MD**
