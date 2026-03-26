---
name: ux-frontend-scorer
description: >-
  Scores frontend UX across 8 dimensions: Visual Hierarchy, Responsive Layout, Component Architecture, Interaction Design, Accessibility, RTL/Bilingual Support, Design System Consistency, Frontend Performance. Triggers on "score UX", "rate the frontend", "UI quality check", "UX scorecard", "is the frontend solid", "design quality review", "frontend audit".
---

# UX / Frontend Scorer

Score frontend quality, design consistency, and user experience implementation. Hat 5 of the 5-Hat Quality Scorecard System.

The core question: **Would a designer be proud to claim this as their work?**

## Scoring Process

### Step 1: Discover Frontend Surface

Map the frontend landscape:

1. **Component inventory**: Glob `**/*.tsx`, `**/*.jsx` to count and categorize components
2. **Styling approach**: Check for Tailwind config, CSS modules, styled-components, global CSS files
3. **Design tokens**: Look for theme config, color constants, spacing scales, typography definitions
4. **Layout system**: Check for layout components, grid patterns, responsive wrappers
5. **Asset handling**: Check `public/` or `assets/` for images, fonts, icons. Check for SVG component patterns
6. **Accessibility config**: Look for `eslint-plugin-jsx-a11y`, axe-core, pa11y configs
7. **Internationalization**: Check for `next-intl`, `react-i18next`, `dir="rtl"`, locale files

### Step 2: Score Each Dimension

Read `references/ux-frontend-anchors.md` for detailed rubrics. For calibration reference, see `../composite-scorer/references/calibration-examples.md` (UX Frontend section).

| Dimension | Weight | How to Evaluate |
|-----------|--------|----------------|
| Visual Hierarchy | 15% | Typography scale, spacing consistency, color usage, contrast ratios. |
| Responsive Layout | 10% | Breakpoint strategy, mobile-first patterns, touch targets, viewport handling. |
| Component Architecture | 15% | Composition patterns, prop interfaces, reusability, atomic design adherence. |
| Interaction Design | 10% | Hover/focus states, transitions, loading feedback, micro-interactions. |
| Accessibility (a11y) | 15% | ARIA usage, keyboard navigation, color contrast, screen reader support. |
| RTL / Bilingual Support | 15% | dir attribute, logical properties, Arabic typography, mixed-direction text. |
| Design System Consistency | 10% | Token usage, component variants, spacing scale adherence, naming conventions. |
| Frontend Performance | 10% | Bundle size, code splitting, image optimization, render efficiency. |

### Automated Frontend Checks

Run these programmatically:

```bash
# Component count
echo "Components:" && find . -name "*.tsx" -path "*/components/*" | wc -l

# Tailwind config presence
ls tailwind.config* 2>/dev/null && echo "Tailwind configured" || echo "No Tailwind config"

# Accessibility attributes
echo "aria-label usage:" && grep -r "aria-label\|aria-describedby\|role=" --include="*.tsx" -l | wc -l

# RTL support
echo "RTL directives:" && grep -r "dir=.rtl\|direction.*rtl\|logical" --include="*.tsx" --include="*.css" -l | wc -l

# Image optimization
echo "Next Image usage:" && grep -r "next/image\|Image " --include="*.tsx" -l | wc -l
echo "Raw img tags:" && grep -r "<img " --include="*.tsx" -l | wc -l

# Color consistency (hardcoded colors vs tokens)
echo "Hardcoded colors:" && grep -r "#[0-9a-fA-F]\{3,6\}" --include="*.tsx" | grep -v "tailwind\|config\|theme" | wc -l

# Focus visible patterns
echo "Focus styles:" && grep -r "focus-visible\|focus:\|:focus" --include="*.tsx" --include="*.css" -l | wc -l
```

### MENA-Specific UX Checks

For Arabic/MENA-targeted products, these carry extra weight:

- **RTL layout completeness**: Every page renders correctly with `dir="rtl"`. Check for hardcoded `left`/`right` vs logical `start`/`end` properties.
- **Arabic typography**: Font family supports Arabic glyphs (Inter does not, Cairo/Tajawal/IBM Plex Arabic do). Line-height adjusted for Arabic (typically needs 1.6-1.8x vs 1.5x for Latin).
- **Bidirectional text**: Mixed Arabic/English content handles direction correctly. Numbers in Arabic text display LTR.
- **Cultural design**: Color choices appropriate (green positive associations, no culturally sensitive imagery). Calendar shows Hijri option if date-relevant.
- **WhatsApp-native patterns**: If WhatsApp is a touchpoint, UI patterns match WhatsApp conventions users expect (chat bubbles, status indicators).

### Step 3: Output Format

```
## UX Frontend Scorecard — [Project Name]
Phase: [phase] | Components: [count] | Styling: [approach] | RTL: [yes/no]

### Category Score: X.X / 10 ([grade])

| Dimension | Score | Evidence |
|-----------|-------|----------|
| Visual Hierarchy | X/10 | [typography scale, spacing analysis] |
| ... | ... | ... |

### Frontend Metrics
- Component count: X
- Accessibility attributes: X files
- RTL directives: X files
- Hardcoded colors: X instances (vs tokens)
- Image optimization: X/Y using next/image
- Focus styles: X files

### Critical Gaps
- [Dimension]: Score X → Target 8. Action: [specific frontend task]

### Hard Stops
- RTL/Bilingual < 5 (if MENA-targeted): [PASS/FAIL/N-A]
- Accessibility < 5: [PASS/FAIL]
```

### Skip Conditions

Do NOT run this scorer when:
- **Pure API/backend project**: No frontend files (`.tsx`, `.jsx`, `.vue`, `.svelte`). Return "N/A: no frontend surface."
- **CLI tool or data pipeline**: No visual interface to evaluate.
- **Mobile-only app (React Native/Flutter)**: This scorer is web-focused. Responsive Layout and some Accessibility dimensions need adaptation for native mobile. Flag to user and score with caveats.
