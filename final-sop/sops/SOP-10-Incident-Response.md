# SOP-10: Incident Response

**Version:** 1.0 | **Date:** April 2026
**Scope:** All production and staging systems in SMOrchestra
**Locked by:** Mamoun Alamouri, 2026-04-06

---

## Purpose

Define how SMOrchestra detects, communicates, mitigates, resolves, and learns from incidents. Adapted from the engineering:incident-response plugin skill for our AI-native org with agent-driven execution.

---

## Severity Classification

| Level | Definition | Examples | Response Time | Communication |
|---|---|---|---|---|
| **SEV1** | Production down. Revenue or data at risk. | Supabase outage (all apps down), scoring engine returns 500 for all requests, n8n main workflow chain failure (signal pipeline halted), data breach or unauthorized access | < 15 min | Telegram to Mamoun immediately |
| **SEV2** | Major degradation. Core feature broken but system partially works. | Dashboard 500 errors on key pages, n8n webhook receiver dropping > 20% of events, scoring engine returning stale data (cache not refreshing), Paperclip unable to dispatch to 1+ agents | < 30 min | Telegram to Mamoun within 30 min |
| **SEV3** | Minor degradation. Non-critical feature broken or performance issue. | Single n8n workflow failing (non-pipeline-critical), slow dashboard load (> 5s), agent skill injection mismatch (see SOP-09), non-critical API returning errors intermittently | < 2 hours | Linear comment on tracking issue |
| **SEV4** | Cosmetic or low-impact. No user-facing effect. | Log noise, minor UI glitch, deprecated dependency warning, test flakiness | < 24 hours | Linear comment on tracking issue |

---

## Roles

| Role | Agent/Person | Responsibility |
|---|---|---|
| **Incident Commander** | Sulaiman (CEO Agent) | Declares severity, coordinates response, owns communication, drives postmortem |
| **Mitigation Lead** | DevOps Agent | Executes rollbacks, restarts services, applies temporary fixes |
| **Root Cause Lead** | al-Jazari (VP Eng Agent) | Investigates root cause, identifies fix, implements permanent resolution |
| **Verification** | QA Lead Agent + Lana | Confirms fix works, runs regression, signs off on resolution |
| **Escalation Authority** | Mamoun Alamouri | Final decision on SEV1-2, approves production hotfixes |

---

## 5-Phase Response Framework

### Phase 1: Triage (0-15 min)

1. **Detect:** Alert arrives via monitoring (n8n health checks, Supabase alerts, agent heartbeat failures) or manual report.
2. **Classify:** Sulaiman assigns severity using the table above. When in doubt, round up (SEV3 becomes SEV2).
3. **Assign:** Sulaiman dispatches roles:
   - DevOps Agent begins mitigation
   - al-Jazari begins investigation
   - QA Lead Agent prepares verification environment
4. **Document:** Create a Linear issue with label `incident` and severity tag. Title format: `[SEV-X] Brief description - YYYY-MM-DD`

**Triage checklist:**
```
[ ] Severity assigned
[ ] Linear issue created
[ ] Roles dispatched
[ ] Communication sent (per severity level)
[ ] Impact scope identified (which users/systems affected)
```

### Phase 2: Communicate (Continuous)

**SEV1-2:** Telegram message to Mamoun with:
```
INCIDENT: [SEV-X] [One-line summary]
Impact: [What is broken, who is affected]
Status: [Investigating / Mitigating / Resolved]
ETA: [Estimated time to resolution or "Unknown"]
Action needed: [Yes/No - what Mamoun needs to do]
```

Update every 30 min for SEV1, every 60 min for SEV2, until resolved.

**SEV3-4:** Linear comment updates. No Telegram unless escalated.

**Escalation triggers:**
- Mitigation fails after 30 min (SEV1) or 60 min (SEV2) -- escalate to Mamoun
- Root cause requires infrastructure access agents don't have -- escalate to Mamoun
- Fix requires production database changes -- escalate to Mamoun
- Impact is worse than initially classified -- reclassify and re-communicate

### Phase 3: Mitigate (Parallel with Phase 2)

Goal: Stop the bleeding. Restore service even if degraded.

**DevOps Agent actions (in priority order):**

1. **Rollback** -- If a recent deploy caused the issue:
   ```bash
   # On smo-dev (100.117.35.19)
   git log --oneline -5   # Identify last good commit
   git revert HEAD         # Revert bad commit
   # Redeploy
   ```
2. **Restart** -- If service is hung:
   ```bash
   # On appropriate server
   sudo systemctl restart [service-name]
   # or
   docker restart [container-name]
   ```
3. **Failover** -- If smo-dev is down, critical orchestration continues on smo-brain
4. **Feature flag** -- Disable the broken feature if possible, keep rest of system running
5. **Manual workaround** -- Document and communicate a temporary user-facing workaround

