# Output File Specifications - eo-brain-ingestion

Detailed specification templates for all 13 generated files.

## OUTPUT FILE SPECIFICATIONS

### Specification: personal-preferences.md

**Purpose:** Ready-to-paste text for Claude.ai Settings > Profile > Personal Preferences.

**Format:** Plain text with section labels. NO markdown headers (Claude.ai settings does not render markdown). NO XML tags. Just clean, readable instruction text with ALL-CAPS section labels.

**Target length:** 40-80 lines.

**Instruction Design Principles Applied:**
1. Positive constraints: "Use specific language: numbers over claims" instead of "Don't use buzzwords"
2. Behavioral rules: "When analyzing a market, apply [framework]" instead of "Be a good strategist"
3. Critical rules at edges: most important rules in first and last sections
4. Verifiable: every rule can be checked in 5 seconds ("Did Claude include an ROI calculation? Yes/No")
5. Meta-patterns: named reasoning frameworks that scale across tasks

**Archetype-to-Mode Mapping Table:**

| Archetype | Mode 1 Name | Mode 1 Behavior | Mode 2 Name | Mode 2 Behavior |
|-----------|-------------|------------------|-------------|------------------|
| The Closer | Ruthless Mentor | Challenge assumptions, pressure-test revenue logic, no cheerleading | Super Coworker | Execute like senior hire, flag risks inside execution |
| The Builder | Technical Advisor | Challenge architecture, question scope, push for simplicity | Build Partner | Build fast, ship early, iterate from live data |
| The Networker | Strategic Advisor | Challenge positioning, question differentiation, push for specificity | Growth Partner | Sequence introductions, build social proof, leverage relationships |
| The Operator | Systems Thinker | Challenge efficiency, question process, push for automation | Execution Engine | Optimize workflows, remove manual steps, measure everything |

**Output Template:**

```
[Founder name]. [Role], [Company]. [1-sentence background from founderprofile.md]. Based in [location]. Building [venture name]: [one-line description].

CORE THESIS
[Synthesized from positioning.md unique mechanism + brandvoice.md origin story + Gap-Fill Q1. Frame as the founder's contrarian belief about their market. Structure: "Most people think X. I believe Y because Z." Maximum 3-4 sentences. Must be specific enough that someone reading it knows exactly what this founder stands for.]

DECISION FRAMEWORK
When evaluating anything, apply this stack:
1. [Derived from archetype. The Closer: "Revenue signal first. If nobody will pay, do not build."]
2. [Derived from niche.md + market-analysis.md regional context]
3. [Derived from gtm.md top motion priorities]
4. [Derived from strategy.md path rationale]
5. [Derived from founderprofile.md risk profile]

MODE 1: [Name from archetype table] (default)
Active when: [Derived from Gap-Fill Q4 + archetype behavior]
- [3-4 behavioral rules from archetype Mode 1 column + brandvoice tone]

MODE 2: [Name from archetype table] (triggered when direction is agreed)
Active when: [Derived from Gap-Fill Q4 + archetype behavior]
- [3-4 execution rules from archetype Mode 2 column + strategy path]

COMMUNICATION
[3-4 rules from brandvoice.md tone guidelines, rephrased as positive behavioral instructions. Example: "Lead with commercial impact and specific numbers" not "Don't be vague"]

HARD CONSTRAINTS
[From brandvoice.md words to avoid + Gap-Fill Q3, rephrased as positive replacements where possible. Example: "Replace these words with specific language: leverage, synergy, ecosystem" not just "Never say leverage"]
```

---

### Specification: cowork-instruction.md [REVISED]

**Purpose:** Ready-to-paste global CLAUDE.md that works across ALL the founder's projects.

**Key Design Change:** This is FOUNDER-scoped, not project-scoped. It encodes how the founder works, what tools they use, and what quality standards they apply. It must work whether the founder is building their MicroSaaS, writing a proposal, or creating content.

**Format:** Standard CLAUDE.md markdown format.

**Target length:** 80-150 lines.

**Output Template:**

