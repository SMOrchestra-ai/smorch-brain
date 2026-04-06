# Question Bank: ICP Clarity Scoring Engine

Complete question set with scoring rubrics for Sections A-E.

---

## SECTION A: WHO — Dream Customer Profile (25 pts)

### A1. Customer Identity (5 pts)

**Question:** "Describe your ideal customer as a specific person. Include: their role/title, company size, industry, geography, and one defining characteristic that makes them YOUR buyer (not just anyone in that role)."

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or completely vague ("business owners")
- **1-2 pts:** Generic role without defining characteristic ("marketing managers in UAE")
- **3-4 pts:** Specific role + company size + industry but missing defining characteristic ("marketing managers at 5-50 person agencies in UAE")
- **5 pts:** Sharp, LinkedIn-searchable specificity with defining characteristic ("marketing managers at white-label creative agencies in UAE who are drowning in freelancer chaos")

**AI scoring approach:**
- Extracts: role, company size, industry, geography, defining characteristic
- Evaluates whether you could find this person on LinkedIn using only these criteria
- Flags if defining characteristic is actually a pain or need (not a characteristic that makes them YOUR buyer)
- **Consistency check:** Does this align with niche from SC1?

**Example strong answer:**
"Sarah: Head of Operations at a 15-person digital marketing agency in Dubai. She manages 8-12 freelancers across design, copywriting, and social. The defining characteristic: she's technologically savvy but impatient — she's tried 5 different tools in the past 18 months and quit each one because it required 'one more login.' She's looking for a solution that solves freelancer coordination in her existing Slack or WhatsApp workflow."

**Example weak answer:**
"Business owners who need to manage teams"

---

### A2. Day-in-the-Life (5 pts)

**Question:** "Walk through a typical workday for your ideal customer. Where do they spend their time? What tools do they use? What frustrates them between 9am and 6pm?"

**Word limit:** 200 words

**Scoring rubric:**
- **0 pts:** Blank
- **1-2 pts:** Generic day description ("They check email, attend meetings, work on projects")
- **3-4 pts:** Some behavioral detail with tool mentions but not frustration-focused
- **5 pts:** Vivid enough that you could write a VSL opening scene from it; includes specific tools, time blocks, and clear frustration moments

**AI scoring approach:**
- Identifies tool mentions (Slack, email, Google Drive, Asana, etc.) and evaluates specificity
- Maps time blocks (e.g., "8-9am: firefighting messages, 10am-12pm: deep work, 2-3pm: client calls, 3-5pm: admin")
- Extracts frustration triggers (context switching, manual work, information loss, approval delays)
- **Consistency check:** Do mentioned tools align with customer identity from A1?

**Example strong answer:**
"Her day starts at 8:30am with 30 minutes of Slack/WhatsApp chaos: freelancer questions, client feedback, and revision requests mixed together. 9am-12pm she's in design reviews and client calls, switching between Figma, email, and notes. Lunch. 1-2pm is 'catch-up hell' — she's lost track of which freelancer is blocked on what, so she's re-asking the same questions. 2-4pm: approval bottleneck. She's waiting on 3 client approvals before she can brief freelancers. 4-5pm: grudge work — manual project status updates in a spreadsheet because none of her tools talk to each other. She goes home frustrated that she spent zero time on strategic work."

**Example weak answer:**
"They work on projects, check email, and attend meetings."

---

### A3. Buying Behavior (5 pts)

**Question:** "How does this person typically buy solutions like yours? Do they search Google, ask peers, attend events, respond to LinkedIn, use WhatsApp groups? What triggers them to look for a solution?"

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank
- **1-2 pts:** Guessing without channel specificity ("They probably use Google")
- **3-4 pts:** Some channel knowledge but missing trigger or timeline ("They'd find us on LinkedIn or Google")
- **5 pts:** Clear buying journey with named triggers, channels, and decision timeline

**AI scoring approach:**
- Extracts: primary search channel, peer-influenced channels (WhatsApp groups, industry forums, Slack communities)
- Identifies trigger: crisis (e.g., "after missing a deadline"), time-based (e.g., "at start of financial year"), event-based (e.g., "after attending GITEX")
- Evaluates if trigger is reactive or proactive
- **Consistency check:** Do buying channels align with E (congregation points)?

