# QA Handover Template

Copy this template when handing off work to QA.

---

## Handover: {Feature/Fix Name}

**Date:** {YYYY-MM-DD}
**Developer:** {name or "Claude Code"}
**PR:** #{number} — {link}
**Branch:** {branch name}
**Deployed to:** {server} at {URL}
**Commit on server:** {run `/api/health` or `git log --oneline -1`}

### What Changed

- {bullet 1: what was added/changed/fixed}
- {bullet 2}
- {bullet 3}

### What to Test

| # | Scenario | Steps | Expected Result |
|---|----------|-------|----------------|
| 1 | {scenario} | 1. Go to... 2. Click... | {expected} |
| 2 | {scenario} | 1. Go to... 2. Enter... | {expected} |
| 3 | {scenario} | 1. Go to... | {expected} |

### What NOT to Test (out of scope)

- {anything unchanged that QA should skip}

### Known Issues

- {any known limitations or edge cases}

### Rollback Plan

If critical issues found:
```bash
ssh {server} "cd {path} && git checkout {previous-commit} && npm run build && pm2 reload ecosystem.config.js"
```

### Sign-off

- [ ] QA tested all scenarios above
- [ ] QA verified commit hash matches PR
- [ ] QA tested on mobile viewport
- [ ] QA tested Arabic/RTL (if applicable)
- [ ] QA approved — ready for main merge
