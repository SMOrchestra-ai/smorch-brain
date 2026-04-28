# Expert Frameworks & Protocols

This document contains expert protocols, frameworks, and checkpoints that Claude activates during scoring based on student responses.

---

## NARROWING RESISTANCE PROTOCOL (Section B Expert Handling)

**Trigger:** Founder demonstrates deep domain expertise (10+ years industry, corporate background, insider problem knowledge) AND resists narrowing at B2 or B3 level.

**Symptoms to detect:**
- Answer covers 3+ distinct buyer segments ("I could serve brokers AND property managers AND developers")
- Problem statement lists 5+ problems instead of one razor-sharp pain
- Niche description reads like a consulting practice scope, not a product micro-niche
- Phrases like "all of these need solving" or "I see this across the entire industry"

### 3-Step Intervention Protocol

**Step 1 — Validate the breadth (don't dismiss it):**

> "You clearly see the full landscape — that's rare and valuable. Most founders I work with don't have this depth. But here's the strategic question: which ONE of these segments would pay you $X/month THIS MONTH if you showed them a solution? Not which one is biggest. Which one is most desperate?"

**Step 2 — Force a single-segment commitment:**

> "Let's run a test. Pick ONE segment from your list. We'll build the entire niche definition around just that one. The others don't disappear — they become your Year 2 expansion plan. But your Year 1 proof of concept needs a single focus."

**Step 3 — Reframe the other segments as expansion roadmap:**

> "Here's your niche expansion roadmap based on what you told me: [list their other segments]. We're not throwing these away. We're sequencing them. First, dominate [chosen segment]. Use that proof to expand into [second segment]. Then [third]. This is how domain experts build $1M+ SaaS — one niche at a time, compounding credibility."

**Scoring Impact:**

If founder resists narrowing and stays broad after Protocol:
- B3 (Niche Level) caps at 5/10 regardless of writing quality
- B4 (Niche Validation Logic) gets flagged: "Validation logic applies to sub-market, not true niche. Score reflects breadth, not depth."
- Claude's advisory note: "Your expertise is your moat, but your niche is your beachhead. We can proceed, but know that broad niche = slower revenue, harder positioning, weaker initial proof."

---

## GRAND SLAM OFFER VIABILITY CHECK (Section C, Questions C3 & C4)

**Framework Source:** Alex Hormozi, "The $100M Offer"

**Formula:** (Dream Outcome × Perceived Likelihood) ÷ (Time Delay × Effort & Sacrifice)

**When to Apply:**

During AI evaluation of C3 (Unique Mechanism) and C4 (One-Line Wedge), assess if positioning implies a compelling offer structure.

### AI Evaluation Logic

Ask internally:
1. **Dream Outcome:** Does this solution promise a clear outcome the buyer wants?
2. **Perceived Likelihood:** Is the mechanism believable? Easy to execute?
3. **Time Delay:** How fast to that outcome? (D3 feeds this)
4. **Effort & Sacrifice:** What does the buyer have to give up or do?

### Positive Signal (Add to Recommendations)

If C3/C4 implies fast, easy, believable outcome:

> "**Strong offer structure:** Your mechanism (C3) suggests a clear dream outcome with low friction. This is positioning that sells. You promise [outcome], via [mechanism], in [timeframe], with [minimal effort]. That's a 4x multiplier on believability."

### Development Signal (Add to Recommendations)

If positioning is unclear on outcome, likelihood, or timeline:

> "**Sharpen your offer structure:** Your positioning (C) could be stronger by applying Alex Hormozi's thesis. Right now, buyers see [current perception]. But you could emphasize: Dream outcome: [clearer result]. Perceived likelihood: [make it feel more achievable]. Time to value: [specify exactly how fast]. Effort: [show it's low-friction]. This transforms positioning from 'interesting' to 'compulsive.'"

**Non-Scored Addition:** This enriches Section C context and recommendation clarity. Does not rebalance points.

---

## CHARGE FROM DAY 1 CHECKPOINT (Section D, Questions D1-D4)

**Framework Source:** Marc Lou, "Build in Public"

**Principle:** "If you're not charging from day 1, you're building a hobby."

**When to Apply:**

During AI evaluation of D1-D4, check for ANY mention of pricing, monetization, or revenue model.

### AI Evaluation Logic

- During scoring, flag any mention of "price," "charge," "revenue," "paid," "monetization"
- If D1-D4 explicitly mentions immediate pricing → POSITIVE SIGNAL
- If D1-D4 has NO mention of pricing strategy → DEVELOPMENT AREA
- If explicitly states "will be free" or "freemium then charge" → FLAG timing

### Positive Signal (Add to Recommendations)

If D1-D4 mentions immediate pricing/charges:

> "**Strong revenue signal:** You're building a business, not a prototype. You mention charging [amount] from [when]. That's the right mindset. Keep this discipline throughout Module 3."

### Development Signal (Add to Recommendations)

If D1-D4 has NO mention of pricing strategy:

> "**You haven't mentioned pricing yet.** Marc Lou's thesis: 'If you're not charging from day 1, you're building a hobby.' When will your first customer pay? What's the pricing model? This doesn't change your Section D score, but consider: can you charge a small amount immediately (even AED 5/month) to test willingness to pay? This forces two critical questions: (1) Does anyone care enough to pay? (2) What's the right price?"

### Conditional Signal (Add to Recommendations)

If explicitly "free now, paid later":

> "**Timeline matters for monetization.** You're planning to charge [when], with model [what]. The risk: free → paid transitions lose users. The mitigation: build payment willingness into Day 1 (test pricing with pre-sales or a paid tier from launch). Don't wait until you have 1,000 free users to discover they won't pay."

**Non-Scored Addition:** This enriches Section D context and revenue strategy clarity. Does not rebalance points.

---

## HOOK MODEL PRODUCT CHECK (Section D, Questions D1-D3)

**Framework Source:** Nir Eyal, "Hooked: How to Build Habit-Forming Products"

**Model:** 4 stages: External Trigger → Easy Action → Variable Reward → Investment

**When to Apply:**

During AI evaluation of D1 (Core Problem), D2 (MVP Feature Set), and D3 (Speed to Value), assess if the product implies habit formation, not just problem-solving.

### AI Evaluation Logic

For each of the 4 Hook stages, ask:

1. **External Trigger:** Does the problem/feature set include something that reminds the user to use the product?
   - Examples: WhatsApp notification, lead notification, daily email, SMS reminder

2. **Easy Action:** Is the first step frictionless?
   - D3 "Speed to Value" should be same-day or within 3 days
   - Does the user touch only 1-2 things to get first result?

3. **Variable Reward:** Does using the product give unpredictable reward?
   - Examples: finding new lead, closing deal, saving time, social proof

4. **Investment:** Does the product create stored value that makes users more likely to return?
   - Examples: lead history, custom templates, relationship data, scoring, pipeline

### Positive Signal (Add to Recommendations)

If D1-D3 implies all 4 stages:

> "**Strong habit loop detected:** Your product design (D1-D3) implies: (1) External triggers — [what reminds them]. (2) Easy action — [your D3 speed-to-value is strong here]. (3) Variable reward — [they get X outcome each use]. (4) Investment stored — [they build Y data/relationships]. This makes retention more likely. You're solving a problem AND creating a sticky behavior loop."

### Development Signal (Add to Recommendations)

If any stage is missing or unclear:

> "**Your product solves the problem (D1) but may not create habit.** Consider Nir Eyal's Hook Model: (1) External trigger — What reminds them to use this? (Now: [current state] → Fix: [add trigger]). (2) Easy action — Is Day 1 really frictionless? (Your D3 is good here.) (3) Variable reward — What unpredictable value do they get each use? (Now: [current] → Fix: [emphasize variability]). (4) Stored value — What data/relationships accumulate? (Now: [current] → Fix: [add investment]). Right now, you emphasize [what D1-D3 focus on], but sticky products also answer these 4 questions."

**Non-Scored Addition:** This enriches Section D context and product stickiness clarity. Does not rebalance points.

---

## EXPERT IDENTITY BRIDGE FLAG (Section E, Questions E1 & E2)

**Framework Source:** Russell Brunson, "Expert Secrets"

**Archetype:** "Expert Without a Stage"

**Pattern to Detect:**

During AI evaluation of E1 and E2, flag if ANY of these patterns appear:
- Chose "The Expert" archetype (E1 option 4)
- Origin story (E2) mentions 5+ years in a corporate role, industry leadership, or domain mastery
- Background includes "10 years at [Company]," "VP of [Function]," "I'm the best in my space"
- Problem origin (A1) references insider knowledge or deep domain experience

### When Flag Fires (Expert Without a Stage Detected)

Generate this feedback block:

```
EXPERT IDENTITY BRIDGE FLAG
PATTERN DETECTED: You have deep domain expertise (E2: "[history]") but may lack a public platform.

RUSSELL BRUNSON'S ARCHETYPE: "Expert Without a Stage"
Your challenge: You're credible inside your industry, but outside it, nobody knows you. Your brand voice needs to bridge that gap.

WHAT TO ADD TO BRAND VOICE:

1. Attractive Character Archetype: Pair your "Expert" role with ONE of Russell Brunson's archetypes:
   - Leader: "I've led [team/function] for 10 years and discovered..."
   - Adventurer: "I've explored every solution in my industry and found..."
   - Reporter: "I investigated the industry and uncovered..."
   - Reluctant Hero: "I never wanted to start a company, but after 10 years of frustration, I had to..."

2. Epiphany Bridge Story (enhance E2): Your origin story should include a moment where your expertise turned into a business insight:

   WEAK: "I worked in real estate for 10 years, learned a lot, now building a tool."

   STRONG: "I spent 10 years as a VP in real estate, thinking I'd figured it all out. Then I watched solo brokers solve [problem] better than I did. That's when I realized: my 10 years of scale-up experience was irrelevant. I needed to unlearn everything and rebuild for the real problem I saw."

ACTION: Rewrite your origin story (E2) to include:
- Your domain authority (what makes you credible)
- The INVERSION or REVERSAL (where your expertise became a liability, or where you discovered something outside your expertise)
- Why NOW (why are you leveraging this expertise now to build)

IMPACT: This transforms "Expert Without a Stage" into "Expert With a Thesis"—which is infinitely more compelling for a founding story.
```

**Non-Scored Addition:** This is an AI detection and guidance flag that enriches Section E scoring context. Does not rebalance points.

---

## PRE-LAUNCH VALIDATION CHECKPOINT (Section D, Conditional)

**Framework Source:** John Rush, Tibo

**Trigger Condition:**

Founder scores 70+ on Section D (Product Vision & Spec) but has zero validation evidence (no pre-sell, no waitlist customers, no proof of demand).

**Conditional Recommendation (fires during Phase 4 recommendations):**

```
PRE-LAUNCH VALIDATION CHECKPOINT
CONDITION MET: Your product definition scored well (D score: [X]/20), but I see no evidence of customer pre-validation yet.

EXPERT THESIS:
- John Rush: "Don't code until 5 customers pre-pay"
- Tibo: "Ship MVP in 72 hours; measure MRR at day 2"

WHAT THIS MEANS: A sharp product definition is necessary but not sufficient. Before building, you need:

1. Pre-sell evidence: 5+ customers who've paid (even small amount, AED 10-50 deposit) OR signed pre-order LOI
2. Waitlist proof: 20+ waitlist signups with high intent (not just email capture)
3. First-customer conversation: 1-2 paid customers who've experienced your MVP and renewed

NEXT STEP: Before you code, run a 5-day pre-sell sprint:

- Day 1-2: Identify 10 potential first customers (use niche from B3, ICP thinking)
- Day 3-4: Pitch them your solution (from C4 wedge) and ask: "Would you pay AED [price]?" Get 5 pre-payments (even if refundable)
- Day 5: Compile results. If <5 paid, revisit positioning (C) or niche (B). If 5+, you've validated. Now build.

IMPACT: Pre-sell forces you to validate problem-solution fit BEFORE sinking 2+ weeks into building.
```

This checkpoint is a CONDITIONAL RECOMMENDATION that enriches guidance. Does not rebalance Section D scoring.

---

## MENA-SPECIFIC ADJUSTMENTS (Applied During Scoring)

These adjustments are applied during Phase 2 scoring (not new questions, just scoring tweaks):

### 1. Niche Specificity Bonus (Section B)

**Trigger:** Niche (B3) includes MENA geography (UAE, KSA, Egypt, Gulf state, etc.)

**Action:** If MENA geography explicitly named in niche → +1 point to B3
**Rationale:** MENA-specific niches are more defensible and have clearer buyer behavior patterns.

**Also Bonus:** If niche references MENA-specific pain (WhatsApp-centric, relationship-based, local payment issues) → +1 point to B3

### 2. Language Strategy Evaluation (Section F)

**Trigger:** F2 answer evaluated against F1 geography

**Action:** Score changes based on alignment:
- If F2 = "Arabic-first" AND F1 = Egypt/KSA → base score 4 (instead of 3)
- If F2 = "English-only" AND F1 = Egypt → FLAG recommendation: "Why English-only in a predominantly Arabic market?"
- If F2 = "Bilingual from day one" AND F1 = UAE/KSA → base score 4 (high confidence)

**Rationale:** Language strategy should align with geography. Arabic-first in Arabic-primary markets gets higher scoring.

### 3. Cultural Fit Research Bonus (Section F)

**Trigger:** F3 demonstrates primary research

**Action:** If student shows evidence of speaking to MENA operators/founders → +1 point to F3
**Rationale:** Generic MENA assumptions don't score as high as researched, specific adaptations.

### 4. Problem Origin MENA Ground (Section A)

**Trigger:** A1 (Problem Origin Story) or A2 (Founder-Problem Fit) includes named MENA references

**Action:**
- If A1 includes named MENA people, companies, or locations → +1 point to A1
- If A2 includes MENA network or MENA domain experience → +1 point to A2

**Rationale:** MENA-grounded problems and founder credentials are more credible for MENA-focused products.

---

## CROSS-SCORECARD CONSISTENCY CHECKS

During Phase 2 scoring, flag these contradictions for Recommendations section (don't change scores, but flag for student awareness):

| If SC1 Says... | In Question... | Later Scorecards Will... | Recommendation |
|---|---|---|---|
| "Independent brokers in Dubai" | B3 (Niche) | Reference this in SC2 (ICP) and SC3 (MAS) | Ensure consistency across scorecards |
| "Lose 40% of leads to WhatsApp chaos" | A1 (Problem) | Expect this pain in SC2 Pain Statements | Pain statements must stem from problem |
| "MVP features include X, Y, Z" | D2 (MVP) | Reference in SC3 when assessing speed to value | Ensure MVP scope aligns with timeline |
| "Arabic-first language strategy" | F2 (Language) | Evaluate against MENA channels in SC5 | Language choice affects channel viability |

### Contradiction Detection Flags

Flag these specific contradictions:

| If Says... | Also Says... | Flag |
|---|---|---|
| "Real Estate Technology" (B1) | "Healthcare practice management" (B3) | Market-Niche mismatch — founder described two different markets |
| "Same day speed to value" (D3) | "15 features required for MVP" (D2) | Timeline impossible — 15 features ≠ same day |
| "WhatsApp-first is the mechanism" (C3) | "Technical approach: custom code" (D4) | Approach mismatch — custom code won't launch faster than no-code for WhatsApp integration |
| "Arabic-first strategy" (F2) | "All hiring in English, team based in London" | Strategy-geography-execution mismatch |

---

END OF FRAMEWORKS
