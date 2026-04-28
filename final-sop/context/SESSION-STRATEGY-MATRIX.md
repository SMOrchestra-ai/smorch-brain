# Session Strategy Matrix

> Formalized run vs issue strategy for AI agent sessions.
> **This is architecture, not configuration.** Changes require deliberate decision, not casual toggle.

---

## Definitions

| Mode | Description | Best For |
|------|-------------|----------|
| **Run** | Bounded execution. Fresh context per wake. Agent completes task and terminates. | Deterministic tasks, parallel work, no state needed between invocations. |
| **Issue** | Continuity session. Agent maintains context across interactions. Supervision and synthesis. | Strategy, multi-step reasoning, cross-cutting decisions, tasks requiring memory. |

---

## Locked Defaults

| Role | Default Mode | Rationale |
|------|-------------|-----------|
| CEO Agent (Sulaiman) | Issue | Needs continuity for strategy, cross-project visibility, and decision synthesis. |
| VP Engineering | Run | Each task is bounded: design, review, plan. Fresh context prevents stale assumptions. |
| QA Lead (Lana) | Run | Each PR review is independent. Clean slate prevents bias from previous reviews. |
| DevOps Agent | Run | Deploy, monitor, respond. Each operation is atomic and bounded. |
| Data Engineer | Run | Pipeline tasks are isolated. ETL jobs don't need conversational memory. |
| GTM Agent | Mixed | Campaign launches = run. Strategy refinement = issue. See override conditions. |
| Content Agent | Mixed | Individual posts = run. Content calendar planning = issue. See override conditions. |

---

## Override Conditions

> Task shape beats role default. Apply these overrides when the task doesn't fit the role's locked mode.

### Run -> Issue (upgrade to continuity)

| Condition | Example | Why |
|-----------|---------|-----|
| Task spans multiple sessions | Multi-day architecture redesign | Needs memory of prior decisions |
| Task requires cross-agent synthesis | Combining QA results + engineering feedback | Needs accumulated context |
| Task involves stakeholder negotiation | Going back and forth on requirements | Conversation history matters |
| Task has branching decision tree | "If X then do Y, else do Z" with discovery | Can't pre-determine execution path |

### Issue -> Run (downgrade to bounded)

| Condition | Example | Why |
|-----------|---------|-----|
| Task is fully specified | Execute a known playbook | No decisions to make, just execute |
| Task is embarrassingly parallel | Generate 10 independent assets | Each is independent, no shared state |
| Context is polluted | Agent is confused by accumulated state | Fresh start is more efficient |
| Task is time-sensitive | Incident response first action | Speed > continuity |

---

## Decision Flowchart

```
Is the task fully specified with no ambiguity?
  YES -> Run
  NO  -> Does it require memory of previous steps?
           YES -> Issue
           NO  -> Is it parallelizable?
                    YES -> Run
                    NO  -> Does it require cross-agent coordination?
                             YES -> Issue
                             NO  -> Default to role's locked mode
```

---

## Rules

1. **Task shape beats role default.** A QA agent doing multi-sprint test strategy planning should use Issue mode despite the Run default.
2. **Mixed-mode roles** must declare the mode at task assignment time. No implicit switching mid-task.
3. **Mode escalation** (Run -> Issue) can happen mid-task if the agent discovers the task is more complex than expected. Agent must log the escalation reason.
4. **Mode downgrade** (Issue -> Run) should be a deliberate restart, not a drift. Kill the issue session, start a fresh run.
5. **CEO Agent is always Issue.** No override. Strategy requires continuity.
6. **Incident response** always starts as Run regardless of role. Escalate to Issue only if the incident becomes a multi-day investigation.

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Long-running Issue for mechanical tasks | Context bloat, slower responses, hallucination risk | Break into Run tasks, aggregate results in a final Issue |
| Run mode for strategy work | Loses prior reasoning, repeats analysis | Use Issue mode for anything requiring synthesis |
| Never overriding defaults | Some tasks don't fit the role's default | Apply override conditions above |
| Switching modes mid-task silently | Confusing audit trail, lost context | Log mode changes explicitly |
