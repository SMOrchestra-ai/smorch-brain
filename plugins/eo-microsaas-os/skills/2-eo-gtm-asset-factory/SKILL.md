---
name: 2-eo-gtm-asset-factory
description: "EO GTM Asset Factory v2 — template-driven, branded, deployable asset production. Reads brain files + 22 pre-built templates, produces preGTM universal assets (outreach DOCX, landing page HTML, one-pager PDF, pitch deck PPTX) + 1 GTM motion playbook (30-day DOCX). Triggers on: 'build my GTM assets', 'generate assets', 'sales toolkit', 'GTM factory', 'phase 2', 'create outreach', 'build landing page'."
version: "2.0"
---

# GTM Asset Factory v2

**Build your complete sales toolkit and 30-day battle plan in one run.**

You're about to generate two things:
1. **Your Sales Toolkit** — 4 deployable preGTM assets (messages, landing page, one-pager, pitch deck)
2. **Your 30-Day Battle Plan** — 1 GTM playbook tailored to your highest-scoring motion

This is not a template dump. Everything is branded to your identity, filled with your positioning, and adapted to MENA realities. You sell first, build later.

---

## What This Skill Does

This skill reads your brain files and 22 pre-built templates from your workspace, swaps in your content, applies your brand colors, and generates actual deployable files:

- **DOCX outreach documents** (warm WhatsApp, cold WhatsApp, warm LinkedIn, cold LinkedIn, advisory close script)
- **HTML landing page** (responsive, branded, ready to deploy)
- **PDF one-pager** (company overview, proof points)
- **PPTX pitch deck** (7-10 slides, branded)
- **DOCX GTM playbook** (30-day execution plan for your selected motion)

All files are ready to use immediately. No "send to designer" step. No "fill in the blanks yourself" nonsense.

---

## Inputs: Where We Read From

### Brain Files (Your Project Context)
Read from: `EO-Brain/1-ProjectBrain/Project/`

| File | What We Extract | Used For |
|------|-----------------|----------|
| `gtm.md` | Motion rankings (all 13, with tiers and scores) | Recommend your best motion, display rankings |
| `positioning.md` | Wedge angle, unique mechanism, one-sentence positioning | All outreach copy and landing page |
| `icp.md` | Role, industry, pains, dream outcome, channels | Message targeting, pain language, objection handling |
| `brandvoice.md` | Primary/secondary/accent colors, fonts, tone rules, words to use/avoid | Visual branding of HTML/PPTX/PDF + copy tone |
| `companyprofile.md` | Venture name, one-liner, pricing tiers, tech stack | Company identity, landing page, one-pager |
| `founderprofile.md` | Founder name, archetype, origin story | Advisory close script personalization, credibility |
| `niche.md` | 3-level niche, demographics | Market positioning, landing page proof points |
| `market-analysis.md` | Growth signals, TAM/SAM/SOM | Landing page proof points, market context |
| `strategy.md` | Recommended strategy, 90-day roadmap | GTM playbook customization |
| `_language-pref.md` | Language preference (English or Arabic) | Message language selection, RTL support |

### Template Files (Asset Blueprints)
Read from: `EO-Brain/2-GTM/Templates/`

**preGTM templates (8 files):**
- `preGTM/warm-whatsapp-msg.md`
- `preGTM/cold-whatsapp-msg.md`
- `preGTM/warm-linkedin-msg.md`
- `preGTM/cold-linkedin-msg.md`
- `preGTM/advisory-close-script.md`
- `preGTM/landing-page.html`
- `preGTM/one-pager.md`
- `preGTM/pitch-deck.md`

**GTM motion templates (13 files):**
- `GTM/01-waitlist-heat-to-webinar.md`
- `GTM/02-build-in-public-trust.md`
- `GTM/03-authority-education-engine.md`
- `GTM/04-wave-riding.md`
- `GTM/05-ltd-cash-to-mrr.md`
- `GTM/06-signal-sniper-outbound.md`
- `GTM/07-outcome-demo-first.md`
- `GTM/08-hammering-feature-first.md`
- `GTM/09-bofu-seo-strike.md`
- `GTM/10-dream-100.md`
- `GTM/11-7x4x11-strategy.md`
- `GTM/12-value-trust-engine.md`
- `GTM/13-paid-vsl-value-ladder.md`

**Deployment reference:**
- `Templates/deployment-guide.md`

---

## Placeholder System

Templates use two placeholder types:

