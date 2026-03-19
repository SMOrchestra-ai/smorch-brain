// HTML Builder v3 — SMO-quality landing pages with intelligent section mapping
// Maps MD blueprint sections to rich HTML components: hero, stats, problem cards,
// solution steps, features grid, results, pricing, audience, CTA

const fs = require('fs');
const path = require('path');
const { parseBlueprint, categorizeSection } = require('../utils/md-parser');
const { toCssVars } = require('../utils/brand');

/**
 * Build a production-quality landing page from a markdown blueprint
 */
function buildLandingPage(inputPath, outputDir, templatePath, brand, lang) {
  const blueprint = parseBlueprint(inputPath);
  let template = fs.readFileSync(templatePath, 'utf-8');

  const cssVars = toCssVars(brand.colors);
  const isArabic = lang === 'ar';
  const dir = isArabic ? 'rtl' : 'ltr';

  // Categorize all sections
  const categorized = blueprint.sections.map(s => ({
    ...s,
    category: categorizeSection(s.title),
  }));

  // Extract key sections
  const problemSections = categorized.filter(s => s.category === 'problem');
  const solutionSections = categorized.filter(s => s.category === 'solution');
  const tractionSections = categorized.filter(s => s.category === 'traction');
  const pricingSections = categorized.filter(s => s.category === 'pricing');
  const audienceSections = categorized.filter(s => s.category === 'audience');
  const timingSections = categorized.filter(s => s.category === 'timing');
  const ctaSections = categorized.filter(s => s.category === 'cta');
  const otherSections = categorized.filter(s =>
    !['problem', 'solution', 'traction', 'pricing', 'audience', 'cta'].includes(s.category)
  );

  // Build venture name split for logo
  const ventureName = blueprint.title || 'Venture';
  const nameParts = splitVentureName(ventureName);

  // Build hero content from title + subtitle + first section
  const heroHeadline = buildHeroHeadline(blueprint.title, brand.colors.primary);
  const heroSubtitle = blueprint.subtitle || (blueprint.sections[0]?.text?.split('\n')[0]) || '';

  // Collect stats from traction + timing sections
  const allStats = [];
  for (const s of [...tractionSections, ...timingSections]) {
    allStats.push(...s.stats);
    // Also extract stats from list items
    for (const list of s.lists) {
      for (const item of list) {
        const numMatch = item.match(/^([\d,.]+[+%]?(?:\s*[-–]\s*[\d,.]+[+%]?)?)\s+(.+)/);
        if (numMatch) {
          allStats.push({ number: numMatch[1], label: numMatch[2] });
        }
        // Also try extracting leading numbers from items like "200-person waitlist"
        const leadMatch = item.match(/([\d,.]+[+%]?)\s*[-–]?\s*(.{5,40})/);
        if (leadMatch && !numMatch) {
          allStats.push({ number: leadMatch[1], label: leadMatch[2] });
        }
      }
    }
  }
  const uniqueStats = dedupeStats(allStats).slice(0, 4);

  // Build nav links from major section categories
  const navSections = [];
  if (problemSections.length) navSections.push({ id: 'problem', label: 'Problem' });
  if (solutionSections.length) navSections.push({ id: 'solution', label: 'Solution' });
  if (tractionSections.length) navSections.push({ id: 'results', label: 'Results' });
  if (pricingSections.length) navSections.push({ id: 'pricing', label: 'Pricing' });
  const navLinksHtml = navSections
    .map(n => `<a onclick="smoothScroll('${n.id}')">${n.label}</a>`)
    .join('\n        ');

  // Build stats bar
  const statsHtml = uniqueStats.length >= 2 ? `
  <section class="stats-bar">
    <div class="stats-grid">
      ${uniqueStats.map(s => `
      <div class="stat-item animate">
        <div class="stat-number">${esc(s.number)}</div>
        <div class="stat-label">${esc(s.label)}</div>
      </div>`).join('')}
    </div>
  </section>` : '';

  // Build all dynamic sections
  let sectionsHtml = '';
  let sectionIndex = 0;

  // Problem section(s)
  for (const s of problemSections) {
    sectionsHtml += buildProblemSection(s, sectionIndex);
    sectionIndex++;
  }

  // Solution section(s)
  for (const s of solutionSections) {
    sectionsHtml += buildSolutionSection(s, sectionIndex);
    sectionIndex++;
  }

  // Audience section
  for (const s of audienceSections) {
    sectionsHtml += buildAudienceSection(s);
    sectionIndex++;
  }

  // Timing / "Why Now" — render as features
  for (const s of timingSections) {
    sectionsHtml += buildFeaturesSection(s, sectionIndex);
    sectionIndex++;
  }

  // Traction / Results
  for (const s of tractionSections) {
    sectionsHtml += buildResultsSection(s);
    sectionIndex++;
  }

  // Pricing
  for (const s of pricingSections) {
    sectionsHtml += buildPricingSection(s);
    sectionIndex++;
  }

  // All other sections — alternate light/dark
  for (const s of otherSections) {
    const isDark = sectionIndex % 2 === 0;
    sectionsHtml += buildGenericSection(s, isDark, sectionIndex);
    sectionIndex++;
  }

  // CTA content
  const ctaSection = ctaSections[0];
  const ctaHeadline = ctaSection ? ctaSection.title : 'Ready to Get Started?';
  const ctaSubtitle = ctaSection?.text || 'Take the next step.';
  const ctaText = blueprint.metadata.cta || extractCtaText(ctaSections) || 'Get Started';
  const ctaUrl = blueprint.metadata.ctaUrl || '#';

  // Pill text
  const pillText = blueprint.metadata.pill || ventureName.toUpperCase();

  // Hero note
  const heroNote = audienceSections.length > 0 && audienceSections[0].text
    ? `<div class="hero-note animate">${esc(audienceSections[0].text.substring(0, 120))}</div>`
    : '';

  // Replace all template placeholders
  const html = template
    .replace(/\{\{CSS_VARS\}\}/g, cssVars)
    .replace(/\{\{DIR\}\}/g, dir)
    .replace(/\{\{LANG\}\}/g, isArabic ? 'ar' : 'en')
    .replace(/\{\{TITLE\}\}/g, esc(blueprint.title))
    .replace(/\{\{VENTURE_NAME\}\}/g, esc(ventureName))
    .replace(/\{\{VENTURE_NAME_FIRST\}\}/g, esc(nameParts.first))
    .replace(/\{\{VENTURE_NAME_LAST\}\}/g, esc(nameParts.last))
    .replace(/\{\{PILL_TEXT\}\}/g, esc(pillText))
    .replace(/\{\{HERO_HEADLINE\}\}/g, heroHeadline)
    .replace(/\{\{HERO_SUBTITLE\}\}/g, esc(heroSubtitle))
    .replace(/\{\{HERO_NOTE\}\}/g, heroNote)
    .replace(/\{\{NAV_LINKS\}\}/g, navLinksHtml)
    .replace(/\{\{STATS_SECTION\}\}/g, statsHtml)
    .replace(/\{\{SECTIONS_HTML\}\}/g, sectionsHtml)
    .replace(/\{\{CTA_TEXT\}\}/g, esc(ctaText))
    .replace(/\{\{CTA_URL\}\}/g, ctaUrl)
    .replace(/\{\{CTA_HEADLINE\}\}/g, esc(ctaHeadline))
    .replace(/\{\{CTA_SUBTITLE\}\}/g, esc(ctaSubtitle.substring(0, 200)))
    .replace(/\{\{PRIMARY_COLOR\}\}/g, brand.colors.primary)
    .replace(/\{\{YEAR\}\}/g, new Date().getFullYear().toString());

  const filename = 'landing-page.html';
  const outputPath = path.join(outputDir, filename);
  fs.writeFileSync(outputPath, html, 'utf-8');

  return { file: filename, type: 'landing-page', size: fs.statSync(outputPath).size };
}

