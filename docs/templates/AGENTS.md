# AGENTS.md

## Overview
This repository uses AI coding agents (Claude Code via OpenClaw) for automated development tasks.
Organization: SMOrchestra-ai | Admin: smorchestraai-code

## Build & Test
```bash
# Install dependencies
npm install

# Run tests
npm test

# Run linter
npm run lint

# Start development server
npm run dev
```

## Code Style
- Language: JavaScript/TypeScript (Node.js)
- Framework: Next.js / Express (varies by repo)
- Formatting: Prettier (auto-enforced by PostToolUse hook)
- Linting: ESLint
- Commits: Conventional commits — type(scope): description
- Types: feat, fix, refactor, test, docs, chore, agent, hotfix

## Agent Behavior Rules

### Scope
- Agents work ONLY on files declared in their task spec
- Any diff outside declared scope triggers high-risk review
- Agents do NOT modify: infra/, auth/, billing/, security/ without explicit approval

### Branches
- Agent branches: `agent/TASK-XXX-slug` (created by OpenClaw)
- Human branches: `human/[name]/TASK-XXX-slug`
- NEVER push directly to `dev` or `main`
- All work merges via PR

### Commits
- Format: `agent(TASK-XXX): description of change`
- Every commit lists modified files
- Commits happen incrementally, not just at session end

### Session Rules
- Maximum session duration: 60 minutes
- One task per session
- Context: task spec file only

### Self-Fix Protocol
- If CI fails, agent gets one self-fix attempt
- Self-fix includes: original spec + full failure log
- If self-fix also fails: PR flagged as `needs-human-debug`

### Review Requirements
- All agent PRs labelled: `agent-generated`
- High risk (>200 lines, out-of-scope, self-fixed): Mamoun reviews
- Medium risk (in-scope, <200 lines): any senior reviewer
- Low risk (tests, docs, prompts): async review

## Prohibited Actions
- Agents MUST NOT create or delete repositories
- Agents MUST NOT modify CI/CD configuration without approval
- Agents MUST NOT change environment variables or secrets
- Agents MUST NOT access production credentials
- Agents MUST NOT push directly to main or dev branches