### Content Placeholders: {{PLACEHOLDER}}
Replaced with values extracted from brain files.

| Placeholder | Brain File | Example |
|-------------|-----------|---------|
| `{{VENTURE_NAME}}` | companyprofile.md | "SalesMfast AI" |
| `{{ONE_LINER}}` | companyprofile.md | "Signal-based CRM for Gulf SMEs" |
| `{{FOUNDER_NAME}}` | founderprofile.md | "Mamoun Alamouri" |
| `{{ICP_ROLE}}` | icp.md | "Sales Director" |
| `{{ICP_INDUSTRY}}` | icp.md | "Real Estate Tech" |
| `{{ICP_PAIN_1}}` | icp.md | "95% of outreach gets ignored" |
| `{{ICP_PAIN_2}}` | icp.md | "No way to qualify leads before call" |
| `{{ICP_PAIN_3}}` | icp.md | "Sales team burns 6+ hours on follow-up" |
| `{{ICP_DREAM_OUTCOME}}` | icp.md | "Every qualified lead responds within 2 hours" |
| `{{POSITIONING_STATEMENT}}` | positioning.md | (1-sentence positioning) |
| `{{UNIQUE_MECHANISM}}` | positioning.md | "Signal detection engine" |
| `{{WEDGE_ANGLE}}` | positioning.md | "Speed-to-qualification audit" |
| `{{PRICING_TIERS}}` | companyprofile.md | "Starter $99/mo, Pro $299/mo, Enterprise custom" |
| `{{MARKET_SIZE}}` | market-analysis.md | "12,000+ SMEs in GCC region" |
| `{{GROWTH_SIGNALS}}` | market-analysis.md | "Real estate tech market growing 42% YoY" |
| `{{NICHE_L1}}` | niche.md | "Sales Tech" |
| `{{NICHE_L2}}` | niche.md | "Outbound Automation" |
| `{{NICHE_L3}}` | niche.md | "Signal-based CRM for UAE real estate teams" |

### Brand Placeholders: {{BRAND_*}}
Replaced with values from brandvoice.md (for visual assets only).

| Placeholder | Brain File | Example |
|-------------|-----------|---------|
| `{{BRAND_PRIMARY}}` | brandvoice.md | "#1A2B4F" |
| `{{BRAND_SECONDARY}}` | brandvoice.md | "#FF6B35" |
| `{{BRAND_ACCENT}}` | brandvoice.md | "#00D4FF" |
| `{{BRAND_BG}}` | brandvoice.md | "#0F1724" |
| `{{BRAND_TEXT}}` | brandvoice.md | "#FFFFFF" |
| `{{BRAND_FONT_HEAD}}` | brandvoice.md | "Inter" |
| `{{BRAND_FONT_BODY}}` | brandvoice.md | "Inter" |

---

## Execution Flow

### Phase 1: Template Verification
Before any generation, verify all required templates exist in the student workspace.

```
Check: EO-Brain/2-GTM/Templates/preGTM/ (8 files required)
Check: EO-Brain/2-GTM/Templates/GTM/ (13 files required)
Check: EO-Brain/1-ProjectBrain/Project/ (10 brain files required)
```

**Fallback rules:**
- **Template missing entirely:** Skip that asset. Warn student: "Template [name] not found. Skipping [asset]. You can add it later and re-run."
- **Template empty or < 5 lines:** Treat as missing. Same skip + warn behavior.
- **Template malformed (no {{PLACEHOLDER}} tags):** Warn: "Template [name] exists but has no placeholder tags. Using it as-is without personalization. Review the output manually."
- **Brain file missing:** Use fallback value "[NEEDS INPUT]" for that placeholder. Flag in delivery summary: "X placeholders unfilled because [brain-file] was missing."
- **Never block the entire run because one template is broken.** Generate everything that CAN be generated, flag what couldn't.

### Phase 2: Motion Selection (Do This FIRST, Before Reading Other Files)

**CRITICAL EXECUTION ORDER:** Do NOT read all 10 brain files upfront. That causes stalling. Instead:

**Step 1: Read ONLY gtm.md**
Read `gtm.md` from `EO-Brain/1-ProjectBrain/Project/`. Extract the motion ranking table with scores and tiers.

**Step 2: Present top 3 motions IMMEDIATELY after reading gtm.md**

Do NOT auto-select. Display this and STOP to wait for student input:

