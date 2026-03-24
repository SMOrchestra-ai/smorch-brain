# Competitive Analysis Framework — Positioning Against Methodology

## PURPOSE
Use this when generating competitive-landscape.md. Ensures competitive analysis serves positioning, not just information gathering.

---

## THE 3-LAYER COMPETITIVE MAP

### Layer 1: Direct Competitors (Who does roughly what you do)
Companies/products in the same market category targeting similar ICP.

**For each (document 3-5):**
- Name + URL
- What they do (one sentence)
- Pricing (specific tiers if public, range if not)
- ICP overlap: how similar is their customer to yours? (HIGH/MEDIUM/LOW)
- Strengths: what they do well (be honest, not dismissive)
- Weaknesses: where they fail (be specific, not "bad UX")
- Threat level: LOW (niche player) / MEDIUM (growing) / HIGH (dominant)

### Layer 2: Indirect Competitors (What the customer does instead)
These are the real competitors. Most deals are lost to inaction, not to other vendors.

**Always include:**
- **Status quo:** "They keep doing what they're doing" — the biggest competitor for any product
- **Manual approach:** Spreadsheets, email chains, in-house hacks
- **Adjacent tools:** CRM used for outbound when it's really a signal detection problem
- **Hiring:** "They hire a person to do this instead of buying software/services"
- **Consultants/agencies:** "They hire a generalist consultant instead of using a specialized tool"

**For each:**
- What it is
- Why customers default to it (inertia, familiarity, perceived lower risk)
- Its structural limitation (what it can never do, no matter how much effort)
- Switching cost from it to you (what does the customer have to change?)

### Layer 3: Regional Competitors (MENA-Specific)
Competitors that exist specifically in the MENA market or have MENA-adapted offerings.

**For each:**
- Name + country of origin
- MENA market coverage (which countries)
- Arabic support (native / translated / none)
- Local pricing (adapted for region or global pricing?)
- Relationship network (do they have wasta / connections that give them unfair advantage?)
- Government/regulatory position (any preferred vendor status?)

---

## COMPETITIVE POSITIONING MAP

Plot competitors on a 2x2 matrix. Choose axes that make you win.

**Axis selection rules:**
- X-axis: a dimension where you're clearly on one end (e.g., price, specialization, MENA-focus)
- Y-axis: a dimension where you differentiate from close competitors (e.g., automation level, signal coverage, Arabic-native)
- You should be in the TOP-RIGHT quadrant (high on both desired dimensions)
- If you're not, either the axes are wrong or the positioning needs rethinking

**Common axis pairs:**
- Price vs. MENA specialization
- Automation level vs. Signal coverage depth
- Enterprise vs. SME focus
- Self-serve vs. Done-for-you
- Generic vs. Industry-specific

---

## GAP EXPLOITATION

This is the most important section. It connects competitive analysis to positioning.

**The Gap:** What do ALL competitors (direct + indirect + regional) miss?

**Rules for identifying the gap:**
- It must be structural, not just a feature. "No one has dark mode" is a feature gap. "No one processes Arabic intent signals from WhatsApp conversations" is a structural gap
- It must matter to the ICP. A gap nobody cares about isn't exploitable
- It must be defensible. If competitors could close the gap in 2 months, it's not a wedge

**Gap format:**
"All alternatives fail at [specific capability] because [structural reason]. This means [ICP] currently [workaround with specific cost]. Our [unique mechanism] closes this gap by [how]."

**Example:**
"All competing outbound platforms fail at detecting Arabic-language buying signals because their NLP is English-only and their data sources don't index MENA business activity. This means Gulf-based sales teams manually scan LinkedIn and WhatsApp for intent, missing 60%+ of signals. SalesMfast Signal Engine closes this gap with Arabic-native signal processing from 10 MENA-specific data sources."

---

## OBJECTION MAPPING

For each major competitor, document the objection a buyer would raise and the counter.

| Competitor | Buyer Says | Counter |
|-----------|-----------|---------|
| [Competitor A] | "They're cheaper" | "[Specific ROI comparison]: they cost X but miss Y signals, costing you Z in lost deals" |
| [Status quo] | "We're fine doing it manually" | "[Specific cost of manual]: your team spends N hours/week, which at $X/hour = $Y/month — more than our price" |
| [Hiring] | "We'll just hire an SDR" | "[Specific comparison]: an SDR costs $X/month all-in, detects signals manually, and takes 3 months to ramp. We detect more signals on day 1 for 1/3 the cost" |

---

## VALIDATION CHECKLIST

After generating competitive-landscape.md, verify:

- [ ] 3-5 direct competitors listed with honest strengths AND weaknesses
- [ ] Status quo and manual approach included as indirect competitors
- [ ] At least 1 regional/MENA-specific competitor if project targets MENA
- [ ] Positioning map has 2 axes where you clearly win
- [ ] Gap is structural, not just a feature
- [ ] Gap connects directly to the unique mechanism in positioning.md
- [ ] Competitive pricing comparison present (not just your own price)
- [ ] Objection mapping covers the top 3 "why not us" responses
