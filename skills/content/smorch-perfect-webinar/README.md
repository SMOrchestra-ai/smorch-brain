# smorch-perfect-webinar Skill

## Overview
This is a complete, reusable skill for building Perfect Webinar asset bundles. It packages the entire workflow for creating webinar/speaking engagement campaigns using Russell Brunson's Perfect Webinar framework.

## What's Included

### Main Skill File
- **SKILL.md** (318 lines) — The skill interface and intake workflow
  - Intake questionnaire (20 questions covering event details, stories, frameworks, offer, speaker details)
  - 7-phase workflow overview
  - Output file naming conventions
  - Reference file guide

### Reference Files (in `/references/`)
1. **perfect-webinar-framework.md** (208 lines)
   - Russell Brunson's Perfect Webinar structure explained
   - Core principle: belief shifts, not feature teaching
   - The three false beliefs (Vehicle/Internal/External)
   - The three secrets and framework reveals
   - Hard stop rules (what kills a webinar)

2. **story-architecture.md** (215 lines)
   - Epiphany Bridge structure (5 beats: Setup → Fall → Dark Night → Epiphany → New Belief)
   - Four stories needed (Origin + 3 Secrets)
   - "One specific moment" principle
   - Compressed vs. Full versions
   - Story quality checklist

3. **deck-structure.md** (920 lines)
   - Complete 20-slide breakdown
   - Design system (SMO brand colors: navy #0F1923, orange #FF6B35)
   - Slide-by-slide content + speaker notes with timing and stage directions
   - PptxGenJS implementation notes
   - Mobile responsive considerations

4. **social-templates.md** (381 lines)
   - 5 LinkedIn post templates (Big Promise → Secret 1 → Secret 2 → Secret 3 → Post-Event FOMO)
   - 1,200-1,500 character optimal length
   - Pattern interrupt opening lines
   - First comment strategy (link in comment, not body)
   - Post quality checklist

5. **email-templates.md** (430 lines)
   - 3-email sequence (Registration Push → Urgency/Last Call → Post-Webinar)
   - A/B subject line options for each email
   - 2 LinkedIn DM templates (Warm connection + Cold connection)
   - DM character limits and customization variables
   - Engagement tactics after sending

6. **landing-page-structure.md** (996 lines)
   - Complete HTML single-file VSL registration page
   - SMO design system (black background, orange accent)
   - Section-by-section breakdown
   - Full responsive HTML template with inline CSS and JavaScript
   - Countdown timer implementation
   - Form integration notes

## How to Use This Skill

### Step 1: Provide Intake Information
When triggering this skill, provide answers to the 20 questions in SKILL.md Phase 0:
- Event details (date, time, location, audience)
- Big Promise
- 3 False Beliefs (Vehicle/Internal/External)
- 3 Secrets + Framework names
- 4 Stories (Origin + 3 Secrets)
- Authority sources
- The Offer
- Speaker details
- Campaign timeline
- Language preference

### Step 2: Follow the 7-Phase Workflow

1. **Phase 1: Stories** → Creates `[event-name]-stories.md`
2. **Phase 2: Deck** → Creates `[event-name]-deck.pptx` using PptxGenJS
3. **Phase 3: Social Posts** → Creates 5 posts in `[event-name]-campaign-assets.md`
4. **Phase 4: Email Sequence** → Creates 3 emails in `[event-name]-campaign-assets.md`
5. **Phase 5: LinkedIn DMs** → Creates 2 DM templates in `[event-name]-campaign-assets.md`
6. **Phase 6: Landing Page** → Creates `[event-name]-registration-page.html`
7. **Phase 7: QA & Delivery** → PDF conversion, image extraction, verification

### Step 3: Deliverables
You'll receive:
- `[event-name]-stories.md` — All 4 stories (Origin + 3 Secrets), full + compressed versions
- `[event-name]-deck.pptx` — 20-slide Perfect Webinar deck with full speaker notes
- `[event-name]-deck.pdf` — PDF for visual QA
- `[event-name]-campaign-assets.md` — All social posts, emails, and DMs
- `[event-name]-registration-page.html` — Single-file registration page with countdown timer
- Slide images (key slides extracted for verification)

## File Naming Convention
All outputs follow this pattern:
```
[event-name]-[asset-type].[ext]

Examples:
- rakez-sales-2026-stories.md
- rakez-sales-2026-deck.pptx
- rakez-sales-2026-campaign-assets.md
- rakez-sales-2026-registration-page.html
```

## Design System (Embedded)

**Colors (SMO Brand):**
- Background: #0F1923 (dark navy) or #000000 (pure black)
- Accent: #FF6600 or #FF6B35 (orange)
- Text Primary: #FFFFFF (white)
- Text Secondary: #CCCCCC or #F0F0F0 (light gray/off-white)

**Typography:**
- Headlines: Inter Bold, 44-56px
- Body: Inter Regular, 24-28px (deck), 16-18px (page)
- Font fallback: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif

**Layout:**
- 16:9 aspect ratio (deck)
- Max-width 1200px (content)
- Responsive: 320px mobile, 640-1024px tablet, 1025px+ desktop

## Key Principles

### Perfect Webinar Framework
- **Shift beliefs, don't teach features**
- **3 False Beliefs → 3 Secrets → 3 Frameworks**
- **Every framework has a name** (PreMeeting Kill Sheet, 30-Second Trust Flip, WSO Cultural Accelerator)
- **Stories prove beliefs**, not lessons
- **Offer stacking creates perceived value**

### Content Standards
- **Contrarian > generic** (angle matters)
- **Specific > general** (one moment > broad narrative)
- **Proof > assertion** (stories and data > claims)
- **Pattern interrupt** (opening lines, headlines, CTAs)
- **Low friction next steps** (15-min call, not "let's discuss")

### Quality Checks
- [ ] No secret without a named framework
- [ ] No story without a specific moment
- [ ] No belief shift without proof (story + data)
- [ ] All dates, times, links correct
- [ ] No placeholder text
- [ ] Mobile responsive tested
- [ ] Countdown timer working

## Integration with Other Skills
- **smo-offer-assets** — Use for client pitch decks and offer pages (different from webinar decks)
- **eo-youtube-mamoun** — Use for YouTube video decks (different structure)
- **signal-to-trust-gtm** — Use for general campaign content without webinar context

## Notes for Operators
- This skill is self-contained and walk-through
- It guides the operator (or Mamoun) through each phase
- References are detailed enough to be implemented standalone
- All HTML/CSS/JavaScript is inline (no external assets needed)
- Deck requires PptxGenJS (npm package, already in the tech stack)
- Output files are ready to use/deploy immediately

## Version
- Created: 2026-03-14
- Based on: RAKEZ Sales Mastery webinar (tested, production-proven)
- Fits: SMOrchestra.ai brand + signal-based selling thesis
