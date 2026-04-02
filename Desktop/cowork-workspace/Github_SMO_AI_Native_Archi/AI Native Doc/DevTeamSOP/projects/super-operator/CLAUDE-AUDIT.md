# CLAUDE.md - Super Operator Platform: Repo & Workflow Audit

## YOUR MISSION

You are a principal systems architect running a full capability audit for SMOrchestra.ai. You have three jobs:

1. **UNDERSTAND THE VISION** - Read the target product below. Lock it in.
2. **AUDIT EVERYTHING** - Every repo, every n8n workflow, every Supabase table. Document what exists.
3. **MAP THE GAPS** - Separate report: what is missing, how to connect the dots, domino build sequence.

---

## PART 1: THE VISION (Read and Lock In)

### The Big Domino: Super Operator Platform
A profile-based AI Operator Platform where users enter through Telegram/WhatsApp, describe what they want, and the system takes them from intent to deployed outcome. Operator profiles: Super Coder, Super Coach, Super Assistant, Super Agency/Marketer.

### First Domino: Super MicroSaaS Coder & Launcher (GTM Included)
This is what we build first. The most complex path. Every other operator is a subset.

**The 10-Stage Pipeline:**
```
[1] INTAKE ............. User describes idea (Telegram/WhatsApp)
[2] QUALIFICATION ...... 5-scorecard system validates idea, ICP, market, strategy, GTM fitness
[3] BRAIN BUILD ........ Ingests scorecard output into 12 structured project files
[4] ARCHITECTURE ....... Produces BRD, tech stack, architecture diagrams, MCP plan
[5] CODE BUILD ......... 5-phase dev pipeline (BRD > scaffold > core > integration > deploy-ready)
[6] QA + SECURITY ...... Code quality, tests, RTL Arabic, security hardening
[7] DEPLOY ............. VPS provisioning, Docker, Coolify, domain/SSL, CI/CD
[8] SAAS SHELL ......... SaaSFast wraps app with auth, payments, launch pages, AR/EN
[9] GTM GENERATION ..... Landing pages, email sequences, LinkedIn, WhatsApp copy
[10] CAMPAIGN LAUNCH ... Scraper + enrichment > signal scoring > autonomous multi-channel outbound
```

**Paying customer:** Non-technical founders in MENA who want to build and launch a MicroSaaS without hiring a dev team.

---

## PART 2: AUDIT INSTRUCTIONS

### 2.1 GitHub Repos to Audit

**Access:** You should have SSH/gh access via smorchestraai-code. If not, ask Mamoun for credentials.

Check these locations for repos:
- `gh repo list SMOrchestra-ai --limit 100` (org repos)
- `gh repo list smorchestraai-code --limit 100` (personal repos)
- `gh repo view yousef268/SaaSFast` (team member - SaaS shell)
- `gh repo view yousef268/ScrapMfast` (team member - signal engine)
- `gh repo view MamounSMO/eo-assessment-system` (scorecard web app)
- `gh repo view MamounSMO/EO-Build` (EO training/build)
- `gh repo view Marc-Lou-Org/ship-fast` (purchased ShipFast boilerplate)

**If you can't access a repo, document that and move on. Do NOT skip repos you can access.**

For EACH repo you can access, clone it and document:

| Field | Capture |
|-------|---------|
| Repo name + URL | Full path |
| Purpose | 1-2 sentences |
| Tech stack | Languages, frameworks, DB, key libs |
| Status | Production / Development / Prototype / Abandoned |
| Entry point | Main file or startup command |
| Database | Schema details if Supabase/Postgres |
| API endpoints | List ALL REST/GraphQL endpoints |
| MCP servers | Any MCP implementations found |
| External integrations | APIs called (GHL, Instantly, HeyReach, Apify, etc.) |
| Current deployment | Where/how deployed today |
| Test coverage | Tests exist? Passing? |
| Documentation | CLAUDE.md? README? |
| Production readiness | 1-5 scale with justification |
| Pipeline stage mapping | Which of the 10 stages does this repo serve? |

### 2.2 Supabase Audit

**Known Supabase account (mamoun@smorchestra.com):**
- `entrepreneursoasis` (ID: lhmrqdvwtahpgunoyxso, region: ap-northeast-1) - ACTIVE
  - Tables found: interests, playbooks, scoring_rubrics (3 rows), categories (5 rows), assessments, products, profiles, countries (22 rows), submissions, newsletter_subscribers
  - All tables have RLS enabled
- `mamoun@smorchestra.com's Project` (ID: odjuqweiyzicqmcqozsu - INACTIVE, skip)

**IMPORTANT: There may be additional Supabase projects on different accounts.** The CEO confirmed "EO MENA" exists on Supabase. To find ALL Supabase connections:

