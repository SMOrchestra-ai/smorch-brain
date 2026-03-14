---
name: market-attractiveness-scoring-engine
description: Scorecard 3 of 5 — Evaluates market attractiveness across 4 dimensions (Market Size, Competition, Monetization, Execution). Scores /100 with hybrid MC + AI-evaluated questions.
version: "2.0"
---

# SKILL: Market Attractiveness Scoring Engine

**Version:** 2.0
**Created:** 2026-03-06
**Framework:** Alex Hormozi ($100M Leads), Chet Holmes (7x4x11)
**Input Sources:** SC1 (Project Definition) + SC2 (ICP Clarity)
**Output File:** `MarketAttractiveness.md`
**Execution Model:** Claude-administered questionnaire with real-time AI scoring

---

## 1. STRATEGIC PURPOSE

Market Attractiveness Scoring (MAS) determines whether a market is worth entering by shifting from subjective ratings to evidence-based validation. Rather than asking founders to rate pain intensity 1-5, the system requires concrete evidence: customer conversations, competitive research, market data, regulatory signals, and growth indicators.

**Philosophy:** Student provides evidence; AI validates findings; output is a defensible market assessment.

**Philosophical Shift from Previous Version:**
- Old: "How intense is the pain? Rate 1-5."
- New: "Show me your evidence that pain is real. Cite conversations, data, competitor reviews, market research."

---

## 2. PREREQUISITES

This scorecard builds on upstream data. Do not administer until student has completed:

| Prerequisite | Provides | Used In |
|--------------|----------|---------|
| **SC1: Project Definition** | Niche, sub-market, positioning, geography, product scope | Sections C, D (MENA context) |
| **SC2: ICP Clarity** | Pain statements, congregation points, budget range, buying behavior | Sections A, B, C (all evidence) |

**Pre-Admin Checklist:**
- Display SC1 outputs (niche, positioning, geography, ICP)
- Display SC2 outputs (pain statements, congregation points, budget range)
- Ask student: "Are these still accurate? Any updates?"
- Note any updates; flag for cross-scorecard consistency review

---

## 3. SECTION ARCHITECTURE

| Section | Points | Questions | Duration | Focus |
|---------|--------|-----------|----------|-------|
| **A. Pain Reality & Intensity** | 25 | 5 (4 FT, 1 MC×3) | 15 min | Evidence of real, frequent, costly, urgent pain |
| **B. Purchasing Power & Willingness** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Budget authority, payment capability, willingness signals |
| **C. ICP Accessibility** | 25 | 5 (4 FT, 1 MC+FT) | 15 min | Congregation density, reach, channels, competitor gaps |
| **D. Market Growth & Momentum** | 25 | 5 (3 FT, 2 MC+FT) | 15 min | Direction, tailwinds, funding, demand, MENA readiness |
| **TOTAL** | **100** | **25** | **60 min** | |

### Score Bands

| Range | Band | Meaning | Risk | Action |
|-------|------|---------|------|--------|
| **85-100** | LAUNCH READY | Strong evidence across all dimensions | Low | Execute GTM; move to SC5 |
| **70-84** | ALMOST THERE | Solid core appeal; 1-2 sections need validation | Low-Med | Fix weakest section; re-score; confirm |
| **55-69** | NEEDS WORK | Right direction but significant gaps | Medium | 30-day validation plan required |
| **40-54** | EARLY STAGE | Fundamental validation needed | Med-High | 10+ buyer interviews before GTM |
| **0-39** | RESET | Core assumptions likely wrong | High | Revisit SC1/SC2; consider pivot |

---

## 4. SECTION A: PAIN REALITY & INTENSITY (25 POINTS)

**Goal:** Validate that SC2 pains are real, frequent, costly, and urgent through evidence, not speculation.

### A1. Pain Evidence Strength (5 pts)
**Type:** Free-text, 150-word limit
**Question:**
> From your ICP pain statements (listed from SC2), which THREE pains have the STRONGEST evidence of being real? For each pain, cite your evidence: customer conversations, competitor reviews, market data, case studies, or observable behavior.

**Display:** Show SC2 pain statements as reference. Provide example: "Pain: 'Invoice reconciliation wastes 15 hours/week.' Evidence: 4 finance managers confirmed; competitor reviews mention 'time-saving' (500+ FreshBooks reviews); ZATCA mandate forces e-invoicing."

**AI Scoring Rubric:**

| Score | Criteria | What AI Checks |
|-------|----------|---|
| 0 | Blank or off-topic | Did not attempt |
| 1 | Assertion only ("I think") | No evidence cited; pure speculation |
| 2 | Generic evidence | Vague sources ("asked people"); no names, numbers, or quotes |
| 3 | Partial evidence | 2 types for 1 pain OR 1 type for 2 pains; some specificity |
| 4 | Strong evidence | 2+ types per pain for ≥2 pains; named sources; numbers cited |
| 5 | Expert evidence | 3+ types per pain across all 3 pains; could use in pitch deck |

**Evaluation Process:**
1. Extract 3 pains mentioned; verify they match SC2 pain statements
2. For each pain, count distinct evidence types (conversations, data, competitive, research, regulatory)
3. Assess specificity: Named people/companies (high) vs. generic sources (low)
4. Check consistency with SC2 pain map
5. Award: (Diversity × 0.5) + (Specificity × 0.3) + (Consistency × 0.2)

**Improvement (if <4):**
- Score 0-2: "Schedule 3 buyer conversations THIS WEEK. Ask: 'How does this pain show up for you?' Document stories, not yes/no."
- Score 2-3: "For #1 pain, gather 3 sources: (1) conversation quote, (2) competitive evidence, (3) data point. Name and number everything."
- Score 3-4: "Add one more evidence type per pain. Check Google Trends, LinkedIn, competitor support forums."

**Time to Fix:** 2-5 hours (conversations + research)

---

### A2. Pain Frequency (5 pts)
**Type:** Multiple Choice × 3 (one per pain)
**Question:** How often does **[Pain from A1]** occur for your buyer?

**Options:**
- Multiple times daily (5 pts)
- Daily (4 pts)
- Weekly (3 pts)
- Monthly (2 pts)
- Quarterly or less (1 pt)

**Scoring:** Average of 3 pain frequencies. Deterministic (no interpretation).

**Consistency Check:** If pain cost (A3) is high but frequency is quarterly, flag (possible high-impact rare events). Ask for clarification; don't penalize if explained.

**Improvement (if score <3):**
> "Your frequency average is low. Either: (1) Find daily/weekly pains, OR (2) Show how infrequent pains compound. Example: 'Quarterly audit failure × 4/year × 30 hours = 120 hours/year = 2.5 weeks.'"

**Time to Fix:** 30 minutes (reframe or pivot pain)

---

### A3. Pain Cost (5 pts)
**Type:** Free-text, 100-word limit
**Question:** Quantify the cost of your #1 pain per month. Show your math.

**Display Example:** "Pain: Manual invoice reconciliation. Cost: 4 finance staff × 15 hours/week ÷ 4 = 15 hours/month × $50/hour = $750/month. Plus: 2 errors/month × $200 audit cost = $400/month. Total: $1,150/month."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | No quantification ("very expensive") |
| 1 | Partial math (incomplete or unclear formula) |
| 2 | Rough estimate (math valid but arbitrary numbers) |
| 3 | Reasonable math (realistic unit costs; misses 1 cost type) |
| 4 | Sharp calculation (multiple cost types; all clear; realistic) |
| 5 | Expert (comprehensive model; sensitivity analysis; investor-grade) |

