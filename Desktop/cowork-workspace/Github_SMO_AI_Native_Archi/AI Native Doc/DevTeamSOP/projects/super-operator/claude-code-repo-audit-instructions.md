# Claude Code Repo Audit Instructions
## For: Super MicroSaaS Coder & Launcher (GTM Included)

**Purpose:** Audit all repos and n8n workflows to produce a capability map, integration map, and gap analysis for building the Super Coder & Launcher platform.

**Who runs this:** Claude Code on the server (smo-brain or smo-dev), authenticated as smorchestraai-code with access to all repos.

**Output location:** Create `/audit/` folder in the repo root. All output files go there.

---

## PROMPT FOR CLAUDE CODE

Paste this entire block into a Claude Code session on the server:

```
You are acting as a principal systems architect auditing all repos and automation workflows for SMOrchestra.ai.

## TARGET PRODUCT VISION

We are building a "Super MicroSaaS Coder & Launcher (GTM Included)" - an autonomous pipeline that takes a founder from "I have a SaaS idea" to "live deployed app with running outbound campaigns."

The 10-stage pipeline:
1. INTAKE: User describes idea via Telegram/WhatsApp
2. QUALIFICATION: 5-scorecard system validates idea, ICP, market, strategy, GTM fitness
3. BRAIN BUILD: Ingests scorecard outputs into 12 structured project files
4. ARCHITECTURE: Produces BRD, tech stack decisions, architecture diagrams, MCP plan
5. CODE BUILD: 5-phase dev pipeline (BRD parse > scaffold > core > integration > deploy-ready)
6. QA + SECURITY: Code quality, tests, RTL Arabic validation, security hardening
7. DEPLOY: VPS provisioning, Docker, Coolify, domain/SSL, CI/CD, monitoring
8. SAAS SHELL: SaaSFast wraps app with auth, payments, launch pages, Arabic/English
9. GTM GENERATION: Landing pages, email sequences, LinkedIn copy, WhatsApp messages
10. CAMPAIGN LAUNCH: Scraper + enrichment > signal scoring > autonomous multi-channel outbound

## REPOS TO AUDIT

All repos accessible under the SMOrchestra-ai GitHub org AND personal accounts:

### In SMOrchestra-ai org:
- smorch-brain (skill registry, 48 skills, 3 plugins, 6 profiles, MCP configs)
- eo-assessment-system (scorecard web app)

### Pending transfer (check personal accounts):
- yousef268/SaaSFast (SaaS shell: auth, payments, launch pages)
- yousef268/ScrapMfast (signal-based sales engine)
- MamounSMO/EO-Build (EO training/build system)
- Marc-Lou-Org/ship-fast (original ShipFast boilerplate)

For each repo, clone it and analyze:

## DELIVERABLE 1: REPO INVENTORY TABLE

For EACH repo, document:
| Field | What to capture |
|-------|----------------|
| Repo name | Full path |
| Purpose | 1-2 sentence description |
| Tech stack | Languages, frameworks, databases, key libraries |
| Status | Production / Development / Prototype / Abandoned |
| Entry point | Main file or startup command |
| Database | Supabase / PostgreSQL / SQLite / None / Other |
| API endpoints | List all REST/GraphQL endpoints if any |
| MCP servers | Any MCP implementations |
| External integrations | APIs called (GHL, Instantly, HeyReach, Apify, etc.) |
| Deployment | How/where deployed today |
| Dependencies | Other repos it depends on |
| Test coverage | Tests exist? Passing? Coverage %? |
| Documentation | CLAUDE.md? README? API docs? |
| Production readiness | 1-5 scale with justification |

## DELIVERABLE 2: CAPABILITY MAP

Map each repo against the 10-stage pipeline. For each stage, answer:
- Which repo(s) cover this stage?
- What percentage is complete?
- Is it manual-only, API-ready, or MCP-ready?
- What specific gaps exist?

## DELIVERABLE 3: n8n WORKFLOW AUDIT

We have 3 n8n instances. Audit the ACTIVE workflows on each:

### n8n-mamoun (smo-brain server) - Active workflows to analyze:
- EO Assessment workflows: "EO - Project Definition Assessment", "EO - ICP Assessment", "EO - MAS Assessment", "EO - GTM Assessment", "EO - Strategy Selector", "EO - Consolidated Assessment"
- SCF Signal pipeline: "LinkedIn Scraper", "Google Maps Scraper", "YouTube Scraper", "Enrichment Pipeline", "Campaign Trigger Evaluator", "Message Generator", "SCF - Webhook Handlers", "Add Lead to campaign", "create camp", "Heyreach event", "GHL Event"
- Notion sync: "Gotchas KB > Notion Push", "Notion > Gotchas MD Pull"

### n8n-dev (smo-dev server) - Active workflows to analyze:
- ACE (Autonomous Campaign Engine) suite:
  - "ACE - BRD Intake" (inactive but exists)
  - "ACE - Claude Brain"
  - "ACE - Deploy Master"
  - "ACE - Deploy Emails"
  - "ACE - Deploy LinkedIn"
  - "ACE - Deploy WhatsApp"
  - "ACE - Deploy Social"
  - "ACE - Campaign Orchestrator"
  - "ACE - Reply Router"
  - "ACE - Status Sync"
  - "ACE - Telegram Commands"
  - "ACE - Telegram Callbacks"
  - "ACE - CSV Upload"
  - "ACE - Dashboard Generator"
  - "ACE - Error Handler"
  - "ACE - Weekly Optimization"
  - "ACE - Metrics GHL"
  - "ACE - Metrics Instantly"
  - "ACE - Metrics HeyReach"
- SCF Signal pipeline (copies from mamoun): LinkedIn Scraper, Google Maps Scraper, YouTube Scraper, Enrichment Pipeline, Campaign Trigger Evaluator, Message Generator, SCF Webhook Handlers, Add Lead to campaign, create camp
- Signal detection: "MENA Hiring Signal Detection" (multiple versions), "MENA Event Signal Detection (EventBrite)", "Clay Enrichment-test"
- Outreach: "outreach/activate"

### n8n-production (legacy server):
- Only audit workflows marked ACTIVE
- Classify as: reusable / obsolete / needs migration

For each workflow, document:
| Field | What to capture |
|-------|----------------|
| Name | Workflow name |
| Instance | mamoun / dev / production |
| Active | yes/no |
| Purpose | What it does (1 sentence) |
| Trigger | Webhook / Schedule / Manual / Sub-workflow |
| Integrations | Which tools it connects (GHL, Instantly, HeyReach, Apify, Claude API, Telegram, etc.) |
| Pipeline stage | Which of the 10 stages does it serve? |
| Reusability | HIGH / MEDIUM / LOW for Super Coder & Launcher |
| Gaps | What's missing or broken |

## DELIVERABLE 4: INTEGRATION MAP

Show how repos and n8n workflows connect TODAY:
- API calls between systems
- Webhook connections
- File-based handoffs
- Manual handoffs (human copies data between tools)
- MCP connections
- Missing bridges that block autonomy

Draw this as a text diagram showing data flow between all components.

## DELIVERABLE 5: ACE SYSTEM DEEP DIVE

The ACE (Autonomous Campaign Engine) on n8n-dev is the most relevant existing orchestration. For each ACE workflow:
- What does it actually do (read the workflow nodes)?
- What data schema does it use?
- How does it connect to other ACE workflows?
- Does it have its own state management?
- Can it be extended or must it be rebuilt?

This is critical because ACE may already solve parts of the orchestration gap.

## DELIVERABLE 6: MISSING COMPONENTS

Based on the audit, identify what is missing to connect the 10-stage pipeline:

### Critical for MVP:
- [ ] Scorecard API/MCP (eo-assessment-system exposes structured output)
- [ ] Canonical project state schema
- [ ] Master orchestrator (or can ACE be extended?)
- [ ] Skill-to-orchestrator bridges
- [ ] Signal engine MCP (ScrapMfast API wrapper)

### Critical for production:
- [ ] Approval framework (Telegram bot)
- [ ] Error recovery / resumability
- [ ] Artifact registry
- [ ] Cross-instance n8n federation (if needed)

### Can wait:
- [ ] Multi-tenant / permissions
- [ ] Productization wrapper
- [ ] Observability beyond n8n logs

For each missing component, specify:
- What exactly needs to be built
- Estimated effort (hours/days)
- Which existing asset it connects to
- Whether it blocks other components

## DELIVERABLE 7: RECOMMENDED DOMINO SEQUENCE

Based on what you find, recommend the build order.

Key question to answer: Can ACE on n8n-dev be extended to serve as the master orchestrator for the full pipeline, or does a new orchestration layer need to be built?

## OUTPUT FILES

Create these files in /audit/:

```
/audit/
  repo-inventory.md          (Deliverable 1)
  capability-map.md          (Deliverable 2)
  n8n-workflow-audit.md      (Deliverable 3)
  integration-map.md         (Deliverable 4)
  ace-deep-dive.md           (Deliverable 5)
  missing-components.md      (Deliverable 6)
  domino-sequence.md         (Deliverable 7)
  executive-summary.md       (1-page summary of findings)
