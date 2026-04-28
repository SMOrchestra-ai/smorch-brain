# SMOrchestra Weekly Architecture Audit
**Date:** 2026-03-29
**Run:** Automated weekly audit

---

## Repo Inventory Note

The audit task lists 7 active repos as: SaaSFast, eo-assessment-system, smorch-brain, EO-Build, ScrapMfast, ship-fast, eo-mena. The actual org currently has **8 active (non-archived) repos**: SaaSFast, EO-Scorecard-Platform, smorch-brain, eo-mena, smorch-context, Signal-Sales-Engine, supervibes, smorch-dist. The task checklist appears outdated. This audit covers the **8 actual active repos**. `smorch-dist` is a plugin distribution repo and treated as non-product for scaffold purposes.

---

## Scorecard

| # | Dimension | Score | Issues |
|---|-----------|-------|--------|
| A1 | Org metadata | 10/10 | All fields populated: name, description, email, blog, company, location |
| A2 | Teams | 10/10 | engineering ✅, agents ✅, reviewers ✅ (+ dev-team, founders, gtm-team, eo-students) |
| A3 | Repo descriptions + topics | 7/10 | All repos have descriptions ✅. Topics missing: Signal-Sales-Engine, supervibes, smorch-dist (3/8 repos have null repositoryTopics) |
| A4 | Branch protection | 4/10 | main protected: SaaSFast ✅, smorch-brain ✅, eo-mena ✅ — UNPROTECTED: EO-Scorecard-Platform, smorch-context, Signal-Sales-Engine, supervibes. dev branch missing entirely on Signal-Sales-Engine and supervibes. ⚠️ MAMOUN REQUIRED |
| B1 | Essential files | 5/10 | README ✅ all repos. CHANGELOG ✅ all repos. AGENTS.md ✅ all repos. CLAUDE.md missing from 5/8 repos (SaaSFast, EO-Scorecard-Platform, eo-mena, smorch-context, supervibes). CODEOWNERS missing from 3/8 (smorch-context, Signal-Sales-Engine, supervibes) |
| B2 | PR templates | 8/10 | PR templates exist in all 8 repos ✅. However Signal-Sales-Engine and supervibes use a simplified template (missing explicit Risk Assessment section with checkbox list). Content otherwise adequate. |
| B3 | Issue templates | 6/10 | Full standard (bug.md + feature.md + task.md): SaaSFast ✅, EO-Scorecard-Platform ✅, smorch-brain ✅, eo-mena ✅. Partial/custom: smorch-context (context-error.md + new-context.md, no task.md). Signal-Sales-Engine and supervibes have bug_report.md + feature_request.md only (missing task.md, non-standard naming) |
| B4 | Version control | 10/10 | Every repo has at least one tag with a matching GitHub Release. SaaSFast at v3.0.0, all others at v0.1.0 |
| B5 | Architecture scaffold | 10/10 | SaaSFast: agents, docs, infra, product, prompts, specs, tests ✅. EO-Scorecard-Platform: agents, docs, infra, product, prompts, specs, tests ✅ |
| C1 | Hooks | 10/10 | All 6 required hooks present and correctly configured: destructive-blocker, SQL-guard, secret-scanner, auto-formatter, compaction-restorer, session-bootstrap |
| C2 | Agents | 10/10 | code-reviewer.md (memory: project) ✅, test-runner.md (memory: project) ✅, pr-creator.md (agent-generated label logic) ✅ |
| C3 | Conditional rules | 10/10 | infra-guard.md (paths: **/infra/**, **/.github/workflows/**) ✅, auth-security.md (paths: **/auth/**, **/security/**) ✅, database-guard.md (paths: **/migrations/**, **/*.sql) ✅ |
| D1 | smorch-brain health | 6/10 | smorch-brain is cloned at `~/Desktop/cowork-workspace/smorch-brain` (NOT `~/smorch-brain`). The PostToolUse hook path `~/smorch-brain/scripts/smorch` is wrong — silently failing on every skill write. Additionally, local repo has **uncommitted changes**: 12 modified `dist/*.plugin` files + 1 untracked worktree. No security bypass in scripts/smorch ✅. |
| D2 | Git hooks | 9/10 | commit-msg hook is installed locally at `~/Desktop/cowork-workspace/smorch-brain/.git/hooks/commit-msg` ✅ and validates conventional commit format ✅. |

