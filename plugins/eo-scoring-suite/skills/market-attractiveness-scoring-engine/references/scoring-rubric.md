# Scoring Rubric: Market Attractiveness Scoring Engine

Complete scoring criteria and evaluation guidelines for all 25 questions, organized by section.

---

## GENERAL RUBRIC PRINCIPLES

1. **Score 0-5 Scale Per Question:** Each question worth 5 points; scale is 0-5
2. **Rubric Evaluation:** Apply scoring rubric to response; assign score based on criteria match
3. **Evidence Quality > Confidence:** Specific, named evidence scores higher than vague confidence
4. **Consistency Checking:** Flag contradictions across related questions; offer clarification rather than penalizing
5. **MENA Adjustments:** Apply geography-specific scoring modifiers where noted

---

## SECTION A: PAIN REALITY & INTENSITY RUBRICS

### A1-A5 Scoring Process

**Common Evaluation Steps (apply to most free-text):**
1. Extract the claim from student response
2. Identify specific, named evidence (companies, people, dates, numbers)
3. Count evidence types (conversation, competitive, data, research, regulatory, observable behavior)
4. Assess realism and consistency with SC2 upstream data
5. Apply weighted formula: (Metric A × weight) + (Metric B × weight) + ...
6. Assign score from rubric

**Example Weighted Evaluation (A1):**
- Diversity of evidence types: 0.5
- Specificity of sources: 0.3
- Consistency with SC2: 0.2
- **Award = (Div × 0.5) + (Spec × 0.3) + (Cons × 0.2)**

---

## SECTION B: PURCHASING POWER & WILLINGNESS RUBRICS

### B3 Pricing Framework Cross-Check (Expert Enhancement)

**During B3 evaluation, Claude performs automated cross-checks:**

**CROSS-CHECK 1: Pain Frequency × Pain Cost**
- Source: A2 (pain frequency) + A3 (pain cost)
- Formula: If pain is daily ($X/month cost), pricing should be 20-40% of $X/month
- Example: Daily pain costing $1,000/month → price should be $200-400/month (not $50/month)
- **If inconsistency >50%:** Flag with recommendation

**CROSS-CHECK 2: Competitor Pricing (from SC1 positioning)**
- Source: SC1 competitor pricing data
- Acceptable range: ±30% of competitor average (allows for differentiation)
- **If inconsistency >50%:** Flag with recommendation

**CROSS-CHECK 3: ICP Budget Range (from SC2)**
- Source: SC2 budget range + purchasing power signals from B1-B2
- Formula: ICP budget from SC2 × typical allocation % = acceptable price range
- Example: ICP budget $5K/month, typical SaaS allocation 10-20% = $500-1K acceptable
- **If inconsistency >50%:** Flag with recommendation

**FIRING LOGIC FOR HIGH-PRIORITY RECOMMENDATION:**
```
IF (stated price vs. implied price from A2+A3 = >50% gap)
AND (stated price vs. SC1 competitors = >50% gap)
AND (stated price vs. SC2 budget = >50% gap)
→ FIRE: "Pricing shows significant inconsistencies. Stress-test with 3 ICPs before GTM."
```

---

### B5 Underpricing Detection (Expert Framework)

**Triggered During B3 Review & B1 Comparison**

**Signal (a): Competitor Pricing Gap**
- Founder states: "$X/month" (B3)
- SC1 positioning shows: Competitors charge 3-5x more
- RED FLAG: If price is >50% below competitor average for same problem size
- RECOMMENDATION: Compare B3 against SC1 competitor pricing matrix

**Signal (b): B2B Pricing-to-Pain Mismatch**
- Founder states: "$X/month" (B3)
- Pain cost from A3 is: >$1,000/month
- Stated price is: <$50/month
- RED FLAG: Price <5% of annual pain cost suggests underpricing for B2B
- RULE OF THUMB: B2B pricing should be 20-40% of pain cost; <10% signals underpricing

**Signal (c): Pain Frequency-Pricing Disconnect**
- Pain frequency from A2: Daily (or multiple times daily)
- Pricing model from B3: Annual subscription OR quarterly
- RED FLAG: Daily pain should map to monthly billing (not annual)
- LOGIC: High-frequency pains require frequent payment reminder; annual billing masks true cost

**Signal (d): Founder Rationalization**
- Founder statement heard: "I need to be cheaper to compete" OR "Price doesn't matter; volume does" OR "We'll raise it later"
- RED FLAG: This is classic underpricing rationalization
- RECOMMENDATION: "This thinking leads to margin death. Instead: (1) Find non-price differentiation, (2) Target segment with higher willingness-to-pay, (3) Bundle additional value, (4) Raise price BEFORE GTM."

---

