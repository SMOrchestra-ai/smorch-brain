# SOP-3: GitHub Standards & Repo Management

**Version:** 2.0 | **Date:** March 2026
**Scope:** Every project in the SMOrchestra GitHub org
**GitHub Org:** SMOrchestra-ai
**User Account:** smorchestraai-code
**Team Member:** @lanaalkurdsmo (when collaborating)

---

## Claude Code's Role: GitHub Admin + CPO

Claude Code acts as the **GitHub administrator** and **Chief Product Officer** for all SMOrchestra repos. This means:

1. **Own the dev pipeline** — enforce branch model, conventional commits, release protocol, QA gates
2. **Own version control** — decide when to bump major/minor/patch, enforce SemVer, create releases
3. **Own documentation** — CHANGELOG, AGENTS.md, README, ADRs must be current at all times
4. **Own repo hygiene** — flag stale branches, orphaned tags, missing files, incorrect remotes
5. **Own governance** — verify every push goes to the right account, every PR follows the template, every release passes QA

**Claude Code does NOT:**
- Merge to main without Mamoun's approval (MAMOUN-REQUIRED)
- Create or delete repos without Mamoun's approval
- Change team membership or permissions
- Make architecture decisions — only recommend

---

## Rule 0: Two-Account Architecture

SMOrchestra uses two GitHub locations with strict separation:

### smorchestraai-code (User Account) — Parking + Open Source

| What Goes Here | Examples |
|---------------|---------|
| **Forked open source repos** | gstack, paperclip, superpowers |
| **Parking repos** (pre-production, lead magnets, experiments) | gtm-fitness-scorecard |
| **Archived repos** (retired versions, superseded code) | Signal-Sales-Engine-v1, Signal-Based- |

**Rules for user account:**
- NO production code lives here
- Archived repos are reviewed every 4 weeks — delete if no longer needed
- Forks stay as-is (upstream reference)
- Parking repos move to org when they become production

### SMOrchestra-ai (Org) — All Live/Production Repos

| What Goes Here | Examples |
|---------------|---------|
| **All production products** | SaaSFast, EO-Scorecard-Platform, Signal-Sales-Engine, eo-mena |
| **Internal tools & infrastructure** | smorch-brain, smorch-dist, smorch-context, supervibes |
| **Team collaboration repos** | Any repo the team works on |

**Rules for org:**
- Every live product MUST be here
- All team members access repos through the org
- Branch protection enforced on main + dev
- CODEOWNERS, AGENTS.md, CHANGELOG.md required

### How to Verify (Claude Code runs this every session)
```bash
git remote -v | grep -E "(SMOrchestra-ai|smorchestraai-code)"
```

| If Remote Shows | And Repo Is | Action |
|----------------|-------------|--------|
| `SMOrchestra-ai` | Production code | CORRECT — proceed |
| `smorchestraai-code` | Production code | WRONG — STOP. Ask Mamoun. Likely needs transfer to org. |
| `smorchestraai-code` | Fork/parking/archived | CORRECT — proceed |
| Any other account | Anything | WRONG — STOP immediately. Ask Mamoun. |

### Current Repo Inventory (as of March 2026)

**smorchestraai-code (User):**
| Repo | Type | Status |
|------|------|--------|
| gstack | Fork (open source) | Active |
| paperclip | Fork (open source) | Active |
| superpowers | Fork (open source) | Active |
| gtm-fitness-scorecard | Parking (lead magnet) | Active |
| Signal-Sales-Engine-v1 | Archived | 4-week review pending |
| Signal-Based- | Archived | 4-week review pending |

**SMOrchestra-ai (Org):**
| Repo | Product | Status |
|------|---------|--------|
| SaaSFast | MicroSaaS Launcher Platform | Live v3.0.0 |
| EO-Scorecard-Platform | EO Assessment Scorecards | Live |
| Signal-Sales-Engine | B2B Signal Intelligence Stack | Live v3 |
| eo-mena | EO MENA Regional Platform | Live |
| smorch-brain | Skills Registry + CLI | Live |
| smorch-dist | Plugin Distribution | Live |
| smorch-context | Business Context Files | Live |
| supervibes | Parallel Claude Code Orchestration | Live |

---

## Rule 1: Always Push to the Org for Production Code

**THE RULE:** All production code goes to `SMOrchestra-ai` org repos. Never to the user account.

Before every push, Claude Code MUST verify:
```bash
git remote -v | grep "SMOrchestra-ai"
```

If the remote points to `smorchestraai-code` for production code, STOP and ask Mamoun.

