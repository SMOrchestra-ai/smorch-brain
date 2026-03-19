// PDF Builder - Lead magnets, checklists, guides
// Renders MD → branded HTML → PDF via Puppeteer

const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const { parseBlueprint } = require('../utils/md-parser');

/**
 * Build a PDF from a markdown blueprint
 * Uses Puppeteer to render branded HTML to PDF
 */
async function buildPdf(inputPath, outputDir, baseTemplatePath) {
  const blueprint = parseBlueprint(inputPath);
  const template = fs.readFileSync(baseTemplatePath, 'utf-8');

  const contentHtml = marked(blueprint.raw);

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

  // Try Puppeteer for real PDF generation
  let puppeteer;
  try {
    puppeteer = require('puppeteer');
  } catch (e) {
    // Fallback: save as print-ready HTML
    const filename = path.basename(inputPath, '.md') + '.print.html';
    const outputPath = path.join(outputDir, filename);
    fs.writeFileSync(outputPath, html, 'utf-8');
    return {
      file: filename,
      type: 'pdf-ready-html',
      size: fs.statSync(outputPath).size,
      note: 'Puppeteer not available. Open in browser, Cmd+P to save as PDF.',
    };
  }

  // Use PUPPETEER_EXECUTABLE_PATH env var, or find cached Chrome, or let Puppeteer find it
  const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH || findCachedChrome();
  const launchOptions = { headless: true, args: ['--no-sandbox'] };
  if (executablePath) launchOptions.executablePath = executablePath;

  const browser = await puppeteer.launch(launchOptions);
  const page = await browser.newPage();
  await page.setContent(html, { waitUntil: 'networkidle0', timeout: 30000 });

  const filename = path.basename(inputPath, '.md') + '.pdf';
  const outputPath = path.join(outputDir, filename);
  await page.pdf({
    path: outputPath,
    format: 'A4',
    margin: { top: '20mm', right: '20mm', bottom: '20mm', left: '20mm' },
    printBackground: true,
  });

  await browser.close();

  return { file: filename, type: 'pdf', size: fs.statSync(outputPath).size };
}

function findCachedChrome() {
  const fs = require('fs');
  const path = require('path');

  // 1. Check for system Chrome (most reliable)
  const systemChrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
  if (fs.existsSync(systemChrome)) return systemChrome;

  // 2. Check Puppeteer cache
  const cacheDir = path.join(require('os').homedir(), '.cache', 'puppeteer', 'chrome');
  if (!fs.existsSync(cacheDir)) return null;
  const versions = fs.readdirSync(cacheDir).filter(d => d.startsWith('mac_arm-') || d.startsWith('mac-'));
  if (versions.length === 0) return null;
  versions.sort();
  const latest = versions[versions.length - 1];
  const chromePath = path.join(cacheDir, latest, 'chrome-mac-arm64', 'Google Chrome for Testing.app', 'Contents', 'MacOS', 'Google Chrome for Testing');
  return fs.existsSync(chromePath) ? chromePath : null;
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

module.exports = { buildPdf };