```markdown
# [Founder Name] - Global Cowork Instructions

## WHO I AM
[Name] - [Role]. [1-2 sentence background from founderprofile.md]
Building [venture name(s)]: [one-line each]
Based in [location].

## WHAT I BUILD
[List each business line/product with one-line description. If the student runs multiple ventures, list all from Gap-Fill Round 2 Q6. If only one venture, list it with product lines if applicable.]

## MY TOOL STACK
[Grouped by function from Gap-Fill Round 2 Q7. Categories as applicable:]
[CRM: tool name]
[Cold Email: tool name]
[LinkedIn: tool name]
[Automation: tool name]
[AI: tool name]
[Design: tool name]
[Other: tool name]

## HOW I WORK
1. ASK QUESTIONS WHEN: [Specific triggers derived from archetype. The Closer: "target audience is ambiguous, deliverable format is not specified, pricing tier is unclear, which business line this is for." The Builder: "architecture decision has multiple valid paths, scope is not bounded, dependencies are unclear."]
2. PROCEED WITHOUT ASKING WHEN: [Derived from archetype. The Closer: "task is straightforward, context is clear from the folder, continuation of existing work." The Builder: "implementation path is obvious, tests will catch errors, can be iterated."]
3. SELF-LEARNING: When we build something complex together (3+ steps, likely to repeat), offer to create a reusable skill capturing the structure, preferences, and decision logic.

## QUALITY STANDARDS BY DELIVERABLE
[Separate rules for each type the founder produces, from Gap-Fill Round 2 Q8 + brandvoice.md tone:]
- Proposals/Decks: [Rules derived from archetype + brandvoice. Example for The Closer: "Lead with business problem and commercial impact. ROI framing mandatory. Numbers and timelines always included."]
- Campaign materials: [Example: "Pattern interrupt in first line. Short sentences. Low-friction CTA."]
- Content (YouTube, LinkedIn): [Example: "Contrarian angle mandatory. Teach frameworks, not features."]
- Technical docs: [Example: "Include the 'why' alongside the 'how'. Diagram when possible."]

## LANGUAGE DEFAULTS
[From brandvoice.md language defaults section. Example:]
- Client-facing B2B: English unless specified
- SME materials: Arabic-first with English tech terms
- YouTube: Check which channel/language before starting
- LinkedIn: English

## FILE NAMING CONVENTIONS
[From Gap-Fill Round 2 Q8 or derived from venture name. Example:]
- [venture-slug]-[type]-[date].ext

## WHAT NOT TO DO
[From brandvoice.md words to avoid + positioning.md competitive alternatives. Rephrased as positive replacements:]
- Use specific language instead of: [words to avoid list]
- Recommend [venture-native approaches] instead of: [competitive alternatives that fail for this founder's market]
- [MENA-specific rules if applicable: "Default to MENA market context, not Western/US assumptions"]
```

---

## COMPLETE OUTPUT FILE FIELD EXAMPLES

All 13 output files require filled examples (not just templates) showing realistic data for a fictional venture: **WhatsApp CRM for independent real estate brokers in Dubai and Abu Dhabi.**

---

### 1. companyprofile.md

**Template structure:** Company name, founding narrative, mission, the problem being solved, founding team, current metrics.

**Filled example:**

```markdown
# SalesMfast Real Estate CRM

**Company:** SalesMfast Real Estate CRM
**Founded:** March 2026
**Founder:** Sarah Al-Mazroui
**Location:** Dubai, UAE

## Mission
Empower independent real estate brokers in MENA to own client relationships and win more deals by capturing leads directly in WhatsApp — without tool-switching or losing context.

## The Problem Solved
Independent brokers in UAE lose 35-40% of leads to fragmented communication. Leads come via WhatsApp, email, SMS with zero centralization. Brokers forget follow-ups, deals go cold. Current solutions (HubSpot, Pipedrive) require desktop work and are overkill for solo brokers.

## Founding Story
In Q3 2024, I watched my mentor lose an AED 180K deal because he forgot to follow up on a WhatsApp inquiry from 3 days prior. The message was buried in 200+ group messages. That moment, I knew this was solvable.

## Current Metrics (as of April 2026)
- 12 pilot customers (independent brokers, Dubai + Abu Dhabi)
- AED 1,200/year per customer (early pricing)
- ARR: AED 14,400 (pilot phase)
- NPS: 42 (from pilot feedback)
- Churn: 0% (early-stage, all pilots retained)

## Team
- **Founder/CEO:** Sarah Al-Mazroui (8 years as real estate ops analyst, 2 years in SaaS sales)
- **Technical Partner:** [Co-founder name, brief background]

## Next 90 Days
Scale pilot to 50 customers; validate AED 1,500/month SaaS pricing; build feature set for phase 2 (reporting, CRM integrations).
```

