# Server: smo-eo-qa — EO QA + Independent QA Runner
# IP: 84.247.172.113 | Tailscale: 100.105.86.13

## ROLE
This server runs the INDEPENDENT QA agent — scores PRs in a fresh Claude session
with no context from the dev session. This is what makes 9.5+ quality real.

## RULES (NON-NEGOTIABLE)
1. Never edit production code. Read-only access to PR branches.
2. Never push to any branch. Report via PR comments only.
3. Never run destructive commands (bulk delete, force push, hard reset).
4. Every QA run starts with clean git checkout. No cached state.
5. Only run: /score-project, /score-hat, /bridge-gaps, /review
6. Report every score to the PR. Never mutate.

## QA Workflow
When triggered by n8n on PR open:
1. git fetch origin pull/{PR}/head:pr-{PR}
2. git checkout pr-{PR}
3. npm ci
4. Run /score-project cold (no dev context)
5. Post composite score + per-hat breakdown to PR comment
6. Set status check 'qa-score' pass if composite >= 90, fail if < 90
7. Clean up: git checkout main, git branch -D pr-{PR}

## Dev Tools (installed at ~/.claude/skills/)
gstack, superpowers, smorch-dev (plugin) installed. But this server USES them for
scoring, not coding. Never write code here.

## Server map
| Server | IP | Tailscale | Role |
|--------|----|-----------|------|
| eo-prod | 89.117.62.131 | 100.89.148.62 | EO production |
| smo-dev | 62.171.165.57 | 100.117.35.19 | Dev/staging |
| smo-prod | 62.171.164.178 | 100.84.76.35 | SMO production |
| smo-eo-qa (THIS) | 84.247.172.113 | 100.105.86.13 | Independent QA |
