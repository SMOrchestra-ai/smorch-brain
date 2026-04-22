# Skill Injection Masterplan v2: Autopilot AI Development Organization

**Version:** 2.0
**Date:** 2026-04-06
**Author:** Claude (CPO + CTO + Engineering Head mode)
**Sponsor:** Mamoun Alamouri, Founder & CEO
**Status:** FINAL — Ready for Execution

---

## Part 1: The Macro Change

### What This Delivers

Today, SMOrchestra's AI-native org has **execution muscle** — 7 agents that can write code, test, deploy, and ship campaigns. But the system breaks when:

- A PR ships without structured review (al-Jazari self-approves based on vibes, not checklists)
- An incident hits production and there's no triage protocol (DevOps reacts, nobody coordinates)
- Architecture decisions are made ad-hoc (no ADR discipline, no trade-off analysis)
- Sprints have no formal planning (CEO assigns based on feel, not RICE/capacity)
- Projects start and immediately hit blockers that could've been caught in 10 minutes
- Work handed to Lana has no project context — she reviews code without knowing why it exists
- Codex and Claude Code are used inconsistently — no clear doctrine on which agent does what

**The macro change:** We inject **operational standards + project automation + human handover protocols** into every agent, every server, every session — so the org runs like a software company with 10 years of engineering culture, not a startup winging it.

### The End State: Autopilot MicroSaaS Factory

```
Mamoun writes a requirement (1 paragraph)
    ↓
Sulaiman (CEO) decomposes → PRD with INVEST stories, acceptance criteria
    ↓
Sulaiman proposes agent plan: "6 agents, 9 tasks. Codex for tasks 1,4 (high volume, low reasoning). Claude Code for the rest (architecture, integration)."
    ↓
Mamoun approves or adjusts → Sprint auto-planned with RICE scoring
    ↓
Project onboarding auto-runs → All dependencies verified before first line of code
    ↓
al-Jazari (VP Eng) builds → Self-reviews with 4-dimension framework
    ↓
QA Lead validates → Testing strategy + 5-hat scoring
    ↓
Handover to Lana → Full project context, decision authority matrix, structured review
    ↓
Lana approves or escalates → Ship with deploy checklist verified
    ↓
Monitoring active → Incident response armed, weekly stakeholder brief auto-generated
```

---

## Part 2: Three New Capabilities

### 2.1 Codex Doctrine: Agent-Proposed, Mamoun-Approved

**Problem:** SOP-7 had CEO and VP Eng auto-routing to Codex. This created inconsistency — sometimes Codex was used where Claude Code was better, and engineers had no say.

**New Policy:**

**Step 1:** When Sulaiman receives a BRD, he produces a **Workforce Plan** alongside the PRD:

```markdown
## Workforce Plan: [Project Name]

### Total: [X] agents across [Y] tasks

### Claude Code Assignments
| Task | Agent | Reasoning |
|------|-------|-----------|
| BRD-1: Database schema | VP Eng | High architectural sensitivity, needs ADR |
| BRD-3: Scoring engine | VP Eng | Complex reasoning, Claude API integration |
| BRD-6: Dashboard | VP Eng | Cross-service, frontend + API |

### Codex Assignments
| Task | Agent | Reasoning |
|------|-------|-----------|
| BRD-2: Webhook boilerplate | VP Eng (Codex) | 7 similar endpoints, high volume, low reasoning |
| BRD-4: Test scaffolding | QA Lead (Codex) | Repetitive test generation, defensive validation |

### Rationale
Codex handles bounded, repetitive backend work where speed > reasoning depth.
Claude Code handles architecture, integration, and anything touching security/auth.

### Risk Assessment
- Codex tasks are isolated modules with clear interfaces
- No Codex task touches auth, payments, or shared contracts
- Rollback plan: If Codex output fails review, reassign to Claude Code
```

**Step 2:** Mamoun reviews and approves/adjusts via Telegram or Linear comment.

**Step 3:** Only after approval, CEO dispatches with the confirmed assignments.

**Where Codex Fits Best (from SOP-7 research):**

| Use Case | Why Codex | Guardrails |
|----------|-----------|------------|
| Bounded backend CRUD | 2-3x faster generation, defensive validation | Must follow SPEC.json from Claude planner |
| Test scaffold generation | High volume, repetitive, validation-heavy | Must pass all existing tests |
| Webhook/API boilerplate | Similar endpoints, low reasoning intensity | No auth/payment endpoints |
| Terminal debugging | CLI-native, better at build failures | Time-boxed to 30min, escalate if stuck |
| Data migration scripts | Formulaic transforms, high volume | Read-only analysis first, write requires approval |

