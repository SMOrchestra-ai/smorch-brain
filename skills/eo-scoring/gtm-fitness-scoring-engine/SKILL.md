<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: gtm-fitness-scoring-engine
description: Scorecard 5 of 5 — Evaluate readiness across 13 GTM motions using composite scoring (Fit×0.4 + Readiness×0.3 + MENA×0.3). Assign PRIMARY/SECONDARY/CONDITIONAL/SKIP tiers.
version: "3.0"
---

# SKILL: GTM Fitness Scoring Engine v3.0

**Version:** 3.0 — Deep Matrix Integration
**Created:** 2026-03-06 | **Updated:** 2026-03-10
**Input Sources:** SC1 (Project Definition), SC2 (ICP Clarity), SC3 (Market Attractiveness), SC4 (Strategy Selector), GTM Matrix
**Output File:** `gtm-fitness.md`
**Execution Model:** 13 MC questions → Weight Matrix scoring → Motion composite ranking → Tier assignment → 72-Hour Commitment

---

## STRATEGIC PURPOSE

GTM Fitness Scoring answers one question: **"Of all 13 go-to-market motions, which 2-3 should this founder activate FIRST?"**

This is NOT a general marketing assessment. It's a precision instrument combining:
- **Upstream context** (SC1-SC4): niche, ICP, market conditions, strategy path, founder archetype
- **Founder's business reality** (13 MC questions): assets, infrastructure, capacity, market dynamics
- **Motion intelligence** (GTM Matrix): real examples, win/fail conditions, MENA execution playbooks
- **Weight matrix scoring**: each question influences each motion differently (169 weighted connections)

**Philosophy:** Every founder has 2-3 motions that are natural fits and 10 that will waste their time. The scoring engine finds the natural fits by cross-referencing what the founder HAS (assets, infra, capacity) with what each motion NEEDS (prerequisites, conditions, execution requirements).

---

## PREREQUISITES — UPSTREAM DATA CONTRACT

**Required Upstream Scorecards:**
- **SC1** (Project Definition): Niche, positioning, geography, ACV, brand voice
- **SC2** (ICP Clarity): Buyer profile, pain points, congregation points, budget, hero journey stage
- **SC3** (Market Attractiveness): Pain reality, purchasing power, ICP accessibility, market growth, competition density
- **SC4** (Strategy Selector): Strategy path, founder archetype, skill, capital, hours, risk tolerance

**Pre-Assessment Check:**
1. Validate all 4 upstream scorecards completed
2. If any upstream score < 40 (RESET band): flag warning — GTM assessment may be premature
3. Load upstream scores to calculate fit bonuses and strategy path bonuses

**Read `references/weight-matrix.md` for upstream bonus calculation formula and strategy path bonus matrix.**

---

## THE 13 ASSESSMENT QUESTIONS (Q0-Q12)

Founder answers 13 multiple-choice questions (4 options, scored 1-4). Weight matrix determines how each answer influences each motion's readiness score.

### Your Assets (Q0-Q2)

**Q0: Email List Size**
- No list yet (1) | Under 500 (2) | 500-2,000 (3) | Over 2,000 (4)
- Critical for: Waitlist Heat (w=3), Authority Education (w=2), Value Trust Engine (w=2)

**Q1: Content Frequency**
- Rarely/never (1) | Once a month (2) | Weekly (3) | Multiple/week (4)
- Critical for: Build-in-Public (w=3), Authority Education (w=3), Wave Riding (w=2), BOFU SEO (w=2)

**Q2: Founder Visibility**
- Not at all (1) | Somewhat (2) | Regular social (3) | Already building personal brand (4)
- Critical for: Build-in-Public (w=3), Authority Education (w=3), Waitlist Heat (w=2), Dream 100 (w=2), Value Trust (w=2)

### Your Product (Q3-Q4)

**Q3: Demo Ability**
- No — value takes time (1) | Partially (2) | Solid demo (3) | Instantly impressive (4)
- Critical for: Outcome Demo First (w=3), LTD Cash-to-MRR (w=3), Hammering-Feature (w=2), Paid VSL (w=2)

**Q4: Outbound Tools**
- Nothing (1) | Basic CRM/email (2) | Email + LinkedIn + CRM (3) | Full stack (4)
- Critical for: Signal Sniper (w=3), 7x4x11 (w=2), Dream 100 (w=1)

### Your Infrastructure (Q5-Q7)

