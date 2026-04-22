# SOP-32 — App Patching + Versioning (enforced)

**Status:** Active 2026-04-23

## Semantic version rules

- **Patch** (`vX.Y.Z → vX.Y.(Z+1)`): bug fix, no contract change, no DB migration
- **Minor** (`vX.Y.Z → vX.(Y+1).0`): new feature backward-compatible
- **Major** (`vX.Y.Z → v(X+1).0.0`): breaking API/schema change — requires ADR + migration script

## Hotfix path (SEV1 only)

Branch pattern: `hotfix/PROD-SEV{1-4}-{slug}`. Only this prefix can PR directly to `main` (branch protection otherwise blocks). Flow:

1. `git checkout main && git pull`
2. `git checkout -b hotfix/PROD-SEV1-{slug}`
3. fix + test
4. PR to main — CEO 1-approval (branch protection enforces)
5. merge → tag `vX.Y.(Z+1)` → `/smo-deploy --env production`
6. backport: PR hotfix branch → dev, merge
7. `/smo-incident SEV{N}` writeup in `docs/incidents/`

## Regular fix path

Branch: `fix/SMO-{linear-id}-{slug}` (or `feat/SMO-{id}-{slug}` for features). PR target: `dev`. Standard /smo-plan → /smo-deploy chain.

## v2 (major) path

Required artifacts before first `feat/v2-*` commit:
- `architecture/adrs/ADR-NNN-v2-{slug}.md` — motivation, breaking changes list, migration plan
- Updated `architecture/brd.md` — new ACs, old AC numbers preserved with "DEPRECATED v1" note
- `scripts/migrate-v1-to-v2.{sh,sql}` — idempotent + reversible
- Migration test: `tests/migration/v1-to-v2.test.ts`
- CHANGELOG.md entry at top with prominent BREAKING banner

Enforcement: `/smo-score` Architecture hat caps at 6 if any artifact missing. Merge blocked by ship gate.

## New-repo v2 path (rarer)

When rewriting for different audience/product, not in-place:
1. New repo per Guide 01 + SOP-31
2. Old repo: `gh repo edit --add-topic status-archived --remove-topic status-{production|beta|dev}`
3. ADR in old repo `architecture/adrs/ADR-DEPRECATED.md` pointing to new repo
4. Old repo README.md top: `⚠️ DEPRECATED — see {new-repo-url}`
5. After 30-day buffer: `gh repo archive {old-repo}`

## Rollback SLA

| Environment | SLA |
|---|---|
| Production | ≤90 seconds |
| Staging | ≤120 seconds |

`/smo-rollback --env production` is the only sanctioned rollback mechanism. Audit-logged. Telegram-notified. Reverses git tag + rebuilds + reloads pm2/docker + health-checks. If SLA missed → SEV1 incident.

## Enforcement

- Branch protection on `main`: only `hotfix/PROD-SEV*-*` branches OR PRs from `dev` can merge
- Pre-commit hook rejects `fix/*` branches committing directly to main
- `/smo-ship` blocks if:
  - No CHANGELOG.md entry for this version
  - No matching `vX.Y.Z` tag planned (dry-run tag check)
  - For major: ADR file missing + migration script missing

## Version bump automation

`/smo-ship` auto-computes next version based on commit prefix:
- `fix:` / `hotfix:` → patch
- `feat:` → minor
- `feat!:` or `BREAKING CHANGE:` footer → major
- Writes CHANGELOG entry, creates tag, pushes.

Overrides: `/smo-ship --version v2.0.0` (explicit).
