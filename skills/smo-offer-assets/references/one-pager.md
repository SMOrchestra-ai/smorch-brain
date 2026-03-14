# One-Pager Structure

This reference defines the single-page offer summary. Based on the Engine and Expansion one-pager PDFs.

The one-pager is a **leave-behind** — something a prospect can scan in 60 seconds and know exactly what you offer, what it costs, and what to do next. It's not a brochure. It's a decision document.

## Production Method

Create as an HTML file styled for print/PDF, then convert to PDF using the pdf skill. Design for A4 or US Letter size (8.5" x 11").

Key constraint: **everything must fit on one page**. If content overflows, cut ruthlessly — the one-pager is not the place for details. That's what the deck and landing page are for.

## Layout Structure

The one-pager uses a structured grid layout with a dark header bar and white body.

### Header Bar (Dark BG — top ~15% of page)
```
[Brand Logo/Name — left]     [Offer Name — center, large]     [Tagline — right or below]
```
- Background: `#000000`
- Text: white
- Offer name: 28-32pt, 800 weight
- Tagline: 14pt, `#A3A3A3`
- Optional: accent underline or border below the header

### Stats Bar (Below header — accent bg or dark bg)
```
[Stat 1]  |  [Stat 2]  |  [Stat 3]  |  [Stat 4]
```
- 3-4 key metrics in a horizontal row
- Large numbers (24-28pt, bold, accent or white)
- Small labels (9-10pt)
- Separated by subtle vertical dividers
- Background options: `#FF6600` with white text, or `#000000` continued

### Body Grid (White BG — main content area)

The body is divided into a **2-column grid** with a clear visual hierarchy.

#### Left Column (~55% width)

**The Problem (Section 1)**
- Section header: "The Challenge" or "Why This Matters" (16pt, bold)
- 3-4 bullet points describing the pain (10-11pt)
- Keep each bullet to 1 line max

**How It Works (Section 2)**
- Section header: "How [Offer] Works" (16pt, bold)
- 3-4 numbered steps, each with title + 1-line description
- Step numbers in accent color circles
- Or: a mini process flow diagram

**What's Included (Section 3)**
- Section header: "What You Get" (16pt, bold)
- Checkmark list of deliverables (10pt)
- 6-10 items organized in 2 sub-columns if needed
- Checkmarks in accent color

#### Right Column (~45% width)

**Key Results (Section 1)**
- Section header: "Results" (16pt, bold)
- 2-3 stat callouts: large number + label
- Or: mini case study (industry, result, quote)

**Pricing (Section 2)**
- Section header: "Investment" (16pt, bold)
- Clear price breakdown:
  - Setup: $X
  - Monthly: $X/mo
  - Performance bonus: $X/SQL (if applicable)
- Or: tier summary if multiple options
- Background: light card (`#F5F5F5`) with subtle border

**Qualifier (Section 3)**
- Section header: "Is This For You?" (14pt, bold)
- 3-4 "Perfect for:" items (green checkmarks)
- 2-3 "Not for:" items (red X marks)
- Compact text (9-10pt)

### CTA Bar (Bottom strip — dark or accent bg)
```
[CTA Text — "Book Your Signal Audit"]  [Email]  [Phone]  [URL]
```
- Background: `#000000` or `#FF6600`
- Full width across bottom
- CTA text: 14pt, bold
- Contact info: 10pt
- Optional: QR code for calendar link (right side)

### Footer Line
- Tiny text: "© SMOrchestra.ai | Confidential" (8pt, muted)

## Print CSS Considerations

```css
@page {
  size: A4;
  margin: 0;
}
@media print {
  body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  .no-print { display: none; }
}
```

- Force background colors to print (the dark header must render)
- Remove any hover states, animations, or interactive elements
- Set explicit widths in points/inches, not percentages where possible
- Test that text doesn't overflow containers

## Typography for One-Pager

Everything is smaller than the landing page and deck because of space constraints:

| Element | Size | Weight |
|---------|------|--------|
| Offer name (header) | 28-32pt | 800 |
| Section headers | 14-16pt | 700 |
| Body text | 10-11pt | 400 |
| Bullet items | 10pt | 400 |
| Stat numbers | 28-36pt | 800 |
| Stat labels | 9-10pt | 500 |
| CTA text | 14pt | 700 |
| Contact info | 10pt | 400 |
| Fine print | 8pt | 400 |

## Content Priorities

If space is tight, cut in this order (last item cut first):
1. ~~Qualifier section~~ (cut first — move to deck/page)
2. ~~Case study~~ (summarize to one stat instead)
3. ~~How it works steps~~ (reduce to 3 steps)
4. Keep: Problem, Pricing, What's Included, Stats, CTA — these are sacred

## Example Content Mapping (The Engine)

| Section | Content |
|---------|---------|
| Header | "SalesMfast: The Engine" |
| Tagline | "Signal-Based Revenue Engine for MENA B2B" |
| Stats | 3-5x Response Rate · 20% Meeting Rate · 90 Days to ROI · $200/SQL |
| Problem | SDR teams burning cash, cold outbound fails in MENA, no signal detection |
| How It Works | 1. Detect Signals → 2. Score & Prioritize → 3. Multi-Channel Sequence → 4. Convert & Optimize |
| What's Included | Signal detection setup, 3-channel orchestration, weekly optimization, dedicated strategist |
| Results | "8.5x ROI in 90 days" + industry/metric |
| Pricing | $2,500 setup + $3,500/mo + $200/SQL bonus |
| Qualifier | For: B2B SaaS $1M+ ARR, selling into Gulf. Not for: B2C, pre-revenue |
| CTA | Book Your Signal Audit → mamoun@smorchestra.ai |