// ─── Section Builders ────────────────────────────────────────────────────

function buildProblemSection(section, idx) {
  const items = getAllItems(section);
  const text = section.text || '';

  // If we have list items, render as numbered cards
  if (items.length >= 2) {
    const cardsHtml = items.slice(0, 4).map((item, i) => {
      const parts = splitItemTitleDesc(item);
      return `
          <div class="card animate">
            <div class="card-number">${String(i + 1).padStart(2, '0')}</div>
            <h3 class="card-title">${esc(parts.title)}</h3>
            <p class="card-text">${esc(parts.desc)}</p>
          </div>`;
    }).join('');

    return `
  <section class="problem-section" id="problem">
    <div class="section-inner">
      <span class="eyebrow animate">THE PROBLEM</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${text ? `<p class="section-subtitle animate">${esc(text.substring(0, 200))}</p>` : ''}
      <div class="cards-grid">${cardsHtml}
      </div>
    </div>
  </section>`;
  }

  // Fallback: render text as a prose block with an accent callout
  const sentences = text.split(/\.\s+/).filter(Boolean);
  const mainText = sentences.slice(0, 3).join('. ') + '.';
  const callout = sentences.length > 3 ? sentences.slice(3).join('. ') + '.' : '';

  return `
  <section class="problem-section" id="problem">
    <div class="section-inner">
      <span class="eyebrow animate">THE PROBLEM</span>
      <h2 class="animate">${esc(section.title)}</h2>
      <p class="content-text animate" style="color:#525252;max-width:800px;font-size:1.1rem;line-height:1.8;">${esc(mainText)}</p>
      ${callout ? `<div class="solution-note animate" style="background:rgba(239,68,68,0.05);border-left-color:#EF4444;margin-top:2rem;color:#525252;">${esc(callout)}</div>` : ''}
    </div>
  </section>`;
}

