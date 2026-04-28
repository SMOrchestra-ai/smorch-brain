<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
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

### Track A Weight Distribution
| Criterion | Weight |
|-----------|--------|
| C1: Hook & Pattern Interrupt | 18% |
| C2: Authority Signal | 15% |
| C3: Framework Delivery | 12% |
| C4: Client Acquisition Trigger | 15% |
| C5: Engagement Mechanics | 10% |
| C6: Contrarian Angle | 10% |
| C7: Platform Optimization | 8% |
| C8: Social Proof Integration | 7% |
| C9: Content-to-Commerce Bridge | 5% |
| **Total** | **100%** |

### Track B Weight Distribution
| Criterion | Weight |
|-----------|--------|
| C1: Hook Quality | 16% |
| C2: Aspiration Trigger | 13% |
| C3: Practical Framework | 12% |
| C4: AI Demystification | 12% |
| C5: Training Funnel Integration | 14% |
| C6: Community Building | 10% |
| C7: Arabic Language Quality | 10% |
| C8: Social Proof | 8% |
| C9: Build-in-Public Energy | 5% |
| **Total** | **100%** |

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

### C9: Content Pillar Rotation — Weight: 5%

This post's role within the weekly content mix. A single post is evaluated for how it contributes to the overall pillar rotation, not for frequency (frequency is an operational metric, not a post quality metric).

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Post clearly serves a specific content pillar (hot take, case study, framework, behind-the-scenes). Pillar is different from the previous 2 posts. Rotation creates a varied, engaging feed that gives different reasons to follow. |
| 7/10 | Good | Post has a clear pillar identity. May overlap slightly with recent posts but still adds variety. |
| 5/10 | Mediocre | Same pillar as last 2-3 posts. Feed feels repetitive. Follower fatigue risk. |
| 1/10 | Failure | No pillar awareness. Random content. Or every post is the same format/angle. |

**Fix Action:** Before posting, check the last 2 posts. If both were frameworks, this one should be a story or hot take. Rotate: framework → case study → hot take → behind-the-scenes.

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

### C1: Hook Power (Arabic) — Weight: 16%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | First line in conversational Gulf Arabic that stops an aspiring entrepreneur. Bold, relatable, specific. "بديت مشروعي بدون خبرة برمجة. بعد 30 يوم كان عندي SaaS شغال يدخل فلوس." |
| 7/10 | Good | Arabic hook with clear value signal. Gets the click. Not as vivid or specific as possible. |
| 5/10 | Mediocre | Readable but not scroll-stopping. "نصائح لرواد الأعمال الجدد" |
| 1/10 | Failure | MSA formal Arabic that reads like a textbook. Or starts with 3 lines of pleasantries before content. |

**Fix Action:** Start with a personal result or transformation in Gulf Arabic. "[What I did] + [What happened] + [Timeframe]." Conversational, not formal. Think: how would you tell this to a friend at a coffee shop?

---

### C2: Aspiration Trigger — Weight: 13%

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

### C5: Training Funnel Integration — Weight: 14%

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

### C9: Build-in-Public Energy — Weight: 5%

Arabic build-in-public content is massively underserved on LinkedIn. Posts showing the messy, real process of building something get 3-5x more engagement than polished "expert" content in Arabic markets. This criterion evaluates whether the post taps into that energy.

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Shows real work in progress. Screenshots of actual builds, real revenue numbers, genuine mistakes. "بديت الساعة 9 الصبح. الحين الساعة 3 وعندي MVP شغال. شوفوا..." Raw, authentic, inspiring. Makes aspiring founders think "I could do that." |
| 7/10 | Good | Some build-in-public elements. References real work but more polished than raw. Still feels authentic. |
| 5/10 | Mediocre | Polished expert content. Well-written but no raw build-in-public energy. Reads like a blog post, not a founder sharing in real-time. |
| 1/10 | Failure | Pure theoretical or motivational content. No connection to actual building. "AI will change the world" without showing how. |

**Fix Action:** Share one thing you built or did TODAY with a screenshot or specific metric. "اليوم سويت [thing]. النتيجة: [result]. الخطوة الجاي: [next step]." Real-time > polished.

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

## Calibration Anchor: Scored Examples

### Track A Example (English B2B)

**Post being scored:**

```
Everyone says build relationships first in the Gulf.

I disagree.

Build proof of competence first.

In MENA B2B, trust is everything. But trust doesn't come from 47 coffee meetings.

Trust comes from demonstrating you know your stuff before the first handshake.

Over the last quarter, we tested this with 127 outbound campaigns across UAE and Saudi:

→ Signal-based outreach with proof-first messaging: 8.3% reply rate
→ Relationship-first approach (warm intros, events, coffees): 2.1% reply rate

The signal-based approach was 4x faster and cost 60% less per meeting booked.

The Gulf rewards competence signaled early, not relationships built slowly.

If your outbound reply rate in MENA is below 5%, you're probably leading with the wrong thing.

The first touchpoint should prove you understand their problem — not ask for 30 minutes of their time.

What's your reply rate on Gulf-targeted outbound?
```

