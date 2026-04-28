# UX Frontend Scorer — Anchor Rubrics

## 1. Visual Hierarchy (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No typography scale. Random font sizes. No spacing system. Colors used arbitrarily. Low contrast text. |
| 4-5 | Some hierarchy but inconsistent. 5+ different font sizes with no scale. Spacing varies randomly between components. |
| 6-7 | Clear heading hierarchy (h1-h4). Consistent spacing scale (4px/8px base). Primary/secondary color used purposefully. Contrast passes AA. |
| 8-9 | Modular type scale. 8px grid system. Color palette with semantic meaning (success, warning, error, info). White space used deliberately. |
| 10 | Design token-driven hierarchy. Every visual decision traceable to a token. Visual rhythm consistent across all pages. Contrast passes AAA. |

**Evidence to look for**: Check Tailwind config for custom font sizes, spacing scale, color palette. Look for typography components. Count distinct font-size values across the codebase.

## 2. Responsive Layout (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | Fixed-width layout. No breakpoints. Horizontal scroll on mobile. No viewport meta tag. |
| 4-5 | Viewport meta exists. Some responsive classes but layout breaks at certain widths. Desktop-first only. |
| 6-7 | Mobile-first breakpoints. Layout works at sm/md/lg. Touch targets 44px+. No horizontal overflow. |
| 8-9 | Fluid typography. Container queries where relevant. Navigation collapses to mobile pattern. All interactive elements thumb-friendly. |
| 10 | Responsive tested across real devices. Responsive images with srcset. Viewport-specific features (hover vs touch). No layout shifts on resize. |

**Evidence to look for**: Tailwind responsive prefixes (sm:, md:, lg:), min-width vs max-width media queries, touch target sizes, mobile navigation pattern (hamburger/drawer).

## 3. Component Architecture (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | Monolithic page components. 500+ line files mixing layout, logic, and style. No reusable components. |
| 4-5 | Some extraction but inconsistent. Components accept 10+ props with no grouping. Mixed concerns. |
| 6-7 | Presentational/container split. Props well-typed. Components under 200 lines. Composition over configuration. |
| 8-9 | Atomic design layers (atoms, molecules, organisms). Render props or compound components for complex UI. Storybook or equivalent. |
| 10 | Component API designed for consumers. Forwarded refs. Polymorphic components. Slot patterns. Component documentation. |

**Evidence to look for**: Average component file size. Check for component directories (ui/, shared/, common/). Look for compound component patterns, forwardRef usage, generic/polymorphic components.

## 4. Interaction Design (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No hover states. No transitions. Buttons don't indicate clickability. No loading feedback during actions. |
| 4-5 | Basic hover effects. Some transitions but jarring (instant state changes). Loading spinners on some actions. |
| 6-7 | Consistent hover/active states. Smooth transitions (150-300ms). Loading indicators on all async actions. Disabled states clear. |
| 8-9 | Micro-interactions enhance UX (button press feedback, success animations). Optimistic UI updates. Skeleton screens. Drag handles where relevant. |
| 10 | Motion design system (spring physics, stagger animations). Gesture support for touch. Reduced-motion respected. Every interaction provides immediate feedback. |

**Evidence to look for**: Search for `transition`, `animate`, `motion`, `framer-motion`. Check for hover/focus/active pseudo-class usage. Look for optimistic update patterns in mutations.

## 5. Accessibility (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No alt text. No ARIA labels. Keyboard unusable. Color-only indicators. Non-semantic HTML (div soup). |
| 4-5 | Some alt text. A few ARIA labels. Keyboard works on standard elements but not custom components. |
| 6-7 | Semantic HTML used. Alt text on images. ARIA labels on interactive elements. Focus styles visible. Skip-to-content link. |
| 8-9 | Full keyboard navigation. ARIA live regions for dynamic content. Focus management on route changes. Color never sole indicator. axe-core in CI. |
| 10 | WCAG 2.1 AA certified. Screen reader tested. Reduced motion support. High contrast mode. Accessibility statement published. |

**Evidence to look for**: Count `aria-label`, `aria-describedby`, `role=` attributes. Check for `alt` on images. Look for semantic tags (nav, main, aside, section, article). Check for `eslint-plugin-jsx-a11y`.

## 6. RTL / Bilingual Support (Weight: 15%) — HARD STOP if < 5 (MENA products)

| Score | Anchor |
|-------|--------|
| 1-3 | No RTL consideration. Hardcoded left/right everywhere. Arabic text displays but layout is broken. |
| 4-5 | `dir="rtl"` exists on some pages. Some logical properties but mixed with physical. Arabic font loaded but line-height wrong. |
| 6-7 | Global RTL toggle works. Logical properties (start/end) replace left/right. Arabic font with proper line-height. Number display correct in Arabic context. |
| 8-9 | Full RTL mirror on every component. Bidirectional text handling tested. Icon direction flipped where semantic. Locale-aware date/number formatting. |
| 10 | Bilingual UI tested end-to-end. Dynamic direction switching seamless. Cultural adaptation beyond translation (imagery, iconography, calendar). RTL visual regression tests. |

**Evidence to look for**: Count `dir="rtl"` or `[dir="rtl"]` selectors. Search for `margin-left`/`padding-right` vs `margin-inline-start`/`padding-inline-end`. Check for Arabic web fonts in font stack. Look for i18n library with RTL support.

## 7. Design System Consistency (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No design system. Every component styled ad hoc. 20+ colors with no naming. Random spacing values. |
| 4-5 | Some shared styles but not systematic. Component library started but abandoned. Tailwind used with arbitrary values (`w-[347px]`). |
| 6-7 | Tailwind config defines color palette, spacing, typography. Shared UI components used consistently. Naming conventions followed. |
| 8-9 | Design tokens defined. Component variants use consistent API (size, variant props). Tailwind extended thoughtfully. No arbitrary values in production code. |
| 10 | Living design system with documentation. Tokens synced between design tool and code. Component audit shows 95%+ reuse. Visual regression on design system components. |

**Evidence to look for**: Check `tailwind.config` for custom theme extension. Count arbitrary Tailwind values (`[` brackets). Look for a `ui/` or `design-system/` directory. Check for consistent component prop patterns (variant, size).

## 8. Frontend Performance (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No code splitting. Everything in one bundle. Raw img tags. No lazy loading. Re-renders on every state change. |
| 4-5 | Basic code splitting (route-level). Some image optimization. React.memo on a few components but no strategy. |
| 6-7 | Route-based code splitting. next/image or equivalent for images. useMemo/useCallback where measurably impactful. Bundle under 500KB initial. |
| 8-9 | Bundle analysis done. Tree-shaking verified. Dynamic imports for heavy libraries. Server Components for static content (Next.js). |
| 10 | Performance budget in CI. Lighthouse score >90. Bundle size tracked over time. Render performance profiled. No unnecessary client-side JS. |

**Evidence to look for**: Check for `dynamic()` or `lazy()` imports. Look at `next.config.js` for bundle analysis plugins. Search for `React.memo`, `useMemo`, `useCallback` usage. Check if `next/image` is used consistently vs raw `<img>` tags.