### Phase 4: Resolve (After Mitigation)

Goal: Permanent fix deployed and verified.

1. **al-Jazari identifies root cause** using the 5 Whys method (see Postmortem section)
2. **Fix is implemented** on a branch, PR created
3. **QA Lead Agent reviews** fix for correctness and security
4. **Lana verifies** fix on staging (Windows machine, Amman timezone UTC+3 -- plan handover timing accordingly)
5. **Deploy** fix via standard deploy process (SOP-06, smo-dev)
6. **Monitor** for 30 min post-deploy to confirm resolution
7. **Close** Linear issue with resolution summary

### Phase 5: Postmortem

**Deadline:**
- SEV1-2: Postmortem document completed within 24 hours of resolution
- SEV3-4: Postmortem document completed within 72 hours of resolution

**Ownership:** Sulaiman drafts the postmortem. al-Jazari provides technical details. QA Lead provides verification details.

---

## Postmortem Template

```markdown
# Postmortem: [SEV-X] [Title]

**Date:** YYYY-MM-DD
**Duration:** [Time from detection to resolution]
**Author:** [Agent/Person who wrote this]
**Severity:** SEV-X
**Linear Issue:** [Link]

## Summary
[2-3 sentences: What happened, what was the impact, how was it resolved]

## Impact
- **Users affected:** [Count or scope]
- **Duration of impact:** [Minutes/hours]
- **Data loss:** [Yes/No, details]
- **Revenue impact:** [If applicable]

## Timeline (UTC+4 Dubai time)
| Time | Event |
|---|---|
| HH:MM | [First detection signal] |
| HH:MM | [Severity declared] |
| HH:MM | [Mitigation started] |
| HH:MM | [Mitigation effective] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix deployed] |
| HH:MM | [Verification complete, incident closed] |

## Root Cause: 5 Whys

1. **Why did the system fail?** [Answer]
2. **Why did [Answer 1] happen?** [Answer]
3. **Why did [Answer 2] happen?** [Answer]
4. **Why did [Answer 3] happen?** [Answer]
5. **Why did [Answer 4] happen?** [Root cause]

## What Went Well
- [Bullet points]

## What Went Poorly
- [Bullet points]

## Action Items

| Action | Owner | Priority | Deadline | Status |
|---|---|---|---|---|
| [Preventive action] | [Agent/Person] | P1/P2/P3 | YYYY-MM-DD | Open |

## Lessons Learned
[What changes to process, monitoring, or architecture should be made]
```

---

## Example Scenarios

### Scenario A: n8n Signal Pipeline Failure (SEV1)

**Detection:** n8n health check workflow on smo-brain reports main signal pipeline has not executed in 15 min.

**Triage:** Sulaiman classifies as SEV1 (signal pipeline is core revenue engine). Dispatches DevOps to check n8n, al-Jazari to investigate workflow logic.

**Communicate:** Telegram to Mamoun:
```
INCIDENT: [SEV1] Signal pipeline halted - no executions in 15 min
Impact: All inbound signals queued but not processed. Scoring stale.
Status: Investigating
ETA: Unknown
Action needed: No - agents handling
```

**Mitigate:** DevOps checks n8n on smo-brain (100.89.148.62):
- n8n process running but workflow stuck in "executing" state
- DevOps restarts the specific workflow execution
- Pipeline resumes, queued signals begin processing

**Resolve:** al-Jazari finds root cause: webhook payload exceeded n8n memory limit. Fix: add payload size validation at webhook entry. PR created, reviewed, deployed.

**Postmortem:** Completed within 24 hours. Action item: add payload size monitoring alert.

### Scenario B: Dashboard 500 Error (SEV2)

**Detection:** Lana reports dashboard returns 500 on the scoring overview page.

**Triage:** Sulaiman classifies as SEV2 (dashboard works on other pages, scoring data still being collected).

**Communicate:** Telegram to Mamoun within 30 min.

**Mitigate:** DevOps checks Supabase function logs. Function timeout on a heavy query. DevOps increases timeout as temporary fix.

**Resolve:** al-Jazari optimizes the query, adds index. PR reviewed, deployed. Lana verifies on her Windows machine.

**Postmortem:** Completed within 24 hours. Action item: add query performance monitoring, set timeout alerts.

### Scenario C: Agent Skill Mismatch (SEV3)

**Detection:** GTM Agent executes a code-review skill it should not own.

**Triage:** Sulaiman classifies as SEV3 (no user impact, but routing integrity compromised).

**Communicate:** Linear comment.

**Resolve:** al-Jazari audits OpenClaw config against SOP-09 registry. Finds GTM agent config has stale skill assignment. Fixes config, syncs from smorch-brain.

**Postmortem:** Completed within 72 hours. Action item: add monthly registry audit to prevent drift.
