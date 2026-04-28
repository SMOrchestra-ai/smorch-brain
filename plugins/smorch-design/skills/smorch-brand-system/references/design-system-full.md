# SMO Design System

This is the single source of truth for SMOrchestra visual identity across all assets — landing pages, decks, and one-pagers.

## CSS Variables (Landing Pages)

```css
:root {
  --bg: #000000;
  --bg-alt: #0A0A0A;
  --bg-card: rgba(255, 255, 255, 0.04);
  --accent: #FF6600;
  --accent-hover: #CC5200;
  --accent-light: #FFF3E6;
  --accent-glow: rgba(255, 102, 0, 0.15);
  --text: #FFFFFF;
  --text-muted: #A3A3A3;
  --text-dark: #171717;
  --text-dark-muted: #525252;
  --border: rgba(255, 255, 255, 0.08);
  --font: 'Inter', system-ui, -apple-system, sans-serif;
}
```

## Color Usage Rules

### Dark Sections (Primary — hero, CTA, alternating content)
- Background: `#000000` or `#0A0A0A`
- Text: `#FFFFFF` for headings, `#A3A3A3` for body/muted
- Cards: `rgba(255,255,255,0.04)` background with `rgba(255,255,255,0.08)` border
- Accent elements: `#FF6600` for buttons, highlights, borders, icons

### White Sections (Alternating content sections)
- Background: `#FFFFFF`
- Text: `#171717` for headings, `#525252` for body/muted
- Cards: `#F9F9F9` or `#F5F5F5` background with `#E5E5E5` border
- Accent elements: `#FF6600` stays the same orange
- Badges/pills: `#FFF3E6` background with `#FF6600` text

### Accent Color (#FF6600)
The orange is used for:
- Primary CTA buttons (solid fill, white text)
- Card top borders or left borders (4px solid)
- Highlighted text spans (`.sm-accent` class)
- Stat numbers and key metrics
- Icon circles and decorative elements
- Hover states darken to `#CC5200`

### Semantic Colors
- Success/Positive: `#22C55E` (green) — used in qualifier "good fit" sections
- Danger/Negative: `#EF4444` (red) — used in problem cards, "not for you" sections
- Warning: `#F59E0B` (amber) — occasional emphasis

## Typography

### Font Family
```
'Inter', system-ui, -apple-system, sans-serif
```
Load via Google Fonts: `https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap`

### Scale (Landing Pages)
| Element | Size | Weight | Line Height |
|---------|------|--------|-------------|
| Hero H1 | 56px (desktop), 36px (mobile) | 800 | 1.1 |
| Section H2 | 40px (desktop), 28px (mobile) | 700 | 1.2 |
| Card H3 | 20-24px | 600 | 1.3 |
| Body text | 16-18px | 400 | 1.6-1.7 |
| Muted/caption | 14px | 400 | 1.5 |
| Pill badges | 13-14px | 600 | 1 |
| Stat numbers | 48-56px | 800 | 1 |
| Stat labels | 14px | 500 | 1.3 |
| Nav links | 15px | 500 | 1 |
| Button text | 16px | 600 | 1 |

### Scale (Slide Decks — PPTX)
| Element | Size | Weight |
|---------|------|--------|
| Slide title | 36-44pt | Bold |
| Section header | 20-24pt | Bold |
| Body text | 14-16pt | Regular |
| Stat numbers | 60-72pt | Bold |
| Stat labels | 12-14pt | Regular |
| Footer/caption | 10-12pt | Regular |

### Scale (One-Pager)
| Element | Size | Weight |
|---------|------|--------|
| Offer name | 28-32pt | 800 |
| Section headers | 16-18pt | 700 |
| Body text | 10-11pt | 400 |
| Stat numbers | 36-40pt | 800 |
| Fine print | 8-9pt | 400 |

## Spacing & Layout

### Landing Pages
- Max content width: `1200px`, centered
- Section padding: `100px 0` (desktop), `60px 0` (mobile)
- Card padding: `32px`
- Card border-radius: `12px`
- Button border-radius: `8px`
- Pill border-radius: `50px`
- Grid gaps: `24px` (cards), `32px` (sections)
- Margins from edge: minimum `20px` on mobile

