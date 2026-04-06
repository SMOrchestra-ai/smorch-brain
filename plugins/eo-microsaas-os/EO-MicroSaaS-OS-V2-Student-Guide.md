# EO MicroSaaS OS V2 — Student Guide

**Your complete guide to going from idea to working product using AI.**

---

## What Is This?

The EO MicroSaaS OS is a Cowork plugin that walks you through 6 phases of building a MicroSaaS product. It's your AI co-pilot: it reads your scorecards, builds your business brain, creates your sales toolkit, teaches you to build custom AI skills, designs your architecture, and packages everything for Claude Code to build your app.

You don't need to be technical. The plugin handles the complexity. You make the business decisions.

---

## Prerequisites (Before You Install)

### 1. Claude Pro or Team subscription
You need access to **Cowork mode** in the Claude desktop app. This plugin runs inside Cowork.

### 2. Complete Your 5 Scorecards
These are mandatory. The entire system reads from them. Without scorecards, there's nothing to process.

| # | Scorecard | What It Validates | Time |
|---|-----------|-------------------|------|
| SC1 | Project Definition | Your niche, problem, solution, positioning | ~20 min |
| SC2 | ICP Clarity | Who your customer is, their pains, dream outcome | ~15 min |
| SC3 | Market Attractiveness | Market size, competition, monetization | ~15 min |
| SC4 | Strategy Selector | Your founder archetype, strategy path | ~15 min |
| SC5 | GTM Fitness | Which of 13 go-to-market motions fit you best | ~20 min |

**How to run them:** Use the `eo-scoring-suite` plugin. Run `/eo-score` and follow the prompts. Each scorecard takes 15-20 minutes. You'll get scores out of 100.

**Minimum scores recommended:** 70+ on each. Below 70, the system will coach you to improve before proceeding. You can bypass, but the output quality drops.

### 3. Save Your Scorecard Files
After running each scorecard, save the output as a markdown file. Name them:
- `SC1-Project-Definition-[your-project]-[date].md`
- `SC2-ICP-Clarity-[your-project]-[date].md`
- `SC3-Market-Attractiveness-[your-project]-[date].md`
- `SC4-Strategy-Selector-[your-project]-[date].md`
- `SC5-GTM-Fitness-[your-project]-[date].md`

Place them in a folder called `EO-Brain/0-Scorecards/` in the folder you'll select for Cowork.

### 4. Set Up Your Workspace (Starter Kit)
You'll receive a **EO-Brain-Starter-Kit.zip** file. This contains the full folder structure with all 22 GTM templates pre-loaded.

**Setup:**
1. Create a folder on your computer for your project (e.g., `~/Documents/MyMicroSaaS/`)
2. Unzip `EO-Brain-Starter-Kit.zip` into that folder
3. You should now have `~/Documents/MyMicroSaaS/EO-Brain/` with all phase folders and templates inside
4. Put your 5 scorecard files into `EO-Brain/0-Scorecards/`

**Do NOT manually create the folder structure.** The starter kit has everything set up correctly, including 22 GTM templates the plugin needs in Phase 2. If you create folders manually, you'll be missing templates.

---

## Installing the Plugin

1. Open the Claude desktop app
2. Install the **eo-scoring-suite** plugin first (for running scorecards)
3. Install the **eo-microsaas-os** plugin (the main OS): Go to **Settings > Plugins > Install from file** and select `eo-microsaas-os.plugin`
4. The plugin registers 7 skills and 3 commands

---

## The 6 Phases (Your Journey)

### Phase 0: Scorecards (you do this BEFORE the plugin)
Run 5 scorecards. Save them. This is your input.

**Time:** ~90 minutes total
**Output:** 5 scorecard files in `EO-Brain/0-Scorecards/`

---

### Phase 1: Business Brain
**Command:** `/eo-start` (first time) or `/eo-guide` (returning)
**Skill:** `1-eo-brain-ingestion`

What happens: The AI reads all 5 scorecards, asks you a few gap-fill questions (max 4 per round, max 2 rounds), and generates your complete business brain.

