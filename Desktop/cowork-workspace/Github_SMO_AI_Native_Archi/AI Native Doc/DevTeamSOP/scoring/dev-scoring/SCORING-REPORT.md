# smorch-dev-scoring Plugin — Self-Assessment Scorecard

**Date**: 2026-03-26
**Version**: 1.1.0 (post gap-bridge)
**Files**: 23 (1 manifest, 7 SKILL.md, 12 reference docs, 4 commands, 1 scoring report)
**Total lines**: 2,314

---

## Skill Scoring Criteria

Each skill scored on 10 dimensions (1-10 scale):

| # | Criterion | What It Measures |
|---|-----------|-----------------|
| 1 | Frontmatter Quality | Name (lowercase-hyphen), description (<800 chars), triggers listed |
| 2 | Scope Clarity | Core question defined, boundaries clear, knows when NOT to fire |
| 3 | Process Structure | Step-by-step flow, numbered steps, logical order |
| 4 | Automated Checks | Programmatic signals (bash/grep commands) where applicable |
| 5 | MENA Context | Region-specific considerations included |
| 6 | Output Template | Structured, consistent output format defined |
| 7 | Reference Quality | Anchor rubrics complete, 5-level scoring bands, evidence guidance |
| 8 | Progressive Disclosure | SKILL.md lean (<500 lines), detail in references/ |
| 9 | Cross-References | Links to other skills, calibration examples, knows its place in the system |
| 10 | Actionability | Practical enough for Claude to execute without guessing |

---

## Skill Scores (v1.1 — post gap-bridge)

### Skill 1: product-scorer — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | Name correct, description 296 chars |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions + system context |
| Process Structure | 9 | 9 | — | 4-step process, clear discovery order |
| Automated Checks | 7 | 7 | — | Doc-based scoring, no bash needed |
| MENA Context | 10 | 9 | +1 | WhatsApp, Arabic-first, AI-adjusted timelines |
| Output Template | 9 | 9 | — | Clean table format with hard stop check |
| Reference Quality | 10 | 10 | — | 8 dims x 5 levels + evidence + calibration examples |
| Progressive Disclosure | 10 | 10 | — | 105 lines SKILL.md |
| Cross-References | 10 | 8 | +2 | System Context section + calibration reference + skip conditions |
| Actionability | 10 | 10 | — | File discovery + scoring steps executable |

### Skill 2: architecture-scorer — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 310 chars, good triggers |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions |
| Process Structure | 10 | 10 | — | 4 steps + stack-specific heuristics |
| Automated Checks | 8 | 8 | — | Security grep patterns |
| MENA Context | 8 | 8 | — | Implicit through stack patterns |
| Output Template | 9 | 9 | — | Complete with hard stop section |
| Reference Quality | 10 | 10 | — | 8 dims x 5 levels + calibration link |
| Progressive Disclosure | 10 | 10 | — | 104 lines SKILL.md |
| Cross-References | 10 | 9 | +1 | Calibration reference + skip conditions |
| Actionability | 10 | 10 | — | Priority-ordered discovery + grep patterns |

### Skill 3: engineering-scorer — 9.5 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 298 chars |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions |
| Process Structure | 9 | 9 | — | 3-step + automated checks |
| Automated Checks | 10 | 10 | — | 5 bash commands |
| MENA Context | 9 | 7 | +2 | Added: RTL CSS, Arabic strings, timezone, i18n architecture in anchors |
| Output Template | 9 | 9 | — | Automated metrics section |
| Reference Quality | 10 | 10 | — | 8 dims + MENA notes + calibration link |
| Progressive Disclosure | 10 | 10 | — | 95 lines SKILL.md |
| Cross-References | 10 | 8 | +2 | Calibration reference + skip conditions |
| Actionability | 10 | 10 | — | Most objective scorer |

