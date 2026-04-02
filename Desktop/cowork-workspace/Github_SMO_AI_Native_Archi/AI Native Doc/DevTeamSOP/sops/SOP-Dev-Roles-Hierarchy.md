# SOP-5: Development Roles & Hierarchy

**Version:** 1.0 | **Date:** March 2026
**Scope:** Every project in the SMOrchestra GitHub org
**GitHub Org:** SMOrchestra-ai

---

## The Three-Layer Operating Model

SMOrchestra runs an **AI-native development organization** where humans set direction, AI executes, and humans validate. The hierarchy is:

```
┌──────────────────────────────────────────────────┐
│               MAMOUN ALAMOURI                     │
│           Founder / Strategic Authority            │
│                                                    │
│  Business requirements · Architecture decisions    │
│  Release approvals · Client relationships          │
│  Team composition · Financial decisions             │
└────────────────────┬─────────────────────────────┘
                     │
                     │ Sets direction + approves
                     ▼
┌──────────────────────────────────────────────────┐
│         AI LAYER (Claude Code + OpenClaw)          │
│       CEO / COO / Engineering / QA Execution       │
│                                                    │
│  Code writing · Test creation · CI/CD · Scoring    │
│  PR creation · Documentation · Branch management   │
│  Task orchestration · Self-fix loops · Audits      │
└──────┬──────────────────────────────────┬────────┘
       │                                  │
       │ Assigns tasks (Linear)           │ Creates PRs for review
       ▼                                  ▼
┌──────────────────────────────────────────────────┐
│           LANA AL-KURD (@lanaalkurdsmo)           │
│        Human Engineer / QA / User Advocate         │
│                                                    │
│  Code review · QA testing · User interface testing │
│  Troubleshooting · Bug reporting · Arabic RTL QA   │
│  Debug investigation · Spec feedback               │
└──────────────────────────────────────────────────┘
```

---

## Role 1: Mamoun — Founder / Strategic Authority

### What Mamoun Does

| Responsibility | Examples |
|---------------|----------|
| **Business requirements** | "We need Arabic WhatsApp onboarding for the SME product" |
| **Architecture decisions** | ADR creation, choosing Supabase over Firebase, API versioning strategy |
| **Release approvals** | Every dev → main merge requires Mamoun's approval |
| **Client relationships** | Demos, feedback sessions, commercial commitments |
| **Team decisions** | Hiring, access changes, role modifications |
| **Budget & tooling** | Choosing between tools, approving paid seats, infra costs |
| **Priority setting** | Which tasks run first, which products get attention this sprint |

### What Mamoun Does NOT Do

- Write code (AI does this)
- Run QA (Lana + AI do this)
- Create branches or PRs (AI does this)
- Write tests (AI does this)
- Generate documentation (AI does this, Mamoun reviews)
- Debug CI failures (Lana + AI do this)

### Decision Rights (MAMOUN-REQUIRED)

These actions STOP and WAIT for Mamoun's explicit approval:

| Decision | Why |
|----------|-----|
| Merge to main (release) | Production deployment |
| Create/delete repos | Org structure |
| Change branch protection | Security |
| Modify infra/, auth/, billing/ | High blast radius |
| Add/remove team members | Access control |
| Architecture changes (new ADR) | System design |
| Release with score below 90 | Quality gate override |
| Skip QA on any release | Quality gate bypass |
| Defer a CRITICAL issue | Risk acceptance |
| Involve Lana on a task | Task assignment authority |
| Delete archived repos | Irreversible |

---

## Role 2: AI Layer — CEO/COO/Engineering/QA Execution

The AI layer operates as **four functional roles simultaneously**:

### AI as CEO (Product Direction Execution)
- Translates Mamoun's business requirements into technical specs
- Manages product backlog priorities (via Linear)
- Creates and assigns tasks for Lana
- Reports status and flags decisions to Mamoun

### AI as COO (Operations & Orchestration)
- Manages the task queue (OpenClaw)
- Handles dependency resolution between tasks
- Enforces branch model, commit conventions, release protocol
- Runs weekly architecture audits (Sundays 9am Dubai)
- Monitors repo hygiene (stale branches, orphaned tags)

### AI as Engineering Lead
- Writes ALL production code (Claude Code)
- Creates and maintains tests
- Generates documentation
- Creates PRs with structured descriptions
- Self-fix loop: reads CI failures, applies fixes, retries once
- Writes commit messages following conventional commit format
- Manages version control (tags, releases, CHANGELOG)

