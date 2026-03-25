---
name: smorch-project-brain
description: "Project Brain System — creates structured project context files from raw inputs (slides, docs, verbal context, web research). Supports 7 project types with deep/quick modes. Triggers on: 'create project brain', 'new project', 'start a project', 'build project files', 'project brain for [client]', 'set up [client name]', 'initialize project', 'brain for [project]', or any upload of client files (PPTX, DOCX, PDF) with context suggesting new project setup. Also triggers on: 'update project brain', 'add to brain', 'brain has changed', 'new input for [project]'. Do NOT trigger for: EO student brain ingestion (eo-brain-ingestion), campaign asset creation without project setup (signal-to-trust-gtm), individual file creation (positioning only, ICP only)."
---

# SMOrchestra Project Brain System

## PURPOSE

Transform raw inputs into structured project files that become the permanent source of truth for everything built afterward. The brain is the single contract between strategy and execution. Every downstream skill reads from the same brain files. Zero re-asking.

## EXECUTION FLOW

```
Q0: MODE → Q1: PROJECT TYPE → PHASE 0: VALIDATE INPUTS → PHASE 1: EXTRACT → PHASE 2: SCORE + GAP-FILL → PHASE 3: GENERATE → PHASE 4: VERIFY
```

---

## Q0: MODE DETECTION (First question, always)

Ask the user:

**"Deep brain or quick brain?"**

| Mode | When to Use | Files Generated | Gap-Fill Rounds | Quality Gate | Time |
|------|------------|-----------------|-----------------|-------------|------|
| **DEEP** | Strategic project, long-term, multi-campaign, high-revenue | All 8 core + type-specific extensions | 2 rounds max | 8.5/10 minimum | 20-40 min |
| **QUICK** | Fast turnaround, single deliverable, exploratory, small scope | 4 essential files only | 1 round max | 7.0/10 minimum | 5-15 min |

**DEEP mode files (8 core):** company-profile.md, icp.md, positioning.md, offer.md, competitive-landscape.md, brand-voice.md, gtm-channels.md, project-instruction.md + type-specific extensions + mena-context.md (default)

**QUICK mode files (4 essential):** company-profile.md, icp.md, positioning.md, project-instruction.md

**Upgrade rule:** A quick brain can be upgraded to deep at any time. Trigger: "go deeper on this project" or "upgrade to deep brain." The analyzer scores existing files and runs gap-fill on missing/weak dimensions. No re-asking for data already captured.

---

## Q1: PROJECT TYPE (Second question)

Ask the user:

**"What type of project is this?"**

| Type | Code | Description | Type-Specific Extensions (DEEP only) |
|------|------|-------------|--------------------------------------|
| Tech Product | `tech` | SaaS, platform, or tool build | tech-spec.md, revenue-model.md |
| GTM Consulting | `gtm-consulting` | Advisory engagement, strategy + recommendations | engagement-model.md |
| GTM Agency | `gtm-agency` | Done-for-you execution, campaigns + automation | engagement-model.md |
| Recorded Training | `training-recorded` | Pre-recorded course or video series | curriculum.md, content-plan.md |
| Cohort Training | `training-cohort` | Live cohort with fixed start/end, group dynamics | curriculum.md, content-plan.md |
| Mastermind / Community | `community` | Ongoing membership, peer group, community | community-design.md, content-plan.md, revenue-model.md |
| Distribution | `distribution` | Launch platform, marketplace, directory | distribution-spec.md, revenue-model.md, content-plan.md |

---

## Q2: INPUT DETECTION (Third question)

Ask the user:

**"What inputs do you have?"**

| Input Mode | Detection | Execution Path |
|-----------|-----------|----------------|
| A) Files only (PPTX/DOCX/PDF) | User uploads files | FILE-FIRST path |
| B) Verbal context only | No files, user describes | INTERVIEW path |
| C) Files + verbal | Mixed inputs | HYBRID path (files first, verbal fills gaps) |
| D) URL/LinkedIn only | URL provided | RESEARCH path |
| E) Updating existing brain | Brain already exists | UPDATE path |

