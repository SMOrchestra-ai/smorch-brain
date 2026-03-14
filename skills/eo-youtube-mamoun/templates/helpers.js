/**
 * YouTube Deck Builder - Reusable Helpers
 *
 * Copy this file as the starting boilerplate for every new deck build.
 * Modify the content sections; keep the helpers and constants intact.
 *
 * Dependencies: pptxgenjs, react, react-dom, react-icons, sharp
 */

const pptxgen = require("pptxgenjs");
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");

// ===================== DESIGN SYSTEM =====================

const C = {
  bg: "0F1724",        // Primary background (every slide)
  bgLight: "1A2332",   // Card backgrounds
  teal: "00D4FF",      // Primary accent
  orange: "FF6B35",    // Secondary accent, CTAs, step badges
  white: "FFFFFF",     // Titles, primary text
  gray: "8892A0",      // Body text, descriptions
  darkGray: "2A3441",  // Card backgrounds (darker), NO cards
  green: "00E676",     // Success, positive callouts
  red: "FF4757",       // Warnings, NO labels
  gold: "FFD700",      // Pro tips, highlights
  purple: "8B5CF6",    // Tertiary accent, plugins
};

const FONT_HEAD = "Arial Black";
const FONT_BODY = "Arial";

// ===================== SHADOW FACTORY =====================
// NEVER reuse a shadow object. PptxGenJS mutates them in place.
const makeShadow = () => ({
  type: "outer", blur: 8, offset: 3, angle: 135,
  color: "000000", opacity: 0.3,
});

// ===================== ICON PIPELINE =====================

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

// ===================== ENGLISH HELPERS (LAYOUT_16x9: 10" x 5.625") =====================

function addSlideNumber_EN(slide, num, total) {
  slide.addText(`${num}/${total}`, {
    x: 9.2, y: 5.2, w: 0.6, h: 0.3,
    fontSize: 9, color: C.gray, fontFace: FONT_BODY, align: "right",
  });
}

function addFooterBar_EN(slide) {
  slide.addShape("rect", {
    x: 0, y: 5.35, w: 10, h: 0.275,
    fill: { color: C.teal, transparency: 85 },
  });
  slide.addText("@MamounAlamouri", {
    x: 0.3, y: 5.35, w: 3, h: 0.275,
    fontSize: 8, color: C.gray, fontFace: FONT_BODY,
  });
}

function addStepBadge_EN(slide, num) {
  slide.addShape("rect", {
    x: 0.35, y: 0.2, w: 0.55, h: 0.55,
    fill: { color: C.orange }, rectRadius: 0.08, shadow: makeShadow(),
  });
  slide.addText(String(num), {
    x: 0.35, y: 0.2, w: 0.55, h: 0.55,
    fontSize: 22, color: C.white, fontFace: FONT_HEAD,
    bold: true, align: "center", valign: "middle",
  });
}

// ===================== ARABIC HELPERS (LAYOUT_WIDE: 13.3" x 7.5") =====================

function addSlideNumber_AR(slide, num, total) {
  slide.addText(`${num}/${total}`, {
    x: 0.2, y: 5.2, w: 0.6, h: 0.3,
    fontSize: 9, color: C.gray, fontFace: FONT_BODY, align: "left",
  });
}

function addFooterBar_AR(slide) {
  slide.addShape("rect", {
    x: 0, y: 5.35, w: 10, h: 0.275,
    fill: { color: C.teal, transparency: 85 },
  });
  slide.addText("@MamounAlamouri", {
    x: 6.7, y: 5.35, w: 3, h: 0.275,
    fontSize: 8, color: C.gray, fontFace: FONT_BODY, align: "right",
  });
}

function addStepBadge_AR(slide, num) {
  slide.addShape("rect", {
    x: 9.1, y: 0.2, w: 0.55, h: 0.55,
    fill: { color: C.orange }, rectRadius: 0.08, shadow: makeShadow(),
  });
  slide.addText(String(num), {
    x: 9.1, y: 0.2, w: 0.55, h: 0.55,
    fontSize: 22, color: C.white, fontFace: FONT_HEAD,
    bold: true, align: "center", valign: "middle",
  });
}

// ===================== CARD PATTERNS =====================

/**
 * Standard card with left accent border (English LTR)
 */
function addCard_EN(slide, { x, y, w, h, accent, fill }) {
  slide.addShape("rect", { x, y, w, h, fill: { color: fill || C.darkGray }, shadow: makeShadow() });
  slide.addShape("rect", { x, y, w: 0.07, h, fill: { color: accent } });
}

/**
 * Standard card with right accent border (Arabic RTL)
 */
function addCard_AR(slide, { x, y, w, h, accent, fill }) {
  slide.addShape("rect", { x, y, w, h, fill: { color: fill || C.darkGray }, shadow: makeShadow() });
  slide.addShape("rect", { x: x + w - 0.07, y, w: 0.07, h, fill: { color: accent } });
}

/**
 * Comparison card with top accent border
 */
function addComparisonCard(slide, { x, y, w, h, accent }) {
  slide.addShape("rect", { x, y, w, h, fill: { color: C.bgLight }, shadow: makeShadow() });
  slide.addShape("rect", { x, y, w, h: 0.06, fill: { color: accent } });
}

/**
 * Pro tip box (full width, gold accent)
 */
function addProTip_EN(slide, { y, text, h }) {
  h = h || 0.8;
  slide.addShape("rect", { x: 0.5, y, w: 9, h, fill: { color: "1A1A2E" }, shadow: makeShadow() });
  slide.addShape("rect", { x: 0.5, y, w: 0.07, h, fill: { color: C.gold } });
  slide.addText("PRO TIP", {
    x: 0.8, y, w: 1.5, h: 0.3,
    fontSize: 10, color: C.gold, fontFace: FONT_BODY, bold: true, charSpacing: 2,
  });
  slide.addText(text, {
    x: 0.8, y: y + 0.3, w: 8.5, h: h - 0.35,
    fontSize: 13, color: C.gray, fontFace: FONT_BODY,
  });
}

// ===================== EXPORTS =====================

module.exports = {
  C,
  FONT_HEAD,
  FONT_BODY,
  makeShadow,
  renderIconSvg,
  iconToBase64Png,
  // English
  addSlideNumber_EN,
  addFooterBar_EN,
  addStepBadge_EN,
  addCard_EN,
  addProTip_EN,
  // Arabic
  addSlideNumber_AR,
  addFooterBar_AR,
  addStepBadge_AR,
  addCard_AR,
  // Shared
  addComparisonCard,
};
