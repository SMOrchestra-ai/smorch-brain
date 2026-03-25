# DOCX Production Patterns (V3 - python-docx)

All EO .docx files are built using python-docx. This file contains the battle-tested patterns, helper functions, and style constants from V3 production.

**Technology:** python-docx (Python). Replaced docx-js (Node.js) after V2.

## Setup

```bash
pip install python-docx --break-system-packages
```

## Color Scheme

```python
NAVY = "1B2A4A"    # Headers, table headers, title backgrounds
TEAL = "0D9488"    # Accents, callout borders, secondary headers
GOLD = "D97706"    # Highlights, important callouts, CTA elements
WHITE = "FFFFFF"   # Text on dark backgrounds
LIGHT_BG = "F0FDFA"  # Light teal background for callout boxes
```

## Core Import Block

```python
from docx import Document
from docx.shared import Inches, Pt, Cm, RGBColor, Emu
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn, nsdecls
from docx.oxml import parse_xml
import copy
```

## Template-Based Production Pattern (V3 Standard)

V3 production uses a template .docx as the base, then replaces placeholder text with real content. This preserves formatting, headers, footers, and styles that are painful to recreate programmatically.

### The Dict Ordering Rule (Critical)

When building the replacement dictionary, order matters. Specific/longer replacements MUST come before generic/shorter ones. If "STEP" appears before "STEP 1 TITLE", the engine replaces "STEP" first and corrupts "STEP 1 TITLE".

```python
replacements = {
    # LONGER / MORE SPECIFIC FIRST
    "STEP 1 TITLE": "Your Desktop is the Factory",
    "STEP 2 TITLE": "Cowork Mode: The Operator Layer",
    "STEP 3 TITLE": "Skills: Packaging Expertise",
    "STEP 1 DURATION": "35 min",
    "STEP 2 DURATION": "50 min",
    # SHORTER / MORE GENERIC LAST
    "TRAINING TITLE": "Claude Mastery for Micro-SaaS Solopreneurs",
    "VERSION": "v3.0",
}
```

### Full Paragraph Rewrite Pattern

python-docx stores text across multiple runs within a paragraph. A simple find-replace on individual runs fails when the placeholder text spans runs (e.g., "STEP" in run 1, " 1 TITLE" in run 2). The solution: collapse all runs into the first run, then replace.

```python
def replace_in_doc(doc, replacements):
    """Replace placeholders across all paragraphs and table cells.

    Collapses multi-run paragraphs into a single run before replacing.
    This handles cross-run text that simple run-level replacement misses.
    """
    def process_paragraph(para):
        # Skip empty paragraphs
        if not para.runs:
            return

        # Collapse: merge all run text into first run
        full_text = para.text
        if not any(key in full_text for key in replacements):
            return

        # Preserve first run's formatting
        first_run = para.runs[0]

        # Apply replacements to full text
        for old, new in replacements.items():
            full_text = full_text.replace(old, new)

        # Set collapsed text on first run, clear the rest
        first_run.text = full_text
        for run in para.runs[1:]:
            run.text = ""

    # Process all body paragraphs
    for para in doc.paragraphs:
        process_paragraph(para)

    # Process all table cells (including nested tables)
    for table in doc.tables:
        for row in table.rows:
            for cell in row.cells:
                for para in cell.paragraphs:
                    process_paragraph(para)
```

### Two-Pass Verification

After replacement, verify no placeholders remain. This catches typos in the replacement dict and cross-run edge cases.

```python
def verify_replacements(doc, replacements):
    """Check that no placeholder text survives replacement."""
    remaining = []

    # Check body paragraphs
    for para in doc.paragraphs:
        for key in replacements:
            if key in para.text:
                remaining.append(f"Body: '{key}' still in paragraph: {para.text[:80]}")

    # Check table cells
    for table in doc.tables:
        for row in table.rows:
            for cell in row.cells:
                for para in cell.paragraphs:
                    for key in replacements:
                        if key in para.text:
                            remaining.append(f"Table: '{key}' still in cell: {para.text[:80]}")

    if remaining:
        print(f"WARNING: {len(remaining)} unreplaced placeholders found:")
        for r in remaining:
            print(f"  - {r}")
    else:
        print("Verification PASSED: all placeholders replaced.")

    return len(remaining) == 0
```

## Table Cell Formatting

When modifying table cells, python-docx provides direct access but formatting requires XML manipulation for backgrounds:

```python
def set_cell_shading(cell, color_hex):
    """Set background color on a table cell."""
    shading = parse_xml(
        f'<w:shd {nsdecls("w")} w:fill="{color_hex}" w:val="clear"/>'
    )
    cell._tc.get_or_add_tcPr().append(shading)

def set_cell_text(cell, text, bold=False, color=None, size=None):
    """Set cell text with formatting, clearing existing content."""
    cell.text = ""  # Clear existing
    para = cell.paragraphs[0]
    run = para.add_run(text)
    run.bold = bold
    if color:
        run.font.color.rgb = RGBColor.from_string(color)
    if size:
        run.font.size = Pt(size)
```

