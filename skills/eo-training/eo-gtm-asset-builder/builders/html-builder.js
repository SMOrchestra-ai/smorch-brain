// HTML Builder v2 — Landing pages with per-customer brand colors
// Produces production-quality landing pages matching SMO benchmark

const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const { parseBlueprint } = require('../utils/md-parser');
const { toCssVars } = require('../utils/brand');

/**
 * Build a landing page HTML from a markdown blueprint
 * @param {string} inputPath - Path to MD source file
 * @param {string} outputDir - Output directory
 * @param {string} templatePath - Path to HTML template
 * @param {object} brand - Brand config
 * @param {string} lang - Language: 'en', 'ar', or 'both'
 */
function buildLandingPage(inputPath, outputDir, templatePath, brand, lang) {
  const blueprint = parseBlueprint(inputPath);
  let template = fs.readFileSync(templatePath, 'utf-8');

  // Extract sections for structured landing page
  const problemSection = blueprint.sections.find(s =>
    s.title.match(/problem|pain|challenge/i)
  );
  const solutionSection = blueprint.sections.find(s =>
    s.title.match(/solution|what|how|product/i)
  );
  const proofSection = blueprint.sections.find(s =>
    s.title.match(/traction|proof|validation|evidence/i)
  );
  const pricingSection = blueprint.sections.find(s =>
    s.title.match(/pricing|plans|tiers/i)
  );

  // Build CSS variables from customer colors
  const cssVars = toCssVars(brand.colors);

  // Determine direction and fonts
  const isArabic = lang === 'ar';
  const dir = isArabic ? 'rtl' : 'ltr';
  const fontFamily = isArabic ? brand.fonts.headerAr : brand.fonts.en;

  // Build content sections
  const problemHtml = problemSection
    ? buildSectionHtml(problemSection, 'THE PROBLEM')
    : '';
  const solutionHtml = solutionSection
    ? buildSectionHtml(solutionSection, 'THE SOLUTION')
    : '';
  const proofHtml = proofSection
    ? buildSectionHtml(proofSection, 'TRACTION')
    : '';

  // Content fallback: if no structured sections, use full markdown
  const contentHtml = (problemHtml || solutionHtml || proofHtml)
    ? `${problemHtml}${solutionHtml}${proofHtml}`
    : marked(blueprint.raw);

  // Replace template placeholders
  const html = template
    .replace(/\{\{CSS_VARS\}\}/g, cssVars)
    .replace(/\{\{DIR\}\}/g, dir)
    .replace(/\{\{LANG\}\}/g, isArabic ? 'ar' : 'en')
    .replace(/\{\{FONT_FAMILY\}\}/g, fontFamily)
    .replace(/\{\{TITLE\}\}/g, escapeHtml(blueprint.title))
    .replace(/\{\{SUBTITLE\}\}/g, escapeHtml(blueprint.metadata.subtitle || ''))
    .replace(/\{\{VENTURE_NAME\}\}/g, escapeHtml(blueprint.metadata.venture || blueprint.title))
    .replace(/\{\{CONTENT\}\}/g, contentHtml)
    .replace(/\{\{CTA_TEXT\}\}/g, blueprint.metadata.cta || 'Get Started')
    .replace(/\{\{CTA_URL\}\}/g, blueprint.metadata.ctaUrl || '#')
    .replace(/\{\{PRIMARY_COLOR\}\}/g, brand.colors.primary)
    .replace(/\{\{YEAR\}\}/g, new Date().getFullYear().toString());

  const filename = 'landing-page.html';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, html, 'utf-8');

  return { file: filename, type: 'landing-page', size: fs.statSync(outputPath).size };
}

function buildSectionHtml(section, eyebrow) {
  const items = section.lists.flat();
  const itemsHtml = items.length > 0
    ? items.map(item => `
      <div class="feature-card">
        <div class="feature-icon">→</div>
        <div>
          <h4>${escapeHtml(item.split(':')[0] || item)}</h4>
          <p>${escapeHtml(item.includes(':') ? item.split(':').slice(1).join(':').trim() : '')}</p>
        </div>
      </div>
    `).join('')
    : '';

  return `
    <section class="content-section">
      <div class="section-inner">
        <span class="eyebrow">${eyebrow}</span>
        <h2>${escapeHtml(section.title)}</h2>
        ${section.text ? `<p class="section-text">${escapeHtml(section.text).substring(0, 300)}</p>` : ''}
        ${itemsHtml ? `<div class="features-grid">${itemsHtml}</div>` : ''}
      </div>
    </section>
  `;
}

function escapeHtml(str) {
  if (!str) return '';
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

module.exports = { buildLandingPage };
