# SOP-06: Team Distribution — Human Collaboration Protocol

**Version:** 1.0
**Date:** March 2026
**Owner:** Mamoun Alamouri
**Scope:** Every project in the SMOrchestra GitHub org
**Team Member:** Lana Al-Kurd (@lanaalkurdsmo on GitHub)
**PM Tool:** Linear (SMOrchestra workspace)
**Skills Used:** `/linear`, Linear MCP tools

---

## When to Involve Lana

Claude Code MUST ask Mamoun before involving Lana. The question format:

> "This task would benefit from human review/QA/debugging. Should I invite Lana (@lanaalkurdsmo) to collaborate? Specifically for: [list what you need]."

### Tasks That SHOULD Involve Lana

| Task Type | Lana's Role | Why Human Needed |
|-----------|------------|-----------------|
| **Code Review** | Review agent PRs before merge | Human judgment on intent alignment, security, architecture |
| **QA Testing** | Run functional tests, verify UI, test Arabic RTL | Humans catch UX issues AI misses |
| **User Testing** | Test as a real user, report bugs with screenshots | AI can't be a real user |
| **Debugging** | Investigate `needs-human-debug` PRs | Complex bugs need human context |
| **Client Demos** | Test the demo path, verify it works end-to-end | Client-facing quality requires human eyes |
| **Documentation Review** | Review docs for accuracy and clarity | Humans catch confusing explanations |

### Tasks That Should NOT Involve Lana

| Task Type | Why |
|-----------|-----|
| Code writing | Claude Code handles this |
| Automated testing | CI and Playwright handle this |
| Git operations | Claude Code and hooks handle this |
| CHANGELOG generation | Automated |
| Architecture decisions | Mamoun's domain |
| Client communication | Mamoun's domain |

---

## How to Create Tasks for Lana

### Step 1: Mamoun Approves
Ask Mamoun: "Should I create a task for Lana?"

### Step 2: Create Linear Ticket
If Mamoun says yes, use the Linear MCP:

```
Create a Linear issue with:
- Title: [TASK-TYPE]: [description]
- Description: [full context, what to do, what to look for]
- Assignee: Lana Al-Kurd
- Priority: [Urgent/High/Medium/Low]
- Label: [review/qa/debug/testing]
- Project: [current project name]
```

### Step 3: Include Context in the Ticket

Every ticket for Lana must include:

```markdown
## What to Do
[Clear, specific instructions]

## Where to Look
[File paths, URLs, branch name]

## What to Check For
[Specific things to verify]

## How to Report Back
1. Comment on this ticket with findings
2. If bugs found: create sub-issues with screenshots
3. If approved: comment "QA PASS" and close

## Branch
[branch name to checkout and test]

## Time Estimate
[X] minutes
```

### Step 4: Notify
After creating the ticket, Claude Code reports to Mamoun:
> "Created Linear ticket TASK-XXX for Lana: [title]. Assigned as [priority]. She'll need [estimated time]."

---

## Task Templates for Lana

### Code Review Task
```markdown
Title: REVIEW: [PR title]
Description:
## PR to Review
[PR URL]

## What Changed
[Summary of changes — 3-5 bullets]

## Risk Tier
[HIGH/MEDIUM/LOW] — [reason]

## What to Check
- [ ] Code does what the spec says
- [ ] No files touched outside declared scope
- [ ] No hardcoded secrets or credentials
- [ ] Error handling is appropriate
- [ ] Tests cover the main scenarios
- [ ] Arabic RTL renders correctly (if applicable)

## How to Report
- Comment on the PR with findings
- Use CRITICAL, SUGGESTION, GOOD format
- End with APPROVE / REQUEST CHANGES / BLOCK
```

