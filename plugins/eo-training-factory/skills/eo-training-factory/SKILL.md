<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: eo-training-factory
description: "EO Training Factory - builds complete training products for Entrepreneurs Oasis MENA. Triggers: 'create training', 'build training', 'new training program', 'EO training', 'build a course', 'training for [topic]'. Also triggers on partial requests: 'build slides for step 3', 'arabize the student guide', 'create outbound sequences', 'YouTube videos', 'launch webinar', 'revamp scripts', 'update slide decks'. ENTRY POINT for all EO training work. Routes to 6 engines: training-content (slides, scripts, guides), gtm-assets (outbound, LinkedIn, VSL, landing pages), tools-builder (scorecards, frameworks, lead magnets), youtube-prep (5 attraction videos), webinar-launcher (Perfect Webinar), arabization (RTL Arabic). Do NOT trigger for: GTM campaigns unrelated to training (signal-to-trust-gtm), CRM ops (ghl-operator)."
---

# EO Training Factory

Master orchestrator for building complete training products for Entrepreneurs Oasis (EO) MENA, founded by Mamoun Alamouri. EO trains expert-to-founder MENA entrepreneurs to build micro-SaaS businesses.

This skill encodes the full methodology extracted from real V3 production builds. It asks the right questions, generates the master plan, then routes to specialized sub-skill engines for each deliverable category.

**V3 Production Context:** The Claude Mastery Training (first EO training product) uses a 5-step structure (not "modules"). V3 introduced narrative resequencing of Steps 3-5, WARP RECAP milestone slides, CLAUDE CONCEPT explainer slides, and python-docx/python-pptx production methods. All patterns in this factory are battle-tested from that production run.

## Routing Logic

When this skill triggers, determine what the user needs and route accordingly:

| User Says | Route To |
|-----------|----------|
| "Create training" / "Build training" / "New training program" | **Phase 0: BRD Alignment** (this file) then sub-skills in sequence |
| "Build slides" / "Create scripts" / "Student guide" / "Trainer guide" / "Curriculum" | Read `references/training-content-engine.md` |
| "Revamp slides" / "Update scripts" / "V3 resequencing" / "WARP RECAP" / "CONCEPT slides" | Read `references/training-content-engine.md` (Section: PPTX Production) |
| "Build GTM" / "Outbound sequences" / "LinkedIn posts" / "VSL" / "Landing page" / "Signal playbook" | Read `references/gtm-asset-engine.md` |
| "Build a scorecard" / "Create a framework" / "Lead magnet" / "Strategy selector" / "Interactive tool" | Read `references/tools-builder.md` |
| "YouTube videos" / "Video preps" / "Attraction content" / "YouTube for training" | Read `references/youtube-prep-engine.md` |
| "Webinar" / "Launch event" / "Perfect webinar" / "Training launch" / "Webinar script" | Read `references/webinar-launcher.md` |
| "Arabize" / "Arabic version" / "Translate to Arabic" / "RTL" / "Arabic deck" / "Arabic script" / "Arabic slides" / "-AR files" | Read `references/arabization-engine.md` |

For a FULL training build, execute phases in order. For individual deliverables, jump directly to the relevant sub-skill.

## Core Principles (Non-Negotiable)

1. **Arabic delivery, English-first assets.** Training is delivered in Arabic. All assets built in English first, then Arabized via the arabization-engine. Never build directly in Arabic.

2. **Demand-First Thinking.** "Think demand before you think product." Every training starts with market validation. The MAS score determines whether to build at all.

3. **The training IS the proof.** EO uses a 4-layer meta-learning architecture. The platform being taught is built LIVE during recording. The training itself is a GTM motion.

4. **Signal-based, not relationship-based.** MENA signals are different, not absent. Never frame MENA as signal-deficient.

5. **Specificity over generality.** "Ahmed, 35, runs 3 beauty clinics in JLT" - not "SME owners in UAE."

6. **Contrarian positioning.** Relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement.

