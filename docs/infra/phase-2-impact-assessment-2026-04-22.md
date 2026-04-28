# Phase 2 Evidence — Global Setup Audit + EX-6 Impact Assessment

**Date:** 2026-04-22
**Author:** Claude (lead architect)
**Method:** autonomous research agent sweep across `~/.claude/`, all 4 canonical repos (brain/dev/dist/context), and 17 active product repos.

---

## Top-of-file flags

- **No fresh secret-leak** in recent commits (PostToolUse secret-scanner active; gitleaks findings on SSE + contabo-mcp-server tracked in Phase 1).
- **Drift risk is systemic:** 7 of 11 locally-cloned product repos are AHEAD of origin with uncommitted CLAUDE.md edits, orphan `.claude/` dirs, or untracked docs. Textbook L-009 violation.
- **Signal-Sales-Engine still on `feat/recover-sse-v3-n8n-workflows-ace`** with 32 remote branches and orphan `agent/*` branches — bloat not yet pruned.
- **`~/.claude/skills` symlink** points at case-variant dir `SKILLs`; three `.bak` symlinks all aim at the same target = stale.

---

## Section 1 — Global setup inventory

### `~/.claude/` (user scope)
| Path | State | Flags |
|---|---|---|
| `CLAUDE.md` | 124 lines, 2026-04-21 | L-009 rule duplicated at lines 80 + 124 (verbatim) |
| `CLAUDE.md.pre-phase6-backup` + `.v1.bak` | backups at top level | move to `_backups/` |
| `lessons.md` | 9 lessons (L-001…L-009), pruned 2026-04-21 | ✓ |
| `settings.json` | 5 hooks wired (destructive, SQL, secrets, formatter, SessionStart) | ✓ |
| `plans/` | 30 random-slug files | hygiene needed |
| `plugins/smorch-dev/` + `plugins/smorch-ops/` | both installed | ✓ |
| `skills → /…/SKILLs` | symlink to case-variant dir, 3 bak symlinks same target | 🟡 cleanup |
| `commands-backup-20260324/` (136 files) + `_commands-backup-2026-03-25/` (27 files) | old backup sprawl | delete |

### `smorch-brain/`
| Area | Count | Notes |
|---|---|---|
| `sops/` | 6 (SOP-20-25 just committed) | ✓ |
| `SOP/` | separate dir exists | 🔴 duplicate dir |
| `canonical/` | `repo-registry.md` + `skills-manifest` | global CLAUDE.md references it as `project-registry.md` — name drift |
| `skills/` | ~60 skills across 8 categories (`_archive`/`content`/`dev-meta`/`eo-scoring`/`eo-training`/`personal`/`smorch-gtm`/`tools`) | ✓ |
| `plugins/` | 12 plugins | ✓ |
| 5 `.plugin` binary artifacts at repo root | compiled bundles committed to source repo | 🟡 should live in smorch-dist only |
| `CLAUDE.md` | 142 lines | over Boris ≤120 |

### `smorch-dev/`
- `plugins/smorch-dev/commands/` — **11 commands** (plan/code/score/bridge-gaps/handover/qa-handover-score/qa-run/ship/retro/triage/dev-guide)
- `plugins/smorch-dev/skills/` — **10 skills**
- `plugins/smorch-ops/commands/` — **7 commands** (deploy/drift/health/incident/rollback/secrets/skill-sync)
- `plugins/smorch-ops/skills/` — **7 skills**
- `install/`, `scripts/`, `docs/` all present. ✓

### `smorch-dist/` + `smorch-context/`
- Not cloned locally. smorch-context last pushed 2026-04-05 (17 days stale).

---

## Section 2 — Gaps & duplications

- **SOP reference drift**: global CLAUDE.md references SOP-02/10/11/12/13/14/15/16/17/18 — none in `sops/` (only SOP-20-25 there). Older ones presumed in `SOP/` (capital) — two dirs is one too many.
- **Registry filename**: global CLAUDE.md says `project-registry.md`, actual file is `repo-registry.md`.
- **L-009 duplication**: same block pasted twice in `~/.claude/CLAUDE.md`.
- **Plugin binaries at brain root**: 5 × `.plugin` compiled bundles polluting source repo.
- **Duplicate `sync-plugins.sh` + `sync-plugins.txt`** (identical content, two file types).
- **DOCX clutter** in brain/docs/: 4 legacy `.docx` files.
- **Skill overlap (minor)**: `smo-scorer` (plugin) vs `dev-meta/` scorer skills (brain) — verify scope before Phase 4.

---

## Section 3 — EX-6 Impact Assessment (17 active repos)

Legend: 🟢 clean / 🟡 minor drift / 🔴 needs remediation before Phase 3

