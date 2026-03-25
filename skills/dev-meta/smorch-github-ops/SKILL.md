---
name: smorch-github-ops
description: "SMOrchestra GitHub Operations Enforcer — enforces the complete AI-Native GitHub Architecture in every Claude Code session. Use whenever working in any git repo to enforce branch naming, conventional commits, SemVer, release protocol, changelog maintenance, documentation standards, and PR management. Triggers on: any git operation, 'commit', 'push', 'release', 'deploy', 'new repo', 'create repo', 'branch', 'merge', 'PR', 'pull request', 'tag', 'version', 'changelog'. This is THE enforcement layer that makes GitHub discipline automatic. Always load this skill at session start when working in any repository."
---

# SMOrchestra GitHub Operations Enforcer

This skill enforces the complete AI-Native GitHub Architecture. Every rule below is mandatory. No exceptions. No shortcuts.

---

## 1. SESSION START CHECKS

Run these checks at the start of every session that touches a git repo.

1. Run `git branch --show-current` to verify the current branch.
2. If on `main` or `dev`, STOP. Do not make changes. Create or switch to a proper working branch first.
3. Run `git status` to check for uncommitted changes from previous sessions. If found, inform the user and ask how to proceed before doing anything else.
4. Run `git fetch origin` to get latest remote state.
5. If creating a new branch, always branch from the latest `dev`: `git checkout dev && git pull origin dev && git checkout -b <branch-name>`.
6. Run `git branch -r | grep agent/` to check for active agent branches. If any touch the same files you plan to modify, warn the user about potential conflicts.

### Session Start Output Template
```
SESSION CHECK:
- Current branch: [branch]
- Branch OK: [yes/no — no if on main or dev]
- Uncommitted changes: [yes/no — list files if yes]
- Remote sync: [up to date / behind by N commits]
- Active agent branches: [list or none]
- Ready to work: [yes/no]
```

---

## 2. BRANCH NAMING ENFORCEMENT

Every branch MUST use one of these prefixes. No exceptions.

| Type | Format | Example |
|------|--------|---------|
| Human work | `human/[name]/TASK-XXX-slug` | `human/mamoun/TASK-042-add-auth` |
| Agent work | `agent/TASK-XXX-slug` | `agent/TASK-015-fix-routing` |
| Feature | `feature/[descriptive-name]` | `feature/signal-scoring-engine` |
| Hotfix | `hotfix/[slug]` | `hotfix/fix-login-crash` |
| Sandbox | `sandbox/[experiment]` | `sandbox/test-new-api` |

### Rules
- NEVER create a branch without a correct prefix from the table above.
- NEVER push directly to `main` or `dev`. Always go through a PR.
- If the user asks to commit to `main` or `dev` directly, refuse and explain: "Direct pushes to main/dev are blocked by our architecture. Create a branch and PR instead."
- When no task ID exists, use a descriptive slug: `feature/add-webhook-handler`.
- Keep slugs lowercase, hyphen-separated, max 5 words.

---

## 3. CONVENTIONAL COMMITS

Every commit message MUST follow this format:

```
[type](TASK-XXX): short description in imperative mood
```

If no task ID exists, omit the parenthetical:

```
[type]: short description in imperative mood
```

### Allowed Types

| Type | Use When |
|------|----------|
| `feat` | Adding new functionality |
| `fix` | Fixing a bug |
| `refactor` | Restructuring code without changing behavior |
| `test` | Adding or updating tests |
| `docs` | Documentation only changes |
| `chore` | Build process, dependencies, CI config |
| `agent` | AI agent generated changes (always specify files modified) |
| `hotfix` | Emergency production fix |

### Rules
- Imperative mood: "add" not "added", "fix" not "fixed", "update" not "updated".
- First letter of description is lowercase.
- No period at the end.
- Max 72 characters for the first line.
- One concern per commit. If you changed auth AND routing, make two commits.
- Agent commits MUST list modified files in the body:
  ```
  agent(TASK-012): add input validation to signup form

  Modified files:
  - src/components/SignupForm.tsx
  - src/utils/validators.ts
  ```
