# Slide Architecture Patterns

Each slide type has a proven layout. Pick the right one for the content.

## Slide Types and When to Use Them

### 1. TITLE Slide

The opening frame. No footer bar. Centered composition.

**Layout:**
- Centered icon at top (0.7" x 0.7")
- Subtitle line (gray, charSpacing:4, 20pt)
- Main keyword LARGE (54pt, white, bold)
- Second subtitle (teal, charSpacing:3, 20pt)
- Orange divider line (centered, 3" wide, 0.04" tall)
- Tagline (italic, gray, 16pt)
- Author line (gray, 12pt)

**When:** First slide of every video.

```
┌─────────────────────────┐
│         [icon]          │
│    SUBTITLE LINE        │
│     MAIN WORD           │
│   second subtitle       │
│      ────────           │
│   tagline italic        │
│   author name           │
│                 1/15    │
└─────────────────────────┘
```

### 2. REALITY CHECK Slide

Kills excuses. Left column: things you DON'T need. Right column: what you DO need.

**Layout:**
- Title top-left (32pt)
- 3 "NO" cards stacked vertically (left side, darkGray fill)
  - Warning icon + bold text + gray subtext
- 1 "WHAT YOU NEED" box (right side, dark green fill, green left-border)
  - Bullet list of requirements

**When:** Second slide. Clears objections before the teaching starts.

```
┌─────────────────────────┐
│ THE REALITY CHECK       │
│ ──                      │
│ [!] No X needed  │ WHAT │
│ [!] No Y needed  │ YOU  │
│ [!] No Z needed  │ NEED │
│                  │ • A  │
│                  │ • B  │
│ @MamounAlamouri  │ • C  │
└─────────────────────────┘
```

### 3. CONCEPT / DEFINITION Slide

Explains a term, then compares two approaches.

**Layout:**
- Title top
- Definition box (full width, darkGray, 18pt white text)
- Two comparison columns below:
  - Left: "old way" (red accent)
  - Right: "new way" (green accent)
  - Orange "VS" circle between them

**When:** After reality check. Defines the core concept.

```
┌─────────────────────────┐
│ WHAT IS [CONCEPT]?      │
│ ──                      │
│ ┌─────────────────────┐ │
│ │ Definition text...  │ │
│ └─────────────────────┘ │
│ ┌──────┐ VS ┌──────┐   │
│ │Old   │    │New   │   │
│ │way   │    │way   │   │
│ └──────┘    └──────┘   │
└─────────────────────────┘
```

### 4. STRATEGY / OPTIONS Slide

Two equal options side by side. Empowers viewer to choose.