**Example strong answer:**
"Sarah learns about solutions through two paths: (1) Peer recommendations — she's active in 3 WhatsApp groups for UAE marketing leaders and asks there when she's frustrated. (2) She Googles 'freelancer management tools' after getting burned by a miscommunication with a freelancer (crisis trigger). The trigger is usually a specific moment: a missed deadline, a scope creep explosion, or when she's about to hire a new freelancer and realizes she has no system. She reads reviews on G2, asks in her networks, then schedules demos. Timeline: from trigger to buying decision = 2-3 weeks if the pain is acute."

**Example weak answer:**
"They probably search on Google or LinkedIn."

---

### A4. Decision Authority (5 pts)

**Multiple choice + free-text**

**MC Question:** "Who makes the buying decision?"
- They decide alone
- They decide with 1 other person
- Committee of 3+
- They influence but don't decide

**Free-text (75 words):** "Describe the approval process."

**Scoring rubric:**
- **MC base:** 2.5 pts for selection
- **Free-text evaluation:** 2.5 pts based on:
  - **0 pts:** Vague or missing ("my boss approves it")
  - **1 pt:** Generic approval process
  - **2.5 pts:** Specific approvers named, timeline, specific blockers identified

**AI scoring approach:**
- Extracts decision maker (CEO, head of department, team lead, individual contributor)
- Identifies secondary decision maker (CFO, procurement, other departments)
- Flags if decision authority contradicts A1 (e.g., "I said operations manager" but approval requires C-suite)
- Notes approval timeline and potential deal acceleration

**Example strong answer (MC: They decide with 1 other):**
"Sarah decides but runs it by her owner because it impacts the overall tech stack. Owner's main concern: cost and whether it integrates with Slack. If it does and it's <$500/mo, she approves in same meeting. If it requires new training, owner wants a 2-week pilot first. Timeline: decision to contract = 5-10 days if both are in sync."

---

### A5. Budget Reality (5 pts)

**Multiple choice + free-text**

**MC Question:** "What's their realistic budget for a solution like yours (per month)?"
- <$50/mo
- $50-200/mo
- $200-500/mo
- $500-2000/mo
- $2000+/mo

**Free-text (75 words):** "How do you know this? (existing spend, conversations, competitor pricing)"

**Scoring rubric:**
- **MC base:** 2.5 pts for selection
- **Free-text evaluation:** 2.5 pts based on evidence quality:
  - **0 pts:** "I think they can afford it" (no evidence)
  - **1 pt:** Vague evidence ("competitors charge $X")
  - **2.5 pts:** Strong evidence (existing spend on alternatives, actual conversation, public pricing of competitors, ROI math)

**AI scoring approach:**
- Extracts budget range
- Evaluates evidence tier: assumption < competitor pricing < actual conversation < existing spend data
- **Consistency check:** Does budget align with pain urgency and customer identity from A1-A3?
  - Red flag: "They're desperate for this" but "Budget is <$50/mo"
  - Red flag: "Small 5-person agency" but "Budget is $2000+/mo"
- Flags if founder assumes their customer has same budget as their ideal customer should

**Example strong answer (MC: $200-500/mo):**
"Sarah's agency currently pays $250/mo for Asana (project management), $60/mo for Figma (design), and $50/mo for Slack. She's already spending $360/mo on tools. When I asked her how much she'd pay for one tool that replaced all three, she said '$400-600 would be a no-brainer, save me that management headache.' Also, I found that her main competitor (an enterprise freelancer management platform) charges $500-800/mo, and she's opted out of that because it's 'overkill for our size.' So $200-500 is the sweet spot before it feels like overkill, $500+ is enterprise pricing to her."

---

## SECTION B: WHAT — Pain Statements (20 pts)

### B1-B10: Top 10 Pain Statements (2 pts each, 20 total)

**Question:** "List 10 specific pain statements your ideal customer would say out loud. These are things they're RUNNING AWAY FROM. Write them as direct quotes — how your customer would actually say it, in their words."

**Word limit per statement:** 50 words max

**Guidance shown to founder:**
- Weak: "They have trouble with marketing" → Generic, not quotable, no specificity
- Strong: "I'm spending AED 5,000 a month on Instagram ads and I have no idea which ones are bringing in actual clients" → Specific, quotable, includes named cost/frequency/emotion