### B3 Grand Slam Offer Check (Expert Framework)

**Triggered After B3 & B5 Completion**

Based on pain evidence (Section A) and purchasing power (Section B), evaluate Alex Hormozi's Grand Slam formula:

**1. Dream Outcome Score:** How transformative is this solution?
- Extract from: A3 pain cost + B3 ROI calculation
- Score high if: ROI >5x AND pain cost >$1K/month AND pain affects revenue directly
- Score low if: ROI <2x OR pain is operational convenience

**2. Perceived Likelihood:** How credible is the value delivery claim?
- Extract from: A1 evidence strength + B5 willingness proof
- Score high if: Expert evidence (A1=5) + Signed commitments (B5≥4)
- Score low if: Assertion evidence (A1<3) + Only aspirational signals (B5<2)

**3. Time Delay:** How fast can value be delivered?
- Extract from: A5 urgency signals + B2 budget process
- Score high if: Sales cycle <4 weeks (urgency + simple approval)
- Score low if: Sales cycle >8 weeks (complex approval + implementation lag)

**4. Effort & Sacrifice:** How easy is it for buyer to switch/adopt?
- Extract from: A4 workaround brittleness + B1 existing spend
- Score high if: Current workarounds failing badly + low switching cost (<20% of pain)
- Score low if: Workarounds functional + switching cost >50% of pain

**Viability Index Calculation:**
```
Viability Index = (Dream × Likelihood) / (Delay × Effort)
IF Viability Index < 2.0 → FLAG: "Weak offer structure"
IF Viability Index 2.0-3.5 → CAUTION: "Moderately strong offer"
IF Viability Index > 3.5 → STRONG: "High-probability offer"
```

---

## SECTION C: ICP ACCESSIBILITY RUBRICS

### C5 MENA Channel Reference Baseline

Use this table to evaluate realism of student's C5 channel mix:

| Country | LinkedIn | WhatsApp | Email | Events | Language | Notes |
|---------|----------|----------|-------|--------|----------|-------|
| Saudi | 65-70% | 90%+ | 40-50% | Medium | Arabic growing | High business adoption |
| UAE | 75%+ | 95%+ | 60% | High | Mixed | Highest GCC penetration |
| Qatar | 70% | 95%+ | 60% | Medium | Mixed | Similar to Saudi |
| Egypt | 35-45% | 95%+ | 15-25% | Low | Arabic | Credit card low; mobile-first |
| Jordan | 45-50% | 95%+ | 20-30% | Low | Arabic | Growing but lower adoption |
| Lebanon | 45-50% | 95%+ | 20-30% | Low | Arabic | Economic challenges reduce spend |
| Morocco | 45% | 90%+ | 15-20% | Low | Arabic/French | Francophone segment distinct |

**Scoring C5:**
- Score 0-1: No MENA awareness OR Western assumptions only (email + LinkedIn = "standard")
- Score 2: Surface awareness ("MENA uses WhatsApp more"; vague)
- Score 3: 2-3 MENA factors mentioned; partial channel mix provided
- Score 4: 3-4 factors mentioned; channel % provided; language strategy clear
- Score 5: Detailed mix by geography; language strategy; local competitive advantage identified

**Evaluation weights (C5 Award):**
- Factors Mentioned: 0.3
- Channel Mix Realism (vs. table): 0.35
- Language Strategy: 0.2
- Competitive Position (local advantage): 0.15

---

## SECTION D: MARKET GROWTH & MOMENTUM RUBRICS

### D1-D5 Growth Evidence Quality Hierarchy

Use this hierarchy to assess evidence quality in Section D responses:

**Evidence Quality Tiers (Highest to Lowest):**

1. **Investment Grade (Score 5):**
   - Named analyst firm (Gartner, McKinsey, Statista) with year and specific %, CAGR
   - Competitor funding with amounts, dates, and rounds
   - Regulatory deadline in writing with effective date
   - Direct buyer statement from named person
   - Multiple external validation sources

2. **Strong Evidence (Score 4):**
   - Two validation sources (analyst + competitor funding OR regulatory + buyer)
   - Specific, dated evidence for 2+ signals
   - Named firms and quantified data
   - Regulatory pressure identified with estimated impact scope

3. **Partial Evidence (Score 3):**
   - One strong source + one weak source
   - Some specificity but missing key details (dates, numbers, names)
   - Logical reasoning with some validation
   - Beginning of multi-source thinking

4. **Weak Evidence (Score 2):**
   - Generic observation ("market is growing")
   - Single source without specificity
   - Unvalidated assumptions
   - No named firms, dates, or numbers

5. **No Evidence (Score 0-1):**
   - Blank or "don't know"
   - Contradicts evidence
   - Pure opinion

---

### D2 Tailwind Specificity Evaluation