function buildSolutionSection(section, idx) {
  const items = getAllItems(section);
  const text = section.text || '';

  if (items.length >= 2) {
    const cardsHtml = items.slice(0, 6).map((item, i) => {
      const parts = splitItemTitleDesc(item);
      return `
          <div class="card animate">
            <div class="card-number">${String(i + 1).padStart(2, '0')}</div>
            <h3 class="card-title">${esc(parts.title)}</h3>
            <p class="card-text">${esc(parts.desc)}</p>
          </div>`;
    }).join('');

    return `
  <section class="solution-section" id="solution">
    <div class="section-inner">
      <span class="eyebrow animate">THE SOLUTION</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${text ? `<p class="section-subtitle animate">${esc(text.substring(0, 300))}</p>` : ''}
      <div class="cards-grid">${cardsHtml}
      </div>
    </div>
  </section>`;
  }

  // Text-heavy solution: render as rich prose
  return `
  <section class="solution-section" id="solution">
    <div class="section-inner">
      <span class="eyebrow animate">THE SOLUTION</span>
      <h2 class="animate">${esc(section.title)}</h2>
      <p class="content-text animate" style="color:#A3A3A3;max-width:800px;font-size:1.1rem;line-height:1.8;">${esc(text)}</p>
      ${section.keyPoints.length > 0 ? `
      <div class="features-grid" style="margin-top:2rem;">
        ${section.keyPoints.slice(0, 4).map(kp => `
        <div class="feature-card animate">
          <div class="feature-card-title">${esc(kp)}</div>
        </div>`).join('')}
      </div>` : ''}
    </div>
  </section>`;
}

function buildResultsSection(section) {
  const stats = section.stats || [];
  const items = getAllItems(section);

  // Extract stat-like items from lists
  const resultItems = [];
  for (const item of items) {
    const numMatch = item.match(/^([\d,.]+[+%]?(?:[-–/][\d,.]+[+%]?)?)\s+(.+)/);
    if (numMatch) {
      resultItems.push({ number: numMatch[1], label: numMatch[2] });
    } else {
      // Try to find a number anywhere in the item
      const anyNum = item.match(/([\d,.]+[+%]+)\s+(.{5,})/);
      if (anyNum) {
        resultItems.push({ number: anyNum[1], label: anyNum[2] });
      } else {
        resultItems.push({ number: '✓', label: item });
      }
    }
  }

  const displayItems = dedupeStats([...stats, ...resultItems]).slice(0, 4);
  const text = section.text || '';

  return `
  <section class="results-section" id="results">
    <div class="section-inner">
      <span class="eyebrow animate">PROOF</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${displayItems.length > 0 ? `
      <div class="results-grid">
        ${displayItems.map(s => `
        <div class="result-item animate">
          <div class="result-number">${esc(s.number)}</div>
          <div class="result-label">${esc(s.label)}</div>
        </div>`).join('')}
      </div>` : ''}
      ${text ? `<div class="case-study animate">${esc(text)}</div>` : ''}
    </div>
  </section>`;
}

