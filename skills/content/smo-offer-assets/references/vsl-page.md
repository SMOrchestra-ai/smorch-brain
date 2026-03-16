# VSL Landing Page Structure

This is the reference for VSL-style (Video Sales Letter) landing pages, modeled on `smorchestra-home-ghl.html`.

The VSL page is **centered and video-focused** — the hero pulls the visitor into a video that does the heavy selling, supported by structured offer cards and proof sections below.

## Section Map (Top to Bottom)

### 1. Fixed Navigation
- Dark bg with blur backdrop
- Logo left, links center, CTA button right
- Mobile hamburger menu

### 2. Hero Section (Dark BG — centered)
```
[Subtitle text — 1 line, muted]
[H1 — 2-3 lines, with .sm-accent span on key phrase]
[Subtext — 1-2 lines explaining the offer]
[Video Container — 16:9 aspect ratio with play button overlay]
[3-Card Grid below video — offer cards with top accent border]
```

**Key details:**
- Everything is **centered** (text-align: center on the hero)
- The video container has a dark background with a play button SVG overlay
- Clicking play replaces the placeholder with an iframe embed (YouTube/Vimeo/Wistia)
- The 3 cards below the video represent the 3 core offers or pillars
- Each card has: orange top border, icon, title, short description, optional "Learn More" link
- One card can use `.outline` variant (orange border all around instead of just top)

**Hero CSS pattern:**
```css
.sm-hero {
  padding: 140px 0 80px;
  text-align: center;
  position: relative;
}
.sm-hero h1 {
  font-size: 56px;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 24px;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}
.sm-video-container {
  max-width: 800px;
  margin: 48px auto;
  border-radius: 12px;
  overflow: hidden;
  aspect-ratio: 16/9;
  background: #0A0A0A;
  border: 1px solid rgba(255,255,255,0.08);
  cursor: pointer;
  position: relative;
}
```

### 3. Stats Bar (Dark BG)
```
[4 stats in a row: number + label]
```
- Large numbers (48-56px, bold, accent color)
- Small labels below (14px, muted)
- Grid: `grid-template-columns: repeat(4, 1fr)` on desktop, `repeat(2, 1fr)` on mobile
- Subtle top/bottom borders: `rgba(255,255,255,0.08)`

### 4. Problem Section (WHITE BG)
```
[Pill badge — "THE PROBLEM"]
[H2 — What's broken]
[Subtitle — 1-2 lines]
[3-4 Problem Cards — dark bg cards on white section, with RED left border]
```
- Cards have `#171717` background when on white section (inverted)
- Each card: red left border (`border-left: 4px solid #EF4444`), title, description
- Text on dark cards is white

### 5. Engine/Solution Diagram (WHITE BG)
```
[Pill badge — "THE ENGINE" or "HOW IT WORKS"]
[H2 — The solution name]
[Hub-and-Spoke SVG Diagram — center hub with radiating nodes]
```
- The diagram is an inline SVG showing the system architecture
- Center circle with the engine name
- 4-6 satellite nodes connected by lines
- Each node: icon + label
- Uses accent color for connections and highlights
- This section is optional — only include if the offer has a visual system to show

### 6. Offers Section (DARK BG)
```
[Pill badge — "OUR OFFERS" or "WHAT WE BUILD"]
[H2]
[2-Column Grid — each offer as a large card]
```
- Two offer cards side by side
- Each card: accent top border, offer name (H3), description, feature list (checkmarks), price, CTA button
- Feature lists use `✓` checkmarks in accent color
- Cards are equal height with flex

### 7. Why Section (WHITE BG)
```
[Pill badge — "WHY SMO" or "WHY THIS WORKS"]
[H2 — Why choose this]
[3-4 Reason Cards — light cards with orange LEFT border]
```
- Cards on white bg with `#F9F9F9` fill
- Orange left border (`border-left: 4px solid #FF6600`)
- Each card: title (bold), description paragraph

### 8. Trust Quote Section (DARK BG)
```
[Large quote — italicized, centered, with quotation marks]
[Attribution — name/title below]
```
- Uses the contrarian thesis quote or a client testimonial
- Large font (24-28px), italic
- Decorative quotation mark icon above (accent color)
- Max-width: 800px, centered

### 9. Results Section (WHITE BG)
```
[Pill badge — "RESULTS"]
[H2 — Proof that it works]
[4 Metric Cards — large stat + label]
[Case Study Card — full-width below metrics]
```
- Metric cards: big number (accent color, 48px bold), label below
- Case study: border card with client name, challenge, result, quote
- Optional: before/after comparison

### 10. Final CTA Section (DARK BG)
```
[H2 — Action-oriented headline]
[Subtitle — urgency/qualifier text]
[Primary CTA Button]
[Small muted text — "No commitment. 15-minute call."]
```

### 11. Footer (DARK BG — darker shade)
```
[3-column: Brand | Links | Contact]
[Bottom bar: © copyright | Legal links]
```

## Mobile Responsive Breakpoints

```css
@media (max-width: 768px) {
  .sm-hero h1 { font-size: 36px; }
  .sm-section { padding: 60px 0; }
  .sm-grid-3, .sm-grid-4 { grid-template-columns: 1fr; }
  .sm-grid-2 { grid-template-columns: 1fr; }
  .sm-stats-grid { grid-template-columns: repeat(2, 1fr); }
  .sm-nav-links { display: none; } /* replaced by hamburger */
}
```

## Key Differences from Big Headline Page

| Feature | VSL Page | Big Headline Page |
|---------|----------|-------------------|
| Hero alignment | Centered | Left-aligned |
| Hero focal point | Video embed | Big headline text |
| Below hero | 3 offer cards | CTA buttons + qualifier |
| Problem cards | Dark cards on white bg, red LEFT border | Numbered cards (01-04), red circle numbers |
| Has video | Yes (required) | No |
| Has diagram | Yes (SVG hub-and-spoke) | No (uses step process instead) |
| Has FAQ | No | Yes (accordion) |
| Has qualifier section | No (qualifier is implied in offers) | Yes (positive/negative columns) |
| Has pricing section | In offers section (side by side) | Dedicated centered card |
