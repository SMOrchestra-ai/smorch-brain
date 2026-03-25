# Market Attractiveness Scoring Engine -- Detailed Dimensions

Reference file for `SKILL.md`. Contains all 25 questions with their descriptions, display examples, evaluation processes, and improvement guidance.

---

## SECTION A: PAIN REALITY & INTENSITY (25 POINTS)

**Goal:** Validate that SC2 pains are real, frequent, costly, and urgent through evidence, not speculation.

---

### A1. Pain Evidence Strength (5 pts)
**Type:** Free-text, 150-word limit
**Question:**
> From your ICP pain statements (listed from SC2), which THREE pains have the STRONGEST evidence of being real? For each pain, cite your evidence: customer conversations, competitor reviews, market data, case studies, or observable behavior.

**Display:** Show SC2 pain statements as reference. Provide example: "Pain: 'Invoice reconciliation wastes 15 hours/week.' Evidence: 4 finance managers confirmed; competitor reviews mention 'time-saving' (500+ FreshBooks reviews); ZATCA mandate forces e-invoicing."

**Evaluation Process:**
1. Extract 3 pains mentioned; verify they match SC2 pain statements
2. For each pain, count distinct evidence types (conversations, data, competitive, research, regulatory)
3. Assess specificity: Named people/companies (high) vs. generic sources (low)
4. Check consistency with SC2 pain map
5. Award: (Diversity x 0.5) + (Specificity x 0.3) + (Consistency x 0.2)

**Improvement (if <4):**
- Score 0-2: "Schedule 3 buyer conversations THIS WEEK. Ask: 'How does this pain show up for you?' Document stories, not yes/no."
- Score 2-3: "For #1 pain, gather 3 sources: (1) conversation quote, (2) competitive evidence, (3) data point. Name and number everything."
- Score 3-4: "Add one more evidence type per pain. Check Google Trends, LinkedIn, competitor support forums."

**Time to Fix:** 2-5 hours (conversations + research)

For scoring rubric, see `scoring-rubrics.md` Section A1.

---

### A2. Pain Frequency (5 pts)
**Type:** Multiple Choice x 3 (one per pain)
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
> "Your frequency average is low. Either: (1) Find daily/weekly pains, OR (2) Show how infrequent pains compound. Example: 'Quarterly audit failure x 4/year x 30 hours = 120 hours/year = 2.5 weeks.'"

**Time to Fix:** 30 minutes (reframe or pivot pain)

---

### A3. Pain Cost (5 pts)
**Type:** Free-text, 100-word limit
**Question:** Quantify the cost of your #1 pain per month. Show your math.

**Display Example:** "Pain: Manual invoice reconciliation. Cost: 4 finance staff x 15 hours/week / 4 = 15 hours/month x $50/hour = $750/month. Plus: 2 errors/month x $200 audit cost = $400/month. Total: $1,150/month."

**Evaluation Process:**
1. Extract and verify math (hours x rate = cost)
2. Check unit realism ($30-150/hour for labor is realistic; $50-1K per error typical)
3. Assess completeness (labor + error + opportunity cost)
4. MENA adjustment: Egypt/Jordan labor may be $20-40/hour; validate consistency
5. Award: (Math x 0.4) + (Unit Realism x 0.35) + (Completeness x 0.25)

**Improvement (if <4):**
- Score 0-2: "Pick ONE cost driver and calculate it. If 10 hours/week x $50/hour = $2,000/month. That's your baseline."
- Score 2-3: "Add missing costs: errors/rework + opportunity cost. Include all cost types."
- Score 3-4: "Validate unit costs with a buyer: 'Is $50/hour loaded cost right for your team?'"

**Time to Fix:** 1-2 hours (research + math)

For scoring rubric, see `scoring-rubrics.md` Section A3.

---

### A4. Workaround Assessment (5 pts)
**Type:** Free-text, 150-word limit
**Question:** What are buyers doing TODAY to manage this pain? List tools, processes, workarounds. How broken are they?

