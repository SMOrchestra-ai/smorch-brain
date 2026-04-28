# AI-Native GitHub Architecture --- Industry Best Practices for Founder-Led Engineering

**For:** Founders using Claude Code as their primary engineering system
**Audience:** Solo operators and small teams (1--5 humans + AI agents)
**Version:** 1.0 --- March 2026

---

## 1. The Paradigm Shift

A repository is not a codebase. It is an execution environment for agents. Git is not version control. It is a coordination protocol between humans and machines.

Once you accept these two premises, every decision downstream changes. Branch protection is not bureaucracy---it is the only thing standing between a hallucinating agent and your production database. Commit conventions are not style preferences---they are machine-readable intent signals that let automation distinguish a bug fix from a breaking change.

**Why traditional git workflows collapse with AI agents:**

- **Merge hell.** An agent working on `feature/auth-refactor` does not know another agent just restructured the same files on `feature/api-cleanup`. Without concurrency-aware orchestration, you spend more time resolving conflicts than shipping.
- **Spec vacuum.** A human developer reads Slack threads, attends standups, absorbs context. An agent reads what you give it. No spec means the agent invents one---and you will not like its imagination.
- **Zombie branches.** Agents spin up branches, get interrupted, leave half-finished work. Without TTLs and cleanup, your repo fills with dead experiments.
- **Runaway sessions.** Without guardrails, an agent will `rm -rf` a directory, force-push to main, or drop a production table---not out of malice, but because the shortest path between "fix the test" and "tests pass" sometimes runs through your infrastructure.
- **Undifferentiated review.** When 80% of PRs are agent-generated, reviewing every line the same way burns your scarcest resource: human attention. You need risk-tiered review.

---

## 2. The Five-Layer Architecture

Every task flows through five layers: **Intent, Orchestration, Execution, Validation, Human Gate.**

### Layer 1: Intent

**What it does:** Captures the human goal in structured form.
**Why it exists:** Agents need unambiguous scope. A vague issue produces vague code.
**How to implement:** Use GitHub Issues with structured templates. Every issue must declare: objective, acceptance criteria, affected files/directories, risk level (low/medium/high). The human writes the goal, not the implementation spec. Let the agent decompose.

### Layer 2: Orchestration

**What it does:** Converts intent into executable tasks with concurrency control.
**Why it exists:** Multiple agents working simultaneously will collide on files without coordination.
**How to implement:** Maintain a task queue (a GitHub Project board or a simple JSON manifest) that tracks: which files each task touches, dependencies between tasks, which agent sessions are active. Before dispatching a task, check for file-level conflicts. If two tasks touch the same file, serialize them.

### Layer 3: Execution

**What it does:** The agent writes code in an isolated workspace.
**Why it exists:** Isolation prevents cross-contamination between tasks.
**How to implement:** Each agent session operates on its own branch with a defined TTL (default: 4 hours for features, 1 hour for fixes). The session is pinned to a spec---the issue body plus any referenced architecture docs. If the agent needs to modify files outside its declared scope, it stops and requests approval.

### Layer 4: Validation

**What it does:** CI runs tests, linting, type checking. If CI fails, the agent reads the failure output and attempts one self-fix.
**Why it exists:** Agents produce code that looks right but fails in ways a compiler catches instantly.
**How to implement:**

```yaml
# .github/workflows/agent-validation.yml
name: Agent Validation
on: [pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: npm ci
      - name: Lint
        run: npm run lint
      - name: Type check
        run: npm run typecheck
      - name: Test
        run: npm test
      - name: Agent self-fix (on failure)
        if: failure() && startsWith(github.head_ref, 'agent/')
        run: |
          echo "CI failed. Agent may attempt one self-fix commit."
          # Your agent orchestrator triggers a retry here
```

One retry only. If the second attempt fails, the PR gets labeled `needs-human` and queued for review.

### Layer 5: Human Gate

**What it does:** Risk-tiered PR review before merge.
**Why it exists:** Not all changes carry equal risk. A copy change does not need the same scrutiny as a database migration.
**How to implement:**