**Scoring rubric per statement:**
- **0 pts:** Blank, or completely generic ("hard to manage projects")
- **1 pt:** Generic pain with some context ("getting clients is hard", "managing teams is exhausting")
- **2 pts:** Specific, quotable, includes cost/frequency/emotion ("I'm losing $200/week to scope creep because my contracts don't clarify deliverables, and I find out AFTER the work's done")

**AI scoring approach for individual statements:**
- **Specificity check:** Does it name a number, frequency, emotion, or cost?
- **Quotability check:** Could you use this exact wording in copy?
- **Owner-obvious check:** Is this genuinely painful for A1's customer, or is it a solution-feature disguised as a pain?

**CRITICAL: Set-level evaluation (bonus/penalty)**

After scoring all 10 individually, AI evaluates the SET for:

1. **Diversity (no clustering):** Are all 10 versions of the same pain, or do they represent different pain axes?
   - Red flag: All 10 are variations of "I don't have a system"
   - Green: 2 pains about visibility, 3 about timeliness, 2 about collaboration, 2 about scale, 1 about compliance
   - **Penalty:** -5 pts if top 10 are 8+ repetitions of same pain

2. **Escalation (surface to deep):** Do pains escalate from surface-level (inconvenience) to deep (existential to business)?
   - Surface: "Organizing my files takes time"
   - Mid: "I miss deadlines because I'm disorganized"
   - Deep: "Clients lost me a $50K contract because we delivered late; now my reputation is damaged"
   - **Penalty:** -3 pts if all pains stay at surface level

3. **ICP consistency (founder knows their customer):** Do pains logically belong to A1's customer?
   - Red flag: Customer is a 50-person agency ops head, but pain is "I code JavaScript and debugging is hard"
   - **Penalty:** -5 pts for major inconsistency with A1 identity

4. **Intensity hierarchy:** Are the pains ranked by real intensity for the customer, or random?
   - Top 3 should be the ones that would trigger buying within 30 days
   - Bottom 3 should be real but lower priority
   - No penalty for ordering, but AI notes in recommendations if top pains don't align with A3 buying triggers

**Example strong pain statements (scored 2 each):**
- "Every Friday I spend 4 hours manually updating our project status spreadsheet because no tool integrates with our chaos. AED 4,000 in billable time spent on non-billable work."
- "I told a freelancer the deadline was Monday. He delivered Wednesday. I didn't follow up because I was in back-to-back meetings. Client found out about the delay before I did. Lost the retainer."
- "I have three freelancers who are ready to work but I don't trust them with new clients yet because I can't track their quality consistently. So I'm bottlenecking on myself."
- "My agency processes invoices manually. When a freelancer tries to double-bill me or invoice for the wrong rate, it takes me 2 days to find the original contract and fix it."
- "I hired a designer. First project, I gave feedback. Two weeks later, they delivered v4 of something I thought we agreed on in v2. Wasted effort, missed deadline, bad client experience."

**Example weak pain statements (scored 0-1):**
- "Managing freelancers is hard" (0 pts — completely generic)
- "Communication is difficult" (0 pts — vague, not quotable)
- "I want better project management" (1 pt — this is a solution feature, not a pain)
- "Teams are getting bigger" (1 pt — this is a trend, not a pain the customer experiences)

---

## SECTION C: WHAT — Pleasure Statements (20 pts)

### C1-C10: Top 10 Pleasure Statements (2 pts each, 20 total)

**Question:** "List 10 specific outcomes your ideal customer DREAMS about. These are things they're RUNNING TOWARD. Write them as aspirational statements in your customer's voice."

**Word limit per statement:** 50 words max

**Guidance shown to founder:**
- Weak: "They want more revenue" → Generic, could apply to anyone
- Strong: "I want to know exactly which leads are hot so I call them first and close before my competitor even follows up" → Specific, vivid, emotionally resonant

**Scoring rubric per statement:**
- **0 pts:** Blank or completely generic ("more money", "better systems")
- **1 pt:** Generic desire with context ("I want my team to be happier")
- **2 pts:** Specific, vivid, emotionally resonant outcome that's clearly aspirational for A1's customer ("I want to spend my mornings on strategy and client relationships, not firefighting freelancer miscommunications")