---

## PHASE 0: INPUT VALIDATION

Before extracting anything, validate what we received.

### File Format Check
- **Supported:** PPTX, DOCX, PDF, URL (website or LinkedIn)
- **Unsupported:** .key (Keynote), .pages, .numbers, image-only PDFs → WARN user, offer verbal gap-fill as primary path
- **Empty/corrupted files** → Reject with clear message

### Extraction Yield Score
After initial extraction attempt, score the yield:

| Yield | Label | Action |
|-------|-------|--------|
| >50% of brain fields populated | HIGH | Proceed to Phase 1 with confidence |
| 20-50% populated | MEDIUM | Proceed, flag heavy gap-fill needed |
| 5-20% populated | LOW | Warn user: "Your files gave me [X] of [Y] fields. I'll need to ask you about [list missing areas]" |
| <5% populated | INSUFFICIENT | "These files don't contain enough structured data for a brain. Let's switch to verbal intake." |

Report to user: "From your [file type], I extracted: [list of fields found]. Missing: [list of gaps]. Proceeding to gap-fill."

### Save Raw Inputs
Copy all uploaded files to: `/projects/[client-name]/references/`
- PPTX → `/references/slides/`
- DOCX/PDF → `/references/docs/`
- Scraped web content → `/references/web/`
- Verbal notes → `/references/notes/` (save as transcript.md)

---

## PHASE 1: EXTRACTION

### Execution Path: FILE-FIRST

1. Detect file type
2. Extract text content:
   - PPTX: Unpack slides, read text + speaker notes per slide
   - DOCX: Pandoc text extraction or direct paragraph reading
   - PDF: PDF text extraction (pdftotext or equivalent)
3. Map extracted content to brain file fields using **references/extraction-map.md**
4. Score confidence per field: HIGH (clear match to slide title/heading), MEDIUM (inferred from context), LOW (ambiguous)
5. Produce intermediate extraction: `extraction-report.md` (field → value → source → confidence)

### Execution Path: INTERVIEW

Round 1: Foundation (5 questions, always asked)
1. **Project overview:** "Describe the project in 2-3 sentences. What is it, who is it for, and what problem does it solve?"
2. **Customer:** "Describe your ideal customer. Job title, company size, industry, geography. One specific person if possible."
3. **Pain:** "What are the top 3 pains this customer has that your project solves? Be specific: frequency, dollar cost, emotional weight."
4. **Differentiation:** "What makes this different from alternatives? What do you do that competitors can't or won't?"
5. **Pricing + delivery:** "How is this priced and delivered? Timeline, format, what the customer gets."

Round 2: Depth (DEEP mode only, 5 questions)
6. **Competitors:** "Name 3 direct competitors and their biggest weakness."
7. **GTM channels:** "Where does your customer hang out? How will you reach them? LinkedIn, WhatsApp, events, email, referrals?"
8. **Voice + tone:** "Describe the voice for this project. Direct? Educational? Provocative? Give me 3 words and an example sentence."
9. **MENA specifics:** "Is this project MENA-focused? If yes: which countries, Arabic or English primary, WhatsApp or email for outreach?"
10. **Success metrics:** "What does success look like in 90 days? One number that proves this worked."

Round 3: Targeted (both modes, only if gaps remain after Round 1-2)
3-5 targeted questions addressing specific missing fields. See gap-fill protocol below.

### Execution Path: HYBRID

1. Run FILE-FIRST extraction
2. Score extraction yield
3. Identify gaps
4. Run INTERVIEW but ONLY for gaps (skip questions where file extraction was HIGH confidence)
5. Merge: file extraction + verbal answers. Verbal OVERRIDES file data when conflict detected

### Execution Path: RESEARCH

1. Scrape URL or LinkedIn profile/company page
2. Extract: company description, product/service, team, pricing (if visible), case studies, recent posts
3. Score extraction yield
4. Run INTERVIEW for all gaps (web scraping rarely yields >30% of brain fields)

### Execution Path: UPDATE