**Display Example:** "Workarounds: (1) Manual spreadsheet INDEX/MATCH (errors if format changes), (2) Temp staff hiring (expensive, turnover loss), (3) Quarterly audits (reactive, errors found too late). Failures: Formula breaks -> hidden errors -> audit discovers massive backlog -> expensive rework."

**Evaluation Process:**
1. Extract named tools/processes
2. Count distinct failure points (errors, delays, cost, hiring friction, knowledge loss)
3. Assess specificity: "INDEX/MATCH breaks" (specific) vs. "it's slow" (generic)
4. Check consistency: Do workarounds match pain statement?
5. Award: (Tool Specificity x 0.4) + (Failure Count x 0.3) + (Articulation x 0.3)

**Improvement (if <4):**
- Score 0-2: "Interview 3 ICPs. Ask: 'Walk me through how you handle this today. What breaks?' Take notes."
- Score 2-3: "You know tools; now know failures. Ask: 'What bugs you about this? When has it failed?'"
- Score 3-4: "Deepen failure analysis. Ask: 'Why do you keep using this despite problems?' Answer = your moat."

**Time to Fix:** 2-3 hours (interviews)

For scoring rubric, see `scoring-rubrics.md` Section A4.

---

### A5. Pain Urgency Signal (5 pts)
**Type:** Free-text, 100-word limit
**Question:** If you pitched tomorrow, what timeline would buyer want? (week/month/quarter/someday) What evidence supports it?

**Display Example:** "Urgency: This month. Evidence: (1) ZATCA mandate effective next month; (2) CFO said 'We need solution before month-end'; (3) Budget allocated in Q; (4) Competitor launched. Multiple external pressures = HIGH urgency."

**Signal Hierarchy:** Regulatory deadline > Competitive pressure > Budget deadline > Operational crisis > Seasonal > Buyer statement > Aspiration

**Evaluation Process:**
1. Extract claimed timeline (week/month/quarter/someday)
2. Count distinct signals; categorize by hierarchy
3. Assess evidence quality: Direct quote (high) > Assumption (low)
4. Check consistency: Does timeline match evidence?
5. Award: (Timeline Realism x 0.3) + (Signal Count x 0.4) + (Evidence Quality x 0.3)

**Improvement (if <4):**
- Score 0-2: "Ask ICP: 'When would you need this? What makes that timeline urgent?' Find external pressure: regulation, competitor, budget deadline, crisis."
- Score 2-3: "Find one external signal. Verify its date. Is regulatory deadline in writing? Is budget allocation confirmed?"
- Score 3-4: "Ask: 'What happens if you DON'T solve this by [timeline]?' Their answer = cost of inaction."

**Time to Fix:** 1-2 hours (buyer conversation)

For scoring rubric, see `scoring-rubrics.md` Section A5.

**Section A Total:** A1+A2+A3+A4+A5 = 0-25 pts

---

## SECTION B: PURCHASING POWER & WILLINGNESS (25 POINTS)

**Goal:** Validate that ICP has budget and will pay.

---

### B1. Existing Spend (5 pts)
**Type:** Free-text, 100-word limit
**Question:** What are buyers CURRENTLY PAYING for related problems? List tools/services and monthly spend.

**Display Example:** "Current spend: (1) QuickBooks: $25/month; (2) Zapier: $99/month; (3) Freelance accountant: $300/month; (4) Internal labor: 40 hours x $50/hour = $2,000/month. Total: $2,424/month."

**Evaluation Process:**
1. Extract named tools; count pricing data points
2. Assess completeness (tools + services + labor + vendors)
3. Verify realism (QuickBooks $25-300/month is realistic; $5K/month is not)
4. Check consistency with pain cost (A3): Should be in same ballpark
5. Award: (Tool Specificity x 0.35) + (Price Completeness x 0.35) + (Labor Inclusion x 0.3)

**Improvement (if <4):**
- Score 0-2: "Interview 3 ICPs: 'What tools do you use for [problem]? What's the monthly cost?' Get vendor names and actual prices."
- Score 2-3: "Add pricing. Google vendor prices. Ask: 'Do you pay for freelance help?' Include labor cost."
- Score 3-4: "Good map. Validate: Ask 'How much do you spend per month on [problem]?' Your estimate should align."

