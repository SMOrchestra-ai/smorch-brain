# Build Log — Self-Learning Record

This file is updated after every major deliverable completion. Read it at the start of every new build to avoid repeating past mistakes.

---

## Build #1: Claude Mastery for Micro-SaaS Solopreneurs (MENA Edition)
**Date:** February 2026
**Training type:** 4-hour prerecorded (1h free + 3h paid)
**Status:** In progress — Training Macro complete, deliverables building

### Deliverables Completed

#### Training Macro (v1.2) — COMPLETED
**What worked:**
- Building .md first for fast iteration, then .docx for professional formatting
- Using docx-js with helper functions (heading, para, boldPara, bullet, table helpers) — highly reusable
- Proposing all decisions upfront rather than discovering them mid-build
- Pushing back on pricing ($27/mo community → $47/mo) — Mamoun agreed
- The "Founding Builders" framing (mutual commitment, not just discounts) was well-received

**Corrections from Mamoun (apply to all future builds):**
1. **Training language:** Always Arabic delivery, English-first assets. Never assume English delivery.
2. **Community platform:** Default is SalesMfast (GHL-based). Don't propose Circle/Skool/Discord.
3. **MAS/ICP scoring:** 5 per category, 20 total (SUM, not average). Previous version had 1-5 per category averaged to /5 — this was wrong. Always use sum-based /20.
4. **Signal-based outbound:** Must be a standalone deliverable category. Email + LinkedIn + WhatsApp triggered by signals, not calendar cadence. Platforms: LinkedIn, Sales Navigator, Trigify.
5. **bolt.new:** Must be included alongside Lovable, Cursor, Replit in tool landscape decisions.

**Patterns to remember:**
- Mamoun corrects in batches (4 items at once). Apply ALL corrections across ALL files immediately.
- "Agree with all" = lock it permanently. No reopening.
- He says "most important" when he means it. YouTube Video Preps = highest quality investment.
- Pricing discussions take 2-3 rounds to finalize. Propose, listen, refine, confirm.
- The 4-layer meta-learning architecture is not optional — it's structural. Every training must have a live throughline.

**New patterns discovered:**
- The "Founding Builders" model: 10 early adopters with mutual commitment (attend calls, share journey, testimonial in 60 days). This is reusable for any future training launch.
- Decision closing format: numbered list in dedicated section at end of Macro. Clean, scannable, no ambiguity.
- Color scheme (NAVY/TEAL/GOLD) was accepted without changes — use as default for all EO materials.

#### V3 Slide Decks (Steps 1-5) — COMPLETED
**What worked:**
- Raw XML injection for WARP RECAP slides (template-based, no python-pptx dependency for these)
- python-pptx for CLAUDE CONCEPT slides (programmatic shape creation with SMOrchestra design system)
- Surgical ZIP-level PPTX corruption repair when python-pptx leaves orphaned parts in Content_Types.xml
- Two-slide WARP RECAP system per step: "STEP N COMPLETE" + "WHAT CARRIES FORWARD"
- SMOrchestra design system colors: BG #0F1B2D, ORANGE #FF6600, WHITE #FFFFFF, LIGHT #1E324A, GRAY #B0BECE

**Corrections from Mamoun:**
- V3 narrative resequencing: S2=Desktop+Cowork (50min, was 45), S3=Skills, S4=MCPs, S5=Code+Closing
- Duration cascade: S2 going from 45 to 50 min pushed +5 min through all subsequent timing references
- "STEP" replaces "MODULE" everywhere, no exceptions

**Patterns to remember:**
- PPTX registration requires 4 actions or slide is invisible: write slide XML, write slide rels, register in presentation.xml, register in presentation.xml.rels
- Content_Types.xml uses absolute paths (/ppt/slides/slideN.xml), ZIP dict uses relative paths (ppt/slides/slideN.xml)
- sldId values must be unique integers; rId values must not conflict with existing rels
- WARP RECAP background requires explicit bgPr block with effectLst element

**New patterns discovered:**
- Two production methods coexist: raw XML for simple branded slides, python-pptx for complex programmatic slides
- Surgical repair algorithm: read ZIP, parse Content_Types.xml with lxml, find orphaned slide entries, remove them, rebuild ZIP
- WARP RECAP coordinate differences: S3 uses wider canvas (cx=9144000, x=1143000), S4/S5 use narrower (cx=7772000, x=686000)

