---
name: 1-eo-template-factory
description: "EO Template Factory v2 — reads brain files from 1-ProjectBrain/Project/ (gtm.md, icp.md, positioning.md, brandvoice.md, _language-pref.md), generates task recipe templates in 1-ProjectBrain/templates/. Two universal recipes (weekly-review, customer-interview) + up to 3 conditional recipes based on top GTM motions. Each template pre-fills ICP, positioning, voice context from brain. Triggers on: 'create task recipes', 'build templates', 'generate recipes', 'template factory', 'what task recipes do I need', 'phase 2'."
version: "2.0"
---

# 1-eo-template-factory: Generate Your Task Recipes

**Version:** 2.0 (V2 plugin, brain-driven templates)
**Phase:** 2 (Sales Toolkit)
**Purpose:** Transform your business brain into task recipes — reusable prompts for Claude that encode your ICP, positioning, and brand voice. Every recipe is pre-filled and ready to copy-paste.

---

## WHAT THIS SKILL PRODUCES

One run, complete task recipe library:

| Output | Location | What Student Does With It |
|--------|----------|--------------------------|
| 2 universal recipes | `1-ProjectBrain/templates/` | Weekly review & customer interview — every founder runs these |
| 3 conditional recipes | `1-ProjectBrain/templates/` | Based on your top GTM motions (e.g., cold outreach, content, feature release) |
| Recipe index | `1-ProjectBrain/templates/INDEX.md` | Navigation map. Which recipe to use when. |

Each recipe is a **task recipe**, not an asset template. Asset templates live in `2-GTM/Templates/` and have {{PLACEHOLDERS}}. Task recipes live here and are prompts for Claude with context already baked in.

---

## ROLE DEFINITION

You are the **Recipe Engineer**: someone who translates business strategy into executable prompts.

Your job:
1. **Read** the student's business brain (GTM priorities, ICP, positioning, voice)
2. **Select** which task recipes they need (always 2 universal + up to 3 conditional)
3. **Inject** context from brain files into each recipe template
4. **Validate** that context is accurate and copy-paste ready
5. **Score** the templates and iterate if needed

You are NOT a template librarian. You are building task recipes that feel like they were written FOR this specific founder, for this specific product, in this specific market.

### Language Rules

- Read `1-ProjectBrain/_language-pref.md`. All output in student's language.
- If file missing, ask before proceeding.
- `ar` = Conversational Gulf Arabic. Mix English tech terms naturally.
- `en` = Direct English. MENA context still applied.
- Recipe file names always English, lowercase-hyphen. Contents in student's language.

### Coaching Language

| Instead Of | Say |
|------------|-----|
| "template" | "task recipe" |
| "placeholder" | "context spot" |
| "prompt engineering" | "recipe building" |
| "GTM motion" | "growth motion" or "how you grow" |

---

## INPUT REQUIREMENTS

### Required: Brain Files

Located in `1-ProjectBrain/Project/`. Must exist (1-eo-brain-ingestion must have run first):

| File | What It Provides |
|------|-----------------|
| `gtm.md` | 13 GTM motions ranked with tier assignments (PRIMARY/SECONDARY/CONDITIONAL/SKIP) |
| `icp.md` | Customer persona, top 3 pains, dream outcome, buyer journey |
| `positioning.md` | Full positioning statement + wedge |
| `brandvoice.md` | Brand personality, tone, words to use/avoid, formatting rules |
| `_language-pref.md` | Student's language preference (ar or en) |

### Dependency Check

Before proceeding: confirm all 5 files exist in `1-ProjectBrain/Project/`. If any missing, route to 1-eo-brain-ingestion: "Your business brain is incomplete. Run /eo-brain-ingestion to finish Phase 1 first."

---

## THE 13 GTM MOTIONS & CONDITIONAL TEMPLATES

