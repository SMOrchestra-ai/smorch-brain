// HTML Builder - Landing pages + Email templates
// Reads MD blueprints, renders branded HTML files

const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const { parseBlueprint } = require('../utils/md-parser');
const brand = require('../utils/brand');

/**
 * Build a landing page HTML from a markdown blueprint
 */
function buildLandingPage(inputPath, outputDir, templatePath) {
  const blueprint = parseBlueprint(inputPath);
  const template = fs.readFileSync(templatePath, 'utf-8');

  // Convert markdown body to HTML
  const contentHtml = marked(blueprint.raw);

  const html = template
    .replace('{{TITLE}}', blueprint.title)
    .replace('{{CONTENT}}', contentHtml);

  const filename = path.basename(inputPath, '.md') + '.html';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, html, 'utf-8');

  return { file: filename, type: 'landing-page', size: fs.statSync(outputPath).size };
}

/**
 * Build email HTML from a markdown blueprint containing email sequences
 */
function buildEmailSequence(inputPath, outputDir, templatePath) {
  const blueprint = parseBlueprint(inputPath);
  const template = fs.readFileSync(templatePath, 'utf-8');
  const outputs = [];

  // Extract individual emails from sections
  const emailSections = blueprint.sections.filter(s =>
    s.title.match(/email\s*\d/i) || s.title.match(/step\s*\d/i) || s.title.match(/the\s+(pattern|proof|breakup)/i)
  );

  if (emailSections.length === 0) {
    // Single email file - render the whole thing
    const contentHtml = formatEmailContent(blueprint.sections, blueprint.raw);
    const html = template
      .replace('{{TITLE}}', blueprint.title)
      .replace('{{CONTENT}}', contentHtml)
      .replace('{{CTA_URL}}', '#submit')
      .replace('{{CTA_TEXT}}', 'Submit Your Product')
      .replace('{{UNSUBSCRIBE_URL}}', '#unsubscribe');

    const filename = path.basename(inputPath, '.md') + '.html';
    const outputPath = path.join(outputDir, filename);
    fs.writeFileSync(outputPath, html, 'utf-8');
    outputs.push({ file: filename, type: 'email', size: fs.statSync(outputPath).size });
  } else {
    // Multiple emails - one file per email
    emailSections.forEach((section, idx) => {
      const emailNum = idx + 1;

      // Extract subject line and body from section content
      const subjectMatch = section.text.match(/\*\*Subject.*?\*\*:?\s*(.+)/i) ||
                          section.text.match(/Subject.*?:\s*(.+)/i);
      const subject = subjectMatch ? subjectMatch[1].trim() : `Email ${emailNum}`;

      // Extract body from code blocks or text
      const codeBlocks = section.content.filter(l => !l.startsWith('```') && !l.startsWith('**'));
      const bodyText = section.text || codeBlocks.join('\n');

      const contentHtml = `
        <p style="margin:0 0 8px;font-size:11px;color:#6B7280;font-weight:600;">EMAIL ${emailNum}</p>
        <h2 style="margin:0 0 16px;font-family:'Cairo',Arial,sans-serif;font-size:18px;color:#1A1A2E;">Subject: ${escapeHtml(subject)}</h2>
        <div style="font-size:14px;color:#111827;line-height:1.7;">
          ${bodyText.split('\n').map(l => `<p style="margin:0 0 12px;">${escapeHtml(l)}</p>`).join('\n')}
        </div>
      `;

      const html = template
        .replace('{{TITLE}}', `${blueprint.title} - Email ${emailNum}`)
        .replace('{{CONTENT}}', contentHtml)
        .replace('{{CTA_URL}}', '#submit')
        .replace('{{CTA_TEXT}}', 'Submit Your Product')
        .replace('{{UNSUBSCRIBE_URL}}', '#unsubscribe');

      const filename = path.basename(inputPath, '.md') + `-email${emailNum}.html`;
      const outputPath = path.join(outputDir, filename);
      fs.writeFileSync(outputPath, html, 'utf-8');
      outputs.push({ file: filename, type: 'email', size: fs.statSync(outputPath).size });
    });
  }

  return outputs;
}

function formatEmailContent(sections, raw) {
  let html = '';
  for (const section of sections) {
    html += `<h2 style="margin:20px 0 8px;font-family:'Cairo',Arial,sans-serif;font-size:16px;color:#FF6B00;">${escapeHtml(section.title)}</h2>`;
    html += `<div style="font-size:14px;color:#111827;line-height:1.7;">${marked(section.content.join('\n'))}</div>`;
  }
  return html;
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

module.exports = { buildLandingPage, buildEmailSequence };
