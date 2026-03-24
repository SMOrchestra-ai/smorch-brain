# Templates Reference -- Strategy Selector Engine

This file contains output templates, Movement Brief prompts, and free-text response examples referenced by SKILL.md.

---

## OUTPUT FILE TEMPLATE: strategy-recommendation.md

**Automatically generated with all sections populated. Structure:**

```markdown
# Strategy Recommendation -- [Founder Name]
**Date:** [Date]
**Scorecard Version:** 2.0

---

## 1. STRATEGY SELECTOR SCORE

| Section | Score | Max |
|---------|-------|-----|
| A. Founder-Strategy Alignment | [X] | 20 |
| B. Market-Strategy Fit | [X] | 25 |
| C. ICP-Strategy Fit | [X] | 25 |
| D. Execution Readiness | [X] | 20 |
| E. MENA Strategy Fit | [X] | 10 |
| **TOTAL** | **[X]** | **100** |

---

## 2. READINESS SCORE

**Formula:**
Readiness = (MAS Score x 0.35) + (ICP Clarity Score x 0.35) + (GTM Potential x 0.30)

**Inputs:**
- MAS Score (SC3): [X]/100
- ICP Clarity Score (SC2): [X]/100
- GTM Potential (D+E normalized): [X]/100

**Readiness Score:** [X]/100
**Assessment:** [READY / CONFIDENT / CAUTIOUS / UNCERTAIN / NOT READY]

---

## 3. RECOMMENDED PRIMARY PATH

**Path:** [Replicate & Localize / Consulting-First SaaS / Boring Micro-SaaS / Hammering Deep]

**Why This Path:**
[3-5 bullet points explaining why this path matches founder profile, market conditions, and ICP behavior]

**Confidence Level:** [High / Medium / Low]

---

## 4. SECONDARY PATH

**Path:** [Secondary path name]

**Trigger Conditions for Switching:**
[2-3 conditions under which the founder should switch to the secondary path]

---

## 5. DEMAND-FIRST QUADRANT

[Quadrant classification from BRD framework]

---

## 6. ARCHETYPE CLASSIFICATION

**Archetype:** [1 of 8 archetypes]
**Attractive Character:** [Reporter / Leader / Reluctant Hero / Adventurer]
**Brand Voice:** [One-line brand voice description]

---

## 7. TOP 5 BOTTLENECK ANALYSIS (CROSS-PILLAR)

| # | Bottleneck | Source Scorecard | Impact | Recommended Action |
|---|-----------|-----------------|--------|-------------------|
| 1 | [Bottleneck] | [SC1/SC2/SC3/SC4] | [High/Med/Low] | [Action] |
| 2 | [Bottleneck] | [SC1/SC2/SC3/SC4] | [High/Med/Low] | [Action] |
| 3 | [Bottleneck] | [SC1/SC2/SC3/SC4] | [High/Med/Low] | [Action] |
| 4 | [Bottleneck] | [SC1/SC2/SC3/SC4] | [High/Med/Low] | [Action] |
| 5 | [Bottleneck] | [SC1/SC2/SC3/SC4] | [High/Med/Low] | [Action] |

---

## 8. 90-DAY STRATEGIC ROADMAP

### Month 1: [Theme]
- [Action 1]
- [Action 2]
- [Action 3]
- **Success Metric:** [Metric]

### Month 2: [Theme]
- [Action 1]
- [Action 2]
- [Action 3]
- **Success Metric:** [Metric]

### Month 3: [Theme]
- [Action 1]
- [Action 2]
- [Action 3]
- **Success Metric:** [Metric]

---

## 9. MOVEMENT BRIEF

**Cause:** [What cause does this founder champion?]
**New Opportunity vs. Improvement:** [New Opportunity or Improvement Offer -- with description]
**Enemy:** [What specific problem or system does the founder oppose?]
**Future Vision:** [What future are they building?]

---

## 10. RE-ASSESSMENT TRIGGERS

[List of conditions that should trigger re-running SC4]
- [Trigger 1]
- [Trigger 2]
- [Trigger 3]

---

## 11. 30-DAY VALIDATION EXPERIMENT

[Path-specific experiment from strategy-paths.md, pre-populated for selected path]

---

## 12. NEXT STEPS

- [ ] Execute 30-day validation experiment
- [ ] Proceed to SC5 (GTM Fitness) after validation
- [ ] [Additional next steps based on recommendation]
```

---

## MOVEMENT BRIEF PROMPTS

**Purpose:** Articulate the founder's larger purpose and positioning narrative. This section feeds from the Conversational Advisor Framework's movement-brief.md deliverable.

**Prompts to populate in output:**

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

## FREE-TEXT RESPONSE EXAMPLES

### B5. Strategy Path Hypothesis -- Display Example

**Question:** Based on your market, which of the 4 strategy paths feels most natural? Why?

**Example Response:**
"I think Consulting-First SaaS is best because: (1) My ICP is in Egypt where business relationships are critical; consulting builds trust first. (2) Market is emerging (competitors aware but not many); early adopters willing to pay for guidance. (3) I have sales skills but not technical skills. (4) Conservative risk tolerance; need revenue in 90 days; consulting is fastest path."

---

### C5. ICP-Strategy Synthesis -- Display Example

**Question:** Looking at your ICP's buying behavior, pain urgency, and budget--does your chosen strategy (from B5) still make sense? Or would you reconsider?

**Example Response:**
"My ICP (finance managers at mid-market Saudi companies) show: Complex decision (finance team + CFO); 1-month urgency (ZATCA deadline); $150-500/month budget; reachable via LinkedIn + WhatsApp. My Consulting-First path still makes sense because: (1) Complex decisions require relationship building that consulting provides. (2) ZATCA urgency means they want expert guidance, not DIY SaaS. (3) Mid-market budget supports $200-300/month consulting model. (4) LinkedIn + WhatsApp are perfect channels for direct outreach."
