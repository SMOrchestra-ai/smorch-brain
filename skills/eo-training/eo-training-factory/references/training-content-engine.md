# EO Training Factory: Training Content Engine Production Guide (V3)

## Overview

This reference encodes the exact production patterns for the EO Training Factory's complete training content suite, extracted from battle-tested V3 production builds. All deliverables follow standardized architecture ensuring consistency, scalability, and professional delivery quality.

**V3 Key Changes from V2:**
- "MODULE" retired, replaced with "STEP" everywhere
- Narrative resequencing: S2=Desktop+Cowork (50min), S3=Skills, S4=MCPs, S5=Code+Closing
- Duration cascade: S2 from 45 to 50 min, all subsequent timings shift +5 min
- Two PPTX production methods: raw XML (WARP RECAP) and python-pptx (CLAUDE CONCEPT)
- python-docx replaces docx-js for all .docx production
- Dict ordering rule enforced for all text replacement operations

**Total Build Output:** 18+ files across 5 paid steps + Free Hour + Closing, organized in strict folder structure with precise naming conventions.

---

## 1. V3 Step Structure

### Step Definitions

| Step | V3 Title | Duration | Sections | Slide Count | Script Length |
|------|----------|----------|----------|-------------|---------------|
| S1 | Business Brain | 30 min | 3 timed sections | 20 slides | Short form (~22 paragraphs) |
| S2 | Desktop + Cowork | 50 min | 3 timed sections | 17 slides (incl. 2 CLAUDE CONCEPT) | Short form (~22 paragraphs) |
| S3 | Skills | 30 min | 3 timed sections | 14 slides (12 base + 2 WARP RECAP) | Full production (60-82 paragraphs) |
| S4 | MCPs - Connection Layer | 30 min | 3 timed sections | 14 slides (12 base + 2 WARP RECAP) | Full production (60-82 paragraphs) |
| S5 | Code + Closing | 40 min | 5 timed sections | 18 slides (16 base + 2 WARP RECAP) | Full production (60-82 paragraphs) |

### V3 Narrative Resequencing

V3 reordered Steps 2-5 from V2. The key changes:

| V2 Order | V3 Order | Reason |
|----------|----------|--------|
| S2: Desktop + MCPs | S2: Desktop + Cowork | Cowork is the visual "wow" moment; MCPs are infrastructure |
| S3: Skills | S3: Skills | Unchanged |
| S4: Cowork | S4: MCPs - Connection Layer | MCPs now positioned as the connection layer between skills |
| S5: Code + Closing | S5: Code + Closing | Unchanged, but CLAUDE.md-first development approach added |

### Duration Cascade Rule

If any step's duration changes, ALL subsequent steps shift. Example from V3:
- S2 went from 45 min to 50 min (+5 min)
- This cascaded through ALL timing references in S3, S4, S5 agenda slides, scripts, and ops checklists
- The cascade affects: agenda slide timing blocks, [TIME WARNING] markers in scripts, Recording Timeline cells in ops xlsx

### Timed Sections Per Step

| Step | Section 1 | Section 2 | Section 3 | Section 4 | Section 5 |
|------|-----------|-----------|-----------|-----------|-----------|
| S1 | 0:00-8:00 | 8:00-20:00 | 20:00-30:00 | - | - |
| S2 | 0:00-8:00 | 8:00-20:00 | 20:00-30:00 | - | - |
| S3 | 0:00-5:00 | 5:00-22:00 | 22:00-30:00 | - | - |
| S4 | 0:00-5:00 | 5:00-22:00 | 22:00-30:00 | - | - |
| S5 | 0:00-8:00 | 8:00-30:00 | 30:00-40:00 | (has 5 section dividers) | - |

S3/S4 intro shortened to 0:00-5:00 because students are already in motion. Main build section expanded to 5:00-22:00 for hands-on demo time.

---

## 2. Slide Deck Production

### Slide Architecture (All Steps)

