// Brand System — Per-Customer Configuration
// Colors come from CLI args, not hardcoded. This module builds the brand config.

const DEFAULT_COLORS = {
  primary: '#FF6B00',
  secondary: '#6B7280',
  accent: '#D4A853',
  dark: '#1A1A2E',
  bg: '#FFFFFF',
  cream: '#FDF8F0',
  text: '#111827',
  textLight: '#9CA3AF',
};

const FONTS = {
  headerAr: 'Cairo',
  bodyAr: 'Tajawal',
  en: 'Inter',
};

const FONT_IMPORTS = [
  'https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap',
  'https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700&display=swap',
  'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap',
];

const BANNED_WORDS = [
  'leverage', 'synergy', 'ecosystem', 'holistic',
  'digital transformation', 'innovative', 'cutting-edge',
  'world-class', 'best-in-class',
];

/**
 * Build brand config from customer-provided colors
 * @param {string[]} customerColors - Array of 2-4 hex colors from customer
 * @returns {object} Complete brand config
 */
function buildBrand(customerColors) {
  // Parse customer colors into roles
  const colors = { ...DEFAULT_COLORS };

  if (customerColors && customerColors.length >= 2) {
    colors.primary = customerColors[0];
    colors.dark = customerColors[1];
    if (customerColors.length >= 3) colors.accent = customerColors[2];
    if (customerColors.length >= 4) colors.bg = customerColors[3];

    // Auto-derive secondary colors
    colors.secondary = adjustBrightness(colors.primary, -30);
    colors.cream = adjustBrightness(colors.bg, -3);

    // Auto-detect text color based on background brightness
    const bgBrightness = getBrightness(colors.bg);
    colors.text = bgBrightness > 128 ? '#111827' : '#FFFFFF';
    colors.textLight = bgBrightness > 128 ? '#9CA3AF' : '#A3A3A3';
  }

  // Strip # for DOCX/PPTX hex values
  const docxColors = {};
  const pptxColors = {};
  for (const [key, val] of Object.entries(colors)) {
    const hex = val.replace('#', '');
    docxColors[key] = hex;
    pptxColors[key] = hex;
  }
  pptxColors.white = 'FFFFFF';

  return {
    colors,
    fonts: FONTS,
    fontImports: FONT_IMPORTS,
    bannedWords: BANNED_WORDS,
    rtl: true,
    docxColors,
    pptxColors,
  };
}

/**
 * Generate CSS variables string from brand colors
 */
function toCssVars(colors) {
  const primary = colors.primary;
  const primaryHover = adjustBrightness(primary, -20);
  const primaryGlow = hexToRgba(primary, 0.15);
  const bgAlt = adjustBrightness(colors.bg || '#000000', 4);
  const bgBrightness = getBrightness(colors.bg || '#FFFFFF');

  return `
    --primary: ${primary};
    --primary-hover: ${primaryHover};
    --primary-glow: ${primaryGlow};
    --bg: ${colors.bg || '#FFFFFF'};
    --bg-alt: ${bgAlt};
    --bg-card: ${bgBrightness > 128 ? 'rgba(0,0,0,0.03)' : 'rgba(255,255,255,0.04)'};
    --accent: ${colors.accent || colors.primary};
    --dark: ${colors.dark || '#1A1A2E'};
    --text: ${colors.text || (bgBrightness > 128 ? '#111827' : '#FFFFFF')};
    --text-muted: ${colors.textLight || (bgBrightness > 128 ? '#6B7280' : '#A3A3A3')};
    --text-dark: ${bgBrightness > 128 ? '#111827' : '#FFFFFF'};
    --border: ${bgBrightness > 128 ? 'rgba(0,0,0,0.08)' : 'rgba(255,255,255,0.08)'};
    --success: #22C55E;
    --error: #EF4444;
    --font: 'Inter', system-ui, -apple-system, sans-serif;
    --font-ar: 'Cairo', 'Tajawal', system-ui, sans-serif;
  `;
}

function hexToRgba(hex, alpha) {
  const h = hex.replace('#', '');
  const r = parseInt(h.substring(0, 2), 16);
  const g = parseInt(h.substring(2, 4), 16);
  const b = parseInt(h.substring(4, 6), 16);
  return `rgba(${r},${g},${b},${alpha})`;
}

function getBrightness(hex) {
  const h = hex.replace('#', '');
  const r = parseInt(h.substring(0, 2), 16);
  const g = parseInt(h.substring(2, 4), 16);
  const b = parseInt(h.substring(4, 6), 16);
  return (r * 299 + g * 587 + b * 114) / 1000;
}

function adjustBrightness(hex, percent) {
  const h = hex.replace('#', '');
  let r = parseInt(h.substring(0, 2), 16);
  let g = parseInt(h.substring(2, 4), 16);
  let b = parseInt(h.substring(4, 6), 16);

  r = Math.min(255, Math.max(0, r + Math.round(r * percent / 100)));
  g = Math.min(255, Math.max(0, g + Math.round(g * percent / 100)));
  b = Math.min(255, Math.max(0, b + Math.round(b * percent / 100)));

  return '#' + [r, g, b].map(c => c.toString(16).padStart(2, '0')).join('');
}

// Legacy export for backward compatibility
module.exports = {
  ...buildBrand(null),
  buildBrand,
  toCssVars,
  hexToRgba,
  getBrightness,
  adjustBrightness,
};
