# AI-Native Architecture Deep Audit — Findings & Execution Plan

**Date:** 2026-03-23
**Version:** 1.0
**Audit by:** Claude Code (3 parallel research agents)
**Scope:** Claude Code configuration, GitHub setup, skills, hooks, agents, SOPs, industry benchmarks

---

## 1. Executive Summary

Three parallel research agents audited the SMOrchestra AI-native architecture against: (1) current Claude Code best practices, (2) GitHub AI-native industry standards as of March 2026, and (3) an internal self-audit of what's actually on disk vs what's documented.

**Bottom line:** The conceptual architecture is ahead of industry. The enforcement layer has critical gaps. Several connected tools (MCP servers) are not being leveraged. Some documented features are theater — they look good but nothing enforces them.

**Current state:** Strong foundation with holes
**After this plan:** Production-hardened, self-enforcing, industry-leading

---

## 2. What's Genuinely Strong (Keep)

| Area | Why It's Strong |
|------|----------------|
| **Five-layer architecture** (Intent → Orchestration → Execution → Validation → Human Gate) | Matches what OpenAI published as "Harness Engineering" (Feb 2026). You had it before they documented it. |
| **Branch namespace separation** (`human/` vs `agent/`) | Now industry standard. Your v2 plan predates the consensus. |
| **Risk-tiered PR review** | Being adopted by enterprise teams globally. Your HIGH/MEDIUM/LOW tier matches best practice exactly. |
| **Self-fix loop** (agent reads CI failure, one retry) | Matches the "Level 3 Healer" pattern in self-healing CI research. |
| **Skills distribution system** (smorch CLI + profiles) | Unique in the industry. Nobody else has on-demand skill selection per machine with profile-based sync. |
| **Destructive command hook** | Blocks rm -rf, force push, hard reset, table drops. Well-designed, tested. |
| **PostCompact context restorer** | Re-injects branch, directory, and Required Skills reminder. Documented best practice. |
| **Conditional rules** (infra-guard, auth-security, database-guard) | Exactly what Anthropic recommends for domain-specific enforcement. |

---

## 3. What's Theater (Documented But Not Enforced)

These items appear in our documentation, skills, or SOPs but have **no automation backing them**. They rely entirely on Claude "remembering" — which fails after compaction or in fresh sessions.

| Item | Where Documented | Reality |
|------|-----------------|---------|
| **Session-start checks** (branch audit, stale detection, hook install) | smorch-github-ops skill, CLAUDE.md | No SessionStart hook. Claude only does this if it reads the skill AND remembers. |
| **Branch TTL: 48-hour enforcement** | CLAUDE.md, reference guide | No cron job, no scheduled task. Purely aspirational. |
| **Agent PRs get `agent-generated` label** | Reference guide, smorch-github-ops skill | The pr-creator agent doesn't add this label. |
| **CHANGELOG enforcement on merge** | smorch-github-ops skill | No CI check, no hook. Honor system. |
| **Scope checking for agent PRs** | Reference guide (Section 13 CI job) | No repo has this CI workflow. |
| **`docs/templates/` in smorch-brain** | Reference guide Appendix B | **Directory doesn't exist.** |
| **"Don't add disclaimers about AI limitations"** | CLAUDE.md | Claude Code doesn't do this by default. Wasted instruction. |
| **"Don't generate filler content"** | CLAUDE.md | Already default behavior. Wasted instruction. |
| **"Daily audit at 8am"** | Discussed in session | May not be persisted — needs verification. |

**Impact:** When a team member or server Claude Code starts a fresh session, none of these "rules" are active. The architecture appears complete but has enforcement holes a truck could drive through.

---

## 4. What's Actually Dangerous

### 4.1 Branch Protection Bypass in `smorch push`

**Risk: CRITICAL**

Lines 303-309 of `~/smorch-brain/scripts/smorch` temporarily set required reviews to 0, force-merge, then set back to 1. This defeats the entire purpose of branch protection.

```bash
# DANGEROUS: Temporarily removes branch protection
gh api -X PATCH repos/SMOrchestra-ai/smorch-brain/branches/main/protection/required_pull_request_reviews \
  -f required_approving_review_count=0
# ... force merge ...
gh api -X PATCH repos/SMOrchestra-ai/smorch-brain/branches/main/protection/required_pull_request_reviews \
  -f required_approving_review_count=1
```