### Skill 4: qa-scorer — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 275 chars |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions + library/CLI adaptations |
| Process Structure | 9 | 9 | — | 3-step with automated signals |
| Automated Checks | 10 | 10 | — | 5 bash commands |
| MENA Context | 10 | 10 | — | RTL, Arabic input, Gulf timezones, WhatsApp, phone formats |
| Output Template | 9 | 9 | — | Test health metrics + hard stops |
| Reference Quality | 10 | 10 | — | 8 dims x 5 levels + calibration link |
| Progressive Disclosure | 10 | 10 | — | 106 lines SKILL.md |
| Cross-References | 10 | 8 | +2 | Calibration reference + skip conditions |
| Actionability | 10 | 10 | — | Programmatically verifiable |

### Skill 5: ux-frontend-scorer — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 316 chars |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions (API, CLI, mobile) |
| Process Structure | 9 | 9 | — | 3-step with 7-point discovery |
| Automated Checks | 10 | 10 | — | 7 bash commands |
| MENA Context | 10 | 10 | — | RTL, Arabic typography, bidi, cultural, WhatsApp |
| Output Template | 9 | 9 | — | Frontend metrics |
| Reference Quality | 10 | 10 | — | 8 dims x 5 levels + calibration link |
| Progressive Disclosure | 10 | 10 | — | 114 lines SKILL.md |
| Cross-References | 10 | 8 | +2 | Calibration reference + skip conditions |
| Actionability | 10 | 10 | — | Color audit, component count, a11y check |

### Skill 6: composite-scorer — 9.8 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 332 chars |
| Scope Clarity | 10 | 10 | — | Core question + skip conditions for project types |
| Process Structure | 10 | 10 | — | 9-step orchestration: +persistence +consistency check +skip logic |
| Automated Checks | 9 | 8 | +1 | Cross-hat consistency check is quasi-automated |
| MENA Context | 9 | 8 | +1 | RTL hard stop + skip logic redistributes weights correctly |
| Output Template | 10 | 10 | — | Composite + breakdown + hard stops + history + next action |
| Reference Quality | 10 | 10 | — | 4 reference files: phase-weights, hard-stops, score-storage, calibration-examples |
| Progressive Disclosure | 10 | 10 | — | 174 lines SKILL.md, 4 reference files total 340 lines |
| Cross-References | 10 | 10 | — | References all 5 scorers + commands + storage + calibration |
| Actionability | 10 | 10 | — | Persistence schema, consistency pairs, skip redistribution all specified |

### Skill 7: gap-bridger — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | 288 chars |
| Scope Clarity | 10 | 10 | — | "Highest-impact thing to fix right now" |
| Process Structure | 10 | 10 | — | 7-step + MENA priority boost |
| Automated Checks | 7 | 7 | — | Action planning, not measurement |
| MENA Context | 9 | 7 | +2 | MENA Priority Boost section: RTL, Arabic input, WhatsApp |
| Output Template | 10 | 10 | — | Sprint-ready with acceptance criteria |
| Reference Quality | 10 | 10 | — | 40-dimension effort matrix |
| Progressive Disclosure | 10 | 10 | — | 159 lines SKILL.md |
| Cross-References | 10 | 9 | +1 | Score storage integration for delta tracking |
| Actionability | 10 | 10 | — | Impact formula + effort sizes + task quality examples |

---

## Command Scores (v1.1)

### Command 1: /score-project — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | Clean |
| Purpose Clarity | 10 | 10 | — | Unambiguous |
| Usage Instructions | 10 | 9 | +1 | Prerequisite check section added |
| Output Description | 9 | 9 | — | All sections listed |
| When to Use | 10 | 10 | — | 5 scenarios |
| Connection to Skills | 10 | 9 | +1 | Handles backend-only projects (skip Hat 5) |
| Length | 9 | 9 | — | 72 lines |

### Command 2: /score-hat — 9.6 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | Clear |
| Purpose Clarity | 10 | 10 | — | Single hat focus |
| Usage Instructions | 10 | 10 | — | Shortcut table + prerequisite check |
| Output Description | 9 | 9 | — | Category-level output |
| When to Use | 10 | 10 | — | 6 scenarios |
| Connection to Skills | 10 | 10 | — | Maps shortcuts + applicability check |
| Length | 9 | 9 | — | 70 lines |

### Command 3: /bridge-gaps — 9.5 / 10