```

## RULES

1. Be explicit. If a repo looks incomplete, say so.
2. If you cannot access a repo, document that and move on.
3. Do NOT assume capabilities exist because a skill describes them. Check the actual code.
4. Distinguish between "works manually in Cowork" and "has API/MCP that can be called programmatically."
5. The ACE system on n8n-dev is likely the most important existing asset. Analyze it thoroughly.
6. For n8n workflows, use the n8n API to read workflow details, not just names.
7. If you find the scorecard app (eo-assessment-system) already has API endpoints, document them precisely.
8. Check if ScrapMfast already has API endpoints built (the CEO mentioned APIs exist).
9. The 48 skills in smorch-brain are Cowork/Claude Code skills (markdown instruction files), NOT APIs. They guide AI behavior but do not expose programmatic interfaces. Do not confuse them with API endpoints.
10. Pay special attention to how EO Assessment scorecard results flow into brain ingestion today. This is the first domino.
```

---

## HOW TO RUN THIS AUDIT

### Option A: Single server session (recommended)
SSH into smo-brain (or smo-dev), start a Claude Code session, paste the prompt above.

### Option B: Split across servers
- Run repo audit on whichever server has git access to all repos
- Run n8n audit from the server that has API access to all 3 instances (check MCP configs)

### Pre-requisites before running:
1. Verify git access: `gh repo list SMOrchestra-ai --limit 100`
2. Verify access to personal repos: `gh repo view yousef268/SaaSFast` (etc.)
3. Verify n8n API access: test one workflow list call per instance
4. Ensure enough disk space for cloning repos

