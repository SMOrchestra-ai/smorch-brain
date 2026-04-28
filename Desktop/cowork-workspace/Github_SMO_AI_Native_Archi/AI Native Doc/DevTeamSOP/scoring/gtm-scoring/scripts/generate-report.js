#!/usr/bin/env node
/**
 * SMOrchestra.ai Score Report Generator
 *
 * Reads score JSON files from the scores/ directory and produces
 * a professionally formatted Word document (.docx) report.
 *
 * Usage:
 *   node generate-report.js [campaign-name|latest]
 *
 * Dependencies:
 *   npm install docx
 *
 * Output:
 *   [campaign-name]-score-report-[date].docx in the workspace root
 */

const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  WidthType, AlignmentType, HeadingLevel, BorderStyle, ShadingType,
  Header, Footer, PageNumber, NumberFormat, TableOfContents,
  convertInchesToTwip
} = require('docx');

// Brand colors
const NAVY = '1B2A4A';
const ORANGE = 'FF6600';
const WHITE = 'FFFFFF';
const GREEN = '2E7D32';
const BLUE = '1565C0';
const AMBER = 'F57F17';
const RED = 'C62828';
const LIGHT_GRAY = 'F5F5F5';

function getScoreColor(score) {
  if (score >= 9.0) return GREEN;
  if (score >= 7.5) return BLUE;
  if (score >= 6.0) return AMBER;
  return RED;
}

function getVerdict(score) {
  if (score >= 9.0) return 'ELITE';
  if (score >= 7.5) return 'STRONG';
  if (score >= 6.0) return 'ACCEPTABLE';
  if (score >= 4.0) return 'BELOW STANDARD';
  return 'FAILED';
}

function getVerdictAction(score) {
  if (score >= 9.0) return 'SHIP';
  if (score >= 7.5) return 'TWEAK';
  if (score >= 6.0) return 'IMPROVE';
  if (score >= 4.0) return 'REWORK';
  return 'RESTART';
}

function getPriority(score, hardStops) {
  if (hardStops && hardStops.length > 0) return 'P0: EMERGENCY';
  if (score < 6.0) return 'P1: CRITICAL';
  if (score < 7.0) return 'P2: HIGH';
  if (score < 7.5) return 'P4: LOW';
  if (score < 8.5) return 'P5: OPTIMIZATION';
  return 'P6: MAINTENANCE';
}

// Load score files
function loadScores(arg) {
  const scoresDir = path.join(process.cwd(), 'scores');
  if (!fs.existsSync(scoresDir)) {
    console.error('No scores/ directory found. Run /score or /score-all first.');
    process.exit(1);
  }

  const files = fs.readdirSync(scoresDir)
    .filter(f => f.endsWith('.json'))
    .sort((a, b) => fs.statSync(path.join(scoresDir, b)).mtime - fs.statSync(path.join(scoresDir, a)).mtime);

  if (files.length === 0) {
    console.error('No score JSON files found. Run /score or /score-all first.');
    process.exit(1);
  }

  let selected;
  if (!arg || arg === 'latest') {
    // Get the most recent file, or all files from the most recent date
    const latestFile = files[0];
    const latestDate = JSON.parse(fs.readFileSync(path.join(scoresDir, latestFile), 'utf8')).date;
    selected = files.filter(f => {
      const data = JSON.parse(fs.readFileSync(path.join(scoresDir, f), 'utf8'));
      return data.date === latestDate;
    });
  } else {
    // Match campaign name
    selected = files.filter(f => f.toLowerCase().includes(arg.toLowerCase()));
  }

  return selected.map(f => JSON.parse(fs.readFileSync(path.join(scoresDir, f), 'utf8')));
}

// Build table helper
function buildCriteriaTable(criteria) {
  const headerRow = new TableRow({
    tableHeader: true,
    children: ['#', 'Criterion', 'Weight', 'Score', 'Status'].map(text =>
      new TableCell({
        shading: { type: ShadingType.SOLID, color: NAVY },
        children: [new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text, bold: true, color: WHITE, size: 20, font: 'Calibri' })]
        })]
      })
    )
  });

  const rows = criteria.map((c, i) => {
    const scoreColor = getScoreColor(c.score);
    const statusText = c.status || (c.score >= 7.0 ? 'OK' : c.score >= 5.0 ? 'FIX' : 'HARD STOP');
    return new TableRow({
      children: [
        new TableCell({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: c.id || `C${i+1}`, size: 20, font: 'Calibri' })] })] }),
        new TableCell({ children: [new Paragraph({ children: [new TextRun({ text: c.name, size: 20, font: 'Calibri' })] })] }),
        new TableCell({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: `${c.weight}%`, size: 20, font: 'Calibri' })] })] }),
        new TableCell({
          shading: { type: ShadingType.SOLID, color: scoreColor },
          children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: c.score.toFixed(1), bold: true, color: WHITE, size: 20, font: 'Calibri' })] })]
        }),
        new TableCell({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: statusText, bold: statusText === 'HARD STOP', color: statusText === 'HARD STOP' ? RED : '333333', size: 20, font: 'Calibri' })] })] })
      ]
    });
  });

  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [headerRow, ...rows]
  });
}