7. **"STEP" terminology, not "MODULE."** All V3 assets use "Step 1", "Step 2" etc. "Module" was retired in V3. This applies to: slide covers, takeaway titles, bridge slides, scripts, student materials, trainer guides, and ops checklists.

## Phase 0: BRD Alignment (Interactive)

When triggered with "create training" or a new training build, run this interactive discovery. Ask these questions in conversational batches (not a wall of 20 questions). Push back on weak answers.

### Batch 1: The What & Who

Ask these first. Everything else depends on them.

**Questions to surface:**
- What does this training teach? What specific skill or capability does the graduate walk away with?
- What 3-4 belief shifts does this training create? (Start with limiting belief, end with capability belief)
- Who exactly is this for? Give me 3 named personas with city, age, industry, specific pain. Not segments, people.
- What is the live throughline? What real product gets built LIVE during recording to prove the methodology?

**How to handle answers:**
- If the belief arc is vague ("learn AI tools"), push back. Ask: "What does the graduate believe on Day 1 that they no longer believe on Day 30?"
- If personas are generic ("business owners in Dubai"), push back. Ask: "Name one. What's their name, what do they run, what keeps them up at night?"
- If there's no live throughline, flag it. The 4-layer meta-learning architecture requires it.

### Batch 2: Structure & Format

Once topic + audience are locked:

**Questions to surface:**
- Duration: How many hours total? What's the free/paid split? (Default: ~1h free + ~3h paid = ~4h total)
- Step count: How many steps? (Default: Free Hour + 5 paid steps + Closing)
- Recording format: Camera-on-Mamoun + Loom screen recording, team post-production? (This is the default, confirm or deviate)
- Tool landscape: What's the primary tool ecosystem? What complementary tools get mentioned?

**V3 Step Structure (Claude Mastery reference):**

| Step | Title | Duration | Core Content |
|------|-------|----------|--------------|
| S1 | Business Brain | 30 min | Project brain files, 12 context docs |
| S2 | Desktop + Cowork | 50 min | Artifacts, Cowork Mode, CLAUDE.md |
| S3 | Skills | 30 min | Skill extraction from Cowork session history |
| S4 | MCPs - Connection Layer | 30 min | MCP servers, tool connections |
| S5 | Code + Closing | 40 min | CLAUDE.md-first dev, prototype deployment |

**Duration cascade rule:** If one step's duration changes, all subsequent steps shift. S2 went from 45 to 50 min, cascading +5 min through S3-S5 timings.

### Batch 3: Business Model

Once structure is clear:

**Questions to surface:**
- Pricing ladder: What tiers? (Default pattern below)
- Community platform: SalesMfast (GHL-based) is the default. Confirm or override.
- Community benefits: Weekly Q&A, guest experts, future trainings access, peer accountability?
- Upsell path: What happens after training? Agency services? Premium community? 1-on-1?

**Default Pricing Pattern (push back if Mamoun underprices for Gulf market):**
- Founding Members (first 50): $97 - includes training + community. Mutual commitment: attend calls, share journey, testimonial in 60 days.
- Standard Price: $497 - training + 12mo community.
- Community renews at monthly rate after Year 1.

### Batch 4: GTM & Distribution

Once business model is locked:

**Questions to surface:**
- Domain/URL for landing page
- YouTube channel: existing or new?
- Launch timeline: when does recording start? When does it go live?
- Webinar launch: will there be a launch webinar? (If yes, the webinar-launcher sub-skill handles this)
- What tools/lead magnets should be built? (Routes to tools-builder sub-skill)

### Output: Training Macro

Once all decisions are closed, generate the Training Macro (.md + .docx):

Read `references/decision-protocol.md` for the decision closing format.
Read `references/docx-patterns.md` for .docx production patterns.