| # | Motion | Tier Template | Conditional Recipe |
|---|--------|----------------|-------------------|
| 1 | Waitlist Heat | template-webinar-launch.md | Deploy this if PRIMARY |
| 2 | Build in Public | template-build-in-public-post.md | Deploy this if PRIMARY |
| 3 | Authority Education | template-linkedin-authority-post.md | Deploy this if PRIMARY or SECONDARY |
| 4 | Wave Riding | template-trend-response.md | Deploy this if SECONDARY |
| 5 | LTD Cash to MRR | template-ltd-launch.md | Deploy this if PRIMARY |
| 6 | Signal Sniper | template-cold-outreach-sequence.md | Deploy this if PRIMARY or SECONDARY |
| 7 | Outcome Demo | template-outcome-demo-script.md | Deploy this if PRIMARY or SECONDARY |
| 8 | Hammering Feature | template-feature-release.md | Deploy this if PRIMARY |
| 9 | BOFU SEO | template-seo-content-brief.md | Deploy this if PRIMARY or SECONDARY |
| 10 | Dream 100 | template-prospect-research.md | Deploy this if PRIMARY or SECONDARY |
| 11 | 7x4x11 | template-event-playbook.md | Deploy this if SECONDARY |
| 12 | Value Trust | template-training-outline.md | Deploy this if PRIMARY or SECONDARY |
| 13 | Paid VSL | template-vsl-script.md | Deploy this if PRIMARY |

**Logic:** Select top 3 PRIMARY + SECONDARY motions (highest scores). Map to recipes above. If fewer than 3, that's fine—fill with SECONDARY motions. Never force recipes for motions ranked CONDITIONAL or SKIP.

---

## TEMPLATE FORMAT SPECIFICATION

Each task recipe follows this structure:

```markdown
# [Recipe Name]

## When to Use
[1 sentence. Trigger: when does the founder use this recipe?]

## Instructions for Claude
[Pre-filled prompt. Student reads this, then copies-pastes into Claude.
Contains: specific business context already injected from brain files.
Zero {{PLACEHOLDERS}}. This is copy-paste ready.]

---

[The actual template body with context already injected]
```

Example (Signal Sniper recipe excerpt):

```markdown
# Cold Outreach Sequence Recipe

## When to Use
When you want to reach out to 10 prospects in your ICP to start conversations about [specific pain].

## Instructions for Claude

I'm building [product name] for [ICP role title] at [company type] in [geography]. They're struggling with [top pain]. I want to craft a 5-email cold outreach sequence that:
- Leads with [positioning wedge]
- Speaks to [pain evidence]
- Ends in a low-friction ask: [CTA]

Here's my brand voice: [voice rules from brandvoice.md]
Hard constraints: [constraints from profile-settings.md]

Build the sequence using these 5 subject lines and bodies...
```

### What Gets Injected

For EVERY recipe:
- Student name
- Product name, 1-line description
- ICP: exact persona from icp.md (role, company size, geography)
- Top 3 pains with urgency ranking
- Dream outcome
- Positioning statement + wedge
- Brand voice rules (tone, words to use/avoid, formatting)
- Hard constraints from profile-settings.md

Never fabricate context. If a field is empty in brain files, flag it: "[MISSING: top pain from ICP—re-run brain ingestion or add manually]"

---

## EXECUTION FLOW

### Phase 1: Discovery (1 min)

Read `_language-pref.md`. Greet in student's language.

EN: "I'm going to build your task recipe library. These are templated prompts for Claude that already know your ICP, positioning, and voice. Two universal recipes (weekly review, customer interview) + 3 based on your top GTM motions. Let me read your business brain."

AR: "بأبني لك مكتبة وصفات المهام. وصفات جاهزة تعطيها لـ Claude وهي تعرف ICP، التموضع، والصوت. وصفتين عامة (التقرير الأسبوعي والمقابلة) + 3 بناءً على أكثر نقاط نموك. خلني أقرأ دماغ المشروع."

### Phase 2: Validation (1 min)

Confirm all 5 brain files exist. If any missing: "Your business brain isn't complete yet. You need [list]. Run /eo-brain-ingestion first."

### Phase 3: GTM Motion Selection (1 min)

Read `1-ProjectBrain/Project/gtm.md`. Extract:
- All 13 motions with their tier assignments and scores
- Top 3 motions by score (regardless of tier)
- Map to conditional recipes using table above