1. Read existing brain files from `/projects/[client-name]/brain/`
2. Process new input (file, verbal, or URL)
3. Produce diff: what's new vs. what exists
4. Present diff to user: "Here's what changed. Confirm or correct."
5. Merge approved changes
6. Run correction cascade (see references/self-learning-protocol.md)

---

## PHASE 2: GAP ANALYSIS + GAP-FILL

### Completeness Scoring

Score each brain file on field coverage:

| Score | Label | Meaning |
|-------|-------|---------|
| 90-100% | STRONG | All fields populated with specific, actionable data |
| 70-89% | ADEQUATE | Most fields populated, some weak or generic |
| 50-69% | WEAK | Major gaps, enough to start but needs iteration |
| <50% | INSUFFICIENT | Too many gaps. DEEP mode: must gap-fill. QUICK mode: acceptable with [UNDEFINED] tags |

### The 3-Option Gap-Fill Protocol

For every MISSING or WEAK field, present:

```
FIELD: [field name] in [brain file]
STATUS: MISSING | WEAK (current value: "[what was extracted]")
GAP: [what specific information is needed]

Options:
  (A) PROVIDE — You give me this information now
  (B) RESEARCH — I research and suggest, you confirm or correct
  (C) DEFER — Mark as [UNDEFINED: description] for later
```

**Rules:**
- Group related gaps together (all ICP gaps in one batch, all positioning gaps in one batch)
- DEEP mode: max 2 rounds of gap-fill (8-10 questions total across both rounds)
- QUICK mode: max 1 round (3-5 questions)
- If user picks (B) RESEARCH: use web search to find data. Tag result as `[RESEARCHED — VERIFY: source URL]`
- If user picks (C) DEFER: field shows `[UNDEFINED: what's needed to complete this field]`
- After gap-fill, re-score all files. Report improvement: "Brain completeness: X% → Y%"

### Cross-File Consistency Check

After scoring, validate:

| Rule | Check | Severity |
|------|-------|----------|
| ICP ↔ Positioning | ICP's top pain must appear in positioning statement | HARD STOP — fix before generating |
| ICP ↔ GTM Channels | Access channels in icp.md must match gtm-channels.md | WARNING — flag but don't block |
| Offer ↔ ICP | Offer price must be within ICP's budget range | WARNING |
| Positioning ↔ Competitive | Unique mechanism must address a gap in competitive-landscape.md | HARD STOP |
| Brand Voice ↔ Global CLAUDE.md | No duplication of Mamoun's global voice rules | WARNING |
| mena-context ↔ company-profile | If geography includes MENA, mena-context.md must not be empty | WARNING |

---

## PHASE 3: GENERATION

### Core Brain Files (see architecture doc for full templates)

**DEEP mode generates:**
1. `company-profile.md` — Client/venture overview, problem, market, product, assessment
2. `icp.md` — Primary persona, pains (5), dream outcome, buying behavior, access channels, anti-personas
3. `positioning.md` — Category, competitive alternatives, unique mechanism, positioning statement, wedge, differentiators
4. `offer.md` — Value stack, pricing, guarantee, delivery, success metrics
5. `competitive-landscape.md` — Direct/indirect competitors, positioning map, gap exploitation
6. `brand-voice.md` — Character, language rules, writing rules, words to use/avoid, examples
7. `gtm-channels.md` — Primary/secondary channels, channel rules, motion priority
8. `project-instruction.md` — CLAUDE.md for this project (see references/instruction-design.md for design principles)
9. `mena-context.md` — DEFAULT for all projects (see references/mena-context.md)
10. Type-specific extension files per Q1 answer

**QUICK mode generates:**
1. `company-profile.md` — Condensed: venture overview + problem + product only
2. `icp.md` — Condensed: persona + top 3 pains + dream outcome only
3. `positioning.md` — Condensed: category + unique mechanism + wedge only
4. `project-instruction.md` — Condensed: what this is + who we serve + 3 decision rules + file references

### File Generation Rules

