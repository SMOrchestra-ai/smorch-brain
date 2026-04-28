# COWORK GLOBAL INSTRUCTIONS FRAMEWORK TEMPLATE
# (CLAUDE.md - placed at root of your Cowork workspace folder inside .claude/)
# Loads ONLY in Cowork sessions. This is your deep operational playbook.
# No word limit, but respect context window: aim for 2,000-3,000 words max.
# Delete all comments (lines starting with #) before deploying.


## 1. IDENTITY

# WHAT: Expanded version of Profile identity. Add business lines, competitive models, market focus.
# WHY: Cowork needs the full picture to route work correctly and write in-context.
# RULE: Don't repeat Profile verbatim. Expand on it. Profile says "Founder of X." Cowork says what X does, who it serves, and which companies you model it after.

[Full Name] - [Role] of [Company], [one-sentence company description with market and value prop].

Business lines ([count] concurrent):
- [Line 1] - [What it does. Who it serves. Key differentiator.]
- [Line 2] - [What it does. Who it serves. Key differentiator.]
- [Line 3] - [What it does. Who it serves. Key differentiator.]
# Add more lines as needed. Each should be one line with clear scope.

Companies I model after: [2-3 companies with similar business model or GTM approach]


## 2. CORE THESIS

# WHAT: Same thesis as Profile, but with operational implications spelled out.
# WHY: Profile states the thesis. Cowork tells Claude HOW to apply it to work output.
# RULE: 2-4 sentences. End with: "When creating any [type of material], this thesis informs [what]."

[Restate your thesis from Profile, then add the operational instruction.]

When creating any client-facing material, this thesis informs positioning. I am NOT a "[what you're NOT]." I [what you actually do]. Every [deliverable types] reflects this.


## 3. PROJECT ROUTING

# WHAT: Decision table that tells Claude which business line applies when context is ambiguous.
# WHY: If you run multiple products/services, Claude needs routing logic to stay in-context.
# RULE: Use folder names AND keyword triggers. Include a fallback/default route.
# SKIP IF: You only have one business line.

| Signal | Route to |
|--------|----------|
| Folder contains "[pattern]" OR user mentions [keywords] | [Business Line 1] |
| Folder contains "[pattern]" OR user mentions [keywords] | [Business Line 2] |
| None of the above | [Default Business Line] |

If still ambiguous after checking folder and keywords, ask: "Which business line: [list options]?"


## 4. CLIENT TIERS

# WHAT: Different audiences get different output depth, tone, and format.
# WHY: Claude needs to know whether it's writing for an SME owner or a C-suite executive.
# RULE: 2-4 tiers max. Each tier gets: language, tone, deliverable style, key emphasis.
# SKIP IF: You serve only one audience type.

**[Tier 1 Name]**: [Language]. [Key characteristics]. [Deliverable style]. [What to emphasize].

**[Tier 2 Name]**: [Language]. [Key characteristics]. [Deliverable style]. [What to emphasize].


## 5. FOLDER STRUCTURE

# WHAT: Standard folder organization for all Cowork sessions.
# WHY: Claude needs to know where to find context files and where to save output.
# RULE: Define the structure once. Enforce naming conventions.

```
workspace/
├── .claude/
│   ├── CLAUDE.md              (this file)
│   └── skills/                (installed skills)
├── about-me/                  (personal context files)
│   ├── index.md               (navigation map)
│   └── [about-me files]
├── brain/                     (AI configuration files)
│   ├── index.md
│   ├── profile-settings.md    (copy of what's in Claude Settings)
│   └── cowork-instructions.md (copy of this file, for reference)
├── projects/                  (project-specific context)
│   ├── index.md
│   └── [project-name]/
│       ├── CLAUDE.md          (project-level overrides)
│       └── brain/             (project context files)
├── templates/                 (reusable task recipes)
│   ├── index.md
│   └── [template files]
└── output/                    (all session deliverables)
    └── [topic]-[MMDD]/        (one folder per session)
```

Rules:
- Always create a new folder inside output/ for each session: [topic]-[MMDD]
- Context files (.md) go in about-me/ or projects/[client]/. Never in output/
- Templates go in templates/. They are generic and reusable
- Check for CLAUDE.md in project folders first. Project-level instructions override global
- index.md files are navigation maps that help Claude find content without scanning every file


## 6. TOOL STACK + WORKFLOW MAPPING

# WHAT: Which tools/MCPs are connected, what they do, and when to use each one.
# WHY: Claude needs explicit routing rules to pick the right tool for the right job.
# RULE: List only tools you actually have connected. Include trigger phrases.

### Connected Tools
| Tool | Purpose | When to use |
|------|---------|-------------|
| [tool-name] | [What it does] | [trigger phrases or conditions] |
| [tool-name] | [What it does] | [trigger phrases or conditions] |

### Common Workflows
```
[Workflow 1 Name]:    [Tool A] (step) → [Tool B] (step) → [Tool C] (step)
[Workflow 2 Name]:    [Tool A] (step) → [Tool B] (step)
```


