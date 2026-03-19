---
name: eo-gtm-asset-factory
description: "EO GTM Asset Factory v2 — Orchestrator skill that reads scorecard results, lets the customer pick ONE GTM motion from their top 3, collects brand colors and language preference, then produces a complete asset bundle: core assets (warm sequences, landing page, LinkedIn posts, 1-pager, slide deck) + motion-specific assets. Triggers: 'build my GTM assets', 'generate assets', 'GTM factory', 'produce my launch assets', 'create my GTM bundle'."
version: "2.0"
---

# EO GTM Asset Factory v2

**Version:** 2.0
**Date:** 2026-03-19
**Role:** GTM Asset Orchestrator (Skill 2 of EO MicroSaaS OS)
**Purpose:** Produce a focused, high-quality GTM asset bundle for ONE selected motion + universal core assets. Every asset is tailored to the customer's ICP, positioning, brand voice, brand colors, and language.

---

## HOW THIS SKILL WORKS

This is an **interactive** skill. It does NOT dump 25 generic files. It:

1. **Reads** the customer's scorecard results (SC5 GTM Fitness) to get their ranked GTM motions
2. **Shows** the top 3 motions with scores and descriptions
3. **Asks** the customer to pick ONE primary GTM motion (from top 3, or they can pick any of the 13)
4. **Asks** for 2-4 brand colors (hex codes or descriptions like "dark navy, bright orange")
5. **Asks** for language preference: English, Arabic, or Both
6. **Generates** core assets (always produced regardless of GTM) + motion-specific assets (only for the selected GTM)

The output is focused, not bloated. One GTM done right > 13 GTMs done mediocre.

---

## INTERACTIVE FLOW

### Step 1: Context Load

Read these files (ask customer for location if not obvious):

| File | What We Need |
|------|-------------|
| SC5 GTM Fitness scorecard | Motion rankings table (13 motions with Fit/Readiness/MENA scores) |
| project-brain/positioning.md | Wedge angle, unique mechanism, one-sentence positioning |
| project-brain/icp.md | Persona, pains, dream outcome, buyer journey, access channels |
| project-brain/brandvoice.md | Tone, language rules, words to use/avoid |
| project-brain/companyprofile.md | Venture name, one-liner, pricing, URL |
| project-brain/founderprofile.md | Founder story, archetype, network |

### Step 2: Show Top 3 + Ask for Selection

Display:

```
YOUR TOP 3 GTM MOTIONS (from SC5):

#1 [Motion Name] — Score: X.X (PRIMARY)
   → [One-line description of what this motion does]
   → Best for: [context]

#2 [Motion Name] — Score: X.X (PRIMARY)
   → [One-line description]
   → Best for: [context]

#3 [Motion Name] — Score: X.X (PRIMARY)
   → [One-line description]
   → Best for: [context]

Which GTM motion do you want to build assets for?
Pick 1, 2, or 3 — or type the name of any other motion from the full list of 13.
```

If customer wants to see the full 13, show them. But guide toward top 3.

### Step 3: Collect Brand Info

```
BRAND SETUP:

1. What are your brand colors? (Give me 2-4 colors)
   Examples: "Dark navy #1A1A2E, Orange #FF6B00, Light gray #F5F5F5"
   Or just describe: "black and orange" and I'll pick the hex codes.

2. Language preference for your assets:
   (a) English only
   (b) Arabic only
   (c) Both English and Arabic
```

### Step 4: Confirm and Generate

```
PRODUCTION PLAN:

GTM Motion: [Selected Motion]
Brand Colors: [Primary] / [Secondary] / [Accent] / [Background]
Language: [Selection]

CORE ASSETS (always produced):
  ✓ Warm email sequence (3 emails) — DOCX
  ✓ LinkedIn warm outreach sequence (3 messages) — DOCX
  ✓ WhatsApp warm outreach sequence (3 messages) — DOCX
  ✓ Landing page — HTML (your brand colors)
  ✓ 2 LinkedIn launch posts — DOCX
  ✓ 1-pager company overview — DOCX (PDF-ready)
  ✓ 10-slide pitch deck — PPTX

MOTION-SPECIFIC ASSETS ([Selected Motion]):
  ✓ [List from the motion's sub-skill file]

Ready to generate? (yes/no)
```

On confirmation, proceed to generation.

---

## THE 13 GTM MOTIONS

Each motion has its own specification file in `motions/`. When a customer selects a motion, read that file for the specific asset templates.

