---
name: 1-eo-brain-ingestion
description: "EO Brain Ingestion Engine v4 — reads 5 scorecard files from 0-Scorecards/, runs quality gates, coaching loops, gap-fill questions, and produces the complete business brain: 6 About-Me files, 10+ Project brain files, profile-settings.md, cowork-instructions.md, and project-instruction.md. All copy-paste ready. Zero student editing. Triggers on: 'build my brain', 'brain ingestion', 'ingest scorecards', 'process my scorecards', 'create brain files', 'phase 1', 'step 1'."
version: "4.0"
---

# 1-eo-brain-ingestion: Build Your AI Brain

**Version:** 4.0 (V2 plugin, revised directory structure)
**Phase:** 1 (Business Brain)
**Purpose:** Transform scorecard outputs into a complete business brain. The student does ZERO editing. This skill reads, extracts, asks targeted questions, and produces every file ready for deployment.

---

## WHAT THIS SKILL PRODUCES

One run, complete brain:

| Output | Location | What Student Does With It |
|--------|----------|--------------------------|
| 6 About-Me files | `1-ProjectBrain/About-Me/` | Deep founder context. Any skill can reference these. |
| 10+ Project brain files | `1-ProjectBrain/Project/` | Business context. Every downstream skill reads these. |
| Profile Settings | `1-ProjectBrain/profile-settings.md` | Copy to: Claude.ai > Settings > Profile > Preferences |
| Cowork Instructions | `1-ProjectBrain/cowork-instructions.md` | Copy to: Cowork workspace .claude/CLAUDE.md |
| Project Instructions | `1-ProjectBrain/project-instruction.md` | Used automatically by this project folder |

---

## INPUT REQUIREMENTS

### Required: 5 Scorecard Files

Located in `EO-Brain/0-Scorecards/`. File patterns:

| Scorecard | Pattern | What It Provides |
|-----------|---------|-----------------|
| SC1: Project Definition | `SC1-*` or `*Project-Definition*` | Niche, positioning, brand voice, founder story, MENA context |
| SC2: ICP Clarity | `SC2-*` or `*ICP-Clarity*` | Customer persona, pains, dream outcome, buyer journey, access channels |
| SC3: Market Attractiveness | `SC3-*` or `*Market-Attractiveness*` | Market size, competition, monetization, growth signals |
| SC4: Strategy Selector | `SC4-*` or `*Strategy-Selector*` | Founder archetype, strategy path, 90-day roadmap |
| SC5: GTM Fitness | `SC5-*` or `*GTM-Fitness*` | 13 GTM motions ranked with tier assignments |

### Required: Language Preference

Read `EO-Brain/_language-pref.md`. All output files generated in the student's chosen language. If missing, ask and create before proceeding.

### Optional: Existing Input Files

If student has prior context files (marked with `-i` suffix), treat as ADDITIONAL input. Always produce fresh outputs from the framework. Input files enrich, never replace.

---

## QUALITY GATES

### Score Thresholds

| Score | Action | Message |
|-------|--------|---------|
| >= 85 | PASS | "Strong. Proceeding to extraction." |
| 70-84 | COACH | Ask 1-3 targeted questions per weak dimension. Max 2 rounds. |
| < 70 | STOP | "This scorecard has significant gaps. I recommend re-running it. Here's the specific issue: [dimension]. Takes 15 minutes." Offer bypass option. |

### Gate Check Display

```
QUALITY GATES
=============
SC1: Project Definition    [XX]/100  [PASS/COACH/STOP]
SC2: ICP Clarity           [XX]/100  [PASS/COACH/STOP]
SC3: Market Attractiveness [XX]/100  [PASS/COACH/STOP]
SC4: Strategy Selector     [XX]/100  [PASS/COACH/STOP]
SC5: GTM Fitness           [XX]/100  [PASS/COACH/STOP]

Status: [ALL PASS / X NEED COACHING / X NEED RE-RUN]
```

### Coaching Rules

- Max 3 questions per scorecard needing coaching
- Max 2 rounds per dimension
- Questions are sharp and specific: "Your niche scored X. The gap: [specific issue]. Who are the 100 people who would pay $50/month within 90 days? Name the role, company size, geography."
- After coaching, answer REPLACES the weak section in extraction

---

## EXECUTION FLOW

