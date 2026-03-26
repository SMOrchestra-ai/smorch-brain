---
description: Create or update a project brain from raw inputs
argument-hint: '[project-name or update]'
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, WebFetch, WebSearch, AskUserQuestion
---

Launch the smorch-project-brain skill to create or refresh project context files.

If $1 is a project name, create a new project brain directory and populate it.
If $1 is "update", scan existing brain files and refresh with new context.
If no argument, ask the user which project using AskUserQuestion.
