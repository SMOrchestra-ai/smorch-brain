// EO MENA Brand System Constants
// Source: project-brain/brandvoice.md + CLAUDE.md Design System

const brand = {
  colors: {
    primary: '#FF6B00',
    secondary: '#6B7280',
    accent: '#D4A853',
    dark: '#1A1A2E',
    bg: '#FFFFFF',
    cream: '#FDF8F0',
    text: '#111827',
    textLight: '#9CA3AF',
  },

  fonts: {
    headerAr: 'Cairo',
    bodyAr: 'Tajawal',
    en: 'Inter',
  },

  // Google Fonts import URLs
  fontImports: [
    'https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap',
  ],

  rtl: true,

  bannedWords: [
    'leverage', 'synergy', 'ecosystem', 'holistic',
    'digital transformation', 'innovative', 'cutting-edge',
    'world-class', 'best-in-class',
  ],

  // DOCX color values (hex without #)
  docxColors: {
    primary: 'FF6B00',
    secondary: '6B7280',
    accent: 'D4A853',
    dark: '1A1A2E',
    text: '111827',
  },

  // PPTX color values (hex without #)
  pptxColors: {
    primary: 'FF6B00',
    secondary: '6B7280',
    accent: 'D4A853',
    dark: '1A1A2E',
    white: 'FFFFFF',
    cream: 'FDF8F0',
  },
};

module.exports = brand;
