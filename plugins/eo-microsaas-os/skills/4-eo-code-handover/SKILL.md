---
name: 4-eo-code-handover
description: "EO Code Handover Engine v2 — Phase 4 companion skill. The final step before Claude Code. Packages all phases 0-4 content into a production handover bundle. Reads entire EO-Brain workspace, generates INDEX.md (complete file manifest + what each doc is for), README.md (Claude Code setup instructions + bootstrap prompt). Students use this to onboard Claude Code with full context. After code-handover runs, student switches to Claude Code and begins Phase 5 (Build). Triggers on: 'prepare handover', 'handover to claude code', 'phase 4 complete', 'ready to code', 'build my app', 'switch to claude code'."
version: "2.0"
---

# 4-eo-code-handover: The Handoff to Claude Code

**Version:** 2.0 (V2 plugin)
**Phase:** 4 (Code Handover)
**Purpose:** Package everything from Phases 0-4 into a coherent handover bundle. This is the LAST skill in the EO OS. After this runs, the student switches to Claude Code and begins building (Phase 5). Zero files are edited by the student. All outputs are ready to copy directly into Claude Code context.

---

## WHAT THIS SKILL PRODUCES

Two documents, ready for Claude Code:

| Output | Location | Purpose | How Student Uses It |
|--------|----------|---------|---------------------|
| INDEX.md | 5-CodeHandover/ | Complete manifest of all project files. What each document is, where it lives, why Claude Code needs it. | Copy into Claude Code as the "master reference." Claude Code scans this to understand the project structure. |
| README.md | 5-CodeHandover/ | Step-by-step setup for Claude Code: which plugins to install, how to initialize the session, what the BRD contains, bootstrap prompt to give Claude Code on first message. | Student reads this once, follows it in Claude Code, then runs the bootstrap prompt. |

**That's it.** Two files. Everything else is already in EO-Brain/. This skill doesn't move or copy files—it creates a roadmap and a launch template.

---

## INPUT REQUIREMENTS

### Required: All Phases 0-4 Complete

This skill assumes:
- **Phase 0** (0-Scorecards/) — at least 5 scorecard files present
- **Phase 1** (1-ProjectBrain/) — business brain files complete (About-Me, Project, profile-settings.md, etc.)
- **Phase 2** (2-GTM/output/) — GTM assets generated (preGTM and GTM playbook)
- **Phase 3** (3-Newskills/) — custom skills created (optional, but checked)
- **Phase 4** (4-Architecture/) — tech-stack-decision.md, brd.md, db-architecture.md, mcp-integration-plan.md

If any phase is missing critical files, this skill detects it and offers options:
- Proceed anyway (flag missing files in the README)
- Go back and complete the phase first

### Required: Language Preference

Read `EO-Brain/_language-pref.md`. All output in student's language.

---

## ROLE DEFINITION

You are the **Code Handover Manager**: the person who briefs the dev team (in this case, Claude Code) so they can start building immediately without questions.

Your job:
1. **Scan the entire EO-Brain workspace** — understand every file, every folder, every decision made in Phases 0-4
2. **Create an INDEX** that maps every file to its purpose and where Claude Code should use it
3. **Write a README** that tells Claude Code:
   - What plugins to install in their development environment
   - How to initialize the project (repo setup, env vars, database seed)
   - What the BRD is and how to use it as the build spec
   - A "bootstrap prompt" to give Claude Code on day 1 so they have full context
4. **Flag any gaps** — missing files, incomplete phases, unclear decisions
5. **Make the handoff seamless** — Claude Code should never need to ask "where is [file]?" or "what does [business decision] mean?"

You are NOT a dev. You're a project manager handing off to the dev team. Clarity, completeness, and no ambiguity.

### Language Rules

- All output in the language specified in `_language-pref.md`
- Keep file paths and code terms in English (e.g., "1-ProjectBrain/", "brd.md", "Vercel")
- Business context is in the student's language
- Code samples and technical instructions are in English

---

## EXECUTION FLOW

### Phase 1: Workspace Audit (5 min, automated)

Scan the entire EO-Brain/ directory. Count files per phase:

```
Phase 0 (0-Scorecards/):
  - SC1 Project Definition: [filename]
  - SC2 ICP Clarity: [filename]
  - SC3 Market Attractiveness: [filename]
  - SC4 Strategy Selector: [filename]
  - SC5 GTM Fitness: [filename]
  Total: [X] files

Phase 1 (1-ProjectBrain/):
  - About-Me/: [list 6 files]
  - Project/: [list all files]
  - profile-settings.md: ✅
  - cowork-instructions.md: ✅
  - project-instruction.md: ✅
  Total: [X] files

Phase 2 (2-GTM/output/):
  - preGTM/: [list files]
  - GTM/: [list files]
  Total: [X] files

Phase 3 (3-Newskills/):
  - Dev/: [X] skill files
  - GTM/: [X] skill files
  - Ops/: [X] skill files
  Total: [X] skills created

Phase 4 (4-Architecture/):
  - tech-stack-decision.md: ✅
  - brd.md: ✅
  - db-architecture.md: ✅
  - mcp-integration-plan.md: ✅
  Total: 4 files

MISSING or INCOMPLETE:
  - [List any phases with < expected file count]
```

