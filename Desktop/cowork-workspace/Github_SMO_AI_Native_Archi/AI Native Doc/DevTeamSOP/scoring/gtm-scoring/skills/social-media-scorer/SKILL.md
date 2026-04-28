---
name: social-media-scorer
description: Scores organic social media posts across TOFU/MOFU/BOFU funnel stages with 6 universal criteria plus stage-specific criteria. Evaluates hooks, value density, format optimization, engagement triggers, CTA alignment, and authenticity against 2026 LinkedIn/social algorithm data. Triggers on 'score my post', 'rate this social post', 'social media quality check', 'is this post ready', 'post review', 'content score', 'organic post audit', 'funnel stage check'.
---

# Social Media Scorer

**System 4 of 6 — Battle-Tested Social Media Expert Hat**

**What this scores:** Organic social media posts (primarily LinkedIn, also Twitter/X, Instagram) as campaign assets serving specific funnel stages. Every post must have a job: attract (TOFU), educate (MOFU), or convert (BOFU). Posts without a funnel assignment are random acts of content.

**Benchmark sources:** LinkedIn 2026 engagement benchmarks (Socialinsider), CMI 2025 B2B Content Marketing report, LinkedIn Algorithm 2026 mechanics. Read `references/benchmarks-2026.md` for current numbers.