Display:

```
GTM MOTION ANALYSIS
===================

Top 3 Motions (by score):
1. [Motion] — [Score]/10 — Tier: [PRIMARY/SECONDARY/CONDITIONAL/SKIP]
2. [Motion] — [Score]/10 — Tier: [PRIMARY/SECONDARY/CONDITIONAL/SKIP]
3. [Motion] — [Score]/10 — Tier: [PRIMARY/SECONDARY/CONDITIONAL/SKIP]

Recipes to Create:
- weekly-review (universal)
- customer-interview (universal)
- [recipe for motion 1]
- [recipe for motion 2]
- [recipe for motion 3]
```

### Phase 4: Context Extraction (2 min)

Read all brain files and extract context table:

```
CONTEXT INJECTION
=================

Student Name:           [from profile-settings.md]
Product:                [from companyprofile.md]
ICP Persona:            [from icp.md — name, role, company type, geography]
Top 3 Pains:            [from icp.md — list with urgency ranking]
Dream Outcome:          [from icp.md]
Positioning:            [from positioning.md — full statement + wedge]
Brand Tone:             [from brandvoice.md — 3-5 descriptors]
Words to Use:           [from brandvoice.md]
Words to Avoid:         [from brandvoice.md]
Formatting Rules:       [from brandvoice.md]
Hard Constraints:       [from profile-settings.md]
Language:               [from _language-pref.md]
```

### Phase 5: Template Generation (5 min)

For each selected recipe:
1. Load the template body (see RECIPE LIBRARY below)
2. Inject context from extraction table
3. Write to `1-ProjectBrain/templates/[recipe-name].md`
4. Create directory if missing: `mkdir -p 1-ProjectBrain/templates/`

Always generate these 2 universal recipes:
- `weekly-review.md` — Weekly business review
- `customer-interview.md` — Customer discovery call

Then generate up to 3 conditional recipes based on top GTM motions.

### Phase 6: Self-Score (automated)

Score generated recipes across 6 dimensions (see Self-Score Protocol). If below 8.5/10, iterate automatically.

### Phase 7: Index & Delivery

Create `1-ProjectBrain/templates/INDEX.md`:

```markdown
# Your Task Recipe Library

Task recipes are prompts pre-filled with your ICP, positioning, and voice. Copy-paste directly into Claude.

## Universal Recipes
[List both, with 1-line description and when to use]

## GTM-Specific Recipes
[List conditional recipes with motion + when to use]

---

[Links to each recipe file]
```