**Evaluation Process:**
1. Extract and verify math (hours × rate = cost)
2. Check unit realism ($30-150/hour for labor is realistic; $50-1K per error typical)
3. Assess completeness (labor + error + opportunity cost)
4. MENA adjustment: Egypt/Jordan labor may be $20-40/hour; validate consistency
5. Award: (Math × 0.4) + (Unit Realism × 0.35) + (Completeness × 0.25)

**Improvement (if <4):**
- Score 0-2: "Pick ONE cost driver and calculate it. If 10 hours/week × $50/hour = $2,000/month. That's your baseline."
- Score 2-3: "Add missing costs: errors/rework + opportunity cost. Include all cost types."
- Score 3-4: "Validate unit costs with a buyer: 'Is $50/hour loaded cost right for your team?'"

**Time to Fix:** 1-2 hours (research + math)

---

### A4. Workaround Assessment (5 pts)
**Type:** Free-text, 150-word limit
**Question:** What are buyers doing TODAY to manage this pain? List tools, processes, workarounds. How broken are they?

**Display Example:** "Workarounds: (1) Manual spreadsheet INDEX/MATCH (errors if format changes), (2) Temp staff hiring (expensive, turnover loss), (3) Quarterly audits (reactive, errors found too late). Failures: Formula breaks → hidden errors → audit discovers massive backlog → expensive rework."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | No answer |
| 1 | "Not doing anything" (unaware of buyer behavior) |
| 2 | Generic ("spreadsheets and manual processes") |
| 3 | Named tools ("Excel, Zapier, manual emails") with basic failures |
| 4 | Tools + specific failures ("formula breaks if format changes"; "hiring delays") |
| 5 | Comprehensive failure map with failure chains and buyer frustration clear |

**Evaluation Process:**
1. Extract named tools/processes
2. Count distinct failure points (errors, delays, cost, hiring friction, knowledge loss)
3. Assess specificity: "INDEX/MATCH breaks" (specific) vs. "it's slow" (generic)
4. Check consistency: Do workarounds match pain statement?
5. Award: (Tool Specificity × 0.4) + (Failure Count × 0.3) + (Articulation × 0.3)

**Improvement (if <4):**
- Score 0-2: "Interview 3 ICPs. Ask: 'Walk me through how you handle this today. What breaks?' Take notes."
- Score 2-3: "You know tools; now know failures. Ask: 'What bugs you about this? When has it failed?'"
- Score 3-4: "Deepen failure analysis. Ask: 'Why do you keep using this despite problems?' Answer = your moat."

**Time to Fix:** 2-3 hours (interviews)

---

### A5. Pain Urgency Signal (5 pts)
**Type:** Free-text, 100-word limit
**Question:** If you pitched tomorrow, what timeline would buyer want? (week/month/quarter/someday) What evidence supports it?

**Display Example:** "Urgency: This month. Evidence: (1) ZATCA mandate effective next month; (2) CFO said 'We need solution before month-end'; (3) Budget allocated in Q; (4) Competitor launched. Multiple external pressures = HIGH urgency."

**AI Scoring Rubric:**

| Score | Criteria | Signal Type |
|-------|----------|---|
| 0 | Blank | N/A |
| 1 | Wishful thinking ("want it ASAP"; no evidence) | Hope, not reality |
| 2 | Logical assumption (reasonable guess; unvalidated) | Internal logic only |
| 3 | Some signals (1-2 present; budget allocated, timeline mentioned) | Beginning of urgency |
| 4 | Strong signals (2-3: regulatory + budget + competitive) | Multiple pressure points |
| 5 | Validated urgency (3+ signals; direct buyer statement; external deadlines) | Investment-grade |

**Signal Hierarchy:** Regulatory deadline > Competitive pressure > Budget deadline > Operational crisis > Seasonal > Buyer statement > Aspiration

**Evaluation Process:**
1. Extract claimed timeline (week/month/quarter/someday)
2. Count distinct signals; categorize by hierarchy
3. Assess evidence quality: Direct quote (high) > Assumption (low)
4. Check consistency: Does timeline match evidence?
5. Award: (Timeline Realism × 0.3) + (Signal Count × 0.4) + (Evidence Quality × 0.3)

**Improvement (if <4):**
- Score 0-2: "Ask ICP: 'When would you need this? What makes that timeline urgent?' Find external pressure: regulation, competitor, budget deadline, crisis."
- Score 2-3: "Find one external signal. Verify its date. Is regulatory deadline in writing? Is budget allocation confirmed?"
- Score 3-4: "Ask: 'What happens if you DON'T solve this by [timeline]?' Their answer = cost of inaction."

**Time to Fix:** 1-2 hours (buyer conversation)

**Section A Total:** A1+A2+A3+A4+A5 = 0-25 pts

---

## 5. SECTION B: PURCHASING POWER & WILLINGNESS (25 POINTS)

**Goal:** Validate that ICP has budget and will pay.

### B1. Existing Spend (5 pts)
**Type:** Free-text, 100-word limit
**Question:** What are buyers CURRENTLY PAYING for related problems? List tools/services and monthly spend.

**Display Example:** "Current spend: (1) QuickBooks: $25/month; (2) Zapier: $99/month; (3) Freelance accountant: $300/month; (4) Internal labor: 40 hours × $50/hour = $2,000/month. Total: $2,424/month."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank or "I don't know" |
| 1 | Generic ("accounting software"; no names, prices) |
| 2 | Some specificity (1-2 tools; vague pricing) |
| 3 | Specific tools (3+ named; prices; may miss labor) |
| 4 | Sharp spend map (named tools + prices; includes labor cost) |
| 5 | Expert (complete spend; hidden costs; purchasing precedent clear) |

**Evaluation Process:**
1. Extract named tools; count pricing data points
2. Assess completeness (tools + services + labor + vendors)
3. Verify realism (QuickBooks $25-300/month is realistic; $5K/month is not)
4. Check consistency with pain cost (A3): Should be in same ballpark
5. Award: (Tool Specificity × 0.35) + (Price Completeness × 0.35) + (Labor Inclusion × 0.3)

**Improvement (if <4):**
- Score 0-2: "Interview 3 ICPs: 'What tools do you use for [problem]? What's the monthly cost?' Get vendor names and actual prices."
- Score 2-3: "Add pricing. Google vendor prices. Ask: 'Do you pay for freelance help?' Include labor cost."
- Score 3-4: "Good map. Validate: Ask 'How much do you spend per month on [problem]?' Your estimate should align."

**Time to Fix:** 1-2 hours (interviews + web research)

---

### B2. Budget Authority (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** Who controls the budget for your solution?
- User/manager themselves (2 pts)
- User + 1 approver (2 pts)
- Department head (1.5 pts)
- C-suite (1 pt)
- Committee (1 pt)

**Free-text (75 words):** Describe the budget decision process. Who proposes? Who approves? Timeline? Thresholds?

**Display Example:** "Finance Manager proposes to Finance Director. Director approves if <$500/month + ROI >3x within 1 week. If >$500/month, needs CFO (4 weeks). Our price: $150/month → Director approval → 1-week sales cycle."

