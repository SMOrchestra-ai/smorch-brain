# SOP-3: GitHub Standards & Repo Management

**Version:** 1.0 | **Date:** March 2026
**Scope:** Every project in the SMOrchestra GitHub org
**GitHub Org:** SMOrchestra-ai
**Admin Account:** smorchestraai-code
**Team Member:** @lanaalkurdsmo (when collaborating)

---

## Rule 1: Always Push to the Org, Never Personal Accounts

**THE RULE:** All code goes to `SMOrchestra-ai` org repos. Never to personal GitHub accounts.

Before every push, Claude Code MUST verify:
```bash
git remote -v | grep "SMOrchestra-ai"
```

If the remote points anywhere other than `SMOrchestra-ai`, STOP and ask Mamoun.

| Right | Wrong |
|-------|-------|
| `github.com/SMOrchestra-ai/SaaSFast.git` | `github.com/mamounalamouri/SaaSFast.git` |
| `github.com/SMOrchestra-ai/eo-assessment-system.git` | `github.com/lanaalkurdsmo/eo-assessment-system.git` |

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
2. Create release PR: dev → main
3. Mamoun reviews and approves                    ← MAMOUN-REQUIRED
4. Merge to main (merge commit, NOT squash)
5. Tag: git tag -a vX.Y.Z -m "description"
6. Push tag: git push origin vX.Y.Z
7. Create GitHub Release: gh release create vX.Y.Z ...
8. Update CHANGELOG.md on dev
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