- NEVER commit without following this format. If the user provides a non-conforming message, reformat it before committing.

### Validation Before Committing
Before every `git commit`, verify:
1. Message matches the format above.
2. Type is from the allowed list.
3. Description is imperative mood.
4. One concern per commit (if multiple concerns, split into multiple commits).
5. If agent-generated, files are listed in the body.

---

## 4. VERSION CONTROL (SemVer)

All version numbers follow Semantic Versioning strictly.

| Change Level | When | Example |
|---|---|---|
| MAJOR (X.0.0) | Breaking changes, rewrites, architecture changes | v1.0.0 -> v2.0.0 |
| MINOR (x.Y.0) | New features, backward-compatible additions | v1.0.0 -> v1.1.0 |
| PATCH (x.y.Z) | Bug fixes, docs, performance improvements | v1.0.0 -> v1.0.1 |

### Rules
- Tag format: `vX.Y.Z` (always prefixed with `v`).
- NEVER create a new repo for a new version. Versions are tags, not repos. If the user asks to create `product-v2` as a separate repo, refuse and explain: "Versions are tags on the same repo. Use `git tag v2.0.0` instead of creating a new repo."
- First release of any repo: `v0.1.0`.
- Pre-release tags: `vX.Y.Z-alpha.1`, `vX.Y.Z-beta.1`, `vX.Y.Z-rc.1`.
- Every tag MUST have a corresponding GitHub Release.

---

## 5. RELEASE PROTOCOL

When the user says "release", "deploy to main", "ship it", or "push to production", execute this sequence exactly:

### Step 1: Pre-Release Verification
```bash
git checkout dev
git pull origin dev
# Verify CI is passing (check GitHub Actions if configured)
git log --oneline dev..HEAD  # Review what's being released
```

### Step 2: Create Release PR
Create a PR from `dev` -> `main` with this format:
- Title: `Release vX.Y.Z — [short description]`
- Body must include:
  - Summary of changes (grouped by type: Features, Fixes, Refactors)
  - Breaking changes (if any, highlighted prominently)
  - Migration steps (if any)
  - Link to full changelog diff

### Step 3: After Merge
```bash
git checkout main
git pull origin main
git tag -a vX.Y.Z -m "Release vX.Y.Z — [short description]"
git push origin vX.Y.Z
```

### Step 4: Create GitHub Release
```bash
gh release create vX.Y.Z --title "vX.Y.Z — [short description]" --notes "[release notes]"
```

### Step 5: Update Changelog on Dev
```bash
git checkout dev
git pull origin dev
# Update CHANGELOG.md with the new release entry
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG.md for vX.Y.Z"
git push origin dev
```

### Rules
- NEVER squash when merging `dev` -> `main`. Use `--no-ff` to preserve the merge commit.
- NEVER skip the GitHub Release step. Tags without releases are incomplete.
- NEVER skip the changelog update step.

---

## 6. CHANGELOG MAINTENANCE