| Slide # | Role | Content |
|---------|------|---------|
| 1 | Title / Cover | "STEP N" label + step title |
| 2 | Agenda / Section Map | Timing block: section ranges |
| 3-4 | Context / Why This Matters | Belief shift setup |
| 5 | Section Divider (Section 1) | First section title + timing |
| 6-8 | Section 1 content | Framework or concept slides |
| 9 | Section Divider (Section 2) | Second section title + timing |
| 10 | Section 2 content | |
| 11 | Takeaways | "Step N Takeaways" - 4-5 bullets |
| 12 | Bridge / Coming Next | "STEP N+1" teaser (except Step 5) |
| 13 | WARP RECAP - "STEP N COMPLETE" | What was built this step |
| 14 | WARP RECAP - "WHAT CARRIES FORWARD" | What feeds into next step |

Step 5 exception: Has 5 section dividers. Takeaway on slide 11, bridge/reference on slide 14, WARP RECAP at slides 17-18.

### EO Color Scheme (11 Tokens)

```
# Main deck colors
NAVY:          #1B2A4A    (headers, critical emphasis, main deck background)
TEAL:          #0D9488    (primary action, key takeaways)
GOLD:          #D97706    (highlights, callouts, content slide accents)
WHITE:         #FFFFFF    (body text)
LIGHT_BG:      #F0FDFA    (backgrounds, subtle contrast on some content slides)

# WARP RECAP colors (distinct visual mode)
RECAP_BG:      #0F172A    (near-black navy, darker than main deck)
RECAP_LABEL:   #94A3B8    (slate grey for "W A R P  R E C A P" category tag)
RECAP_STEP:    #FF6600    (bright orange for step label, NOT the gold #D97706)

# CLAUDE CONCEPT colors (SMOrchestra design system)
CONCEPT_BG:    #0F1B2D    (charcoal navy)
CONCEPT_ORANGE:#FF6600    (SMOrchestra orange)
CONCEPT_LIGHT: #1E324A    (lighter panel background)
CONCEPT_GRAY:  #B0BECE    (secondary text)
```

### Takeaway Slide Pattern

Title: "Step N Takeaways" (not "Module N Takeaways")

Content: 4-5 bullets. 1-2 bullets swapped from generic to EO-specific per step.

The "Built for EO:" bullet is the anchor. Example (S5): "Built for EO: EO platform prototype deployed live - listing, search, and submission"

Generic principles kept alongside because they still apply. Only 1-2 bullets replaced per revamp pass.

### Bridge Slide Pattern

