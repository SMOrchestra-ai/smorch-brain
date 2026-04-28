# Sales Navigator Operator - Learnings Log

## Purpose
Self-learning capture file. Every session should leave a trace here so future sessions start smarter. Read this file FIRST before any Sales Nav operation to avoid repeating mistakes and to apply discovered optimizations.

## Format
```
### [YYYY-MM-DD] - [Session Type]
**Objective**: what we tried
**Discovery**: what we learned
**Action**: what to do differently next time
**Category**: search | signal | navigation | mena | boolean | ui_change | error
```

---

## Log Entries

### 2026-02-27 - Initial Setup
**Objective**: Created smorch-salesnav-operator skill from deep research synthesis
**Discovery**: Skill architecture designed with 6 modes (A-F), MENA-specific playbook, Core plan constraints mapped. Key insight: Core plan lacks Buyer Intent signals, so monitoring stacks using saved searches + alerts are the primary signal source. No CSV export means all extraction is manual or via enrichment tool bridging.
**Action**: All future sessions should check Core plan constraints before suggesting features. Always offer Core-compatible workarounds before mentioning upgrade.
**Category**: setup

### 2026-02-27 - MENA Timing Note
**Objective**: Document Ramadan 2026 timing
**Discovery**: Ramadan 2026 starts approximately Feb 28 and ends approximately Mar 30. This means starting RIGHT NOW, outreach should be at 50% volume, evening timing (post-Iftar, 7-10pm GST), no aggressive CTAs. Post-Eid first week of April is historically highest deal velocity.
**Action**: Any campaigns built during Feb 28 - Mar 30 2026 must be flagged for Ramadan pacing. Resume full volume first week of April.
**Category**: mena

---

## Pattern Library (Updated as patterns emerge)

### Boolean Patterns That Work in MENA
- Pending: will populate after first live search sessions

### Title Variants Discovered
- Pending: will populate as we discover new role/title mappings

### Geography Corrections
- Pending: will track expat drift and geo mismatches

### False Positive Patterns
- Pending: will track recurring false positives to build exclusion lists

### UI Changes Detected
- Pending: LinkedIn updates Sales Nav UI frequently, track changes here

---

## Metrics Tracking (Weekly)

| Week | Alerts Processed | P1 Signals | P2 Signals | Sequences Launched | Meetings Booked |
|------|-----------------|------------|------------|-------------------|-----------------|
| (pending first live sessions) | | | | | |
