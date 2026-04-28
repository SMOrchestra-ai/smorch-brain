# ADR-004 — DEV-layer vs APP-layer Separation for Skills Injection

**Status:** Accepted 2026-04-23
**Author:** Claude (lead architect) + CEO directive (EX-2, EX-3)
**Context:** Post-perfctl rebuild surfaced a conflation between skills used AT DEV-TIME (while engineers build the app) and skills INJECTED AT RUNTIME (into the deployed app's Claude API calls). Treating them as the same pool caused (a) dev-only skills bloating production bundles, (b) runtime skills injected before app fundamentals worked, masking real bugs.

## Decision

Two distinct layers, separately managed:

### DEV-layer
- **Purpose:** assist the engineer building the app
- **Lives at:** `{repo}/.claude/`, `{repo}/.smorch/`, `~/.claude/plugins/smorch-dev/`, `smorch-brain/skills/dev-meta/`
- **Invoked by:** human developer via `/smo-*` slash commands, `/score-project`, etc.
- **NOT in production bundle.**

### APP-layer
- **Purpose:** enhance user-facing runtime behavior of the deployed app
- **Lives at:** `{repo}/skills/`, declared in `{repo}/skills/runtime-skills.json` (schema in canonical/skills/)
- **Invoked by:** deployed app's own Claude API calls (e.g., Anthropic SDK skill parameter)
- **Injection rule (EX-2):** LAST step of app build — only after frontend + automation + DB + end-to-end test are all green.
- **Quality gate (EX-3):** every skill must pass external-agency-team eval with composite ≥92 before listing in runtime-skills.json. Eval evidence at `smorch-brain/skills/{skill-id}/evals/`.

## Consequences

- Pre-commit hook (EX-4, Phase 5) rejects `runtime-skills.json` entries lacking eval_evidence_path.
- `/smo-drift` reports any `runtime-skills.json` that declares skills with eval_score <92 or eval_date older than 90 days (re-eval SLA).
- Repos with `runtime_skills: "none"` explicitly (e.g., static sites, pure CRUD) skip the check.
- Dev-meta skills in `smorch-brain/skills/dev-meta/` never appear in runtime manifests by construction.

## Alternatives considered

1. **Single unified skill pool** — rejected: caused production bundle bloat + masking of app bugs.
2. **Skills as git submodules per repo** — rejected: sync headache + version drift.
3. **Skills served via CDN at runtime (no bundling)** — deferred: useful future optimization but adds serving infra cost today.