```
YOUR TOP 3 GTM MOTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⭐ 1. [Motion Name] — Score: 9.0 (Fit: 8.6 | Readiness: 9.5 | MENA: 9)  ← Recommended
   Why: [1-sentence reason from gtm.md context]

   2. [Motion Name] — Score: 8.8 (Fit: 8.6 | Readiness: 9.8 | MENA: 8)
   Why: [1-sentence reason]

   3. [Motion Name] — Score: 8.4 (Fit: 8.6 | Readiness: 8.4 | MENA: 8)
   Why: [1-sentence reason]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which motion do you want your 30-day battle plan for?
Pick 1, 2, or 3 (or say "show all 13" for the full list).
```

**Rules:**
- Mark the highest-scoring motion with ⭐ and "← Recommended"
- Include a 1-sentence "Why" for each top 3 (from gtm.md scores)
- If student says "show all 13", display full ranking with tiers (PRIMARY/SECONDARY/CONDITIONAL/SKIP)
- **Wait for student response.** Do not proceed until student picks.
- If student picks outside top 3, acknowledge and proceed (never block).

### Phase 3: Brain Load (Read Remaining Files AFTER Motion Is Selected)

**Only after the student picks their motion**, read the remaining brain files needed for asset generation:

1. Read `_language-pref.md` → determine language (English or Arabic)
2. Read `brandvoice.md` → extract colors, fonts, tone rules
3. Read `positioning.md` → extract wedge, mechanism, statement
4. Read `icp.md` → extract role, industry, pains, outcome
5. Read `companyprofile.md` → extract venture name, one-liner, pricing
6. Read `founderprofile.md` → extract founder name, archetype
7. Read `niche.md` → extract 3-level niche
8. Read `market-analysis.md` → extract market size, growth signals
9. Read `strategy.md` → extract strategy context

Build the placeholder dictionary from these files. Then proceed immediately to Phase 4 (asset generation). Do NOT pause between reading files and generating assets.

### Phase 4: preGTM Asset Generation
Generate 4 universal assets (every student gets these):

#### 4a: Outreach Messages (DOCX)
Read and fill these templates in sequence:
1. `preGTM/warm-whatsapp-msg.md` → fill placeholders, apply tone, generate DOCX section
2. `preGTM/cold-whatsapp-msg.md` → fill placeholders, generate DOCX section
3. `preGTM/warm-linkedin-msg.md` → fill placeholders, generate DOCX section
4. `preGTM/cold-linkedin-msg.md` → fill placeholders, generate DOCX section
5. `preGTM/advisory-close-script.md` → fill placeholders, generate DOCX section

Output file: `output/preGTM/outreach-messages.docx`

**Quality gate:** All 5 message types present, all placeholders filled, one CTA per message, brand tone consistent.

#### 4b: Landing Page (HTML)
Read `preGTM/landing-page.html`:
1. Fill all content placeholders (venture name, positioning, ICP details, pricing, market proof points)
2. Apply brand colors: inject CSS variables at `<style>` top
3. If Arabic language preference: wrap content in `<div dir="rtl">`, apply Arabic font stack (IBM Plex Arabic / Noto Sans Arabic)
4. Verify responsive design (mobile-first, breakpoints at 640px, 1024px)
5. Generate deployable HTML

Output file: `output/preGTM/landing-page.html`

**Quality gate:** All placeholders filled, brand colors applied, responsive, RTL-compatible if Arabic, meta tags present, CTAs point to calendar link.

#### 4c: One-Pager (PDF via Markdown)
Read `preGTM/one-pager.md`:
1. Fill all placeholders
2. Generate markdown → convert to PDF (via MD-to-PDF or similar tool)
3. Apply brand colors to headings
4. Ensure single-page layout (fits on one letter-size page)

Output file: `output/preGTM/one-pager.pdf`

**Quality gate:** Single page, all key proof points visible, one CTA, brand colors applied.

#### 4d: Pitch Deck (PPTX via Markdown)
Read `preGTM/pitch-deck.md`:
1. Parse slide outline from markdown
2. Fill placeholders in each slide
3. Generate PPTX with:
   - Title slide: venture name, one-liner, founder name
   - Problem slide: ICP pain points
   - Solution slide: unique mechanism, positioning
   - Proof slide: market size, growth signals
   - Pricing slide: tiers
   - CTA slide: calendar link
4. Apply brand colors to slide backgrounds, headings, accent elements
5. Ensure 7-10 slides

