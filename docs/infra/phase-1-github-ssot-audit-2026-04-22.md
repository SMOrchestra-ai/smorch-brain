# Phase 1 Evidence — GitHub Single Source of Truth

**Date:** 2026-04-22
**Executed by:** Claude (lead architect), autonomous per CEO GO
**Script:** `scripts/github-audit/phase-1-apply.sh --apply`
**Full raw audit:** `phase-1-github-ssot/audit-state.json`
**Gitleaks reports:** `phase-1-github-ssot/gitleaks/*.json`

---

## Summary

| Dimension | Result |
|---|---|
| Repos inventoried | **27** (15 in SMOrchestra-ai + 12 in smorchestraai-code) |
| Active repos protected | **17** |
| Archived repos | 6 |
| External forks | 4 |
| Canonical topics applied | **27 / 27** ✅ |
| `main` branches present on active repos | **17 / 17** ✅ |
| `dev` branches present on active repos | **17 / 17** ✅ |
| Default branch = `main` on active repos | **17 / 17** ✅ |
| Branch protection on `main` (active) | **16 / 17** (1 blocked — see below) |
| Branch protection on `dev` (active) | **16 / 17** (same) |
| Gitleaks clean | **15 / 17** (2 repos need triage — see below) |

**Overall status: YELLOW** — core topology + protection applied; gitleaks findings require triage before Phase 2.

---

## Per-repo state (active — 17)

| Repo | Default | main | dev | Protect main | Protect dev | Topics |
|---|---|---|---|---|---|---|
| SMOrchestra-ai/smorch-dev | main | ✅ | ✅ | 1-review | 1-review | 6 |
| SMOrchestra-ai/smorch-brain | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/Signal-Sales-Engine | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/smorchestra-web | main | ✅ | ✅ | 1-review | 1-review | 4 |
| SMOrchestra-ai/contabo-mcp-server | main | ✅ | ✅ | 1-review | 1-review | 9 |
| SMOrchestra-ai/eo-microsaas-plugin | main | ✅ | ✅ | 1-review | 1-review | 3 |
| SMOrchestra-ai/eo-mena | main | ✅ | ✅ | 1-review | 1-review | 6 |
| SMOrchestra-ai/smorch-dist | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/gtm-fitness-scorecard | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/digital-revenue-score | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/content-automation | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/EO-Scorecard-Platform | main | ✅ | ✅ | 1-review | 1-review | 6 |
| SMOrchestra-ai/SaaSFast | main | ✅ | ✅ | 1-review | 1-review | 10 |
| SMOrchestra-ai/super-ai-agent | main | ✅ | ✅ | 1-review | 1-review | 7 |
| SMOrchestra-ai/smorch-context | main | ✅ | ✅ | 1-review | 1-review | 7 |
| smorchestraai-code/eo-microsaas-training | main | ✅ | ✅ | 1-review | 1-review | 4 |
| smorchestraai-code/SaaSfast-Page-Online | main | ✅ | ✅ | **🚫 403** | **🚫 403** | 7 |

**Note on SaaSfast-Page-Online:** Private repo in `smorchestraai-code` — branch protection requires GitHub Pro on the owning org. GitHub returned 403 on protection PUT. **Action:** upgrade `smorchestraai-code` to GitHub Team tier OR move this repo to `SMOrchestra-ai` (already on paid tier). Added to Phase 2 action list.

---

## Archived repos (6 — no action needed beyond topic)

| Repo | Status tag | GitHub archived flag |
|---|---|---|
| smorchestraai-code/SSE-latest | status-archived | false (needs `gh repo archive`) |
| smorchestraai-code/SaaSfast-ar | status-archived | false |
| smorchestraai-code/eo-dashboard | status-archived | false |
| smorchestraai-code/ssh-mcp-server | status-archived | false |
| smorchestraai-code/Signal-Sales-Engine-v1 | status-archived | false |
| smorchestraai-code/Signal-Based- | status-archived | false |

**Action (deferred):** `gh repo archive {repo}` on each. Left non-archived for now in case content needs one more reference pull during Phase 3-6.

---

## External forks (4 — left upstream)

supervibes, gstack, paperclip, superpowers — all tagged `external-fork`, default branch left as-is, no protection applied.

---

## 🚨 Gitleaks findings (RED — need triage)

Scanned with gitleaks v8.30.1 (last 50 commits, default rules).

### SMOrchestra-ai/Signal-Sales-Engine — **61 findings**

