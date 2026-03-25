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

Strategy Selector synthesizes data from Scorecards 1-3 to recommend the optimal strategy path for the next 90 days. It answers: "Given my market, my ICP, my positioning, and my resources--what is the BEST way to validate and grow?"

**Philosophy:** No one-size-fits-all strategy. The right strategy depends on market conditions, founder resources, and ICP fit.

**Four Strategy Paths:**
1. **Replicate & Localize:** Take proven global product; adapt for specific MENA market/ICP
2. **Consulting-First SaaS:** Sell consulting/services first; transition to productized SaaS
3. **Boring Micro-SaaS:** Build minimal product; charge money immediately; optimize for unit economics
4. **Hammering Deep:** Go vertical/deep in one niche; own it completely before expanding

For detailed strategy path descriptions, execution requirements, 90-day roadmaps, content-to-paid pipelines, and 30-day validation experiments, see **strategy-paths.md**.

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

**Early Pattern of Inaction Check:** Before proceeding to A1, check for Pattern of Inaction signals. For detailed activation criteria and the 72-Hour Validation Sprint protocol, see **archetypes.md** (section: Early Pattern of Inaction Check).

### A1. Core Skill (5 pts)
**Type:** Multiple Choice
**Question:** What's your strongest skill set?

**Options (Deterministic Scoring):**
- Technical (can build) (5 pts) -- Favors: Hammering Deep, Boring Micro-SaaS
- Sales (can close) (5 pts) -- Favors: Consulting-First SaaS, Replicate & Localize
- Content (can teach/write) (4 pts) -- Favors: Authority-driven paths (Consulting-First, Hammering Deep)
- Operations (can systematize) (5 pts) -- Favors: Replicate & Localize, Boring Micro-SaaS
- Relationships (deep network) (5 pts) -- Favors: Consulting-First SaaS, Replicate & Localize

**Scoring:** Award points directly per option. Multiple answers allowed; score highest.
**AI Processing:** Store selection for strategy path weighting (Section B).

**Attractive Character Mapping:** After A1, map the founder's strategy path to an Attractive Character archetype (Russell Brunson's 4 types). For the full Character-to-Path mapping table and Expert Without a Stage override rules, see **archetypes.md** (section: Attractive Character Mapping).

---

### A2. Available Capital (5 pts)
**Type:** Multiple Choice
**Question:** How much can you invest in the next 90 days?

**Options:**
- $0 (time only) (5 pts) -- Favors: Consulting-First SaaS, Micro-SaaS (no build cost)
- $500-2K (5 pts) -- Favors: Micro-SaaS (lean build)
- $2K-10K (5 pts) -- Favors: Hammering Deep (dedicated build time)
- $10K-50K (4 pts) -- Favors: Replicate & Localize (localization costs), Consulting-First (service delivery)
- $50K+ (3 pts) -- Favors: Replicate & Localize (all paths viable)

**Note:** Paradox in scoring: $0 and $50K+ both score high because: $0 forces lean/service-based paths (high creativity); $50K enables any path (all viable).

---

### A3. Time Commitment (5 pts)
**Type:** Multiple Choice
**Question:** How much time weekly?

**Options:**
- <10 hrs/week (side project) (5 pts) -- Favors: Micro-SaaS (lean), Consulting-First (project-based)
- 10-20 hrs/week (serious side) (5 pts) -- Favors: Boring Micro-SaaS, Hammering Deep (part-time founder)
- 20-40 hrs/week (part-time founder) (4 pts) -- Favors: Hammering Deep, Consulting-First SaaS
- 40+ hrs/week (full-time) (5 pts) -- Favors: All paths viable

**Note:** All bands score well if matched correctly. <10 hrs requires different path than 40+ hrs.

---

### A4. Risk Tolerance (5 pts)
**Type:** Multiple Choice
**Question:** What's your risk profile?

**Options:**
- Conservative (revenue in 30 days) (5 pts) -- Favors: Consulting-First SaaS, Micro-SaaS (fastest revenue)
- Moderate (90 days to revenue) (5 pts) -- Favors: Boring Micro-SaaS, Hammering Deep (balanced)
- Aggressive (6+ months runway) (4 pts) -- Favors: Replicate & Localize (longer build)
- Already have other income (5 pts) -- Favors: Hammering Deep, Replicate & Localize (can wait longer)

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

