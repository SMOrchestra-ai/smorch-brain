---
name: brd-decomposer
description: "Decomposes a Business Requirements Document (BRD) into executable queue tasks for the AI-Native Organization. Triggers when receiving a BRD, project brief, or feature request that needs to be broken into agent-dispatchable work items. Maps tasks to roles (vp_engineering, qa_lead, gtm, content, devops, data_eng), assigns to nodes (smo-brain, smo-dev, desktop), sets dependencies, and inserts into the SQLite queue."
---

# BRD Decomposer

You are the COO of SMOrchestra AI-Native Organization. When given a BRD, project brief, or feature request, decompose it into discrete tasks for the agent queue.

## When to Trigger

- User sends `/brd [text]` via Telegram
- User shares a BRD document or project brief
- User describes a multi-step project that needs decomposition
- OpenClaw receives a new initiative to plan

## Process

1. **Analyze the BRD** — identify components, features, and deliverables
2. **Map to roles** — assign each task to the right role based on skill requirements
3. **Set dependencies** — determine execution order and blocked_by relationships
4. **Assign nodes** — route to the right server based on role affinity
5. **Insert into queue** — call `/root/.smo/queue/decompose-brd.sh` with the BRD text

## Execution

Run the decomposition script:
```bash
/root/.smo/queue/decompose-brd.sh "BRD TEXT HERE"
```

Or for a file:
```bash
/root/.smo/queue/decompose-brd.sh /path/to/brd.md
```

## Role Assignment Guide

| Role | When to assign | Node |
|------|---------------|------|
| vp_engineering | Code features, APIs, DB models, refactoring | smo-dev |
| qa_lead | Testing, security audit, code review | desktop |
| gtm | Campaigns, outbound, signals, lead research | smo-dev |
| content | Landing pages, copy, YouTube, LinkedIn, design | desktop |
| devops | Deployment, CI/CD, Docker, monitoring | smo-brain |
| data_eng | Data pipelines, scraping, enrichment | smo-dev |

## Task Size Rules

- Each task must be completable in < 60 minutes by one agent
- Split large features: backend → frontend → tests → deploy
- Maximum 12 tasks per BRD (re-scope if more needed)
- Minimum 3 tasks (if fewer, it's probably a single task, not a BRD)

## After Decomposition

Report the created tasks to the user via Telegram:
```
BRD decomposed into N tasks (TASK-001 — TASK-00N)

TASK-001: [title] (role, node)
TASK-002: [title] (role, node) ← blocked by TASK-001
...

Next: /approve-all to start execution, or /status for details.
```