**Q5: Marketing Budget**
- Under $500/month (1) | $500-2K (2) | $2K-5K (3) | Over $5K (4)
- Critical for: Paid VSL (w=3), 7x4x11 (w=2), Signal Sniper (w=1), Wave Riding (w=1)

**Q6: Network Strength**
- Very weak (1) | Some contacts (2) | Good network (3) | 20+ active relationships (4)
- Critical for: Dream 100 (w=3), 7x4x11 (w=2), Waitlist Heat (w=2)

**Q7: Deal Size**
- Under $500/year (1) | $500-2K (2) | $2K-10K (3) | Over $10K (4)
- Critical for: 7x4x11 (w=3), Signal Sniper (w=2), Outcome Demo (w=1), Paid VSL (w=1)

### Your Market (Q8-Q10)

**Q8: Speed to Ship**
- Weeks/months (1) | About a week (2) | Few days (3) | Same day (4)
- Critical for: Wave Riding (w=3), LTD (w=3), Hammering-Feature (w=3), Build-in-Public (w=2)

**Q9: Search Demand**
- None — don't know they need it (1) | Some — low volume (2) | Yes — clear demand (3) | High volume + intent (4)
- Critical for: BOFU SEO (w=3), Hammering-Feature (w=3), Paid VSL (w=2)

**Q10: Sales Capacity**
- None — self-serve only (1) | Limited — few calls/week (2) | Moderate — 10-20/week (3) | Strong — dedicated sales (4)
- Critical for: 7x4x11 (w=3), Signal Sniper (w=3), Dream 100 (w=2), Outcome Demo (w=2)

### Your Capacity (Q11)

**Q11: Event Experience**
- Never (1) | Once/twice (2) | Several times (3) | Regularly (4)
- Critical for: Waitlist Heat (w=3), Value Trust Engine (w=3), Authority Education (w=2), 7x4x11 (w=2)

### Your MENA Focus (Q12)

**Q12: MENA Focus**
- Not at all (1) | Some MENA (2) | Primary market (3) | MENA-only (4)
- MENA Multiplier: 1→0.3x | 2→0.6x | 3→1.0x | 4→1.2x
- Note: Q12 does NOT feed into weight matrix. It acts as global multiplier on MENA dimension of every motion.

---

## SCORING ENGINE

### Motion Readiness Score

```
readinessRaw = SUM(answer_value[q] × weight[motion][q]) for q=0..11
readinessMax = SUM(4 × weight[motion][q]) for all q
readiness = (readinessRaw / readinessMax) × 10
```

### Motion Fit Score

```
fit = defaultFit + upstreamFitBonus + strategyPathBonus
fit = min(10, fit)  // cap at 10
```

**Upstream Fit Bonus:** +0.5 per upstream scorecard (SC1-SC4) > 70. Maximum +1.6
**Strategy Path Bonus:** +0-3 per motion based on SC4 strategy path. See `references/weight-matrix.md`

### Motion MENA Score

```
mena = min(10, baseMena × menaMultiplier)
```

Where menaMultiplier = [0.3, 0.6, 1.0, 1.2] based on Q12.

### Composite Score (per motion)

```
composite = (fit × 0.4) + (readiness × 0.3) + (mena × 0.3)
Range: 0.0 to 10.0
```

### Motion Tier Assignment

| Tier | Score | Action | Meaning |
|------|-------|--------|---------|
| **PRIMARY** | >= 6.5 | Deploy now | High fit + readiness + MENA = fastest ROI |
| **SECONDARY** | 5.0-6.4 | Build capacity | Good fit, some gaps = next quarter |
| **CONDITIONAL** | 3.5-4.9 | Fix gaps first | Potential but needs prerequisites |
| **SKIP** | < 3.5 | Deprioritize | Low fit or readiness now |

### Overall Score (0-100)

```
raw = ((sum_of_answers - num_answered) / (num_answered × 3)) × 85
bonus = SC1>70?+3:0 + SC2>70?+3:0 + SC3>70?+2:0 + SC4>70?+2:0
bonus += Q12≥3?+3:(≥2?+1:0)
overall = min(100, max(0, round(raw + bonus)))
```

### Score Bands

| Band | Score | Meaning |
|------|-------|---------|
| **Launch Ready** | 85-100 | Strong across all dimensions — execute the plan |
| **Almost There** | 70-84 | Good foundation, fill 1-2 gaps |
| **Needs Work** | 55-69 | Multiple gaps to address |
| **Early Stage** | 40-54 | Build fundamentals before GTM activation |
| **Reset** | 0-39 | Return to upstream scorecards |

