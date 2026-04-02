# ADR-009: gstack as CEO/QA Methodology Layer

**Date:** 2026-03-28
**Status:** Accepted
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (VibeMicroSaaS Super AI — Phase 0)

## 1. Context

The VibeMicroSaaS pipeline requires two capabilities that Superpowers (ADR-008) does not cover: (1) high-velocity idea validation and product strategy stress-testing (Stages 1-4), and (2) browser-based visual QA and performance benchmarking of deployed MicroSaaS apps (Stages 6-8). gstack by Garry Tan provides role-based personas (CEO, Eng Manager, Designer, QA) and Playwright-based browser automation specifically designed for these use cases.

## 2. Options Considered

### Option A: Custom skills only (status quo)
- **Description:** Continue using existing eo-scoring skills and eo-qa-testing skill
- **Pros:** Already integrated; familiar
- **Cons:** No browser-based visual QA; no automated performance benchmarking; no "judgmental planning" for idea validation; no auto-fix + regression test pattern
- **Estimated effort:** 0

### Option B: gstack (Garry Tan / YC methodology)
- **Description:** Install gstack skill set into Claude Code. Key skills: `/office-hours` (6 forcing questions for idea validation), `/qa` (Playwright browser automation — visual testing, auto-fix, regression tests), `/review` (cross-role code review), `/benchmark` (Core Web Vitals), `/plan-eng` (engineering planning), `/careful` + `/freeze` + `/guard` (safety mechanisms)
- **Pros:** `/office-hours` stress-tests ideas using 50% of its 10K token budget on forcing questions — excellent for Stage 1-2 idea validation; `/qa` opens real browser, identifies broken UI, auto-fixes with atomic commits, generates regression tests — perfect for Stage 6-8; role-based personas provide different review lenses; `/benchmark` checks Core Web Vitals
- **Cons:** "Judgmental" style may conflict with Superpowers' "systematic" style if both active simultaneously; role personas overlap with our custom role CLAUDE.md files (ADR-007)
- **Estimated effort:** 2 hours (install + configure)

## 3. Decision

We chose **Option B: gstack** as a complementary methodology to Superpowers (ADR-008). gstack handles Launch (Stages 1-4) and Validation (Stages 6-8); Superpowers handles Build (Stages 5-6). They are never active simultaneously on the same Claude Code instance.

## 4. Trade-offs Accepted

- **Two methodology frameworks:** Managing two skill sets adds cognitive overhead. We mitigate this by assigning them to different roles in the AI org (ADR-007): gstack for CEO/QA roles, Superpowers for VP Engineering role.
- **Potential instruction conflicts:** gstack's CLAUDE.md directives could conflict with our custom CLAUDE.md. We mitigate by loading gstack skills selectively per role, not globally.

## 5. Consequences

**Immediate actions required:**
- [ ] Install gstack: clone `garrytan/gstack` skills into `~/.claude/skills/gstack/` on all nodes (Mamoun, Day 1)
- [ ] Test `/office-hours` with a sample MicroSaaS idea against the 13 GTM Matrix (Mamoun, Day 1)
- [ ] Test `/qa` on the live EO Scorecard Platform URL (Lana, Day 2)
- [ ] Resolve any CLAUDE.md conflicts between gstack and existing project instructions (Mamoun, Day 1)

**What changes as a result:**
- Stage 1-2 (Intake + Qualification): OpenClaw can invoke Claude Code with gstack `/office-hours` to stress-test founder ideas before committing pipeline resources
- Stage 6-8 (QA + Deploy + SaaS Shell): QA Lead role uses gstack `/qa` for browser-based visual testing, `/benchmark` for performance, auto-fix + regression test generation
- Stage 9 (GTM Generation): gstack `/qa` validates landing pages before campaign launch

**Role-to-Methodology Mapping (with ADR-007 and ADR-008):**

| AI Org Role | Primary Methodology | Key Skills |
|-------------|-------------------|------------|
| OpenClaw (COO) | gstack | `/office-hours`, `/plan-ceo-review` |
| VP Engineering | Superpowers | TDD, subagent isolation, spec compliance |
| QA Lead | gstack + Superpowers | `/qa`, `/benchmark`, Superpowers review |
| GTM Specialist | Existing GTM skills | signal-to-trust, wedge-generator |
| Content Lead | Existing content skills | asset-factory, youtube-deck |
| DevOps | Existing deploy skills | deploy-infra, Contabo MCP |
| Data Engineer | Existing scraper skills | scraper-layer, clay-operator |

**Reversal cost:** Easy (< 1 day) — gstack is a set of markdown skills that can be removed without affecting codebase
