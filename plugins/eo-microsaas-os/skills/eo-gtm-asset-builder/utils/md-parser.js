// Markdown Blueprint Parser v3
// Extracts rich structured data: sections, tables, lists, code blocks, stats, pricing, qualifiers

const fs = require('fs');
const matter = require('gray-matter');
const { marked } = require('marked');

/**
 * Parse a markdown file into structured sections with rich content extraction
 * @param {string} filePath - Path to MD file
 * @returns {object} { metadata, title, subtitle, sections, raw, html }
 */
function parseBlueprint(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const { data: metadata, content: body } = matter(content);

  const lines = body.split('\n');
  const sections = [];
  let currentSection = null;
  let title = '';
  let subtitle = '';

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const h1Match = line.match(/^# (.+)/);
    const h2Match = line.match(/^## (.+)/);
    const h3Match = line.match(/^### (.+)/);

    if (h1Match && !title) {
      title = h1Match[1].trim();
      // Look ahead for subtitle (bold or italic line right after title)
      for (let j = i + 1; j < Math.min(i + 4, lines.length); j++) {
        const nextLine = lines[j].trim();
        if (nextLine.startsWith('**') && nextLine.endsWith('**')) {
          subtitle = nextLine.slice(2, -2);
          break;
        }
        if (nextLine.startsWith('*') && nextLine.endsWith('*') && !nextLine.startsWith('**')) {
          subtitle = nextLine.slice(1, -1);
          break;
        }
      }
      continue;
    }

    if (h2Match || h3Match) {
      if (currentSection) sections.push(currentSection);
      currentSection = {
        level: h2Match ? 2 : 3,
        title: (h2Match || h3Match)[1].trim(),
        content: [],
        tables: [],
        lists: [],
        codeBlocks: [],
        stats: [],       // Extracted numbers/stats
        checklist: [],    // Checkbox items
      };
      continue;
    }

    if (currentSection) {
      currentSection.content.push(line);
    }
  }

  if (currentSection) sections.push(currentSection);

  // Post-process sections
  for (const section of sections) {
    section.tables = extractTables(section.content);
    section.lists = extractLists(section.content);
    section.codeBlocks = extractCodeBlocks(section.content.join('\n'));
    section.stats = extractStats(section.content);
    section.checklist = extractChecklist(section.content);

    // Build text: exclude table rows, list items, code block lines, and checklist items
    const codeBlockRanges = getCodeBlockRanges(section.content);
    section.text = section.content
      .filter((l, idx) => {
        if (l.startsWith('|')) return false;
        if (l.match(/^[\s]*[-*]\s+/)) return false;
        if (l.match(/^[\s]*\d+\.\s+/)) return false;
        if (l.match(/^[\s]*[-*]\s*\[[ x]\]/i)) return false;
        if (l.trim() === '---') return false;
        if (l.trim() === '```' || l.trim().startsWith('```')) return false;
        if (codeBlockRanges.some(r => idx >= r.start && idx <= r.end)) return false;
        return l.trim() !== '';
      })
      .join('\n')
      .trim();

    // Extract bold phrases as key points
    section.keyPoints = extractBoldPhrases(section.text);
  }

  return {
    metadata,
    title,
    subtitle,
    sections,
    raw: body,
    html: marked(body),
  };
}

/**
 * Extract markdown tables
 */
function extractTables(lines) {
  const tables = [];
  let inTable = false;
  let currentTable = { headers: [], rows: [] };

  for (const line of lines) {
    if (line.startsWith('|')) {
      if (!inTable) {
        inTable = true;
        currentTable = { headers: [], rows: [] };
        currentTable.headers = line.split('|').filter(c => c.trim()).map(c => c.trim());
      } else if (line.match(/^\|[\s-:|]+\|$/)) {
        continue;
      } else {
        currentTable.rows.push(
          line.split('|').filter(c => c.trim()).map(c => c.trim())
        );
      }
    } else if (inTable) {
      inTable = false;
      if (currentTable.headers.length > 0) tables.push(currentTable);
    }
  }

  if (inTable && currentTable.headers.length > 0) tables.push(currentTable);
  return tables;
}

/**
 * Extract bullet/numbered lists
 */
function extractLists(lines) {
  const lists = [];
  let currentList = [];

  for (const line of lines) {
    // Skip checklist items (they're extracted separately)
    if (line.match(/^[\s]*[-*]\s*\[[ x]\]/i)) continue;

    const bulletMatch = line.match(/^[\s]*[-*]\s+(.+)/);
    const numberedMatch = line.match(/^[\s]*\d+\.\s+(.+)/);

    if (bulletMatch || numberedMatch) {
      currentList.push((bulletMatch || numberedMatch)[1].trim());
    } else if (currentList.length > 0) {
      lists.push([...currentList]);
      currentList = [];
    }
  }

  if (currentList.length > 0) lists.push(currentList);
  return lists;
}

/**
 * Extract code blocks from content string
 */
function extractCodeBlocks(content) {
  const blocks = [];
  const regex = /```(\w*)\n([\s\S]*?)```/g;
  let match;
  while ((match = regex.exec(content)) !== null) {
    blocks.push({ language: match[1], code: match[2].trim() });
  }
  return blocks;
}

/**
 * Get line ranges of code blocks for filtering
 */
function getCodeBlockRanges(lines) {
  const ranges = [];
  let start = -1;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('```')) {
      if (start === -1) {
        start = i;
      } else {
        ranges.push({ start, end: i });
        start = -1;
      }
    }
  }
  return ranges;
}