| Right | Wrong |
|-------|-------|
| `github.com/SMOrchestra-ai/SaaSFast.git` | `github.com/smorchestraai-code/SaaSFast.git` |
| `github.com/SMOrchestra-ai/Signal-Sales-Engine.git` | `github.com/smorchestraai-code/Signal-Sales-Engine.git` |
| `github.com/smorchestraai-code/gstack.git` (fork) | `github.com/SMOrchestra-ai/gstack.git` (wrong location for fork) |

---

## Rule 2: Branch Naming Convention

| Pattern | Who Creates | Example |
|---------|-----------|---------|
| `main` | Protected | Never push directly |
| `dev` | Protected (default) | Never push directly |
| `human/[name]/TASK-XXX-slug` | Human developer | `human/mamoun/TASK-042-arabic-rtl` |
| `agent/TASK-XXX-slug` | OpenClaw/Claude Code | `agent/TASK-042-arabic-rtl` |
| `feature/[name]` | Developer | `feature/config-refactor` |
| `hotfix/[slug]` | Mamoun only | `hotfix/auth-token-fix` |
| `sandbox/[experiment]` | Anyone | `sandbox/v2-experiment` |

**Enforced by:** PreToolUse hook on git push (validates branch name before push).

---

## Rule 3: Conventional Commits

Every commit message must follow:
```
type(scope): description

Types: feat, fix, refactor, test, docs, chore, agent, hotfix
```

| Type | When | Example |
|------|------|---------|
| `feat` | New feature | `feat(TASK-42): add Arabic RTL support` |
| `fix` | Bug fix | `fix: resolve null pointer on empty payload` |
| `refactor` | Code restructure | `refactor: extract scoring engine to module` |
| `test` | Tests | `test(TASK-42): add RTL rendering tests` |
| `docs` | Docs only | `docs: update CHANGELOG for v1.0.0` |
| `chore` | Config, deps | `chore: upgrade supabase-js to v2.45` |
| `agent` | AI agent work | `agent(TASK-42): implement RTL per spec` |
| `hotfix` | Production emergency | `hotfix: fix auth token expiry` |

**Enforced by:** Git commit-msg hook (rejects non-conforming messages at git level).

---

## Rule 4: Version Control — Tags and Releases

### When to Bump Versions

| Change Type | Version Bump | Example |
|------------|-------------|---------|
| Breaking changes, rewrites | MAJOR | v1.0.0 → v2.0.0 |
| New features, enhancements | MINOR | v1.0.0 → v1.1.0 |
| Bug fixes, patches | PATCH | v1.0.0 → v1.0.1 |

### The Golden Rule
**One product = one repo. Versions are tags, not repos.**
Never create `product-v2` as a separate repo. Tag versions in the same repo.

### Release Protocol
```
1. dev is stable, all target PRs merged
2. Run SOP-1 QA Protocol — must score 90+
3. Create release PR: dev → main
4. Mamoun reviews and approves                    ← MAMOUN-REQUIRED
5. Merge to main (merge commit, NOT squash)
6. Tag: git tag -a vX.Y.Z -m "description"
7. Push tag: git push origin vX.Y.Z
8. Create GitHub Release: gh release create vX.Y.Z --notes-file RELEASE_NOTES.md
9. Update CHANGELOG.md on dev
10. Verify: gh api repos/SMOrchestra-ai/REPO/releases --jq '.[0].tag_name'
```

### Hotfix Protocol
```
1. Branch: git checkout -b hotfix/[slug] from main
2. Fix the issue
3. PR to main — Mamoun reviews                    ← MAMOUN-REQUIRED
4. After merge to main: tag, release, CHANGELOG
5. CRITICAL: Merge hotfix back to dev             ← Prevents drift
   git checkout dev && git merge hotfix/[slug]
```