**B1. Pain Intensity vs. Market Maturity (4 pts)**
"Your MAS shows pain intensity of [X/25]. This suggests the market is:"
- Very early stage; buyers don't know the problem exists (1 pt) -- Favors: Authority-driven, long sales cycle
- Emerging; buyers know the pain but limited solutions exist (3 pts) -- Favors: Hammering Deep, Consulting-First
- Mature; multiple solutions exist; buyers are deciding between options (2 pts) -- Favors: Replicate & Localize, Micro-SaaS (price competition)
- Saturated; many competitors; price-driven (1 pt) -- Favors: Niche Hammering Deep

**B2. Purchasing Power Assessment (4 pts)**
"Your MAS shows budget authority/pricing as [X/25]. This suggests:"
- Simple decision (user/manager approval; fast cycle) (4 pts) -- All paths viable; favors Micro-SaaS (simplicity)
- Complex decision (committee/C-suite; slow cycle) (2 pts) -- Favors: Replicate & Localize, Consulting-First (relationship-based)
- Budget-constrained (low willingness to pay) (1 pt) -- Favors: Micro-SaaS (low price), Consulting-First (value-based)
- High purchasing power (premium pricing viable) (3 pts) -- Favors: Replicate & Localize (assumes premium positioning)

**B3. ICP Accessibility Assessment (4 pts)**
"Your MAS shows accessibility as [X/25]. Reach capability suggests:"
- High density; easy reach (own congregation points) (4 pts) -- Favors: Boring Micro-SaaS, Hammering Deep (fast customer acquisition)
- Medium density; reachable but requires marketing (3 pts) -- Favors: Consulting-First SaaS, Hammering Deep
- Low density; hard to reach; fragmented (2 pts) -- Favors: Replicate & Localize (partnership-based reach), Consulting-First (referral-based)
- Very low density; custom reach required per customer (1 pt) -- Favors: Consulting-First SaaS (service model), not Micro-SaaS

**B4. Market Growth & Momentum (4 pts)**
"Your MAS shows market direction as [growing/stable/declining]. This suggests:"
- Rapidly growing market; tailwinds present (4 pts) -- Favors: Micro-SaaS (ride the wave), Hammering Deep (own the wave)
- Stable/slow growth; limited tailwinds (3 pts) -- Favors: Consulting-First SaaS (sustainable revenue), Replicate & Localize (proven demand)
- Declining; few tailwinds; competitive pressure (1 pt) -- Favors: Micro-SaaS (lean, rapid pivot), Consulting-First (recurring revenue)
- Unknown/unclear market direction (0 pts) -- Flag for more MAS validation

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

**AI Scoring Rubric (0-9 pts):**

| Score | Criteria |
|-------|----------|
| 0-2 | No hypothesis or completely misaligned with upstream data (MAS, ICP, Founder profile) |
| 3-4 | Names a path but reasoning is weak or misaligned with data |
| 5-6 | Names a path with reasonable reasoning; some alignment with data; minor gaps |
| 7-8 | Strong reasoning; clear alignment with MAS, ICP, and founder profile from Sections A-B1-B4 |
| 9 | Expert hypothesis; reasoning demonstrates deep understanding of strategy-market fit; could defend in investor pitch |

**Evaluation Process:**
1. Extract student's selected path
2. Extract reasoning (3-5 points they mention)
3. Cross-check against Section A (founder skills, capital, time, risk)
4. Cross-check against B1-B4 (market data)
5. Cross-check against SC2 (ICP)
6. Award points: Path Clarity (3 pts) + Reasoning Quality (3 pts) + Data Alignment (3 pts)

**Improvement Recommendation (if <7):**
- Score 0-3: "You haven't clearly chosen a path or your reasoning doesn't match your data. Review your MAS and ICP scores."
- Score 4-6: "You have a path but reasoning is incomplete. Strengthen by explicitly stating why this path vs. the other 3."
- Score 7-8: "Strong reasoning. Final check: Would this path work given your founder constraints (A1-A4)?"

**Section B Total:** B1+B2+B3+B4+B5 = 0-25 pts

For the Content-to-Paid Pipeline mapping per strategy path, see **strategy-paths.md** (section: Content-to-Paid Pipeline).

---

## 6. SECTION C: ICP-STRATEGY FIT (25 POINTS)

**Goal:** Assess which strategy path aligns with ICP behavior from SC2.