## Document Structure Pattern (From-Scratch Builds)

For documents that don't use a template (rare in V3):

```python
doc = Document()

# Set default font
style = doc.styles['Normal']
font = style.font
font.name = 'Calibri'
font.size = Pt(11)

# Set margins
for section in doc.sections:
    section.top_margin = Inches(1)
    section.bottom_margin = Inches(1)
    section.left_margin = Inches(1)
    section.right_margin = Inches(1)
```

## Helper Functions (From-Scratch Builds)

```python
def add_heading(doc, text, level=1):
    """Add a styled heading."""
    heading = doc.add_heading(text, level=level)
    for run in heading.runs:
        run.font.color.rgb = RGBColor.from_string(NAVY)
        run.font.name = 'Calibri'
    return heading

def add_para(doc, text, bold=False):
    """Add a styled paragraph."""
    para = doc.add_paragraph()
    run = para.add_run(text)
    run.font.name = 'Calibri'
    run.font.size = Pt(11)
    run.bold = bold
    return para

def add_bullet(doc, text, level=0):
    """Add a bullet point."""
    para = doc.add_paragraph(text, style='List Bullet')
    para.paragraph_format.left_indent = Inches(0.25 * (level + 1))
    return para

def add_table(doc, headers, rows, col_widths=None):
    """Add a styled table with navy header row."""
    table = doc.add_table(rows=1 + len(rows), cols=len(headers))
    table.style = 'Table Grid'

    # Header row
    for i, header in enumerate(headers):
        cell = table.rows[0].cells[i]
        cell.text = header
        for para in cell.paragraphs:
            para.alignment = WD_ALIGN_PARAGRAPH.CENTER
            for run in para.runs:
                run.bold = True
                run.font.color.rgb = RGBColor.from_string(WHITE)
                run.font.name = 'Calibri'
                run.font.size = Pt(10)
        set_cell_shading(cell, NAVY)

    # Data rows
    for r, row_data in enumerate(rows):
        for c, cell_text in enumerate(row_data):
            table.rows[r + 1].cells[c].text = cell_text

    return table
```

## Callout Box Pattern

```python
def add_callout(doc, title, body_lines):
    """Add a teal-bordered callout box using a single-cell table."""
    table = doc.add_table(rows=1, cols=1)
    cell = table.rows[0].cells[0]

    # Title
    title_para = cell.paragraphs[0]
    title_run = title_para.add_run(title)
    title_run.bold = True
    title_run.font.color.rgb = RGBColor.from_string(TEAL)
    title_run.font.name = 'Calibri'
    title_run.font.size = Pt(11)

    # Body lines
    for line in body_lines:
        para = cell.add_paragraph()
        run = para.add_run(line)
        run.font.name = 'Calibri'
        run.font.size = Pt(10)

    # Background
    set_cell_shading(cell, LIGHT_BG)

    # Left border accent (requires XML)
    tc_pr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>'
        f'  <w:left w:val="single" w:sz="24" w:color="{TEAL}"/>'
        f'  <w:top w:val="single" w:sz="4" w:color="{TEAL}"/>'
        f'  <w:bottom w:val="single" w:sz="4" w:color="{TEAL}"/>'
        f'  <w:right w:val="single" w:sz="4" w:color="{TEAL}"/>'
        f'</w:tcBorders>'
    )
    tc_pr.append(borders)

    return table
```

## Build & Validate Pattern

```python
import os

def build_and_validate(doc, output_path, expected_min_size=5000):
    """Save document and validate output."""
    doc.save(output_path)

    stats = os.stat(output_path)
    print(f"Created: {output_path}")
    print(f"Size: {stats.st_size:,} bytes")

    if stats.st_size < expected_min_size:
        print(f"WARNING: File smaller than expected ({expected_min_size} bytes)")
    else:
        print("Validation: OK")

    return stats.st_size
```

## Common Patterns

**Template-first is default:** In V3, almost all .docx files start from a template. From-scratch builds are the exception, not the rule.

**Cross-file consistency:** When updating a .docx, always update the corresponding .md. Both files must stay in sync.

**Section numbering:** Use consistent "1. SECTION NAME" format matching the .md structure.

**PreCohort Guide exception:** The PreCohort Trainer Guide uses "SECTION 1/2/3" (not STEP) to avoid naming collision with training steps. This is intentional. The replacement dict for PreCohort must use SECTION_ prefixed placeholders.

**Recording Timeline exception:** The Recording Timeline sheet in the Ops Checklist is built with openpyxl (direct cell assignment), not python-docx. See training-content-engine.md Section 9 for that pattern.