| Risk Level | Trigger | Review Required |
|---|---|---|
| Low | Docs, comments, CSS, copy | Auto-merge after CI passes |
| Medium | Feature code, tests, configs | 1 human review |
| High | Auth, payments, infra, DB schema | 2 human reviews + explicit approval |
| Critical | Env vars, secrets, CI/CD pipeline | Founder/CTO only |

---

## 3. Repository Architecture

Standard directory structure for AI-native repos:

```
project-root/
  product/          # Application source code
  agents/           # Agent configurations and custom agents
  prompts/          # Reusable prompt templates
  specs/            # Feature specs, ADRs, architecture docs
  tests/            # Test suites (unit, integration, e2e)
  infra/            # Terraform, Docker, CI/CD configs
  docs/             # User-facing documentation
  .github/          # Issue templates, PR templates, workflows
  CLAUDE.md         # Agent instructions (Claude Code specific)
  AGENTS.md         # Cross-tool agent instructions (universal)
  CHANGELOG.md      # Release history
  ARCHITECTURE.md   # System architecture overview
```

**Directory ownership rules:**

- `product/` --- Agents write here under orchestration. Humans review.
- `agents/` --- Humans only. Agent configurations are human-controlled.
- `infra/` --- Protected. Changes require high-risk review.
- `specs/` --- Humans write specs. Agents read them. Never the reverse.

**When to use this scaffold vs lighter structures:** If your repo has fewer than 10 files, skip the scaffold. Use it when the agent needs to understand boundaries---which typically happens around 20+ files or when multiple agents operate concurrently.

---

## 4. Branch Model

```
main (protected, tagged releases)
  |
  dev (default branch, integration target)
    |
    |-- human/ma/auth-redesign
    |-- agent/claude/issue-42-api-endpoint
    |-- feature/onboarding-flow
    |-- sandbox/experiment-vector-search
    |-- hotfix/fix-payment-webhook
```

**Naming conventions:**

- `human/{initials}/{description}` --- Human-authored work
- `agent/{tool}/{issue-number}-{description}` --- Agent-authored work
- `feature/{description}` --- Collaborative (human + agent)
- `sandbox/{description}` --- Experimental, no merge expectation
- `hotfix/{description}` --- Urgent production fixes

**Critical rules:**

1. **Namespace separation.** Humans and agents never work on the same branch simultaneously. If a human needs to intervene on an agent branch, the agent session ends first.
2. **Never push directly to main or dev.** All changes flow through PRs.
3. **Hotfix merges both ways.** Hotfix branches merge to both main and dev to prevent drift.
4. **Branch TTL: 48 hours.** Any branch older than 48 hours without activity gets flagged. Any branch older than 7 days gets archived. Stale branches are where bugs hide.

---

## 5. Version Control and SemVer

**When to bump:**

- **Major (v2.0.0):** Breaking API changes, database schema migrations that are not backward-compatible, fundamental architecture shifts.
- **Minor (v1.1.0):** New features, new endpoints, new capabilities that do not break existing behavior.
- **Patch (v1.0.1):** Bug fixes, performance improvements, documentation corrections.

**The golden rule:** One product equals one repo. Versions are tags, not repos. Creating `my-app-v2` as a separate repository is the single most common mistake in founder-led teams. It splits your history, doubles your CI maintenance, and guarantees the two repos drift.

**GitHub Releases vs tags:** A tag without a Release is invisible to anyone who does not use the CLI. Always create a GitHub Release for every version tag. The Release is where you put human-readable notes, link to the changelog, and attach build artifacts.

---

## 6. The Enforcement Stack

This is the most important section. Agent compliance follows a hierarchy: deterministic enforcement beats probabilistic instruction every time.

### 6.1 Hooks (100% Deterministic)

These fire on every relevant action. The agent cannot bypass them.

**PreToolUse -- Destructive Command Blocker:**

```json
{
  "hooks": [
    {
      "type": "preToolUse",
      "matcher": "Bash",
      "hook": {
        "type": "intercept",
        "command": "echo \"$TOOL_INPUT\" | grep -qE '(rm\\s+-rf|--force|force.push|hard.reset|DROP\\s+TABLE|TRUNCATE)' && echo '{\"decision\": \"block\", \"reason\": \"Destructive command blocked by hook\"}' || echo '{\"decision\": \"allow\"}'"
      }
    }
  ]
}
```

