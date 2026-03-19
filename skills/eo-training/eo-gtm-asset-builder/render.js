#!/usr/bin/env node
// EO GTM Asset Builder - Production Renderer
// Reads MD blueprints from assets/ and renders deployable files
//
// Usage:
//   node render.js --input ../../assets --brand ../../project-brain/brandvoice.md --output ./deployable
//   node render.js (uses defaults)

const fs = require('fs');
const path = require('path');
const { buildLandingPage, buildEmailSequence } = require('./builders/html-builder');
const { buildDocx } = require('./builders/docx-builder');
const { buildPptx } = require('./builders/pptx-builder');
const { buildPdf } = require('./builders/pdf-builder');
const { buildXlsx } = require('./builders/xlsx-builder');
const { validateAll } = require('./utils/quality-gate');

// Parse CLI args
const args = parseArgs(process.argv.slice(2));
const ASSETS_DIR = path.resolve(args.input || path.join(__dirname, '..', '..', 'assets'));
const BRAND_FILE = path.resolve(args.brand || path.join(__dirname, '..', '..', 'project-brain', 'brandvoice.md'));
const OUTPUT_DIR = path.resolve(args.output || path.join(__dirname, 'deployable'));
const BASE_TEMPLATE = path.join(__dirname, 'templates', 'base.html');
const EMAIL_TEMPLATE = path.join(__dirname, 'templates', 'email.html');

// Production map: which blueprint gets which output format
const PRODUCTION_MAP = {
  // DOCX outputs
  'core/one-pager.md': 'docx+pdf',
  'core/positioning-statement.md': 'docx',
  'core/icp-brief.md': 'docx',
  'core/messaging-framework.md': 'docx',
  'dream-100/value-offer.md': 'docx',
  'outcome-demo-first/outcome-demo-script.md': 'docx',
  'outcome-demo-first/before-after-template.md': 'docx',
  'outcome-demo-first/demo-distribution-plan.md': 'docx',
  'value-trust-engine/value-content-playbook.md': 'docx',
  'value-trust-engine/trust-building-sequence.md': 'docx',
  'value-trust-engine/give-first-framework.md': 'docx',
  'waitlist-webinar/webinar-promotion-plan.md': 'docx',
  'signal-sniper-outbound/linkedin-connection-sequence.md': 'docx',
  '7x4x11-strategy/platform-format-guide.md': 'docx',
  'authority-education/youtube-script-template.md': 'docx',

  // HTML email outputs
  'dream-100/outreach-sequence.md': 'email',
  'signal-sniper-outbound/cold-email-3step.md': 'email',
  'waitlist-webinar/webinar-email-sequence.md': 'email',

  // PPTX outputs
  'authority-education/webinar-structure.md': 'pptx',

  // PDF outputs
  'authority-education/lead-magnet-outline.md': 'pdf',

  // XLSX outputs
  'dream-100/target-list.md': 'xlsx',
  'authority-education/content-calendar-30d.md': 'xlsx',
  '7x4x11-strategy/content-distribution-matrix.md': 'xlsx',
};