| # | Motion | Sub-Skill File | Score Range |
|---|--------|---------------|-------------|
| 1 | Dream 100 Strategy | motions/dream-100.md | Network leverage |
| 2 | Authority Education Engine | motions/authority-education.md | Content authority |
| 3 | Outcome Demo First | motions/outcome-demo-first.md | Proof-led selling |
| 4 | Value Trust Engine | motions/value-trust-engine.md | Give-first trust |
| 5 | Waitlist Heat-to-Webinar Close | motions/waitlist-webinar.md | Controlled launches |
| 6 | Signal Sniper Outbound | motions/signal-sniper-outbound.md | Intent-based outbound |
| 7 | 7x4x11 Strategy | motions/7x4x11-strategy.md | Content distribution |
| 8 | MicroSaaS BOFU SEO Strike | motions/bofu-seo.md | Search-driven inbound |
| 9 | Hammering-Feature-First Launches | motions/hammering-feature-first.md | Feature-led launches |
| 10 | Build-in-Public Trust Flywheel | motions/build-in-public.md | Transparency trust |
| 11 | Wave Riding Distribution | motions/wave-riding.md | Trend riding |
| 12 | Paid VSL Value Ladder | motions/paid-vsl.md | Paid acquisition |
| 13 | LTD Cash-to-MRR Ladder | motions/ltd-cash-to-mrr.md | Lifetime deal launch |

---

## CORE ASSETS (Always Produced)

Read `core-assets.md` for full specifications. Summary:

### 1. Warm Email Sequence (DOCX)
3-email sequence for warm contacts (existing network, newsletter, community).
- Email 1: "Something new" announcement with value hook
- Email 2: Social proof + outcome demo
- Email 3: Soft CTA (book a call, join waitlist, or try free)

### 2. LinkedIn Warm Outreach (DOCX)
3-message sequence for warm LinkedIn connections.
- Connection note (if not connected): mention mutual context
- Message 1: Value-give (insight, resource, or demo link)
- Message 2: Specific ask (15-min call or waitlist)
- Message 3: Breakup (no guilt, leave door open)

### 3. WhatsApp Warm Sequence (DOCX)
3-message WhatsApp sequence for warm contacts.
- Message 1: Casual announcement + one-line hook
- Message 2: Voice note script (30 seconds) with outcome proof
- Message 3: Direct CTA with time-bound element

### 4. Landing Page (HTML)
Full production-ready landing page using customer's brand colors.
Quality benchmark: SMO's the-engine-ghl.html and smorchestra-home-ghl.html
- CSS variables for all colors (easy customization)
- Hero: headline + subtitle + CTA + trust signals
- Problem section: ICP's top 3 pains
- Solution section: unique mechanism + outcome
- Social proof section: testimonials, logos, numbers
- CTA section: primary conversion action
- Mobile responsive, RTL-ready if Arabic

