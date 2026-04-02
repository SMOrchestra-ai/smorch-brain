---
description: Generate a formatted Word document scorecard report from scoring results. Includes all criteria breakdowns, benchmarks, and improvement roadmap.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(wc:*), Bash(mkdir:*), Bash(node:*), Bash(npm:*)
argument-hint: '[campaign-name or latest]'
---

# /score-report — Generate Score Report Document

Produces a professionally formatted Word document (.docx) from scoring results.

## When to Use

After running `/score` or `/score-all`, use this command to produce a shareable, archivable report document. Useful for:
- Client-facing campaign quality reports
- Internal quality review documentation
- Historical score tracking
- Team calibration exercises

## Execution Flow

### Step 1: Locate Score Data

If $ARGUMENTS contains "latest":
- Find the most recent score JSON files in `scores/` directory

If $ARGUMENTS contains a campaign name:
- Find score files matching that campaign name

If no score files exist:
- "No score data found. Run /score or /score-all first, then generate the report."

### Step 2: Build the Report

**Option A: Bundled Script (preferred)**
Run the bundled report generator from `scripts/generate-report.js`:
```bash
cd [workspace-root]/SOP/GTM/smorch-gtm-scoring
npm install docx  # if not already installed
node scripts/generate-report.js [campaign-name|latest]
```
This produces a branded .docx with all formatting, tables, and color coding built in.

**Option B: Manual via docx skill**
If the script is unavailable or the user needs a customized report, use the docx skill (read `/mnt/.claude/skills/docx/SKILL.md`) to create a Word document with:

**Document Structure:**
1. **Cover page** — Campaign name, date, overall score, verdict badge
2. **Executive Summary** — Campaign Health score, status, top 3 findings
3. **System-by-System Breakdown** — For each scored system:
   - System name and overall score
   - Criteria table with scores, weights, status
   - Hard stops flagged in red
   - Top fix actions with estimated impact
   - Benchmark comparison
4. **Composite Analysis** (if multi-system) — Campaign Health formula, cross-system dependencies
5. **Improvement Roadmap** — Prioritized fixes (P0-P6), timeline, expected score lift
6. **Benchmark Reference** — Channel-specific benchmarks for context
7. **Appendix** — Full criteria descriptions for reference

**Formatting:**
- SMOrch brand colors: navy (#1B2A4A) primary, orange (#FF6600) accent
- Score badges: green (9+), blue (7.5-8.9), amber (6-7.4), red (<6)
- Tables with header rows in navy with white text
- Page numbers in footer
- "SMOrchestra.ai Quality Gate Report" in header

### Step 3: Save and Present

Save as: `[campaign-name]-score-report-[date].docx` in workspace

Present to user with file link.

## Output Example

```
SMOrchestra.ai Quality Gate Report
Campaign: Q2 MENA SaaS Signal Engine
Date: 2026-03-26
Campaign Health: 7.8 / 10 — YELLOW

Executive Summary:
Campaign strategy is strong (8.2) with clear signal detection and MENA adaptation.
Email copy needs work (6.8) — subject lines scoring below threshold on personalization.
Offer positioning is solid (7.5) but unique mechanism needs sharper articulation.
LinkedIn branding performing well (8.0) on Track A, Track B needs frequency increase.

Priority P3: Fix email subject lines and body personalization before deployment.
```
