# SOP-25 — Skills Injection Quality Gate

**Status:** Canonical, 2026-04-22
**Enforces:** EX-3 (external eval before injection)

## Problem

Skills previously injected into apps based on vibes. Poor-quality skills pollute app output.

## Flow

```
1. Skill authored          → smorch-brain/skills/{skill-id}/
2. Eval harness authored   → smorch-brain/skills/{skill-id}/evals/
3. External team evals     → agency team runs input/output consistency tests
                              OUTSIDE the app in a controlled harness
4. Quality gate            → score ≥92 composite:
                              - accuracy (output matches expected)
                              - consistency (same input → same output)
                              - latency (p95 within budget)
                              - cost (tokens per call within budget)
5. Sign-off                → eval report at smorch-brain/skills/{skill-id}/evals/2026-MM-DD-pass.md
6. Inject                  → add skill to app's .smorch/app-skills/ manifest
7. Monitor                 → smorch-dev:cost-tracker flags per-PR anomalies
```

## Mandatory companion skills (always bundled with any injection)

- **Journey skills/templates/plugins** — define user journey the app serves; skills align
- **Scoring plugins/skills** — enforce quality at every app output; catch drift before users do

## Eval harness structure

```
smorch-brain/skills/{skill-id}/evals/
  consistency-test.md       # input/output pairs, expected behavior
  quality-rubric.md         # scoring criteria
  2026-MM-DD-pass.md        # latest passing eval (dated)
  2026-MM-DD-fail.md        # if fails, why + next steps
```

## Who evals

**Agency team (external to app dev team).** This is intentional — the people injecting skills don't also grade them. Conflict of interest.

## Rejection

Fail eval → skill does NOT get injected → add to backlog with specific gaps to address. Re-eval when improved.