### 5. LinkedIn Launch Posts (DOCX)
2 posts for announcing the product launch on LinkedIn.
- Post 1: Story-driven (origin story + what I built + who it's for)
- Post 2: Value-driven (3 specific outcomes + CTA)
- Each post: 150-250 words, no hashtag spam (max 3), strong hook first line

### 6. Company 1-Pager (DOCX)
Single-page company overview, PDF-ready.
- Header: logo area + venture name + one-liner
- Problem → Solution → For Who → Why Now → Traction → CTA
- Max 400 words. Clean layout. Brand colors applied.

### 7. 10-Slide Pitch Deck (PPTX)
Presentation deck with customer's brand colors.
Slide structure:
1. Title: Venture name + one-liner + logo area
2. Problem: ICP's top 3 pains with specific data
3. Solution: What you built and why it's different
4. How It Works: 3-step process visualization
5. Market: TAM/SAM/SOM with MENA-specific data
6. Traction: Validation evidence, beta users, waitlist size
7. Business Model: Pricing tiers + unit economics
8. GTM Strategy: The selected motion explained simply
9. Team: Founder story + credibility signals
10. CTA: Next step + contact info

---

## BRAND VOICE ENFORCEMENT

Every asset must pass these checks:

1. **First line test:** Pattern interrupt. No "I hope this finds you well" or "Dear Sir/Madam"
2. **Word filter:** Scan against brandvoice.md Words to Avoid. Replace matches.
3. **Tone match:** Align to founder archetype:
   - The Closer: direct, proof-heavy, numbers-first
   - The Builder: show-don't-tell, product-focused
   - The Connector: community-language, social-proof
4. **Length check:** Emails < 150 words. LinkedIn messages < 100 words. WhatsApp < 50 words.
5. **CTA check:** Every piece has exactly ONE call-to-action.
6. **MENA check:** If targeting MENA:
   - Trust signals front-loaded
   - No hard sell in first touch
   - WhatsApp sequences in Gulf Arabic (conversational, not MSA)
   - RTL support in landing page if Arabic selected

---

## OUTPUT STRUCTURE

```
assets/
├── README.md                           # Index + usage guide
├── brand-config.md                     # Brand colors, fonts, language recorded
├── core/
│   ├── warm-email-sequence.docx        # 3-email warm sequence
│   ├── linkedin-warm-sequence.docx     # 3-message LinkedIn outreach
│   ├── whatsapp-warm-sequence.docx     # 3-message WhatsApp outreach
│   ├── landing-page.html               # Production-ready landing page
│   ├── linkedin-launch-post-1.docx     # Story-driven launch post
│   ├── linkedin-launch-post-2.docx     # Value-driven launch post
│   ├── company-one-pager.docx          # 1-page company overview
│   └── pitch-deck-10slides.pptx        # 10-slide presentation
├── [selected-motion]/                  # Motion-specific assets
│   ├── [asset-1].docx
│   ├── [asset-2].docx
│   └── ...
└── [selected-motion]-ar/               # Arabic versions (if "both" selected)
    ├── [asset-1].docx
    └── ...
```

If language = "both", every DOCX/MD asset gets an `-ar/` mirror folder with Arabic versions.
Landing page gets `dir="rtl"` + Arabic fonts (Cairo headers, Tajawal body) in the Arabic version.
PPTX gets a separate Arabic version with RTL slide layout.

---

## QUALITY GATES

### Per-Asset Gates

| Gate | Check | Fail Action |
|------|-------|-------------|
| Brand Voice | Words to Avoid filter | Rewrite |
| Length | Within format limits | Cut ruthlessly |
| CTA | Exactly one per piece | Fix |
| ICP Match | References specific ICP details | Rewrite with specifics |
| Positioning | Uses wedge angle or mechanism | Inject positioning |
| Brand Colors | All outputs use customer's palette | Fix colors |
| First Line | Pattern interrupt test | Rewrite opener |
| Language | Correct language per selection | Translate/fix |

### Bundle Gates

| Gate | Check | Fail Action |
|------|-------|-------------|
| Completeness | All core + motion assets present | Generate missing |
| Consistency | Same positioning across all assets | Align |
| Color Match | Landing page + deck use same colors | Fix |
| Format | DOCX for messaging, HTML for landing page, PPTX for deck | Convert |

---

## EXECUTION SUMMARY

After generation, display:

```
GTM ASSET BUNDLE COMPLETE

Motion: [Selected]
Language: [EN/AR/Both]
Brand: [Color palette shown]

CORE ASSETS (7 files):
  ✓ warm-email-sequence.docx
  ✓ linkedin-warm-sequence.docx
  ✓ whatsapp-warm-sequence.docx
  ✓ landing-page.html
  ✓ linkedin-launch-post-1.docx
  ✓ linkedin-launch-post-2.docx
  ✓ company-one-pager.docx
  ✓ pitch-deck-10slides.pptx

MOTION ASSETS ([N] files):
  ✓ [list each file]

Total: [X] files in assets/
Output: [path]

DEPLOYMENT ORDER:
1. Review and customize the 1-pager and deck first
2. Set up the landing page (host or paste into GHL)
3. Load email sequence into your CRM/Instantly
4. Queue LinkedIn posts (post 1 on launch day, post 2 three days later)
5. Send WhatsApp sequence to warm contacts on launch day
6. Deploy motion-specific assets per the motion's playbook
```

---

## CROSS-SKILL DEPENDENCIES

### Upstream
| Skill | What It Provides |
|-------|-----------------|
| eo-brain-ingestion | 12 project-brain files (positioning, ICP, brand voice, etc.) |
| SC5 GTM Fitness | Motion rankings that determine top 3 options |

### Downstream
| Skill | What It Consumes |
|-------|-----------------|
| eo-gtm-asset-builder | Production renderer — converts MD blueprints to DOCX/PPTX/HTML/PDF |
| eo-skill-extractor | Student extracts reusable skills from assets |

### Production Renderer
The `eo-gtm-asset-builder` skill (Node.js) handles converting markdown asset blueprints into production files:
- MD → DOCX (using `docx` library)
- MD → PPTX (using `pptxgenjs`)
- MD → HTML landing page (template with CSS variables for brand colors)
- MD → PDF (using Puppeteer or print-ready HTML)

Run: `cd skills/eo-gtm-asset-builder && node render.js --motion [selected] --colors "#hex1,#hex2,#hex3" --lang [en|ar|both]`