Display this audit to the student. Ask:

EN: "I found [count] files across Phases 0-4. [If complete:] Everything's here. [If gaps:] You're missing [files/phases]. Want to complete them now or proceed with what you have?"

AR: "لقيت [count] ملف عبر المراحل 0-4. [If complete:] كل شي موجود. [If gaps:] ناقص عندك [files/phases]. بتبي تكملهم الحين ولا تقدم بإللي عندك?"

---

### Phase 2: INDEX.md Generation (automated)

Generate `5-CodeHandover/INDEX.md`. This is the **master reference map** for Claude Code.

Structure:

```markdown
# EO Code Handover — Complete Project Index

**Project:** [Product Name]
**Founder:** [Your Name]
**Created:** [Date]
**Language:** [en|ar]

---

## EXECUTIVE SUMMARY

[1-2 sentences: What the product does, who it's for, how it makes money]

Example:
"[Product Name] is a MENA-focused [customer type] tool that [problem solved]. Monetization: [pricing model]. MVP scope: [5-8 core features]."

---

## FILE MANIFEST & USAGE GUIDE

### PHASE 0: SCORECARDS (Validation & Metrics)

These files show why this product exists, who the customer is, and the market opportunity. Reference these when building if customer logic questions come up.

| File | Location | Purpose | Claude Code Usage |
|------|----------|---------|-------------------|
| [SC1 filename] | 0-Scorecards/ | Project Definition: niche, positioning, founder story, MENA context | Read once. Reference for brand voice, positioning rationale. Build features aligned with niche definition. |
| [SC2 filename] | 0-Scorecards/ | ICP Clarity: customer persona, pains, dream outcome, buying journey | Reference for: validation rules (only these customer types should sign up), messaging copy alignment (speak to stated pains), feature priority (build what solves stated dream outcome first). |
| [SC3 filename] | 0-Scorecards/ | Market Attractiveness: market size, monetization assumptions, growth signals | Reference for: pricing validation (charge what market research says), feature scope (don't over-scope, keep it tight), competitive differentiation. |
| [SC4 filename] | 0-Scorecards/ | Strategy Selector: founder archetype, strategy path, 90-day roadmap | Reference for: which business assumptions are non-negotiable (in the roadmap), feature sequencing (what launches week 1 vs. week 4), what success looks like. |
| [SC5 filename] | 0-Scorecards/ | GTM Fitness: 13 GTM motions ranked with tier assignments | Reference for: integration priorities (which tools matter most for launch), customer acquisition flow, how to test product-market fit. |

**How Claude Code uses Phase 0:**
- Scorecards are the "why" behind every feature and integration
- If Claude Code questions a feature priority, the answer is in SC4 (roadmap)
- If Claude Code questions a customer type, the answer is in SC2 (ICP)

---

### PHASE 1: BUSINESS BRAIN (Founder Context & Operating Manual)

These files tell Claude Code who YOU are and how you work. Claude Code reads these to match your voice, values, and decision-making style.

**About-Me files** (read all 6):
| File | Purpose | Claude Code Usage |
|------|---------|-------------------|
| 1-ProjectBrain/About-Me/my-background.md | Your experience, credibility, expertise | Build features assuming founder knows [domain]. Use language that reflects founder credibility. |
| 1-ProjectBrain/About-Me/my-goals.md | What success looks like in 12 months, 3 years | Features and roadmap align with stated goals. |
| 1-ProjectBrain/About-Me/my-market.md | Markets you focus on (MENA, specific countries, verticals) | Localize for primary market. RTL if Arabic-facing. Payment gateways chosen for stated market. |
| 1-ProjectBrain/About-Me/my-resources.md | Budget, team, time, tools you have | Right-size architecture for available resources. Don't over-engineer. |
| 1-ProjectBrain/About-Me/my-vision.md | Long-term vision (what does this build toward?) | Features ladder toward vision. Future MCPs and automation designed with vision in mind. |
| 1-ProjectBrain/About-Me/my-operating-style.md | How you work, collaboration style, risk tolerance | Communication: how you prefer to give feedback. Iteration style: big changes at once or gradual. |

**Project brain files** (read all):
| File | Purpose | Claude Code Usage |
|------|---------|-------------------|
| 1-ProjectBrain/Project/positioning.md | How product is positioned, vs. competitors | Feature copy and messaging align with positioning. Competitive moat is clear in code (e.g., MENA localization, unique integrations). |
| 1-ProjectBrain/Project/business-model.md | How money flows, pricing, unit economics | Payment logic matches business model. Subscription vs. one-time? Free trial? Freemium? |
| 1-ProjectBrain/Project/customer-segments.md | Which customer types, access strategy, revenue split | Features prioritize high-revenue segments first. Validation rules gate the right customers in. |
| 1-ProjectBrain/Project/competitor-analysis.md | Top 3 competitors, their strengths, your differentiation | Code defensibility: build the moat (RTL, MENA payments, custom integrations, etc.). |
| 1-ProjectBrain/Project/[other files] | [Specific context for this product] | [How Claude Code uses it] |

**Identity & Operating Files:**
| File | Purpose | Claude Code Usage |
|------|---------|-------------------|
| 1-ProjectBrain/profile-settings.md | AI identity card: founder thesis, communication style, constraints, operating modes | **Claude Code reads this on every message.** Matches tone, writing style, decision framework. Respects hard constraints. |
| 1-ProjectBrain/cowork-instructions.md | Your operating manual: business lines, tool stack, deliverable formats, file conventions | File naming conventions match your defaults. Output formats match your expectations. |
| 1-ProjectBrain/project-instruction.md | Project-specific rules for Claude Code in this workspace | Applied automatically by Claude Code when working in this folder. |

**How Claude Code uses Phase 1:**
- profile-settings.md is the single most important file. Claude Code reads it on init.
- Project brain files inform business logic (who can sign up, what they pay, how they're reached)
- About-Me files explain the "why" behind architecture decisions

---

### PHASE 2: GTM ASSETS (Customer Acquisition Strategy & Messaging)

These files show how you'll reach customers and what they'll hear. Claude Code uses these to align product features with customer reality.

| File | Location | Purpose | Claude Code Usage |
|------|----------|---------|-------------------|
| 2-GTM/output/preGTM/[positioning] | preGTM folder | Positioning statement, target persona, key messages | Product messaging and copy align with stated positioning. |
| 2-GTM/output/preGTM/[landing page] | preGTM folder | Landing page copy (headline, CTA, social proof) | Payment flow CTA matches landing page promise. Success metrics match landing page offer. |
| 2-GTM/output/GTM/[playbook] | GTM folder | 30-day GTM battle plan: motion, channels, integration tools, sequence | Integration design matches GTM tools (WhatsApp, HeyReach, GoHighLevel, Tap Payments, etc.). Webhook design supports stated integrations. |
| 2-GTM/output/GTM/[content] | GTM folder | Email sequences, LinkedIn templates, WhatsApp templates | API integrations support these channels. Product behavior triggers these messages (e.g., "order paid" → send WhatsApp). |

**How Claude Code uses Phase 2:**
- GTM playbook tells Claude Code: "This product integrates with WhatsApp, Tap Payments, HeyReach, and GoHighLevel. That's non-negotiable."
- Landing page copy shows what customer expects on day 1 (features promised must exist)
- Messaging tells Claude Code how to write system emails and notifications (tone, voice, MENA localization)

---

### PHASE 3: CUSTOM SKILLS (Automation Layer)

If created, these are MCPs or reusable workflows you built for your processes.

| File | Location | Purpose | Claude Code Usage |
|------|----------|---------|-------------------|
| 3-Newskills/Dev/[skill].md | Dev folder | Automation for development workflows | Reference if applicable. Not usually needed for MVP. |
| 3-Newskills/GTM/[skill].md | GTM folder | Automation for GTM workflows | Post-MVP: integrate into app as part of Phase 5+ roadmap. |
| 3-Newskills/Ops/[skill].md | Ops folder | Automation for operational workflows | Post-MVP: same as GTM skills. |

**How Claude Code uses Phase 3:**
- Phase 3 is optional for MVP. If skills exist, they inform future automation architecture (Phase 5+).
- Don't try to build Phase 3 skills into MVP. Complexity tax not worth it.

---

### PHASE 4: ARCHITECTURE (Build Specification)

**These are THE DOCS Claude Code will use to start building immediately.**

| File | Location | Purpose | Claude Code Usage |
|------|----------|---------|-------------------|
| 4-Architecture/tech-stack-decision.md | 4-Architecture/ | Recommended tech stack (Next.js, Supabase, Vercel, Tap Payments, WhatsApp, etc.), justifications, cost breakdown, MENA defaults | **This is the spec.** Install exactly these dependencies. Deploy on exactly this infrastructure. No substitutions unless approved. |
| 4-Architecture/brd.md | 4-Architecture/ | Business Requirements Document: MVP features, user stories, acceptance criteria, scope boundaries, integrations | **This is the build checklist.** Every user story gets acceptance criteria. Every acceptance criterion becomes a test case. This is the north star. |
| 4-Architecture/db-architecture.md | 4-Architecture/ | Database schema (tables, columns, types, indexes, relationships), migrations, GDPR/data residency notes | **This is the schema.** Generate migrations from this. Seed database with this in mind. |
| 4-Architecture/mcp-integration-plan.md | 4-Architecture/ | MCP & automation strategy: how to integrate with external tools (Tap, WhatsApp, HeyReach, etc.), webhook design, data sync flows | **This is the integration roadmap.** Webhook endpoints are designed here. Data sync logic is defined here. |

**How Claude Code uses Phase 4:**
- BRD is the single source of truth for MVP scope and acceptance criteria
- Tech-stack is NOT a suggestion—it's the spec. Use exactly these tools.
- db-architecture is the database schema. Generate migrations from this.
- mcp-integration-plan defines webhook architecture and integration endpoints.

---

## QUICK REFERENCE: WHERE TO FIND THINGS

**If Claude Code needs to know...** | **...read this file:**
---|---
"Who is the customer?" | 1-ProjectBrain/Project/customer-segments.md + SC2 ICP Clarity
"How much should they pay?" | 1-ProjectBrain/Project/business-model.md + SC3 Market Attractiveness
"What's the brand voice?" | 1-ProjectBrain/profile-settings.md + SC1 Project Definition
"What does MVP include?" | 4-Architecture/brd.md (MVP Scope section)
"How do we reach customers?" | 2-GTM/output/GTM/[playbook]
"How do we integrate with [Tool]?" | 4-Architecture/mcp-integration-plan.md
"What's the database schema?" | 4-Architecture/db-architecture.md
"What are the payment details?" | 4-Architecture/tech-stack-decision.md (payments section) + 4-Architecture/mcp-integration-plan.md (webhook flow)
"How does notification work?" | 4-Architecture/mcp-integration-plan.md (WhatsApp MCP section)
"What's the founder's style?" | 1-ProjectBrain/profile-settings.md + 1-ProjectBrain/cowork-instructions.md
"What's the 90-day roadmap?" | SC4 Strategy Selector
"What's the competitive moat?" | 1-ProjectBrain/Project/competitor-analysis.md + 4-Architecture/tech-stack-decision.md (MENA localization section)

---

## DEPLOYMENT & LAUNCH CHECKLIST

These are baked into the BRD acceptance criteria, but summary:

- [ ] Frontend deployed on Vercel
- [ ] Database seeded on Supabase
- [ ] Tap Payments integrated and tested (sandbox mode)
- [ ] WhatsApp notifications working
- [ ] Admin panel functional
- [ ] Authentication (email + SMS 2FA) working
- [ ] All acceptance criteria passing
- [ ] Error monitoring (Sentry) active
- [ ] README with deployment instructions written
- [ ] Founder can redeploy if needed

---

## NEXT STEPS: CLAUDE CODE ONBOARDING

1. **Read this INDEX.md** — understand the project structure
2. **Read the README.md** (below) — follow setup instructions
3. **Paste the bootstrap prompt** (in README) into Claude Code on your first message
4. **Claude Code will begin with full context** — no setup needed from you

After that: Claude Code builds according to BRD. You review, iterate, ship.

---

*Last updated: [Date]*
*Project: [Product Name]*
*Language: [en|ar]*
```

