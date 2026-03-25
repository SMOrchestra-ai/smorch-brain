# ICP Clarity Scoring Engine -- Scoring Rubrics

This file contains all detailed rubrics, scales, scoring logic, consistency engine rules, scoring bands, MENA-specific scoring context, and the recommendation engine.

---

## SCORING RUBRICS PER QUESTION

### Section A: WHO (25 pts)

**A1. Customer Identity (5 pts):**
- **0 pts:** Blank or completely vague ("business owners")
- **1-2 pts:** Generic role without defining characteristic ("marketing managers in UAE")
- **3-4 pts:** Specific role + company size + industry but missing defining characteristic ("marketing managers at 5-50 person agencies in UAE")
- **5 pts:** Sharp, LinkedIn-searchable specificity with defining characteristic ("marketing managers at white-label creative agencies in UAE who are drowning in freelancer chaos")

**A2. Day-in-the-Life (5 pts):**
- **0 pts:** Blank
- **1-2 pts:** Generic day description ("They check email, attend meetings, work on projects")
- **3-4 pts:** Some behavioral detail with tool mentions but not frustration-focused
- **5 pts:** Vivid enough that you could write a VSL opening scene from it; includes specific tools, time blocks, and clear frustration moments

**A3. Buying Behavior (5 pts):**
- **0 pts:** Blank
- **1-2 pts:** Guessing without channel specificity ("They probably use Google")
- **3-4 pts:** Some channel knowledge but missing trigger or timeline ("They'd find us on LinkedIn or Google")
- **5 pts:** Clear buying journey with named triggers, channels, and decision timeline

**A4. Decision Authority (5 pts):**
- **MC base:** 2.5 pts for selection
- **Free-text evaluation:** 2.5 pts based on:
  - **0 pts:** Vague or missing ("my boss approves it")
  - **1 pt:** Generic approval process
  - **2.5 pts:** Specific approvers named, timeline, specific blockers identified

**A5. Budget Reality (5 pts):**
- **MC base:** 2.5 pts for selection
- **Free-text evaluation:** 2.5 pts based on evidence quality:
  - **0 pts:** "I think they can afford it" (no evidence)
  - **1 pt:** Vague evidence ("competitors charge $X")
  - **2.5 pts:** Strong evidence (existing spend on alternatives, actual conversation, public pricing of competitors, ROI math)

---

### Section B: Pain Statements (20 pts)

**B1-B10 Individual scoring (2 pts each):**
- **0 pts:** Blank, or completely generic ("hard to manage projects")
- **1 pt:** Generic pain with some context ("getting clients is hard", "managing teams is exhausting")
- **2 pts:** Specific, quotable, includes cost/frequency/emotion ("I'm losing $200/week to scope creep because my contracts don't clarify deliverables, and I find out AFTER the work's done")

---

### Section C: Pleasure Statements (20 pts)

**C1-C10 Individual scoring (2 pts each):**
- **0 pts:** Blank or completely generic ("more money", "better systems")
- **1 pt:** Generic desire with context ("I want my team to be happier")
- **2 pts:** Specific, vivid, emotionally resonant outcome that's clearly aspirational for A1's customer ("I want to spend my mornings on strategy and client relationships, not firefighting freelancer miscommunications")

---

### Section D: Hero Journey (20 pts)

**D1. Client's Current State (5 pts):**
- **0-1 pts:** Vague ("They're frustrated")
- **2-3 pts:** Some detail about situation or attempts, but missing frustration or clarity on failed attempts
- **4-5 pts:** Vivid enough to be a VSL opening scene; includes situation, frustration level, specific attempts/failures

**D2. Client's Desired Future State (5 pts):**
- **0-1 pts:** Vague ("They'll be happy", "Things will be better")
- **2-3 pts:** Somewhat specific but missing time-bound or measurable element
- **4-5 pts:** Measurable, time-bound, vivid -- could be a case study/testimonial