### Phase 1: Discovery (2 min)

Read `_language-pref.md`. Greet in the student's language:

EN: "I'm going to build your complete AI brain from your scorecard results. This produces everything you need: your AI identity card, your operating manual, your project setup, your founder story files, and starter task recipes. All copy-paste ready. Let me find your scorecard files."

AR: "بأبني لك دماغ الذكاء الاصطناعي الكامل من نتائج بطاقات التقييم. هذا ينتج كل شي تحتاجه: بطاقة هويتك الذكية، دليل التشغيل، إعدادات المشروع، ملفات قصتك كمؤسس، ووصفات المهام الجاهزة. كل شي جاهز للنسخ واللصق. خلني ألقى ملفات بطاقات التقييم."

Locate all 5 files in `EO-Brain/0-Scorecards/`. Confirm with student.

### Phase 2: Quality Gates (1 min)

Run gate checks. Display score table. Route to coaching if needed.

### Phase 3: Coaching (0-10 min, only if needed)

For any scorecard scoring 70-84, ask targeted questions. Integrate answers into extraction.

### Phase 4: Extraction (automated)

Parse all 5 scorecard files using the Data Extraction Map (below). Flag any empty fields.

### Phase 5: Gap-Fill Questions (5-8 min)

Two rounds of 4 questions. Present each round as a single block. Wait for all answers before proceeding.

**Round 1: Voice, Thesis, Constraints, Modes**

Q1 — THESIS: "What is the one belief about your market that most people get wrong? The contrarian take that drives everything you build."
→ Feeds: profile-settings.md CORE THESIS

Q2 — VOICE: "When you write content, which 3 words describe your tone? Share an example of your best writing if you have one."
→ Feeds: profile-settings.md COMMUNICATION, About-Me/my-operating-style.md

Q3 — CONSTRAINTS: "What words or phrases make you cringe when AI writes them? What formatting rules matter in EVERY response?"
→ Feeds: profile-settings.md HARD CONSTRAINTS

Q4 — MODES: "When working with AI, what triggers you wanting pushback/challenge vs. pure execution? What do you say when you want each mode?"
→ Feeds: profile-settings.md OPERATING MODES

**Round 2: Business Lines, Tools, Deliverables, Patterns**

Q5 — COMPETITORS: "Your scorecards mention these competitors: [list from SC3]. Any MENA-specific ones to add? Top 2 competitors' biggest weakness?"
→ Feeds: Project/competitor-analysis.md

Q6 — BUSINESS LINES: "Do you run other products or business lines beyond [venture name]? List with one-line descriptions."
→ Feeds: cowork-instructions.md IDENTITY, About-Me/my-vision.md

Q7 — TOOLS: "What tools do you use? List by category: CRM, email, LinkedIn, automation, AI, design, project management."
→ Feeds: cowork-instructions.md TOOL STACK

Q8 — WORK PATTERNS: "What deliverables do you produce most? (proposals, campaigns, scripts, landing pages, etc.) Any file naming conventions?"
→ Feeds: cowork-instructions.md OUTPUT STANDARDS + FILE NAMING

### Phase 6: Generation (automated)

Create all output directories if missing, then generate files in this order:

1. **10+ Project brain files** in `1-ProjectBrain/Project/`
2. **6 About-Me files** in `1-ProjectBrain/About-Me/`
3. **profile-settings.md** in `1-ProjectBrain/` (Layer 1: 7-section, <300 words)
4. **cowork-instructions.md** in `1-ProjectBrain/` (Layer 2: 12-section, 2000-3000 words)
5. **project-instruction.md** in `1-ProjectBrain/` (Layer 3: 100-250 lines)
6. **INDEX.md** in `1-ProjectBrain/` (navigation map)

### Phase 7: Self-Score (automated)

Score output across 10 dimensions (see Self-Score Protocol). If below 8.5/10, iterate automatically before delivering.

### Phase 8: Delivery

Present all files with delivery summary:

