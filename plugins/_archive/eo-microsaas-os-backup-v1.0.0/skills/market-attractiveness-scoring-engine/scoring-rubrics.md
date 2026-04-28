# Market Attractiveness Scoring Engine -- Scoring Rubrics

Reference file for `SKILL.md`. Contains all detailed rubric tables, scoring scales, scoring logic, and expert framework additions.

---

## SECTION A RUBRICS

### A1. Pain Evidence Strength (0-5)

| Score | Criteria | What AI Checks |
|-------|----------|---|
| 0 | Blank or off-topic | Did not attempt |
| 1 | Assertion only ("I think") | No evidence cited; pure speculation |
| 2 | Generic evidence | Vague sources ("asked people"); no names, numbers, or quotes |
| 3 | Partial evidence | 2 types for 1 pain OR 1 type for 2 pains; some specificity |
| 4 | Strong evidence | 2+ types per pain for >=2 pains; named sources; numbers cited |
| 5 | Expert evidence | 3+ types per pain across all 3 pains; could use in pitch deck |

---

### A3. Pain Cost (0-5)

| Score | Criteria |
|-------|----------|
| 0 | No quantification ("very expensive") |
| 1 | Partial math (incomplete or unclear formula) |
| 2 | Rough estimate (math valid but arbitrary numbers) |
| 3 | Reasonable math (realistic unit costs; misses 1 cost type) |
| 4 | Sharp calculation (multiple cost types; all clear; realistic) |
| 5 | Expert (comprehensive model; sensitivity analysis; investor-grade) |

---

### A4. Workaround Assessment (0-5)

| Score | Criteria |
|-------|----------|
| 0 | No answer |
| 1 | "Not doing anything" (unaware of buyer behavior) |
| 2 | Generic ("spreadsheets and manual processes") |
| 3 | Named tools ("Excel, Zapier, manual emails") with basic failures |
| 4 | Tools + specific failures ("formula breaks if format changes"; "hiring delays") |
| 5 | Comprehensive failure map with failure chains and buyer frustration clear |

---

### A5. Pain Urgency Signal (0-5)

| Score | Criteria | Signal Type |
|-------|----------|---|
| 0 | Blank | N/A |
| 1 | Wishful thinking ("want it ASAP"; no evidence) | Hope, not reality |
| 2 | Logical assumption (reasonable guess; unvalidated) | Internal logic only |
| 3 | Some signals (1-2 present; budget allocated, timeline mentioned) | Beginning of urgency |
| 4 | Strong signals (2-3: regulatory + budget + competitive) | Multiple pressure points |
| 5 | Validated urgency (3+ signals; direct buyer statement; external deadlines) | Investment-grade |

---

## SECTION B RUBRICS

### B1. Existing Spend (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank or "I don't know" |
| 1 | Generic ("accounting software"; no names, prices) |
| 2 | Some specificity (1-2 tools; vague pricing) |
| 3 | Specific tools (3+ named; prices; may miss labor) |
| 4 | Sharp spend map (named tools + prices; includes labor cost) |
| 5 | Expert (complete spend; hidden costs; purchasing precedent clear) |

---

### B2. Budget Authority -- Free-text Scoring (0-3)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Generic ("they need approval") |
| 2 | Partial (decision-maker named; missing timeline/thresholds) |
| 3 | Sharp (decision-maker + timeline + thresholds + connection to sales cycle) |

---

### B3. Price Point Validation (0-5)

| Score | Criteria |
|-------|----------|
| 0 | No price |
| 1 | Price only (no comparison) |
| 2 | Partial logic (ONE benchmark; missing others) |
| 3 | Two comparisons (clear but incomplete) |
| 4 | Three comparisons (clear "no brainer" calc) |
| 5 | Expert model (all 3 comparisons + sensitivity analysis) |

#### EXPERT FRAMEWORK: Pricing Framework Cross-Check (B3 Enhancement)

During B3 Evaluation, Claude performs automated cross-checks. This validates founder's pricing against three data sources for consistency. Flag any inconsistency >50%.

**CROSS-CHECK 1: Pain Frequency x Pain Cost**
- Source: A2 (pain frequency) + A3 (pain cost)
- Check: Does stated price align with pain frequency and cost?
- Formula: If pain is daily ($X/month cost), pricing should be 20-40% of $X/month
- Example: Daily pain costing $1,000/month -> price should be $200-400/month (not $50/month)
- If inconsistency >50%: "Your pain occurs [frequency] and costs $[A3]/month, but price is $[B3]. For [frequency] pain, 20-40% ratio suggests $[calculated range]. Discrepancy = [%]. Validate: Are you underpricing? Or is pain cost overstated?"

