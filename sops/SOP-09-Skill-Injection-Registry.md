---
status: active
last_reviewed: 2026-04-19
---

# SOP-9: Skill Injection Registry

**Version:** 1.0 | **Date:** April 2026
**Scope:** All agents in the SMOrchestra AI-native org
**Locked by:** Mamoun Alamouri, 2026-04-06

---

## Purpose

Every agent must know exactly which skills it owns. Skill duplication across agents causes conflicting outputs, wasted compute, and unpredictable routing. This registry is the single source of truth for skill-to-agent assignment.

**Rules:**

1. One skill = one primary owner. Secondary agents may have read access but never execute authority.
2. If two agents need the same skill, one owns it and the other calls it via delegation (not duplication).
3. This registry is authoritative. If a skill is not listed here, no agent runs it.

---

## Skill Registry

### Sulaiman (CEO Agent)

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| feature-spec | product-management | "write spec", "define feature", "spec out" | Manual |
| sprint-planning | product-management | "plan sprint", "sprint scope", "next sprint" | Manual |
| stakeholder-comms | product-management | "stakeholder update", "exec summary", "board update" | Manual |
| roadmap-management | product-management | "update roadmap", "roadmap review", "prioritize roadmap" | Manual |
| metrics-review | product-management | "review metrics", "KPI check", "dashboard review" | Auto (weekly) |
| incident-response (commander) | engineering | "SEV1", "SEV2", "incident", "outage" | Auto (on alert) |
| workforce-plan | custom | "workforce plan", "allocate agents", "codex vs claude" | Manual |

### al-Jazari (VP Engineering Agent)

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| code-review | engineering | "review PR", "code review", "check code" | Auto (on PR) |
| system-design | engineering | "design system", "architecture for", "system design" | Manual |
| architecture | engineering | "architecture review", "arch decision", "ADR" | Manual |
| tech-debt | engineering | "tech debt", "refactor plan", "cleanup" | Manual |
| testing-strategy | engineering | "test plan", "testing strategy", "QA approach" | Manual |
| deploy-checklist | engineering | "deploy check", "pre-deploy", "release checklist" | Auto (pre-deploy) |
| debug | engineering | "debug", "investigate error", "root cause" | Manual |
| documentation | engineering | "write docs", "document this", "runbook" | Manual |
| feature-spec | product-management | "technical spec", "eng spec" | Manual |
| project-onboard | custom | "/project-onboard", "onboard project", "preflight" | Manual |
| handover-to-lana | custom | "hand to lana", "lana review", "QA handover" | Auto (on PR ready) |

### QA Lead Agent

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| testing-strategy | engineering | "QA plan", "test coverage", "regression plan" | Manual |
| code-review (security + correctness) | engineering | "security review", "correctness check" | Auto (on PR) |
| handover-to-lana | custom | "prepare for lana", "lana brief" | Auto (on PR ready) |

### DevOps Agent

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| deploy-checklist | engineering | "deploy", "release", "ship it" | Auto (pre-deploy) |
| incident-response (mitigation) | engineering | "mitigate", "rollback", "hotfix infra" | Auto (on alert) |
| documentation (runbooks) | engineering | "write runbook", "ops doc", "incident playbook" | Manual |
| project-onboard | custom | "setup project", "infra check", "env setup" | Manual |

### GTM Agent

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| competitive-analysis | product-management | "competitive brief", "competitor check" | Manual |
| user-research-synthesis | product-management | "synthesize research", "user insights" | Manual |
| All smorch-gtm skills | smorch-gtm-engine, smorch-gtm-tools, smorch-gtm-scoring | Various (see plugin docs) | Per-skill |

### Content Agent

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| stakeholder-comms (customer-facing) | product-management | "customer update", "release notes", "changelog" | Manual |

### Data Engineering Agent

| Skill Name | Source Plugin | Trigger Phrases | Auto/Manual |
|---|---|---|---|
| metrics-tracking | custom | "track metric", "add KPI", "instrument" | Manual |
| user-research-synthesis | product-management | "data analysis", "usage patterns", "cohort analysis" | Manual |

---

## Source of Truth

```
smorch-brain repo
  └── plugins/
       ├── engineering/          # code-review, debug, deploy-checklist, etc.
       ├── product-management/   # feature-spec, sprint-planning, etc.
       ├── smorch-gtm-engine/    # signal-detector, campaign-strategist, etc.
       ├── smorch-gtm-tools/     # clay-operator, instantly-operator, etc.
       ├── smorch-gtm-scoring/   # campaign-strategy-scorer, etc.
       └── custom/               # workforce-plan, handover-to-lana, project-onboard
```

Each plugin directory contains a `SKILL.md` defining inputs, outputs, triggers, and constraints. The `SKILL.md` is the executable definition. This SOP is the assignment map.

---

## Update Process

1. **Never edit skills directly on servers.** Servers pull from smorch-brain. Direct edits get overwritten on next sync.
2. All changes go through a smorch-brain commit:
   - Add or modify the skill in `plugins/[category]/SKILL.md`
   - Update this registry (SOP-09) in the same commit
   - Run `smorch audit` before pushing
   - Push to smorch-brain main branch
   - Servers pull on next sync cycle (or manual `smorch push`)
3. To reassign a skill to a different agent:
   - Update the registry table (move the row)
   - Update the agent's OpenClaw config to include/exclude the skill
   - Verify via `/project-onboard` that the receiving agent can invoke the skill
4. To add a new skill:
   - Create `SKILL.md` in the appropriate plugin directory
   - Add a row to the correct agent table in this registry
   - Specify Auto vs Manual and trigger phrases
   - Run integration test: dispatch a task using the trigger phrase, confirm correct agent picks it up

---

## Conflict Resolution

If two agents attempt to execute the same skill on the same task:

1. The agent listed as primary owner in this registry wins.
2. The secondary agent's execution is cancelled.
3. An alert is sent to Sulaiman to investigate the routing failure.
4. Root cause is logged and the routing rule is patched in OpenClaw config.

---

## Audit

Run monthly: Compare active OpenClaw agent configs against this registry. Any mismatch is a SEV3 incident (see SOP-10).
