---
name: asset-factory
description: "Produces multi-channel campaign assets (cold email sequences, LinkedIn DMs, LinkedIn authority posts, social posts, VSL scripts, 1-pagers, landing pages, slide decks, DOCX documents) from validated positioning and wedges. Generates production-ready files with consistent brand design, vulnerability-arc storytelling, and signal-based trust engineering tone. Use when creating campaign assets, generating sequences, producing branded deliverables, or scaling content production. Outputs complete asset bundle ready for deployment."
---

# Asset Factory

## Purpose

Transforms validated positioning and wedges into complete multi-channel campaign assets: production-ready files across email, LinkedIn, social, VSL, and branded documents (DOCX, PDF, PPTX, HTML).

**Core Philosophy**: Every asset activates psychological triggers, maintains vulnerability-arc storytelling, and serves trust engineering, not feature-dumping. Quality over volume. One elite sequence beats 42 mediocre assets.

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this during:
- **Mode A (New Campaign)**: Fourth sub-skill (after wedge-generator)
- **Mode B (Weekly Assets)**: Weekly asset bundles
- **Mode C (Full Campaign Pack)**: Complete deliverable set (email + LinkedIn + social + VSL + docs)

Direct invoke: "Generate email sequences", "Create LinkedIn messages", "Produce campaign assets", "Build campaign pack", "Generate outreach sequences"

## Inputs

### Required

1. **Positioning Document** (from positioning-engine): Core thesis, ICP, offer architecture, psychological triggers
2. **Wedges** (from wedge-generator or direct): Signal-matched one-sentence hooks
3. **ICP Context**: Who is the buyer, what stage, what pain
4. **Geographic Market**: MENA (high-context, trust-first) | US (low-context, direct) | Custom

### Optional
- **Brand Template**: Custom colors/fonts. If not provided, use SMOrch default brand system (see Brand Design System below)
- **Channel Mix**: Which channels to produce (email, LinkedIn DM, LinkedIn posts, social, VSL, docs)
- **Performance data** (Mode B refinement)
- **Existing battle cards or case studies**

## Brand Design System (Default)

Use these unless the user provides custom brand colors/templates.

### Document Colors (DOCX, PDF)
| Element | Color | Hex |
|---------|-------|-----|
| Primary Orange | Brand accent, headers, borders | #E8612D |
| Dark Navy | Body text, backgrounds | #1B2A3D |
| Body Gray | Paragraph text | #555555 |
| Light Gray | Secondary text, metadata | #888888 |

### Digital Colors (HTML, Landing Pages, Decks)
| Element | Color | Hex |
|---------|-------|-----|
| Background | Near-black | #0A0A0A |
| Primary Orange | CTAs, accents, highlights | #FF6600 |
| White | Body text on dark | #FFFFFF |
| Muted Gray | Secondary text | #999999 |

### Typography
- **English**: Inter (headings + body)
- **Arabic**: Cairo (headings + body)
- **Code/Data**: JetBrains Mono or monospace

### Document Structure Conventions
- Header: "[Company] | [Document Title]" with orange bottom border
- Footer: "[Thesis tagline] | Page X"
- Section spacing: generous whitespace between sections
- Tables: orange header row, alternating light gray rows
- No decorative elements. Clean, operator-grade design

## Outputs: Campaign Asset Bundle

```
campaign-assets/
├── outreach-sequences.md          (cold email + LinkedIn DM)
├── outreach-sequences.docx        (branded DOCX version)
├── linkedin-posts.md              (authority posts mirroring email arc)
├── social-posts.md                (cross-platform social)
├── vsl-scripts.md                 (full VSL + short version)
├── [name]-1pager.pdf              (branded 1-pager)
├── [name]-deck.pptx               (branded slide deck)
├── landing-page.html              (standalone HTML)
└── [name]-macro.md                (positioning + offer architecture)
```

Not every campaign needs every asset. Produce what the campaign requires.

---

## WRITING RULES (ALL ASSETS)

### Tone
- Direct. Every sentence earns its place
- Vulnerability as default hook: "I failed, here's what I learned"
- Peer-to-peer operator energy. Zero guru positioning
- Contrarian angle mandatory: if it sounds like every other consultant, kill it
- Documenting the build, not performing the highlight reel

