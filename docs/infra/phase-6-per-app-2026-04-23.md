# Phase 6 Evidence — Per-App Deep Dive + EX-7 Sync

**Date:** 2026-04-23

## What landed this phase (as a design + ship phase)

### EX-7 Multi-Machine Sync — DEPLOYED
- Script: `smorch-dev/scripts/sync/sync-from-github.sh`
- Deployed to all 4 servers via Tailscale SSH with `*/30 * * * *` cron (pulls `smorch-brain` + `smorch-dev` from GitHub)
- Mamoun's Mac: launchd agent `ai.smorchestra.sync-from-github` — runs every 1800s
- Heartbeats → `flow.smorchestra.ai/webhook/sync-heartbeat`
- Never overwrites local changes (halts if `git status --porcelain` non-empty)
- Log: `/var/log/sync-from-github.log` (servers) / `~/.claude/logs/sync-from-github.log` (Mac)

### Phase 6 artifacts committed to April22-CleanSlate-SuperEnv/phase-6-per-app/
- `TEMPLATE.md` — canonical per-app one-pager structure (18 fields)
- `MASTER-REGISTRY.md` — 17 repos × priority tier × blocker × ETA
- `SSE-DEEP-DIVE.md` — first full deep-dive (Tier 1 repo, most critical)

### Master registry tiers
- **Tier 1 (production-critical, NOT ready):** Signal-Sales-Engine, content-automation, SaaSFast
- **Tier 2 (production but needs paperwork):** eo-mena, EO-Scorecard, digital-revenue-score, gtm-fitness-scorecard, eo-microsaas-plugin, smorchestra-web
- **Tier 3 (infra/tooling):** smorch-brain/dev/dist/context, super-ai-agent, contabo-mcp-server, eo-microsaas-training, SaaSfast-Page-Online

## Phase 6 is intentionally iterative

Rather than produce 17 deep-dive docs in one session (shallow, stale fast), Phase 6 runs per-repo AS THEY MATURE. Each Tier 1 repo gets its deep-dive + skill injection when its fundamentals are green (per EX-2). Expected wall-clock: 2-3 weeks serial, 3-5 days if CEO + Claude pair on it.

## Gate to exit Phase 6

All 17 repos have:
- ✅ `.smorch/project.json` present + valid (6/17 done Phase 3; 11 remaining)
- ✅ CLAUDE.md ≤80 lines Boris (3/17 already there; 14 need trim)
- ✅ `docs/phase-6-deep-dive-2026-04-23.md` (1/17 done; 16 remaining)
- ✅ `skills/runtime-skills.json` OR explicit `runtime_skills: "none"`

## What triggers Phase 7

Phase 7 (Desktop Clean-Slate) starts only when Phase 6 is 100% — GitHub is fully canonical, every repo has its deep-dive, skills are injected (or explicitly declared none). Then we wipe + rebuild the desktop workspace from canonical GitHub.
