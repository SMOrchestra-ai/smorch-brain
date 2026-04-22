# {Project-Display-Name}

## Identity
{1 line — what this is, who it's for, which business line}

## Stack
- Frontend: {specific version, not "modern JS"}
- Backend: {specific}
- DB: {Supabase project ref OR MongoDB URI var OR N/A}
- Deploy: {pm2 | docker-compose | netlify} on {smo-prod | smo-dev | eo-prod | netlify}
- Language: {English | Arabic-first | bilingual}
- MENA: {yes — RTL, AED/SAR/QAR, Fri/Sat weekend | no}

## Plugin overlay
Uses smorch-dev + smorch-ops plugins (L-009 discipline, 7-pillar chain).
Overlay config: `.smorch/project.json`.

## Command chain (daily engineering loop)
`/smo-plan → /smo-code → /smo-score → /smo-bridge-gaps → /smo-handover → /smo-qa-handover-score (Lana) → /smo-qa-run (Lana) → /smo-ship → /smo-deploy`

## Non-negotiable rules (5 max)
1. {Rule 1 — e.g., "All currency AED/SAR/QAR, never USD"}
2. {Rule 2}
3. {Rule 3}
4. {Rule 4}
5. {Rule 5}

## Ship gates
- Composite weighted score ≥92 (top-3 dims = 80%, rest = 20% — per SOP-23)
- Each top-3 hat ≥8.5, each supporting ≥7.0
- Handover ≥80 from Lana
- BRD AC-N.N → 100% test coverage

## Environment variables (see .env.example — no values)
- {VAR_NAME}: {purpose}

## Deploy
- Staging: `/smo-deploy --env staging` → smo-dev (/root/{project})
- Production: `/smo-deploy --env production` → {host} ({path}) — CEO approval required on smo-prod/eo-prod touches

## Rollback SLA
- Production: ≤90 seconds
- Staging: ≤120 seconds

## Runtime skills (APP-layer — EX-2: LAST step)
Injected only after frontend + automation + DB + test are all green.
See `skills/runtime-skills.json`.

## Per-project lessons
`{project}/.claude/lessons.md` — session-start hook auto-loads.
Promote to global `~/.claude/lessons.md` via `/smo-retro` when pattern hits 3+ projects.
