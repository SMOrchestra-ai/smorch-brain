# ADR-008: Superpowers as Engineering Methodology Layer

**Date:** 2026-03-28
**Status:** Accepted
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (VibeMicroSaaS Super AI — Phase 0)

## 1. Context

The VibeMicroSaaS pipeline generates production code autonomously (Stages 5-6: Code Build + QA). Autonomous code generation without engineering discipline produces "AI slop" — code that works superficially but accumulates technical debt, lacks tests, and breaks under edge cases. The platform needs an enforced engineering methodology that ensures code quality without human code review at every step.

## 2. Options Considered

### Option A: No methodology enforcement (status quo)
- **Description:** Continue using existing `eo-microsaas-dev` and `eo-qa-testing` skills as-is. These are markdown instructions that suggest but don't enforce quality practices.
- **Pros:** Zero setup; already working for guided sessions
- **Cons:** No TDD enforcement; quality varies without human review; no spec compliance verification; skills "suggest" rather than "require"
- **Estimated effort:** 0

### Option B: Superpowers Framework (obra/superpowers)
- **Description:** Install Superpowers as a Claude Code plugin/skill set. Enforces: mandatory brainstorming before code, TDD RED-GREEN-REFACTOR cycle, subagent isolation per task, two-stage review (spec compliance + code quality), automated deletion of non-tested code, Git Worktree isolation for parallel development.
- **Pros:** Pre-implementation TDD prevents bugs at source; subagent isolation prevents context contamination; two-stage review catches both spec drift and quality issues; design-locking ensures architecture decisions stick; particularly strong for Signal Sales Engine (complex data processing where bugs = spam/GDPR violations)
- **Cons:** Slower than unstructured coding; some overhead in brainstorming phase; requires plan approval before coding starts
- **Estimated effort:** 4 hours (install + configure + test)

### Option C: Custom TDD enforcement via hooks
- **Description:** Build custom Claude Code hooks that reject commits without corresponding test files
- **Pros:** Tailored to our exact needs
- **Cons:** Must build and maintain ourselves; hooks are brittle; doesn't provide subagent isolation or spec compliance review
- **Estimated effort:** 1-2 days

## 3. Decision

We chose **Option B: Superpowers** because it provides a comprehensive, battle-tested engineering methodology specifically designed for autonomous code generation. The overhead of brainstorming-before-code and TDD enforcement is the correct trade-off for a platform that ships production code to paying customers without human review.

## 4. Trade-offs Accepted

- **Speed vs. rigor:** Superpowers is slower than unstructured coding. We accept 20-30% longer build times in exchange for production-grade code quality.
- **Plan approval overhead:** Every coding task requires an approved implementation plan before a single line of code is written. We accept this because the alternative (autonomous agent coding without a plan) is how "AI slop" happens.

## 5. Consequences

**Immediate actions required:**
- [ ] Install Superpowers: `/plugin marketplace add obra/superpowers-marketplace` on all Claude Code instances (Mamoun, Day 1)
- [ ] Configure Superpowers to work alongside existing eo-microsaas-dev skill without conflicts (Mamoun, Day 1)
- [ ] Test TDD enforcement on a sample Stage 5 build (Lana, Day 2)

**What changes as a result:**
- All Stage 5 (Code Build) and Stage 6 (QA) work runs through Superpowers methodology
- VP Engineering role (ADR-007) uses Superpowers as its primary operating framework
- Code that lacks tests is automatically deleted — no exceptions
- Implementation plans must be approved before coding begins (OpenClaw approval via Telegram for autonomous runs)

**Integration with AI-Native Org:**
- VP Engineering Claude Code instance loads Superpowers + `vp-engineering.md`
- QA Lead Claude Code instance uses Superpowers review capabilities + gstack `/qa` for browser testing
- Other roles (GTM, Content, DevOps) do NOT load Superpowers — it's engineering-specific

**Reversal cost:** Easy (< 1 day) — Superpowers is a plugin that can be removed without affecting codebase