**D3. The Obstacles (5 pts):**
- **0-1 pts:** Restates features as obstacles ("They don't have a tool that integrates with Slack")
- **2-3 pts:** Real obstacles but generic ("Communication is hard", "Coordination takes time")
- **4-5 pts:** Specific, validated obstacles that your product uniquely addresses (but aren't just feature rephrasing)

**D4. The Solution Bridge (5 pts):**
- **0-1 pts:** Generic claims ("Our tool makes things better", "We help teams communicate")
- **2-3 pts:** Some obstacle-solution mapping but incomplete or vague
- **4-5 pts:** Clear 1:1 obstacle-to-solution mapping with specificity; not just features, but how features remove obstacles

---

### Section E: Congregation & Access (15 pts)

**E1. Online Congregation Points (5 pts):**
- **0-1 pts:** Generic platforms ("Facebook and LinkedIn")
- **2-3 pts:** Named platforms with some specificity ("LinkedIn groups for agency owners")
- **4-5 pts:** Specific groups, communities, forums, influencers, hashtags with membership/relevance explanation

**E2. Offline Congregation Points (5 pts):**
- **0-1 pts:** Generic ("Business events")
- **2-3 pts:** Named events but generic ("Annual marketing conference")
- **4-5 pts:** Named specific events with MENA relevance and frequency (e.g., "GITEX, STEP, Abu Dhabi Publishing Forum, Flex Events")

**E3. Access Strategy (5 pts):**
- **0-1 pts:** Vague ("I'll do marketing", "I'll network")
- **2-3 pts:** Some channels named but vague on execution ("I'll reach out to people on LinkedIn and attend events")
- **4-5 pts:** Specific plan with named channels, numbers, timeline, and realistic execution (e.g., "LinkedIn outbound to 40 people (2/day), referrals from 3 existing customers (10 intros), STEP event (25 conversations), WeSpace community (10 members), WhatsApp group outreach (15 people).")

---

## AI SCORING ARCHITECTURE

### Universal Rubric (Applied across all sections)

Every free-text answer is evaluated on a 0-5 scale:

| Score | Signal | Evidence |
|-------|--------|----------|
| **0** | Blank or incomprehensible | Missing answer, random text, or completely off-topic |
| **1** | Generic/guessing | Cliched language, no specificity, could apply to any customer or market |
| **2** | Surface-level attempt | Some specificity but missing key dimensions (e.g., named tool but no emotion) |
| **3** | Good foundation | Specific enough to act on, but missing depth or evidence |
| **4** | Strong clarity | Specific, evidence-based, actionable, minor gaps |
| **5** | Production-ready | Specific, vivid, evidence-based, quotable, action-ready |

### Question-Specific Rubrics

Each question's rubric (above) takes precedence over the universal rubric. E.g., A1 "Dream Customer" has a specific 5-point scale tied to LinkedIn searchability.

### Special Handling: Pain/Pleasure Statements (Sections B & C)

**Individual scoring:** 0-2 pts per statement (not 0-5)

**Set-level scoring:** After all 10 are scored individually, AI applies penalties and bonuses:
- **Bonus +5:** If set shows excellent diversity, escalation, AND ICP consistency
- **Penalty -5:** If 8+ statements are repetitions of same pain/pleasure
- **Penalty -3:** If pains/pleasures don't escalate from surface to deep
- **Penalty -5:** If pleasure set doesn't map to pain set

Example:
- B1-B10 scored individually: 2+2+2+1+2+2+2+1+2+2 = 18 pts
- Set-level evaluation: Strong diversity (+0), good escalation (+0), excellent consistency with A1 (+2 bonus)
- **Final B Score: 20 pts** (capped at 20, not 25)

---

## CONSISTENCY ENGINE

After all sections are complete, I scan for contradictions between SC1 outputs and ICP answers:

**Red flag contradictions (trigger immediate notification):**

1. **Niche vs. Budget mismatch**
   - SC1 niche: "Premium B2B SaaS for enterprise"
   - ICP A5 Budget: "<$50/mo"
   - Flag: "Your niche positioning is premium, but budget selection suggests price-sensitive buyers. Clarify which is your actual target."

2. **Positioning vs. Pain mismatch**
   - SC1 positioning: "We help you save time on freelancer management"
   - ICP B1-B10: Top pains are all about cost/revenue, none about time
   - Flag: "Your positioning emphasizes time-saving, but your ICP's top pains are cost-driven. Which is the real problem? Consider repositioning or refocusing ICP."

3. **Geography vs. Congregation mismatch**
   - SC1 geography: "Saudi Arabia, Riyadh"
   - ICP E1: "WhatsApp groups for UAE founders", "GITEX (Dubai)"
   - Flag: "Your geography is KSA but congregation points are UAE. Are you targeting KSA or UAE? Clarify and adjust E1/E2."

4. **Customer identity vs. Day-in-the-life mismatch**
   - ICP A1: "Digital marketing managers at 50-person agencies"
   - ICP A2: Day includes "engineering tasks", "data analysis", "server management"
   - Flag: "Your customer identity is marketing manager, but day-in-the-life is operations/technical. Clarify which role you're targeting."

5. **Budget vs. ROI mismatch (from D4)**
   - ICP A5: Budget is $50-200/mo
   - ICP D2: Desired future state is "$10M in additional revenue"
   - ICP D4: Solution delivers "$100K value"
   - Flag: "ROI numbers don't match budget sensitivity. A buyer only willing to spend $50-200/mo won't justify a product with $100K value. Either budget is wrong or value is overstated."

6. **Pain statements vs. Hero Journey mismatch**
   - ICP B1-B10: Pains are all about "miscommunication with freelancers"
   - ICP D1 (Current state): "Situation is fine, just looking to optimize"
   - Flag: "Pain statements suggest crisis, but current state suggests optimization. Is your customer desperate or optimizing? This affects buying timeline in A3."

7. **Pleasure statements vs. Obstacle mismatch**
   - ICP D3 Obstacle: "Freelancers are in different time zones"
   - ICP C1-C10: No pleasure statement addressing time zone challenge
   - Flag: "Your main obstacle (time zones) doesn't have a corresponding pleasure statement. Add one or reconsider if this obstacle is primary."

**Yellow flag warnings (notify, but don't block):**
- ICP A4 decision authority is "committee of 3+" but A1 customer is "individual contributor" (likely can't make committee decisions)
- Buying trigger in A3 is "emergency" but buying cycle is "3 months" (doesn't align)
- ICP congregation points are primarily offline but A3 buying behavior is "search online"

---

## SCORING BANDS

Final ICP Clarity Score: **0-100 pts**

| Band | Score | Interpretation | Recommendation |
|------|-------|-----------------|-----------------|
| **Elite** | 85-100 | ICP is vivid, specific, evidence-backed, GTM-ready | Launch GTM immediately. Data for all downstream scorecards ready. |
| **Strong** | 70-84 | ICP is clear and actionable with minor gaps | One revision round; fix highest-impact gaps (usually pain/pleasure set diversity, or obstacle clarity). Proceed to Scorecard 3. |
| **Adequate** | 55-69 | ICP has foundation but needs rework on 1-2 sections | Revise identified sections. Common: Day-in-the-life lacks specificity, or congregation points are too generic. Resubmit before proceeding. |
| **Weak** | 40-54 | ICP is generic; feels like educated guessing | Major rework needed. Likely: founder hasn't validated assumptions with customers yet. Recommend 3-5 customer conversations before resubmitting. |
| **Foundational** | 0-39 | ICP is unfocused or contradictory | Start over. Run founder through customer discovery process first. Scorecard is not yet possible. |

---

## VALIDATION REALITY CHECK: Customer Interview Gate

**Steve Blank Mandate: "Get out of the building."**

This system prevents a critical failure: founders scoring 85-95/100 on ICP Clarity without having had a single real conversation with their target customer. To address this, SC2 includes an interview validation gate BEFORE scoring proceeds.

### Interview Validation Protocol

**At the START of SC2, ask:**
> "How many real, unscripted conversations have you had with people matching this ICP in the last 30 days? (These must be 1-on-1 conversations -- not group interviews, not hypotheticals, not your own assumptions.)"

**Founder's answer maps to one of three tracks:**

| Conversation Count | Track | Output | Score Impact |
|---|---|---|---|
| **0 conversations** | Red Flag | Flag Warning + Strong Recommendation | No penalty to final score, but BLOCKADE: "Before you continue, please schedule 3 customer conversations in the next 5 days. Return with notes. SC2 isn't a replacement for customer discovery." |
| **1-4 conversations** | Moderate Advisory | Advisory Note in icp-refined.md | No penalty, but include notation: "ICP validated against [N] customer conversations. Recommend 3 more before GTM launch." |
| **5+ conversations** | Validated | Clean Progression | No flag; proceed normally. Include: "ICP validated against [N] customer conversations." |

### Validation Track Determines Recommendation Engine

**If Red Flag (0 conversations):**
- Display this before SC2 proceeds:
  > "Your ICP is well-articulated on paper, but it's untested. Steve Blank's core principle applies here: you don't have an ICP until a real customer confirms it by saying 'Yes, that's me.' Right now, this is a hypothesis. We recommend you pause SC2 and conduct 3 quick interviews (20 minutes each) with people you THINK match this profile. Here's a template: [INTERVIEW_TEMPLATE]. Come back when you have notes."
- Option: **Allow continuation with warning** ("Skip this check and continue") -- but flag in final output.

**If Moderate Advisory (1-4 conversations):**
- Include in `icp-refined.md` header:
  > "**Validation Note:** This ICP is based on [N] customer conversations. It's directionally sound but not fully validated. Recommend conducting 2-3 more conversations in parallel with GTM to confirm messaging resonates."

**If Validated (5+):**
- Include in `icp-refined.md` header:
  > "**Validation Note:** This ICP is validated against [N] real customer conversations. Confidence: HIGH."

### How This Feeds Recommendation Engine (Not Score Itself)

The interview count does NOT reduce the 100-point score. Instead, it:
1. **Flags confidence level** in the final output
2. **Prioritizes which Section scores matter most** (e.g., if 0 conversations, all answers are hypothesis-quality, so recommendations focus on "validate this assumption")
3. **Shapes GTM recommendations** (if 5+ conversations, skip discovery-phase GTM; if 0 conversations, build discovery-phase GTM)
4. **Suggests interview topics for next phase** (e.g., "Section C (Pleasure) felt generic. Ask customers directly: 'What does success look like?'")

---

## MENA-SPECIFIC SCORING CONTEXT

Throughout scoring, I account for MENA-specific nuances:

### Geography & Payment
- If geography is UAE/KSA: acknowledge higher credit card penetration, but validate BNPL adoption (Tabby, Tamara)
- If geography is Egypt/Levant: acknowledge WhatsApp and bank transfer preference, lower credit card trust
- A5 (Budget Reality) scoring: "You said $500/mo. In KSA, that's reasonable for B2B SaaS. In Egypt, that might be 3-6x the expected price. Validate."

### Congregation Points (E1 & E2)
- **Online:** Recognize that MENA founders often congregate in:
  - WhatsApp business groups (higher trust signal than LinkedIn in some markets)
  - Slack communities (growing, but less adopted than in US)
  - Twitter (Arabic and English speakers, good for visibility)
  - Instagram (emerging as B2B channel in MENA, underestimated)
  - Local job boards/portals (Bayt.com, Naukrigulf, LinkedIn Local)
- **Offline:** Recognize major MENA events:
  - GITEX (Dubai, annual, 170K attendees, largest tech event in MENA)
  - STEP Conf (Dubai/other cities, networking-focused)
  - Flex Events (Abu Dhabi, curated entrepreneur events)
  - Arab Startups Conference
  - Local chambers of commerce (DCCI, ADCCI, others)
- Red flag: If E1/E2 are entirely Western congregation points (ProductHunt, Hacker News, TechCrunch), flag it
  - "Your congregation points are Western-focused. MENA buyer behavior is different -- more WhatsApp, more relationship-based. Are you sure these are where your MENA customer actually congregates?"

### Buying Behavior (A3)
- MENA-specific triggers:
  - Personal referral from trusted source (highest trust signal)
  - Regulatory mandate (e.g., ZATCA e-invoicing in KSA, VAT compliance in UAE)
  - Seasonal urgency (e.g., Ramadan, Eid, year-end planning cycles)
  - Event attendance (personal relationship still matters)
- Red flag: If buying trigger is "random Google search" but A3 says "very relational, wants to know vendor personally", flag contradiction
  - "Your customer decides via personal referral (relational), but buying trigger is 'searching Google' (low-trust signal). How do they actually find you? Referral or search?"

### Decision Authority (A4)
- MENA nuance: Decision authority often involves more stakeholders than in Western markets
  - Individual contributor decides personally (rare for tech spending in MENA B2B)
  - Manager approves (common for <$1K/mo)
  - Owner/C-suite involved (common for $1K+/mo, even if just looped in)
  - Budget owner + IT department (if anything touching systems)
- AI scoring: account for this relationship-heavy decision-making

### Pain Statements (B)
- MENA-relevant pains to probe for (if missing):
  - Language/Arabic support (if not mentioned)
  - Compliance with local regulations (if not mentioned)
  - Difficulty finding talent (particularly technical)
  - Geographic distribution (across UAE, KSA, Egypt, etc.)
  - Currency/payment handling (if multinational team)
- If pains are entirely Western-generic, flag it: "Your pains sound like they could apply to any market. Are there MENA-specific pains? Regulatory? Talent? Language?"

### Current State & Hero Journey (D1)
- MENA context:
  - Founder bootstrapping (no external capital) is the default -- affects available budget
  - Manual processes (WhatsApp, spreadsheets, email) are the baseline, not the exception
  - Many MENA founders are in "survival mode" (revenue needed in 30 days)
- AI scoring should adjust expectations for "sophistication" (a MENA founder with a spreadsheet is normal; don't mark that as weak)

---

## RECOMMENDATION ENGINE

### Per-Question Recommendations

**If A1 scores 0-2:**
"Your customer identity is too generic. On LinkedIn, you couldn't find this person using your description. Before proceeding, narrow down: What's the smallest company where this person exists? What's the most specific title? What's one thing about them that makes them buy from you (not from competitors)?"

**If A2 scores 0-2:**
"Your day-in-the-life is too generic. It could apply to any professional. Next time, include: specific tools they use, specific frustrations at specific times, emotional temperature (are they calm, stressed, resigned?). If you can't picture the day vividly, you haven't researched enough."

**If A3 scores 0-2:**
"You're guessing how this person finds solutions. Before you do GTM, find 3 people in this role and ask: 'How did you find your current [tool] solution? Where were you when you started looking? Who did you ask?' Document the pattern."

**If A4 scores 0-2:**
"You don't know who actually makes the decision. This is critical for sales. Get on a call with 1-2 prospects and ask: 'If you loved this, what would need to happen for you to sign a contract? Who else would be involved?'"

**If A5 scores 0-2:**
"Your budget assumption isn't evidence-based. Check: (1) What do they currently pay for alternatives? (2) Ask 3 people directly: 'What would you pay for a solution that solved X?' (3) Look up competitor pricing."

**If B1-B10 individual scores are mostly 0-1:**
"Your pain statements are too generic. Each one should be quotable -- something a customer would say in a rant to a friend. Rewrite them as specific moments: not 'managing is hard,' but 'Last Tuesday, I realized I had no idea which freelancer was closest to deadline, so I had to check 5 different Slack conversations to figure it out.'"

**If B set-level score penalized for clustering:**
"Your top 10 pains are all versions of the same pain. This tells me you've found ONE problem but haven't explored the full problem landscape. Brainstorm: What are 3-5 OTHER problems your customer has? What keeps them up at night besides [main pain]? Add those to your list."

**If C set-level score penalized for not mapping to B:**
"Your pleasure statements don't address your pain statements. If your main pain is 'miscommunication,' a pleasure statement should be something like 'Every request is crystal clear; no one has to ask twice.' Link them 1:1 and resubmit."

**If D1 scores 0-2:**
"Your current state is too soft. You said 'they're looking to optimize.' That doesn't sound like someone with buying urgency. Is your customer desperate (crisis) or optimizing (nice-to-have)? This determines sales cycle length. Be honest."

**If D2 scores 0-2:**
"Your future state is vague. Don't say 'they'll be happy.' Say what their life looks like 90 days in: metrics they can track, time they get back, confidence they feel. Something specific enough to become a testimonial."

**If D3 scores 0-2:**
"You're restating features as obstacles. Obstacle: 'Freelancers work across time zones; Sarah can't monitor all communication in real-time.' Feature: 'needs a consolidated communication tool.' Don't conflate them. Name real blockers."

**If D4 scores 0-2:**
"You're making generic claims ('our tool helps'). Map each obstacle to your specific solution. Obstacle 1 -> your feature X addresses it by doing Y. Be specific. If you can't explain how you solve the obstacle, you don't yet."

**If E1 scores 0-2:**
"Your congregation points are too generic. 'LinkedIn' isn't a congregation point; 'LinkedIn group for marketing leaders in UAE with 4K members' is. Go deeper: specific groups, communities, forums, hashtags. Name them."

**If E2 scores 0-2:**
"You don't actually know where this customer gathers offline. Attend one of the events you listed and observe: Is your ideal customer there? How many? How active are they? Or ask 3 people in this role: 'Which events/meetups do you attend?'"

**If E3 scores 0-2:**
"Your access plan is too vague. Get specific: 'LinkedIn outbound to 40 people (2/day), WhatsApp warm intros (15 people), STEP event (25 conversations).' Numbers + channels + timeline. If you can't describe how to reach 100 people, you can't GTM."

---

### Cross-Scorecard Recommendations

**ICP -> Market Attractiveness (Scorecard 3):**
- "Strong pain clarity in Scorecard 2 means Scorecard 3 will focus on validating those pains with evidence. Start collecting customer conversations that confirm pain B1-B3."
- "Weak congregation clarity means Scorecard 3 will flag accessibility risk. Before you proceed, clarify E1 and E2."

**ICP -> Strategy Selector (Scorecard 4):**
- "Low decision authority (A4) -> Strategy paths like 'Dream 100' and 'Hammering Deep' require very fast sales cycles. If your buyer is a committee, adjust strategy to 'Consulting-First' or 'Authority Education' for longer nurture."
- "High congregation density (E1/E2) -> You can execute 'Dream 100' or event-based strategies. Low density -> Content-first or paid channels are more viable."

**ICP -> GTM Fitness (Scorecard 5):**
- "Buying behavior (A3) tells us which GTM motions to activate first. If they buy via peer recommendation, 'Referral loops' and 'Community' motions score high. If they buy via Google search, 'SEO' and 'Authority Education' score high."