**Free-text Scoring (0-3):**
| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Generic ("they need approval") |
| 2 | Partial (decision-maker named; missing timeline/thresholds) |
| 3 | Sharp (decision-maker + timeline + thresholds + connection to sales cycle) |

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Extract MC (simplicity score): simpler = higher score
2. Extract free-text details (decision-maker, timeline, thresholds)
3. Check consistency: Does ACV from SC1 fit within decision threshold?
4. Flag if ACV exceeds threshold (longer sales cycle)
5. Award: (MC × 0.4) + (Free-text Quality × 0.6)

**Improvement (if <3):**
> "Interview decision-maker: 'If you wanted to buy [solution] at $[price]/month, how would approval work? Who would you ask? How long?' Document exact process and timeline."

**Time to Fix:** 1-2 hours (buyer interview)

---

### B3. Price Point Validation (5 pts)
**Type:** Free-text, 100-word limit
**Question:** What price are you charging? Compare to: (a) pain cost, (b) alternative spend, (c) ROI delivered. Does it pass the no-brainer test?

**Display Example:** "Price: $199/month. (a) Pain cost $1,150/month; price is 17% of pain. (b) Alternatives $2,424/month; price is 8% of alternatives. (c) ROI: Customer pays $2,388/year; saves $13,800/year; ROI = 5.8x. Verdict: Clear no-brainer; customer saves $2,225/month net."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | No price |
| 1 | Price only (no comparison) |
| 2 | Partial logic (ONE benchmark; missing others) |
| 3 | Two comparisons (clear but incomplete) |
| 4 | Three comparisons (clear "no brainer" calc) |
| 5 | Expert model (all 3 comparisons + sensitivity analysis) |

**Evaluation Process:**
1. Extract price; normalize to $/month
2. Validate vs. pain cost (A3): Price < 50% pain cost = good; < 25% = strong
3. Validate vs. alternatives (B1): Price < 25% = good
4. Calculate ROI: Annual cost vs. annual savings; aim for 3x+ minimum
5. Check math accuracy
6. Award: (Pain Comparison × 0.27) + (Alternative Comparison × 0.27) + (ROI × 0.26) + (Clarity × 0.2)

**Improvement (if <4):**
- Score 0-2: "Use formula: Pain cost × 30-40% = entry price. Example: $1,150 × 35% = $400/month."
- Score 2-3: "All 3 benchmarks required. Calculate ROI: (Annual savings) ÷ (Annual cost) = ROI multiple. Aim for 3x+"
- Score 3-4: "Stress-test with buyer: 'Would you pay $[price] to save $[pain]?' Their reaction tells you if realistic."

**Time to Fix:** 1-2 hours (modeling + validation)

---

**### EXPERT FRAMEWORK ADDITION: Pricing Framework Cross-Check (B3 Enhancement)**

**During B3 Evaluation, Claude performs automated cross-checks:**

This check validates founder's pricing against three data sources for consistency. Flag any inconsistency >50%.

**CROSS-CHECK 1: Pain Frequency × Pain Cost**
- Source: A2 (pain frequency) + A3 (pain cost)
- Check: Does stated price align with pain frequency and cost?
- Formula: If pain is daily ($X/month cost), pricing should be 20-40% of $X/month
- Example: Daily pain costing $1,000/month → price should be $200-400/month (not $50/month)
- If inconsistency >50%: "Your pain occurs [frequency] and costs $[A3]/month, but price is $[B3]. For [frequency] pain, 20-40% ratio suggests $[calculated range]. Discrepancy = [%]. Validate: Are you underpricing? Or is pain cost overstated?"

**CROSS-CHECK 2: Competitor Pricing (from SC1 positioning)**
- Source: SC1 competitor pricing data
- Check: How does founder's price compare to named competitors?
- Acceptable range: ±30% of competitor average (allows for differentiation)
- If inconsistency >50%: "You priced at $[stated], but [Competitor A] charges $[comp A], [Competitor B] charges $[comp B]. Average: $[avg]. You're [%] below market. Validate: (1) Are you solving different problem? (2) Is this intentional undercutting? (3) Missing value communication? Consider raising to market-aligned price if solving same problem."

**CROSS-CHECK 3: ICP Budget Range (from SC2)**
- Source: SC2 budget range + purchasing power signals from B1-B2
- Check: Does stated price fit within ICP's stated budget or typical allocation?
- Formula: ICP budget from SC2 × typical allocation % = acceptable price range
- Example: ICP budget $5K/month, typical SaaS allocation 10-20% = $500-1K acceptable
- If inconsistency >50%: "SC2 indicated budget of $[SC2 budget], but B3 price is $[stated]. If $[stated] is [%] of their budget allocation, validate with budget-holder: 'Of your $[budget] monthly allocation, how much goes to [category]?'"

**FLAGGING LOGIC:**
IF (stated price vs. implied price from A2+A3 = >50% gap)
AND (stated price vs. SC1 competitors = >50% gap)
AND (stated price vs. SC2 budget = >50% gap)
→ FIRE HIGH-PRIORITY RECOMMENDATION: "Pricing shows significant inconsistencies across three frameworks. Before GTM, stress-test with 3 ICPs: 'Would you pay $[competitor avg price]?' If yes, raise price. Underpricing early stage is costly."

---

### B4. Payment Infrastructure (5 pts)
**Type:** Multiple Choice (MENA-specific context)
**Question:** How will buyers pay?

**Options & Base Scoring:**
- Credit card online (5 pts)
- Bank transfer (5 pts)
- Mobile wallets (Apple Pay, STC Pay, Google Pay, etc.) (5 pts)
- BNPL (Tabby, Tamara, etc.) (4 pts)
- Mixed/multiple (5 pts)
- Cash/check (2 pts)
- Unknown (0 pts)

**MENA Adjustments:** If "Credit card only" in Egypt/Jordan/Lebanon/Morocco: Deduct 1 pt (credit card adoption <40%; should add bank transfer or BNPL).

**Display:** Show MENA context. "Saudi: Credit card adoption 65%; mobile wallet 90%. Egypt: Credit card 30%; WhatsApp Pay adoption emerging. Offer 2-3 methods to maximize conversion."

**Improvement (if <5):**
- If credit card only (Egypt/Jordan): "Add bank transfer (primary) + BNPL secondary. Increases conversion significantly."
- If Unknown: "Ask ICP: 'How do you prefer to pay for SaaS? Credit card, bank transfer, BNPL?' Their answer guides your infrastructure."

**Time to Fix:** 30 minutes (research + setup)

---

### B5. Willingness Signal (5 pts)
**Type:** Free-text, 100-word limit
**Question:** What is the STRONGEST signal that someone would PAY? (pre-orders, verbal commits, LOIs, pilots, competitor revenue, market research)

**Display Example:** "Signal: Signed LOI with [Company] for $2K/month pilot. CTO: 'This is exactly what we need; we can start [month].' Also: 8 people on waitlist said 'I'd pay $200-300/month.' LOI is strongest signal."

**AI Scoring Rubric:**

| Score | Signal Type | Criteria |
|-------|---|---|
| 0 | No signal | Blank |
| 1 | Aspirational | "I think people would pay" (no evidence) |
| 2 | Behavioral | Waitlist, email signups, free trial (intent; no commitment) |
| 3 | Verbal | "Buyer said they'd pay" (named, stated, but no signature) |
| 4 | Signed | Signed LOI, paid pilot, pre-order agreement |
| 5 | Executed | Paid pilot in progress, pre-orders collected, competitor revenue data |