**Time to Fix:** 1-2 hours (interviews + web research)

For scoring rubric, see `scoring-rubrics.md` Section B1.

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

**Display Example:** "Finance Manager proposes to Finance Director. Director approves if <$500/month + ROI >3x within 1 week. If >$500/month, needs CFO (4 weeks). Our price: $150/month -> Director approval -> 1-week sales cycle."

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Extract MC (simplicity score): simpler = higher score
2. Extract free-text details (decision-maker, timeline, thresholds)
3. Check consistency: Does ACV from SC1 fit within decision threshold?
4. Flag if ACV exceeds threshold (longer sales cycle)
5. Award: (MC x 0.4) + (Free-text Quality x 0.6)

**Improvement (if <3):**
> "Interview decision-maker: 'If you wanted to buy [solution] at $[price]/month, how would approval work? Who would you ask? How long?' Document exact process and timeline."

**Time to Fix:** 1-2 hours (buyer interview)

For scoring rubric, see `scoring-rubrics.md` Section B2.

---

### B3. Price Point Validation (5 pts)
**Type:** Free-text, 100-word limit
**Question:** What price are you charging? Compare to: (a) pain cost, (b) alternative spend, (c) ROI delivered. Does it pass the no-brainer test?

**Display Example:** "Price: $199/month. (a) Pain cost $1,150/month; price is 17% of pain. (b) Alternatives $2,424/month; price is 8% of alternatives. (c) ROI: Customer pays $2,388/year; saves $13,800/year; ROI = 5.8x. Verdict: Clear no-brainer; customer saves $2,225/month net."

**Evaluation Process:**
1. Extract price; normalize to $/month
2. Validate vs. pain cost (A3): Price < 50% pain cost = good; < 25% = strong
3. Validate vs. alternatives (B1): Price < 25% = good
4. Calculate ROI: Annual cost vs. annual savings; aim for 3x+ minimum
5. Check math accuracy
6. Award: (Pain Comparison x 0.27) + (Alternative Comparison x 0.27) + (ROI x 0.26) + (Clarity x 0.2)

**Improvement (if <4):**
- Score 0-2: "Use formula: Pain cost x 30-40% = entry price. Example: $1,150 x 35% = $400/month."
- Score 2-3: "All 3 benchmarks required. Calculate ROI: (Annual savings) / (Annual cost) = ROI multiple. Aim for 3x+"
- Score 3-4: "Stress-test with buyer: 'Would you pay $[price] to save $[pain]?' Their reaction tells you if realistic."

**Time to Fix:** 1-2 hours (modeling + validation)

For scoring rubric and expert framework cross-checks, see `scoring-rubrics.md` Section B3.

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

**Hierarchy:** Executed Payment > Signed Commitment > Verbal > Behavioral > Aspirational

**Evaluation Process:**
1. Identify signal type; map to hierarchy
2. Assess specificity: Named buyer (high) vs. generic (low)
3. Verify commitment level: Money down > Signature > Verbal > Behavioral > Aspirational
4. Check consistency with urgency (A5)
5. Award: (Signal Type x 0.4) + (Specificity x 0.3) + (Commitment Level x 0.3)

**Improvement (if <4):**
- Score 0-2: "Go get a willingness signal. Contact 5 ICPs; ask 'Would you pay $[price] for this?' Get 2-3 explicit yes answers. Document names."
- Score 2-3: "Convert waitlist -> pilot. Offer 50% off if they commit to $500 pilot in 30 days."
- Score 3-4: "Turn verbal -> signed. Send one-page LOI: '[Company] agrees to pilot [solution] for $[price] from [date] to [date].' Get signature."

**Time to Fix:** 1-3 weeks (outreach + pilot closure)

For scoring rubric and expert frameworks (Underpricing Detection, Grand Slam Offer Check), see `scoring-rubrics.md` Section B5.

**Section B Total:** B1+B2+B3+B4+B5 = 0-25 pts

