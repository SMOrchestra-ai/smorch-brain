# Arabization Engine - Sub-Skill Reference (V3)

## Overview

This is the **arabization master reference** for the EO Training Factory. When Mamoun triggers arabization tasks ("arabize the student guide", "arabize everything", "Arabic deck", "Arabic script", etc.), this sub-skill takes over completely.

**V3 Production Context:** 16 Arabic files delivered across 3 sessions covering PPTX (5 slide decks), DOCX (5 scripts + 2 guides + 1 card), XLSX (2 checklists), HTML (1 landing page). Every pattern below is battle-tested from real production, not theoretical.

---

## Section 1: Translation Rules (LOCKED)

These rules are **non-negotiable** and proven across all completed arabization work.

### Rule 1: Gulf Arabic Dialect ONLY

- Use **Gulf Arabic** (Khaleeji), NOT Modern Standard Arabic (MSA)
- Conversational, business-appropriate tone
- Think: Dubai WhatsApp group, not Al Jazeera newsroom
- Appropriate for UAE, KSA, Jordan, wider MENA region
- **Never** use MSA formal registers when Gulf Arabic colloquialisms fit better

### Rule 2: Technical Terms Stay in English

These terms remain **unchanged** in all arabized content:

Claude, MCP, API, SaaS, Docker, n8n, Cursor, Lovable, bolt.new, GitHub, Supabase, Vercel, React, Tailwind, GHL, Instantly, HeyReach, LinkedIn, WhatsApp, YouTube, PDF, CSV, HTML, CSS, JavaScript, CLAUDE.md, Cowork, Skills, MCPs

**Rationale:** These are industry-standard technical identifiers. Translating them creates confusion and breaks interoperability.

### Rule 3: Brand Translations (LOCKED)

These specific translations are **canonical** across all arabized assets:

| English | Arabic | Context |
|---------|--------|---------|
| EO MENA Launching Pad | منصة الإطلاق EO MENA | Platform branding |
| Training name pattern | ابنِ منتجك [Topic] مع [Tool] | e.g., "ابنِ منتجك MicroSaaS مع Claude" |
| solopreneur | رائد أعمال | Entrepreneur, business founder |
| Founding builder/member | عضو مؤسس | Organizational role |
| Signal-based trust engineering | هندسة الثقة القائمة على الإشارات | Methodology term |

### Rule 4: Mamoun's Arabic Bio (Standard)

Use this **exact text** in all bio sections requiring Arabic:

> مؤسس SMOrchestra: وكالة GTM بالذكاء الاصطناعي. مؤسس EntrepreneursOasis MENA. +20 سنة في مبيعات التكنولوجيا | +12 سنة في AI. مقيم في دبي، أصله من الأردن.

**Translation breakdown:**
- SMOrchestra: GTM agency with AI
- EntrepreneursOasis MENA founder
- +20 years in tech sales | +12 years in AI
- Based in Dubai, originally from Jordan

### Rule 5: Claude Prompts Stay in English

**Prompt text itself:** Remain in English (Claude works best with English inputs)

**Prompt TITLE/DESCRIPTION:** Translate to Gulf Arabic

**Example:**
```
English:
- Title: "Generate Sales Email Copy"
- Prompt: "Write a professional sales email..."

Arabic:
- Title: "إنشاء نص بريد مبيعات احترافي"
- Prompt: "Write a professional sales email..." [English unchanged]
```

### Rule 6: LinkedIn Posts & VSL Scripts - FULLY Translate

These are **audience-facing** content meant for Arabic speakers:
- Translate 100% to Gulf Arabic
- No technical terms remain in English (unless industry-standard tech brand names)
- Adjust examples and cultural references for MENA audience where appropriate

### Rule 7: Numbers & Pricing

- **Numbers in digital content:** Use Western Arabic numerals (1, 2, 3)
- **NOT Eastern Arabic:** ١, ٢, ٣ (avoid in digital content)
- **Pricing:** Keep USD with $ symbol (e.g., $99/month)

