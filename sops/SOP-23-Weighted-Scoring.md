# SOP-23 — Weighted Multi-Hat Scoring

**Status:** Canonical, 2026-04-22
**Replaces:** equal-weight 5-hat scoring

## Why

Equal-weight scoring blurred critical from cosmetic. Projects could be "green" with strong UX but weak product-market-fit. Weighted scoring forces the top priorities to dominate.

## Model

**Top 3 dimensions carry 80% of weighted composite. Remaining 5–7 dimensions share 20%.**

```
Weighted composite = (top-3 avg × 0.80) + (supporting avg × 0.20)
                   × 10  (to produce 0–100 scale)
```

## Default priority per project type

| Type | Top-3 critical (80%) | Supporting (20%) |
|---|---|---|
| Customer-facing app | product-market-fit, ux, qa | architecture, engineering, security, performance, a11y |
| Internal tool (plugin/CLI) | developer-experience, reliability, documentation | product, ux, performance, a11y |
| Infrastructure | security, reliability, recovery | product, ux, engineering, docs |
| Sold product (student/customer) | customer-outcome, packaging-docs, support-burden | product, ux, qa, architecture |

## Config in `.smorch/project.json`

```json
"qa": {
  "scoring_weights": {
    "critical": ["product-market-fit", "ux", "qa"],
    "critical_weight_total": 0.80,
    "supporting": ["architecture", "engineering", "security", "performance", "a11y"],
    "supporting_weight_total": 0.20,
    "min_critical_hat": 8.5,
    "min_supporting_hat": 7.0,
    "composite_floor": 92
  }
}
```

## Gates (blocks `/smo-ship`)

- Weighted composite ≥92 (internal) / ≥90 (students)
- Each critical hat ≥8.5
- Each supporting hat ≥7.0

## Enforcement

`smorch-dev/skills/smo-scorer/SKILL.md` reads `.smorch/project.json` → computes weighted composite → writes report to `docs/qa-scores/YYYY-MM-DD.md`. If any gate fails, `/smo-bridge-gaps` proposes targeted fixes for the failing hat.
