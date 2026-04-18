# SOP: Independent QA Agent (smo-test)

**Version:** 1.0
**Date:** 2026-04-18
**Owner:** Mamoun Alamouri
**Status:** Active

---

## Purpose

Kill the self-verification loop that caps quality at ~7/10. Claude Code scoring its own work in the same session inflates scores. An independent Claude session on a different machine with clean context gives honest numbers.

This SOP defines how that independent session runs.

## Infrastructure

| Component | Where | Role |
|-----------|-------|------|
| smo-test server | 84.247.172.113 (Tailscale 100.105.86.13) | Runs the QA agent |
| QA runner script | `/opt/qa-runner.sh` | Clones PR branch, runs `/score-project`, posts comment |
| n8n workflow | flow.smorchestra.ai `qa-agent-trigger` | GitHub webhook → SSH to smo-test → run script |
| GitHub branch protection | `dev` branch, each repo | Requires `qa-score` status check ≥ 90 |
| Skills on smo-test | `/root/.claude/skills/` (82 skills) | Same as dev machines — gstack, superpowers, smorch-dev-scoring |

## How It Works

```
Developer opens PR to dev branch
         │
         ▼
GitHub webhook → n8n (flow.smorchestra.ai)
         │
         ▼
n8n SSHes to smo-test, runs:
  bash /opt/qa-runner.sh <owner> <repo> <pr-number>
         │
         ▼
qa-runner.sh:
  1. Clone repo fresh to /tmp/qa-<repo>-<pr>
  2. git fetch pull/<pr>/head → checkout
  3. npm ci
  4. claude --print "Run /score-project on this codebase"
  5. Extract composite score (0-100)
  6. Post markdown comment to PR with full report
  7. Set GitHub status check 'qa-score' pass/fail based on ≥ 90
  8. Telegram notify
         │
         ▼
Branch protection blocks merge until qa-score passes
```

## Why It's "Independent"

- **Different machine:** smo-test has no access to developer's local files or session history
- **Fresh Claude session:** each run spawns a new `claude --print` process with zero prior context about why the code was written
- **Clean checkout:** no cached node_modules, no uncommitted changes, no dev-side patches
- **Deterministic input:** only sees what's in the PR commits

Self-score on dev machine: ~95 (inflated)
Independent score on smo-test: ~75 (honest)

Gap = what's actually missing for production quality.

## Operational Rules

1. **smo-test NEVER writes code.** QA runner is read-only on repos. Posts comments only.
2. **smo-test NEVER pushes.** Git remote is read-only.
3. **QA runner exits cleanly.** Leaves no residual state (cleanup trap removes /tmp/qa-*).
4. **Timeout: 10 minutes per PR.** If longer, kill and comment "QA timeout — re-submit."
5. **Concurrent runs allowed up to 3.** More than that → queue.

## What Counts as a Pass

Composite score ≥ 90 with no hat below 8/10. If any hat < 8, manual review required regardless of composite.

## Setup Checklist (Completed)

- [x] smo-test provisioned: Ubuntu 24.04, Node 22, npm 10.9, bun 1.3.12
- [x] Claude Code 2.1.114 installed
- [x] Skills synced (82 skills including gstack, superpowers, smorch-dev-scoring)
- [x] CLAUDE.md deployed (server-specific, QA-role)
- [x] settings.json deployed (same hook set as other servers)
- [x] .mcp.json deployed (n8n, linear, exa, playwright, contabo)
- [x] gh CLI installed (for PR commenting)
- [x] `/opt/qa-runner.sh` deployed + executable
- [x] Canonical configs snapshotted to smorch-brain/canonical/
- [x] Drift detection extended to include smo-test

## Remaining Setup (Requires External Access)

- [ ] Deploy `smorch-brain/n8n-workflows/qa-agent-trigger.json` to flow.smorchestra.ai n8n
- [ ] Add GitHub PAT to n8n credentials (repo:status scope, PR comment scope)
- [ ] Add SSH credential to smo-test in n8n credentials
- [ ] Create webhook in each repo: `https://flow.smorchestra.ai/webhook/qa-agent-trigger`
- [ ] Add branch protection rule on `dev`:
  - Require status check: `qa-score`
  - Require: up-to-date before merge
- [ ] Test: open dummy PR to dev, verify QA comment posts within 10 min

## First Test Target

`digital-revenue-score` repo (already has PR quality gates from Phase 3). First PR opened here after this SOP activates should trigger the full pipeline.

## Escalation

| Scenario | Action |
|----------|--------|
| QA agent fails to run | Telegram alert + check smo-test health + check n8n logs |
| QA score 0 on legitimate PR | Re-run manually via `ssh smo-test; bash /opt/qa-runner.sh ...` |
| Drift detected on smo-test | Fix via `smorch-brain/canonical/*-smo-test.*` baseline |
| qa-runner.sh timeout | Increase to 15min or investigate slow repos |
