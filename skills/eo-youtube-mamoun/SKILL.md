---
name: eo-youtube-mamoun
description: "YouTube Video Deck Builder for Mamoun Alamouri's channel. Produces bilingual (English + Arabic) PPTX slide decks with full recording scripts as speaker notes, dark tech visual identity, and RTL Arabic support. Triggers on: 'YouTube deck', 'video slides', 'recording deck', 'build slides for YouTube', 'new video deck', 'YouTube presentation', 'slides for my video', 'yt deck', 'build a deck for recording', 'presentation for YouTube video', or any request to create slide decks intended for YouTube video recording. Also triggers when the user mentions building slides with speaker notes/scripts, bilingual Arabic+English decks, or Mamoun's YouTube channel content. This skill should fire for ANY YouTube video slide deck request, even partial ones like 'build the Arabic version' or 'add speaker notes to these slides'. Do NOT trigger for: general presentations unrelated to YouTube recording, client pitch decks (use smo-offer-assets), EO training slides (use eo-training-factory)."
---

# YouTube Video Deck Builder

You are building slide decks for Mamoun Alamouri's YouTube channel (@MamounAlamouri). These decks serve a dual purpose: visual backdrop during recording AND standalone educational resource viewers can screenshot and reference.

## The Playbook (Read This First)

Mamoun's YouTube deck philosophy: "I am an architect and builder, not a tool guy. Focus on the playbook, not teaching theory."

Every video follows a pattern: identify a real problem the audience faces, demolish the excuses, lay out the framework, then walk through execution step by step. The slides support this narrative arc, not the other way around.

### Narrative Arc (Every Video)

```
1. TITLE          - Pattern interrupt hook. Bold claim.
2. REALITY CHECK  - Kill the excuses. "You don't need X, Y, Z."
3. CONCEPT        - Define the thing. Simple comparison.
4. STRATEGY       - Give options. Empower the viewer to choose.
5. TOOLKIT        - What they need (minimal). No tool worship.
6-N. STEPS        - The actual execution. One slide per step.
N+1. CTA          - Subscribe, engage, next video tease.
```

This is not rigid. Some videos may skip Strategy or Toolkit. Some may have 5 steps, some 12. The arc adapts to the content, but the principle holds: hook them, clear the path, walk them through it, call them to action.

### Before You Start

Ask the user (if not already specified):
1. **Video topic** and working title
2. **Number of steps** in the walkthrough
3. **Target length** (affects script depth in speaker notes)
4. **Languages needed**: English only, Arabic only, or both
5. **Any specific tools/products** being demonstrated

## Pre-Recording API Verification Gate (MANDATORY)

Before building any deck that demonstrates tools, APIs, or integrations, verify that all technical claims are current. Stale API examples in a YouTube video are permanent credibility damage.

### Why This Exists

YouTube videos live forever. A code example with a deprecated endpoint, wrong auth pattern, or missing parameter will generate confused comments for years. This gate prevents that.

### Execution

1. **List every API/tool shown in this video:**
   Write a quick inventory: "This video demonstrates GHL contact API, Instantly campaign API, n8n webhook node"

2. **Fetch current docs for each:**
   Invoke the get-api-docs skill for each API in the inventory:
   ```bash
   chub search "[tool name]" --json
   chub get [doc-id] --lang [py|js] -o /tmp/current-[tool]-for-video.md
   ```

3. **Check the gotchas knowledge base:**
   Read `API-Context-Hub/gotchas/[tool]-gotchas.md` for each tool in the inventory.
   Any HIGH-impact gotcha that affects the demo flow must be:
   - Mentioned in the video script (speaker notes)
   - Shown as a warning callout slide if it's a common trap

4. **Cross-reference code examples against fetched docs:**
   - Verify endpoint URLs, HTTP methods, required headers
   - Verify request/response payload shapes
   - Verify rate limits mentioned in the script
   - Verify auth patterns (API key vs OAuth vs Bearer)

5. **If discrepancies found:**
   - Update the slide content and speaker notes BEFORE recording
   - Add a "Common Gotcha" slide if the discrepancy is something viewers will hit
   - Log the finding to the relevant gotchas file (content published = false until video goes live)

### Gate Check

Do NOT proceed to Phase 2 (Build English Deck) until:
- [ ] API inventory documented for this video
- [ ] chub docs fetched for all APIs shown (or WebSearch if no chub doc)
- [ ] Gotchas KB checked for all tools demonstrated
- [ ] All code examples verified against current docs
- [ ] Any gotcha worth mentioning added as slide or speaker note callout

## Production Pipeline

### Phase 1: Content Architecture

Before touching PptxGenJS, outline the full deck:

