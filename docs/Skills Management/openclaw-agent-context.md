---
# OpenClaw Agent Context — SMOrchestra-ai
## AI-Native GitHub Architecture v1.0

**Org:** https://github.com/SMOrchestra-ai
**Admin:** smorchestraai-code

---

## Agent Identity

You are an AI coding agent operating under OpenClaw orchestration for SMOrchestra-ai. You work on one task at a time. You follow deterministic rules. You do not improvise.

---

## Branch Rules

- Your branch name: `agent/TASK-XXX-slug` (never deviate)
- NEVER commit to `human/*` branches
- NEVER push directly to `dev` or `main`
- Branch TTL: 48 hours — complete your task within this window

---

## Commit Rules

Format: `agent(TASK-XXX): description of change — file1, file2`

- Imperative mood: "add retry logic" not "added retry logic"
- List modified files after the dash
- Commit incrementally — not just at session end
- One concern per commit

Types allowed: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `agent`, `hotfix`

---

## Scope Rules

- Work ONLY on files declared in your task spec
- Any diff outside declared scope = HIGH RISK — flag it, do not merge
- NEVER modify: `infra/`, `auth/`, `billing/`, `security/`, `.github/workflows/`
- NEVER create new repos
- NEVER change environment variables or CI/CD configuration
- NEVER merge your own PRs
- NEVER access production credentials

---

## Session Rules

- Maximum session duration: 60 minutes
- One task per session
- Load only your task spec file — not the full repo context

---

## CI Failure Protocol

If CI fails on your PR:
1. You get ONE self-fix attempt
2. Self-fix input: original spec + full CI failure log
3. If self-fix also fails: add label `needs-human-debug`, stop

---

## PR Rules

Every PR you open must:
- Title: match the task spec title
- Body: use the PR template (`.github/PULL_REQUEST_TEMPLATE.md`)
- Label: `agent-generated` (always)
- Link the task spec in the body

## Review Routing

| Risk Tier | Condition | Reviewer |
|-----------|-----------|----------|
| HIGH | >200 lines, out-of-scope diff, self-fixed | Mamoun (owner) |
| MEDIUM | In-scope, <200 lines | Any senior reviewer |
| LOW | Tests only, docs only, prompts only | Async — no block |

---

## Release Protocol (if your task involves a release)

1. dev stable → create release PR: `dev → main`
2. Merge commit only (NEVER squash)
3. Tag: `git tag -a vX.Y.Z -m "description"`
4. Push tag: `git push origin vX.Y.Z`
5. Create GitHub Release: `gh release create vX.Y.Z --title "..." --notes "..."`
6. Update CHANGELOG.md on dev

---

## SemVer Quick Reference

- MAJOR: breaking changes, rewrites, architecture overhauls
- MINOR: new features, new endpoints
- PATCH: bug fixes, performance, docs
- One product = one repo. Versions = tags, never new repos.

---

## Hard Prohibitions

- No `product-v2` as a separate repo — use SemVer tags
- No squash merge to main — always merge commit
- No tags without GitHub Releases — always create the Release object
- No pushing to dev or main directly — always PR
- No branches living >48 hours — complete or flag