**Training Macro Structure:**
1. Strategic Context - what, who, belief arc, 4-layer meta-learning
2. Business Model - pricing ladder, community, upsell path
3. Core Frameworks - all scoring systems with rubrics (read `references/frameworks.md`)
4. Training Structure - timed step breakdown with V3 step titles
5. Live Throughline - step-by-step progression
6. Deliverable Manifest - all assets with formats
7. Recording Logistics - format, sequence, prep
8. Signal-Based Selling - MENA-specific signals (read `references/mena-context.md`)
9. All Decisions (Closed) - numbered, locked, no TBD allowed

## Full Build Sequence

After Training Macro is approved, build deliverables in this order. Read `references/asset-sequencing.md` for dependency graph and parallel build opportunities.

### Phase 1: Content Foundation
| # | Deliverable | Sub-Skill | Format |
|---|------------|-----------|--------|
| 1 | Curriculum Guide | training-content-engine | .docx |
| 2 | Strategy Selector / Lead Magnet Tool | tools-builder | .html/.jsx |
| 3 | Student Mastery Checklist | training-content-engine | .xlsx |
| 4 | Student Quick-Reference Card | training-content-engine | .docx |

### Phase 2: Production Assets
| # | Deliverable | Sub-Skill | Format | Production Method |
|---|------------|-----------|--------|-------------------|
| 5 | Slide Decks (1 per step) | training-content-engine | .pptx | Base slides + raw XML (WARP RECAP) + python-pptx (CONCEPT) |
| 6 | Recording Scripts (1 per step) | training-content-engine | .docx | python-docx text replacement with dict ordering |
| 7 | Trainer Guide | training-content-engine | .docx | python-docx |
| 8 | Pre-Cohort Trainer Guide | training-content-engine | .docx | python-docx (uses SECTION not STEP) |
| 9 | Training Ops Checklist | training-content-engine | .xlsx | openpyxl direct cell + text replacement |

**V3 Slide counts (battle-tested):**
- Step 1: 20 slides (intro-heavy)
- Step 2: 17 slides (includes 2 CLAUDE CONCEPT slides)
- Step 3: 14 slides (12 base + 2 WARP RECAP)
- Step 4: 14 slides (12 base + 2 WARP RECAP)
- Step 5: 18 slides (16 base + 2 WARP RECAP)

**V3 Script structures:**
- Steps 1-2: Short form (~22 paragraphs)
- Steps 3-5: Full production form (60-82 paragraphs)

### Phase 3: GTM Assets (Revenue Engine)
| # | Deliverable | Sub-Skill | Format |
|---|------------|-----------|--------|
| 10 | YouTube Video Preps (5 videos) | youtube-prep-engine | .docx |
| 11 | LinkedIn Post Series | gtm-asset-engine | .docx |
| 12 | VSL Scripts (1-min + 5-min) | gtm-asset-engine | .docx |
| 13 | VSL Landing Page | gtm-asset-engine | .html |
| 14 | Outbound Sequences | gtm-asset-engine | .docx |
| 15 | Signal Outbound Playbook | gtm-asset-engine | .docx |
| 16 | One-Pagers (EN + AR) | gtm-asset-engine | .pdf |

### Phase 4: Launch Assets
| # | Deliverable | Sub-Skill | Format |
|---|------------|-----------|--------|
| 17 | Webinar Script + Slides | webinar-launcher | .docx + .pptx |
| 18 | Webinar Registration Page | webinar-launcher | .html |
| 19 | Webinar Follow-Up Sequences | webinar-launcher | .docx |

### Phase 5: Arabization
| # | Deliverable | Sub-Skill | Format |
|---|------------|-----------|--------|
| 20 | Arabic versions of ALL above | arabization-engine | -AR.* |

### Phase 6: Self-Learning
After every major deliverable, append to `references/build-log.md`: date, what worked, what Mamoun corrected, patterns to remember. Also create pattern capture files per `PatternCaptures/` methodology.

## V3 Revamp Protocol

When updating existing assets from V2 to V3 (or any version bump):