function buildPricingSection(section) {
  const tables = section.tables || [];
  const text = section.text || '';

  if (tables.length > 0) {
    const table = tables[0];
    // Each row becomes a pricing card
    const cardsHtml = table.rows.map(row => {
      const tierName = row[0] || '';
      const price = row[1] || '';
      const desc = row.slice(2).join(' · ') || '';
      // Split description by + or , for feature list
      const features = desc.split(/[+,·]/).map(f => f.trim()).filter(Boolean);

      return `
        <div class="pricing-card animate">
          <div class="pricing-title">${esc(tierName)}</div>
          <div class="pricing-price">${esc(price)}</div>
          ${features.length > 0 ? `
          <ul class="pricing-features">
            ${features.map(f => `<li>${esc(f)}</li>`).join('\n            ')}
          </ul>` : ''}
          <button class="btn btn-primary" onclick="smoothScroll('cta')">Get Started →</button>
        </div>`;
    }).join('');

    return `
  <section class="pricing-section" id="pricing">
    <div class="section-inner">
      <h2 class="animate">${esc(section.title)}</h2>
      <div class="pricing-container">${cardsHtml}
      </div>
    </div>
  </section>`;
  }

  // No table — render as content with list
  const items = getAllItems(section);
  return `
  <section class="pricing-section" id="pricing">
    <div class="section-inner">
      <h2 class="animate">${esc(section.title)}</h2>
      ${text ? `<p class="section-subtitle animate" style="color:#525252;">${esc(text)}</p>` : ''}
      ${items.length > 0 ? `
      <ul class="pricing-features animate">
        ${items.map(i => `<li>${esc(i)}</li>`).join('\n        ')}
      </ul>` : ''}
    </div>
  </section>`;
}

function buildAudienceSection(section) {
  const text = section.text || '';
  const items = getAllItems(section);

  // Extract tags from items (short phrases)
  const tags = items.filter(i => i.length < 50);
  const longItems = items.filter(i => i.length >= 50);

  return `
  <section class="audience-section" id="audience">
    <div class="section-inner">
      <span class="eyebrow animate">WHO THIS IS FOR</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${text ? `<p class="audience-text animate">${esc(text)}</p>` : ''}
      ${tags.length > 0 ? `
      <div class="audience-tags animate">
        ${tags.map(t => `<span class="audience-tag">${esc(t)}</span>`).join('\n        ')}
      </div>` : ''}
      ${longItems.length > 0 ? `
      <ul class="bullet-list" style="margin-top:2rem;">
        ${longItems.map(i => `<li class="animate">${esc(i)}</li>`).join('\n        ')}
      </ul>` : ''}
    </div>
  </section>`;
}

function buildFeaturesSection(section, idx) {
  const items = getAllItems(section);

  if (items.length >= 2) {
    const featureCards = items.slice(0, 6).map(item => {
      const parts = splitItemTitleDesc(item);
      return `
        <div class="feature-card animate">
          <div class="feature-card-title">${esc(parts.title)}</div>
          <div class="feature-card-desc">${esc(parts.desc)}</div>
        </div>`;
    }).join('');

    return `
  <section class="features-section">
    <div class="section-inner">
      <span class="eyebrow animate">${esc(section.title.toUpperCase())}</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${section.text ? `<p class="section-subtitle animate">${esc(section.text.substring(0, 200))}</p>` : ''}
      <div class="features-grid">${featureCards}
      </div>
    </div>
  </section>`;
  }

  // Fallback
  return buildGenericSection(section, true, idx);
}

