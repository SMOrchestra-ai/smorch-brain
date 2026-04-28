# SOP-01: QA Protocol

**Version:** 2.0
**Date:** April 2026
**Owner:** Mamoun Alamouri
**Scope:** Every project in the SMOrchestra GitHub org
**Time Bound:** 60 minutes maximum unless a CRITICAL issue is found
**Skills Used:** `/score-project`, `/score-hat`, `/bridge-gaps`, `/webapp-testing`, `/systematic-debugging`
**Paperclip QA Lead:** Agent ID `8b397285-24b0-4d64-8832-d88f0e5891b4` | Adapter: `claude_local` | Reports to: CEO (`ceeb7fb5`)

---

## Paperclip QA Agent (Automated Dispatch)

The QA Lead agent in Paperclip automatically handles validation when the CEO assigns a QA subtask. This is the primary QA path for BRD-driven work.

### How It Works

1. CEO decomposes a BRD and creates a QA subtask: `POST /api/companies/{cid}/issues` with `assigneeAgentId: 8b397285`, `status: todo`, `parentId: <engineering-task-id>`
2. Paperclip dispatches the QA Lead via `claude_local` adapter on smo-brain
3. QA Lead checks out the issue, reads acceptance criteria from the description
4. QA Lead validates VP Eng deliverables against the criteria
5. QA Lead comments on the issue with a structured pass/fail report
6. QA Lead sets issue status: `done` (pass), `blocked` (can't validate), or leaves `in_progress` (needs fixes)

### QA Lead Validation Checklist (auto-applied)

- All files from the BRD exist
- Existing code not broken or deleted
- `npm install` / `npm run typecheck` / `npm run build` pass
- Tests exist and pass
- Scope discipline: no extra files or features beyond spec
- PR targets correct branch (usually `dev`)

### When QA Lead Blocks

The QA Lead marks issues `blocked` when:
- VP Eng hasn't completed the parent task yet
- File access is restricted (permission-mode limitation)
- Acceptance criteria are ambiguous — escalates to CEO → Mamoun

### Manual QA (This SOP)

Use this SOP's manual protocol (Phases 1-4 below) when:
- Running pre-release QA (dev → main merge)
- Client demo prep
- Mamoun says "run QA"
- Weekly scheduled audits
- QA Lead agent is unavailable or blocked

---

## When This SOP Triggers

Run this QA protocol:
- Before any release PR (dev → main)
- Before any demo to a client or stakeholder
- After completing a feature branch (before PR to dev)
- When Mamoun says "run QA" or "check quality"
- Weekly on active projects (via scheduled audit)

---

## Phase 1: Automated Scoring (15 min)

### Step 1.1 — Run the 5-Hat Composite Scorer
```
/score-project
```
This runs all 5 hat scorers in sequence:

| Hat | Skill | What It Scores |
|-----|-------|---------------|
| Product | `/score-hat product` | Problem clarity, scope discipline, requirements quality, roadmap, market validation |
| Architecture | `/score-hat architecture` | BRD traceability, data architecture, API design, security, scalability, failure recovery |
| Engineering | `/score-hat engineering` | Code organization, TypeScript quality, error handling, testing, performance, security practices |
| QA | `/score-hat qa` | Functional completeness, edge cases, cross-browser, real-world performance, data integrity |
| UX/Frontend | `/score-hat ux-frontend` | Visual hierarchy, responsive layout, component architecture, interaction design, accessibility, RTL/Arabic |

### Step 1.2 — Record the Score
Save the composite score to `docs/qa-scores/[date]-[version].md`:
```markdown
# QA Score: [Project] v[X.Y.Z]
Date: [today]
Composite: XX/100
Product: XX | Architecture: XX | Engineering: XX | QA: XX | UX: XX

Issues found: [count]
Critical: [count]
```

### Step 1.3 — Decision Gate

| Composite Score | Action |
|----------------|--------|
| **90-100** | PASS — Proceed to release |
| **80-89** | CONDITIONAL PASS — Fix issues >7 severity, re-score affected hats |
| **70-79** | HOLD — Run Phase 2 gap bridging. Re-score. Release only if >85 after fix. |
| **Below 70** | FAIL — Major work needed. Create Linear tickets for each issue. No release. |

---

## Phase 2: Functional Testing (20 min)

### Step 2.1 — Determine Test Approach

| Project Type | Approach |
|-------------|----------|
| **Web app (frontend)** | Run `/webapp-testing` with Playwright |
| **API-only / backend** | Run test suite (`npm test`, `pytest`, etc.) + manual curl/Postman checks |
| **CLI tool / script** | Run with sample inputs, verify outputs |
| **No tests exist** | Create basic smoke tests first (happy path only), THEN run QA. Flag "no test coverage" as a HIGH issue in the report. |

### Step 2.1a — For Web Apps: Run Webapp Testing
```
/webapp-testing
```
Uses Playwright to:
- Navigate all main routes
- Test form submissions
- Verify API responses
- Check responsive layout (desktop + mobile)
- Validate Arabic RTL rendering (if applicable)
- Screenshot each page state

### Step 2.2 — Edge Case Testing
Test these scenarios manually or via Playwright:

| Category | Tests |
|----------|-------|
| **Empty states** | No data, first-time user, empty dashboard |
| **Error states** | Invalid input, network failure, timeout |
| **Boundary values** | Max length inputs, zero, negative numbers, special characters |
| **Arabic/RTL** | All text renders correctly in Arabic, layout mirrors properly |
| **Mobile** | Touch targets >44px, no horizontal scroll, readable text |
| **Auth** | Logged out redirect, expired session, role-based access |

### Step 2.2a — For Bugs Found: Run Systematic Debugging
If a bug is discovered during testing:
```
/systematic-debugging
```
This skill enforces root cause analysis before proposing fixes — prevents the "change random things until it works" anti-pattern.

### Step 2.3 — Report Issues
For each issue found:
1. Screenshot the issue (webapp) or paste the error output (API/CLI)
2. Describe: what happened vs what should happen
3. Rate severity: CRITICAL / HIGH / MEDIUM / LOW
4. Create a spec if Claude can fix it immediately

---

## Phase 3: Gap Bridging (20 min)

### Step 3.1 — Run Gap Bridger
```
/bridge-gaps
```
This takes the scoring results and generates a prioritized improvement plan with effort-to-impact ratios.

### Step 3.2 — Fix What's Possible in 20 Min
Focus on:
- CRITICAL issues first (security, data loss, crashes)
- HIGH issues with effort <15 min
- Skip LOW and MEDIUM unless trivially fixable

### Step 3.3 — Re-Score Affected Hats
After fixes, re-run only the affected hat scorers:
```
/score-hat [affected-hat]
```

---

## Phase 4: Final Report (5 min)

### Step 4.1 — Generate QA Report

```markdown
# QA Report: [Project] v[X.Y.Z]
**Date:** [today]
**Duration:** [X] minutes
**Scorer:** Claude Code + [Human if applicable]

## Scores
| Hat | Before | After | Delta |
|-----|--------|-------|-------|
| Product | XX | XX | +X |
| Architecture | XX | XX | +X |
| Engineering | XX | XX | +X |
| QA | XX | XX | +X |
| UX/Frontend | XX | XX | +X |
| **Composite** | **XX** | **XX** | **+X** |

## Issues Found
| # | Severity | Description | Status |
|---|----------|------------|--------|
| 1 | CRITICAL | ... | FIXED |
| 2 | HIGH | ... | FIXED |
| 3 | MEDIUM | ... | DEFERRED (ticket created) |

## Decision
[ ] PASS — Ready for release
[ ] CONDITIONAL PASS — Release after [specific fix]
[ ] HOLD — Needs [specific work] before release
[ ] FAIL — [reason]

## MAMOUN-REQUIRED
[List any issues that need Mamoun's decision]
```

### Step 4.2 — Save and Notify
- Save report to `docs/qa-scores/`
- If HOLD or FAIL: create Linear tickets for outstanding issues
- If team member (Lana) is involved: assign review/QA tickets per SOP-4

---

## Time Budget

| Phase | Time | Action if Over |
|-------|------|---------------|
| Automated scoring | 15 min | Scoring should be faster. If slow, check if repo is too large for context. |
| Functional testing | 20 min | Focus on critical paths only. Skip cosmetic issues. |
| Gap bridging | 20 min | Fix only CRITICAL and quick HIGH. Defer the rest. |
| Final report | 5 min | Template is pre-built. Fill in numbers. |
| **Total** | **60 min** | If a CRITICAL issue is found that requires >20 min to fix, extend to 90 min max and note the extension reason in the report. |

---

## MAMOUN-REQUIRED Actions
These require Mamoun's explicit approval — Claude Code must ASK, not proceed:
- Releasing with a score below 80
- Skipping QA on any release
- Deferring a CRITICAL issue
- Changing infra, auth, or database schema to fix a QA issue
