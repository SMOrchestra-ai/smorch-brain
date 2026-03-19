#!/usr/bin/env node
// EO GTM Asset Builder v2 — Production Renderer
// Reads MD blueprints from assets/ and renders deployable files
//
// INTERACTIVE MODE: Run with no args → reads SC5 scorecard, shows top 3 motions,
//   prompts for motion selection, brand colors, and language preference.
//
// CLI MODE: Pass all args to skip prompts:
//   node render.js --motion dream-100 --colors "#FF6B00,#1A1A2E,#D4A853" --lang en
//   node render.js --motion all (renders all found assets, legacy mode)

const fs = require('fs');
const path = require('path');
const readline = require('readline');
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
const SCORECARDS_DIR = path.resolve(args.scorecards || path.join(__dirname, '..', '..', 'scorecards'));
const BASE_TEMPLATE = path.join(__dirname, 'templates', 'base.html');
const LANDING_TEMPLATE = path.join(__dirname, 'templates', 'landing-page.html');

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

// Core assets (always produced)
const CORE_ASSETS = {
  'core/one-pager.md': 'docx',
  'core/positioning-statement.md': 'docx',
  'core/icp-brief.md': 'docx',
  'core/messaging-framework.md': 'docx',
};

// All 13 motion display names for the interactive menu
const ALL_MOTIONS = {
  'dream-100': 'Dream 100 Strategy',
  'authority-education': 'Authority Education Engine',
  'outcome-demo-first': 'Outcome Demo First',
  'value-trust-engine': 'Value Trust Engine',
  'waitlist-webinar': 'Waitlist Heat-to-Webinar Close',
  'signal-sniper-outbound': 'Signal Sniper Outbound',
  '7x4x11-strategy': '7x4x11 Strategy',
  'bofu-seo': 'MicroSaaS BOFU SEO Strike',
  'hammering-feature-first': 'Hammering-Feature-First Launches',
  'build-in-public': 'Build-in-Public Trust Flywheel',
  'wave-riding': 'Wave Riding Distribution',
  'paid-vsl': 'Paid VSL Value Ladder',
  'ltd-cash-to-mrr': 'LTD Cash-to-MRR Ladder',
};

// ─── Interactive Prompt Helpers ──────────────────────────────────────────

function createRL() {
  return readline.createInterface({ input: process.stdin, output: process.stdout });
}

function ask(rl, question) {
  return new Promise(resolve => rl.question(question, answer => resolve(answer.trim())));
}

/**
 * Parse the SC5 GTM Fitness scorecard to extract ranked motions
 */
function parseScorecard() {
  if (!fs.existsSync(SCORECARDS_DIR)) return null;

  const files = fs.readdirSync(SCORECARDS_DIR);
  const sc5File = files.find(f => f.toLowerCase().includes('sc5') || f.toLowerCase().includes('gtm-fitness'));
  if (!sc5File) return null;

  const content = fs.readFileSync(path.join(SCORECARDS_DIR, sc5File), 'utf-8');

  // Parse the motion ranking table
  // Format: | # | Motion | Fit | Readiness | MENA | Score | Tier |
  const motions = [];
  const lines = content.split('\n');
  let inTable = false;

  for (const line of lines) {
    if (line.includes('| # |') || line.includes('|---|')) {
      inTable = true;
      continue;
    }
    if (inTable && line.startsWith('|')) {
      const cells = line.split('|').map(c => c.trim()).filter(Boolean);
      if (cells.length >= 6) {
        const rank = parseInt(cells[0]);
        if (!isNaN(rank)) {
          motions.push({
            rank,
            name: cells[1],
            fit: parseFloat(cells[2]) || 0,
            readiness: parseFloat(cells[3]) || 0,
            mena: parseFloat(cells[4]) || 0,
            score: parseFloat(cells[5]) || 0,
            tier: cells[6] || 'PRIMARY',
          });
        }
      }
    } else if (inTable && !line.startsWith('|')) {
      inTable = false;
    }
  }

  return motions.length > 0 ? motions : null;
}

/**
 * Map a scorecard motion name to our motion slug
 */