1. **Check .env files in EVERY repo** for `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `NEXT_PUBLIC_SUPABASE_URL`, or any supabase reference
2. **Check n8n credentials** for Supabase/Postgres connections on all 3 instances
3. **Check .env.example, .env.local, .env.production** files
4. **If you find a different Supabase project URL** (different subdomain than lhmrqdvwtahpgunoyxso), document it and ask Mamoun for access

For EACH Supabase project found:
- List all tables and their schemas (columns, types, constraints)
- Document RLS policies
- Document edge functions
- List migrations
- Map which tables serve which pipeline stages
- Note any state management patterns (project tracking, phase tracking, etc.)
- Check if any tables could serve as the canonical project state store for the Super Operator pipeline

### 2.3 n8n Workflow Audit (3 Instances)

You have MCP access to all 3 instances. Use the n8n MCP tools to read workflow details.

#### n8n-mamoun (smo-brain server) - 52 workflows
Key ACTIVE workflows to deep-dive:
- **EO Scorecards:** "EO - Project Definition Assessment", "EO - ICP Assessment", "EO - MAS Assessment", "EO - GTM Assessment", "EO - Strategy Selector", "EO - Consolidated Assessment"
- **SCF Signal Pipeline:** "LinkedIn Scraper", "Google Maps Scraper", "YouTube Scraper", "Enrichment Pipeline", "Campaign Trigger Evaluator", "Message Generator", "SCF - Webhook Handlers", "Add Lead to campaign", "create camp", "Heyreach event", "GHL Event"
- **Knowledge Sync:** "Gotchas KB > Notion Push", "Notion > Gotchas MD Pull" variants
- **Other active:** "Customer Support Voice Agent", "Doc Refresh Companion"

#### n8n-dev (smo-dev server) - 72 workflows
Key ACTIVE workflows to deep-dive:

**ACE (Autonomous Campaign Engine) - THIS IS CRITICAL:**
- "ACE - Claude Brain" (active)
- "ACE - Deploy Master" (active)
- "ACE - Deploy Emails" (active)
- "ACE - Deploy LinkedIn" (active)
- "ACE - Deploy WhatsApp" (active)
- "ACE - Deploy Social" (active)
- "ACE - Campaign Orchestrator" (active)
- "ACE - Reply Router" (active)
- "ACE - Status Sync" (active)
- "ACE - Telegram Commands" (active)
- "ACE - Telegram Callbacks" (active)
- "ACE - CSV Upload" (active)
- "ACE - Dashboard Generator" (active)
- "ACE - Error Handler" (active)
- "ACE - Weekly Optimization" (active)
- "ACE - Metrics GHL" (active)
- "ACE - Metrics Instantly" (active)
- "ACE - Metrics HeyReach" (active)
- "ACE - BRD Intake" (INACTIVE but exists - check why)

**Signal Detection:**
- "MENA Hiring Signal Detection" (active, latest version)
- "Clay Enrichment-test" (active)

**Outreach:**
- "outreach/activate" (active)

**Legacy SCF:** LinkedIn Scraper, Google Maps Scraper, YouTube Scraper, Enrichment Pipeline, etc. (copies from mamoun instance)

#### n8n-production (legacy server) - 80 workflows
Only audit workflows marked ACTIVE:
- "scraper test" (active), "score card" (active), "pepsi demo" (active)
- "File Analysis via Webhook" (active), "translator test" (active)
- "Enrich Company Data" (2 active versions), "chatbot" (active)
- "last mile approval workflow" (active), "std approval from odoo" (active)
- "lana translator" (active), "crew ai and comfy" (active)
- "scrap translate" (active), "start from scratch" (active)

Classify each as: **reusable for Super Operator / obsolete / needs migration to dev**

For EACH active workflow across all 3 instances, document:

| Field | Capture |
|-------|---------|
| Name | Workflow name |
| Instance | mamoun / dev / production |
| Active | yes/no |
| Purpose | What it does (1 sentence) |
| Trigger type | Webhook / Schedule / Manual / Sub-workflow |
| Node count | How many nodes |
| Key integrations | Which external tools it calls |
| Data schema | What data structure it passes between nodes |
| State management | Does it track state? Where? How? |
| Pipeline stage | Which of the 10 stages does it serve? |
| Reusability | HIGH / MEDIUM / LOW for Super Coder & Launcher |
| Issues/gaps | What's broken or missing |

### 2.4 Skills Inventory (Context Only)

The smorch-brain repo contains 48 Cowork/Claude Code skills across 6 categories. These are markdown instruction files that guide AI behavior. They are NOT APIs. They do NOT expose programmatic interfaces.

**Do NOT audit each skill individually.** Instead, confirm:
- smorch-brain repo structure matches the documented inventory (48 skills, 6 categories)
- 3 plugins exist: smorch-gtm-engine, eo-microsaas-os, eo-scoring-suite
- Profile system works (mamoun=48, smo-brain=22, smo-dev=11-14)

### 2.5 Infrastructure Inventory

Document what exists:
- OpenClaw 3-node mesh (smo-brain gateway + smo-dev agent + desktop agent)
- Tailscale VPN (smo-brain: 100.89.148.62, smo-dev: 100.117.35.19, desktop: 100.100.239.103)
- Contabo MCP (server lifecycle management)
- smorch CLI (skill distribution)
- GitHub org: SMOrchestra-ai (Team plan)
- Linear integration (if configured)

---

## PART 3: OUTPUT FILES

Create ALL output in a `/superai-audit/` folder. Location: create it wherever you're working.

### Report 1: `repo-inventory.md`
Complete table of all repos with every field from 2.1.

### Report 2: `supabase-audit.md`
All tables, schemas, RLS policies, edge functions from the entrepreneursoasis project.

### Report 3: `n8n-workflow-audit.md`
All active workflows across all 3 instances with every field from 2.3.
Organize by instance, then by pipeline stage relevance.

### Report 4: `ace-deep-dive.md` (HIGHEST PRIORITY)
The ACE system on n8n-dev is the most important existing asset. For EACH ACE workflow:
- Read the full workflow via n8n API (use `n8n_get_workflow` with the workflow ID)
- Document every node and its purpose
- Map data flow between ACE workflows
- Identify the state management model (does ACE have a project/campaign state object?)
- Answer: Can ACE be extended to orchestrate the full 10-stage pipeline, or must a new orchestrator be built?

### Report 5: `capability-map.md`
Matrix mapping every repo + every n8n workflow against the 10 pipeline stages.
For each stage, answer:
- What covers it today?
- Manual-only, API-ready, or MCP-ready?
- Percentage complete?
- Gaps?

### Report 6: `integration-map.md`
Text diagram showing how everything connects TODAY:
- API calls between systems
- Webhook connections
- File-based handoffs
- Manual handoffs (human copies data)
- MCP connections
- Missing bridges

### Report 7: `gap-analysis.md`
What is missing to connect the full pipeline, organized as:

**MVP Critical (must have to demo end-to-end):**
- Each gap: what it is, what to build, effort estimate, what it connects to, what it blocks

**Production Critical (must have before selling):**
- Same format

**Can Wait (nice to have, build later):**
- Same format

### Report 8: `domino-sequence.md`
Recommended build order based on what you actually found (not assumptions).

Key questions this must answer:
1. Can ACE be extended as the master orchestrator? Or new build?
2. Does eo-assessment-system already have API endpoints? If yes, Domino 1 may be partially done.
3. Does ScrapMfast already have usable APIs? If yes, what's the MCP wrapper effort?
4. What is the fastest path from current state to "scorecard > brain > build > deploy > campaign"?
5. What's the realistic timeline?

### Report 9: `executive-summary.md`
One page. What exists, what's missing, what to build first, estimated timeline.

---

## RULES

1. **Be explicit.** If a repo is incomplete, say so. If a workflow is broken, say so.
2. **Do NOT assume capabilities exist.** Check the actual code/workflow nodes.
3. **Distinguish between:** "works manually in Cowork" vs "has API/MCP that can be called programmatically."
4. **The 48 skills are instructions, not APIs.** Do not confuse them with programmatic interfaces.
5. **ACE is the highest-priority audit target.** Spend the most time here.
6. **Use n8n MCP tools** to read workflow details (n8n_get_workflow with workflow ID). Do not guess from names alone.
7. **If you can't access something,** document what you tried and move on. Do not block the entire audit.
8. **For Supabase,** use the Supabase MCP tools (list_tables, execute_sql) to inspect the schema.
9. **For GitHub repos,** clone and inspect. Look at package.json, requirements.txt, main entry files, API routes.
10. **Produce all 9 reports.** Do not skip any.

---

## ACCESS SUMMARY

| System | Access Method |
|--------|-------------|
| GitHub repos | `gh` CLI (smorchestraai-code) or SSH |
| n8n-mamoun | MCP: mcp__n8n-mamoun__* tools |
| n8n-dev | MCP: mcp__n8n-dev__* tools |
| n8n-production | MCP: mcp__n8n-production__* tools |
| Supabase (known) | MCP: mcp__cb73f37d__* tools (project: lhmrqdvwtahpgunoyxso) |
| Supabase (discover) | Check .env files in repos for additional Supabase project URLs |
| Contabo | MCP: mcp__contabo-server__* tools |
| GHL | MCP: mcp__ghl-mcp__* tools |
| Instantly | MCP: mcp__instantly__* tools |
| Linear | MCP: mcp__0ee06d36__* tools |

**DISCOVERY RULE:** Do not assume the systems listed above are complete. When auditing repos, check .env / .env.example / config files for ANY external service connections (Supabase, Firebase, MongoDB, Redis, etc.). The CEO confirmed there are Supabase projects beyond what's listed here (e.g., "EO MENA"). If you find a connection you cannot access, document the URL/reference and ask Mamoun for credentials. Do not skip.