Output file: `output/preGTM/pitch-deck.pptx`

**Quality gate:** 7-10 slides, brand colors applied, readable fonts (14pt minimum body), one CTA on final slide.

### Phase 5: GTM Playbook Generation
Read selected motion template from `GTM/{number}-{motion-name}.md`:

1. Extract motion overview (what it is, who it's for, stage fit)
2. Personalize "why this motion for you" section using scores from gtm.md
3. Add MENA reality check section (trust-first mechanics, channel preferences, market context)
4. Generate 30-day execution calendar (week-by-week action plan)
5. Specify key assets to build for this motion
6. Create metrics dashboard (5 core metrics, pause/pivot signals)
7. Include common mistakes for this motion
8. Show integration points to other high-scoring motions
9. Fill all content placeholders from brain files
10. Apply brand tone from brandvoice.md

Output file: `output/GTM/{motion-name}-playbook.docx`

**Quality gate:** All sections present, motion-specific focus, MENA context included, 30-day roadmap visible, metrics defined.

### Phase 6: Quality Gates
Before handoff, run these verifications on all generated files:

#### Brand Voice Check
For all text (messages, playbook, landing page):
- Scan against `brandvoice.md` words-to-avoid list
- Verify tone matches brand voice (direct, trust-first, proof-first)
- No corporate buzzwords: "leverage," "ecosystem," "synergy," "holistic approach"
- No soft language: "hopefully," "might," "potentially"

Action if failed: Flag sections, suggest rewrites

#### CTA Check
For all customer-facing assets:
- Exactly one CTA per message/section
- CTAs are low-friction: "15-min call," not "strategic consultation"
- No multiple CTAs in same piece
- Calendar links or clear next step

Action if failed: Consolidate CTAs

#### MENA Check
For all assets:
- WhatsApp included in outreach toolkit (not just email/LinkedIn)
- Trust-first messaging (proof before pitch)
- Arabic variants present in templates
- Respect for relationship-based selling ethos
- No assumptions about Western B2B norms

Action if failed: Add trust layer, add WhatsApp option

#### First-Line Pattern Interrupt
For all outreach messages:
- First line is not: "I hope this finds you well", "I came across your profile", "I wanted to reach out"
- First line has specific hook: personalization, insight, or mutual connection

Action if failed: Rewrite opener

#### File Completeness
Check output directory:
```
output/preGTM/
  ✓ outreach-messages.docx
  ✓ landing-page.html
  ✓ one-pager.pdf
  ✓ pitch-deck.pptx

output/GTM/
  ✓ {motion-name}-playbook.docx
```

Action if failed: Generate missing files

#### Positioning Consistency
Verify same positioning statement appears consistently across all assets:
- Landing page
- One-pager
- Pitch deck
- Advisory close script
- All outreach messages

Action if failed: Align all to positioning.md

#### Brand Visual Consistency
For HTML, PPTX, PDF:
- Primary color appears on all key elements
- Secondary color appears in accents
- Font stack correct (brand fonts specified)
- RTL respected if Arabic

Action if failed: Re-apply brand variables

### Phase 7: Handoff and Deployment
Generate summary report:

```
✅ YOUR SALES TOOLKIT IS READY

You now have:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**preGTM Assets** (deploy immediately)
📄 outreach-messages.docx — 5 sequences: warm WhatsApp, cold WhatsApp, warm LinkedIn, cold LinkedIn, advisory close
🌐 landing-page.html — Branded, responsive, ready to deploy on any domain
📋 one-pager.pdf — Company overview, proof points, one-pager for investors/partners
🎯 pitch-deck.pptx — 8-slide pitch deck, all slides branded

**Your 30-Day GTM Playbook**
📅 {Motion Name} Playbook (DOCX) — Week-by-week execution plan, asset specs, metrics, common pitfalls

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next Steps:**
1. Review all files (they're in output/preGTM/ and output/GTM/)
2. Deploy landing page to your domain (use deployment-guide.md)
3. Start Week 1 of your playbook tomorrow morning
4. Track the 5 core metrics in your playbook
5. Adjust based on signals by end of Week 2

Questions? See deployment-guide.md for channel-specific setup.
```

---

## Quality Self-Score Protocol

After generation completes, rate your output across 10 dimensions. **Target score: 8.5+**

| Dimension | Rating (1-10) | Passing Criteria | Fail Action |
|-----------|---------------|-----------------|-------------|
| **Brand Consistency** | _/10 | Colors, fonts, tone match across all assets | Reapply brand variables |
| **Content Accuracy** | _/10 | All placeholders filled, no typos, positioning consistent | Verify placeholders, proofread |
| **CTA Clarity** | _/10 | One clear, low-friction CTA per piece | Consolidate/rewrite CTAs |
| **MENA Fit** | _/10 | WhatsApp included, trust-first, Arabic-ready | Add Arabic variants, trust language |
| **Outreach Quality** | _/10 | Pattern interrupt in first line, personalization hooks included | Rewrite openers |
| **Message Length** | _/10 | WhatsApp <50 words, LinkedIn <100, Email <150 | Cut to spec |
| **Asset Completeness** | _/10 | All 4 preGTM + 1 GTM playbook present | Generate missing |
| **Playbook Specificity** | _/10 | Motion-specific, 30-day calendar clear, metrics defined | Add motion context |
| **Landing Page Tech** | _/10 | Responsive, RTL if Arabic, fast load, meta tags present | Fix technical issues |
| **Positioning Unity** | _/10 | Same statement across landing page, one-pager, pitch, advisory close | Align to positioning.md |

**Average your scores. If below 8.5, flag which dimensions need rework before delivery.**

---

## Key Design Decisions

### 1. Template-Driven Architecture
Templates live in student workspace, not in skill code. This means:
- Templates are editable by students without code changes
- Templates persist and can be re-used
- Brand updates don't require skill rewrites

### 2. Two-Part Output Model
**preGTM** (universal):
- Every student needs these 4 assets before picking a motion
- Covers all foundational outreach channels (WhatsApp, LinkedIn)
- Includes advisory close script (sell first, build later)

**GTM Playbook** (motion-specific):
- Student picks 1 of 13 motions based on scores
- Focused, actionable 30-day plan
- Reduces overwhelm (not 15-40 files, just 1 focused playbook)

### 3. Brand Voice Enforcement
Brand colors and tone are applied consistently:
- HTML: CSS variables injected at runtime
- DOCX: Formatted text with tone rules enforced
- PPTX: Slide colors and typography consistent
- Markdown: Frontmatter specifies brand tone

### 4. MENA-First Design
- WhatsApp is primary outreach channel (not email)
- Trust-first messaging (proof before pitch)
- Arabic variants included in all templates
- RTL support for Arabic output
- Regional context in every playbook

### 5. RTL Support for Arabic
If language preference is Arabic:
- HTML: `<div dir="rtl">` wrapper, Arabic font stack (IBM Plex Arabic / Noto Sans Arabic)
- Markdown/DOCX: Direction specified in template
- No assumptions about script directionality

---

## Cross-Skill Dependencies

### Upstream (Required Before Running This Skill)
| Skill | Provides | Used For |
|-------|----------|----------|
| **S0: Scoring Suite** | gtm.md with motion rankings and scores | Motion recommendation, tier assignment |
| **S1: Brain Ingestion** | All brain files (positioning, ICP, company, founder, market) | Content population for all templates |

### Downstream (Uses This Skill's Output)
| Skill | Consumes | How |
|-------|----------|-----|
| **S3: Skill Extractor** | Asset patterns and templates | Extract reusable operator skills |
| **S5: MicroSaaS Dev** | Landing page, messaging | Product page reference, in-app copy |

### Note on Dependencies
- **Do NOT run this skill** unless S0 (scoring) and S1 (brain ingestion) are complete
- If gtm.md is missing, skill will fail at Phase 3
- If brain files are incomplete, placeholders will not fill correctly

---

## File Generation Details

### DOCX Files (Outreach Messages, Playbook)
Generated using Python `python-docx` library or equivalent:
- Template: Read markdown content, parse sections
- Fill placeholders using placeholder dictionary
- Apply formatting: bold for headers, bullet points for lists
- Insert page breaks between major sections
- Add table of contents for playbook
- Export as .docx

### HTML Landing Page
Generated with these specifications:
- **Doctype:** HTML5, responsive viewport
- **CSS:** Inline `<style>` block with brand variables
- **Fonts:** Brand fonts via Google Fonts or system stack
- **Responsive:** Mobile-first, breakpoints at 640px, 1024px
- **RTL:** `dir="rtl"` if Arabic language preference
- **Meta:** Title, description, OG tags
- **Deployment:** Save to `output/preGTM/landing-page.html`

### PDF Output (One-Pager)
Generated using:
- Markdown → HTML → PDF conversion (via markdown-pdf or puppeteer)
- OR: Direct markdown-to-PDF tool
- Single-page layout (8.5" x 11", no page breaks)
- Brand colors applied to headings
- Optimized for print and screen

### PPTX Pitch Deck
Generated using `python-pptx` or equivalent:
- Template: 8 slides minimum
- Slide 1: Title (venture name, one-liner, founder)
- Slide 2: Problem (ICP pains)
- Slide 3: Solution (unique mechanism)
- Slide 4: Market (size, growth)
- Slide 5: Traction/Proof
- Slide 6: Pricing
- Slide 7-8: Roadmap, CTA
- Brand colors: primary on headers, accent on buttons
- Fonts: brand font throughout
- Export as .pptx

---

## Error Handling

### If Template Files Are Missing
```
ERROR: Required templates not found.

Missing files:
  - EO-Brain/2-GTM/Templates/preGTM/warm-whatsapp-msg.md
  - EO-Brain/2-GTM/Templates/GTM/01-waitlist-heat-to-webinar.md

Action: Verify all 21 template files exist before running this skill.
```

### If Brain Files Are Incomplete
```
WARNING: Some brain files are missing or incomplete.

Missing: positioning.md
Incomplete: icp.md (missing ICP_PAIN_3)

Action: Complete all brain files (S1: Brain Ingestion) before running.
Some placeholders will remain unfilled.
```

### If Placeholder Extraction Fails
```
ERROR: Could not extract placeholder value.

Placeholder: {{FOUNDER_NAME}}
Brain file: founderprofile.md
Issue: Field not found or malformed YAML frontmatter

Action: Check founderprofile.md has proper structure and "founder_name" field.
```

### If Language Preference Is Not Set
```
WARNING: No language preference found in _language-pref.md

Action: Defaulting to English. To use Arabic, create _language-pref.md with:
language: "ar"
```

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Placeholders not filled | Brain file incomplete | Complete all fields in brain files |
| Landing page colors wrong | Brand variables not applied | Re-run phase 4b, verify CSS injection |
| DOCX has formatting issues | Markdown → DOCX conversion error | Check markdown syntax in templates |
| PPTX fonts look wrong | Font not installed on system | Verify brand fonts in brandvoice.md |
| Arabic text appears left-to-right | RTL not applied | Verify language pref = "ar" and dir="rtl" injected |
| Calendar links broken | CALENDAR_LINK placeholder not filled | Add calendar link to founderprofile.md |
| One-pager flows to 2 pages | Content too long | Reduce text or remove proof points |
| Quality gates fail | Brand tone inconsistent | Rewrite using brandvoice.md tone rules |

---

## Skill Reusability

### Run Again After Updates
You can re-run this skill anytime you update:
- **Brain files** (positioning, ICP, market context) → Regenerate all preGTM + playbook
- **Templates** (update template files) → Regenerate specific assets
- **Brand identity** (brandvoice.md) → Regenerate visual assets (HTML, PPTX, PDF)
- **GTM motion selection** → Regenerate just the playbook (skip preGTM)

### Non-Destructive Updates
Output files are saved to `output/` directories. Existing versions are not overwritten (save with timestamp if needed).

---

## Coaching Language

### For preGTM Assets
> "You now have your **complete sales toolkit** — everything you need to start conversations tomorrow. Landing page is live-ready, messages are pattern-interrupt tested, advisor close script follows the framework. Pick one channel (WhatsApp for MENA is best) and start with 10 conversations this week."

### For GTM Playbook
> "This is your **30-day battle plan**. It's not theoretical. Week 1 you do X, Week 2 you measure Y, Week 3 you adjust Z. If you follow it exactly and hit the metrics in the dashboard, you'll have signal about whether this motion works for you by end of month. No guessing."

---

## Deployment Reference

See `EO-Brain/2-GTM/Templates/deployment-guide.md` for:
- How to deploy landing page to your domain
- How to use WhatsApp template with GHL/WhatsApp Business API
- How to set up LinkedIn message sequencing
- How to track metrics from your playbook
- How to handle common objections per ICP

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-04-03 | Production release: template-driven, brand-aware, MENA-first, two-part output |
| 1.0 | 2025-12-15 | Initial version: markdown bundles per motion |

---

*Built for Entrepreneurs Oasis MENA. Signal-based trust engineering. Sell first, build later.*
