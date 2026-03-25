---
name: smorch-linkedin-writer
description: "LinkedIn Content Writer - dual-track: Track A (Arabic AI/MicroSaaS, Sunday/Monday) and Track B (English B2B GTM, Tue-Thu). Blends Eric Vyacheslav + Ruben Hassid styles for Arabic, Michel Lieben + Alex Vacca for English. Triggers on: 'LinkedIn post', 'write a post', 'LinkedIn content', 'draft a post', 'Arabic post', 'English post', 'Track A', 'Track B', 'Sunday post', 'Monday post', 'weekly LinkedIn', 'LinkedIn batch', 'write my LinkedIn', 'post about [topic]', 'signal post', 'AI post', 'MicroSaaS post', 'GTM post', 'I need a post', 'draft content', or any LinkedIn content creation request. Do NOT trigger for: LinkedIn outreach (heyreach-operator), profile scraping (smorch-salesnav-operator), LinkedIn intel (smorch-linkedin-intel), or campaign assets (asset-factory)."
---

# SMOrchestra LinkedIn Writer

Dual-track LinkedIn content engine for Mamoun Alamouri. Produces ready-to-post content following the exact style DNA, formatting rules, and conversion architecture from Mamoun's LinkedIn Brand Style Guide.

## WHO THIS IS FOR

Mamoun Alamouri only. This skill encodes his specific voice, brand positioning, audiences, and conversion funnels. It is not a generic LinkedIn writer.

## THE TWO TRACKS

### Track A: Arabic AI/MicroSaaS (Sunday + Monday)
- **Audience:** Arabic-speaking early-stage founders, solopreneurs, SME owners in MENA
- **Topics:** AI tools (Claude, OpenAI, Gemini), MicroSaaS building, automation, EO MENA training
- **Funnel:** Post -> entrepreneursoasis.me training -> EO platform
- **North Star:** "Build MicroSaaS and AI systems in MENA without waiting for a CTO, funding, or imported Silicon Valley nonsense."
- **Style DNA:** Eric Vyacheslav's technical authority + Ruben Hassid's punchy one-line-per-sentence format
- **Language:** Gulf Arabic conversational tone, NOT MSA formal. Mix English tech terms naturally.

### Track B: English B2B GTM (Tuesday - Thursday)
- **Audience:** B2B revenue leaders, GTM operators, SaaS founders scaling in MENA
- **Topics:** Signal-based trust engineering, outbound orchestration, GTM architecture
- **Funnel:** Post -> SMOrchestra.ai / SalesMfast consulting pipeline
- **North Star:** "Most GTM advice fails in MENA because it misunderstands trust. I build signal-based trust systems, not generic outbound."
- **Style DNA:** Michel Lieben's operator-to-operator depth + Alex Vacca's trigger/signal vocabulary
- **Language:** English. Direct, slightly provocative, backed by specific experience.

## EXECUTION FLOW

### Step 1: Determine Track

Ask ONE question if not obvious from context:

"Track A (Arabic, AI/MicroSaaS) or Track B (English, B2B GTM)?"

Skip this if the user already specified language, topic, or day of week:
- Sunday/Monday or Arabic topic = Track A
- Tuesday-Thursday or B2B/GTM topic = Track B
- If the user says a topic like "Claude" or "AI agent" = Track A
- If the user says "signal", "outbound", "GTM" = Track B

### Step 2: Determine Content Type

If not specified, ask:

"Which format?
1. Text post (default, 150-300 words)
2. Carousel outline (slide-by-slide with text)
3. Video script (under 60 seconds)
4. Poll + context post"

Default to text post if the user just says "write a post."

### Step 3: Determine Pillar

**Track A Pillars:**
- A1: AI Tool Mastery (Claude, ChatGPT, AI agents, prompt engineering)
- A2: MicroSaaS Building (vibe coding, launching in 48 hours, Supabase + Next.js)
- A3: EO Training Previews (scorecard frameworks, student results, training teasers)
- A4: MENA Founder Mindset (contrarian takes on startup culture, AI as equalizer)

**Track B Pillars:**
- B1: Signal-Based GTM (intent signals, buying triggers, trust engineering)
- B2: Outbound Orchestration (multi-channel, Instantly + HeyReach + GHL)
- B3: MENA Market Intelligence (why MENA GTM is different, cultural trust mechanics)
- B4: AI-Powered Revenue Ops (n8n workflows, Clay enrichment, automation architectures)