- Map each slide to a segment of the narrative arc
- Write the one-line takeaway for each slide
- Estimate time allocation per slide (total should hit target video length)
- Identify which slide layouts fit each content type (see Slide Architecture reference)

### Phase 2: Build English Deck

Read `references/design-system.md` for colors, fonts, and visual rules.
Read `references/slide-architecture.md` for layout patterns per slide type.
Read `references/speaker-notes-guide.md` for recording script format.

Use the template helpers in `templates/helpers.js` as your starting boilerplate. This file contains the color constants, icon pipeline, footer/badge helpers, and shadow factory that are battle-tested.

Build with PptxGenJS (Node.js). Key rules from the pptx skill:
- Read the pptx skill's `pptxgenjs.md` for the full API reference
- NEVER use "#" in hex colors (corrupts file)
- NEVER reuse option objects (use factory functions like `makeShadow()`)
- Use `breakLine: true` in text arrays, never `\n` in multi-line text runs
- Use `bullet: true`, never unicode "•"
- Use `margin: 0` when aligning text precisely with shapes

Layout: `LAYOUT_16x9` (10" x 5.625") for English.

### Phase 3: Build Arabic Deck (if bilingual)

Read `references/rtl-arabic-guide.md` for the full RTL adaptation rules.

Key adaptations:
- Layout: `LAYOUT_WIDE` (13.3" x 7.5") gives more room for Arabic text
- Mirror all x-positions (step badges go right, slide numbers go left)
- Body text: `align: "right"`
- Tone: Gulf Arabic conversational, mix English tech terms naturally
- Speaker notes: Full Arabic recording script, same structure as English

### Phase 4: Speaker Notes (Recording Scripts)

Every slide gets a full recording script in speaker notes. This is not optional. The speaker notes ARE the video script.

Read `references/speaker-notes-guide.md` for format and examples.

### Phase 5: QA

Follow the pptx skill's QA workflow:
1. Content QA: `python -m markitdown output.pptx` - check for missing content, typos
2. Visual QA: Convert to images, inspect with subagent
3. Fix and re-verify

```bash
python scripts/office/soffice.py --headless --convert-to pdf output.pptx
pdftoppm -jpeg -r 150 output.pdf slide
ls slide-*.jpg
```

### Technical Accuracy QA (for API/tool videos only)

After visual QA, run a final technical accuracy check:

1. Re-read the fetched API docs from `/tmp/current-[tool]-for-video.md`
2. Compare every code snippet in the deck against the docs
3. Verify any numbers (rate limits, pricing, quotas) are still current
4. Check that gotcha callouts match the gotchas KB entries

If anything changed between deck build and QA (rare but possible with fast-moving APIs):
- Update the affected slides
- Re-run visual QA on changed slides only

## File Naming

```
yt-[lang]-[topic-slug]-[date].pptx
```

Examples:
- `yt-en-ship-microsaas-9steps-2026-03.pptx`
- `yt-ar-ship-microsaas-9steps-2026-03.pptx`

## Post-Recording: Publish Gotcha Discoveries

After the video is recorded and published:

1. **Update gotchas KB entries** that were surfaced during this video build:
   - Set `Content Published: true` on any gotcha that was discussed in the video
   - Add `Video Reference: yt-[lang]-[topic]-[date]` to the gotcha entry
   - This prevents duplicate coverage in future videos

2. **Log new discoveries** from viewer comments (ongoing):
   - Monitor video comments for "this doesn't work anymore" type feedback
   - If valid, add to the relevant gotchas file with `Source: viewer-feedback`
   - Flag the affected operator skill for reference file refresh

3. **Content recycling signal:**
   - Any gotcha with `Content Published: false` and `Impact: HIGH` is a candidate for its own video
   - Run `API-Context-Hub/skill-updates/phase4/gotchas-to-content-export.py` monthly to surface these

## Reference Files

| File | When to Read |
|------|-------------|
| `references/design-system.md` | Before building any deck. Colors, fonts, visual identity. |
| `references/slide-architecture.md` | When deciding layout for each slide type. |
| `references/rtl-arabic-guide.md` | When building Arabic version. RTL positioning rules. |
| `references/speaker-notes-guide.md` | When writing recording scripts for speaker notes. |
| `templates/helpers.js` | Copy as starting boilerplate for every new deck build. |
| `API-Context-Hub/gotchas/[tool]-gotchas.md` | Before building any deck with tool demos. Check for known traps. |
| `/tmp/current-[tool]-for-video.md` | During build. Live API reference fetched via chub. |

## Dependencies

```bash
npm install -g pptxgenjs react react-dom react-icons sharp
pip install "markitdown[pptx]"
```

LibreOffice and pdftoppm for visual QA (usually pre-installed).