**Hierarchy:** Executed Payment > Signed Commitment > Verbal > Behavioral > Aspirational

**Evaluation Process:**
1. Identify signal type; map to hierarchy
2. Assess specificity: Named buyer (high) vs. generic (low)
3. Verify commitment level: Money down > Signature > Verbal > Behavioral > Aspirational
4. Check consistency with urgency (A5)
5. Award: (Signal Type × 0.4) + (Specificity × 0.3) + (Commitment Level × 0.3)

**Improvement (if <4):**
- Score 0-2: "Go get a willingness signal. Contact 5 ICPs; ask 'Would you pay $[price] for this?' Get 2-3 explicit yes answers. Document names."
- Score 2-3: "Convert waitlist → pilot. Offer 50% off if they commit to $500 pilot in 30 days."
- Score 3-4: "Turn verbal → signed. Send one-page LOI: '[Company] agrees to pilot [solution] for $[price] from [date] to [date].' Get signature."

**Time to Fix:** 1-3 weeks (outreach + pilot closure)

### EXPERT FRAMEWORK ADDITION: Underpricing Detection

**Triggered During B3 Review & B1 Comparison**

After founder provides pricing (B3) and existing spend (B1), Claude applies Alex Hormozi's principle: "95% of businesses underprice." This evaluation specifically identifies underpricing signals.

**UNDERPRICING DETECTION CHECKLIST:**

**Signal (a): Competitor Pricing Gap**
- Founder says: "$X/month" (stated price from B3)
- SC1 positioning analysis shows: Competitors charge 3-5x more
- ACTION: Compare B3 stated price against SC1 competitor pricing matrix
- RED FLAG: If price is >50% below competitor average for same problem size
- RECOMMENDATION: "Your price ($X) is 60% below [Competitor A] ($Y). Given pain severity (A3: $[pain/month]), consider: (1) Are you solving different problem? (2) Intentional underpricing to gain market? (3) Missing value communication? Validate pricing assumption with 3 ICPs: 'Would you pay $[competitor price]?'"

**Signal (b): B2B Pricing-to-Pain Mismatch**
- Founder says: "$X/month" (B3 stated price)
- Pain cost from A3 is: >$1,000/month
- Stated price is: <$50/month
- RED FLAG: Price <5% of annual pain cost suggests underpricing for B2B
- RULE OF THUMB: B2B pricing should be 20-40% of pain cost; <10% signals underpricing
- RECOMMENDATION: "Pain cost is $[A3] but price is $X/month. Pain-to-price ratio is [ratio]%. For B2B, 20-40% is standard. You're at [ratio]%, suggesting potential underpricing. Test pricing: 'If we charged 2x, would you still buy?' Their reaction indicates true price ceiling."

**Signal (c): Pain Frequency-Pricing Disconnect**
- Pain frequency from A2: Daily (or multiple times daily)
- Pricing model from B3: Annual subscription OR quarterly
- RED FLAG: Daily pain should map to monthly billing (not annual)
- LOGIC: High-frequency pains require frequent payment reminder; annual billing masks true cost
- RECOMMENDATION: "Your pain occurs daily but price is annual. This may underprice perceived value. CONSIDER: Switch to monthly billing to increase perceived value and price. Daily pain justifies $X/month rather than $[annual/12]/month."

**Signal (d): Founder Rationalization**
- Founder statement heard: "I need to be cheaper to compete" OR "Price doesn't matter; volume does" OR "We'll raise it later"
- RED FLAG: This is classic underpricing rationalization (Alex Hormozi warning)
- RECOMMENDATION: "This thinking leads to margin death. You say '[rationalization].' Instead: (1) Find non-price differentiation, (2) Target segment with higher willingness-to-pay, (3) Bundle additional value, (4) Raise price BEFORE GTM (harder after). Price first; then acquire customers at sustainable unit economics."

**SCORING IMPACT:**
- Signal detected = No points deducted from B3 (student may have valid reason)
- BUT: Trigger recommendation that appears in output RECOMMENDATIONS section (high priority)
- FRAMING: "Not a weakness; an opportunity to capture more value aligned with market reality"

---

### EXPERT FRAMEWORK ADDITION: Pricing Framework Cross-Check

**Triggered After B3 & B5 Completion**

After the founder completes B3 (Price Point Validation) and B5 (Willingness Signal), Claude evaluates the offer structure using Alex Hormozi's Grand Slam formula:

**GRAND SLAM OFFER CHECK:**
Based on pain evidence (Section A) and purchasing power (Section B), evaluate:

1. **Dream Outcome Score:** How transformative is this solution? (Scale: Modest improvement vs. Life-changing)
   - Extract from: A3 pain cost + B3 ROI calculation
   - Score high if: ROI >5x AND pain cost >$1K/month AND pain affects revenue directly
   - Score low if: ROI <2x OR pain is operational convenience

2. **Perceived Likelihood:** How credible is the value delivery claim given available evidence?
   - Extract from: A1 evidence strength + B5 willingness proof
   - Score high if: Expert evidence (A1=5) + Signed commitments (B5≥4)
   - Score low if: Assertion evidence (A1<3) + Only aspirational signals (B5<2)

3. **Time Delay:** How fast can value be delivered?
   - Extract from: A5 urgency signals + B2 budget process
   - Score high if: Sales cycle <4 weeks (urgency + simple approval)
   - Score low if: Sales cycle >8 weeks (complex approval + implementation lag)

4. **Effort & Sacrifice:** How easy is it for buyer to switch/adopt?
   - Extract from: A4 workaround brittleness + B1 existing spend
   - Score high if: Current workarounds failing badly + low switching cost (<20% of pain)
   - Score low if: Workarounds functional + switching cost >50% of pain

**CALCULATION:**
```
Viability Index = (Dream × Likelihood) / (Delay × Effort)
IF Viability Index < 2.0 → FLAG: "Weak offer structure"
IF Viability Index 2.0-3.5 → CAUTION: "Moderately strong offer"
IF Viability Index > 3.5 → STRONG: "High-probability offer"
```

**RECOMMENDATION TRIGGER:**
If Viability Index <2.0, fire this recommendation:
> "Your offer structure may be underpowered. While market validation is present, either: (1) Dream outcome is modest (pain cost too small or ROI weak), (2) Buyer confidence is low (evidence is weak), (3) Sales cycle is long (urgency or approval friction), or (4) Switching cost is high.
>
> TO STRENGTHEN: (a) Increase Dream by expanding value capture (find additional pain relief beyond core pain), (b) Build Likelihood with proof (get signed pilot or LOI), (c) Compress Delay by streamlining approval (negotiate with budget authority), (d) Reduce Effort by offering migration support or phased rollout.
>
> CONSIDER REDESIGNING VALUE PROPOSITION before GTM if Viability <2.0."

**Section B Total:** B1+B2+B3+B4+B5 = 0-25 pts

---

## 6. SECTION C: ICP ACCESSIBILITY (25 POINTS)

**Goal:** Validate that you can actually reach your ICP.

### C1. Congregation Density (5 pts)
**Type:** Free-text, 100-word limit
**Question:** From SC2 congregation points, which has HIGHEST density of exact buyers? How many are there?