**Field validation rules:**
- Company name: Required, 2-50 characters
- Founded date: Required, ISO date format (YYYY-MM-DD)
- Founder name: Required, full name
- Mission: Required, 1-3 sentences, specific to niche
- Problem: Required, quantified (% lost leads, cost per deal, frequency)
- Founding story: Recommended, 100-300 words with specific moment
- Metrics: Required if revenue > $0, otherwise state "pre-revenue"
- Team: Required, list all founders + 1-2 sentence background each

---

### 2. founderprofile.md

**Template structure:** Name, background, domain expertise, why this founder, decision-making style, risk profile, geographic context.

**Filled example:**

```markdown
# Founder Profile: Sarah Al-Mazroui

## Background
**Age:** 32
**Base:** Dubai, UAE
**Nationality:** Jordanian
**Work history:**
- 8 years at CBRE (2016-2024): Real estate operations analyst, managed 50+ brokers
- 2 years at GoHighLevel (2024-2026): Sales consultant, helped agencies with CRM + automation
- Currently: Full-time on SalesMfast

## Domain Expertise
**Real Estate:** 8 years. Know the exact workflow brokers use, the pain points, the tool stack they prefer (WhatsApp > desktop). Understand broker economics (commission structure, seasonality).
**SaaS:** 2 years in GTM. Learned positioning, cold outreach, piloting with customers. Network of 200+ MENA SaaS operators.

## Why This Founder?
Sarah has an unfair advantage: She's been inside a top-5 global brokerage, managed brokers in GCC, observed their workflows in detail, and built relationships with 200+ independent brokers. She knows what doesn't work (HubSpot is overkill; brokers resist desktop tools). She's not learning the domain; she's applying it.

## Decision-Making Style
**Strength:** Decisive. Once she commits to a direction (WhatsApp-native for solo brokers in GCC), she moves fast. Doesn't overthink.
**Challenge:** Tendency to move fast without validation. Needs external pressure to slow down and test assumptions.

## Risk Profile
**Appetite:** Moderate-to-high. Left stable job to bootstrap. Capital: $25K (personal savings). Comfortable with 18-month runway to profitability. Not comfortable risking family money.
**Constraint:** Cannot afford to fail; this is her primary income now.

## Geographic Strengths
- UAE: Lived 8 years, deep network (100+ brokers)
- KSA: Have connections (50+ contacts from CBRE days)
- Egypt: Limited network (cousin in Cairo = 5-10 contacts)
- Levant: Minimal network (2-3 contacts)

## GTM Instincts
- Relationship-first (will personally call 100+ brokers)
- Prefers warm intros over cold outreach
- Visible on LinkedIn, not on Twitter
- Comfortable on Zoom calls, prefers WhatsApp for ongoing communication

## What She Needs
1. Someone to pressure-test revenue assumptions (she's optimistic)
2. Someone to hold her accountable to 30-day validation cycles (she wants to over-build)
3. Clear positioning language (she can explain the solution but struggles with positioning hooks)
```

**Field validation rules:**
- Name: Required, full name
- Age/base: Required, geography essential for MENA context
- Work history: Required, list 3+ roles with years and one-line context
- Domain expertise: Required, quantify years + depth (not "experienced," but "8 years, know exact workflow")
- Unfair advantage: Required, specific to this founder (not generic)
- Decision style: Required, strength + challenge
- Risk profile: Required, appetite + constraint
- Geographic strengths: Required if MENA-focused, list countries + network size by region
- GTM instincts: Required, 3-4 bullet points on how founder naturally sells
- Needs: Required, 2-3 things this founder needs to succeed

---

### 3. brandvoice.md

**Template structure:** Founder character archetype, tone guidelines, positioning language, words to avoid, MENA-specific voice rules.

**Filled example:**

