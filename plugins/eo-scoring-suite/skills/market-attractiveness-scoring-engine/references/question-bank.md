# Question Bank: Market Attractiveness Scoring Engine

All 25 questions (A1-D5) with display guidance, scoring rubrics, and improvement paths.

---

## SECTION A: PAIN REALITY & INTENSITY (25 POINTS)

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

---

## SECTION B: PURCHASING POWER & WILLINGNESS (25 POINTS)

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

## B2-D5 QUESTIONS TRUNCATED FOR SPACE

See full question-bank.md in original file or request specific sections.

---

END OF QUESTION BANK