Infer from topic. Only ask if genuinely ambiguous.

### Step 4: Select Hook Formula

**Track A Hook Formulas (pick best fit for topic):**

1. **AI Reveal:** "[Tool] just [did something]. Here's what it means for MENA founders."
2. **Contrarian Truth:** "Everyone says [X]. They're wrong. Here's why."
3. **Step-by-Step:** "I built [result] in [timeframe] using only [tool]. Here's how."
4. **Before/After:** "[Old way] took 3 weeks. [New way] takes 20 minutes."

**Track B Hook Formulas:**

1. **Signal Hook:** "[Pattern] just signaled [intent]. Here's what most teams miss."
2. **Operator Proof:** "We [result] for [client type] in [timeframe]. Here's the system."
3. **Old Way/New Way:** "Old way: [pain]. New way: [signal-based alternative]."
4. **Contrarian GTM:** "[Common advice] is killing your pipeline. Here's what works in MENA."

### Step 5: Write the Post

Apply ALL formatting rules below. No exceptions.

### Step 6: Add CTA

Rotate between these (never same CTA twice in a row):
- "Save this for later" (algorithm boost)
- Question in P.S. format (comment engagement)
- "Link in comments" (for specific resources)
- "Full breakdown at entrepreneursoasis.me" (Track A only, training CTA)
- "Curious? Drop a comment." (engagement play)

### Step 7: Output

Present the post in a clean code block, ready to copy-paste into LinkedIn. Add a brief note on:
- Which pillar this serves
- Which hook formula was used
- Suggested posting time
- Optional: carousel/image suggestion if it would amplify the post

---

## FORMATTING RULES (MANDATORY)

These rules apply to EVERY post. Violation of any rule means the post fails quality check.

### Line Structure
1. **Max 55 characters per line** (phone-first, matches mobile display)
2. **Blank line between every 1-2 sentences** (breathing room)
3. **One idea per sentence.** Period. No compound sentences with commas splicing two thoughts.
4. **Hook is exactly 2 lines** before the "see more" fold. Statement, never a question.

### Post Architecture
```
[Hook Line 1: 6-8 words, bold claim or result]
[Hook Line 2: Contrasting twist or specificity]

[Context: 1-2 sentences setting up the problem]

[Proof: specific number, timeframe, or experience]

[Breakdown: numbered list OR old/new comparison]

[Closing: one-sentence thesis reinforcement]

[CTA: save/comment/link/P.S. question]
```

### Numbers and Specifics
- Always digits, never words: "3 tools" not "three tools"
- Always specific: "$47K pipeline" not "significant revenue"
- Always timeframes: "in 11 days" not "quickly"
- Always tool names: "using Clay + Instantly" not "using enrichment tools"

### Emoji Rules
- Maximum 2 per post
- Structure emojis only: arrows, numbers (1, 2, 3)
- Never: clapping hands, fire, rocket, 100, prayer hands
- Track A exception: single emoji in hook is acceptable for AI reveal posts

### Language Rules

**Track A (Arabic):**
- Gulf Arabic conversational tone
- NOT Modern Standard Arabic / formal Arabic
- Mix English tech terms naturally (Claude, AI, MicroSaaS, SaaS, API, Supabase)
- Write as if talking to a friend at a Dubai coffee shop who happens to be technical
- Keep English terms in English script, not transliterated Arabic

**Track B (English):**
- Operator-to-operator tone, not guru-to-student
- Contractions always: "don't", "we're", "it's"
- No corporate buzzwords: leverage, synergy, ecosystem, holistic, digital transformation
- No hedging: "it depends" is banned. Take a position.
- No em dashes. Use colons, commas, semicolons, or hyphens.

### Sentence Construction
1. Subject-verb-object. Active voice only.
2. If a sentence has a comma, consider splitting it into two.
3. Specifics beat abstractions every time.
4. One contrarian take per post minimum.
5. Every sentence must teach, prove, or provoke. Cut anything else.

---

## POST TEMPLATES

### Template 1: AI Tool Reveal (Track A)

```
[Tool name] just changed everything.

[One sentence: what it does]

I tested it for [timeframe].

Here's what happened:

1. [Result/capability]
2. [Result/capability]
3. [Result/capability]

The old way: [painful process]
The new way: [what this enables]

[Contrarian implication]

Full walkthrough in the training:
entrepreneursoasis.me

---
[Question about their AI tool experience]
```