**PreToolUse -- Secret Scanner:**

```json
{
  "type": "preToolUse",
  "matcher": "Write|Edit",
  "hook": {
    "type": "intercept",
    "command": "echo \"$TOOL_INPUT\" | grep -qE '(sk-[a-zA-Z0-9]{20,}|AKIA[A-Z0-9]{16}|ghp_[a-zA-Z0-9]{36}|password\\s*=\\s*[\"'\\''\\\"].+[\"'\\''\\\"]])' && echo '{\"decision\": \"block\", \"reason\": \"Potential secret detected\"}' || echo '{\"decision\": \"allow\"}'"
  }
}
```

**PostToolUse -- Auto-Formatter:**

```json
{
  "type": "postToolUse",
  "matcher": "Write|Edit",
  "hook": {
    "type": "afterExecution",
    "command": "npx prettier --write \"$FILEPATH\" 2>/dev/null; echo 'Formatted'"
  }
}
```

**PostCompact -- Context Restorer:**

When the agent compacts its context window, critical information can be lost. This hook re-injects it:

```json
{
  "type": "postCompact",
  "hook": {
    "type": "afterExecution",
    "command": "echo \"CONTEXT RESTORE: Branch=$(git branch --show-current) | Dir=$(pwd) | Protected files: infra/, .env*, auth/\""
  }
}
```

**SessionStart -- Environment Bootstrap:**

```json
{
  "type": "sessionStart",
  "hook": {
    "type": "afterExecution",
    "command": "git branch --show-current && echo '---' && cat CLAUDE.md | head -50 && echo '---' && echo 'Hooks verified: active'"
  }
}
```

### 6.2 Git Hooks (100% at Commit Level)

**commit-msg -- Conventional Commit Enforcer:**

```bash
#!/bin/sh
# .git/hooks/commit-msg
MSG=$(cat "$1")
PATTERN='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,72}'

if ! echo "$MSG" | grep -qE "$PATTERN"; then
  echo "ERROR: Commit message must follow Conventional Commits format."
  echo "Examples:"
  echo "  feat(auth): add OAuth2 login flow"
  echo "  fix(api): handle null response from payment gateway"
  echo "  docs: update API reference for v2 endpoints"
  exit 1
fi
```

### 6.3 Conditional Rules (100% When Triggered)

These load only when specific files are in the changeset:

**Infrastructure guard** --- activates when changes touch `infra/`, `Dockerfile`, or `.github/workflows/`:
- Requires high-risk PR label
- Blocks agent auto-merge
- Mandates founder review

**Auth/security guard** --- activates for `auth/`, `security/`, `.env*`:
- Requires two reviewers
- Triggers secret scan
- Blocks if any new environment variable is added without documentation

**Database guard** --- activates for `migrations/`, `*.sql`, schema files:
- Requires explicit migration plan in PR description
- Blocks destructive DDL (DROP, TRUNCATE) without manual override
- Requires rollback script for every migration

### 6.4 CLAUDE.md / AGENTS.md (~80% Advisory)

These are instruction files. They guide agent behavior but cannot enforce it with 100% reliability.

**What goes in CLAUDE.md vs what needs hooks:**

The litmus test: "Would the agent make a dangerous mistake without this line?" If yes, it needs a hook. If the mistake is merely suboptimal (wrong naming convention, missing a test), CLAUDE.md is sufficient.

- **Hook territory:** Do not delete files. Do not force push. Do not modify environment variables. Do not run DDL.
- **CLAUDE.md territory:** Use TypeScript strict mode. Write tests for new functions. Follow the project's naming conventions. Keep PRs under 400 lines.

**AGENTS.md as the cross-tool standard:** AGENTS.md works with 25+ AI coding tools (not just Claude Code). If your team uses multiple tools, put universal instructions in AGENTS.md and tool-specific instructions in the tool's own config file.

**Budget: 150--200 instructions maximum.** Beyond this threshold, compliance drops measurably. Prioritize constraints that prevent damage over preferences that improve style.

---

## 7. Custom Agents