### Rule 8: Sentence Structure

Arabic sentences flow differently from English. Don't do word-for-word translation. Restructure sentences to sound natural in Gulf Arabic. Common patterns:
- English "X helps you do Y" becomes Arabic "مع X تقدر تسوي Y" (with X you can do Y)
- English passive voice converts to Arabic active voice
- English lists with semicolons convert to Arabic flowing paragraphs where appropriate

---

## Section 2: Translation Dict Approach (V3 - CRITICAL)

**Never use machine translation.** Build hand-written translation dicts keyed to actual content extracted from source files.

### Why Dicts, Not translate()

Machine translation (Google, DeepL, etc.) produces MSA formal Arabic. We need Gulf Arabic conversational tone. The dict approach:
1. Reads actual text from the source file
2. Maps each unique text block to a hand-written Gulf Arabic translation
3. Applies replacements programmatically
4. Preserves formatting, fonts, colors, sizes

### How to Build a Translation Dict

```python
# Step 1: Extract all unique text from source file
texts = set()
for slide in prs.slides:
    for shape in slide.shapes:
        if hasattr(shape, 'text_frame'):
            for para in shape.text_frame.paragraphs:
                t = para.text.strip()
                if t:
                    texts.add(t)

# Step 2: Print for manual translation
for t in sorted(texts):
    print(f'    "{t}": "",')

# Step 3: Fill in Gulf Arabic translations manually
TRANS = {
    "Build Your Business Brain": "ابنِ عقل مشروعك",
    "Step 1 Complete": "الخطوة 1 مكتملة",
    # ... all entries filled manually
}
```

### Dict Ordering Rule (CRITICAL)

Specific/long replacements MUST come before generic/short ones to prevent partial matches.

```
WRONG:  {"Step": "الخطوة", "Step 1 Complete": "الخطوة 1 مكتملة"}
  -> "Step 1 Complete" becomes "الخطوة 1 Complete" (generic runs first, corrupts specific)

RIGHT:  {"Step 1 Complete": "الخطوة 1 مكتملة", "Step": "الخطوة"}
  -> Specific/long first, generic/short last
```

When building dicts, sort keys by length descending before applying replacements.

---

## Section 3: Per-Filetype V3 Patterns

### PPTX Files (Battle-Tested)

**Pipeline:** `repair_pptx_zip()` pre → load → shape name matching → text replacement → font enforcement (standard + complex script `<a:cs>`) → RTL paragraph-level → save → `repair_pptx_zip()` post

**Tools:** python-pptx + zipfile + lxml

**Architecture:**

```python
import zipfile
from pptx import Presentation
from pptx.oxml.ns import qn
from lxml import etree

ARABIC_FONT = "Arial"

# 1. Repair ZIP before loading (deduplicate entries)
repaired = repair_pptx_zip(source_path)

# 2. Load presentation
prs = Presentation(repaired)

# 3. Iterate slides and shapes
for slide in prs.slides:
    for shape in slide.shapes:
        if not hasattr(shape, 'text_frame'):
            continue
        for para in shape.text_frame.paragraphs:
            original = para.text.strip()
            if original in TRANS:
                arabic = TRANS[original]
                # Replace text in first run, clear remaining runs
                if para.runs:
                    para.runs[0].text = arabic
                    for r in para.runs[1:]:
                        r.text = ""
                    # Set font on all runs
                    for r in para.runs:
                        set_arabic_run_pptx(r)
                # Set RTL on paragraph
                set_rtl_para_pptx(para)

# 4. Save
prs.save(output_path)

# 5. Repair ZIP after saving (python-pptx can introduce duplicates)
repair_pptx_zip(output_path, output_path)
```

**Layout safety:** Use `prs.slide_layouts[-1]` instead of assuming index 6 for Blank layout. Source PPTX files may have only 1 layout.

