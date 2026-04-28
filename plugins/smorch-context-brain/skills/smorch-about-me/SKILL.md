<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: smorch-about-me
description: "About Me File Builder - creates structured personal context files for AI-assisted work. Supports 3 personas (Founder, Employee, Generic) with 4 input modes: raw text extraction, interactive Q&A, existing file gap-fill, and LinkedIn/CV upload parsing. Configurable language (English, Arabic, Bilingual). Triggers on: 'about me', 'build my about me', 'create about me files', 'personal context', 'who am I file', 'build my profile', 'context files', 'about me for AI', 'personal operating manual', 'user manual', 'tell AI about me'. Also triggers on: 'update my about me', 'fill gaps in my profile', 'parse my LinkedIn', 'extract from my resume'. Do NOT trigger for: EO scorecard ingestion (eo-brain-ingestion), project-level CLAUDE.md generation, or CRM contact creation."
---

# smorch-about-me: About Me File Builder

## PURPOSE

Build structured "About Me" files that give AI assistants deep context about the user. These files answer: "Who is this person, how do they work, what are they building, what constraints do they operate under, and WHY does it matter to them?"

Three personas produce different file sets:
- **Founder** (6 files): Background, Vision, Goals, Resources, Operating Style, Market
- **Employee** (5 files): Role, Operating Style, Tools & Systems, Priorities, Growth
- **Generic** (4 files): Background, Preferences, Goals, Audience & Distribution

## WHY THIS EXISTS (NOT JUST ANOTHER PROFILE TEMPLATE)

Generic profile templates capture biography. This skill captures **operating context**: the information AI needs to give you advice that fits your reality, your constraints, your market, and your decision-making patterns. Specifically:

- **Motivation layer:** Not just "what you're building" but "why it matters to you personally and what happens if you fail"
- **Anti-pattern layer:** Explicit instructions on what AI should NEVER suggest
- **Regional context:** Built for MENA-first founders where trust mechanics, WhatsApp-first communication, and Arabic credibility signals are structural, not cosmetic
- **Signal-based framing:** For founders using signal-based GTM, templates prompt for signal detection patterns, trust engineering approach, and ICP access methods

---

## PHASE 0: DETECT MODE

Before anything else, determine which input mode applies.

### MODE A: Raw Text Dump
**Trigger:** User pastes unstructured text (bio, LinkedIn text, resume content, brain dump)
**Detection:** Message contains substantial text (100+ characters) that reads like a profile, bio, self-description, or career narrative. Look for: job titles, company names, skill mentions, goal statements, industry references.
**Action:** Parse → Extract using EXTRACTION MAP → Map to persona template → Present extracted summary for user confirmation → Ask only for gaps

**Handling semi-structured input:** LinkedIn profiles often have line breaks, bullet points, and section headers. Treat these as structured raw text. Extract by section if possible (Experience, About, Skills, etc.).

### MODE B: Interactive Q&A
**Trigger:** User says "build my about me" or similar with no attached content, OR user explicitly requests interactive mode
**Detection:** Short request (<100 characters) with no raw input and no file upload
**Action:** Ask persona question first → Then walk through sections in rounds of 3-4 questions

### MODE C: Existing Files Update
**Trigger:** User has partial about-me files already in the workspace
**Detection:** Check workspace for files matching `my-*.md` pattern. If found, read them all.
**Action:** Read existing → Identify sections that are empty (template placeholders, code blocks with only examples), minimal (<2 sentences of real content), or outdated (last-updated date >90 days ago) → Ask only for missing data → Regenerate complete files preserving existing filled content

**Version handling:** If multiple versions exist (e.g., `my-old-background.md` and `my-background.md`), use the most recently modified file. Ask user to confirm if ambiguous.

### MODE D: LinkedIn/CV Upload
**Trigger:** User uploads a PDF, DOCX, or text file
**Detection:** File in /mnt/uploads/ referenced in conversation
**Action:** Read the file using appropriate parser (Read tool for text/md, python-docx for DOCX, pdf tools for PDF) → Extract text content → Apply MODE A logic on extracted text → Ask for gaps