---

## THE 13 SMOrchestra GTM MOTIONS — DEEP INTELLIGENCE

**Before assessing motions, read `references/motion-definitions.md` and `references/weight-matrix.md` for:**
- Detailed definition of each motion + best-fit conditions
- Real examples (Copy.ai, Jasper AI, Slack, Notion, etc.)
- Win/fail patterns + MENA execution playbooks
- Critical weight dependencies + 72-hour launch commitments

---

### MOTION QUICK REFERENCE

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

**For full definitions, examples, and MENA playbooks, read `references/motion-definitions.md`**

---

## WEIGHT MATRIX (13x13)

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

**Weight Legend:** 3=critical | 2=strong influence | 1=moderate | 0=irrelevant
**Full matrix logic and upstream bonus formulas in `references/weight-matrix.md`**

---

## EXPERT FRAMEWORK GATES

Expert gates add diagnostic context to recommendations. They don't change scores but may reorder priorities, add prerequisites, or trigger interventions.

**Five Gates Applied:**
1. **Pattern of Inaction Check** — If founder has been working >6 months with zero launches
2. **Content Systems Check** — If any content motion (Authority, Build-Public, Wave Riding) = PRIMARY
3. **Solo Founder Bandwidth Calculator** — Applied to all motions
4. **Pattern Interrupt Readiness** — If content motion = PRIMARY or SECONDARY
5. **Engagement Audit** — Applied to top 3 motions

**For full gate details, diagnostic criteria, and intervention output, read `references/expert-gates.md`**

---

## MOTION TIERING LOGIC

### PRIMARY Motions (Deploy Now)

Criteria:
- Composite score >= 6.5
- Sum of top 2-3 motion scores represents fastest path to revenue
- Founder has or can quickly build required assets
- 72-hour launch feasible

Action: Activate within 72 hours. Target revenue/customer traction in 30 days.

### SECONDARY Motions (Build Capacity)

Criteria:
- Composite score 5.0-6.4
- Good fit but missing some capability or infrastructure
- Should be sequenced after PRIMARY is stabilized (weeks 5-8)

Action: Plan capacity building. Launch after PRIMARY shows traction.

### CONDITIONAL Motions (Fix Gaps First)

Criteria:
- Composite score 3.5-4.9
- Potential fit but critical gaps are real
- Requires 4-12 weeks of capability/infrastructure building

Action: Define gap-closing plan. Revisit in Q3-Q4.

### SKIP Motions (Deprioritize)

Criteria:
- Composite score < 3.5
- Low fit or impossible readiness given current profile
- Not worth founder's effort

Action: Deprioritize. Revisit if founder's situation materially changes.

---

## 72-HOUR LAUNCH COMMITMENT

Each PRIMARY motion includes specific 72-hour action items. Founder should commit to one ACTION (not "planning") per 24-hour block:
- **Hour 0-24:** [First action — deliverable, not discussion]
- **Hour 24-48:** [Second action — moves the motion forward]
- **Hour 48-72:** [Third action — completes initial setup]

**Why 72 hours?** Founders who don't activate within 3 days rarely execute. Momentum is everything.

**Calendar reminder:** Set 72-hour follow-up call to confirm completion.

---

## OUTPUT FILE STRUCTURE

Output file: `gtm-fitness.md`

**Sections:** (See `references/output-template.md` for full template)
1. Overall assessment & score band
2. Warnings & prerequisites (from expert gates)
3. All 13 motions ranked (composite score + tier)
4. PRIMARY motions (deep dive: why works, gaps, 72-hour, 30-day, MENA adaptations)
5. SECONDARY motions (with capacity-building plan)
6. CONDITIONAL motions (with gap-closing plan)
7. SKIP motions (why not now)
8. 72-hour commitment detail
9. 90-day motion sequence
10. MENA execution adaptations
11. Re-assessment triggers

---

## EXECUTION CHECKLIST

### Phase 1: Load Upstream Scores
- [ ] Retrieve SC1, SC2, SC3, SC4 scores; confirm all present
- [ ] Calculate upstreamFitBonus: +0.5 per SC > 70 (max +1.6)
- [ ] Load strategy path bonus matrix from SC4 selection

