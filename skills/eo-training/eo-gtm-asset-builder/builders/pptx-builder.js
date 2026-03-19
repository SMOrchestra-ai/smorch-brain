// PPTX Builder v2 — Per-customer brand colors
// Reads MD blueprints, renders branded PowerPoint presentations

const fs = require('fs');
const path = require('path');
const PptxGenJS = require('pptxgenjs');
const { parseBlueprint } = require('../utils/md-parser');

/**
 * Build a PPTX from a markdown blueprint
 * @param {string} inputPath - Path to MD file
 * @param {string} outputDir - Output directory
 * @param {object} brand - Brand config with pptxColors, fonts
 */
async function buildPptx(inputPath, outputDir, brand) {
  const blueprint = parseBlueprint(inputPath);
  const pptx = new PptxGenJS();
  const pc = brand.pptxColors;
  const fonts = brand.fonts;

  pptx.layout = 'LAYOUT_WIDE';
  pptx.author = 'EO GTM Asset Factory';
  pptx.title = blueprint.title;

  // Define slide masters with customer brand colors
  pptx.defineSlideMaster({
    title: 'TITLE',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 4.8, w: '100%', h: 0.06, fill: { color: pc.primary } } },
    ],
  });

  pptx.defineSlideMaster({
    title: 'SECTION',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 0, w: 0.08, h: '100%', fill: { color: pc.primary } } },
    ],
  });

  pptx.defineSlideMaster({
    title: 'CONTENT',
    background: { color: pc.white || 'FFFFFF' },
    objects: [
      { rect: { x: 0, y: 0, w: '100%', h: 0.04, fill: { color: pc.primary } } },
      { text: { text: blueprint.title, options: {
        x: 0.6, y: 4.9, w: 5, h: 0.3,
        fontSize: 8, fontFace: fonts.en, color: pc.secondary || '6B7280',
      }}},
    ],
  });

  pptx.defineSlideMaster({
    title: 'CLOSING',
    background: { color: pc.dark },
    objects: [
      { rect: { x: 0, y: 4.8, w: '100%', h: 0.06, fill: { color: pc.primary } } },
    ],
  });

  // Text style helpers
  const styles = {
    title: { fontSize: 32, fontFace: fonts.en, color: pc.white || 'FFFFFF', bold: true },
    subtitle: { fontSize: 16, fontFace: fonts.en, color: pc.secondary || '9CA3AF' },
    sectionTitle: { fontSize: 28, fontFace: fonts.en, color: pc.white || 'FFFFFF', bold: true },
    titleDark: { fontSize: 22, fontFace: fonts.en, color: pc.dark, bold: true },
    bodyDark: { fontSize: 13, fontFace: fonts.en, color: pc.text || '111827' },
    bullet: { fontSize: 12, fontFace: fonts.en, color: pc.text || '111827', bullet: { code: '2022' } },
  };

  // Slide 1: Title
  const titleSlide = pptx.addSlide({ masterName: 'TITLE' });
  titleSlide.addText(blueprint.title, {
    x: 0.6, y: 1.5, w: 8.8, h: 1.2, ...styles.title,
  });

  const subtitle = blueprint.sections[0]?.text?.split('\n')[0] || '';
  if (subtitle) {
    titleSlide.addText(subtitle, {
      x: 0.6, y: 3.4, w: 8.8, h: 0.6, ...styles.subtitle,
    });
  }

  // Process sections into slides
  let slideCount = 1;
  for (const section of blueprint.sections) {
    if (section.level === 2) {
      const sectionSlide = pptx.addSlide({ masterName: 'SECTION' });
      sectionSlide.addText(section.title, {
        x: 0.6, y: 1.8, w: 8.8, h: 1.5, ...styles.sectionTitle,
      });
      slideCount++;
    }

    if (section.text || section.lists.length > 0 || section.tables.length > 0) {
      const contentSlide = pptx.addSlide({ masterName: 'CONTENT' });
      contentSlide.addText(section.title, {
        x: 0.6, y: 0.3, w: 8.8, h: 0.6, ...styles.titleDark,
      });

      let yPos = 1.1;

      if (section.text) {
        const lines = section.text.split('\n').filter(l => l.trim()).slice(0, 6);
        contentSlide.addText(lines.join('\n'), {
          x: 0.6, y: yPos, w: 8.8, h: Math.min(lines.length * 0.4, 2),
          ...styles.bodyDark, valign: 'top',
        });
        yPos += Math.min(lines.length * 0.35, 1.8) + 0.2;
      }

      for (const list of section.lists) {
        const bulletItems = list.slice(0, 6).map(item => ({
          text: item,
          options: { ...styles.bullet, breakLine: true },
        }));

        if (bulletItems.length > 0) {
          contentSlide.addText(bulletItems, {
            x: 0.6, y: yPos, w: 8.8, h: Math.min(bulletItems.length * 0.35, 2.5),
            valign: 'top',
          });
          yPos += Math.min(bulletItems.length * 0.3, 2) + 0.2;
        }
      }

      for (const table of section.tables) {
        const tableRows = [];
        tableRows.push(table.headers.map(h => ({
          text: h, options: { bold: true, fontSize: 10, color: 'FFFFFF', fontFace: fonts.en },
        })));
        for (const row of table.rows.slice(0, 5)) {
          tableRows.push(row.map(cell => ({
            text: cell, options: { fontSize: 10, color: pc.dark, fontFace: fonts.en },
          })));
        }

        if (tableRows.length > 1) {
          contentSlide.addTable(tableRows, {
            x: 0.6, y: yPos, w: 8.8,
            border: { pt: 0.5, color: 'E5E7EB' },
            colW: Array(table.headers.length).fill(8.8 / table.headers.length),
            rowH: 0.35,
            autoPage: false,
          });
        }
      }

      slideCount++;
    }
  }

  // Closing slide
  const closingSlide = pptx.addSlide({ masterName: 'CLOSING' });
  closingSlide.addText('Thank You', {
    x: 0.6, y: 1.5, w: 8.8, h: 1,
    ...styles.title, fontSize: 36, align: 'center',
  });
  closingSlide.addText(blueprint.metadata.cta || 'Get Started', {
    x: 0.6, y: 2.8, w: 8.8, h: 0.5,
    ...styles.subtitle, align: 'center',
  });

  const filename = path.basename(inputPath, '.md') + '.pptx';
  const outputPath = path.join(outputDir, filename);
  await pptx.writeFile({ fileName: outputPath });

  const stats = fs.statSync(outputPath);
  return { file: filename, type: 'pptx', size: stats.size, slides: slideCount + 1 };
}

module.exports = { buildPptx };