**If file is unreadable:** Notify user: "I couldn't parse that file. Can you paste the text content directly, or tell me about yourself and I'll ask questions for the gaps?"

### MODE RESOLUTION

If multiple signals are present, apply this logic:

1. **User explicitly requests a mode?** → Use that mode. User intent always wins.
2. **File uploaded?** → MODE D (parse file, then apply MODE A extraction logic)
3. **Substantial text in message (100+ chars of profile-like content)?** → MODE A
4. **Existing my-*.md files in workspace?** → MODE C (read, identify gaps, ask only for missing)
5. **None of the above?** → MODE B (interactive Q&A)

**If unclear:** Ask the user: "I can work with you three ways: (1) You paste text about yourself and I'll organize it, (2) I ask you questions section by section, (3) I read your existing files and fill gaps. Which works best?"

---

## PHASE 1: PERSONA SELECTION

Ask the user which persona fits them. Skip if obvious from context (e.g., user mentions "my company" = Founder, "my manager" = Employee).

**Question:** "Which best describes your situation?"
- **Founder/CEO** - Building or running your own business. You set the vision, make strategic decisions, and need AI to understand your thesis and market. *(6 files)*
- **Employee/Team Member** - Working within an organization. You need AI to understand your role, ownership areas, decision rights, and collaboration map. *(5 files)*
- **Generic/Individual** - Freelancer, creator, student, consultant, or personal use. You want AI to understand how you think, what you value, and how you prefer to work. *(4 files)*

---

## PHASE 2: LANGUAGE CONFIGURATION

**Question:** "What language for your About Me files?"
- **Bilingual (English + Gulf Arabic)** - Each section has both languages. Best for MENA founders and teams.
- **English only** - Clean, single-language output.
- **Arabic only** - Gulf Arabic throughout with English tech terms where natural.

Default: Bilingual for MENA-based users, English for others. If user's name or context suggests MENA origin, default to bilingual.

**Bilingual format rule:** Section headers and instructions are bilingual. Tables use single-language column headers (English) with bilingual row labels only where it aids comprehension. This prevents cluttered, unreadable tables.

---

## PHASE 3: DATA COLLECTION

### For MODE A (Raw Text) or MODE D (Upload):

1. Parse the input text/document
2. Extract all identifiable data points using the EXTRACTION MAP below
3. Map each data point to the appropriate file and section
4. **Present extraction summary** to user: "Here's what I extracted. Confirm this is accurate, then I'll ask about the gaps."
5. Identify gaps: sections with no mapped data
6. Ask gap-fill questions in rounds of 3-4, maximum 3 rounds
7. If user stops answering or says "that's enough," generate files with available data and mark remaining sections as gaps
8. Generate files

### For MODE B (Interactive Q&A):

Ask questions in rounds. Each round = 3-4 questions grouped by theme. Maximum 5 rounds total. Use AskUserQuestion tool with multiple-choice where possible to reduce friction.

**FOUNDER Q&A SEQUENCE:**

Round 1 - Identity & Business Lines:
- Q1: "What business lines are you running or building? For each: name, what it does, stage (idea/building/live/scaling), primary market."
- Q2: "Which one is your primary focus right now? Why that one?"
- Q3: "Career history in 3-5 bullet points. Focus on what gives you credibility in the market you're targeting. Example: '20 years B2B SaaS enterprise tech in MENA (Cisco, Avaya, Uniphore). Closed 200+ enterprise deals in the Gulf. Built and sold signal-based outbound systems.'"

Round 2 - Thesis & Motivation:
- Q4: "What's your contrarian belief about your market that most people get wrong? The insight that drives everything you build. Example: 'Relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement.'"
- Q5: "Why does building this matter to you personally? What happens in your life if you succeed? What happens if you fail? Be specific."
- Q6: "What have you tried before in this space that didn't work? What did you learn from it?"

