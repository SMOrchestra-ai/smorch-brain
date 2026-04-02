# NLClaudeCode — Next-Level Claude Code Setup Guide

## Industry-Grade Configuration for AI-Native Development Teams

**Version:** 1.0
**Date:** 2026-03-23
**Author:** Mamoun Alamouri + Claude Code
**Org:** SMOrchestra.ai
**Purpose:** Complete reference for configuring Claude Code at production grade. Every setting, hook, agent, rule, and skill documented with rationale. Based on Anthropic best practices, industry research, and real implementation.

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [Hooks — The Enforcement Layer](#2-hooks--the-enforcement-layer)
3. [Conditional Rules](#3-conditional-rules)
4. [Custom Agents](#4-custom-agents)
5. [Skills Architecture](#5-skills-architecture)
6. [CLAUDE.md — Signal, Not Noise](#6-claudemd--signal-not-noise)
7. [Git Integration](#7-git-integration)
8. [Session Management](#8-session-management)
9. [Parallel Work](#9-parallel-work)
10. [MCP Servers](#10-mcp-servers)
11. [Scheduled Tasks](#11-scheduled-tasks)
12. [Security Posture](#12-security-posture)
13. [Team Distribution](#13-team-distribution)
14. [Keyboard Shortcuts & Workflow](#14-keyboard-shortcuts--workflow)
15. [What NOT to Configure](#15-what-not-to-configure)
16. [Settings.json Complete Reference](#16-settingsjson-complete-reference)

---

## 1. Philosophy

Three principles govern this setup:

**1. CLAUDE.md is advisory (~80% compliance). Hooks are law (100%).**
If something must happen every time — formatting, blocking destructive commands, secret scanning — it's a hook. If it's guidance Claude should follow — branch naming, commit style, coding patterns — it's CLAUDE.md or a skill.

**2. Every documented feature must be enforced.**
If your architecture doc says "session-start checks happen," there must be a SessionStart hook. If it says "agent PRs get labeled," the pr-creator agent must add the label. Documentation without enforcement is theater.

**3. Context is finite. Spend it wisely.**
Every line in CLAUDE.md, every skill loaded, every MCP tool description consumes context tokens. Remove anything Claude already does by default. Load skills on demand, not globally. Use @imports for reference docs.

---

## 2. Hooks — The Enforcement Layer

Hooks are the most important part of your Claude Code setup. They fire deterministically — before tools execute, after tools complete, at session start, after compaction. They cannot be forgotten, skipped, or hallucinated away.

### 2.1 PreToolUse Hooks (Fire BEFORE a tool runs)

#### Destructive Command Blocker
**What it does:** Blocks dangerous bash commands before they execute.
**Why it exists:** Servers run as root. One `rm -rf /` or `git push --force` can destroy everything.
**Blocked patterns:** rm -rf, git push --force, git push -f, git reset --hard, git checkout ., git restore ., git clean -f, DROP TABLE, TRUNCATE TABLE

```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "CMD=$(jq -r '.tool_input.command' 2>/dev/null); if echo \"$CMD\" | grep -qiE '(rm -rf|git push --force|git push -f |git reset --hard|git checkout \\\\.|git restore \\\\.|git clean -f|drop table|truncate table)'; then echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"BLOCKED: Destructive command detected.\"}}'; else echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"allow\"}}'; fi",
    "statusMessage": "Checking for destructive commands..."
  }]
}
```

**Source:** Tip #40 (Block destructive commands with PreToolUse hooks). Claude Code 50 Best Practices + SMOrchestra deep audit.

#### Supabase SQL Guard
**What it does:** Blocks destructive SQL through the Supabase MCP (not just bash).
**Why it exists:** The destructive command hook only catches bash. The Supabase MCP (`execute_sql`) is a direct line to your database with zero protection. Without this hook, `DROP TABLE users CASCADE` goes through unchecked.

```json
{
  "matcher": "mcp__cb73f37d*",
  "hooks": [{
    "type": "command",
    "command": "SQL=$(jq -r '.tool_input.query // .tool_input.sql // empty' 2>/dev/null); if [ -n \"$SQL\" ] && echo \"$SQL\" | grep -qiE '(DROP\\\\s+(TABLE|SCHEMA|DATABASE|INDEX)|TRUNCATE|DELETE\\\\s+FROM\\\\s+[a-z_]+\\\\s*;)'; then echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"BLOCKED: Destructive SQL detected.\"}}'; else echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"allow\"}}'; fi",
    "statusMessage": "Checking SQL for destructive operations..."
  }]
}
```

**Source:** SMOrchestra deep audit finding #4.2 — "Supabase MCP Has Zero SQL Protection."

#### Secret Scanner
**What it does:** Scans every file Write/Edit for API keys, tokens, and credential patterns.
**Why it exists:** One accidental commit of credentials = leaked keys on GitHub. No amount of post-push scanning fixes a leaked secret.
**Patterns detected:** `sk-` (Anthropic/OpenAI), `AKIA` (AWS), `ghp_` (GitHub)
**Exempted files:** .env.example, .md files, settings.json (documentation/config)

```json
{
  "matcher": "Write|Edit",
  "hooks": [{
    "type": "command",
    "command": "CONTENT=$(jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null); if [ -n \"$CONTENT\" ] && echo \"$CONTENT\" | grep -qiE '(sk-[a-zA-Z0-9]{20,}|AKIA[A-Z0-9]{16}|ghp_[a-zA-Z0-9]{36})'; then FILE=$(jq -r '.tool_input.file_path // empty' 2>/dev/null); if ! echo \"$FILE\" | grep -qiE '(\\\\.env\\\\.example|\\\\.md|settings\\\\.json)'; then echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"BLOCKED: Possible secret detected. Use .env files.\"}}'; else echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"allow\"}}'; fi; else echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"allow\"}}'; fi",
    "statusMessage": "Scanning for secrets..."
  }]
}
```

**Source:** SMOrchestra deep audit finding #4.3.

### 2.2 PostToolUse Hooks (Fire AFTER a tool completes)

#### Auto-Formatter (Prettier)
**What it does:** Runs Prettier on every JS/TS/JSX/TSX file after Claude writes or edits it.
**Why it exists:** Consistent formatting without relying on Claude to remember. Hooks enforce at 100% vs CLAUDE.md at ~80%.

```json
{
  "matcher": "Write|Edit",
  "hooks": [{
    "type": "command",
    "command": "F=$(jq -r '.tool_input.file_path // .tool_response.filePath' 2>/dev/null); if echo \"$F\" | grep -qE '\\\\.(js|ts|jsx|tsx)$'; then npx prettier --write \"$F\" 2>/dev/null || true; fi",
    "statusMessage": "Auto-formatting..."
  }]
}
```

**Source:** Tip #39 (Auto-format with a PostToolUse hook). Claude Code 50 Best Practices.

#### Skills Auto-Push
**What it does:** When Claude writes to `~/.claude/skills/`, automatically pushes to the smorch-brain registry.
**Why it exists:** Skills created in Cowork sessions are immediately backed up to Git without manual intervention.

```json
{
  "matcher": "Write",
  "hooks": [{
    "type": "command",
    "command": "if echo \"$CLAUDE_TOOL_INPUT\" | grep -q '.claude/skills'; then bash ~/smorch-brain/scripts/smorch push >/dev/null 2>&1 & fi"
  }]
}
```

**Source:** SMOrchestra skills distribution architecture.

### 2.3 PostCompact Hook (Fires after context compaction)

#### Context Restorer
**What it does:** Re-injects critical context after compaction: current branch, working directory, Required Skills reminder, active hooks list.
**Why it exists:** Long sessions compact automatically. Without this hook, Claude forgets what it was doing, which branch it's on, and which rules to follow.

```json
{
  "matcher": "manual|auto",
  "hooks": [{
    "type": "command",
    "command": "BRANCH=$(git branch --show-current 2>/dev/null || echo unknown); DIR=$(pwd); echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"PostCompact\\\",\\\"additionalContext\\\":\\\"CONTEXT RESTORE -- Branch: $BRANCH | Dir: $DIR | Check CLAUDE.md Required Skills. Follow GitHub SOPs. Hooks active: destructive-blocker, SQL-guard, secret-scanner, auto-formatter.\\\"}}\"",
    "statusMessage": "Restoring context..."
  }]
}
```

**Source:** Tip #41 (Preserve context across compaction). Claude Code 50 Best Practices.

### 2.4 SessionStart Hook (Fires at the beginning of every session)

#### Environment Bootstrap
**What it does:** Checks git branch, verifies commit hooks are installed, reminds about Required Skills and SOPs.
**Why it exists:** Without this, session-start checks only happen if Claude reads the skill AND remembers. After a fresh start, nothing is guaranteed. This hook makes it deterministic.

```json
{
  "matcher": "*",
  "hooks": [{
    "type": "command",
    "command": "BRANCH=$(git branch --show-current 2>/dev/null || echo none); HOOKS=$(ls .git/hooks/commit-msg 2>/dev/null && echo ok || echo missing); echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"SessionStart\\\",\\\"additionalContext\\\":\\\"SESSION BOOTSTRAP -- Branch: $BRANCH | Git commit hook: $HOOKS | Check CLAUDE.md Required Skills. Follow SMOrchestra GitHub SOPs.\\\"}}\"",
    "statusMessage": "Bootstrapping session..."
  }]
}
```

**Source:** SMOrchestra deep audit — "Session-start checks" was theater. Now enforced.

---

## 3. Conditional Rules

Rules in `.claude/rules/` load only when Claude works on matching file paths. They keep CLAUDE.md lean while providing domain-specific enforcement.

### 3.1 Infrastructure Guard (`infra-guard.md`)
**Triggers on:** `infra/`, `Dockerfile*`, `docker-compose*`, `.github/workflows/*`, `ci.yml`
**Rules:** Extra caution, require Mamoun approval, no changes to CI without review, document every change in ADR.

### 3.2 Auth & Security Guard (`auth-security.md`)
**Triggers on:** `auth/`, `security/`, `.env`, `*.key`, `*.pem`
**Rules:** Never weaken auth checks, never expose secrets, require Mamoun review, check for common vulnerabilities.

### 3.3 Database Guard (`database-guard.md`)
**Triggers on:** `migrations/`, `*.sql`, `schema*`, `supabase/`
**Rules:** Reversible migrations mandatory, backup before destructive changes, test on branch first, RLS policies required on every table.

**Source:** Tip #31 (Use .claude/rules/ for conditional rules). Claude Code 50 Best Practices.

---

## 4. Custom Agents

Agents live in `.claude/agents/`. They spawn as separate Claude instances with their own context, tools, and (optionally) persistent memory.

### 4.1 Code Reviewer (`code-reviewer.md`)
**Model:** Opus
**Memory:** Project-scoped persistent (`~/.claude/agent-memory/code-reviewer/MEMORY.md`)
**Tools:** Read, Glob, Grep, Bash (read-only investigation)
**Output:** MERGE / REVISE / BLOCK recommendation with structured review (critical / suggestion / good)

### 4.2 Test Runner (`test-runner.md`)
**Memory:** Project-scoped persistent (`~/.claude/agent-memory/test-runner/MEMORY.md`)
**Tools:** Bash, Read, Grep, Edit (can fix failures)
**Output:** Pass/fail summary with counts, duration, flaky test detection

### 4.3 PR Creator (`pr-creator.md`)
**Tools:** Bash, Read, Glob, Grep
**Labels:** Always adds `agent-generated`. Adds `high-risk` or `low-risk` based on diff analysis.
**Output:** PR created with SMOrchestra template, risk tier assessed

### When to use agents vs inline work:

| Situation | Action |
|-----------|--------|
| Research a library/API | Spawn Explore agent (Haiku, fast) |
| Deep debugging (>20% context) | Spawn agent with specific files |
| Code review | Spawn code-reviewer agent (fresh context) |
| Run tests | Spawn test-runner agent |
| Quick fix, single file | Do NOT spawn — work inline |
| Simple question | Use /btw overlay instead |

**Source:** Tip #19 (Subagents), Tip #35 (Custom subagents), Tip #45 (One writes, another reviews). Claude Code 50 Best Practices.

---

## 5. Skills Architecture

Skills are markdown files in `~/.claude/skills/` that load on demand, not every session. They extend Claude's knowledge without bloating the always-loaded CLAUDE.md.

### Distribution System
- **Registry:** `smorch-brain` GitHub repo — 55 skills in 7 categories
- **CLI:** `smorch` — push, pull, install, remove, list, diff, status
- **Profiles:** mamoun (all), smo-brain (22), smo-dev (11), developer, gtm-team, eo-student
- **Per-project selection:** CLAUDE.md `## Required Skills` section tells Claude which skills are relevant

### Categories
| Category | Count | Purpose |
|----------|-------|---------|
| smorch-gtm | 12 | GTM, outbound, signal detection, CRM operators |
| eo-training | 6 | EO product skills (ingestion, tech architect, dev) |
| eo-scoring | 5 | Scoring engines (ICP, Market, GTM, Strategy, Project) |
| content | 4 | Content creation, YouTube, webinars, movements |
| dev-meta | 5 | Development workflow, debugging, code review, GitHub ops |
| tools | 8 | Utilities (testing, API docs, research, design, Supabase, Contabo, Arabic, client mgmt) |

### Key Workflow
```bash
# Create/modify skill in Cowork → auto-pushed to registry via PostToolUse hook
# Pull to any machine:
smorch pull --profile <name>
# Install single skill outside profile:
smorch install tools/supabase-admin
```

**Source:** Tip #8 (Leverage skills for on-demand knowledge). Claude Code 50 Best Practices + SMOrchestra skills distribution plan.

---

## 6. CLAUDE.md — Signal, Not Noise

### The Litmus Test
For every line: "Would Claude make a mistake without this?" If no — delete it.
Budget: ~150-200 instructions before compliance drops. System prompt uses ~50.

### What to include:
- Who you are, what you build (context Claude can't infer)
- Tool stack with MCP connections (what's available)
- Output quality standards (specific to your domain)
- Language/cultural defaults (MENA market, Arabic, Gulf tone)
- File naming conventions
- GitHub SOPs (branch naming, commit format, release protocol)
- What NOT to do (only if Claude would actually do it wrong)

### What to remove:
- "Don't add disclaimers about AI limitations" — Claude Code doesn't do this
- "Don't generate filler content" — already default behavior
- "Don't create README files" — conflicts with GitHub SOPs
- Tool listings for tools without MCP (Canva, HeyGen) — Claude can't use them
- Plugin recommendations — managed by skills registry
- Long-form skill creation instructions — condensable to 3 lines

### Use @imports for reference docs:
```markdown
@docs/git-instructions.md
@docs/skill-guide.md
```
Claude reads these on demand without bloating the always-loaded CLAUDE.md.

**Source:** Tips #28, #29, #30, #32. Claude Code 50 Best Practices.

---

## 7. Git Integration

### Conventional Commits — Triple Enforcement
1. **Git hook** (`commit-msg`): Rejects at git level. Works regardless of Claude.
2. **PreToolUse hook** on `git commit`: Validates before Claude even runs the command.
3. **smorch-github-ops skill**: Documents the format for Claude's reference.

### Format:
```
type(scope): description (max 72 chars first line)

Types: feat, fix, refactor, test, docs, chore, agent, hotfix
```

### Branch Naming Convention
| Pattern | Purpose |
|---------|---------|
| `human/[name]/TASK-XXX-slug` | Human work |
| `agent/TASK-XXX-slug` | AI agent work |
| `feature/[name]` | Feature branches |
| `hotfix/[slug]` | Production emergencies |
| `sandbox/[experiment]` | Exploration (never merges) |

### CI Workflows Deployed
- **changelog-check.yml** — Enforces CHANGELOG.md update on release PRs (dev → main)
- **agent-scope-check.yml** — Validates agent PRs: checks locked directories, line count, auto-labels risk tier

**Source:** Tips #4, #6. Claude Code 50 Best Practices + AI-Native Git Architecture v2.

---

## 8. Session Management

### Start fresh between unrelated tasks
`/clear` — a clean session with a sharp prompt beats a degraded 3-hour session.

### Guide compaction
`/compact focus on the API changes and modified files`
The PostCompact hook auto-restores branch, directory, and Required Skills.

### After 2 corrections on the same issue
Start fresh. The context is full of failed approaches hurting the next attempt.

### Use effort levels
- `ultrathink` — architecture decisions, complex debugging, multi-step reasoning
- Normal — daily development
- Low effort — variable renames, simple queries

**Source:** Tips #7, #12, #21, #24. Claude Code 50 Best Practices.

---

## 9. Parallel Work

### Worktrees
`claude --worktree feature-auth` — creates isolated branch + workspace. Run 2-3 in parallel.

### Agent Teams (Experimental)
`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — 3-5 teammates coordinating via shared task list.
Use for: parallel reviews, research tasks. NOT for: same-file edits.

### Batch Mode
```bash
for repo in SaaSFast eo-assessment-system smorch-brain; do
  claude -p "Check repo SMOrchestra-ai/$repo for missing docs" \
    --allowedTools Bash,Read &
done
wait
```

**Source:** Tips #15, #20, #49. Claude Code 50 Best Practices.

---

## 10. MCP Servers

### Connected & Actively Used
| Server | Purpose | Skill |
|--------|---------|-------|
| Supabase | Database admin | supabase-admin |
| Contabo | Server management | contabo-deployment |
| SSH Manager | Remote execution | contabo-deployment |
| GoHighLevel | CRM operations | ghl-operator |
| Instantly | Cold email | instantly-operator |
| n8n | Workflow automation | n8n-architect |
| Apify | Web scraping | scraper-layer |
| Playwright | Browser testing | webapp-testing |
| Figma | Design reference | frontend-design |

### Security
- Supabase SQL guard hook protects against destructive DDL
- MCP allowlisting recommended (not yet enforced — risk of breaking active servers)
- 655 malicious MCP "skills" cataloged as of March 2026 — only install from trusted sources

---

## 11. Scheduled Tasks

| Task | Schedule | Purpose |
|------|----------|---------|
| `smorch-daily-audit` | 8:00am Dubai daily | Audit 14 GitHub dimensions, flag gaps, auto-fix, recommend |
| `smorch-push` | 9:07am Dubai daily | Sync skills to registry |
| `weekly-storage-audit` | Friday 5pm | Laptop storage health check |

---

## 12. Security Posture

### Defense Layers

| Layer | Scope | Enforcement |
|-------|-------|-------------|
| PreToolUse: Destructive blocker | Bash commands | 100% (hook) |
| PreToolUse: SQL guard | Supabase MCP | 100% (hook) |
| PreToolUse: Secret scanner | File writes | 100% (hook) |
| Git hook: Commit format | Git commits | 100% (git hook) |
| Conditional rule: infra-guard | infra/, CI/CD files | 100% (when triggered) |
| Conditional rule: auth-security | auth/, security/, .env | 100% (when triggered) |
| Conditional rule: database-guard | migrations/, .sql | 100% (when triggered) |
| Branch protection | main + dev | 100% (GitHub) |
| CLAUDE.md: GitHub SOPs | All operations | ~80% (advisory) |

### What's Protected
- ✅ Bash destructive commands (rm -rf, force push, hard reset)
- ✅ SQL destructive statements (DROP, TRUNCATE, mass DELETE)
- ✅ Secret/credential exposure (API keys, tokens)
- ✅ Direct push to main/dev (branch protection)
- ✅ Non-conventional commits (git hook)
- ✅ Infra/auth file changes without review (conditional rules)

---

## 13. Team Distribution

### Onboarding a new machine:
```bash
smorch init --profile <name>
```
This clones the registry, installs profile skills, merges MCP configs.

### Onboarding instructions include:
1. Pull latest skills
2. Install hooks in settings.json
3. Install custom agents
4. Install conditional rules
5. Install git commit hook
6. Verify CLAUDE.md has GitHub SOPs
7. Run verification checklist

Full instructions: `~/smorch-brain/docs/claude-code-onboarding-guide.md`

---

## 14. Keyboard Shortcuts & Workflow

| Shortcut | Action | When to Use |
|----------|--------|-------------|
| `Esc` | Stop Claude mid-action | Redirect immediately |
| `Esc Esc` | Rewind to checkpoint | Undo a bad approach |
| `Shift+Tab` | Cycle permission modes | Switch to Plan Mode |
| `Ctrl+S` | Stash prompt draft | Need quick answer first |
| `Ctrl+B` | Background long command | Test suite running |
| `Ctrl+G` | Edit plan in editor | Tweak a few steps |
| `/clear` | Fresh session | New task |
| `/compact` | Force compaction | Context getting large |
| `/btw` | Quick side question | Without polluting context |
| `/branch` | Fork conversation | Try risky approach safely |
| `/agents` | Browse custom agents | Launch code-reviewer, test-runner, pr-creator |
| `@file` | Reference file directly | Skip search, save tokens |

---

## 15. What NOT to Configure

| Don't | Why |
|-------|-----|
| Don't put everything in CLAUDE.md | Use skills (on-demand), rules (conditional), hooks (deterministic) |
| Don't create hooks for guidance | Hooks are for requirements. CLAUDE.md is for guidance. |
| Don't load all skills globally | Use profiles and per-project Required Skills |
| Don't skip the litmus test | Every CLAUDE.md line must justify its existence |
| Don't alias `cc` on servers | Servers run as root. Destructive hook is a safety net, not permission to skip prompts |
| Don't use Agent Teams for same-file edits | Known issue: overwrites between teammates |
| Don't install MCP servers from unknown sources | 655 malicious servers cataloged |
| Don't trust CLAUDE.md for security-critical rules | Use hooks (100%) not instructions (~80%) |

---

## 16. Settings.json Complete Reference

The production settings.json includes:
- 5 PreToolUse hooks (destructive blocker, SQL guard, secret scanner)
- 2 PostToolUse hooks (auto-formatter, skills auto-push)
- 1 PostCompact hook (context restorer)
- 1 SessionStart hook (environment bootstrap)
- GitHub plugin enabled
- Dangerous mode prompt skipped (when using cc alias)

Location: `~/.claude/settings.json`
Template: `~/smorch-brain/docs/templates/settings.json`

---

*This guide is maintained in the smorch-brain registry. Update it as your setup evolves. `smorch push` backs it up automatically.*