### Hard Rules
- No em dashes. Use colons, commas, semicolons, hyphens only
- No filler: no "in today's rapidly evolving landscape," no "it's important to note"
- No banned words: leverage, synergy, ecosystem, holistic, digital transformation, innovative, cutting-edge, world-class, best-in-class
- Numbers always digits. Always specific. Always with timeframes
- Tool names always named. Never "an enrichment tool." Always "Clay"
- One idea per email/message. Not a list
- CTA always low-friction: "15-min call" not "discovery session"
- Real proof only. No fabricated case studies. Anonymize real ones if needed

### Psychological Trigger Hierarchy

Every asset must activate at minimum the top 3 triggers:

| Priority | Trigger | How It Works |
|----------|---------|-------------|
| ★ PRIMARY | Identity Threat | Current method is costing them. Status quo = losing |
| ★ PRIMARY | Costly Signal | Proof of competence embedded in the message itself |
| ★ PRIMARY | Temporal Window | Real urgency tied to market timing, not fake scarcity |
| Supporting | Asymmetric Information | Insider intelligence positioning |
| Supporting | In-Group/Out-Group | Self-selection sharpens desire |
| Supporting | Transformation Narrative | Identity shift, not skills gap |
| Supporting | Cognitive Fluency | System visualization breeds confidence |

**TOP 3 DEPLOYMENT RULE**: All assets must activate Identity Threat, Costly Signal, and Temporal Window. Supporting triggers used where format allows (landing page, macro doc, deck) but not required in short-form assets (cold email, DMs).

---

## COLD EMAIL SEQUENCE

### Architecture: 3-Email Vulnerability Arc

One sequence. One story arc across 3 emails. Not 3 independent pitches.

| Email | Day | Story Beat | Emotional Register | Primary Trigger | Length |
|-------|-----|------------|-------------------|----------------|--------|
| E1 | 1 | Vulnerable Origin: "I failed, studied what works, cracked it" | Vulnerable + credible | Identity Threat | 75-95 words |
| E2 | 3 | Trust-as-Science Confession: "My weakness became my edge" | Confessional + intellectually surprising | Identity Threat + Costly Signal | 75-95 words |
| E3 | 6 | System Proof: "Now AI/system runs it: here's proof" | Confident + operational | Costly Signal + Temporal Window | 75-95 words |

### Email Writing Rules

- **Subject lines**: 3-7 words, curiosity-driven, zero spam triggers
  - Good: "{{firstName}} <> [Sender]", "I was terrible at relationships", "AI runs 80% of my GTM"
  - Bad: "Quick question", "Boost your revenue", anything with exclamation marks
- Pattern interrupt in first line. Never "I hope this email finds you well"
- Every email activates at least 1 of the top 3 psychological triggers
- CTA: reply or book call. Always low-friction. Single word CTAs encouraged ("Interested?" / "Worth a call?" / "Worth 15 minutes?")
- No P.S. lines unless they add genuine value
- No links in cold emails. Plain text only. Under 100 words
- Merge fields: {{firstName}}, {{company}}, {{signal}}
- **Deployment note**: Add one {{signal}} sentence to Email 1 opening for +0.2 on personalization score. Example: "Noticed {{company}} just {{signal}}." Place before the origin story

### A/B Testing Philosophy

Do NOT default to A/B email variants. One elite sequence > two mediocre ones.
A/B test only when explicitly requested or on specific elements (subject lines, CTAs).

### Scoring Gate

Every email must score 9.0+ on the Copywriting Scorer (System 3A, 9 criteria weighted) before shipping:
- C1: Subject Line (15%), C2: Opening Line (15%), C3: Spam Filter (12%), C4: Body Value Density (12%), C5: Social Proof (8%), C6: CTA (15%), C7: Personalization (10%), C8: Sequence Architecture (8%), C9: Tone & Voice (5%)

Systematic weakness to watch: C7 Personalization (template limitation at 8.0). Note as deployment-time fix with {{signal}} tokens.

**ICP-specific email templates**: Read `references/email-templates.md`

---

## LINKEDIN DM

### Architecture: Connect Clean + Single Signal Message

- **Connection**: No note. Let profile and content do the pre-work
- **Message**: ONE signal message after accept. No follow-up sequence
- Single message = zero harassment risk. Reply or move on

### A/B Test Framework (When Testing)

| Variant | Type | Word Count | Expected Result |
|---------|------|------------|----------------|
| Message A | Direct offer. Assumes they saw content. Low effort to reply | ~40 words | Higher volume, lower quality |
| Message B | Vulnerable story. Builds trust in the message itself. Self-selecting | ~85 words | Lower volume, higher quality |

