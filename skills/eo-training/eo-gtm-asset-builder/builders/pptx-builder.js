// PPTX Builder - Webinar decks, pitch decks
// Reads MD blueprints, renders branded PowerPoint presentations

const fs = require('fs');
const path = require('path');
const PptxGenJS = require('pptxgenjs');
const { parseBlueprint } = require('../utils/md-parser');
const brand = require('../utils/brand');
const slideMaster = require('../templates/slide-master');

/**
 * Build a PPTX from a webinar/deck markdown blueprint
 */
async function buildPptx(inputPath, outputDir) {
  const blueprint = parseBlueprint(inputPath);
  const pptx = new PptxGenJS();

  pptx.layout = 'LAYOUT_WIDE';
  pptx.author = 'Entrepreneurs Oasis MENA';
  pptx.title = blueprint.title;

  // Define slide masters
  for (const [name, config] of Object.entries(slideMaster.masters)) {
    pptx.defineSlideMaster({
      title: name,
      background: config.background,
      objects: config.objects || [],
    });
  }

  // Slide 1: Title slide
  const titleSlide = pptx.addSlide({ masterName: 'TITLE' });
  titleSlide.addText(blueprint.title, {
    x: 0.6, y: 1.5, w: 8.8, h: 1.2,
    ...slideMaster.textStyles.title,
  });

  // Subtitle from first paragraph or metadata
  const subtitle = blueprint.sections[0]?.text?.split('\n')[0] || 'Signal-Verified Launch Platform';
  titleSlide.addText(subtitle, {
    x: 0.6, y: 3.4, w: 8.8, h: 0.6,
    ...slideMaster.textStyles.subtitle,
  });

  titleSlide.addText('Mamoun Alamouri | Entrepreneurs Oasis MENA', {
    x: 0.6, y: 4.4, w: 8.8, h: 0.4,
    fontSize: 12, fontFace: brand.fonts.en, color: brand.pptxColors.secondary,
  });

  // Process sections into slides
  let slideCount = 1;
  for (const section of blueprint.sections) {
    // Section header slides (H2)
    if (section.level === 2) {
      const sectionSlide = pptx.addSlide({ masterName: 'SECTION' });
      sectionSlide.addText(section.title, {
        x: 0.6, y: 1.8, w: 8.8, h: 1.5,
        ...slideMaster.textStyles.sectionTitle,
      });
      slideCount++;
    }

    // Content slides (H3 subsections or content within H2)
    if (section.text || section.lists.length > 0 || section.tables.length > 0) {
      const contentSlide = pptx.addSlide({ masterName: 'CONTENT' });

      // Title
      contentSlide.addText(section.title, {
        x: 0.6, y: 0.3, w: 8.8, h: 0.6,
        ...slideMaster.textStyles.titleDark,
        fontSize: 22,
      });

      // Body text
      let yPos = 1.1;

      if (section.text) {
        const lines = section.text.split('\n').filter(l => l.trim()).slice(0, 6);
        const bodyText = lines.join('\n');
        contentSlide.addText(bodyText, {
          x: 0.6, y: yPos, w: 8.8, h: Math.min(lines.length * 0.4, 2),
          ...slideMaster.textStyles.bodyDark,
          fontSize: 13,
          valign: 'top',
        });
        yPos += Math.min(lines.length * 0.35, 1.8) + 0.2;
      }

      // Bullet lists
      for (const list of section.lists) {
        const bulletItems = list.slice(0, 6).map(item => ({
          text: item,
          options: { ...slideMaster.textStyles.bullet, breakLine: true },
        }));

        if (bulletItems.length > 0) {
          contentSlide.addText(bulletItems, {
            x: 0.6, y: yPos, w: 8.8, h: Math.min(bulletItems.length * 0.35, 2.5),
            valign: 'top',
          });
          yPos += Math.min(bulletItems.length * 0.3, 2) + 0.2;
        }
      }

      // Tables (simplified for slides)
      for (const table of section.tables) {
        const tableRows = [];
        // Header
        tableRows.push(table.headers.map(h => ({
          text: h, options: { bold: true, fontSize: 10, color: 'FFFFFF', fontFace: brand.fonts.en },
        })));
        // Data (max 5 rows for readability)
        for (const row of table.rows.slice(0, 5)) {
          tableRows.push(row.map(cell => ({
            text: cell, options: { fontSize: 10, color: brand.pptxColors.dark, fontFace: brand.fonts.en },
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
    ...slideMaster.textStyles.title,
    fontSize: 36,
    align: 'center',
  });
  closingSlide.addText('Submit your product at entrepreneursoasis.com', {
    x: 0.6, y: 2.8, w: 8.8, h: 0.5,
    ...slideMaster.textStyles.subtitle,
    align: 'center',
  });
  closingSlide.addText('Mamoun Alamouri | @MamounAlamouri', {
    x: 0.6, y: 4.2, w: 8.8, h: 0.4,
    fontSize: 12, fontFace: brand.fonts.en, color: brand.pptxColors.secondary,
    align: 'center',
  });

  const filename = path.basename(inputPath, '.md') + '.pptx';
  const outputPath = path.join(outputDir, filename);
  await pptx.writeFile({ fileName: outputPath });

  const stats = fs.statSync(outputPath);
  return { file: filename, type: 'pptx', size: stats.size, slides: slideCount + 1 };
}

module.exports = { buildPptx };
