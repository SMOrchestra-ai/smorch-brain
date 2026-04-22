# SOP-20 — Branch Model (Production is Sacred)

**Status:** Canonical, 2026-04-22
**Scope:** Every active SMOrchestra repo (SMOrchestra-ai + smorchestraai-code orgs, excluding archives + external forks)
**Enforces:** L-009 (GitHub = SSoT), L-014 candidate (no dev on prod branch)

## The model

```
main    = production. Reflects prod server state. NOBODY develops here.
dev     = active development. All feature PRs target this.
feat/*  = feature branches (from dev → dev)
fix/*   = bug fix branches (from dev → dev)
hotfix/* = emergency only (from main → main + dev)
```

## Developer macro-flow

1. `git checkout dev && git pull --ff-only origin dev`
2. `git checkout -b feat/SMO-123-short-description`
3. Work. Tests. `/smo-score ≥92` (top-3 hats 80% weight per SOP-23). `/smo-handover`.
4. `git add <specific-files>` (never `git add .`)
5. `git commit -m "..."` per SOP-22 format
6. `git push -u origin feat/SMO-123-short-description`
7. `gh pr create --base dev --title "..." --body "Linear: SMO-123, score attached, Lana QA pass attached"`
8. Review → merge squash → dev updated
9. Release: `gh pr create --base main --head dev --title "release vX.Y.Z"` → CEO approves → merge → auto-deploy
10. `git tag vX.Y.Z && git push origin vX.Y.Z`

## Prohibitions (enforced by branch protection)

- ❌ Direct commit to `main`
- ❌ Direct commit to `dev` (PR only)
- ❌ Force push to `main` or `dev`
- ❌ Delete `main` or `dev`
- ❌ PR merge without required reviews + CI green
- ❌ Bypass branch protection (admin enforcement on)

## Hotfix exception (SEV1 only)

```
git checkout main && git pull
git checkout -b hotfix/PROD-SEV1-description
# fix
gh pr create --base main → CEO approve → merge → deploy
gh pr create --base dev --head hotfix/PROD-SEV1-description → merge (sync dev with main)
```

## status-dev repos (no production yet)

- `main` may not exist yet OR exists as "promote-ready" marker
- When ready for first prod deploy → create `main` from `dev` → flip `status-dev` → `status-beta` via CEO PR

## status-archived repos

- GitHub archive flag ON
- README.md points to successor
- No branches modified