Round 3 - Market & GTM:
- Q7: "Your ICP in one sentence. How do you access them? What signals tell you they're ready to buy?"
- Q8: "What's your GTM approach? Not theory: what channels are you using, what's working, what's not? How do you build trust with buyers in your market?"
- Q9: "What do you know about your market that outsiders don't? What cultural, regional, or industry dynamics shape how your buyers decide?"

Round 4 - Goals & Resources:
- Q10: "What does success look like in 6 months? Specific: revenue number, customer count, product state. What's the minimum outcome worth your time?"
- Q11: "Time available per week, monthly budget, runway in months, and current tool stack."
- Q12: "Who can help you? Not who you wish you had. Who you actually have access to right now."

Round 5 - Operating Style:
- Q13: "How should AI work with you? When should it challenge your thinking vs. just execute what you ask?"
- Q14: "Communication style: what tone, what format, what level of detail? What words, phrases, or approaches make you cringe? Example: 'Never use leverage, synergy, ecosystem, digital transformation. No corporate softening. Lead with impact, not methodology.'"
- Q15: "How do you make decisions? Fast on 70% confidence, or deliberate with full data? What decisions do you make alone vs. need input on?"

**EMPLOYEE Q&A SEQUENCE:**

Round 1 - Role & Ownership:
- Q1: "Your role title and one-sentence mission. What exists because you do your job well?"
- Q2: "Ownership map: What do you own entirely? What do you share? What do you influence but don't decide?"
- Q3: "Decision rights: what can you decide alone, what needs manager approval, what needs team consensus? What's your 'just do it' threshold?"

Round 2 - Operating & Collaboration:
- Q4: "Who's your manager? What do they care about most? How do they prefer to receive updates? Reporting cadence?"
- Q5: "Key cross-functional partners you work with regularly. Who depends on your output (and when do they need it)? Who do you depend on?"
- Q6: "Communication style: how do you prefer feedback (direct/wrapped/written/verbal)? Deep work blocks? Meeting preferences?"

Round 3 - Tools & Priorities:
- Q7: "Tools you use daily. For each: what it's for and whether it's your source of truth for that information type."
- Q8: "Current top 3 priorities this quarter. What metrics define success for each? If you could only work on ONE thing this week, which one?"
- Q9: "What's the biggest blocker preventing you from shipping your top priority? Who or what would unblock it?"

Round 4 - Growth & Anti-Patterns:
- Q10: "Strongest skills (what people come to you for) and areas you're actively developing."
- Q11: "Career goal in 1-3 years. What's the biggest gap between where you are and where you want to be?"
- Q12: "What should AI NEVER suggest for your role? Example: 'Don't suggest I bypass my manager,' 'Don't suggest I take on work outside my ownership area,' 'Don't suggest I focus on career advancement over team delivery.'"

**GENERIC Q&A SEQUENCE:**

Round 1 - Who You Are:
- Q1: "What do you do? Primary occupation, what you're working on now, and what you're known for."
- Q2: "What do you know deeply? Areas where you're genuinely expert, not just interested."
- Q3: "Skills you're strong at, skills you're learning, skills you lack and need help with."

Round 2 - How You Work:
- Q4: "How should AI communicate with you? Tone, format, level of detail, language. What approaches waste your time?"
- Q5: "What are you trying to achieve in the next 6 months? Be specific. When do you need results: ASAP, 3 months, 6 months, no deadline?"
- Q6: "Constraints: time available per week, budget, non-negotiables, things you refuse to do."

Round 3 - Audience & Distribution:
- Q7: "Who do you serve or sell to? Clients, audience, community, employer. How do you reach them?"
- Q8: "What platforms or channels do you use to find work, build reputation, or distribute content? Followers/subscribers/list size if relevant."
- Q9: "What's your income model? (Employment, freelance, product, consulting, content, mixed) How stable is it?"

### For MODE C (Existing Files Update):

