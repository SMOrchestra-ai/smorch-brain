# ICP Clarity Scoring Engine -- Output Templates

This file contains the output template for `icp-refined.md` and the Claude execution flow for running the scoring session.

---

## CLAUDE EXECUTION FLOW

### Session Start

1. **Prerequisite Verification**
   - Ask founder: "Do you have a completed Scorecard 1 (Project Definition)?"
   - If yes: Request link to `project-definition.md`
   - If no: Provide SC1 link, ask founder to complete first
   - Once received: Extract niche, positioning, geography, core problem
   - Display: "Using niche: [X], positioning: [Y], geography: [Z]. I'll flag any contradictions as we go."

2. **Explain the Philosophy**
   - "This isn't a checklist. You walk in thinking you know your customer. You walk out with a specific, scored ICP that your GTM team can actually use. Some of your answers will surprise you -- especially when we get to the Hero Journey. That's the point."

3. **Section-by-section flow** (no skipping):
   - Intro to section with framework context
   - Each question asked with word limit
   - After answer submission: immediate 0-5 score with brief reason
   - Hint offered only if score is 0-1 ("That answer is too generic. Think of a specific moment in this person's week where they feel this frustration.")

### During Scoring

- **Score 0-1:** Offer a hint immediately. Don't skip to next question.
  - "That's very broad. Can you give me a specific example? A named tool, a time of day, a conversation?"
- **Score 2-3:** Acknowledge progress, ask follow-up for clarity.
  - "Good start. You mentioned budget is $200/mo but I don't see how you arrived at that number. What's your evidence?"
- **Score 4-5:** Acknowledge and move forward.
  - "That's specific enough to act on. Moving to next question."

### After Each Section

- Display section subtotal and brief pattern recognition
  - "Section A (WHO): 18/25. Strong on identity (A1: 5) and buying behavior (A3: 5), weaker on decision authority (A4: 2). Before moving to B, quick question: Who actually approves the purchase decision -- the ops manager or the agency owner?"

### Before Section B (Pain Statements)

- Explain the 50-word format and "quotability" concept
  - "Each pain should be short enough to read in a tweet, specific enough to quote in your copy. Not 'managing teams is hard.' More like 'I lose 4 hours every Friday to manual status updates that should take 30 minutes if my tools just talked to each other.'"
- Show 2-3 strong/weak examples
- Ask founder to list all 10 pains at once, then AI scores individually + set-level

### Before Section C (Pleasure Statements)

- Explain the "running toward" framing
  - "This isn't the absence of pain. It's the dream outcome. Not 'I want fewer miscommunications.' More like 'I walk into client calls knowing every freelancer delivered exactly what was promised, on time, so I can focus on selling the next project instead of firefighting.'"
- Show examples
- Same flow: list all 10, score individually + set-level

### After Section D (Hero Journey)

- Offer optional narrative synthesis
  - "I just scored your hero journey. Here's what I'm seeing: [Current state -> Obstacles -> Solution -> Future state]. Does that feel like your customer's real story, or should we adjust?"
- This is where contradictions often surface

### After Section E (Where)

- Ask for clarification on congregation density
  - "You mentioned 'LinkedIn groups for agency owners.' How many groups? How many members? How active? I want to assess if this is a high-density congregation point."

### Post-Scoring Consistency Check

- Run consistency engine (see scoring-rubrics.md for full rules)
- Display any red/yellow flags
- Ask founder: "I'm seeing a potential contradiction. You said your customer's main pain is cost-driven, but your positioning emphasizes time-saving. Which is the real pain? This matters for messaging and product prioritization."

### Per-Section Recommendation Examples

**Section A (WHO) recommendation example:**
"A4 (Decision Authority) scored 2/5. You said 'the ops manager decides, but the owner might have a say.' That vagueness will hurt your sales process. Next time we talk, find out: Does the ops manager have budget authority up to $X without approval? If yes, you're selling to one person. If no, you're selling to two. Find out which, and revise."

**Section B (Pain) recommendation example:**
"B1-B10 total: 18/20. Individual scores are strong (mostly 2s), but set-level evaluation: your top 10 pains are 8 variations of the same pain (miscommunication). This tells me you've identified the problem but not explored the full problem space. Before GTM, spend an hour brainstorming: What are 3-5 OTHER pains your customer has? E.g., cost control? Quality assurance? Freelancer retention? Add those to your list."

**Section D (WHY) recommendation example:**
"D3 (Obstacles) scored 2/5. You listed 'they don't have a good system.' That's feature language, not obstacle language. Real obstacle: 'Each freelancer works in isolation; Sarah can't see if one is blocked waiting for another, so parallel work becomes sequential and timelines slip.' That's a blocker your solution uniquely addresses. Rephrase and resubmit."

---

## OUTPUT TEMPLATE: ICP-REFINED.MD

After scoring is complete and locked, generate `icp-refined.md` with this structure:

