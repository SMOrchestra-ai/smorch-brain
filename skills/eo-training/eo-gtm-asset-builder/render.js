#!/usr/bin/env node
// EO GTM Asset Builder v2 — Production Renderer
// Reads MD blueprints from assets/ and renders deployable files
// Now supports: per-customer brand colors, language selection, single-motion focus
//
// Usage:
//   node render.js --input ../../assets --brand ../../project-brain/brandvoice.md --output ./deployable
//   node render.js --motion dream-100 --colors "#FF6B00,#1A1A2E,#D4A853" --lang en
//   node render.js --motion all (renders all found assets, legacy mode)

const fs = require('fs');
const path = require('path');
const { buildDocx } = require('./builders/docx-builder');
const { buildPptx } = require('./builders/pptx-builder');
const { buildPdf } = require('./builders/pdf-builder');
const { buildLandingPage } = require('./builders/html-builder');
const { buildXlsx } = require('./builders/xlsx-builder');
const { validateAll } = require('./utils/quality-gate');
const { buildBrand } = require('./utils/brand');

// Parse CLI args
const args = parseArgs(process.argv.slice(2));
const ASSETS_DIR = path.resolve(args.input || path.join(__dirname, '..', '..', 'assets'));
const BRAND_FILE = path.resolve(args.brand || path.join(__dirname, '..', '..', 'project-brain', 'brandvoice.md'));
const OUTPUT_DIR = path.resolve(args.output || path.join(__dirname, 'deployable'));
const WORKSPACE_OUTPUT = path.resolve(args['workspace-output'] || path.join(__dirname, '..', '..', 'GTM-Assets-Production'));
const SELECTED_MOTION = args.motion || 'all';
const LANG = args.lang || 'en';
const CUSTOMER_COLORS = args.colors ? args.colors.split(',').map(c => c.trim()) : null;

// Build brand config from customer colors
const brand = buildBrand(CUSTOMER_COLORS);

// Templates
const BASE_TEMPLATE = path.join(__dirname, 'templates', 'base.html');
const LANDING_TEMPLATE = path.join(__dirname, 'templates', 'landing-page.html');

// Production map: which blueprint gets which output format
// Core assets (always produced) + motion-specific assets
const CORE_ASSETS = {
  'core/one-pager.md': 'docx',
  'core/positioning-statement.md': 'docx',
  'core/icp-brief.md': 'docx',
  'core/messaging-framework.md': 'docx',
};

// Motion-specific asset maps
const MOTION_ASSETS = {
  'dream-100': {
    'dream-100/target-list.md': 'xlsx',
    'dream-100/outreach-sequence.md': 'docx',
    'dream-100/value-offer.md': 'docx',
  },
  'authority-education': {
    'authority-education/youtube-script-template.md': 'docx',
    'authority-education/lead-magnet-outline.md': 'docx',
    'authority-education/webinar-structure.md': 'pptx',
    'authority-education/content-calendar-30d.md': 'xlsx',
  },
  'outcome-demo-first': {
    'outcome-demo-first/outcome-demo-script.md': 'docx',
    'outcome-demo-first/before-after-template.md': 'docx',
    'outcome-demo-first/demo-distribution-plan.md': 'docx',
  },
  'value-trust-engine': {
    'value-trust-engine/value-content-playbook.md': 'docx',
    'value-trust-engine/trust-building-sequence.md': 'docx',
    'value-trust-engine/give-first-framework.md': 'docx',
  },
  'waitlist-webinar': {
    'waitlist-webinar/webinar-email-sequence.md': 'docx',
    'waitlist-webinar/webinar-promotion-plan.md': 'docx',
  },
  'signal-sniper-outbound': {
    'signal-sniper-outbound/cold-email-3step.md': 'docx',
    'signal-sniper-outbound/linkedin-connection-sequence.md': 'docx',
  },
  '7x4x11-strategy': {
    '7x4x11-strategy/content-distribution-matrix.md': 'xlsx',
    '7x4x11-strategy/platform-format-guide.md': 'docx',
  },
};

