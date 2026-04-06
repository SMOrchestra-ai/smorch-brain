# Sprint Velocity Data

> Living document tracking sprint velocity across SMOrchestra AI-native org.
> **Updated at sprint close.** Source of truth for sprint planning predictions and capacity decisions.

---

## Current Sprint

- **Sprint:** [name/number]
- **Start:** YYYY-MM-DD | **End:** YYYY-MM-DD
- **Planned points:** [X]
- **Completed points:** [Y] *(updated at close)*
- **Velocity:** [Y] pts/sprint
- **Active adjustment factors:** [none / Ramadan -35% / etc.]

---

## Historical Velocity

| Sprint | Dates | Planned | Completed | Velocity | Carry-Over | Notes |
|--------|-------|---------|-----------|----------|------------|-------|
| *Example: Sprint 1* | *2026-03-01 to 2026-03-14* | *21* | *18* | *18* | *3* | *First sprint, calibration* |
| | | | | | | |
| | | | | | | |
| | | | | | | |

---

## Rolling Average

- **3-sprint average:** [X] pts
- **Trend:** [improving / stable / declining]
- **Trend reason:** [one-line explanation — e.g., "stable after onboarding ramp-up completed"]

### Velocity Chart (text-based)

```
Sprint    | Velocity | Bar
----------|----------|--------------------
Sprint 1  | 18       | ##################
Sprint 2  | 22       | ######################
Sprint 3  | 20       | ####################
3-avg     | 20       | ==================== (reference line)
```

---

## Agent Performance

| Agent | Role | Tasks Completed | Points Delivered | Avg Completion Time | Success Rate | Notes |
|-------|------|-----------------|------------------|---------------------|--------------|-------|
| *Example: VP Engineering* | *Engineering* | *8* | *12* | *2.1 hrs/task* | *95%* | *Handles architecture + code review* |
| | | | | | | |
| | | | | | | |
| | | | | | | |

### Tool Split per Agent

| Agent | Claude Code Tasks | Claude Code Time | Codex Tasks | Codex Time | Manual Tasks | Manual Time |
|-------|-------------------|------------------|-------------|------------|--------------|-------------|
| | | | | | | |
| | | | | | | |

---

## Codex vs Claude Code Summary

| Tool | Total Tasks (All Time) | Total Points | Total Hours | Avg Points/Task | Best For |
|------|------------------------|--------------|-------------|-----------------|----------|
| Claude Code | | | | | Complex multi-file, architecture, debugging |
| Codex | | | | | Bounded single-file, repetitive, parallelizable |
| Manual / Other | | | | | Decisions, reviews, stakeholder comms |

---

## Adjustment Factors (Reference)

> Apply these when planning sprint capacity. Multiply baseline velocity by the factor.

| Factor | Impact | When to Apply | Source |
|--------|--------|---------------|--------|
| Ramadan | -35% velocity | During Ramadan month | Observed 2025-2026 data |
| Eid al-Fitr week | 0 velocity (skip) | 3-5 day window around Eid | Hard stop |
| Eid al-Adha week | 0 velocity (skip) | 3-5 day window around Eid | Hard stop |
| Summer (Jul-Aug) | -20% velocity | July 1 - August 31 | Reduced availability, travel |
| New project onboarding | -25% first sprint | First sprint of any new project | Ramp-up cost |
| Team member added | -15% that sprint | Sprint when new agent/member joins | Integration overhead |
| Team member removed | -10% that sprint | Sprint when agent/member leaves | Knowledge transfer |
| Holiday (UAE national) | -50% that week | UAE National Day, other public holidays | Reduced working days |
| Major release prep | -20% velocity | Sprint before a major launch | Testing and stabilization overhead |

### Calculating Adjusted Capacity

```
Adjusted Velocity = Rolling 3-Sprint Avg x (1 - sum of active adjustment percentages)

Example:
  Rolling avg = 20 pts
  Active: Ramadan (-35%)
  Adjusted = 20 x (1 - 0.35) = 13 pts
```

---

## Sprint-over-Sprint Comparison

| Metric | Previous Sprint | Current Sprint | Delta | Trend |
|--------|----------------|----------------|-------|-------|
| Planned points | | | | |
| Completed points | | | | |
| Velocity | | | | |
| Carry-over items | | | | |
| Agent utilization % | | | | |
| Codex % of work | | | | |

---

## Prediction Log

> Track prediction accuracy to improve future estimates.

| Sprint | Predicted Velocity | Actual Velocity | Accuracy % | Miss Reason |
|--------|-------------------|-----------------|------------|-------------|
| | | | | |
| | | | | |

---

## Rules

1. **Update at sprint close.** Do not update mid-sprint except for the current sprint status.
2. **Carry-over items** count toward the sprint they were completed in, not the sprint they were planned in.
3. **Velocity = completed points only.** Partial completion = 0 points for velocity calculation.
4. **Rolling average uses last 3 completed sprints.** Skip any sprint marked as "anomaly" (e.g., Eid week).
5. **Agent performance** is for capacity planning, not performance review. No ranking or comparison.
6. **Prediction accuracy** below 70% for 2 consecutive sprints triggers a recalibration session.