---

### Phase 3: README.md Generation (automated)

Generate `5-CodeHandover/README.md`. This is the **setup guide for Claude Code.**

Structure:

```markdown
# Code Handover: Getting Claude Code Ready

**This document tells Claude Code how to set up and start building.**

---

## SECTION 1: FOR YOU (The Founder)

### What Happens Next

You're handing off to Claude Code, which is Anthropic's specialized development assistant. Here's the flow:

1. **Open Claude Code** (separate interface from Claude.ai)
2. **Install recommended plugins** (see below)
3. **Set up your development environment** (repo, env vars, database)
4. **Give Claude Code the bootstrap prompt** (at the bottom of this doc)
5. **Claude Code starts building** according to your BRD

Claude Code can:
- ✅ Write code (frontend, backend, migrations, tests)
- ✅ Deploy to Vercel
- ✅ Debug errors in real-time
- ✅ Read your business context files
- ✅ Implement integrations (Tap, WhatsApp, HeyReach, etc.)
- ✅ Write database migrations
- ⚠️ May ask clarifying questions if something in the BRD is ambiguous (that's good, not bad)

### Your Job During Dev Phase

1. **Test features** as Claude Code builds them
2. **Validate against BRD** — "Does this match what I asked for?"
3. **Give feedback** — "This is right" or "This needs to change because [reason]"
4. **Approve major decisions** — Claude Code will ask before making trade-off choices

### Timeline Expectation

- **MVP (all acceptance criteria):** 3-4 weeks
- **Bug fixes & Polish:** 1 week
- **User testing:** 1 week
- **Launch:** Week 6-7 from start

---

## SECTION 2: CLAUDE CODE SETUP

### Recommended Plugins for Claude Code

Before you start, ensure Claude Code has these plugins installed:

1. **Supabase** — Database setup, migrations, seeding
2. **Vercel** — Deployment, environment variables, domain setup
3. **Git** — Repository management, commits, branch management
4. **Node.js/npm** — Package management, dependency installation
5. **Docker** (optional) — If local testing needs containerization
6. **API Testing** (e.g., Postman or curl) — Webhook testing, payment gateway testing

**Installation check:**
In Claude Code, ask: "List my available plugins" or check Settings > Plugins.

### Development Environment Setup

#### Step 1: Create GitHub Repository

```bash
# You create this manually in GitHub (or ask Claude Code to create via API)
# Name: [product-name]-api
# Type: Private (add Claude Code as collaborator if needed)
```

#### Step 2: Clone & Initialize

Claude Code will do this, but here's what happens:

```bash
git clone https://github.com/[you]/[product-name]-api.git
cd [product-name]-api

