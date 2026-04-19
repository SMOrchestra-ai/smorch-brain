# Lana Al-Kurd -- QA Lead / Claude Code Configuration

## Platform
You are running on Windows. Use forward slashes in paths. Use Git Bash for terminal commands. Never generate macOS or Linux-specific paths (no /Users/, no /home/).

## Role Definition
Lana Al-Kurd is the QA Lead for SMOrchestra.ai engineering projects. Her primary responsibilities:
- Code review and quality assurance for all PRs
- Security audit before any deployment
- Bug identification, documentation, and tracking via Linear
- Maintaining quality gates across all projects
- Testing strategy and test coverage oversight

## Quality Gates

All work must pass these thresholds before approval:

| Scorer | Minimum | Command |
|--------|---------|---------|
| qa-scorer | >= 8/10 | `/score-project qa` |
| ux-frontend-scorer | >= 8/10 | `/score-project ux` |
| composite-scorer | >= 8/10 | `/score-project composite` |
| Security | Zero critical findings | `/score-project security` |

If any score is below threshold, the PR is blocked until fixed. No exceptions.

## Bug Report Template

When filing bugs in Linear, use this format:

```
**Title**: [COMPONENT] Brief description of the defect

**Severity**: Critical / High / Medium / Low
**Environment**: [branch, commit hash, OS]
**Steps to Reproduce**:
1.
2.
3.

**Expected Behavior**:
**Actual Behavior**:
**Evidence**: [screenshot, error log, test output]

**Root Cause Hypothesis**: [if known]
**Suggested Fix**: [if known]
**Affected Users/Flows**: [which user journeys break]
```

## Review Output Format

Use the engineering:code-review 4-dimension framework for all reviews:

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
- [ ] No blocking operations in hot paths
- Findings: ...

### 4. Maintainability
- [ ] Code is readable without excessive comments
- [ ] No dead code
- [ ] Consistent naming conventions
- [ ] Tests cover new logic
- Findings: ...

### Verdict: APPROVE / REQUEST CHANGES / BLOCK
### Score: X/10
### Required Actions: [numbered list if not approved]
```

## Required Skills

These skills must be available in Claude Code:
- `smorch-dev:smo-scorer (qa-hat)` -- primary quality scoring
- `smorch-dev:smo-scorer (ux-hat)` -- frontend quality
- `smorch-dev:smo-scorer` -- overall composite score
- `smorch-dev:smo-scorer (engineering-hat)` -- engineering quality
- `smorch-dev:smo-scorer (architecture-hat)` -- architecture review
- `engineering:code-review` -- structured review framework
- `engineering:deploy-checklist` -- pre-deploy verification
- `engineering:testing-strategy` -- test planning
- `engineering:debug` -- structured debugging
- `superpowers:systematic-debugging` -- root cause analysis (moved from smorch-dev → superpowers upstream plugin; invoked via /smo-triage)

## Branch Naming Convention

```
human/lana/TASK-XXX-description
```

Examples:
- `human/lana/SSE-142-fix-signal-dedup`
- `human/lana/SSE-155-add-webhook-validation`

## Hard Rules

1. **Never push directly to main or dev.** Always create a branch and PR.
2. **Never approve your own code.** All PRs require review from Mamoun or another team member.
3. **Never skip security audit.** Run security scoring before marking any PR as ready.
4. **Never commit secrets.** No API keys, tokens, passwords, or credentials in code. If detected, immediately revoke and rotate.
5. **Never force push.** No `git push --force` or `git reset --hard` on shared branches.
6. **Never merge without passing CI.** All checks must be green.
7. **Never delete branches you did not create.**

## Decision Authority

### Lana Decides Alone
- Bug severity classification
- Test strategy for a ticket
- Whether a PR needs more test coverage
- Code style feedback
- Which review dimensions to emphasize

### Lana Decides + Notifies Mamoun
- Blocking a PR for quality reasons
- Changing test infrastructure
- Adding new linting or formatting rules
- Requesting architecture changes in a PR

### Mamoun Decides
- Deploying to production
- Changing quality gate thresholds
- Modifying branch protection rules
- Adding new team members or changing permissions
- Any infrastructure or server changes

### Lana Never
- Deploy to production
- Modify CI/CD pipeline configuration
- Change environment variables on servers
- Approve PRs without running all quality gates
- Bypass security findings

## Workflow Integration

### On Receiving a PR to Review
1. Pull the branch locally
2. Run `/score-project composite` -- check all gates
3. Run `/review` using the 4-dimension framework
4. If score < 8 on any dimension, add specific feedback and request changes
5. If all gates pass, approve with the review output attached

### On Filing a Bug
1. Reproduce on the latest `dev` branch
2. Fill out the bug template above
3. Tag with severity and affected component
4. If Critical: message Mamoun on Telegram immediately
5. Create Linear issue with the bug report

### On Starting a New Task
1. `git checkout dev && git pull origin dev`
2. `git checkout -b human/lana/TASK-XXX-description`
3. Read the Linear ticket fully before starting
4. Check the project CLAUDE.md for context
5. Work, commit often, push when ready for review
