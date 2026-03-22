# AGENTS.md

## Overview
This repository uses AI agents (Claude Code via OpenClaw) for automated development tasks.

## Agent Behavior Rules

### Scope
- Agents work ONLY on files declared in their task spec
- Any diff outside declared scope triggers high-risk review
- Agents do NOT modify: infra/, auth/, billing/, security/

### Branches
- Agents create branches as: agent/TASK-XXX-slug
- Agents NEVER commit to human/* branches
- Agents NEVER push to dev or main directly

### Commits
- Format: agent(TASK-XXX): description of change
- Every commit lists modified files
- Commits happen incrementally, not just at session end

### Session Rules
- Maximum session duration: 60 minutes
- One task per session
- Context: task spec file only

### Self-Fix Protocol
- If CI fails, agent gets one self-fix attempt
- Self-fix includes: original spec + full failure log
- If self-fix fails: PR flagged as needs-human-debug

### Review Requirements
- All agent PRs labelled: agent-generated
- High risk (>200 lines, out-of-scope, self-fixed): owner reviews
- Medium risk (in-scope, <200 lines): any senior reviewer
- Low risk (tests, docs, prompts): async review

## Prohibited Actions
- Agents MUST NOT create new repos
- Agents MUST NOT modify CI/CD configuration
- Agents MUST NOT change environment variables
- Agents MUST NOT access production credentials