**OVERALL: 114/140 (8.1/10)**

---

## Auto-Fixed

Nothing was auto-fixed in this run. All identified issues require either Mamoun's decision (branch protection, stale branches) or content creation from templates (CLAUDE.md, CODEOWNERS, issue templates). No broken tags without releases were found.

---

## Requires Mamoun

### 🔴 Critical: Branch Protection Gaps (A4)
Four repos have no branch protection on `main`:
- `EO-Scorecard-Platform` — main and dev both unprotected. This is a product repo with active commits.
- `smorch-context` — main and dev unprotected
- `Signal-Sales-Engine` — main unprotected, no dev branch exists
- `supervibes` — main unprotected, no dev branch exists

**Recommended fix:** Add required PR reviews (minimum 1) to main for all 4 repos. Create dev branch on Signal-Sales-Engine and supervibes if active development is occurring there.

### 🟡 Stale Branches (E1) — Require Merge, Extend, or Kill Decision

**EO-Scorecard-Platform** (9 stale branches, all last committed 2026-03-22 to 2026-03-23, now 6-7 days old):
- `feature/checkout-flow-fix` — 2026-03-23
- `feature/eo-dark-theme-alignment` — 2026-03-22
- `feature/eo-scorecard-revamp` — 2026-03-22
- `feature/purchase-confirmation-email` — 2026-03-23
- `fix/assessment-access-check` — 2026-03-23
- `fix/auth-callback-502` — 2026-03-23
- `fix/auth-callback-redirect` — 2026-03-23
- `fix/restore-original-scorecards` — 2026-03-23
- `hotfix/stripe-guest-checkout` — 2026-03-23

**smorch-brain** (3 stale branches):
- `feature/add-smorch-github-ops-skill` — 2026-03-22 (7 days)
- `fix/smorch-push-macos-compat` — 2026-03-20 (9 days)
- `skills/export-2026-03-20` — 2026-03-20 (9 days)

**smorch-context** (1 stale branch):
- `md-only` — 2026-03-25 (4 days)

**SaaSFast** (1 stale branch):
- `arabic-rtl` — 2026-03-19 (10 days) — oldest stale branch in the org

**Total stale: 14 branches.** Do NOT delete — Mamoun must decide: merge to dev, keep open, or delete.

### 🔴 smorch-brain Hook Path Mismatch (D1)
smorch-brain is cloned at `~/Desktop/cowork-workspace/smorch-brain` but the PostToolUse hook references `~/smorch-brain/scripts/smorch`. **This hook has been silently failing on every skill write.** The skill auto-sync is broken. Fix: update the hook path in `~/.claude/settings.json` to use the correct path, or symlink `~/smorch-brain → ~/Desktop/cowork-workspace/smorch-brain`.

Additionally, the local smorch-brain has **12 uncommitted modified files** in `dist/` (all `.plugin` files). These appear to be pending skill distribution updates that were never committed/pushed. Mamoun should review and commit or reset these.

Uncommitted dist changes:
- dist/_archive.plugin
- dist/eo-microsaas-os.plugin
- dist/eo-scoring-suite.plugin
- dist/eo-training-factory.plugin
- dist/mamoun-personal-branding.plugin
- dist/smorch-context-brain.plugin
- dist/smorch-design.plugin
- dist/smorch-dev-scoring.plugin
- dist/smorch-dev.plugin
- dist/smorch-gtm-engine.plugin
- dist/smorch-gtm-scoring.plugin
- dist/smorch-gtm-tools.plugin

### 🟡 Missing CI Workflows (CI section)
The following product repos are missing `changelog-check.yml` and/or `agent-scope-check.yml`:
- `EO-Scorecard-Platform` — has `ci.yml` only, missing both required workflows
- `Signal-Sales-Engine` — no `.github/workflows/` directory at all
- `supervibes` — no `.github/workflows/` directory at all