1. Read all `my-*.md` files in workspace
2. For each file, identify sections that are:
   - **Empty:** Template placeholder still there (code blocks with only example text, unfilled tables, `[Your answer here]` markers)
   - **Minimal:** Less than 2 sentences of real content (not counting examples or instructions)
   - **Outdated:** Last-updated date >90 days ago, or content references past dates/goals
3. Present gap summary to user: "I read your existing files. Here's what's filled vs. what's missing: [summary]. Want me to ask questions for the gaps?"
4. Group missing sections into themed rounds (max 3 rounds)
5. Ask gap-fill questions for missing data only
6. Regenerate complete files, preserving all existing filled content verbatim

---

## PHASE 4: FILE GENERATION

### OUTPUT STRUCTURE BY PERSONA

**FOUNDER (6 files):**

```
about-me/
  my-background.md      - Career, skills, founder-market fit, network, weaknesses
  my-vision.md          - Core thesis, business lines, content DNA, strategic direction
  my-goals.md           - Success definition, revenue, timeline, motivation, accountability
  my-resources.md       - Time, money, tools, people, existing assets
  my-operating-style.md - Communication, decisions, operating modes, personality, anti-patterns
  my-market.md          - ICP, competitive landscape, regional context, GTM approach, trust mechanics
```

**EMPLOYEE (5 files):**

```
about-me/
  my-role.md              - Role mission, ownership map, decision rights, escalation, success metrics
  my-operating-style.md   - Communication, work rhythm, collaboration map, personality, anti-patterns
  my-tools-and-systems.md - Tool stack, data sources, dashboards, where truth lives
  my-priorities.md        - Current projects, blockers, quarterly goals, weekly focus
  my-growth.md            - Skills inventory, career goals, learning focus, growth areas
```

**GENERIC (4 files):**

```
about-me/
  my-background.md       - Who I am, what I do, skills, deep knowledge areas
  my-preferences.md      - Communication style, how I work, what I value, constraints
  my-goals.md            - What I'm working toward, timeline, resources available
  my-audience.md         - Who I serve/sell to, platforms, distribution, income model
```

### FILE FORMAT RULES

1. **Header format:** `# File Title | Arabic Translation` (if bilingual)
2. **Intro quote:** One sentence explaining why this file matters for AI context, in both languages if bilingual
3. **Section numbering:** `## 1. Section Name | Arabic Name`
4. **Filled content:** Replace template placeholders with actual user data. Bold key facts. Write in first person.
5. **Unfilled sections:** Mark with `<!-- GAP: [section name] - not yet filled -->` AND add a visible note: `> ⚠️ This section needs input. Run smorch-about-me to fill it.`
6. **Self-check:** Every file ends with a self-check checklist, items checked for filled sections
7. **Metadata footer:** Every file ends with `---\n*Last updated: [actual date] | Review: quarterly | Persona: [Founder/Employee/Generic]*`
8. **AI reading instruction:** First line after the header quote: `<!-- AI: Skip sections marked as GAP. Only use filled content for context. -->`

### BILINGUAL FORMAT

When bilingual is selected:
- Section headers: bilingual on the same line (`## 1. Section Title | العنوان`)
- Instructions/questions: English line, then Arabic line below
- Tables: English column headers only (bilingual headers create unreadable tables)
- Content: English paragraph, then Arabic paragraph
- Arabic tone: Conversational Gulf Arabic. Not MSA formal. English tech terms mixed naturally (MRR, GTM, ICP, CRM stay in English)

### CONTENT RULES (ZERO FABRICATION)

- **NEVER infer or fabricate** content the user didn't provide. If you're not sure, mark it as a gap.
- **DO rephrase** user input for clarity, consistency, and AI-readability.
- **DO add structure** (tables, bullet points) to organize unstructured user input.
- **DO NOT fill** optional sections with generic advice. Leave them as gaps.
- When user gives aspirational answers that conflict with their stated constraints (e.g., "40 hours/week" but "side project"), flag the conflict: "You mentioned this is a side project but also said 40 hours/week. Which is accurate?"

---

## PHASE 5: QUALITY GATE

Before delivering files, score across these 5 dimensions. Each dimension 1-10. **Minimum 8.0 average to deliver.**