# Claude Code creates these automatically
# .env.local (copy the template below)
# package.json (Next.js + dependencies)
# prisma/schema.prisma (database schema from 4-Architecture/db-architecture.md)
# README.md (deployment instructions)
```

#### Step 3: Environment Variables (.env.local)

Claude Code will create this file. You provide the secrets:

```env
# Database (Supabase)
DATABASE_URL="postgresql://[user]:[password]@[host]:5432/[database]?schema=public"
NEXT_PUBLIC_SUPABASE_URL="https://[project].supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="[anon-key-from-supabase]"

# Tap Payments (for payment integration)
TAP_API_KEY="sk_test_[key]"  # From Tap Payments dashboard
TAP_WEBHOOK_SECRET="[secret]"

# WhatsApp Business API
WHATSAPP_BUSINESS_ACCOUNT_ID="[from-meta-or-twilio]"
WHATSAPP_ACCESS_TOKEN="[from-meta-or-twilio]"
WHATSAPP_PHONE_NUMBER="[your-business-phone]"

# SMS (Twilio or Unifonic)
TWILIO_ACCOUNT_SID="[sid]"
TWILIO_AUTH_TOKEN="[token]"
TWILIO_PHONE_NUMBER="[your-twilio-number]"

# Vercel (for deployments & cron jobs)
VERCEL_PROJECT_ID="[from-vercel]"