/**
 * Extract statistics/numbers from content (e.g., "134% YoY", "200+ founders", "$49-199")
 */
function extractStats(lines) {
  const stats = [];
  for (const line of lines) {
    // Match patterns like: "200-person", "134%", "$49-199", "22 qualified", "15-20 hours"
    const matches = line.match(/(\d[\d,.]*[+%]?(?:\s*[-–]\s*\d[\d,.]*[+%]?)?)\s+([A-Za-z][^.;,]{3,40})/g);
    if (matches) {
      for (const m of matches) {
        const numMatch = m.match(/^([\d,.]+[+%]?(?:\s*[-–]\s*[\d,.]+[+%]?)?)\s+(.+)/);
        if (numMatch) {
          stats.push({ number: numMatch[1].trim(), label: numMatch[2].trim() });
        }
      }
    }
    // Also match "$X" patterns
    const dollarMatches = line.match(/\$[\d,.]+(?:\s*[-–]\s*\$?[\d,.]+)?/g);
    if (dollarMatches) {
      for (const d of dollarMatches) {
        const context = line.substring(line.indexOf(d) + d.length, line.indexOf(d) + d.length + 40).trim();
        if (context) {
          stats.push({ number: d, label: context.split(/[.;,]/)[0].trim() });
        }
      }
    }
  }
  // Deduplicate and limit
  const seen = new Set();
  return stats.filter(s => {
    const key = s.number;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  }).slice(0, 8);
}

/**
 * Extract checklist items (- [ ] or - [x])
 */
function extractChecklist(lines) {
  const items = [];
  for (const line of lines) {
    const match = line.match(/^[\s]*[-*]\s*\[([ x])\]\s+(.+)/i);
    if (match) {
      items.push({ checked: match[1].toLowerCase() === 'x', text: match[2].trim() });
    }
  }
  return items;
}

/**
 * Extract bold phrases as key points
 */
function extractBoldPhrases(text) {
  const phrases = [];
  const regex = /\*\*([^*]+)\*\*/g;
  let match;
  while ((match = regex.exec(text)) !== null) {
    if (match[1].length > 5 && match[1].length < 100) {
      phrases.push(match[1]);
    }
  }
  return phrases;
}

/**
 * Categorize a section by its title for intelligent rendering
 */
function categorizeSection(title) {
  const t = title.toLowerCase();
  if (t.match(/problem|pain|challenge|broken|wrong|fail/)) return 'problem';
  if (t.match(/solution|how|product|what we|engine|platform|approach/)) return 'solution';
  if (t.match(/traction|proof|result|evidence|validation|metric/)) return 'traction';
  if (t.match(/pricing|price|plan|tier|cost|invest/)) return 'pricing';
  if (t.match(/who|serve|audience|icp|target|customer|ideal/)) return 'audience';
  if (t.match(/why now|timing|market|opportunity|trend/)) return 'timing';
  if (t.match(/next|cta|start|book|apply|join|sign|contact|step/)) return 'cta';
  if (t.match(/faq|question|asked/)) return 'faq';
  if (t.match(/value|principle|rule|framework|exchange/)) return 'values';
  if (t.match(/distribution|channel|delivery|plan/)) return 'distribution';
  if (t.match(/adaptation|note|mena|cultural|arabic/)) return 'adaptation';
  if (t.match(/pre-|before|preparation|require/)) return 'preparation';
  if (t.match(/touch|step|sequence|day|week/)) return 'sequence';
  return 'content';
}

module.exports = { parseBlueprint, extractTables, extractLists, extractCodeBlocks, categorizeSection };