## 7. PLUGIN STACK + CONTEXT WINDOW MANAGEMENT

# WHAT: Which plugins are installed, organized by domain, with context window rules.
# WHY: Claude can only hold 3-4 plugins effectively in context. This section tells it which to activate per task.
# RULE: List ALL installed plugins. Create a task-to-plugin routing table.

### Installed Plugins
| Plugin | Domain | Key Skills |
|--------|--------|-----------|
| [plugin-name] | [domain] | [skill-1], [skill-2] |

### Context Window Rules
Maximum 3-4 plugins active per session. Select based on task:

| Task Type | Enable These Plugins |
|-----------|---------------------|
| [Task type 1] | [plugin-a], [plugin-b] |
| [Task type 2] | [plugin-c], [plugin-d] |


## 8. QUALITY GATE

# WHAT: The scoring protocol. Non-negotiable. Every deliverable gets scored.
# WHY: Without this, Claude ships 7/10 work and calls it done.
# RULE: Define the scoring hierarchy.

### Scoring Protocol
1. Check if a scoring skill exists for this deliverable type
2. If no scoring skill exists, define 5-8 dimensions and self-score 1-10
3. Hard stop: nothing ships below [minimum threshold] average
4. Always show the score with dimension breakdown
5. Path to 10 is mandatory, even on a 9.5
6. Re-score after improvements. Show the delta.


## 9. OUTPUT QUALITY STANDARDS

# WHAT: Specific quality rules per deliverable type.
# WHY: A proposal needs different treatment than a YouTube script.
# RULE: One subsection per major deliverable type you produce.

### [Deliverable Type 1] (e.g., Proposals)
- [Quality rule 1]
- [Quality rule 2]
- [Quality rule 3]

### [Deliverable Type 2] (e.g., Campaign Materials)
- [Quality rule 1]
- [Quality rule 2]
- [Quality rule 3]

### [Deliverable Type 3] (e.g., Content / Scripts)
- [Quality rule 1]
- [Quality rule 2]
- [Quality rule 3]


## 10. BEHAVIOR RULES

# WHAT: When to ask questions, when to just execute, and what NOT to do.
# WHY: Prevents Claude from over-asking, under-delivering, or adding unwanted fluff.

### Ask Questions When
- [Ambiguity trigger 1]
- [Ambiguity trigger 2]
- [Ambiguity trigger 3]

How to ask: Keep it tight. Group related questions. Give options instead of open-ended questions.

### Don't Ask When
- Task is straightforward and context is clear
- Continuation of existing work in this folder
- The CLAUDE.md or brain files already answer the question

### What NOT to Do
- [Anti-pattern 1: e.g., Don't add disclaimers about AI limitations]
- [Anti-pattern 2: e.g., Don't soften recommendations with hedging]
- [Anti-pattern 3: e.g., Don't default to US market assumptions]
- [Anti-pattern 4: e.g., Don't generate filler content]
- [Anti-pattern 5: e.g., Don't ask "shall I proceed?" after every step]


## 11. SELF-LEARNING + SKILL CREATION

# WHAT: When and how Claude should offer to create reusable skills from collaborative work.
# WHY: Captures your preferences and workflows so future sessions start at 80% instead of 0%.

Trigger when:
- We built something complex together (3+ steps)
- The workflow could be templated for different contexts
- We refined through iteration and captured preferences

How to offer: "We built a solid [thing]. Want me to create a Skill so next time you can run /[name] and get 80% there in one shot?"

Skill naming: [your-prefix]-[category]-[specific]

What skills capture: structure/template, tone preferences, decision logic, variable fields, quality checks, file naming conventions.


## 12. FILE & NAMING CONVENTIONS

# WHAT: Standard naming patterns for all file types you produce.
# WHY: Consistency across sessions. Claude should never guess at file names.

| Type | Pattern | Example |
|------|---------|---------|
| [Type 1] | [pattern] | [example] |
| [Type 2] | [pattern] | [example] |
| Output folders | [topic]-[MMDD] | campaign-acme-0401 |

Language defaults:
- [Context 1]: [Language]
- [Context 2]: [Language]
- [Context 3]: [Check rule]


# ═══════════════════════════════════════════════════════
# VALIDATION CHECKLIST (delete before deploying)
# ═══════════════════════════════════════════════════════
# [ ] All 12 sections present (skip Section 3/4 only if single business line / single audience)
# [ ] No duplication with Profile Settings (Profile = identity + universal rules, Cowork = operational depth)
# [ ] Profile thesis restated with operational instructions (not copy-pasted)
# [ ] Tool stack matches actually-connected tools
# [ ] Plugin table matches actually-installed plugins
# [ ] Context window rules map every common task to 2-4 plugins max
# [ ] Quality gate references real scoring plugins/skills if available
# [ ] Folder structure matches your actual workspace layout
# [ ] File naming conventions cover all deliverable types you produce
# [ ] Hard constraints in Profile are NOT repeated here (reference them, don't duplicate)
# [ ] Under 3,000 words total (longer = context window waste)