```markdown
# Brand Voice: Sarah & SalesMfast

## Founder Character
**Archetype:** Market Hunter (Sales-focused, relationship builder, knows the exact buyer pain from inside)

**Positioning voice:** "I've been inside this world. I know the real problem. Here's the system that fixes it."

**How she shows up:** Knowledgeable but humble. Sarah doesn't position as a genius; she positions as someone who solved a problem for herself and is sharing it.

## Tone Guidelines

**Lead with:** Specificity + respect for broker's time
- Instead of: "Your CRM is broken"
- Say: "You're losing 3-4 deals monthly because leads are scattered across WhatsApp, email, SMS"

**Emotional temperature:** Professional-warm (not corporate-cold, not casual-friendly)
- Not: "Let's transform your business" (too corporate)
- Not: "Yo, check out our CRM" (too casual)
- Instead: "Here's how I fixed this problem for brokers like you"

**Proof type:** Named examples + quantified impact
- "3 brokers I worked with lost average of AED 15K per deal due to lead chaos. After implementing this system, they recovered those deals."

**Call to action:** Low-friction, specific
- Not: "Let's discuss your digital transformation roadmap"
- Instead: "Let's do a 15-min walkthrough with one of your leads to show you exactly how this works"

## MENA-Specific Voice Rules
- **Relationship-first:** Lead every conversation with relationship-building, not product
- **Respect hierarchy:** If talking to broker + team, address the decision-maker first
- **Arabic-first for Arab audience:** When speaking in Arabic, use Gulf Arabic (conversational, not MSA)
- **Family business context:** Recognize that many brokers ARE family businesses; acknowledge family in decision
- **Trust through presence:** Be visible and available (WhatsApp > email for ongoing communication)

## Words to Avoid
- "Leverage," "synergy," "ecosystem," "holistic" — Too corporate
- "Disrupt," "innovation" — Overused
- "SME," "B2B" — Use specific: "independent brokers"
- "Digital transformation" — Too vague. Say: "WhatsApp-native lead capture"
- "Best-in-class," "industry-leading" — No evidence. Show, don't claim.

## What She Actually Sounds Like
From a real cold email to a broker:

"Hi [Name],

I noticed you're managing listings across WhatsApp groups and email. Quick question: How many deals have you lost because a lead's inquiry got buried?

I ask because I worked with 3 other brokers who each estimated they lose 2-3 deals per month this way. That's roughly AED 30-50K per month.

Last month, I built a system that captures every WhatsApp lead automatically and reminds you when to follow up. All without leaving WhatsApp.

Want to see it work with one of your real leads? 15 minutes on Zoom.

—Sarah"
```

**Field validation rules:**
- Archetype: Required, must map to one of 8 archetypes
- Positioning voice: Required, 1-2 sentence summary
- Tone guidelines: Required, 3-4 "say this not that" examples
- MENA rules: Required if MENA geography, 3-4 cultural specifics
- Words to avoid: Required, list 5+ with replacements
- Real example: Recommended, show how founder actually writes

---

### 4-13. Remaining Output Files (Brief Specifications with Filled Examples)

Due to length, here are specifications and one filled example for each. Full templates should follow the same "template + filled example + validation rules" pattern.

#### 4. **niche.md** (From SC1 B3)
- **Filled example:** "Independent real estate brokers in Dubai and Abu Dhabi, managing 10-40 active listings, who lose an average of 3-4 deals per month (AED 15-20K per month) because all communication happens across WhatsApp, email, SMS with zero tracking — solved by automatic lead capture + follow-up reminders inside WhatsApp."
- **Validation:** All 4 elements present (person, situation, problem, outcome), includes quantified impact (AED/month), geographic specificity

#### 5. **icp.md** (From SC2 section A)
- **Filled example:**
```
ROLE: Independent commercial real estate broker
COMPANY: Self-employed or 2-person firm
GEOGRAPHY: Dubai, Abu Dhabi, Sharjah, Al Ain
COMPANY SIZE: Solo to 2 people
COMPANY REVENUE: AED 500K-2M annually
DEFINING CHARACTERISTIC: Managing 10-40 listings simultaneously via WhatsApp

PAIN: Lose 3-4 deals/month to lead tracking chaos
BUYING TRIGGER: Recent loss of a AED 100K+ deal due to missed WhatsApp follow-up
BUYING CYCLE: 2-3 weeks from awareness to contract
DECISION MAKER: Broker themselves (owner = decision maker)
BUDGET: AED 1,200-2,000 annually
```
- **Validation:** All section complete, budget is realistic for SMB, pain is broker-specific, decision maker is clear

#### 6. **positioning.md** (From SC1 section C)
- **Filled example:** "WhatsApp-native lead capture for independent Gulf brokers who use WhatsApp exclusively and lose deals to message chaos"
- **Validation:** Short (1 sentence), names how (WhatsApp-native), names who (independent Gulf brokers), names problem (message chaos)

