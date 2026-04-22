---
status: active
last_reviewed: 2026-04-19
---

# SOP-13: Lana Handover Protocol

**Version:** 1.0 | **Date:** April 2026
**Scope:** All tasks, PRs, and context shared with Lana (Human QA, Amman UTC+3)
**Locked by:** Mamoun Alamouri, 2026-04-06

---

## Purpose

Every task Lana receives must include full project context so her Claude Code session never drifts. Lana operates on a Windows machine in Amman (UTC+3). She does not have the same ambient context that agents on smo-brain/smo-dev accumulate over time. Without explicit context transfer, her reviews will miss architectural intent, skip known constraints, and duplicate already-rejected approaches.

This SOP defines three deliverables that ensure Lana always has what she needs.

---

## Deliverable A: Project Context File

**File:** `.claude/LANA-PROJECT-CONTEXT.md` in every active repo.

**Updated:** Each sprint (or when architecture changes mid-sprint).

**Owner:** al-Jazari (VP Eng Agent) generates. Sulaiman reviews.

### Template

```markdown
# Lana Project Context: [Repo Name]

**Last updated:** YYYY-MM-DD
**Sprint:** [Sprint name/number]
**Updated by:** [Agent name]

## Architecture Overview
[2-3 paragraphs: What this system does, how it's structured, key components
and their relationships. Include a simple diagram if helpful.]

## Critical Constraints
- [Constraint 1: e.g., "All API routes must validate JWT before processing"]
- [Constraint 2: e.g., "Supabase RLS is enabled -- never bypass with service role in client code"]
- [Constraint 3: e.g., "n8n webhooks must respond within 10s or they timeout"]

## Known Tech Debt
| Area | Description | Risk if Touched | Planned Fix |
|---|---|---|---|
| [Module] | [What's wrong] | [What breaks] | [Sprint/date] |

## Recent Architecture Decision Records (ADRs)
| ADR | Decision | Impact on Lana's Work |
|---|---|---|
| ADR-XXX | [Decision summary] | [What Lana should know] |

## Integration Map
[Which services talk to which. API contracts. Shared databases.
Format: Service A -> Service B (via X)]

## Escalation Triggers
These conditions mean Lana should stop and escalate (not try to fix):
- [Trigger 1: e.g., "Any test touching auth/billing fails"]
- [Trigger 2: e.g., "Score drops below 80 after gap-bridger"]
- [Trigger 3: e.g., "PR touches more than 3 services"]

## Environment Setup (Windows)
[Any Windows-specific setup Lana needs for this repo.
Git Bash commands, npm/node version, env file locations.]
```

---

## Deliverable B: Per-PR Handover Brief

**Generated:** Automatically when a PR is marked "Ready for Review" and assigned to Lana.

**Owner:** al-Jazari generates. QA Lead Agent adds testing section.

**Format:** Posted as the first comment on the PR.

### Template

```markdown
## Handover Brief for Lana

### Why This PR Matters
[1-2 sentences: Business context. What user problem does this solve or
what system improvement does this make.]

### What Changed (Risk-Annotated)

| File/Module | Change | Risk | Notes |
|---|---|---|---|
| `src/scoring/engine.ts` | Modified scoring algorithm | HIGH | Core business logic, test thoroughly |
| `src/api/routes/score.ts` | Added new endpoint | MEDIUM | New API surface, check auth |
| `src/utils/format.ts` | Helper function added | LOW | Utility, minimal blast radius |

### What Could Go Wrong
- [Risk 1: e.g., "Scoring algorithm change could affect existing scores -- verify backward compatibility"]
- [Risk 2: e.g., "New endpoint has no rate limiting yet -- flag if exposed publicly"]

### What Was Already Tested
- [ ] Unit tests pass (coverage: XX%)
- [ ] Integration tests pass
- [ ] Agent code review complete (reviewer: [agent name])
- [ ] Scoring report: [score]/100

### What Lana Should Test
1. [Specific test case 1 with steps]
2. [Specific test case 2 with steps]
3. [Edge case to verify]
4. [Regression check: verify X still works]

### Lana's Authority on This PR
[See Decision Authority Matrix below for the category this PR falls into]
- **This PR is:** [LOW-risk / MEDIUM-risk / HIGH-risk]
- **Lana can:** [Approve and merge / Approve and notify Mamoun / Request changes only]
```

---

## Deliverable C: Decision Authority Matrix

### LANA DECIDES ALONE

No approval from Mamoun needed. Lana acts and proceeds.

| Situation | Action |
|---|---|
| LOW-risk PRs (utility changes, docs, config, tests) | Approve and merge to dev |
| MEDIUM-risk PRs with score >= 85 | Approve and merge to dev |
| Environment fixes (missing env var, wrong path) | Fix and commit |
| Create Linear issues for bugs found | Create with proper template (see below) |
| Request changes on any PR | Comment with specific feedback, send back |
| Ask agents to clarify or re-test | Tag in PR comment |

### LANA DECIDES + NOTIFIES MAMOUN