**Display Example:** "Top point: LinkedIn Finance Mgr group. Estimated: 5K group members; 2K mid-market companies (ACV sweet spot); 500-1K exact fit by size + industry. Can reach 100 in 30 days via targeted outreach."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Vague ("LinkedIn"; no specific group/location) |
| 2 | Generic ("LinkedIn finance group"; no estimate) |
| 3 | Specific point + rough estimate |
| 4 | Sharp calculation (layered: total → filtered by role → filtered by size → actual fit) |
| 5 | Expert map (multiple points ranked; specific counts; actionable reach) |

**Evaluation Process:**
1. Extract congregation point; verify it matches SC2 points
2. Extract density estimate; check calculation quality
3. Assess layering: Total → Role filter → Size filter → Geography filter = actual ICP fit
4. Award: (Specificity × 0.3) + (Estimation Quality × 0.35) + (Filtering Logic × 0.35)

**Improvement (if <4):**
- Score 0-2: "Name ONE congregation point (LinkedIn group, conference, business club, city). Research its size."
- Score 2-3: "Validate estimate with actual data (LinkedIn group member count, conference attendee list, census data)."
- Score 3-4: "Layer the estimate. Of 5K group members: 20% right role × 40% right size × 50% right industry = 200 prospects."

**Time to Fix:** 2-3 hours (research + filtering)

---

### C2. Reach Capability (5 pts)
**Type:** Free-text, 100-word limit
**Question:** Can you reach 100+ buyers in 30 days with your resources? Describe exactly how.

**Display Example:** "Plan: (1) LinkedIn outbound: 20 messages/week × 4 weeks = 80 reach attempts; 20% response = 16 meetings. 30 min/day. (2) Cold email: 10/week × 4 = 40 attempts; 5% response = 2 meetings. Total: 120 reach attempts, ~18 meetings, 1 hour/day. Achievable."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No path ("I'll use LinkedIn") |
| 2 | Some path (channels named; numbers missing/unrealistic) |
| 3 | Specific path (channels + weekly targets; realistic) |
| 4 | Sharp plan (channels + daily cadence + response rates + time/resources) |
| 5 | Expert model (multiple channels + targets + validated rates + contingency) |

**Evaluation Process:**
1. Extract channels and targets
2. Check realism: LinkedIn 15-20 quality msgs/week/person is realistic; 100+/week is not
3. Verify math: Sum targets; do they reach ~100 in 30 days?
4. Confirm resources: Can stated team do this?
5. Award: (Channel Diversity × 0.2) + (Target Specificity × 0.35) + (Realism × 0.35) + (Resource Clarity × 0.1)

**Improvement (if <3):**
- Score 0-1: "Pick ONE channel. Calculate: 100 people ÷ 30 days = 3.3/day. For LinkedIn: 4 msgs/day × 20-30 min = achievable."
- Score 1-2: "Make specific. 'LinkedIn: 4 msgs/day × 5 days × 4 weeks = 80 msgs. 20% response = 16 replies. 30 min/day = 10 hours total.'"
- Score 2-3: "Stress-test: Can you ACTUALLY do 20 msgs/day while running business? If not, reduce target or phase it."

**Time to Fix:** 2-3 hours (planning + validation)

---

### C3. Channel Viability (5 pts)
**Type:** Multiple Choice (select top 3) + Free-text (2 pts each)

**MC:** Which channels can you realistically use? (Select max 3)
- LinkedIn outbound
- Cold email
- WhatsApp
- Content marketing
- Paid ads
- Events & networking
- SEO
- Referrals
- Community (Slack, Discord, Reddit, forums)
- Partner channels

**Free-text (75 words each, up to 2 questions = 4 pts total):**

For top 3 selections: "Describe your specific capability on [Channel]. Example: 'LinkedIn — 5K connections, mostly [role], in [geography]; I've done 50+ outreach with 15% response rate; 30 min/day; can scale to 200+/month.'"

**Scoring:**

**MC (0-5):**
- 5 pts: 3 channels with strong ICP fit
- 3 pts: 3 viable but lower-fit channels
- 1 pt: 1-2 channels with weak fit
- 0 pts: No fit

**Free-text (0-2 per channel, up to 4 pts):**
| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Vague ("I'll use LinkedIn") |
| 2 | Specific ("5K connections, 15% response rate, 30 min/day") |

**Combined:** MC (0-5) + Free-text (0-4) → normalize to 0-5

**Evaluation Process:**
1. Verify channel selections align with ICP
2. Extract capability specifics (audience, response rate, time)
3. Check for proof (actual experience vs. aspirational)
4. Assess consistency: Does free-text match MC selections?
5. Award: (Channel Fit × 0.35) + (Capability Detail × 0.35) + (Proof × 0.3)

**Improvement (if <4):**
- MC weak fit: "Your channels don't match ICP. [ICP] congregates on [X], not [Y]. Reconsider."
- Free-text vague: "Tell me your actual capability. Numbers: audience size, response rate, time required. Build on real data."
- Proof missing: "Have you tried this channel? Do 20 attempts this week; measure response rate."

**Time to Fix:** 1-2 weeks (validate channels + measure)

---

### C4. Competitor Access Pattern (5 pts)
**Type:** Free-text, 100-word limit
**Question:** How are competitors reaching these buyers? What channels dominate? Where are they weak?

**Display Example:** "Competitors [A, B] dominate LinkedIn (15K followers; weekly posts) and content (SEO-ranked). Absent from: WhatsApp outreach, email list, community engagement. Gap: MENA congregates on WhatsApp; competitors ignore it. Opportunity: Own WhatsApp channel + email list in [geography]."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No awareness ("don't know competitors") |
| 2 | Basic (names competitors; knows 1 channel) |
| 3 | Partial map (2-3 competitors; 1-2 channels each; 1 weakness) |
| 4 | Sharp map (2-3 competitors; channels + metrics; 2+ weaknesses) |
| 5 | Expert (detailed channels + metrics; clear gaps; strategic positioning) |

**Evaluation Process:**
1. Extract named competitors (not generic)
2. Extract channels per competitor
3. Check research quality: Did they actually look at competitors?
4. Identify weaknesses articulated
5. Assess gap identification (strategic opportunity?)
6. Award: (Competitor Specificity × 0.3) + (Channel Coverage × 0.3) + (Weakness × 0.2) + (Gap ID × 0.2)

**Improvement (if <3):**
- Score 0-1: "Spend 30 min per competitor. Visit website, check LinkedIn (followers, posts), search their content (rank for what?), look for email list."
- Score 2: "You know competitors and channels. Identify weaknesses: 'What are they NOT doing? What's missing?'"
- Score 3: "Good map. Deepen weakness analysis: For each competitor, state clearly: 'They're strong on [channel] but weak on [channel].'"

**Time to Fix:** 3-5 hours (research: sites, social, SEO, reviews)

---

### C5. MENA Access Reality (5 pts)
**Type:** Free-text, 100-word limit
**Question:** For your MENA geography (SC1), what's realistic channel mix? Account for: Arabic vs. English, WhatsApp vs. email, LinkedIn penetration, event culture, mobile-first.

**Display Examples:**

**Saudi:** "Saudi finance managers: 65% LinkedIn (high); 90% WhatsApp (primary); 40% email (secondary); 25% conferences. Strategy: 35% LinkedIn, 40% WhatsApp, 15% email, 10% events. Arabic preference growing."

**Egypt:** "Egypt SME owners: 35% LinkedIn (lower); 95% WhatsApp (primary); 15% email (low); 10% conferences. Strategy: 50% WhatsApp, 35% LinkedIn, 10% email, 5% in-person. All content in Arabic."