Every repo MUST have a `CHANGELOG.md` following the [Keep a Changelog](https://keepachangelog.com) format.

### Format
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Fixed
- Bug fixes

### Removed
- Removed features

### Breaking Changes
- Changes that break backward compatibility

[Unreleased]: https://github.com/ORG/REPO/compare/vX.Y.Z...HEAD
[X.Y.Z]: https://github.com/ORG/REPO/compare/vX.Y.Z-1...vX.Y.Z
```

### Rules
- Update the `[Unreleased]` section with every PR merge into `dev`.
- Move `[Unreleased]` items into a versioned section when releasing.
- Every entry links to the relevant PR or commit when possible.
- Sections with no items are omitted (do not include empty `### Added` sections).

---

## 7. DOCUMENTATION CHECKLIST

Every repo MUST have these files. Check at session start and flag any missing ones.

| File | Purpose |
|------|---------|
| `README.md` | What the project is, how to install, how to run, how to contribute |
| `CHANGELOG.md` | Release history following Keep a Changelog format |
| `AGENTS.md` | AI agent behavior rules, scope limits, session protocol |
| `CLAUDE.md` | Claude Code project context — loaded automatically |
| `.github/CODEOWNERS` | Who reviews what |
| `.github/PULL_REQUEST_TEMPLATE.md` | Standard PR format |
| `.github/ISSUE_TEMPLATE/bug.md` | Bug report template |
| `.github/ISSUE_TEMPLATE/feature.md` | Feature request template |
| `.github/ISSUE_TEMPLATE/task.md` | Task template |

### When Files Are Missing
Output this checklist at session start for any repo:
```
REPO DOCUMENTATION STATUS:
- [x] README.md
- [ ] CHANGELOG.md  <-- MISSING
- [x] AGENTS.md
- [ ] CLAUDE.md  <-- MISSING
...
Action: Create missing files? (y/n)
```

Do NOT silently create files. Always flag and ask first.

---

## 8. AGENTS.md GENERATION

When `AGENTS.md` is missing and the user approves creation, generate it from this template:

```markdown
# AGENTS.md — [Repo Name]

## Scope
- This repo contains: [description]
- Agents may modify: [list of directories/files]
- Agents may NOT modify: [protected files — e.g., .env, secrets, CI config]

## Branch Rules
- Agents MUST use branch prefix: `agent/TASK-XXX-slug`
- Agents NEVER push to `main` or `dev` directly
- Agents NEVER merge their own PRs

## Commit Format
```
[type](TASK-XXX): description in imperative mood
```
Agent commits must include `Modified files:` list in body.

## Session Rules
- Start every session with: git status, branch check, fetch
- End every session with: commit all work, push branch, summarize changes
- If interrupted mid-task: leave a TODO comment in code and note in commit message

## Self-Fix Protocol
- If a build/test fails after your change, attempt to fix it (max 2 attempts)
- If you cannot fix it, revert your change and report the failure
- NEVER force-push to cover up a broken commit

## Review Tiers
| Risk | Examples | Review Required |
|------|----------|----------------|
| Low | Docs, comments, formatting | Auto-merge OK |
| Medium | New features, refactors | 1 human reviewer |
| High | Auth, payments, data migration, infra | 2 human reviewers |

## Prohibited Actions
- NEVER modify `.env`, secrets, or credential files
- NEVER run destructive database operations
- NEVER disable tests or CI checks
- NEVER modify CODEOWNERS or branch protection rules
- NEVER push to `main` or `dev` directly
```

Customize the template based on what you can infer from the repo contents (language, framework, directory structure).

---

## 9. NEW REPO SETUP

When the user creates a new repo or says "set up a new repo", execute this sequence:

### Step 1: Initialize with Dev as Default
```bash
git init
git checkout -b dev
# Create initial files (see step 3)
git add -A
git commit -m "chore: initial repo setup"
git remote add origin <url>
git push -u origin dev
```

### Step 2: Create Main Branch with Protection
```bash
git checkout -b main
git push -u origin main
# Set dev as default branch via GitHub API
gh api -X PATCH repos/{owner}/{repo} -f default_branch=dev
# Note: Branch protection requires GitHub Pro/Team/Enterprise
```

### Step 3: Add Standard Documentation
Create all files from the Documentation Checklist (Section 7):
- `README.md` — with project name, description, install/run instructions, contribution guide
- `CHANGELOG.md` — initialized with `## [Unreleased]` and `## [0.1.0] - YYYY-MM-DD` with "Initial release" entry
- `AGENTS.md` — from template in Section 8
- `CLAUDE.md` — with project context, tech stack, conventions
- `.github/CODEOWNERS` — with default owner
- `.github/PULL_REQUEST_TEMPLATE.md` — see Section 11
- `.github/ISSUE_TEMPLATE/bug.md` — standard bug template
- `.github/ISSUE_TEMPLATE/feature.md` — standard feature template
- `.github/ISSUE_TEMPLATE/task.md` — standard task template

### Step 4: Architecture Scaffold (Product Repos Only)
If this is a product/application repo (not a library or config repo), create:
```
agents/        # AI agent configs and prompts
prompts/       # Prompt templates
specs/         # Product and technical specifications
product/       # Product docs, PRDs, user stories
tests/         # Test suites
infra/         # Infrastructure configs (Docker, CI, deploy)
docs/          # Developer documentation
```
Each directory gets a `.gitkeep` and a brief `README.md` explaining its purpose.

### Step 5: Finalize
```bash
gh repo edit --description "[repo description]" --add-topic "[topic1]" --add-topic "[topic2]"
git tag -a v0.1.0 -m "Initial release"
git push origin v0.1.0
gh release create v0.1.0 --title "v0.1.0 — Initial Release" --notes "Initial project setup with standard documentation and architecture scaffold."
```

---

## 10. REPO NAMING RULES

- One product = one repo. Period.
- NEVER create `product-v2` as a separate repo. Versions are tags.
- Sub-applications that deploy independently get their own repo.
- Template repos are prefixed with `template-` and clearly marked: `gh repo edit --is-template`.
- Monorepo sub-packages use directory structure, not separate repos.
- Naming format: `lowercase-hyphen-separated`. No underscores, no camelCase.

### When to Block
If the user asks to create a repo named like `myapp-v2`, `project-new`, or `service-rewrite`:
- STOP and ask: "Is this a new version of an existing project? If so, we should tag the existing repo instead of creating a new one."

---

## 11. PR MANAGEMENT

### PR Template
Every PR uses this template (create as `.github/PULL_REQUEST_TEMPLATE.md`):

```markdown
## Summary
<!-- What does this PR do? 1-3 bullet points -->

## Task Reference
<!-- TASK-XXX or N/A -->

## Type of Change
- [ ] feat: New feature
- [ ] fix: Bug fix
- [ ] refactor: Code refactoring
- [ ] docs: Documentation
- [ ] test: Tests
- [ ] chore: Maintenance
- [ ] hotfix: Emergency fix

## Risk Assessment
- [ ] Low — Docs, formatting, comments
- [ ] Medium — New feature, refactor
- [ ] High — Auth, payments, data, infra

## Testing
<!-- How was this tested? -->

## Checklist
- [ ] Conventional commit messages used
- [ ] Tests pass locally
- [ ] Documentation updated (if applicable)
- [ ] CHANGELOG.md updated under [Unreleased]
- [ ] No secrets or credentials in code
```

### PR Rules
- Every merge into `dev` or `main` goes through a PR. No exceptions.
- Agent-generated PRs get the label `agent-generated`.
- PRs include task reference when one exists.
- PRs include risk assessment.
- Reviewer assignment follows the risk tier:
  - Low risk: auto-merge or any team member
  - Medium risk: 1 human reviewer
  - High risk: 2 human reviewers
- PR title follows: `[type](TASK-XXX): description` (same as commit format).

### Creating a PR (Command Reference)
```bash
# Feature PR to dev
gh pr create --base dev --title "feat(TASK-XXX): add feature" --body "$(cat <<'EOF'
## Summary
- Added X feature

## Task Reference
TASK-XXX

## Risk Assessment
- [x] Medium

## Checklist
- [x] Conventional commits
- [x] Tests pass
- [x] Changelog updated
EOF
)"

# Agent PR — add label
gh pr create --base dev --title "agent(TASK-XXX): description" --label "agent-generated" --body "..."
```

---

## 12. ANTI-PATTERNS — BLOCK AND WARN

If any of these are about to happen, STOP and warn the user. Do not proceed.

| Anti-Pattern | Response |
|---|---|
| Pushing directly to `main` or `dev` | "Direct pushes to main/dev are blocked. Create a branch and PR." |
| Creating a tag without a GitHub Release | "Tags must have GitHub Releases. Creating release now." |
| Skipping CHANGELOG update on release | "CHANGELOG.md must be updated for every release. Updating now." |
| Creating a version-numbered repo (e.g., `app-v2`) | "Versions are tags, not repos. Tag the existing repo instead." |
| Branch unmerged >48 hours | "Branch [name] has been open for >48 hours. Merge or close?" |
| Non-conventional commit message | "Commit message doesn't follow convention. Reformatting: [corrected message]" |
| Skipping PR for merge into dev/main | "All merges into dev/main require a PR. Creating PR now." |
| Committing secrets or .env files | "BLOCKED: .env and credential files must never be committed. Removing from staging." |
| Force-pushing to shared branches | "Force-push to shared branches is destructive. Use a new commit instead." |
| Amending commits that are already pushed | "Amending pushed commits rewrites history. Create a new commit instead." |

### Automatic Corrections
For these cases, do not just warn — correct automatically:
1. **Non-conventional commit**: Reformat the message before committing.
2. **Missing changelog on release**: Add the changelog entry before completing the release.
3. **Tag without release**: Create the GitHub Release immediately after tagging.
4. **Staged .env or secrets**: Unstage them and add to `.gitignore`.

---

## 13. SUBAGENT PATTERNS — WHEN TO SPAWN

Use subagents to keep your main context clean. Spawn when the task would consume >20% of context.

| Situation | Action |
|---|---|
| Research a library/API before using it | Spawn Explore agent: "Find how X works in this codebase" |
| Deep debugging with many file reads | Spawn agent: "Debug why X fails — check files A, B, C" |
| Code review after implementation | Spawn code-reviewer agent from .claude/agents/ |
| Running full test suite | Spawn test-runner agent from .claude/agents/ |
| Creating a PR with proper template | Spawn pr-creator agent from .claude/agents/ |
| Parallel independent tasks | Spawn multiple agents in one message |
| Quick fix, single file, clear scope | Do NOT spawn — handle inline |
| Simple question about the codebase | Do NOT spawn — use Grep/Read directly |

### Agent naming
When spawning, always give a clear 3-5 word description:
- "Research Supabase RLS patterns"
- "Debug auth middleware failure"
- "Review scoring engine changes"

---

## 14. CONVERSATION BRANCHING — SAFE EXPERIMENTATION

Use `/branch` (or `/fork`) before risky approaches:

| Situation | Action |
|---|---|
| About to try a major refactor | `/branch` first — if it fails, rewind to the fork point |
| Two possible architectural approaches | `/branch`, try approach A. If bad, go back, try B. |
| Experimental change to infra/config | `/branch` — never experiment on the main conversation |
| Quick, well-understood fix | Skip branching — just do it |

### Rule: If you'd feel nervous about Esc+Esc not being enough to undo, `/branch` first.

---

## 15. BATCH OPERATIONS

For operations across multiple repos or files, use `claude -p` (non-interactive mode):

```bash
# Audit all repos
for repo in SaaSFast eo-assessment-system smorch-brain EO-Build ScrapMfast eo-mena; do
  claude -p "Check repo SMOrchestra-ai/$repo for missing docs" --allowedTools Bash,Read
done

# Update all project CLAUDE.md files
for dir in ~/Desktop/cowork-workspace/*/; do
  if [ -f "$dir/CLAUDE.md" ]; then
    claude -p "Review $dir/CLAUDE.md and ensure Required Skills section exists" --allowedTools Read,Edit
  fi
done
```

Use `--allowedTools` to scope what the batch can do. Never give batch operations Write access to infra files.

---

## Quick Reference Card

```
BRANCH:   human/[name]/TASK-XXX-slug | agent/TASK-XXX-slug | feature/slug | hotfix/slug | sandbox/slug
COMMIT:   [type](TASK-XXX): imperative description
TYPES:    feat | fix | refactor | test | docs | chore | agent | hotfix
TAG:      vX.Y.Z
RELEASE:  PR dev->main | tag | gh release | changelog update
NEVER:    push to main/dev | skip PR | skip changelog | create version repos | commit secrets
AGENTS:   code-reviewer | test-runner | pr-creator (via /agents)
BRANCH:   /branch before risky refactors
BATCH:    claude -p for multi-repo operations
```
