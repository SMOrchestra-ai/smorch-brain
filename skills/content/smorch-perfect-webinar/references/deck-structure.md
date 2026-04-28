# Deck Structure: 23-Slide Perfect Webinar (V2)

Battle-tested on RAKEZ V6 (scored 8.6/10). This is the exact 23-slide breakdown with design system, speaker notes patterns, and PptxGenJS implementation.

---

## Design System (SMO Brand - V6 Battle-Tested)

**Colors:**
- BG_DARK: #0D0D1A (near-black navy, primary background)
- BG_CARD: #161625 (slightly lighter, card backgrounds)
- BG_CARD2: #1A1A2E (alternate card)
- BLUE_CARD: #1E1E38 (feature cards)
- ORANGE: #E8651A (accent, highlights, CTAs)
- WHITE: #FFFFFF (headlines, primary text)
- GRAY_LIGHT: #CCCCCC (body text, descriptions)
- GRAY: #888899 (footers, secondary info)
- RED_SOFT: #CC3333 (myth text, "before" states)
- GREEN_SOFT: #33AA55 (checkmarks, "after" states)

**Typography:**
- Headlines: Arial Bold, 28-36pt, WHITE
- Subheaders: Arial Bold, 16-20pt, ORANGE
- Body: Arial Regular, 13-16pt, GRAY_LIGHT
- Category labels: Arial Bold, 10-12pt, ORANGE, charSpacing: 3-4, all caps
- Speaker Notes: Any readable font, 12pt minimum