### Agent Commits Must Include Co-Authored-By
```
agent(TASK-XXX): description of change

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

---

## Rule 5: PR Standards

Every PR must include:
- **Summary** (1-3 bullet points)
- **Task reference** (Linear ticket or task spec)
- **Quality score** (from SOP-2 Pre-Upload Scoring)
- **Testing checklist** (what was tested)
- **Risk assessment** (HIGH/MEDIUM/LOW)

**Template enforced by:** `.github/PULL_REQUEST_TEMPLATE.md`

---

## Rule 6: Required Files Checklist

Before pushing ANY new project, verify:

```
[ ] README.md — describes what this is
[ ] CHANGELOG.md — release history
[ ] AGENTS.md — AI agent behavior rules
[ ] .claude/CLAUDE.md — Claude Code project context + Required Skills
[ ] .github/CODEOWNERS — file ownership
[ ] .github/PULL_REQUEST_TEMPLATE.md — PR template
[ ] .github/ISSUE_TEMPLATE/ — bug, feature, task templates
[ ] .github/workflows/ci.yml — CI pipeline
[ ] .github/workflows/changelog-check.yml — CHANGELOG enforcement
[ ] .github/workflows/agent-scope-check.yml — agent PR scope check
[ ] SOPs/ — all 4 SOP files
```

---

## Rule 7: What Requires MAMOUN-REQUIRED Approval

Claude Code must STOP and ASK Mamoun before:

| Action | Why |
|--------|-----|
| Creating a new repo | Repo structure affects the entire org |
| Changing branch protection rules | Security-critical |
| Modifying infra/, auth/, billing/ files | High blast radius |
| Releasing to main (dev → main merge) | Production deployment |
| Force pushing to any branch | Destructive — rewrites history |
| Archiving or deleting a repo | Irreversible |
| Adding a new team member to the org | Access control |
| Changing CODEOWNERS | Ownership changes |

---

## Rule 8: Do NOT Do These Things

| Don't | Why | Do This Instead |
|-------|-----|-----------------|
| Push to personal GitHub account | All code belongs to org | Always push to SMOrchestra-ai |
| Create product-v2 as separate repo | Splits history | Use SemVer tags in same repo |
| Skip CHANGELOG on releases | Nobody knows what changed | Update CHANGELOG with every release |
| Push directly to main or dev | Bypasses review | Always use PRs |
| Create tags without GitHub Releases | Tags are invisible | Always create Release for each tag |
| Delete branches without checking | May contain work | Archive or merge first |
| Commit .env files | Credential leak | Use .env.example only |
| Make architecture decisions without ADR | Decision rationale lost | Create docs/adr/ADR-XXX.md for every arch decision |
| Merge without QA score | Quality unknown | Always run SOP-1 or SOP-2 first |

---

## Rule 9: Archive Cleanup Cycle (Every 4 Weeks)

Claude Code flags archived repos for review on the 1st of each month:

```
For each archived repo on smorchestraai-code:
1. When was it archived?
2. Has anyone accessed it in 4 weeks?
3. Is there any code worth preserving that isn't in the org?
4. Recommendation: DELETE or KEEP (with reason)
```

**MAMOUN-REQUIRED:** Deleting archived repos is irreversible. Claude Code recommends, Mamoun decides.

### Repo Lifecycle

```
Parking (user) → Production (org) → Archived (user) → Deleted (after 4-week review)
                                          ↑
Fork (user) ← stays here permanently
```

---

## Rule 10: Moving Repos Between Accounts

### Parking → Production (user → org)
When a repo graduates from parking to production:
```bash
# 1. Create repo on org
gh repo create SMOrchestra-ai/REPO-NAME --private --default-branch dev

# 2. Push all branches and tags from local clone
cd ~/local-clone
git remote add org https://github.com/SMOrchestra-ai/REPO-NAME.git
git push org --all
git push org --tags

# 3. Update local remote
git remote remove origin
git remote rename org origin

# 4. Set up branch protection on org
gh api -X PUT repos/SMOrchestra-ai/REPO-NAME/branches/main/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1
gh api -X PUT repos/SMOrchestra-ai/REPO-NAME/branches/dev/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1

# 5. Archive the old repo on user account
gh repo archive smorchestraai-code/REPO-NAME --yes

# 6. Update repo description on org
gh repo edit SMOrchestra-ai/REPO-NAME --description "..." --add-topic ...
```

### Production → Archived (org → user archive)
When a product is retired:
```bash
# 1. Ensure final release is tagged and released
# 2. Archive on org: gh repo archive SMOrchestra-ai/REPO-NAME --yes
# 3. Repo stays on org (archived) — do NOT move to user
```

---

## Quick Command Reference

```bash
# Start fresh
git checkout dev && git pull origin dev
git checkout -b human/mamoun/TASK-XXX-slug

# Commit
git commit -m "feat(TASK-XXX): description"

# Release
gh pr create --base main --head dev --title "Release vX.Y.Z"
# After merge:
git tag -a vX.Y.Z -m "description"
git push origin vX.Y.Z
gh release create vX.Y.Z --title "vX.Y.Z — Title" --notes "..."

# Check repo health
gh repo list SMOrchestra-ai --json name,description
gh api repos/SMOrchestra-ai/REPO/releases
```
