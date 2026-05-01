---
status: active
last_reviewed: 2026-05-02
owner: Mamoun Alamouri
captured: "Codified 2026-05-02 after migrating Signal-Sales-Engine off claude.ai agent desktop into Claude Code (VSCode extension). The migration revealed every SMOrchestra project needs the same discipline foundation (project lessons.md, SOP INDEX, CLAUDE.md Discipline block, commit-msg hook, gitignored Claude state) — without it each project drifts independently."
---

# SOP-22: Project Migration to Claude Code

**Version:** 1.0
**Date:** May 2026
**Owner:** Mamoun Alamouri
**Scope:** Bringing any SMOrchestra project from claude.ai agent desktop (or no-Claude-at-all) into Claude Code (VSCode extension or CLI) with full discipline foundation
**Skills Used:** `migrate-project-to-claude-code` (~/.claude/skills/migrate-project-to-claude-code/)
**Related SOPs:** SOP-02 Pre-Upload-Scoring, SOP-03 Github-Standards, SOP-08 Project-Kickoff-PreDev-Check
**Principle:** Every project gets the same discipline foundation. No project starts work in Claude Code without lessons.md, SOP INDEX (if applicable), CLAUDE.md Discipline block, commit-msg hook, and gitignored Claude state.

---

## When This SOP Triggers