### Test Parameters
- 50 connections per variant
- Measure reply rate + call booking rate at 2 weeks
- Kill the loser. Scale the winner

### Scoring Gate
LinkedIn DM must score 9.0+ on Copywriting Scorer (System 3C, 7 criteria weighted) before shipping.

**ICP-specific LinkedIn DM templates**: Read `references/linkedin-templates.md`

---

## LINKEDIN AUTHORITY POSTS

### Architecture: Mirror Email Sequence Structure

LinkedIn posts mirror the email vulnerability arc: same story beats, expanded for public content format.

| Post | Mirrors | Pillar | Hook Trigger | Suggested Day |
|------|---------|--------|-------------|--------------|
| Post 1 | E1 (origin story) | MENA Market Intelligence | STORY ENTRY | Tuesday |
| Post 2 | E2 (trust science) | Signal-Based GTM | STOLEN THOUGHT | Thursday |
| Post 3 | E3 (AI/system proof) | AI-Powered Revenue Ops | COMPARISON | Tuesday (next week) |

### Post Format Rules (Hard Gates)

- Max 55 characters per line (phone-first)
- Line break after every THOUGHT, not every sentence
- Fragments encouraged: "No CTO. No funding. No excuses." Three beats
- Hook is exactly 2 lines before "see more" fold. Statement, never question
- Rarely more than 8 words per sentence
- Three-beat repetition patterns
- Post length: 150-300 words
- Maximum 2 emojis per post (structure only, never clapping/fire/rocket)

### Required Elements Per Post

1. **Disagreement trigger**: one claim reasonable people could argue against. Place after proof, never open with unsubstantiated controversy
2. **Pinned comment**: 2-4 sentences, value-dense, zero self-promotion (bonus tool, expanded step, or teaser)
3. **Self-ID prompt or P.S. question**: rotate, never repeat in consecutive posts
4. **Proof density minimum**: 2 specific metrics + 1 named tool + 1 specific timeframe
5. **Named framework**: when teaching multi-step system, name it. Branded frameworks compound

### 8 Hook Psychological Triggers

Pick the trigger FIRST, then write the hook:

1. **CONTRADICTION**: Sounds wrong on purpose. Forces "wait, what?"
2. **ACCUSATION**: Calls reader out directly. Creates defensiveness
3. **STOLEN THOUGHT**: Says what they think but won't say publicly
4. **SPECIFICITY**: Number so precise it can't be fabricated
5. **STORY ENTRY**: Drops you into a moment
6. **TIMELINESS**: First to report. Urgency and FOMO
7. **COMPARISON**: Old vs New or Tool A vs Tool B
8. **SYSTEM REVEAL**: Exposes the machinery

### CTA Rotation (never same twice in a row)
1. Self-ID prompt (comment engagement)
2. P.S. question format
3. "Save this. You'll need it."
4. "Link in comments"
5. "Curious? Drop a comment."

### Scoring Gate
Each post must score 9.0+ on LinkedIn Branding Scorer (Track A: English B2B, 9 criteria):
- C1: Hook Power (18%), C2: Authority Signal (15%), C3: Contrarian Angle (12%), C4: Client Trigger Density (15%), C5: Value-to-Promotion Ratio (10%), C6: MENA Market Specificity (10%), C7: Format & Readability (8%), C8: Engagement Architecture (7%), C9: Consistency & Frequency (5%)

---

## SOCIAL POSTS

### Architecture: ICP-Targeted, Trigger-Activated

3 posts, each targeting a different ICP segment with a different entry angle:

| Post | ICP Target | Primary Trigger | CTA |
|------|-----------|----------------|-----|
| 1 | Pipeline problems (has product, broken GTM) | Identity Threat | Assessment/scorecard link |
| 2 | No audience (has expertise, no distribution) | Costly Signal | Assessment/scorecard link |
| 3 | Founder bottleneck (founder IS the GTM) | Temporal Window | Assessment/scorecard link |

### Post Rules
- 150-210 words each
- Opens with identity threat hook (competitor advantage angle)
- Includes anonymized case example
- Embeds costly signal naturally
- Temporal window in CTA
- Copy-paste ready
- No hashtags in body. Add 2-3 at bottom if platform requires

---

## VSL SCRIPTS

### Architecture: 5-Minute Full + 1-Minute Short

**5-Minute VSL Timeline:**

