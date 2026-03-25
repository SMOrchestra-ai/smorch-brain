// PPTX Builder v3 — Production-quality branded slide decks
// Intelligent section-to-slide mapping: title, section dividers, content,
// bullet slides, table slides, key metric slides, closing CTA

const fs = require('fs');
const path = require('path');
const PptxGenJS = require('pptxgenjs');
const { parseBlueprint, categorizeSection } = require('../utils/md-parser');

/**
 * Build a branded PPTX from a markdown blueprint
 */
async function buildPptx(inputPath, outputDir, brand) {
  const blueprint = parseBlueprint(inputPath);
  const pptx = new PptxGenJS();
  const pc = brand.pptxColors;
  const fonts = brand.fonts;

  pptx.layout = 'LAYOUT_WIDE';
  pptx.author = 'EO GTM Asset Factory';
  pptx.title = blueprint.title;

  // ── Define Slide Masters ──
  pptx.defineSlideMaster({
    title: 'TITLE_MASTER',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 5.0, w: '100%', h: 0.06, fill: { color: pc.primary } } },
      // Dot grid pattern overlay (subtle)
      { rect: { x: 0, y: 0, w: '100%', h: '100%', fill: { color: pc.dark, transparency: 95 } } },
    ],
  });

  pptx.defineSlideMaster({
    title: 'SECTION_MASTER',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 0, w: 0.1, h: '100%', fill: { color: pc.primary } } },
      { rect: { x: 0, y: 5.0, w: '100%', h: 0.06, fill: { color: pc.primary } } },
    ],
  });

  pptx.defineSlideMaster({
    title: 'CONTENT_MASTER',
    background: { color: pc.white || 'FFFFFF' },
    objects: [
      { rect: { x: 0, y: 0, w: '100%', h: 0.05, fill: { color: pc.primary } } },
      // Footer bar
      { rect: { x: 0, y: 5.3, w: '100%', h: 0.3, fill: { color: pc.dark } } },
      { text: { text: blueprint.title, options: {
        x: 0.5, y: 5.33, w: 8, h: 0.25,
        fontSize: 8, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
      }}},
    ],
  });

  pptx.defineSlideMaster({
    title: 'DARK_CONTENT',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 0, w: '100%', h: 0.05, fill: { color: pc.primary } } },
      // Footer
      { rect: { x: 0, y: 5.3, w: '100%', h: 0.3, fill: { color: '000000' } } },
      { text: { text: blueprint.title, options: {
        x: 0.5, y: 5.33, w: 8, h: 0.25,
        fontSize: 8, fontFace: fonts.en, color: '525252',
      }}},
    ],
  });

  pptx.defineSlideMaster({
    title: 'CLOSING_MASTER',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 5.0, w: '100%', h: 0.06, fill: { color: pc.primary } } },
    ],
  });

  // ── Slide 1: Title Slide ──
  const titleSlide = pptx.addSlide({ masterName: 'TITLE_MASTER' });

  // Brand pill
  titleSlide.addShape(pptx.ShapeType.roundRect, {
    x: 0.6, y: 1.0, w: 3.5, h: 0.4,
    fill: { color: pc.dark },
    line: { color: pc.primary, width: 1.5 },
    rectRadius: 0.2,
  });
  titleSlide.addText(blueprint.title.toUpperCase().substring(0, 35), {
    x: 0.6, y: 1.0, w: 3.5, h: 0.4,
    fontSize: 9, fontFace: fonts.en, color: pc.primary,
    bold: true, align: 'center',
    letterSpacing: 3,
  });

  // Main title
  titleSlide.addText(blueprint.title, {
    x: 0.6, y: 1.8, w: 9, h: 1.4,
    fontSize: 38, fontFace: fonts.en, color: pc.white || 'FFFFFF',
    bold: true, lineSpacing: 42,
  });

  // Subtitle
  const subtitle = blueprint.subtitle || '';
  if (subtitle) {
    titleSlide.addText(subtitle, {
      x: 0.6, y: 3.4, w: 9, h: 0.8,
      fontSize: 16, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
      lineSpacing: 22,
    });
  }

  // Accent bar under title
  titleSlide.addShape(pptx.ShapeType.rect, {
    x: 0.6, y: 4.4, w: 1.5, h: 0.06,
    fill: { color: pc.primary },
  });

  let slideCount = 1;

  // ── Process Sections ──
  for (let i = 0; i < blueprint.sections.length; i++) {
    const section = blueprint.sections[i];
    const category = categorizeSection(section.title);
    const isH2 = section.level === 2;

    // Section divider for H2 sections
    if (isH2) {
      const divider = pptx.addSlide({ masterName: 'SECTION_MASTER' });
      divider.addText(section.title, {
        x: 0.8, y: 1.5, w: 9, h: 1.5,
        fontSize: 32, fontFace: fonts.en, color: pc.white || 'FFFFFF',
        bold: true, lineSpacing: 38,
      });

      // Section subtitle from first line of text
      if (section.text) {
        const firstLine = section.text.split('\n')[0] || '';
        divider.addText(firstLine.substring(0, 150), {
          x: 0.8, y: 3.2, w: 9, h: 0.8,
          fontSize: 14, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
          lineSpacing: 20,
        });
      }
      slideCount++;
    }

    // Content slide based on category
    if (category === 'traction' || category === 'timing') {
      slideCount += buildMetricsSlide(pptx, section, pc, fonts);
    } else if (category === 'pricing') {
      slideCount += buildPricingSlide(pptx, section, pc, fonts);
    } else if (section.tables.length > 0) {
      slideCount += buildTableSlide(pptx, section, pc, fonts);
    } else if (section.codeBlocks.length > 0) {
      slideCount += buildTemplateSlide(pptx, section, pc, fonts);
    } else if (section.lists.length > 0 && getAllItems(section).length > 0) {
      slideCount += buildBulletSlide(pptx, section, pc, fonts);
    } else if (section.text) {
      slideCount += buildTextSlide(pptx, section, pc, fonts);
    }
  }

  // ── Closing Slide ──
  const closing = pptx.addSlide({ masterName: 'CLOSING_MASTER' });

  // CTA text
  const ctaText = blueprint.metadata.cta || 'Get Started';
  closing.addText('Ready?', {
    x: 0.6, y: 1.2, w: 9, h: 1,
    fontSize: 44, fontFace: fonts.en, color: pc.white || 'FFFFFF',
    bold: true, align: 'center',
  });

  closing.addText(ctaText, {
    x: 0.6, y: 2.5, w: 9, h: 0.6,
    fontSize: 18, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
    align: 'center',
  });

  // CTA button shape
  closing.addShape(pptx.ShapeType.roundRect, {
    x: 3.5, y: 3.5, w: 3.5, h: 0.6,
    fill: { color: pc.primary },
    rectRadius: 0.1,
  });
  closing.addText(`${ctaText} →`, {
    x: 3.5, y: 3.5, w: 3.5, h: 0.6,
    fontSize: 16, fontFace: fonts.en, color: pc.dark,
    bold: true, align: 'center', valign: 'middle',
  });

  // Accent bar
  closing.addShape(pptx.ShapeType.rect, {
    x: 4.5, y: 4.5, w: 1.5, h: 0.06,
    fill: { color: pc.primary },
  });

  slideCount++;

  const filename = path.basename(inputPath, '.md') + '.pptx';
  const outputPath = path.join(outputDir, filename);
  await pptx.writeFile({ fileName: outputPath });

  return { file: filename, type: 'pptx', size: fs.statSync(outputPath).size, slides: slideCount };
}

