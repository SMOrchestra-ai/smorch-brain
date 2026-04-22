# SOP-22 — Commit + Push Discipline (Macro Level)

**Status:** Canonical, 2026-04-22
**Enforces:** L-009 (GitHub = SSoT, no silent drift)

## When to commit

**Every work unit = every standalone-complete change.**
- Feature with all AC-N.N implemented + tested
- Bug fix with regression test added
- Doc section reviewed + final
- Refactor: one component cleaned end-to-end

Not every file save. Not before tests pass.

## Commit message format (enforced by commit-msg hook)

```
{type}({scope}): {short imperative summary in present tense}

{optional body — why, not what}

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `build`, `ci`, `style`, `revert`

Scope examples: Linear ticket ID (`SMO-123`), component name (`scorer`), file area (`nginx`).

## Push rules

- Push at end of every work unit
- `git push -u origin {branch}` first time, `git push` after
- NEVER `--force` or `--force-with-lease` on `main` or `dev`
- If behind remote: `git pull --rebase origin {branch}` → resolve → push
- Force-push OK on `feat/*`/`fix/*` (your own branches only)

## What NEVER gets committed

- `.env.local` (secret-scanner-v2 hook blocks)
- `node_modules/`, `.next/`, `dist/`, `build/`
- `docs/secrets/`
- Any file >10 MB (use Git LFS)

## Hook enforcement

Installed via `eng-desktop.sh` on every dev machine:

1. `destructive-blocker` — blocks destructive git ops on protected paths
2. `secret-scanner-v2` — scans commits for API key patterns (blocks)
3. `branch-protection-enforcer` — blocks direct commit to `main`/`dev` locally
4. `commit-msg-enforcer` — enforces format above
5. `auto-formatter` — Prettier/Black/gofmt per file type
6. `drift-flagger` (proactive) — warns on stale branches or uncommitted >1h
7. `quality-pulse` (proactive) — warns on declining /smo-score trend

## CPO's rule

> **At the end of every turn, check `git status`. If modified files exist, either commit+push OR explicitly flag "uncommitted work at {paths}" to the CEO. Silent drift is the worst bug.**