**WARP RECAP slides:** These use raw XML with hardcoded coordinates. For Arabic versions, keep all coordinate positions identical (x, y, cx, cy values stay the same). Only change: font typeface from "Georgia" to "Arial" and add `lang="ar-SA"` to `<a:rPr>` elements.

---

### DOCX Files (Battle-Tested)

**Pipeline:** load → paragraph text matching with `.strip()` → `apply_arabic_para_docx()` (preserves bold/size/color, clears runs, inserts single Arabic run) → font enforcement (standard + complex script `<w:cs>`) → RTL (`<w:bidi>` + `<w:jc right>`)

**Tools:** python-docx + lxml

**Architecture:**

```python
from docx import Document
from docx.oxml.ns import qn as wqn
from docx.oxml import OxmlElement

ARABIC_FONT = "Arial"

doc = Document(source_path)

for para in doc.paragraphs:
    original = para.text.strip()
    if original in TRANS:
        apply_arabic_para_docx(para, TRANS[original])

doc.save(output_path)
```

**Key difference from PPTX:** DOCX uses `<w:cs>` for complex script font (not `<a:cs>`). Both must be set or Arabic renders in the wrong font.

**Table handling:** Iterate `doc.tables` separately. For each cell, iterate `cell.paragraphs` and apply the same pattern.

---

### XLSX Files (Battle-Tested)

**Tools:** openpyxl

**Architecture:**

```python
from openpyxl import load_workbook
from openpyxl.styles import Font, Alignment

ARABIC_FONT = "Arial"

wb = load_workbook(source_path)

for ws in wb.worksheets:
    # Translate sheet name
    if ws.title in SHEET_TRANS:
        ws.title = SHEET_TRANS[ws.title]

    for row in ws.iter_rows():
        for cell in row:
            if cell.value and isinstance(cell.value, str):
                # NEVER touch formulas
                if cell.value.startswith('='):
                    continue
                stripped = cell.value.strip()
                if stripped in TRANS:
                    cell.value = TRANS[stripped]
                    cell.font = Font(name=ARABIC_FONT)
                    cell.alignment = Alignment(horizontal='right', rtl=True)

wb.save(output_path)
```

**Critical:** Formula cells (starting with `=`) are NEVER translated. Translating formula syntax breaks all calculations.

---

### HTML Files

**Tools:** Direct text manipulation + CSS flipping

1. Change `<html lang="en" dir="ltr">` to `<html lang="ar" dir="rtl">`
2. Flip all directional CSS: `text-align: left` → `right`, `padding-left` → `padding-right`, etc.
3. Add Arabic font family: `font-family: 'Segoe UI', Tahoma, Arial, sans-serif;`
4. Translate all visible text to Gulf Arabic
5. Keep color variable names and responsive breakpoints unchanged
6. **File naming:** `OriginalName-AR.html`

---

### PDF Files

**Recommended approach:** Generate Arabic HTML version first, then convert to PDF. Direct PDF generation with Arabic text is fragile.

If direct PDF is needed:
```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from arabic_reshaper import reshape
from bidi.algorithm import get_display

def create_arabic_pdf(text, output_file):
    c = canvas.Canvas(output_file, pagesize=letter)
    reshaped = reshape(text)
    bidi_text = get_display(reshaped)
    c.drawString(100, 750, bidi_text)
    c.save()
```

Install: `pip install arabic-reshaper python-bidi reportlab --break-system-packages`

---

## Section 4: Core Python Functions (V3 - Battle-Tested)

These 6 functions are the production foundation. Copy-paste into any arabization script.