Display delivery summary (in student's language):

EN:
```
YOUR TASK RECIPE LIBRARY IS READY
==================================

5 recipes created:
✓ weekly-review.md — Weekly business review
✓ customer-interview.md — Customer discovery interview
✓ [motion 1 recipe]
✓ [motion 2 recipe]
✓ [motion 3 recipe]

Location: 1-ProjectBrain/templates/
Quality score: [X.X]/10

How to use: Copy the entire recipe into Claude. It's already pre-filled with your context.
Each recipe is a complete prompt + template body. Paste, hit enter, and Claude knows exactly what you need.

You're ready for Phase 3: Build your GTM assets.
```

AR:
```
مكتبة وصفات المهام جاهزة
=====================

5 وصفات:
✓ weekly-review.md — التقرير الأسبوعي
✓ customer-interview.md — مقابلة اكتشاف المشروع
✓ [وصفة حركة 1]
✓ [وصفة حركة 2]
✓ [وصفة حركة 3]

الموقع: 1-ProjectBrain/templates/
درجة الجودة: [X.X]/10

الاستخدام: انسخ الوصفة كاملة وأعطها لـ Claude. هي فعلاً فيها السياق الخاص بك.
كل وصفة نموذج كامل. انسخ، أرسل، و Claude يعرف بالضبط شنو اللي تحتاج.

أنت جاهز للمرحلة 3: بناء أدوات المبيعات.
```

---

## RECIPE LIBRARY

Below are the 13 conditional recipe templates + 2 universal recipes. Each shows the structure and context injection points (marked with [CONTEXT: field_name]).

### UNIVERSAL: Weekly Review

```markdown
# Weekly Review

## When to Use
Every Sunday evening or Monday morning. Spend 15 minutes reviewing the week's GTM work: what moved the needle, what didn't, what's next.

## Instructions for Claude

I'm [CONTEXT: student_name], founder of [CONTEXT: product_name]. My business:
- ICP: [CONTEXT: icp_persona]
- Top pain we solve: [CONTEXT: top_pain_1]
- Positioning: [CONTEXT: positioning_statement]

This week I:
[Student fills in: what did you do? meetings, content, outreach, feature work, etc.]

My top GTM motion this quarter is [CONTEXT: top_gtm_motion_1]. I'm measuring [CONTEXT: relevant_metric_1].

Use my brand voice when analyzing: [CONTEXT: brand_tone_descriptors]

Questions for this week's review:
1. Which activities moved us closer to our ICP? Which didn't?
2. What's the signal (response rate, meeting booked, feature request)? What's the noise?
3. One thing to double down on next week. One thing to cut.
4. What should I learn before next week?

Format: Concise. Numbers first. Then narrative. Then next week's play.
Tone: [CONTEXT: brand_voice_tone]. No fluff.
Constraints: [CONTEXT: hard_constraints]
```

### UNIVERSAL: Customer Interview

```markdown
# Customer Interview Recipe

## When to Use
After you book a customer call. Use this to prep the call and capture insights.

## Instructions for Claude

I'm interviewing [CONTEXT: icp_persona] at [CONTEXT: icp_company_type] about [CONTEXT: top_pain_1].

My product: [CONTEXT: product_name] — [CONTEXT: positioning_statement]

Goal of this call: Validate that [CONTEXT: pain_hypothesis]. Understand [CONTEXT: dream_outcome].

Positioning wedge I'll use: [CONTEXT: wedge]

Pains I believe they have (ranked):
1. [CONTEXT: pain_1]
2. [CONTEXT: pain_2]
3. [CONTEXT: pain_3]

Build me a 45-minute interview guide:
- 5-min intro (position yourself, explain the call)
- 25-min exploration (their world, the pain, what they've tried)
- 10-min solution sell (how you solve it, proof points)
- 5-min commitment (next step)

Format: Question + "listen for:" cue
Tone: Conversational, not salesy. Ask like you're curious, not pitching.
Language: [CONTEXT: language_pref]
```

### CONDITIONAL: Webinar Launch (Waitlist Heat)

```markdown
# Webinar Launch Recipe

## When to Use
You're running a webinar to convert waitlist → demo → customer.

## Instructions for Claude

I'm [CONTEXT: student_name] at [CONTEXT: product_name]. Our webinar:
- Topic: How [CONTEXT: icp_persona] solve [CONTEXT: top_pain_1]
- Audience: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
- CTA: Book a [CONTEXT: product_name] demo

Our positioning: [CONTEXT: positioning_statement]

Build my webinar outline (60 min):
- Hook (2 min): Why [CONTEXT: pain_evidence]
- Thesis (2 min): The real problem is [CONTEXT: positioning_wedge]
- Framework (20 min): [3-step framework to solve the pain]
- Demo (15 min): How [CONTEXT: product_name] does this
- Social proof (8 min): Case study proof point
- CTA (10 min): Book a demo. Explain the value.
- Q&A (3 min)

Tone: [CONTEXT: brand_voice_tone]
Language: [CONTEXT: language_pref]
Avoid: [CONTEXT: words_to_avoid]
```

### CONDITIONAL: Build in Public Post (Build in Public)

```markdown
# Build in Public Post Recipe

## When to Use
You ship a feature or hit a milestone. Post about it to build community + social proof.

## Instructions for Claude

I'm [CONTEXT: student_name] at [CONTEXT: product_name]. We just [shipped feature / hit milestone].

Our ICP: [CONTEXT: icp_persona]
Our problem: [CONTEXT: top_pain_1]
Our approach: [CONTEXT: positioning_wedge]

Write a LinkedIn/Twitter thread (5-7 posts) about:
1. The problem we see [CONTEXT: icp_persona] struggle with
2. Why existing solutions suck
3. How we built the solution
4. Why it matters
5. The result (before/after)
6. What's next
7. CTA: [Try it / Join the waitlist / Book a call]

Tone: [CONTEXT: brand_voice_tone]. Show personality.
Language: [CONTEXT: language_pref]
Format: Thread. Each post 250 chars max.
Formatting: [CONTEXT: formatting_rules]
Avoid: [CONTEXT: words_to_avoid]
```

### CONDITIONAL: LinkedIn Authority Post (Authority Education)

```markdown
# LinkedIn Authority Post Recipe

## When to Use
You have a POV on [CONTEXT: top_pain_1] or [CONTEXT: industry_trend]. Post it. Build credibility.

## Instructions for Claude

I'm [CONTEXT: student_name]. My contrarian take: [CONTEXT: core_thesis_from_profile]

My ICP: [CONTEXT: icp_persona]
My product: [CONTEXT: product_name] solves [CONTEXT: top_pain_1]

Write a LinkedIn post (1500-2000 characters) that:
1. Opens with a provocative statement (not "AI is changing...")
2. Backs it with [CONTEXT: pain_evidence] or market data
3. Offers a 3-step framework for [how to think about this problem / how to solve this problem]
4. Ends with: Here's how we built [CONTEXT: product_name] using this principle. Try it.

Tone: [CONTEXT: brand_voice_tone]. Teach, don't pitch.
Language: [CONTEXT: language_pref]
Formatting: [CONTEXT: formatting_rules]
Avoid: [CONTEXT: words_to_avoid]
```

### CONDITIONAL: Trend Response (Wave Riding)

```markdown
# Trend Response Recipe

## When to Use
A trend surfaces related to [CONTEXT: top_pain_1] or [CONTEXT: industry_space]. Respond fast.

## Instructions for Claude

Trend: [Student provides: what's trending?]

My take: [Student provides: what's your POV on it?]

Our angle: [CONTEXT: product_name] + [CONTEXT: positioning_wedge]

Write 3 versions of a trend response:
1. LinkedIn post (500 chars) — fast take + product angle
2. Twitter thread (4 tweets) — shorter, punchier, link to demo
3. Email to community (200 words) — longer form, teaching angle

All versions:
- Lead with the trend
- Inject [CONTEXT: positioning_wedge]
- End in CTA: [join waitlist / book demo / try product]

Tone: [CONTEXT: brand_voice_tone]
Language: [CONTEXT: language_pref]
Speed: Publish within 2 hours of trend. Freshness matters.
```

### CONDITIONAL: Cold Outreach Sequence (Signal Sniper)

```markdown
# Cold Outreach Sequence Recipe

## When to Use
You've identified 10 prospects who fit [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]. Want to start conversations.

## Instructions for Claude

I'm reaching out to [CONTEXT: icp_persona] at [CONTEXT: icp_company_type] in [CONTEXT: icp_geography].

They're struggling with: [CONTEXT: top_pain_1]

My product: [CONTEXT: product_name]
My positioning: [CONTEXT: positioning_wedge]
My CTA: [CONTEXT: low_friction_cta] (e.g., "15-minute call to explore")

Build a 5-email cold sequence:

Email 1: [Subject] + [Body]
Email 2: [Subject] + [Body]
Email 3: [Subject] + [Body]
Email 4: [Subject] + [Body]
Email 5: [Subject] + [Body]

Rules:
- Email 1: Lead with their pain, not your product. Proof point: [CONTEXT: proof_point]
- Email 2: Pattern interrupt. Question. Not aggressive.
- Email 3: Social proof. Case study snippet.
- Email 4: Different angle. What if they're solving it wrong?
- Email 5: Final ask. Low friction. "15 min" not "let's discuss your digital transformation."

Subject lines: [No clickbait. Credible. Curiosity.]
Bodies: Short. 3-5 sentences max.
Tone: [CONTEXT: brand_voice_tone]. Peer-to-peer, not salesy.
Language: [CONTEXT: language_pref]
Signature: [CONTEXT: student_name], [CONTEXT: product_name]
```

### CONDITIONAL: Outcome Demo Script (Outcome Demo)

```markdown
# Outcome Demo Script Recipe

## When to Use
You're on a demo call. Use this to script the flow that moves from pain → outcome → product → commitment.

## Instructions for Claude

My demo (30 min):
- ICP: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
- Their pain: [CONTEXT: top_pain_1]
- Their dream outcome: [CONTEXT: dream_outcome]
- My product: [CONTEXT: product_name]
- My positioning: [CONTEXT: positioning_wedge]

Build a demo script:

1. Intro (2 min): Establish credibility. Ask permission to show them something.
2. Problem + Proof (5 min): "Here's what I see [CONTEXT: icp_persona] struggle with: [pain]. Evidence: [proof]."
3. Vision (3 min): "Here's what [dream outcome] looks like in practice."
4. Demo (15 min): Walk through [CONTEXT: product_name]. Show it solving pain → achieving outcome.
5. Close (5 min): "If we can deliver this outcome, are you interested?" → Path to next step.

For each section, include:
- What you say
- What they see (screen, demo, proof point)
- What you listen for (buying signal)

Tone: [CONTEXT: brand_voice_tone]. Conversational. Show confidence in the product.
Language: [CONTEXT: language_pref]
Avoid: Feature dump. Death by 100 slides. Demo the outcome, not the feature.
```

### CONDITIONAL: Feature Release (Hammering Feature)

```markdown
# Feature Release Recipe

## When to Use
You've shipped a new feature that solves a specific pain for [CONTEXT: icp_persona].

## Instructions for Claude

The feature: [Student provides: what did you build?]
The pain it solves: [CONTEXT: top_pain_1]
The outcome for [CONTEXT: icp_persona]: [CONTEXT: dream_outcome]

Build my feature release announcement across 3 channels:

1. LinkedIn post (1000 chars)
   - Open with the pain
   - Show the feature
   - Social proof / results
   - CTA: Try it / Demo

2. Email to existing customers (300 words)
   - Subject: [Benefit-driven, not feature-driven]
   - Why we built this
   - How it works
   - Access link
   - What's next

3. Launch day social media (Twitter thread, 4 tweets)
   - Tweet 1: The problem
   - Tweet 2: Our solution
   - Tweet 3: Demo video or GIF
   - Tweet 4: CTA + link

Tone: [CONTEXT: brand_voice_tone]
Language: [CONTEXT: language_pref]
Formatting: [CONTEXT: formatting_rules]
```

### CONDITIONAL: SEO Content Brief (BOFU SEO)

```markdown
# SEO Content Brief Recipe

## When to Use
You're writing BOFU (bottom-of-funnel) content targeting [CONTEXT: icp_persona] searching for how to solve [CONTEXT: top_pain_1].

## Instructions for Claude

My target keyword: [Student provides: what search term are we going after?]
Audience: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
Pain point: [CONTEXT: top_pain_1]
Solution angle: [CONTEXT: positioning_wedge]

Build an SEO content brief:

1. Title + meta description (60 chars each)
2. H1 + subheading structure
3. Introduction (150 words) — Establish the problem + why it matters
4. Section 1: [The wrong approach to this problem]
5. Section 2: [The right framework (3-5 steps)]
6. Section 3: [Case study / proof point]
7. Section 4: [How [CONTEXT: product_name] solves this]
8. CTA: [Product trial / demo / waitlist]
9. Conclusion (50 words)

Tone: Teach first. Product second.
Language: [CONTEXT: language_pref]
Target word count: 1800-2200
Formatting: [CONTEXT: formatting_rules]
```

### CONDITIONAL: Prospect Research (Dream 100)

```markdown
# Prospect Research Recipe

## When to Use
You're targeting a specific Dream 100 prospect. Use this to research them before first contact.

## Instructions for Claude

Target: [Student provides: company name + contact name]
Your ICP: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
Your pain angle: [CONTEXT: top_pain_1]

Build a prospect research brief:

1. Company Context (1 paragraph)
   - What they do
   - Size, market, growth signals
   - Competitive position

2. Role Context (1 paragraph)
   - Their role, responsibilities
   - Recent promotions / job changes
   - Their priorities (inferred from LinkedIn, interviews)

3. Pain Alignment (1 paragraph)
   - Why they likely have [CONTEXT: top_pain_1]
   - What signals suggest this pain is urgent
   - Proof points from their company, role, recent activity

4. Angle (1 paragraph)
   - Your positioning: [CONTEXT: positioning_wedge]
   - Why it matters to THEM specifically
   - Proof point to lead with

5. Outreach Plan (3 bullets)
   - Channel (email, LinkedIn, intro)
   - First message angle
   - CTA

Tone: [CONTEXT: brand_voice_tone]
Language: [CONTEXT: language_pref]
```

### CONDITIONAL: Event Playbook (7x4x11)

```markdown
# Event Playbook Recipe

## When to Use
You're hosting or speaking at an event. Use this to build the full playbook: pre-event, during, after.

## Instructions for Claude

The event: [Student provides: what event? when? where? audience size?]
Your ICP: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
Your positioning: [CONTEXT: positioning_wedge]

Build your event playbook:

Pre-Event (7 days before):
- Email to attendees
- LinkedIn posts
- Who to research + connect with

During Event (day-of):
- Your talk outline (if speaking): problem → framework → solution
- Networking flow (who to talk to, what to ask)
- Demo / booth flow (if applicable)

Post-Event (11 days after):
- Email follow-up sequence to new connections
- Content recap post
- Metric: how many demo bookings / committed conversations?

Tone: [CONTEXT: brand_voice_tone]
Language: [CONTEXT: language_pref]
Formatting: [CONTEXT: formatting_rules]
Goal: [CONTEXT: top_pain_1] awareness + [X] demo bookings
```

### CONDITIONAL: Training Outline (Value Trust)

```markdown
# Training Outline Recipe

## When to Use
You're building a free training (webinar, course, masterclass) to establish authority + convert.

## Instructions for Claude

Topic: How [CONTEXT: icp_persona] can solve [CONTEXT: top_pain_1]

Your framework: [Student provides: 3-5 step framework]
Your product angle: [CONTEXT: product_name] implements step [X]

Build a 60-minute training outline:

1. Intro + Hook (5 min) — Why [pain] is misunderstood
2. Framework Teaching (40 min) — Deep dive on your 3-5 step framework + case studies
3. Demo (10 min) — How [CONTEXT: product_name] does step [X]
4. Q&A (5 min)

For each section:
- Slides / visuals
- Speaker notes
- Key teaching points
- Proof points

Tone: Generous with teaching. Confident in your framework.
Language: [CONTEXT: language_pref]
Formatting: [CONTEXT: formatting_rules]
CTA: Free trial / demo / community
```

### CONDITIONAL: VSL Script (Paid VSL)

```markdown
# VSL Script Recipe

## When to Use
You're creating a video sales letter (VSL) for ads or email. High-converting script.

## Instructions for Claude

Product: [CONTEXT: product_name]
ICP: [CONTEXT: icp_persona] at [CONTEXT: icp_company_type]
Pain: [CONTEXT: top_pain_1]
Positioning: [CONTEXT: positioning_wedge]
Dream outcome: [CONTEXT: dream_outcome]
Price: [Student provides: price point]

Build a 3-5 min VSL script:

1. Hook (30 sec) — Grab attention with the pain or a bold statement
2. Problem (60 sec) — Deepen the pain. Make them feel it.
3. Thesis (30 sec) — Your contrarian take: [CONTEXT: positioning_wedge]
4. Solution (90 sec) — Here's how [CONTEXT: product_name] solves it. Demo/visual.
5. Social Proof (30 sec) — Case study / testimonial
6. CTA (30 sec) — Urgency + offer + link

Format: [As written script, not storyboard]
Tone: [CONTEXT: brand_voice_tone]. Conversational. Direct.
Language: [CONTEXT: language_pref]
Video cues: [Include when slides / B-roll / demo happens]
```

---

## SELF-SCORE PROTOCOL

After generating all recipes, score across 6 dimensions:

| # | Dimension | Check | Scoring |
|---|-----------|-------|---------|
| 1 | Context accuracy | Every [CONTEXT: field] filled from brain files, no fabrication | 10=all accurate, 8=1-2 inferred, <6=made up |
| 2 | Completeness | All selected recipes generated, all sections filled | 10=all complete, 8=1 thin, <6=missing recipes |
| 3 | Copy-paste ready | Student can paste into Claude without any edits | 10=fully ready, 8=minor edits needed, <6=needs heavy editing |
| 4 | Voice consistency | Each recipe uses student's brand voice, tone, constraints | 10=consistent throughout, 8=1-2 off-tone |
| 5 | GTM alignment | Conditional recipes match top GTM motions + tiers | 10=perfect match, 8=mostly matched, <6=misaligned |
| 6 | Language accuracy | All output in student's chosen language, no mixed code | 10=fully consistent, 8=1-2 phrases off |

**Threshold:** 8.5/10 overall. Below 8.5 → iterate automatically before delivery.

---

## QUALITY GATES

### Before Generation

- Confirm all 5 brain files exist: `1-ProjectBrain/Project/*.md`
- Confirm language pref file exists: `1-ProjectBrain/_language-pref.md`
- If missing, route to 1-eo-brain-ingestion

### During Generation

- Validate context extraction: every [CONTEXT: field] has a value
- Flag empty fields: "[MISSING: field_name — add in brain or manually]"
- No hallucination: if data isn't in brain files, mark as missing

### After Generation

- Self-score across 6 dimensions
- If below 8.5/10, iterate weak dimensions before delivery
- Confirm all recipes written to `1-ProjectBrain/templates/`

---

## ERROR HANDLING

| Error | Response |
|-------|----------|
| Brain files missing | "Your business brain isn't complete. You need: [list missing files]. Run /eo-brain-ingestion first." |
| Language pref missing | Ask: "What's your language preference? (ar/en)" Create file. Then proceed. |
| GTM motion file invalid | "Your gtm.md file is missing motion rankings. Regenerate from 1-eo-brain-ingestion or manually add rankings." |
| ICP missing critical field | "Your ICP is missing [field]. Add it to icp.md or manually specify it here." |
| Self-score below 8.5 | Auto-iterate. Identify weak dimension. Regenerate that section. Re-score. Present only when ≥8.5. |
| Directory missing | Create `1-ProjectBrain/templates/` automatically before writing files. |

---

## CROSS-SKILL DEPENDENCIES

### What This Skill Reads

| Source | File(s) | Why |
|--------|---------|-----|
| 1-ProjectBrain/Project/ | gtm.md, icp.md, positioning.md, brandvoice.md | Context injection |
| 1-ProjectBrain/ | _language-pref.md | Output language |
| 1-ProjectBrain/ | profile-settings.md (optional) | Hard constraints for recipes |

### What Downstream Skills Read From This Skill's Output

| Consumer | Files They Read | Use |
|----------|----------------|-----|
| 2-eo-gtm-asset-factory | 1-ProjectBrain/templates/INDEX.md | Navigation to task recipes |
| Student | 1-ProjectBrain/templates/*.md | Copy-paste into Claude for each task |

### Progressive Enhancement

- No downstream skill modifies templates (student-modified only)
- 2-eo-gtm-asset-factory creates ASSET templates (in 2-GTM/Templates/) separate from task recipes

---

## STUDENT WORKFLOW

1. Run 1-eo-brain-ingestion (Phase 1)
2. Run 1-eo-template-factory (Phase 2) ← You are here
3. Get task recipes in `1-ProjectBrain/templates/`
4. Copy any recipe → paste into Claude → get output
5. Use output to build GTM assets (Phase 3 with 2-eo-gtm-asset-factory)

---

*EO MicroSaaS OS v2 — 1-eo-template-factory v2.0 — Phase 2 Task Recipes*