**What Does NOT Go to Codex:**
- Architecture decisions or ADRs
- Security-sensitive code (auth, RLS, payments)
- Cross-service integration
- Anything requiring repo-wide understanding
- UI/frontend (Claude's architectural consistency matters)

### 2.2 Project Onboarding: Pre-Flight Dependency Check

**Problem:** Every project (SSE V3, EO, CXMfast) hits the same blockers: missing .env vars, Tailscale not approved, Supabase IP not allowlisted, MCP not connected. Each blocker costs 30-60 min while agents wait for Mamoun.

**New Skill: `smorch-dev:project-onboard`**

When invoked (automatically on project kickoff or manually), it runs a 17-section pre-flight check:

```
/project-onboard [project-name]

Running pre-flight check for: Signal-Sales-Engine
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Section 1: Auth & Access
  ✅ Claude Code auth on smo-brain — v4.2.1
  ✅ Claude Code auth on smo-dev — v4.2.1
  ✅ Codex auth on smo-brain — v2.1.0
  ✅ claude_local root fix — acceptEdits mode on all 5 agents

Section 2: Network (Tailscale)
  ✅ smo-brain → smo-dev SSH — connected
  ✅ smo-dev → smo-brain SSH — connected
  ⚠️  Tailscale session expires in 12h — MAMOUN: renew at login.tailscale.com

Section 3: Database (Supabase)
  ✅ SUPABASE_URL present
  ✅ SUPABASE_ANON_KEY present
  ❌ SUPABASE_SERVICE_ROLE_KEY MISSING — MAMOUN: add to .env
  ❌ smo-dev IP not in Supabase allowlist — MAMOUN: add 89.117.62.131
  ✅ DB connection test passed

Section 4: Environment Variables
  ✅ .env exists, gitignored
  ❌ REDIS_URL missing — MAMOUN: provide Redis connection string
  ✅ All other vars present per .env.example

Section 5: n8n Connection
  ✅ n8n-dev healthy (smo-dev:5170)
  ✅ n8n-brain healthy (smo-brain:5678)
  ✅ MCP connected

Section 6: Agent Communication (Paperclip)
  ✅ Paperclip API healthy
  ✅ CEO wake — responded
  ✅ VP Eng wake — responded
  ⚠️  QA Lead wake — timeout 8s (expected <5s)

Section 7: MCP Connectors
  ✅ Linear — connected
  ✅ n8n-smo-dev — connected
  ✅ Playwright — connected
  ❌ Supabase MCP — wrong org linked — MAMOUN: relink to correct project

Section 8: Model Usage Status
  ✅ Claude Max subscription — active, 87% quota remaining
  ✅ Codex — active
  ⚠️  OpenAI token refresh — last refresh 6h ago, auto-refresh in 2h
  ✅ Gemini Flash Lite (heartbeat) — active

Section 9: Git & Repo
  ✅ Repo cloned at /workspaces/smo/Signal-Sales-Engine
  ✅ On dev branch, clean working tree
  ✅ Push test — auth OK

Section 10: Browser Dependencies
  ❌ Playwright browsers not installed on smo-dev — auto-fix: npx playwright install
  ✅ No other browser-dependent tests detected

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESULT: 3 BLOCKERS (need Mamoun), 2 WARNINGS, 1 AUTO-FIX

BLOCKERS FOR MAMOUN:
1. Add SUPABASE_SERVICE_ROLE_KEY to .env
2. Add smo-dev IP (89.117.62.131) to Supabase allowlist
3. Relink Supabase MCP to correct project

Send to Mamoun via Telegram? [Y/n]
```

**Key Design Decisions:**
- Categorizes issues as BLOCKER (needs Mamoun), WARNING (degrades but works), AUTO-FIX (agent handles)
- Checks model usage quotas so we don't hit limits mid-execution
- Verifies browser dependencies for headless execution
- Tests every MCP connector before first task
- Sends consolidated blocker list to Mamoun — one message, not 5 separate requests
- Runs automatically on project kickoff, can also be run on-demand

### 2.3 Lana Handover Process: Context-Rich, Authority-Clear

**Problem:** Lana receives task tickets with narrow scope but no project context. Her Claude Code doesn't know the architecture, the ADRs, the trade-offs, or why decisions were made. She reviews code without institutional memory. When she's unsure about authority, she either blocks (slow) or approves (risky).

**New Skill: `smorch-dev:handover-to-lana`**

When VP Eng or QA Lead completes work and it's ready for Lana, this skill auto-generates a handover package:

**A. Project Context File (per-repo, persistent)**

Created once per project, updated each sprint. Lives at `.claude/LANA-PROJECT-CONTEXT.md`:

```markdown
# Signal Sales Engine — Context for Lana

## What This Project Does
B2B signal intelligence engine. Detects buying intent from 4 sources
(Apify scraping, Firecrawl competitor monitoring, Clay enrichment,
GHL CRM events), scores signals via Claude API, routes to outreach
channels (email/LinkedIn/WhatsApp).

## Architecture (Current)
- 14 n8n workflows on testflow.smorchestra.ai
- 11 Supabase tables (see schema in docs/database-schema.md)
- Next.js dashboard at /dashboard
- Scoring engine: Claude API primary, rule-based fallback

## Critical Constraints
- NEVER modify webhook payload structure (3 external systems depend on it)
- NEVER change signal_sources table schema without ADR
- Arabic RTL: All dashboard text must render correctly in both directions
- Performance: Signal scoring must complete in < 3 seconds per signal

## Known Technical Debt
- [ ] YouTube scraper not deployed (26 nodes, too complex for MCP)
- [ ] LinkedIn scraper not deployed (24 nodes, same reason)
- [ ] No load testing on scoring engine yet
- [ ] Dashboard has no error boundaries

## Recent Decisions (ADRs)
- ADR-001: SQLite for queue, Supabase for application data
- BRD-3: Rule-based scoring fallback when Claude API is down

## Integration Map
Apify → n8n (ingestion) → Supabase (storage) → n8n (scoring) → n8n (routing)
                                                                    ↓
                                               Instantly (email) / HeyReach (LinkedIn) / GHL (WhatsApp)
Feedback: Instantly webhooks → n8n → Supabase (feedback_events)
          HeyReach webhooks → n8n → Supabase (feedback_events)
```

**B. Per-PR Handover Brief (auto-generated on PR creation)**

Appended to every Linear ticket assigned to Lana:

```markdown
## Handover to Lana

### Why This PR Matters
Implements signal scoring engine (BRD-3). This is the intelligence
layer — without it, raw signals go to outreach unsorted. Business
impact: Wrong signals = wasted outreach = damaged trust.

### What Changed (Risk-Annotated)
| File | Change | Risk | Why |
|------|--------|------|-----|
| lib/scoring/engine.ts | NEW | HIGH | Core scoring logic, Claude API calls |
| lib/scoring/fallback.ts | NEW | MEDIUM | Rule-based fallback, no external deps |
| n8n/003-scoring.json | NEW | LOW | Workflow definition, no runtime code |

### What Could Go Wrong
1. Claude API timeout → scoring hangs → outreach queue blocks
2. Rule-based fallback scores differently than Claude → inconsistent routing
3. Signal with missing fields → unhandled null → crash
4. Score > 100 or < 0 → downstream routing logic breaks

### What Was Tested
- Unit tests: 12 passing (scoring logic, fallback, edge cases)
- Integration: Scoring workflow deployed to n8n-dev (inactive)
- NOT tested: Load performance, Arabic signal content, real Claude API

### What Lana Should Test
1. Activate n8n workflow 003, trigger with test signal
2. Verify score lands in account_intent_scores table
3. Test with missing fields (null company, null signal_type)
4. Verify fallback activates when Claude API key is removed
5. Check dashboard renders scores correctly (RTL if Arabic)

### Scores
- Engineering: 8.5/10
- Architecture: 9/10
- QA: 7.5/10 (load testing gap)
- Composite: 8.2/10

### Your Authority on This PR
RISK TIER: HIGH (new scoring engine, core business logic)
→ Review thoroughly, REQUEST CHANGES if issues found
→ If you approve: notify Mamoun for final sign-off
→ If CRITICAL issue: BLOCK immediately, notify Mamoun
```

**C. Decision Authority Matrix (Lana's Permanent Reference)**

What Lana can decide on her own vs what needs escalation:

```
LANA DECIDES ALONE:
├── Approve LOW-risk PRs (tests, docs, config, < 50 LOC, isolated)
├── Approve MEDIUM-risk PRs (score >= 85, no security, single service)
├── Fix environment issues (missing deps, config typos, cache)
├── Push to human/lana/* branches
├── Create GitHub issues for bugs found
├── Request changes on any PR regardless of risk
├── Reject PRs with score < 70 (automatic BLOCK)
└── Run additional tests beyond what's specified

LANA DECIDES + NOTIFIES MAMOUN:
├── Approve MEDIUM-risk PRs touching API contracts
├── Approve PRs where she overrode a gap-bridger recommendation
├── Flag architectural concerns (doesn't block, but records)
├── Defer non-critical bugs to next sprint
└── Extend testing timeline beyond SLA

MAMOUN DECIDES (Lana escalates):
├── HIGH-risk PR approval (auth, RLS, payments, migrations, cross-service)
├── Any CRITICAL security finding
├── Score below 80 after gap bridging
├── Scope changes to the PR
├── Hotfix approvals
├── Ship with known HIGH severity bug
├── Changes to webhook payload structures
├── Changes to public API contracts
└── Release to production (always)

LANA NEVER DOES:
├── Merge to main
├── Modify infrastructure/auth/billing
├── Create or delete repos
├── Change team access or permissions
├── Override quality gates without Mamoun
├── Approve her own code
└── Skip security audit on auth-touching PRs
```

---

## Part 3: Current SOPs Review + Gap Map

### 3.1 Existing SOPs (8)

| SOP | Assessment |
|-----|-----------|
| **SOP-1: QA Protocol** | STRONG. 60-min 4-phase workflow with scoring gates. |
| **SOP-2: Pre-Upload Scoring** | STRONG. 5-hat system with hard stops. |
| **SOP-3: Github Standards** | STRONG. Missing: deploy checklist integration. |
| **SOP-4: Infrastructure Node Roles** | ADEQUATE. Missing: incident routing per server. |
| **SOP-5: Dev Roles Hierarchy** | STRONG. 3-layer model. |
| **SOP-6: Team Distribution** | STRONG. Missing: Lana authority matrix. |
| **SOP-7: Agentic Coding Orchestration** | DETAILED. Needs: Codex doctrine update (agent-proposes, Mamoun-approves). |
| **SOP-8: Project Kickoff Pre-Dev Check** | EXCELLENT. Foundation for project-onboard skill. |

### 3.2 New SOPs After Injection

| New SOP | What It Adds |
|---------|-------------|
| **SOP-9: Skill Injection Registry** | Who has what skills, single source of truth |
| **SOP-10: Incident Response Protocol** | SEV1-4 triage → mitigate → resolve → postmortem |
| **SOP-11: Codex Doctrine** | Agent-proposes workforce plan, Mamoun approves, use-case taxonomy |
| **SOP-12: Project Onboarding Automation** | Pre-flight check, blocker routing, auto-fix |
| **SOP-13: Lana Handover Protocol** | Context files, PR briefs, authority matrix |

---

## Part 4: Contradiction Resolution & Duplicate Removal

### 4.1 Duplicates to Remove

| Duplicate | Resolution |
|-----------|-----------|
| `systematic-debugging` vs `engineering:debug` | Merge. Keep "NO FIXES WITHOUT ROOT CAUSE" from smorch, use plugin's 4-step framework |
| `requesting-code-review` vs `engineering:code-review` | Layer. requesting = when to review. code-review = how to review. Wire together. |
| 15 GTM skills across 3 locations | smorch-dist is truth. Score each, delete from /skills/smorch-gtm/ |
| `engineering-scorer` vs `engineering:code-review` | Layer. code-review = qualitative (during dev). engineering-scorer = quantitative (at PR gate). Sequential. |
| `gap-bridger` vs `engineering:tech-debt` | Layer. tech-debt = quarterly audit. gap-bridger = per-PR fix cycle. Different lifecycle. |

### 4.2 SOP-7 Codex Update

**Remove:** Autonomous Codex routing by CEO/VP Eng
**Add:** Workforce Plan template (Section 2.1 above)
**Keep:** 13-dimension S_route scoring framework (good architecture, now advisory to Mamoun)
**Keep:** Task taxonomy (Category 1-5), safety constraints, handoff contracts
**Update:** Routing rules section — output is recommendation to Mamoun, not auto-dispatch

---

## Part 5: MENA Deep Layer (Injectable, Not Enforced)

**Design:** A standalone file `MENA-DEEP-OVERLAY.md` that agents can opt into per-project or per-task. Not baked into plugin defaults.

**How it's activated:**
- Per-project: Add `mena_overlay: deep` to project CLAUDE.md
- Per-task: Sulaiman tags Linear ticket with `mena:deep`
- Per-session: Agent loads overlay file at session start

**What's in it:**

```markdown
# MENA Deep Overlay — Injectable Context Layer

## When to Activate
- Client-facing output for Gulf/Levant markets
- Arabic-first products (SalesMfast SME, EO MENA)
- Competitive analysis involving MENA players
- Stakeholder updates to Gulf clients

## When NOT to Activate
- Internal tooling and infrastructure
- English-only international products
- Developer documentation
- System-level code (no cultural context needed)

## Language Rules (When Active)
- Client-facing Arabic: Gulf conversational, NOT MSA
- Technical Arabic: Use established tech terms, don't translate jargon
- Bilingual output: Arabic primary, English reference underneath
- Numbers: Use Western Arabic numerals (1,2,3) not Eastern (١,٢,٣) for tech context
- Currency: AED for UAE, SAR for Saudi, QAR for Qatar, KWD for Kuwait. Always show USD equivalent.

## Code Review Additions (When Active)
- [ ] All user-facing text supports RTL rendering
- [ ] Arabic text with mixed LTR content (numbers, English terms) renders correctly
- [ ] WhatsApp message templates follow platform limits (1024 chars, specific formatting)
- [ ] Date/time displays use local format (DD/MM/YYYY, 12h with AM/PM for Gulf)
- [ ] Phone numbers follow E.164 with Gulf country codes (+971, +966, +974, +965)
- [ ] Form inputs handle Arabic text input without breaking validation
- [ ] PDF generation renders Arabic correctly (right-to-left, proper font embedding)

## Stakeholder Communication (When Active)
- Executive updates: English with Arabic key terms
- Client updates: Gulf Arabic, conversational tone
- Status format: Maintain Green/Yellow/Red but add Arabic labels
- Timing: Account for Gulf weekends (Fri-Sat), Ramadan working hours, Amman time (UTC+3) vs Dubai (UTC+4)

## Competitive Analysis (When Active)
- Include regional competitors (not just global):
  - CRM: Freshworks ME, Bayzat, Zoho ME editions
  - Outreach: Rasayel (WhatsApp), Respond.io, Wati
  - Data: Dealroom MENA, Magnitt, MAGNiTT
- Pricing context: Gulf companies expect premium pricing with white-glove service
- Distribution: WhatsApp > Email for initial outreach in Gulf
- Trust signals: Government partnerships, free zone presence, Arabic support

## Sprint Planning (When Active)
- Account for: Ramadan (reduced hours), Eid holidays (3-5 days), UAE National Day (Dec 2-3)
- Working hours: Sun-Thu in Gulf, Sat-Thu in some markets
- Amman team (Lana): Sun-Thu, 8am-5pm UTC+3
- Dubai team: Sun-Thu, 9am-6pm UTC+4

## User Research Synthesis (When Active)
- Buying behavior: Relationship-based, not transactional
- Decision speed: Slower than US, faster once trust established
- Procurement: Often requires in-person meeting before purchase
- Reference checks: Verbal > written testimonials in Gulf culture
- WhatsApp is primary business communication channel

## Feature Spec Additions (When Active)
- Acceptance criteria must include Arabic RTL test cases
- User stories should specify: "As a Gulf business owner" not generic "As a user"
- Non-functional requirements: Arabic search, Arabic sorting, Arabic PDF export
- Success metrics: Include regional benchmarks (MENA open rates, MENA response rates)

## Metrics (When Active)
- Email open rates: MENA benchmark 25-35% (higher than global 20%)
- LinkedIn connection rate: MENA benchmark 30-40% (relationship culture)
- WhatsApp response rate: MENA benchmark 45-60% (primary channel)
- Sales cycle: 4-8 weeks (longer than US, shorter than Europe)
```

---

## Part 6: The 3-Phase Execution Plan

### Phase 1: FOUNDATION (Now — ~10 hours)

**Goal:** Full skill injection + new capabilities operational.

#### 1A: Plugin Deployment & Cleanup (~2.5 hours)

| Step | Action | Time |
|------|--------|------|
| 1A.1 | Copy engineering + product-management plugins to smorch-brain/plugins/ | 15 min |
| 1A.2 | Score 15 duplicate GTM skills (smorch-dist vs /skills/smorch-gtm/), document best version | 20 min |
| 1A.3 | Delete inferior duplicates from /skills/smorch-gtm/ | 10 min |
| 1A.4 | Merge systematic-debugging into engineering:debug (keep "NO FIXES WITHOUT ROOT CAUSE" rule) | 15 min |
| 1A.5 | Wire requesting-code-review to invoke engineering:code-review framework | 10 min |
| 1A.6 | Create MENA-DEEP-OVERLAY.md (injectable, not enforced) | 30 min |
| 1A.7 | Update SOP-7: Codex doctrine (agent-proposes, Mamoun-approves), remove auto-routing | 30 min |
| 1A.8 | Create SOP-9 through SOP-13 (5 new SOPs) | 45 min |

#### 1B: Agent Wiring (~1.5 hours)

| Step | Action | Time |
|------|--------|------|
| 1B.1 | Create SKILLS-CEO.md for Sulaiman (stakeholder-comms, roadmap, sprint-planning, incident commander, metrics, workforce-plan) | 15 min |
| 1B.2 | Create SKILLS-VP-ENG.md for al-Jazari (code-review, system-design, architecture, tech-debt, testing-strategy, deploy-checklist, debug, documentation, feature-spec, project-onboard) | 15 min |
| 1B.3 | Create SKILLS-QA.md (testing-strategy, code-review security dims, handover-to-lana) | 10 min |
| 1B.4 | Create SKILLS-DEVOPS.md (deploy-checklist, incident-response mitigation, documentation runbooks, project-onboard) | 10 min |
| 1B.5 | Create SKILLS-GTM.md + SKILLS-CONTENT.md + SKILLS-DATA-ENG.md | 15 min |
| 1B.6 | Update Sulaiman's AGENTS.md with operating procedures + workforce plan template | 15 min |
| 1B.7 | Update al-Jazari's AGENTS.md with engineering procedures + handover template | 15 min |

#### 1C: New Skills Creation (~2 hours)

| Step | Action | Time |
|------|--------|------|
| 1C.1 | Create `smorch-dev:project-onboard` skill (17-section pre-flight check) | 45 min |
| 1C.2 | Create `smorch-dev:handover-to-lana` skill (context file + PR brief + authority matrix) | 45 min |
| 1C.3 | Create `smorch-dev:workforce-plan` skill (Codex vs Claude Code proposal template for CEO) | 30 min |

#### 1D: Server Deployment (~1 hour)

| Step | Action | Time |
|------|--------|------|
| 1D.1 | Commit all changes to smorch-brain, push to dev | 10 min |
| 1D.2 | SSH to smo-brain, pull, symlink plugins to /root/.claude/plugins/ | 10 min |
| 1D.3 | SSH to smo-dev, pull, symlink plugins to /root/.claude/plugins/ | 10 min |
| 1D.4 | Create deploy-skills.sh automation script | 15 min |
| 1D.5 | Deploy Lana's config package to smorch-brain/lana-config/ | 15 min |

#### 1E: Context Files & Templates (~1.5 hours)

| Step | Action | Time |
|------|--------|------|
| 1E.1 | Update each project's CLAUDE.md with Required Skills section | 20 min |
| 1E.2 | Create 5 templates: ADR, PRD, Incident Report, Deploy Checklist, Sprint Plan | 30 min |
| 1E.3 | Create SKILL-LIFECYCLE-TRIGGERS.md (when each skill fires) | 15 min |
| 1E.4 | Create Lana's LANA-PROJECT-CONTEXT.md for Signal-Sales-Engine | 20 min |
| 1E.5 | Create Lana's decision authority matrix as standalone doc | 10 min |
| 1E.6 | Update DevTeamSOP README.md and INDEX.md | 10 min |

#### 1F: Auto-Trigger Hooks (~1 hour)

| Step | Action | Time |
|------|--------|------|
| 1F.1 | SessionStart hook: check CLAUDE.md, remind agent of required skills | 10 min |
| 1F.2 | PreToolUse hook for git commit: remind to run /review | 10 min |
| 1F.3 | PostToolUse hook for PR creation: auto-generate deploy-checklist | 10 min |
| 1F.4 | n8n trigger: Linear issue → "done" → auto stakeholder summary to Mamoun | 15 min |
| 1F.5 | n8n trigger: Sunday 9am Dubai → auto sprint-planning for Sulaiman | 15 min |

#### 1G: Validation (~30 min)

| Step | Action | Time |
|------|--------|------|
| 1G.1 | Test: al-Jazari /review on SSE V3 file → structured 4-dimension output | 5 min |
| 1G.2 | Test: Sulaiman /stakeholder-update → audience-tailored brief | 5 min |
| 1G.3 | Test: /project-onboard on Signal-Sales-Engine → pre-flight report | 5 min |
| 1G.4 | Test: /handover-to-lana generates context file + PR brief | 5 min |
| 1G.5 | Test: workforce-plan template generates Codex vs Claude proposal | 5 min |
| 1G.6 | Test: auto-trigger fires on git commit → review reminder | 5 min |

---

### Phase 2: CLOSE THE GAPS (Immediately After Phase 1 — ~5 hours)

**All items here have ZERO technical dependency.** They're pure skill authoring, n8n workflows, and content creation.

| Step | What We Build | Time | Why No Blocker |
|------|--------------|------|----------------|
| 2.1 | **BRD → Auto-PRD pipeline**: n8n workflow — Linear ticket with "BRD" label → triggers Sulaiman → feature-spec generates PRD → creates sub-tickets + workforce plan | 1.5h | n8n running, Linear MCP connected, feature-spec skill exists from Phase 1 |
| 2.2 | **Monitoring/observability skill** (`smorch-dev:monitor`): Health check patterns, alerting rules, log analysis templates, dashboard creation. Wire into Paperclip heartbeat + DevOps agent. Include: n8n workflow health, Supabase connection monitoring, API response time tracking | 1h | Pure skill authoring. Paperclip heartbeat already exists |
| 2.3 | **Tech debt integration into Paperclip**: Quarterly cron via n8n → al-Jazari runs tech-debt audit across all repos → creates remediation tickets on Linear with RICE scores | 30 min | n8n + Linear + tech-debt skill all available from Phase 1 |
| 2.4 | **Deep MENA layer finalization**: Complete Arabic-first output templates for all PM skills. Gulf business culture templates for stakeholder-comms. MENA competitive landscape for competitive-analysis. Create injection mechanism (CLAUDE.md toggle + Linear tag) | 1h | Pure content. No infra dependency |
| 2.5 | **Sprint velocity tracking**: Add velocity dimensions to sprint-planning skill. Track story points per sprint. Calculate team velocity for capacity planning. Store in Linear custom fields | 30 min | Linear MCP available, sprint-planning exists from Phase 1 |
| 2.6 | **Lana onboarding execution**: Send setup guide, share credentials, schedule verification call, create test ticket | 30 min | Config package ready from Phase 1 |

---

### Phase 3: DEFERRED (Technical Dependency)

| Item | Dependency | When |
|------|-----------|------|
| **Load/chaos testing skill** | Needs k6 installed on smo-dev. Needs baseline metrics from monitoring skill (Phase 2). Needs a deployed product to test against. | After first product ships through the new pipeline. Monitoring from Phase 2 must be running to measure results. |

**This is the only item deferred. Everything else ships in Phase 1 + Phase 2.**

---

## Part 7: Endgame Scoring

### After Phase 1 + Phase 2 Complete

| Dimension | Score | Evidence |
|-----------|:---:|---------|
| **Requirement → PRD automation** | **10** | BRD→PRD n8n pipeline (Phase 2.1) makes it hands-free with workforce plan |
| **Architecture discipline** | **9.5** | ADR template + system-design skill + auto-trigger on new-system |
| **Code quality enforcement** | **10** | 4-dimension review on every PR + 5-Hat scoring + pre-commit hook |
| **Testing standards** | **9** | testing-strategy + webapp-testing + qa-scorer. Gap: no load testing yet |
| **Deploy safety** | **10** | deploy-checklist auto-generated. Pre/during/post verified |
| **Incident response** | **10** | SEV1-4 protocol + monitoring skill (Phase 2.2) for proactive detection |
| **Sprint cadence** | **10** | RICE scoring + velocity tracking (Phase 2.5) + capacity planning |
| **Stakeholder visibility** | **10** | Auto weekly brief + Green/Yellow/Red + audience-tailored |
| **Tech debt management** | **10** | Quarterly audit via Paperclip cron (Phase 2.3) + remediation tickets |
| **MENA contextualization** | **10** | Deep injectable layer (Phase 2.4) — opt-in per project/task |
| **Duplicate/contradiction cleanup** | **10** | 15 GTM dupes removed, debugging merged, Codex doctrine clean |
| **Lana integration** | **10** | Handover skill + context files + authority matrix + onboarding |
| **Autopilot readiness** | **10** | BRD→PRD pipeline + project-onboard + workforce plan + auto-triggers |
| **Server consistency** | **9.5** | deploy-skills.sh + weekly n8n sync |
| **Codex integration** | **10** | Agent-proposes, Mamoun-approves. Clear use-case taxonomy. |
| **Project onboarding** | **10** | 17-section pre-flight. Blocker routing. Auto-fix where possible |
| **Human handover** | **10** | Context files + PR briefs + decision authority matrix |

### Weighted Composite

| Category | Weight | Score |
|----------|:---:|:---:|
| Quality Gates (review, test, deploy, scoring) | 25% | **9.8** |
| Operational Discipline (sprint, incident, debt, stakeholder) | 20% | **10** |
| Autopilot Pipeline (requirement → ship) | 20% | **10** |
| Human Integration (Lana handover, authority, context) | 15% | **10** |
| Infrastructure (servers, onboarding, MENA, Codex) | 10% | **9.9** |
| Cleanup (duplicates, contradictions, SOPs) | 10% | **10** |

### **Weighted Composite: 9.95/10**

**The 0.05 gap:** Architecture auto-trigger depends on consistent "new-system" tagging (slightly fuzzy), and load testing deferred to Phase 3. Both close naturally as the system runs.

---

## Part 8: File Change Manifest

### New Files (Phase 1)
```
smorch-brain/plugins/engineering/                    ← Copy from Plugins/
smorch-brain/plugins/product-management/             ← Copy from Plugins/
smorch-brain/skills/project-onboard/SKILL.md         ← New skill
smorch-brain/skills/handover-to-lana/SKILL.md        ← New skill
smorch-brain/skills/workforce-plan/SKILL.md          ← New skill
smorch-brain/scripts/deploy-skills.sh                ← Deployment automation
smorch-brain/lana-config/CLAUDE.md                   ← Her global config
smorch-brain/lana-config/settings.json               ← Her hooks
smorch-brain/lana-config/.mcp.json                   ← Her MCP connections
DevTeamSOP/MENA-DEEP-OVERLAY.md                      ← Injectable MENA layer
DevTeamSOP/SKILL-LIFECYCLE-TRIGGERS.md               ← When skills fire
DevTeamSOP/sops/SOP-Skill-Injection-Registry.md      ← SOP-9
DevTeamSOP/sops/SOP-Incident-Response.md             ← SOP-10
DevTeamSOP/sops/SOP-Codex-Doctrine.md                ← SOP-11
DevTeamSOP/sops/SOP-Project-Onboarding-Auto.md       ← SOP-12
DevTeamSOP/sops/SOP-Lana-Handover-Protocol.md        ← SOP-13
DevTeamSOP/templates/ADR-TEMPLATE.md
DevTeamSOP/templates/PRD-TEMPLATE.md
DevTeamSOP/templates/INCIDENT-REPORT.md
DevTeamSOP/templates/DEPLOY-CHECKLIST.md
DevTeamSOP/templates/SPRINT-PLAN.md
DevTeamSOP/templates/WORKFORCE-PLAN.md
DevTeamSOP/templates/LANA-HANDOVER-BRIEF.md
Paperclip: SKILLS-CEO.md, SKILLS-VP-ENG.md, SKILLS-QA.md,
           SKILLS-DEVOPS.md, SKILLS-GTM.md, SKILLS-CONTENT.md,
           SKILLS-DATA-ENG.md
Per-project: .claude/LANA-PROJECT-CONTEXT.md
```

### Files to Modify
```
DevTeamSOP/sops/SOP-Agentic-Coding-Orchestration.md  ← Codex doctrine
DevTeamSOP/sops/SOP-Team-Distribution.md              ← Add authority matrix
DevTeamSOP/README.md + INDEX.md                        ← New SOPs + templates
All project CLAUDE.md files                            ← Required Skills
Sulaiman AGENTS.md (OpenClaw)                          ← Operating procedures
al-Jazari AGENTS.md (OpenClaw)                         ← Engineering procedures
~/.claude/settings.json (all servers)                  ← Auto-trigger hooks
```

### Files to Delete
```
15 duplicate GTM skills from /skills/smorch-gtm/
smorch-dev/skills/systematic-debugging/ (after merge into engineering:debug)
```

### New Files (Phase 2)
```
n8n workflow: BRD-to-PRD pipeline
n8n workflow: Quarterly tech-debt audit
n8n workflow: Weekly skill sync
smorch-brain/skills/monitor/SKILL.md                   ← Monitoring skill
MENA-DEEP-OVERLAY.md updates                           ← Complete Arabic templates
```

---

*Self-Assessment: 9.5/10. The 0.5 gap: this is a large execution across 2 phases touching multiple servers. Risk of partial completion exists. Mitigated by: phased structure (each phase is independently valuable), validation at end of Phase 1, and deploy-skills.sh for repeatable server sync.*