```python
import zipfile
from lxml import etree
from pptx.oxml.ns import qn
from pptx.oxml import parse_xml
from docx.oxml.ns import qn as wqn
from docx.oxml import OxmlElement

ARABIC_FONT = "Arial"


# ============ PPTX FUNCTIONS ============

def repair_pptx_zip(src_path, dst_path=None):
    """Deduplicate ZIP entries that cause 'save as recovered' prompts.
    Run BEFORE loading with python-pptx AND AFTER saving.
    Returns path to repaired file."""
    out = dst_path or src_path + ".repaired.pptx"
    seen = set()
    with zipfile.ZipFile(src_path, 'r') as zin:
        with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                if item.filename not in seen:
                    seen.add(item.filename)
                    zout.writestr(item, zin.read(item.filename))
    return out


def set_arabic_run_pptx(run):
    """Set both standard font AND complex script font on a PPTX run.
    Without <a:cs>, Arabic renders in the wrong (default) font."""
    run.font.name = ARABIC_FONT
    rPr = run._r.get_or_add_rPr()
    # Remove existing complex script font entries
    for cs in rPr.findall(qn('a:cs')):
        rPr.remove(cs)
    # Add complex script font
    cs_elem = parse_xml(
        f'<a:cs xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" typeface="{ARABIC_FONT}"/>'
    )
    rPr.append(cs_elem)


def set_rtl_para_pptx(para):
    """Set RTL direction and right alignment on a PPTX paragraph."""
    pPr = para._pPr
    if pPr is None:
        pPr = para._p.get_or_add_pPr()
    pPr.set('rtl', '1')
    pPr.set('algn', 'r')


# ============ DOCX FUNCTIONS ============

def set_rtl_para_docx(para):
    """Set RTL direction on a DOCX paragraph using <w:bidi> and <w:jc right>."""
    pPr = para._element.find(wqn("w:pPr"))
    if pPr is None:
        pPr = OxmlElement("w:pPr")
        para._element.insert(0, pPr)
    # Add bidi element
    bidi = pPr.find(wqn("w:bidi"))
    if bidi is None:
        bidi = OxmlElement("w:bidi")
        pPr.append(bidi)
    bidi.set(wqn("w:val"), "1")
    # Add right justification
    jc = pPr.find(wqn("w:jc"))
    if jc is None:
        jc = OxmlElement("w:jc")
        pPr.append(jc)
    jc.set(wqn("w:val"), "right")


def apply_arabic_para_docx(para, arabic_text):
    """Replace paragraph content with Arabic text while preserving
    bold, size, and color from the original first run.
    Handles complex script font via <w:cs> element."""
    # Capture formatting from first run
    bold = size = color = None
    if para.runs:
        r0 = para.runs[0]
        bold = r0.bold or False
        size = r0.font.size
        color = r0.font.color.rgb if (r0.font.color and r0.font.color.type) else None

    # Clear all non-pPr children (removes all runs)
    for child in list(para._element):
        if child.tag not in (wqn("w:pPr"),):
            para._element.remove(child)

    # Add single Arabic run
    run = para.add_run(arabic_text)
    run.bold = bold
    run.font.name = ARABIC_FONT

    # Set complex script font (<w:cs>)
    rPr = run._element.find(wqn("w:rPr"))
    if rPr is None:
        rPr = OxmlElement("w:rPr")
        run._element.insert(0, rPr)
    cs = OxmlElement("w:rFonts")
    cs.set(wqn("w:cs"), ARABIC_FONT)
    rPr.append(cs)

    # Restore formatting
    if size:
        run.font.size = size
    if color:
        run.font.color.rgb = color

    # Set paragraph RTL
    set_rtl_para_docx(para)
```

---

## Section 5: Batch Arabization Workflow

### Step 1: Inventory Source Files
```bash
find /path/to/training -type f \( -name "*.docx" -o -name "*.xlsx" -o -name "*.pptx" -o -name "*.html" \) | sort
```

### Step 2: Group by Type
- PPTX files: need ZIP repair + complex script font
- DOCX files: need apply_arabic_para_docx + bidi
- XLSX files: need openpyxl + formula protection
- HTML files: need dir="rtl" + CSS flip