**Layout:**
- Title top
- Two tall cards (equal width, ~4.3" each)
  - Top accent bar (different color per option)
  - Option label (charSpacing:3, small, accent color)
  - Option name (22pt, bold, white)
  - Description (14pt, gray, line spacing 1.5)
  - Italic tagline at bottom (12pt, accent color)

**When:** Before the steps. Strategic fork in the road.

```
┌─────────────────────────┐
│ PICK YOUR STRATEGY      │
│ ──                      │
│ ┌──────────┐┌──────────┐│
│ │▄▄▄▄ teal ││▄▄▄▄ orng ││
│ │OPTION A  ││OPTION B  ││
│ │Name      ││Name      ││
│ │          ││          ││
│ │desc...   ││desc...   ││
│ │tagline   ││tagline   ││
│ └──────────┘└──────────┘│
└─────────────────────────┘
```

### 5. TOOLKIT Slide

Three tools/resources in equal columns.

**Layout:**
- Title top
- Three cards (equal width, ~2.8" each, ~3.5" tall)
  - Top accent bar (unique color each)
  - Centered icon (0.7" x 0.7")
  - Tool name (18pt, bold, centered)
  - Description (13pt, gray, centered)
- Italic caption at bottom ("All three are X. Different modes for Y.")

**When:** Right before the steps. Shows the "weapons" briefly.

```
┌─────────────────────────┐
│ YOUR TOOLKIT            │
│ ──                      │
│ ┌──────┐┌──────┐┌─────┐│
│ │▄ teal││▄ orng││▄ grn││
│ │[icon]││[icon]││[icon]││
│ │Name  ││Name  ││Name ││
│ │desc  ││desc  ││desc ││
│ └──────┘└──────┘└─────┘│
│ caption italic center   │
└─────────────────────────┘
```

### 6. STEP Slides (The Core)

Each step gets its own slide with a step badge and varied layouts. This is where you spend 70% of the deck. VARY THE LAYOUTS across steps to keep visual interest.

**Common elements on every step slide:**
- Step badge: orange rounded rect (0.55" x 0.55") top-left with white number
- Step title: 24pt bold next to badge
- Footer bar + slide number

**Layout variations for step content:**

#### A. Two-Card Layout
Two side-by-side cards with left-accent borders. Good for comparing two things or showing two download/install items.
```
[1] STEP TITLE
┌──────────┐ ┌──────────┐
│▎ Card A  │ │▎ Card B  │
│  desc    │ │  desc    │
└──────────┘ └──────────┘
┌──── PRO TIP ──────────┐
```

#### B. List Layout
Vertical list of items with icons. Good for file lists, feature lists, checklist items.
```
[1] STEP TITLE
┌─────────────────────┐
│ [icon] Item 1 - desc│
│ [icon] Item 2 - desc│
│ [icon] Item 3 - desc│
│ [icon] Item 4 - desc│
└─────────────────────┘
```

#### C. Numbered Steps with Sidebar
Left column: numbered steps (1., 2., 3...). Right column: callout box with extra context.
```
[3] STEP TITLE
1. First action...     ┌──────────┐
2. Second action...    │ KEY      │
3. Third action...     │ CONTEXT  │
                       │ box      │
                       └──────────┘
```

#### D. Horizontal Bars
Full-width bars stacked vertically. Good for showing tools, connections, or layers.
```
[5] STEP TITLE
┌─ [icon] Tool/Layer 1 ──────────┐
┌─ [icon] Tool/Layer 2 ──────────┐
┌─ [icon] Tool/Layer 3 ──────────┐
```

#### E. Terminal / Code Mockup
Dark box styled like a terminal window. Good for showing commands or code.
```
[7] STEP TITLE
┌─ terminal ──────────────────┐
│ > command one               │
│ > command two               │
│ > command three             │
└─────────────────────────────┘
```

#### F. Grid Cards
2x2 or 3x2 grid of small cards. Good for showing multiple related options.
```
[8] STEP TITLE
┌──────┐ ┌──────┐ ┌──────┐
│ Opt1 │ │ Opt2 │ │ Opt3 │
└──────┘ └──────┘ └──────┘
```

#### G. Action Cards with Letter Badges
Cards with bold letter identifiers (A, B, C). Good for distinct action items in a step.
```
[9] STEP TITLE
┌─ A ─────────┐
│ Action desc  │
├─ B ─────────┤
│ Action desc  │
├─ C ─────────┤
│ Action desc  │
└──────────────┘
```

### 7. CTA Slide (Closer)

Mirror the title slide energy. No footer bar. Centered composition.

**Layout:**
- Centered icon (larger than usual)
- Bold call to action text (28-32pt)
- Orange divider
- Tagline
- Subscribe/engage prompt
- Social handle

**When:** Last slide. Always.

## Layout Selection Guide

| Content Type | Best Layout |
|-------------|-------------|
| Two things to install/download | Two-Card (A) |
| List of files/items (4-6 items) | List (B) |
| Sequential actions with context | Numbered Steps + Sidebar (C) |
| Tools/layers/connections | Horizontal Bars (D) |
| Commands/code to run | Terminal Mockup (E) |
| Multiple options (3-6) | Grid Cards (F) |
| Distinct action items | Action Cards + Letters (G) |

## Critical Rule: Vary Your Layouts

Never use the same layout for consecutive step slides. If Step 1 uses Two-Card, Step 2 should use List or Horizontal Bars. The visual variety keeps the viewer engaged during the longest section of the deck.

Map out which layout each step will use BEFORE you start coding.