### QA Testing Task
```markdown
Title: QA: [feature/page name]
Description:
## What to Test
[Feature description]

## Test Environment
Branch: [branch]
URL: [if deployed] or run locally: [commands]

## Test Checklist
- [ ] Happy path works end-to-end
- [ ] Error states handled (invalid input, empty data)
- [ ] Mobile responsive
- [ ] Arabic RTL (if applicable)
- [ ] All buttons/links work
- [ ] Data persists correctly

## How to Report
Create sub-issues for each bug found:
- Title: BUG: [short description]
- Screenshot attached
- Steps to reproduce
- Expected vs actual behavior
```

### Debug Task
```markdown
Title: DEBUG: [issue description]
Description:
## The Problem
[What's broken]

## What Claude Code Tried
[What the self-fix loop attempted]

## Error Logs
[Paste relevant logs]

## Where to Look
[File paths, function names]

## How to Report
- Comment with root cause analysis
- If you can fix it: create a branch `human/lana/TASK-XXX-fix` and push
- If you need more info: comment with questions
```

---

## Collaboration Workflow

```
1. Claude Code completes feature/fix
2. Claude Code runs SOP-2 (Pre-Upload Scoring)
3. Score meets threshold → Claude Code creates PR
4. Claude Code asks Mamoun: "Should Lana review?"
5. If yes → Claude Code creates Linear ticket
6. Lana reviews/tests/debugs
7. Lana reports back (Linear comment or PR review)
8. Claude Code reads Lana's feedback
9. Claude Code fixes issues raised
10. Mamoun approves final merge
```

---

## GitHub Access for Lana

### Current Setup (GitHub Team Plan — Decided March 31, 2026)
- GitHub: @lanaalkurdsmo
- Org: SMOrchestra-ai (GitHub Team Plan, $4/user/month)
- Team: `engineering` (write access to all repos)
- Review permissions: Can approve PRs on dev
- Branch protection: Enforced by GitHub Team Plan (required reviewers + CODEOWNERS)
- Role definition: See SOP-5 (Dev Roles & Hierarchy)

### What Lana Can Do
- Review and comment on PRs
- Create branches (`human/lana/TASK-XXX-slug`)
- Push to her own branches
- Create issues
- Run local tests

### What Lana Cannot Do (MAMOUN-REQUIRED)
- Merge to dev or main
- Modify infra/, auth/, billing/
- Change branch protection
- Create or delete repos
- Modify CODEOWNERS

---

## MAMOUN-REQUIRED Actions in This SOP

| Action | Requires Mamoun |
|--------|----------------|
| Deciding to involve Lana on a task | YES — always ask first |
| Creating tickets for Lana | After Mamoun approves |
| Changing Lana's GitHub permissions | YES |
| Adding new team members | YES |
| Approving Lana's review of HIGH risk PRs | YES — Mamoun still reviews HIGH risk |
| Final merge decision | YES — Lana recommends, Mamoun decides |

---

## SLA / Turnaround Expectations

| Task Type | Expected Turnaround | Escalation If Missed |
|-----------|-------------------|---------------------|
| Code review (MEDIUM risk) | 4 hours | Mamoun reviews instead |
| Code review (HIGH risk) | 2 hours | Mamoun reviews regardless |
| QA testing | 8 hours (same business day) | Claude Code runs automated QA as fallback |
| Debugging | 24 hours | Mamoun + Claude Code pair-debug |
| User testing | 48 hours | Defer to next sprint |

### If Lana Is Unavailable
1. Claude Code asks Mamoun: "Lana is not responding to TASK-XXX (assigned [X] hours ago). Options: (A) I run automated QA/review, (B) You review, (C) Extend deadline."
2. Mamoun decides.
3. For code review: Claude Code's `code-reviewer` agent can provide first-pass review as stopgap.
4. For QA: Claude Code runs `/webapp-testing` + `/score-project` as automated substitute.
5. For user testing: This cannot be substituted. Defer or Mamoun tests.

---

## Escalation

If Lana finds a CRITICAL issue:
1. She comments on the ticket immediately
2. Claude Code reads the comment and assesses
3. Claude Code notifies Mamoun: "Lana found a CRITICAL issue on TASK-XXX: [description]. Recommend: [fix/hold/escalate]."
4. Mamoun decides next step