### Phase 2: Administer 13 MC Questions (Q0-Q12)
- [ ] Present by category group (Assets Q0-Q2, Product Q3-Q4, Infrastructure Q5-Q7, Market Q8-Q10, Capacity Q11, MENA Q12)
- [ ] Collect 4-option answers (scored 1-4 each)
- [ ] Store all answers for Phase 3 calculation

### Phase 3: Score All 13 Motions
- [ ] For each motion (0-12), calculate:
  - readiness = (readinessRaw / readinessMax) × 10
  - fit = defaultFit + upstreamFitBonus + strategyPathBonus (cap at 10)
  - mena = baseMena × Q12Multiplier
  - composite = (fit × 0.4) + (readiness × 0.3) + (mena × 0.3)
- [ ] Assign tier: PRIMARY (≥6.5) / SECONDARY (5.0-6.4) / CONDITIONAL (3.5-4.9) / SKIP (<3.5)
- [ ] Calculate overall score (0-100) with raw + bonuses + MENA bonus

### Phase 4: Apply Expert Gates (From references/expert-gates.md)
- [ ] Pattern of Inaction Check: High scores but zero launches → Flag founder
- [ ] Content Systems Check: If content motion = PRIMARY, verify system in place
- [ ] Solo Founder Bandwidth: Sum PRIMARY motion hours vs. founder availability
- [ ] Pattern Interrupt Readiness: If content PRIMARY, confirm hooks exist
- [ ] Engagement Audit: Top 3 motions, check 3-4/4 hook components

### Phase 5: Rank Motions & Detail PRIMARY
- [ ] Sort all 13 motions by composite score (highest first)
- [ ] For each PRIMARY motion:
  - **Why it works:** Map to founder assets + market conditions
  - **Gaps:** Missing prerequisites; how to close in 72 hours
  - **72-hour commitment:** 3 specific actions (day 1, day 2, day 3)
  - **30-day traction goal:** Quantified outcome
  - **MENA adaptation:** Country-specific playbook (WhatsApp, payment, language)
- [ ] For SECONDARY/CONDITIONAL: List capacity-building or gap-closing plan

### Phase 6: Generate Output
- [ ] Create gtm-fitness.md using references/output-template.md
- [ ] Populate: overall score + band, all 13 motions ranked, expert gate warnings
- [ ] Include: 72-hour commitment detail + 90-day motion sequence + MENA adaptations

### Phase 7: Handoff & 72-Hour Commitment
- [ ] Display score, band, PRIMARY motions, readiness gaps
- [ ] Highlight 72-hour commitment: "Pick ONE PRIMARY motion. Complete these 3 actions in 3 days."
- [ ] Offer 72-hour follow-up call: "Let's confirm execution on Day 4"
- [ ] Message: "SC5 complete. All 5 scorecards done. Ready for /eo brain ingestion or web dashboard."

---

## CROSS-REFERENCE: HTML SCORING vs. SKILL SCORING

The HTML dashboard in the EO platform and this SKILL operate on same logic:
- **Same upstream data contract** (SC1-SC4 required)
- **Same weight matrix** (169 weighted connections)
- **Same motion defaults** (fit, MENA, hours)
- **Same scoring formula** (readiness × readinessMax, composite calc)
- **Same tier assignment** (PRIMARY >= 6.5, etc.)

Difference:
- **HTML dashboard:** Real-time UI, interactive matrix, visual scoring
- **SKILL:** Prose-based, narrative context, expert gates, output file generation

Both produce same final scores. Use whichever format suits founder workflow.

---

## REFERENCES FOLDER STRUCTURE

All heavy content moved to references/ directory:

1. **motion-definitions.md** (12K words)
   - Full definition of all 13 motions
   - Real examples + case studies
   - Win/fail patterns
   - MENA execution playbooks
   - Critical weight dependencies

2. **weight-matrix.md** (5K words)
   - Full 13×13 weight matrix
   - Upstream bonus calculations
   - Strategy path bonus matrix
   - Upstream data-to-motion mapping
   - Motion scoring priority model

3. **expert-gates.md** (4K words)
   - Gate 1-5 detailed criteria
   - Diagnostic frameworks
   - Intervention output templates
   - Gate application decision tree

4. **output-template.md** (3K words)
   - Full gtm-fitness.md template
   - Variable insertion points
   - Section-by-section guidance
   - Output variations (quick summary, deep dive, dashboard)

**Point founders here for deep content. Keep SKILL.md under 480 lines.**

---

**SKILL v3.0 — End**

**Questions?** Refer to references/ folder or contact Mamoun Alamouri (@MamounAlamouri).