**Why this exists:** smorch push needs to merge skills to main without a PR review. But the implementation creates a window where ANYONE can push to main unreviewed.

**Fix:** Use a GitHub App token with bypass permissions, OR push directly to dev (not main) and let the normal release flow promote to main.

### 4.2 Supabase MCP Has Zero SQL Protection

**Risk: CRITICAL**

The destructive command hook blocks `DROP TABLE` in bash commands. But the Supabase MCP (`mcp__cb73f37d__execute_sql`) accepts raw SQL with no validation. You could execute:

```sql
DROP TABLE users CASCADE;
TRUNCATE payments;
DELETE FROM assessments WHERE 1=1;
```

And nothing would stop it. The database-guard rule only triggers when editing `.sql` FILES, not when running SQL through the MCP tool.

**Fix:** Add a PreToolUse hook on `mcp__cb73f37d__execute_sql` that blocks DDL statements.

### 4.3 No Secret Detection

**Risk: HIGH**

No hook scans for API keys, tokens, passwords, or `.env` file contents in code before commit. One accidental commit = leaked credentials on GitHub.

**Fix:** Add a PreToolUse hook on Write/Edit that scans for common secret patterns (API_KEY=, Bearer, sk-, password=).

### 4.4 MCP Server Attack Surface

**Risk: HIGH**

You have 15+ MCP servers connected. As of March 2026, 655 malicious MCP "skills" have been cataloged. No allowlisting is configured. A compromised MCP server could exfiltrate data.

**Fix:** Configure `allowedMcpServers` in settings to whitelist only the MCPs you actively use.

---

## 5. Industry Capabilities We're Missing

### 5.1 AGENTS.md — The Cross-Tool Standard

**What it is:** A Markdown file in repo root that declares AI agent behavior rules. Unlike CLAUDE.md (Claude-only), AGENTS.md works with 25+ tools: Claude Code, Cursor, Copilot, Codex, Google Jules, Gemini CLI, Aider, and more.

**Status:** 60,000+ repos. Under Linux Foundation governance. OpenAI maintains 88 AGENTS.md files internally.

**Why we need it:** If any team member uses Cursor, Copilot, or any other AI tool, they get zero guidance from CLAUDE.md. AGENTS.md provides a universal standard.

**Action:** Add AGENTS.md to all 7 active repos. Extract the cross-tool subset from our CLAUDE.md files.

### 5.2 SessionStart Hook

**What it is:** A hook that fires at the beginning of every Claude Code session. Can set environment variables, load context, verify state.

**Why we need it:** Currently, session-start checks (branch audit, hook installation, stale branch detection) are aspirational — they only happen if Claude reads the skill. A SessionStart hook makes them deterministic.

**Action:** Create a SessionStart hook that: verifies git hooks installed, checks branch conventions, loads environment vars.

### 5.3 Subagent Persistent Memory

**What it is:** Subagents can have persistent memory at `~/.claude/agent-memory/<name>/`. The subagent reads/writes a MEMORY.md that accumulates learnings across sessions.

**Why we need it:** Our code-reviewer agent starts fresh every time. With persistent memory, it remembers codebase patterns, recurring issues, and architectural decisions — getting better over time.

**Action:** Add `memory: project` scope to code-reviewer and test-runner agents.

### 5.4 GitHub Agentic Workflows (Feb 2026)

**What it is:** Native GitHub feature. Write automation goals in Markdown, GitHub compiles to Actions YAML. Agents run in sandboxed containers.

**Use cases:** Self-healing CI (auto-fix broken builds), continuous documentation, automated triage.

**Action:** Evaluate for our repos. Could replace custom scripts for doc sync and CI repair.

### 5.5 Claude Code Review (March 2026)

**What it is:** Multi-agent PR review system. Multiple specialized agents analyze code simultaneously (logic, security, conventions). Comments posted directly on PRs.

**Cost:** ~$15-25 per review. Teams/Enterprise only.

**Action:** Evaluate for our high-risk PRs (infra, auth, >200 lines).

### 5.6 Tool Input Modification Hooks (v2.0.10+)

**What it is:** PreToolUse hooks can now MODIFY tool inputs before execution — not just allow/deny.

**Why we need it:** Could auto-format commit messages to match conventional commits standard, add dry-run flags to dangerous commands, enforce branch naming at push time.

**Action:** Implement for git commit and git push.

---