### Step 3: Extract Text for Translation Dicts
For each file, extract all unique text strings. Print them as dict stubs for manual Gulf Arabic translation.

### Step 4: Build Translation Dicts
Fill in Gulf Arabic translations manually. Sort keys by length descending (dict ordering rule).

### Step 5: Run Arabization Scripts
Execute per-filetype scripts with the translation dicts. Use the core functions from Section 4.

### Step 6: ZIP Repair (PPTX only)
Run `repair_pptx_zip()` on all output PPTX files. This is mandatory post-save.

### Step 7: Verify and Report
Run quality verification checklist (Section 6) on each file. Report results:
```
✓ EO-Slides-S1-BusinessBrain.pptx → EO-Slides-S1-BusinessBrain-AR.pptx (20 slides)
✓ EO-Recording-Script-S1.docx → EO-Recording-Script-S1-AR.docx (22 paragraphs)
✓ EO-Mastery-Checklist.xlsx → EO-Mastery-Checklist-AR.xlsx (4 sheets)
✗ Complex-layout.pdf → manual review required
```

---

## Section 6: Quality Verification Checklist

### All Files
- [ ] File exists with size > 10KB
- [ ] Contains Arabic text (not empty or broken)
- [ ] Brand references use canonical Arabic translations (Rule 3)
- [ ] Technical terms remain in English (Rule 2)
- [ ] File naming follows `-AR` convention
- [ ] Numbers use Western Arabic numerals (1, 2, 3)

### PPTX Files
- [ ] ZIP repair ran both pre and post (`repair_pptx_zip`)
- [ ] No "save as recovered" prompt when opening in PowerPoint
- [ ] Arabic font renders correctly (not fallback font)
- [ ] Complex script font set via `<a:cs>` element
- [ ] RTL direction set at paragraph level (`rtl='1'`, `algn='r'`)
- [ ] Slide layouts and designs unchanged
- [ ] Speaker notes present and correct
- [ ] All coordinate positions identical to English version

### DOCX Files
- [ ] `<w:bidi>` element present on Arabic paragraphs
- [ ] `<w:jc>` set to "right" on Arabic paragraphs
- [ ] Complex script font set via `<w:cs>` element
- [ ] Bold, size, color preserved from original
- [ ] Table content arabized (iterate `doc.tables` separately)
- [ ] Headers and footers translated

### XLSX Files
- [ ] ALL formulas still calculate correctly (formula cells untouched)
- [ ] Sheet names in Arabic
- [ ] Cell alignment set to `Alignment(horizontal='right', rtl=True)`
- [ ] Font set to Arial on translated cells
- [ ] Column widths preserved
- [ ] Conditional formatting still applies

### HTML Files
- [ ] `<html lang="ar" dir="rtl">` set correctly
- [ ] All directional CSS flipped
- [ ] Arabic font family applied
- [ ] Responsive design still works
- [ ] Colors and brand identity preserved

---

## Section 7: Common Failure Modes (V3 Production)

| # | Symptom | Root Cause | Fix |
|---|---------|-----------|-----|
| 1 | "save as recovered" prompt in PowerPoint | Duplicate ZIP entries in source PPTX | Run `repair_pptx_zip()` BEFORE loading AND AFTER saving |
| 2 | Arabic text renders in wrong/ugly font | Only `run.font.name` set, missing complex script font | Set `<a:cs>` (PPTX) or `<w:cs>` (DOCX) in addition to standard font |
| 3 | Text appears left-aligned despite RTL setting | RTL set at wrong XML level | PPTX: set on `pPr` element. DOCX: use `<w:bidi>` + `<w:jc right>` on paragraph |
| 4 | Layout crash: "index out of range" on slide_layouts[6] | Source PPTX only has 1 layout | Use `prs.slide_layouts[-1]` instead of hardcoded index |
| 5 | Partial text corrupted after replacement | Generic dict entries run before specific ones | Sort dict keys by length descending (specific/long FIRST) |
| 6 | Bold/color lost after Arabic replacement | Runs cleared without capturing formatting first | Use `apply_arabic_para_docx()` which captures bold/size/color before clearing |
| 7 | Formula cells show `#REF!` after XLSX translation | Formula syntax was translated | Check `cell.value.startswith('=')` and skip formula cells |
| 8 | Filename mismatch causes "file not found" | Output path doesn't match expected naming | Always verify output filenames match `-AR` convention |
| 9 | Encoding issues: curly quotes, special chars | Character encoding mismatch in dict keys | Use `.strip()` on source text before dict lookup. Watch for U+2019 vs U+0027 |

