// Quality Gate Validator
// Checks outputs against brand standards, RTL, CTAs, file sizes, banned words

const fs = require('fs');
const path = require('path');
const brand = require('./brand');

const SIZE_LIMITS = {
  '.html': 500 * 1024,   // 500KB
  '.pptx': 10 * 1024 * 1024, // 10MB
  '.pdf': 5 * 1024 * 1024,   // 5MB
  '.docx': 2 * 1024 * 1024,  // 2MB
  '.xlsx': 2 * 1024 * 1024,  // 2MB
};

/**
 * Run all quality gates on a file
 * @param {string} filePath - Path to output file
 * @returns {{ pass: boolean, errors: string[], warnings: string[] }}
 */
function validateFile(filePath) {
  const errors = [];
  const warnings = [];
  const ext = path.extname(filePath).toLowerCase();

  // File size check
  const stats = fs.statSync(filePath);
  const limit = SIZE_LIMITS[ext];
  if (limit && stats.size > limit) {
    errors.push(`File size ${(stats.size / 1024).toFixed(0)}KB exceeds limit ${(limit / 1024).toFixed(0)}KB`);
  }

  // For HTML files, check content
  if (ext === '.html') {
    const content = fs.readFileSync(filePath, 'utf-8');
    validateHtml(content, errors, warnings);
  }

  return {
    pass: errors.length === 0,
    errors,
    warnings,
    file: path.basename(filePath),
    size: `${(stats.size / 1024).toFixed(1)}KB`,
  };
}

function validateHtml(content, errors, warnings) {
  // Brand color check
  const hexColors = content.match(/#[0-9A-Fa-f]{6}/g) || [];
  const allowedColors = Object.values(brand.colors).map(c => c.toLowerCase());
  for (const color of hexColors) {
    // Allow brand colors + common UI grays used in templates
    const uiColors = ['#000000', '#ffffff', '#f9fafb', '#e5e7eb', '#fdf8f0'];
    if (!allowedColors.includes(color.toLowerCase()) && !uiColors.includes(color.toLowerCase())) {
      warnings.push(`Non-brand color found: ${color}`);
    }
  }

  // RTL check
  if (!content.includes('dir="rtl"') && !content.includes("dir='rtl'")) {
    warnings.push('No RTL direction attribute found');
  }

  // CTA check
  const ctaPatterns = [/href=/i, /button/i, /cta/i, /submit/i, /book/i, /join/i, /sign.?up/i, /register/i];
  const hasCta = ctaPatterns.some(p => p.test(content));
  if (!hasCta) {
    warnings.push('No CTA detected');
  }

  // Banned words check
  const contentLower = content.toLowerCase();
  for (const word of brand.bannedWords) {
    if (contentLower.includes(word.toLowerCase())) {
      errors.push(`Banned word found: "${word}"`);
    }
  }
}

/**
 * Validate all files in a directory
 */
function validateAll(dirPath) {
  const results = [];
  const files = fs.readdirSync(dirPath).filter(f => !f.startsWith('.'));

  for (const file of files) {
    const filePath = path.join(dirPath, file);
    if (fs.statSync(filePath).isFile()) {
      results.push(validateFile(filePath));
    }
  }

  const passed = results.filter(r => r.pass).length;
  const total = results.length;

  return {
    results,
    summary: `${passed}/${total} files passed quality gates`,
    allPassed: passed === total,
  };
}

module.exports = { validateFile, validateAll };
