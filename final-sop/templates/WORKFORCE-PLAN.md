# Workforce Plan: [Project Name]

**Date:** YYYY-MM-DD
**Author:** [Name]
**Status:** Pending Approval | Approved | In Progress | Complete

---

## Overview

| Dimension     | Value |
|---------------|-------|
| Project Name  |       |
| Total Agents  |       |
| Total Tasks   |       |
| Sprint/Cycle  |       |

---

## Claude Code Assignments

> Claude Code: interactive, full repo access, auth-capable, multi-step reasoning, tool use.

| Task | Agent | Reasoning |
|------|-------|-----------|
|      |       |           |
|      |       |           |
|      |       |           |

---

## Codex Assignments

> Codex: sandboxed, isolated execution, no auth/secrets, parallel batch-friendly.

| Task | Agent | Reasoning |
|------|-------|-----------|
|      |       |           |
|      |       |           |
|      |       |           |

---

## Rationale

[Explain why tasks were split this way. Reference task shape: does the task need auth, multi-file context, tool access, or conversation continuity (Claude Code)? Or is it isolated, deterministic, and parallelizable (Codex)?]

---

## Risk Assessment

### Isolation Risks
- [ ] No Codex task requires access to secrets, API keys, or auth tokens
- [ ] No Codex task depends on output from another Codex task in the same batch
- [ ] Each Codex task can succeed independently with the provided context

### Security
- [ ] No credentials passed to Codex sandbox
- [ ] No PII or sensitive data in Codex task inputs
- [ ] Output from Codex reviewed before merging

### Rollback Plan
| Scenario | Action |
|----------|--------|
| Codex task produces incorrect output | Discard output, reassign to Claude Code |
| Codex task hangs or times out | Cancel, resubmit with reduced scope |
| Integration conflict between parallel outputs | Claude Code resolves merge manually |

---

## Approval

> **This plan requires Mamoun's approval before dispatch.**

- [ ] Mamoun reviewed assignments
- [ ] Mamoun approved dispatch
- **Approved by:** _______________
- **Date:** _______________
