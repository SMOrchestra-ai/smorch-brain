# SMOrchestra.ai - Team Operating SOP: How to Work with Claude

**Version:** 1.0 | **Date:** March 2026 | **Owner:** Mamoun Alamouri

---

## Purpose

This SOP defines how every SMOrchestra team member uses Claude. Not guidelines. Rules. Follow them exactly. Your output quality, speed, and accountability depend on this system working consistently across the team.

---

## SECTION 1: MANDATORY DAILY REPORTING

**This is non-negotiable. No exceptions. No reminders.**

Every team member must send a voice note at the end of each working day reporting what they shipped. Not what they "worked on." What they shipped.

**Format:** Voice note (WhatsApp group or designated channel)

**Timing:** End of day, before signing off

**Content must include:**
1. What you shipped today (deliverables, files, outputs)
2. Which tasks from your assignment are now complete
3. Any blockers or decisions needed from Mamoun
4. What you plan to ship tomorrow

**The rule:** When Mamoun assigns you a task, YOU own the reporting. Mamoun should never have to follow up or ask "where is this?" You report proactively. Every day. Without fail.

If you shipped nothing, say so and say why. Silence is worse than "I got blocked."

---

## SECTION 2: THE 22 RULES (Baseline)

These 22 rules are your foundation. Every team member must internalize them before doing any work with Claude.

### Before You Type (Rules 1-4)

**Rule 1: Turn on Extended Thinking.** Settings > Model > Extended Thinking: ON. Without it, you get first-pass answers. With it, Claude reasons through the problem before responding. The difference in output quality is massive for strategy, code, and complex analysis.

**Rule 2: Select Opus 4.6 as default.** Opus is the most capable model. Sonnet and Haiku have their place (covered below), but Opus is the default for all real work. Non-negotiable.

**Rule 3: Open Cowork, not blank Chat.** Chat mode has no file access, no code execution, no persistence. It is for quick throwaway questions only. For all real work: Cowork. Always.

**Rule 4: Point to your directory first.** Before typing anything, select your working folder. Claude reads the files inside and uses them as context. No folder = zero knowledge about your work. Every session.

### Build Your Command Center (Rules 5-9)

**Rule 5: Use the smorch-context folder structure.** Every team member clones the smorch-context repo to their machine. This is NOT just 3 files. It contains full project context organized by business line:

```
smorch-context/
  CC_CX/
    Project1-CC-transformation/
    Project2-CXMfast/
    Project3-CX-community/
  EntrepreneurOasis/
    Project1-MicroSaaSClaudeOS-Training/
    Project2-EO-BuildAppSumoTech/
    Project3-AI-Super-cowork-training/
    Project4-AI-Super-MicroSaaS-LauncherTech/
  SalesMfastGTM/
    Project1-SalesMfastExpand/
    Project2-SalesMfastB2B/
    project3-SalesMfast-SME/
    Project4-CohortTraining/
    Project5-MarketingTransformation/
    Project6-SSEngineTech/
```

Your role determines which folders you need. See the ClaudeBrainSync setup guide for your role-specific configuration.

**Rule 6: Your ABOUT-ME files define who you are to Claude.** These contain your identity, voice, and rules. Claude reads them to understand WHO is working.

**Rule 7: Project folders keep context isolated.** One subfolder per project. When you work on SalesMfast GTM, Claude sees only that context. When you switch to EO, it sees that one. No bleed-over.

**Rule 8: Templates folder stores reusable formats.** Email templates, report structures, code scaffolds. Anything you use repeatedly.

**Rule 9: Outputs folder holds Claude's deliverables.** Everything Claude creates lands here. Clean separation between input context and output.

### The Files That Change Everything (Rules 10-14)

**Rule 10: about-me.md exists for a reason.** It tells Claude your name, role, company, industry, daily responsibilities, key projects, and goals. Be specific. "I am a SaaS founder" is useless. "I run B2B outbound campaigns for CXMfast targeting contact center managers in Saudi Arabia" is useful.

**Rule 11: my-voice.md controls tone.** Your tone preferences, banned words, and 3-5 real writing samples. Without this, Claude writes generic corporate language. With it, Claude writes like you.

**Rule 12: my-rules.md sets guardrails.** Operational rules (ask before deleting files, show plan before executing), formatting rules (no em dashes, no emojis), content rules (never hedge, take positions). Set once, enforced automatically.