## 6. Unused MCP Servers (Already Connected, Not Leveraged)

| MCP Server | Connected | Used by Any Skill | Action |
|-----------|-----------|-------------------|--------|
| **Supabase** (`cb73f37d`) | YES | None — used ad-hoc only | Build `supabase-admin` skill |
| **Contabo** | YES | None | Build `contabo-ops` skill |
| **SSH Manager** | YES | None directly | Integrate with `eo-deploy-infra` |
| **Claude Preview** (browser) | YES | None | Integrate with `webapp-testing` |
| **Resend** (email) | YES | None | Integrate with `instantly-operator` or build notifications |
| **Figma** | YES | None | Integrate with `frontend-design` |
| **PDF Filler** | YES | None | Could automate client proposal PDFs |

**Cost implication:** These MCP servers consume context tokens (tool descriptions loaded into every session). If unused, they're pure waste. Either use them or remove them from the config.

---

## 7. Skill Gaps

### Missing Skills

| Skill | Category | Why Needed |
|-------|----------|-----------|
| **supabase-admin** | tools | Heavy DB work, MCP connected but no skill to guide operations |
| **contabo-deployment** | tools | Entire infra is Contabo + nginx + pm2, no automation skill |
| **arabic-localizer** | content | Core market differentiator, no dedicated localization skill |
| **client-onboarding** | new category | Agency business with no client management workflow |
| **incident-response** | dev-meta | No rollback, no recovery, no postmortem skill |
| **deployment-checklist** | dev-meta | Manual deploys with no pre/post checks |

### Potentially Redundant Skills

| Skills | Issue |
|--------|-------|
| `eo-gtm-asset-factory` + `eo-gtm-asset-builder` | Names suggest overlap. Audit for consolidation. |
| `smo-skill-creator` + Anthropic `skill-creator` | Both create skills. SMO version has custom naming rules. Keep SMO, deprecate if Anthropic version is sufficient. |
| `asset-factory` (GTM) + `smo-offer-assets` (content) | Potential overlap in asset generation. |
| `changelog-generator` + `smorch-github-ops` changelog section | Ops skill already handles changelog. Generator may be redundant. |

---

## 8. Hook Gaps

### Current Hooks (3)

| Hook | Type | Status |
|------|------|--------|
| Destructive command blocker | PreToolUse/Bash | WORKING |
| Auto-formatter (Prettier) | PostToolUse/Write\|Edit | WORKING |
| Compaction context restorer | PostCompact | WORKING |

### Hooks That Should Exist

| Hook | Type | What It Does | Risk Without It |
|------|------|-------------|----------------|
| **Supabase SQL guard** | PreToolUse/execute_sql | Blocks DDL (DROP, TRUNCATE, ALTER DROP) through MCP | Production data loss |
| **Secret scanner** | PreToolUse/Write\|Edit | Scans for API keys, tokens, passwords | Credential leak on push |
| **Commit format enforcer** | PreToolUse/Bash(git commit) | Validates conventional commit format | Inconsistent history |
| **Branch name validator** | PreToolUse/Bash(git push) | Ensures branch follows naming convention | Branch pollution |
| **Session bootstrap** | SessionStart | Verifies hooks, loads env, checks branch state | Uninitialized sessions |
| **MCP allowlist** | Settings | Whitelist approved MCP servers | Supply chain attack |

---

## 9. Execution Plan

### Phase 1: Critical Fixes (30 min)

| # | Action | What It Does |
|---|--------|-------------|
| FIX-1 | Remove branch protection bypass from `smorch push` | Eliminates the backdoor that lets anyone push to main unreviewed. Changes push flow to go through dev → PR → main. |
| FIX-2 | Add Supabase SQL protection hook | Blocks DDL statements (DROP, TRUNCATE, ALTER DROP, DELETE without WHERE) through the Supabase MCP. Prevents accidental or malicious data destruction. |
| FIX-3 | Add secret detection hook | Scans every file Write/Edit for patterns: `API_KEY=`, `Bearer `, `sk-`, `password=`, `.env` content. Blocks the write and warns. |
| FIX-4 | Create `docs/templates/` in smorch-brain | Makes the reference guide truthful. Adds actual templates for: AGENTS.md, CHANGELOG.md, PR template, issue templates, README. |

### Phase 2: Enforcement Layer (1 hour)

