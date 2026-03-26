// DOCX Builder v3 — Rich structured Word documents with per-customer branding
// Produces executive-grade documents: branded headers, code block callouts,
// structured tables, numbered lists, section dividers, bold key phrases

const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel,
  Table, TableRow, TableCell, WidthType, BorderStyle,
  AlignmentType, ShadingType, TabStopPosition, TabStopType,
  PageBreak,
} = require('docx');
const { parseBlueprint, categorizeSection } = require('../utils/md-parser');

/**
 * Build a rich DOCX from a markdown blueprint
 */
async function buildDocx(inputPath, outputDir, brand) {
  const blueprint = parseBlueprint(inputPath);
  const children = [];
  const dc = brand.docxColors;
  const fonts = brand.fonts;

  // ── Cover / Header Block ──
  // Brand accent bar
  children.push(new Paragraph({
    children: [new TextRun({ text: ' ', size: 4 })],
    border: { bottom: { color: dc.primary, size: 12, style: BorderStyle.SINGLE } },
    spacing: { after: 200 },
  }));

  // Title
  children.push(new Paragraph({
    children: [new TextRun({
      text: blueprint.title,
      bold: true,
      size: 44,
      color: dc.dark,
      font: fonts.en,
    })],
    spacing: { after: 80 },
  }));

  // Subtitle if exists
  if (blueprint.subtitle) {
    children.push(new Paragraph({
      children: [new TextRun({
        text: blueprint.subtitle,
        size: 24,
        color: dc.secondary || '6B7280',
        font: fonts.en,
        italics: true,
      })],
      spacing: { after: 200 },
    }));
  }

  // Thin accent line under header
  children.push(new Paragraph({
    children: [new TextRun({ text: ' ', size: 4 })],
    border: { bottom: { color: dc.primary, size: 4, style: BorderStyle.SINGLE } },
    spacing: { after: 400 },
  }));

  // ── Process Sections ──
  for (let i = 0; i < blueprint.sections.length; i++) {
    const section = blueprint.sections[i];
    const category = categorizeSection(section.title);

    // Section heading with accent color for H2, dark for H3
    const isH2 = section.level === 2;
    children.push(new Paragraph({
      children: [new TextRun({
        text: section.title.toUpperCase(),
        bold: true,
        size: isH2 ? 28 : 24,
        color: isH2 ? dc.primary : dc.dark,
        font: fonts.en,
      })],
      heading: isH2 ? HeadingLevel.HEADING_1 : HeadingLevel.HEADING_2,
      spacing: { before: 400, after: 60 },
    }));

    // Section underline for H2
    if (isH2) {
      children.push(new Paragraph({
        children: [new TextRun({ text: ' ', size: 2 })],
        border: { bottom: { color: dc.primary, size: 2, style: BorderStyle.SINGLE } },
        spacing: { after: 200 },
      }));
    }

    // Body text — parse into rich paragraphs with bold handling
    if (section.text) {
      const paragraphs = section.text.split('\n').filter(l => l.trim());
      for (const para of paragraphs) {
        children.push(buildRichParagraph(para, dc, fonts));
      }
    }

    // Code blocks — render as styled callout boxes
    for (const block of section.codeBlocks) {
      children.push(new Paragraph({ spacing: { before: 120 } }));

      // Code block with background shading and left border
      const codeLines = block.code.split('\n');
      for (const codeLine of codeLines) {
        children.push(new Paragraph({
          children: [new TextRun({
            text: codeLine || ' ',
            size: 20,
            font: 'Courier New',
            color: dc.text,
          })],
          shading: { fill: dc.cream || 'FDF8F0', type: ShadingType.SOLID },
          border: {
            left: { color: dc.primary, size: 6, style: BorderStyle.SINGLE },
          },
          spacing: { after: 0, line: 280 },
          indent: { left: 200 },
        }));
      }
      children.push(new Paragraph({ spacing: { after: 200 } }));
    }

    // Tables — branded with header row
    for (const table of section.tables) {
      children.push(buildBrandedTable(table, dc, fonts));
      children.push(new Paragraph({ spacing: { after: 200 } }));
    }

    // Checklist items
    if (section.checklist.length > 0) {
      for (const item of section.checklist) {
        const checkChar = item.checked ? '☑' : '☐';
        children.push(new Paragraph({
          children: [
            new TextRun({ text: `${checkChar}  `, size: 22, font: fonts.en, color: dc.primary }),
            new TextRun({ text: item.text, size: 22, font: fonts.en, color: dc.text }),
          ],
          spacing: { after: 60 },
          indent: { left: 200 },
        }));
      }
      children.push(new Paragraph({ spacing: { after: 160 } }));
    }

    // Lists — numbered for sequences, bulleted for others
    for (const list of section.lists) {
      const isSequence = category === 'sequence' || section.title.match(/touch|step|sequence/i);

      for (let j = 0; j < list.length; j++) {
        const item = list[j];

        if (isSequence) {
          // Numbered step with accent number
          children.push(new Paragraph({
            children: [
              new TextRun({ text: `${j + 1}. `, bold: true, size: 22, color: dc.primary, font: fonts.en }),
              ...parseInlineBold(item, dc, fonts),
            ],
            spacing: { after: 80 },
            indent: { left: 200 },
          }));
        } else {
          // Bullet with accent arrow
          children.push(new Paragraph({
            children: [
              new TextRun({ text: '→  ', size: 22, color: dc.primary, font: fonts.en }),
              ...parseInlineBold(item, dc, fonts),
            ],
            spacing: { after: 60 },
            indent: { left: 200 },
          }));
        }
      }
      children.push(new Paragraph({ spacing: { after: 160 } }));
    }

    // Extra spacing between major sections
    if (isH2 && i < blueprint.sections.length - 1) {
      children.push(new Paragraph({ spacing: { after: 200 } }));
    }
  }

  // ── Footer ──
  children.push(new Paragraph({
    children: [new TextRun({ text: ' ', size: 2 })],
    border: { top: { color: dc.primary, size: 4, style: BorderStyle.SINGLE } },
    spacing: { before: 600 },
  }));

  children.push(new Paragraph({
    children: [new TextRun({
      text: `${blueprint.title} — Generated by EO GTM Asset Factory`,
      size: 16,
      color: dc.secondary || '6B7280',
      font: fonts.en,
      italics: true,
    })],
    spacing: { before: 100 },
  }));

  const doc = new Document({
    styles: {
      default: {
        document: {
          run: { font: fonts.en, size: 22, color: dc.text },
          paragraph: { spacing: { line: 340 } },
        },
      },
    },
    sections: [{
      properties: {
        page: {
          margin: { top: 1200, right: 1200, bottom: 1200, left: 1200 },
        },
      },
      children,
    }],
  });

  const buffer = await Packer.toBuffer(doc);
  const filename = path.basename(inputPath, '.md') + '.docx';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, buffer);

  return { file: filename, type: 'docx', size: buffer.length };
}