### Code Reviewer

```yaml
# agents/code-reviewer.yml
name: code-reviewer
model: claude-sonnet
trigger: pull_request
permissions:
  - read: product/, tests/
  - write: none
memory: .agents/review-patterns.md  # Persistent memory file
instructions: |
  Review for: correctness, security, performance, test coverage.
  Reference past review patterns in review-patterns.md.
  After each review, append new patterns discovered to memory file.
  Label PRs: approved, changes-requested, needs-discussion.
```

The persistent memory file is the key differentiator. The reviewer gets smarter over time because it accumulates project-specific patterns: "This codebase always forgets to handle the null case on API responses" or "Auth middleware must be tested with expired tokens."

### Test Runner

```yaml
name: test-runner
trigger: on_demand
permissions:
  - read: product/, tests/
  - write: tests/
instructions: |
  Detect test framework from package.json/pyproject.toml.
  Run full suite. On failure:
    1. Read error output
    2. Identify root cause
    3. Fix test OR fix code (if test is correct and code is wrong)
    4. Re-run. If second run fails, stop and report.
```

### PR Creator

```yaml
name: pr-creator
trigger: branch_ready
permissions:
  - read: all
  - write: .github/
labels:
  - agent-generated     # Always applied
  - high-risk           # If touching infra/, auth/, payments/
  - self-fixed          # If agent fixed its own CI failure
instructions: |
  Create PR with: summary, changes list, test results, risk assessment.
  Auto-label based on files changed.
  Link to originating issue.
```

**When to spawn agents vs work inline:** Spawn a separate agent when the task is self-contained and does not require back-and-forth with the human. Work inline when the task requires iterative refinement or real-time decision-making.

---

## 8. CI/CD for AI-Native Teams

### CHANGELOG Enforcement

```yaml
# .github/workflows/changelog-check.yml
name: Changelog Check
on:
  pull_request:
    branches: [main]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Verify CHANGELOG updated
        run: |
          if ! git diff origin/main --name-only | grep -q "CHANGELOG.md"; then
            echo "ERROR: Release PRs must update CHANGELOG.md"
            exit 1
          fi
```

### Agent Scope Checking

```yaml
- name: Verify agent stayed in scope
  if: startsWith(github.head_ref, 'agent/')
  run: |
    DECLARED=$(gh issue view "$ISSUE_NUM" --json body -q '.body' | grep -oP 'Files: \K.*')
    CHANGED=$(git diff origin/dev --name-only | tr '\n' ',')
    # Compare declared vs actual changed files
    # Fail if agent touched undeclared directories
```

### Self-Healing CI Pattern

The agent reads its own failure, attempts one fix, and either succeeds or escalates:

```yaml
- name: Self-heal on failure
  if: failure() && startsWith(github.head_ref, 'agent/')
  run: |
    echo "::warning::Agent CI failed. Triggering one self-fix attempt."
    # Dispatch event to agent orchestrator with failure logs
    gh api repos/${{ github.repository }}/dispatches \
      -f event_type="agent-self-fix" \
      -f client_payload[branch]="${{ github.head_ref }}" \
      -f client_payload[run_id]="${{ github.run_id }}"
```

---

## 9. Release Protocol

Full sequence:

1. **Dev stabilizes.** All feature branches merged, CI green on dev.
2. **Release PR.** Create PR from dev to main. Title: `release: vX.Y.Z`. Body includes changelog entries.
3. **Merge to main.** Use merge commit (not squash). Squash destroys the individual commit history that makes debugging possible.
4. **Tag.** `git tag -a vX.Y.Z -m "Release vX.Y.Z"` immediately after merge.
5. **GitHub Release.** Create from the tag. Include full changelog for this version.
6. **CHANGELOG update.** Move items from `[Unreleased]` to the new version section.
7. **Deploy.** Trigger deployment from the tag or release event.

**CHANGELOG format** (Keep a Changelog standard):

```markdown
# Changelog

## [Unreleased]

## [1.2.0] - 2026-03-24
### Added
- OAuth2 login flow with Google and GitHub providers
- Rate limiting on public API endpoints

### Fixed
- Payment webhook timeout on high-traffic events
- Null pointer in user profile serialization

### Changed
- Upgraded database driver to v4.2 for connection pooling
```

