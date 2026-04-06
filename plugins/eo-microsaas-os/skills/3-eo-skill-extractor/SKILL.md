---
name: 3-eo-skill-extractor
description: "EO Skill Extractor v2 — teaching wrapper that guides students through creating custom AI skills for their tools. Reads GTM motion playbook to suggest which workflows to automate. 4-Phase Framework: Tool Discovery, Operation Mapping, SKILL.md Construction, Testing. Triggers on: 'build my AI team', 'skill extractor', 'create a skill', 'phase 3', 'build a skill', 'super AI team'."
version: "2.0"
---

# 3-Skill Extractor: Build Your Super AI Team

## The Framing
You don't need to hire people. You need to create specialized AI agents who:
- Work 24/7 and never call in sick
- Execute your exact SOP every single time
- Get smarter with each iteration
- Cost virtually nothing to scale

Every skill you create from this point is a team member. Each one handles one workflow. Together, they become your super AI team.

---

## What This Skill Does

**Does NOT:**
- Auto-generate skills for you (that would defeat the learning)
- Give you cookie-cutter templates you don't understand
- Let you create something that breaks in production

**DOES:**
- Guide you through the 4-Phase Framework step-by-step
- Read YOUR project context (1-ProjectBrain) and GTM motion (2-GTM/output/GTM)
- Show you exactly which operations in your workflow are skill-worthy
- Teach you the SKILL.md structure so you own it completely
- Connect your new skill to your other systems
- Quality-check your work before you deploy

---

## Inputs This Skill Reads

Before you run this, the skill will read:

