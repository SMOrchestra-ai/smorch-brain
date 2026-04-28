# AI-Native GitHub Architecture — Reference Guide
## What 10/10 Looks Like

**Version:** 1.0
**Date:** 2026-03-22
**Author:** Mamoun Alamouri + Claude Code
**Purpose:** Complete reference for building and maintaining a perfect-score AI-Native GitHub setup for agentic coding teams

---

## Who This Guide Is For

- **Founders** running AI-assisted development with small teams (1-5 humans + AI agents)
- **Solo operators** using Claude Code / OpenClaw for agentic coding
- **Teams** that need to know exactly what to set up, why, and how to maintain it

This guide covers everything from org setup to daily operations. Each section explains what the 10/10 standard is, why it matters, and how to achieve it.

---

## Table of Contents

1. [Organization Setup](#1-organization-setup)
2. [Repository Architecture](#2-repository-architecture)
3. [Branch Model](#3-branch-model)
4. [Version Control & SemVer](#4-version-control--semver)
5. [Release Protocol](#5-release-protocol)
6. [Documentation Standards](#6-documentation-standards)
7. [AGENTS.md — The AI-Native Standard](#7-agentsmd--the-ai-native-standard)
8. [Commit Conventions](#8-commit-conventions)
9. [PR & Issue Templates](#9-pr--issue-templates)
10. [Branch Protection Rules](#10-branch-protection-rules)
11. [Repository Lifecycle](#11-repository-lifecycle)
12. [Multi-Repo Coordination](#12-multi-repo-coordination)
13. [CI/CD for AI-Native Teams](#13-cicd-for-ai-native-teams)
14. [Daily Operations Checklists](#14-daily-operations-checklists)
15. [Anti-Patterns — What NOT to Do](#15-anti-patterns--what-not-to-do)
16. [Scoring Rubric — Rate Your Setup](#16-scoring-rubric--rate-your-setup)

---

## 1. Organization Setup

### What 10/10 looks like:
- Org name, description, email, URL all configured
- Profile README (`.github/profile/README.md`) visible on org page
- Teams defined with clear ownership roles
- Default repository settings configured (default branch = `dev`, features enabled)

### Teams Structure

| Team | Role | Access Level |
|------|------|-------------|
| **engineering** | All human developers | Write on all repos |
| **agents** | Service accounts for AI agents | Write on repos they work on |
| **reviewers** | Humans authorized to approve merges | Maintain on all repos |
| **admin** | Org owner (Mamoun) | Admin on all repos |

### Why it matters:
Teams control who can merge, who can review, and who gets notified. Without teams, you're relying on individual permissions which don't scale and can't be audited.

### How to set it up:
```bash
# Set org metadata
gh api -X PATCH orgs/YOUR-ORG -f name="Company Name" \
  -f description="What your org does" \
  -f email="contact@company.com" \
  -f blog="https://company.com"

# Create teams (if not already done)
gh api -X POST orgs/YOUR-ORG/teams -f name="engineering" -f privacy="closed"
gh api -X POST orgs/YOUR-ORG/teams -f name="agents" -f privacy="closed"
gh api -X POST orgs/YOUR-ORG/teams -f name="reviewers" -f privacy="closed"
```

---

## 2. Repository Architecture

### What 10/10 looks like:

Every product repo has this structure:

```
repo/
  product/                    # Shippable code
    api/                      # REST / GraphQL layers
    services/                 # Core business logic
    workers/                  # Background jobs
    ui/                       # Frontend

  agents/                     # Agent configuration
    openclaw/                 # OpenClaw queue config
    claude/                   # Claude Code session config
    experiments/              # Throwaway spikes

  prompts/                    # Version-controlled prompts
    codegen/                  # Code generation prompts
    review/                   # Code review prompts
    specs/                    # Spec templates

  specs/                      # Work input files
    tasks/                    # TASK-XXX.md (from Linear/PM tool)
    features/                 # Feature briefs

  tests/                      # All tests
  infra/                      # LOCKED — deployment, CI, environments
  docs/                       # Architecture decisions, runbooks

  .github/
    CODEOWNERS                # File-level ownership
    PULL_REQUEST_TEMPLATE.md  # Standardized PR format
    ISSUE_TEMPLATE/
      bug.md                  # Bug report template
      feature.md              # Feature request template
      task.md                 # Task template
    workflows/
      ci.yml                  # CI pipeline

  AGENTS.md                   # AI agent behavior rules
  CHANGELOG.md                # Release history
  CLAUDE.md                   # Claude Code project instructions
  README.md                   # What this repo is
```

### When NOT to scaffold:
- **Skills/config repos** (like smorch-brain): Use a lighter structure — just `skills/`, `profiles/`, `scripts/`, `docs/`
- **Template repos**: Scaffold is the template itself
- **Archive repos**: Don't scaffold, just add README + description and archive

### Directory ownership rules:

| Directory | Owner | Rules |
|-----------|-------|-------|
| `product/` | Engineering + agents | Normal development |
| `agents/` | OpenClaw system | Humans don't edit directly |
| `prompts/` | Mamoun (or tech lead) | Changes via PR only |
| `specs/tasks/` | Auto-generated from PM tool | Mamoun approves before execution |
| `infra/` | LOCKED | 2 human approvals minimum |
| `docs/` | Anyone | Low-risk, async review OK |

---

## 3. Branch Model

### What 10/10 looks like:

```
main (protected) ← Tagged releases only
  ↑
dev (protected, default) ← Integration branch, always deployable to staging
  ↑
human/[name]/TASK-XXX-slug     ← Human work
agent/TASK-XXX-slug            ← AI agent work
sandbox/[experiment]           ← Exploration, never merges
hotfix/[slug]                  ← Production emergencies → main AND dev
```

### Branch naming rules:

| Pattern | Created By | Purpose | Merges Into |
|---------|-----------|---------|-------------|
| `main` | Protected | Production, tagged releases | Never directly |
| `dev` | Protected | Integration, staging | main via release PR |
| `human/[name]/TASK-XXX-slug` | Individual developer | Human development | dev |
| `agent/TASK-XXX-slug` | OpenClaw / automation | AI agent execution | dev |
| `feature/[name]` | Developer | Larger feature work | dev |
| `sandbox/[experiment]` | Anyone | Exploration | Deleted when done |
| `hotfix/[slug]` | Tech lead / owner | Production emergency | main AND dev |

### Critical rules:
1. **OpenClaw never commits to human/* branches**
2. **Humans never commit to agent/* branches**
3. **Nobody pushes directly to dev or main**
4. **hotfix/* branches merge to BOTH main and dev to prevent drift**
5. **Branch TTL: 48 hours** — unmerged branches get flagged and reviewed

---

## 4. Version Control & SemVer

### What 10/10 looks like:
Every meaningful release has a SemVer tag AND a GitHub Release with notes.

### SemVer explained:

```
v[MAJOR].[MINOR].[PATCH]

MAJOR (v1 → v2 → v3):
  - Breaking changes
  - Complete rewrites
  - Architecture overhauls
  - When: "users need to change how they use this"

MINOR (v3.0 → v3.1 → v3.2):
  - New features
  - New endpoints
  - Significant enhancements
  - When: "users get something new but nothing breaks"

PATCH (v3.1.0 → v3.1.1 → v3.1.2):
  - Bug fixes
  - Performance improvements
  - Documentation updates
  - When: "we fixed something, nothing new"
```

### When to create a new repo vs new version:

| Scenario | Action | Example |
|----------|--------|---------|
| Complete rewrite of same product | **New major version in SAME repo** | SaaSFast v2 → v3 in one repo |
| New product that shares no code | **New repo** | eo-assessment-system is separate from SaaSFast |
| Sub-app that deploys independently | **New repo** | Scorecard app fronted by SaaSFast = separate repo |
| Fork for different market/client | **New repo** (not a GitHub fork) | Different deployment, different lifecycle |
| Experimental rewrite you might abandon | **Branch** (`sandbox/v2-experiment`) | Explore in branch, promote to tag if it works |

### The golden rule:
**One product = one repo. Versions are tags, not repos.**

Creating `product-v2` as a separate repo splits your git history, doubles maintenance, and creates confusion about which is canonical. Tag versions. Archive old code if needed. Never duplicate repos for versions.

---

## 5. Release Protocol

### What 10/10 looks like:

Every release follows this exact sequence:

```
1. dev is stable
   ├── All target PRs merged
   ├── CI passing
   └── Manual testing complete

2. Create release PR: dev → main
   ├── Title: "Release vX.Y.Z"
   ├── Body: what changed, what was tested, known risks
   └── Reviewer: product owner / tech lead

3. Owner reviews and approves

4. Merge to main (merge commit, NOT squash)
   └── Preserving the merge commit gives you a clean release point

5. Tag the release
   git tag -a vX.Y.Z -m "Release title and summary"
   git push origin vX.Y.Z

6. Create GitHub Release
   gh release create vX.Y.Z --title "vX.Y.Z — Release Title" \
     --notes-file RELEASE_NOTES.md

7. Update CHANGELOG.md on dev
   ├── Add release entry
   └── Commit: docs: add vX.Y.Z changelog entry

8. CI/CD deploys from tag (if configured)
```

### CHANGELOG.md format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [v3.0.0] — 2026-03-22

### Added
- Multi-config system (storefront/template modes)
- Product catalog with Supabase schema
- Customer dashboard with 10-stage PipelineTracker
- 5-step onboarding wizard
- Admin dashboard with role-gated access
- White-label template system
- 100+ Arabic RTL translation keys

### Changed
- Renamed config structure for multi-deployment support

### Fixed
- RTL layout issues in pricing components

### Breaking Changes
- Config format changed — migration required from v2.x

---

## [v2.0.0] — 2026-02-15

### Added
- Arabic RTL support
- Supabase authentication
...
```

### Why GitHub Releases matter (not just tags):
- **Visibility:** Releases appear on the repo homepage. Tags don't.
- **Discoverability:** Anyone browsing the repo sees the latest release immediately.
- **Release notes:** Releases support formatted markdown notes, assets, and pre-release flags.
- **API access:** External tools can query releases. CI/CD can trigger from releases.
- **A tag without a release is invisible** — it exists in git but nobody sees it unless they know to look.

---

## 6. Documentation Standards

### What 10/10 looks like:

Every repo has these documents:

| Document | Location | Purpose | Who Maintains |
|----------|----------|---------|---------------|
| **README.md** | Root | What this is, how to run it, architecture overview | Engineering |
| **CHANGELOG.md** | Root | Release history | Auto-generated + reviewed |
| **AGENTS.md** | Root | AI agent behavior rules | Tech lead |
| **CLAUDE.md** | Root or `.claude/` | Claude Code project context | Developer |
| **ARCHITECTURE.md** | `docs/` | System architecture, data flow, decisions | Tech lead |
| **ADR-XXX.md** | `docs/adr/` | Architecture Decision Records | Whoever made the decision |
| **CODEOWNERS** | `.github/` | File-level ownership | Tech lead |

### README.md template:

```markdown
# [Product Name]

One-sentence description of what this product does.

## Status
- **Version:** vX.Y.Z
- **Environment:** Production / Staging / Development
- **CI:** passing/failing badge

## Quick Start
\`\`\`bash
# How to run locally in 3 commands or less
\`\`\`

## Architecture
Brief description + link to docs/ARCHITECTURE.md

## Development
- Branch from `dev`
- Follow conventional commits
- See AGENTS.md for AI agent rules

## Release History
See [CHANGELOG.md](CHANGELOG.md)
```

### Architecture Decision Records (ADRs):

ADRs document WHY you made a decision, not just WHAT. Format:

```markdown
# ADR-001: [Decision Title]

**Date:** 2026-03-22
**Status:** Accepted / Superseded / Deprecated
**Decision maker:** [Name]

## Context
What situation or problem prompted this decision?

## Decision
What did we decide?

## Consequences
What are the trade-offs? What do we gain? What do we lose?

## Alternatives Considered
What else could we have done and why didn't we?
```

---

## 7. AGENTS.md — The AI-Native Standard

### What it is:
AGENTS.md is the emerging standard (adopted by 20,000+ repos as of 2026) for declaring how AI coding agents should behave in a repository. It's the AI equivalent of CONTRIBUTING.md.

### What 10/10 looks like:

```markdown
# AGENTS.md

## Overview
This repository uses AI agents (Claude Code via OpenClaw) for automated development tasks.

## Agent Behavior Rules

### Scope
- Agents work ONLY on files declared in their task spec
- Any diff outside declared scope triggers high-risk review
- Agents do NOT modify: infra/, auth/, billing/, security/

### Branches
- Agents create branches as: agent/TASK-XXX-slug
- Agents NEVER commit to human/* branches
- Agents NEVER push to dev or main directly

### Commits
- Format: agent(TASK-XXX): description of change
- Every commit lists modified files
- Commits happen incrementally, not just at session end

### Session Rules
- Maximum session duration: 60 minutes
- One task per session
- Context: task spec file only (no global repo context)

### Self-Fix Protocol
- If CI fails, agent gets one self-fix attempt
- Self-fix includes: original spec + full failure log
- If self-fix also fails: PR flagged as needs-human-debug

### Review Requirements
- All agent PRs labelled: agent-generated
- High risk (>200 lines, out-of-scope, self-fixed): owner reviews
- Medium risk (in-scope, <200 lines): any senior reviewer
- Low risk (tests, docs, prompts): async review

## Tools & Configuration
- **Orchestrator:** OpenClaw
- **Agent:** Claude Code (Opus)
- **CI:** GitHub Actions
- **PM:** Linear

## Prohibited Actions
- Agents MUST NOT create new repos
- Agents MUST NOT modify CI/CD configuration
- Agents MUST NOT change environment variables
- Agents MUST NOT access production credentials
```

### Why AGENTS.md matters:
Without it, every AI agent that touches your repo has to guess the rules. With it, the rules are explicit, version-controlled, and enforceable. It's the difference between "the agent broke something" and "the agent followed the documented protocol."

---

## 8. Commit Conventions

### What 10/10 looks like:

Conventional Commits format, enforced by git hooks:

```
[type](TASK-XXX): short description (imperative mood)

Optional body explaining WHY, not WHAT.

Co-Authored-By: name <email>  (if applicable)
```

### Types:

| Type | When | Example |
|------|------|---------|
| `feat` | New feature | `feat(TASK-184): add retry logic to queue consumer` |
| `fix` | Bug fix | `fix(TASK-201): resolve null pointer on empty payload` |
| `refactor` | Code restructure, no behavior change | `refactor: extract scoring engine to separate module` |
| `test` | Adding/fixing tests | `test(TASK-184): add retry exhaustion test` |
| `docs` | Documentation only | `docs: add ADR-001 multi-tenant decision` |
| `chore` | Dependencies, config, tooling | `chore: upgrade supabase-js to v2.45` |
| `agent` | All OpenClaw/AI commits | `agent(TASK-184): implement backoff per spec` |
| `hotfix` | Production emergency | `hotfix: fix auth token expiry check` |

### Rules:
1. **Imperative mood:** "add retry logic" not "added retry logic"
2. **Why, not what:** The diff shows WHAT changed. The message explains WHY.
3. **One concern per commit:** Don't bundle unrelated changes.
4. **Reference the task:** Always include TASK-XXX when one exists.
5. **Agent commits specify files:** `agent(TASK-184): implement backoff — workers/queue.go`

---

## 9. PR & Issue Templates

### PR Template (`.github/PULL_REQUEST_TEMPLATE.md`):

```markdown
## Summary
<!-- What changed and why? 1-3 bullet points. -->

## Task Reference
<!-- Link to Linear ticket or task spec -->
TASK-XXX

## Changes
<!-- List files changed and what each change does -->

## Testing
- [ ] Unit tests pass
- [ ] Manual testing completed
- [ ] No regressions

## Risk Assessment
- [ ] Touches only declared files
- [ ] Diff under 200 lines
- [ ] No infra/auth/billing changes

## Screenshots
<!-- If UI changes, add before/after -->
```

### Issue Templates:

**Bug Report** (`.github/ISSUE_TEMPLATE/bug.md`):
```markdown
---
name: Bug Report
about: Something isn't working correctly
labels: bug
---

## Description
<!-- What's broken? -->

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
<!-- What should happen? -->

## Actual Behavior
<!-- What actually happens? -->

## Environment
- Browser/OS:
- Version:
```

**Feature Request** (`.github/ISSUE_TEMPLATE/feature.md`):
```markdown
---
name: Feature Request
about: Suggest a new capability
labels: enhancement
---

## Problem
<!-- What problem does this solve? -->

## Proposed Solution
<!-- How should it work? -->

## Alternatives Considered
<!-- What else could solve this? -->

## Impact
<!-- Who benefits? How much? -->
```

**Task** (`.github/ISSUE_TEMPLATE/task.md`):
```markdown
---
name: Task
about: Internal development task
labels: task
---

## Goal
<!-- One sentence: what needs to happen? -->

## Scope
<!-- Which files/modules are affected? -->

## Constraints
<!-- What must NOT change? -->

## Acceptance Criteria
- [ ]
- [ ]
```

---

## 10. Branch Protection Rules

### What 10/10 looks like:

**main branch:**
| Rule | Setting |
|------|---------|
| Require PR before merge | YES |
| Required approving reviews | 1 (increase to 2 for teams >3) |
| Dismiss stale PR reviews | YES |
| Require status checks to pass | YES (CI must pass) |
| Enforce for admins | YES |
| Allow force pushes | NO |
| Allow deletions | NO |

**dev branch:**
| Rule | Setting |
|------|---------|
| Require PR before merge | YES |
| Required approving reviews | 1 |
| Require status checks to pass | YES |
| Enforce for admins | NO (owner can emergency merge) |
| Allow force pushes | NO |
| Allow deletions | NO |

### How to configure:
```bash
# Protect main
gh api -X PUT repos/ORG/REPO/branches/main/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f required_pull_request_reviews[dismiss_stale_reviews]=true \
  -f enforce_admins=true \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]="ci"

# Protect dev
gh api -X PUT repos/ORG/REPO/branches/dev/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f enforce_admins=false
```

---

## 11. Repository Lifecycle

### When to create a new repo:

| Scenario | Decision |
|----------|----------|
| New product | New repo |
| New major version of existing product | **Same repo, new tag** |
| Sub-app that deploys independently | New repo |
| Shared library used by multiple products | New repo |
| Template/boilerplate | New repo (mark as template) |
| Experiment that might not ship | **Branch** (`sandbox/`) |

### New repo checklist:

```
[ ] Create repo with dev as default branch
[ ] Add description and topics
[ ] Add to appropriate team (engineering/agents)
[ ] Create main branch, set protection rules
[ ] Add CLAUDE.md with project context
[ ] Add AGENTS.md with agent rules
[ ] Add README.md
[ ] Add CHANGELOG.md (start at v0.1.0)
[ ] Add .github/CODEOWNERS
[ ] Add .github/PULL_REQUEST_TEMPLATE.md
[ ] Add .github/ISSUE_TEMPLATE/ (bug, feature, task)
[ ] Add .github/workflows/ci.yml
[ ] Add architecture scaffold (if product repo)
[ ] Create initial tag: v0.1.0
[ ] Create GitHub Release for v0.1.0
```

### Archiving repos:
When a repo is no longer active:
1. Ensure README explains why it's archived
2. Add final CHANGELOG entry
3. Archive via `gh repo archive ORG/REPO`
4. Do NOT delete — history has value

---

## 12. Multi-Repo Coordination

### The problem:
Multiple products (SaaSFast, eo-assessment-system, CXMfast, etc.) share infrastructure, design systems, or APIs. A change in one might affect another.

### What 10/10 looks like:

**Shared dependencies documented:**
- Each repo's README lists its dependencies on other repos
- API contracts between repos are documented in `docs/api-contracts/`
- Breaking changes in one repo trigger notifications to dependent repos

**Version coordination:**
- Repos that depend on each other reference specific versions
- Shared packages are versioned independently
- Release notes in one repo reference related releases in others

**Cross-repo ADRs:**
When a decision affects multiple repos, the ADR lives in the org-level documentation repo (e.g., `smorch-brain/docs/adr/`) with links from each affected repo.

---

## 13. CI/CD for AI-Native Teams

### What 10/10 looks like:

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [dev, main]
  pull_request:
    branches: [dev, main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint
        run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test
        run: npm test

  commit-lint:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Validate commit messages
        run: |
          # Check conventional commit format
          git log origin/dev..HEAD --format='%s' | while read msg; do
            if ! echo "$msg" | grep -qE '^(feat|fix|refactor|test|docs|chore|agent|hotfix)(\(.+\))?: .+'; then
              echo "Bad commit: $msg"
              exit 1
            fi
          done

  scope-check:
    runs-on: ubuntu-latest
    if: startsWith(github.head_ref, 'agent/')
    steps:
      - uses: actions/checkout@v4
      - name: Verify agent stayed in scope
        run: |
          # Compare diff against declared spec files
          # Flag if agent touched files outside spec
          echo "Scope check for agent branch"
```

### Agent-specific CI considerations:
1. **Scope checking:** Verify agent PRs only touch declared files
2. **Self-fix loop:** On CI failure, feed error back to agent for one retry
3. **Auto-labeling:** Agent PRs get `agent-generated` label automatically
4. **Risk scoring:** Calculate risk tier from diff size, file locations, scope compliance

---

## 14. Daily Operations Checklists

### Start of day:
```
[ ] Check for open PRs needing review
[ ] Check for branch TTL violations (>48 hours)
[ ] Check CI status on dev branch
[ ] Review any needs-human-debug PRs
```

### Before starting new work:
```
[ ] Create task/ticket first (Linear, GitHub Issue, etc.)
[ ] Check for file conflicts with active agent branches
[ ] Pull latest dev
[ ] Create branch with correct naming convention
```

### Before merging:
```
[ ] PR has description and task reference
[ ] CI passes
[ ] Reviewer approved
[ ] CHANGELOG updated (for releases)
[ ] No scope violations
```

### Release day:
```
[ ] All target PRs merged to dev
[ ] Dev is stable and tested
[ ] Create release PR: dev → main
[ ] Owner reviews and approves
[ ] Merge to main (merge commit, not squash)
[ ] Tag: git tag -a vX.Y.Z -m "description"
[ ] Push tag: git push origin vX.Y.Z
[ ] Create GitHub Release with notes
[ ] Update CHANGELOG.md on dev
[ ] Announce to team
```

---

## 15. Anti-Patterns — What NOT to Do

| Anti-Pattern | Why It's Bad | Do This Instead |
|-------------|-------------|-----------------|
| **Create `product-v2` as a new repo** | Splits history, doubles maintenance, creates confusion | Use SemVer tags in the same repo |
| **Push directly to main or dev** | Bypasses review, breaks CI trust | Always use PRs |
| **Create tags without GitHub Releases** | Tags are invisible to casual browsers | Always create a Release for each version tag |
| **Skip CHANGELOG** | Nobody knows what changed or when | Update CHANGELOG with every release |
| **Let branches live forever** | Branch debt, merge conflicts, context loss | 48-hour TTL, enforce cleanup |
| **One massive PR** | Unreviewable, risky, defeats the purpose of review | Small PRs, one concern each |
| **Agent and human on same branch** | Git state corruption, context collision | Strict namespace separation |
| **No AGENTS.md** | Every AI agent guesses the rules | Document agent behavior explicitly |
| **Squash merge to main** | Loses the merge point that marks the release | Use merge commit for dev → main |
| **Skip commit conventions** | Unreadable history, can't auto-generate changelogs | Enforce conventional commits |
| **Archive by deleting** | History lost forever | Archive the repo instead |
| **Fork your own repo** | Forks are for contributing to others' projects | Create a new repo if needed |

---

## 16. Scoring Rubric — Rate Your Setup

Use this rubric to score any GitHub organization on a 10-point scale.

| Dimension | 0 Points | 5 Points | 10 Points |
|-----------|----------|----------|-----------|
| **Org metadata** | Empty | Name + description | Full: name, description, email, URL, profile README |
| **Repo descriptions** | None | Some repos described | All repos have descriptions + topics |
| **Branch model** | Only main | main + dev | main + dev + human/* + agent/* + naming conventions |
| **Branch protection** | None | main protected | main + dev protected, enforced for admins, status checks required |
| **Architecture scaffold** | Flat files | Some directories | Full v2 scaffold with ownership rules |
| **Version control** | No tags | Some tags | SemVer tags + GitHub Releases for every version |
| **CHANGELOGs** | None | Some repos | Every repo, updated with every release |
| **AGENTS.md** | None | Basic rules | Full agent behavior spec with scope, commits, review tiers |
| **PR templates** | None | Basic template | Template with summary, testing, risk assessment, scope check |
| **Issue templates** | None | One template | Bug, feature, task templates |
| **Commit conventions** | Random messages | Mostly consistent | Conventional commits, enforced by hooks/CI |
| **Release protocol** | Push to main | Tags only | Full protocol: PR → merge → tag → Release → CHANGELOG |
| **Documentation** | README only | README + some docs | README + CHANGELOG + AGENTS.md + ARCHITECTURE + ADRs |
| **Teams** | Individual permissions | Some teams | Full team structure with role-based access |

**Scoring:**
- **0-3:** Beginner — repos exist but no discipline
- **4-6:** Functional — basics are there, significant gaps
- **7-8:** Professional — most things right, minor gaps
- **9-10:** AI-Native Production Grade — complete discipline, automated enforcement

---

## Appendix A: Quick Command Reference

```bash
# === DAILY ===
git checkout dev && git pull origin dev          # Start fresh
git checkout -b human/mamoun/TASK-XXX-slug       # Create branch
git commit -m "feat(TASK-XXX): description"      # Commit

# === RELEASES ===
git checkout main && git pull origin main        # Prep for release
gh pr create --base main --head dev \
  --title "Release vX.Y.Z" --body "Release notes" # Release PR
git tag -a vX.Y.Z -m "Release description"       # Tag after merge
git push origin vX.Y.Z                           # Push tag
gh release create vX.Y.Z --title "vX.Y.Z — Title" \
  --notes "Release notes here"                    # Create Release

# === MAINTENANCE ===
gh repo edit ORG/REPO --description "desc"       # Set description
gh repo edit ORG/REPO --add-topic topic1         # Add topics
gh repo archive ORG/REPO                         # Archive repo

# === AUDIT ===
gh repo list ORG --json name,description         # List all repos
gh api repos/ORG/REPO/releases                   # Check releases
gh api repos/ORG/REPO/branches/main/protection   # Check protection
```

---

## Appendix B: File Templates

All templates referenced in this guide are available in the `smorch-brain` repository under `docs/templates/` for use with the `smorch-github-ops` skill.

---

*This guide is a living document. Update it as your architecture evolves. Version it. Practice what it preaches.*