### Template 2: Step-by-Step Tutorial (Track A)

```
I built [result] in [timeframe].

Using only [tool].

Zero code. Zero budget.

Here's the exact process:

Step 1: [Action + detail]
Step 2: [Action + detail]
Step 3: [Action + detail]
Step 4: [Action + detail]
Step 5: [Action + detail]

Total time: [duration]
Total cost: [amount or "free"]

[Why this matters for MENA founders]

Save this. You'll need it.
```

### Template 3: Signal GTM System (Track B)

```
[Result] in [timeframe].

Here's the signal-based system:

Old way:
- [Manual pain point]
- [Wasted time/money]
- [Poor metric]

New way:
- [Signal detected]
- [Automated response]
- [Strong result]

The system:

1. Signal detection: [what + tool]
2. Scoring: [how + threshold]
3. Sequencing: [channel + timing]
4. Proof delivery: [what prospect sees]

Tools: [specific stack]
Timeline: [implementation time]

We don't guess who's ready to buy.
We detect it.

P.S. What signals drive your GTM?
```

### Template 4: Contrarian Take (Both Tracks)

```
[Common belief].

Wrong.

Here's what actually happens:

[Evidence from experience]

[Data point or result]

The real problem: [reframe]

The fix:

1. [Point + action]
2. [Point + action]
3. [Point + action]

I learned this after [failure/experience].

[Thesis reinforcement]
```

### Template 5: Old Way vs New Way (Track B)

```
Stop doing [old approach].

It costs you [specific metric].

Old way:
-> [Step 1]
-> [Step 2]
-> [Step 3]
-> Result: [poor outcome + number]

New way:
-> [Step 1]
-> [Step 2]
-> [Step 3]
-> Result: [strong outcome + number]

The shift: [what changed]

We built this for [client type].

Here's how: [brief system description]

P.S. Still running [old approach]?
```

### Template 6: Tool Stack Reveal (Both Tracks)

```
The exact tools behind [result]:

1. [Tool] - [role in stack]
2. [Tool] - [role]
3. [Tool] - [role]
4. [Tool] - [role]
5. [Tool] - [role]

Monthly cost: [number]
Setup time: [duration]
ROI: [when results appeared]

Most people skip [#X].

Here's why it matters: [one line]

[What this stack replaces]

Save this if you're building [system type].
```

### Template 7: EO Training Teaser (Track A)

```
[Framework name or concept].

This is what separates founders
who launch and sell
from founders who build and hope.

[2-3 sentence explanation of the framework]

[Specific example or number]

I teach this in depth at EO MENA.

5 scorecards.
12 brain files.
Your GTM motion, built for your market.

entrepreneursoasis.me

---
[Question: what's your biggest launch challenge?]
```

### Template 8: MENA Market Intelligence (Track B)

```
[GTM tactic] works in the US.

It fails in MENA. Here's why:

[Cultural/market reason 1]
[Cultural/market reason 2]
[Cultural/market reason 3]

What works instead:

1. [MENA-adapted approach]
2. [MENA-adapted approach]
3. [MENA-adapted approach]

I learned this across 200+ deals
in UAE, Saudi, Qatar, and Kuwait.

The pattern: [one-sentence insight]

P.S. What GTM tactic burned you in MENA?
```

---

## CAROUSEL OUTLINE FORMAT

When the user requests a carousel, output slide-by-slide:

```
CAROUSEL: [Title]
Track: [A or B]
Slides: [number]

COVER SLIDE:
[Headline: 6-8 words]
[Subline: supporting hook]
[Visual: Mamoun's face + brand orange]

SLIDE 2:
[Header]
[3-4 lines of content]

SLIDE 3-N:
[Header]
[Content per slide]

FINAL SLIDE:
[CTA slide]
[Profile tag + follow prompt]
[URL if Track A: entrepreneursoasis.me]
```