| Timestamp | Section | Dominant Trigger |
|-----------|---------|-----------------|
| 0:00-0:30 | Identity Threat hook + thesis statement | Identity Threat |
| 0:30-1:30 | 3 lies/myths the audience believes | Identity Threat |
| 1:30-2:30 | Mechanism reveal (system visualization: DIAGNOSE → SCORE → SELECT → INSTALL → OPERATE) | Costly Signal |
| 2:30-3:30 | Proof: anonymized cases + credentials | Costly Signal |
| 3:30-4:30 | Offer breakdown (phased structure with outcomes per phase) | Transformation Narrative |
| 4:30-5:00 | Temporal close (real market-timing scarcity) | Temporal Window |

### Script Rules
- Spoken word: conversational but intentional. No filler
- Include [PAUSE], [TEXT ON SCREEN], [B-ROLL] directions
- Anonymize company references
- Production notes: visual guidelines, B-roll strategy, audio, pacing

**1-Minute Short**: Condense to hook + mechanism + proof + CTA. For ads/reels.

---

## DOCUMENT GENERATION (DOCX, PDF, PPTX, HTML)

### DOCX Generation
Use Node.js `docx` library. Structure:
- Header with brand bar (orange bottom border)
- Footer with thesis tagline + page numbers
- Title page with meta table (sender, price, duration, version)
- Sections with branded heading styles (orange accent color)
- Scoring tables with orange header rows
- Body text in clean, professional formatting
- No decorative images. Content density > decoration

### PDF Generation
Use Python `reportlab` Canvas API. Same brand colors. Clean layout.

### PPTX Generation
Use PptxGenJS (Node.js). Dark backgrounds (#0A0A0A), orange accents (#FF6600), white text. Operator-grade, not marketing-fluffy.

### HTML Landing Pages
Standalone single-file HTML. Dark theme (#0A0A0A bg), orange CTAs (#FF6600), Inter font, responsive, no external dependencies except CDN fonts.

---

## ANONYMIZATION RULES

When using real company examples, anonymize:

| Pattern | Format |
|---------|--------|
| Client company | "[Descriptor], [Country/Region]" |
| Person names | Remove entirely or use first name only with permission |
| Exact revenue | Use ranges or "X+" format |
| Competitor names | "[Category] company" |

Examples:
- "Uniphore" → "US-Based Conversational AI Scale-up"
- "ThoughtNudge" → "B2B AI Campaign Management, UAE"
- "BCX" → "Local Tech Vendor, KSA"

---

## GEOGRAPHIC TONE ADAPTATION

| Dimension | MENA | US |
|-----------|------|------|
| Context level | High (implied, trust-first) | Low (explicit, data-first) |
| Language | "We", peer references, vulnerability | "You", metrics, directness |
| Proof type | Peer names, MENA examples, credentials | Numbers, ROI, case studies |
| Sequence length | 3 emails (vulnerability arc) | 3 emails (value arc) |
| Channel priority | WhatsApp > LinkedIn > Email | Email > LinkedIn |
| Trust mechanism | Confession + costly signal | Data + social proof |

---

## SCORING GATES (Mandatory Before Shipping)

| Asset Type | Scorer | Minimum Score |
|------------|--------|---------------|
| Cold emails | Copywriting Scorer (3A) | 9.0 |
| LinkedIn authority posts | LinkedIn Branding Scorer (Track A/B) | 9.0 |
| Headlines/positioning | Offer Positioning Scorer | 9.5 |
| LinkedIn DMs | Copywriting Scorer (3C) | 9.0 |
| Social posts | Social Media Scorer | 8.5 |
| VSL scripts | Copywriting Scorer (3B) | 8.5 |

**Hard stop**: Any individual criterion below 5.0 = rewrite before shipping.

**Scoring output format**: Include full scoring breakdown table with each asset (criterion, weight, score, notes). Include composite score and verdict (ELITE 9-10 / STRONG 7.5-8.9 / ADEQUATE 6-7.4 / WEAK <6).

---

## INTEGRATION

**Upstream**: positioning-engine (thesis, offer, triggers), wedge-generator (wedges), campaign-strategist (ICP, hierarchy)
**Downstream**: outbound-orchestrator (deployment to Instantly/HeyReach/GHL), scoring-orchestrator (quality gate)

## Reference Files

| File | Content |
|------|---------|
| `references/email-templates.md` | Cold email vulnerability arc templates by ICP |
| `references/linkedin-templates.md` | LinkedIn DM + authority post templates by ICP |
| `references/social-templates.md` | Social post templates with trigger deployment |
| `references/whatsapp-templates.md` | WhatsApp variants by ICP (MENA-specific) |
