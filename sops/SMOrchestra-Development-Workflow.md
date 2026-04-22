# SMOrchestra Development Workflow — SINGLE SOURCE OF TRUTH

**Version:** 1.0
**Date:** 2026-04-18
**Owner:** Mamoun Alamouri
**Supersedes:** Workflow text in global CLAUDE.md, INDEX.md, SOP-01, SOP-02. Those files now LINK here.

---

## The Only Workflow That Ships

Every feature ships through these 9 steps. No shortcuts. No "just this once." The quality gates are independently verified — you cannot grade your own work.

```
1. PLAN            → superpowers:writing-plans → gstack:/plan-eng-review
2. CODE            → superpowers:test-driven-development
3. SELF-REVIEW     → gstack:/review (4 dims)
4. SELF-SCORE      → /score-project (5 hats, ≥ 90 composite)
5. FIX GAPS        → /bridge-gaps if any score < 9
6. OPEN PR         → gstack:/ship
7. CI GATES        → GitHub Actions (coverage, Lighthouse, axe, Semgrep, E2E, BRD trace)
8. INDEPENDENT QA  → separate Claude session on smo-test scores PR cold
9. DEPLOY + PROBE  → gstack:/land-and-deploy + Sentry/PostHog event validation
```

Skip any step → PR blocked. No exceptions.

---

## Step-by-Step

### 1. Plan
- **Tool:** `superpowers:writing-plans` then `gstack:/plan-eng-review`
- **Output:** Plan doc in `docs/plans/[feature]-[date].md`
- **Must include:** User stories, acceptance criteria, risk, dependencies
- **Duration:** 20–60 min

### 2. Code (TDD)
- **Tool:** `superpowers:test-driven-development`
- **Rule:** Write failing test first. Implement minimum to pass. Refactor.
- **Every commit:** conventional commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Never:** commit `.env`, `node_modules/`, build artifacts, secrets

### 3. Self-Review
- **Tool:** `gstack:/review`
- **Scope:** 4 dimensions — security, performance, correctness, maintainability
- **Must score:** 8/10 minimum on each dimension
- **If below 8:** fix before proceeding

### 4. Self-Score
- **Tool:** `/score-project`
- **Scope:** 5 hats — product, architecture, engineering, qa, ux-frontend
- **Threshold:** composite ≥ 90 to proceed
- **Output:** saved to `docs/qa-scores/[date]-[version].md`

### 5. Fix Gaps
- **Tool:** `/bridge-gaps`
- **When:** any hat < 9 or composite < 90
- **Output:** fix plan with prioritized tasks + auto-fixes applied
- **Re-score** after fixes

### 6. Open PR
- **Tool:** `gstack:/ship`
- **Target branch:** `dev` (never `main` directly)
- **PR body must have:** handover brief attached (use `templates/LANA-HANDOVER-BRIEF.md`)
- **PR title:** conventional commit style

### 7. CI Gates (GitHub Actions)

Every PR blocks on:

| Gate | Threshold | Workflow |
|------|-----------|----------|
| Type check | 0 errors | `npm run typecheck` |
| Lint | 0 errors | `npm run lint` |
| Unit test coverage | ≥ 80% lines | `npm run test -- --coverage` |
| Build | succeeds | `npm run build` |
| Lighthouse perf | ≥ 90 | `lighthouse-ci-action` |
| axe-core a11y | 0 violations | `npm run test:a11y` |
| Semgrep | 0 high-sev | `returntocorp/semgrep-action` |
| npm audit | 0 high-sev | `npm audit --audit-level=high` |
| Playwright E2E | passes | `npx playwright test` |
| BRD traceability | every AC tagged | `scripts/check-brd-traceability.js` |

If any fails → PR cannot merge. No override without Mamoun approval.

### 8. Independent QA

- **Trigger:** PR opened targeting `dev` branch
- **Runner:** Separate Claude Code session on smo-test (different machine, clean context)
- **Action:** n8n clones PR branch → runs `/score-project` cold → posts composite to PR comment
- **Block:** status check `qa-score` ≥ 90 required to merge

**This is what makes 9.5+ real.** You cannot grade your own work honestly. An independent session catches what your session missed.

### 9. Deploy + Probe

- **Tool:** `gstack:/land-and-deploy`
- **Post-deploy probe script:**
  1. pm2 reload + health endpoint check (3 retries)
  2. Sentry API probe — verify event received within 60s
  3. PostHog API probe — verify event captured
  4. Lighthouse against live URL (perf ≥ 90)
- **Auto-rollback:** if probe fails → `git checkout` previous commit, pm2 reload, re-probe, Telegram alert

---

## Score Thresholds

| Composite | Decision |
|-----------|----------|
| 95+ | Ship. |
| 90–94 | Ship with optional `/bridge-gaps`. |
| 85–89 | Fix gaps. Re-score. Cannot merge until 90+. |
| 80–84 | Blocked. `/bridge-gaps`. Re-score. |
| <80 | Rejected. Escalate to Mamoun. |

---

## Who Does What

| Role | Responsibility |
|------|----------------|
| Dev (Claude Code) | Steps 1–6 |
| CI (GitHub Actions) | Step 7 |
| QA agent (Claude on smo-test) | Step 8 |
| DevOps (n8n + probe script) | Step 9 |
| Mamoun | Approve overrides, approve Codex use (SOP-11), approve production migrations |
| Lana | Human QA for SEV1 edge cases only |

---

## What Makes This 9.5+

**The jump from 7 → 9.5 is Step 8 (independent QA).**

A single Claude session scoring its own code inflates. You've lived this. `/score-project` returns "95 composite" while real quality is ~75.

Step 8 breaks the loop. A fresh Claude session on smo-test with no context about your decisions runs `/score-project` and sees the code as a reviewer, not an author. That score is real.

Steps 7 and 9 handle what's not subjective: coverage, perf, a11y, security, deploy success.

Remove any step and the number goes back to 7.

---

## References (other docs link here)

- Global CLAUDE.md `DEV TOOLS` section → links here for detail
- INDEX.md `Dev Tool Suites` section → links here
- SOP-01 QA Protocol → phases 2-3 superseded by CI + QA agent in this doc
- SOP-02 Pre-Upload Scoring → thresholds match this doc; scoring logic here is authoritative

If any doc contradicts this one, this one wins.