**When evaluating D2 responses, check for specificity on THREE dimensions:**

1. **Named Source:** (Highest = actual regulation/mandate; Lowest = "industry trends")
   - Specific: "ZATCA e-invoicing mandate effective June 2026"
   - Generic: "companies are digitizing"

2. **Quantified Impact:** (Highest = affects all companies in jurisdiction; Lowest = affects some businesses)
   - Specific: "All Saudi companies must comply = affects 500K+ businesses"
   - Generic: "businesses are automating"

3. **Connection to Solution:** (Highest = direct forcing function; Lowest = tangential)
   - Direct: "ZATCA mandate forces e-invoicing adoption → your invoice software solves this"
   - Tangential: "Labor costs rising → people like automation → maybe they'd buy software"

**Scoring D2 (Award):**
- Tailwind Count: 0.35
- Specificity (source + impact + connection): 0.35
- Solution Relevance: 0.3

---

## CROSS-SCORECARD CONSISTENCY CHECKS

Claude automatically checks these alignments during scoring:

**SC1 ↔ SC3 Alignment:**
- ICP from SC2 matches pain evidence in A1?
- Geography from SC1 matches MENA strategy in C5?
- Positioning aligns with pain evidence?

**SC2 ↔ SC3 Alignment:**
- Pain statements from SC2 referenced in A1-A5?
- Congregation points from SC2 in C1?
- Budget range from SC2 feasible with B3 pricing?

**Internal MAS Consistency:**
- Pain cost (A3) vs. Frequency (A2): High-cost pains should occur frequently
- Reach (C2) vs. Congregation (C1): If dense, should be reachable
- Market Growth (D1) vs. Funding (D3): Growing markets have funded competitors

**Flagging Logic:**
- Flag contradictions for student clarification
- Offer chance to update; don't penalize if good explanation provided
- Surface inconsistencies as learning opportunities, not scoring penalties

---

## SCORING ADJUSTMENT RULES

### MENA-Specific Adjustments

**Applied Throughout Scoring:**

1. **B4 Payment (Egypt/Jordan/Lebanon):**
   - If "Credit card only" in low-adoption countries: Deduct 1 pt
   - Reason: Credit card adoption <40%; should add bank transfer or BNPL

2. **C3/C5 Channels:**
   - Adjust channel fit based on geography penetration rates
   - Example: If student proposes "Email primary" for Egypt, flag as misaligned with 15-25% email adoption

3. **D2 Tailwinds:**
   - Recognize Vision 2030 (Saudi), ZATCA (Saudi), data laws (UAE/Egypt)
   - These are high-impact; regulatory tailwinds score higher

4. **D5 Readiness:**
   - Expect longer sales cycles in emerging markets
   - Government adoption slower; private sector faster
   - Adjust GTM timeline expectations by geography readiness level

---

## IMPROVEMENT PATH TEMPLATES

### For Score 0-2 (Needs Major Work)
> "Schedule X buyer conversations THIS WEEK. Ask: [Specific question]. Document [format]."

### For Score 2-3 (Getting There)
> "For [#1 item], gather [X sources]: (1) [type], (2) [type], (3) [type]. Name and number everything."

### For Score 3-4 (Nearly There)
> "Add [one more dimension]. Validate with buyer: '[Question]?' Their reaction tells you [insight]."

### For Score 4+ (Strong; Refining)
> "Deepen analysis: Ask: '[Follow-up question]?' Their answer = [strategic insight]."

---

## BORDERLINE CALIBRATION EXAMPLES

These examples show the hardest scoring decisions for Market Attractiveness's most critical evidence questions.

---

### Borderline: A2 (Pain Frequency) — Score 2 vs 3

**Question:** A2 — Pain Frequency (5 points). How often does the target ICP experience the pain? Score based on evidence hierarchy.

**Answer:** "Real estate brokers lose leads multiple times per week. I talked to 5 brokers and they each mentioned losing leads — probably 2-3 times per week on average."

**Score 2 argument:** Student is using self-reported frequency ("probably 2-3 times per week") without behavioral evidence. The interview count is small (5 brokers), and the answer is vague on proof. "They mentioned losing leads" doesn't show frequency rigorously.

**Score 3 argument:** Multiple sources (5 brokers) all independently mentioned the same pain (lead loss). The frequency estimate (2-3x/week) is consistent across sources, suggesting pattern validity. The student made an inference from multiple inputs, not a single assumption.

**RULING: 2** — Tiebreaker: Missing the behavioral evidence tier. A 3 would include: "I asked each broker to screenshot their WhatsApp on a Monday and Thursday. All 5 had 15-30+ unread messages. I asked 'How many of these are leads you haven't followed up on?' Answers ranged from 2-8 per day = 10-40 per week. They also estimated 3-5 deals lost monthly to this chaos." This is observed behavior + quantified impact, not just "probably happens."

