# Product Scorer — Anchor Rubrics

Use these rubrics to score each dimension. Match the project evidence to the closest anchor level.

## 1. Problem Clarity (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | Vague or assumed problem. "SMEs need better tools." No specific pain quantified. No target user named. |
| 4-5 | Problem identified but not validated. Assumption-based. Missing the WHO or the WHEN it hurts. |
| 6-7 | Clear problem statement, validated with at least anecdotal evidence. WHO + WHAT pain defined. |
| 8-9 | Validated with customer evidence, quantified impact (e.g., "40% lead loss"), specific trigger moments identified. |
| 10 | Revenue already flowing from manual/consulting version. Product automates proven demand. |

**Evidence to look for:** Problem statements in BRD/PRD. Customer quotes. Pain quantification. Target persona definition. If none exist, score 1-3.

## 2. Scope Discipline (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | Scope is a wish list. No prioritization framework. Everything labeled "must-have." |
| 4-5 | Some prioritization exists but MVP is still bloated. 20+ features in "Phase 1." |
| 6-7 | Clear MoSCoW or similar. MVP has 3-5 core features. Trade-off rationale is weak. |
| 8-9 | Tight MVP (1-3 features), clear "not building" list, scope tied to revenue hypothesis. |
| 10 | Scope is minimal, validated against willingness-to-pay, with explicit kill criteria if assumptions fail. |

**Evidence to look for:** Feature lists with priority labels. MVP definition. "Out of scope" documentation. Feature count in codebase vs spec.

## 3. Requirements Quality (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | Requirements are feature lists with no user context. "Add dashboard." No acceptance criteria. |
| 4-5 | Some user stories exist but are vague. Acceptance criteria missing or untestable. |
| 6-7 | Stories follow WHO/WHAT/WHY format. Acceptance criteria exist. Edge cases partially covered. |
| 8-9 | Stories are testable, include happy path + edge cases, map to measurable outcomes. |
| 10 | Stories include behavioral acceptance criteria, error states, performance expectations, traceable to business metrics. |

**Evidence to look for:** User story files. Acceptance criteria in issues/tasks. Test cases that map to requirements.

## 4. Roadmap Strategy (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No roadmap, or roadmap is a flat feature list with dates. No learning loops. |
| 4-5 | Phases exist but are arbitrary. Phase 2 is just "more features," not driven by Phase 1 data. |
| 6-7 | Clear phases with logic. Some decision gates between phases. But no kill criteria. |
| 8-9 | Phases are hypothesis-driven. Each phase has success metrics that gate the next. Pivot/persevere criteria defined. |
| 10 | Roadmap includes explicit bet sizing, learning milestones, revenue gates, and competitive response planning. |

**Evidence to look for:** Roadmap files. Phase descriptions. Decision criteria between phases. Milestone definitions.

## 5. Market Validation (Weight: 15%)

| Score | Anchor |
|-------|--------|
| 1-3 | No validation. Building on assumption. "I think people need this." |
| 4-5 | Talked to people, got positive feedback, but no commitment. Surveys count here. |
| 6-7 | 5+ ICP conversations with documented pain confirmation. Some expressed willingness to pay. |
| 8-9 | Pre-sales, deposits, or LOIs from target customers. Pricing tested. |
| 10 | Revenue already flowing from manual/consulting version. Product is automating proven demand. |

**Evidence to look for:** Customer interview notes. Pre-sales documentation. Pricing experiments. Revenue data. Landing page conversion data.

## 6. Success Metrics (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No metrics defined. "We'll figure it out after launch." |
| 4-5 | Vanity metrics only. "Number of users." No connection to revenue or retention. |
| 6-7 | Leading + lagging metrics defined. But baselines not established. |
| 8-9 | North Star metric + supporting metrics. Baselines established. Measurement infrastructure planned. |
| 10 | Full metrics tree: North Star to leading indicators to input metrics. Instrumentation built into MVP scope. |

**Evidence to look for:** Analytics setup. Metric definitions in docs. Dashboard configs. Event tracking code.

## 7. Competitive Positioning (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | No competitive analysis. "We don't have competitors" (red flag). |
| 4-5 | Competitors listed but no differentiation strategy. Feature comparison only. |
| 6-7 | Clear differentiation on 1-2 axes. Understands competitive weaknesses to exploit. |
| 8-9 | April Dunford-level positioning. Clear category, competitive alternatives, differentiated value mapped to ICP pain. |
| 10 | Positioning tested with target customers. Win/loss analysis from early deals informs strategy. |

**Evidence to look for:** Competitive analysis docs. Positioning statements. Landing page copy (reveals positioning). README differentiation claims.

## 8. Resource-Scope Fit (Weight: 10%)

| Score | Anchor |
|-------|--------|
| 1-3 | Scope requires 10x the available resources. Timeline is fantasy. |
| 4-5 | Scope is ambitious but possible with perfect execution (which never happens). |
| 6-7 | Scope fits resources with some buffer. Timeline has padding. |
| 8-9 | Scope is conservative relative to resources. Team has done similar work before. |
| 10 | Scope is deliberately understated. Team could ship in half the timeline. Built-in slack for learning. |

**Evidence to look for:** Team size indicators. Dependency count (package.json). Codebase complexity vs timeline. Prior project evidence.