**Rule 13: Import context from other AIs if switching.** Use Claude's memory import feature to transfer what matters from ChatGPT or other tools.

**Rule 14: Global Instructions run behind every conversation.** Your identity line and standing orders. Set once in Settings > Cowork > Edit Global Instructions.

### Set Once, Never Again (Rules 15-18)

**Rule 15: Configure Global Instructions.** Settings > Cowork > Edit Global Instructions. This is injected before every conversation.

**Rule 16: Paste your identity line.** "I'm [Name], [Role] at SMOrchestra.ai. Read my files before every task."

**Rule 17: Add the safety line.** "Ask questions before executing. Show a plan first." This prevents Claude from going rogue on complex tasks.

**Rule 18: Add the protection line.** "Never delete files without my explicit approval." Claude has real file access. This is your safety net.

### Kill These Habits (Rules 19-22)

**Rule 19: Stop writing long prompts.** If your context files are set up properly, your prompts should be 2-3 sentences. The context does the heavy lifting.

**Rule 20: Stop skipping folder setup.** "I'll do it later" is the #1 reason people get bad output. 30 minutes of setup = months of better results.

**Rule 21: Stop using Chat when you need Cowork.** Chat is a bicycle. Cowork is a workshop. Use the right tool.

**Rule 22: Stop expecting Claude to know you without files.** No context files = you are a stranger every session. Three files fix this permanently.

---

## SECTION 3: MODEL SELECTION RULES

Not everything needs Opus. Use the right model for the job.

**Opus 4.6 (Default):** Strategy, deep analysis, complex writing, code architecture, anything requiring judgment. This is your workhorse. Extended Thinking ON.

**Sonnet (Dumb Work):** Translation, filling data into templates, clear mechanical tasks with no ambiguity. When the task requires zero judgment and the instructions are explicit, Sonnet is faster and cheaper. Examples: translating a doc from English to Arabic, populating a spreadsheet from given data, reformatting content from one structure to another.

**When in doubt, use Opus.** The cost of using Sonnet on a judgment task is rework. The cost of using Opus on a simple task is a few extra seconds.

---

## SECTION 4: THE SELF-SCORING RULE

**After every significant deliverable, ask Claude to score itself and bridge the gap to 10/10.**

This is mandatory. Not optional. Not "when you remember."

After Claude delivers any substantial output (proposal, campaign, deck, code, strategy doc), say:

> "Score this output 1-10 on [relevance/quality/completeness]. What would make it a 10/10? Bridge the gap."

Claude will identify its own weak spots and improve. This single habit eliminates 80% of the "good enough" mediocrity that wastes revision cycles.

Do this BEFORE sending the deliverable for review. Your first submission should already be the improved version.

---

## SECTION 5: SKILL AND PLUGIN SYSTEM

### The Skill Catalog

A skill catalog has been created and shared with the entire team. Before starting any task, check the catalog to see if a relevant skill exists. Do not reinvent work that has already been systematized.

Review the catalog: `SOP/claude-plugins-catalog-2026-03.docx`

Your role determines which plugins you install. Refer to the ClaudeBrainSync guide for your specific setup.

### The Skill Lifecycle: From Deep Work to Reusable Asset

Every piece of deep collaborative work should follow this lifecycle:

**Step 1: Do the deep work.** Build the proposal, campaign, workflow, or whatever the task requires. Use Opus. Use Extended Thinking. Get it right.

**Step 2: Turn it into a skill.** If the work involved 3+ steps that could be templated, or if you will repeat this type of work, create a skill from it. Use the smorch-dev:smo-skill-creator or smorch-gtm-engine:smorch-skill-creator skill.

**Step 3: Keep the skill for a few days.** Run it on 2-3 real tasks. Do not declare it production-ready on day one.

**Step 4: Score the results.** After each use, score the skill output 1-10. Document what worked and what did not.

**Step 5: When results are satisfactory.** Report the results to Mamoun and upload the skill to the SMOrchestra GitHub.

### When a Skill Is NOT Yielding Good Results

**Do NOT modify the original skill.** Instead:

1. Create a new skill with a descriptive variant name (e.g., `linkedin-nour-style` if Nour is testing a different LinkedIn approach)
2. Follow the same lifecycle above: keep it for a few days, score results
3. When ready, score it against the original by giving both skills the same 3 tasks in the same Cowork session
4. The winner becomes the standard. The loser gets archived with notes on why it lost.

This prevents breaking working skills while experimenting. Always preserve what works.