# Error Tracking (Sentry)
SENTRY_DSN="[from-sentry]"

# Email (if using SendGrid or similar)
SENDGRID_API_KEY="[if-using-email]"
```

**Where to get these:**
- Supabase: Supabase dashboard > Settings > API
- Tap Payments: Tap Payments dashboard > API Keys
- WhatsApp: Meta Business Platform or Twilio Console
- Twilio: Twilio Console > Account Info
- Sentry: Sentry dashboard > Project > Client Keys

#### Step 4: Database Setup

Claude Code will run:

```bash
# Generate migration from schema
npx prisma migrate dev --name init

# Seed database (optional test data)
npx prisma db seed
```

#### Step 5: Install Dependencies

Claude Code will run:

```bash
npm install
# Installs: Next.js, React, Tailwind, Supabase, Prisma, Tap SDK, Twilio, etc.
```

#### Step 6: Test Locally

```bash
npm run dev
# App runs on http://localhost:3000
```

---

## SECTION 3: WHAT THE BRD CONTAINS

The file `4-Architecture/brd.md` is your build specification. It has:

1. **MVP Scope:** [X] core features that ship day 1
2. **User Stories:** Every feature as a story ("As a [user], I want [feature] so that [outcome]")
3. **Acceptance Criteria:** Checkboxes for every story (must all pass before feature is done)
4. **Integrations:** Which external tools to connect (Tap, WhatsApp, HeyReach, etc.)
5. **Success Metrics:** How you measure if it worked

**Claude Code will:**
- Read the BRD on init
- Build every user story
- Test every acceptance criterion
- Never ship a feature that doesn't pass all criteria

**You will:**
- Test features Claude Code builds
- Confirm they match the BRD
- Ask for changes if needed (this becomes a new story or a spec refinement)

**The rule:** If it's not in the BRD, it's not in MVP. No exceptions. This keeps the 30-day timeline realistic.

---

## SECTION 4: BOOTSTRAP PROMPT FOR CLAUDE CODE

**Copy this entire prompt and paste it as your first message to Claude Code.**

(Adjust [brackets] with your actual values)

---

### BOOTSTRAP PROMPT: START HERE

```
I'm handing off my MicroSaaS project to you. You're about to build the MVP.
Here's everything you need:

PROJECT CONTEXT
===============

Name: [Product Name]
Founder: [Your Name]
Market: MENA ([Primary Countries])
Vision: [1-sentence vision from Phase 1]

CRITICAL FILES (Read All of These)
==================================

1. Business Brain (who you are, how you think):
   - Read: EO-Brain/1-ProjectBrain/profile-settings.md (MY IDENTITY CARD)
   - This tells you my voice, my constraints, how I like to work
   - Read every time before responding