**CROSS-CHECK 2: Competitor Pricing (from SC1 positioning)**
- Source: SC1 competitor pricing data
- Check: How does founder's price compare to named competitors?
- Acceptable range: +/-30% of competitor average (allows for differentiation)
- If inconsistency >50%: "You priced at $[stated], but [Competitor A] charges $[comp A], [Competitor B] charges $[comp B]. Average: $[avg]. You're [%] below market. Validate: (1) Are you solving different problem? (2) Is this intentional undercutting? (3) Missing value communication? Consider raising to market-aligned price if solving same problem."

**CROSS-CHECK 3: ICP Budget Range (from SC2)**
- Source: SC2 budget range + purchasing power signals from B1-B2
- Check: Does stated price fit within ICP's stated budget or typical allocation?
- Formula: ICP budget from SC2 x typical allocation % = acceptable price range
- Example: ICP budget $5K/month, typical SaaS allocation 10-20% = $500-1K acceptable
- If inconsistency >50%: "SC2 indicated budget of $[SC2 budget], but B3 price is $[stated]. If $[stated] is [%] of their budget allocation, validate with budget-holder: 'Of your $[budget] monthly allocation, how much goes to [category]?'"

**FLAGGING LOGIC:**
IF (stated price vs. implied price from A2+A3 = >50% gap)
AND (stated price vs. SC1 competitors = >50% gap)
AND (stated price vs. SC2 budget = >50% gap)
-> FIRE HIGH-PRIORITY RECOMMENDATION: "Pricing shows significant inconsistencies across three frameworks. Before GTM, stress-test with 3 ICPs: 'Would you pay $[competitor avg price]?' If yes, raise price. Underpricing early stage is costly."

---

### B5. Willingness Signal (0-5)

| Score | Signal Type | Criteria |
|-------|---|---|
| 0 | No signal | Blank |
| 1 | Aspirational | "I think people would pay" (no evidence) |
| 2 | Behavioral | Waitlist, email signups, free trial (intent; no commitment) |
| 3 | Verbal | "Buyer said they'd pay" (named, stated, but no signature) |
| 4 | Signed | Signed LOI, paid pilot, pre-order agreement |
| 5 | Executed | Paid pilot in progress, pre-orders collected, competitor revenue data |

#### EXPERT FRAMEWORK: Underpricing Detection

Triggered during B3 review and B1 comparison. After founder provides pricing (B3) and existing spend (B1), Claude applies Alex Hormozi's principle: "95% of businesses underprice." This evaluation specifically identifies underpricing signals.

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

#### EXPERT FRAMEWORK: Grand Slam Offer Check (Pricing Framework Cross-Check)

Triggered after B3 and B5 completion. After the founder completes B3 (Price Point Validation) and B5 (Willingness Signal), Claude evaluates the offer structure using Alex Hormozi's Grand Slam formula.

**GRAND SLAM OFFER CHECK:**
Based on pain evidence (Section A) and purchasing power (Section B), evaluate:

1. **Dream Outcome Score:** How transformative is this solution? (Scale: Modest improvement vs. Life-changing)
   - Extract from: A3 pain cost + B3 ROI calculation
   - Score high if: ROI >5x AND pain cost >$1K/month AND pain affects revenue directly
   - Score low if: ROI <2x OR pain is operational convenience

