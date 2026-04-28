# Lana's Guide — QA Lead Operations

**What this is:** Your single reference for working as QA Lead in the SMOrchestra AI-native org. What tools you have, what you decide alone, and how everything connects.

---

## Your Setup (Windows)

| Item | Detail |
|------|--------|
| Terminal | Git Bash (not CMD or PowerShell) |
| Paths | Forward slashes always (`C:/Users/Lana/...`) |
| Branch naming | `human/lana/TASK-XXX-description` |
| Claude Code config | `.claude/CLAUDE.md` in each project root |
| Full setup guide | `smorch-brain/final-sop/lana/SETUP-GUIDE-WINDOWS.md` |

---

## Daily Workflow

### Morning (Start of Day)
1. `git checkout dev && git pull origin dev` — sync latest
2. Check Linear for assigned tickets (filter: `assignee:Lana`, `status:In Progress` or `status:Review`)
3. Check Telegram for any messages from Mamoun or Sulaiman
4. Start with highest-priority PR review or assigned ticket

### When You Receive a PR to Review
1. Pull the branch: `git checkout <branch> && git pull`
2. Run scoring: `/score-project composite` — checks all 4 gates
3. Run review: `/review` — structured 4-dimension framework (Correctness, Security, Performance, Maintainability)
4. **Score >= 8 on all dimensions** → Approve with review attached
5. **Score < 8 on any dimension** → Request changes with specific, numbered actions
6. **Critical security finding** → Block immediately, notify Mamoun on Telegram

### When You Find a Bug
1. Reproduce on latest `dev` branch
2. File in Linear using the bug template (see CLAUDE.md)
3. Tag severity: Critical / High / Medium / Low
4. **Critical bugs** → Telegram Mamoun immediately with Linear link

### When You Start a New Task
1. `git checkout dev && git pull origin dev`
2. `git checkout -b human/lana/TASK-XXX-description`
3. Read the Linear ticket fully
4. Check `.claude/LANA-PROJECT-CONTEXT.md` for project context
5. Work → commit often → push when ready for review

---

## Quality Gates (Hard Rules)

| Gate | Minimum | Command |
|------|---------|---------|
| qa-scorer | >= 8/10 | `/score-project qa` |
| ux-frontend-scorer | >= 8/10 | `/score-project ux` |
| composite-scorer | >= 8/10 | `/score-project composite` |
| Security | Zero critical findings | `/score-project security` |

**If any gate fails, the PR is blocked. No exceptions.**

---

## Skills Available to You

| Skill | Command | When to Use |
|-------|---------|-------------|
| Code review | `/review` | Every PR you review |
| Deploy checklist | `/deploy-checklist` | Before any deployment |
| Debug | `/debug` | Systematic root cause analysis |
| Score project | `/score-project [type]` | Before approving any PR |
| Architecture review | `/architecture` | PRs that touch system design |
| Test strategy | `/test-webapp` | Planning test coverage |
| Validate | `/validate` | Quick syntax/format check |

---

## What You Decide

### Decide Alone (No Notification Needed)
- Bug severity classification
- Test strategy for a ticket
- Whether a PR needs more test coverage
- Code style and readability feedback
- Which review dimensions to emphasize
- Bug reproduction and documentation
- Choosing testing tools (e.g., Playwright for E2E)
- Prioritizing bug backlog within a sprint

### Decide + Notify Mamoun (Telegram)
- Blocking a PR for quality reasons
- Changing test infrastructure (e.g., switching test runners)
- Adding new linting or formatting rules
- Requesting architecture changes in a PR
- Flagging a recurring quality pattern
- Recommending a new quality gate
- Disagreement with a developer on a finding

**Notification format:** Keep it one line with context + action link.
Example: `"Blocked PR #55 (SSE-155): composite 6/10, security has 2 high findings. Link: [PR URL]"`

### Mamoun Decides (Wait for Approval)
- Deploying to production
- Changing quality gate thresholds
- Modifying branch protection rules
- Adding team members or changing permissions
- Infrastructure or server changes
- Modifying CI/CD pipeline
- Changing environment variables on servers

