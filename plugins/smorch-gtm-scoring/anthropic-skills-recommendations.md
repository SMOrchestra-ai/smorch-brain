# Anthropic-Skills Gap Bridge Recommendations

These skills are external to smorch-brain (installed via Claude Code marketplace). Changes require editing the source files in `~/.claude/skills.bak.*` or their marketplace equivalents.

## CRITICAL (Blocks 9.5+)

### 1. docx — 590 lines, OVER 500-line limit
**Current:** Single monolithic file with XML Reference section taking ~150 lines.
**Fix:** Extract XML Reference section (tracked changes, comments, document structure) into `references/xml-reference.md`. Extract code examples for creating documents via docx-js into `references/docx-js-patterns.md`. Target SKILL.md under 300 lines.
**Post-fix score:** L3 jumps from 6.5 → 9.5.

### 2. internal-comms — 32 lines, Anthropic-specific
**Current:** Thin dispatcher routing to `examples/` files about Anthropic 3P updates, company newsletters, FAQs. Zero relevance outside Anthropic.
**Fix:** Either (a) replace with an SMOrch-adapted version covering client status reports, campaign updates, team standups, investor updates, or (b) remove from skill list entirely since it adds noise. The smorch-design:doc-coauthoring skill handles document writing better.
**Recommendation:** Remove. It's dead weight.

### 3. brand-guidelines — 73 lines, Anthropic-specific
**Current:** Anthropic brand colors (#141413, #d97757), Poppins/Lora fonts. Irrelevant for SMOrch work.
**Fix:** Already superseded by `smorch-design:smorch-brand-system` which has the SMOrch dark theme, #FF6600 orange, Inter font. Remove brand-guidelines from active skills or replace content with SMOrch brand system.
**Recommendation:** Remove. smorch-brand-system handles this.

### 4. scorecard-effectiveness — MISSING
**Current:** Registered in skill descriptions but no SKILL.md found anywhere on system.
**Fix:** Either create the skill (scores lead magnets/assessments on conversion effectiveness) or remove the registration. Ghost skills waste context window.
**Recommendation:** Build it or kill it. If building, model after the eo-scoring-suite pattern.

## HIGH (Needed for 9.5 floor)

### 5. frontend-design — 42 lines, too thin
**Current:** Great principles (anti-AI-slop, bold aesthetic direction) but no execution recipes.
**Fix:** Add component patterns (hero sections, dashboards, forms), layout archetypes, color palette guidance, and 2-3 before/after examples. Target 150-200 lines.
**Post-fix score:** L3 jumps from 7.0 → 9.0.

### 6. skill-creator — 485 lines, borderline
**Current:** 15 lines from the limit. Adding anything pushes it over.
**Fix:** Extract the eval-viewer HTML generation workflow into `references/eval-viewer.md`. This frees ~50 lines for future improvements.
**Post-fix score:** L3 stays at 9.0+ with headroom.

### 7. schedule — 40 lines, minimal
**Current:** Functional but no error handling, retry patterns, or failure mode guidance.
**Fix:** Add: what happens when a scheduled task fails, retry logic, timezone edge cases, and 2-3 common scheduling patterns.
**Post-fix score:** L2 jumps from 7.5 → 9.0.

## POLISH (9.5 → 10.0)

### 8. using-superpowers — Aggressive tone may suppress valid creativity
**Fix:** Soften the ALL-CAPS directives to clear rules without the aggression. The skill's intent is correct but the delivery creates a "scared to deviate" effect.

### 9. web-artifacts-builder — Missing testing + a11y
**Fix:** Add accessibility defaults (ARIA, keyboard nav, focus management) and a basic testing checklist.

### 10. canvas-design — Thin on execution
**Fix:** Add 3-4 layout pattern examples (poster, infographic, certificate, social card) with composition rules.

---

## Score Projections After Fixes

| Skill | Before | After | Delta |
|-------|--------|-------|-------|
| docx | 8.0 | 9.5 | +1.5 |
| internal-comms | 5.3 | REMOVED | — |
| brand-guidelines | 5.7 | REMOVED | — |
| scorecard-effectiveness | 0.0 | BUILT or REMOVED | — |
| frontend-design | 7.7 | 9.2 | +1.5 |
| skill-creator | 9.0 | 9.5 | +0.5 |
| schedule | 8.0 | 9.0 | +1.0 |
| Suite Average (excl removed) | 7.9 | 9.2 | +1.3 |