**AI scoring approach for individual statements:**
- **Specificity check:** Is this outcome concrete, or is it another abstraction?
- **Vividness check:** Can you picture the desired state?
- **Emotion resonance check:** Does it tap into pride, relief, ambition, or confidence?
- **Owner-obvious check:** Is this genuinely aspirational for A1, or is it generic?

**CRITICAL: Set-level evaluation (bonus/penalty)**

After scoring all 10 individually, AI evaluates the SET for:

1. **Specificity escalation (surface pleasure to deep satisfaction):**
   - Surface: "I want my calendar to be less busy"
   - Mid: "I want to get 4 hours back per week for strategic work"
   - Deep: "I want to be known in my market as someone who ships on time and doesn't blame freelancers for missed deadlines"
   - **Penalty:** -3 pts if all pleasures stay at surface level

2. **Pain-Pleasure mapping:** Does each major pain have a corresponding pleasure?
   - If B1 is "I lose 4 hours/week on manual admin", C1-C10 should include "I spend those 4 hours on strategy"
   - **Penalty:** -5 pts if pleasure set doesn't address main pain points

3. **Consistency with ICP:** Are aspirations realistic for A1's customer?
   - Red flag: Customer is bootstrapped founder, but pleasure is "I hire a VP of Operations"
   - Green: Customer wants autonomy, pleasure is "I can take a vacation without the agency falling apart"

4. **Emotional resonance (bonus):** Do 7+ of the 10 pleasures tap into emotion (confidence, relief, pride, belonging)?
   - **Bonus +2:** If set is emotionally rich

**Example strong pleasure statements (scored 2 each):**
- "I can hand off a project to a freelancer and wake up to finished work that matches my brief exactly. No revision loops, no surprises."
- "My team trusts the system so much that they stop asking me for updates. They look it up themselves. I'm no longer a bottleneck."
- "I tell a client about a deadline and I deliver it. On time. Every time. My reputation shifts from 'good person, slightly chaotic' to 'most reliable partner in the city.'"
- "I spend Monday-Thursday on winning new clients and strategy. Fridays, I spend 30 minutes reviewing the week and looking ahead. Admin is gone."
- "I onboard a freelancer and within 24 hours, they know exactly what to do, how we communicate, and what quality we expect. Ramp time drops from 2 weeks to 2 days."

**Example weak pleasure statements (scored 0-1):**
- "Things run smoothly" (0 pts — completely vague)
- "We'd be more organized" (1 pt — generic, could apply to anyone)
- "Fewer problems" (1 pt — abstract, not aspirational)

---

## SECTION D: WHY — Hero Journey (20 pts)

### D1. Current State (5 pts)

**Question:** "Describe your customer's current situation. What's frustrating them? What have they tried to fix it? Why haven't their solutions worked?"

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or generic ("they're struggling")
- **1-2 pts:** Surface description without emotion or specificity
- **3-4 pts:** Clear frustration described with 1-2 failed attempts mentioned
- **5 pts:** Vivid current state with named failed attempts and emotional resonance

**AI scoring approach:**
- Identifies: current pain point, emotional state (desperate vs. optimizing), failed attempts (tools, systems, workarounds)
- Evaluates whether current state aligns with B1-B10 pains
- Flags if current state is too soft ("they're looking to optimize") given acute pains

**Example strong answer:**
"Sarah's managing freelancers via WhatsApp and email. She's tried Asana (too complex), Monday.com (same), and a custom Airtable (her co-founder built it but nobody uses it). The real problem: she can't see the full picture. One freelancer hasn't responded in 2 days. She doesn't know if he's sick, overbooked, or ghosting. A client revision request sits in her email thread with 20 other messages. She's exhausted from context-switching and feels like she's losing control. She describes it as 'every day feels like I'm putting out fires.'"

---

### D2. Desired Future State (5 pts)

**Question:** "Fast-forward 90 days. If your solution worked perfectly, what would your customer's life look like? What's different? What can they now measure or feel?"

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or generic ("they'd be happy")
- **1-2 pts:** Vague future state without metrics
- **3-4 pts:** Clear outcome but missing emotional or measurable dimension
- **5 pts:** Specific, measurable, emotionally resonant future state (revenue impact, time freed, reputation shift)

**AI scoring approach:**
- Extracts: measurable outcomes (time saved, revenue gained, quality metrics, reputation shift)
- Evaluates specificity of metrics
- Flags if future state doesn't match B/C (pains/pleasures)
- Evaluates ROI coherence (does value justify A5 budget?)