function buildGenericSection(section, isDark, idx) {
  const cssClass = isDark ? 'content-dark' : 'content-light';
  const text = section.text || '';
  const items = getAllItems(section);
  const codeBlocks = section.codeBlocks || [];
  const tables = section.tables || [];
  const eyebrow = section.title.toUpperCase().substring(0, 30);
  const sectionId = section.title.toLowerCase().replace(/[^a-z0-9]+/g, '-').substring(0, 20);

  let contentHtml = '';

  // Text
  if (text) {
    contentHtml += `<p class="content-text animate">${esc(text)}</p>`;
  }

  // Code blocks (message templates, scripts, etc.)
  for (const block of codeBlocks) {
    contentHtml += `<div class="code-block animate">${esc(block.code)}</div>`;
  }

  // Lists
  if (items.length > 0) {
    contentHtml += `
      <ul class="bullet-list">
        ${items.slice(0, 10).map(i => `<li class="animate">${esc(i)}</li>`).join('\n        ')}
      </ul>`;
  }

  // Tables rendered as cards
  for (const table of tables) {
    contentHtml += `
      <div class="cards-grid" style="margin-top:2rem;">
        ${table.rows.slice(0, 6).map((row, i) => `
        <div class="card animate" style="${isDark ? 'background:rgba(255,255,255,0.04);border-color:rgba(255,255,255,0.08);' : ''}">
          <div class="card-number" style="background:var(--primary);">${String(i + 1).padStart(2, '0')}</div>
          <h3 class="card-title" style="${isDark ? 'color:#fff;' : ''}">${esc(row[0] || '')}</h3>
          <p class="card-text" style="${isDark ? 'color:#A3A3A3;' : ''}">${esc(row.slice(1).join(' · '))}</p>
        </div>`).join('')}
      </div>`;
  }

  return `
  <section class="${cssClass}" id="${sectionId}">
    <div class="section-inner">
      <span class="eyebrow animate">${esc(eyebrow)}</span>
      <h2 class="animate">${esc(section.title)}</h2>
      ${contentHtml}
    </div>
  </section>`;
}

// ─── Helpers ──────────────────────────────────────────────────────────────

function esc(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function getAllItems(section) {
  const items = [];
  for (const list of (section.lists || [])) {
    items.push(...list);
  }
  return items;
}

function splitItemTitleDesc(item) {
  // Try splitting on ": " first
  const colonIdx = item.indexOf(': ');
  if (colonIdx > 0 && colonIdx < 60) {
    return { title: item.substring(0, colonIdx), desc: item.substring(colonIdx + 2) };
  }
  // Try splitting on " — " or " - " or " – "
  const dashMatch = item.match(/^(.{5,50})\s+[—–-]\s+(.+)/);
  if (dashMatch) {
    return { title: dashMatch[1], desc: dashMatch[2] };
  }
  // Fallback: first sentence is title, rest is desc
  const dotIdx = item.indexOf('. ');
  if (dotIdx > 0 && dotIdx < 80) {
    return { title: item.substring(0, dotIdx), desc: item.substring(dotIdx + 2) };
  }
  return { title: item.substring(0, 60), desc: item.length > 60 ? item.substring(60) : '' };
}

function splitVentureName(name) {
  // Try to split on space for logo display: "Entrepreneurs Oasis" → "Entrepreneurs " + "Oasis"
  const words = name.split(' ');
  if (words.length >= 2) {
    const last = words[words.length - 1];
    const first = words.slice(0, -1).join(' ') + ' ';
    return { first, last };
  }
  return { first: name, last: '' };
}

function buildHeroHeadline(title, primaryColor) {
  // Make the last word or key phrase accent-colored
  const words = title.split(' ');
  if (words.length >= 3) {
    const lastTwo = words.slice(-2).join(' ');
    const rest = words.slice(0, -2).join(' ');
    return `${esc(rest)}<br><span class="accent">${esc(lastTwo)}</span>`;
  }
  if (words.length === 2) {
    return `${esc(words[0])}<br><span class="accent">${esc(words[1])}</span>`;
  }
  return `<span class="accent">${esc(title)}</span>`;
}

function extractCtaText(ctaSections) {
  for (const s of ctaSections) {
    if (s.text) {
      const firstLine = s.text.split('\n')[0];
      if (firstLine.length < 60) return firstLine;
    }
  }
  return null;
}

function dedupeStats(stats) {
  const seen = new Set();
  return stats.filter(s => {
    if (!s.number || !s.label) return false;
    const key = s.number.toString().replace(/\s/g, '');
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

module.exports = { buildLandingPage };