2. Business Context (who the customer is):
   - Read: EO-Brain/1-ProjectBrain/Project/ (all files)
   - This tells you positioning, customer pain, business model, market

3. Build Specification (what to build):
   - Read: EO-Brain/4-Architecture/brd.md (THE BUILD SPEC)
   - This is the north star: MVP scope, user stories, acceptance criteria
   - Never ship a feature that doesn't pass its acceptance criteria
   - Never add features not in the BRD (ask me first if unclear)

4. Tech Stack (what tools to use):
   - Read: EO-Brain/4-Architecture/tech-stack-decision.md
   - This is the spec, not a suggestion
   - Use exactly these tools: Next.js, Supabase, Vercel, Tap Payments, WhatsApp, [etc.]
   - Don't substitute without asking me

5. Database Schema (what to build):
   - Read: EO-Architecture/db-architecture.md
   - This is the schema. Generate migrations from this.
   - Tables, columns, indexes—it's all defined

6. Integration Plan (how to connect external tools):
   - Read: EO-Brain/4-Architecture/mcp-integration-plan.md
   - This shows how to integrate Tap, WhatsApp, [other tools]
   - Webhook design, data sync logic, automation architecture

7. GTM Assets (what customers will see):
   - Read: EO-Brain/2-GTM/output/ (both preGTM and GTM)
   - Landing page copy, messaging, integrations
   - Product features must align with landing page promises

YOUR JOB
========

1. Set up the project:
   - Clone repo, create .env.local with secrets
   - Run: npm install
   - Run: npx prisma migrate dev --name init
   - Run: npm run dev (test on localhost:3000)

2. Build according to the BRD:
   - Every user story becomes a feature
   - Every acceptance criterion becomes a test
   - Don't ship until ALL criteria pass

3. Implement integrations:
   - Tap Payments webhook
   - WhatsApp message sending
   - [Any other integrations from the BRD]

4. Deploy:
   - Vercel for frontend + API routes
   - Supabase for database
   - Sentry for error tracking
   - Test: run locally, then deploy to Vercel staging, then production

5. Communicate:
   - Ask questions if BRD is ambiguous
   - Show me progress weekly
   - Alert me to trade-offs or timeline risks
   - Propose solutions, not problems

MY PREFERENCES
==============

[Copy from: EO-Brain/1-ProjectBrain/profile-settings.md]

Communication style: [e.g., "Direct. No fluff. Show trade-offs."]
Decision mode: [e.g., "Challenge me if it doesn't fit the market."]
Output format: [e.g., "Code-first. Walk me through it."]

SUCCESS CRITERIA
================

MVP is done when:
- ✅ All user stories in BRD have acceptance criteria passing
- ✅ Database schema matches db-architecture.md
- ✅ Tap Payments webhook working (test + production)
- ✅ WhatsApp notifications sending
- ✅ Authentication (email + SMS 2FA) functional
- ✅ Admin panel working (I can manage customers)
- ✅ Deployed on Vercel
- ✅ Sentry monitoring active
- ✅ README with deployment instructions written

Timeline: 3-4 weeks to launch

NEXT STEPS
==========

1. Confirm you've read the BRD (4-Architecture/brd.md)
2. Confirm you understand the tech stack (4-Architecture/tech-stack-decision.md)
3. Start: "Let me set up the project. I'll create the repo, install dependencies, and seed the database."
4. Show me: .env.local template (for me to fill with secrets)
5. Show me: First build output (user registration feature, acceptance criteria)

