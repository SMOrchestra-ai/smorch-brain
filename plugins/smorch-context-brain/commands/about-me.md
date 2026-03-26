---
description: Build or update your personal About Me context files
argument-hint: '[mode: build, update, gap-fill, or parse]'
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, AskUserQuestion
---

Launch the smorch-about-me skill to create or update personal context files.

If $1 is provided, use it as the mode:
- build: Start from scratch with interactive Q&A
- update: Update existing About Me files with new info
- gap-fill: Find and fill gaps in existing files
- parse: Extract from uploaded LinkedIn/CV file

If no argument, ask which mode using AskUserQuestion.