### D1: COMPLETENESS (1-10)
- All files for the persona are generated
- No empty sections (either filled with real content or explicitly marked as GAP with visible warning)
- Self-check section present in every file
- Metadata footer with actual date present in every file
- **Score 10:** Every section either has real user content or is clearly marked as a gap with context on why it matters

### D2: ACCURACY (1-10)
- Every filled section traces back to user input (zero fabrication)
- No aspirational inflation: if user said "$500/month budget," file says $500, not "$500-1000"
- Conflicting information was flagged and resolved, not silently chosen
- **Score 10:** A user reading their files says "yes, this is exactly right" for every filled section

### D3: AI CONTEXT VALUE (1-10)
- A new AI assistant reading only these files (no conversation history) would understand who this person is
- Decision rights and operating modes are clear enough for AI to know when to ask vs. act
- Communication preferences are specific enough for AI to match tone and format
- Anti-patterns are explicit: AI knows what to NEVER do
- Motivation is captured: AI understands WHY this person is doing this, not just WHAT
- **Score 10:** AI can personalize all work (proposals, emails, strategies, code) from these files alone

### D4: USABILITY (1-10)
- A non-technical person can understand every question and fill every section
- Examples are concrete and show the depth expected (not abstract placeholders)
- Language matches user's selection and feels natural
- File structure is logical: you can find any section in <10 seconds
- **Score 10:** A first-time user with no instructions can fill these files correctly

### D5: ACTIONABILITY (1-10)
- Files contain enough specificity for AI to take action (not just understand)
- ICP is specific enough to find on LinkedIn (Founder/Generic)
- Metrics have numbers, not just descriptions (Employee)
- GTM approach describes what's actually happening, not aspirations
- **Score 10:** AI can generate a first-draft campaign, email, proposal, or plan from these files without asking follow-up questions

### SCORING PROCESS
After generating all files, mentally score each dimension. If average <8.0:
1. Identify the weakest dimension
2. Ask 1-2 targeted questions to strengthen it
3. Regenerate only the affected file(s)
4. Re-score

---

## PHASE 6: DELIVERY

1. Write all files to the output directory (the workspace folder the user selected, in an `about-me/` subdirectory)
2. Present a summary table:

```
| File | Sections Filled | Gaps Remaining | Quality |
|------|----------------|----------------|---------|
| my-background.md | 5/5 | 0 | ✅ |
| my-vision.md | 3/4 | Strategic Direction | ⚠️ |
```

3. Recommend next step based on gaps:
   - If >3 gaps: "Your files are a good start. Fill the gaps marked with ⚠️ to get full AI context value."
   - If 1-3 gaps: "Almost complete. The key gap is [X] because [why it matters for AI]."
   - If 0 gaps: "Your About Me is complete. Any AI reading these files will understand who you are."
4. Offer: "Want me to generate a CLAUDE.md instruction file from your About Me? This converts your context into direct AI operating instructions."
5. Offer: "Want me to create a one-paragraph summary you can paste into any AI chat as a system prompt?"

---

## EXTRACTION MAP

Maps raw input data points to output files. When parsing raw text, scan for ALL signals below. Multiple signals can map to the same section (merge them).

