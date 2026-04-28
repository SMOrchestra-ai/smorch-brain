# Deploy Checklist: [Release / Feature Name]

**Date:** YYYY-MM-DD
**Deploy Owner:** [Name]
**Environment:** staging | production
**Type:** [ ] Feature Flag  [ ] DB Migration  [ ] Breaking API Change  [ ] Standard

---

## Pre-Deploy

- [ ] All tests passing (unit, integration, e2e)
- [ ] Code reviewed and approved
- [ ] No critical or blocker bugs open against this release
- [ ] DB migrations tested against staging data
- [ ] Feature flags configured and default states verified
- [ ] Rollback plan documented (see Rollback section below)
- [ ] On-call engineer notified
- [ ] Release notes drafted
- [ ] Dependency versions locked (no floating)

### If DB Migration
- [ ] Migration is backward-compatible (old code can run against new schema)
- [ ] Migration tested with production-scale data volume
- [ ] Rollback migration script exists and tested
- [ ] Migration estimated runtime: ____

### If Breaking API Change
- [ ] Deprecation notice sent to consumers (minimum 2 weeks prior)
- [ ] Versioned endpoint available
- [ ] Consumer migration guide published
- [ ] Old endpoint sunset date set: ____

### If Feature Flag
- [ ] Flag registered in flag management system
- [ ] Default state: OFF in production
- [ ] Kill switch tested (flag OFF disables feature cleanly)
- [ ] Gradual rollout plan defined: ___% -> ___% -> 100%

---

## Deploy

- [ ] Deploy to staging
- [ ] Staging smoke tests pass
- [ ] QA sign-off on staging
- [ ] Deploy to production (canary if available)
- [ ] Monitor error rates for 15 minutes post-deploy
- [ ] Verify critical user flows:
  - [ ] [Flow 1]
  - [ ] [Flow 2]
  - [ ] [Flow 3]
- [ ] Verify no new errors in logging/monitoring

---

## Post-Deploy

- [ ] Metrics nominal (latency, error rate, throughput)
- [ ] Release notes published
- [ ] Stakeholders notified (Slack / Telegram / email)
- [ ] Related tickets moved to Done
- [ ] Feature flag gradual rollout started (if applicable)
- [ ] Monitoring alerts configured for new features

---

## Rollback Triggers

Initiate rollback immediately if ANY of the following occur:

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Error rate spike | > [X]% above baseline | Rollback deploy |
| Latency increase | p95 > [X]ms | Rollback deploy |
| Critical flow failure | Any critical path broken | Rollback deploy |
| Data integrity | Any data corruption signal | Rollback + incident |

### Rollback Steps

1.
2.
3.

---

## Sign-Off

| Role | Name | Approved | Time |
|------|------|----------|------|
| Deploy Owner | | [ ] | |
| QA | | [ ] | |
| On-Call | | [ ] | |
