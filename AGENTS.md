# AGENTS.md

## Overview
This repository (`smorch-brain`) uses AI coding agents (Claude Code via OpenClaw) for automated development tasks.
SMOrchestra Skills Registry -- Claude Code skills, machine profiles, MCP configs. Central catalog for the AI-native architecture.

Organization: SMOrchestra-ai | Admin: smorchestraai-code

## Code Style
- Language: Python
- Formatting: Black + isort (Python), Prettier for non-Python files
- Commits: Conventional commits -- type(scope): description
- Types: feat, fix, refactor, test, docs, chore, agent, hotfix

## Agent Behavior Rules

### Scope
- Agents work ONLY on files declared in their task spec
- Any diff outside declared scope triggers high-risk review
- Agents do NOT modify: infra/, auth/, billing/, security/ without explicit approval

### Branches
- Agent branches: agent/TASK-XXX-slug (created by OpenClaw)
- Human branches: human/[name]/TASK-XXX-slug
- NEVER push directly to dev or main
- All work merges via PR

### Commits
- Format: agent(TASK-XXX): description of change
- Every commit lists modified files

### Review Requirements
- All agent PRs labelled: agent-generated
- High risk (>200 lines, out-of-scope): Mamoun reviews
- Medium risk (in-scope, <200 lines): any senior reviewer
- Low risk (tests, docs): async review

## Prohibited Actions
- Agents MUST NOT create or delete repositories
- Agents MUST NOT modify CI/CD configuration without approval
- Agents MUST NOT change environment variables or secrets
- Agents MUST NOT push directly to main or dev branches