SaaSFast and eo-mena are compliant.

---

## Documentation Gaps (Can Be Fixed With Templates)

The following gaps were identified in B1. These can be created from smorch-brain templates once branch protection is addressed:

| Repo | Missing CLAUDE.md | Missing CODEOWNERS |
|------|-------------------|-------------------|
| SaaSFast | ❌ | ✅ |
| EO-Scorecard-Platform | ❌ | ✅ |
| eo-mena | ❌ | ✅ |
| smorch-context | ❌ | ❌ |
| Signal-Sales-Engine | ✅ | ❌ |
| supervibes | ❌ | ❌ |

Issue template gaps:
- `smorch-context`: missing task.md, uses custom naming (context-error.md, new-context.md) — this may be intentional given the repo purpose
- `Signal-Sales-Engine` and `supervibes`: rename bug_report.md → bug.md, feature_request.md → feature.md, add task.md

Topics missing (A3):
- `Signal-Sales-Engine`: add topics (e.g., signal-intelligence, b2b, gtm, outbound)
- `supervibes`: add topics (e.g., claude-code, ai-native, orchestration, multi-agent)
- `smorch-dist`: add topics (e.g., plugins, distribution, claude-code)

---

## Recommendations

1. **Batch-create CLAUDE.md files** for the 5 repos missing them (SaaSFast, EO-Scorecard-Platform, eo-mena, smorch-context, supervibes). Each should contain project-specific context: tech stack, active agents, deploy targets, and environment notes. Use Signal-Sales-Engine's CLAUDE.md as a template.

2. **Resolve EO-Scorecard-Platform branch accumulation.** With 9 active feature/fix branches all stalled at 2026-03-23, there appears to have been a development push that paused without merging. Consider a dedicated branch cleanup session to merge or close these before they diverge further.

3. **Add smorch-brain local clone check to session bootstrap.** The SessionStart hook currently reports git branch and commit hook status. It should also verify that `~/smorch-brain/scripts/smorch` is executable and reachable. If not, surface a warning rather than silent failure on PostToolUse.

4. **Evaluate supervibes and Signal-Sales-Engine for full architecture adoption.** Both lack: dev branch, branch protection, CI workflows, CLAUDE.md, CODEOWNERS, and topics. If these repos are becoming active, they need the full AI-native scaffold applied.

5. **Add smorch-dist to the audit manifest or archive it.** It currently falls outside the 7-repo scope defined in the audit task and has no topics, no protection, and minimal configuration. Either bring it to standard or archive if the distribution model has changed.

6. **PR template standardization.** Signal-Sales-Engine and supervibes use a simplified 3-section template (Summary, Changes, Test Plan) vs the full 5-section standard (Summary, Task Reference, Changes, Testing, Risk Assessment). Align to the full template so the risk assessment checklist is consistently enforced.

---

## Industry Updates

- **Claude Code Model Context Protocol (MCP) v1.0** was formalized in early 2025. The current MCP server configuration is extensive (200+ tools). Consider auditing MCP server usage patterns — unused servers add auth surface area.

- **GitHub branch rulesets** (GA as of 2024) are now the recommended approach over legacy branch protection rules. Rulesets support org-level policies that apply automatically to new repos, which would address the recurring gap where new repos (Signal-Sales-Engine, supervibes) start unprotected. Consider migrating from per-repo protection to org-level rulesets.

- **Claude Sonnet 4.6 / Opus 4.6** (current model family) supports extended thinking and larger context windows. The current agents (code-reviewer, test-runner, pr-creator) could benefit from explicit model pinning in their frontmatter to ensure they use the latest capable model rather than inheriting defaults.

- **GitHub Actions composite actions** could consolidate the recurring `changelog-check.yml` and `agent-scope-check.yml` workflows into a single reusable action stored in smorch-brain, removing the need to manually sync workflow files across repos.
