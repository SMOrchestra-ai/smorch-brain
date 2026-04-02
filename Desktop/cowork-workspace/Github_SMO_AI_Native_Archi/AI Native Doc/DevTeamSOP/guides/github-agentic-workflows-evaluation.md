# GitHub Agentic Workflows — Evaluation Report

**Date:** 2026-03-23
**For:** Mamoun Alamouri / SMOrchestra.ai
**Evaluated by:** Claude Code research agent (16 web searches, 20+ sources)

---

## 1. What Are GitHub Agentic Workflows?

Two distinct things exist under the "agentic" umbrella:

### A. GitHub Agentic Workflows (gh-aw)
An open-source framework (MIT license) that lets you write automation instructions in **Markdown** instead of YAML. Files go in `.github/workflows/`. The `gh aw compile` CLI converts them into standard GitHub Actions `.lock.yml` files. At runtime, a coding agent (Copilot CLI, Claude, or Codex) executes the natural-language instructions inside a GitHub Actions runner.

**How it works:**
1. Write a Markdown file with YAML frontmatter (triggers, permissions, safe-outputs, tools)
2. `gh aw compile` generates `.github/workflows/<name>.lock.yml`
3. On trigger (issue opened, PR created, schedule), Actions spins up a runner
4. The runner loads the agent and feeds it the Markdown instructions + repo context
5. Agent runs **read-only by default** — write ops happen through declared **safe-outputs** only
6. PRs are **never auto-merged** — human must review

### B. Copilot Coding Agent
Assign a GitHub issue to Copilot. It spins up an Actions environment, writes code, runs tests, self-reviews, runs security scanning, and opens a PR. Custom agents defined via `.github/agents/*.md`.

**The relationship:** gh-aw = continuous event-driven automation. Copilot Coding Agent = task-specific code generation. They coexist without conflict.

---

## 2. Current Status (March 2026)

| Feature | Status |
|---------|--------|
| GitHub Agentic Workflows (gh-aw) | **Tech Preview** — not GA, may change significantly |
| Copilot Coding Agent | **GA** for paid Copilot subscribers |
| Copilot CLI (agentic terminal) | **GA** since March 2, 2026 |
| Custom Agents (.github/agents/) | **GA** in VS Code and JetBrains |
| Copilot Code Review (agentic) | **GA** since March 5, 2026 |

---

## 3. How You Define Them

### Agentic Workflows (gh-aw): Markdown with YAML Frontmatter

```markdown
---
name: triage-issues
on:
  issues:
    types: [opened]
permissions:
  issues: read
  contents: read
safe-outputs:
  - type: add-label
    limit: 3
  - type: add-comment
    limit: 1
tools:
  - github-issues
  - github-search
agent: copilot-cli
---

# Issue Triage Agent

You are an issue triage agent for a Next.js SaaS application.

## When a new issue arrives:
1. Read the issue title and body
2. Check if it's a bug report, feature request, or question
3. Apply the appropriate label
4. Add a comment summarizing your analysis
```

### Custom Agents (Copilot): `.github/agents/*.md`

```markdown
---
name: perf-optimizer
description: Optimizes performance-critical code paths
tools:
  - terminal
  - file-editor
---

# Performance Optimizer Agent

Before making any change:
1. Run the existing benchmark suite
2. Record baseline metrics
3. Make the optimization
4. Re-run benchmarks
5. Only open a PR if performance improves by > 5%
```

---

## 4. What Can They Do?

**gh-aw use cases:**
- Issue triage (auto-label, categorize, assign)
- PR review assistance (analyze diffs, flag issues)
- CI failure analysis (read logs, suggest fixes)
- Self-healing CI (detect failure, create fix PR)
- Documentation generation
- Daily/weekly status reports
- Stale issue cleanup
- Dependency update analysis

**Copilot Coding Agent use cases:**
- Fix bugs from issue descriptions
- Add test coverage
- Clean up tech debt
- Implement features from specs
- Refactor code
- Address code review comments

---

## 5. gh-aw vs Traditional GitHub Actions

| Dimension | Traditional Actions | Agentic Workflows |
|-----------|-------------------|------------------|
| Definition | YAML | Markdown + YAML frontmatter |
| Logic | Deterministic steps | LLM-driven decisions |
| Reproducibility | Fully deterministic | **Non-deterministic** |
| Security | Token-based | Read-only agent + safe-outputs separation |
| Build/deploy | Core use case | **Not recommended** |
| Triage/review | Requires complex scripting | Natural fit |
| Cost | Compute only | Compute + LLM tokens |
| Maturity | 6+ years | 5 weeks old |

**Critical:** gh-aw runs ON TOP of Actions, not instead of. CI/CD stays as deterministic YAML. gh-aw handles fuzzy, judgment-based tasks.

---

## 6. Pricing

- **gh-aw framework:** Free, open source (MIT)
- **Compute:** Standard GitHub Actions pricing
- **LLM tokens:** Depends on agent (Copilot included with subscription, Claude/Codex at their rates)
- **Copilot Coding Agent:** Requires Copilot Pro+ ($39/month) or Enterprise
- **Estimated monthly for daily triage + weekly reports:** $20-50/month on top of existing plan

