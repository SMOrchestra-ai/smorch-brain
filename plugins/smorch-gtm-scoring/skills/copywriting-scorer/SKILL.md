---
name: copywriting-scorer
description: Scores written copy across 4 subsystems (cold email, VSL scripts, LinkedIn DMs, WhatsApp messages) against channel-specific criteria. Evaluates spam filter survival, scroll-stopping hooks, engagement quality, and action triggers. Uses 2026 Gmail/Microsoft mechanics, Instantly.ai benchmarks, and MENA WhatsApp data. Triggers on 'score my email', 'rate this copy', 'email quality check', 'VSL score', 'score my LinkedIn message', 'WhatsApp copy review', 'will this pass spam filters', 'copywriting audit', 'score outreach messages'.
---

# Copywriting Scorer

**System 3 of 6 — Battle-Tested Copywriter Hat**

**What this scores:** The actual written words in cold emails, VSL scripts, LinkedIn outreach messages, and WhatsApp messages. Four subsystems, each with channel-specific criteria calibrated to where the words actually appear and what they need to survive (spam filters, scroll behavior, conversation dynamics).

**Benchmark sources:** Instantly.ai 2026 Cold Email Benchmarks, CopyPosse VSL framework, LinkedIn 2026 engagement data, Gmail/Microsoft 2026 spam filter mechanics, MENA WhatsApp B2B data. Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/benchmarks-2026.md` for current numbers.

**Scoring rules:** Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## Subsystem Selection

When scoring copy, first identify which subsystem applies:

| Content | Subsystem | Criteria Count |
|---------|-----------|---------------|
| Cold email (outbound) | 3A: Cold Email | 9 criteria |
| Video sales letter script | 3B: VSL Script | 8 criteria |
| LinkedIn DMs and connection notes | 3C: LinkedIn DM | 7 criteria |
| WhatsApp business messages | 3D: WhatsApp | 8 criteria |

If scoring copy for a multi-channel campaign, score each channel separately and report the subsystem scores individually. The orchestrator uses the highest-scoring subsystem for the composite Campaign Health formula.

---

## SUBSYSTEM 3A: COLD EMAIL COPY — 9 Criteria

Cold email copy must survive three gauntlets: the spam filter (technical), the inbox scan (2 seconds to earn the open), and the read (10 seconds to earn the reply). 2026 Gmail and Microsoft are ruthless: DMARC enforcement, spam complaint tracking, and content filtering are all stricter than 2024.

### C1: Subject Line — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3-6 words. Lowercase. Feels like an internal email, not marketing. Creates curiosity gap without clickbait. Personalized variable (company name or trigger). Zero spam trigger words. Example: "quick q about {{company}} expansion" |
| 7/10 | Good | 4-8 words. Mostly clean. Some personalization. Creates interest but could be sharper. "thoughts on {{company}}'s outbound" |
| 5/10 | Mediocre | Generic but not terrible. "Partnership opportunity" or "Quick question." No personalization. Would blend into inbox. |
| 1/10 | Failure | Marketing blast subject. "Unlock Your Growth Potential with AI-Powered Solutions!" All caps, exclamation, spam triggers. |

**Fix Action:** Rewrite as 4 words, lowercase, with one {{variable}}. Delete every word that sounds like marketing.

---

### C2: Opening Line (Hook) — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Signal-derived. References something specific the prospect DID (hired VP Sales, raised Series B, posted about X, expanded to new market). Timeline hook: "Noticed {{company}} just {{signal}}..." 2.3x higher reply rate than problem hooks per Instantly 2026 data. |
| 7/10 | Good | References something relevant about the prospect (industry, role, company stage). Not signal-specific but shows research. "As a [role] at a [stage] company in [market]..." |
| 5/10 | Mediocre | Generic problem statement. "Many companies in your industry struggle with..." Not personalized. Not signal-based. |
| 1/10 | Failure | "I hope this email finds you well." Or "My name is X and I work at Y." Instant delete. |

**Fix Action:** Replace the opening line with a timeline hook: "Noticed {{company}} just [signal]. When companies [do signal], they typically face [consequence]..." Use one real, verifiable signal about the prospect.

---

### C3: Spam Filter Survival — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Zero spam trigger words. No HTML formatting. No images or links in first email. Plain text appearance. Proper DMARC/DKIM/SPF. Under 80 words. No ALL CAPS. Single plain CTA. Passes Instantly spam checker clean. |
| 7/10 | Good | Mostly clean. Maybe one tracked link (not in first email). Under 100 words. No images. Minor formatting. Would pass most filters. |
| 5/10 | Mediocre | 1-2 minor triggers. Maybe one link. Slightly formatted. 100-150 words. 50/50 chance on strict filters. |
| 1/10 | Failure | Loaded with spam triggers. HTML template. Multiple links. Images. Looks like a newsletter. Over 200 words. Gmail rejects or marks spam. |

**Fix Action:** Run the email through a spam word checker. Remove: free, guarantee, act now, limited time, click here, no obligation, all caps words. Remove all links from email 1. Strip HTML to plain text. Cut to under 80 words.

---

### C4: Body Value Density — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Every sentence adds value or moves toward CTA. No filler. Demonstrates understanding of their specific situation. Shows proof of competence in 1-2 sentences max. Total email: 50-80 words. |
| 7/10 | Good | Mostly value-dense. One sentence of context that could be cut. 80-100 words. Proof is present but could be sharper. |
| 5/10 | Mediocre | Some value but padded. "We've helped companies like yours..." without specifics. 100-150 words with unnecessary context. |
| 1/10 | Failure | Feature dump. Company history. "Founded in 2015, we are a leading provider of..." No value for the reader. |

**Fix Action:** Read each sentence and ask: "Does this give the prospect new information they care about?" Delete every sentence where the answer is no. Target: 50-80 words total.

---

### C5: Social Proof Integration — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Subtle, specific, relevant. "Did this for {{similar company}} — went from X to Y in Z weeks." One line. Named or industry-specific. |
| 7/10 | Good | Relevant proof but slightly generic. "Helped 3 [industry] companies in [region] achieve [result]." Credible but not personalized to prospect. |
| 5/10 | Mediocre | Generic. "Trusted by 100+ companies." No specifics. Or proof not relevant to prospect's situation. |
| 1/10 | Failure | No social proof. Or bragging: "We're the #1 rated platform on G2." Self-focused, not prospect-focused. |

**Fix Action:** Replace generic proof with one specific line: "[Company similar to theirs] went from [metric A] to [metric B] in [timeframe]." Use a company the prospect would recognize or respect.

---

### C6: CTA Clarity & Friction — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Single, low-friction CTA. "Worth a 15-min call this week?" or "Want me to send a 2-min video showing how this would work for {{company}}?" Binary yes/no. No calendar link in first email. |
| 7/10 | Good | Clear single CTA. Slightly higher friction. "Would Thursday or Friday work for a quick chat?" Specific but still easy. May include calendar link in email 2+. |
| 5/10 | Mediocre | Reasonable CTA but slightly high friction. "Let's schedule a 30-minute demo." Or multiple CTAs competing for attention. |
| 1/10 | Failure | No CTA. Or high friction: "Fill out this form." Or aggressive: "Ready to 10x your revenue?" |

**Fix Action:** Replace with a binary question the prospect can answer in 2 words: "Worth a quick call?" or "Want me to send a short video?" One CTA. Zero links in email 1.

---

### C7: Personalization Depth — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3 layers: (1) Signal/trigger, (2) Company-specific detail, (3) Role-specific pain. Feels like a human wrote this for one person. Not just {{firstName}} merge. |
| 7/10 | Good | 2 layers: company context + role relevance. Merge fields plus one custom detail. Feels semi-personalized. |
| 5/10 | Mediocre | First name + company name merge. Maybe industry mention. Template with merge fields visible. |
| 1/10 | Failure | Zero personalization. Mass blast obvious. Or fake personalization: "I've been following {{company}} for a while." |

**Fix Action:** Add one line that proves you looked at their specific situation: a recent hire they made, a product they launched, a post they wrote, or a market they entered. This line cannot be generated by a merge field alone.

---

### C8: Sequence Architecture — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 4-7 emails. Each follow-up adds NEW value (different angle, new proof, alternative CTA). 3-4 day spacing. Tone shifts from curious to helpful to direct. Step 1 gets 58% of replies; steps 2-7 add 42%. |
| 7/10 | Good | 3-5 emails with new angles per follow-up. 3-5 day spacing. Tone progression exists. Each email offers a different reason to reply. |
| 5/10 | Mediocre | 3 emails. Follow-ups are "just checking in" or "bumping this." No new value per touch. |
| 1/10 | Failure | 1 email, no follow-up. Or 10+ that repeat the same pitch. Or follow-ups within 24 hours. |

**Fix Action:** Write each follow-up with a NEW hook: email 2 = new proof point, email 3 = alternative CTA (video/resource), email 4 = social proof angle, email 5 = breakup email. Never repeat the same pitch.

---

### C9: Tone & Voice — Weight: 5%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Peer-to-peer. Not supplicant ("I'd be honored..."). Not aggressive ("You're losing $X every day..."). Confident, casual, direct. Reads like a sharp colleague, not a salesperson. |
| 7/10 | Good | Professional and approachable. Slightly formal but not stiff. Reads naturally. |
| 5/10 | Mediocre | Professional but stiff. Corporate tone. "I would like to introduce..." Reads like a business letter from 2010. |
| 1/10 | Failure | Desperate, aggressive, or sycophantic. "I know you're incredibly busy but..." or "ACT NOW!" |

**Fix Action:** Read the email out loud. If you wouldn't say it to a peer at a conference, rewrite it. Remove all formal hedging ("I would like to," "I was wondering if"). Be direct.

---

## SUBSYSTEM 3B: VSL SCRIPT — 8 Criteria

Video Sales Letters combine visual + verbal persuasion. The script is the skeleton. Key metric: retention. If they don't watch, they don't convert.

### C1: Hook (First 15 Seconds) — Weight: 20%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Pattern interrupt that stops the prospect clicking away. Calls out specific pain or desire. "If you're running outbound in the Gulf and your reply rates are below 3%, this is why." Bold claim backed by proof. 80-90% viewer retention through first 30 seconds. |
| 7/10 | Good | Strong opening with clear value promise. Gets to the point within 10 seconds. Specific enough to hold attention. 70-80% retention at 30s. |
| 5/10 | Mediocre | Decent opening but generic. "Are you struggling with lead generation?" Not specific enough to stop a busy VP. 60-70% retention at 30s. |
| 1/10 | Failure | Starts with company intro, logo animation, or "Welcome to this video about..." 40-50% retention at 30s. |

**Fix Action:** Rewrite the first 2 sentences to: (1) Call out a specific number or pain point, (2) Promise what they'll learn. "In the next [X] minutes, I'll show you [specific thing] that [specific result]."

---

### C2: Problem Articulation — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Describes prospect's reality so precisely they think "this person has been watching my team." Specific numbers, scenarios, emotional triggers. Agitates without manipulating. |
| 7/10 | Good | Problem clearly stated with some specificity. Recognizable to the target audience. Missing the "they've been watching me" feeling. |
| 5/10 | Mediocre | States the problem surface-level. "Many companies struggle with inefficient sales." Not specific enough for recognition. |
| 1/10 | Failure | No problem articulation. Jumps to solution features. Or so generic it applies to every business. |

**Fix Action:** Interview 3 prospects and write down the exact words they use to describe the problem. Use those words, not marketing language.

---

### C3: Unique Mechanism Explanation — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Named framework explained in 60-90 seconds. Visual or metaphor that makes it memorable. "This is the Signal-to-Trust Engine. Here's why it works differently..." Clear cause-and-effect logic. |
| 7/10 | Good | Mechanism described with differentiation. Named but visual could be stronger. Takes longer than 90 seconds to explain. |
| 5/10 | Mediocre | Mentions methodology but doesn't explain WHY it works differently. "We use AI and data science." |
| 1/10 | Failure | No mechanism. "We're just really good at what we do." |

**Fix Action:** Draw the mechanism as a 3-step flow. Name it. Explain each step in one sentence. The viewer should be able to draw it from memory after watching.

---

### C4: Proof Stacking — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3+ types of proof: specific case study with numbers, named client/logo, third-party data, live demo/before-after. Proof appears every 2-3 minutes throughout the VSL. |
| 7/10 | Good | 2 proof types woven in. Appears at least twice. Credible and relevant to the ICP. |
| 5/10 | Mediocre | One case study, generic. "A client in the tech industry saw 40% improvement." No name, no specifics. |
| 1/10 | Failure | Zero proof. Only self-reported claims. |

**Fix Action:** Add one proof point per 3 minutes of video. Types: screenshot of result, specific client quote, before/after data, live demo showing the mechanism working.

---

### C5: Objection Handling — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Top 3-5 objections addressed proactively and woven into narrative. "You might be thinking: we've tried outbound before and it didn't work. Here's why..." Each flipped into a selling point. |
| 7/10 | Good | 2-3 objections addressed. Integrated into the flow, not a separate "FAQ" section. |
| 5/10 | Mediocre | 1-2 objections mentioned briefly. "Some people worry about cost, but..." Not woven into narrative. |
| 1/10 | Failure | No objection handling. Viewer's skepticism goes unanswered. |

**Fix Action:** List the top 3 reasons prospects say no. For each, write a "flip" sentence that turns the objection into evidence the offer works. Weave these into the script after proof sections.

---

### C6: Retention Architecture — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Pattern interrupts every 60-90 seconds (visual change, tone shift, new story, data point). Open loops: "In a minute I'll show you..." Mid-point retention hook at 50% mark. |
| 7/10 | Good | Pattern interrupts every 2 minutes. Some open loops. Pacing varies but could be sharper. |
| 5/10 | Mediocre | Mostly linear delivery. Some visual changes but script is monotone. No open loops. |
| 1/10 | Failure | Talking head with no variation for 8+ minutes. No open loops. No pattern interrupts. |

**Fix Action:** Add an open loop before every major section: "Coming up, I'll show you [specific thing]..." and mark 5 points in the script for visual cuts or energy shifts.

---

### C7: CTA & Close — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Clear, single next step. Low friction. Appears at peak engagement (after strongest proof). Urgency is real, not manufactured. CTA repeated 2-3 times in final section. |
| 7/10 | Good | Clear CTA at the end. Appears once with urgency. Low-to-medium friction. |
| 5/10 | Mediocre | CTA exists but weak or high friction. "Contact us to learn more." Or buried at the end when most have dropped off. |
| 1/10 | Failure | No clear CTA. Ends with "thanks for watching." |

**Fix Action:** Place the CTA immediately after your strongest proof point (not at the end). Repeat it once more in the closing. Make it a binary action: "Click below to book" or "Reply with X."

---

### C8: Script Length & Pacing — Weight: 5%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 8-15 minutes for full VSL. 1,500-2,500 words. Pacing matches content density. No dead air, no rushing. |
| 7/10 | Good | Within 5-20 minute range. Pacing mostly consistent. One section may drag slightly. |
| 5/10 | Mediocre | Too long (20+) or too short (<5 for full VSL). Pacing inconsistent. |
| 1/10 | Failure | 3-minute overview that sells nothing or 30-minute lecture. |

**Fix Action:** Time each section. If any section exceeds 3 minutes without a proof point or pattern interrupt, split it or cut it.

---

## SUBSYSTEM 3C: LINKEDIN DM — 7 Criteria

LinkedIn DMs operate in a trust-first environment. The platform punishes aggressive sales behavior with reduced visibility and connection blocks. Sequence pacing and value-first approach are critical.

### C1: Connection Request Note — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Under 300 characters. References shared context, mutual connection, or specific content they posted. No pitch. Pure curiosity or genuine compliment. |
| 7/10 | Good | Personalized with role/industry reference. Under 300 chars. No pitch. Professional and warm. |
| 5/10 | Mediocre | Generic but not terrible. "I'd like to connect with fellow professionals in [industry]." |
| 1/10 | Failure | Pitch in connection request. "We help companies increase revenue by 300%!" Instant ignore. |

**Fix Action:** Reference one specific thing about them: a post they wrote, a mutual connection, or a shared experience. Under 200 characters. Zero sales language.

---

### C2: First Message After Connect — Weight: 20%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Conversational, not salesy. References something specific. Asks genuine question OR shares relevant insight. No pitch. Goal: start a conversation. |
| 7/10 | Good | Warm and personalized. Shows interest in their work. May offer a value piece but doesn't pitch. |
| 5/10 | Mediocre | Slightly salesy but tolerable. "I help companies like yours with..." Pitch disguised as conversation. |
| 1/10 | Failure | Immediate pitch dump. "We'd love to show you our platform." Relationship burned. |

**Fix Action:** Ask them a genuine question about something they've shared or worked on. No pitch. No value offer. Just curiosity about their work.

---

### C3: Value-First Approach — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Shares something genuinely useful BEFORE any ask. Relevant benchmark, framework, connection intro. "Thought you'd find this interesting — here's our data on cold email reply rates in UAE." |
| 7/10 | Good | Offers relevant value. Resource is genuinely useful even if branded. Not a product pitch disguised as value. |
| 5/10 | Mediocre | Thinly veiled self-promotion. "We just published a whitepaper about our amazing solution." |
| 1/10 | Failure | No value. Every message about what you want. Pure extraction. |

**Fix Action:** Send one piece of genuinely useful content (benchmark data, framework, introduction) with zero ask attached. Value first, relationship second, business third.

---

### C4: Conversation Sequencing — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3-5 messages over 2-3 weeks. Each adds value. Pitch doesn't appear until message 3+ after engagement signal. Sequence: Connect > Value > Engage > Soft pitch > Direct ask. |
| 7/10 | Good | 3-4 messages. Value before pitch. Timing respects their engagement level. Soft pitch in message 3. |
| 5/10 | Mediocre | 2 messages: connect, then pitch. Skips value and engagement phase. |
| 1/10 | Failure | 1 message pitch. Or 7+ rapid-fire messages. LinkedIn harassment. |

**Fix Action:** Map 4 messages with 3-5 day gaps: (1) Thank + question, (2) Share value, (3) Soft pitch IF they engaged, (4) Direct ask with low-friction CTA. If no engagement by message 2, stop.

---

### C5: Personalization Quality — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | References their content, company news, mutual connections, or specific role challenges. Shows genuine research. Feels 1:1. |
| 7/10 | Good | References role + industry with relevant context. Feels personalized but could be deeper. |
| 5/10 | Mediocre | First name + company. Maybe role reference. Feels like a template with merge fields. |
| 1/10 | Failure | Zero personalization. Same message to 500 people. Obviously automated. |

**Fix Action:** Before messaging, spend 2 minutes on their profile: read their last 3 posts, check their About section, note any mutual connections. Reference one specific finding in your message.

---

### C6: Tone & Authenticity — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Reads like a peer. Curious, confident, not desperate. Matches their communication style. No emoji spam. No excessive enthusiasm. |
| 7/10 | Good | Professional and warm. Slightly formal but genuine. |
| 5/10 | Mediocre | Robotic. "I trust you are doing well. I wanted to reach out because..." |
| 1/10 | Failure | Fake enthusiasm. "LOVE your work!! Would be AMAZING to chat!!" |

**Fix Action:** Read it out loud. Does it sound like how you'd talk to a colleague? If not, rewrite in conversational tone.

---

### C7: CTA Progression — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | CTA escalates naturally. Messages 1-2: no ask. Message 3: soft ("would you be open to..."). Messages 4-5: direct but low-friction ("15 min this week?"). CTA matches relationship temperature. |
| 7/10 | Good | CTA appears appropriately. Message 2-3. Soft ask that feels natural given the conversation. |
| 5/10 | Mediocre | CTA in message 1-2. Premature. Signals sales intent too early. |
| 1/10 | Failure | Aggressive CTA from first touch. Or no CTA ever. |

**Fix Action:** No CTA until message 3 minimum. When you do ask, make it easy: "Would a 15-min chat be worth it?" Not "Let me know when you're free for a 45-minute product walkthrough."

---

## SUBSYSTEM 3D: WHATSAPP MESSAGES — 8 Criteria

WhatsApp is MENA's #1 warm B2B channel. Different rules: more personal, shorter messages, voice notes are acceptable, Arabic greetings expected for Gulf markets. Timing matters more than any other channel.

### C1: Opening Greeting & Context — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Culturally appropriate greeting (Arabic for MENA, localized for market). Immediate context: "السلام عليكم [Name], [Mutual connection/event] suggested I reach out..." Under 2 lines before value. |
| 7/10 | Good | Appropriate greeting with some context. May be slightly longer than needed. Cultural norms respected. |
| 5/10 | Mediocre | Generic greeting. "Hi [Name], I'd like to discuss..." No cultural calibration. No context for why you're messaging. |
| 1/10 | Failure | No greeting. Straight to pitch. Or formal English on a Gulf WhatsApp contact. |

**Fix Action:** Lead with culturally appropriate greeting + one line of context (how you know them, why you're reaching out). Under 30 words before getting to value.

---

### C2: Message Brevity — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Under 60 words per message. Scannable on mobile. Each message is one thought. Multiple short messages preferred over one long one. |
| 7/10 | Good | 60-100 words. Slightly long but readable on mobile. Gets to the point. |
| 5/10 | Mediocre | 100-200 words. Paragraph-style message on WhatsApp. Requires scrolling on mobile. |
| 1/10 | Failure | 200+ words. Email-length message pasted into WhatsApp. Prospect won't read it. |

**Fix Action:** Cut the message in half. Then cut it again. If it doesn't fit on one mobile screen without scrolling, it's too long.

---

### C3: Value Proposition — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | One clear, specific value in 1-2 lines. "We helped [similar company] book 12 meetings in 3 weeks from zero outbound." Immediately relevant to their situation. |
| 7/10 | Good | Value stated clearly. Relevant to recipient. May take 2-3 lines. Specific enough to be credible. |
| 5/10 | Mediocre | Generic value. "We can help your business grow." Not specific to them. |
| 1/10 | Failure | No value. Feature dump. Company description. "We are an AI agency that provides..." |

**Fix Action:** One line: "[Similar company] achieved [specific result] in [timeframe] using [your mechanism]." If you can't write this line, your value prop isn't clear enough for WhatsApp.

---

### C4: Voice Note Readiness — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Script designed for voice note delivery (CEO/founder voice). Under 60 seconds. Conversational tone. Key message in first 15 seconds. Voice notes from founders convert 2x higher than text in MENA. |
| 7/10 | Good | Could work as voice note with minor adaptation. Natural language. Under 90 seconds. |
| 5/10 | Mediocre | Text-only message. Not designed for voice. Would sound stilted as voice note. |
| 1/10 | Failure | Formal text message that would sound robotic if read aloud. No voice note strategy. |

**Fix Action:** Record a 45-second voice note version of the message. Speak naturally. If it sounds like reading an email, rewrite more conversationally. Send the voice note instead of text for warm leads.

---

### C5: Timing Optimization — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Sent during optimal MENA business hours (Sun-Thu, 9-11am or 2-4pm Gulf time). Ramadan timing adjusted (post-iftar 8-10pm). Follows engagement signal (responded to email, viewed LinkedIn profile). |
| 7/10 | Good | Sent during business hours for the target market. Follows some engagement signal. |
| 5/10 | Mediocre | Sent during business hours but no market-specific optimization. Random timing within the week. |
| 1/10 | Failure | Sent at midnight. Or Friday/Saturday for Gulf markets. Or during prayer times. Cultural insensitivity. |

**Fix Action:** Set WhatsApp sends only during: (1) Sunday-Thursday for Gulf, (2) 9-11am or 2-4pm local time, (3) Only after a warm signal (email reply, LinkedIn view, event meeting). Never cold WhatsApp without prior touchpoint.

---

### C6: Follow-Up Cadence — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 2-3 follow-ups max over 2 weeks. Each adds new value. If no response after 3, stop. WhatsApp is personal space, persistence here feels invasive. |
| 7/10 | Good | 2 follow-ups with new value per message. Appropriate spacing (3-5 days). |
| 5/10 | Mediocre | 1 follow-up. "Just checking if you saw my message." No new value. |
| 1/10 | Failure | 5+ follow-ups on WhatsApp. Or follow-ups within hours. Blocked and reported. |

**Fix Action:** Max 3 WhatsApp messages total. Each must contain something new (insight, result, connection). After 3 with no response, the lead goes back to email/LinkedIn. WhatsApp is a privilege, not a right.

---

### C7: Personalization & Relevance — Weight: 13%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | References specific shared context (event, mutual connection, their recent post, their company news). Feels like you're continuing a conversation, not starting a cold outreach. |
| 7/10 | Good | Personalized with company/role context. Shows awareness of their situation. |
| 5/10 | Mediocre | Name and company only. Generic message with merge fields. |
| 1/10 | Failure | Zero personalization. Bulk broadcast. Obviously copy-pasted. |

**Fix Action:** Reference one specific thing that connects you: "Met you at [event]," "Saw your post about [topic]," or "[Mutual connection] mentioned you're working on [X]."

---

### C8: CTA Simplicity — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | One-tap or one-word CTA. "Interested?" or "Want me to send a 2-min video?" or "Worth a quick call?" The easier the response, the higher the conversion. |
| 7/10 | Good | Simple CTA. "Would Tuesday or Wednesday work?" Requires a short answer. |
| 5/10 | Mediocre | CTA requires effort. "Please fill out this form and we'll get back to you." |
| 1/10 | Failure | No CTA. Or complex multi-step CTA. "Visit our website, navigate to pricing, and submit an inquiry." |

**Fix Action:** Rewrite CTA as a yes/no question. "Worth 15 minutes?" or "Want me to send the case study?" One question, one tap to answer.

---

## Scoring Execution

### Input Required
1. The copy to score (email text, VSL script, LinkedIn messages, WhatsApp messages)
2. Which subsystem (3A/3B/3C/3D) - auto-detect from content type
3. Target ICP and market (for calibrating MENA vs US benchmarks)

### Scoring Mindset

Think like a copywriter who has written 5,000+ cold emails and watched the analytics on every one. You know that:
- Subject lines determine whether everything else matters
- The first line is worth more than the rest of the email combined
- 50-80 words is the sweet spot; every word beyond 80 costs you replies
- Timeline hooks (referencing something they just did) outperform problem hooks 2.3x
- Follow-ups with new value recover 42% of total replies
- WhatsApp in MENA is a relationship channel first, sales channel second
- Voice notes from founders outperform text 2:1 in Gulf B2B

---

## Cross-System Dependencies

Copywriting is a downstream system. When copy scores poorly, the root cause is often upstream.

| Low Score In Copy | Likely Upstream Cause | Check This System & Criterion |
|-------------------|----------------------|-------------------------------|
| 3A C2: Opening line generic | No signal defined | Campaign Strategy: C1 Signal Clarity |
| 3A C4: Body has no value | Offer unclear | Offer/Positioning: C1 Dream Outcome Clarity |
| 3A C5: No social proof | No proof stacked | Offer/Positioning: C2 Perceived Likelihood |
| 3A C7: Can't personalize deeply | ICP too broad | Campaign Strategy: C2 ICP Precision |
| 3B C3: Mechanism explanation weak | No named mechanism | Offer/Positioning: C5 Unique Mechanism |
| 3B C4: Proof section thin | Offer lacks case studies | Offer/Positioning: C2 Perceived Likelihood |
| 3C C3: Value-first content missing | No value to share | Offer/Positioning: C7 Price-to-Value Gap |
| 3D C1: Greeting wrong for market | Channel-market mismatch | Campaign Strategy: C3 Channel-Market Fit |
| 3D C5: Timing off | No market timing plan | Campaign Strategy: C6 Timing & Velocity |
| All subsystems: CTA weak | Offer doesn't reduce friction | Offer/Positioning: C4 Effort Minimization |

If 3+ copywriting criteria trace to the same upstream system, flag it: "The copy isn't the problem. Fix [upstream system] first, then re-score copy."
