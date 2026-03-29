<!-- IP:START - Command routing with methodology references -->
---
description: Deep signal-based research on a prospect company or person
argument-hint: "[company-name or person-name]"
allowed-tools: Read, Write, Bash, Grep, Glob, Task, WebSearch, WebFetch, AskUserQuestion
---

Research a prospect using signal-based intelligence. Goes deeper than generic company lookups — specifically hunting for buying signals that map to outreach wedges.

**Argument:** `$ARGUMENTS` — Company name, person name, LinkedIn URL, or domain.

**Research Phases:**

1. **Company Intelligence**
   - Company overview: size, industry, location, revenue estimate
   - Tech stack signals: what tools/platforms do they use? (CRM, marketing automation, sales tools)
   - Growth signals: hiring trends, office expansion, new markets
   - Competitive landscape: who are they competing with? Any visible weaknesses?
   - Content signals: what are they publishing? What topics? What gaps?
   - Web presence: website quality, SEO strength, social media activity

2. **Signal Detection**
   Specifically hunt for:
   - **Job postings**: hiring sales, marketing, BDR, RevOps, CX roles → growth intent
   - **Funding/investment**: recent rounds, investor announcements → budget available
   - **Leadership changes**: new CxO, VP Sales/Marketing → new initiative likely
   - **Tech stack changes**: adopting/dropping tools → integration opportunity
   - **Competitor dissatisfaction**: reviews mentioning competitor problems → switching intent
   - **Content consumption**: what industry events, publications, communities they engage with
   - **Regulatory/market shifts**: new regulations, market changes affecting their business

3. **Signal Classification**
   For each detected signal:
   - Type: Trust Signal or Intent Signal
   - Strength: Strong / Moderate / Weak
   - Freshness: days since signal detected
   - Apply Hard Stop: >90 days = stale, flag but don't prioritize

4. **ICP Fit Check**
   - Match against all active campaign ICPs
   - If fit=PASS for any campaign, note which one
   - If fit=FAIL, explain why and whether it's close

5. **Wedge Recommendation**
   Based on detected signals, recommend:
   - Best wedge angle (which signal to reference in outreach)
   - Recommended channel (email, LinkedIn, WhatsApp — based on prospect's activity patterns)
   - Draft first-touch message using the recommended wedge
   - Silence type this prospect likely has (Proof / Cost / Trust / Timing / Clarity)

**Output:**
- Prospect brief in structured format
- Save to `prospects/[company-or-name]-brief-[date].md`
- If the prospect fits an active campaign, offer to add them to the lead list
<!-- IP:END -->