#### V3 Recording Scripts (Steps 1-5) — COMPLETED
**What worked:**
- Template-based python-docx with dict ordering rule (specific/long replacements FIRST)
- Full paragraph rewrite pattern: collapse all runs into first run before replacing
- Two-pass verification: replace then check no placeholders survive
- Two script structures: short form (S1-S2, ~22 paragraphs) vs full production (S3-S5, 60-82 paragraphs)

**Corrections from Mamoun:**
- PreCohort Trainer Guide uses "SECTION 1/2/3" not "STEP" to avoid naming collision with training steps
- Recording Timeline sheet uses openpyxl direct cell assignment, not text replacement

**Patterns to remember:**
- Dict ordering is critical: "STEP 1 TITLE" must come before "STEP" in the replacement dict
- python-docx multi-run problem: placeholders can span runs, collapsing into first run solves this
- Always run verify_replacements() after replace_in_doc() before saving

**New patterns discovered:**
- Template .docx approach is superior to from-scratch builds: preserves headers, footers, styles, page numbering
- openpyxl for xlsx: iterate rows with ws.iter_rows(), assign cell.value directly for Recording Timeline

#### V3 Factory Skill Revamp — COMPLETED
**Date:** March 2026
**What was revamped:**
- SKILL.md: complete rewrite with V3 routing logic, 7 core principles, Phase 0-3 tables
- training-content-engine.md: complete rewrite with 11 sections encoding all production patterns from 4 pattern captures
- docx-patterns.md: complete technology swap from docx-js (Node.js) to python-docx (Python)
- asset-sequencing.md: MODULE→STEP terminology throughout
- frameworks.md: MODULE→STEP in Belief Arc section
- decision-protocol.md: MODULE→STEP in live throughline reference
- build-log.md: V3 entries added (this entry)
- mena-context.md: Arabic adaptation patterns from WARP RECAP captures added

**Patterns to remember:**
- Pattern captures from production sessions are the most valuable input for skill revamps
- Revamp after building, not before: real production data beats hypothetical templates every time
- The dict ordering rule and full paragraph rewrite pattern are the two most critical python-docx patterns

#### V3 Arabization Engine Rewrite - COMPLETED
**Date:** March 12, 2026
**What was revamped:**
- arabization-engine.md: complete rewrite from pattern capture `arabic-arabization-full-stack-2026-03-12.md`
- Replaced theoretical placeholder functions with 6 battle-tested core Python functions
- Added translation dict approach (hand-written, not machine translation)
- Added ZIP repair pipeline for PPTX (repair_pptx_zip pre+post)
- Added complex script font handling (<a:cs> for PPTX, <w:cs> for DOCX)
- Added 9 documented failure modes with fixes from real production
- Added reuse templates for PPTX, DOCX, XLSX arabization
- Documented V3 file structure (16 Arabic files delivered)
- Updated mena-context.md with V3 arabization production rules
- Updated SKILL.md routing with additional arabization triggers

**Patterns to remember:**
- Translation dicts with length-descending key ordering prevent partial match corruption
- Complex script font is the #1 missed step: without it Arabic renders in fallback font
- ZIP deduplication must happen both before AND after python-pptx processing
- apply_arabic_para_docx() must capture bold/size/color before clearing runs
- Layout safety: use `prs.slide_layouts[-1]` not hardcoded index

**New patterns discovered:**
- Pattern captures from arabization sessions are even more code-heavy than content sessions
- The 6 core functions (repair_pptx_zip, set_arabic_run_pptx, set_rtl_para_pptx, set_rtl_para_docx, apply_arabic_para_docx, set_arabic_run_docx) are the reusable foundation for any future arabization work

---

## Template for Future Entries

```
#### [Deliverable Name] (vX.X) — COMPLETED/IN PROGRESS
**What worked:**
- [Pattern that should be repeated]

**Corrections from Mamoun:**
- [Specific correction and how it was applied]

**Patterns to remember:**
- [Reusable insight for future builds]

**New patterns discovered:**
- [New approach or framework that emerged]
```
