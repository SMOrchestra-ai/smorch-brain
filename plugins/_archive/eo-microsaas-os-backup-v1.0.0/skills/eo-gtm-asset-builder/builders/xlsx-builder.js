// XLSX Builder v2 — Per-customer brand colors
// Reads MD blueprints, renders branded Excel spreadsheets

const fs = require('fs');
const path = require('path');
const ExcelJS = require('exceljs');
const { parseBlueprint } = require('../utils/md-parser');

/**
 * Build an XLSX from a markdown blueprint
 * @param {string} inputPath - Path to MD file
 * @param {string} outputDir - Output directory
 * @param {object} brand - Brand config with docxColors, fonts
 */
async function buildXlsx(inputPath, outputDir, brand) {
  const blueprint = parseBlueprint(inputPath);
  const dc = brand.docxColors;
  const fonts = brand.fonts;
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'EO GTM Asset Factory';
  workbook.created = new Date();

  const allTables = [];
  for (const section of blueprint.sections) {
    for (const table of section.tables) {
      allTables.push({ title: section.title, ...table });
    }
  }

  if (allTables.length > 0) {
    for (const table of allTables) {
      const sheetName = sanitizeSheetName(table.title);
      const sheet = workbook.addWorksheet(sheetName);

      sheet.addRow(table.headers);
      const headerRow = sheet.getRow(1);
      headerRow.eachCell(cell => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + dc.dark } };
        cell.font = { bold: true, color: { argb: 'FFFFFFFF' }, name: fonts.en, size: 11 };
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
        cell.border = borderStyle();
      });
      headerRow.height = 28;

      table.rows.forEach((row, idx) => {
        sheet.addRow(row);
        const dataRow = sheet.getRow(idx + 2);
        dataRow.eachCell(cell => {
          cell.font = { name: fonts.en, size: 10, color: { argb: 'FF' + dc.text } };
          cell.alignment = { vertical: 'middle', wrapText: true };
          cell.border = borderStyle();
          if (idx % 2 === 0) {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + (dc.cream || 'FDF8F0') } };
          }
        });
      });

      sheet.columns.forEach((col, i) => {
        const maxLen = Math.max(
          (table.headers[i] || '').length,
          ...table.rows.map(r => (r[i] || '').length)
        );
        col.width = Math.min(Math.max(maxLen + 4, 12), 40);
      });

      sheet.views = [{ state: 'frozen', ySplit: 1 }];
    }
  } else {
    const sheet = workbook.addWorksheet('Data');
    let rowNum = 1;

    for (const section of blueprint.sections) {
      sheet.addRow([section.title]);
      const sectionRow = sheet.getRow(rowNum);
      sectionRow.getCell(1).font = { bold: true, size: 12, color: { argb: 'FF' + dc.primary }, name: fonts.en };
      rowNum++;

      for (const list of section.lists) {
        for (const item of list) {
          sheet.addRow(['', item]);
          const itemRow = sheet.getRow(rowNum);
          itemRow.getCell(2).font = { name: fonts.en, size: 10, color: { argb: 'FF' + dc.text } };
          rowNum++;
        }
      }

      sheet.addRow([]);
      rowNum++;
    }

    sheet.getColumn(1).width = 30;
    sheet.getColumn(2).width = 50;
  }

  const filename = path.basename(inputPath, '.md') + '.xlsx';
  const outputPath = path.join(outputDir, filename);
  await workbook.xlsx.writeFile(outputPath);

  return { file: filename, type: 'xlsx', size: fs.statSync(outputPath).size };
}

function borderStyle() {
  return {
    top: { style: 'thin', color: { argb: 'FFE5E7EB' } },
    left: { style: 'thin', color: { argb: 'FFE5E7EB' } },
    bottom: { style: 'thin', color: { argb: 'FFE5E7EB' } },
    right: { style: 'thin', color: { argb: 'FFE5E7EB' } },
  };
}

function sanitizeSheetName(name) {
  return name.replace(/[\\/*?:\[\]]/g, '').substring(0, 31);
}

module.exports = { buildXlsx };