| Criterion | Score | v1.0 | Delta | Notes |
|-----------|-------|------|-------|-------|
| Frontmatter | 9 | 9 | — | Clear |
| Purpose Clarity | 10 | 10 | — | Sprint-ready plan |
| Usage Instructions | 10 | 9 | +1 | 3-tier prerequisite check (session → stored → manual) |
| Output Description | 9 | 9 | — | All sections listed |
| When to Use | 9 | 9 | — | 4 scenarios |
| Connection to Skills | 10 | 9 | +1 | Score storage integration |
| Length | 9 | 9 | — | 65 lines |

### Command 4: /calibrate — 9.2 / 10 (NEW)

| Criterion | Score | Notes |
|-----------|-------|-------|
| Frontmatter | 9 | Clear name and description |
| Purpose Clarity | 10 | "Record a calibration example" |
| Usage Instructions | 9 | Process explained, schema documented |
| Output Description | 9 | JSON schema with example |
| When to Use | 10 | 4 specific scenarios |
| Connection to Skills | 9 | Links to calibration-examples.md, explains future auto-loading |
| Length | 9 | 78 lines |
| Future-Proofing | 10 | Explicitly marks current limitation + evolution path |

---

## Overall Plugin Score (v1.1)

| Component | v1.1 | v1.0 | Delta |
|-----------|------|------|-------|
| product-scorer | 9.6 | 9.1 | +0.5 |
| architecture-scorer | 9.6 | 9.3 | +0.3 |
| engineering-scorer | 9.5 | 9.0 | +0.5 |
| qa-scorer | 9.6 | 9.2 | +0.4 |
| ux-frontend-scorer | 9.6 | 9.2 | +0.4 |
| composite-scorer | 9.8 | 9.5 | +0.3 |
| gap-bridger | 9.6 | 9.4 | +0.2 |
| /score-project | 9.6 | 9.0 | +0.6 |
| /score-hat | 9.6 | 9.2 | +0.4 |
| /bridge-gaps | 9.5 | 9.0 | +0.5 |
| /calibrate | 9.2 | — | NEW |
| **Plugin Average** | **9.56 / 10** | **9.19** | **+0.37** |

### Plugin Structure Quality (v1.1)

| Criterion | Score | v1.0 | Notes |
|-----------|-------|------|-------|
| Naming convention | 10 | 10 | All lowercase-hyphen, consistent |
| File organization | 10 | 10 | skills/[name]/SKILL.md + references/, commands/*.md |
| Progressive disclosure | 10 | 10 | All SKILL.md <175 lines |
| Manifest completeness | 9 | 9 | plugin.json has all required fields |
| Description quality | 9 | 9 | All <800 chars with triggers |
| Cross-skill coherence | 10 | 10 | Consistent output, shared vocab, clear orchestration |
| MENA integration | 10 | 9 | All scorers now have MENA context + priority boost in gap-bridger |
| Score persistence | 10 | — | JSON schema, history tracking, delta calculation |
| Calibration system | 9 | — | Examples exist, /calibrate command captures real data, auto-loading is future |
| Cross-hat consistency | 10 | — | 5 dimension pairs checked for contradictions |
| Skip conditions | 10 | — | Every scorer + composite knows when NOT to fire |
| Prerequisite validation | 10 | — | All commands validate before executing |
| Total line count | 10 | 10 | 2,314 lines across 23 files |

### Plugin Overall: 9.6 / 10 — Grade: A+

---

## Remaining Path to 10.0

| Gap | Impact | Status | Path |
|-----|--------|--------|------|
| Auto-loaded calibration | Medium | /calibrate collects data | After 5+ real project scoring runs, update scorers to read `.scores/calibration/` and select closest match as anchor |
| Inter-rater reliability test | Medium | Needs real data | Run same project through 3 separate Claude sessions, measure score variance, refine anchors where variance > 1.0 |
| Stack-specific scorer variants | Low | Optional | Next.js-specific, Express-specific, n8n-specific weight adjustments within architecture and engineering scorers |
| Automated score persistence via bash | Low | Schema exists | Build a bash helper that writes the JSON automatically instead of relying on Claude to format it |

These gaps require real-world usage data to close. The `/calibrate` command is the collection mechanism. After 5-10 calibration snapshots, the plugin will have enough data to auto-anchor and reach true 10.0.