---

### Borderline: A3 (Pain Cost) — Score 3 vs 4

**Question:** A3 — Pain Cost (5 points). What is the financial/opportunity impact of the pain? Evidence quality determines score.

**Answer:** "Each broker manages 15-40 listings. Average listing value is AED 200K. If a broker loses even 1 deal per month to poor lead tracking, that's AED 200K revenue lost per month. At a 10% commission, that's AED 20K per broker per month = AED 240K annually."

**Score 3 argument:** The calculation is logical (deal value × lost deals × commission %), but it's built on an assumption about deal loss rate ("even 1 deal per month"). Student didn't validate this with brokers — it's inference. The math is sound but the input variable is not evidence-based.

**Score 4 argument:** This is "strong evidence" tier because the student used real data (listing values from MLS or broker websites) + a conservative estimate (1 deal/month) + clear math chain (value → commission → monthly impact). The assumption is reasonable and transparent.

**RULING: 3** — Tiebreaker: Upgrade to 4 with one additional layer: "I asked 5 brokers: 'How many deals do you estimate you lose monthly due to lead chaos or delayed follow-up?' Answers: 1-3 deals/month. One said 'At least AED 15-20K per month in missed commissions.'" This validates the lost-deal assumption rather than inferring it.

---

### Borderline: D2 (Tailwind Specificity) — Score 3 vs 4

**Question:** D2 — Tailwind Specificity (5 points). Evaluate on: Named Source + Quantified Impact + Connection to Solution.

**Answer to "What external tailwind will help your market grow?":** "ZATCA e-invoicing mandate. All Saudi companies will need to comply by 2025. It's a forcing function that will drive demand for any accounting/invoicing software. Everyone affected will be looking for solutions."

**Score 3 argument:** Named source (ZATCA), impact (all Saudi companies), but loose connection to the student's specific solution. If the student is building a "WhatsApp CRM for real estate," how does ZATCA e-invoicing help? The tailwind is real, but the connection to the specific solution is tangential. The impact is correct but generic.

**Score 4 argument:** The student understands the tailwind is a forcing function (all companies must comply). If they're building something related to Saudi business operations (accounting, invoicing, SaaS for regulated businesses), this is a strong tailwind. The specificity is in the mechanism: "Companies must invoice electronically → they need tools to manage that → our solution integrates with ZATCA or makes compliance easier."

**RULING: 3** — Tiebreaker: The connection to solution is missing. A 4 would articulate: "ZATCA mandate forces all real estate brokerages in Saudi to adopt electronic invoicing by June 2025. They'll need tools to track, generate, and file invoices. Our WhatsApp CRM includes built-in invoice generation + ZATCA formatting, so brokers can issue compliant invoices directly from WhatsApp without switching tools." This shows how the tailwind drives demand for the specific solution.

---

### Borderline: C5 (MENA Channel Mix Realism) — Score 3 vs 4

**Question:** C5 — MENA Channel Mix (5 points). Evaluate channel selection against geography, language, and local adoption rates.

**Answer:** "Our ICP is marketing managers at 50-person digital agencies in Saudi. They'll find us via: (1) LinkedIn outreach — 60% of our GTM, (2) WhatsApp groups for marketing professionals — 25%, (3) Email newsletter sponsorships — 15%. We'll also do some paid LinkedIn ads once we have proof."

**Score 3 argument:** Student names channels (LinkedIn, WhatsApp, email) and provides rough allocation (60-25-15). But it's weak on MENA-specific adjustment. Marketing managers in Saudi do use LinkedIn, but email newsletter sponsorships have lower ROI than in Western markets (email adoption is lower). The allocation ignores the reference baseline.

**Score 4 argument:** The student shows local awareness (LinkedIn + WhatsApp primary, not just LinkedIn). The allocation reflects MENA reality (WhatsApp significant, email secondary). If they added one more layer ("Email because they're professional/corporate audience, but WhatsApp because Saudi business culture is relationship-first"), that would be 4.

**RULING: 3.5 → 4** — Tiebreaker: The channel mix is realistic for Saudi marketing managers, but the reasoning is light. A 5 would include: "LinkedIn because our ICP (marketing managers at established agencies) uses LinkedIn for professional development (S-curve adoption in Gulf is strong). WhatsApp because Saudi business culture defaults to WhatsApp for warm introductions — cold LinkedIn works less. Email sponsorships work with newsletter-educated audiences, which this ICP is (they read marketing blogs/newsletters). Paid LinkedIn ads after proof because conversion cost is still reasonable for $10K+ ACV."

---

END OF SCORING RUBRIC