**Why merge commit, not squash:** Squash collapses 15 meaningful commits into one blob. When something breaks in production, you need granular history to bisect the failure. Squash merges from feature branches to dev are fine. Squash from dev to main is not.

---

## 10. Documentation Standards

Every repo needs these files. No exceptions.

| File | Purpose | Owner |
|---|---|---|
| `README.md` | What this is, how to run it, how to contribute | Human |
| `CHANGELOG.md` | Version history in Keep a Changelog format | Human + Agent |
| `AGENTS.md` | Instructions for any AI tool working in this repo | Human |
| `CLAUDE.md` | Claude Code-specific instructions and constraints | Human |
| `ARCHITECTURE.md` | System design, data flow, key decisions | Human |
| `specs/adr-NNN-*.md` | Architecture Decision Records | Human |

**ADR Template:**

```markdown
# ADR-001: Use PostgreSQL over MongoDB

## Status
Accepted

## Context
We need a database for structured relational data with ACID transactions.

## Decision
PostgreSQL via Supabase.

## Consequences
- Positive: Strong typing, mature tooling, RLS for multi-tenancy
- Negative: Less flexible schema evolution than document stores
```

---

## 11. Skills Distribution (Multi-Machine Setups)

When you run Claude Code across multiple machines (development laptop, CI server, staging environment), skills and configurations must stay synchronized.

**Central registry model:**

```
skills-registry/
  shared/               # Skills available to all machines
    code-review.md
    test-runner.md
  profiles/
    dev-machine.json    # Role: full development
    ci-runner.json      # Role: validation only
    staging.json        # Role: deployment only
```

**Machine profiles:**

```json
{
  "machine": "ci-runner",
  "skills": ["test-runner", "lint-checker", "scope-validator"],
  "excluded_skills": ["code-writer", "pr-creator"],
  "constraints": {
    "write_access": false,
    "max_session_minutes": 15
  }
}
```

**Per-project skill selection via CLAUDE.md:**

```markdown
## Required Skills
- code-reviewer (from shared/)
- test-runner (from shared/)
- db-migrator (project-specific, in agents/)
```

**Sync model:** On-demand push/pull, not automated cron. You want explicit control over when new skills propagate. Run `skills sync pull` before starting work, `skills sync push` after creating new skills.

---

## 12. Daily Operations Checklists

### Start of Day

- [ ] Pull latest from dev
- [ ] Check for stale branches (>48 hours)
- [ ] Review any PRs labeled `needs-human`
- [ ] Check CI status on dev branch
- [ ] Review agent session logs from overnight runs (if applicable)

### Before Starting Work

- [ ] Create or claim an issue with structured template
- [ ] Verify no active agent sessions on overlapping files
- [ ] Create branch with correct namespace prefix
- [ ] Confirm hooks are loaded (`claude hooks list` or equivalent)

### Before Merging

- [ ] CI passes on all checks
- [ ] PR description includes: what changed, why, how to test
- [ ] CHANGELOG updated if user-facing change
- [ ] No secrets in diff (run scanner)
- [ ] Risk label applied and appropriate reviewers assigned

### Release Day

- [ ] All items in `[Unreleased]` changelog reviewed
- [ ] Dev branch CI green
- [ ] Release PR created (dev to main)
- [ ] After merge: tag created, GitHub Release published
- [ ] Deployment verified in production
- [ ] CHANGELOG `[Unreleased]` section cleared

---

## 13. The Scoring Rubric

Score your GitHub organization across 14 dimensions. Rate each 0 (absent), 5 (partial), or 10 (complete).