### C1-C4: AI-Generated Questions (16 pts)

**System Behavior:** Similar to Section B. Pull ICP data; generate 4 alignment questions.

**C1. Buying Behavior & Decision Complexity (4 pts)**
"Your ICP profile shows [X] buying behavior. This suggests:"
- Individual decision-maker (1 person); fast buying cycle (4 pts) -- Favors: Micro-SaaS, Boring SaaS (quick close)
- Small team decision (2-3 people); moderate cycle (3 pts) -- Favors: Consulting-First (relationship-heavy)
- Committee/complex decision (4+ approvers; slow cycle) (2 pts) -- Favors: Replicate & Localize (trust-based), Consulting-First (long relationship)
- Highly political/complex (1 pt) -- Favors: Consulting-First SaaS, Hammering Deep (need advocates)

**C2. Pain Urgency & Purchase Timeline (4 pts)**
"Your ICP shows pain urgency of [X]. This suggests:"
- Extreme urgency (solve within 1 week) (4 pts) -- Favors: Micro-SaaS (instant solution), Boring SaaS
- High urgency (solve within 1 month) (3 pts) -- Favors: Boring Micro-SaaS, Consulting-First (30-day implementation)
- Moderate urgency (solve within 3 months) (2 pts) -- Favors: Replicate & Localize, Consulting-First SaaS
- Low/aspirational urgency (timeline flexible) (1 pt) -- Favors: Hammering Deep (long-term positioning)

**C3. Budget Level & Payment Willingness (4 pts)**
"Your ICP shows budget authority of [X] and payment willingness of [X]. This suggests:"
- Low budget; looking for cheap solution (1 pt) -- Favors: Micro-SaaS (low price), Consulting-First (project-based)
- Mid-range budget; ROI-focused (4 pts) -- Favors: All paths viable; match to other factors
- High budget; willing to invest; relationship-driven (3 pts) -- Favors: Replicate & Localize (premium), Consulting-First SaaS (white-glove)
- Varies by buyer; mixed willingness (2 pts) -- Favors: Boring Micro-SaaS (multiple tiers), Hammering Deep (own the niche)

**C4. Accessibility & Channel Strength (4 pts)**
"Your ICP shows congregation points of [X] and channel viability of [X]. This suggests:"
- High density; easy to reach via specific channels (4 pts) -- Favors: Micro-SaaS, Boring SaaS (fast scaling via channels)
- Medium reach; requires marketing mix (3 pts) -- Favors: Consulting-First SaaS, Hammering Deep (content + direct)
- Low reach; hard to reach at scale (2 pts) -- Favors: Consulting-First SaaS (client-by-client), Replicate & Localize (partnership reach)
- Fragmented; no clear access pattern (1 pt) -- Favors: Consulting-First SaaS, Hammering Deep (build network over time)

---

### C5. ICP-Strategy Synthesis (9 pts)

**Type:** Free-text, 100-word limit
**Question:** Looking at your ICP's buying behavior, pain urgency, and budget--does your chosen strategy (from B5) still make sense? Or would you reconsider?

**AI Scoring Rubric (0-9 pts):**

| Score | Criteria |
|-------|----------|
| 0-2 | Strategy contradicts ICP behavior; misaligned |
| 3-4 | Strategy is reasonable but has some tension with ICP behavior |
| 5-6 | Strategy aligns with most ICP factors; minor concerns |
| 7-8 | Strong alignment; strategy clearly matches ICP behavior; demonstrates understanding |
| 9 | Expert synthesis; explicitly addresses buying complexity, urgency, budget, and accessibility |

**Evaluation Process:**
1. Extract student's stated ICP characteristics
2. Extract their strategy choice from B5
3. Cross-check alignment: Does strategy match buyer profile?
4. Assess reasoning quality
5. Award points: (Strategy Clarity x 2) + (ICP Understanding x 2) + (Alignment Reasoning x 5)

**Improvement Recommendation (if <7):**
- Score 0-3: "Your strategy contradicts your ICP profile. Match strategy to buying behavior."
- Score 4-6: "Your strategy mostly works but has tension. How will you handle that tension?"
- Score 7-8: "Good alignment. Validate with 1-2 ICPs: 'Does [strategy] match how you'd want to buy?'"

**Section C Total:** C1+C2+C3+C4+C5 = 0-25 pts