1. **Every claim must be traceable.** If a field comes from a file, tag: `[SOURCE: filename.pptx, slide 4]`. If from verbal, tag: `[SOURCE: user input]`. If from research, tag: `[RESEARCHED — VERIFY: URL]`. If deferred, tag: `[UNDEFINED: what's needed]`
2. **Specificity over generality.** Never write "businesses" when you can write "Series A SaaS companies with 20-50 employees in UAE selling to enterprise." Never write "pain point" when you can write "loses 3 deals/month because proposals take 2 weeks to produce."
3. **Markdown format.** All files use markdown with H2 sections and bullet lists. No YAML frontmatter in brain files (keeps them human-readable and Claude-parseable).
4. **Line budget.** Each file stays within its line budget (defined in architecture doc). Concise > comprehensive.
5. **No duplication of global CLAUDE.md content.** project-instruction.md must NOT repeat Mamoun's tone rules, word bans, or communication preferences. It ONLY contains project-specific context. See references/instruction-design.md.

### Project Instruction Design (CRITICAL)

The project-instruction.md follows 6 design principles from references/instruction-design.md:

1. **Positive over negative** — "Use WhatsApp for warm MENA leads" not "Don't use email for MENA"
2. **Behavioral over trait** — "When creating content, lead with the ICP's #1 pain" not "Be pain-focused"
3. **Critical rules at edges** — Most important rules in first and last sections (highest attention zones)
4. **Verifiable in 5 seconds** — Each rule can be checked in one pass of a deliverable
5. **No duplication across layers** — project-instruction.md overrides, never duplicates, global CLAUDE.md
6. **Meta-patterns scale** — Define named frameworks ("use the Signal-to-Trust framework") and reference by name

### Save Output

All generated brain files saved to: `/projects/[client-name]/brain/`

project-instruction.md is also copied to `/projects/[client-name]/CLAUDE.md` (project root) so Claude auto-loads it when working in that folder.

---

## PHASE 4: VERIFICATION

### Self-Score (8 dimensions)

Score each dimension 1-10. Read references/quality-rubrics.md for scoring criteria.

| Dimension | What a 10 Looks Like |
|-----------|---------------------|
| 1. Extraction accuracy | Every field traces to a specific source. Zero fabrication |
| 2. Specificity | Named entities, numbers, quoted language in every field |
| 3. Consistency | Zero contradictions across brain files |
| 4. Actionability | A downstream skill can use any file immediately without follow-up |
| 5. Completeness | All required files exist, all required fields populated |
| 6. MENA context | Regional specifics present where applicable |
| 7. Positioning clarity | Wedge is sharp, mechanism is defensible, not generic |
| 8. Commercial grounding | Pricing, revenue model, or budget reality is present and realistic |

**Thresholds:**
- DEEP mode: minimum 8.5/10 overall, no dimension below 7.0
- QUICK mode: minimum 7.0/10 overall, no dimension below 5.0
- Any dimension below threshold: auto-iterate on that dimension (re-extract, refine, or ask one targeted question)

### Spot-Check Protocol

After self-scoring, read back 3 critical decisions to the user for confirmation:
1. "Your positioning wedge is: [wedge]. Correct?"
2. "Your ICP's #1 pain is: [pain]. Correct?"
3. "Your primary GTM channel is: [channel]. Correct?"

If user corrects any: update the relevant brain files, run correction cascade, re-score.

### Brain Log

Write to `/projects/[client-name]/brain-log.md`:

```markdown
## [date] — Brain Created
- Mode: DEEP | QUICK
- Project type: [type]
- Input types: [PPTX, verbal, URL, etc.]
- Extraction yield: [X/Y fields from files]
- Gap-fill rounds: [N rounds, M questions asked]
- Quality score: [X/10 per dimension, overall]
- Fields deferred: [list of [UNDEFINED] fields]
- Corrections applied: [list if any spot-check corrections]
```

### Deliver