async function main() {
  console.log('\n=== EO GTM Asset Builder - Production Renderer ===\n');
  console.log(`Input:  ${ASSETS_DIR}`);
  console.log(`Brand:  ${BRAND_FILE}`);
  console.log(`Output: ${OUTPUT_DIR}\n`);

  // Validate inputs exist
  if (!fs.existsSync(ASSETS_DIR)) {
    console.error(`ERROR: Assets directory not found: ${ASSETS_DIR}`);
    process.exit(1);
  }
  if (!fs.existsSync(BRAND_FILE)) {
    console.error(`ERROR: Brand file not found: ${BRAND_FILE}`);
    process.exit(1);
  }

  // Ensure output directory exists
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  const results = [];
  const errors = [];
  let processed = 0;
  const total = Object.keys(PRODUCTION_MAP).length;

  for (const [relativePath, format] of Object.entries(PRODUCTION_MAP)) {
    const inputPath = path.join(ASSETS_DIR, relativePath);
    processed++;

    if (!fs.existsSync(inputPath)) {
      console.log(`  [${processed}/${total}] SKIP ${relativePath} (file not found)`);
      continue;
    }

    try {
      const tag = `[${processed}/${total}]`;

      if (format === 'docx' || format === 'docx+pdf') {
        const result = await buildDocx(inputPath, OUTPUT_DIR);
        results.push(result);
        console.log(`  ${tag} DOCX ${result.file} (${formatSize(result.size)})`);

        if (format === 'docx+pdf') {
          const pdfResult = await buildPdf(inputPath, OUTPUT_DIR, BASE_TEMPLATE);
          results.push(pdfResult);
          console.log(`  ${tag} PDF  ${pdfResult.file} (${formatSize(pdfResult.size)})${pdfResult.warning ? ' [!]' : ''}`);
        }
      } else if (format === 'email') {
        const emailResults = buildEmailSequence(inputPath, OUTPUT_DIR, EMAIL_TEMPLATE);
        for (const r of emailResults) {
          results.push(r);
          console.log(`  ${tag} HTML ${r.file} (${formatSize(r.size)})`);
        }
      } else if (format === 'pptx') {
        const result = await buildPptx(inputPath, OUTPUT_DIR);
        results.push(result);
        console.log(`  ${tag} PPTX ${result.file} (${formatSize(result.size)}, ${result.slides} slides)`);
      } else if (format === 'pdf') {
        const result = await buildPdf(inputPath, OUTPUT_DIR, BASE_TEMPLATE);
        results.push(result);
        console.log(`  ${tag} PDF  ${result.file} (${formatSize(result.size)})${result.warning ? ' [!]' : ''}`);
      } else if (format === 'xlsx') {
        const result = await buildXlsx(inputPath, OUTPUT_DIR);
        results.push(result);
        console.log(`  ${tag} XLSX ${result.file} (${formatSize(result.size)})`);
      }
    } catch (err) {
      console.error(`  [${processed}/${total}] ERROR ${relativePath}: ${err.message}`);
      errors.push({ file: relativePath, error: err.message });
    }
  }

  // Run quality gates
  console.log('\n--- Quality Gates ---\n');
  const validation = validateAll(OUTPUT_DIR);
  for (const result of validation.results) {
    const status = result.pass ? 'PASS' : 'FAIL';
    const icon = result.pass ? '+' : 'x';
    console.log(`  [${icon}] ${status} ${result.file} (${result.size})`);
    for (const err of result.errors) {
      console.log(`      ERROR: ${err}`);
    }
    for (const warn of result.warnings) {
      console.log(`      WARN:  ${warn}`);
    }
  }

  // Summary
  console.log('\n=== BUILD COMPLETE ===\n');
  console.log(`  Files produced: ${results.length}`);
  console.log(`  Errors: ${errors.length}`);
  console.log(`  Quality: ${validation.summary}`);
  console.log(`  Output: ${OUTPUT_DIR}\n`);

  // Breakdown by type
  const byType = {};
  for (const r of results) {
    byType[r.type] = (byType[r.type] || 0) + 1;
  }
  for (const [type, count] of Object.entries(byType)) {
    console.log(`  ${type.toUpperCase()}: ${count} files`);
  }

  if (errors.length > 0) {
    console.log('\nErrors:');
    for (const e of errors) {
      console.log(`  - ${e.file}: ${e.error}`);
    }
    process.exit(1);
  }
}

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i++) {
    if (argv[i].startsWith('--') && i + 1 < argv.length) {
      args[argv[i].slice(2)] = argv[i + 1];
      i++;
    }
  }
  return args;
}

function formatSize(bytes) {
  if (bytes < 1024) return `${bytes}B`;
  return `${(bytes / 1024).toFixed(1)}KB`;
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