1. **1-ProjectBrain/Project/*.md**
   - Your business model, target customer, revenue thesis
   - Existing operations and workflows
   - Pain points and bottlenecks

2. **2-GTM/output/GTM/[Your-Chosen-Motion].md**
   - The GTM motion you selected (e.g., 06-Signal Sniper, 13-Paid VSL)
   - The specific workflow steps for that motion
   - High-value, repetitive operations in that motion

3. **_language-pref.md** (if exists)
   - Your language preference for skill instructions

4. **Tool & MCP Inventory** (you'll provide)
   - Tools your team actually uses
   - MCPs connected to your Claude setup
   - APIs available in your stack

---

## Outputs This Skill Creates

Creates new skill files in **3-Newskills/** with the correct directory structure:

```
3-Newskills/
├── Dev/              (Supabase, n8n, API automations, databases)
├── GTM/              (Email, LinkedIn, CRM, social, landing pages)
└── Ops/              (Project management, docs, scheduling, reporting)
```

Each skill you create follows this structure:
- **YAML frontmatter** (metadata for organization)
- **Role definition** (what this AI agent does)
- **4-Phase Framework** (how you built it)
- **Trigger & Input specs** (when/how it runs)
- **Core SOP** (step-by-step workflow)
- **Error Handling** (what breaks, how to fix)
- **Cross-skill Dependencies** (what other skills it needs)
- **Quality Checklist** (before you deploy)
- **Self-Score** (how good is this skill really?)

---

### Founder Quotes (use contextually throughout the session)

| Moment | EN Quote | AR Quote |
|--------|----------|----------|
| Starting Phase 1 | "The best founders don't hire faster. They automate smarter." | "أفضل المؤسسين ما يوظفون أسرع. يأتمتون أذكى." |
| Student lists 10+ tools | "You don't need all of these. You need the 3 that move revenue." | "ما تحتاج كل هالأدوات. تحتاج الـ 3 اللي تحرك الإيرادات." |
| Student hesitates on first skill | "Your first skill will be ugly. Ship it anyway. Version 2 will be clean." | "أول skill بيطلع مو حلو. أطلقه. النسخة الثانية بتكون نظيفة." |
| Student finishes a skill | "Congratulations, you just hired an employee who never sleeps, never complains, and costs $0/month." | "مبروك، توظفت موظف ما ينام، ما يشتكي، وراتبه $0 بالشهر." |
| Student wants to skip testing | "Untested skills are like sending an intern to a client meeting unsupervised. You'll regret it." | "Skill بدون تجربة مثل ما ترسل متدرب لاجتماع عميل بدون إشراف. بتندم." |

---

## The 4-Phase Framework

This is how you'll build each skill.

### Phase 1: Tool Discovery
**Question:** What tools + MCPs do I actually have available?

**What to map:**
- Primary tools in your stack (CRM, email, social, analytics, etc.)
- MCPs connected to your Cowork setup
- APIs you have credentials for
- Internal databases (Supabase, n8n, etc.)
- Manual tools (spreadsheets, Zapier, IFTTT)

**Output:**
A simple table:
```
| Tool | MCP Connected? | Operations Available |
|------|----------------|---------------------|
| [tool name] | Yes/No | [what this tool can do] |
```

**Why this matters:** You can't automate what you don't have access to. If you have a tool but no MCP, you might need to build a bridge (n8n workflow, API call, etc.).

---

### Phase 2: Operation Mapping
**Question:** Which workflows in my GTM motion are high-value + repetitive + time-consuming?

**What to find:**
- Operations that happen weekly or more
- Steps that take 30+ minutes manually
- Decisions that follow a pattern
- Data that moves between tools

**Example:**
If you chose **06-Signal Sniper** (cold outbound):
- Enriching lead data (LinkedIn, ZoomInfo, emails) = high-value, repetitive
- Personalizing emails with signal = time-consuming but pattern-based
- Scoring leads by engagement signals = rule-based, doable by AI

**Output:**
For each operation:
```
Operation: [Name]
Current tool(s): [Where it happens now]
Time spent: [How long per week]
Repetition: [How many times]
Decision logic: [Is it rules-based or judgment-based?]
Data input: [What feeds into this]
Data output: [What comes out]
Failure mode: [What breaks when this goes wrong]
```

**Why this matters:** Not every workflow deserves a skill. You only create skills for operations that:
1. Follow a pattern (rules-based, not creative judgment)
2. Happen frequently (weekly+)
3. Free up meaningful time when automated
4. Have clear success criteria

---

### Phase 3: SKILL.md Construction
**Question:** How do I build this into a Cowork skill that actually works?

**The SKILL.md structure:**

```yaml
---
title: "[Skill Name]"
role: "[What this AI agent does]"
context: "[Which GTM motion / workflow]"
tools_required: "[CRM, email, n8n, etc.]"
operations_automated: "[List 3-5 operations]"
time_saved_per_week: "[Hours]"
created_date: "[Date]"
status: "[discovery/testing/production]"
---

## Role

[1-2 sentence description of what this skill does. Write as if describing a team member.]

Example: "Lead Enricher finds buying signals in prospect data and scores them by intent level. Works with raw lead lists and returns scored, prioritized prospects."

## Why This Skill Exists

[The business problem this solves. Be specific about time/cost/impact.]

Example: "Our cold outbound team spends 45 minutes per day manually researching 15-20 leads. We're losing competitive advantage because we can't enrich and score at speed. Lead Enricher does this in 90 seconds."

## Inputs

[What this skill needs to run]

- **Input format:** [CSV, JSON, single lead, batch]
- **Data required:** [Fields needed]
- **Tool access required:** [Which systems it touches]
- **MCP dependencies:** [Which MCPs must be active]

Example:
```
Input: CSV with columns [first_name, last_name, company, industry, email]
Tools: LinkedIn (HeyReach MCP), ZoomInfo API, CRM (GoHighLevel MCP)
```

## Outputs

[What this skill produces]

- **Format:** [CSV, CRM update, email, Slack message, etc.]
- **Fields:** [What data comes out]
- **Destination:** [Where it goes (CRM, spreadsheet, Slack, etc.)]

Example:
```
Output: Updated CSV with new columns:
- signal_score (0-100)
- buying_intent_indicators (list)
- enriched_linkedin_url
- recommended_angle (personalization hook)
```

## Core SOP (Step-by-Step)

[The exact workflow this skill executes]

**Step 1: Input validation**
- Check for required fields
- Validate email/LinkedIn URLs
- Handle missing data (skip or flag?)

**Step 2: [Operation A]**
- What happens
- Tools used
- Decision points
- Error handling

**Step 3: [Operation B]**
- What happens
- Tools used
- Decision points
- Error handling

*Repeat for each core operation*

**Step N: Output & logging**
- Format the output
- Send to destination
- Log what happened (for debugging)
- Notify user of completion

## Error Handling

[What breaks and how to fix it]

Create a table for each common failure:

| Failure Mode | Cause | Recovery Action |
|--------------|-------|-----------------|
| [Problem] | [Why it happens] | [How to fix] |

Examples:
```
| LinkedIn profile not found | Typo in name or profile URL dead | Flag prospect, skip enrichment, continue batch |
| Rate limit hit on ZoomInfo API | Too many lookups too fast | Pause for 60 sec, resume |
| Missing required field | Input CSV incomplete | Stop batch, notify user, return partial results |
| Email already in CRM | Duplicate lead | Skip and note in log |
```

## Cross-Skill Dependencies

[What other skills does this one depend on? What depends on this?]

Example:
```
Depends on:
- [2-Trend Monitor] to identify buying signals

Required by:
- [Cold Email Personalizer] (uses this skill's output as input)
- [Lead Priority Dashboard] (displays this skill's scores)
```

## Testing Checklist

[Before you deploy this skill to production, verify all of these]

- [ ] Tested with real data from your CRM/email/social
- [ ] Tested with edge cases (missing fields, special characters, duplicates)
- [ ] Tested error handling (what happens when a tool is unavailable)
- [ ] Verified output format matches what downstream skills/tools need
- [ ] Timed the execution (does it actually save time?)
- [ ] Ran 3-5 real operations and spot-checked results for accuracy
- [ ] Documented any surprises or gotchas
- [ ] Got feedback from the team member who'll use it

## Quality Self-Score

[Rate yourself honestly]

| Dimension | Score (1-5) | Notes |
|-----------|-------------|-------|
| **Clarity** | ? | Is the SOP so clear a new team member could execute it? |
| **Completeness** | ? | Does it handle edge cases or just the happy path? |
| **Reliability** | ? | Have you tested this 5+ times with real data? |
| **Efficiency** | ? | Does it actually save time vs. doing it manually? |
| **Maintainability** | ? | Could you update this skill in 30 minutes if something breaks? |

## Success Criteria

[How do you know this skill is working?]

- ✓ [Measurable outcome #1]
- ✓ [Measurable outcome #2]
- ✓ [Measurable outcome #3]

Example:
```
- ✓ Processes 15+ leads per day (was manual, took 45 minutes)
- ✓ Lead enrichment accuracy 90%+ (spot-checked vs. manual research)
- ✓ Catches 80%+ of qualified leads that cold email scoring would prioritize
- ✓ Takes < 5 minutes to run vs. 45 minutes manual
```

## Version History

[Track changes as you improve this skill]

```
v1.0 - Initial build
v1.1 - Added fallback when ZoomInfo unavailable
v1.2 - Improved LinkedIn enrichment accuracy
```

---

```

---

## GTM Motion → Suggested Starter Skills

**Read your chosen GTM motion file (2-GTM/output/GTM/), then check this table for skill ideas.**

Each motion has bottleneck operations that beg for automation. Start here.

| Motion | Suggested Starter Skills |
|--------|------------------------|
| **01-Waitlist Heat** | Email list manager, webinar registration tracker, waitlist CRM updater |
| **02-Build in Public** | Social post scheduler, metrics dashboard updater, changelog publisher |
| **03-Authority Education** | YouTube upload assistant, content calendar manager, LinkedIn post drafter |
| **04-Wave Riding** | Trend monitor, news scanner, rapid response post creator |
| **05-LTD Cash to MRR** | AppSumo listing manager, LTD customer migrator, MRR conversion tracker |
| **06-Signal Sniper** | Lead enricher, signal scorer, cold email personalizer |
| **07-Outcome Demo** | Demo environment resetter, case study generator, before/after compiler |
| **08-Hammering Feature** | Feature page builder, SEO tracker, directory submission automator |
| **09-BOFU SEO** | Keyword tracker, content brief generator, internal linking auditor |
| **10-Dream 100** | Contact researcher, engagement tracker, co-creation proposal drafter |
| **11-7x4x11** | Event scheduler, touchpoint tracker, follow-up sequence manager |
| **12-Value Trust** | Training content organizer, community digest builder, upsell trigger monitor |
| **13-Paid VSL** | Ad performance tracker, VSL script versioner, landing page A/B manager |

---

## Teaching Methodology: How To Use This Framework

### Phase 1: Ask Yourself These Questions

1. **"What tools do I actually have?"**
   - Don't assume you know. Log into each platform.
   - Which MCPs are connected to your Cowork setup?
   - What APIs do you have credentials for?
   - What's still manual (spreadsheets, copy-paste)?

2. **"What's slowing my team down?"**
   - Not what *could* be automated. What *should* be?
   - Talk to the person doing the work. Ask them where they lose time.
   - Time that costs money = priority.

3. **"Is this rules-based or judgment-based?"**
   - Rules-based (e.g., "if lead came from LinkedIn AND company size > 50 AND engaged with 2+ posts, then score 8/10") = skill-worthy
   - Judgment-based (e.g., "does this prospect feel like a good fit for our product?") = AI-assisted, not automated

### Phase 2: Don't Overthink The Mapping

You're not writing dissertation here. Just answer:
- **Operation:** What's the task?
- **Current tool:** Where does it happen now?
- **Time:** How long does it take?
- **Pattern:** Does it follow the same logic every time?

That's it. One page per operation.

### Phase 3: Build The Skill With This Mindset

**You own this.** This isn't a template you fill in. You're designing an instruction manual for how your AI team member executes this specific workflow in your specific stack.

**Questions to ask yourself as you build:**
- If I handed this SKILL.md to Claude (or another AI), could they execute this perfectly on day 1?
- What would break? (Missing fields? Third-party API down? Edge cases?)
- What's the minimum viable output? (Don't overcomplicate.)
- How do I know it worked? (What's the success signal?)

**Common mistakes to avoid:**
- Writing SOPs that are too vague ("enrich the lead" = not actionable)
- Ignoring error cases (what happens when the API is down?)
- Building skills for operations that happen once a month (not worth it)
- Creating skills that depend on 5 other skills (too fragile)
- Not testing with real data before calling it "done"

### Phase 4: Test Before You Deploy

**"Testing" doesn't mean reading through it.** It means running it.

- Pick 3-5 real operations from your workflow
- Actually execute the SKILL.md manually (or with an AI, depending on what it is)
- Time it. Compare to doing it manually.
- Check the output. Is it accurate?
- Try to break it. Missing field? API timeout? Duplicate data?
- Fix what breaks. Update the SKILL.md.
- Only after this do you call it "done."

---

## The GTM Motion Connection

**Before you create a skill, read your chosen GTM motion playbook (2-GTM/output/GTM/).**

Your motion tells you:
- Which workflows happen weekly (skill candidate)
- Where manual work creates bottlenecks (skill opportunity)
- What data flows between tools (integration points)
- What the success metrics are (skill success criteria)

**Example:**

If you chose **06-Signal Sniper** and your motion says:
- "Week 1: Find 100 target prospects in your ICP"
- "Week 2-3: Enrich and score each prospect on buying signals"
- "Week 4-6: Personalized cold email sequence based on signal strength"

Then your first skills should be:
1. **Lead Enricher** (automates the enrichment part)
2. **Signal Scorer** (automates the scoring)
3. **Cold Email Personalizer** (uses the scoring to personalize)

You're building skills that directly accelerate your chosen motion.

---

## What Failure Looks Like (And How To Avoid It)

### Failure Mode 1: "I created a skill I don't understand"
**What happened:** You used a template, filled in some fields, and now you can't update it when it breaks.

**How to avoid it:** Before you call a skill "done," explain it to someone else. If you can't explain the SOP in 5 minutes, you don't understand it yet. Go back and clarify.

### Failure Mode 2: "My skill works 80% of the time"
**What happened:** You tested with the happy path but didn't account for edge cases. Now it breaks on Tuesdays when your CRM is syncing, or when a prospect's name has special characters.

**How to avoid it:** In Phase 4 (Testing), deliberately try to break it. Missing fields. API timeouts. Duplicates. Unusual data. Build error handling for the top 5 ways it could fail.

### Failure Mode 3: "This skill was supposed to save time but it just adds a step"
**What happened:** You automated a 5-minute task but now someone has to manually trigger the skill and move the output around. It's not actually faster.

**How to avoid it:** In Phase 2 (Operation Mapping), ask: "Will this skill reduce total time, or just move the work around?" If it's not a net win, don't build it.

### Failure Mode 4: "I have 20 skills and they don't talk to each other"
**What happened:** Each skill is designed in isolation. The output of Skill A doesn't match the input of Skill B. They conflict.

**How to avoid it:** In the "Cross-skill Dependencies" section, map what each skill needs from others and what it provides. Before building Skill B, check if Skill A already does part of the work.

---

## Directory Structure

When you're ready to create a skill, save it in the right place:

```
3-Newskills/
│
├── Dev/                           (Backend, databases, APIs, infrastructure)
│   ├── supabase-row-inserter/
│   ├── n8n-webhook-trigger/
│   ├── api-data-transformer/
│   └── database-sync-manager/
│
├── GTM/                           (Customer acquisition, revenue, product-market fit)
│   ├── cold-email-personalizer/
│   ├── linkedin-sequence-manager/
│   ├── lead-scorer/
│   ├── waitlist-email-blaster/
│   └── demo-booking-automator/
│
└── Ops/                           (Coordination, planning, reporting, admin)
    ├── weekly-report-generator/
    ├── project-sync-updater/
    ├── team-calendar-blocker/
    └── content-calendar-publisher/
```

**When you create a skill:**
1. Create the folder in the right category (Dev, GTM, or Ops)
2. Add SKILL.md inside
3. Add any supporting files (templates, error logs, dependencies list)
4. Note it in your skill inventory

---

## Language Awareness

If you have _language-pref.md configured:
- **English-primary:** SOPs are direct, technical, concise
- **Arabic-primary:** Conversational tone, mix Arabic + English tech terms naturally
- **Bilingual:** Frontmatter in English, SOPs available in both

When you create a skill, match your language preference. Your AI team member should sound like your team.

---

## Quality Checklist Before You Deploy

Don't call a skill "production-ready" until you check all of these:

- [ ] **Clarity**: Could a new team member read the SOP and execute it without asking questions?
- [ ] **Completeness**: Does it handle the happy path AND the 5 most likely failure modes?
- [ ] **Accuracy**: Have you tested it 3+ times with real data and verified the output?
- [ ] **Efficiency**: Does it actually save time? (Measure it. Don't guess.)
- [ ] **Dependencies**: Does it need other skills or tools? Are those documented?
- [ ] **Error handling**: What breaks and how do you fix it? Is that in the skill?
- [ ] **Logging**: Can you see what happened if something goes wrong?
- [ ] **Maintenance**: Could you update this skill in 30 minutes if something breaks?
- [ ] **Testing**: Have you tested it in the actual environment (not just locally)?
- [ ] **Documentation**: Is SKILL.md so clear that someone else could take over if you left?

If you check all 10, you're done. If not, keep iterating.

---

## The Running Joke (So You Don't Get Too Serious)

You're building a super AI team. Your first hire (your first skill) will be clumsy. It'll make mistakes. It'll need hand-holding. That's normal.

By your 5th skill, you'll have a team that runs circles around your manual process. By your 10th, you'll wonder how you ever did this work manually.

By your 20th, you'll stop counting and just accept that you've built a robot army that works while you sleep.

---

## Next Steps After This Skill

Once you've created your first skill:

1. **Test it with real operations** (Phase 4). Don't just read it, run it.
2. **Get feedback** from the team member who'll actually use it.
3. **Version it** (v1.1, v1.2, etc.) as you find issues.
4. **Create your second skill** by following this same framework. (It gets faster.)
5. **Link skills together**. Skill A's output feeds into Skill B. Build the interconnections.
6. **Monitor the metrics**. How much time does your team actually save? Where are the friction points?

---

## Questions To Ask Before You Start

Before you run this skill and start building, answer these:

1. **Which GTM motion did I choose?** (Check 2-GTM/output/GTM/)
2. **What tools does my team actually use?** (List them.)
3. **Which MCPs are connected to my Cowork setup?** (Check your Claude settings.)
4. **What operations slow my team down the most?** (Ask them.)
5. **Do I want to build one big skill or start with something small?** (Start small. Iterate.)

---

**Welcome to Phase 3. You're about to create your super AI team. Let's go.**

