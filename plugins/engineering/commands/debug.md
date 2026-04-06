---
description: Structured debugging session — reproduce, isolate, diagnose, and fix
argument-hint: "<error message or problem description>"
---

# /debug

> If you see unfamiliar placeholders or need to check which tools are connected, see [CONNECTORS.md](../CONNECTORS.md).

Run a structured debugging session to find and fix issues systematically.

## Usage

```
/debug $ARGUMENTS
```

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Step 1-3, you CANNOT propose fixes. Symptom fixes are failure.
If 3+ fix attempts fail, STOP — question the architecture, don't attempt fix #4.

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                       DEBUG                                        │
├─────────────────────────────────────────────────────────────────┤
│  Step 1: REPRODUCE                                                │
│  ✓ Understand the expected vs. actual behavior                   │
│  ✓ Identify exact reproduction steps                             │
│  ✓ Determine scope (when did it start? who is affected?)        │
│  ✓ In multi-component systems: add diagnostic logging at EACH   │
│    component boundary BEFORE attempting fixes                    │
│                                                                    │
│  Step 2: ISOLATE                                                   │
│  ✓ Narrow down the component, service, or code path             │
│  ✓ Check recent changes (deploys, config changes, dependencies) │
│  ✓ Review logs and error messages — read them COMPLETELY         │
│  ✓ Find working examples of similar code — compare differences  │
│                                                                    │
│  Step 3: DIAGNOSE                                                  │
│  ✓ Form a SINGLE hypothesis: "X is root cause because Y"        │
│  ✓ Test with the SMALLEST possible change (one variable only)    │
│  ✓ If it didn't work: form NEW hypothesis, don't stack fixes    │
│  ✓ Trace data flow backward to find the SOURCE, not the symptom │
│                                                                    │
│  Step 4: FIX                                                       │
│  ✓ Create failing test case BEFORE implementing fix              │
│  ✓ Implement SINGLE fix addressing root cause                    │
│  ✓ Verify: test passes, no other tests broken, issue resolved   │
│  ✓ If fix fails and 3+ attempts made: STOP, question architecture│
└─────────────────────────────────────────────────────────────────┘
```

## Red Flags — STOP and Return to Step 1

If you catch yourself thinking any of these, you are skipping the process:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "It's probably X, let me fix that" (without evidence)
- "One more fix attempt" (when already tried 2+)
- Proposing solutions before tracing data flow

## What I Need From You

Tell me about the problem. Any of these help:
- Error message or stack trace
- Steps to reproduce
- What changed recently
- Logs or screenshots
- Expected vs. actual behavior

## Output

```markdown
## Debug Report: [Issue Summary]

### Reproduction
- **Expected**: [What should happen]
- **Actual**: [What happens instead]
- **Steps**: [How to reproduce]

### Root Cause
[Explanation of why the bug occurs]

### Fix
[Code changes or configuration fixes needed]

### Prevention
- [Test to add]
- [Guard to put in place]
```

## If Connectors Available

If **~~monitoring** is connected:
- Pull logs, error rates, and metrics around the time of the issue
- Show recent deploys and config changes that may correlate

If **~~source control** is connected:
- Identify recent commits and PRs that touched affected code paths
- Check if the issue correlates with a specific change

If **~~project tracker** is connected:
- Search for related bug reports or known issues
- Create a ticket for the fix once identified

## Tips

1. **Share error messages exactly** — Don't paraphrase. The exact text matters.
2. **Mention what changed** — Recent deploys, dependency updates, and config changes are top suspects.
3. **Include context** — "This works in staging but not prod" or "Only affects large payloads" narrows things fast.