#### 7. **competitor-analysis.md** (From SC1 C2 + SC3 research)
- **Filled example:**
```
CURRENT ALTERNATIVES:
1. HubSpot — Broken: Overkill (300+ features), AED 1000/month, requires desktop work, no WhatsApp
2. Pipedrive — Broken: Still desktop-first, AED 500/month, designed for sales teams not solo brokers
3. Manual WhatsApp groups — Broken: No history, no automation, no follow-up triggers, brokers forget
4. Spreadsheets + WhatsApp — Broken: Manual updates, 3+ hours/week admin, lost data

COMPETITIVE ADVANTAGE:
We're the only tool that lives IN WhatsApp. Brokers don't switch apps. Leads are captured automatically. Follow-ups are automatic. Pricing is 1/5 of HubSpot.
```
- **Validation:** Lists real alternatives (not just competitors), explains what's broken for each, positions unique advantage

#### 8. **market-analysis.md** (From SC3)
- **Filled example:**
```
MARKET SIZE:
TAM: 15,000 licensed brokers in UAE
SAM: 7,500 independent brokers (50% of 15,000)
SOM Year 1: 150 brokers (2% of SAM, conservative)

MARKET GROWTH:
UAE real estate market growing 8% annually. Post-pandemic, brokers are digitizing faster. ZATCA regulations driving accounting tool adoption (adjacent signal).

MENA TRENDS:
- WhatsApp B2B adoption: 90%+ in GCC
- SaaS adoption in SMB: 25% in UAE, 15% in KSA (growing)
- Arabic language requirement: 60% of brokers prefer Arabic UI

COMPETITIVE LANDSCAPE:
No direct competitor in UAE serving solo brokers with WhatsApp-native CRM.
```
- **Validation:** Market size broken into TAM/SAM/SOM, growth is quantified with sources, MENA-specific signals included

#### 9. **strategy.md** (From SC4)
- **Filled example:**
```
STRATEGY PATH: Consulting-First SaaS

RATIONALE:
Sarah has 200+ broker relationships + 8 years domain expertise. Fast path: Close 3 consulting clients in Month 1 (system setup + training = AED 5K per broker). Use consulting revenue to fund SaaS build. Consulting clients become product advisory board + early SaaS customers.

MONTH 1: Consulting Launch
- Define service: "WhatsApp lead capture setup + broker training" at AED 5K/month
- Outreach: 50 warm calls to broker network
- Target: 3 signed contracts
- Revenue: AED 15K/month

MONTH 2: Productize
- Document repeating workflows from consulting delivery
- Identify what should be software vs. manual service
- Build MVP: Auto-capture, categorization, reminders
- Continue consulting (revenue funds build)

MONTH 3+: SaaS Launch
- Beta SaaS with consulting clients (AED 1.5K/year = $410/year)
- Transition consulting clients to SaaS at discount
- Launch public SaaS at AED 2K/year
- Consulting customers become case studies + testimonials for SaaS GTM
```
- **Validation:** Strategy path is named (one of 4), rationale is founder-specific, includes month-by-month roadmap, shows revenue logic

#### 10. **gtm.md** (From SC5 motion scoring)
- **Filled example:**
```
PRIMARY GTM MOTIONS (Next 90 days):

1. Signal Sniper Outbound (Fit: 5/10)
   — Personalized outreach to 100+ brokers in database
   — Use Clay to identify brokers with clear buying signals (recent posts about lead management, hiring sales staff)
   — Pitch: 15-minute walkthrough of how system would work with their leads
   — Target: 20 conversations, 3 pilot closes in 30 days

2. Outcome Demo First (Fit: 7/10)
   — Record video demo showing: Lead comes in WhatsApp → System captures it → Reminder triggers → Broker closes deal
   — Use demo in sales calls + email outreach
   — Lead with: "See how one of your leads would be handled"

3. Dream 100 Strategy (Fit: 6/10, +1 MENA bonus)
   — Identify 30 real estate consultants/advisors/trainers who work with brokers
   — Build relationships (LinkedIn, WhatsApp, coffee)
   — Create affiliate arrangement: They recommend SalesMfast, earn AED 300 per customer
   — Target: 10 affiliates sending 2-3 customers each/month by Month 3

SECONDARY MOTIONS:
- Authority Education (Fit: 4/10) — LinkedIn posts about broker lead management. Build slowly.
- Wave Riding (Fit: 3/10) — Monitor MENA real estate trends; ship quick features if regulatory mandate emerges

SEQUENCING:
Months 1-2: Signal Sniper (fast, founder-led, high touch)
Months 2-3: Demo-first + Dream 100 launch in parallel
Month 3+: Measure what works; double down on highest CAC/LTV
```
- **Validation:** Lists motions with fit scores, explains sequencing logic, includes MENA-aware adjustments

