# Mamoun YouTube Visual Identity

## Color Palette

Dark tech aesthetic. Premium feel. High contrast for readability on screens and in thumbnails.

```javascript
const C = {
  bg: "0F1724",        // Deep navy-black. Primary background.
  bgLight: "1A2332",   // Slightly lighter. Card backgrounds.
  teal: "00D4FF",      // Primary accent. Links, highlights, Option A.
  orange: "FF6B35",    // Secondary accent. CTAs, step badges, Option B.
  white: "FFFFFF",     // Titles, primary text on dark.
  gray: "8892A0",      // Body text, descriptions, muted content.
  darkGray: "2A3441",  // Card backgrounds (darker variant), "NO" cards.
  green: "00E676",     // Success, positive callouts, "what you need".
  red: "FF4757",       // Warnings, "NO" labels, traditional/bad option.
  gold: "FFD700",      // Pro tips, highlights, special callouts.
  purple: "8B5CF6",    // Tertiary accent. Plugins, extensions.
};
```

### Color Usage Rules

- **Background**: Always `bg` (0F1724). Every slide. No exceptions.
- **Titles**: Always `white`. Bold. Arial Black.
- **Body text**: Always `gray`. Arial.
- **Step badges**: Orange rectangle with white number.
- **Cards**: `bgLight` or `darkGray` fill with colored left-border accent.
- **Comparison columns**: Use contrasting accent colors (teal vs orange, red vs green).
- **Pro tip boxes**: Dark fill ("1A1A2E") with gold left-border.
- **"What you need" boxes**: Dark green fill ("0A2E1A") with green left-border.

### What to Avoid

- Never use white or light backgrounds. The dark theme is the brand.
- Never use accent lines under titles (AI-generated slide hallmark).
- Never put a teal accent line under every title. Use it sparingly on introductory slides only, not step slides.

## Typography

```javascript
const FONT_HEAD = "Arial Black";  // Titles, headers, step names
const FONT_BODY = "Arial";        // Body text, descriptions, notes
```

| Element | Font | Size | Weight | Color |
|---------|------|------|--------|-------|
| Slide title | Arial Black | 32pt | Bold | white |
| Title slide main word | Arial Black | 54pt | Bold | white |
| Title slide subtitle | Arial | 20pt | Normal | gray or teal |
| Step title | Arial Black | 24pt | Bold | white |
| Card header | Arial | 18pt | Bold | white |
| Body text | Arial | 13-15pt | Normal | gray |
| Option labels | Arial | 11pt | Bold + charSpacing:3 | accent color |
| Pro tip label | Arial | 10pt | Bold + charSpacing:2 | gold |
| Captions/footer | Arial | 8-9pt | Normal | gray |
| Taglines | Arial | 12-16pt | Italic | accent color |

### Character Spacing

Use `charSpacing` (not `letterSpacing`, which PptxGenJS silently ignores) for:
- Subtitle text on title slides: `charSpacing: 3-4`
- Option/section labels: `charSpacing: 2-3`
- Pro tip labels: `charSpacing: 2`

## Shadows

Always use a factory function. PptxGenJS mutates shadow objects in place, so reusing a single object corrupts subsequent shapes.

```javascript
const makeShadow = () => ({
  type: "outer",
  blur: 8,
  offset: 3,
  angle: 135,
  color: "000000",
  opacity: 0.3
});
```

Apply shadows to: cards, content boxes, step badges, comparison columns.
Do NOT apply shadows to: footer bars, divider lines, small text elements.

## Icons

Use react-icons (Font Awesome set) rendered to base64 PNG via sharp.

```javascript
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");

function renderIconSvg(IconComponent, color = "#000000", size = 256) {
  return ReactDOMServer.renderToStaticMarkup(
    React.createElement(IconComponent, { color, size: String(size) })
  );
}

async function iconToBase64Png(IconComponent, color, size = 256) {
  const svg = renderIconSvg(IconComponent, color, size);
  const pngBuffer = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + pngBuffer.toString("base64");
}
```

Render at 256px for crisp display. The `w` and `h` on the slide control display size (typically 0.4-0.7 inches).

Icon color should match the section's accent color. Common mappings:
- Teal icons: primary concepts, navigation, links
- Orange icons: actions, downloads, configurations
- Green icons: success states, code, deployment
- Gold icons: tips, highlights, time-related
- Red icons: warnings, things to avoid
- Purple icons: extensions, plugins, extras

## Layout Constants

### English (LAYOUT_16x9: 10" x 5.625")

| Element | Position |
|---------|----------|
| Slide title | x:0.5 y:0.3 w:9 h:0.7 (or x:1.1 for step slides) |
| Step badge | x:0.35 y:0.2 w:0.55 h:0.55 |
| Content area | x:0.5 y:1.1-1.4, varies by layout |
| Footer bar | x:0 y:5.35 w:10 h:0.275 |
| Footer text | x:0.3 y:5.35 |
| Slide number | x:9.2 y:5.2 (right-aligned) |
| Minimum margins | 0.5" from edges |

### Arabic (LAYOUT_WIDE: 13.3" x 7.5")

See `rtl-arabic-guide.md` for mirrored positions.

## Footer Bar

Semi-transparent teal bar at bottom of every content slide (not title or CTA slides).

```javascript
function addFooterBar(slide) {
  slide.addShape("rect", {
    x: 0, y: 5.35, w: 10, h: 0.275,
    fill: { color: C.teal, transparency: 85 }
  });
  slide.addText("@MamounAlamouri", {
    x: 0.3, y: 5.35, w: 3, h: 0.275,
    fontSize: 8, color: C.gray, fontFace: FONT_BODY
  });
}
```

## Card Patterns

### Standard Card (left accent border)
```javascript
slide.addShape("rect", { x, y, w, h, fill: { color: C.darkGray }, shadow: makeShadow() });
slide.addShape("rect", { x, y, w: 0.07, h, fill: { color: accentColor } });
```

### Comparison Card (top accent border)
```javascript
slide.addShape("rect", { x, y, w, h, fill: { color: C.bgLight }, shadow: makeShadow() });
slide.addShape("rect", { x, y, w, h: 0.06, fill: { color: accentColor } });
```

### Pro Tip Box
```javascript
slide.addShape("rect", { x: 0.5, y, w: 9, h: 0.8, fill: { color: "1A1A2E" }, shadow: makeShadow() });
slide.addShape("rect", { x: 0.5, y, w: 0.07, h: 0.8, fill: { color: C.gold } });
slide.addText("PRO TIP", { ..., fontSize: 10, color: C.gold, bold: true, charSpacing: 2 });
```
