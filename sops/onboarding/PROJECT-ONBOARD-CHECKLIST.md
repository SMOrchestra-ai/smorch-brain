# Project Onboard Pre-Flight Checklist

> Run this checklist when onboarding to any SMOrchestra.ai project.
> 17 sections. Each has: check name, command, pass criteria, common blocker + fix.
> Issue categories: BLOCKER (needs Mamoun), WARNING (degrades experience), AUTO-FIX (agent handles)
>
> Last updated: 2026-04-06

---

## How to Use

1. Open Git Bash (Windows) or terminal (Linux/macOS)
2. `cd` to the project repo root
3. Run each check in order
4. Record PASS/FAIL for each
5. Fix AUTO-FIX items immediately
6. Report WARNING items in your standup
7. Escalate BLOCKER items to Mamoun via Telegram with the exact error

---

## 1. Git Clone Verified

**Command:**
```bash
git remote -v
```

**Pass criteria:** Shows `https://github.com/SMOrchestra-ai/[repo-name]` for origin.

**Common blocker:** Wrong remote or no remote.
- **Fix (AUTO-FIX):** `git remote set-url origin https://github.com/SMOrchestra-ai/[repo-name].git`

---

## 2. Correct Branch

**Command:**
```bash
git branch --show-current
```

**Pass criteria:** Shows `dev` (for starting work) or your feature branch `human/lana/TASK-XXX-*`.

**Common blocker:** On `main` by accident.
- **Fix (AUTO-FIX):** `git checkout dev && git pull origin dev`

---

## 3. Branch Up to Date

**Command:**
```bash
git fetch origin && git status
```

**Pass criteria:** "Your branch is up to date with 'origin/dev'" or "ahead by N commits" (if you have local work).

**Common blocker:** "Your branch is behind."
- **Fix (AUTO-FIX):** `git pull origin dev`

---

## 4. Node.js Version

**Command:**
```bash
node --version
```

**Pass criteria:** v18.x or higher.

**Common blocker:** Old Node version or Node not installed.
- **Fix (AUTO-FIX):** Download from https://nodejs.org (Windows) or `nvm install 18` (Linux)
- **Category:** BLOCKER if not installed

---

## 5. Dependencies Installed

**Command:**
```bash
npm install
```

**Pass criteria:** Completes without errors. `node_modules/` directory exists.

**Common blocker:** Permission errors on Windows.
- **Fix (AUTO-FIX):** Run Git Bash as Administrator, then `npm install`
- **Common blocker:** Package resolution conflicts.
- **Fix:** `rm -rf node_modules package-lock.json && npm install`
- **Category:** BLOCKER if persistent errors

---

## 6. Environment Variables

**Command:**
```bash
# Check if .env exists
ls -la .env 2>/dev/null || echo "NO .env FILE"

# Check if .env.example exists for reference
ls -la .env.example 2>/dev/null || echo "NO .env.example FILE"
```

**Pass criteria:** `.env` file exists OR the project does not require one (check README).

**Common blocker:** `.env` missing -- secrets not available.
- **Fix:** Copy `.env.example` to `.env`: `cp .env.example .env`
- **Category:** BLOCKER -- ask Mamoun for actual secret values. Never guess or use placeholders in production.

---

## 7. Claude Code Installed

**Command:**
```bash
claude --version
```

**Pass criteria:** Returns a version number.

**Common blocker:** "command not found."
- **Fix (AUTO-FIX):** `npm install -g @anthropic-ai/claude-code`
- Windows-specific: Ensure npm global bin is in PATH (see Setup Guide Step 9)

---

## 8. Global CLAUDE.md Present

**Command:**
```bash
# Git Bash (Windows) or terminal (Linux/macOS)
cat ~/.claude/CLAUDE.md | head -5
```

**Pass criteria:** Shows the first 5 lines of Lana's QA Lead CLAUDE.md.

**Common blocker:** File missing or wrong content.
- **Fix (AUTO-FIX):** Copy from SOP package: `cp [sop-path]/lana/CLAUDE.md ~/.claude/CLAUDE.md`
- **Category:** WARNING -- Claude Code works without it but lacks role context

---

## 9. Settings.json Present

**Command:**
```bash
cat ~/.claude/settings.json | head -3
```

**Pass criteria:** Shows JSON with `"hooks"` key.

**Common blocker:** File missing.
- **Fix (AUTO-FIX):** Copy from SOP package: `cp [sop-path]/lana/settings.json ~/.claude/settings.json`
- **Category:** WARNING -- hooks for destructive command blocking will not work

---

## 10. MCP Configuration Present

**Command:**
```bash
cat ~/.claude/.mcp.json | head -5
```

**Pass criteria:** Shows JSON with `"mcpServers"` key including `"linear"`.