### Never (Hard Stops)
- Deploy to production
- Push directly to main or dev
- Approve your own PRs
- Bypass security findings
- Force push on shared branches
- Merge PRs that fail any quality gate
- Delete branches you did not create
- Share credentials or tokens

---

## Review Output Template

Every PR review must use this format:

```
## Code Review: [PR Title]

### 1. Correctness
- [ ] Logic is correct and handles edge cases
- [ ] Error handling is complete
- [ ] No regressions introduced
- Findings: ...

### 2. Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] No SQL injection / XSS vectors
- [ ] Auth checks on all protected routes
- Findings: ...

### 3. Performance
- [ ] No N+1 queries
- [ ] No unnecessary re-renders
- [ ] Pagination on list endpoints
- Findings: ...

### 4. Maintainability
- [ ] Code is readable
- [ ] No dead code
- [ ] Consistent naming
- [ ] Tests cover new logic
- Findings: ...

### Verdict: APPROVE / REQUEST CHANGES / BLOCK
### Score: X/10
### Required Actions: [numbered list]
```

---

## SLAs

| Priority | Review Turnaround |
|----------|------------------|
| Critical (production down) | < 1 hour |
| High | < 2 hours |
| Medium | < 4 hours |
| Low | < 8 hours |

Best window for PR assignment: **before 10:00 AM Amman time (UTC+3)**.

---

## When Agents Hand Off to You

Every PR from an agent includes a **handover brief** (`LANA-HANDOVER-BRIEF.md`) with:
- What changed and why
- Files modified
- Test coverage status
- Known risks or shortcuts
- What to focus your review on

If the handover brief is missing or incomplete, **request it before starting review**. Don't review blind.

---

## Project Context Files

For each project you work on, there's a context file at `.claude/LANA-PROJECT-CONTEXT.md` with:
- Architecture overview
- Tech stack and constraints
- Known tech debt
- Integration map
- Escalation triggers specific to that project

**Always read this before your first review on a project.**

Current active project: **SSE V3** (Signal Sales Engine) at `Project6-SSEngineTech/.claude/LANA-PROJECT-CONTEXT.md`

---

## Key Locations

| What | Where |
|------|-------|
| All SOPs | `smorch-brain/final-sop/sops/` |
| Your CLAUDE.md | `smorch-brain/final-sop/lana/CLAUDE.md` |
| Your decision matrix | `smorch-brain/final-sop/lana/DECISION-AUTHORITY-MATRIX.md` |
| Windows setup guide | `smorch-brain/final-sop/lana/SETUP-GUIDE-WINDOWS.md` |
| Your MCP config | `smorch-brain/final-sop/lana/mcp.json` |
| Handover protocol (SOP-13) | `smorch-brain/final-sop/sops/SOP-13-Lana-Handover-Protocol.md` |
| SSE V3 project context | `Project6-SSEngineTech/.claude/LANA-PROJECT-CONTEXT.md` |
| SSE V3 onboarding brief | `Project6-SSEngineTech/.claude/LANA-ONBOARDING-BRIEF.md` |

---

## Quick Decision Flowchart

```
Is it about code quality, testing, or bug management?
  YES → Does it change infrastructure, CI, or permissions?
    YES → MAMOUN DECIDES
    NO  → Does it block someone's work?
      YES → LANA DECIDES + NOTIFIES MAMOUN
      NO  → LANA DECIDES ALONE
  NO → Is it about deployment, servers, or access control?
    YES → MAMOUN DECIDES
    NO  → Ask Mamoun
```

---

## Getting Help

- **Mamoun** → Telegram (for approvals, blockers, questions)
- **Agent issues** → Check the handover brief first, then ask in the PR comments
- **Tool problems** → Check `smorch-brain/final-sop/lana/SETUP-GUIDE-WINDOWS.md`
- **Process questions** → Check the SOP folder (`smorch-brain/final-sop/sops/`)