Lana makes the call but sends Mamoun a Telegram summary within 1 hour.

| Situation | Action |
|---|---|
| MEDIUM-risk PR touching API contracts | Approve + notify with contract diff summary |
| Override gap-bridger recommendation | Approve + notify with reasoning |
| Defer non-critical bugs to next sprint | Create issue + notify with justification |
| Test reveals unexpected behavior (non-blocking) | Document + notify |

### MAMOUN DECIDES

Lana flags and waits. Does not proceed without Mamoun's explicit approval.

| Situation | Action |
|---|---|
| HIGH-risk PRs (auth, billing, multi-service, schema changes) | Flag via Telegram, wait for approval |
| CRITICAL security findings | Flag via Telegram immediately, block PR |
| Score < 80 after gap-bridger | Flag via Telegram, PR stays open |
| Scope changes (PR does more/less than spec) | Flag via Telegram, request clarification |
| Hotfixes to production | Flag via Telegram, wait for approval |
| Production releases (merge dev -> main) | Flag via Telegram, wait for approval |

### LANA NEVER

These actions are outside Lana's authority regardless of context.

| Action | Reason |
|---|---|
| Merge to main | Production releases require Mamoun's approval |
| Modify infrastructure, auth, or billing code | Architecture-level changes, agent + Mamoun only |
| Create or delete repositories | Org-level decision |
| Override quality gates (force-merge failing checks) | Quality gates exist for a reason |
| Edit OpenClaw or Paperclip configuration | Agent infrastructure, see SOP-09 |
| Deploy to production | Deploys run from smo-dev by agents, see SOP-06 |

---

## Windows Machine Considerations

Lana works on a Windows machine. All handover materials must account for this.

### Path Format
- Use forward slashes (`src/api/routes.ts`) or platform-agnostic format in all documentation
- Never use backslashes in handover briefs
- If a command requires a specific path, provide both formats:
  ```
  # Unix/Mac
  cd /workspaces/smo/repo-name
  # Windows (Git Bash)
  cd /c/Users/Lana/repos/repo-name
  ```

### Shell
- **Recommended:** Git Bash (ships with Git for Windows)
- **Alternative:** PowerShell (provide PowerShell-compatible commands when relevant)
- All npm/node/git commands work the same in Git Bash

### Commands
When handover briefs include terminal commands:
- Test that commands work in Git Bash
- Avoid Unix-only tools (`sed`, `awk`, `xargs`) without Git Bash equivalents
- Use `npx` instead of global installs where possible
- Note any tools that need Windows-specific installation (e.g., Playwright browsers)

---

## Weekly Context Reset

**Frequency:** Every Monday, auto-generated and posted to each active repo's `.claude/LANA-PROJECT-CONTEXT.md`.

**Owner:** al-Jazari generates. Sulaiman reviews for completeness.

**Contents:**

```markdown
## Weekly Context Reset: [Week of YYYY-MM-DD]

### Architecture Changes This Week
- [Change 1 with ADR reference if applicable]
- [Change 2]

### Deferred Gaps
| Gap | Reason Deferred | Risk Level | Planned Sprint |
|---|---|---|---|
| [Gap description] | [Why not fixed now] | [Low/Med/High] | [Sprint] |

### Performance Trends
- Scoring report average: [X]/100 (trend: up/down/stable)
- Test coverage: [X]% (delta: +/-X%)
- Open bugs: [X] (delta: +/-X)

### Upcoming Work
| Task | Priority | Relevant Files | Notes for Lana |
|---|---|---|---|
| [Task 1] | P1 | `src/...` | [Context] |
| [Task 2] | P2 | `src/...` | [Context] |

### Active Risks
- [Risk 1 that Lana should watch for during reviews]
- [Risk 2]
```

---

## Bug Report Template

Every bug Lana files must use this structured format. Unstructured bug reports are rejected and sent back for reformatting.

```markdown
## Bug Report

**Title:** [Concise description of the bug]
**Severity:** SEV1 / SEV2 / SEV3 / SEV4 (see SOP-10)
**Found in:** PR #[number] / Sprint testing / Regression
**Reporter:** Lana

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens. Include error messages, screenshots, console output.]

### Files Involved
- `src/path/to/file.ts` (line XX)
- `src/path/to/other-file.ts`

### Environment
- **OS:** Windows [version]
- **Node:** [version]
- **Browser:** [if applicable]
- **Branch:** [branch name]
- **Commit:** [short SHA]

### Additional Context
[Anything else relevant: related PRs, similar bugs, workarounds attempted]
```

---

## Handover Timing

Lana is in Amman, UTC+3. Plan handovers accordingly:

- **Best window for PR assignment:** Before 10:00 UTC+3 (Lana's morning)
- **Avoid:** Assigning complex PRs after 16:00 UTC+3 (not enough time for thorough review)
- **Urgent items:** Telegram ping with context, don't just assign and wait
- **Response expectation:** Lana responds within 4 working hours during her business day (09:00-18:00 UTC+3)