| # | Criterion | Weight | Score | Rationale |
|---|-----------|--------|-------|-----------|
| C1 | Hook Power | 18% | 9.5 | "Everyone says build relationships first in the Gulf. I disagree." Contrarian, specific to ICP, bold. VP of Sales stops scrolling. |
| C2 | Authority Signal | 15% | 9.0 | "127 outbound campaigns" shows volume. Specific reply rates (8.3% vs 2.1%). Shows the work. |
| C3 | Contrarian Angle | 12% | 9.5 | Challenges the #1 conventional wisdom in Gulf B2B. Backed by data, not opinion. |
| C4 | Client Trigger Density | 15% | 9.0 | "If your outbound reply rate in MENA is below 5%" — direct trigger. ICP thinks "that's us." |
| C5 | Value-to-Promotion Ratio | 10% | 9.0 | 90% value, 10% implied authority. No pitch. No CTA to book a call. |
| C6 | MENA Market Specificity | 10% | 9.5 | Gulf-specific data. "47 coffee meetings" — only someone in MENA B2B would say this. |
| C7 | Format & Readability | 8% | 8.5 | Text post (correct for hot take). Good white space. Short paragraphs. Could be stronger as carousel with the data comparison. |
| C8 | Engagement Architecture | 7% | 8.0 | Question at end targets the right audience. Could be sharper: asking for their specific reply rate number would force more engagement. |
| C9 | Content Pillar Rotation | 5% | 8.5 | Clear hot take / data-backed contrarian pillar. Assume it follows a framework or case study post. |

**Track A Overall: 9.05 / 10 — VERDICT: ELITE (Ship immediately)**
**TOP FIX: C8 — Sharpen closing question to "Drop your Gulf outbound reply rate below. Under 5%? I'll tell you where the leak is." Forces engagement AND opens DM conversations.**

---

### Track B Calibration Example: Arabic AI/MicroSaaS Post

**Scenario:** Sunday Arabic LinkedIn post for @MamounAlamouri about using Claude to build a SaaS product in 48 hours.

**Post being scored:**
"قبل 48 ساعة ما كان عندي أي كود.
اليوم عندي SaaS شغال فيه 3 مشتركين يدفعوا.

السر؟ Claude + Supabase + فكرة واضحة.

أغلب الناس يعتقدوا إنك تحتاج:
❌ فريق مبرمجين
❌ 6 شهور تطوير
❌ $50K ميزانية

الحقيقة:
✅ شخص واحد + AI = MVP في يومين
✅ $0 تكلفة تطوير
✅ أول عميل يدفع قبل ما تكتب سطر كود واحد

الخطوات بالضبط:
1. حددت المشكلة (clinic no-shows في الإمارات)
2. بنيت brain files بـ5 scorecards
3. Claude كتب الكود كامل
4. Deploy على Vercel + Supabase
5. أول 3 عملاء من WhatsApp outreach

مو لازم تكون مبرمج.
لازم تكون واضح في المشكلة اللي تحلها.

AI هو الأداة. أنت المفكر.

🔥 الأسبوع الجاي بنزل فيديو يوتيوب أشرح كل خطوة بالتفصيل.
تابعوني عشان ما تفوتكم."

**Score:**

| # | Criterion | Weight | Score | Rationale |
|---|-----------|--------|-------|-----------|
| C1 | Hook | 16% | 9.5 | "قبل 48 ساعة ما كان عندي أي كود" — pattern interrupt, specific timeline, creates curiosity gap. First-person, vulnerable, bold. |
| C2 | Aspiration Trigger | 13% | 9.0 | "شخص واحد + AI = MVP في يومين" is aspirational and achievable. Shows the path, not just the destination. |
| C3 | Practical Framework | 12% | 9.0 | 5 exact steps. Numbered. Specific tools named. Reader could replicate this weekend. |
| C4 | AI Demystification | 12% | 9.0 | "Claude كتب الكود كامل" and "مو لازم تكون مبرمج" directly addresses the intimidation barrier. Makes AI accessible. |
| C5 | Training Funnel Integration | 14% | 8.5 | YouTube tease at the end. Could be stronger — missing link to training or lead magnet. "بنزل فيديو" is good but no direct CTA to join something. |
| C6 | Community Building | 10% | 8.0 | "تابعوني" is standard. Missing: question that drives comments ("شو المشكلة اللي تحبوا تحلوها بالـAI؟"). Build-in-public energy is strong but community call is weak. |
| C7 | Arabic Language Quality | 10% | 9.0 | Conversational Gulf Arabic. English tech terms mixed naturally (Claude, Supabase, Vercel, Deploy, MVP). Not MSA formal. Reads like talking to a friend. |
| C8 | Social Proof | 8% | 8.5 | "3 مشتركين يدفعوا" — real, specific, humble. Build-in-public transparency. Could add monthly revenue number for stronger proof. |
| C9 | Build-in-Public Energy | 5% | 9.0 | Raw, real-time sharing. "قبل 48 ساعة..." creates the build-in-public timeline. Authentic without being performative. |

**OVERALL: 8.87 / 10 — VERDICT: STRONG**
**HARD STOPS: None**
**TOP FIX: C6 Community Building — add a closing question: "شو المشكلة اللي تبون تحلوها بالـAI؟ نزلوها بالكومنتات." Drives comment velocity and signals community building.**

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
