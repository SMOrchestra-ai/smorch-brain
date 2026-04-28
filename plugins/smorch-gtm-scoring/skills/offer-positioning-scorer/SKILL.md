<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: offer-positioning-scorer
description: Scores offer structure and market positioning against 10 weighted criteria using Hormozi Value Equation, Dunford 5-Component Positioning, and Signal-to-Trust framework. Evaluates dream outcome clarity, perceived likelihood, time to value, effort minimization, unique mechanism, competitive alternatives, price-to-value gap, risk reversal, ICP-offer alignment, and positioning statement. Triggers on 'score my offer', 'rate my positioning', 'offer quality check', 'is my offer strong enough', 'positioning review', 'value prop score', 'offer audit'.
---

# Offer & Positioning Scorer

**System 2 of 6 — Battle-Tested Offer & GTM Expert Hat**

**What this scores:** The core offer construct and market positioning. Is this something people would feel stupid saying no to? Is the positioning defensible and clear? A strong offer is the foundation: great copy can't sell a weak offer, but even mediocre copy can sell a strong one.

**Benchmark sources:** Alex Hormozi Value Equation ($100M Offers), April Dunford 5-Component Positioning (Obviously Awesome), Russell Brunson Attractive Character + Value Ladder, Signal-to-Trust framework.

**Scoring rules:** Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## The Hormozi Value Equation

Before scoring, understand the framework that grounds criteria C1-C4:

```
Perceived Value = (Dream Outcome x Perceived Likelihood) / (Time Delay x Effort & Sacrifice)
```

Maximize the numerator (big outcome, high belief it works). Minimize the denominator (fast results, low buyer effort). Target: numerator product > 60, denominator product < 15, ratio > 4.0.

## The Dunford Positioning Completeness Check