### AI as QA Automation
- Runs 5-hat scoring system (`/score-project`, `/score-hat`)
- Executes automated tests (Playwright, unit tests, integration tests)
- Generates gap bridge plans (`/bridge-gaps`)
- First-pass code review via `code-reviewer` agent
- Pre-upload scoring before every PR (SOP-2)

### What AI Does NOT Do

| Restriction | Why | Who Does It |
|------------|-----|-------------|
| Merge to main without Mamoun | Production safety | Mamoun approves |
| Make architecture decisions | Strategic impact | Mamoun decides, AI recommends |
| Create/delete repos | Org structure | Mamoun approves |
| Modify infra/auth/billing without approval | High blast radius | Mamoun approves |
| Replace human QA judgment | UX requires lived experience | Lana tests |
| Test as a real user | AI can't be a user | Lana tests |
| Validate Arabic UX in real context | Cultural nuance | Lana validates |
| Handle client-facing communication | Relationship trust | Mamoun handles |

---

## Role 3: Lana — Human Engineer / QA / User Advocate

### Core Identity

Lana is the **human quality gate** in an AI-native system. Her value is NOT in writing code — it's in **judgment, user empathy, and real-world validation** that AI cannot provide.

Reference: [Human Engineer Role in AI-Native Architecture](human-engineer-role-ai-native-2026-03.md)

### Time Allocation

| Activity | % Time | What This Looks Like |
|----------|--------|---------------------|
| **Code Review** | 40% | Review agent PRs, check intent alignment, scope compliance, security |
| **QA & User Testing** | 25% | Test as real user, Arabic RTL, mobile, edge cases, user flows |
| **Troubleshooting** | 20% | Debug `needs-human-debug` PRs, production incidents, integration failures |
| **Spec Feedback** | 10% | Review specs for clarity, add constraints AI missed, flag ambiguities |
| **System Integrity** | 5% | Verify hooks work, check branch health, documentation accuracy |

### What Lana Does

| Task | Description | Tools |
|------|-------------|-------|
| **Review agent PRs** | Read spec → read diff → verify scope → test change → MERGE/REVISE/BLOCK | GitHub PR interface |
| **QA testing** | Walk through as a real user. Test happy path, error states, Arabic RTL, mobile | Browser, device testing |
| **Bug reporting** | Structured reports: steps to reproduce, expected vs actual, screenshot, affected files | Linear tickets |
| **Debug investigation** | For `needs-human-debug` tagged PRs — root cause analysis, environment issues | Local dev environment |
| **Arabic RTL validation** | Verify Arabic text renders correctly, layout mirrors, numbers/dates format properly | Browser + Arabic keyboard |
| **User acceptance testing** | Coordinate with real users, translate feedback into structured specs | Linear + direct testing |
| **Spec review** | Flag unclear requirements, missing constraints, scope issues | Linear comments |

### What Lana Does NOT Do

| Don't | Why | Who Does It |
|-------|-----|-------------|
| Write production code | AI writes code | Claude Code |
| Write tests | AI writes tests | Claude Code |
| Create branches | AI creates branches | OpenClaw / Claude Code |
| Write commit messages | Automated by hooks | Git hooks |
| Write documentation | AI generates docs | Claude Code |
| Make architecture decisions | Mamoun's domain | Mamoun |
| Approve releases to main | Mamoun's decision | Mamoun |
| Change infra/auth/billing | MAMOUN-REQUIRED | Mamoun approves |
| Communicate with clients | Mamoun's relationship | Mamoun |

### Branch Permissions

| Action | Allowed? |
|--------|----------|
| Create `human/lana/TASK-XXX-slug` branches | YES |
| Push to her own branches | YES |
| Review and comment on PRs | YES |
| Approve PRs on dev | YES (MEDIUM/LOW risk) |
| Merge to dev | NO — Mamoun or AI merges |
| Merge to main | NO — MAMOUN-REQUIRED |
| Push to main or dev directly | NO — branch protection |

---

## How the Three Layers Interact

### Daily Flow

