---
status: active
last_reviewed: 2026-04-19
superseded_note: "Scoring thresholds authoritative. Enforcement now via independent QA agent on smo-eo-qa (see SOP-QA-Agent-Independent.md)."
---

# SOP-02: Pre-Upload Scoring & Gap Bridge to 10/10

**Version:** 1.0
**Date:** March 2026
**Owner:** Mamoun Alamouri
**Scope:** Every code push, PR, and release in the SMOrchestra GitHub org
**Skills Used:** `/score-project`, `/score-hat`, `/bridge-gaps`
**Dev Tool Suites:** gstack (`/review` BEFORE scoring), superpowers (`verification-before-completion`), smorch-dev-scoring (`/score-project`, `/bridge-gaps`)
**Principle:** Nothing ships below 85. Nothing releases below 90.
**Pre-requisite:** Run gstack `/review` BEFORE `/score-project`. Code review catches issues that inflate gap bridge work.

---

## When This SOP Triggers

**Automatically (Claude Code must do this without being asked):**
- Before creating any PR (human/* or agent/* branch → dev)
- Before any release PR (dev → main)
- After completing a feature implementation
- When the QA Protocol (SOP-1) scores below 85

**On request:**
- When Mamoun says "score this" or "is this ready?"

---

## Phase 1: Pre-Push Scoring (Auto-trigger)

### Before Every PR — Claude Code MUST:

1. **Run the relevant hat scorer(s)** based on what changed:

| What Changed | Run These Hats |
|-------------|---------------|
| Frontend code (HTML, CSS, JS, TSX) | Engineering + UX/Frontend |
| Backend/API code | Engineering + Architecture |
| Database/migrations | Architecture + QA |
| Full feature (frontend + backend) | All 5 hats |
| Tests only | QA only |
| Docs only | Skip scoring |
| Config/infra | Architecture only |

2. **Score and gate:**

| Score | Action |
|-------|--------|
| **90+** | Proceed with PR. Include score in PR body. |
| **85-89** | Run `/bridge-gaps`. Fix what's quick (<15 min). Re-score. If still <90, proceed but note gaps in PR body. |
| **80-84** | Run `/bridge-gaps`. Fix gaps. Re-score. Must reach 85+ before PR. |
| **Below 80** | STOP. Do not create PR. Run full gap bridge. Re-score. If still <80, flag to Mamoun. |

3. **Include score in PR body:**
```markdown
## Quality Score
Composite: XX/100
Hats scored: [list]
Gap bridge applied: Yes/No
```

---

## Phase 2: Gap Bridge Protocol

### Step 2.1 — Run Gap Bridger
```
/bridge-gaps
```

This generates:
- Prioritized list of improvements (effort vs impact)
- Specific code changes for each gap
- Estimated time per fix

### Step 2.2 — Triage by Effort-to-Impact

| Quadrant | Action |
|----------|--------|
| **High impact, low effort** (<10 min) | Fix immediately |
| **High impact, high effort** (>30 min) | Create Linear ticket, defer to next sprint |
| **Low impact, low effort** | Fix if time permits in the current session |
| **Low impact, high effort** | Ignore |

### Step 2.3 — Re-Score
After fixes, re-run ONLY the affected hat scorers:
```
/score-hat [hat-name]
```

### Step 2.4 — Document in PR
```markdown
## Gap Bridge Applied
- [Gap 1]: Fixed (Engineering +3)
- [Gap 2]: Fixed (UX +5)
- [Gap 3]: Deferred — Linear ticket TASK-XXX
```

---

## Phase 3: Release Gate (dev → main)

Before any release PR:

1. Run full 5-hat composite scorer: `/score-project`
2. **Release gate: composite must be 90+**
3. If below 90: run full gap bridge, fix, re-score
4. If still below 90 after gap bridge: **MAMOUN-REQUIRED** decision

### Release PR Body Must Include:
```markdown
## Release Quality Gate
Composite Score: XX/100
| Hat | Score |
|-----|-------|
| Product | XX |
| Architecture | XX |
| Engineering | XX |
| QA | XX |
| UX/Frontend | XX |

Gap bridge applied: Yes/No
Issues deferred: [count] (see Linear)
MAMOUN reviewed: Yes/No
```

---

## Scoring Targets by Project Phase

| Phase | Minimum Score | Target |
|-------|--------------|--------|
| **MVP / v0.1.0** | 75 | 80 |
| **Beta / v0.x** | 80 | 85 |
| **Production / v1.0+** | 85 | 90+ |
| **Release to main** | 90 | 95+ |
| **Client delivery** | 90 | 95+ |

---

## What Claude Code Does Automatically

| Trigger | Action |
|---------|--------|
| Finishing a feature | Run relevant hat scorers |
| Score below 85 | Auto-run `/bridge-gaps`, fix quick wins |
| Creating a PR | Include score in PR body |
| Release PR | Full 5-hat composite + release gate |
| Score below 80 | STOP and ask Mamoun |

---

## First Commit / No Baseline

On the very first commit of a new project (before any code exists to score):
1. Skip scoring — there's nothing to score yet
2. After the first feature is complete, run the first baseline score
3. Save as `docs/qa-scores/baseline-[date].md`
4. All future scores are measured against this baseline

---

## Score History & Trend Tracking

After every scoring run, append to `docs/qa-scores/score-history.csv`:
```csv
date,version,product,architecture,engineering,qa,ux,composite,gap_bridge,notes
2026-03-24,v1.0.0,88,92,85,90,87,88.4,yes,pre-release QA
```

This enables trend analysis: are scores improving, stable, or declining?

---

## MAMOUN-REQUIRED Actions
- Releasing with composite below 90
- Skipping scoring on any PR
- Overriding a FAIL gate
- Accepting technical debt on a CRITICAL gap