Shows "STEP N+1" with teaser text. Step 5 has no bridge to next (it's the final step); instead uses reference/closing content.

### XML Text Replacement Method

```python
content.replace(f'>{old}<', f'>{new}<')
```

Only replaces text between `>` and `<` tags in XML. Critical: character encoding must exactly match. Curly apostrophes (U+2019) vs straight (U+0027) cause silent failures. Always inspect raw XML before assuming which character is present.

---

## 3. WARP RECAP Slides

### Two-Slide System Per Step

**Slide A: "STEP N COMPLETE"**
- Visual confirmation the step's build is done
- Main text: one concrete outcome statement (what was shipped)
- Orange label confirms step completion

**Slide B: "WHAT CARRIES FORWARD"**
- Bridges to next step without naming it explicitly
- Main text: one forward-looking statement (what this enables)
- Step 5 uses CTA instead of bridge: "You ship now. Build in public. Grow."

### Visual Hierarchy (3 Layers)

1. Category label ("W A R P  R E C A P") - grey #94A3B8, spaced, 14pt Calibri, kern=0, spc=600
2. Step label ("STEP 5 COMPLETE" / "WHAT CARRIES FORWARD") - orange #FF6600, 14pt Calibri, bold
3. Main text - white #FFFFFF, 24pt Georgia (or 32pt on S3), bold

### WARP RECAP Content Per Step

| Step | COMPLETE text | FORWARD text |
|------|--------------|--------------|
| S3 | Custom MENA Micro-SaaS Evaluator skill built for EO | Evaluator skill activates in every Cowork session |
| S4 | EO GTM assets produced in batch | GTM assets ready for Step 5 build |
| S5 | EO platform prototype built and deployed | You ship now. Build in public. Grow. |

### Main Text Writing Rules

- COMPLETE slide: past tense ("X built", "X deployed", "X produced")
- FORWARD slide: forward tense or imperative ("X ready for Y", "X activates in Z")
- Always reference the EO artifact specifically (not "your project" but "EO platform", "Evaluator skill")
- Max 8 words. If you need more, the concept isn't sharp enough.

### Full XML Template (Battle-Tested)

Uses S4/S5 coordinates (cx=7772000). For S3, use cx=9144000 and x=1143000 instead of x=686000.

```xml
<?xml version='1.0' encoding='UTF-8' standalone='yes'?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:bg>
      <p:bgPr>
        <a:solidFill><a:srgbClr val="0F172A"/></a:solidFill>
        <a:effectLst/>
      </p:bgPr>
    </p:bg>
    <p:spTree>
      <p:nvGrpSpPr>
        <p:cNvPr id="1" name=""/>
        <p:cNvGrpSpPr/>
        <p:nvPr/>
      </p:nvGrpSpPr>
      <p:grpSpPr>
        <a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
          <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm>
      </p:grpSpPr>
      <!-- BOX 1: Category label -->
      <p:sp>
        <p:nvSpPr>
          <p:cNvPr id="2" name="Label"/>
          <p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr>
          <p:nvPr/>
        </p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="686000" y="1645920"/><a:ext cx="7772000" cy="457200"/></a:xfrm>
          <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
          <a:noFill/>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="0" rIns="0" tIns="0" bIns="0" anchor="ctr"/>
          <a:lstStyle/>
          <a:p>
            <a:pPr algn="ctr"/>
            <a:r>
              <a:rPr lang="en-US" sz="1400" kern="0" spc="600" dirty="0">
                <a:solidFill><a:srgbClr val="94A3B8"/></a:solidFill>
                <a:latin typeface="Calibri" pitchFamily="34" charset="0"/>
              </a:rPr>
              <a:t>W A R P  R E C A P</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>
      <!-- BOX 2: Step label -->
      <p:sp>
        <p:nvSpPr>
          <p:cNvPr id="3" name="StepLabel"/>
          <p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr>
          <p:nvPr/>
        </p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="686000" y="2194560"/><a:ext cx="7772000" cy="457200"/></a:xfrm>
          <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
          <a:noFill/>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="0" rIns="0" tIns="0" bIns="0" anchor="ctr"/>
          <a:lstStyle/>
          <a:p>
            <a:pPr algn="ctr"/>
            <a:r>
              <a:rPr lang="en-US" sz="1400" b="1" dirty="0">
                <a:solidFill><a:srgbClr val="FF6600"/></a:solidFill>
                <a:latin typeface="Calibri" pitchFamily="34" charset="0"/>
              </a:rPr>
              <a:t>STEP_LABEL</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>
      <!-- BOX 3: Main text -->
      <p:sp>
        <p:nvSpPr>
          <p:cNvPr id="4" name="MainText"/>
          <p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr>
          <p:nvPr/>
        </p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="686000" y="2743200"/><a:ext cx="7772000" cy="1371600"/></a:xfrm>
          <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
          <a:noFill/>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="0" rIns="0" tIns="0" bIns="0" anchor="t" wrap="square"/>
          <a:lstStyle/>
          <a:p>
            <a:pPr algn="ctr"/>
            <a:r>
              <a:rPr lang="en-US" sz="2400" b="1" dirty="0">
                <a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill>
                <a:latin typeface="Georgia" pitchFamily="18" charset="0"/>
              </a:rPr>
              <a:t>MAIN_TEXT</a:t>
            </a:r>
          </a:p>
        </p:txBody>
      </p:sp>
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sld>
```

### Coordinate Differences Between Steps

| Property | S3 | S4/S5 |
|----------|-----|--------|
| x offset (all boxes) | 1143000 | 686000 |
| cx width (all boxes) | 9144000 | 7772000 |
| Main text font size | 3200 (32pt) | 2400 (24pt) |
| y positions | Same for all | Same for all |

S3 used wider coordinate space. S4/S5 corrected to narrower coordinates for better 10-inch slide margins.

### Y Positions (Consistent Across All Steps)

- Label top: y=1645920
- Step label top: y=2194560
- Main text top: y=2743200
- Gap between elements: 91440 EMU (~0.1 inch)

### PPTX Registration Sequence (All 4 Required)

When adding WARP RECAP slides to existing deck:

1. Write `ppt/slides/slide{n}.xml` - the actual slide content
2. Write `ppt/slides/_rels/slide{n}.xml.rels` - the slide's relationships (minimal if no images)
3. Register in `ppt/presentation.xml`: add `<p:sldId id="NNN" r:id="rIdXX"/>` after last existing sldId
4. Register in `ppt/_rels/presentation.xml.rels`: add `<Relationship Id="rIdXX" Type="...slide" Target="slides/slide{n}.xml"/>` after last existing slide Relationship

**sldId numbering:** Use last sldId + 1, + 2 for two new slides. rId values must not conflict with existing rIds in presentation.xml.rels. Inspect existing rels file first.

**Minimal rels file for new slides:**
```xml
<?xml version='1.0' encoding='UTF-8' standalone='yes'?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>
```

**Critical:** The `<p:bg>` block with `<p:bgPr>` and `<a:effectLst/>` is REQUIRED for dark background. Without it, slide inherits white from master.

---

## 4. CLAUDE CONCEPT Slides

### Anatomy

CLAUDE CONCEPT slides are explainer slides using SMOrchestra's dark design system. They use python-pptx (not raw XML) for production.

### SMOrchestra Design System

```
Background:    #0F1B2D (charcoal navy)
Orange accent: #FF6600
White text:    #FFFFFF
Light panel:   #1E324A (lighter navy for content areas)
Gray text:     #B0BECE (secondary/descriptive text)
```

### Layout Coordinates (inches, python-pptx)

| Element | Left | Top | Width | Height |
|---------|------|-----|-------|--------|
| Title text | 0.5 | 0.4 | 9.0 | 0.6 |
| Subtitle text | 0.5 | 1.0 | 9.0 | 0.4 |
| Content panel | 0.5 | 1.6 | 9.0 | 5.0 |
| Panel items | 0.7 | (varies) | 8.6 | 0.4 each |

### python-pptx Production Method

```python
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

prs = Presentation()
prs.slide_width = Inches(10)
prs.slide_height = Inches(7.5)

slide_layout = prs.slide_layouts[6]  # blank layout
slide = prs.slides.add_slide(slide_layout)

# Set background
bg = slide.background
fill = bg.fill
fill.solid()
fill.fore_color.rgb = RGBColor(0x0F, 0x1B, 0x2D)

# Add title
txBox = slide.shapes.add_textbox(Inches(0.5), Inches(0.4), Inches(9.0), Inches(0.6))
tf = txBox.text_frame
tf.word_wrap = True
p = tf.paragraphs[0]
p.text = "CLAUDE CONCEPT TITLE"
p.font.size = Pt(28)
p.font.bold = True
p.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
p.alignment = PP_ALIGN.LEFT
```

---

## 5. PPTX Corruption Repair

### Root Cause

When python-pptx writes slides and some elements fail or get removed mid-process, the resulting file can have:
- Orphaned entries in `[Content_Types].xml` pointing to slides that don't exist in the ZIP
- Missing `.rels` files for slides that DO exist
- Mismatched sldId entries in `presentation.xml`

PowerPoint opens these files with "repair" prompts that often delete the problematic slides entirely.

### Surgical Repair Algorithm

```python
import zipfile
import os
import re
from collections import OrderedDict
from lxml import etree

def repair_pptx(input_path, output_path):
    """
    Surgical PPTX repair: removes orphaned references,
    fixes Content_Types, renumbers sldIds.
    """
    temp_dir = '/tmp/pptx_repair'
    os.makedirs(temp_dir, exist_ok=True)

    # 1. Extract all files
    with zipfile.ZipFile(input_path, 'r') as z:
        z.extractall(temp_dir)

    # 2. Find which slides actually exist in the ZIP
    slides_dir = os.path.join(temp_dir, 'ppt', 'slides')
    existing_slides = set()
    if os.path.isdir(slides_dir):
        for f in os.listdir(slides_dir):
            m = re.match(r'slide(\d+)\.xml', f)
            if m:
                existing_slides.add(int(m.group(1)))

    # 3. Fix [Content_Types].xml - remove entries for non-existent slides
    ct_path = os.path.join(temp_dir, '[Content_Types].xml')
    tree = etree.parse(ct_path)
    root = tree.getroot()
    ns = root.nsmap.get(None, '')
    removals = []
    for override in root.findall(f'{{{ns}}}Override'):
        pn = override.get('PartName', '')
        m = re.match(r'/ppt/slides/slide(\d+)\.xml', pn)
        if m and int(m.group(1)) not in existing_slides:
            removals.append(override)
    for r in removals:
        root.remove(r)
    tree.write(ct_path, xml_declaration=True, encoding='UTF-8', standalone=True)

    # 4. Fix presentation.xml - remove sldId entries for missing slides
    pres_path = os.path.join(temp_dir, 'ppt', 'presentation.xml')
    pres_tree = etree.parse(pres_path)
    pres_root = pres_tree.getroot()
    # Find all sldId elements, check their rId targets
    pres_rels_path = os.path.join(temp_dir, 'ppt', '_rels', 'presentation.xml.rels')
    rels_tree = etree.parse(pres_rels_path)
    rels_root = rels_tree.getroot()
    rels_ns = rels_root.nsmap.get(None, '')

    # Build rId -> target mapping
    rid_to_target = {}
    for rel in rels_root.findall(f'{{{rels_ns}}}Relationship'):
        rid_to_target[rel.get('Id')] = rel.get('Target')

    # Remove sldId entries pointing to non-existent slides
    p_ns = 'http://schemas.openxmlformats.org/presentationml/2006/main'
    r_ns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
    sld_id_lst = pres_root.find(f'{{{p_ns}}}sldIdLst')
    if sld_id_lst is not None:
        remove_sld = []
        for sld_id in sld_id_lst.findall(f'{{{p_ns}}}sldId'):
            rid = sld_id.get(f'{{{r_ns}}}id')
            target = rid_to_target.get(rid, '')
            m = re.match(r'slides/slide(\d+)\.xml', target)
            if m and int(m.group(1)) not in existing_slides:
                remove_sld.append(sld_id)
        for s in remove_sld:
            sld_id_lst.remove(s)
    pres_tree.write(pres_path, xml_declaration=True, encoding='UTF-8', standalone=True)

    # 5. Remove orphaned rels entries
    remove_rels = []
    for rel in rels_root.findall(f'{{{rels_ns}}}Relationship'):
        target = rel.get('Target', '')
        m = re.match(r'slides/slide(\d+)\.xml', target)
        if m and int(m.group(1)) not in existing_slides:
            remove_rels.append(rel)
    for r in remove_rels:
        rels_root.remove(r)
    rels_tree.write(pres_rels_path, xml_declaration=True, encoding='UTF-8', standalone=True)

    # 6. Ensure every existing slide has a .rels file
    rels_dir = os.path.join(slides_dir, '_rels')
    os.makedirs(rels_dir, exist_ok=True)
    for sn in existing_slides:
        rels_file = os.path.join(rels_dir, f'slide{sn}.xml.rels')
        if not os.path.exists(rels_file):
            with open(rels_file, 'w') as f:
                f.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n')
                f.write('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>\n')

    # 7. Repack as new PPTX
    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zout:
        for root_dir, dirs, files in os.walk(temp_dir):
            for file in files:
                file_path = os.path.join(root_dir, file)
                arcname = os.path.relpath(file_path, temp_dir)
                zout.write(file_path, arcname)

    # 8. Cleanup
    import shutil
    shutil.rmtree(temp_dir)

    return output_path
```

**Key insight:** Content_Types.xml uses absolute paths (`/ppt/slides/slideN.xml`), while the ZIP dict uses relative paths (`ppt/slides/slideN.xml`). Both must be consistent with what actually exists in the archive.

---

## 6. Recording Script Production

### Two Script Structures

**Short form (Steps 1-2):** ~22 paragraphs. Leaner structure because early steps are more introductory/conceptual.

**Full production form (Steps 3-5):** 60-82 paragraphs. Includes detailed [DEMO] sections, [SLIDE X] markers for every slide, [TIME WARNING] markers, common objections, and explicit transition cues.

### V3 Replacement Examples

When revamping scripts from V2 to V3:

```python
replacements = OrderedDict([
    # SPECIFIC/LONG first
    ("Module 2: Desktop & MCPs", "Step 2: Desktop + Cowork"),
    ("Module 3: Skills Extraction", "Step 3: Skills"),
    ("Module 4: Cowork Mode", "Step 4: MCPs - Connection Layer"),
    ("Module 5: Code & Closing", "Step 5: Code + Closing"),
    ("Module 2", "Step 2"),
    ("Module 3", "Step 3"),
    ("Module 4", "Step 4"),
    ("Module 5", "Step 5"),
    # GENERIC/SHORT last
    ("Module", "Step"),
])
```

### Dict Ordering Rule (CRITICAL)

```
WRONG: {"Module": "Step", "Module 2: Desktop & MCPs": "Step 2: Desktop + Cowork"}
  -> "Module 2: Desktop & MCPs" becomes "Step 2: Desktop & MCPs" (generic runs first)

RIGHT: {"Module 2: Desktop & MCPs": "Step 2: Desktop + Cowork", "Module": "Step"}
  -> Specific/long first, generic/short last
```

Use `OrderedDict` or Python 3.7+ dict (insertion-ordered) with entries sorted longest-first.

---

## 7. Student Materials

### Files and V3 Change Scope

| File | V3 Changes | Method |
|------|-----------|--------|
| EO-Mastery-Checklist.xlsx | MODULE -> STEP in all 5 sheets | openpyxl text replacement |
| EO-Student-QuickStart-Card.docx | MODULE -> STEP + timing references | python-docx |
| EO-Quick-Reference-Card.docx | MODULE -> STEP references | python-docx |
| claude-mastery-card.docx | MODULE -> STEP in mastery framework | python-docx |
| EO-MicroSaaS-Launch-Guide.docx | Minimal changes (not step-specific) | python-docx |

### Recording Timeline Exception (Ops Checklist)

The Recording Timeline sheet in `EO-Training-Ops-Checklist.xlsx` uses openpyxl direct cell assignment, NOT text replacement. Each cell has specific content that must be written explicitly:

```python
import openpyxl

wb = openpyxl.load_workbook('EO-Training-Ops-Checklist.xlsx')
ws = wb['Recording Timeline']

# Direct cell assignment for timeline data
ws['A2'] = 'Script finalization'
ws['B2'] = 'Step 1: Business Brain'
ws['C2'] = '2 hours'
# ... continue for all rows
```

This is because the Recording Timeline has structured data that doesn't follow simple text replacement patterns.

---

## 8. Trainer Materials

### PreCohort Guide Exception

The PreCohort Trainer Guide uses "SECTION 1/2/3" (not "STEP 1/2/3") to avoid naming collision with the main training steps. Steps refer to the training curriculum; Sections refer to the pre-cohort preparation phases.

```python
# PreCohort replacement dict - note SECTION preserved
precohort_replacements = OrderedDict([
    ("Module 1: Business Brain", "Step 1: Business Brain"),
    ("Module 2: Desktop & MCPs", "Step 2: Desktop + Cowork"),
    ("Module 3: Skills Extraction", "Step 3: Skills"),
    ("Module 4: Cowork Mode", "Step 4: MCPs - Connection Layer"),
    ("Module 5: Code & Closing", "Step 5: Code + Closing"),
    ("Module", "Step"),
    # DO NOT replace "SECTION" - it's intentional in PreCohort context
])
```

### Trainer Guide Structure

Per-step sections include: energy level target, talking points (not full script), time budget, delivery notes (pace, tone, emphasis), demo scripts with recovery plans, common objections and reframes, energy management notes.

---

## 9. Ops Checklist (xlsx)

### openpyxl Production Pattern

For text replacement across all sheets:

```python
import openpyxl

wb = openpyxl.load_workbook(filepath)
replacements = OrderedDict([
    ("Module 5: Code & Closing", "Step 5: Code + Closing"),
    ("Module 4: Cowork Mode", "Step 4: MCPs - Connection Layer"),
    ("Module 3: Skills Extraction", "Step 3: Skills"),
    ("Module 2: Desktop & MCPs", "Step 2: Desktop + Cowork"),
    ("Module 1: Business Brain", "Step 1: Business Brain"),
    ("Module", "Step"),
])

for ws in wb.worksheets:
    for row in ws.iter_rows():
        for cell in row:
            if cell.value and isinstance(cell.value, str):
                original = cell.value
                for old, new in replacements.items():
                    if old in cell.value:
                        cell.value = cell.value.replace(old, new)

wb.save(output_filepath)
```

The Recording Timeline sheet is the exception (see Section 7 above).

---

## 10. Python-docx Production Patterns

### Full Paragraph Rewrite Pattern

python-docx stores paragraph text across multiple "runs" (formatting spans). A word like "Module" might be split across runs as "Mod" + "ule" due to spell-check or formatting changes. Simple `run.text.replace()` fails on split text.

**Solution: collapse all runs into the first run, then replace.**

```python
from docx import Document

def replace_in_doc(doc_path, output_path, replacements):
    """
    replacements: OrderedDict of {old: new} - LONGEST/MOST-SPECIFIC FIRST
    """
    doc = Document(doc_path)

    for para in doc.paragraphs:
        # Collapse all runs into first run's text
        full_text = ''.join(run.text for run in para.runs)
        if not full_text:
            continue

        # Check if any replacement applies
        modified = full_text
        for old, new in replacements.items():
            if old in modified:
                modified = modified.replace(old, new)

        if modified != full_text:
            # Rewrite: put all text in first run, clear the rest
            if para.runs:
                para.runs[0].text = modified
                for run in para.runs[1:]:
                    run.text = ''

    doc.save(output_path)
```

### Two-Pass Verification

After replacement, verify no old terms remain:

```python
def verify_replacements(doc_path, old_terms):
    """Verify no old terms survive in the document."""
    doc = Document(doc_path)
    findings = {}
    for term in old_terms:
        count = 0
        for para in doc.paragraphs:
            full_text = ''.join(run.text for run in para.runs)
            count += full_text.count(term)
        if count > 0:
            findings[term] = count
    return findings  # Empty dict = all clear
```

### Table Cell Replacement

Tables have their own paragraphs. Must iterate separately:

```python
for table in doc.tables:
    for row in table.rows:
        for cell in row.cells:
            for para in cell.paragraphs:
                full_text = ''.join(run.text for run in para.runs)
                modified = full_text
                for old, new in replacements.items():
                    if old in modified:
                        modified = modified.replace(old, new)
                if modified != full_text and para.runs:
                    para.runs[0].text = modified
                    for run in para.runs[1:]:
                        run.text = ''
```

---

## 11. Quality Verification

### Post-Build Checklist

1. **Terminology scan:** `grep -c "Module"` across all output files should return 0 (except PreCohort SECTION context)
2. **Slide count verification:** Unzip PPTX, count slide XML files, compare to expected count
3. **WARP RECAP visual check:** Background is dark navy (not white), grey label, orange step label, white Georgia main text
4. **PPTX registration:** presentation.xml has correct sldId entries, presentation.xml.rels has matching Relationship entries, every slide has a .rels file
5. **Script alignment:** [SLIDE X] marker count matches actual slide count in corresponding deck
6. **Timing verification:** Section timings in agenda slides match script [TIME WARNING] markers
7. **Character encoding:** No curly/straight apostrophe mismatches in XML replacements

### Pattern Capture (Mandatory)

After every major deliverable, create a pattern capture file:

**Location:** `EO_Claude_Training/PatternCaptures/`
**Naming:** `pattern-[asset-type]-[context]-[date].md`
**Template:** 7 fields (Asset Type, Structure, Decision Points, Formatting, Iteration Log, MENA Adaptations, Reuse Template)

---

## File Structure (V3 Naming)

```
EO_Claude_Training/
├── 01-Training-Content/
│   ├── EO-Curriculum-Guide.docx
│   ├── EO-Trainer-Guide.docx
│   ├── EO-PreCohort-Trainer-Guide.docx
│   ├── EO-Recording-Script-06-Closing.docx
│   ├── EO-Training-Ops-Checklist.xlsx
│   ├── EO-S1-BusinessBrain/
│   │   ├── EO-Slides-S1-BusinessBrain.pptx
│   │   └── EO-Recording-Script-S1-BusinessBrain.docx
│   ├── EO-S2-DesktopCowork/
│   │   ├── EO-Slides-S2-DesktopCowork.pptx
│   │   └── EO-Recording-Script-S2-DesktopCowork.docx
│   ├── EO-S3-Skills/
│   │   ├── EO-Slides-S3-Skills.pptx
│   │   └── EO-Recording-Script-S3-Skills.docx
│   ├── EO-S4-MCPs/
│   │   ├── EO-Slides-S4-MCPs.pptx
│   │   └── EO-Recording-Script-S4-MCPs.docx
│   ├── EO-S5-CodeClosing/
│   │   ├── EO-Slides-S5-CodeClosing.pptx
│   │   └── EO-Recording-Script-S5-CodeClosing.docx
│   ├── Student Guide/
│   │   ├── EO-Mastery-Checklist.xlsx
│   │   ├── EO-Student-QuickStart-Card.docx
│   │   ├── EO-MicroSaaS-Launch-Guide.docx
│   │   ├── EO-Quick-Reference-Card.docx
│   │   └── claude-mastery-card.docx
│   └── Trainer Guide/
│       ├── EO-Trainer-Guide.docx
│       ├── EO-Trainer-Ops-Checklist.docx
│       └── EO-PreCohort-Trainer-Guide.docx
```

---

## Naming Convention Rules (V3)

| Deliverable Type | Pattern | Example |
|---|---|---|
| Slide Deck | `EO-Slides-S{N}-[StepName].pptx` | `EO-Slides-S2-DesktopCowork.pptx` |
| Recording Script | `EO-Recording-Script-S{N}-[StepName].docx` | `EO-Recording-Script-S3-Skills.docx` |
| Curriculum Guide | `EO-Curriculum-Guide.docx` | - |
| Trainer Guide | `EO-Trainer-Guide.docx` | - |
| Pre-Cohort Guide | `EO-PreCohort-Trainer-Guide.docx` | - |
| Training Ops | `EO-Training-Ops-Checklist.xlsx` | - |
| Training Macro | `Training-Macro.docx` | - |

**Last Updated:** 2026-03-12
**Version:** 3.0
**Source:** Battle-tested from Claude Mastery Training V3 production (PatternCaptures/)