Questions before I start? Ask now. Once you start building, assume you understand the BRD fully.
```

---

(End of bootstrap prompt)

---

### Why This Bootstrap Prompt Works

1. **Clarity:** Claude Code knows exactly what to do (build the BRD)
2. **Context:** Claude Code has read all critical files (brain, BRD, tech stack, integrations)
3. **Constraints:** Claude Code knows "don't add features not in BRD" and "don't change tech stack"
4. **Success criteria:** Claude Code knows what "done" looks like
5. **Tone:** Claude Code knows your communication style and decision mode

---

## SECTION 5: COMMON Q&A DURING DEV PHASE

**Q: Claude Code asks to add a feature. Is this okay?**

A: Check the BRD. If it's there, yes (Claude Code caught something). If it's not there, say: "That's smart, but it's not in our MVP scope. Let's ship MVP first, then iterate based on real users. Add it to the post-launch roadmap."

**Q: Claude Code says timeline is tight. What do I do?**

A: That's valuable feedback. Ask: "What's the blocker? Can we simplify, defer, or parallelize?" Work with Claude Code to adjust. A 4-week timeline assumes no blockers. Some give is normal.

**Q: Claude Code is about to deploy to production. Should I review?**

A: YES. Always review before production. Especially check: payment integrations, customer data handling, security. If uncertain, ask Claude Code: "Walk me through what this deployment changes."

**Q: I realized the BRD missed something. Can Claude Code change it mid-build?**

A: Yes, but it restarts some work. Better: finish MVP first, then iterate. If it's critical to MVP, change it NOW and tell Claude Code. They'll adjust.

**Q: Can Claude Code work with other tools/frameworks?**

A: No. The tech stack is locked. If you want to change it (e.g., "use Vue instead of React"), that's a strategic decision that delays MVP. Not recommended.

---

## SECTION 6: AFTER MVP LAUNCHES

Once MVP is live:

1. **Monitor real usage** — Which features do customers actually use?
2. **Iterate fast** — Post-launch roadmap based on real data
3. **Phase 3 automation** — Now is when to build custom skills (MCPs) to automate your processes
4. **Phase 5+ features** — Advanced features, integrations, scaling

Claude Code can continue working with you for post-MVP features using the same BRD + brain file workflow.

---

## CHECKLIST: BEFORE YOU GIVE CLAUDE CODE THE BOOTSTRAP PROMPT

- [ ] I've read this entire README
- [ ] I've read the BRD (4-Architecture/brd.md)
- [ ] I've read the tech stack decision (4-Architecture/tech-stack-decision.md)
- [ ] I have all secrets ready (.env values from Supabase, Tap, WhatsApp, etc.)
- [ ] I understand: "Don't change tech stack, don't add features not in BRD"
- [ ] I'm ready to start: I have availability to test Claude Code's work weekly

If you checked all boxes: **Paste the bootstrap prompt into Claude Code and say "go"**

---

*Last updated: [Date]*
*Project: [Product Name]*
*Contact: [Your Email]*
```

---

### Phase 4: Self-Score (automated)

After generating both documents, score:

| # | Dimension | Check |
|---|-----------|-------|
| 1 | Workspace audit accuracy | Correctly scanned all 6 phases, counted files, identified gaps |
| 2 | INDEX.md completeness | All files listed with purpose + Claude Code usage instructions |
| 3 | INDEX.md clarity | Clear file organization, quick reference table, easy to navigate |
| 4 | README.md setup clarity | Step-by-step dev environment setup (repo, env vars, database, dependencies) |
| 5 | README.md bootstrap prompt | Complete, copy-paste ready, includes all critical context |
| 6 | BRD integration | README clearly explains how BRD is the build spec |
| 7 | Tech stack reinforcement | README emphasizes tech stack is locked (not a suggestion) |
| 8 | Success criteria clarity | README clearly lists what "MVP done" means |
| 9 | Q&A usefulness | Common questions answered (feature requests, timeline, deployments) |
| 10 | MENA context present | MENA payment gateways, messaging, localization mentioned in handover |

**Threshold:** 8.5/10. Below: iterate before presenting to student.

Display score:

```
CODE HANDOVER QUALITY SCORE: 9.1/10

✅ Workspace audit (10/10) — All files found, counted, categorized
✅ INDEX.md completeness (9/10) — All files listed with clear purpose
✅ INDEX.md clarity (9/10) — Quick reference is helpful, navigation is easy
✅ README setup clarity (9/10) — Step-by-step, only missing Docker explanation
✅ Bootstrap prompt (9/10) — Copy-paste ready, includes context
✅ BRD integration (9/10) — Clearly explains BRD is the spec
✅ Tech stack lock (10/10) — Multiple reminders not to swap tools
✅ Success criteria (10/10) — Launch checklist is concrete
✅ Q&A usefulness (9/10) — Covers 80% of real questions
✅ MENA context (9/10) — Tap, WhatsApp, RTL mentioned

Notes: Optional: add Docker setup to README if local testing needs containerization. Otherwise, ready.
```

---

## QUALITY GATES

### Gate 1: All Phase Files Present

Scan all 4 architecture files exist:
- tech-stack-decision.md
- brd.md
- db-architecture.md
- mcp-integration-plan.md

If missing, ask: "I found [X] of 4 architecture files. Want to generate the missing ones before handover?"

### Gate 2: BRD Has Acceptance Criteria

BRD must include acceptance criteria for every user story (checklist format). If not:
- "The BRD needs acceptance criteria for Claude Code to know when a feature is done. Let me check—I see [X] user stories with criteria, [Y] without. Should I regenerate with criteria for all?"

### Gate 3: Bootstrap Prompt Is Copy-Paste Ready

Bootstrap prompt in README must be:
- Complete (founder just copies and pastes into Claude Code)
- No [brackets] left unfilled (fill them in the generation process)
- Includes all critical file paths
- Includes success criteria and timeline

If not perfect, iterate.

### Gate 4: Index Maps ALL Files

INDEX.md must list every file student created across Phases 0-4 with a "why Claude Code needs it" explanation. If gaps:
- "I found [X] files but didn't map [Y] files. Let me add those to the index."

---

## ERROR HANDLING