| # | Action | What It Does |
|---|--------|-------------|
| BUILD-5 | Add AGENTS.md to all 7 active repos | Cross-tool standard. Works with Claude Code, Cursor, Copilot, Codex, 25+ tools. Declares build commands, code style, commit conventions, agent boundaries. |
| BUILD-6 | Create SessionStart hook | Fires at every session start. Verifies git hooks installed, checks branch naming, loads env vars, reminds about Required Skills. Makes session-start checks deterministic instead of aspirational. |
| BUILD-7 | Add persistent memory to agents | Code-reviewer and test-runner agents accumulate learnings across sessions. Remembers codebase patterns, recurring issues, architectural decisions. Gets smarter over time. |
| ENFORCE-10 | Add commit format hook | PreToolUse on `git commit` validates conventional commit format before the commit runs. Universal — works regardless of per-repo git hook installation. |
| ENFORCE-11 | Add branch validation hook | PreToolUse on `git push` ensures branch follows naming convention (human/, agent/, feature/, hotfix/, sandbox/). |

### Phase 3: Skills & Agents (1.5 hours)

| # | Action | What It Does |
|---|--------|-------------|
| BUILD-8 | Build Supabase admin skill | Leverages the MCP you're already paying for. SOPs for: schema design, RLS policies, migrations, backups, monitoring. |
| BUILD-9 | Build Contabo deployment skill | Leverages the Contabo MCP. SOPs for: nginx config, pm2 management, SSL certs, health checks, rollback. |
| SKILL-15 | Arabic localization skill | Core market differentiator. RTL validation, Arabic tone checking, bilingual content guidelines. |
| SKILL-16 | Client management skill | Agency workflow: onboarding, status reports, SOW generation, engagement tracking. |

### Phase 4: Hardening (30 min)

| # | Action | What It Does |
|---|--------|-------------|
| ENFORCE-12 | Clean CLAUDE.md + add @imports | Remove theater lines (saves ~30 instruction slots). Move git SOPs to `@docs/git-instructions.md`. Move skill info to `@docs/skill-guide.md`. |
| ENFORCE-13 | Add MCP allowlisting | Whitelist the 15 MCPs you actually use. Block everything else. Prevents supply chain attacks. |
| EVALUATE-14 | Assess GitHub Agentic Workflows | Document whether `gh aw` can replace custom scripts for: doc sync, triage, self-healing CI. Decision: adopt or defer. |

### Phase 5: Sync (15 min)

| # | Action | What It Does |
|---|--------|-------------|
| PUSH | Push all changes to smorch-brain | Commit hooks, skills, agents, templates. |
| SYNC | Provide server update instructions | Commands for smo-brain and smo-dev to pull latest. |

---

## 10. Expected Outcome

### Before vs After

| Dimension | Before | After |
|-----------|--------|-------|
| **SQL protection** | NONE through MCP | DDL blocked, logged |
| **Secret detection** | NONE | Every file write scanned |
| **Session consistency** | Depends on Claude's memory | Deterministic bootstrap hook |
| **Cross-tool compatibility** | Claude-only (CLAUDE.md) | 25+ tools (AGENTS.md) |
| **Agent intelligence** | Stateless (fresh every time) | Persistent memory, improving |
| **Commit discipline** | Per-repo git hook (if installed) | Universal Claude-level hook |
| **Branch discipline** | Honor system | Hook-enforced at push time |
| **MCP security** | Open (any server can connect) | Allowlisted (whitelist only) |
| **CLAUDE.md efficiency** | ~300 lines, some theater | ~200 lines, every line earns its place |
| **Unused MCPs** | 7 connected, unused | 2-3 skills built to leverage them |

### Projected Architecture Score: 9.5 → 10/10

The remaining 0.5 comes from: (1) GitHub Agentic Workflows evaluation (may add self-healing CI), (2) Claude Code Review evaluation (may add automated PR review), (3) team habit formation.

---

## 11. Timeline

| Phase | Duration | Dependencies |
|-------|----------|-------------|
| Phase 1: Critical fixes | 30 min | None — start immediately |
| Phase 2: Enforcement layer | 1 hour | Phase 1 |
| Phase 3: Skills & agents | 1.5 hours | None — can parallel with Phase 2 |
| Phase 4: Hardening | 30 min | Phase 2 |
| Phase 5: Sync | 15 min | All phases |

**Total: ~4 hours**

All phases can be executed in a single session with parallel work.