All 5 components must be explicitly defined:
1. Competitive alternatives (what they'd do if you didn't exist)
2. Unique attributes (what you have that alternatives don't)
3. Value/proof (the benefit those attributes deliver, with evidence)
4. Target customer characteristics (who cares most about that value)
5. Market category (the context that makes the value obvious)

Missing any component = incomplete positioning.

### Narrative Coherence Test

Beyond the 5-component check, run this coherence test: read components 1-5 in sequence. Do they tell one consistent story? Or do they contradict each other?

| Test | Pass | Fail |
|------|------|------|
| Target customer (4) would actually face the competitive alternatives (1) | Target aligns with alternatives | Target wouldn't consider those alternatives |
| Unique attributes (2) directly address why alternatives fail for this target | Attributes solve the target's specific gap | Attributes are generic, not tied to the alternative's weakness |
| Value/proof (3) comes from the target customer type (4), not a different segment | Proof from same ICP | Proof from unrelated segment |
| Market category (5) makes the unique attributes (2) obviously relevant | Category frames the value | Category is too broad or too narrow for the attributes |

If any test fails, the positioning has internal contradictions. Fix the weakest component to align with the strongest one.

A positioning that fails narrative coherence gets -1.5 on C10 (Positioning Statement Clarity) regardless of how each component scores individually.

---

## The 10 Criteria

### C1: Dream Outcome Clarity — Weight: 15%

The prospect must see themselves in a specific, measurable better future. Not features. Not capabilities. The transformation.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Prospect can see themselves in a specific, measurable better future. "Go from 3 meetings/month from cold outbound to 15+ qualified meetings/month within 90 days." Outcome is vivid, tangible, desirable. Uses their language, not yours. |
| 7/10 | Good | Outcome stated with some specificity. "Significantly increase your qualified meetings from outbound." Direction clear but magnitude and timeline vague. The prospect believes it but can't picture it precisely. |
| 5/10 | Mediocre | Outcome stated but vague. "Improve your sales pipeline." No specificity on magnitude or timeline. Could mean anything. |
| 1/10 | Failure | No outcome articulated. Feature list presented as the offer. "We provide AI-powered CRM solutions." |

**Fix Action:** Complete this sentence with numbers: "Our clients go from [specific current state with number] to [specific future state with number] in [timeframe]." If you can't fill in the numbers, you haven't defined the dream outcome yet.

---

### C2: Perceived Likelihood of Achievement — Weight: 12%

The prospect must believe this will work for them specifically. Not in theory. Not for other companies. For them.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Proof stacked 3+ layers deep: case studies with numbers, named logos, demo of the mechanism working, risk reversal (guarantee). Proof from similar companies (same industry, size, market). Prospect thinks "this will probably work for me specifically." |
| 7/10 | Good | 2 types of proof (case study + testimonial, or demo + data). Proof is relevant but may not be from exact same ICP segment. Prospect thinks "this looks credible." |
| 5/10 | Mediocre | One testimonial or case study. Generic "trusted by 50+ companies" without specifics. Prospect hopes it works but isn't convinced. |
| 1/10 | Failure | Zero proof. "Trust us, we're experts." No case studies, no demo, no social proof. |

**Fix Action:** Stack 3 proof types for your core ICP: (1) one specific case study with before/after numbers, (2) one named logo or testimonial, (3) one mechanism demo or live walkthrough. If you lack case studies, offer a free pilot to your best-fit prospect and document everything.

---

### C3: Time to Value — Weight: 10%

Compressed timelines with clear milestones. "Results typically appear within a few months" creates doubt. "First signals detected in week 1, first meetings booked by week 3" creates urgency to start.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Clear, compressed timeline with milestones. "First signals detected in week 1. First meetings booked by week 3. Full pipeline running by day 60." Each milestone is measurable and verifiable. |
| 7/10 | Good | Timeline exists with general milestones. "You'll see initial results within 30 days, full program running by 90 days." Clear direction but milestones could be sharper. |
| 5/10 | Mediocre | Vague timeline. "Results typically appear within a few months." No milestones. No specific checkpoints the buyer can verify. |
| 1/10 | Failure | No timeline. Or worse: "This is a long-term strategic investment." Translation: you won't see ROI. |

**Fix Action:** Map 4 milestones with dates: (1) Setup complete by Day X, (2) First measurable result by Day Y, (3) Pattern established by Day Z, (4) Full ROI visible by Day W. Even if estimates, they give the prospect a timeline to hold you to.

---

### C4: Effort & Sacrifice Minimization — Weight: 10%

The buyer's effort is the hidden tax on your offer. Done-for-you beats done-with-you beats do-it-yourself. The less the buyer has to do, the higher the perceived value.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Offer designed so buyer does minimal work. "We build it, we run it, we hand you booked meetings. Your team spends 30 minutes/week reviewing pipeline." Done-for-you with clear scope of what you handle vs what they provide. |
| 7/10 | Good | Mostly done-for-you with some buyer involvement. "We handle 80% of the work. You'll need to approve messaging and attend qualified meetings." Clear division of labor. |
| 5/10 | Mediocre | Buyer has to do significant work but it's somewhat guided. "We'll train your team and provide templates." Done-with-you where "with" means they do most of it. |
| 1/10 | Failure | Buyer does all the work. Essentially selling a course or toolkit disguised as a service. No support structure. |

**Fix Action:** List every step in your delivery process. Mark each as "Us" or "Them." If more than 20% is "Them," find ways to automate or absorb those steps. The goal: buyer signs, provides access/info, and receives results.

---

### C5: Unique Mechanism — Weight: 12%

A named, proprietary framework that explains WHY this works differently. "Signal-to-Trust Engine" or "Digital Silence Index." The mechanism is the answer to "why should I believe this approach is different?"

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Proprietary or named framework that explains WHY this works differently. "Signal-to-Trust Engine" or "Digital Silence Index." Mechanism is believable, explainable in 60 seconds, and defensible. Has visual or diagram representation. |
| 7/10 | Good | Named approach with clear differentiation. "Our 3-Phase Signal Detection Process." Explains the how, but mechanism may not feel proprietary. Defensible but not unique enough to prevent copying. |
| 5/10 | Mediocre | Generic methodology. "We use AI and data-driven insights." No named framework. Nothing proprietary. Could describe 100 competitors. |
| 1/10 | Failure | No mechanism. "We do outbound." Zero differentiation in how. Completely interchangeable with any competitor. |

**Fix Action:** Name your process. Take the 3-5 steps you actually follow and give the sequence a name. "The [Name] Framework/Engine/Method." Then draw a simple diagram: Step 1 → Step 2 → Step 3 → Result. The name creates memorability; the diagram creates credibility. Takes 20 minutes.

---

### C6: Competitive Alternative Clarity — Weight: 7%

The prospect needs to understand what happens if they don't buy from you. Not "they go to a competitor" but the real alternative: they hire 2 more SDRs ($180K loaded cost), they keep doing 47 coffee meetings, they use a generic tool and get generic results.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Crystal clear on what happens if they don't buy: specific alternatives named with costs. "They keep doing manual relationship-selling (47 coffee meetings), hire 2 more SDRs ($180K+ loaded cost), or use a generic tool and get generic results." Alternative is painful and quantified. |
| 7/10 | Good | Alternatives named with some cost framing. "They could hire internally or use a generic outbound agency." Cost comparison implied but not fully quantified. |
| 5/10 | Mediocre | Mentions competitors exist but doesn't frame the alternative vividly. "Other agencies do this differently." No cost comparison. |
| 1/10 | Failure | No competitive framing. Prospect has no context for why this vs anything else. Offer exists in a vacuum. |

**Fix Action:** List the 3 real alternatives your prospect faces (not competitors, but alternative approaches): (1) DIY approach + cost, (2) Hire internally + cost, (3) Generic vendor + cost. Then show how your offer compares on cost AND outcome for each.

---

### C7: Price-to-Value Gap — Weight: 10%

Price should feel like a fraction of the value. If you deliver 15 meetings/month and their average deal is $50K, paying $5K/month is obvious 10x ROI. The math must be explicit.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Price feels like a fraction of the value. ROI math explicit: "If we deliver 15 meetings/month and your average deal is $50K, paying $5K/month is 10x ROI minimum." The math is in the offer, not left to the prospect to figure out. |
| 7/10 | Good | Value clearly exceeds price. ROI implied and roughly quantifiable. "This will more than pay for itself within the first quarter." Numbers support the claim even if not front-and-center. |
| 5/10 | Mediocre | Value is implied but not calculated. "This will pay for itself." No specific ROI math. Price anchor is missing. |
| 1/10 | Failure | Price feels arbitrary. No value anchor. "Our package starts at $X." Why X? No connection between price and expected return. |

**Fix Action:** Calculate the explicit ROI: (Expected meetings per month) x (Close rate) x (Average deal value) = Revenue generated. Compare to your price. If the ratio isn't 3x+, either increase the outcome or decrease the price. Show this math in the offer.

---

### C8: Risk Reversal — Weight: 8%

Strong guarantees reduce buyer risk to near zero. The guarantee demonstrates confidence in your own delivery. No guarantee signals risk the buyer bears alone.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Strong guarantee: performance-based, money-back on specific conditions, or pilot/proof-of-concept with clear success criteria. "If we don't deliver 10+ qualified meetings in 60 days, you don't pay for month 2." Buyer risk approaches zero. |
| 7/10 | Good | Meaningful guarantee with reasonable conditions. "30-day trial period. If you're not seeing traction, we extend free of charge." Not performance-based but shows confidence. |
| 5/10 | Mediocre | Soft guarantee. "We'll work with you until you're satisfied." No specific conditions. Vague and unenforceable. |
| 1/10 | Failure | No guarantee. All risk on buyer. "Payment due upfront, no refunds." Or worse: long contract lock-in with no performance clauses. |

**Fix Action:** Pick one: (1) Performance guarantee with specific metric ("X meetings or we work free until delivered"), (2) Time-based pilot ("60-day pilot, cancel anytime"), or (3) Money-back with clear criteria. Choose the one you can actually honor.

---

### C9: ICP-Offer Alignment — Weight: 7%

The offer must be built for a specific buyer with specific pain. Enterprise B2B in Gulf with 50+ person sales team = different offer than SME in Dubai wanting more WhatsApp leads. One-size-fits-all offers sell to no one.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Offer built for a specific buyer with specific pain. Enterprise B2B in Gulf with 50+ person sales team = different offer than SME in Dubai wanting more WhatsApp leads. Segmented offers exist per ICP tier. Language, proof, and pricing match the segment. |
| 7/10 | Good | Offer aligned with primary ICP. Some customization for secondary segments. Pricing tiers exist even if not fully differentiated in messaging. |
| 5/10 | Mediocre | One offer for everyone. "Our solution works for businesses of all sizes." No segmentation. No ICP-specific messaging. |
| 1/10 | Failure | Offer is misaligned with actual buyer needs. Built for who you want to sell to, not who actually buys. |

**Fix Action:** Define your top 2 ICP segments. For each, write: (1) Their specific pain, (2) The specific outcome they want, (3) How the offer delivers that outcome, (4) Price point that makes ROI math work for them. Two versions, not one generic offer.

---

### C10: Positioning Statement Clarity — Weight: 9%

The "bar test": if someone asks at a networking event "what do you do?", the answer takes 15 seconds and the person immediately knows if they're a prospect or not.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Passes the bar test: 15-second answer, listener immediately knows if they're a prospect. No jargon. Crystal clear category. "We build signal-based outbound engines for B2B companies entering Gulf markets. Our clients book 15+ qualified meetings per month without a single coffee meeting." |
| 7/10 | Good | Clear in 30 seconds. Minor jargon but understandable. Listener gets it but might need one follow-up question. |
| 5/10 | Mediocre | Takes 60+ seconds to explain. Uses industry jargon. Person nods politely but doesn't really get it. |
| 1/10 | Failure | Cannot articulate what you do without a slide deck. Positioning is a paragraph, not a sentence. |

**Fix Action:** Complete this template: "We [verb] [specific thing] for [specific who] so they can [specific outcome]." No more than 20 words. Test it on someone outside your industry. If they can't immediately tell if they're a prospect, rewrite it.

---

Run the Dunford Positioning Completeness Check and Narrative Coherence Test (see above) after scoring all 10 criteria.

---

## Scoring Execution

### Input Required

To score an offer/positioning:
1. The offer document, proposal, landing page, or verbal description
2. Target ICP (who is this offer for)
3. Price point (if applicable)

### Scoring Mindset

Think like Alex Hormozi evaluating a business owner's offer at a workshop. You've seen 10,000 offers. You know that:
- Most offers fail because the dream outcome is unclear, not because the price is wrong
- Proof stacking is the most underinvested element (founders assume trust, buyers don't)
- The unique mechanism is what makes an offer defensible against copycats
- Risk reversal is the single fastest way to increase conversion on a strong offer
- MENA buyers need more proof and longer trust-building than US buyers; the offer must account for this

### Output Format

Use the standard score report from `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md`. Additionally, always include:

1. **Hormozi Value Equation calculation:** Numerator (C1 × C2), Denominator (inverse C3 × inverse C4), Ratio
2. **Dunford Completeness Check:** 5-component Y/N table
3. **Narrative Coherence Test:** Pass/Fail with notes

---

## Calibration Anchor: Scored Example

**Scenario:** SalesMfast Signal Engine offer for Series A-B SaaS companies expanding into Gulf markets.

| # | Criterion | Weight | Score | Rationale |
|---|-----------|--------|-------|-----------|
| C1 | Dream Outcome Clarity | 15% | 9.0 | "Go from 3 meetings/month to 15+ qualified meetings/month within 90 days, without hiring SDRs or flying to coffee meetings." Vivid, measurable, desirable. Minor: "qualified" could be more precisely defined (what qualification criteria?). |
| C2 | Perceived Likelihood | 12% | 8.0 | 2 case studies with numbers (SaaS company in Riyadh: 3→14 meetings in 60 days). Named framework (Signal-to-Trust Engine). Missing: third proof layer (no live demo or third-party validation). |
| C3 | Time to Value | 10% | 9.0 | "Week 1: signal infrastructure live. Week 3: first meetings booked. Day 60: pipeline running at full capacity." 4 milestones, specific, measurable. |
| C4 | Effort Minimization | 10% | 8.5 | Done-for-you with 30 min/week client commitment. Client provides: ICP description, CRM access, messaging approval. Clear scope. Gap: onboarding still takes 5 hours of client time in week 1. |
| C5 | Unique Mechanism | 12% | 9.5 | "Signal-to-Trust Engine" — named, diagrammed, explainable in 60 seconds. 3-step visual: Detect Signal → Score Intent → Sequence Trust Proof. Defensible against generic "AI outbound" competitors. |
| C6 | Competitive Alternative Clarity | 7% | 8.5 | 3 alternatives quantified: (1) Hire 2 SDRs: $180K+/year loaded cost, (2) Relationship-selling: 47 coffee meetings per quarter, (3) Generic agency: $8-12K/month with batch-and-blast. Each compared on cost AND outcome. |
| C7 | Price-to-Value Gap | 10% | 8.5 | ROI math explicit: 15 meetings × 20% close rate × $50K avg deal = $150K pipeline/month. Price: $5-8K/month. 18-30x ROI. Math is in the proposal. Gap: ROI assumes prospect's close rate, which varies. |
| C8 | Risk Reversal | 8% | 8.0 | "60-day pilot. If fewer than 10 qualified meetings in 60 days, month 2 is free." Performance-based but not full money-back. Adequate for MENA trust threshold. |
| C9 | ICP-Offer Alignment | 7% | 9.0 | Enterprise tier (50+ employees): done-for-you at $8K/month. Growth tier (20-50): done-with-you at $5K/month. Messaging, proof, and pricing differentiated per tier. |
| C10 | Positioning Statement | 9% | 9.0 | "We build signal-based outbound engines for B2B companies entering Gulf markets. Our clients book 15+ qualified meetings per month without a single coffee meeting." Passes bar test. 12 seconds. Listener immediately knows if they're a prospect. |

**OVERALL: 8.72 / 10 — VERDICT: STRONG**
**HARD STOPS: None**
**Dunford Check: 5/5 present. Narrative coherence: PASS.**
**Value Equation: Numerator (9.0 × 8.0 = 72) / Denominator (9.0⁻¹ × 8.5⁻¹ ≈ low effort, fast time) = strong ratio >4.0.**
**TOP FIX: C2 Perceived Likelihood — add a third proof type (live demo walkthrough or third-party validation). Lift: +1.0.**

---

## Cross-System Dependencies

Offer/Positioning is the second upstream system. It feeds copywriting, social proof, and YouTube content. A weak offer makes every downstream asset harder.

| Downstream Weakness | Likely Root Cause Here | Check This Criterion |
|---------------------|----------------------|---------------------|
| Email body has no compelling value | Dream outcome unclear | C1: Dream Outcome Clarity |
| Social media posts lack proof | No proof stacking in offer | C2: Perceived Likelihood |
| VSL script can't articulate why different | No unique mechanism | C5: Unique Mechanism |
| Copy can't justify the price | Price-value math missing | C7: Price-to-Value Gap |
| Prospects ghost after proposal | No risk reversal | C8: Risk Reversal |
| LinkedIn posts lack specificity | Positioning statement too broad | C10: Positioning Statement Clarity |
| YouTube scripts generic, no unique angle | No competitive framing | C6: Competitive Alternative Clarity |
| Different assets tell different stories | ICP-Offer misalignment | C9: ICP-Offer Alignment |

When copywriting, social media, or YouTube scorers flag low scores on value clarity, mechanism explanation, or proof quality, the fix is almost always here, not in the downstream asset.
