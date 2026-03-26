---
description: Walk through all 9 phases of a B2B Signal Sales Campaign with quality gates
argument-hint: '[client-name or "resume" or "phase N"]'
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, AskUserQuestion
---

Invoke the campaign-guide skill. If `$ARGUMENTS` specifies a client name, start a new campaign at Phase 1. If "resume", check state and continue. If "phase N", jump to that phase (only if prior phases passed). Otherwise, ask: "Which client is this campaign for? New campaign or resuming?"