**Text replacement rules (battle-tested):**
1. Build replacement dict with SPECIFIC/LONG replacements FIRST, GENERIC/SHORT replacements LAST
2. For python-docx: use full paragraph rewrite pattern (collapse all runs into first run)
3. For xlsx: iterate all sheets, all rows, all cells
4. Always verify with regex scan after replacement: `grep -c "old_term"` should return 0
5. For PPTX: XML replacement uses `content.replace(f'>{old}<', f'>{new}<')` pattern
6. Watch for character encoding: curly apostrophe (U+2019) vs straight (U+0027) causes silent failures

**Critical dict ordering rule:**
```
WRONG: {"Cowork": "MCPs", "Cowork session": "MCP connection"}
  -> "Cowork session" becomes "MCPs session" (generic runs first, corrupts specific)

RIGHT: {"Cowork session": "MCP connection", "Cowork": "MCPs"}
  -> Specific/long first, generic/short last
```

**PreCohort Guide exception:** Uses "SECTION 1/2/3" not "STEP 1/2/3" to avoid naming collision with the main training steps.

## Folder Structure (V3, per Training)

```
EO_Claude_Training/
├── Training-Macro.md
├── Training-Macro.docx
├── PatternCaptures/                    (production pattern docs)
│   └── pattern-[asset-type]-[context]-[date].md
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
├── 02-Tools/
│   └── (interactive HTML tools, scorecards, frameworks)
├── 03-GTM-Sales/
│   ├── EO-YouTube-Video-Preps.docx
│   ├── EO-LinkedIn-Post-Series.docx
│   ├── EO-VSL-Scripts.docx
│   ├── EO-VSL-Landing-Page.html
│   ├── EO-Outbound-Sequences.docx
│   ├── EO-Signal-Outbound-Playbook.docx
│   └── EO-Training-One-Pager-*.pdf
├── 04-Launch/
│   ├── EO-Webinar-Script.docx
│   ├── EO-Webinar-Slides.pptx
│   ├── EO-Webinar-Registration.html
│   └── EO-Webinar-FollowUp-Sequences.docx
└── 05-Reference/
    └── (pricing strategy, ICP docs, pattern captures)
```

## Mamoun's Working Style

- **Corrects fast, expects immediate integration.** Apply corrections across ALL files, not just the one mentioned.
- **Thinks in systems.** A pricing change cascades to positioning, community, upsell, and every GTM asset.
- **"Agree with all" = locked permanently.** No reopening.
- **Values pushback.** Challenge when something doesn't make strategic sense.
- **"Most important" means quality ceiling, not speed.** YouTube preps = highest investment.
- **Arabic-first market intuition.** Trust his market read. Challenge execution, not market insight.
- **Corrects in batches.** 4+ items at once. Apply ALL corrections across ALL files immediately.
- **Pattern capture is mandatory.** After every deliverable, capture production patterns to `PatternCaptures/` using the 7-field template.

## Reference Files

| File | When to Read |
|------|-------------|
| `references/training-content-engine.md` | Building slides, scripts, guides, student materials, curriculum. Contains PPTX production patterns (WARP RECAP, CLAUDE CONCEPT, corruption repair), python-docx patterns, V3 narrative structure. |
| `references/gtm-asset-engine.md` | Building LinkedIn posts, outbound sequences, VSL, landing pages, playbooks |
| `references/tools-builder.md` | Building interactive tools, scorecards, frameworks, lead magnets |
| `references/youtube-prep-engine.md` | Building YouTube attraction videos |
| `references/webinar-launcher.md` | Building launch webinar assets (includes full Perfect Webinar framework by Brunson) |
| `references/arabization-engine.md` | Arabizing any training or GTM asset |
| `references/decision-protocol.md` | During Phase 0 BRD alignment |
| `references/docx-patterns.md` | Creating any .docx file (python-docx patterns, NOT docx-js) |
| `references/mena-context.md` | Writing MENA-specific content, Arabic adaptation rules |
| `references/frameworks.md` | Referencing MAS, ICP, GTM, Strategy Selector, Belief Arc |
| `references/asset-sequencing.md` | Planning build order and parallel opportunities |
| `references/build-log.md` | Start of every build (read) and end of every deliverable (write) |
