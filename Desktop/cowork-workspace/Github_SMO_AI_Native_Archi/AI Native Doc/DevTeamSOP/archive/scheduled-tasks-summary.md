# SMOrchestra.ai Scheduled Tasks: Operations Playbook

**Version:** 2.0
**Generated:** March 26, 2026
**Total Active Tasks:** 9 (6 deployed + 3 new)
**Quality Target:** Every task is self-contained and replicable by any team member with a Claude setup + the correct MCPs enabled.

---

## How to Use This Document

Each task below contains:

1. **Metadata**: schedule, dependencies, tools required
2. **Full Prompt Template**: copy-paste into a Claude scheduled task and it runs autonomously
3. **Success Criteria**: how to know the output is good
4. **Error Handling**: what to do when things break
5. **Quality Gate**: self-scoring rubric

**Gulf Business Week Awareness:** All tasks respect Sun-Thu as the MENA work week. Friday/Saturday tasks are intelligence-gathering (no client-facing outputs). Sunday tasks prep the week ahead.

---

## Weekly Cadence Overview

| Day | Time | Task # | Task Name | Category | Feeds Into |
|-----|------|--------|-----------|----------|------------|
| Daily | 08:06 | 1 | Plugin Drift Audit | Ops | All tasks (skill integrity) |
| Friday | 11:06 | 2 | YouTube Content Intelligence | Content Intel | Task 3 (Repurpose) |
| Friday | 11:35 | 3 | YouTube Repurpose Engine | Content Production | LinkedIn posts, YouTube scripts |
| Saturday | 10:05 | 4 | LinkedIn Content Intelligence | Content Intel | LinkedIn posts, outreach timing |
| Sunday | 09:00 | 5 | Sales Navigator ICP Search | Lead Gen | Task 9 (Campaign Summary), HeyReach/Instantly |
| Sunday | 14:00 | 8 | Linear Project Summary | Project Ops | Monday standup, stakeholder updates |
| Sunday | 22:09 | 6 | Competitive Intelligence Sweep | Strategy | Wedge generation, positioning |
| Monday | 08:00 | 9 | Campaign Summary & Audit | GTM Ops | Weekly review, campaign optimization |
| 1st of Month | 09:00 | 7 | API Documentation Refresh | Tech Ops | Operator skill maintenance |

---

## Task 1: Daily Plugin Drift Audit

**Task ID:** `smorch-daily-audit`
**Schedule:** Every day at 08:06 AM
**Category:** Operations
**Tools Required:** File system access (Read, Glob, Grep)
**Skills Referenced:** None (pure file comparison)
**Feeds Into:** All other tasks (ensures skill integrity before they run)

### Success Criteria
- Every deployed plugin skill matches its source definition
- Drift detected = specific file path + diff summary
- Zero false positives (cosmetic whitespace changes excluded)

### Full Prompt Template

```
OBJECTIVE: Compare smorch-brain plugin source files against deployed Cowork plugin files. Flag any drift.

STEP 1 — DISCOVER SOURCE FILES
Scan /mnt/.claude/skills/ and /mnt/.remote-plugins/ for all SKILL.md files.
Build a manifest: {skill_name, source_path, last_modified_date, file_hash}

STEP 2 — DISCOVER DEPLOYED FILES
Scan /mnt/.local-plugins/cache/ for all deployed skill files.
Build a matching manifest: {skill_name, deployed_path, last_modified_date, file_hash}

STEP 3 — COMPARE
For each skill in source manifest:
- Find matching deployed file by skill_name
- Compare file hashes
- If different: extract the diff (first 50 lines max)
- If source exists but no deployed version: flag as MISSING DEPLOYMENT
- If deployed exists but no source: flag as ORPHAN (deployed without source)

STEP 4 — REPORT
Generate a structured report:

DRIFT AUDIT REPORT — [DATE]
Total skills scanned: [N]
Matching (no drift): [N]
Drifted: [N] (list each with file path + summary of changes)
Missing deployments: [N]
Orphaned deployments: [N]

STEP 5 — QUALITY GATE
Self-score this audit:
- Did I scan ALL plugin directories? (Y/N)
- Did I exclude whitespace-only changes? (Y/N)
- Is the report actionable (someone can fix each drift item)? (Y/N)
If any N: re-run the failed step before saving.

Save report to: /mnt/SOP/audits/drift-audit-[YYYY-MM-DD].md
```

### Error Handling
- If a plugin directory doesn't exist: log as WARNING, continue scanning other directories
- If file permissions block reading: log as ERROR with specific path, continue
- If report file can't be saved: output to console as fallback

---

## Task 2: YouTube Content Intelligence Monitor

**Task ID:** `youtube-creator-monitor`
**Schedule:** Every Friday at 11:06 AM
**Category:** Content Intelligence
**Tools Required:** WebSearch, WebFetch
**Skills Referenced:** None (pure research task)
**Feeds Into:** Task 3 (YouTube Repurpose Engine, runs 30 min later)