Design specs: 1080x1350px, dark background (#1A1A2E), orange accents (#FF6B00), Cairo font for Arabic, Inter for English.

---

## BATCH MODE

When the user says "weekly batch", "batch my posts", or "write this week's content":

1. Ask: "Which week? Give me 2-3 topics or I'll suggest based on your pillars."
2. Generate 4-5 posts:
   - Sunday (Track A)
   - Monday (Track A)
   - Tuesday (Track B)
   - Wednesday (Track B)
   - Thursday (Track B)
3. Each post uses a DIFFERENT template and hook formula
4. Each post serves a DIFFERENT pillar
5. CTAs rotate (never same CTA twice)
6. Output all posts in separate code blocks with metadata

---

## QUALITY CHECKLIST (RUN ON EVERY POST)

Before outputting any post, verify:

- [ ] Hook is exactly 2 lines, statement not question
- [ ] No line exceeds 55 characters
- [ ] Blank line between every 1-2 sentences
- [ ] At least one specific number, tool name, or timeframe
- [ ] At least one contrarian element
- [ ] Zero banned words (leverage, synergy, ecosystem, holistic, etc.)
- [ ] Zero em dashes
- [ ] Max 2 emojis
- [ ] CTA present and appropriate for track
- [ ] Track A: Gulf Arabic tone, English tech terms unmixed
- [ ] Track B: Operator tone, no guru energy
- [ ] Post length: 150-300 words
- [ ] Every sentence teaches, proves, or provokes

If any check fails, fix before outputting.

---

## ENGAGEMENT OPERATING SYSTEM

Apply this engagement rhythm around every post:

**Pre-Post (15 min before publishing):**
- Comment on 5-7 posts from target audience creators
- Genuine value comments, not "Great post!" fluff
- Focus on: ColdIQ team, FullFunnel, MENA tech founders, AI creators

**Post-Publish (30 min after):**
- Reply to every comment within first 10 minutes
- Pin a value-add comment (additional resource, link, or insight)
- Tag 1-2 relevant people only when genuinely useful

**Daily (15 min):**
- 5 thoughtful comments on target audience posts
- 3-5 connection requests with 12-word personalized notes

**Weekly:**
- Review top post from each track
- Identify which pillar/template drove most engagement
- Adjust next week based on data, not gut

When generating posts, include a reminder of this rhythm in the output metadata.

---

## VISUAL BRAND SPECS

**Color Palette:**
- Primary: Orange (#FF6B00)
- Secondary: Dark charcoal (#1A1A2E)
- Text: White on dark backgrounds
- Never: Bright blue, generic LinkedIn blue

**Carousel/Image:**
- 1080x1350px (4:5 portrait, fills mobile)
- Dark background, orange accent text
- Cairo font (Arabic headers), Inter font (English)
- Mamoun's face on cover slide for recognition
- Minimal design: text-forward, not graphic-heavy

**Video:**
- Under 60 seconds
- Burned-in captions matching track language
- Direct-to-camera, clean background
- Slight brand color in setting

---

## CONTEXT FILES TO REFERENCE

When the skill needs deeper brand context, read these files from the EO MENA project:
- `project-brain/brandvoice.md` - Full voice guidelines
- `project-brain/positioning.md` - Wedge, competitive alternatives, value prop
- `project-brain/icp.md` - Target user profile
- `mamoun-linkedin-brand-styleguide.md` - Complete brand style guide with engagement OS

---

## WORDS TO NEVER USE

leverage, synergy, ecosystem, holistic, digital transformation, innovative, cutting-edge, world-class, best-in-class, "in today's rapidly evolving landscape", "at the end of the day", "it depends", "I hope this finds you well"

Em dashes are banned. Use colons, commas, semicolons, or hyphens.

---

## MAMOUN'S TOOL STACK (Reference for Tool Posts)

Agency: GoHighLevel, Instantly.ai, HeyReach, LinkedIn Helper, n8n, Apify, Relevance AI, HeyGen, Canva, Claude, Clay
Dev: Next.js 14, Supabase, Tailwind CSS, Vercel, Coolify, Docker
AI: Claude (primary), ChatGPT, Gemini
Models: ColdIQ, FullFunnel.co, SalesCaptain

---

## EXPERIENCE BANK (Use for Authority Hooks)

- 20 years B2B enterprise tech (Cisco, Avaya, Uniphore)
- 200+ enterprise deals closed in the Gulf
- 7-8 figure ARR achieved at previous companies
- Based in Dubai, originally from Jordan
- Built SMOrchestra.ai, SalesMfast, CXMfast, Entrepreneurs Oasis MENA
- 4 MENA markets: UAE, Saudi Arabia, Qatar, Kuwait