**MENA Channel Reference Table:**

| Country | LinkedIn | WhatsApp | Email | Events | Language |
|---------|----------|----------|-------|--------|----------|
| Saudi | 65-70% | 90%+ | 40-50% | Medium | Arabic growing |
| UAE | 75%+ | 95%+ | 60% | High | Mixed |
| Qatar | 70% | 95%+ | 60% | Medium | Mixed |
| Egypt | 35-45% | 95%+ | 15-25% | Low | Arabic |
| Jordan | 45-50% | 95%+ | 20-30% | Low | Arabic |
| Lebanon | 45-50% | 95%+ | 20-30% | Low | Arabic |
| Morocco | 45% | 90%+ | 15-20% | Low | Arabic/French |

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Western assumptions ("email and LinkedIn standard"; no MENA adaptation) |
| 2 | Surface awareness ("MENA uses WhatsApp more"; vague) |
| 3 | Some context (2-3 MENA factors mentioned; partial channel mix) |
| 4 | Sharp strategy (3-4 factors; channel % provided; language clear) |
| 5 | Expert (detailed mix by geography; language strategy; local competitive advantage identified) |

**Evaluation Process:**
1. Extract geography (from SC1)
2. Identify MENA factors mentioned (language, WhatsApp, LinkedIn, email, events, mobile)
3. Compare student's channel mix to baseline table (unrealistic mix = flag)
4. Assess language strategy (Arabic/English/mixed)
5. Assess local competitive positioning
6. Award: (Factors Mentioned × 0.3) + (Channel Mix Realism × 0.35) + (Language × 0.2) + (Competitive Position × 0.15)

**Improvement (if <3):**
- Score 0-1: "Research [country]'s communication norms. Google '[country] business communication preferences.' Ask 2 local founders: 'How do you reach customers here? What channels work?'"
- Score 2: "You know WhatsApp is important; expand. What about LinkedIn adoption? Email culture? Events? For [country], provide realistic percentages."
- Score 3: "Good MENA awareness. Add language strategy. Will you do Arabic outreach? How will this affect response rates?"

**Time to Fix:** 2-3 hours (research + local conversations)

**Section C Total:** C1+C2+C3+C4+C5 = 0-25 pts

---

## 7. SECTION D: MARKET GROWTH & MOMENTUM (25 POINTS)

**Goal:** Validate that market is growing and has external tailwinds.

### D1. Market Direction (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** What is the overall direction of your market?
- Rapidly growing (>30% YoY) (2 pts)
- Growing (10-30% YoY) (2 pts)
- Stable (0-10% YoY) (1.5 pts)
- Declining (<0% YoY) (0.5 pts)
- Don't know (0 pts) → Triggers recommendation to research

**Free-text (75 words):** What evidence supports this? (Analyst reports, company funding, revenue growth, customer growth, market research)

**Display Example:** "Market direction: Growing (15-25% YoY). Evidence: (1) Gartner 2026 report projects [market] at 18% CAGR through 2030. (2) 5 funded competitors in last 18 months ($15M total); only 2 competitors existed 2 years ago. (3) Google Trends shows [keyword] search volume up 35% YoY. = Growing market."

**Free-text Scoring (0-3):**
| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Assumption ("market is growing"; no evidence) |
| 2 | Generic ("I read [market] is growing"; no source/numbers) |
| 3 | Sharp ("Gartner 2026 report: 18% CAGR through 2030"; specific numbers) |

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to growth category
2. Extract free-text sources: Analyst firms (Gartner, McKinsey, Statista) + competitor funding + customer growth
3. Assess evidence quality: Named firm + report year + numbers (highest) vs. generic opinion (lowest)
4. Verify consistency: Does free-text match MC? (If MC says "rapidly growing," evidence should show 30%+ growth)
5. Award: (MC × 0.4) + (Free-text Quality × 0.6)

**Improvement (if <3):**
- Score 0-1: "Research market growth. Google '[market] market size 2024 2025 2026 growth rate.' Find specific number. Spend 1 hour."
- Score 2: "You have direction but weak evidence. Find named analyst source (Gartner, Statista, IBISWorld) OR competitor funding data."
- Score "Don't know": "Research TODAY: (1) Google Trends '[market keyword]' (1-year trend up/down?), (2) Statista '[market] forecasts,' (3) Crunchbase '[market]' funding. Come back with direction + numbers."

**Time to Fix:** 1-2 hours (research)

---

### D2. Tailwind Events (5 pts)
**Type:** Free-text, 150-word limit
**Question:** List regulatory, technology, cultural, or economic shifts PUSHING buyers toward solutions like yours. Examples: Vision 2030, ZATCA, GDPR, labor cost inflation, remote work, AI integration.

**Display Example:** "Tailwinds: (1) ZATCA e-invoicing mandate effective [month] → forces modernization. (2) Saudi labor cost inflation 12% YoY → companies automating to reduce headcount. (3) Cloud adoption 40% CAGR → companies shifting from on-premise. (4) AI integration requirements → want AI-powered insights. All = EXTERNAL pressure pushing toward automation solutions."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No tailwinds ("don't know any") OR only generic ("technology advancing") |
| 2 | Generic tailwinds (1 trend; no specificity/dates) |
| 3 | Some specific (2 tailwinds named; missing dates/impact) |
| 4 | Sharp (2-3 specific + dated tailwinds; clear buyer urgency connection) |
| 5 | Expert (3+ specific tailwinds; dates; magnitude; strategic interpretation) |

**Evaluation Process:**
1. Extract tailwind types (regulatory, economic, technology, cultural, competitive)
2. Assess specificity: "ZATCA e-invoicing effective June 2026" (specific) vs. "digitization happening" (vague)
3. Verify realism: Are dates correct?
4. Assess relevance: Does tailwind push toward student's solution? (Direct = strong; tangential = weak)
5. Assess magnitude: How many buyers affected? (Regulatory affecting ALL companies in jurisdiction = highest)
6. Award: (Tailwind Count × 0.35) + (Specificity × 0.35) + (Solution Relevance × 0.3)

**Improvement (if <2):**
- Score 0-1: "Brainstorm tailwinds. What regulatory changes, cost pressures, or technology shifts affect your market in [geography]? Find 2-3 specific examples."
- Score 2: "Be specific. Instead of 'digitization happening,' name regulation (ZATCA, Vision 2030, data law). Instead of 'costs rising,' state: 'Labor inflation 8% YoY.'"

**Time to Fix:** 2-3 hours (research)

---

### D3. Competitive Landscape (5 pts)
**Type:** Free-text, 150-word limit
**Question:** Is money flowing into your space? Name funded competitors (Series A+, recent seed), acquisitions. What does this tell you about viability?

**Display Example:** "Funding: [Competitor A] $8M Series B (Q4 2025); [Competitor B] $1.5M seed (Q2 2025); [Competitor C] acquired by [acquirer] for ~$10-20M (2024). Signal: VCs fund this space = investor confidence. Exits exist = acquisition pathways. Buyers pay = revenue-generating. Space is competitive + validated. My differentiation: [specific advantage]."

**AI Scoring Rubric:**

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No awareness ("don't know competitors") |
| 2 | Names competitors (no funding/acquisition data) |
| 3 | Partial funding (2 competitors + some funding; may lack acquisition/interpretation) |
| 4 | Sharp funding (2-3 competitors + amounts + stages; clear viability signal) |
| 5 | Expert (3+ funded competitors + amounts + dates; acquisition data; market viability clear) |