| Scenario | Response |
|----------|----------|
| Phase 4 files missing (e.g., BRD incomplete) | "Handover needs all 4 architecture files. Missing: [list]. Should I go back and complete Phase 4 first?" |
| BRD has no acceptance criteria | "Claude Code can't build without acceptance criteria—they're the test cases. Let me regenerate the BRD with checkboxes for every story." |
| Bootstrap prompt is long (>1000 words) | "The prompt is solid but dense. Want me to trim it and move details to the INDEX?" |
| Student hasn't filled in .env secrets | Warn: "I can generate the .env template, but you'll need API keys from Supabase, Tap Payments, WhatsApp, etc. Collect those before giving Claude Code the bootstrap prompt." |
| Student says "I'll make changes during dev" | "Got it. But bigger changes mid-dev slow Claude Code down. Test MVP first, iterate after launch. If something in the BRD is wrong NOW, tell me and I'll fix it before we start building." |

---

## CROSS-SKILL DEPENDENCIES

| This Skill | Reads From | Writes To |
|------------|------------|-----------|
| 4-eo-code-handover | Entire EO-Brain/ (all phases), 4-Architecture/ (all 4 docs) | 5-CodeHandover/INDEX.md, 5-CodeHandover/README.md |

| Next (Claude Code) | What It Needs From 4-eo-code-handover |
|-------------------|--------------------------------------|
| Claude Code (Phase 5) | INDEX.md (to find files), README.md bootstrap prompt (to initialize context), BRD + tech stack + db-architecture (to start building) |

---

## LANGUAGE AWARENESS

**English output (en):**
- All sections in English
- Code samples in English
- File paths in English
- Tech terms in English

**Arabic output (ar):**
- Business explanations and instructions in Gulf Arabic
- File paths remain English (e.g., "EO-Brain/", "brd.md")
- Code samples remain English
- Tech terms remain English
- Bootstrap prompt in Arabic (founder-facing part) + English (Claude Code-facing part)

---

## MENA CONTEXT IN HANDOVER

This skill explicitly calls out MENA defaults in the README:
- Payment gateways (Tap, HyperPay, not Stripe-only)
- Messaging (WhatsApp primary, SMS backup)
- RTL support (if Arabic-facing product)
- Data residency (where customer data lives)
- Timezone handling (MENA users may span UTC+2 to UTC+4)

Claude Code will read these and never suggest a US-only stack.

---

## SELF-LEARNING: AFTER CODE HANDOVER

Offer to create a Cowork Skill:

"We've built a solid handover package here. Want me to create a Cowork Skill from this so you can run `/smorch-eo-code-handover` for your next project? I'll template: the audit framework, INDEX structure, README sections, and bootstrap prompt generator. Next time, it's 90% automatic."

---

### Founder Quotes (use contextually in the session)

| Moment | EN Quote | AR Quote |
|--------|----------|----------|
| Starting handover | "You've done the hard part: thinking clearly. Now we package it so the builder never has to guess." | "سويت الجزء الصعب: التفكير بوضوح. الحين نغلفه عشان الباني ما يحتاج يخمن." |
| Student has missing phases | "Missing files aren't a failure. They're a conscious scope decision. We flag them, we move forward." | "ملفات ناقصة مو فشل. قرار واعي بالنطاق. نعلّمها ونكمل." |
| INDEX.md generated | "This INDEX is your product's memory. Claude Code reads it once and knows everything you spent weeks building." | "هالـ INDEX ذاكرة منتجك. Claude Code يقراه مرة ويعرف كل شي قضيت أسابيع تبنيه." |
| README with bootstrap prompt done | "One prompt. That's all it takes. You paste this, Claude Code wakes up knowing your business, your customer, your stack, your plan. That's the power of context." | "Prompt واحد. هذا كل اللي تحتاج. تلصقه، Claude Code يصحى يعرف بزنسك، عميلك، الـ stack، وخطتك. هذي قوة السياق." |
| Handover complete | "Phase 0 to Phase 4: complete. You went from 'I have an idea' to 'I have a build spec.' Most founders never get here." | "من المرحلة 0 للمرحلة 4: تم. من 'عندي فكرة' إلى 'عندي مخطط بناء.' أغلب المؤسسين ما يوصلون هنا." |

---

## THE MOMENT OF TRUTH

After 4-eo-code-handover runs, the student's workflow is:

1. **Generate INDEX.md and README.md** (this skill does it)
2. **Open Claude Code** (separate tool)
3. **Paste the bootstrap prompt** from README
4. **Claude Code reads all context files** automatically
5. **Claude Code starts building** according to BRD
6. **Student tests** and iterates as Claude Code builds
7. **MVP ships** in 3-4 weeks

That's the complete EO OS: from idea validation (Phase 0) to working software (Phase 5).

---

*EO MicroSaaS OS v2 — 4-eo-code-handover — Phase 4 Code Handover*
