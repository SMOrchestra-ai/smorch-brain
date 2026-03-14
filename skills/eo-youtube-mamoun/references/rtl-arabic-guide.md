# Arabic RTL Deck Production Guide

## Layout Choice

Use `LAYOUT_WIDE` (13.3" x 7.5") for Arabic decks. Arabic text takes more horizontal space than English, and the wider layout prevents cramping.

English uses `LAYOUT_16x9` (10" x 5.625"). Do NOT use the same layout for both languages.

## RTL Mirroring Rules

PptxGenJS has no built-in RTL support. You mirror manually by flipping x-positions.

### Position Mirroring Reference

| Element | English (LTR) | Arabic (RTL) |
|---------|---------------|--------------|
| Step badge | x: 0.35 (top-left) | x: 9.1 (top-right) |
| Step title | x: 1.1 (after badge) | x: 0.5, align:"right" (before badge) |
| Slide number | x: 9.2, align:"right" | x: 0.2, align:"left" |
| Footer handle | x: 0.3 | x: 6.7, align:"right" |
| Card left-accent | x: cardX (left edge) | x: cardX + cardW - 0.07 (right edge) |

### Text Alignment

```javascript
// English
{ align: "left" }   // Body text
{ align: "center" } // Titles stay centered

// Arabic
{ align: "right" }  // Body text
{ align: "center" } // Titles stay centered
```

Titles remain centered in both languages. Only body text, descriptions, and list items flip to right-aligned.

### Card Accent Borders

In English, accent borders sit on the LEFT edge of cards:
```javascript
slide.addShape("rect", { x: cardX, y, w: 0.07, h, fill: { color: accent } });
```

In Arabic, flip them to the RIGHT edge:
```javascript
slide.addShape("rect", { x: cardX + cardW - 0.07, y, w: 0.07, h, fill: { color: accent } });
```

### "NO" Cards in Reality Check

English: warning icon on left, text right-aligned within card.
Arabic: warning icon on right, text left of it, "لا" (NO) on right side.

```javascript
// Arabic NO card pattern
s.addShape("rect", { x: 4.8, y, w: 4.7, h: 1.0, fill: { color: C.darkGray }, shadow: makeShadow() });
s.addShape("rect", { x: 9.43, y, w: 0.07, h: 1.0, fill: { color: card.color } }); // accent on RIGHT
s.addText("لا", { x: 8.3, y, w: 1.0, h: 1.0, fontSize: 28, color: card.color, fontFace: FONT_HEAD, bold: true, align: "center", valign: "middle" });
s.addText(card.text, { x: 5.0, y: y + 0.15, w: 3.2, h: 0.4, fontSize: 15, color: C.white, fontFace: FONT_BODY, bold: true, align: "right" });
```

## Arabic Text Tone

Gulf Arabic conversational tone. Not MSA (Modern Standard Arabic) formal. Mix English tech terms naturally because that is how the MENA tech community actually speaks.

### Tone Examples

Bad (too formal MSA):
> "يجب عليك تحميل البرنامج وتثبيته على حاسوبك الشخصي"

Good (Gulf conversational):
> "نزّل Claude Desktop على جهازك. الخطوة بسيطة."

Bad (over-translating tech terms):
> "الحوسبة السحابية للبرمجيات كخدمة المصغرة"

Good (natural code-switching):
> "ابني MicroSaaS كامل في عطلة نهاية الأسبوع بـ Claude"

### Words to Keep in English
- Claude, Cowork, MCP, API, SaaS, MicroSaaS
- GitHub, Supabase, Vercel, Docker
- Technical terms that have no natural Arabic equivalent the audience uses
- Product names and brand names

### Arabic Speaker Notes

Same structure as English scripts but in Gulf Arabic. Include:
- Stage directions in Arabic: `[الانتقال: ...]`, `[الطاقة: عالية]`
- Timestamp ranges
- Natural conversational flow, as if speaking to a friend who's technical

## Common Overlap Pitfalls

Arabic text is often wider than English for the same content. Watch for:

1. **Sidebar + description overlap**: If a step slide has a sidebar box at x:0.5 w:3.2 and descriptions starting at x:1.0, they overlap. Push descriptions to x:4.0 or beyond.

2. **Card text overflow**: Arabic descriptions may need 10-20% more width. Test with actual text, not placeholders.

3. **Title wrapping**: If an Arabic title wraps to two lines, any decorative element positioned for single-line (like a divider) needs to move down.

## Helper Functions (Arabic Version)

```javascript
function addSlideNumber(slide, num, total) {
  slide.addText(`${num}/${total}`, {
    x: 0.2, y: 5.2, w: 0.6, h: 0.3,
    fontSize: 9, color: C.gray, fontFace: FONT_BODY, align: "left"
  });
}

function addFooterBar(slide) {
  slide.addShape("rect", {
    x: 0, y: 5.35, w: 10, h: 0.275,
    fill: { color: C.teal, transparency: 85 }
  });
  slide.addText("@MamounAlamouri", {
    x: 6.7, y: 5.35, w: 3, h: 0.275,
    fontSize: 8, color: C.gray, fontFace: FONT_BODY, align: "right"
  });
}

function addStepBadge(slide, num) {
  slide.addShape("rect", {
    x: 9.1, y: 0.2, w: 0.55, h: 0.55,
    fill: { color: C.orange }, rectRadius: 0.08, shadow: makeShadow()
  });
  slide.addText(String(num), {
    x: 9.1, y: 0.2, w: 0.55, h: 0.55,
    fontSize: 22, color: C.white, fontFace: FONT_HEAD, bold: true,
    align: "center", valign: "middle"
  });
}
```

## Icon Rendering (Arabic)

Same pipeline as English but use `renderToString` and `"data:image/png;base64,"` prefix format:

```javascript
async function renderIcon(Component, color, size = 48) {
  const svg = ReactDOMServer.renderToString(
    React.createElement(Component, { color, size })
  );
  const png = await sharp(Buffer.from(svg)).png().toBuffer();
  return "data:image/png;base64," + png.toString("base64");
}
```

Both formats work in PptxGenJS. The English version uses `"image/png;base64,"` (without `data:`) and `renderToStaticMarkup`. Either is fine; just be consistent within a single build file.