**Common blocker:** File missing or LINEAR_API_KEY not set.
- **Fix (AUTO-FIX):** Copy file: `cp [sop-path]/lana/mcp.json ~/.claude/.mcp.json`
- **Fix for key:** `export LINEAR_API_KEY="token-from-mamoun"` (session) or `setx LINEAR_API_KEY "token-from-mamoun"` (permanent, Windows only)
- **Category:** BLOCKER if Linear MCP is required for the project

---

## 11. Plugins Installed

**Command:**
```bash
ls ~/.claude/plugins/
```

**Pass criteria:** Shows `.md` plugin files.

**Common blocker:** Empty directory or directory missing.
- **Fix (AUTO-FIX):**
  ```bash
  mkdir -p ~/.claude/plugins
  cp ~/smorchestra/smorch-dist/plugins/*.md ~/.claude/plugins/
  cp ~/smorchestra/smorch-brain/plugins/*.md ~/.claude/plugins/
  ```
- **Category:** WARNING -- skills will be limited

---

## 12. Project CLAUDE.md Present

**Command:**
```bash
cat CLAUDE.md | head -5 2>/dev/null || echo "NO PROJECT CLAUDE.md"
```

**Pass criteria:** Project-specific CLAUDE.md exists in the repo root.

**Common blocker:** No project-level CLAUDE.md.
- **Fix:** Use the `LANA-PROJECT-CONTEXT-TEMPLATE.md` to create one.
- **Category:** WARNING -- Claude Code will lack project-specific context

---

## 13. Tests Run Successfully

**Command:**
```bash
npm test 2>&1 | tail -20
```

**Pass criteria:** All tests pass. Zero failures.

**Common blocker:** Tests fail on fresh clone.
- **Fix:** Check if `.env` is needed for tests. Check if a test database is required.
- **Category:** WARNING if some fail, BLOCKER if all fail

---

## 14. Linting Passes

**Command:**
```bash
npm run lint 2>&1 | tail -20
```

**Pass criteria:** Zero errors. Warnings are acceptable.

**Common blocker:** No lint script defined.
- **Fix:** Check `package.json` for the correct script name (may be `npm run lint:check` or `npx eslint .`)
- **Category:** WARNING

---

## 15. Build Succeeds

**Command:**
```bash
npm run build 2>&1 | tail -20
```

**Pass criteria:** Build completes without errors.

**Common blocker:** TypeScript errors, missing types.
- **Fix:** `npm install` again, check for missing `@types/*` packages
- **Category:** BLOCKER -- cannot deploy if build fails

---

## 16. Quality Gate Score

**Command:**
```bash
claude --print "/score-project composite"
```

**Pass criteria:** Composite score >= 8/10.

**Common blocker:** Score below threshold.
- **Fix:** Review the score breakdown, address the lowest-scoring dimensions first
- **Category:** WARNING on initial onboard (baseline), BLOCKER before any PR

---

## 17. Linear Access Verified

**Command:**
```bash
claude --print "List my Linear issues"
```

**Pass criteria:** Returns a list of issues (even if empty).

**Common blocker:** Auth failure or MCP not configured.
- **Fix:** Verify LINEAR_API_KEY is set: `echo $LINEAR_API_KEY`
- **Fix:** Verify MCP config: `cat ~/.claude/.mcp.json`
- **Category:** BLOCKER -- cannot track or file issues

---

## Consolidated Output Format

After running all checks, produce a summary in this format:

```
PROJECT ONBOARD: [Project Name]
DATE: YYYY-MM-DD
OPERATOR: Lana Al-Kurd

CHECK RESULTS:
 1. Git Clone Verified        [PASS/FAIL]
 2. Correct Branch             [PASS/FAIL]
 3. Branch Up to Date          [PASS/FAIL]
 4. Node.js Version            [PASS/FAIL]
 5. Dependencies Installed     [PASS/FAIL]
 6. Environment Variables      [PASS/FAIL]
 7. Claude Code Installed      [PASS/FAIL]
 8. Global CLAUDE.md Present   [PASS/FAIL]
 9. Settings.json Present      [PASS/FAIL]
10. MCP Configuration Present  [PASS/FAIL]
11. Plugins Installed          [PASS/FAIL]
12. Project CLAUDE.md Present  [PASS/FAIL]
13. Tests Run Successfully     [PASS/FAIL]
14. Linting Passes             [PASS/FAIL]
15. Build Succeeds             [PASS/FAIL]
16. Quality Gate Score         [PASS/FAIL] -- Score: X/10
17. Linear Access Verified     [PASS/FAIL]

BLOCKERS (needs Mamoun):
- [list any BLOCKER items with details]

WARNINGS (degrades experience):
- [list any WARNING items]

AUTO-FIXED:
- [list any items that were auto-fixed during the check]

READY TO WORK: [YES/NO]
```

---

## After All Checks Pass

1. Fill out the `LANA-PROJECT-CONTEXT-TEMPLATE.md` for this project
2. Create your first branch: `git checkout -b human/lana/TASK-XXX-description`
3. Open Claude Code: `claude`
4. Start working on your first Linear ticket