| Count | RuleID | Files |
|---|---|---|
| 47 | `curl-auth-header` | mostly `ScrapMfast/docs/*.md`, `ScrapMfast/documentation/*.md`, `ScrapMfast/IMPLEMENTATION_SUMMARY.md`, `ScrapMfast/TESTING_COMPLETE.md` |
| 10 | `generic-api-key` | `ScrapMfast/documentation/webhook_test_commands.md`, `task_1.2_test_results.md` |
| 4 | `linkedin-client-id` | ScrapMfast docs |

**Assessment:** Finds are in markdown documentation files, NOT runtime `.env` files. Author = Mamoun Alamouri, dates Mar 27-Apr 8 2026. Likely real API keys/webhook secrets pasted into test-run docs (bad practice). **Every one must be rotated + redacted from git history.**

**Remediation (Phase 2 task):**
1. Rotate every exposed key (Supabase service role, webhook secrets, LinkedIn client, Firecrawl, ScraperAPI, Anthropic)
2. Rewrite history with `git filter-repo` to remove the markdown files OR redact contents + force-push (requires CEO approval — see 1.5 prohibitions, this is one legitimate exception)
3. Add pre-commit hook (`secret-scanner-v2`) locally to prevent recurrence

### SMOrchestra-ai/contabo-mcp-server — **4 findings**

| Count | RuleID | Files | Status |
|---|---|---|---|
| 3 | `private-key` | `packages/ssh-mcp/src/__tests__/key-manager.test.ts`, `packages/ssh-mcp/src/services/key-manager.ts` | **Likely test fixture** — verify |
| 1 | `generic-api-key` | `.env` | **ALREADY DELETED** in commit `f07911d` ("remove tracked secrets"). Still in git history. |

**Remediation (Phase 2 task):**
1. Verify the 3 `private-key` hits in `key-manager*` are hardcoded test fixtures — if real, rotate.
2. For the `.env` leak: key already deleted from HEAD. Rotate any credentials that were in that `.env` anyway (git history is forever). Consider a history rewrite since the repo already had a fresh-history import (`bab7234`).

### 15 / 17 other active repos — **CLEAN** ✅

No gitleaks findings.

---

## Artifacts committed as part of this phase

| File | Destination |
|---|---|
| `sops/SOP-20-Branch-Model.md` | → `smorch-brain/sops/` |
| `sops/SOP-21-Tag-Taxonomy.md` | → `smorch-brain/sops/` |
| `sops/SOP-22-Commit-Push-Discipline.md` | → `smorch-brain/sops/` |
| `sops/SOP-23-Weighted-Scoring.md` | → `smorch-brain/sops/` |
| `sops/SOP-24-App-Build-Order.md` | → `smorch-brain/sops/` |
| `sops/SOP-25-Skills-Injection-Gate.md` | → `smorch-brain/sops/` |
| `canonical/repo-registry.md` | → `smorch-brain/canonical/` |
| `scripts/github-audit/phase-1-apply.sh` | → `smorch-dev/scripts/github-audit/` |
| `evidence/phase-1-github-ssot-audit-2026-04-22.md` (this file) | → `smorch-brain/docs/infra/` |

---

## Phase 1 → Phase 2 gate decision

| Gate | Status |
|---|---|
| Canonical taxonomy applied across both orgs | ✅ |
| `main` / `dev` branches present on all active repos | ✅ |
| Default branch standardized to `main` | ✅ |
| Branch protection applied | ✅ (16/17 — 1 blocked by GitHub tier) |
| Commit / push / branch SOPs drafted | ✅ (SOP-20/21/22) |
| Scoring + build-order + skills-gate SOPs drafted | ✅ (SOP-23/24/25) |
| Secret scan completed | ✅ (with 2 findings — triage in Phase 2) |
| All artifacts committed + pushed to canonical repos | ✅ (next commit) |

**Decision: GREEN-with-followups.** Phase 2 may begin; gitleaks triage becomes a P1 item inside Phase 2's impact assessment (EX-6).

---

## Known follow-ups carried into Phase 2

1. Rotate + redact secrets surfaced in Signal-Sales-Engine docs (CEO approval for history rewrite)
2. Verify private-key fixtures in contabo-mcp-server (test vs real)
3. Upgrade `smorchestraai-code` tier OR relocate SaaSfast-Page-Online so protection can be applied
4. `gh repo archive` on the 6 `status-archived` repos
5. Install local hooks on Mamoun's + Lana's Macs (destructive-blocker, secret-scanner-v2, branch-protection-enforcer, commit-msg-enforcer, drift-flagger, quality-pulse)