---

## Section 8: Reuse Templates

### PPTX Arabization Template

```python
import zipfile
from pptx import Presentation
from pptx.oxml.ns import qn
from pptx.oxml import parse_xml

ARABIC_FONT = "Arial"

def repair_pptx_zip(src, dst=None):
    out = dst or src + ".repaired.pptx"
    seen = set()
    with zipfile.ZipFile(src, 'r') as zin:
        with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                if item.filename not in seen:
                    seen.add(item.filename)
                    zout.writestr(item, zin.read(item.filename))
    return out

def set_arabic_run_pptx(run):
    run.font.name = ARABIC_FONT
    rPr = run._r.get_or_add_rPr()
    for cs in rPr.findall(qn('a:cs')):
        rPr.remove(cs)
    cs_elem = parse_xml(f'<a:cs xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" typeface="{ARABIC_FONT}"/>')
    rPr.append(cs_elem)

def set_rtl_para_pptx(para):
    pPr = para._pPr
    if pPr is None:
        pPr = para._p.get_or_add_pPr()
    pPr.set('rtl', '1')
    pPr.set('algn', 'r')

TRANS = {
    # FILL: sorted by key length descending
}

src = "SOURCE.pptx"
out = "SOURCE-AR.pptx"

repaired = repair_pptx_zip(src)
prs = Presentation(repaired)

for slide in prs.slides:
    for shape in slide.shapes:
        if not hasattr(shape, 'text_frame'):
            continue
        for para in shape.text_frame.paragraphs:
            t = para.text.strip()
            if t in TRANS:
                if para.runs:
                    para.runs[0].text = TRANS[t]
                    for r in para.runs[1:]:
                        r.text = ""
                    for r in para.runs:
                        set_arabic_run_pptx(r)
                set_rtl_para_pptx(para)

prs.save(out)
repair_pptx_zip(out, out)
print(f"Done: {out}")
```

### DOCX Arabization Template

```python
from docx import Document
from docx.oxml.ns import qn as wqn
from docx.oxml import OxmlElement

ARABIC_FONT = "Arial"

# Include set_rtl_para_docx and apply_arabic_para_docx from Section 4

TRANS = {
    # FILL: sorted by key length descending
}

doc = Document("SOURCE.docx")

for para in doc.paragraphs:
    t = para.text.strip()
    if t in TRANS:
        apply_arabic_para_docx(para, TRANS[t])

# Don't forget tables
for table in doc.tables:
    for row in table.rows:
        for cell in row.cells:
            for para in cell.paragraphs:
                t = para.text.strip()
                if t in TRANS:
                    apply_arabic_para_docx(para, TRANS[t])

doc.save("SOURCE-AR.docx")
print("Done: SOURCE-AR.docx")
```

### XLSX Arabization Template

