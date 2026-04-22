# SOP-10: Session Start & Finish Checklist

**Version:** 1.0
**Date:** 2026-04-17
**Owner:** Mamoun Alamouri
**Scope:** Every coding session — Claude Code, human devs, QA team
**Enforcement:** Claude Code SessionStart hook + CLAUDE.md rules
**Goal:** GitHub = single source of truth. Zero drift between Desktop, GitHub, and server.

---

## START OF WORK (mandatory, no exceptions)

### Step 1: Verify Directory (10 seconds)

```bash
git rev-parse --show-toplevel
```

**Must match** your project folder in `~/Desktop/cowork-workspace/CodingProjects/{project}/`.

If it returns a PARENT directory (like `~`), you are in the WRONG folder. Stop and cd to the correct project folder. See Project Registry in CLAUDE.md.

### Step 2: Verify Remote (10 seconds)

```bash
git remote get-url origin
```

| If Remote Shows | Expected |
|----------------|----------|
| `SMOrchestra-ai/...` | Production code |
| `smorchestraai-code/...` | Forks/parking only |

If production code points to `smorchestraai-code`, STOP. Transfer to org first.

### Step 3: Pull Latest (30 seconds)

```bash
git fetch origin
git status
```

If behind remote → `git pull origin {branch}` before ANY changes.
If diverged → `git pull --rebase origin {branch}`.
NEVER start work on a stale branch.

### Step 4: Verify Branch (10 seconds)

```bash
git branch --show-current
```

Must be `main`, `dev`, `feat/*`, or `human/*`. If detached HEAD, fix before proceeding.

### Step 5: Server Sync Check (for deployed projects only)

```bash
# SSH to server
ssh {server} "cd {path} && git log --oneline -1"
# Compare with
git log --oneline origin/{branch} -1
```

If server is behind GitHub → deploy before starting new work.

**Total: ~60 seconds. No shortcuts.**

---

## DURING WORK

### Commit Discipline

- Commit logical units as you go (not one giant commit at the end)
- Conventional commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`
- Include task reference when applicable: `feat(TASK-42): description`
- Agent commits include: `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

### Branch Model

| Branch | Who | Purpose |
|--------|-----|---------|
| `main` | Protected | Production releases only |
| `dev` | Protected | Integration branch |
| `feat/{name}` | Anyone | Feature work |
| `fix/{name}` | Anyone | Bug fixes |
| `human/{name}/TASK-XXX` | Human devs | Task-specific |

### Never Do During Work

- Edit files directly on the server
- Commit `.env`, secrets, `node_modules/`, `.next/`, build artifacts
- Push directly to `main` (always use PR)
- Leave uncommitted work when switching projects

---

## END OF WORK (mandatory, no exceptions)

### Step 1: Commit All Changes

```bash
git status
# If any changes:
git add {specific files}
git commit -m "type: description"
```

**NEVER leave uncommitted work.** If work is incomplete, commit with `chore: WIP — {description}`.

### Step 2: Push to GitHub

```bash
git push origin {branch}
```

GitHub must have your latest at all times. If you close your laptop without pushing, you violated this SOP.

### Step 3: Create PR (if work is complete)

```bash
gh pr create --title "type: description" --body "## Summary\n- ...\n## Test plan\n- ..."
```

### Step 4: Deploy to Server (if merging to main/dev)

```bash
# After PR merge:
ssh {server} "cd {path} && git pull origin {branch} && npm run build && pm2 restart {process}"
```

### Step 5: Verify 3-Way Sync

```bash
# Local
git log --oneline -1
# GitHub
git log --oneline origin/{branch} -1
# Server
ssh {server} "cd {path} && git log --oneline -1"
```

All three must show the same commit hash. If not, fix before closing.

### Step 6: Notify QA (if deploying)

After deploying, notify QA team:
- What was deployed
- Which URL to test
- What changed (link to PR)

---

## PARALLEL WORK (handling QA versions)

### Rule: QA Always Tests What's on the Server

QA never tests from localhost. QA tests the deployed server URL.

### Branching for Parallel Work

```
main (production) ← tagged releases
  └── dev (integration) ← all PRs merge here
       ├── feat/feature-a (developer 1)
       ├── feat/feature-b (developer 2)
       └── fix/bug-123 (developer 3)
```

### QA Flow

1. Developer finishes work → PR to `dev`
2. PR merged to `dev`
3. Deploy `dev` branch to server: `git pull origin dev && npm run build && pm2 restart`
4. Notify QA: "dev deployed at {URL}, ready for testing"
5. QA tests on server
6. QA passes → PR from `dev` to `main` (release)
7. Deploy `main` to production server

### If QA Finds Bugs

1. QA reports bug with: URL, steps to reproduce, expected vs actual
2. Developer creates `fix/{bug-name}` branch from `dev`
3. Fix → PR to `dev` → deploy → QA re-tests
4. Repeat until QA passes

### Version Tracking

Every deployment has a commit hash. To verify what QA is testing:

```bash
# On server
git log --oneline -1
# Output: abc1234 feat: add Arabic RTL support

# On GitHub
gh pr list --state merged --limit 5
```

---

## ENFORCEMENT

### Automated (hooks)

| Hook | What It Checks | When |
|------|---------------|------|
| SessionStart | .git root matches CWD, remote matches expected, branch is not behind | Every session start |
| PreToolUse:Bash | Blocks destructive commands (rm -rf, git push --force, etc.) | Every bash command |
| PreToolUse:Write/Edit | Blocks secrets in code files | Every file edit |

### Manual (checklist)

Print this and tape it next to your monitor:

```
START:
[ ] Right folder? (git rev-parse --show-toplevel)
[ ] Right remote? (git remote get-url origin)
[ ] Pulled latest? (git fetch && git status)
[ ] Right branch? (git branch --show-current)

FINISH:
[ ] All committed? (git status clean)
[ ] Pushed to GitHub? (git push)
[ ] PR created? (if work complete)
[ ] Server deployed? (if merging)
[ ] 3-way sync verified? (local = GitHub = server)
```

---

## PROJECT REGISTRY (master reference)

| Project | Folder | GitHub Repo | Branch | Server | Deploy Path | PM2 |
|---------|--------|-------------|--------|--------|-------------|-----|
| EO MENA | EO-MENA/ | SMOrchestra-ai/eo-mena | main | contabo-main | /root/eo-mena-new/ | eo-main |
| EO Scorecard | EO-Scorecard-Platform/ | SMOrchestra-ai/EO-Scorecard-Platform | dev | contabo-main | /var/www/eo-scoring/ | eo-scoring |
| Content Auto | content-automation/ | SMOrchestra-ai/content-automation | dev | smo-dev | /root/content-automation/ | content |
| GTM Scorecard | gtm-fitness-scorecard/ | smorchestraai-code/gtm-fitness-scorecard | dev | contabo-main | TBD | TBD |
| Digital Revenue | digital-revenue-score/ | SMOrchestra-ai/digital-revenue-score | dev | contabo-main | TBD | TBD |
| Contabo MCP | contabo-mcp-server/ | SMOrchestra-ai/contabo-mcp-server | feat/monorepo-consolidation | N/A | N/A | N/A |
| Freepik MCP | freepik-mcp/ | freepik-company/freepik-mcp | main | N/A | N/A | N/A |
| smorch-brain | smorch-brain/ | SMOrchestra-ai/smorch-brain | dev | contabo-main | /root/smorch-brain/ | N/A |

All folders are at: `~/Desktop/cowork-workspace/CodingProjects/{folder}/`
All folders have `.git` at their root.