// ─── Helpers ──────────────────────────────────────────────────────────────

function buildRichParagraph(text, dc, fonts) {
  return new Paragraph({
    children: parseInlineBold(text, dc, fonts),
    spacing: { after: 120 },
  });
}

function parseInlineBold(text, dc, fonts) {
  const runs = [];
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  for (const part of parts) {
    if (part.startsWith('**') && part.endsWith('**')) {
      runs.push(new TextRun({
        text: part.slice(2, -2),
        bold: true,
        size: 22,
        font: fonts.en,
        color: dc.dark,
      }));
    } else if (part.trim()) {
      runs.push(new TextRun({
        text: part,
        size: 22,
        font: fonts.en,
        color: dc.text,
      }));
    }
  }
  return runs;
}

function buildBrandedTable(tableData, dc, fonts) {
  const rows = [];

  // Header row
  rows.push(new TableRow({
    children: tableData.headers.map(h =>
      new TableCell({
        children: [new Paragraph({
          children: [new TextRun({
            text: h,
            bold: true,
            size: 20,
            color: 'FFFFFF',
            font: fonts.en,
          })],
          alignment: AlignmentType.CENTER,
        })],
        shading: { fill: dc.dark, type: ShadingType.SOLID },
        width: { size: Math.floor(100 / tableData.headers.length), type: WidthType.PERCENTAGE },
        verticalAlign: 'center',
      })
    ),
    tableHeader: true,
  }));

  // Data rows with alternating background
  tableData.rows.forEach((row, idx) => {
    rows.push(new TableRow({
      children: row.map(cell =>
        new TableCell({
          children: [new Paragraph({
            children: parseInlineBold(cell, dc, fonts),
            spacing: { before: 40, after: 40 },
          })],
          shading: idx % 2 === 0
            ? { fill: dc.cream || 'FDF8F0', type: ShadingType.SOLID }
            : undefined,
          verticalAlign: 'center',
        })
      ),
    }));
  });

  return new Table({
    rows,
    width: { size: 100, type: WidthType.PERCENTAGE },
  });
}

module.exports = { buildDocx };