```python
from openpyxl import load_workbook
from openpyxl.styles import Font, Alignment

ARABIC_FONT = "Arial"

TRANS = {
    # FILL: sorted by key length descending
}
SHEET_TRANS = {
    # "English Sheet Name": "Arabic Sheet Name"
}

wb = load_workbook("SOURCE.xlsx")

for ws in wb.worksheets:
    if ws.title in SHEET_TRANS:
        ws.title = SHEET_TRANS[ws.title]
    for row in ws.iter_rows():
        for cell in row:
            if cell.value and isinstance(cell.value, str):
                if cell.value.startswith('='):
                    continue
                s = cell.value.strip()
                if s in TRANS:
                    cell.value = TRANS[s]
                    cell.font = Font(name=ARABIC_FONT)
                    cell.alignment = Alignment(horizontal='right', rtl=True)

wb.save("SOURCE-AR.xlsx")
print("Done: SOURCE-AR.xlsx")
```

---

## Section 9: V3 File Structure (16 Arabic Files)

```
01-Training-Content/
├── EO-S1-BusinessBrain/
│   ├── EO-Slides-S1-BusinessBrain-AR.pptx
│   └── EO-Recording-Script-S1-BusinessBrain-AR.docx
├── EO-S2-DesktopCowork/
│   ├── EO-Slides-S2-DesktopCowork-AR.pptx
│   └── EO-Recording-Script-S2-DesktopCowork-AR.docx
├── EO-S3-Skills/
│   ├── EO-Slides-S3-Skills-AR.pptx
│   └── EO-Recording-Script-S3-Skills-AR.docx
├── EO-S4-MCPs/
│   ├── EO-Slides-S4-MCPs-AR.pptx
│   └── EO-Recording-Script-S4-MCPs-AR.docx
├── EO-S5-CodeClosing/
│   ├── EO-Slides-S5-CodeClosing-AR.pptx
│   └── EO-Recording-Script-S5-CodeClosing-AR.docx
├── Student Guide/
│   ├── EO-Student-QuickStart-Card-AR.docx
│   ├── EO-Mastery-Checklist-AR.xlsx
│   └── EO-MicroSaaS-Launch-Guide-AR.docx
├── Trainer Guide/
│   ├── EO-Trainer-Guide-AR.docx
│   └── EO-Training-Ops-Checklist-AR.xlsx
└── EO-Recording-Script-06-Closing-AR.docx

03-GTM-Sales/
└── EO-VSL-Landing-Page-AR.html
```

---

## Section 10: Escalation Rules

**Escalate to manual review if:**
1. File is PDF with complex layouts (graphics, tables, headers/footers)
2. File contains code snippets (keep 100% in English)
3. File has embedded videos or interactive elements
4. File contains images with embedded text
5. File is from external vendor (licensing/approval needed)
6. Translation has ambiguous cultural references
7. Source PPTX has more than 1 slide master with conflicting layouts

**Escalation process:**
1. Note the filename and issue reason
2. Create a `-REVIEW` version (e.g., `Complex-REVIEW.pdf`)
3. Flag for Mamoun's manual approval before final release

---

## Changelog

| Date | Change | Status |
|------|--------|--------|
| 2026-03-03 | Initial arabization-engine.md created | Archived |
| 2026-03-03 | 10 files arabized (Student Guide + GTM-Sales) | Verified |
| 2026-03-03 | Translation rules locked after real-world testing | Stable |
| 2026-03-12 | **V3 REWRITE:** Complete rewrite from pattern capture `arabic-arabization-full-stack-2026-03-12.md` | Active |
| 2026-03-12 | Added: repair_pptx_zip, complex script font (<a:cs>/<w:cs>), translation dict approach | Production |
| 2026-03-12 | Added: apply_arabic_para_docx, set_rtl_para_pptx, set_rtl_para_docx | Production |
| 2026-03-12 | Added: 9 failure modes from real production | Production |
| 2026-03-12 | Added: reuse templates for PPTX/DOCX/XLSX | Production |
| 2026-03-12 | 16 Arabic files documented in V3 file structure | Verified |

---

**Last updated:** 2026-03-12
**Status:** Production-ready (V3)
**Ownership:** EO Training Factory arabization sub-skill