**What you get:**
- 6 About-Me files (your background, vision, market, goals, operating style, resources)
- 10+ Project brain files (niche, positioning, ICP, brand voice, strategy, GTM rankings, competitors, market analysis, founder profile, company profile)
- Profile Settings (copy-paste into Claude Settings > Profile)
- Cowork Instructions (copy-paste into your project's .claude/CLAUDE.md)
- Project Instructions (auto-referenced by this project folder)

**Time:** ~30 minutes (mostly automated, you answer a few questions)

**Then:** Run `1-eo-template-factory` to generate task recipe templates matched to your GTM motion.

---

### Phase 2: Sales Toolkit + 30-Day Battle Plan
**Skill:** `2-eo-gtm-asset-factory`

What happens: The AI reads your brain files + 22 pre-built templates, fills them with YOUR content, and generates ready-to-use sales materials.

**What you get:**
- **5 outreach messages** (warm WhatsApp, cold WhatsApp, warm LinkedIn, cold LinkedIn, advisory close script)
- **1 landing page** (HTML, responsive, branded)
- **1 one-pager** (PDF, single page company overview)
- **1 pitch deck** (PPTX, 7-10 slides, branded)
- **1 GTM playbook** (DOCX, 30-day execution plan for your top motion)

**Time:** ~20 minutes (automated generation + your review)

**Important:** The plugin will show you your GTM motion rankings and ask you to pick one for the 30-day playbook. Choose your highest-scoring PRIMARY motion.

---

### Phase 3: Build Your Super AI Team
**Skill:** `3-eo-skill-extractor`

What happens: The AI teaches you how to create custom Cowork skills for YOUR tools and workflows. This is not auto-generation; it's guided creation so you understand what you're building.

**What you learn:**
- Tool Discovery (what tools you have, what they can do)
- Operation Mapping (which workflows are worth automating)
- SKILL.md Construction (building the actual skill file)
- Testing (making sure it works before you deploy)

**What you get:** 1-3 custom skills saved in `EO-Brain/3-Newskills/`

**Time:** ~45 minutes per skill

**GTM-informed suggestions:** The plugin reads your chosen GTM motion and suggests which skills to build first. For example, if you chose "Signal Sniper" (cold outbound), it might suggest: Lead Enricher, Email Personalizer, Signal Scorer.

---

### Phase 4: Architecture + Code Handover
**Skills:** `4-eo-tech-architect` then `4-eo-code-handover`

**Part A: Tech Architect**
What happens: The AI reads your entire business brain + GTM assets, asks 5-8 questions about your tech preferences, team, budget, and generates a complete architecture.

What you get:
- **tech-stack-decision.md** — What to build with and why (MENA-optimized: Tap/HyperPay for payments, WhatsApp for messaging, RTL for Arabic)
- **brd.md** — Business Requirements Document with user stories + acceptance criteria (this is what Claude Code builds from)
- **db-architecture.md** — Database schema and relationships
- **mcp-integration-plan.md** — How your AI tools connect

**Part B: Code Handover**
What happens: The AI scans everything from Phases 0-4 and packages it into two files that Claude Code needs.

What you get:
- **INDEX.md** — Complete manifest of every file, what it does, where Claude Code should use it
- **README.md** — Setup instructions + a bootstrap prompt you paste into Claude Code on day 1

**Time:** ~30 minutes for both

---

### Phase 5: Build (in Claude Code, not Cowork)
After the handover, you switch from Cowork to **Claude Code** (the CLI tool or IDE integration). You paste the bootstrap prompt from README.md, and Claude Code starts building your MVP with full context from everything you've done.

This phase is outside the plugin. The plugin's job ends at Phase 4.

---

## Quick Reference: Commands

| Command | When to Use | What It Does |
|---------|-------------|--------------|
| `/eo-start` | First time ever | Sets language, creates workspace, checks scorecards, begins Phase 1 |
| `/eo-guide` | Every return visit | Scans where you are, recommends next step |
| `/eo-status` | Quick check | Shows phase completion dashboard: file counts, scores, next action |

---

## Quick Reference: Skills

| Skill | Phase | Trigger Phrases |
|-------|-------|-----------------|
| 0-eo-guide | 0 | "guide me", "what's next", "where am I" |
| 1-eo-brain-ingestion | 1 | "build my brain", "process scorecards", "phase 1" |
| 1-eo-template-factory | 1 | "create task recipes", "build templates" |
| 2-eo-gtm-asset-factory | 2 | "build my sales toolkit", "generate assets", "phase 2" |
| 3-eo-skill-extractor | 3 | "build my AI team", "create a skill", "phase 3" |
| 4-eo-tech-architect | 4 | "design my blueprint", "tech stack", "create BRD" |
| 4-eo-code-handover | 4 | "prepare handover", "ready to code", "switch to Claude Code" |

---

## Language

On your first run, the plugin asks: Arabic or English?

- **Arabic** = Gulf Arabic (conversational, not formal MSA). English tech terms mixed in naturally (e.g., "الـ landing page جاهزة").
- **English** = Direct English with MENA context.
- File names and directory structure are always in English regardless of your choice.
- You can change this anytime by editing `EO-Brain/_language-pref.md`.

---

## What If I Skip a Phase?

The plugin never blocks you. If you try to jump ahead, it will:

1. **Acknowledge** — "I get it. Context-setting feels slow."
2. **Explain the ROI** — "30 minutes here saves you 3 days of fixing later."
3. **Give you options** — Proceed anyway (with warnings), go back and complete, or do a quick partial version.

You're always in control. The plugin recommends, never forces.

---

## Scoring

Every skill scores its output across 10 dimensions (7 universal + 3 skill-specific). Threshold is 8.5/10 average. If below, the skill identifies the 2 weakest dimensions and offers to fix them.

Quality gates at each phase transition:
- **>= 85/100:** PASS. Proceed.
- **70-84/100:** COACH. Targeted questions to strengthen weak areas.
- **< 70/100:** STOP. Recommends re-running the scorecard. 15 minutes. You can bypass.

---

## Workspace Structure (What Your Folder Looks Like After All Phases)

```
EO-Brain/
├── _language-pref.md          ← Your language choice
├── 0-Scorecards/              ← Your 5 scorecard files (you created these)
├── 1-ProjectBrain/
│   ├── About-Me/              ← 6 founder context files
│   ├── Project/               ← 10+ business brain files
│   ├── templates/             ← Task recipe templates
│   ├── profile-settings.md    ← Copy to Claude Settings
│   ├── cowork-instructions.md ← Copy to .claude/CLAUDE.md
│   └── project-instruction.md ← Auto-referenced
├── 2-GTM/
│   ├── Templates/             ← 22 source templates (pre-loaded)
│   └── output/
│       ├── preGTM/            ← Your 8 sales toolkit files
│       └── GTM/               ← Your 30-day playbook
├── 3-Newskills/
│   ├── Dev/                   ← Technical skills you build
│   ├── GTM/                   ← Sales/marketing skills
│   └── Ops/                   ← Operations skills
├── 4-Architecture/
│   ├── tech-stack-decision.md
│   ├── brd.md
│   ├── db-architecture.md
│   └── mcp-integration-plan.md
└── 5-CodeHandover/
    ├── INDEX.md               ← File manifest for Claude Code
    └── README.md              ← Bootstrap prompt for Claude Code
```

---

## Tips

1. **Do the scorecards seriously.** Garbage in, garbage out. The better your scorecard answers, the better every downstream output.
2. **Start with `/eo-start`.** It scaffolds everything correctly.
3. **Don't skip Phase 1.** The business brain is the foundation for everything. 30 minutes of context = days of saved revision.
4. **Pick ONE GTM motion for Phase 2.** Don't try to do all 13. Your highest-scoring PRIMARY motion is the right choice.
5. **Phase 3 is optional but powerful.** Each skill you create saves you hours of repetitive work.
6. **Copy your Profile Settings.** After Phase 1, copy `profile-settings.md` content into Claude Settings > Profile. This makes EVERY Claude conversation smarter about your business.
7. **The bootstrap prompt is gold.** When you paste it into Claude Code, your developer AI knows everything about your business, customer, stack, and plan. One prompt, full context.

---

---

## What You Receive (Deliverables Checklist)

| File | What It Is | Required? |
|------|-----------|-----------|
| `eo-microsaas-os.plugin` | The main OS plugin. Install in Cowork. | Yes |
| `EO-Brain-Starter-Kit.zip` | Pre-built workspace with 22 GTM templates. Unzip to your project folder. | Yes |
| `EO-MicroSaaS-OS-V2-Student-Guide.md` | This guide. | Recommended |
| `eo-scoring-suite` plugin | For running your 5 scorecards. Installed separately. | Yes (Phase 0) |

---

*EO MicroSaaS OS V2 — Built by SMOrchestra.ai*
*Plugin version: 2.0.0*