| # | Repo | Status | Critical finding |
|---|---|---|---|
| 1 | Signal-Sales-Engine | 🔴 | Still on `feat/recover-sse-v3-n8n-workflows-ace`, 32 remote branches, orphan `agent/*` sprawl, not merged to main |
| 2 | eo-mena | 🔴 | On `feat/smorch-overlay`, massive untracked (app/, architecture/, assets/, database/), `.claude-from-old/` dir never cleaned, CLAUDE.md = 179 lines |
| 3 | smorch-brain | 🟡 | 5 `.plugin` binaries at root, 2 SOP dirs, docx clutter, CLAUDE.md = 142 |
| 4 | content-automation | 🟡 | dev ahead 1, uncommitted CLAUDE.md, CLAUDE.md = 158 |
| 5 | EO-Scorecard-Platform | 🟡 | dev ahead 1, uncommitted CLAUDE.md + orphan `.claude/` |
| 6 | contabo-mcp-server | 🟡 | dev ahead 1, uncommitted CLAUDE.md, CLAUDE.md = **286 lines** |
| 7 | SaaSFast | 🟡 | dev ahead 1, uncommitted CLAUDE.md + untracked `DevTeamSOP/` |
| 8 | digital-revenue-score | 🟡 | dev ahead 2, uncommitted CLAUDE.md + README, CLAUDE.md = **339 lines** |
| 9 | gtm-fitness-scorecard | 🟡 | dev ahead 1, uncommitted CLAUDE.md + untracked `coding-brd.md` |
| 10 | smorch-dist | 🟡 | not cloned locally |
| 11 | smorch-context | 🟡 | 17 days stale, not cloned locally, purpose unclear |
| 12 | SaaSfast-Page-Online | 🟡 | NO CLAUDE.md |
| 13 | eo-microsaas-training | 🟡 | not cloned locally |
| 14 | smorch-dev | 🟢 | clean, CLAUDE.md = 43 (Boris ✓) |
| 15 | smorchestra-web | 🟢 | clean, CLAUDE.md = 38 (Boris ✓), healthy quality-bridge refactor trail |
| 16 | eo-microsaas-plugin | 🟢 | clean, CLAUDE.md = 43 (Boris ✓) |
| 17 | super-ai-agent | 🟢 | clean, 7 healthy auto-fix commits in April |

**Totals:** 4 🟢 / 11 🟡 / 2 🔴

### Pattern analysis

The April 17-22 "infra remediation" sweep did real work (CI gates, deploy configs, Playwright, L-009 captured) — but after each automated PR, a local CLAUDE.md edit was left uncommitted. **The issue is not the sweep; it's the final-mile push discipline.** Exactly what L-009 was written for.

---

## Section 4 — Phase 2 action list

### P0 — blockers for Phase 3

1. **Signal-Sales-Engine branch cleanup** — merge/archive `feat/recover-sse-v3-n8n-workflows-ace`, prune 20+ orphan `agent/*` branches. CEO decision required since this touches `main` on a status-beta repo. ~90 min.
2. **Commit & push the 7 ahead/dirty local repos** (EO-MENA, EO-Scorecard-Platform, SaaSFast, content-automation, contabo-mcp-server, digital-revenue-score, gtm-fitness-scorecard) — each has uncommitted CLAUDE.md or orphan `.claude/`. L-009 enforcement. ~60 min.
3. **Consolidate brain SOP dirs** — pick `sops/` vs `SOP/`, merge. Update global CLAUDE.md refs so SOP-02/10-18 all resolve. ~45 min.
4. **Fix registry filename drift** — rename or update reference (`project-registry.md` vs `repo-registry.md`). ~5 min.
5. **Clone `smorch-dist` + `smorch-context` locally**. ~10 min.

### P1 — must land in Phase 2

6. CLAUDE.md Boris-discipline trim — digital-revenue-score (339→60), contabo-mcp-server (286→60), eo-mena (179→80), content-automation (158→60). ~2-3 h.
7. Delete 5 `.plugin` binaries from brain root. ~20 min.
8. Clean `~/.claude/` backup sprawl. ~15 min.
9. Fix global CLAUDE.md L-009 duplication. ~2 min.
10. Add CLAUDE.md to `SaaSfast-Page-Online`. ~15 min.
11. Investigate `smorch-context` 17-day staleness. ~20 min.
12. Clone + audit `eo-microsaas-training`. ~15 min.
13. Sync all 4 servers post-commit via `/smo-drift`. ~15 min.
14. Delete duplicate `sync-plugins.sh/.txt` in brain. ~2 min.
15. Move 4 DOCX files in `brain/docs/` to `_archive/`. ~10 min.

### P2 — can defer to Phase 6 per-app

16. Prune `~/.claude/plans/` (30 random-slug files).
17. `/smo-retro` across all 17 repos to promote project lessons.
18. Audit `smorch-brain/plugins/_archive/`.
19. Delete `commands-backup-*` dirs.

---

## Section 5 — Phase 2 gate decision

**NO-GO for Phase 3 until P0 actions 1-5 complete.**

- Two hard blockers (Signal-Sales-Engine recovery limbo; eo-mena uncommitted untracked state).
- Systemic 7-repo local-ahead-of-remote drift violates L-009.

**Estimated effort to flip to GO:** 3-5 hours focused work on P0 + P1 items 6, 7, 11.

---

## Section 6 — Autonomous actions taken during Phase 2 (so far)

Completed in this phase:
- ✅ Quick-win #9: Fixed L-009 duplication in global `~/.claude/CLAUDE.md`
- ✅ Quick-win #14: Deleted `sync-plugins.txt` duplicate in smorch-brain
- ✅ Quick-win #4: Fixed registry filename drift (updated global CLAUDE.md)
- ✅ Quick-win #5: Cloned `smorch-dist` + `smorch-context` locally
- ✅ Quick-win #7: Moved 5 `.plugin` binaries from brain root → `dist/`

Deferred pending CEO decision (cannot act autonomously):
- ⏸ Action #1 (SSE recovery branch merge/archive) — force-push risk, touches status-beta main
- ⏸ Action #2 (push 7 repos with uncommitted CLAUDE.md edits) — someone made those edits; pushing blind is risky, CEO should confirm intent first
- ⏸ Action #3 (brain SOP dir consolidation) — structural rename, wait for CEO GO

Actions taken vs deferred matches the rule: "force push / cross-repo edits / anything touching customer data → escalate." The 7 uncommitted CLAUDE.md edits fall under "cross-repo edits that affect someone else's in-flight work" until confirmed.