### Repeated Tasks MUST Become Skills

If you do a task more than twice, it must become a skill. No exceptions. The third time you do something manually is a failure of process, not a failure of time.

---

## SECTION 6: CAMPAIGN BASELINE

**Clay + Claude + Signal Sales Engine (our software) is the baseline for all campaigns.**

Every outbound campaign starts from this stack. Not from scratch. Not from a blank Google Sheet.

- **Clay:** Enrichment, signal detection, waterfall data. The data layer.
- **Claude (Cowork + Skills):** Asset generation, wedge creation, sequence writing, analysis. The intelligence layer.
- **Signal Sales Engine (SSE):** Our proprietary software for signal scoring, sequencing, and orchestration. The execution layer.

If someone proposes a campaign workflow that does not include all three, push back. The stack exists for a reason.

---

## SECTION 7: TICKET DISCIPLINE

**All tickets go in Linear. Always.**

Not Slack messages. Not WhatsApp notes. Not "I'll remember." Linear.

Every task assigned must have a Linear ticket. Every task completed must update its Linear ticket. Every blocker must be logged in the ticket.

If a task does not have a ticket, it does not exist. If a ticket is not updated, the work is not done.

---

## SECTION 8: WORKING WITH COWORK (Mandatory Mode)

**Cowork is the only acceptable mode for real work. Always.**

Not Claude.ai chat. Not Claude Code (unless you are in a Dev role working on actual code). Cowork.

Why: Cowork gives Claude access to your files, your project context, your skills, your plugins. Chat mode gives Claude nothing. The output quality difference is not marginal; it is the difference between a stranger and a colleague.

### Session Start Checklist

Every Cowork session, before you type your first task:

1. Confirm you are in Cowork (not Chat)
2. Confirm your folder is pointed to the right project directory
3. Confirm your model is set to Opus 4.6 (or Sonnet if the task is purely mechanical)
4. Confirm Extended Thinking is ON (for Opus tasks)

---

## SECTION 9: SETUP GUIDE (One-Time)

Follow the ClaudeBrainSync guide for your role. The roles are:

| Role | Cowork Plugins | Context Folders |
|------|---------------|-----------------|
| GTM - EO | 6 plugins | EntrepreneurOasis |
| GTM - SMO | 5 plugins | SalesMfastGTM + CC_CX |
| Dev | 1 plugin (+ 7 Code dev tools) | EntrepreneurOasis + SalesMfastGTM |
| EO Student | 2 plugins (+ 7 Code dev tools) | None |

### Daily Commands

| What | Command |
|------|---------|
| Get latest skills | `.\smorch-brain\scripts\smorch.ps1 pull` |
| Get latest context | `.\smorch-brain\scripts\smorch-context.ps1 -Action update` |
| Push context changes | `.\smorch-brain\scripts\smorch-context.ps1 -Action push` |
| Check setup | `.\smorch-brain\scripts\smorch.ps1 status` |

---

## SECTION 10: QUICK REFERENCE - DECISION RULES

**Which model?**
- Judgment required? Opus.
- Mechanical/repetitive? Sonnet.
- Unsure? Opus.

**Which mode?**
- Real work? Cowork. Always.
- Quick factual question? Chat is fine.

**Skill exists?**
- Yes? Use it. Do not do it manually.
- No, but you have done this before? Build one.
- No, first time? Do it in Opus, then build a skill from it.

**Deliverable ready?**
- Did you ask Claude to self-score? If no, do it.
- Did you bridge the gap to 10/10? If no, do it.
- Only then submit for review.

**Task assigned?**
- Is it in Linear? If no, create the ticket first.
- Did you report progress today? If no, send your voice note.

---

## Appendix: File Locations

| Item | Location |
|------|----------|
| This SOP | `SOP/smorch-team-sop-2026-03.md` |
| 22 Rules Deck (reference) | `SOP/22-claude-rules-2026-03.pptx` |
| Brain Sync Setup Guide | `SOP/ClaudeBrainSync-Windows-2026-03.docx` |
| Plugin Catalog | `SOP/claude-plugins-catalog-2026-03.docx` |
| Context Files Repo | `smorch-context/` (cloned from GitHub) |
| Skills Repo | `smorch-brain/` (cloned from GitHub) |

---

*Last updated: March 26, 2026. For questions, ask Mamoun directly. For setup issues, check the troubleshooting section in ClaudeBrainSync.*
