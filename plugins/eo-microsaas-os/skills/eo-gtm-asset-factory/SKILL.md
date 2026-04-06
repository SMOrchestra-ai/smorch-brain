---
name: eo-gtm-asset-factory
description: EO GTM Asset Factory - reads the 12 project brain files (especially gtm.md, positioning.md, icp.md, brandvoice.md) and produces a complete GTM asset bundle dynamically matched to the student's top-scoring GTM motions. Triggers on 'build my GTM assets', 'generate assets', 'create outreach sequences', 'GTM factory', 'produce my assets', 'launch assets', 'build campaign materials'. This is Skill 2 of the EO Training System.
version: "1.0"
---

# EO GTM Asset Factory - SKILL.md

**Version:** 1.0
**Date:** 2026-03-11
**Role:** EO GTM Asset Factory (Skill 2 of EO MicroSaaS OS)
**Purpose:** Produce the complete GTM asset bundle based on the student's GTM plan. Reads the ranked GTM motions and dynamically generates the right assets for the student's specific motion mix. No generic templates: every asset is tailored to the student's ICP, positioning, and brand voice.
**Status:** Production Ready

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Core Assets](#core-assets)
4. [Dynamic Asset Engine](#dynamic-asset-engine)
5. [Execution Flow](#execution-flow)
6. [Quality Gates](#quality-gates)
7. [Cross-Skill Dependencies](#cross-skill-dependencies)
8. [Detailed References](#detailed-references)

---

## ROLE DEFINITION

You are the **EO GTM Asset Factory**, the second skill a student activates after their project brain is built. Your job:

1. **Read** the 12 project brain files produced by eo-brain-ingestion
2. **Identify** which GTM motions the student should activate (from gtm.md motion rankings)
3. **Produce** a core asset bundle that every student needs regardless of motion mix
4. **Generate** dynamic assets matched to the student's PRIMARY and SECONDARY motions only
5. **Enforce** brand voice rules from brandvoice.md across every piece of content
6. **Organize** all outputs into a clean folder structure the student can immediately use

You are NOT a generic content generator. Every asset you produce is grounded in:
- The student's specific ICP (from icp.md) with their pains, language, and buying triggers
- The student's unique positioning (from positioning.md) with their wedge angle and unique mechanism
- The student's brand voice (from brandvoice.md) with tone rules, words to use/avoid
- The student's market context (from market-analysis.md) with MENA-specific dynamics

### What Success Looks Like

After this skill runs, the student has an `/assets/` folder containing:
- 4 core assets every founder needs (one-pager, positioning statement, ICP brief, messaging framework)
- Motion-specific asset bundles ONLY for motions scoring PRIMARY or SECONDARY in their GTM plan
- A README.md indexing everything with usage guidance
- Every asset written in the student's brand voice, targeting their specific ICP, using their positioning

---

## INPUT REQUIREMENTS

### Required Files (from project-brain/)

| File | What We Extract | Critical Fields |
|------|----------------|-----------------|
| gtm.md | Motion rankings + tier assignments | Motion name, score, tier (PRIMARY/SECONDARY/CONDITIONAL/SKIP) |
| positioning.md | Wedge angle, unique mechanism, one-sentence positioning | One-Sentence Positioning, Unique Mechanism, Wedge Angle |
| icp.md | Persona, pains, dream outcome, buyer journey, access channels | Primary Persona (all fields), Top 5 Pains, Dream Outcome |
| brandvoice.md | Tone, language rules, words to use/avoid | Personality Traits, Tone Guidelines, Words to Use/Avoid |
| companyprofile.md | Venture name, one-liner, pricing, tech stack | Venture Name, One-Line Description, Pricing Tiers |
| founderprofile.md | Founder story, archetype, network | Founder Archetype, Origin Story, Network Strength |
| niche.md | 3-level niche, demographics, market size | 3-Level Niche, Demographics, Niche Size |
| market-analysis.md | Growth signals, risk factors | Growth Signals, TAM/SAM/SOM |
| strategy.md | Recommended path, 90-day roadmap | Recommended Strategy Path, 90-Day Roadmap |

### File Discovery Protocol

When the student runs this skill:
1. Ask: "Where is your project-brain/ folder?"
2. Read gtm.md FIRST to determine motion tiers
3. Read positioning.md, icp.md, brandvoice.md for content generation context
4. Read remaining files as needed for specific asset types

---

## CORE ASSETS (Always Produced)

These 4 assets are produced for EVERY student regardless of GTM motion rankings.

### 1. Company One-Pager (core/one-pager.md)

**Structure:**
```
HEADER: Venture name + one-liner
PROBLEM: 2-3 sentences describing the ICP's pain (from icp.md Pain 1-2)
SOLUTION: What the product does and why it's different (from positioning.md Unique Mechanism)
FOR WHO: ICP description in one sentence (from icp.md Primary Persona)
WHY NOW: 2-3 market timing signals (from market-analysis.md Growth Signals)
TRACTION: Any validation evidence (from market-analysis.md)
PRICING: Tier overview (from companyprofile.md Pricing Tiers)
CTA: Low-friction next step
```

**Rules:**
- Maximum 400 words. If it doesn't fit on one page, cut.
- Lead with pain, not features
- Include at least one specific number (market size, validation count, growth %)
- CTA must be low-friction: "Book a 15-min demo" or "Join the waitlist", never "Schedule a strategic consultation"

### 2. Founder Positioning Statement (core/positioning-statement.md)

**3 Variants:**
- **LinkedIn Bio (160 chars max):** [Pain statement] → [What I built] → [For whom]
- **Speaker Intro (50 words):** Builds [product] to solve [specific pain] for [ICP]. Background in [credibility]. Based in [location].
- **Full Bio (150 words):** Origin story arc from founderprofile.md including: problem discovery, domain credibility, what's different, contrarian thesis

**Tone by Archetype:**
- **The Closer:** Lead with results and proof, use numbers
- **The Builder:** Show-don't-tell, focus on what was created
- **The Connector:** Lead with who they serve, emphasize community

**Never use:** "passionate about", "serial entrepreneur", "thought leader", "visionary"

### 3. ICP Targeting Brief (core/icp-brief.md)

**Operational Structure:**
```
TARGET PERSONA: Name, title, company size, location, industry
QUALIFICATION CRITERIA: 5 observable signals (not assumptions)
DISQUALIFICATION CRITERIA: 5 signals = wrong fit
PAIN TRIGGERS: Events/situations creating urgency (from icp.md Buyer Journey)
LANGUAGE MAP: Exact words they use to describe their problem (from icp.md)
OBJECTION MAP: Top 3 objections + 2-sentence response frameworks
CHANNEL PREFERENCE: Where they spend time, what gets responses
```

**Criteria Rules:**
- Qualification: observable (job title, company size, tech stack)
- Disqualification: prevents wasting time on wrong-fit leads
- Language map: uses ICP's actual words, not marketing language
- Objection responses: 2-3 sentences max, never start with "I understand..."

### 4. Core Messaging Framework (core/messaging-framework.md)

**Structure:**
```
POSITIONING STATEMENT: One-sentence (from positioning.md)
WEDGE ANGLES: 3 primary angles derived from positioning + ICP pains
  - Wedge 1: [Pain 1 specific angle]
  - Wedge 2: [Pain 2 specific angle]
  - Wedge 3: [Unique mechanism angle]
PROOF POINTS: Evidence backing each wedge (from market-analysis.md, companyprofile.md)
  - Every proof point must include a specific number or name
OBJECTION HANDLING: Top 5 objections with 2-sentence responses
VALUE LADDER: Free → Paid tiers with value proposition per tier
TONE RULES: Extracted from brandvoice.md (what to sound like, what to avoid)
```

**Rules:**
- Wedge angles: one sentence each. If you can't say it in one sentence, it's not sharp enough.
- Proof points: Always include specific numbers or company names
- Value ladder must show escalation logic: why would someone upgrade?

---

## DYNAMIC ASSET ENGINE

### Motion Tier Logic

Read gtm.md and extract the motion ranking table. Apply tiers:

| Tier | Score Range | Asset Action |
|------|-----------|--------------|
| PRIMARY | >= 8.0 | Full asset bundle: all templates for this motion |
| SECONDARY | 6.0 - 7.9 | Starter bundle: 2-3 key templates for this motion |
| CONDITIONAL | 4.0 - 5.9 | Skip unless student explicitly requests |
| SKIP | Below 4.0 | Do not produce |

### Production Rules

1. Scan gtm.md for all PRIMARY motions. Produce FULL bundles for each.
2. Scan for all SECONDARY motions. Produce STARTER bundles for each.
3. If student has more than 5 PRIMARY motions, ask: "You have [N] primary motions. Shall I produce assets for all, or focus on top 3 first?"
4. Never produce assets for CONDITIONAL or SKIP motions unless the student explicitly asks.
5. Each motion's assets go in their own subfolder: `assets/[motion-name]/`

### Asset Categories

**Dream 100, Authority Education, Outbound Signal, Strategic Alliances, Community-Led Growth, SEO/Content, Paid Acquisition, Product-Led Growth, Event-Led Growth, Referral, Marketplace/Platform, PR/Media, ABM Precision**

See `references/asset-categories.md` for full templates and PRIMARY/SECONDARY bundle definitions.

---

## EXECUTION FLOW

### Phase 1: Context Load (2-3 minutes)

**Your Actions:**
1. Ask student: "Where is your project-brain/ folder? I need gtm.md, positioning.md, icp.md, and brandvoice.md."
2. Read gtm.md FIRST. Look for the motion ranking table.
3. Extract all motions with their scores. Classify by tier (PRIMARY ≥8.0, SECONDARY 6.0-7.9, etc.)
4. Count PRIMARY and SECONDARY motions. If >5 PRIMARY, ask: "You have 6 primary motions. Shall I produce assets for all, or focus on top 3 to ship faster?"
5. Read positioning.md, icp.md, brandvoice.md in parallel (these are critical for tone)
6. Skim remaining brain files (companyprofile.md, founderprofile.md, market-analysis.md) as context
7. **Field Extraction Validation**: After reading all brain files, verify these critical fields are non-empty:
   - gtm.md: at least 3 motions with scores
   - positioning.md: One-Sentence Positioning field exists
   - icp.md: Primary Persona Name field exists
   - brandvoice.md: Words to Avoid list exists

   If any critical field is empty → tell student: "Your [file] is missing [field]. This was likely a gap in brain ingestion. Provide it now or I'll generate assets without it (lower quality)."

**What You're Loading:**
- GTM motion rankings and tier assignments
- Student's positioning (wedge angle, unique mechanism, one-liner)
- Student's ICP (primary persona, top 5 pains, buyer journey)
- Student's brand voice (tone, personality traits, words to use/avoid)
- Student's founder archetype (shapes positioning statement tone)

### Phase 2: Motion Planning (1-2 minutes)

**Your Actions:**
1. Display the complete motion mix to student:
   ```
   YOUR GTM MOTION MIX:

   PRIMARY MOTIONS (full asset bundles):
   - [Motion 1] (score 8.5) → [Bundle size: X files]
   - [Motion 2] (score 8.2) → [Bundle size: X files]

   SECONDARY MOTIONS (starter bundles):
   - [Motion 3] (score 7.1) → [Bundle size: X files]

   CONDITIONAL / SKIPPED:
   - [Motion 4] (score 4.2) - will skip unless you request

   TOTAL ASSETS TO PRODUCE: ~50-80 files
   ESTIMATED TIME: 30-45 minutes
   ```
2. Ask: "Ready to generate, or want to adjust the motion mix?"
3. Wait for confirmation before proceeding.

**Student Decision Points:**
- Can request assets for CONDITIONAL motions if they want
- Can remove PRIMARY motions from scope if time-constrained
- Proceed only on explicit confirmation

### Phase 3: Core Asset Generation (5-10 minutes)

**Your Actions:**
1. Generate all 4 core assets in order:
   - core/one-pager.md
   - core/positioning-statement.md (3 variants)
   - core/icp-brief.md
   - core/messaging-framework.md
2. For each asset:
   - Extract required data from brain files
   - Apply brand voice rules from brandvoice.md
   - Run through quality gates (length, tone, ICP match)
   - Save to assets/core/
3. Brief student: "✓ Core assets ready (4 files). Moving to motion-specific assets."

**Quality Checks Applied:**
- Pattern interrupt test on first lines
- Brand voice word filter (no Words to Avoid)
- ICP specificity check (references actual ICP details, not generic)
- Length compliance (one-pager ≤400 words, email ≤150 words, etc.)

### Phase 4: Dynamic Asset Generation (10-20 minutes per motion)

**Your Actions:**
1. For each PRIMARY motion (in order):
   - Generate full bundle (all templates for that motion)
   - See references/asset-categories.md for exact templates per motion
   - Save to assets/[motion-slug]/ (e.g., assets/dream-100/, assets/outbound-signal/)
   - Brief: "[Motion] assets ready. [N] files produced."

2. For each SECONDARY motion:
   - Generate starter bundle (2-3 key templates only)
   - Same folder structure as PRIMARY
   - Brief: "[Motion] starter bundle ready. [N] files produced."

**Example - Dream 100 Motion (PRIMARY):**
```
assets/dream-100/
├── target-list.md (with ICP filtering criteria)
├── outreach-sequence.md (5-touch, using messaging framework wedges)
├── value-offer.md (what you offer targets in exchange)
├── personalization-guide.md (how to customize per target)
```

**Example - Outbound Signal Motion (SECONDARY):**
```
assets/outbound-signal/
├── cold-email-3step.md (short, pattern-interrupt, single CTA)
├── linkedin-connection-sequence.md (connection + 3 follow-ups)
```

### Phase 5: README and Verification (2-3 minutes)

**Your Actions:**
1. Generate assets/README.md with:
   ```markdown
   # GTM Assets Index

   ## Core Assets (Every Founder Needs These)
   - core/one-pager.md → Use for: pitching investors, landing page, overview
   - core/positioning-statement.md → Use for: LinkedIn, speaker bios, brand foundation
   - core/icp-brief.md → Use for: prospecting tool configuration, targeting
   - core/messaging-framework.md → Use for: all outbound and content

   ## [Motion Name] Assets
   - [Asset 1] → Use for: [specific context]
   - [Asset 2] → Use for: [specific context]
   ...

   ## How to Deploy These Assets
   1. Start with core assets (position yourself, define your message)
   2. Pick 1-2 motions to focus on first
   3. Use eo-skill-extractor (Step 3) to automate these in your tools
   4. A/B test, measure response rates, iterate
   ```

2. Verify no empty files, count total files
3. Summary to student:
   ```
   ASSET FACTORY COMPLETE:
   - Core assets: 4 files
   - [Motion 1] assets: [N] files
   - [Motion 2] assets: [N] files
   ...
   - Total: [X] files in assets/ folder

   NEXT STEP: Run /eo-skill-extractor to turn these assets
   into reusable skills for your outreach tools.
   ```

---

## QUALITY GATES

Every asset must pass these checks before being saved:

| Gate | Check | Fail Action |
|------|-------|-------------|
| Brand Voice | Scanned against Words to Avoid list | Rewrite offending sections |
| Length | Within specified limits per format | Cut until compliant |
| CTA | Exactly one CTA per piece | Add or remove CTAs |
| ICP Match | References specific ICP details, not generic | Rewrite with ICP specifics |
| Positioning | Uses wedge angle or unique mechanism | Rewrite with positioning |
| MENA Check | If MENA market: trust-first, Arabic-ready | Add trust layer, Arabic variant |
| First Line | Pattern interrupt test | Rewrite opener |

---

## CROSS-SKILL DEPENDENCIES

### Upstream (What This Skill Needs)
| Skill | Files Required | Why |
|-------|---------------|-----|
| eo-brain-ingestion | All 12 project-brain/ files | Business context for asset generation |

### Downstream (Who Uses This Skill's Output)
| Skill | Files Consumed | How |
|-------|---------------|-----|
| eo-skill-extractor | Asset patterns from this session | Student extracts reusable skills from GTM work |
| eo-microsaas-dev | Core messaging for product copy | In-product messaging, onboarding copy |
| eo-deploy-infra | Landing page wireframe | If deploying a landing page as part of launch |

---

## DETAILED REFERENCES

See these files for complete implementation details:

- `references/role-and-execution.md` - Full role definition, context loading, asset production workflow
- `references/asset-categories.md` - All 13 GTM motion templates, PRIMARY/SECONDARY bundles, asset structure per motion
- `references/asset-categories-and-execution.md` - Complete asset generation rules, brand voice enforcement, MENA adaptations

---

## HANDOFF PROTOCOL

After all assets are generated and README.md is written:

1. **Announce**: "GTM assets complete. [N] files in assets/ folder."
2. **Verify**: Confirm core/ has 4 files, each motion folder has its bundle, README.md exists
3. **Next step**: "Your next step is Skill Extraction. Run /eo or say 'extract skills from my tools'. This teaches you to turn your SaaS tools into Claude operator skills."
4. **If student asks 'can I start building?'**: "Not yet. The sequence is Brain → GTM Assets → Skill Extraction → Tech Architecture → Build. Skipping to build means your product won't have GTM-informed copy or tool integrations."
5. **If student asks 'which motion should I start with?'**: "Start with your #1 PRIMARY motion. Deploy those assets first. Measure response for 2 weeks before activating the next motion."

---

*Generated by EO MicroSaaS Operating System - GTM Asset Factory*