2. **Perceived Likelihood:** How credible is the value delivery claim given available evidence?
   - Extract from: A1 evidence strength + B5 willingness proof
   - Score high if: Expert evidence (A1=5) + Signed commitments (B5>=4)
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
Viability Index = (Dream x Likelihood) / (Delay x Effort)
IF Viability Index < 2.0 -> FLAG: "Weak offer structure"
IF Viability Index 2.0-3.5 -> CAUTION: "Moderately strong offer"
IF Viability Index > 3.5 -> STRONG: "High-probability offer"
```

**RECOMMENDATION TRIGGER:**
If Viability Index <2.0, fire this recommendation:
> "Your offer structure may be underpowered. While market validation is present, either: (1) Dream outcome is modest (pain cost too small or ROI weak), (2) Buyer confidence is low (evidence is weak), (3) Sales cycle is long (urgency or approval friction), or (4) Switching cost is high.
>
> TO STRENGTHEN: (a) Increase Dream by expanding value capture (find additional pain relief beyond core pain), (b) Build Likelihood with proof (get signed pilot or LOI), (c) Compress Delay by streamlining approval (negotiate with budget authority), (d) Reduce Effort by offering migration support or phased rollout.
>
> CONSIDER REDESIGNING VALUE PROPOSITION before GTM if Viability <2.0."

---

## SECTION C RUBRICS

### C1. Congregation Density (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Vague ("LinkedIn"; no specific group/location) |
| 2 | Generic ("LinkedIn finance group"; no estimate) |
| 3 | Specific point + rough estimate |
| 4 | Sharp calculation (layered: total -> filtered by role -> filtered by size -> actual fit) |
| 5 | Expert map (multiple points ranked; specific counts; actionable reach) |

---

### C2. Reach Capability (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No path ("I'll use LinkedIn") |
| 2 | Some path (channels named; numbers missing/unrealistic) |
| 3 | Specific path (channels + weekly targets; realistic) |
| 4 | Sharp plan (channels + daily cadence + response rates + time/resources) |
| 5 | Expert model (multiple channels + targets + validated rates + contingency) |

---

### C4. Competitor Access Pattern (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No awareness ("don't know competitors") |
| 2 | Basic (names competitors; knows 1 channel) |
| 3 | Partial map (2-3 competitors; 1-2 channels each; 1 weakness) |
| 4 | Sharp map (2-3 competitors; channels + metrics; 2+ weaknesses) |
| 5 | Expert (detailed channels + metrics; clear gaps; strategic positioning) |

---

### C5. MENA Access Reality (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Western assumptions ("email and LinkedIn standard"; no MENA adaptation) |
| 2 | Surface awareness ("MENA uses WhatsApp more"; vague) |
| 3 | Some context (2-3 MENA factors mentioned; partial channel mix) |
| 4 | Sharp strategy (3-4 factors; channel % provided; language clear) |
| 5 | Expert (detailed mix by geography; language strategy; local competitive advantage identified) |

---

## SECTION D RUBRICS

### D1. Market Direction -- Free-text Scoring (0-3)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Assumption ("market is growing"; no evidence) |
| 2 | Generic ("I read [market] is growing"; no source/numbers) |
| 3 | Sharp ("Gartner 2026 report: 18% CAGR through 2030"; specific numbers) |

---

### D2. Tailwind Events (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No tailwinds ("don't know any") OR only generic ("technology advancing") |
| 2 | Generic tailwinds (1 trend; no specificity/dates) |
| 3 | Some specific (2 tailwinds named; missing dates/impact) |
| 4 | Sharp (2-3 specific + dated tailwinds; clear buyer urgency connection) |
| 5 | Expert (3+ specific tailwinds; dates; magnitude; strategic interpretation) |

---

### D3. Competitive Landscape (0-5)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No awareness ("don't know competitors") |
| 2 | Names competitors (no funding/acquisition data) |
| 3 | Partial funding (2 competitors + some funding; may lack acquisition/interpretation) |
| 4 | Sharp funding (2-3 competitors + amounts + stages; clear viability signal) |
| 5 | Expert (3+ funded competitors + amounts + dates; acquisition data; market viability clear) |

---

### D4. Search Demand Signal -- Free-text Scoring (0-3)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | No research ("I think demand is up") |
| 2 | Generic ("I checked Google Trends"; no keywords/timeframe) |
| 3 | Sharp ("Checked '[keyword]' March 2025-2026; volume up 25% YoY") |

---

### D5. MENA Market Readiness -- Free-text Scoring (0-3)

| Score | Criteria |
|-------|----------|
| 0 | Blank |
| 1 | Assumption ("I think market is ready"; no evidence) |
| 2 | Some evidence (ONE source: competitors OR buyers OR research) |
| 3 | Sharp (Multiple sources: competitors + buyer conversations + adoption data) |

#### MENA Readiness Levels

| Level | Meaning | Examples | Sales Cycle | GTM |
|-------|---------|----------|------------|-----|
| **Already Buying** | Category exists; competitors operate; buyers compare | UAE/Saudi SaaS, fintech | Fast (4-8 wks) | Price competitive |
| **Aware Not Buying** | Know category; barriers: price, culture, regulatory | Egypt B2B SaaS (aware; expensive) | Medium (8-16 wks) | Education + ROI |
| **Unaware** | Don't know category exists | MENA early B2B SaaS; AI tools | Long (16-26 wks) | Authority building |
| **Resistant** | Legacy systems entrenched; cultural/regulatory blockers | MENA government compliance | Very Long (26+ wks) | Focus new entrants |

---

## ENGAGEMENT POTENTIAL ASSESSMENT -- DETAILED SCORING

### Application 1: Nir Eyal's Behavioral Hooks (Trigger-Routine-Reward)

**Natural Trigger Analysis:**
- Extract from: A2 pain frequency
- Evaluate: Does the pain create a natural, recurring trigger for product use?

**Scoring:**
- **5/5 - Daily Trigger:** Multiple times daily pain -> Daily product use is natural (e.g., invoice reconciliation happens daily -> daily product check-in natural)
  - Examples: Time-tracking tools (clock in/out = trigger), team communication (Slack-like = trigger), finance dashboard (daily close = trigger)

- **3/5 - Weekly Trigger:** Weekly pain -> Weekly product engagement possible but requires habit building
  - Examples: Payroll software (weekly payroll = trigger), weekly reporting tools

- **1/5 - Low Trigger:** Quarterly/annual pain -> Engagement requires external reminders or artificial cadence
  - Examples: Annual compliance tools, quarterly planning software (user needs prompts to re-engage)

**Interpretation:** If pain is daily but product is annual-use (trigger-routine mismatch), engagement suffers. Founder must either: (1) Increase product interaction frequency (e.g., daily insights email), or (2) Accept lower engagement + higher churn.

**RECOMMENDATION IF TRIGGER LOW:**
> "Your pain occurs [frequency], but this doesn't create a natural daily/weekly trigger for product use. This means: Higher churn, lower upsell opportunity, weaker moat. MITIGATE by: (a) Adding daily-use features (e.g., dashboard notifications), (b) Creating engagement loops (email/Slack integration for daily touchpoints), or (c) Accepting that customer LTV will be [X] at monthly churn [Y]%."

---

### Application 2: Brendan Kane's Content Platform Density (Audience Congregation)

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

### Application 3: Engagement Potential Composite

**COMBINED SCORE:**
```
Engagement Potential = (Trigger Frequency Score / 5) x 0.5 + (Content Platform Density / 5) x 0.5
```

**Interpretation:**
- **4.0-5.0:** High engagement potential. Market supports content-driven + product-driven growth loops. Founder can build brand + acquire customers efficiently.
  - ACTION: Lean into content. Build audience before or alongside product launch. Create daily/weekly content that demonstrates problem + solution.

- **2.5-4.0:** Moderate engagement potential. One dimension strong; one weak. Founder should specialize in the strong dimension.
  - ACTION: If trigger strong but content platform weak -> own outbound. If content platform strong but trigger weak -> build engagement loops into product.

- **0-2.5:** Low engagement potential. Market not conducive to engagement-driven growth. Requires alternative GTM.
  - ACTION: Build outbound + partnership + enterprise sales infrastructure. Content is secondary. Expect higher CAC; budget accordingly.

**EXECUTIVE SUMMARY FOR FOUNDER:**
> "Your market has [engagement_score]/5.0 engagement potential.
>
> **TRIGGER ANALYSIS:** Pain occurs [frequency] -> Natural product engagement is [high/moderate/low]. This [supports/limits] retention.
>
> **CONTENT PLATFORM ANALYSIS:** Your ICP congregates on [platform(s)] with [creator saturation]. Your opportunity: [specific positioning].
>
> **GTM IMPLICATION:** You should emphasize [outbound/content/partnerships] before or alongside product launch. CAC curve will be [aggressive/moderate/slow]."

### Why This Matters for MENA Founders

**Context:** MENA entrepreneurs often default to expensive outbound models (LinkedIn, email, sales team) because traditional content platforms (blogs, YouTube) have lower reach. This layer identifies which founders can break that pattern with engagement-driven growth vs. which need to budget for higher CAC from the start.

**Practical:** If engagement potential is high (4.0+), founder should write 1 article/week + 3 LinkedIn posts/week as part of GTM. If low (0-2.5), founder should hire outbound specialists instead and allocate budget to paid + partnerships.

---

**END OF SCORING-RUBRICS.MD**
