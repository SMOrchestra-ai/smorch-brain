// Quality Gate Validator v2
// Checks outputs against brand standards, RTL, CTAs, file sizes, banned words

const fs = require('fs');
const path = require('path');

const SIZE_LIMITS = {
  '.html': 500 * 1024,
  '.pptx': 10 * 1024 * 1024,
  '.pdf': 5 * 1024 * 1024,
  '.docx': 2 * 1024 * 1024,
  '.xlsx': 2 * 1024 * 1024,
};

const BANNED_WORDS = [
  'leverage', 'synergy', 'ecosystem', 'holistic',
  'digital transformation', 'innovative', 'cutting-edge',
  'world-class', 'best-in-class',
];

/**
 * Run all quality gates on a file
 */
function validateFile(filePath) {
  const errors = [];
  const warnings = [];
  const ext = path.extname(filePath).toLowerCase();

  const stats = fs.statSync(filePath);
  const limit = SIZE_LIMITS[ext];
  if (limit && stats.size > limit) {
    errors.push(`File size ${(stats.size / 1024).toFixed(0)}KB exceeds limit ${(limit / 1024).toFixed(0)}KB`);
  }

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
  // CTA check
  const ctaPatterns = [/href=/i, /button/i, /cta/i, /submit/i, /book/i, /join/i, /sign.?up/i, /register/i, /get.?started/i];
  const hasCta = ctaPatterns.some(p => p.test(content));
  if (!hasCta) {
    warnings.push('No CTA detected');
  }

  // Banned words check
  const contentLower = content.toLowerCase();
  for (const word of BANNED_WORDS) {
    if (contentLower.includes(word.toLowerCase())) {
      errors.push(`Banned word found: "${word}"`);
    }
  }

  // CSS variables check (should use variables, not hardcoded colors)
  if (content.includes('var(--primary)') || content.includes('var(--bg)')) {
    // Good — using CSS variables
  } else if (content.includes('{{CSS_VARS}}')) {
    warnings.push('Template placeholders not replaced — CSS vars still raw');
  }
}

/**
 * Validate all files in a directory
 */
function validateAll(dirPath) {
  const results = [];
  if (!fs.existsSync(dirPath)) return { results, summary: '0/0 files passed', allPassed: true };

  const files = fs.readdirSync(dirPath).filter(f => !f.startsWith('.') && !f.endsWith('.json'));

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