async function main() {
  console.log('\n=== EO GTM Asset Builder v2 ===\n');
  console.log(`Input:   ${ASSETS_DIR}`);
  console.log(`Brand:   ${BRAND_FILE}`);
  console.log(`Output:  ${OUTPUT_DIR}`);
  console.log(`Motion:  ${SELECTED_MOTION}`);
  console.log(`Lang:    ${LANG}`);
  console.log(`Colors:  ${CUSTOMER_COLORS ? CUSTOMER_COLORS.join(', ') : 'default (EO MENA)'}\n`);

  // Validate inputs
  if (!fs.existsSync(ASSETS_DIR)) {
    console.error(`ERROR: Assets directory not found: ${ASSETS_DIR}`);
    process.exit(1);
  }

  // Ensure output directories exist
  for (const dir of [OUTPUT_DIR, WORKSPACE_OUTPUT]) {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  }

  // Build the production map based on motion selection
  let productionMap = { ...CORE_ASSETS };

  if (SELECTED_MOTION === 'all') {
    // Legacy mode: build everything
    for (const motionAssets of Object.values(MOTION_ASSETS)) {
      Object.assign(productionMap, motionAssets);
    }
  } else if (MOTION_ASSETS[SELECTED_MOTION]) {
    // Single motion mode
    Object.assign(productionMap, MOTION_ASSETS[SELECTED_MOTION]);
  } else {
    console.warn(`WARNING: Unknown motion "${SELECTED_MOTION}". Building core assets only.`);
    console.log(`Available motions: ${Object.keys(MOTION_ASSETS).join(', ')}\n`);
  }

  const results = [];
  const errors = [];
  let processed = 0;
  const total = Object.keys(productionMap).length;

  // Also generate landing page
  const landingPageCount = 1;
  const pptxCount = 1;

  console.log(`--- Core Assets ---\n`);

  for (const [relativePath, format] of Object.entries(productionMap)) {
    const inputPath = path.join(ASSETS_DIR, relativePath);
    processed++;

    if (!fs.existsSync(inputPath)) {
      console.log(`  [${processed}/${total}] SKIP ${relativePath} (not found)`);
      continue;
    }

    try {
      const tag = `[${processed}/${total}]`;

      if (format === 'docx') {
        const result = await buildDocx(inputPath, OUTPUT_DIR, brand);
        results.push(result);
        console.log(`  ${tag} DOCX ${result.file} (${formatSize(result.size)})`);
      } else if (format === 'pptx') {
        const result = await buildPptx(inputPath, OUTPUT_DIR, brand);
        results.push(result);
        console.log(`  ${tag} PPTX ${result.file} (${formatSize(result.size)}, ${result.slides} slides)`);
      } else if (format === 'xlsx') {
        const result = await buildXlsx(inputPath, OUTPUT_DIR, brand);
        results.push(result);
        console.log(`  ${tag} XLSX ${result.file} (${formatSize(result.size)})`);
      } else if (format === 'pdf') {
        const result = await buildPdf(inputPath, OUTPUT_DIR, BASE_TEMPLATE, brand);
        results.push(result);
        console.log(`  ${tag} PDF  ${result.file} (${formatSize(result.size)})`);
      }
    } catch (err) {
      console.error(`  [${processed}/${total}] ERROR ${relativePath}: ${err.message}`);
      errors.push({ file: relativePath, error: err.message });
    }
  }

  // Generate landing page from one-pager or positioning statement
  console.log('\n--- Landing Page ---\n');
  try {
    const onePagerPath = path.join(ASSETS_DIR, 'core', 'one-pager.md');
    if (fs.existsSync(onePagerPath) && fs.existsSync(LANDING_TEMPLATE)) {
      const result = buildLandingPage(onePagerPath, OUTPUT_DIR, LANDING_TEMPLATE, brand, LANG);
      results.push(result);
      console.log(`  LAND ${result.file} (${formatSize(result.size)})`);
    } else if (fs.existsSync(onePagerPath) && fs.existsSync(BASE_TEMPLATE)) {
      // Fallback to base template
      const result = buildLandingPage(onePagerPath, OUTPUT_DIR, BASE_TEMPLATE, brand, LANG);
      results.push(result);
      console.log(`  LAND ${result.file} (${formatSize(result.size)}) [base template]`);
    } else {
      console.log('  SKIP landing page (one-pager.md or template not found)');
    }
  } catch (err) {
    console.error(`  ERROR landing page: ${err.message}`);
    errors.push({ file: 'landing-page.html', error: err.message });
  }

  // Run quality gates
  console.log('\n--- Quality Gates ---\n');
  const validation = validateAll(OUTPUT_DIR);
  for (const result of validation.results) {
    const icon = result.pass ? '+' : 'x';
    console.log(`  [${icon}] ${result.pass ? 'PASS' : 'FAIL'} ${result.file} (${result.size})`);
    for (const err of result.errors) console.log(`      ERROR: ${err}`);
    for (const warn of result.warnings) console.log(`      WARN:  ${warn}`);
  }

  // Copy to workspace output
  console.log('\n--- Copying to GTM-Assets-Production ---\n');
  const deployedFiles = fs.readdirSync(OUTPUT_DIR).filter(f => !f.startsWith('.'));
  for (const file of deployedFiles) {
    fs.copyFileSync(path.join(OUTPUT_DIR, file), path.join(WORKSPACE_OUTPUT, file));
  }
  console.log(`  Copied ${deployedFiles.length} files to ${WORKSPACE_OUTPUT}`);

  // Save brand config for reference
  const brandConfigPath = path.join(OUTPUT_DIR, 'brand-config.json');
  fs.writeFileSync(brandConfigPath, JSON.stringify({
    colors: brand.colors,
    fonts: brand.fonts,
    lang: LANG,
    motion: SELECTED_MOTION,
    generated: new Date().toISOString(),
  }, null, 2));

  // Summary
  console.log('\n=== BUILD COMPLETE ===\n');
  console.log(`  Motion:  ${SELECTED_MOTION}`);
  console.log(`  Lang:    ${LANG}`);
  console.log(`  Colors:  ${brand.colors.primary} / ${brand.colors.dark} / ${brand.colors.accent}`);
  console.log(`  Files:   ${results.length}`);
  console.log(`  Errors:  ${errors.length}`);
  console.log(`  Quality: ${validation.summary}`);
  console.log(`  Output:  ${OUTPUT_DIR}\n`);

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
    for (const e of errors) console.log(`  - ${e.file}: ${e.error}`);
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
