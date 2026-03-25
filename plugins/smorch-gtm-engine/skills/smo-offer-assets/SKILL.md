---
name: smo-offer-assets
description: "SMOrchestra Offer Asset Factory — produces complete offer asset bundles (landing page + slide deck + one-pager) in SMO's signature dark/orange design system. Trigger whenever the user says 'offer assets', 'provide the assets', 'build the offer package', 'create the landing page and deck', 'SMO style assets', or any request for client-facing sales collateral bundles including landing pages, pitch decks, and one-pagers. Also triggers on individual asset requests like 'build me an SMO landing page', 'create an offer deck', 'make a one-pager for this offer'. For landing pages, always asks 'VSL page or Big headline?' before producing. This skill should fire for ANY request involving SMOrchestra/SalesMfast offer presentation materials — even partial requests for just one of the three asset types."
---

# SMO Offer Asset Factory

This skill produces **three sales assets** for any SMOrchestra/SalesMfast offer:

1. **Landing Page** (HTML) — either VSL-style or Big Headline style
2. **Slide Deck** (PPTX) — 12-15 slide pitch deck
3. **One-Pager** (PDF via HTML) — single-page offer summary

All three follow the SMO design system: dark theme, `#FF6600` orange accent, Inter font, professional B2B SaaS aesthetic.

## Workflow

### Step 1: Gather Offer Details

Before producing anything, collect these inputs from the user (ask if not provided):

| Input | Description | Example |
|-------|-------------|---------|
| **Offer Name** | The product/service name | "The Engine", "The Expansion" |
| **Tagline** | One-line positioning statement | "Signal-Based Pipeline for MENA" |
| **Target ICP** | Who this is for | "B2B SaaS companies entering MENA" |
| **Core Problem** | 3-4 pain points the offer solves | Cold outbound fails, SDR teams burn cash, no MENA playbook |
| **How It Works** | 3-4 step process | Detect signals → Score → Sequence → Convert |
| **Key Metrics** | 3-4 proof points | "3-5x response rate, 20% meeting rate" |
| **What's Included** | Feature/deliverable list | Channel setup, signal scoring, weekly optimization |
| **Pricing** | Pricing structure | "$2,500 setup + $3,500/mo" |
| **Qualifier** | Who should / shouldn't buy | "For: B2B SaaS $1M+ ARR. Not for: Local retail" |
| **CTA** | Call to action | "Book a Signal Audit" |

### Step 2: Landing Page — Ask the Format Question

**Always ask:** "VSL page or Big headline?"

- **VSL** → Centered hero with video placeholder, 3 offer cards below the fold. Read `references/vsl-page.md`
- **Big Headline** → Left-aligned hero with pill badge, ghost CTA, qualifier divider. Read `references/big-headline-page.md`

Both variants share the SMO design system defined in `references/design-system.md`.

### Step 3: Produce the Landing Page

Read the appropriate reference file for the chosen format. Build a complete, production-ready HTML file:

- Single-file HTML (inline CSS + JS)
- All CSS variables from the design system
- Intersection observer animations (`.sm-animate` → `.sm-visible`)
- Responsive (mobile hamburger menu, stacked grids)
- Sections flow according to the reference file's section map
- Replace all placeholder content with the actual offer details

The landing page is the hero asset — spend the most attention here. Every section should feel intentional and specific to this offer, not generic template filler.

### Step 4: Produce the Slide Deck

Read `references/slide-deck.md` for the exact slide structure.

Use the **pptx skill** (read the pptx SKILL.md and use pptxgenjs) to create the deck. Key principles:

- Dark background slides for title, CTA, and vision slides
- White/light background for content-heavy slides
- `#FF6600` accent color throughout
- Large stat callouts (60-72pt numbers)
- Comparison tables and numbered process flows
- 12-15 slides following the structure template
- Speaker notes on every slide

### Step 5: Produce the One-Pager

Read `references/one-pager.md` for layout structure.

Create a single-page HTML file styled for print/PDF export. The one-pager is a condensed version of the offer:

- Header with logo placeholder + offer name
- Hero stats bar (3-4 key metrics)
- Problem + solution in two columns
- What's included (icon grid or bullet list)
- Pricing block
- CTA with contact info
- Footer with brand tagline

Use the **pdf skill** to convert the HTML to PDF, or produce a clean HTML that prints perfectly.

### Step 6: QA All Three Assets

This is not optional. Check each asset:

**Landing Page:**
- Open in browser or convert to screenshot
- Verify all sections render correctly
- Check responsive behavior
- Confirm all offer details are present (no placeholder text)

**Slide Deck:**
- Run `python -m markitdown output.pptx` to verify content
- Convert to images and visually inspect
- Check for overlapping elements, wrong colors, missing content

**One-Pager:**
- Verify it fits on one page
- Check print margins
- Confirm all key info is present

## SMO Design System (Quick Reference)

Full details in `references/design-system.md`. Quick tokens:

```
Background:     #000000 (dark), #FFFFFF (light sections)
Accent:         #FF6600 (primary), #CC5200 (hover)
Accent Light:   #FFF3E6 (badges on white bg)
Text:           #FFFFFF (on dark), #171717 (on light)
Text Muted:     #A3A3A3 (on dark), #525252 (on light)
Border:         rgba(255,255,255,0.08) (on dark)
Card BG:        rgba(255,255,255,0.04) (on dark)
Font:           'Inter', system-ui, sans-serif
Border Radius:  12px (cards), 8px (buttons), 50px (pills)
```

## Reference Files

| File | When to Read |
|------|-------------|
| `references/design-system.md` | Always — before producing any asset |
| `references/vsl-page.md` | When user chooses "VSL" landing page |
| `references/big-headline-page.md` | When user chooses "Big headline" landing page |
| `references/slide-deck.md` | When producing the pitch deck |
| `references/one-pager.md` | When producing the one-pager |

## Asset Templates

The `assets/` folder contains the two original HTML templates for direct reference:
- `assets/smorchestra-home-ghl.html` — VSL page reference
- `assets/the-engine-ghl.html` — Big headline page reference

When building a landing page, read the appropriate template file to study the exact HTML structure, CSS patterns, and JS behavior. Use these as the source of truth for element ordering, class naming, and animation patterns.

## Output

Save all three files to the workspace folder:
- `[offer-name]-landing-page.html`
- `[offer-name]-deck.pptx`
- `[offer-name]-one-pager.html` (or `.pdf` if converted)

Present all three to the user with computer:// links.