### Success Criteria
- Each target creator checked for new videos in last 7 days
- New content catalogued with: title, topic category, engagement metrics, key takeaways
- Positioning shifts flagged with specific evidence
- Content gaps identified (topics they haven't covered that we can)

### Target Creators
1. [CREATOR 1 NAME] — YouTube URL: [URL] — Why we track: [reason]
2. [CREATOR 2 NAME] — YouTube URL: [URL] — Why we track: [reason]
3. [CREATOR 3 NAME] — YouTube URL: [URL] — Why we track: [reason]

*Replace the placeholders above with your actual tracked creators.*

### Full Prompt Template

```
OBJECTIVE: Weekly intelligence scan of 3 target YouTube creators. Detect new content, extract positioning signals, identify content gaps for Mamoun's channel.

STEP 1 — NEW CONTENT SCAN
For each target creator:
- Search YouTube for their channel's latest uploads (last 7 days)
- For each new video, extract:
  - Title
  - Published date
  - View count (approximate)
  - Duration
  - Topic category: AI Automation | GTM/Sales | MENA Business | MicroSaaS | Personal Brand | Other
  - 3-sentence summary of the core argument
  - Key frameworks or methodologies introduced

STEP 2 — POSITIONING ANALYSIS
For each creator, compare this week vs last 4 weeks:
- Topic shift? (e.g., moved from AI tools to business strategy)
- Audience shift? (e.g., targeting beginners vs advanced)
- Monetization shift? (e.g., new course, consulting offer, affiliate)
- Production quality change? (e.g., new format, shorter videos, more editing)

STEP 3 — CONTENT GAP IDENTIFICATION
Compare their coverage against Mamoun's content thesis (AI as equalizer for MENA entrepreneurs, signal-based GTM, MicroSaaS movement):
- Topics they covered that Mamoun hasn't → OPPORTUNITY (with contrarian angle)
- Topics Mamoun covers that they don't → MOAT (keep building depth)
- Overlapping topics → DIFFERENTIATION NEEDED (what's Mamoun's unique angle?)

STEP 4 — SIGNAL EXTRACTION FOR REPURPOSE
Flag any content that could be repurposed as:
- LinkedIn post (English or Arabic)
- Counter-argument video ("They said X, here's why that fails in MENA")
- Training module content for EO

STEP 5 — OUTPUT FORMAT
Save as: /mnt/SOP/intel/youtube-intel-[YYYY-MM-DD].md

Structure:
## YouTube Content Intelligence — Week of [DATE]

### Creator 1: [NAME]
New Videos: [count]
[For each video: title, date, views, topic, summary, positioning signal]

### Creator 2: [NAME]
[Same structure]

### Creator 3: [NAME]
[Same structure]

### Content Gaps & Opportunities
[Bulleted list with priority: HIGH/MEDIUM/LOW]

### Repurpose Queue
[Specific ideas with target channel and format]

STEP 6 — QUALITY GATE
Self-score:
- All 3 creators checked? (Y/N)
- At least 1 content gap identified? (Y/N)
- At least 1 repurpose idea generated? (Y/N)
- Report is under 1500 words (concise, not padded)? (Y/N)
If any N: fix before saving.
```

### Error Handling
- If a creator hasn't posted in 7 days: note "No new content" and analyze their last 3 videos for trend context
- If WebSearch returns no results: try alternative search queries (channel name + "latest" + current month)
- If a video is region-blocked: note it and move on

---

## Task 3: YouTube Repurpose Engine

**Task ID:** `youtube-repurpose`
**Schedule:** Every Friday at 11:35 AM (30 min after Task 2)
**Category:** Content Production
**Tools Required:** File system (Read), WebSearch
**Skills Referenced:** `mamoun-personal-branding:content-systems`, `mamoun-personal-branding:linkedin-ar-creator`, `mamoun-personal-branding:linkedin-en-gtm`
**Depends On:** Task 2 output (youtube-intel-[DATE].md)
**Feeds Into:** LinkedIn content calendar, YouTube script ideas

### Success Criteria
- Reads Task 2 output successfully
- Generates at least 2 repurpose ideas with full draft outlines
- Each idea tagged with platform (LinkedIn AR, LinkedIn EN, YouTube, EO Training)
- Contrarian angle present in every piece (not generic AI commentary)

### Full Prompt Template

```
OBJECTIVE: Read this week's YouTube intelligence report and generate repurposable content drafts for Mamoun's channels.

STEP 1 — LOAD INTELLIGENCE
Read: /mnt/SOP/intel/youtube-intel-[TODAY's DATE].md
If file not found, check yesterday's date. If still not found: STOP and report "Task 2 output missing — cannot repurpose without intelligence."

STEP 2 — PRIORITIZE REPURPOSE OPPORTUNITIES
From the Repurpose Queue in the intelligence report:
- Rank by: (1) contrarian potential, (2) MENA relevance, (3) timeliness
- Select top 3 ideas

STEP 3 — GENERATE DRAFTS
For each selected idea, produce:

A) If LinkedIn English (Track B, Tue/Thu):
- Hook line (pattern interrupt, <15 words)
- Core argument (3-5 paragraphs, teach a framework)
- CTA (low friction: comment, DM, or link to resource)
- Word count target: 150-250 words

B) If LinkedIn Arabic (Track A, Sun/Mon):
- Hook in Gulf Arabic (conversational, not MSA)
- Mix English tech terms naturally
- CTA appropriate for Arabic audience
- Word count target: 100-200 words

C) If YouTube video idea:
- Title (curiosity-driven, <60 chars)
- Thumbnail concept (text overlay + visual)
- 3-bullet outline of key points
- Estimated length: 8-15 min

STEP 4 — CONTRARIAN CHECK
For each draft, verify:
- Does this sound like every other AI consultant? If yes, KILL IT and rewrite
- Is there a specific number, framework, or MENA example? If no, ADD ONE
- Would Mamoun's ICP (B2B SaaS leaders in Gulf) care? If unsure, SKIP

STEP 5 — OUTPUT
Save as: /mnt/SOP/content/repurpose-drafts-[YYYY-MM-DD].md

STEP 6 — QUALITY GATE
Self-score:
- At least 2 drafts produced? (Y/N)
- Every draft has a contrarian angle? (Y/N)
- No generic "AI is changing everything" filler? (Y/N)
- Drafts are platform-appropriate (length, tone, format)? (Y/N)
```

### Error Handling
- If Task 2 output is missing: generate 2 evergreen repurpose ideas from Mamoun's core thesis instead
- If all competitor content is irrelevant to MENA: pivot to "MENA-specific gap" content (what they're NOT saying)

---

## Task 4: LinkedIn Content Intelligence Monitor

**Task ID:** `linkedin-content-intelligence-monitor`
**Schedule:** Every Saturday at 10:05 AM
**Category:** Content Intelligence
**Tools Required:** WebSearch, WebFetch
**Skills Referenced:** `smorch-gtm-engine:smorch-linkedin-intel`
**Feeds Into:** LinkedIn content calendar, outreach timing, wedge generation

### Success Criteria
- 10+ target profiles scanned for new posts (last 7 days)
- Content signals categorized: topic, engagement level, sentiment
- At least 3 outreach timing signals detected (prospect posted about pain point = warm window)
- Competitor positioning shifts flagged

### Full Prompt Template

```
OBJECTIVE: Scan LinkedIn content signals from target ICP profiles, competitors, and industry voices. Extract signals for content strategy and outreach timing.

STEP 1 — DEFINE SCAN TARGETS (customize these lists)

ICP PROFILES (prospects showing intent):
- [List 5-10 target prospect LinkedIn URLs or names]
- Focus: VP Sales, CRO, Founders at Gulf SaaS companies

COMPETITOR PROFILES:
- ColdIQ team members
- FullFunnel.co team members
- SalesCaptain.io team members
- [Add other competitors]

INDUSTRY VOICES:
- [List 3-5 thought leaders in B2B GTM / AI automation space]

STEP 2 — CONTENT SIGNAL EXTRACTION
For each profile with new posts (last 7 days):
- Post topic and core message
- Engagement metrics (likes, comments, reposts — approximate)
- Sentiment: positive/negative/neutral + specific pain points mentioned
- Signal classification:
  - OUTREACH SIGNAL: prospect posted about a problem we solve → flag for immediate personalized outreach
  - CONTENT SIGNAL: topic trending in our ICP → create content responding to it
  - COMPETITIVE SIGNAL: competitor shared a positioning claim → evaluate and counter
  - TRUST SIGNAL: prospect engaged with our content or similar content → warm lead

STEP 3 — OUTREACH TIMING WINDOWS
Flag any prospect who:
- Posted about pain points matching our solutions (within 48 hours = HOT window)
- Commented on competitor content (within 72 hours = WARM window)
- Shared a job posting for roles we replace/augment (within 1 week = INTENT signal)
- Changed jobs in last 30 days (CHANGE signal)

STEP 4 — CONTENT INSPIRATION
From all signals, generate:
- 2 reactive content ideas (respond to what's trending this week)
- 1 contrarian take (challenge a popular post's premise)

STEP 5 — OUTPUT
Save as: /mnt/SOP/intel/linkedin-intel-[YYYY-MM-DD].md

Structure:
## LinkedIn Content Intelligence — Week of [DATE]

### Outreach Signals (ACT NOW)
[Prospect name, signal type, recommended action, time sensitivity]

### Content Signals
[Topic, evidence, recommended content angle]

### Competitive Signals
[Competitor, claim, our counter-position]

### Content Ideas Generated
[2-3 ideas with hooks]

STEP 6 — QUALITY GATE
- At least 10 profiles scanned? (Y/N)
- At least 1 outreach timing signal found? (Y/N)
- Content ideas are contrarian (not generic)? (Y/N)
- Report saved to correct location? (Y/N)
```

### Error Handling
- If LinkedIn profiles are inaccessible via web search: use cached data from last week + note "limited access" in report
- If no new posts found for a profile: note "inactive" and check if they've been posting on other platforms

---

## Task 5: Sales Navigator ICP Search

**Task ID:** `salesnav-icp-search`
**Schedule:** Every Sunday at 09:00 AM
**Category:** Lead Generation
**Tools Required:** Claude in Chrome (Sales Navigator browser access)
**Skills Referenced:** `smorch-gtm-tools:smorch-salesnav-operator`
**Feeds Into:** HeyReach campaigns, Instantly campaigns, Clay enrichment, Task 9 (Campaign Summary)

### Success Criteria
- All active ICP personas searched
- New leads extracted with signal data
- ICP Fit scored (PASS/FAIL hard stop)
- Signal recency validated (<90 days hard stop)
- Top 10 leads staged for outbound with channel recommendation
- Dedup check against GHL CRM completed

### Full Prompt Template

```
OBJECTIVE: Run saved Sales Navigator searches for all active ICP personas, extract new signal-bearing leads, and stage them for outbound sequencing.

PRE-REQUISITES CHECK:
- Sales Navigator Advanced/Enterprise seat active
- Claude in Chrome extension enabled
- ICP personas defined (see below)
- GHL CRM access for dedup check

STEP 1 — SEARCH EXECUTION
For each persona below, run the corresponding saved Sales Navigator search:

PERSONA 1: VP Sales / CRO at Gulf SaaS companies
- Geography: UAE, Saudi Arabia, Qatar, Kuwait
- Industry: Software, SaaS, Technology
- Company Headcount: 50-500
- Seniority: VP, CXO, Director
- Title keywords: VP Sales, CRO, Chief Revenue Officer, Head of Sales
- Saved Search Name: "[Update with your actual saved search name]"

PERSONA 2: Founder/CEO at MENA SMEs exploring AI
- Geography: UAE, Saudi Arabia
- Industry: Professional Services, Real Estate, Healthcare
- Company Headcount: 10-200
- Seniority: Owner, CXO, Founder
- Title keywords: CEO, Founder, Managing Director, Owner
- Saved Search Name: "[Update with your actual saved search name]"

PERSONA 3: Contact Center Leaders in Gulf
- Geography: UAE, Saudi Arabia, Qatar
- Industry: Telecom, Financial Services, Government
- Company Headcount: 200+
- Seniority: VP, Director
- Title keywords: VP Customer Experience, Director Contact Center, Head of CX
- Saved Search Name: "[Update with your actual saved search name]"

STEP 2 — SIGNAL DETECTION
For each new lead surfaced, check for buying signals:
- Job change in last 90 days (HIGH intent)
- Company headcount growth >10% in 6 months (MEDIUM intent)
- Recent funding round (HIGH intent)
- Posted about pain points matching our solution (TRUST signal)
- Engaged with competitor content (MEDIUM intent)
- Company appeared in relevant news (CONTEXT signal)

STEP 3 — LEAD SCORING & CLASSIFICATION
Score each lead using Signal-to-Trust hard stop rules:
- ICP Fit: PASS / FAIL → If FAIL, skip entirely (Hard Stop Rule 1)
- Signal Recency: <30d / 30-60d / 60-90d / >90d → If >90d, skip (Hard Stop Rule 2)
- Signal Strength: HIGH / MEDIUM / LOW
- Signal Type: INTENT vs TRUST

STEP 4 — CHANNEL RECOMMENDATION
For each qualified lead, recommend primary outreach channel:
- Job change signal → LinkedIn DM first (personal, timely)
- Funding signal → Cold email (data-driven, scalable)
- Content engagement → LinkedIn comment then DM (trust-first)
- Pain point post → LinkedIn DM with specific reference (signal-sniper)
- MENA contact with WhatsApp visible → WhatsApp (highest response rate in Gulf)

STEP 5 — DEDUP CHECK
Cross-reference qualified leads against GHL CRM:
- Use GHL search_contacts MCP tool
- If contact exists: check last_signal_date — if >30 days ago, flag for re-engagement
- If contact doesn't exist: flag as NEW LEAD

STEP 6 — OUTPUT
Save as: /mnt/SOP/leads/salesnav-leads-[YYYY-MM-DD].md

Structure:
## Sales Navigator ICP Search — [DATE]

### Summary
Total new leads found: [N] per persona
Passed ICP Fit: [N]
Passed Signal Recency: [N]
Recommended for outbound: [N]

### Top 10 Leads (ranked by signal strength)
[For each: Name, Title, Company, Signal Type, Signal Detail, Recommended Channel, CRM Status]

### Leads for Clay Enrichment
[CSV-ready list: email, linkedin_url, company, persona_tag, signal_type]

### Dedup Results
New leads: [N]
Existing in CRM (re-engage): [N]
Already in active campaign (skip): [N]

STEP 7 — QUALITY GATE
- All personas searched? (Y/N)
- Hard Stop Rules enforced (no FAIL fits, no >90d signals)? (Y/N)
- Channel recommendations are signal-appropriate? (Y/N)
- Dedup check completed against CRM? (Y/N)
- Top 10 list is genuinely the highest-signal leads? (Y/N)
```

### Error Handling
- If Sales Navigator is inaccessible: use LinkedIn basic search as fallback, note "limited data" in report
- If GHL CRM is unreachable for dedup: proceed without dedup, flag all leads as "DEDUP PENDING"
- If a persona search returns 0 results: widen geography or seniority one level, document the change

---

## Task 6: Competitive Intelligence Sweep

**Task ID:** `competitive-intelligence`
**Schedule:** Every Sunday at 10:09 PM
**Category:** Strategy
**Tools Required:** WebSearch, WebFetch
**Skills Referenced:** `smorch-gtm-engine:positioning-engine`, `sales:competitive-intelligence`
**Targets:** ColdIQ, FullFunnel.co, SalesCaptain.io, Leadgem.nl
**Feeds Into:** Wedge generation, positioning updates, content strategy

### Success Criteria
- All 4 competitors scanned across website, LinkedIn, and content
- Positioning changes documented with specific evidence
- New offers/pricing detected
- At least 1 wedge opportunity identified (gap we can exploit)
- MENA competitor layer included (Arabic-language agencies)

### Full Prompt Template

```
OBJECTIVE: Track positioning, offers, pricing, content, and hiring signals from 4 target agencies + MENA competitors. Identify wedge opportunities for SMOrchestra.

STEP 1 — WEBSITE SCAN
For each target:
1. ColdIQ (coldiq.com)
2. FullFunnel.co (fullfunnel.co)
3. SalesCaptain.io (salescaptain.io)
4. Leadgem.nl (leadgem.nl)

Check:
- Homepage: any messaging changes? New tagline, hero text, CTA?
- Pricing page: any changes to tiers, pricing, or packaging?
- Blog/Resources: new content in last 7 days? Topics?
- Case studies: new ones added?
- Team page: new hires? (signals growth or new capability)
- Job postings: what roles are they hiring? (signals strategic direction)

STEP 2 — LINKEDIN SCAN
For each competitor's company page and key team members:
- New posts in last 7 days
- Engagement levels (are they growing or stagnating?)
- New offers or lead magnets promoted
- Client wins or case studies shared
- Conference appearances or partnerships announced

STEP 3 — MENA COMPETITOR LAYER
Search for Arabic-language agencies offering similar services:
- Search queries: "وكالة تسويق B2B دبي", "AI sales automation UAE", "outbound agency Saudi"
- Check if any new MENA-native competitors have emerged
- Note any global agencies opening MENA offices

STEP 4 — POSITIONING DELTA ANALYSIS
Compare this week vs. previous reports:
- Who shifted positioning? From what to what?
- Who launched a new offer? What's the value prop?
- Who's gaining LinkedIn traction? Why?
- Who's losing momentum? Evidence?

STEP 5 — WEDGE OPPORTUNITIES
Based on gaps found, generate:
- 1-3 wedge angles where SMOrchestra can differentiate
- Each wedge: one sentence, ties to a specific competitor weakness
- Example format: "[Competitor] is pushing [approach] but it fails in MENA because [reason]. Our angle: [SMOrchestra's counter-position]."

STEP 6 — OUTPUT
Save as: /mnt/SOP/intel/competitive-intel-[YYYY-MM-DD].md

Structure:
## Competitive Intelligence — Week of [DATE]

### Competitor Snapshots
[For each of the 4 targets: changes detected, evidence, significance]

### MENA Competitor Landscape
[New entrants, Arabic-language agencies, global agencies entering MENA]

### Positioning Deltas
[Week-over-week changes with evidence]

### Wedge Opportunities
[1-3 actionable wedges with supporting logic]

### Signals for Action
- Content to create: [topics suggested by gaps]
- Outreach angles: [positioning claims to challenge]
- Offers to consider: [packaging ideas from competitor moves]

STEP 7 — QUALITY GATE
- All 4 competitors checked? (Y/N)
- MENA competitor layer included? (Y/N)
- At least 1 wedge opportunity identified with evidence? (Y/N)
- Report is actionable (not just descriptive)? (Y/N)
- Compared against last week's report for deltas? (Y/N)
```

### Error Handling
- If a competitor website is unreachable: use cached Google results, note "site unavailable" in report
- If LinkedIn company pages are restricted: use WebSearch for recent posts instead
- If no changes detected for a competitor: explicitly state "No changes — static week" (don't fabricate changes)

---

## Task 7: Monthly API Documentation Refresh

**Task ID:** `doc-refresh-monthly`
**Schedule:** 1st of every month at 09:00 AM
**Category:** Technical Operations
**Tools Required:** WebSearch, WebFetch, File system (Read, Write, Glob)
**Skills Referenced:** `smorch-dev:get-api-docs`
**Feeds Into:** Operator skill maintenance, all MCP-dependent tasks

### Success Criteria
- All 15 APIs checked for breaking changes
- Stale operator skills flagged with specific outdated sections
- Delta report written with: what changed, impact assessment, remediation steps
- Zero silent failures (every API check produces a result)

### Full Prompt Template

```
OBJECTIVE: Check top 15 APIs used by SMOrchestra operator skills for breaking changes, deprecations, and new features. Flag stale skills. Write delta report.

STEP 1 — API INVENTORY
Check each API's changelog/release notes for changes since last check:

1. GoHighLevel API (rest.gohighlevel.com) — ghl-operator skill
2. Instantly.ai API (api.instantly.ai) — instantly-operator skill
3. HeyReach API (api.heyreach.io) — heyreach-operator skill
4. Clay API (api.clay.com) — clay-operator skill
5. LinkedIn Sales Navigator (no public API, check UI changes) — salesnav-operator skill
6. n8n API (self-hosted) — n8n-architect skill
7. Apify API (api.apify.com) — scraper-layer skill
8. Relevance AI API — agent workflow skill
9. HeyGen API — video generation workflows
10. Resend API (api.resend.com) — email sending
11. Linear API (api.linear.app) — project management
12. OpenAI API — AI agent workflows
13. Anthropic API (api.anthropic.com) — Claude integrations
14. Google Sheets API — signal config, logging
15. Supabase API — MicroSaaS database layer

STEP 2 — CHANGE DETECTION
For each API:
- Check official changelog/release notes page
- Search for "[API name] breaking changes [current month] [current year]"
- Check for deprecated endpoints that our skills reference
- Check for new endpoints that could improve our skills
- Version check: are we referencing the latest version?

STEP 3 — SKILL IMPACT ASSESSMENT
For each change found:
- Which operator skill is affected?
- Is it a BREAKING change (skill will fail) or ENHANCEMENT (skill could be better)?
- Severity: CRITICAL / HIGH / MEDIUM / LOW
- Remediation: specific code/config change needed

STEP 4 — OUTPUT
Save as: /mnt/SOP/audits/api-refresh-[YYYY-MM].md

Also save individual gotcha files for critical changes:
/mnt/SOP/gotchas/[api-name]-[change-summary]-[YYYY-MM].md

Structure:
## API Documentation Refresh — [MONTH YEAR]

### Summary
APIs checked: 15
Changes detected: [N]
Breaking changes: [N]
Skills needing update: [N]

### Changes by Severity
#### CRITICAL
[API name, change, affected skill, remediation]

#### HIGH
[Same format]

#### MEDIUM / LOW
[Same format]

### No Changes Detected
[List APIs with no changes — confirms they were checked]

STEP 5 — QUALITY GATE
- All 15 APIs checked (no skips)? (Y/N)
- Each change has a severity rating? (Y/N)
- Each affected skill has specific remediation steps? (Y/N)
- Report distinguishes BREAKING vs ENHANCEMENT? (Y/N)
- Gotcha files created for critical changes? (Y/N)
```

### Error Handling
- If an API changelog is unavailable: search for community reports of changes, note "changelog unavailable" in report
- If an API has no public changelog: check GitHub issues, community forums, and recent blog posts
- If self-hosted APIs (n8n): check the installed version against latest release

---

## Task 8: Linear Project Summary & Dashboard (NEW)

**Task ID:** `linear-project-summary`
**Schedule:** Every Sunday at 14:00 PM
**Category:** Project Operations
**Tools Required:** Linear MCP (list_issues, list_projects, list_cycles, list_issue_statuses, list_milestones, get_project, get_issue)
**Skills Referenced:** `product-management:metrics-tracking`, `data:interactive-dashboard-builder`
**Feeds Into:** Monday standup, stakeholder updates, sprint planning

### Success Criteria
- All teams, projects, and issues extracted from Linear
- Adherence metrics calculated: on-time completion %, overdue issues, cycle velocity
- Team efficiency scored: throughput, WIP limits, blocked time
- Quality of input scored: description completeness, acceptance criteria presence, estimate accuracy
- Interactive HTML dashboard generated
- Actionable recommendations provided (not just metrics)

### Current Workspace Context (from live data)
- **Team:** Smorchestra (SMO)
- **Project:** SalesMfast Signal Scoring Engine (In Progress, started Feb 12, target Feb 16)
- **Total Issues:** 19 (15 project issues + 4 onboarding)
- **Statuses Available:** Backlog, Todo, In Progress, Done, Canceled, Duplicate
- **Labels:** Setup, Feature, Bug, Improvement
- **Milestones:** Day 1 (Signal Ingestion), Day 2 (Scoring Engine), Day 3 (Hardening/Testing)
- **Cycles:** None configured
- **Issues with Estimates:** 13 of 15 project issues have story point estimates

### Full Prompt Template

```
OBJECTIVE: Extract comprehensive project data from Linear, calculate adherence/efficiency/quality metrics, generate an interactive dashboard and actionable report.

STEP 1 — DATA EXTRACTION
Use Linear MCP tools to pull:

A) Team overview:
- list_teams → get team IDs
- For each team: list_issue_statuses

B) Project status:
- list_projects → get all active projects
- For each project: get_project with includeMembers=true, includeMilestones=true

C) All issues:
- list_issues with team=[team_name], limit=250
- For each issue capture: id, title, status, priority, estimate, labels, createdAt, updatedAt, completedAt, dueDate, projectMilestone, assignee, parentId

D) Cycle data:
- list_cycles for each team (current, previous)

STEP 2 — ADHERENCE METRICS
Calculate:
- On-time completion rate: issues completed by dueDate / total issues with dueDate
- Overdue issues: count and list of issues past dueDate still in Todo/In Progress
- Milestone adherence: issues completed per milestone vs planned
- Sprint velocity: story points completed per cycle (if cycles exist)
- Lead time: average days from created → done
- Cycle time: average days from In Progress → done

STEP 3 — TEAM EFFICIENCY METRICS
Calculate:
- Throughput: issues completed per week (rolling 4-week average)
- WIP ratio: issues In Progress / team members (target: <3 per person)
- Blocked time: issues stuck in same status >7 days
- Priority distribution: % Urgent vs High vs Medium vs Low (healthy = <10% Urgent)
- Unassigned issues: count and % (target: 0% for active sprint)

STEP 4 — QUALITY OF INPUT METRICS
For each issue, score:
- Description completeness: has description >100 chars? (Y/N)
- Acceptance criteria: has clear "done" definition? (Y/N)
- Estimate present: has story point estimate? (Y/N)
- Labels applied: has at least 1 label? (Y/N)
- Due date set: has dueDate? (Y/N)
- Milestone assigned: linked to a project milestone? (Y/N)
Calculate aggregate: Quality Score = (checks passed / total checks) x 100

STEP 5 — SHIPPED WORK ANALYSIS
- Total issues moved to Done in last 7 / 30 / 90 days
- Story points shipped in same periods
- Feature vs Bug vs Improvement ratio (from labels)
- Top contributors (by issues completed)

STEP 6 — GENERATE INTERACTIVE DASHBOARD
Create an HTML dashboard file with:
- Project health summary (red/amber/green)
- Adherence chart (on-time vs late, by milestone)
- WIP chart (current in-progress issues)
- Velocity trend (if cycle data exists)
- Quality score breakdown (radar chart)
- Overdue issues table (sortable)
- Priority distribution pie chart

Use Chart.js for visualizations. Dark theme (#1A1A2E background, #FF6600 accent).

STEP 7 — RECOMMENDATIONS
Based on metrics, generate 3-5 specific recommendations:
- If overdue >20%: "Consider reducing scope or extending timeline for [specific milestone]"
- If WIP >3 per person: "Too much parallel work. Focus: complete [specific issue] before starting new work"
- If quality score <70%: "Issue hygiene needs improvement. Add acceptance criteria to [specific issues]"
- If no cycles configured: "Enable 1-week cycles to track velocity and improve predictability"

STEP 8 — OUTPUT
Save report: /mnt/SOP/reports/linear-summary-[YYYY-MM-DD].md
Save dashboard: /mnt/SOP/reports/linear-dashboard-[YYYY-MM-DD].html

STEP 9 — QUALITY GATE
- All teams and projects included? (Y/N)
- Metrics are calculated from real data (no estimates/guesses)? (Y/N)
- Dashboard renders correctly? (Y/N)
- Recommendations are specific (not generic advice)? (Y/N)
- Report compares against previous week (if available)? (Y/N)
```

### Error Handling
- If Linear MCP is disconnected: STOP and report "Linear MCP not available — cannot generate summary"
- If no issues found: report "Empty workspace — no data to analyze" and skip dashboard generation
- If no cycles exist: skip velocity metrics, recommend enabling cycles in the report
- If dashboard generation fails: provide metrics in markdown table format as fallback

---

## Task 9: Campaign Summary & Audit (NEW)

**Task ID:** `campaign-summary-audit`
**Schedule:** Every Monday at 08:00 AM
**Category:** GTM Operations
**Tools Required:** HeyReach MCP, Instantly MCP (if enabled), GHL MCP
**Skills Referenced:** `smorch-gtm-tools:heyreach-operator`, `smorch-gtm-tools:instantly-operator`, `smorch-gtm-tools:ghl-operator`, `smorch-gtm-engine:signal-to-trust-gtm`
**Feeds Into:** Weekly campaign optimization, budget decisions, wedge refinement

### Success Criteria
- All active campaigns across all platforms extracted
- Performance metrics benchmarked against operator skill standards
- Campaign setup audited against best practices (from operator skills)
- Each campaign scored /100
- Gap bridge plan with specific fixes for underperforming campaigns
- Cross-channel coordination audited (dedup, sequencing, timing)

### Current Campaign Landscape (from live data)

**HeyReach (23 campaigns detected):**
- Active campaigns: Training Offer, Rakez Webinar, MENA GTM Blindspot, Founder-Led Sales Trap, CXMfast, MENA FinTech Q2, Expansion outside MENA
- Largest: CXMfast (473 leads), Rakez Webinar (125 leads)
- Key issue: multiple campaigns using single sender account (140055)

**Instantly:** Campaign list API currently disabled. Task should attempt access each run.

**GHL:** Contact/pipeline data accessible via MCP.

### Full Prompt Template

```
OBJECTIVE: Pull campaign data from HeyReach, Instantly, and GHL. Benchmark against operator skill standards. Score each campaign setup. Provide gap bridge plan.

STEP 1 — DATA EXTRACTION

A) HeyReach Campaigns:
- get_all_campaigns → list all campaigns with status and progress stats
- For each active/paused campaign with >0 leads:
  - get_leads_from_campaign → extract lead counts and statuses
  - get_campaign → get sequence steps, timing, messaging
  - get_overall_stats → platform-wide performance
- get_all_linked_in_accounts → sender health check

B) Instantly Campaigns:
- list_campaigns with get_all=true → all campaigns
- For each active campaign:
  - get_campaign → sequence steps, sending config
  - get_campaign_analytics → open/reply/bounce rates
- list_accounts → sender account health, warmup scores
- If Instantly API is disabled: note "Instantly data unavailable — manual check required" and skip

C) GHL Pipeline:
- get_pipelines → list all active pipelines
- search_opportunities → count by stage
- search_contacts with tag filters → count HOT/WARM/COLD

STEP 2 — PERFORMANCE BENCHMARKING
Compare each campaign against operator skill benchmarks:

HeyReach Benchmarks (from heyreach-operator skill):
- CR acceptance rate: >40% = Excellent, 25-40% = Healthy, <15% = Critical
- DM reply rate MENA: 7.24% baseline
- Optimal message length: <50 words
- Safety limits: 20-25 CRs/day/account, 80-100/week

Instantly Benchmarks (from instantly-operator skill):
- Open rate: >60% = Excellent, 40-60% = Good, <40% = Needs work
- Reply rate: >5% = Excellent (signal-based targeting: 15-25%)
- Bounce rate: <2% = Healthy, >5% = Critical
- Average cold reply rate: 3.43%, MENA: 5.1%

GHL Benchmarks:
- Pipeline conversion: leads → opportunities → closed
- Response time: <2 hours for HOT leads
- Tag hygiene: all contacts tagged with Source_, Status_, Intent_

STEP 3 — CAMPAIGN SETUP AUDIT
Score each campaign /100 across 10 dimensions:

1. NAMING CONVENTION (10pts): follows [campaign-name]-[channel]-v[version] format?
2. LIST QUALITY (10pts): leads match ICP? Deduped? Verified?
3. SEQUENCE DESIGN (10pts): 3-4 steps? Proper timing gaps? Escalation logic?
4. MESSAGE QUALITY (10pts): <120 words (email) / <50 words (LinkedIn)? Pattern interrupt hook? Signal-based personalization?
5. SENDER HEALTH (10pts): warmup score >80? Multiple senders for rotation? SSI score?
6. TIMING (10pts): respects Gulf business hours (Sun-Thu 9-5)? Ramadan adjustments?
7. EXCLUSIONS (10pts): excludes leads in other active campaigns? Excludes existing clients?
8. SAFETY LIMITS (10pts): daily limits within safe range? Account rotation configured?
9. TRACKING (10pts): webhooks configured for signal scoring? Tags applied on engagement?
10. CROSS-CHANNEL COORDINATION (10pts): no duplicate outreach across email+LinkedIn? Sequenced correctly?

STEP 4 — GAP BRIDGE PLAN
For each campaign scoring <80/100:
- List specific dimensions that lost points
- Provide exact fix instructions (not vague advice)
- Prioritize by: impact on reply rate x effort to fix
- Example: "CXMfast campaign scores 4/10 on EXCLUSIONS: excludeInOtherCampaigns=true but excludeHasOtherAccConversations=false. Fix: update campaign settings in HeyReach to enable conversation exclusion."

STEP 5 — CROSS-PLATFORM COORDINATION CHECK
- Are the same leads being contacted on email AND LinkedIn simultaneously? (dedup check)
- Is there proper sequencing? (LinkedIn CR first → email follow-up if no response in 5 days)
- Are engagement signals from one channel updating the other? (webhook check)
- Is GHL receiving signals from both channels? (tag verification)

STEP 6 — OUTPUT
Save report: /mnt/SOP/reports/campaign-audit-[YYYY-MM-DD].md
Save dashboard: /mnt/SOP/reports/campaign-dashboard-[YYYY-MM-DD].html

Report structure:
## Campaign Summary & Audit — [DATE]

### Executive Summary
Total campaigns: [N] across [N] platforms
Active: [N] | Paused: [N] | Completed: [N]
Total leads in pipeline: [N]
Average campaign score: [N]/100

### Platform Summaries
#### HeyReach
[Campaign table: name, status, leads, CR rate, reply rate, score /100]

#### Instantly
[Campaign table: name, status, leads, open rate, reply rate, bounce rate, score /100]

#### GHL Pipeline
[Pipeline stages with counts, conversion rates]

### Campaign Scorecards (detailed)
[For each campaign: 10-dimension breakdown, total score, specific gaps]

### Gap Bridge Plan (prioritized)
[Ranked by impact: campaign name, dimension, current state, fix instruction, expected improvement]

### Cross-Channel Coordination
[Dedup status, sequencing status, signal flow status]

### Recommendations
[3-5 specific, actionable recommendations with expected ROI]

STEP 7 — QUALITY GATE
- All accessible platforms checked? (Y/N)
- Each campaign scored against actual operator skill benchmarks (not made up numbers)? (Y/N)
- Gap bridge plan has specific fix instructions (not "improve messaging")? (Y/N)
- Cross-channel coordination checked? (Y/N)
- Dashboard renders correctly with real data? (Y/N)
- Unavailable platforms noted (not silently skipped)? (Y/N)
```

### Error Handling
- If Instantly API is disabled: note in report, score only HeyReach and GHL campaigns
- If HeyReach API rate-limited: pause 60 seconds, retry once, then proceed with partial data
- If GHL is unreachable: skip pipeline section, note "CRM data unavailable"
- If a campaign has 0 leads: score as 0/100 on LIST QUALITY, flag as "empty campaign — archive or populate"
- If sender account health data is unavailable: score SENDER HEALTH as N/A, don't penalize overall score

---

## Appendix: Task Dependencies Flowchart

```
FRIDAY
  Task 2 (YouTube Intel) ──────→ Task 3 (YouTube Repurpose)
                                      ↓
                                LinkedIn content queue
SATURDAY
  Task 4 (LinkedIn Intel) ──────→ Outreach timing signals
                                      ↓
SUNDAY                          Wedge generation
  Task 5 (Sales Nav) ──────────→ HeyReach / Instantly campaigns
  Task 8 (Linear Summary) ─────→ Monday standup
  Task 6 (Competitive Intel) ──→ Positioning updates, wedge refinement

MONDAY
  Task 9 (Campaign Audit) ─────→ Campaign optimization decisions

DAILY
  Task 1 (Drift Audit) ────────→ All tasks (skill integrity)

MONTHLY
  Task 7 (API Refresh) ────────→ Operator skill updates
```

## Appendix: Setup Checklist for New Team Members

To replicate this automation on your Claude setup:

1. **Install Required Plugins:**
   - smorch-dev (development tools)
   - smorch-gtm-engine (GTM orchestration)
   - smorch-gtm-tools (platform operators)
   - mamoun-personal-branding (content skills)

2. **Enable MCP Connections:**
   - Linear MCP → for Task 8
   - HeyReach MCP → for Task 9
   - Instantly MCP → for Task 9
   - GHL MCP → for Task 5 (dedup) and Task 9

3. **Enable Claude in Chrome:**
   - Required for Task 5 (Sales Navigator)
   - Required for Task 4 (LinkedIn deep research, optional)

4. **Create Output Directories:**
   ```
   /mnt/SOP/audits/        ← Tasks 1, 7
   /mnt/SOP/intel/          ← Tasks 2, 4, 6
   /mnt/SOP/content/        ← Task 3
   /mnt/SOP/leads/          ← Task 5
   /mnt/SOP/reports/        ← Tasks 8, 9
   ```

5. **Create Scheduled Tasks:**
   Copy each task's Full Prompt Template into a new scheduled task with the specified cron schedule.

6. **Customize Placeholders:**
   - Task 2: Add your 3 target YouTube creator URLs
   - Task 4: Add your 10+ target LinkedIn profile URLs
   - Task 5: Add your saved search names from Sales Navigator
   - Task 5: Update persona definitions from your icp.md
