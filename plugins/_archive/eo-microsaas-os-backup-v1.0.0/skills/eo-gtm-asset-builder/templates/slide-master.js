// PPTX Slide Master Configuration
// Used by pptx-builder.js to create branded slide decks

const brand = require('../utils/brand');

const slideMaster = {
  // Slide dimensions (widescreen 16:9)
  layout: { width: 10, height: 5.625 },

  // Master slide definitions
  masters: {
    TITLE: {
      background: { color: brand.pptxColors.dark },
      objects: [
        // Orange accent bar at top
        { rect: { x: 0, y: 0, w: 10, h: 0.08, fill: { color: brand.pptxColors.primary } } },
        // Gold accent line
        { rect: { x: 0.6, y: 3.2, w: 1.2, h: 0.06, fill: { color: brand.pptxColors.accent } } },
      ],
    },
    SECTION: {
      background: { color: brand.pptxColors.primary },
      objects: [
        { rect: { x: 0, y: 5.3, w: 10, h: 0.325, fill: { color: brand.pptxColors.dark } } },
      ],
    },
    CONTENT: {
      background: { color: brand.pptxColors.white },
      objects: [
        // Top orange bar
        { rect: { x: 0, y: 0, w: 10, h: 0.06, fill: { color: brand.pptxColors.primary } } },
        // Footer bar
        { rect: { x: 0, y: 5.3, w: 10, h: 0.325, fill: { color: brand.pptxColors.dark } } },
        // Footer text
        {
          text: {
            text: 'Entrepreneurs Oasis MENA',
            options: {
              x: 0.5, y: 5.35, w: 4, h: 0.25,
              fontSize: 8, color: brand.pptxColors.accent,
              fontFace: brand.fonts.en,
            },
          },
        },
      ],
    },
    CLOSING: {
      background: { color: brand.pptxColors.dark },
      objects: [
        { rect: { x: 0, y: 0, w: 10, h: 0.08, fill: { color: brand.pptxColors.primary } } },
        { rect: { x: 4.2, y: 4.0, w: 1.6, h: 0.06, fill: { color: brand.pptxColors.accent } } },
      ],
    },
  },

  // Default text styles
  textStyles: {
    title: {
      fontSize: 28,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.white,
      bold: true,
    },
    titleDark: {
      fontSize: 28,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.dark,
      bold: true,
    },
    subtitle: {
      fontSize: 16,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.accent,
    },
    body: {
      fontSize: 14,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.secondary,
      lineSpacingMultiple: 1.4,
    },
    bodyDark: {
      fontSize: 14,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.dark,
      lineSpacingMultiple: 1.4,
    },
    bullet: {
      fontSize: 13,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.dark,
      bullet: { type: 'bullet', color: brand.pptxColors.primary },
      lineSpacingMultiple: 1.5,
    },
    sectionTitle: {
      fontSize: 32,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.white,
      bold: true,
    },
    highlight: {
      fontSize: 14,
      fontFace: brand.fonts.en,
      color: brand.pptxColors.primary,
      bold: true,
    },
    // Arabic text styles
    titleAr: {
      fontSize: 28,
      fontFace: brand.fonts.headerAr,
      color: brand.pptxColors.white,
      bold: true,
      rtlMode: true,
    },
    bodyAr: {
      fontSize: 14,
      fontFace: brand.fonts.bodyAr,
      color: brand.pptxColors.dark,
      rtlMode: true,
      lineSpacingMultiple: 1.5,
    },
  },
};

module.exports = slideMaster;
