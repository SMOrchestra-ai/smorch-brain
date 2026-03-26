---
name: linkedin-branding-scorer
description: Scores LinkedIn personal brand posts across 2 tracks. Track A (English B2B) evaluates authority building and client acquisition triggers with 9 criteria. Track B (Arabic Entrepreneurs) evaluates aspiration, AI demystification, training funnel, and community building with 8 criteria. Triggers on 'score my LinkedIn post', 'LinkedIn branding review', 'is this post ready', 'LinkedIn quality check', 'authority post score', 'Arabic post review', 'Track A score', 'Track B score', 'personal brand audit'.
---

# LinkedIn Branding Scorer

**System 6 of 6 — Battle-Tested LinkedIn Personal Branding Expert Hat**

**What this scores:** LinkedIn personal brand posts across two distinct tracks with different audiences, languages, goals, and success metrics. This is NOT general social media scoring (use social-media-scorer for that). This scorer evaluates the strategic personal branding layer: is this post building Mamoun's specific authority and driving the right audience to the right action?

**Benchmark sources:** LinkedIn 2026 engagement data (Socialinsider), LinkedIn Algorithm 2026 (Brixon), Founder Personal Branding 2026 data, LinkedIn Workplace Report 2025. Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/benchmarks-2026.md` for current numbers.

**Scoring rules:** Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## Track Selection

| Track | Language | Audience | Goal | Posting Schedule |
|-------|----------|----------|------|-----------------|
| **Track A** | English | B2B clients (VPs, CROs, founders in MENA) | Build authority + trigger prospects to reach out | Tuesday, Thursday |
| **Track B** | Arabic (Gulf conversational) | Aspiring entrepreneurs in MENA | Build movement + drive to EO training | Sunday, Monday |

If the user doesn't specify the track, determine from the post language and content focus.

**Key difference from social-media-scorer:** Social media scorer evaluates any organic post against funnel-stage criteria. LinkedIn branding scorer evaluates whether posts serve the dual-track personal branding strategy with track-specific criteria. A post can score well on social-media-scorer but poorly on linkedin-branding-scorer if it doesn't serve the strategic goal.

---

## TRACK A: ENGLISH B2B CLIENT POSTS — 9 Criteria

**Strategic purpose:** Every post either builds Mamoun's credibility as the signal-based GTM expert for MENA B2B markets or triggers a prospect to reach out. Inbound from content converts at 14.6% vs 1.7% for cold outbound. That's the ROI of this entire track.

### C1: Hook Power — Weight: 18%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | First line stops a VP of Sales or CRO mid-scroll. Bold, specific, contrarian, or surprising. "I stopped sending connection requests for 30 days. Inbound doubled." Works in preview before "see more." |
| 7/10 | Good | Clear hook with specificity. Earns the click. "Here's what changed when we switched from relationship-selling to signal-based outbound in the Gulf." |
| 5/10 | Mediocre | Decent but predictable. "Here are my top tips for B2B outbound." Not scroll-stopping. |
| 1/10 | Failure | Generic. "Excited to share my thoughts on sales strategy." Or starts with a hashtag. |

**Fix Action:** Rewrite first line with this formula: [Specific action I took] + [Surprising result with number]. "I [did unexpected thing]. [Measurable outcome]."

---

### C2: Authority Signal — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Demonstrates expertise through specificity and results, not claims. "We ran 127 campaigns in Gulf markets last quarter. Here's what the data shows..." Shows the work. Named frameworks. Regional expertise visible. |
| 7/10 | Good | Clear expertise demonstrated. Specific examples. May not have the hard data but shows depth of experience. |
| 5/10 | Mediocre | Claims without evidence. "With 20 years of experience, I can tell you..." Tell, not show. |
| 1/10 | Failure | No authority. Generic advice anyone could post. |

**Fix Action:** Replace claims with evidence. Instead of "I'm experienced in X," write "Here's what happened when we ran X for [client type] in [market]: [specific result]."

---

### C3: Contrarian Angle — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Challenges conventional wisdom that your ICP holds. "Everyone says build relationships first in the Gulf. Wrong. Build proof of competence first." Takes a position. Creates debate. Backed by evidence. |
| 7/10 | Good | Fresh take on a known topic. Not just repeating industry consensus. Has a point of view. |
| 5/10 | Mediocre | Safe take. Agrees with conventional wisdom. True but not differentiated. |
| 1/10 | Failure | No angle. Or contrarian without substance. |

**Fix Action:** Identify the most popular belief in your ICP's world. State the opposite. Support with one specific experience or data point. "Everyone says [popular belief]. Here's why I disagree: [evidence]."

---

### C4: Client Trigger Density — Weight: 15%

This is the money criterion. Does the post make an ideal client think "I need to talk to this person"?

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Post makes ideal client think "I need to talk to this person." Contains specific problem they recognize, specific result they want, or specific gap they feel. "If your outbound reply rate in the Gulf is below 3%, you're probably making one of these 3 mistakes..." |
| 7/10 | Good | Post is relevant to potential clients. They'd bookmark it or share it. May not trigger immediate "I need help" response. |
| 5/10 | Mediocre | Interesting but doesn't trigger buying action. Reader thinks "good content" but not "I need their help." |
| 1/10 | Failure | Zero relevance to clients. Personal musings, motivational quotes, or tech commentary disconnected from their problems. |

**Fix Action:** Add one sentence that directly addresses a pain your ICP feels: "If you're [experiencing specific problem], here's what's actually causing it." The reader should think "that's exactly my situation."

---

### C5: Value-to-Promotion Ratio — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 80%+ value, 20% or less promotion. Even promotional posts teach first. Authority sells through existence, not CTAs. |
| 7/10 | Good | 70/30 value to promotion. Occasional CTA but wrapped in genuine value. |
| 5/10 | Mediocre | 50/50. Feels salesy. "Here are 3 tips... DM me for help." Heavy-handed. |
| 1/10 | Failure | Pure promotion. "We just launched our new service!" |

**Fix Action:** Remove the pitch entirely. If the content is strong enough, prospects will DM you without being asked. If you must CTA, make it value-first: "I wrote a breakdown of this framework — reply 'SIGNAL' and I'll send it."

---

### C6: MENA Market Specificity — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | References Gulf-specific realities: WhatsApp as primary business channel, Arabic trust dynamics, Ramadan timing, regional logos as social proof. Not a Western post with "MENA" added. |
| 7/10 | Good | MENA context present. Regional examples or data. Shows familiarity with the market beyond surface level. |
| 5/10 | Mediocre | Mentions MENA occasionally but content is 90% generic. Could be about any market. |
| 1/10 | Failure | Zero regional context. US-centric examples, USD pricing, Western cultural assumptions. |

**Fix Action:** Add one MENA-specific detail: a Gulf-specific example, a regional benchmark, a cultural insight, or a named regional client/market. This is your competitive moat on LinkedIn.

---

### C7: Format & Readability — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Right format for content type. Carousel for frameworks (6.6% engagement). Text for hot takes. White space. Short paragraphs. Skimmable AND deep-readable. |
| 7/10 | Good | Good formatting. Readable on mobile. Appropriate format choice. |
| 5/10 | Mediocre | Format works but not optimized. Text when carousel would be stronger. Walls of text. |
| 1/10 | Failure | Poor formatting. Long paragraphs. No white space. Image of text. |

**Fix Action:** Check: Is this a framework/process? → Carousel. Is this a story/hot take? → Text with white space. Is this data? → Image/document. Match format to content type.

---

### C8: Engagement Architecture — Weight: 7%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Ends with question or invitation that quality prospects want to answer. Drives comments from target audience. Expert engagement = 5x algorithmic weight. |
| 7/10 | Good | Engagement prompt that invites relevant discussion from the right people. |
| 5/10 | Mediocre | Generic "What do you think?" or "Like if you agree." Drives low-quality engagement. |
| 1/10 | Failure | No engagement mechanism. Broadcast-only. |

**Fix Action:** End with a question your ideal client would want to answer: "What's the biggest [specific challenge] you've seen in [their market/role]?" Not "thoughts?" but something that shows you're genuinely curious about their experience.

---

### C9: Consistency & Frequency — Weight: 5%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 4+ posts per week. Content pillars rotated (hot take, case study, framework, behind-the-scenes). Consistent voice. Regular enough to stay in algorithm and top-of-mind. |
| 7/10 | Good | 3 posts per week. Some pillar rotation. Consistent quality. |
| 5/10 | Mediocre | 1-2 posts per week. Inconsistent quality or frequency. Algorithm forgets you. |
| 1/10 | Failure | Once a month or less. LinkedIn dormant. |

**Fix Action:** Batch create: Sunday = plan 4 posts. Monday = write all 4. Schedule Tue/Thu/Sat/Sun. 2 hours per week, not 30 minutes daily.

---

### Track A Benchmarks
- Engagement rate: >5% per post = strong for B2B personal brand
- Profile views/week: 200+ = growing, 500+ = strong
- Inbound DMs from posts: 2-3/week from qualified prospects = working
- Content-to-meeting conversion: 14.6% of inbound vs 1.7% outbound
- Follower quality > quantity: 5K VPs/CROs > 50K random professionals

---

## TRACK B: ARABIC ASPIRING ENTREPRENEUR POSTS — 8 Criteria

**Strategic purpose:** Build a movement around AI-powered entrepreneurship in MENA. Position Mamoun as the gateway for aspiring founders wanting to build MicroSaaS and AI businesses. Every post is a free sample of the EO training methodology. Drive traffic from LinkedIn to EO MENA training.

### C1: Hook Power (Arabic) — Weight: 18%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | First line in conversational Gulf Arabic that stops an aspiring entrepreneur. Bold, relatable, specific. "بديت مشروعي بدون خبرة برمجة. بعد 30 يوم كان عندي SaaS شغال يدخل فلوس." |
| 7/10 | Good | Arabic hook with clear value signal. Gets the click. Not as vivid or specific as possible. |
| 5/10 | Mediocre | Readable but not scroll-stopping. "نصائح لرواد الأعمال الجدد" |
| 1/10 | Failure | MSA formal Arabic that reads like a textbook. Or starts with 3 lines of pleasantries before content. |

**Fix Action:** Start with a personal result or transformation in Gulf Arabic. "[What I did] + [What happened] + [Timeframe]." Conversational, not formal. Think: how would you tell this to a friend at a coffee shop?

---

### C2: Aspiration Trigger — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Makes the reader see themselves building something. Vivid before/after. "من موظف يشتكي من راتبه لصاحب SaaS يدخل $3K/شهر. الفرق؟ 6 أسابيع و AI." |
| 7/10 | Good | Clear transformation depicted. Specific enough to feel achievable. |
| 5/10 | Mediocre | Motivational but vague. "حلمك ممكن يتحقق" No specific vision. |
| 1/10 | Failure | No aspiration. Theoretical AI content disconnected from life change. |

**Fix Action:** Write one before/after sentence: "من [current state they're in] ل [state they want to be in]. الفرق: [what makes it possible]." Make the "after" specific and achievable, not fantasy.

---

### C3: Practical Framework — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Teaches a specific, actionable micro-skill usable today. Steps numbered. English tech terms mixed naturally with Arabic. "The 3-step validation sprint: 1. Find 10 people with the problem 2. Ask them to pay before you build 3. Build only if 3+ say yes." |
| 7/10 | Good | Actionable advice with some structure. Reader can implement with minor effort. |
| 5/10 | Mediocre | Good advice but abstract. "You need to validate your idea." How? |
| 1/10 | Failure | Pure theory. "AI is transforming the world." Nothing they can do with this. |

**Fix Action:** Add numbered steps (3 max) with one specific tool or action per step. "Step 1: [action] using [tool]. Step 2: [action]. Step 3: [action]." Actionable within 48 hours.

---

### C4: AI Demystification — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Makes AI accessible for non-technical founders. "ما تحتاج تعرف برمجة. تحتاج تعرف تكتب prompt صح وتستخدم الأدوات المناسبة." Shows AI as tool, not magic. |
| 7/10 | Good | Explains AI practically. Shows specific use case. Non-technical audience can follow. |
| 5/10 | Mediocre | Mentions AI without demystifying. Talks capabilities without showing how a founder uses it. |
| 1/10 | Failure | AI jargon that scares non-technical people. "Neural networks and transformer architectures..." |

**Fix Action:** Show one specific AI use case in plain language: "I used [tool] to [specific task] in [timeframe]. Here's exactly what I typed: [example prompt]." The reader should think "I could do that."

---

### C5: Training Funnel Integration — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Post is a free sample of the training methodology. Value so compelling the reader thinks "if this is free, the training must be incredible." Natural bridge: "هذا جزء صغير من اللي نغطيه بالتدريب. لينك التسجيل في أول تعليق." |
| 7/10 | Good | Post demonstrates training quality. CTA to training feels organic. Value-first, then mention. |
| 5/10 | Mediocre | Mentions training but feels forced. "By the way, I have a training." Not organic. |
| 1/10 | Failure | Pure sales pitch. "سجل في التدريب! 🔥" No value. Just promotion. |

**Fix Action:** Structure the post as: 80% = teach one specific thing from the training. 20% = "This is [module X] of [Y]. Full training covers [list 2-3 more topics]. Link in comments." The teach IS the sell.

---

### C6: Community Building — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Creates belonging. Movement language. "إحنا جيل رواد الأعمال اللي بيستخدموا AI بطريقة ما حد استخدمها قبل." In-group identity. Shared mission. |
| 7/10 | Good | Community referenced. Readers feel part of something. Some identity language. |
| 5/10 | Mediocre | Generic community reference. "Join our community." No movement feeling. |
| 1/10 | Failure | No community element. Individual pitch. |

**Fix Action:** Use "we" language: "إحنا نسوي [thing together]" or "جيلنا يقدر [what we can do]." Create an identity for the audience: they're not just followers, they're part of a movement.

---

### C7: Arabic Quality & Tone — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Conversational Gulf Arabic. Mix of Arabic and English tech terms feels natural. "MicroSaaS" stays English. Not MSA formal. Not dialect so local it excludes non-Gulf Arabs. |
| 7/10 | Good | Good Arabic. Mostly conversational. May lean slightly formal or include too much English. |
| 5/10 | Mediocre | Correct Arabic but too formal (MSA). Reads like a university lecture. Or too heavy English. |
| 1/10 | Failure | Poor Arabic, grammar errors, or full English for Arabic audience. |

**Fix Action:** Read it out loud in your Gulf Arabic voice. If it sounds like you're giving a formal speech, rewrite conversationally. Tech terms (SaaS, AI, MVP, prompt) stay English. Everything else = natural Arabic.

---

### C8: Social Proof (Regional) — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | MENA success stories. Gulf founders who built MicroSaaS. Local market data. "أحمد من الرياض بنى تطبيق SaaS بـ 48 ساعة. اليوم عنده 40 مشترك." |
| 7/10 | Good | Regional examples. Arabic-market-relevant proof. Not all local but relatable. |
| 5/10 | Mediocre | Global success stories only. "Look at this founder from San Francisco." Not relatable. |
| 1/10 | Failure | No social proof. Or proof from completely different context. |

**Fix Action:** Add one MENA example: "[Name] from [Gulf city] [specific result] in [timeframe]." If you don't have a student story yet, use your own: "I built [thing] as a test in [timeframe]."

---

### Track B Benchmarks
- Engagement rate on Arabic posts: >4% = strong
- Training registration clicks per post: 5-10 = working, 20+ = viral
- DMs from aspiring founders: 5+/week = authority building
- Follower growth: 50-100 new Arabic-speaking followers/week = strong
- Build-in-public posts get 3-5x more engagement than polished "expert" content in Arabic markets

---

## Scoring Execution

### Input Required
1. The LinkedIn post (text, carousel slides, or image)
2. Track (A or B) — auto-detect from language and content
3. Context: is this part of a weekly batch or standalone?

### Scoring Mindset

Think like a LinkedIn personal branding strategist who has built 5 founder brands from 0 to 10K+ engaged followers. You know that:
- Inbound from content converts at 14.6% — this is the entire business case for Track A
- Arabic build-in-public content is massively underserved on LinkedIn — early movers get disproportionate reach
- Follower quality > quantity — 5K VPs > 50K random professionals
- The post IS the product sample — every post either builds trust or burns it
- 4-5 posts/week is the sweet spot; fewer than 3 and the algorithm forgets you
- Carousels dominate at 6.6% engagement; but hot takes in text format create the most inbound DMs
- Track B's "movement" framing creates a moat that competitors can't replicate with generic content

---

## Cross-System Dependencies

LinkedIn Branding draws from offer positioning (Track A) and campaign strategy (both tracks). It also feeds social media posts.

| Low Score In LinkedIn | Likely Upstream Cause | Check This System & Criterion |
|----------------------|----------------------|-------------------------------|
| Track A C2: Authority signal weak | No case studies | Offer/Positioning: C2 Perceived Likelihood |
| Track A C3: No contrarian angle | Positioning too safe | Offer/Positioning: C10 Positioning Statement |
| Track A C4: Client trigger low | Dream outcome unclear | Offer/Positioning: C1 Dream Outcome Clarity |
| Track A C6: MENA specificity low | Campaign not MENA-native | Campaign Strategy: C10 MENA Contextualization |
| Track A C9: Frequency dropping | No content hierarchy | Campaign Strategy: C5 Q>M>W>D Hierarchy |
| Track B C2: Aspiration weak | No transformation story | Offer/Positioning: C3 Time to Value |
| Track B C3: Framework shallow | No named methodology | Offer/Positioning: C5 Unique Mechanism |
| Track B C5: Funnel disconnect | No MOFU/BOFU mapping | Campaign Strategy: C5 Q>M>W>D Hierarchy |
| Track B C8: No regional proof | No MENA case studies | Offer/Positioning: C2 Perceived Likelihood |

Track A posts that score low on authority and client triggers almost always trace to an offer/positioning gap. You can't signal authority you haven't defined.
