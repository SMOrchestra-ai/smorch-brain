// PDF Builder v2 — Per-customer brand colors
// Renders MD → branded HTML → PDF via Puppeteer (or print-ready HTML fallback)

const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const { parseBlueprint } = require('../utils/md-parser');

/**
 * Build a PDF from a markdown blueprint
 * @param {string} inputPath - Path to MD file
 * @param {string} outputDir - Output directory
 * @param {string} baseTemplatePath - Path to HTML base template
 * @param {object} brand - Brand config
 */
async function buildPdf(inputPath, outputDir, baseTemplatePath, brand) {
  const blueprint = parseBlueprint(inputPath);
  const template = fs.readFileSync(baseTemplatePath, 'utf-8');
  const colors = brand.colors;

  const contentHtml = marked(blueprint.raw);

  const printCss = `
    <style>
      @media print {
        body { font-size: 11pt; }
        .container { max-width: 100%; padding: 0; }
        .cta-button { border: 2px solid ${colors.primary}; }
        .footer { position: fixed; bottom: 0; width: 100%; }
        @page { margin: 20mm; size: A4; }
      }
    </style>
  `;

  const html = template
    .replace('{{TITLE}}', blueprint.title)
    .replace('</head>', printCss + '</head>')
    .replace('{{CONTENT}}', `
      <div class="badge" style="background:${colors.primary};color:#000;display:inline-block;padding:4px 12px;border-radius:4px;font-size:12px;font-weight:700;">EO MENA</div>
      <h1 style="color:${colors.dark || '#1A1A2E'};margin:16px 0 8px;">${escapeHtml(blueprint.title)}</h1>
      <div style="width:60px;height:4px;background:${colors.primary};margin-bottom:24px;"></div>
      ${contentHtml}
      <div style="margin-top:40px;padding:24px;background:${colors.primary}10;border-radius:8px;text-align:center;">
        <h3 style="color:${colors.dark || '#1A1A2E'};">Ready to get started?</h3>
        <p style="color:#6B7280;">Take the next step with confidence.</p>
        <a href="#" style="display:inline-block;margin-top:12px;padding:10px 24px;background:${colors.primary};color:#000;border-radius:6px;text-decoration:none;font-weight:600;">Get Started</a>
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
      warning: 'Puppeteer not available. Open in browser, Cmd+P to save as PDF.',
    };
  }

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
  const systemChrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
  if (fs.existsSync(systemChrome)) return systemChrome;

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