**Automatically (Claude must execute without being asked):**
- User says: "migrate {project} to claude code", "bring {project} into claude code", "set up {project} for claude code", "onboard {project}"
- User opens a SMOrchestra project in Claude Code that has no `.claude/lessons.md` AND has a `CLAUDE.md` (i.e., it's a real project, not a sandbox)

**On request:**
- User runs `/migrate-project <project-path>` (if slash command is configured)

**Skip if:**
- Project is in `_archive/`, `_legacy*`, or `*-pre-phase7` (snapshot directories)
- Project has no `CLAUDE.md` AND no `.git` (not a real codebase)

---

## Pre-requisites (one-time, machine-wide — verify, don't repeat)

These are global setup. Do them ONCE per machine; SOP-22 then assumes they're in place.

1. **MCPs installed in user-scope** — `claude mcp list` shows `n8n-smo-brain`, `n8n-smo-dev`, `contabo-eo`, `contabo-smo`, `supabase-eo`, `supabase-smo`, `Github-smo`, `Github-alamouri`, `firecrawl-mcp`, `instantly`, `playwright`, `railway`, `exa`, `salesmfast-ops` (+ all the claude.ai hosted MCPs). If any missing, see `/Users/mamounalamouri/.claude.json` mcpServers section for the canonical add commands.
2. **Global SessionStart hook for project lessons.md auto-load** — `~/.claude/settings.json` SessionStart hooks array contains an entry that reads `./.claude/lessons.md` from the cwd at session start. Tested 2026-05-02.
3. **Global CLAUDE.md has CLAUDE INTERFACE section** — covers when to recommend CLI vs VSCode extension.

---

## The 6-step migration

Execute every step in order. Each step has a verification before moving to the next.

### Step 1 — Identify the project + classify

```bash
PROJECT_PATH=$1   # e.g. ~/Desktop/repo-workspace/smo/content-automation
cd "$PROJECT_PATH" || { echo "path missing"; exit 1; }
```

Check classification:
- Has `CLAUDE.md` AND `.git` → **migrate** (proceed)
- Has only `CLAUDE.md` (no .git) → **flag**: not a git repo, ask user before proceeding
- Has only `.git` (no CLAUDE.md) → **flag**: needs a CLAUDE.md first, see SOP-08
- Has neither → **skip** (not a SMOrchestra project)
- Path matches `_archive/` or `*-pre-phase7` → **skip** (snapshot)

### Step 2 — Audit the discipline state (read-only)

Run this audit and report findings to user before any writes:

```bash
echo "=== Project: $(basename $PWD) ==="
echo "CLAUDE.md exists?      $(test -f CLAUDE.md && echo yes || echo NO)"
echo "Discipline section?    $(grep -c '## Discipline' CLAUDE.md 2>/dev/null || echo 0)"
echo ".claude/lessons.md?    $(test -f .claude/lessons.md && echo yes || echo NO)"
echo "docs/sop/INDEX.md?     $(test -f docs/sop/INDEX.md && echo yes || echo NO)"
echo "commit-msg hook?       $(test -x .git/hooks/commit-msg && echo yes || echo NO)"
echo "gitignored .claude?    $(grep -c '.claude/settings.local' .gitignore 2>/dev/null || echo 0)"
echo "Phantom SOP refs?      $(grep -cE 'SOP-[0-9]+' CLAUDE.md 2>/dev/null || echo 0)"
echo "Branch:                $(git branch --show-current)"
echo "Working tree clean?    $(git diff --quiet && git diff --cached --quiet && echo yes || echo NO)"
```

If working tree is NOT clean, stop and ask user (don't auto-stash).

### Step 3 — Apply the 4-file discipline foundation

Use SSE's files as the canonical templates. Adapt where project-specific.

**File 1: `.claude/lessons.md`** — copy SSE's structure (header + how-to-use + active-lessons skeleton). Strip SSE's L-SSE-001 and L-SSE-002 (those are SSE-specific). Project gets a clean lessons file with the project name in the title and zero active lessons (waiting for first correction). Path: `~/Desktop/repo-workspace/smo/Signal-Sales-Engine/.claude/lessons.md` is the source-of-truth template.

**File 2: `docs/sop/INDEX.md`** — only create if the project either (a) has files in `./docs/sop/` already OR (b) references `SOP-N` in CLAUDE.md. Otherwise skip — adding INDEX to a project that doesn't use SOPs is bloat. When creating, use SSE's INDEX as template, replace the SSE-specific SOPs with the project's own.

**File 3: Add Discipline section to project `CLAUDE.md`** — copy the 6-block section from SSE's CLAUDE.md (Quality gate / Lessons capture / SOP enforcement / Git discipline / Session bootstrap / When stuck). Adapt slash-command names per the project's plugin:
  - `smorch-dev` plugin → `/smo-score`, `/smo-bridge-gaps`, `/smo-elegance-pause`, `/smo-triage`
  - `eo-microsaas-dev` plugin → `/5-eo-score`, `/6-eo-bridge-gaps`, `/eo-debug` (no elegance-pause equivalent — note as TODO in lessons.md)
  - Other plugins → check the plugin's `commands/` directory for actual command names. NEVER write a slash command into CLAUDE.md without verifying it exists in the active plugin (SOP-22 enforces global CLAUDE.md L-EO-SPLIT rule).

**File 4: Update `.gitignore`** — append at the end:
```
# Claude Code — per-machine settings and agent worktrees
.claude/settings.local.json
.claude/worktrees/
```
Skip if both lines already present.

### Step 4 — Install conventional-commits hook

```bash
# The hook itself is project-portable (same regex, same error message)
cp ~/Desktop/repo-workspace/smo/Signal-Sales-Engine/.git/hooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

# Smoke-test it
echo "random commit message" | .git/hooks/commit-msg /dev/stdin >/dev/null 2>&1 && \
  echo "FAIL: hook accepted bad message" || echo "PASS: hook rejects bad message"
echo "feat(scope): test message" | .git/hooks/commit-msg /dev/stdin >/dev/null 2>&1 && \
  echo "PASS: hook accepts conventional message" || echo "FAIL: hook rejects good message"
```

Both PASS lines required to continue.

### Step 5 — Smoke test the project's CI

If the project has `.github/workflows/`, glance at the most recent workflow runs:
```bash
gh run list --limit 3 --json conclusion,workflowName,event,createdAt | python3 -m json.tool
```

If CI has been failing for 5+ consecutive runs (the SSE pattern that bit us), STOP and surface this to the user before opening any new PR. Don't merge into red CI; either help fix it as part of the migration or call it out as a blocker.

### Step 6 — Open the migration PR

Branch: `chore/discipline-foundation` (or `chore/lessons-and-sop-index` to match SSE's naming).

Commit message:
```
docs: add project lessons.md, SOP INDEX, Discipline section to CLAUDE.md

Per SOP-22 (Project Migration to Claude Code). Brings this project
in line with the discipline foundation: project-level lessons capture,
SOP map (if applicable), Discipline policy block in CLAUDE.md, gitignore
covering Claude state, conventional-commits hook locally installed.

No behavior change to runtime. CI should pass unchanged.
```

PR body must include:
- Audit findings from Step 2 (what was missing)
- List of files created/modified
- Test plan checklist (CI green, hook works)
- Note that this PR is mechanical — no logic change, only discipline scaffolding

After merging, **switch local checkout to the project's main/dev branch and pull** to verify the merge landed cleanly.

---

## Verification (end-to-end check)

After completing Steps 1-6, the project must satisfy:

| Check | How to verify |
|---|---|
| `.claude/lessons.md` exists + auto-loads | Open Claude Code in the project; SessionStart additionalContext should mention "Project Lessons — {project-name}" |
| Discipline section in CLAUDE.md | `grep -A 1 '## Discipline' CLAUDE.md` returns the heading |
| commit-msg hook works | Bad commit message gets rejected; conventional one accepted |
| gitignore covers Claude state | `git check-ignore .claude/settings.local.json` exits 0 |
| Migration PR merged + main green | `gh pr list --state merged --search "chore/discipline-foundation"` shows the PR; `gh run list --limit 1` shows green |

If any check fails, the migration is **incomplete**. Capture the gap as a new lesson in the project's `.claude/lessons.md` (this is itself a SOP-22 enforcement signal).

---

## Failure modes (what to watch for)

| Symptom | Root cause | Fix |
|---|---|---|
| Hook rejects valid commits | Hook regex doesn't allow your project's commit type (e.g., `agent` for agent-generated commits) | Edit `.git/hooks/commit-msg` to add the type to the regex pattern |
| Project CLAUDE.md references slash commands that don't exist in its active plugin | Drifted plugin/CLAUDE pair | Run `ls $(claude config get plugins-path)/{plugin}/commands/` to find real command names; update CLAUDE.md to use them |
| Audit shows working tree dirty mid-migration | Pre-existing in-flight work | STOP, surface to user. Never auto-stash or reset |
| CI fails after PR opens | Migration touched something it shouldn't have | Inspect the diff; common culprit is an unintended edit to `.gitignore` ordering or a CRLF issue on the commit-msg hook |
| Multiple `lessons.md` versions across copies of same project (cowork-workspace vs repo-workspace duplicates) | User has duplicate project trees | Pick the canonical path (usually `repo-workspace/`); flag the duplicate; do NOT migrate both |

---

## What NOT to do

- ❌ Do NOT create stub SOPs for missing ones referenced in CLAUDE.md (write them when needed, per SOP-22 anti-bloat principle).
- ❌ Do NOT migrate `_archive/`, `_legacy*`, or `*-pre-phase7` directories (they're snapshots, no live work happens there).
- ❌ Do NOT modify `~/.claude/settings.json` to add per-project hooks; the global hook for project lessons.md auto-load is already in place.
- ❌ Do NOT batch multiple project migrations into one PR (each project gets its own chore PR for review traceability).
- ❌ Do NOT auto-merge the migration PR via `--admin` without reading the diff yourself; the migration is mechanical but copy-paste errors happen.
- ❌ Do NOT migrate when CI on the project's main has been red for 5+ runs (fix CI first or surface as blocker).

---

## Related work

- `~/.claude/skills/migrate-project-to-claude-code/SKILL.md` — the executable form of this SOP. Auto-loaded by Claude Code; triggers on natural-language phrases like "migrate {project}".
- SSE's `docs/sop/INDEX.md` — example of the SOP INDEX template SOP-22 produces.
- Original SSE migration (PR #92, merged 2026-05-02) — the proof-of-concept that produced this SOP.