function motionNameToSlug(name) {
  const lower = name.toLowerCase();
  if (lower.includes('dream 100')) return 'dream-100';
  if (lower.includes('authority') && lower.includes('education')) return 'authority-education';
  if (lower.includes('outcome') && lower.includes('demo')) return 'outcome-demo-first';
  if (lower.includes('value') && lower.includes('trust')) return 'value-trust-engine';
  if (lower.includes('waitlist') || lower.includes('webinar close')) return 'waitlist-webinar';
  if (lower.includes('signal') && lower.includes('sniper')) return 'signal-sniper-outbound';
  if (lower.includes('7x4x11')) return '7x4x11-strategy';
  if (lower.includes('bofu') || lower.includes('seo strike')) return 'bofu-seo';
  if (lower.includes('hammering') || lower.includes('feature-first')) return 'hammering-feature-first';
  if (lower.includes('build') && lower.includes('public')) return 'build-in-public';
  if (lower.includes('wave') && lower.includes('riding')) return 'wave-riding';
  if (lower.includes('paid') && lower.includes('vsl')) return 'paid-vsl';
  if (lower.includes('ltd') || lower.includes('cash-to-mrr')) return 'ltd-cash-to-mrr';
  return null;
}

/**
 * Run the interactive flow to collect motion, colors, and language
 */
async function runInteractive() {
  const rl = createRL();

  console.log('\n╔══════════════════════════════════════════════╗');
  console.log('║    EO GTM Asset Builder — Interactive Mode   ║');
  console.log('╚══════════════════════════════════════════════╝\n');

  // ── Step 1: Read scorecard and show top 3 ──

  let selectedMotion;
  const motions = parseScorecard();

  if (motions && motions.length >= 3) {
    const top3 = motions.slice(0, 3);

    console.log('YOUR TOP 3 GTM MOTIONS (from SC5 scorecard):\n');
    top3.forEach((m, i) => {
      const slug = motionNameToSlug(m.name);
      const hasAssets = slug && MOTION_ASSETS[slug];
      const status = hasAssets ? '' : ' (assets coming soon)';
      console.log(`  [${i + 1}] ${m.name} — Score: ${m.score} (${m.tier})${status}`);
      console.log(`      Fit: ${m.fit} | Readiness: ${m.readiness} | MENA: ${m.mena}`);
      console.log('');
    });

    console.log('  [4] Show all 13 motions');
    console.log('  [5] Enter a motion name manually\n');

    const choice = await ask(rl, 'Pick a number (1-5): ');

    if (choice === '4') {
      // Show all 13
      console.log('\nALL 13 GTM MOTIONS:\n');
      motions.forEach((m, i) => {
        const slug = motionNameToSlug(m.name);
        const hasAssets = slug && MOTION_ASSETS[slug];
        const marker = i < 3 ? ' ★' : '';
        const status = hasAssets ? '' : ' [no builder assets yet]';
        console.log(`  [${i + 1}] ${m.name} — ${m.score} (${m.tier})${marker}${status}`);
      });
      console.log('');

      const allChoice = await ask(rl, 'Pick a number (1-13): ');
      const idx = parseInt(allChoice) - 1;
      if (idx >= 0 && idx < motions.length) {
        selectedMotion = motionNameToSlug(motions[idx].name);
        if (!selectedMotion) {
          console.log(`\nNo slug mapping for "${motions[idx].name}". Using as-is.`);
          selectedMotion = motions[idx].name.toLowerCase().replace(/\s+/g, '-');
        }
      }
    } else if (choice === '5') {
      console.log(`\nAvailable motions: ${Object.keys(ALL_MOTIONS).join(', ')}\n`);
      selectedMotion = await ask(rl, 'Enter motion slug: ');
    } else {
      const idx = parseInt(choice) - 1;
      if (idx >= 0 && idx < 3) {
        selectedMotion = motionNameToSlug(top3[idx].name);
      }
    }
  } else {
    // No scorecard found — show all motions
    console.log('No SC5 scorecard found. Showing all available motions:\n');
    const slugs = Object.keys(ALL_MOTIONS);
    slugs.forEach((slug, i) => {
      const hasAssets = MOTION_ASSETS[slug] ? '' : ' [no builder assets yet]';
      console.log(`  [${i + 1}] ${ALL_MOTIONS[slug]} (${slug})${hasAssets}`);
    });
    console.log(`  [${slugs.length + 1}] Build ALL motions (legacy mode)\n`);

    const choice = await ask(rl, `Pick a number (1-${slugs.length + 1}): `);
    const idx = parseInt(choice) - 1;
    if (idx >= 0 && idx < slugs.length) {
      selectedMotion = slugs[idx];
    } else {
      selectedMotion = 'all';
    }
  }

  if (!selectedMotion) {
    console.log('\nNo valid selection. Defaulting to top motion.');
    selectedMotion = motions ? motionNameToSlug(motions[0].name) : 'dream-100';
  }

  console.log(`\n✓ Selected motion: ${ALL_MOTIONS[selectedMotion] || selectedMotion}\n`);

  // ── Step 2: Collect brand colors ──

  console.log('BRAND COLORS');
  console.log('Give me 2-4 colors for your brand. Examples:');
  console.log('  "#FF6B00, #1A1A2E, #D4A853, #FFFFFF"');
  console.log('  "black, orange" (I\'ll pick hex codes)');
  console.log('  Press Enter for default EO MENA palette\n');

  const colorsInput = await ask(rl, 'Your brand colors: ');
  let customerColors = null;

  if (colorsInput) {
    customerColors = parseColorInput(colorsInput);
    if (customerColors.length > 0) {
      console.log(`\n✓ Brand colors: ${customerColors.join(', ')}`);
    } else {
      console.log('\n✓ Using default EO MENA palette');
    }
  } else {
    console.log('\n✓ Using default EO MENA palette');
  }

  // ── Step 3: Language preference ──

  console.log('\nLANGUAGE PREFERENCE');
  console.log('  [1] English only');
  console.log('  [2] Arabic only');
  console.log('  [3] Both English and Arabic\n');

  const langChoice = await ask(rl, 'Pick (1/2/3): ');
  let lang = 'en';
  if (langChoice === '2') lang = 'ar';
  else if (langChoice === '3') lang = 'both';

  const langNames = { en: 'English', ar: 'Arabic', both: 'Both English & Arabic' };
  console.log(`\n✓ Language: ${langNames[lang]}`);

  // ── Step 4: Confirm ──

  const motionName = ALL_MOTIONS[selectedMotion] || selectedMotion;
  const motionAssetCount = MOTION_ASSETS[selectedMotion]
    ? Object.keys(MOTION_ASSETS[selectedMotion]).length
    : 0;

  console.log('\n┌─────────────────────────────────────────────┐');
  console.log('│            PRODUCTION PLAN                   │');
  console.log('├─────────────────────────────────────────────┤');
  console.log(`│  GTM Motion:  ${motionName}`);
  console.log(`│  Colors:      ${customerColors ? customerColors.join(' / ') : 'Default EO MENA'}`);
  console.log(`│  Language:    ${langNames[lang]}`);
  console.log('│                                             │');
  console.log('│  CORE ASSETS (always produced):             │');
  console.log('│    ✓ Company one-pager (DOCX)               │');
  console.log('│    ✓ Positioning statement (DOCX)           │');
  console.log('│    ✓ ICP targeting brief (DOCX)             │');
  console.log('│    ✓ Messaging framework (DOCX)             │');
  console.log('│    ✓ Landing page (HTML)                    │');
  console.log('│                                             │');
  console.log(`│  MOTION ASSETS: ${motionAssetCount} files for ${selectedMotion}`);
  console.log('└─────────────────────────────────────────────┘\n');

  const confirm = await ask(rl, 'Ready to generate? (yes/no): ');
  rl.close();

  if (confirm.toLowerCase() !== 'yes' && confirm.toLowerCase() !== 'y') {
    console.log('\nAborted. Run again when ready.');
    process.exit(0);
  }

  return { motion: selectedMotion, colors: customerColors, lang };
}