async function generateReport(scores) {
  const campaignName = scores[0]?.deliverable || 'Campaign';
  const date = scores[0]?.date || new Date().toISOString().split('T')[0];

  // Calculate composite if multiple systems
  let compositeScore = null;
  if (scores.length > 1) {
    const total = scores.reduce((sum, s) => sum + s.overall_score, 0);
    compositeScore = total / scores.length;
  }

  const overallScore = compositeScore || scores[0]?.overall_score || 0;
  const scoreColor = getScoreColor(overallScore);
  const allHardStops = scores.flatMap(s => (s.hard_stops || []).map(hs => `${s.system}: ${hs}`));

  const sections = [];

  // Cover page content
  sections.push(
    new Paragraph({ spacing: { before: 3000 }, children: [] }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: 'SMOrchestra.ai', size: 48, bold: true, color: NAVY, font: 'Calibri' })]
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: 'Quality Gate Score Report', size: 36, color: ORANGE, font: 'Calibri' })]
    }),
    new Paragraph({ spacing: { before: 600 }, children: [] }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: campaignName, size: 32, bold: true, color: NAVY, font: 'Calibri' })]
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 200 },
      children: [new TextRun({ text: date, size: 24, color: '666666', font: 'Calibri' })]
    }),
    new Paragraph({ spacing: { before: 600 }, children: [] }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [
        new TextRun({ text: `Overall Score: ${overallScore.toFixed(1)} / 10`, size: 40, bold: true, color: scoreColor, font: 'Calibri' })
      ]
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 200 },
      children: [new TextRun({ text: getVerdict(overallScore), size: 28, bold: true, color: scoreColor, font: 'Calibri' })]
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 100 },
      children: [new TextRun({ text: `Action: ${getVerdictAction(overallScore)}`, size: 24, color: '666666', font: 'Calibri' })]
    }),
    new Paragraph({ spacing: { before: 200 }, children: [] }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: `Priority: ${getPriority(overallScore, allHardStops)}`, size: 24, bold: true, color: allHardStops.length > 0 ? RED : NAVY, font: 'Calibri' })]
    })
  );

  // Page break before executive summary
  sections.push(new Paragraph({ pageBreakBefore: true, children: [] }));

  // Executive Summary
  sections.push(
    new Paragraph({
      heading: HeadingLevel.HEADING_1,
      children: [new TextRun({ text: 'Executive Summary', bold: true, color: NAVY, size: 28, font: 'Calibri' })]
    }),
    new Paragraph({ spacing: { before: 200 }, children: [] })
  );

  if (allHardStops.length > 0) {
    sections.push(
      new Paragraph({
        children: [
          new TextRun({ text: 'HARD STOPS DETECTED: ', bold: true, color: RED, size: 22, font: 'Calibri' }),
          new TextRun({ text: allHardStops.join('; '), color: RED, size: 22, font: 'Calibri' })
        ]
      }),
      new Paragraph({ spacing: { before: 100 }, children: [] })
    );
  }

  // System scores summary table (if multi-system)
  if (scores.length > 1) {
    const summaryHeader = new TableRow({
      tableHeader: true,
      children: ['System', 'Score', 'Verdict', 'Hard Stops'].map(text =>
        new TableCell({
          shading: { type: ShadingType.SOLID, color: NAVY },
          children: [new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [new TextRun({ text, bold: true, color: WHITE, size: 20, font: 'Calibri' })]
          })]
        })
      )
    });

    const summaryRows = scores.map(s => {
      const sc = getScoreColor(s.overall_score);
      return new TableRow({
        children: [
          new TableCell({ children: [new Paragraph({ children: [new TextRun({ text: s.system || 'Unknown', size: 20, font: 'Calibri' })] })] }),
          new TableCell({
            shading: { type: ShadingType.SOLID, color: sc },
            children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: s.overall_score.toFixed(1), bold: true, color: WHITE, size: 20, font: 'Calibri' })] })]
          }),
          new TableCell({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: getVerdict(s.overall_score), size: 20, font: 'Calibri' })] })] }),
          new TableCell({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: (s.hard_stops || []).length > 0 ? s.hard_stops.join(', ') : 'None', color: (s.hard_stops || []).length > 0 ? RED : '333333', size: 20, font: 'Calibri' })] })] })
        ]
      });
    });

    sections.push(new Table({
      width: { size: 100, type: WidthType.PERCENTAGE },
      rows: [summaryHeader, ...summaryRows]
    }));
    sections.push(new Paragraph({ spacing: { before: 200 }, children: [] }));
  }

  // System-by-system breakdown
  for (const score of scores) {
    sections.push(
      new Paragraph({ pageBreakBefore: true, children: [] }),
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun({ text: `System: ${score.system || 'Unknown'}${score.subsystem ? ` / ${score.subsystem}` : ''}`, bold: true, color: NAVY, size: 28, font: 'Calibri' })]
      }),
      new Paragraph({
        spacing: { before: 100 },
        children: [
          new TextRun({ text: `Score: ${score.overall_score.toFixed(1)} / 10`, bold: true, color: getScoreColor(score.overall_score), size: 24, font: 'Calibri' }),
          new TextRun({ text: `  |  Verdict: ${getVerdict(score.overall_score)}`, size: 24, color: '666666', font: 'Calibri' })
        ]
      }),
      new Paragraph({ spacing: { before: 200 }, children: [] })
    );

    if (score.criteria && score.criteria.length > 0) {
      sections.push(buildCriteriaTable(score.criteria));
    }

    // Top fixes
    const fixes = (score.criteria || [])
      .filter(c => c.score < 7.0 && c.fix_action)
      .sort((a, b) => (a.score - b.score) || (b.weight - a.weight))
      .slice(0, 3);

    if (fixes.length > 0) {
      sections.push(
        new Paragraph({ spacing: { before: 300 }, children: [] }),
        new Paragraph({
          heading: HeadingLevel.HEADING_2,
          children: [new TextRun({ text: 'Top Fix Actions', bold: true, color: ORANGE, size: 24, font: 'Calibri' })]
        })
      );
      fixes.forEach((fix, i) => {
        sections.push(new Paragraph({
          spacing: { before: 100 },
          children: [
            new TextRun({ text: `${i + 1}. ${fix.name} (${fix.score.toFixed(1)}): `, bold: true, size: 20, font: 'Calibri' }),
            new TextRun({ text: fix.fix_action, size: 20, font: 'Calibri' })
          ]
        }));
      });
    }
  }

  // Improvement Roadmap
  sections.push(
    new Paragraph({ pageBreakBefore: true, children: [] }),
    new Paragraph({
      heading: HeadingLevel.HEADING_1,
      children: [new TextRun({ text: 'Improvement Roadmap', bold: true, color: NAVY, size: 28, font: 'Calibri' })]
    }),
    new Paragraph({ spacing: { before: 200 }, children: [] })
  );

  const allFixes = scores.flatMap(s =>
    (s.criteria || [])
      .filter(c => c.score < 7.0 && c.fix_action)
      .map(c => ({ system: s.system, criterion: c.name, score: c.score, weight: c.weight, fix: c.fix_action }))
  ).sort((a, b) => a.score - b.score);

  if (allFixes.length > 0) {
    allFixes.forEach((fix, i) => {
      const priority = fix.score < 5.0 ? 'P0' : fix.score < 6.0 ? 'P1' : 'P2';
      sections.push(new Paragraph({
        spacing: { before: 100 },
        children: [
          new TextRun({ text: `[${priority}] `, bold: true, color: fix.score < 5.0 ? RED : fix.score < 6.0 ? AMBER : NAVY, size: 20, font: 'Calibri' }),
          new TextRun({ text: `${fix.system} > ${fix.criterion} (${fix.score.toFixed(1)}): `, bold: true, size: 20, font: 'Calibri' }),
          new TextRun({ text: fix.fix, size: 20, font: 'Calibri' })
        ]
      }));
    });
  } else {
    sections.push(new Paragraph({
      children: [new TextRun({ text: 'All criteria above 7.0. No mandatory fixes. Focus on optimization.', size: 22, color: GREEN, font: 'Calibri' })]
    }));
  }

  // Create document
  const doc = new Document({
    styles: {
      default: {
        document: { run: { font: 'Calibri', size: 22 } }
      }
    },
    sections: [{
      headers: {
        default: new Header({
          children: [new Paragraph({
            alignment: AlignmentType.RIGHT,
            children: [new TextRun({ text: 'SMOrchestra.ai Quality Gate Report', italics: true, color: '999999', size: 18, font: 'Calibri' })]
          })]
        })
      },
      footers: {
        default: new Footer({
          children: [new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
              new TextRun({ text: 'Page ', size: 18, font: 'Calibri' }),
              new TextRun({ children: [PageNumber.CURRENT], size: 18, font: 'Calibri' })
            ]
          })]
        })
      },
      children: sections
    }]
  });

  const filename = `${campaignName.replace(/[^a-zA-Z0-9]/g, '-').toLowerCase()}-score-report-${date}.docx`;
  const buffer = await Packer.toBuffer(doc);
  fs.writeFileSync(filename, buffer);
  console.log(`Report generated: ${filename}`);
  console.log(`Score: ${overallScore.toFixed(1)} / 10 | Verdict: ${getVerdict(overallScore)} | Priority: ${getPriority(overallScore, allHardStops)}`);
}

// Main
const arg = process.argv[2] || 'latest';
try {
  const scores = loadScores(arg);
  generateReport(scores).catch(err => {
    console.error('Error generating report:', err);
    process.exit(1);
  });
} catch (err) {
  console.error('Error:', err.message);
  process.exit(1);
}