// ─── Slide Type Builders ──────────────────────────────────────────────────

function buildMetricsSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'DARK_CONTENT' });
  const items = getAllItems(section);
  const stats = section.stats || [];

  // Title
  slide.addText(section.title.toUpperCase(), {
    x: 0.5, y: 0.2, w: 9, h: 0.4,
    fontSize: 10, fontFace: fonts.en, color: pc.primary,
    bold: true, letterSpacing: 3,
  });

  // Extract metric items
  const metrics = [];
  for (const item of items) {
    const numMatch = item.match(/^([\d,.]+[+%]?(?:[-–/][\d,.]+[+%]?)?)\s+(.+)/);
    if (numMatch) {
      metrics.push({ number: numMatch[1], label: numMatch[2] });
    } else {
      metrics.push({ number: '→', label: item });
    }
  }

  // Use stats if no good metrics from lists
  const displayMetrics = metrics.length >= 2 ? metrics : [...stats, ...metrics];
  const toShow = displayMetrics.slice(0, 4);

  if (toShow.length > 0) {
    const colWidth = 9 / Math.min(toShow.length, 4);
    toShow.forEach((m, idx) => {
      const x = 0.5 + idx * colWidth;

      // Big number
      slide.addText(m.number, {
        x, y: 1.2, w: colWidth - 0.3, h: 1.2,
        fontSize: 44, fontFace: 'Courier New', color: pc.primary,
        bold: true, valign: 'bottom',
      });

      // Label
      slide.addText(m.label.substring(0, 50), {
        x, y: 2.5, w: colWidth - 0.3, h: 0.8,
        fontSize: 12, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
        valign: 'top', lineSpacing: 16,
      });
    });
  }

  // Text below metrics
  if (section.text) {
    slide.addText(section.text.substring(0, 250), {
      x: 0.5, y: 3.5, w: 9, h: 1.5,
      fontSize: 12, fontFace: fonts.en, color: pc.secondary || '9CA3AF',
      lineSpacing: 18, valign: 'top',
    });
  }

  return 1;
}

function buildBulletSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'CONTENT_MASTER' });
  const items = getAllItems(section);

  // Title
  slide.addText(section.title, {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, fontFace: fonts.en, color: pc.dark, bold: true,
  });

  // Text if exists
  let yPos = 1.0;
  if (section.text) {
    const lines = section.text.split('\n').filter(l => l.trim()).slice(0, 4);
    slide.addText(lines.join('\n'), {
      x: 0.5, y: yPos, w: 9, h: Math.min(lines.length * 0.35, 1.4),
      fontSize: 12, fontFace: fonts.en, color: pc.text || '111827',
      lineSpacing: 18, valign: 'top',
    });
    yPos += Math.min(lines.length * 0.3, 1.2) + 0.2;
  }

  // Bullet items — with accent arrows
  const bulletRows = items.slice(0, 8).map(item => {
    // Parse bold
    const cleanItem = item.replace(/\*\*/g, '');
    return [
      { text: '→  ', options: { fontSize: 12, fontFace: fonts.en, color: pc.primary, bold: true } },
      { text: cleanItem, options: { fontSize: 12, fontFace: fonts.en, color: pc.text || '111827', breakLine: true } },
    ];
  });

  if (bulletRows.length > 0) {
    slide.addText(bulletRows.flat(), {
      x: 0.5, y: yPos, w: 9, h: Math.min(bulletRows.length * 0.35, 3.5),
      valign: 'top', lineSpacing: 20,
    });
  }

  return 1;
}

function buildTextSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'CONTENT_MASTER' });

  // Title
  slide.addText(section.title, {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, fontFace: fonts.en, color: pc.dark, bold: true,
  });

  // Parse text into rich content — handle bold phrases
  const text = section.text || '';
  const paragraphs = text.split('\n').filter(l => l.trim()).slice(0, 10);

  const textRows = [];
  for (const para of paragraphs) {
    const parts = para.split(/(\*\*[^*]+\*\*)/g);
    for (const part of parts) {
      if (part.startsWith('**') && part.endsWith('**')) {
        textRows.push({
          text: part.slice(2, -2),
          options: { fontSize: 13, fontFace: fonts.en, color: pc.dark, bold: true },
        });
      } else if (part.trim()) {
        textRows.push({
          text: part,
          options: { fontSize: 13, fontFace: fonts.en, color: pc.text || '111827' },
        });
      }
    }
    textRows.push({ text: '\n', options: { fontSize: 8 } });
  }

  if (textRows.length > 0) {
    slide.addText(textRows, {
      x: 0.5, y: 1.0, w: 9, h: 3.8,
      valign: 'top', lineSpacing: 20,
    });
  }

  // Key points as accent callouts at bottom
  if (section.keyPoints && section.keyPoints.length > 0) {
    const kpText = section.keyPoints.slice(0, 3).map(kp => `→ ${kp}`).join('  |  ');
    slide.addShape(pptx.ShapeType.rect, {
      x: 0.5, y: 4.6, w: 9, h: 0.5,
      fill: { color: pc.primary, transparency: 90 },
    });
    slide.addText(kpText, {
      x: 0.6, y: 4.6, w: 8.8, h: 0.5,
      fontSize: 10, fontFace: fonts.en, color: pc.primary,
      bold: true, valign: 'middle',
    });
  }

  return 1;
}

function buildTableSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'CONTENT_MASTER' });
  const table = section.tables[0];

  // Title
  slide.addText(section.title, {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, fontFace: fonts.en, color: pc.dark, bold: true,
  });

  // Build table data
  const tableRows = [];

  // Header
  tableRows.push(table.headers.map(h => ({
    text: h,
    options: { bold: true, fontSize: 11, color: 'FFFFFF', fontFace: fonts.en, align: 'center' },
  })));

  // Data rows
  for (const row of table.rows.slice(0, 6)) {
    tableRows.push(row.map(cell => ({
      text: cell.replace(/\*\*/g, ''),
      options: { fontSize: 10, color: pc.dark, fontFace: fonts.en },
    })));
  }

  if (tableRows.length > 1) {
    const colW = Array(table.headers.length).fill(9 / table.headers.length);
    slide.addTable(tableRows, {
      x: 0.5, y: 1.0, w: 9,
      border: { pt: 0.5, color: 'E5E7EB' },
      colW,
      rowH: 0.4,
      autoPage: false,
      fill: { color: 'FFFFFF' },
    });

    // Color the header row
    // (PptxGenJS handles this via cell options, already set above)
  }

  return 1;
}

function buildTemplateSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'DARK_CONTENT' });
  const block = section.codeBlocks[0];

  // Title
  slide.addText(section.title, {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, fontFace: fonts.en, color: pc.white || 'FFFFFF', bold: true,
  });

  // Template text in a styled box
  slide.addShape(pptx.ShapeType.roundRect, {
    x: 0.5, y: 1.0, w: 9, h: 3.8,
    fill: { color: pc.dark, transparency: 50 },
    line: { color: pc.primary, width: 1 },
    rectRadius: 0.1,
  });

  // Code content
  const codeText = block.code.substring(0, 600);
  slide.addText(codeText, {
    x: 0.7, y: 1.1, w: 8.6, h: 3.6,
    fontSize: 11, fontFace: 'Courier New', color: pc.secondary || '9CA3AF',
    lineSpacing: 16, valign: 'top',
  });

  // Accent label
  slide.addText('TEMPLATE', {
    x: 0.5, y: 4.9, w: 2, h: 0.3,
    fontSize: 9, fontFace: fonts.en, color: pc.primary,
    bold: true, letterSpacing: 3,
  });

  return 1;
}

function buildPricingSlide(pptx, section, pc, fonts) {
  const slide = pptx.addSlide({ masterName: 'CONTENT_MASTER' });
  const tables = section.tables || [];

  slide.addText(section.title, {
    x: 0.5, y: 0.2, w: 9, h: 0.6,
    fontSize: 22, fontFace: fonts.en, color: pc.dark, bold: true,
  });

  if (tables.length > 0) {
    const table = tables[0];
    const colCount = Math.min(table.rows.length, 3);
    const cardWidth = 9 / colCount - 0.3;

    table.rows.slice(0, 3).forEach((row, idx) => {
      const x = 0.5 + idx * (cardWidth + 0.3);

      // Card background
      slide.addShape(pptx.ShapeType.roundRect, {
        x, y: 1.0, w: cardWidth, h: 3.8,
        fill: { color: 'FFFFFF' },
        line: { color: 'E5E5E5', width: 1 },
        rectRadius: 0.1,
      });

      // Accent top bar
      slide.addShape(pptx.ShapeType.rect, {
        x, y: 1.0, w: cardWidth, h: 0.06,
        fill: { color: pc.primary },
      });

      // Tier name
      slide.addText(row[0] || '', {
        x: x + 0.2, y: 1.3, w: cardWidth - 0.4, h: 0.4,
        fontSize: 14, fontFace: fonts.en, color: pc.dark, bold: true,
      });

      // Price
      slide.addText(row[1] || '', {
        x: x + 0.2, y: 1.8, w: cardWidth - 0.4, h: 0.6,
        fontSize: 28, fontFace: fonts.en, color: pc.primary, bold: true,
      });

      // Description
      const desc = row.slice(2).join(' · ');
      slide.addText(desc.substring(0, 120), {
        x: x + 0.2, y: 2.5, w: cardWidth - 0.4, h: 2,
        fontSize: 10, fontFace: fonts.en, color: pc.text || '525252',
        lineSpacing: 16, valign: 'top',
      });
    });
  }

  return 1;
}

// ─── Helpers ──────────────────────────────────────────────────────────────

function getAllItems(section) {
  const items = [];
  for (const list of (section.lists || [])) {
    items.push(...list);
  }
  return items;
}

module.exports = { buildPptx };