**Example strong answer:**
"Sarah ships every project on time. Her freelancers know exactly what's expected before they start. She doesn't micromanage; they self-manage through a clear visibility layer. She gets 8 hours back per week. By month 3, she's landed 3 new clients because her reputation shifted from 'flaky' to 'ship-on-time.' Revenue is up 25%. Most importantly: she goes home by 6pm instead of 8pm. She's not thinking about freelancer chaos when she's with her family. Mentally, she's gone from 'hope nothing breaks today' to 'I know exactly where everything stands.'"

---

### D3. Obstacles Blocking Progress (5 pts)

**Question:** "What are the 3 real blockers preventing your customer from reaching this future state ON THEIR OWN? (Don't list features. List real obstacles.)"

**Word limit:** 150 words total (50 per obstacle)

**Scoring rubric:**
- **0 pts:** Blank or lists features disguised as obstacles ("needs a project management tool")
- **1-2 pts:** Some obstacles identified but too generic ("communication is hard")
- **3-4 pts:** 2-3 real obstacles, some with depth, minor feature language
- **5 pts:** 3 specific, business-blocking obstacles that your solution uniquely addresses

**AI scoring approach:**
- **Feature vs. obstacle distinction:** Obstacle is the blocker that exists without your solution. Feature is how you solve it.
  - Feature: "needs a tool that consolidates communication"
  - Obstacle: "Freelancers work across time zones; she can't monitor all Slack channels in real-time, so she misses updates and creates delays"
- Evaluates specificity and business impact
- Flags if obstacles don't align with B1-B10 pains

**Example strong answer:**
1. "Freelancers work across time zones (3 in US, 2 in MENA, 1 in Asia). Sarah can't monitor all conversations in real-time, so when one freelancer gets blocked, she doesn't know for 8 hours. Parallel work becomes sequential."
2. "She has no way to see work-in-progress. A freelancer says 'it's done' but Sarah only discovers issues at QA time. Rewrites blow timelines."
3. "Each freelancer has a different communication preference (Slack, email, WhatsApp, calls). Managing them individually is chaos. She has to repeat context for each person."

---

### D4. Solution Bridge (5 pts)

**Question:** "How does YOUR solution specifically address each obstacle? (Map: Obstacle 1 → Your feature/approach X → Outcome.)"

**Word limit:** 150 words (50 per obstacle)

**Scoring rubric:**
- **0 pts:** Blank or generic ("our tool helps")
- **1-2 pts:** Vague connection between solution and obstacles
- **3-4 pts:** Clear mapping of 2-3 obstacles to solutions, some depth
- **5 pts:** Specific, credible mapping for all 3 obstacles; shows deep understanding of how product solves each blocker