EN:
```
YOUR AI BRAIN IS READY
======================

AI IDENTITY CARD:        1-ProjectBrain/profile-settings.md
  → Copy contents to: Claude.ai > Settings > Profile > Preferences

OPERATING MANUAL:        1-ProjectBrain/cowork-instructions.md
  → Copy contents to: Your Cowork workspace .claude/CLAUDE.md

PROJECT INSTRUCTIONS:    1-ProjectBrain/project-instruction.md
  → Already in place. Used automatically by Claude in this project.

FOUNDER STORY:           1-ProjectBrain/About-Me/ (6 files)
  → Already in place. Any skill can reference these.

BUSINESS CONTEXT:        1-ProjectBrain/Project/ (10+ files)
  → Already in place. Every downstream skill reads these.

Total: [XX] files generated. Quality score: [X.X]/10.

"Claude is as smart as the context you give it. Brain in, magic out."
```

AR:
```
دماغك الذكي جاهز
=================

بطاقة هويتك الذكية:     1-ProjectBrain/profile-settings.md
  → انسخ المحتوى إلى: Claude.ai > الإعدادات > الملف الشخصي > التفضيلات

دليل التشغيل:           1-ProjectBrain/cowork-instructions.md
  → انسخ المحتوى إلى: مساحة العمل .claude/CLAUDE.md

تعليمات المشروع:        1-ProjectBrain/project-instruction.md
  → جاهزة. Claude يستخدمها تلقائياً في هذا المشروع.

قصة المؤسس:             1-ProjectBrain/About-Me/ (6 ملفات)
  → جاهزة. أي مهارة تقدر ترجع لها.

سياق المشروع:           1-ProjectBrain/Project/ (10+ ملفات)
  → جاهزة. كل المهارات القادمة تقرأ هذي الملفات.

المجموع: [XX] ملف. درجة الجودة: [X.X]/10.

"Claude ذكي بقد ما تعطيه سياق. دماغ داخل، سحر خارج."
```

---

## DATA EXTRACTION MAP

### From SC1 (Project Definition)

| Extract | Target File(s) |
|---------|----------------|
| Founder name, background, notable companies | Project/founderprofile.md, profile-settings.md |
| Niche (3 levels: market > segment > micro) | Project/niche.md |
| Problem statement + evidence | Project/companyprofile.md, Project/positioning.md |
| Solution description + MVP scope | Project/companyprofile.md |
| Positioning statement | Project/positioning.md |
| Brand personality, tone, words to use/avoid | Project/brandvoice.md |
| Founder story + archetype | Project/founderprofile.md |
| MENA cultural dynamics, launch geography | Project/niche.md, project-instruction.md |

### From SC2 (ICP Clarity)

| Extract | Target File(s) |
|---------|----------------|
| Customer persona (name, role, demographics) | Project/icp.md |
| Top pains with urgency ranking | Project/icp.md, project-instruction.md |
| Dream outcome | Project/icp.md, Project/positioning.md |
| Buyer journey stages | Project/icp.md |
| Access channels (where they hang out) | Project/icp.md, Project/gtm.md |

### From SC3 (Market Attractiveness)

| Extract | Target File(s) |
|---------|----------------|
| Pain reality + evidence | Project/market-analysis.md |
| Purchasing power | Project/market-analysis.md |
| Market sizing (TAM/SAM/SOM) | Project/market-analysis.md |
| Growth signals | Project/market-analysis.md |
| Competitive landscape | Project/competitor-analysis.md |

### From SC4 (Strategy Selector)

| Extract | Target File(s) |
|---------|----------------|
| Founder archetype | Project/founderprofile.md, profile-settings.md (modes) |
| Strategy path (Replicate, AI-Native, etc.) | Project/strategy.md |
| 90-day roadmap | Project/strategy.md, About-Me/my-goals.md |
| Risk profile | Project/founderprofile.md |

### From SC5 (GTM Fitness)

| Extract | Target File(s) |
|---------|----------------|
| 13 GTM motions ranked with scores | Project/gtm.md |
| Tier assignments (PRIMARY/SECONDARY/CONDITIONAL/SKIP) | Project/gtm.md |
| Top 5 motion details | Project/gtm.md, project-instruction.md |
| Budget + tech stack preferences | About-Me/my-resources.md |
| Launch commitment level | About-Me/my-goals.md |

---

## LAYER 1: PROFILE SETTINGS SPECIFICATION