| # | Dimension | 0 | 5 | 10 |
|---|---|---|---|---|
| 1 | Org metadata | No description, no avatar | Partial info | Full profile, website, description |
| 2 | Repo descriptions | Blank | Some repos described | Every repo has description + topics |
| 3 | Branch model | Pushing to main | Main + feature branches | Full namespace model with TTLs |
| 4 | Branch protection | None | Main protected | Main + dev protected, status checks required |
| 5 | Architecture scaffold | Flat file dump | Some organization | Full directory structure with ownership |
| 6 | Version control | No tags | Tags exist, inconsistent | SemVer tags on every release |
| 7 | CHANGELOGs | None | Exists but outdated | Keep a Changelog format, current |
| 8 | AGENTS.md | None | CLAUDE.md only | AGENTS.md + tool-specific configs |
| 9 | PR templates | None | Basic template | Risk-tiered templates with checklists |
| 10 | Issue templates | None | Single template | Structured templates (bug, feature, task) |
| 11 | Commit conventions | Freeform messages | Mostly conventional | Enforced via hook, 100% compliant |
| 12 | Release protocol | Manual, ad hoc | Tags exist | Full protocol: PR, merge, tag, Release, deploy |
| 13 | Documentation | README only | README + partial docs | Full doc suite (README, ARCH, ADRs, CHANGELOG) |
| 14 | Teams/permissions | Everyone is admin | Some role separation | Tiered: admin, maintainer, agent, read-only |

**Scoring guide:**
- 0--40: Foundations missing. Start with branch protection and commit conventions.
- 41--80: Partial coverage. Focus on enforcement (hooks) and documentation.
- 81--110: Solid. Optimize agent workflows and release automation.
- 111--140: Production-grade AI-native architecture.

---

## 14. Anti-Patterns

**Creating v2 repos instead of tags.** Your app is not a new product. It is a new version. Use `git tag v2.0.0`, not a new repository.

**Pushing directly to main.** Every change---even a typo fix---goes through a PR. This is non-negotiable when agents are in the mix because direct pushes bypass every validation layer.

**Tags without Releases.** A tag that only exists in `git log` is invisible in the GitHub UI. If it is worth tagging, it is worth a Release with notes.

**Skipping CHANGELOG.** "Just read the commits" does not work when 60% of commits are agent-generated conventional commits. The changelog is for humans. Maintain it.

**Letting branches rot.** A branch that has not been touched in a week is not "in progress." It is dead. Archive it or delete it.

**One massive PR.** A 2,000-line PR is not reviewable. It is a rubber-stamp request. Keep agent PRs under 400 lines. If the feature is bigger, decompose it into sequential PRs.

**Agent and human on the same branch.** This creates race conditions, mysterious force-pushes, and lost work. Namespace separation exists for a reason.

**No AGENTS.md.** If you use any AI coding tool and your repo has no agent instructions, the agent is guessing at your conventions. It will guess wrong.

**Squash-merging to main.** Squash destroys commit granularity. You lose `git bisect`. You lose the ability to trace a bug to a specific change. Merge commit to main, always.

**Skipping commit conventions.** Without conventional commits, your changelog is manual, your version bumps are guesswork, and your CI cannot distinguish a feature from a fix.

---

## 15. What's Coming (2026--2027)

**GitHub Agentic Workflows (GA expected mid-2026).** Event-driven repo automation where agents respond to repository events (issue created, PR reviewed, CI failed) without external orchestration. This will replace most of the custom orchestration layer described in Section 2.

**Copilot Code Review (rolling out 2026).** Multi-agent PR review where specialized reviewers (security, performance, style) each pass over the diff independently. Expect this to reduce human review burden by 50--70% for medium-risk PRs.

**Agent Teams (experimental).** Parallel agent sessions that are aware of each other---sharing context about which files are locked, which tasks are in progress, and which architectural decisions have been made. Early implementations are fragile but the direction is clear.

**Persistent Agent Memory.** Agents that remember past sessions, past mistakes, and past review feedback across an entire project lifetime. This changes the calculus on CLAUDE.md---instead of 200 lines of static instructions, the agent builds its own understanding over time.

**What to do now:** Build the enforcement stack (Section 6) today. It will survive every platform change because hooks and git hooks are infrastructure-level controls. Build the orchestration layer (Section 2) as lightweight scripts, not heavy frameworks---it will be replaced by native GitHub features within 12 months.

---

*This guide reflects patterns validated in production across multiple founder-led teams running AI agents as primary engineering systems. The architecture is tool-agnostic where possible and Claude Code-specific where necessary. Update quarterly as the tooling evolves.*
