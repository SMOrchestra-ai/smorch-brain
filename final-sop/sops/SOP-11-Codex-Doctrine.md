# SOP-11: Codex Doctrine -- Codex vs Claude Code Allocation

**Version:** 1.0 | **Date:** April 2026
**Scope:** All development tasks dispatched via Paperclip/OpenClaw
**Locked by:** Mamoun Alamouri, 2026-04-06

---

## Default Rule

**ALL work routes through Claude Code.** Opus for planning and architecture. Sonnet for execution and implementation.

Codex is not a default. It is activated only through an explicit approval process.

---

## Codex Activation Process

```
Agent proposes  ──>  Mamoun reviews  ──>  Approved?  ──>  Dispatch
                                              │
                                              No ──> Claude Code handles everything
```

### Step 1: Agent Proposes a Workforce Plan

Only Sulaiman (CEO Agent) or al-Jazari (VP Eng Agent) may propose Codex usage. No other agent or process activates Codex.

The proposing agent creates a **Workforce Plan** with this format:

```markdown
## Workforce Plan: [Project/Feature Name]

**Proposed by:** [Agent name]
**Date:** YYYY-MM-DD
**Total tasks:** [N]
**Total agents needed:** [N]

### Task Allocation

| # | Task | Tool | Reasoning | Risk |
|---|---|---|---|---|
| 1 | [Task description] | Claude Code (Opus) | [Why Claude Code] | [Low/Med/High] |
| 2 | [Task description] | Codex | [Why Codex is better here] | [Low/Med/High] |
| 3 | [Task description] | Claude Code (Sonnet) | [Why Claude Code] | [Low/Med/High] |

### Codex Tasks Detail
For each task assigned to Codex:
- **Input:** SPEC.json reference or exact specification
- **Bounded scope:** [What files/modules Codex touches -- must be explicit]
- **Expected output:** [What the diff should look like]
- **Max diff size:** [Lines, must be <= 500]
- **Fallback:** If Codex output fails review, reassign to Claude Code

### Risk Assessment
- **Overall risk:** [Low/Medium/High]
- **Worst case if Codex fails:** [Impact description]
- **Recovery plan:** [How we handle failure]
```

### Step 2: Mamoun Approves or Adjusts

Workforce Plan is sent to Mamoun via Telegram (for SEV1-2 urgency) or Linear comment (standard).

Mamoun may:
- **Approve as-is** -- agents proceed
- **Adjust allocation** -- move tasks between Codex and Claude Code
- **Reject** -- all tasks go to Claude Code

No Codex task executes before Mamoun's explicit approval.

### Step 3: Dispatch

After approval, Sulaiman dispatches tasks per the approved plan. Codex tasks include the SPEC.json reference and constraints from the Workforce Plan.

---

## Where Codex Fits Best

Codex is effective for bounded, well-specified, low-risk tasks that don't require repo-wide understanding.

| Use Case | Why Codex Works |
|---|---|
| Bounded backend CRUD operations | Clear input/output, single-file scope, repetitive patterns |
| Test scaffold generation | Formulaic structure, low risk, speeds up coverage |
| Webhook/API boilerplate | Standard patterns, well-defined contracts |
| Terminal debugging (isolated) | Contained scope, fast iteration |
| Data migration scripts | One-time execution, clear before/after states |
| Config file generation | Template-driven, low complexity |
| Repetitive refactoring (rename, restructure) | Mechanical changes, pattern-based |

---

## Where Codex NEVER Goes

These tasks require judgment, context, or cross-cutting understanding that Codex cannot provide.

| Exclusion | Why |
|---|---|
| Architecture decisions | Requires repo-wide understanding, trade-off analysis, ADR context |
| Security-sensitive code | Auth, encryption, access control, token handling -- too high-risk for bounded context |
| Cross-service integration | Requires understanding multiple systems, contracts, failure modes |
| UI/Frontend work | Requires visual judgment, component relationships, user experience context |
| Anything requiring repo-wide understanding | Codex operates on bounded context; it cannot reason about system-wide implications |
| Database schema changes | Requires migration strategy, backward compatibility analysis |
| Agent configuration | OpenClaw/Paperclip configs affect entire org; mistakes cascade |
| Incident response | Requires real-time judgment, escalation decisions, communication |

---

## Guardrails

### 1. SPEC.json Mandatory

Every Codex task must reference a SPEC.json created by Claude Code (Opus). The SPEC.json defines:
- Exact files to create or modify
- Function signatures and types
- Test cases to satisfy
- Constraints and boundaries

Codex follows the SPEC. It does not deviate.

### 2. Max Diff Size: 500 Lines

No single Codex task produces a diff larger than 500 lines. If the estimated output exceeds this:
- Split into multiple bounded tasks
- Or reassign to Claude Code which can handle larger scope

### 3. Plan-First Mandatory

Codex must output a plan before writing code. The plan is reviewed (by al-Jazari or QA Lead) before execution proceeds. No "just start coding."

### 4. Network Boundary Enforced

Codex tasks run in sandboxed environments. No direct access to:
- Production databases
- External APIs with write permissions
- Agent communication channels
- Deployment infrastructure

All Codex output goes through PR review before touching any live system.

---

## Rollback Policy

If Codex output fails review:

1. **Do not retry with Codex.** The task has proven it needs more context than Codex can provide.
2. **Reassign to Claude Code** (Sonnet for execution, Opus if architecture judgment needed).
3. **Log the failure** in the Workforce Plan's Linear issue with reason (e.g., "Codex missed edge case in auth flow -- needs repo-wide context").
4. **Update precedent:** If a task type fails twice via Codex, add it to the "NEVER" list above.

---

## Tracking

Every Workforce Plan that includes Codex tasks gets a Linear issue with label `codex-allocation`. Monthly review of:
- Codex success rate (tasks that passed review without reassignment)
- Average diff size
- Task types that consistently succeed/fail
- Cost comparison (Codex tokens vs Claude Code tokens for equivalent tasks)

Target: Codex tasks should pass review on first attempt > 80% of the time. Below that, tighten the "Fits Best" criteria.

---

## Decision Flowchart

```
New task arrives
    │
    ├── Requires architecture/security/integration/UI?
    │       YES ──> Claude Code (always)
    │
    ├── Bounded CRUD / boilerplate / scaffold / migration?
    │       YES ──> Agent proposes in Workforce Plan
    │                   │
    │                   ├── Mamoun approves? ──> Codex with SPEC.json
    │                   └── Mamoun rejects? ──> Claude Code
    │
    └── Unclear scope?
            ──> Claude Code (default)
```
