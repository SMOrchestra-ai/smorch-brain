// PDF Builder - Lead magnets, checklists, guides
// Renders MD → print-ready HTML (open in browser, Cmd+P to save as PDF)
// Puppeteer is optional: install separately with `npm install puppeteer` if you want auto PDF generation

const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const { parseBlueprint } = require('../utils/md-parser');

/**
 * Build a print-ready HTML from a markdown blueprint
 * Output is designed for browser Print → Save as PDF
 */
async function buildPdf(inputPath, outputDir, baseTemplatePath) {
  const blueprint = parseBlueprint(inputPath);
  const template = fs.readFileSync(baseTemplatePath, 'utf-8');

  const contentHtml = marked(blueprint.raw);

  // Add print-optimized CSS
  const printCss = `
    <style>
      @media print {
        body { font-size: 11pt; }
        .container { max-width: 100%; padding: 0; }
        .cta-button { border: 2px solid #FF6B00; }
        .footer { position: fixed; bottom: 0; width: 100%; }
        @page { margin: 20mm; size: A4; }
      }
    </style>
  `;

  const html = template
    .replace('{{TITLE}}', blueprint.title)
    .replace('</head>', printCss + '</head>')
    .replace('{{CONTENT}}', `
      <div class="badge">EO MENA</div>
      <h1>${escapeHtml(blueprint.title)}</h1>
      <div class="accent-line"></div>
      ${contentHtml}
      <div class="cta-section">
        <h3>Ready to launch your product in MENA?</h3>
        <p>Submit your product for the Triple Assessment and earn the Signal-Verified badge.</p>
        <a href="#" class="cta-button">Submit Your Product</a>
      </div>
    `);

  const filename = path.basename(inputPath, '.md') + '.print.html';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, html, 'utf-8');

  return {
    file: filename,
    type: 'pdf-ready-html',
    size: fs.statSync(outputPath).size,
    note: 'Open in browser and print to PDF (Cmd+P / Ctrl+P)',
  };
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

module.exports = { buildPdf };