---

## 7. Limitations and Gotchas

1. **Non-deterministic** — same workflow, different results. Do NOT use for builds.
2. **Tech preview** — format, CLI, API may all change. No backward compatibility.
3. **Read-only by default** — writes limited to declared safe-outputs.
4. **Agent quality varies** — misunderstands, loops, incorrect decisions. Expect iteration.
5. **Prompt injection risk** — malicious issue/PR content can manipulate agent on public repos.
6. **No auto-merge** — PRs always need human approval.
7. **Token costs spike** — complex analysis on large repos burns through tokens.
8. **No external tool integration** — no native n8n, Linear, etc. bridge.
9. **Debug is hard** — debugging prompts, not code.
10. **Repository noise** — agents creating issues/comments/PRs can overwhelm notifications.

---

## 8. How It Fits Our AI-Native Architecture

### What overlaps with our stack:

| Our Layer | GitHub Equivalent | Verdict |
|-----------|------------------|---------|
| OpenClaw queue + conflict detection | Copilot Coding Agent (issue assignment) | **Keep OpenClaw** — Copilot has no file-level conflict detection, no concurrency cap |
| Claude Code (isolated, spec-pinned) | Copilot Coding Agent (runs in Actions) | **Keep Claude Code** — more control (session TTL, spec injection, commit cadence) |
| Self-fix loop (agent reads CI, retries) | gh-aw self-healing CI | **Keep ours** — more tightly integrated, more predictable |
| Risk-tiered PR review | Copilot Code Review | **Complementary** — Copilot as first-pass, our tiers for human routing |

### What gh-aw adds that we DON'T have:

1. **Event-driven issue triage** — auto-label, categorize before entering pipeline
2. **PR enrichment** — agent adds context (related issues, coverage delta) to every PR
3. **Scheduled repo health** — automated weekly reports
4. **Copilot Code Review as first-pass** — catches low-hanging issues before human review

### Recommended integration:

```
Layer 0 (NEW): gh-aw event handlers
  - Issue triage agent
  - PR enrichment agent
  - Scheduled health check

Layer 1-5: UNCHANGED (Intent → Orchestration → Execution → Validation → Human Gate)

Layer 5 ENHANCED: Copilot Code Review as pre-filter before risk-tiered human review
```

---

## 9. Recommendation for SMOrchestra

### Adopt NOW (low risk, immediate value):
| Feature | Why | Action |
|---------|-----|--------|
| Copilot Code Review | GA, reduces review burden | Enable on SaaSFast + eo-assessment-system |
| Custom agents (.github/agents/) | GA, define specialized profiles | Create doc-writer and test-coverage agents |
| AGENTS.md | Already standard | ✅ Done — all 7 repos |

### Experiment (medium risk):
| Feature | Why | Action |
|---------|-----|--------|
| gh-aw issue triage | Low stakes, one repo test | Try on eo-assessment-system |
| gh-aw weekly health reports | Low stakes | Try on smorch-brain |

### Wait (high risk):
| Feature | Why |
|---------|-----|
| gh-aw self-healing CI | Our OpenClaw self-fix loop is better and more controlled |
| Replacing any OpenClaw function | gh-aw has no task queue, no conflict detection, no concurrency |
| gh-aw for write-heavy automation | Non-deterministic, tech preview |

### The strategic view:

> GitHub is building toward an agent-native developer lifecycle. The trajectory: IDE copilot (done) → async coding agent (done) → continuous repo automation (in progress) → full lifecycle manager (2027).
>
> **Your OpenClaw + Claude Code pipeline is more sophisticated than what GitHub offers today.** Keep it as the core. Cherry-pick the peripheral features (code review, triage, custom agents) that reduce your workload. When gh-aw reaches GA, re-evaluate.

---

## 10. Sources

- [GitHub Agentic Workflows Tech Preview (Feb 13, 2026)](https://github.blog/changelog/2026-02-13-github-agentic-workflows-are-now-in-technical-preview/)
- [gh-aw Official Docs](https://github.github.com/gh-aw/)
- [Automate Repo Tasks with gh-aw (GitHub Blog)](https://github.blog/ai-and-ml/automate-repository-tasks-with-github-agentic-workflows/)
- [What's New with Copilot Coding Agent (GitHub Blog)](https://github.blog/ai-and-ml/github-copilot/whats-new-with-github-copilot-coding-agent/)
- [Copilot Code Review Agentic Architecture (March 5, 2026)](https://github.blog/changelog/2026-03-05-copilot-code-review-now-runs-on-an-agentic-architecture/)
- [About Custom Agents (GitHub Docs)](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-custom-agents)
- [Self-Healing CI Using gh-aw (Tiago Pascoal)](https://pascoal.net/2026/03/12/self-healing-ci-using-gh-aw/)
- [GitHub Agentic Workflows (Hacker News)](https://news.ycombinator.com/item?id=46934107)
- [gh-aw Repository (MIT License)](https://github.com/github/gh-aw)