Present to user:
- Summary: "Brain created for [project name]. Mode: [DEEP/QUICK]. Completeness: [X]%. Quality: [X/10]."
- List of files generated with links
- If any [UNDEFINED] fields: "These fields are deferred: [list]. You can complete them anytime with 'update brain for [project]'."
- If QUICK mode: "This is a quick brain. Say 'upgrade to deep brain' anytime to expand it."

---

## DOWNSTREAM INTEGRATION RULES

### Rule 1: INTEGRITY
Downstream skills read from `/projects/[client-name]/brain/` and NEVER re-ask the user for data already captured in brain files. If a downstream skill needs data not in the brain, it requests a brain update through this skill, NOT through direct user questioning.

### Rule 2: PROGRESSIVE ENHANCEMENT
Downstream skills MAY append discoveries to brain files (e.g., campaign-strategist adds winning wedge variants to positioning.md). They MUST NOT delete or overwrite existing content. Additions are tagged: `[DISCOVERED: source-skill, date]`

### Rule 3: FORMAT
All brain files are consumed as markdown. Downstream skills parse markdown headers and bullet lists directly. No JSON export layer. If a downstream skill requires structured data, it transforms markdown at consumption time.

---

## REFERENCE FILES

Read these BEFORE execution. They contain the depth that makes this skill produce 9/10 output.

| File | When to Read | Purpose |
|------|-------------|---------|
| `references/extraction-map.md` | Phase 1 (extraction) | Field-level mapping rules for PPTX/DOCX/PDF/URL inputs |
| `references/frameworks/positioning-framework.md` | Phase 3 (generating positioning.md) | April Dunford + Hormozi + Brunson synthesized |
| `references/frameworks/icp-framework.md` | Phase 3 (generating icp.md) | Pain hierarchy, persona construction, buying behavior |
| `references/frameworks/offer-design-framework.md` | Phase 3 (generating offer.md) | Hormozi Grand Slam Offer + value stack |
| `references/frameworks/competitive-framework.md` | Phase 3 (generating competitive-landscape.md) | Positioning Against methodology |
| `references/frameworks/gtm-motions.md` | Phase 3 (generating gtm-channels.md) | 13 GTM motions with scoring criteria |
| `references/quality-rubrics.md` | Phase 4 (self-scoring) | 4/6/8/10 criteria per dimension with remediation |
| `references/instruction-design.md` | Phase 3 (generating project-instruction.md) | 6 design principles + populated example |
| `references/self-learning-protocol.md` | Phase 4 (brain-log) + UPDATE path | Build-log, pattern capture, correction cascade |
| `references/mena-context.md` | Phase 3 (generating mena-context.md) | Trust mechanics, Arabic rules, payment methods |
| `references/conflict-resolution.md` | Phase 1 (when multiple inputs) | Rules for contradictory data between inputs |
| `references/examples/salesmfast-signal-engine/` | Phase 3 (all file generation) | Complete populated example brain for reference |

---

## PROJECT TYPE EXTENSION DETAILS

### tech → tech-spec.md
- Tech stack (frontend, backend, database, hosting, APIs)
- Architecture pattern (monolith, microservices, serverless)
- Build phases with milestones
- Integration dependencies
- Data model summary
- Security requirements

### distribution → distribution-spec.md
- Marketplace mechanics (matching algorithm, trust system)
- Dual-ICP: seller profile + buyer profile (icp.md holds PRIMARY side)
- Commission/revenue structure
- Onboarding flows for both sides
- Platform APIs and integrations
- Network effect strategy (chicken-and-egg solution)

### training-recorded, training-cohort → curriculum.md
- Module/step structure with durations
- Learning outcomes per module
- Exercises and assignments
- Assessment criteria
- Prerequisite knowledge
- Tools required

### community → community-design.md
- Membership tiers and pricing
- Engagement mechanics (rituals, cadence, events)
- Governance model
- Content rhythm
- Activation metrics (what makes a member "active")
- Churn prevention mechanics

### gtm-consulting, gtm-agency → engagement-model.md
- Scope of work
- Deliverables with timeline
- Team structure (who does what)
- Success metrics and KPIs
- Reporting cadence
- Escalation protocol
- Handoff/completion criteria