### Cards
Two card styles used throughout:

**Dark Card (on dark bg):**
```css
background: rgba(255, 255, 255, 0.04);
border: 1px solid rgba(255, 255, 255, 0.08);
border-radius: 12px;
padding: 32px;
```

**Light Card (on white bg):**
```css
background: #F9F9F9;
border: 1px solid #E5E5E5;
border-radius: 12px;
padding: 32px;
```

**Accent Border Variants:**
- Top border: `border-top: 4px solid #FF6600` (used on offer cards, feature cards)
- Left border: `border-left: 4px solid #FF6600` (used on signal cards, reason cards)
- Red left border: `border-left: 4px solid #EF4444` (used on problem cards)

## Buttons

### Primary CTA
```css
background: #FF6600;
color: #FFFFFF;
padding: 16px 32px;
border-radius: 8px;
font-weight: 600;
font-size: 16px;
border: none;
cursor: pointer;
transition: all 0.3s ease;
```
Hover: `background: #CC5200; transform: translateY(-2px);`

### Ghost/Secondary CTA
```css
background: transparent;
color: #FFFFFF; /* or #171717 on light bg */
padding: 16px 32px;
border-radius: 8px;
font-weight: 600;
font-size: 16px;
border: 2px solid rgba(255, 255, 255, 0.2);
cursor: pointer;
transition: all 0.3s ease;
```
Hover: `border-color: #FF6600; color: #FF6600;`

## Animations

### Scroll-Triggered Reveal
Uses Intersection Observer to add `.sm-visible` class when elements enter viewport.

```css
.sm-animate {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.sm-animate.sm-visible {
  opacity: 1;
  transform: translateY(0);
}
```

### JS Pattern
```javascript
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('sm-visible');
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.sm-animate').forEach(el => observer.observe(el));
```

### Staggered Delays
Apply `transition-delay` to sequential elements for cascade effect:
```css
.sm-animate:nth-child(1) { transition-delay: 0s; }
.sm-animate:nth-child(2) { transition-delay: 0.1s; }
.sm-animate:nth-child(3) { transition-delay: 0.2s; }
.sm-animate:nth-child(4) { transition-delay: 0.3s; }
```

## Navigation

Fixed top nav with:
- Logo (left) — text "SMOrchestra" or "SalesMfast" with `.sm-accent` span for the "M" or brand marker
- Nav links (center) — 3-5 section anchors
- CTA button (right) — primary orange button
- Mobile: hamburger menu icon that toggles a vertical dropdown

```css
.sm-nav {
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
  background: rgba(0, 0, 0, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  padding: 16px 0;
}
```

## Footer

Dark background, three-column layout:
- Column 1: Brand name + tagline
- Column 2: Quick links
- Column 3: Contact info / social
- Bottom bar: copyright + legal links

## PPTX Color Mapping

When creating slide decks, map the web colors to PPTX:

| Web Token | PPTX Hex | Usage |
|-----------|----------|-------|
| `--bg` | `000000` | Dark slide backgrounds |
| `--accent` | `FF6600` | Accent bars, highlights, stat numbers |
| `--text` | `FFFFFF` | Text on dark slides |
| `--text-dark` | `171717` | Text on white slides |
| `--text-muted` | `A3A3A3` | Subtitles, captions on dark |
| `--text-dark-muted` | `525252` | Subtitles, captions on light |
| White | `FFFFFF` | Light slide backgrounds |
| Card BG | `F5F5F5` | Card/box fills on white slides |
| Red | `EF4444` | Problem indicators |
| Green | `22C55E` | Success/positive indicators |

## Brand Voice in Copy

All assets should reflect SMOrchestra's contrarian positioning:
- Lead with the problem, not the solution
- Be specific — numbers, timelines, mechanisms. Not "improve your pipeline"
- Pattern-interrupt openings — no "in today's digital landscape"
- CTA is always low-friction: "Book a Signal Audit", "See The Engine in Action", "Get Your Pipeline Score"
- Avoid: "leverage", "synergy", "holistic", "ecosystem", "digital transformation"
- Prefer: "signal", "engine", "detect", "sequence", "trust engineering", "revenue system"
