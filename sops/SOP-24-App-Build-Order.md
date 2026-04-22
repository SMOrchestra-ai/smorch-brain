# SOP-24 — Per-App Build Order (Skills injection ALWAYS last)

**Status:** Canonical, 2026-04-22
**Enforces:** L-013 (don't duplicate content), EX-2 (skills injection last)

## Canonical order for every app (Phase 4 + Phase 6)

```
Step 1 — Frontend       : UI structure, routing, state, auth flow
Step 2 — Automation     : n8n workflows, webhooks, event wiring, cron
Step 3 — Database       : schema, migrations, seed, RLS, backups configured
Step 4 — Test           : frontend + automation + DB work E2E (happy/empty/error/edge pass)
Step 5 — Skills injection : ONLY after step 4 green → inject runtime skills/plugins/templates/context
```

## Why this order

Skills inject prompts, templates, and context into the app's Claude API calls at runtime. If fundamentals are broken, skill behavior is indistinguishable from app bugs. **Fix fundamentals on a known-good base first, then layer skills.**

## Per-app tracking

`{repo}/docs/PHASE-TRACKER.md` shows current step + evidence for completed steps:

```
## Step 1 — Frontend ✅
Evidence: docs/qa/2026-MM-DD-frontend-e2e.md

## Step 2 — Automation ✅
Evidence: docs/qa/2026-MM-DD-n8n-workflow-e2e.md

## Step 3 — Database ✅
Evidence: docs/qa/2026-MM-DD-schema-migrations-applied.md

## Step 4 — Test ✅
Evidence: docs/qa/2026-MM-DD-full-e2e.md (all AC-N.N green)

## Step 5 — Skills injection 🔄 IN PROGRESS
Injecting: English-GTM, English-AI-Claude, Arabic-Claude-MicroSaaS
Eval gate: SOP-25 required BEFORE injection
```

## Link to SOP-25

Skills only inject once external eval (SOP-25) passes.