### Founder Extraction Map
| Input Signal | Target File | Target Section |
|---|---|---|
| Job titles, companies, years of experience | my-background.md | Professional Background |
| Technical skills, tools mentioned, certifications | my-background.md | Technical Skills |
| Industry expertise, domain knowledge claims | my-background.md | Founder-Market Fit |
| Social media followers, communities, groups | my-background.md | Network & Distribution |
| Self-identified weaknesses, gaps, "I'm not good at" | my-background.md | What You're NOT Good At |
| Mission statement, beliefs, thesis, contrarian views | my-vision.md | Core Thesis |
| Company/product descriptions, business entities | my-vision.md | Business Lines |
| Content style, voice, tone examples, frameworks taught | my-vision.md | Content & Messaging DNA |
| Long-term direction, 3-5 year vision, "we're heading toward" | my-vision.md | Strategic Direction |
| Words to never use, pet peeves, "I hate when" | my-vision.md | Content DNA (Anti-Words) |
| Revenue targets, customer goals, MRR, ARR | my-goals.md | Revenue Target |
| Timelines, milestones, launch dates, "by Q3" | my-goals.md | Timeline |
| Success/failure definitions, kill criteria | my-goals.md | Definition of Success |
| Personal motivations, "why I'm doing this," life goals | my-goals.md | Motivation & Personal Goals |
| Constraints, non-negotiables, "I won't do X" | my-goals.md | Constraints |
| Previous failures, "tried X and it didn't work" | my-goals.md | Lessons from Past Attempts |
| Hours available, schedule, "I work mornings" | my-resources.md | Time Budget |
| Budget, burn rate, runway, monthly spend | my-resources.md | Money Budget |
| Revenue model: subscription, one-time, freemium, consulting | my-resources.md | Revenue Model |
| Current tools, subscriptions, "I use GHL" | my-resources.md | Tools You Already Have |
| Team, contractors, helpers, co-founders | my-resources.md | People Resources |
| Email lists, audiences, assets, "I have 5K subscribers" | my-resources.md | Existing Assets |
| Communication preferences, "I prefer direct" | my-operating-style.md | Communication Preferences |
| Decision-making style, speed, risk tolerance | my-operating-style.md | Decision Patterns |
| When to challenge vs. execute, "push back when" | my-operating-style.md | Operating Modes |
| DISC/MBTI/Enneagram results | my-operating-style.md | Personality Framework |
| Stress patterns, burnout signals, "when I'm overwhelmed I" | my-operating-style.md | Stress Patterns |
| Words to avoid, anti-patterns for AI behavior | my-operating-style.md | Anti-Patterns |
| Target customer description, "we sell to" | my-market.md | ICP Definition |
| Competitors mentioned, "competing with X" | my-market.md | Competitive Landscape |
| Regional/cultural context, MENA dynamics, Arabic credibility | my-market.md | Regional Context |
| Sales cycle length, "deals take 2-4 weeks" | my-market.md | Sales Cycle |
| Trust mechanics, "buyers expect face-to-face" | my-market.md | Trust & Buying Dynamics |
| WhatsApp vs. email preferences, channel effectiveness | my-market.md | Channel Effectiveness |
| Sales/marketing approach, outbound methods | my-market.md | GTM Approach |
| Signal detection patterns, intent signals tracked | my-market.md | Signal Sources |

### Employee Extraction Map
| Input Signal | Target File | Target Section |
|---|---|---|
| Job title, department, team, org level | my-role.md | Role Title & Mission |
| Responsibilities, ownership, "I own X" | my-role.md | Ownership Map |
| Decision authority, approvals, "I can decide" | my-role.md | Decision Rights |
| KPIs, targets, metrics, OKRs | my-role.md | Success Metrics |
| Manager info, reporting, escalation paths | my-role.md | Escalation Rules |
| Who consumes your output, downstream dependencies | my-role.md | Downstream Impact |
| Communication style, feedback preferences | my-operating-style.md | Communication Preferences |
| Work schedule, deep work times, meeting patterns | my-operating-style.md | Work Rhythm |
| Cross-functional partners, collaborators | my-operating-style.md | Collaboration Map |
| Personality assessments, type results | my-operating-style.md | Personality Framework |
| Stress patterns, "when overloaded I" | my-operating-style.md | Stress Patterns |
| Anti-patterns, "AI should never suggest" | my-operating-style.md | Anti-Patterns |
| Org politics, real vs. stated authority | my-operating-style.md | Organizational Reality |
| Software, platforms, dashboards used | my-tools-and-systems.md | Tool Stack |
| Data sources, authoritative systems | my-tools-and-systems.md | Where Truth Lives |
| Current projects, initiatives, sprints | my-priorities.md | Current Projects |
| Quarterly goals, OKRs, targets | my-priorities.md | This Quarter |
| Blockers, resource gaps, dependencies | my-priorities.md | Blockers |
| Strong skills, expertise, "people come to me for" | my-growth.md | Skills Inventory |
| Development goals, learning focus | my-growth.md | Growth Areas |
| Career aspirations, "I want to become" | my-growth.md | Career Goals |