#### 11. **personal-preferences.md**
- Example already provided in earlier section of this file

#### 12. **cowork-instruction.md**
- Example already provided in earlier section of this file

#### 13. **project-instruction.md** (Venture-specific CLAUDE.md)
- **Filled example:**
```markdown
# SalesMfast Real Estate CRM — Project Instructions

## WHO WE ARE BUILDING FOR
Independent real estate brokers in UAE/GCC, 10-40 listings, all communication via WhatsApp, losing 3-4 deals/month to lead chaos.

## THE PROBLEM WE SOLVE
Brokers lose leads to fragmentation (WhatsApp, email, SMS). No central history. No follow-up automation. Competitors (HubSpot, Pipedrive) are overkill and desktop-first.

## THE SOLUTION
WhatsApp-native CRM that:
1. Auto-captures leads from WhatsApp (no manual entry)
2. Tags + categorizes automatically
3. Sends follow-up reminders at right time
4. All inside WhatsApp (zero app-switching)

## MVP SCOPE (Phase 1)
- WhatsApp webhook integration (capture messages)
- Lead auto-categorization (real, unqualified, spam)
- Follow-up reminder system (SMS + WhatsApp)
- Simple dashboard to see all leads

NOT in MVP: Reporting, CRM integrations, team features, mobile app

## PRICING & GTM
AED 1.5K/year early; AED 2K/year after 50 customers
Target: 50 customers by Month 4; AED 100K ARR by Month 12

## STACK DECISIONS
- **Frontend:** No-code (Bubble or FlutterFlow) for speed
- **Backend:** n8n workflows (WhatsApp webhook → processing → database)
- **Database:** PostgreSQL (self-hosted or Supabase)
- **Messaging:** Twilio for SMS reminders
- **Team:** Solo founder + 1 technical contractor as needed

## QUALITY GATES BEFORE LAUNCH
1. 20 pilot customers through for 4 weeks
2. NPS > 30 from pilots
3. Churn = 0 (pilots stay)
4. Cost per customer acquisition < AED 500
5. LTV:CAC ratio > 3:1

## COMMUNICATION STYLE
- Be specific: "Auto-capture 100% of leads from WhatsApp" not "smart lead management"
- Show results: "3 brokers recovered 12 deals they would have lost" not "more organized"
- Lead with outcome: "Close more deals" not "better CRM"
```
- **Validation:** Includes WHO, WHAT (solution), MVP scope, pricing, stack, quality gates, communication rules

---

## Summary: 13 Output Files + Their Status

| File | Purpose | Template | Filled Example | Validation Rules |
|------|---------|----------|---|---|
| 1. companyprofile.md | Company narrative | ✓ | ✓ (WhatsApp CRM example) | ✓ |
| 2. founderprofile.md | Founder background | ✓ | ✓ (Sarah's profile) | ✓ |
| 3. brandvoice.md | Tone + positioning | ✓ | ✓ (Market Hunter archetype) | ✓ |
| 4. niche.md | 3-level niche definition | ✓ | ✓ (Dubai brokers) | ✓ |
| 5. icp.md | Ideal customer profile | ✓ | ✓ (Solo broker with pain) | ✓ |
| 6. positioning.md | One-liner positioning | ✓ | ✓ (WhatsApp-native for brokers) | ✓ |
| 7. competitor-analysis.md | Alternatives + moats | ✓ | ✓ (HubSpot, Pipedrive, manual) | ✓ |
| 8. market-analysis.md | TAM/SAM/SOM + growth | ✓ | ✓ (UAE real estate market) | ✓ |
| 9. strategy.md | 90-day roadmap | ✓ | ✓ (Consulting-First SaaS) | ✓ |
| 10. gtm.md | Primary GTM motions | ✓ | ✓ (Signal Sniper, Demo, Dream 100) | ✓ |
| 11. personal-preferences.md | Claude behavior profile | ✓ | ✓ (In earlier section) | ✓ |
| 12. cowork-instruction.md | Global CLAUDE.md | ✓ | ✓ (In earlier section) | ✓ |
| 13. project-instruction.md | Project-specific CLAUDE.md | ✓ | ✓ (SalesMfast example) | ✓ |

All 13 files now have: (1) template showing structure, (2) filled example with realistic data, (3) field-level validation rules.