**Layout:**
- 16:9 aspect ratio (LAYOUT_16x9)
- Content area: x:0.8, w:8.4 (0.8" margins each side)
- Top bar: orange rect, x:0, y:0, w:10, h:0.06
- Footer: "smorchestra.ai | @mamounalamouri" at x:5.5, y:5.25, w:3.5, fontSize:9, right-aligned
- Slide number: x:9.3, y:5.15, w:0.5, fontSize:11, right-aligned
- Max 3-4 content elements per slide
- Cards with shadow: mkShadow() factory (blur:6, offset:2, angle:135, opacity:0.2)

---

## SLIDE-BY-SLIDE BREAKDOWN

### SLIDE 1: Title + Authority Hook

**Layout:**
- Top bar (orange)
- Category label: "{{EVENT_HOST}} FOUNDERS SESSION" (all caps, charSpacing)
- Main title: "WHY BEST DEALS" + "DIE IN SILENCE" (or your hook title)
- Subtitle: "The science of [your topic] in the first 90 seconds"
- Speaker name with letter-spacing
- Event host + speaker company logos (if available)

**Speaker Notes Pattern:**
```
TIMING: 30 seconds. Walk on stage. Let the room settle.
Do NOT start talking immediately. Stand center stage, scan the room left to right. Make eye contact with 3 people.
Then say: "Thank you for having me. My name is [NAME]. I've spent [X] years [CREDENTIAL]. And I'm going to share something today that took me [Y] of those years to figure out."
Click to next slide.
```

---

### SLIDE 2: Hook Question (Pattern Interrupt)

**Layout:**
- Large hook question (28pt, WHITE, bold)
- Subtext elements with different styling for emphasis
- [X-second silence] instruction visible as pale text
- Slide number

**Content Pattern:**
```
Have you ever KNOWN
your product was better...
and still
lost the deal?
[4-second silence]
```

**Speaker Notes Pattern:**
```
TIMING: 30 seconds total including the silence.
Read the slide slowly: "[HOOK QUESTION]"
Then STOP. Do not move. Do not click. Count to [X] in your head. Let the room sit in silence.
Look at one person in the front row. Hold eye contact during the silence.
Drop your voice to 60% volume for the next slide. This is the Late-Night FM DJ Voice technique.
The silence IS the point. The audience will feel uncomfortable. Good. That's what their prospects feel.
Click.
```

---

### SLIDE 3: Silence Payoff + Big Domino

**Layout:**
- Quote icon (top left, ORANGE, rendered via react-icons)
- Opening reframe in italic (connected to the silence they just felt)
- Orange divider line
- Big Domino statement below the line (the core insight, with key phrase in ORANGE bold)

**Content Pattern:**
```
[Quote icon]
"That silence you just felt?"
"That's what your prospects experience when [PROBLEM DESCRIPTION]."
"They just go quiet. You call it [COMMON WORD]. It's actually [YOUR REFRAME]."
---
"[BIG DOMINO]. And [BIG DOMINO IS ACTIONABLE]."
```

---

### SLIDE 4: THE BIG PROMISE (Most Important Slide)

**Layout:**
- Category label: "THE PROMISE" (all caps, ORANGE, charSpacing)
- Main promise text (22pt, WHITE)
- 3 "without" cards, each with:
  - X icon (RED_SOFT) on left
  - Without text in WHITE/GRAY_LIGHT
- Transition line: "Three myths are keeping you stuck. Let me break them." (ORANGE, bold)

**Content Pattern:**
```
THE PROMISE

By the end of this session, I'll show you how to [OUTCOME].

[X] Without [WITHOUT #1 - maps to Myth #1]
[X] Without [WITHOUT #2 - maps to Myth #2]
[X] Without [WITHOUT #3 - maps to Myth #3]

Three myths are keeping you stuck. Let me break them.
```

**Speaker Notes Pattern:**
```
TIMING: 90 seconds. THIS IS THE MOST IMPORTANT SLIDE IN THE DECK.
Stand still. Center stage. Hands at sides or one hand forward, palm up.
Say: "Here's what I'm going to show you in the next [DURATION] minutes."
Pause.
"[OUTCOME STATEMENT]."
Pause. Let it land.
"And I'm going to show you how to do it..."
Point to screen or gesture to each line:
"...without [WITHOUT #1]. [ELABORATION]."
"...without [WITHOUT #2]. [ELABORATION]."
"...without [WITHOUT #3]. [ELABORATION]."
Pause 3 seconds. Scan the room.
"Three myths are keeping you stuck. I believed all three of them. They cost me years. Let me break them for you in [DURATION] minutes."
Click.
```

---

### SLIDE 5: Accusation Audit

**Layout:**
- Italic text showing what the audience is thinking (skepticism)
- "Am I wrong?" in ORANGE at the bottom

**Content Pattern:**
```
Right now, some of you are thinking:

"Here we go. Another [CATEGORY] trainer.
He's going to tell me to [GENERIC ADVICE]
and [ANOTHER CLICHE]."

Am I wrong?
```

**Purpose:** Chris Voss technique. Name the objection before they think it. Builds massive trust.

---

### SLIDE 6: Origin Story (Epiphany Bridge)

**Layout:**
- Category label: "MY STORY" + story title
- Visual timeline or 3-4 phase boxes showing the journey
- Minimal text on slide (story is delivered verbally)

**Speaker Notes:** 2-3 minutes. Full Epiphany Bridge (Setup - Fall - Dark Night - Epiphany - New Belief). Include exact dialogue, pauses, voice direction.

---

### SLIDE 7: 4 Silent Killers

**Layout:**
- Category label: "THE 4 SILENT KILLERS"
- Title: "Why buyers go quiet (and what they're actually thinking)"
- 4 cards, each with:
  - Number badge (orange circle)
  - The buyer's QUESTION (relatable format, not framework jargon)
  - Brief description

**Content Pattern (use QUESTIONS, not labels):**
```
01: "Is this confusing? Am I going to drown in options?"
    Choice Overload - Too many providers, too many promises

02: "Have you actually done this before? With people like me?"
    Expectations Gap - Every vendor claims results

03: "Sounds great... but will this work HERE? In THIS market?"
    Information Overload - MENA buyers ask: have you done this with people like me?

04: "Is this worth my time? My money? My reputation?"
    Valuation Problem - They can't calculate ROI because they can't measure what they're losing
```

---

### SLIDE 8: The Big Shift (Research Backing)

**Layout:**
- Category label: "THE BIG SHIFT"
- Title: "What [X] million [data source] conversations reveal"
- 2-3 research stat callouts in large text
- Source citation at bottom

**Content Pattern:**
```
THE BIG SHIFT
What 2.5 million sales conversations reveal

[Large stat] 60% of deals are NOT lost to the competition.
They're lost to NO DECISION. The buyer freezes.

[Large stat] 56% of those frozen deals? It's not FOMO killing them.
It's FOMU: Fear Of Messing Up.

[Large stat] Urgency tactics? They backfire 84% of the time.

Source: JOLT Effect, Dixon & McKenna (2022)
```

---

### SLIDE 9: MYTH #1 -> SECRET #1

**Layout:**
- Red myth text at top: "MYTH #1: [The false belief]" (RED_SOFT, italic, 14pt)
- Secret title: "SECRET #1: [The truth]" (WHITE, bold, 28pt)
- Orange accent line
- Story snippet or framework tease below
- Optional: Quote icon + key story moment

**Content Pattern:**
```
MYTH #1: "[The method they think works]"

SECRET #1
[Contrarian truth title]

[Epiphany Bridge story compressed to key moments]
[Framework name teased]
```

**Speaker Notes:** 3 minutes. Myth statement, story (90 seconds), framework tease, transition.

---

### SLIDE 10: MYTH #2 -> SECRET #2

Same layout as Slide 9 but for the Internal belief.

**Key difference:** This secret often involves research/science (e.g., Princeton Trust Equation, Susan Fiske's Warmth x Competence research). Include the research visual on the NEXT slide.

---

### SLIDE 11: Trust/Research Visual

**Layout:**
- Visual representation of the research backing Secret #2
- Example: 2x2 grid (Warmth x Competence), danger zone highlighted
- Category labels on axes
- Key insight callout in ORANGE

**Purpose:** This slide makes Secret #2 feel research-backed, not opinion-based.

---

### SLIDE 12: MYTH #3 -> SECRET #3

Same layout as Slide 9 but for the External belief.

**Key for MENA:** This is where the "coffee meeting" myth lives. The story should be viscerally MENA-specific.

---

### SLIDE 13: Cultural/Market Visual

**Layout:**
- Visual representation of market-specific context
- Example: Erin Meyer's Cultural Trust Map (3 trust systems in one elevator)
- Shows how different markets build trust differently
- Key insight: "Your elevator has ALL three systems"

**Purpose:** Makes Secret #3 feel researched and market-aware.

---

### SLIDE 14: The System Tease (WSO or Your Named System)

**Layout:**
- Category label: "THE SYSTEM"
- System name: "[Your named framework]" (large, bold)
- 3 component cards, each with:
  - Orange accent bar on left
  - Icon (rendered in ORANGE via react-icons)
  - Component name (ORANGE, bold)
  - One-line description (GRAY_LIGHT)
- Transition line in italic at bottom

**Content Pattern:**
```
THE SYSTEM
Wedge. Signal. Outcome.

[Bolt icon] WEDGE - The one sentence that opens the conversation without triggering resistance.
[Crosshair icon] SIGNAL - The proof of competence delivered at the exact moment intent surfaces.
[Chart icon] OUTCOME - The decision path that makes buying feel like a mutual conclusion, not a close.

"This is the framework. What it looks like in practice? Let me show you."
```

**CRITICAL:** This is a TEASE, not a teach. Name the components, hint at what they do, do NOT explain the methodology.

---

### SLIDE 15: 3 Belief Shifts Summary

**Layout:**
- 3 horizontal cards, one per belief shift
- Each card: "From: [Old belief]" (GRAY) -> "To: [New belief]" (ORANGE)
- Icon per card (X for "from", check for "to")

---

### SLIDE 16: Cost of Inaction

**Layout:**
- Category label: "THE COST OF DOING NOTHING"
- 4 stat callouts in a grid (2x2)
- Each stat: large number + context line
- Footer: "Every month you wait, this compounds."

**Content Pattern:**
```
THE COST OF DOING NOTHING

[Stat 1] X deals lost to silence per quarter
[Stat 2] $XK average deal value sitting in "follow up later"
[Stat 3] X% of your pipeline is actually frozen, not active
[Stat 4] Your competitors are already doing this

Every month you wait, this compounds.
```

---

### SLIDE 17: "Does It Work?" Transition

**Layout:**
- Single centered text on dark background
- Bold, large, minimal

**Content:**
```
"Okay. Does this actually work?"

"Let me show you."
```

**Speaker Notes:** 10 seconds. Let the question hang. Then click.

---

### SLIDES 18-20: Case Studies (3 slides)

**Layout (per case study):**
- Category label: "CASE STUDY [#]: [COMPANY NAME]"
- Subtitle: "Silent Killers eliminated: #X + #Y"
- Two-column layout:
  - Left: BEFORE card (dark red-brown background, #1A1010 or similar)
    - "BEFORE" label in RED_SOFT
    - 3-4 bullet points of the broken state
  - Right: AFTER card (dark green background, #152815 or similar)
    - "AFTER" label in GREEN_SOFT
    - 3-4 bullet points of the transformed state with specific results
- Footer: Transition to next case study or combined proof

**TEACH MODE:** Frame as "Here's what this looks like in practice with a real company..."
**SELL MODE:** Frame as "Here's what happened when we implemented this..."

**Color notes (from V6 QA):**
- BEFORE background: dark reddish (#1A1010)
- AFTER background: dark green (#152815) - tested for contrast, don't go darker
- Text in both: GRAY_LIGHT for readability

---

### SLIDE 21: Combined Proof (Capstone)

**Layout:**
- Black background (#000000) - the ONLY slide with pure black
- Separated text elements (NOT one large text array - prevents bottom clipping):
  - Top: "Three companies. Over" (20pt, GRAY_LIGHT)
  - Center: "$[X] million" (54pt, WHITE, bold)
  - Below center: "in combined new revenue." (20pt, GRAY_LIGHT)
  - Bottom: "Same pattern every time. The positioning changed. Not the product." (16pt, ORANGE)

**Speaker Notes:** 30 seconds. Let the number do the work. 3-second pause after the number. Then the pattern statement.

**IMPORTANT PptxGenJS NOTE:** Use SEPARATE addText() calls for each text element. Do NOT put them in one text array - the large 54pt text will push bottom content off the slide.

---

### SLIDE 22: The Offer

**Layout (two columns):**
- Category label: "THE [OFFER NAME]"
- Title: "[Offer headline]" (28pt, bold)
- **Left column (60% width):** Stack items
  - Each item is a card with:
    - Icon (ORANGE, react-icons)
    - Item name (WHITE, bold, 14pt)
    - Myth linkage in italic (GRAY, 11pt): "Fixes Myth X: replaces [old way] with [new way]"
- **Right column (40% width):** Logistics panel (BG_CARD2 background)
  - Cohort size (ORANGE headline + description)
  - Duration
  - Format (mastermind, course, etc.)
  - Guarantee (green checkmark)
  - Email/contact
- **Bottom:** Qualifying criteria in small text ("IF you're in B2B. Crossed PMF. Ready to scale.")

**MODE VARIATIONS:**
- **TEACH MODE:** "For those who want to implement this systematically..." Soft. No urgency. Session 1 Guarantee.
- **SELL MODE:** Stack reveal with running total. "But wait, there's more." Scarcity counter. Deadline.
- **HYBRID:** Features from both, medium urgency.

---

### SLIDE 23: Close

**Layout:**
- Speaker name/title
- Contrarian thesis (the memorable one-liner they'll repeat to others)
- Strikethrough on a word for visual pattern interrupt
- Contact info
- Event host logo

**Content Pattern:**
```
[Speaker name] | [Company]

"[Contrarian thesis statement]"
~Relationship-based~ selling is a tax on growth.
Signal-based trust engineering is the replacement.

[Email] | [Social handle]
[Event host logo]
```

---

## PptxGenJS Implementation Notes

### Setup Pattern
```javascript
const pptxgen = require("pptxgenjs");
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
// Import specific icons from react-icons/fa

function renderIconSvg(Comp, color, size = 256) {
  return ReactDOMServer.renderToStaticMarkup(
    React.createElement(Comp, { color, size: String(size) })
  );
}

async function iconPng(Comp, color, size = 256) {
  // CRITICAL: react-icons needs # prefix on colors
  const c = color.startsWith("#") ? color : "#" + color;
  const svg = renderIconSvg(Comp, c, size);
  const buf = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + buf.toString("base64");
}

// Shadow factory - MUST use factory to avoid PptxGenJS mutation bug
const mkShadow = () => ({
  type: "outer", blur: 6, offset: 2, angle: 135,
  color: "000000", opacity: 0.2
});
```

### Slide Helpers
```javascript
function addTopBar(s) {
  s.addShape("rect", { x: 0, y: 0, w: 10, h: 0.06,
    fill: { color: ORANGE } });
}

function addFooter(s) {
  s.addText("smorchestra.ai  |  @mamounalamouri",
    { x: 5.5, y: 5.25, w: 3.5, h: 0.3, fontSize: 9,
      color: GRAY, fontFace: "Arial", align: "right" });
}

function addSlideNum(s, n) {
  s.addText(String(n),
    { x: 9.3, y: 5.15, w: 0.5, h: 0.4, fontSize: 11,
      color: GRAY, fontFace: "Arial", align: "right" });
}
```

### Known Pitfalls (from V6 QA)

1. **Icon color bug:** react-icons ignores colors without # prefix. Always use "#E8651A" not "E8651A".
2. **Shadow mutation:** PptxGenJS mutates shadow objects. Use `mkShadow()` factory, never reuse a shadow object.
3. **Footer/slide number overlap:** Footer at x:6.5 collides with slide number at x:9.3. Use x:5.5, w:3.5 for footer.
4. **Large text clipping on black slides:** One text array with 54pt text pushes bottom content off-slide. Use separate addText() calls.
5. **BEFORE/AFTER box contrast:** Don't use fills darker than #1A1010 (red) or #152815 (green). Text becomes unreadable.
6. **LibreOffice malloc warning:** `malloc_consolidate(): unaligned fastbin chunk detected` appears during PDF conversion. Ignore it - PDF is created successfully despite exit code 134.

---

## Visual QA Checklist

After generating the deck, convert to PDF/images and check:

- [ ] All text fully visible (no clipping at edges or bottom of boxes)
- [ ] Icons render in ORANGE, not black
- [ ] Footer text fully visible, not overlapping slide numbers
- [ ] BEFORE/AFTER boxes have readable text contrast
- [ ] No overlapping elements (text through shapes, lines through words)
- [ ] Consistent margins (minimum 0.5" from slide edges)
- [ ] Columns and cards aligned consistently
- [ ] Slide numbers present and readable
- [ ] Quote icons visible against dark background
- [ ] Category labels (all caps, charSpacing) render correctly