---

## SECTION C: ICP ACCESSIBILITY (25 POINTS)

**Goal:** Validate that you can actually reach your ICP.

---

### C1. Congregation Density (5 pts)
**Type:** Free-text, 100-word limit
**Question:** From SC2 congregation points, which has HIGHEST density of exact buyers? How many are there?

**Display Example:** "Top point: LinkedIn Finance Mgr group. Estimated: 5K group members; 2K mid-market companies (ACV sweet spot); 500-1K exact fit by size + industry. Can reach 100 in 30 days via targeted outreach."

**Evaluation Process:**
1. Extract congregation point; verify it matches SC2 points
2. Extract density estimate; check calculation quality
3. Assess layering: Total -> Role filter -> Size filter -> Geography filter = actual ICP fit
4. Award: (Specificity x 0.3) + (Estimation Quality x 0.35) + (Filtering Logic x 0.35)

**Improvement (if <4):**
- Score 0-2: "Name ONE congregation point (LinkedIn group, conference, business club, city). Research its size."
- Score 2-3: "Validate estimate with actual data (LinkedIn group member count, conference attendee list, census data)."
- Score 3-4: "Layer the estimate. Of 5K group members: 20% right role x 40% right size x 50% right industry = 200 prospects."

**Time to Fix:** 2-3 hours (research + filtering)

For scoring rubric, see `scoring-rubrics.md` Section C1.

---

### C2. Reach Capability (5 pts)
**Type:** Free-text, 100-word limit
**Question:** Can you reach 100+ buyers in 30 days with your resources? Describe exactly how.

**Display Example:** "Plan: (1) LinkedIn outbound: 20 messages/week x 4 weeks = 80 reach attempts; 20% response = 16 meetings. 30 min/day. (2) Cold email: 10/week x 4 = 40 attempts; 5% response = 2 meetings. Total: 120 reach attempts, ~18 meetings, 1 hour/day. Achievable."

**Evaluation Process:**
1. Extract channels and targets
2. Check realism: LinkedIn 15-20 quality msgs/week/person is realistic; 100+/week is not
3. Verify math: Sum targets; do they reach ~100 in 30 days?
4. Confirm resources: Can stated team do this?
5. Award: (Channel Diversity x 0.2) + (Target Specificity x 0.35) + (Realism x 0.35) + (Resource Clarity x 0.1)

**Improvement (if <3):**
- Score 0-1: "Pick ONE channel. Calculate: 100 people / 30 days = 3.3/day. For LinkedIn: 4 msgs/day x 20-30 min = achievable."
- Score 1-2: "Make specific. 'LinkedIn: 4 msgs/day x 5 days x 4 weeks = 80 msgs. 20% response = 16 replies. 30 min/day = 10 hours total.'"
- Score 2-3: "Stress-test: Can you ACTUALLY do 20 msgs/day while running business? If not, reduce target or phase it."

**Time to Fix:** 2-3 hours (planning + validation)

For scoring rubric, see `scoring-rubrics.md` Section C2.

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

For top 3 selections: "Describe your specific capability on [Channel]. Example: 'LinkedIn -- 5K connections, mostly [role], in [geography]; I've done 50+ outreach with 15% response rate; 30 min/day; can scale to 200+/month.'"

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

**Combined:** MC (0-5) + Free-text (0-4) -> normalize to 0-5

**Evaluation Process:**
1. Verify channel selections align with ICP
2. Extract capability specifics (audience, response rate, time)
3. Check for proof (actual experience vs. aspirational)
4. Assess consistency: Does free-text match MC selections?
5. Award: (Channel Fit x 0.35) + (Capability Detail x 0.35) + (Proof x 0.3)

**Improvement (if <4):**
- MC weak fit: "Your channels don't match ICP. [ICP] congregates on [X], not [Y]. Reconsider."
- Free-text vague: "Tell me your actual capability. Numbers: audience size, response rate, time required. Build on real data."
- Proof missing: "Have you tried this channel? Do 20 attempts this week; measure response rate."

**Time to Fix:** 1-2 weeks (validate channels + measure)

