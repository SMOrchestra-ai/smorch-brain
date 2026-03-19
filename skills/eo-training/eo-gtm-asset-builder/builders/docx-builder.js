// DOCX Builder - One-pagers, scripts, playbooks, guides
// Reads MD blueprints, renders branded Word documents

const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel,
  Table, TableRow, TableCell, WidthType, BorderStyle,
  AlignmentType, ShadingType, TabStopType, TabStopPosition,
} = require('docx');
const { parseBlueprint } = require('../utils/md-parser');
const brand = require('../utils/brand');

/**
 * Build a DOCX from a markdown blueprint
 */
async function buildDocx(inputPath, outputDir) {
  const blueprint = parseBlueprint(inputPath);
  const children = [];

  // Title
  children.push(
    new Paragraph({
      children: [new TextRun({ text: blueprint.title, bold: true, size: 36, color: brand.docxColors.dark, font: brand.fonts.en })],
      heading: HeadingLevel.TITLE,
      spacing: { after: 100 },
    })
  );

  // Orange accent line
  children.push(
    new Paragraph({
      children: [new TextRun({ text: '                              ', color: brand.docxColors.primary })],
      border: { bottom: { color: brand.docxColors.primary, size: 6, style: BorderStyle.SINGLE } },
      spacing: { after: 300 },
    })
  );

  // Process sections
  for (const section of blueprint.sections) {
    // Section heading
    const headingLevel = section.level === 2 ? HeadingLevel.HEADING_1 : HeadingLevel.HEADING_2;
    children.push(
      new Paragraph({
        children: [new TextRun({
          text: section.title,
          bold: true,
          size: section.level === 2 ? 28 : 24,
          color: section.level === 2 ? brand.docxColors.primary : brand.docxColors.dark,
          font: brand.fonts.en,
        })],
        heading: headingLevel,
        spacing: { before: 300, after: 120 },
      })
    );

    // Section text content
    if (section.text) {
      const paragraphs = section.text.split('\n').filter(l => l.trim());
      for (const para of paragraphs) {
        children.push(buildParagraph(para));
      }
    }

    // Tables
    for (const table of section.tables) {
      children.push(buildTable(table));
      children.push(new Paragraph({ spacing: { after: 200 } }));
    }

    // Lists
    for (const list of section.lists) {
      for (const item of list) {
        children.push(
          new Paragraph({
            children: [new TextRun({ text: item, size: 22, font: brand.fonts.en, color: brand.docxColors.text })],
            bullet: { level: 0 },
            spacing: { after: 60 },
          })
        );
      }
      children.push(new Paragraph({ spacing: { after: 120 } }));
    }
  }

  // Footer
  children.push(
    new Paragraph({
      children: [new TextRun({
        text: 'Entrepreneurs Oasis MENA - Signal-Verified Launch Platform',
        size: 16, color: brand.docxColors.secondary, font: brand.fonts.en, italics: true,
      })],
      spacing: { before: 600 },
      border: { top: { color: brand.docxColors.secondary, size: 1, style: BorderStyle.SINGLE } },
    })
  );

  const doc = new Document({
    styles: {
      default: {
        document: {
          run: { font: brand.fonts.en, size: 22, color: brand.docxColors.text },
          paragraph: { spacing: { line: 360 } },
        },
      },
    },
    sections: [{ children }],
  });

  const buffer = await Packer.toBuffer(doc);
  const filename = path.basename(inputPath, '.md') + '.docx';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, buffer);

  return { file: filename, type: 'docx', size: buffer.length };
}

function buildParagraph(text) {
  const runs = [];
  // Handle bold markers
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  for (const part of parts) {
    if (part.startsWith('**') && part.endsWith('**')) {
      runs.push(new TextRun({
        text: part.slice(2, -2),
        bold: true, size: 22, font: brand.fonts.en, color: brand.docxColors.dark,
      }));
    } else if (part.trim()) {
      runs.push(new TextRun({
        text: part, size: 22, font: brand.fonts.en, color: brand.docxColors.text,
      }));
    }
  }

  return new Paragraph({ children: runs, spacing: { after: 120 } });
}

function buildTable(tableData) {
  const rows = [];

  // Header row
  rows.push(
    new TableRow({
      children: tableData.headers.map(h =>
        new TableCell({
          children: [new Paragraph({
            children: [new TextRun({ text: h, bold: true, size: 20, color: 'FFFFFF', font: brand.fonts.en })],
          })],
          shading: { fill: brand.docxColors.dark, type: ShadingType.SOLID },
          width: { size: Math.floor(100 / tableData.headers.length), type: WidthType.PERCENTAGE },
        })
      ),
    })
  );

  // Data rows
  tableData.rows.forEach((row, idx) => {
    rows.push(
      new TableRow({
        children: row.map(cell =>
          new TableCell({
            children: [new Paragraph({
              children: [new TextRun({ text: cell, size: 20, font: brand.fonts.en, color: brand.docxColors.text })],
            })],
            shading: idx % 2 === 0 ? { fill: 'FDF8F0', type: ShadingType.SOLID } : undefined,
          })
        ),
      })
    );
  });

  return new Table({ rows, width: { size: 100, type: WidthType.PERCENTAGE } });
}

module.exports = { buildDocx };
