# Phase 4 — DEV-layer → APP-layer Skills/Plugin Injection Matrix

**Date:** 2026-04-23
**Per MASTER-PLAN + EX-2/EX-3 + CEO directive**

---

## The two layers distinguished

### DEV-layer (what the engineer has at their keyboard while building the app)
Everything that supports development: CLAUDE.md, BRD, SOPs referenced, scoring plugins, Linear MCP, Supabase MCP, Playwright MCP, git hooks, `/smo-*` commands.

**Lives in:** `{repo}/.claude/`, `{repo}/CLAUDE.md`, `{repo}/.smorch/`, `smorch-dev/plugins/`, `~/.claude/`.

### APP-layer (what the DEPLOYED app invokes at runtime)
Skills, plugins, templates, prompts, context files that the **deployed application** injects into its own Claude API calls at runtime. User-facing runtime, not developer-facing.

**Lives in:** `{repo}/skills/` (bundled with app), `{repo}/prompts/`, loaded dynamically when app serves traffic.

---

## The rule (EX-2 + EX-3)

**Skills injection into APP-layer is the LAST step of every app's build.**
Per-app sequence:
1. Frontend works
2. Automation (n8n) works
3. Database works
4. End-to-end test: all 4 scenarios (happy/empty/error/edge) pass
5. **THEN** inject runtime skills

Skills must pass external-agency-team eval (SOP-25) before injection.

---

## Per-app injection matrix (proposed — confirm per-app in Phase 6)

| App | DEV-layer needs | APP-layer needs | Injection status |
|---|---|---|---|
| **signal-sales-engine** | smorch-dev plugin (plan/code/score/handover), smo-scorer, systematic-debugging, Supabase MCP (SSE), n8n MCP (flow), Playwright, cost-tracker | signal-detector, icp-matcher, campaign-strategist, wedge-generator (runtime), arabic-rtl-checker (if ar user), mena-mobile-check | 🔴 Pre-skills (step 4 not green yet) |
| **content-automation** | smorch-dev, Supabase MCP (SSE content_engine schema), n8n MCP, docker-compose | content repurposing skill, brand-voice-enforcer, hook-extractor | 🔴 Not deployed yet |
| **digital-revenue-score** | smorch-dev, Playwright (for MENA mobile), scoring skills | drs-scorecard-renderer (runtime) | 🟡 Deployed, runtime skills inject-ready |
| **gtm-fitness-scorecard** | smorch-dev, Playwright | gtm-fitness-renderer, positioning-scorer | 🟡 Deployed, runtime skills inject-ready |
| **eo-mena** | smorch-dev, Supabase MCP (entrepreneursoasis), arabic-rtl-checker, mena-mobile-check | eo-gtm-asset-builder (existing), eo-production-renderer, eo-quick-scorer, arabic translator | 🟡 App live, skills partially injected |
| **eo-scorecard / EO-Scorecard-Platform** | smorch-dev, Supabase MCP (entrepreneursoasis) | 5 eo-scoring engines (brain/skills/eo-scoring/) | 🔴 Skills in brain, not in repo yet |
| **SaaSFast** | smorch-dev, MongoDB MCP (pending), Playwright | (gating runtime: validate plan, check quota, enforce limits) | 🔴 Not deployed |
| **contabo-mcp-server** | smorch-dev, contabo MCP (self), Supabase MCP | (the repo IS the skill infra — no runtime skills) | 🟢 DEV-layer self-sufficient |
| **smorchestra-web** | smorch-dev, Netlify | (marketing site, minimal runtime) | 🟢 Done |
| **super-ai-agent** | smorch-dev, Claude SDK | orchestration skills (wire 3 MCPs for EO student deploy) | 🟡 Active dev |
| **smorch-brain** | git-sync, Boris | (knowledge repo, not deployed) | 🟢 Meta |
| **smorch-dev** | self | (plugin source — no runtime app) | 🟢 Meta |

---

## Phase 4 evidence (what produces "Phase 4 done")

1. ✅ This SPEC.md committed
2. ⏳ Per-app `.claude/settings.json` updated to load per-repo lessons.md at session start (template in `smorch-brain/canonical/claude-md/per-app-session-hook.json`)
3. ⏳ Per-app `.smorch/project.json` (Phase 3 delivered 6/17 — rest in Phase 6)
4. ⏳ Per-app CLAUDE.md trimmed to Boris 40-80 lines referencing correct SOPs (Phase 6)
5. ⏳ Per-app `skills/` subdir present + `runtime-skills.json` manifest (Phase 6)
6. ⏳ Pre-commit hook enforces structure per EX-4 (to be built in Phase 5)

**Phase 4 itself is mostly a DESIGN + TEMPLATE phase.** Actual per-app injection is Phase 6's job (one-at-a-time per-app deep dive). Phase 4 produces the matrix + templates; Phase 6 applies them.

---

## Phase 4 templates to produce (inputs to Phase 6)

| Template | Purpose | Status |
|---|---|---|
| `smorch-brain/canonical/claude-md/per-app-CLAUDE-template.md` | Boris 40-80 line skeleton customized per project | needed |
| `smorch-brain/canonical/claude-md/per-app-settings-hook.json` | SessionStart hook that loads `.claude/lessons.md` + `smorch-brain/canonical/*` | needed |
| `smorch-brain/canonical/skills/runtime-skills-manifest-schema.json` | Schema for per-repo `skills/runtime-skills.json` | needed |
| `smorch-brain/canonical/adrs/ADR-004-skills-injection-layer-separation.md` | ADR formalizing DEV vs APP layer distinction | needed |
| `smorch-dev/scripts/injection/validate-skills-eval.sh` | EX-3 gate: reject injection if eval score <92 | needed (Phase 5) |

---

## Gate to exit Phase 4

Phase 4 ships when the above 5 templates are committed to smorch-brain + a Phase 5 cron can validate "every repo declared in registry has a valid `runtime-skills.json` or explicitly marked as `runtime_skills: none`".