/**
 * Parse user color input — handles hex codes, named colors, and mixed formats
 */
function parseColorInput(input) {
  const colors = [];

  // Named color map
  const namedColors = {
    black: '#000000', white: '#FFFFFF', red: '#EF4444', blue: '#3B82F6',
    green: '#22C55E', orange: '#FF6600', yellow: '#EAB308', purple: '#8B5CF6',
    pink: '#EC4899', gray: '#6B7280', grey: '#6B7280', navy: '#1E3A5F',
    gold: '#D4A853', cream: '#FDF8F0', teal: '#14B8A6', indigo: '#6366F1',
    'dark navy': '#1A1A2E', 'dark blue': '#1E3A5F', 'dark gray': '#374151',
    'light gray': '#F3F4F6', 'bright orange': '#FF6B00',
  };

  // Split by comma and process each part
  const parts = input.split(',').map(p => p.trim().toLowerCase());
  for (const part of parts) {
    // Check for hex code
    const hexMatch = part.match(/#?([0-9a-f]{6})/i);
    if (hexMatch) {
      colors.push('#' + hexMatch[1].toUpperCase());
      continue;
    }

    // Check named colors
    if (namedColors[part]) {
      colors.push(namedColors[part]);
      continue;
    }

    // Try partial match
    const match = Object.keys(namedColors).find(n => part.includes(n));
    if (match) {
      colors.push(namedColors[match]);
    }
  }

  return colors;
}

// ─── Build Engine ────────────────────────────────────────────────────────

async function build(selectedMotion, customerColors, lang) {
  const brand = buildBrand(customerColors);

  console.log('\n=== EO GTM Asset Builder v2 ===\n');
  console.log(`Input:   ${ASSETS_DIR}`);
  console.log(`Output:  ${OUTPUT_DIR}`);
  console.log(`Motion:  ${selectedMotion}`);
  console.log(`Lang:    ${lang}`);
  console.log(`Colors:  ${brand.colors.primary} / ${brand.colors.dark} / ${brand.colors.accent}\n`);

  // Validate inputs
  if (!fs.existsSync(ASSETS_DIR)) {
    console.error(`ERROR: Assets directory not found: ${ASSETS_DIR}`);
    process.exit(1);
  }

  // Ensure output directories exist
  for (const dir of [OUTPUT_DIR, WORKSPACE_OUTPUT]) {
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  }

  // Build production map
  let productionMap = { ...CORE_ASSETS };

  if (selectedMotion === 'all') {
    for (const motionAssets of Object.values(MOTION_ASSETS)) {
      Object.assign(productionMap, motionAssets);
    }
  } else if (MOTION_ASSETS[selectedMotion]) {
    Object.assign(productionMap, MOTION_ASSETS[selectedMotion]);
  } else {
    console.warn(`WARNING: No builder assets for "${selectedMotion}". Building core assets only.`);
    console.log(`Motions with assets: ${Object.keys(MOTION_ASSETS).join(', ')}\n`);
  }

  const results = [];
  const errors = [];
  let processed = 0;
  const total = Object.keys(productionMap).length;

  console.log(`--- Building ${total} assets ---\n`);

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

  // Landing page
  console.log('\n--- Landing Page ---\n');
  try {
    const onePagerPath = path.join(ASSETS_DIR, 'core', 'one-pager.md');
    const templateToUse = fs.existsSync(LANDING_TEMPLATE) ? LANDING_TEMPLATE : BASE_TEMPLATE;
    if (fs.existsSync(onePagerPath) && fs.existsSync(templateToUse)) {
      const result = buildLandingPage(onePagerPath, OUTPUT_DIR, templateToUse, brand, lang);
      results.push(result);
      console.log(`  LAND ${result.file} (${formatSize(result.size)})`);
    } else {
      console.log('  SKIP landing page (one-pager.md or template not found)');
    }
  } catch (err) {
    console.error(`  ERROR landing page: ${err.message}`);
    errors.push({ file: 'landing-page.html', error: err.message });
  }

  // Quality gates
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

  // Save brand config
  fs.writeFileSync(path.join(OUTPUT_DIR, 'brand-config.json'), JSON.stringify({
    colors: brand.colors,
    fonts: brand.fonts,
    lang,
    motion: selectedMotion,
    generated: new Date().toISOString(),
  }, null, 2));

  // Summary
  console.log('\n=== BUILD COMPLETE ===\n');
  console.log(`  Motion:  ${ALL_MOTIONS[selectedMotion] || selectedMotion}`);
  console.log(`  Lang:    ${lang}`);
  console.log(`  Colors:  ${brand.colors.primary} / ${brand.colors.dark} / ${brand.colors.accent}`);
  console.log(`  Files:   ${results.length}`);
  console.log(`  Errors:  ${errors.length}`);
  console.log(`  Quality: ${validation.summary}`);
  console.log(`  Output:  ${OUTPUT_DIR}\n`);

  const byType = {};
  for (const r of results) byType[r.type] = (byType[r.type] || 0) + 1;
  for (const [type, count] of Object.entries(byType)) {
    console.log(`  ${type.toUpperCase()}: ${count} files`);
  }

  if (errors.length > 0) {
    console.log('\nErrors:');
    for (const e of errors) console.log(`  - ${e.file}: ${e.error}`);
    process.exit(1);
  }
}

// ─── Entry Point ─────────────────────────────────────────────────────────

async function main() {
  // Check if all required args are provided (CLI mode) or need interactive prompts
  const hasMotion = args.motion;
  const hasColors = args.colors;
  const hasLang = args.lang;

  if (hasMotion && hasColors && hasLang) {
    // Full CLI mode — no prompts needed
    const customerColors = args.colors.split(',').map(c => c.trim());
    await build(args.motion, customerColors, args.lang);
  } else if (hasMotion && !hasColors && !hasLang) {
    // Partial CLI — motion provided but missing colors/lang, use defaults
    await build(args.motion, null, 'en');
  } else {
    // Interactive mode — prompt for everything missing
    const { motion, colors, lang } = await runInteractive();
    await build(motion, colors, lang);
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