**AI scoring approach:**
- Evaluates clarity of: Obstacle → Product capability → Outcome
- Flags if solution feels incremental (doesn't truly solve) vs. transformational
- Assesses whether solution is unique or commoditized
- **Consistency check:** Does solution address D3, or is it describing something else?

**Example strong answer:**
1. "Obstacle: Time zone blindness → Our solution: Automated daily async summary (what happened while you slept, who's blocked, what needs approval). Sarah checks it once a day, 10 minutes, knows everything. → Outcome: She catches blockers within 24 hours, not 8 days."
2. "Obstacle: No work-in-progress visibility → Our solution: Embedded progress updates (freelancer marks 'outline done', 'rough draft done', 'final ready for review' as they go). → Outcome: Sarah reviews incrementally, gives feedback early, no QA surprises."
3. "Obstacle: Fragmented communication → Our solution: One hub where all freelancer communication lives (Slack sync, email forwarding, WhatsApp integration). Sarah communicates once; it reaches everyone. → Outcome: Context stays in one place, less context-switching chaos."

---

## SECTION E: WHERE — Congregation & Access (15 pts)

### E1. Online Congregation Points (5 pts)

**Question:** "Where does your ideal customer congregate online? Name specific platforms, groups, communities, or forums. Estimate community size and activity level."

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or generic ("LinkedIn", "Facebook")
- **1-2 pts:** Platforms named but no specificity ("LinkedIn groups for marketers")
- **3-4 pts:** Named communities with some density info ("3 WhatsApp groups for UAE marketing leads, ~500-1000 members, daily activity")
- **5 pts:** Named, density-quantified congregation points with activity assessment ("WhatsApp group: 'UAE Marketing Leaders' 847 members, 40-60 messages daily. Slack: 'MENA Founders' 1.2K members, engagement is high on #freelancer-management channel.")

**AI scoring approach:**
- Evaluates specificity: generic platforms < named communities < density data
- Assesses if congregation is high-activity or ghost towns
- Flags if online congregation is all Western-focused (may not match MENA customer)
- **Consistency check:** Align with A3 buying channels

**Example strong answer:**
"Sarah congregates in 4 places: (1) WhatsApp group 'UAE Digital Agencies' — 480 people, very active (50-80 msgs/day), leadership from agencies 5-50 people. This is where they ask tool recommendations. (2) LinkedIn — not groups, but she follows 15-20 agency leaders and engages with posts about freelancer management. (3) Slack community 'MENA Entrepreneurs' — 900 members, #agency-scaling channel is where this conversation happens. (4) Twitter — she follows agency-focused accounts and engages 2-3x/week. Highest density: WhatsApp + LinkedIn."

---

### E2. Offline Congregation Points (5 pts)

**Question:** "Where does your ideal customer congregate offline? Name specific events, meetups, conferences, or associations. How often do these happen? How many attendees?"

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or vague ("networking events")
- **1-2 pts:** Events named but no specificity or frequency ("industry conferences")
- **3-4 pts:** Named events with some details ("GITEX, annual Dubai, 100K attendees") but missing personal attendance pattern
- **5 pts:** Named events, frequency, size, AND clear indication founder/customer attends ("GITEX (Dubai, annual, 170K attendees, Sarah goes yearly); STEP Conf (quarterly, 300-500 people, she attended last time); Local chamber events (DCCI monthly brunches, 40-60 agency owners)")

**AI scoring approach:**
- Evaluates specificity of events and personal attendance credibility
- Flags if founder lists events they've never attended or aren't sure customer attends
- Assesses event relevance to customer identity

**Example strong answer:**
"Sarah attends: (1) GITEX (Dubai, annual, huge — 170K overall, agency track 5-8K). She goes for 2-3 days, not to keynotes but to the freelancer management / ops track and sponsor booths. (2) STEP Conf (quarterly, 300-500 curated entrepreneurs, very high-quality network). She's attended twice. (3) Local UAE Marketer brunches (monthly, 30-40 people, organized by DCCI). She goes every other month. (4) She's expressed interest in smaller roundtables or mastermind groups but hasn't found the right one yet."

---

### E3. 30-Day Access Strategy (5 pts)

**Question:** "Based on E1 and E2, outline your specific plan to reach 100 people in your ICP within 30 days. Include channels, action counts, timeline."

**Word limit:** 150 words

**Scoring rubric:**
- **0 pts:** Blank or "do marketing"
- **1-2 pts:** Vague channel mentions without numbers ("LinkedIn outreach + WhatsApp")
- **3-4 pts:** Some numbers and channels, but incomplete ("LinkedIn 20/day, WhatsApp intros 10")
- **5 pts:** Specific, quantified, executable 30-day plan ("LinkedIn: 40 outreaches/week (8/day, 5 days) = 160 contacts. WhatsApp warm intros: 2/day through E1 groups = 40 people. GITEX (if happening in timeframe): 20 conversations. Total: 220+ contacts, filtering to 100 high-fit.")

**AI scoring approach:**
- Evaluates math: do stated actions reach 100?
- Assesses realism: is plan executable by one founder in 30 days?
- Flags if channels don't align with E1/E2 (says "LinkedIn is low-density" but plan is LinkedIn-heavy)

**Example strong answer:**
"30-Day Access Plan: (1) WhatsApp groups (E1.1): Introduce myself in 3 UAE marketing leader groups. Ask for intro to 1-2 people per group. 3 groups × 3 intros = 9 warm conversations. (2) LinkedIn direct outreach: 40 people per week matching A1 (agency ops heads, 5-50 people, UAE-based). 160 total. Filter for 50 best-fit based on company size + recent activity. (3) STEP Conf (if in next 30 days): 15-20 conversations at event. (4) Agency associations: Intro request through 2 DCCI contacts. 5-10 referrals. Total reach: 200+ people, convert to 100+ conversations, 20-30 qualified pilots."

