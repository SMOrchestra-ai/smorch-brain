# SOP-31 — New App Bootstrap (enforced)

**Status:** Active 2026-04-23
**Supersedes:** SOP-08 Project-Kickoff-PreDev-Check (now legacy)
**Scope:** every new repo in SMOrchestra-ai or smorchestraai-code orgs

---

## Rule

A new repo cannot have its first non-scaffold commit until ALL of these exist and are committed:

| File | Source | Enforced by |
|---|---|---|
| `CLAUDE.md` | copy from `smorch-brain/canonical/claude-md/per-app-CLAUDE-template.md`, filled | pre-commit hook + `/smo-score` Boris check |
| `architecture/brd.md` | written per Guide 01 §4 | `/smo-plan` refuses to run if missing |
| `.smorch/project.json` | filled per Guide 01 §6 | `/smo-deploy` + `/smo-drift` require it |
| `.claude/lessons.md` | empty file OK | `/smo-retro` requires file |
| `.claude/settings.json` | copy from `smorch-brain/canonical/claude-md/per-app-settings-hook.json` | SessionStart hook reads it |
| `docs/` with 6 subdirs | `handovers/ qa-scores/ qa/ incidents/ deploys/ retros/` | pre-commit hook |
| `.env.example` | variable names only, no values | secret-scanner-v2 hook ensures no values |
| `.gitignore` | must exclude `node_modules .env* .next dist build .venv` | pre-commit hook |
| `tests/` | empty dir OK | `/smo-score` Engineering Q2 requires tests |

## Enforcement script

`smorch-dev/scripts/hooks/validate-new-app-structure.sh` — runs on every commit to a newly-created repo (detects via `git rev-list HEAD --count < 3`). Any missing file = commit rejected.

## Also enforced

- GitHub canonical tags (domain + lifecycle + distribution) — via `/smo-drift --desktop` and daily github-drift.sh
- Branch protection on `main` from day 1 — applied by `phase-1-apply.sh` (rerun for new repos)
- Default branch = `main`, working branch = `dev` — enforced by `branch-protection-enforcer` git hook

## Exceptions

- **Research spike**: dir named `_spike-*` inside an existing repo — no separate repo, no gates. Promoted to proper scaffold before any PR.
- **External fork**: just `gh repo fork`, then add canonical topic `external-fork` + `status-dev`. No Boris structure required.

## Workflow

Use Guide 01 (`guides/01-START-NEW-APP.md`). This SOP is the mechanical enforcement; the guide is the playbook.