### Generic Extraction Map
| Input Signal | Target File | Target Section |
|---|---|---|
| Occupation, identity, self-description | my-background.md | Who I Am |
| Current projects/focus, "working on" | my-background.md | What I Do |
| Skills, expertise areas, certifications | my-background.md | Skills & Knowledge |
| Communication preferences, tone, format | my-preferences.md | Communication Style |
| Work habits, schedule, productive hours | my-preferences.md | How I Work |
| Values, non-negotiables, principles | my-preferences.md | What I Value |
| Decision-making style, "I decide by" | my-preferences.md | Decision Style |
| Time/budget constraints, limitations | my-preferences.md | Constraints |
| Anti-patterns, "don't give me generic" | my-preferences.md | Anti-Patterns |
| Goals, targets, outcomes sought | my-goals.md | What I'm Building Toward |
| Timeline, milestones, urgency level | my-goals.md | Timeline |
| Available resources, budget, tools | my-goals.md | Resources |
| Motivation, "why this matters" | my-goals.md | Why This Matters |
| Clients, audience, community served | my-audience.md | Who I Serve |
| Platforms, channels, distribution methods | my-audience.md | Platforms & Channels |
| Income model, revenue sources | my-audience.md | Income Model |
| Followers, subscribers, list size | my-audience.md | Audience Size |

---

## ERROR HANDLING

| Error | Response |
|---|---|
| User provides very little input (<50 words) | Ask 3 essential questions: "Who are you?", "What are you building/doing?", "What do you need AI to help with?" Then proceed with MODE B. |
| User refuses to answer personal questions | Respect. Generate files with available data. Mark gaps. No pressure. Say: "No problem. I'll work with what you've shared. You can fill gaps anytime." |
| Uploaded file is unreadable/corrupted | Notify user: "I couldn't read that file. Can you paste the text directly?" Fall back to MODE A or MODE B. |
| Conflicting information in input | Flag the conflict explicitly: "You mentioned [X] but also said [Y]. Which is accurate?" Don't guess or silently pick one. |
| User wants to update one file only | Read that file, ask about empty/outdated sections only, regenerate only that file. Don't touch other files. |
| User gives aspirational answers conflicting with stated constraints | Flag it: "You said [40 hours/week] but also [side project with day job]. These seem to conflict. What's the realistic number?" |
| User pastes competitor info instead of their own | Detect non-self-referential text. Ask: "This reads like it's about another company/person. Is this your competitor? Or is this your own profile?" |
| User is from non-MENA region | Skip MENA-specific regional context questions. Replace with generic "What's different about your market?" Still include the section but with the user's actual regional context. |
| User stops responding mid-flow | After 2 unanswered rounds, generate files with what you have. Mark remaining sections as gaps. Don't push. |
| User provides information that fits a different persona | Suggest persona switch: "Based on what you're describing, the Employee profile might fit better than Founder. Want to switch?" |

---

## DOWNSTREAM INTEGRATION

About Me files feed into other skills:
- **eo-brain-ingestion:** Can use About Me as supplementary founder context alongside scorecards
- **signal-to-trust-gtm:** Reads my-market.md and my-vision.md for campaign alignment, ICP targeting, and wedge generation
- **smo-offer-assets:** Uses my-vision.md for positioning and brand voice in decks and landing pages
- **asset-factory:** Reads my-operating-style.md for anti-patterns and communication DNA when generating campaign copy
- **Any skill:** Can reference my-operating-style.md for communication preferences, anti-patterns, and operating modes

When generating files, remind user: "These files work as standalone context. Any AI tool that reads them will understand who you are and how to work with you. Paste the content into any AI chat, or point skills to these files for automatic personalization."