```
Morning:
  Mamoun → sets priorities for the day
  AI → picks up tasks, starts coding
  Lana → reviews overnight PRs, runs QA on staging

Midday:
  AI → completes features, creates PRs, runs scoring
  Lana → reviews new PRs, tests features, reports bugs
  AI → reads Lana's feedback, fixes issues

Afternoon:
  Lana → QA testing on fixed items, Arabic RTL validation
  AI → gap bridging, documentation, prepares next batch
  Mamoun → reviews HIGH-risk items, makes release decisions

End of Day:
  AI → queues overnight tasks for OpenClaw
  Lana → files end-of-day status on Linear
  Mamoun → reviews status, sets next day priorities
```

### Communication Protocol

| From → To | Channel | Format |
|-----------|---------|--------|
| Mamoun → AI | Claude Code session | Natural language requirements |
| AI → Mamoun | Session output | Structured status + decision requests |
| AI → Lana | Linear tickets | Structured task templates (SOP-4) |
| Lana → AI | Linear comments / PR reviews | Structured bug reports / review comments |
| Lana → Mamoun | Linear / direct message | Escalation of CRITICAL issues only |
| Mamoun → Lana | Linear / direct message | Priority overrides, context sharing |

### Escalation Path

```
Normal flow:
  AI completes → AI scores → AI creates PR → Lana reviews → AI fixes → Mamoun approves release

Bug found by Lana:
  Lana files bug → AI reads → AI fixes → Lana re-tests → resolved

CRITICAL issue:
  Lana finds CRITICAL → comments immediately → AI assesses → AI notifies Mamoun → Mamoun decides

`needs-human-debug`:
  CI fails twice → PR tagged → Lana debugs → writes structured fix spec → AI implements fix

Architecture question:
  AI recommends → Mamoun decides → AI implements → Lana validates
```

---

## Lana's Two Focus Areas

### Focus Area 1: Signal Sales Engine (Primary)

| Sub-Area | What Lana Does | What AI Does |
|----------|---------------|--------------|
| **Ops Side** (email verification, campaign automation) | QA the email workflows, test verification flows, validate campaign sequences work end-to-end | Build automation, write integration code, create workflows |
| **Data Input Side** (scrapers, Firecrawl) | Test scraper outputs for accuracy, verify data quality, check enrichment results | Build scraper integrations, connect Firecrawl + other sources, pipeline code |
| **Brain Orchestration** (Clay replacement vision) | Test signal detection accuracy, validate scoring outputs match expectations, review BRD for v3 | Architecture design, code implementation, BRD drafting |

### Focus Area 2: Ad-Hoc Projects (Secondary)

| How It Works | Details |
|-------------|---------|
| **Task source** | AI creates tasks on Linear based on Mamoun's priorities |
| **Scheduling** | Usually assigned in the morning |
| **Lana's role** | Testing, user interface validation, QA, debugging |
| **Examples** | "Test the new EO scorecard flow", "QA the Arabic RTL on eo-mena", "Debug the webhook integration failure" |

---

## Metrics

### Mamoun's Metrics (Founder)
- Revenue impact of shipped features
- Client satisfaction with deliveries
- Time from requirement to production
- Architecture decision quality (measured by rework rate)

### AI's Metrics (Execution)
- PR quality score (composite from 5-hat scoring)
- CI pass rate on first push
- Self-fix loop success rate
- Task completion throughput

### Lana's Metrics (Human Quality Gate)

| Metric | Target | Why |
|--------|--------|-----|
| PR review turnaround (HIGH risk) | < 2 hours | High-risk changes block the pipeline |
| PR review turnaround (MEDIUM risk) | < 4 hours | Keeps dev flowing |
| PR review turnaround (LOW risk) | < 8 hours | Same business day |
| Escaped defect rate | < 2% | Bugs reaching production despite review |
| QA testing turnaround | Same business day | Features ready for next morning's work |
| `needs-human-debug` resolution | < 2 hours | Unblocks the self-fix loop |
| Bug report quality | Structured, reproducible, with screenshots | Enables AI to fix on first attempt |

---

## MAMOUN-REQUIRED Actions Summary

| Action | Who Requests | Mamoun Decides |
|--------|-------------|----------------|
| Release to main | AI recommends | Mamoun approves |
| Architecture change | AI recommends | Mamoun decides |
| Involve Lana on task | AI asks | Mamoun approves |
| HIGH-risk PR merge | Lana reviews | Mamoun final approval |
| Score below 90 release | AI flags | Mamoun overrides or holds |
| Create/delete repo | AI recommends | Mamoun approves |
| Change team access | Anyone | Mamoun approves |
| Defer CRITICAL issue | AI recommends | Mamoun accepts risk |
