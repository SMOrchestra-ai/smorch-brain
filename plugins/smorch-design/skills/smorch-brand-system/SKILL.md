<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: smorch-brand-system
description: >-
  SMOrchestra/SalesMfast brand design system: dark theme, #FF6600 orange accent, Inter font, professional
  B2B SaaS aesthetic. Apply to any artifact: landing pages, dashboards, slide decks, one-pagers, emails,
  React components. Triggers on: SMOrch style, SMO design, brand style, dark/orange theme, SalesMfast
  design, apply brand, branded landing page, styled dashboard, SMO look and feel, brand system.
---

# SMOrchestra Brand Design System

Apply SMOrchestra's visual identity to any artifact. This skill provides the complete design system: colors, typography, spacing, components, animations, and brand voice rules.

## When to Use

Use this skill whenever building any visual artifact that should carry SMOrchestra or SalesMfast branding:
- Landing pages (HTML)
- Slide decks (PPTX)
- One-pagers (PDF/HTML)
- Dashboards and admin UIs
- React components and web apps
- Email templates
- Social media graphics

## Quick Reference

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#000000` | Primary dark sections |
| Background Alt | `#0A0A0A` | Alternating dark sections |
| Accent | `#FF6600` | CTAs, highlights, borders, stats |
| Accent Hover | `#CC5200` | Button hover states |
| Accent Light | `#FFF3E6` | Badges on white backgrounds |
| Text (dark bg) | `#FFFFFF` | Headings on dark |
| Text Muted (dark bg) | `#A3A3A3` | Body text on dark |
| Text (light bg) | `#171717` | Headings on white |
| Text Muted (light bg) | `#525252` | Body text on white |
| Card (dark bg) | `rgba(255,255,255,0.04)` | Card backgrounds |
| Border (dark bg) | `rgba(255,255,255,0.08)` | Card/section borders |
| Success | `#22C55E` | Positive indicators |
| Danger | `#EF4444` | Problem indicators |

### Typography

Font: `'Inter', system-ui, -apple-system, sans-serif`
Load: `https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap`

| Element | Web Size | PPTX Size | Weight |
|---------|----------|-----------|--------|
| Hero H1 | 56px (36px mobile) | 36-44pt | 800 |
| Section H2 | 40px (28px mobile) | 20-24pt | 700 |
| Card H3 | 20-24px | 16-18pt | 600 |
| Body | 16-18px | 14-16pt | 400 |
| Muted/Caption | 14px | 10-12pt | 400 |
| Pill Badges | 13-14px | - | 600, uppercase, 1px tracking |
| Stat Numbers | 48-56px | 60-72pt | 800 |
| Buttons | 16px | - | 600 |

### CSS Variables (copy-paste ready)

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

### Component Patterns

**Primary CTA**: `#FF6600` bg, white text, 16px 32px padding, 8px radius. Hover: `#CC5200`, translateY(-2px)
**Ghost CTA**: Transparent bg, white text, 2px border `rgba(255,255,255,0.2)`, 8px radius. Hover: border/text turn `#FF6600`
**Dark Card**: `rgba(255,255,255,0.04)` bg, `rgba(255,255,255,0.08)` border, 12px radius, 32px padding
**Light Card**: `#F9F9F9` bg, `#E5E5E5` border, 12px radius, 32px padding
**Accent Border**: `border-top: 4px solid #FF6600` (feature cards) or `border-left: 4px solid #FF6600` (signal cards)
**Pill Badge**: `#FF6600` bg (on dark) or `#FFF3E6` bg with `#FF6600` text (on light), 50px radius, uppercase, 13px

### Navigation

Fixed top, dark with blur: `rgba(0,0,0,0.95)` bg, `backdrop-filter: blur(20px)`, `z-index: 1000`. Logo left, links center, CTA right.

### Animations

Scroll-triggered reveal: elements start `opacity:0; translateY(30px)`, animate to visible on intersection. Stagger children with 0.1s incremental `transition-delay`.

### Brand Voice in Copy

- Lead with the problem, not the solution
- Specific numbers, timelines, mechanisms: not "improve your pipeline"
- Pattern-interrupt openings: no "in today's digital landscape"
- Low-friction CTAs: "Book a Signal Audit", "See The Engine", "Get Your Pipeline Score"
- Banned words: leverage, synergy, holistic, ecosystem, digital transformation
- Brand words: signal, engine, detect, sequence, trust engineering, revenue system

## Detailed Reference

For full CSS snippets, section-by-section layout guides, animation JS, and PPTX color mapping, read `references/design-system-full.md`.