### After the audit:
1. Review all 8 output files
2. Pay special attention to ace-deep-dive.md - if ACE already has orchestration patterns, the build effort drops significantly
3. Use missing-components.md to validate/update the domino sequence in super-coder-launcher-blueprint.md
4. Start building Domino 1 (Scorecard API/MCP)

---

## CONTEXT FILES FOR CLAUDE CODE

When running the audit, inject these as context:
- This file (claude-code-repo-audit-instructions.md)
- super-coder-launcher-blueprint.md (the vision and domino sequence)
- The AI-Native Git Architecture v2 (for understanding repo structure standards)

---

## KEY DISCOVERY FROM n8n AUDIT (Pre-findings)

The n8n-dev instance has a full ACE (Autonomous Campaign Engine) system with 19 active workflows. This was NOT in the original ChatGPT conversation. This changes the gap analysis significantly:

**ACE already handles:**
- Campaign orchestration (ACE - Campaign Orchestrator)
- Multi-channel deployment (Deploy Emails, LinkedIn, WhatsApp, Social)
- Reply routing (ACE - Reply Router)
- Status synchronization (ACE - Status Sync)
- Telegram command interface (ACE - Telegram Commands + Callbacks)
- CSV lead upload (ACE - CSV Upload)
- Dashboard generation (ACE - Dashboard Generator)
- Error handling (ACE - Error Handler)
- Weekly optimization (ACE - Weekly Optimization)
- Channel metrics (Metrics GHL, Instantly, HeyReach)
- AI brain integration (ACE - Claude Brain)
- BRD intake (ACE - BRD Intake, currently inactive)

**This means:** The orchestration gap may be smaller than estimated. ACE could potentially be extended to serve as the master conductor for the full Super Coder & Launcher pipeline, rather than building a new orchestrator from scratch.

**The critical audit question is:** What is ACE's state management model? If it has a project/campaign state object, we can extend it. If it's stateless webhook chains, we need to add state management on top.