**File:** `1-ProjectBrain/profile-settings.md`
**Target:** Under 300 words. Plain text, no markdown headers (Settings doesn't render markdown).
**Framework:** See `references/profile-settings-framework.md`

### 7 Sections

1. **IDENTITY** — Name, role, company, location, timezone, credibility proof
2. **CORE THESIS** — The contrarian belief (from Gap-Fill Q1 + positioning)
3. **OPERATING MODES** — 2 modes mapped from SC4 archetype (see archetype table)
4. **HARD CONSTRAINTS** — 5-8 absolute rules (from Gap-Fill Q3 + brandvoice)
5. **LANGUAGE RULES** — Language switching rules (from _language-pref.md + brandvoice)
6. **RESPONSE FORMAT** — Output style preferences
7. **QUALITY GATE** — Standard: "Score deliverables before presenting. Show the score."

### Archetype-to-Mode Mapping

| SC4 Archetype | Mode 1 (default) | Mode 2 (triggered) |
|---------------|-------------------|---------------------|
| The Closer | "Ruthless Mentor" — challenge assumptions, pressure-test revenue | "Super Coworker" — execute like senior hire, flag risks inside execution |
| The Builder | "Technical Advisor" — challenge architecture, push for simplicity | "Build Partner" — build fast, ship early, iterate from data |
| The Networker | "Strategic Advisor" — challenge positioning, push for specificity | "Growth Partner" — sequence introductions, build social proof |
| The Operator | "Systems Thinker" — challenge efficiency, push for automation | "Execution Engine" — optimize workflows, measure everything |
| The Reluctant Hero | "Ruthless Mentor" — challenge assumptions, leverage domain authority | "Super Coworker" — execute fast, domain expertise as guide |

---

## LAYER 2: COWORK INSTRUCTIONS SPECIFICATION

**File:** `1-ProjectBrain/cowork-instructions.md`
**Target:** 2000-3000 words. Markdown format.
**Framework:** See `references/cowork-instructions-framework.md`

### 12 Sections

1. **IDENTITY** — Founder + company + business lines (expanded from Profile)
2. **CORE THESIS** — Operational implications of the thesis
3. **PROJECT ROUTING** — If multiple business lines, routing logic. Skip if single venture.
4. **CLIENT TIERS** — If multiple audiences, tier definitions. Skip if single ICP.
5. **FOLDER STRUCTURE** — EO-Brain workspace map
6. **TOOL STACK** — All tools by category (from Gap-Fill Q7), mapped to MCP triggers
7. **PLUGIN STACK** — Placeholder: "Add your installed plugins here"
8. **QUALITY GATE** — Standard scoring protocol
9. **OUTPUT STANDARDS** — Deliverable types + tone + format rules (from Gap-Fill Q8)
10. **BEHAVIOR RULES** — Derived from archetype + brandvoice
11. **SELF-LEARNING** — Standard skill creation trigger + naming convention
12. **FILE NAMING** — Patterns derived from venture name + deliverable types

### Key Rules

- FOUNDER-scoped, not project-scoped. Works across all projects.
- No duplication with Profile Settings. Cowork EXPANDS, never repeats.
- Tool stack maps tools to MCP trigger phrases where applicable.

---

## LAYER 3: PROJECT INSTRUCTIONS SPECIFICATION

**File:** `1-ProjectBrain/project-instruction.md`
**Target:** 100-250 lines. Markdown format.

### 14 Sections

1. What This Project Is — from companyprofile.md
2. Who We Serve — from icp.md (persona, top 3 pains)
3. Positioning — from positioning.md (full statement + wedge)
4. GTM Priority — from gtm.md (top 3 motions with scores)
5. Strategy Path — from strategy.md (path + 90-day roadmap)
6. MENA Rules — from niche.md + SC1 cultural context
7. Tech Stack — placeholder, expanded by 4-eo-tech-architect
8. Project Structure — EO-Brain workspace map
9. Key Context Files — pointers to Project/ directory
10. Build Instructions — standard EO 6-phase sequence
11. Design System — from brandvoice.md + defaults
12. Quality Gates — standard EO gates
13. Current Status — "Brain files generated. Ready for GTM assets."
14. Voice for UI Copy — from brandvoice.md filtered for UI text

---

## LAYER 4: ABOUT-ME FILES

**Directory:** `1-ProjectBrain/About-Me/`
**Files:** 6 markdown files. See `references/founder-about-me/` for templates.

| File | Content Source | Purpose |
|------|--------------|---------|
| my-background.md | founderprofile.md + SC1 Section A | Deep founder history for authority content |
| my-vision.md | companyprofile.md + Gap-Fill Q6 + positioning.md | Where the founder is headed |
| my-market.md | niche.md + market-analysis.md + SC3 market sizing | Market understanding |
| my-goals.md | strategy.md (90-day roadmap) + gtm.md (launch commitment) | Concrete goals and timelines |
| my-operating-style.md | SC4 archetype + Gap-Fill Q2/Q4 + brandvoice.md | How the founder thinks and works |
| my-resources.md | Gap-Fill Q7 (tools) + SC5 Q5-Q6 (budget, stack) | Available resources and constraints |

### About-Me File Template

```markdown
# [File Title]

## Summary
[2-3 sentence overview in student's language]

## Details
[Structured content extracted from sources.
Use the student's own words from scorecard answers wherever possible.
No fabrication. Every statement traces to a source.]

## Key Takeaways for AI Tools
[3-5 points that any AI tool should know from this file.
These are the "if you read nothing else, read this" points.]
```

---

## SELF-SCORE PROTOCOL

After generating all files, score across 10 dimensions:

| # | Dimension | Check | Scoring |
|---|-----------|-------|---------|
| 1 | Extraction accuracy | Every field traces to a scorecard answer or gap-fill | 10=all traceable, 8=1-2 inferred, <6=fabricated |
| 2 | Completeness | All files generated, no empty sections | 10=all complete, 8=1-2 thin, <6=missing files |
| 3 | Profile quality | 7 sections, under 300 words, plain text | 10=framework followed, 8=minor gaps |
| 4 | Cowork quality | 12 sections, 2000-3000 words, no Profile duplication | 10=framework followed, 8=some overlap |
| 5 | Layer separation | No content duplicated across layers 1-3 | 10=zero duplication, 8=minor |
| 6 | Thesis capture | Specific + contrarian + evidence-backed | 10=specific, 8=generic |
| 7 | Archetype alignment | Modes match SC4 archetype | 10=aligned, 8=mostly |
| 8 | MENA context | Regional specifics in all relevant files | 10=thorough, 8=thin |
| 9 | Language consistency | All output matches _language-pref.md | 10=consistent, 8=mixed |
| 10 | Copy-paste ready | Student can deploy every file without editing | 10=paste-ready, 8=needs minor edits |

**Threshold:** 8.5/10 overall. Below 8.5 → iterate automatically before delivery.

---

## ERROR HANDLING

| Error | Response |
|-------|----------|
| Missing scorecard | "I can't find [name] in 0-Scorecards/. Have you completed it? Run /eo-score to create it." |
| Score < 70 | "Your [scorecard] scored [X]. That's below the minimum for clean extraction. Re-run it: takes 15 minutes. Or I proceed with gaps flagged." |
| Student skips gap-fill | "I'll work with what I have. Some sections will be thinner. You can always re-run this later with more detail." |
| _language-pref.md missing | Ask language preference. Create file. Then proceed. |
| Self-score below 8.5 | "My output scored [X]/10. Improving [weak dimensions] before delivering to you." (iterate automatically) |
| 1-ProjectBrain/ directory missing | Create it and all subdirectories before writing files. |

---

## CROSS-SKILL DEPENDENCIES

### What This Skill Reads

| Source | File(s) |
|--------|---------|
| 0-Scorecards/ | SC1-SC5 + founder brief |
| EO-Brain/ root | _language-pref.md |

### What Downstream Skills Read From This Skill's Output

| Consumer | Files They Read |
|----------|----------------|
| 1-eo-template-factory | Project/gtm.md, Project/icp.md, Project/positioning.md, Project/brandvoice.md |
| 2-eo-gtm-asset-factory | All 10+ Project/ files + profile-settings.md for brand context |
| 3-eo-skill-extractor | Project/ files for business context |
| 4-eo-tech-architect | All Project/ files for architecture decisions |
| 4-eo-code-handover | Everything in 1-ProjectBrain/ |

### Progressive Enhancement

- **4-eo-tech-architect** expands Tech Stack section in project-instruction.md
- **No downstream skill modifies** profile-settings.md or cowork-instructions.md (founder-scoped, student edits only)

---

*EO MicroSaaS OS v2 — 1-eo-brain-ingestion v4.0 — Phase 1 Foundation*
