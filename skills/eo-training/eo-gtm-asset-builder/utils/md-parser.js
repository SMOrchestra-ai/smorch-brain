// Markdown Blueprint Parser
// Reads MD files and extracts structured data (sections, tables, lists, metadata)

const fs = require('fs');
const matter = require('gray-matter');
const { marked } = require('marked');

/**
 * Parse a markdown file into structured sections
 * @param {string} filePath - Path to MD file
 * @returns {object} { metadata, title, sections, tables, raw }
 */
function parseBlueprint(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const { data: metadata, content: body } = matter(content);

  const lines = body.split('\n');
  const sections = [];
  let currentSection = null;

  for (const line of lines) {
    const h1Match = line.match(/^# (.+)/);
    const h2Match = line.match(/^## (.+)/);
    const h3Match = line.match(/^### (.+)/);

    if (h1Match && !currentSection) {
      // Title line
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
      };
      continue;
    }

    if (currentSection) {
      currentSection.content.push(line);
    }
  }

  if (currentSection) sections.push(currentSection);

  // Post-process sections: extract tables and lists
  for (const section of sections) {
    section.tables = extractTables(section.content);
    section.lists = extractLists(section.content);
    section.text = section.content
      .filter(l => !l.startsWith('|') && !l.startsWith('-') && !l.startsWith('*') && l.trim() !== '')
      .join('\n')
      .trim();
  }

  // Extract title from first H1
  const titleMatch = body.match(/^# (.+)/m);
  const title = titleMatch ? titleMatch[1].trim() : metadata.title || '';

  return {
    metadata,
    title,
    sections,
    raw: body,
    html: marked(body),
  };
}

/**
 * Extract markdown tables from lines
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
        // First row = headers
        currentTable.headers = line.split('|').filter(c => c.trim()).map(c => c.trim());
      } else if (line.match(/^\|[\s-:|]+\|$/)) {
        // Separator row, skip
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
 * Extract bullet/numbered lists from lines
 */
function extractLists(lines) {
  const lists = [];
  let currentList = [];

  for (const line of lines) {
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
 * Extract code blocks from markdown
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

module.exports = { parseBlueprint, extractTables, extractLists, extractCodeBlocks };