For scoring rubric, see `scoring-rubrics.md` Section C3.

---

### C4. Competitor Access Pattern (5 pts)
**Type:** Free-text, 100-word limit
**Question:** How are competitors reaching these buyers? What channels dominate? Where are they weak?

**Display Example:** "Competitors [A, B] dominate LinkedIn (15K followers; weekly posts) and content (SEO-ranked). Absent from: WhatsApp outreach, email list, community engagement. Gap: MENA congregates on WhatsApp; competitors ignore it. Opportunity: Own WhatsApp channel + email list in [geography]."

**Evaluation Process:**
1. Extract named competitors (not generic)
2. Extract channels per competitor
3. Check research quality: Did they actually look at competitors?
4. Identify weaknesses articulated
5. Assess gap identification (strategic opportunity?)
6. Award: (Competitor Specificity x 0.3) + (Channel Coverage x 0.3) + (Weakness x 0.2) + (Gap ID x 0.2)

**Improvement (if <3):**
- Score 0-1: "Spend 30 min per competitor. Visit website, check LinkedIn (followers, posts), search their content (rank for what?), look for email list."
- Score 2: "You know competitors and channels. Identify weaknesses: 'What are they NOT doing? What's missing?'"
- Score 3: "Good map. Deepen weakness analysis: For each competitor, state clearly: 'They're strong on [channel] but weak on [channel].'"

**Time to Fix:** 3-5 hours (research: sites, social, SEO, reviews)

For scoring rubric, see `scoring-rubrics.md` Section C4.

---

### C5. MENA Access Reality (5 pts)
**Type:** Free-text, 100-word limit
**Question:** For your MENA geography (SC1), what's realistic channel mix? Account for: Arabic vs. English, WhatsApp vs. email, LinkedIn penetration, event culture, mobile-first.

**Display Examples:**

**Saudi:** "Saudi finance managers: 65% LinkedIn (high); 90% WhatsApp (primary); 40% email (secondary); 25% conferences. Strategy: 35% LinkedIn, 40% WhatsApp, 15% email, 10% events. Arabic preference growing."

**Egypt:** "Egypt SME owners: 35% LinkedIn (lower); 95% WhatsApp (primary); 15% email (low); 10% conferences. Strategy: 50% WhatsApp, 35% LinkedIn, 10% email, 5% in-person. All content in Arabic."

**Evaluation Process:**
1. Extract geography (from SC1)
2. Identify MENA factors mentioned (language, WhatsApp, LinkedIn, email, events, mobile)
3. Compare student's channel mix to baseline table (see `templates.md` for MENA Channel Reference Table)
4. Assess language strategy (Arabic/English/mixed)
5. Assess local competitive positioning
6. Award: (Factors Mentioned x 0.3) + (Channel Mix Realism x 0.35) + (Language x 0.2) + (Competitive Position x 0.15)

**Improvement (if <3):**
- Score 0-1: "Research [country]'s communication norms. Google '[country] business communication preferences.' Ask 2 local founders: 'How do you reach customers here? What channels work?'"
- Score 2: "You know WhatsApp is important; expand. What about LinkedIn adoption? Email culture? Events? For [country], provide realistic percentages."
- Score 3: "Good MENA awareness. Add language strategy. Will you do Arabic outreach? How will this affect response rates?"

**Time to Fix:** 2-3 hours (research + local conversations)

For scoring rubric, see `scoring-rubrics.md` Section C5.

**Section C Total:** C1+C2+C3+C4+C5 = 0-25 pts

---

## SECTION D: MARKET GROWTH & MOMENTUM (25 POINTS)

**Goal:** Validate that market is growing and has external tailwinds.

---

### D1. Market Direction (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** What is the overall direction of your market?
- Rapidly growing (>30% YoY) (2 pts)
- Growing (10-30% YoY) (2 pts)
- Stable (0-10% YoY) (1.5 pts)
- Declining (<0% YoY) (0.5 pts)
- Don't know (0 pts) -> Triggers recommendation to research