```markdown
# ICP Refined
**Generated from Scorecard 2: ICP Clarity**
**Date:** [Date]
**Score:** [X/100] -- [Band]
**Scorecard 1 Reference:** [Niche, Positioning, Geography]

---

## 1. Dream Customer Profile

### Identity
[A1 output]

### Day-in-the-Life
[A2 output]

### Buying Behavior & Triggers
[A3 output]

### Decision Authority
[A4 output + MC selection + evidence]

### Budget Reality
[A5 output + MC selection + evidence]

**Summary (elevator pitch):**
[1-2 sentence crystal-clear summary of WHO this customer is]

---

## 2. Pain Map (Top 10 Pains)

### High-Urgency Pains (Trigger buying within 30 days)
[B1, B2, B3 listed with scores, ranking by founder-stated urgency]

### Medium-Urgency Pains (Trigger buying within 90 days)
[B4, B5, B6 listed]

### Lower-Urgency Pains (Nice-to-have, trigger eventual upgrade)
[B7, B8, B9, B10 listed]

### Pain Set Analysis
- **Diversity:** [Y statements about 5+ distinct pain axes vs. clustering]
- **Escalation:** [X covers surface-level to deep stakes]
- **Consistency:** [Aligned with customer identity]
- **Set Score:** [0-20 with any bonuses/penalties noted]

---

## 3. Pleasure Map (Top 10 Pleasures)

### Strategic Outcomes (Business-level impact)
[C1, C2, C3 -- outcomes that impact revenue, efficiency, strategy]

### Operational Outcomes (Day-to-day transformation)
[C4, C5, C6, C7 -- outcomes that reduce friction, increase predictability]

### Personal Outcomes (How the founder feels)
[C8, C9, C10 -- confidence, relief, pride, being seen as a leader]

### Pleasure Set Analysis
- **Specificity Escalation:** [Surfaces to deep aspirations?]
- **Pain-Pleasure Mapping:** [Each pain addressed by a corresponding pleasure?]
- **Consistency with ICP:** [Aspirations realistic for customer identity?]
- **Set Score:** [0-20 with bonuses/penalties noted]

---

## 4. Hero Journey

### Current State (Where They Are Now)
[D1 output -- situation, frustration, failed attempts]

### Obstacles Blocking Progress
[D3 output -- 3 real blockers, not features]

### Solution Bridge (Your Approach)
[D4 output -- obstacle-by-obstacle mapping]

### Desired Future State (90-Day Success)
[D2 output -- measurable outcomes, emotional state, case study potential]

---

## 5. Congregation & Access Strategy

### Online Congregation Points (Highest-density first)
[E1 output with density estimates]
- Primary: [Platform/Community - estimated members/activity]
- Secondary: [Platform/Community]
- Tertiary: [Platform/Community]

### Offline Congregation Points (Highest-density first)
[E2 output]
- Primary: [Event/Space - frequency, attendee count]
- Secondary: [Event/Space]
- Tertiary: [Event/Space]

### 30-Day Access Strategy
[E3 output -- specific channels, numbers, timeline]

---

## 6. ICP Clarity Score Breakdown

| Section | Points | Score | Status |
|---------|--------|-------|--------|
| A. WHO | 25 | [X] | [Elite/Strong/Adequate/Weak] |
| B. Pain Statements | 20 | [X] | [Elite/Strong/Adequate/Weak] |
| C. Pleasure Statements | 20 | [X] | [Elite/Strong/Adequate/Weak] |
| D. Hero Journey | 20 | [X] | [Elite/Strong/Adequate/Weak] |
| E. Congregation & Access | 15 | [X] | [Elite/Strong/Adequate/Weak] |
| **TOTAL** | **100** | **[X]** | **[Elite/Strong/Adequate/Weak]** |

### Consistency Notes
[Any red/yellow flags from consistency engine, plus founder's response]

---

## 7. AI Recommendations for Improvement

### High-Impact (Do these before Scorecard 3)
1. [Specific recommendation tied to lowest-scoring section]
2. [If consistency flags exist, how to resolve]

### Medium-Impact (Do these before GTM)
1. [Section-by-section improvements]

### Nice-to-Have (Refinements for future)
1. [Polish items]

### Validation Tasks
- [ ] Have 5 customer conversations about Pain B[X]
- [ ] Verify congregation density from E1/E2 with real numbers
- [ ] Test positioning messaging with 10 people from congregation points

---

## 8. Forward-to-Scorecard-3 Notes

**Market Attractiveness readiness:**
- Pain clarity: [Strong/Adequate/Weak] -- ready to validate pain evidence?
- ICP accessibility: [Strong/Adequate/Weak] -- congregation points clear enough for reach feasibility?
- Recommendation: Proceed to SC3 / Recommend 1 revision round

---

## 9. Cross-Scorecard Flags

**For Strategy Selector (SC4):**
- Buying complexity (A4): [Low/Medium/High] -> affects strategy path fit
- Congregation density (E1/E2): [High/Medium/Low] -> affects GTM motion viability
- Pain urgency (B): [High/Medium/Low] -> affects time-to-revenue expectation

**For GTM Fitness (SC5):**
- Customer learning style (inferred from ICP): [Content-first/Demo-first/Community-first/Authority-first]
- Preferred channel mix (E1/E2): [Online-primary/Offline-primary/Mixed]
- Outreach comfort (A3): [Cold-receptive/Warm-only/Event-primary]

---

**This ICP is production-ready.** Use it in:
- Feature prioritization (which features matter most to overcome obstacles D3?)
- Positioning & messaging (pain B1-B3 -> headline; pleasure C1-C3 -> benefit statement)
- Sales process design (address obstacles D3 in objection-handling)
- GTM motion selection (congregation E1/E2 -> which channels to activate first?)
- Hiring/product spec (who builds the features that matter to this customer?)
```
