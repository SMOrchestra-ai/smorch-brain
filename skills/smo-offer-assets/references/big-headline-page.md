# Big Headline Landing Page Structure

This is the reference for Big Headline style landing pages, modeled on `the-engine-ghl.html`.

The Big Headline page leads with **bold left-aligned text** — no video, just raw copy and clear structure. It's designed for offers where the headline and social proof do the selling, not a video.

## Section Map (Top to Bottom)

### 1. Fixed Navigation
Same as VSL page — dark bg, blur backdrop, logo/links/CTA, mobile hamburger.

### 2. Hero Section (Dark BG — LEFT-ALIGNED)
```
[Pill Badge — orange bg, small caps text, e.g. "SIGNAL-BASED PIPELINE FOR MENA"]
[H1 — 3-4 lines, massive, with .sm-accent span on key phrase]
[Subtitle — 1-2 lines, muted text]
[Two CTA Buttons — Primary (orange) + Ghost (bordered)]
[Divider Qualifier — thin line with centered text, e.g. "For B2B SaaS Doing $1M+ ARR"]
```

**Key details:**
- Everything is **left-aligned** (text-align: left)
- H1 uses `<br>` tags for intentional line breaks to control the visual rhythm
- The `.sm-accent` span on a key phrase turns it orange
- Two buttons side-by-side: primary solid orange + ghost with border
- Below buttons: a subtle divider line with qualifier text centered on it

**Pill badge CSS:**
```css
.sm-pill {
  display: inline-block;
  padding: 8px 20px;
  background: var(--accent-glow);
  color: var(--accent);
  border-radius: 50px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 1px;
  text-transform: uppercase;
  margin-bottom: 24px;
}
```

**Hero H1 CSS:**
```css
.sm-hero h1 {
  font-size: 64px;  /* larger than VSL */
  font-weight: 800;
  line-height: 1.05;
  margin-bottom: 24px;
  max-width: 900px;
  /* NOT centered — left aligned */
}
```

**Divider qualifier:**
```css
.sm-hero-divider {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-top: 48px;
  color: var(--text-muted);
  font-size: 14px;
}
.sm-hero-divider::before,
.sm-hero-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--border);
}
```

### 3. Stats Bar (Dark BG)
Same as VSL — 4 stats in a row, large accent numbers, small labels.

### 4. Problem Section (WHITE BG)
```
[Pill badge — "THE PROBLEM"]
[H2 — What's failing]
[Subtitle]
[4 Numbered Problem Cards in 2x2 grid]
```

**Numbered cards pattern** — different from VSL:
- Each card has a large number in a red circle (01, 02, 03, 04)
- Card: white/light bg, dark text, subtle border
- Number circle: `#EF4444` bg, white text, 40x40px circle
- Title below number, then description
- Grid: 2 columns on desktop, 1 on mobile

```css
.sm-problem-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #EF4444;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 16px;
  margin-bottom: 16px;
}
```

### 5. How It Works Section (DARK BG)
```
[Pill badge — "HOW IT WORKS"]
[H2 — The process]
[4 Steps in a row — icon + step number + title + description]
```

- Each step: SVG icon in a bordered circle, step number badge, title, description
- Steps laid out horizontally on desktop (4-column grid), stacked on mobile
- Step numbers use accent color
- SVG icons should be relevant to each step (search, target, send, chart)
- Optional: connecting lines or arrows between steps

**Step icon pattern:**
```css
.sm-step-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: 2px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}
.sm-step-number {
  font-size: 14px;
  font-weight: 600;
  color: var(--accent);
  margin-bottom: 8px;
}
```

### 6. Signals Section (WHITE BG)
```
[Pill badge — "SIGNALS WE DETECT" or "WHAT WE TRACK"]
[H2]
[Subtitle]
[3-column grid of signal cards — orange left border]
```
- Each card: orange left border, signal type title, description
- Light card style on white bg
- 3-column grid, drops to 1 on mobile

### 7. Channels Section (DARK BG)
```
[Pill badge — "MULTI-CHANNEL EXECUTION" or "THREE CHANNELS"]
[H2]
[3 Channel Cards — each with colored top border]
```
- WhatsApp card: `#25D366` green top border
- Email card: `#3B82F6` blue top border
- LinkedIn card: `#0A66C2` blue top border
- Each card: channel icon, title, description, feature bullets
- Dark card style

### 8. Results Section (WHITE BG)
```
[Pill badge — "RESULTS"]
[H2]
[4 Metric Cards + Case Study]
```
Same as VSL page structure.

### 9. Pricing Section (DARK BG)
```
[Pill badge — "INVESTMENT"]
[H2]
[Single Centered Pricing Card]
```
- One large card centered (max-width: 600px)
- Card contains: offer name, price breakdown, what's included list, CTA button
- Accent top border
- Checkmark list for inclusions
- Optional: "Performance bonus" or variable pricing note

### 10. Qualifier Section (DARK BG or WHITE BG)
```
[H2 — "Is [Offer] Right For You?"]
[Two Columns: Positive (green) | Negative (red)]
```
- Left column "This is for you if…" with green checkmarks (`#22C55E`)
- Right column "This is NOT for you if…" with red X marks (`#EF4444`)
- 4-5 items per column
- Clear, specific qualifiers (not generic)

```css
.sm-qualifier-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 32px;
}
.sm-qualifier-yes .sm-qualifier-icon { color: #22C55E; }
.sm-qualifier-no .sm-qualifier-icon { color: #EF4444; }
```

### 11. FAQ Section (DARK BG)
```
[Pill badge — "COMMON QUESTIONS"]
[H2]
[5-7 Accordion Items]
```
- Each item: question text + toggle arrow
- Click expands to show answer
- Smooth height transition
- Only one open at a time (optional)

**Accordion JS pattern:**
```javascript
document.querySelectorAll('.sm-faq-question').forEach(q => {
  q.addEventListener('click', () => {
    const item = q.parentElement;
    const isOpen = item.classList.contains('sm-faq-open');
    // Close all
    document.querySelectorAll('.sm-faq-item').forEach(i =>
      i.classList.remove('sm-faq-open'));
    // Toggle clicked
    if (!isOpen) item.classList.add('sm-faq-open');
  });
});
```

```css
.sm-faq-answer {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease, padding 0.3s ease;
}
.sm-faq-open .sm-faq-answer {
  max-height: 500px;
  padding-top: 16px;
}
.sm-faq-toggle {
  transition: transform 0.3s ease;
}
.sm-faq-open .sm-faq-toggle {
  transform: rotate(180deg);
}
```

### 12. Final CTA Section (DARK BG)
Same as VSL — action headline, subtitle, button, muted reassurance text.

### 13. Footer
Same as VSL.

## Key Differences from VSL Page

| Feature | Big Headline | VSL Page |
|---------|-------------|----------|
| Hero alignment | Left-aligned | Centered |
| Hero focal point | Massive headline text | Video embed |
| Has pill badge in hero | Yes | No |
| Has ghost CTA button | Yes | No |
| Has divider qualifier | Yes (below buttons) | No |
| Problem cards | Numbered (01-04) with red circles | Dark cards with red left border |
| Has "How It Works" steps | Yes (4-step process) | No (uses diagram instead) |
| Has channels section | Yes (3 colored cards) | No |
| Has pricing section | Yes (dedicated centered card) | No (pricing in offers grid) |
| Has qualifier columns | Yes (green/red two-column) | No |
| Has FAQ accordion | Yes | No |
| Has SVG diagram | No | Yes (hub-and-spoke) |
| Has trust quote section | No | Yes |