**Evaluation Process:**
1. Extract competitor names (not generic)
2. Extract funding data (round, amount, date)
3. Extract acquisition data
4. Assess competitiveness: Multiple funded = validation + high competition; none funded = unvalidated
5. Check strategic interpretation: Does student understand what funding means?
6. Award: (Competitor Specificity × 0.25) + (Funding Completeness × 0.35) + (Acquisition × 0.15) + (Interpretation × 0.25)

**Improvement (if <3):**
- Score 0-2: "Find 2-3 competitors. Use Crunchbase, LinkedIn, Google. For each: founding date, funding rounds, acquisition history."
- Score 2-3: "You have competitors. Research their funding. How much? What stage? When? Check Crunchbase, news, company websites."
- Score 3-4: "Good funding data. Add interpretation. What does [Competitor A]'s Series B mean for the market? Demand? Exit path? Competition intensity?"

**Time to Fix:** 2-3 hours (Crunchbase + research)

---

### D4. Search Demand Signal (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** Is search demand for your solution type increasing?
- Strongly up (>20% YoY) (2 pts)
- Slightly up (5-20% YoY) (1.5 pts)
- Flat (0-5% YoY) (1 pt)
- Down (<0% YoY) (0 pts)
- Don't know (0 pts) → Triggers recommendation

**Free-text (75 words):** What did you check? Which keywords? Tools used? Timeframe?

**Display Example:** "Search demand: Slightly up. I checked Google Trends for '[keyword 1],' '[keyword 2],' '[keyword 3]' from March 2025 to March 2026. Keyword 1 up 25% YoY; Keyword 2 flat; Keyword 3 up 15% YoY. Average = 10-15% growth. Confirmed via Keyword Tool: '[keyword]' has 2,300 monthly searches (up from 1,900 last year)."

**Free-text Scoring (0-3):**
| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No research ("I think demand is up") |
| 2 | Generic ("I checked Google Trends"; no keywords/timeframe) |
| 3 | Sharp ("Checked '[keyword]' March 2025-2026; volume up 25% YoY") |

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to demand category
2. Extract free-text research: Tools (Google Trends, Keyword Tool, Semrush) + keywords + timeframe
3. Verify methodology quality: Named tool + specific keywords + timeframe + numbers (highest) vs. generic (lowest)
4. Check consistency: Does free-text match MC?
5. Award: (MC × 0.4) + (Free-text Quality × 0.6)

**Improvement (if <3):**
- Score 0-1: "Go to Google Trends NOW. Search '[your solution type] [geography].' Check if 30-day trend is up or down. Return with direction."
- Score 2: "You checked something; add data. Google Trends '[keyword 1]' and '[keyword 2].' Report: Search volume X/month, up Y% YoY."
- Score "Don't know": "TODAY: (1) Google Trends: Search '[specific keyword suggestions]'; check 1-year trend. (2) Keyword Tool: Check monthly volume. Come back with direction + numbers."

**Time to Fix:** 30 minutes (Google Trends)

---

### D5. MENA Market Readiness (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** How ready is your MENA market for this solution?
- Already buying (established category, known solutions) (2 pts)
- Aware not buying (knowledge gap or price barrier) (1.5 pts)
- Unaware (need to educate) (1 pt)
- Resistant (entrenched systems, cultural resistance) (0 pts)
- Don't know (0 pts)

**Free-text (75 words):** What tells you this? (Competitor presence, buyer conversations, market research, regulatory readiness)

**Display Example:** "Saudi Arabia: Already buying. Evidence: ZATCA marketplace has 50+ authorized e-invoicing vendors. Major firms (KPMG, Deloitte) promote solutions. Companies actively implementing. Readiness = HIGH; sales cycle 4-8 weeks."

**MENA Readiness Levels:**

| Level | Meaning | Examples | Sales Cycle | GTM |
|-------|---------|----------|------------|-----|
| **Already Buying** | Category exists; competitors operate; buyers compare | UAE/Saudi SaaS, fintech | Fast (4-8 wks) | Price competitive |
| **Aware Not Buying** | Know category; barriers: price, culture, regulatory | Egypt B2B SaaS (aware; expensive) | Medium (8-16 wks) | Education + ROI |
| **Unaware** | Don't know category exists | MENA early B2B SaaS; AI tools | Long (16-26 wks) | Authority building |
| **Resistant** | Legacy systems entrenched; cultural/regulatory blockers | MENA government compliance | Very Long (26+ wks) | Focus new entrants |

**Free-text Scoring (0-3):**
| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Assumption ("I think market is ready"; no evidence) |
| 2 | Some evidence (ONE source: competitors OR buyers OR research) |
| 3 | Sharp (Multiple sources: competitors + buyer conversations + adoption data) |

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to readiness level
2. Extract evidence types (competitor presence, buyer conversations, market research, regulatory)
3. Check evidence quality: Multiple sources (high) vs. single source (low)
4. Assess realism: Is readiness appropriate for their geography?
5. Award: (MC × 0.4) + (Free-text Quality × 0.6)

**Improvement (if <3):**
- Score 0-1: "Research market readiness. (1) Do competitors exist in [geography]? (2) Talk to 3 ICPs: 'Do you know solutions in this category?' (3) Check regulatory status. Return with evidence-based readiness."
- Score 2: "Find one more evidence source. If you have competitor presence, add buyer conversations. If you have buyer data, add market research."
- MC ≠ Free-text: "Your evidence doesn't support your claim. If you said 'Already Buying' but evidence is 'saw one competitor,' that's actually 'Aware Not Buying.' Update MC to match evidence."

**Time to Fix:** 2-3 hours (competitor + buyer research)

**Section D Total:** D1+D2+D3+D4+D5 = 0-25 pts

---

## 7.5. ENGAGEMENT POTENTIAL ASSESSMENT (AI EVALUATION LAYER)

**Triggered After Section D Completion**

Beyond market attractiveness, this layer evaluates whether the market supports engagement-driven growth—a key predictor of founder success in MENA where outbound-heavy models struggle.

**GOAL:** Identify markets with natural behavioral hooks that enable efficient, sustainable customer acquisition.

### Engagement Potential Check

**Application 1: Nir Eyal's Behavioral Hooks (Trigger-Routine-Reward)**

**Natural Trigger Analysis:**
- Extract from: A2 pain frequency
- Evaluate: Does the pain create a natural, recurring trigger for product use?

**Scoring:**
- **5/5 - Daily Trigger:** Multiple times daily pain → Daily product use is natural (e.g., invoice reconciliation happens daily → daily product check-in natural)
  - Examples: Time-tracking tools (clock in/out = trigger), team communication (Slack-like = trigger), finance dashboard (daily close = trigger)

- **3/5 - Weekly Trigger:** Weekly pain → Weekly product engagement possible but requires habit building
  - Examples: Payroll software (weekly payroll = trigger), weekly reporting tools

- **1/5 - Low Trigger:** Quarterly/annual pain → Engagement requires external reminders or artificial cadence
  - Examples: Annual compliance tools, quarterly planning software (user needs prompts to re-engage)

**Interpretation:** If pain is daily but product is annual-use (trigger-routine mismatch), engagement suffers. Founder must either: (1) Increase product interaction frequency (e.g., daily insights email), or (2) Accept lower engagement + higher churn.