For display examples for B5 and C5 free-text responses, see **templates.md** (section: Free-Text Response Examples).

---

## 7. SECTION D: EXECUTION READINESS (20 POINTS)

**Goal:** Assess founder's ability to execute the recommended path.

**System Behavior:** Based on emerging primary path recommendation (B5 + C5), ask 4 path-specific execution readiness questions. Each question = 5 pts (deterministic scoring).

**System Logic:**
1. By end of B5, student has chosen a primary path: Replicate / Consulting / Micro / Hammering
2. System generates 4 MC questions specific to that path
3. Each question = 5 pts (deterministic scoring)

For the complete path-specific question sets (D1-D4 for all four paths), see **strategy-paths.md** (section: Execution Readiness Questions).

**Section D Total:** D1+D2+D3+D4 = 0-20 pts

---

## 8. SECTION E: MENA STRATEGY FIT (10 POINTS)

**Goal:** Assess geographic and cultural alignment with selected strategy.

### E1-E2: AI-Generated Questions (10 pts, 5 pts each)

**System Behavior:** Pull geography from SC1; generate 2 MENA-specific questions.

**E1. Strategy & MENA Culture Alignment (5 pts)**
"Your strategy is [PATH] in [GEOGRAPHY]. This aligns with MENA culture because:"
- Options (Deterministic; system generates based on path + geography):
  - Replicate & Localize in UAE: High tech adoption, proven demand for SaaS -- Strong fit (5)
  - Consulting-First in Egypt: Relationship-based business culture, trust important -- Strong fit (5)
  - Micro-SaaS in Saudi: Growing SaaS adoption, price sensitivity moderate -- Good fit (4)
  - Hammering Deep in Jordan: Opportunity to own vertical before competition arrives -- Good fit (4)
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
Readiness = (MAS Score x 0.35) + (ICP Clarity Score x 0.35) + (GTM Potential x 0.30)
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

1. **If B5 + C5 agree on path (strong alignment):**
   - Award primary path with confidence level
   - Secondary path = next-best fit
   - Trigger confidence threshold for execution

2. **If B5 != C5 (misalignment):**
   - Surface contradiction to student
   - Recommend: "Your market analysis suggests [Path A] but your ICP analysis suggests [Path B]. Which takes priority?"

3. **If either B5 or C5 = <5 pts (weak reasoning):**
   - Surface as concern
   - Recommend: "Your strategy choice isn't strongly grounded. Re-evaluate using [specific data]."

For detailed strategy path descriptions, execution requirements, 90-day roadmaps, and validation experiments, see **strategy-paths.md**.

---

## 11. ARCHETYPE CLASSIFICATION

**System Classifies Student Into 8 Archetypes:**

| # | Archetype | Profile | Default Path |
|---|-----------|---------|-------------|
| 1 | **Launcher** | Ambitious + resources | Replicate & Localize |
| 2 | **Market Hunter** | Sales-focused | Consulting-First SaaS |
| 3 | **Channel Seeker** | Distribution advantage | Boring Micro-SaaS |
| 4 | **Solution Seeker** | Product-focused | Hammering Deep |
| 5 | **Expert Without a Stage** | Domain expertise; no platform | Hammering Deep or Consulting |
| 6 | **Ghost** | Stealth; unknown | Micro-SaaS |
| 7 | **Operator** | Operations-focused | Replicate & Localize |
| 8 | **Scrambler** | Early-stage; figuring out | Consulting-First SaaS (revenue fast) |

For detailed archetype descriptions, scoring criteria, Expert Without a Stage playbook, Portfolio vs. Single Product assessment, and the 30-day validation experiments per archetype, see **archetypes.md**.

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
- Movement Brief (cause, new opportunity, enemy, future vision)
- Re-Assessment Triggers

For the full output template structure and Movement Brief prompts, see **templates.md**.

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

**Reference Files:**
- **archetypes.md** -- Detailed archetype descriptions, scoring criteria, Attractive Character mapping, Pattern of Inaction check, Expert Without a Stage playbook, Portfolio vs. Single Product framework
- **strategy-paths.md** -- Detailed strategy path descriptions, execution requirements, 90-day roadmaps, content-to-paid pipelines, 30-day validation experiments, execution readiness question sets (D1-D4)
- **templates.md** -- Output templates, Movement Brief prompts, free-text response examples

---

**END OF SKILL.MD**