**Free-text (75 words):** What evidence supports this? (Analyst reports, company funding, revenue growth, customer growth, market research)

**Display Example:** "Market direction: Growing (15-25% YoY). Evidence: (1) Gartner 2026 report projects [market] at 18% CAGR through 2030. (2) 5 funded competitors in last 18 months ($15M total); only 2 competitors existed 2 years ago. (3) Google Trends shows [keyword] search volume up 35% YoY. = Growing market."

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to growth category
2. Extract free-text sources: Analyst firms (Gartner, McKinsey, Statista) + competitor funding + customer growth
3. Assess evidence quality: Named firm + report year + numbers (highest) vs. generic opinion (lowest)
4. Verify consistency: Does free-text match MC? (If MC says "rapidly growing," evidence should show 30%+ growth)
5. Award: (MC x 0.4) + (Free-text Quality x 0.6)

**Improvement (if <3):**
- Score 0-1: "Research market growth. Google '[market] market size 2024 2025 2026 growth rate.' Find specific number. Spend 1 hour."
- Score 2: "You have direction but weak evidence. Find named analyst source (Gartner, Statista, IBISWorld) OR competitor funding data."
- Score "Don't know": "Research TODAY: (1) Google Trends '[market keyword]' (1-year trend up/down?), (2) Statista '[market] forecasts,' (3) Crunchbase '[market]' funding. Come back with direction + numbers."

**Time to Fix:** 1-2 hours (research)

For scoring rubric, see `scoring-rubrics.md` Section D1.

---

### D2. Tailwind Events (5 pts)
**Type:** Free-text, 150-word limit
**Question:** List regulatory, technology, cultural, or economic shifts PUSHING buyers toward solutions like yours. Examples: Vision 2030, ZATCA, GDPR, labor cost inflation, remote work, AI integration.

**Display Example:** "Tailwinds: (1) ZATCA e-invoicing mandate effective [month] -> forces modernization. (2) Saudi labor cost inflation 12% YoY -> companies automating to reduce headcount. (3) Cloud adoption 40% CAGR -> companies shifting from on-premise. (4) AI integration requirements -> want AI-powered insights. All = EXTERNAL pressure pushing toward automation solutions."

**Evaluation Process:**
1. Extract tailwind types (regulatory, economic, technology, cultural, competitive)
2. Assess specificity: "ZATCA e-invoicing effective June 2026" (specific) vs. "digitization happening" (vague)
3. Verify realism: Are dates correct?
4. Assess relevance: Does tailwind push toward student's solution? (Direct = strong; tangential = weak)
5. Assess magnitude: How many buyers affected? (Regulatory affecting ALL companies in jurisdiction = highest)
6. Award: (Tailwind Count x 0.35) + (Specificity x 0.35) + (Solution Relevance x 0.3)

**Improvement (if <2):**
- Score 0-1: "Brainstorm tailwinds. What regulatory changes, cost pressures, or technology shifts affect your market in [geography]? Find 2-3 specific examples."
- Score 2: "Be specific. Instead of 'digitization happening,' name regulation (ZATCA, Vision 2030, data law). Instead of 'costs rising,' state: 'Labor inflation 8% YoY.'"

**Time to Fix:** 2-3 hours (research)

For scoring rubric, see `scoring-rubrics.md` Section D2.

---

### D3. Competitive Landscape (5 pts)
**Type:** Free-text, 150-word limit
**Question:** Is money flowing into your space? Name funded competitors (Series A+, recent seed), acquisitions. What does this tell you about viability?

**Display Example:** "Funding: [Competitor A] $8M Series B (Q4 2025); [Competitor B] $1.5M seed (Q2 2025); [Competitor C] acquired by [acquirer] for ~$10-20M (2024). Signal: VCs fund this space = investor confidence. Exits exist = acquisition pathways. Buyers pay = revenue-generating. Space is competitive + validated. My differentiation: [specific advantage]."