**RECOMMENDATION IF TRIGGER LOW:**
> "Your pain occurs [frequency], but this doesn't create a natural daily/weekly trigger for product use. This means: Higher churn, lower upsell opportunity, weaker moat. MITIGATE by: (a) Adding daily-use features (e.g., dashboard notifications), (b) Creating engagement loops (email/Slack integration for daily touchpoints), or (c) Accepting that customer LTV will be [X] at monthly churn [Y]%."

---

**Application 2: Brendan Kane's Content Platform Density (Audience Congregation)**

**High-Density Content Platform Check:**
- Extract from: C1 congregation points + C3 channel viability
- Evaluate: Are there content platforms where ICP congregates that founder can own/dominate?

**Scoring:**
- **5/5 - High Density + Low Creator Supply:** ICP heavily congregates on 1-2 platforms with few competitors creating content
  - Examples: Saudi Finance Managers on LinkedIn (high density, moderate creator supply) | YouTube accounting tutorials (high density, supply exists but fragmented)
  - OPPORTUNITY: Founder can own "finance automation" content space with 3-6 months of consistent posting

- **3/5 - Moderate Density + Moderate Creator Supply:** ICP congregates but multiple creators cover topic
  - Examples: Twitter SaaS founders discussion (dense but saturated) | Reddit [industry] communities
  - OPPORTUNITY: Niche angle possible but requires differentiation

- **1/5 - Low Density or High Creator Saturation:** ICP scattered across platforms OR many creators dominate
  - Examples: "HR software" on general LinkedIn (low specificity) | YouTube general "productivity" (too saturated)
  - LIMITATION: Content-driven growth weak; rely on outbound/paid

**RECOMMENDATION IF CONTENT DENSITY LOW:**
> "Your ICP doesn't congregate densely on any platform you can dominate, or platforms are saturated with creators. This means: Content-driven growth (inbound) is unlikely. IMPLICATIONS: (a) Outbound acquisition (LinkedIn, email, WhatsApp) becomes primary, (b) Paid ads necessary sooner, (c) Higher CAC, (d) Partner/referral channels critical. PLAN: Shift GTM from content to outbound + partnerships."

---

**Application 3: Engagement Potential Composite**

**COMBINED SCORE:**
```
Engagement Potential = (Trigger Frequency Score / 5) × 0.5 + (Content Platform Density / 5) × 0.5
```

**Interpretation:**
- **4.0-5.0:** High engagement potential. Market supports content-driven + product-driven growth loops. Founder can build brand + acquire customers efficiently.
  - ACTION: Lean into content. Build audience before or alongside product launch. Create daily/weekly content that demonstrates problem + solution.

- **2.5-4.0:** Moderate engagement potential. One dimension strong; one weak. Founder should specialize in the strong dimension.
  - ACTION: If trigger strong but content platform weak → own outbound. If content platform strong but trigger weak → build engagement loops into product.

- **0-2.5:** Low engagement potential. Market not conducive to engagement-driven growth. Requires alternative GTM.
  - ACTION: Build outbound + partnership + enterprise sales infrastructure. Content is secondary. Expect higher CAC; budget accordingly.

**EXECUTIVE SUMMARY FOR FOUNDER:**
> "Your market has [engagement_score]/5.0 engagement potential.
>
> **TRIGGER ANALYSIS:** Pain occurs [frequency] → Natural product engagement is [high/moderate/low]. This [supports/limits] retention.
>
> **CONTENT PLATFORM ANALYSIS:** Your ICP congregates on [platform(s)] with [creator saturation]. Your opportunity: [specific positioning].
>
> **GTM IMPLICATION:** You should emphasize [outbound/content/partnerships] before or alongside product launch. CAC curve will be [aggressive/moderate/slow]."

---

### Why This Matters for MENA Founders

**Context:** MENA entrepreneurs often default to expensive outbound models (LinkedIn, email, sales team) because traditional content platforms (blogs, YouTube) have lower reach. This layer identifies which founders can break that pattern with engagement-driven growth vs. which need to budget for higher CAC from the start.

**Practical:** If engagement potential is high (4.0+), founder should write 1 article/week + 3 LinkedIn posts/week as part of GTM. If low (0-2.5), founder should hire outbound specialists instead and allocate budget to paid + partnerships.

---

## 8. OVERALL SCORE & INTERPRETATION

**Total:** A (0-25) + B (0-25) + C (0-25) + D (0-25) = **0-100 points**

**Band Interpretation:** (See Score Bands section earlier)

---

## 9. CROSS-SCORECARD CONSISTENCY CHECKS

**Claude automatically checks:**

1. **SC1 ↔ SC3 Alignment:**
   - ICP from SC2 matches pain evidence in A1?
   - Geography from SC1 matches MENA strategy in C5?
   - Positioning aligns with pain evidence?

2. **SC2 ↔ SC3 Alignment:**
   - Pain statements from SC2 referenced in A1-A5?
   - Congregation points from SC2 in C1?
   - Budget range from SC2 feasible with B3 pricing?

3. **Internal MAS Consistency:**
   - Pain cost (A3) vs. Frequency (A2): High-cost pains should occur frequently
   - Reach (C2) vs. Congregation (C1): If dense, should be reachable
   - Market Growth (D1) vs. Funding (D3): Growing markets have funded competitors

**Flag Contradictions:** Surface for student clarification; offer chance to update; don't penalize if good explanation provided.

---

## 10. RECOMMENDATION ENGINE

**For every question <4:**
```
QUESTION: [Text]
YOUR SCORE: [X/5]

WHY: [What's missing]
TO IMPROVE: [Specific action]
EXAMPLE OF 5: [What great looks like]
TIME TO FIX: [Estimate]
```

**Priority Recommendations:**
Rank by Impact Score = (Points to gain) × (Ease of fix, 1-5)

Recommend fixes in order of highest impact first.

---

## 11. OUTPUT FILE: MarketAttractiveness.md

**Automatically generated with all sections populated:**
- Score Summary (section breakdown + total + band)
- Executive Summary (2-3 sentences on market viability)
- Section A-D Detailed Assessments (student answers + scores)
- Cross-Scorecard Consistency Notes
- Recommendations (prioritized by impact)
- 30-Day Validation Action Plan (if score <70)
- Next Steps (band-specific guidance)
- Frameworks & References

---

## 12. CLAUDE EXECUTION FLOW

1. **Preparation (2 min):** Load SC1 + SC2 data; display for confirmation
2. **Sections A-D (15 min each):** Administer questions in sequence; provide examples
3. **Scoring (10 min):** Apply rubrics; flag contradictions (no penalties; offer clarification)
4. **Output (5 min):** Generate MarketAttractiveness.md
5. **Presentation (5 min):** Show score, band, top 3 fixes
6. **Next Steps (2 min):** Offer re-scoring, validation plan, or move to SC5

**Total Time:** 60-90 minutes

---

## 13. MENA-SPECIFIC ADJUSTMENTS

Applied throughout:
- **B4 Payment:** Deduct 1 pt if credit card only (Egypt/Jordan/Lebanon)
- **C3/C5 Channels:** Adjust channel fit based on geography penetration rates
- **D2 Tailwinds:** Recognize Vision 2030 (Saudi), ZATCA (Saudi), data laws (UAE/Egypt)
- **D5 Readiness:** Expect longer sales cycles in emerging markets; government adoption slower

---

**END OF SKILL.MD**
