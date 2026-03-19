// XLSX Builder - Target lists, content calendars, distribution matrices
// Reads MD blueprints, renders branded Excel spreadsheets

const fs = require('fs');
const path = require('path');
const ExcelJS = require('exceljs');
const { parseBlueprint } = require('../utils/md-parser');
const brand = require('../utils/brand');

/**
 * Build an XLSX from a markdown blueprint containing tables/lists
 */
async function buildXlsx(inputPath, outputDir) {
  const blueprint = parseBlueprint(inputPath);
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Entrepreneurs Oasis MENA';
  workbook.created = new Date();

  // Collect all tables from all sections
  const allTables = [];
  for (const section of blueprint.sections) {
    for (const table of section.tables) {
      allTables.push({ title: section.title, ...table });
    }
  }

  if (allTables.length > 0) {
    // Create a worksheet per table (or combine small ones)
    for (const table of allTables) {
      const sheetName = sanitizeSheetName(table.title);
      const sheet = workbook.addWorksheet(sheetName);

      // Style header row
      sheet.addRow(table.headers);
      const headerRow = sheet.getRow(1);
      headerRow.eachCell(cell => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF' + brand.docxColors.dark } };
        cell.font = { bold: true, color: { argb: 'FFFFFFFF' }, name: brand.fonts.en, size: 11 };
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
        cell.border = borderStyle();
      });
      headerRow.height = 28;

      // Data rows
      table.rows.forEach((row, idx) => {
        sheet.addRow(row);
        const dataRow = sheet.getRow(idx + 2);
        dataRow.eachCell(cell => {
          cell.font = { name: brand.fonts.en, size: 10, color: { argb: 'FF' + brand.docxColors.text } };
          cell.alignment = { vertical: 'middle', wrapText: true };
          cell.border = borderStyle();
          if (idx % 2 === 0) {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFDF8F0' } };
          }
        });
      });

      // Auto-width columns
      sheet.columns.forEach((col, i) => {
        const maxLen = Math.max(
          (table.headers[i] || '').length,
          ...table.rows.map(r => (r[i] || '').length)
        );
        col.width = Math.min(Math.max(maxLen + 4, 12), 40);
      });

      // Freeze header row
      sheet.views = [{ state: 'frozen', ySplit: 1 }];
    }
  } else {
    // No tables found - create a sheet from lists
    const sheet = workbook.addWorksheet('Data');
    let rowNum = 1;

    for (const section of blueprint.sections) {
      // Section header
      sheet.addRow([section.title]);
      const sectionRow = sheet.getRow(rowNum);
      sectionRow.getCell(1).font = { bold: true, size: 12, color: { argb: 'FF' + brand.docxColors.primary }, name: brand.fonts.en };
      rowNum++;

      for (const list of section.lists) {
        for (const item of list) {
          sheet.addRow(['', item]);
          const itemRow = sheet.getRow(rowNum);
          itemRow.getCell(2).font = { name: brand.fonts.en, size: 10, color: { argb: 'FF' + brand.docxColors.text } };
          rowNum++;
        }
      }

      // Empty row between sections
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
  // Excel sheet names: max 31 chars, no special chars
  return name.replace(/[\\/*?:\[\]]/g, '').substring(0, 31);
}

module.exports = { buildXlsx };