**Evaluation Process:**
1. Extract competitor names (not generic)
2. Extract funding data (round, amount, date)
3. Extract acquisition data
4. Assess competitiveness: Multiple funded = validation + high competition; none funded = unvalidated
5. Check strategic interpretation: Does student understand what funding means?
6. Award: (Competitor Specificity x 0.25) + (Funding Completeness x 0.35) + (Acquisition x 0.15) + (Interpretation x 0.25)

**Improvement (if <3):**
- Score 0-2: "Find 2-3 competitors. Use Crunchbase, LinkedIn, Google. For each: founding date, funding rounds, acquisition history."
- Score 2-3: "You have competitors. Research their funding. How much? What stage? When? Check Crunchbase, news, company websites."
- Score 3-4: "Good funding data. Add interpretation. What does [Competitor A]'s Series B mean for the market? Demand? Exit path? Competition intensity?"

**Time to Fix:** 2-3 hours (Crunchbase + research)

For scoring rubric, see `scoring-rubrics.md` Section D3.

---

### D4. Search Demand Signal (5 pts)
**Type:** Multiple Choice (2 pts) + Free-text (3 pts)

**MC:** Is search demand for your solution type increasing?
- Strongly up (>20% YoY) (2 pts)
- Slightly up (5-20% YoY) (1.5 pts)
- Flat (0-5% YoY) (1 pt)
- Down (<0% YoY) (0 pts)
- Don't know (0 pts) -> Triggers recommendation

**Free-text (75 words):** What did you check? Which keywords? Tools used? Timeframe?

**Display Example:** "Search demand: Slightly up. I checked Google Trends for '[keyword 1],' '[keyword 2],' '[keyword 3]' from March 2025 to March 2026. Keyword 1 up 25% YoY; Keyword 2 flat; Keyword 3 up 15% YoY. Average = 10-15% growth. Confirmed via Keyword Tool: '[keyword]' has 2,300 monthly searches (up from 1,900 last year)."

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to demand category
2. Extract free-text research: Tools (Google Trends, Keyword Tool, Semrush) + keywords + timeframe
3. Verify methodology quality: Named tool + specific keywords + timeframe + numbers (highest) vs. generic (lowest)
4. Check consistency: Does free-text match MC?
5. Award: (MC x 0.4) + (Free-text Quality x 0.6)

**Improvement (if <3):**
- Score 0-1: "Go to Google Trends NOW. Search '[your solution type] [geography].' Check if 30-day trend is up or down. Return with direction."
- Score 2: "You checked something; add data. Google Trends '[keyword 1]' and '[keyword 2].' Report: Search volume X/month, up Y% YoY."
- Score "Don't know": "TODAY: (1) Google Trends: Search '[specific keyword suggestions]'; check 1-year trend. (2) Keyword Tool: Check monthly volume. Come back with direction + numbers."

**Time to Fix:** 30 minutes (Google Trends)

For scoring rubric, see `scoring-rubrics.md` Section D4.

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

**Combined:** MC (0-2) + Free-text (0-3) = 0-5 pts

**Evaluation Process:**
1. Map MC to readiness level
2. Extract evidence types (competitor presence, buyer conversations, market research, regulatory)
3. Check evidence quality: Multiple sources (high) vs. single source (low)
4. Assess realism: Is readiness appropriate for their geography?
5. Award: (MC x 0.4) + (Free-text Quality x 0.6)

**Improvement (if <3):**
- Score 0-1: "Research market readiness. (1) Do competitors exist in [geography]? (2) Talk to 3 ICPs: 'Do you know solutions in this category?' (3) Check regulatory status. Return with evidence-based readiness."
- Score 2: "Find one more evidence source. If you have competitor presence, add buyer conversations. If you have buyer data, add market research."
- MC does not match Free-text: "Your evidence doesn't support your claim. If you said 'Already Buying' but evidence is 'saw one competitor,' that's actually 'Aware Not Buying.' Update MC to match evidence."

**Time to Fix:** 2-3 hours (competitor + buyer research)

For scoring rubric and MENA Readiness Levels table, see `scoring-rubrics.md` Section D5.

**Section D Total:** D1+D2+D3+D4+D5 = 0-25 pts

---

**END OF DIMENSIONS.MD**