**Scoring rules:** Read `references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## Funnel Stage Identification

Before scoring, identify the funnel stage:

| Stage | Goal | Audience State | Success Metric |
|-------|------|---------------|----------------|
| TOFU | Awareness & reach | Don't know you | Impressions, shares, new followers |
| MOFU | Consideration & trust | Know you, evaluating | Engagement, saves, resource downloads |
| BOFU | Conversion & action | Trust you, deciding | DMs, link clicks, meetings booked |

If the user doesn't specify, infer from the content: is it designed to attract new audience (TOFU), build trust with existing followers (MOFU), or trigger action from warm prospects (BOFU)?

---

## 6 Universal Criteria (Apply to All Funnel Stages)

### C1: Hook (First 2 Lines) — Weight: 20%

The preview before "see more" is the most valuable real estate in social media. Two lines to earn the click.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Pattern interrupt that stops the scroll. Contrarian take, specific number, bold statement, or unexpected question. Works in the preview. "I booked 47 meetings in 30 days in the Gulf market. Here's what I'd never do again." |
| 7/10 | Good | Clear hook with some specificity. Earns the "see more" click. Not generic but could be sharper. "Here's what changed when we switched from relationship-selling to signal-based outbound." |
| 5/10 | Mediocre | Decent but predictable. "Here are 5 tips for better outbound." Not contrarian. No pattern interrupt. |
| 1/10 | Failure | Generic. "Excited to share some thoughts on AI." Or starts with company news nobody cares about. |

**Fix Action:** Rewrite the first line as: [Specific number] + [Unexpected outcome/claim] + [Timeframe or context]. Delete any first line that starts with "I'm excited," "Thrilled to announce," or "Here are my thoughts."

---

### C2: Value Density — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Every line teaches, challenges, or provokes. Zero filler. Reader learns something actionable OR has a belief shifted. High insight-per-word ratio. |
| 7/10 | Good | 80%+ value content. Minor filler (1-2 setup sentences). Clear takeaway. Reader learns something specific. |
| 5/10 | Mediocre | Some value mixed with filler. "It's important to remember that..." padding. Good points buried in context. |
| 1/10 | Failure | No value. Self-congratulatory, generic motivation, or pure promotion. |

**Fix Action:** Delete every sentence that starts with "It's important to," "As we all know," or "In my experience." If a sentence doesn't teach or provoke, cut it.

---

### C3: Format Optimization — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Format matches platform algorithm preference. Carousels for frameworks (6.60% avg engagement on LinkedIn). Short paragraphs. White space. Bullets for tactical content. Visual if data-heavy. |
| 7/10 | Good | Appropriate format. Good use of white space and paragraph breaks. Readable on mobile. Not the optimal format but works. |
| 5/10 | Mediocre | Text-only when carousel would be stronger. Or wall of text with no formatting. Readable but not optimized. |
| 1/10 | Failure | Wrong format entirely. Image of text. PDF that doesn't load. 2000-word essay with no breaks. |

**Fix Action:** Check the content type against format benchmarks: frameworks/processes = carousel (6.6% engagement). Hot takes/stories = text post (keep under 300 words). Data insights = image or document. Match format to content, not comfort.

---

### C4: Engagement Trigger — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Ends with (or contains) a genuine reason for quality engagement. Question or controversial take that industry experts want to respond to. Engagement from relevant experts = 5x algorithmic weight. |
| 7/10 | Good | Engagement prompt that invites relevant discussion. Specific enough to attract quality comments. |
| 5/10 | Mediocre | "Like if you agree!" or generic "What do you think?" Not compelling enough for quality comments. |
| 1/10 | Failure | No engagement trigger. Broadcast-only. Or "DM me for details" kills public engagement. |

**Fix Action:** End with a polarizing question that your ideal prospect would care about: "Agree or disagree: [specific take related to the post]?" The question should be interesting enough that a VP would type a response, not just click like.

---

### C5: CTA Alignment — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | CTA matches funnel stage. TOFU: follow for more / engage in comments. MOFU: download resource / join webinar. BOFU: book a call / DM for details. One CTA only. |
| 7/10 | Good | CTA present and roughly appropriate. May be slightly misaligned with funnel stage. |
| 5/10 | Mediocre | CTA exists but mismatched. TOFU post with "book a demo" CTA. Or multiple CTAs. |
| 1/10 | Failure | No CTA. Or every post ends with "DM me" regardless of stage. |

**Fix Action:** Match CTA to stage: TOFU = "Follow me for more" or engaging question. MOFU = "Link to resource in comments." BOFU = "DM me [keyword]" or "Link to book in comments." One CTA per post.

---

### C6: Authenticity & Voice — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Sounds like a real person with real opinions. Includes personal experience, specific examples, or hot takes. Voice is consistent and recognizable. |
| 7/10 | Good | Authentic tone with personal perspective. Mostly consistent voice. Could be more distinctive. |
| 5/10 | Mediocre | Professional but generic. Could be written by anyone. No distinctive voice. Safe takes only. |
| 1/10 | Failure | Corporate marketing speak. "We at {{company}} are proud to..." Or obvious AI-generated content with no human fingerprint. |

**Fix Action:** Add one personal detail: a specific story, a specific failure, or a specific number from your own experience. "I know this because [specific thing that happened to me]."

---

## TOFU Stage-Specific Criteria (4 additional criteria, 25% weight)

### T1: Shareability — Weight: 8%

The ultimate TOFU test: does this post earn reposts? A share puts your content in front of someone else's entire network. Shares are the highest-value engagement signal because they require the sharer to stake their own reputation on your content.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Post is so insightful, surprising, or useful that people repost it to their own network. Contains a framework worth saving, a data point worth referencing, or a hot take worth debating. The "my network needs to see this" reaction. |
| 7/10 | Good | Interesting and valuable. People like and comment, but only 30-40% of them would repost. Good content, but the "must share" trigger is missing. Lacks the surprising data point or the perfectly articulated framework. |
| 5/10 | Mediocre | Low share motivation. The content is fine but doesn't compel reposts. Self-promotional undertone reduces share willingness. Too niche for broad sharing. People agree but don't feel the need to amplify. |
| 1/10 | Failure | Zero share motivation. Overtly self-promotional. Content that would make someone look like a shill if they shared it. Boring, obvious, or off-putting. Nobody risks their credibility on this. |

**Fix Action:** Add one surprising data point or contrarian take that makes the reader think "my network needs to see this." Test: would you repost this if someone else wrote it? If no, the content isn't share-worthy yet. Frameworks, counterintuitive data, and "here's what actually happened" stories earn the most shares.

---

### T2: New Audience Attraction — Weight: 5%

TOFU content must work beyond your existing followers. It needs to pull in people who have never heard of you. That means accessible language, universal pain points with a unique lens, and topics that the algorithm can surface to new eyeballs.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Topic appeals beyond existing followers. Touches on trending themes, universal pain points, or contrarian takes on popular subjects. Jargon is either avoided or explained inline. A marketing VP who's never heard of you would still stop to read this. |
| 7/10 | Good | Mostly accessible. Resonates primarily with existing audience but a newcomer could follow the logic. One or two inside references that might lose outsiders. Topic has broad enough appeal to attract some new followers. |
| 5/10 | Mediocre | Inside-baseball content. References previous posts, internal projects, or niche concepts without context. Existing followers get it; newcomers scroll past. Limits growth potential. |
| 1/10 | Failure | Completely inaccessible to anyone outside your immediate circle. Dense jargon, unexplained acronyms, references that require prior context. Actually repels potential new followers because they feel excluded. |

**Fix Action:** Reframe the insight so someone outside your core audience would still find it valuable. Remove or explain any jargon. Test: if a smart person in a different industry read this, would they understand AND find it interesting? If not, the entry point is too narrow.

---

### T3: Authority Signal — Weight: 7%

Authority in TOFU isn't claimed, it's demonstrated. "I'm an expert in X" is a claim. "Here's exactly what happened when we tested X across 14 accounts in 3 months" is demonstration. The best TOFU content proves expertise through specificity, not assertions.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Demonstrates expertise through specificity, not claims. Shows the work, the data, the process, the real result with enough detail that only someone who actually did it could write it. Teaches at a level that makes other practitioners nod along. |
| 7/10 | Good | Shows some real-world evidence. References specific outcomes or processes but could go deeper. Tells more than shows. "We achieved X" without the messy details that prove authenticity. |
| 5/10 | Mediocre | Generic advice anyone could give. "Consistency is key" or "always add value first." Correct but not credibility-building. Could have been written by someone who read about it rather than someone who did it. |
| 1/10 | Failure | No authority signal. Or worse, false authority: "10 years in AI" without any evidence. Generic platitudes that actively undermine credibility with experienced practitioners. |

**Fix Action:** Replace "I'm an expert in X" with "Here's exactly what happened when I did X." Include one specific detail that only someone who actually did the work would know: a failure mode, a surprising metric, a decision fork, a vendor that didn't work out. Show, don't tell.

---

### T4: Brand Memorability — Weight: 5%

A TOFU post that generates engagement but zero brand recall is a wasted post. The goal isn't just reach: it's reach that builds a mental association. Over time, your name should be linked to a specific concept, framework, or perspective in your audience's mind.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Unique angle, signature phrase, or proprietary framework that builds association. Reader can't separate the insight from the person who shared it. Uses a recurring theme or terminology that compounds over multiple posts (e.g., "Signal-to-Trust," "Dream 100"). |
| 7/10 | Good | Good content with some brand signature. The post has personality but doesn't actively build a recurring mental association. A reader might remember the insight but not who posted it. Missing the distinctive signature element. |
| 5/10 | Mediocre | Forgettable authorship. The content could have been posted by any professional in the space. Zero distinctive elements that tie back to a personal brand. Informative but generic. |
| 1/10 | Failure | Actively damages brand. Off-topic post that confuses positioning. Or tone-deaf content that makes people unfollow. Inconsistent voice that prevents any brand association from forming. |

**Fix Action:** Add your signature framework name or recurring theme that readers associate with you. If you don't have one yet, create one: name your methodology, your framework, or your contrarian position. Reference it naturally in the post. Consistency compounds: the same phrase used across 20 posts builds stronger association than 20 unique framings.

---

## MOFU Stage-Specific Criteria (3 additional criteria, 25% weight)

### M1: Educational Depth — Weight: 8%

MOFU content earns trust through competence demonstration. The reader already knows who you are: now they're evaluating whether you actually know what you're talking about. Surface-level tips don't build trust; frameworks that change how they think about a problem do.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Teaches a framework that changes how the reader thinks about a problem. Actionable AND conceptual. Reader can implement today AND understand the deeper logic. The "I never thought about it that way" reaction. Depth that makes experts share it with their team. |
| 7/10 | Good | Useful tactical advice. Reader learns something they can try. But it's a "tip" not a "framework." Changes behavior without changing thinking. Surface-level utility that doesn't build deep trust. The reader says "good point" but doesn't save it. |
| 5/10 | Mediocre | Promotional content disguised as education. "Here's why [our approach] works" dressed up as a how-to. Reader sees through it. Educational wrapper around a pitch. Or truly surface-level: "5 quick tips for better emails." |
| 1/10 | Failure | No educational value. Pure promotion pretending to teach. Or so basic that anyone with 6 months experience already knows it. Actively damages trust because the reader questions your depth. |

**Fix Action:** Teach ONE thing the reader can implement today that also reveals a deeper principle. Framework > tip. "The 3-step process for X" > "5 quick tips for X." The framework approach forces you to show your thinking, which is what builds trust. Include the WHY behind each step, not just the WHAT.

---

### M2: Trust Building — Weight: 7%

Trust at MOFU comes from vulnerability, specificity, and behind-the-scenes honesty. Only sharing wins creates suspicion. Sharing the failures, the messy middle, and the lessons learned creates connection. People trust people who admit what didn't work.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Shares failures alongside wins. Behind-the-scenes of real work: the mistake, the pivot, the unexpected result. Vulnerability where appropriate, not performative. The "I've been there too" reaction from prospects. Builds peer-level trust, not guru worship. |
| 7/10 | Good | Mostly transparent. Shares some process details. Leans toward wins over failures. Authentic but curated. Reader trusts you but feels they're seeing the highlight reel, not the full picture. |
| 5/10 | Mediocre | Only shares wins. "Another successful campaign!" vibe. Curated to the point of inauthenticity. Reader suspects the reality is messier. Fake vulnerability: "I was so scared but then it all worked out perfectly!" |
| 1/10 | Failure | Inauthentic. Obvious humble-bragging. Or oversharing personal drama for engagement bait. Neither builds professional trust. Comes across as either manufactured or unprofessional. |

**Fix Action:** Add one honest failure or lesson learned. "This didn't work, and here's what I learned..." The failure should be genuinely instructive, not a setup for how amazing the eventual win was. Include the specific mistake, the consequence, and the actual lesson: not the polished version, the real one.

---

### M3: Proof & Case Evidence — Weight: 5%

MOFU readers need evidence that your methods work in the real world, not just in theory. The most persuasive proof is specific enough to be verifiable: named clients (with permission), specific metrics, before/after comparisons, and enough context that the reader can judge whether the situation applies to them.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Specific results with context. Named or anonymized client with enough detail to be credible (industry, company size, market, challenge). Before and after with metrics. Timeframe included. Reader can map the case to their own situation. Multiple proof types: data + quote + context. |
| 7/10 | Good | One proof point that's relevant and believable. Generic enough to protect confidentiality but specific enough to be credible. "A Series B SaaS company in Dubai" not just "a client." Metric present but context could be richer. |
| 5/10 | Mediocre | Just claims. "We deliver world-class results." Or case study so generic it could be fiction. "A company improved their metrics." No specifics, no credibility. Reader has no way to evaluate the claim. |
| 1/10 | Failure | No proof at all. Pure assertion. "Our method works." Or proof that's obviously fabricated or so vague it actively damages credibility. Or social proof from irrelevant contexts (consumer case study for B2B audience). |

**Fix Action:** Add one before/after with numbers: "[Context: industry, size, market] went from [metric A] to [metric B] in [timeframe]." Include enough context that the reader can evaluate relevance. If you can't share specifics, anonymize but keep the industry, company stage, and market.

---

## BOFU Stage-Specific Criteria (3 additional criteria, 25% weight)

### B1: Urgency & Relevance — Weight: 5%

BOFU content must give warm prospects a reason to act NOW, not "someday." Real urgency comes from genuine scarcity (limited cohort spots, closing a program, genuine market timing) or compelling relevance (this applies to a decision they're making this quarter). Manufactured urgency ("LAST CHANCE! Offer expires!") posted every week destroys credibility.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Legitimate urgency tied to real constraints: limited spots in a cohort, genuine market timing (budget season, regulatory change, seasonal pattern), or a time-sensitive opportunity. Or high relevance: the post addresses something the prospect is actively deciding this quarter. Not manufactured. |
| 7/10 | Good | Some urgency or timeliness. Weak but not fake. "This matters now because [market condition]." Relevance is clear but urgency could be stronger. The prospect thinks "I should look into this" but not "I need to act this week." |
| 5/10 | Mediocre | Fake urgency posted regularly. "Reach out anytime" (no urgency at all) or "Spots filling fast!" (used every month). Neither compels action nor respects the reader's intelligence. |
| 1/10 | Failure | Destroys credibility. "LAST CHANCE!!!" posted weekly. Or aggressive pressure tactics. Or zero reason to act: no urgency, no relevance, no timing. BOFU content without urgency is just MOFU. |

**Fix Action:** Create real scarcity: limited slots, cohort start dates, or genuine market timing. If there's no real scarcity, don't fake it: instead, frame relevance. "If you're planning Q3 budget right now, this matters because [specific reason]." Tie the CTA to something happening in their world, not yours.

---

### B2: Friction Reduction — Weight: 5%

BOFU prospects have already decided they're interested. The only thing between them and action is friction. Every click, every form field, every ambiguous instruction loses a percentage of warm prospects. The CTA must be dead simple: one action, one step, zero confusion.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Dead simple CTA. "DM me 'SIGNAL'" or "Link in comments to book 15 min." One step, one action. No ambiguity about what happens next. Prospect goes from interest to action in under 10 seconds. The path from post to conversation has zero unnecessary steps. |
| 7/10 | Good | CTA is clear and relatively low friction. "Link in first comment" or "Comment 'interested' and I'll reach out." Two steps max. Minor friction but nothing that would stop a motivated prospect. |
| 5/10 | Mediocre | Multi-step CTA. "Visit our website, navigate to the pricing page, and fill out the contact form." Each step loses 40-60% of interested prospects. Or no clear path: "Check out what we do!" Link to homepage, not booking page. |
| 1/10 | Failure | No clear path from interest to action. Post generates interest but prospect has no idea what to do next. Or CTA requires downloading an app, creating an account, or filling out a 15-field form. Friction that converts interest into frustration. |

**Fix Action:** Reduce CTA to one step, one action. If it requires clicking a link, the link goes to a booking page, not a homepage. If it requires a DM, specify the keyword: "DM me 'SIGNAL'" is better than "DM me." Test: can someone act on this in under 10 seconds? If not, simplify.

---

### B3: Social Proof Stacking — Weight: 5%

At BOFU, the prospect needs final validation that choosing you is the right call. Single proof points are good; stacked proof points are decisive. A client quote PLUS a specific metric PLUS a screenshot of results creates more conviction than any one alone. The goal is to make the decision feel safe.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Multiple proof points in one post: screenshot of results + client quote + specific metric + before/after. Three or more types stacked together. Each proof point reinforces the others. Prospect thinks "everyone is working with them, I should too." |
| 7/10 | Good | Two proof types present. Metric + context, or quote + result. Credible and relevant. Builds confidence but doesn't fully close the certainty gap. Could use one more proof layer for maximum impact. |
| 5/10 | Mediocre | Single proof point at the conversion moment. One metric, one testimonial, one case study. Better than nothing but insufficient for a high-stakes B2B decision. Prospect is still Googling you after reading. |
| 1/10 | Failure | "Trust us." or "We're the best at what we do." Zero evidence. Prospect is expected to take a leap of faith. At BOFU, unsubstantiated claims don't just fail: they actively raise suspicion. |

**Fix Action:** Stack 2+ proof types in the post. Combine: client quote + specific metric, or screenshot + before/after comparison. Screenshots add visual credibility that text alone can't match. If you have video testimonials, reference them. The goal: make the decision feel inevitable, not risky.

---

## Total Weight Distribution

Universal criteria: 75% (C1-C6)
Stage-specific criteria: 25% (T1-T4 for TOFU, M1-M3 for MOFU, B1-B3 for BOFU)

Stage-specific weights are normalized within the 25% allocation:
- TOFU: T1(8%) + T2(5%) + T3(7%) + T4(5%) = 25%
- MOFU: M1(8%) + M2(7%) + M3(5%) = 20% → normalized to 25%
- BOFU: B1(5%) + B2(5%) + B3(5%) = 15% → normalized to 25%

---

## Cross-System Dependencies

When scoring social media posts, check whether low scores trace back to upstream systems:

| Low Score In | Likely Upstream Cause | Check This System |
|-------------|----------------------|-------------------|
| C1: Hook weak | Weak wedge | Campaign Strategy (C4: Wedge Specificity) |
| C2: Value low | Unclear positioning | Offer/Positioning (C1: Dream Outcome Clarity) |
| C6: Voice weak | No authority platform | LinkedIn Branding (Track A: Authority Signal) |
| T3: Authority low | No proof stacking | Offer/Positioning (C8: Risk Reversal) |
| M1: Education shallow | Positioning not defined | Offer/Positioning (C5: Unique Mechanism) |
| M3: No case evidence | Campaign not measured | Campaign Strategy (C8: Measurement Framework) |
| B1: No urgency | No campaign hierarchy | Campaign Strategy (C5: Q>M>W>D Hierarchy) |
| B2: High friction CTA | Wrong channel | Campaign Strategy (C3: Channel-Market Fit) |

If a criterion scores below 6.0 and the dependency table indicates an upstream cause, flag it: "This score is likely a symptom. The root cause is [upstream system] scoring [X] on [criterion]. Fix the upstream issue first."

---

## Scoring Execution

### Input Required
1. The social media post (text, images, carousel slides)
2. Funnel stage (TOFU/MOFU/BOFU) - auto-detect if not specified
3. Target platform (LinkedIn default, or specify Twitter/X, Instagram)

### Scoring Mindset

Think like a social media strategist who manages a B2B founder's personal brand with 50K+ engaged followers. You know that:
- Carousels outperform everything else on LinkedIn at 6.6% engagement
- The first 2 lines are worth more than the rest of the post combined
- Expert engagement (comments from VPs, CROs, founders) carries 5x algorithmic weight
- Build-in-public content gets 3-5x more engagement than polished expert content in Arabic markets
- 4-5 posts/week is the sweet spot for personal brands
- Original content gets 5x more reach than reshares

### Process

1. Read the post content
2. Identify or confirm funnel stage (TOFU/MOFU/BOFU)
3. Score all 6 universal criteria (C1-C6) on 1-10 scale
4. Score the stage-specific criteria (T1-T4, M1-M3, or B1-B3)
5. For any criterion below 7.0, include the Fix Action
6. Check cross-system dependencies for any score below 6.0
7. Calculate weighted average (75% universal + 25% stage-specific)
8. Check hard stops (any criterion below 5.0)
9. Assign verdict per `references/score-bands.md`
10. Present the score report
11. Offer to fix the top issues immediately

Score honestly. An 8.0 with clear fix actions is more useful than a generous 9.0 that hides gaps.
