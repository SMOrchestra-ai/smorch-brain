# ADR-006: Parallel Execution via Claude Code Remote Control

**Date:** 2026-03-28
**Status:** Accepted
**Decider:** Mamoun Alamouri
**Stakeholders:** Lana (Technical Architecture)
**Ticket:** TBD (VibeMicroSaaS Super AI — Phase 0)

## 1. Context

The VibeMicroSaaS Super AI platform requires running multiple full Claude Code instances concurrently on each Contabo server node to parallelize pipeline work (code builds, GTM generation, QA, scraping). The original plan proposed porting Supervibes (a macOS-only tmux-based orchestrator) to Linux, or adopting Supervibe by Superwall. The key requirement is **full Claude Code instances** (not subagents) — each with their own context window, full tool access, and full autonomy.

## 2. Options Considered

### Option A: Port custom Supervibes to Linux
- **Description:** Modify the existing Node.js/tmux-based supervibes tool (smorchestraai-code/supervibes) to work on Linux (Contabo VPS nodes)
- **Pros:** We own the code; controller/worker delegation pattern; web dashboard at localhost:3456
- **Cons:** macOS-only today — requires porting; tmux dependency management; maintenance burden; initial commit only (Mar 19), not battle-tested
- **Estimated effort:** 1-2 days to port

### Option B: Adopt Supervibe by Superwall
- **Description:** Use Superwall's Supervibe tool for parallel agent execution
- **Pros:** Third-party maintained; marketed as autonomous builder
- **Cons:** **iOS/Swift only** — generates SwiftUI + XcodeGen projects, zero web support; 7 GitHub stars; last commit Dec 2025 (dormant); completely irrelevant for Next.js/Supabase stack
- **Estimated effort:** N/A — not technically feasible

### Option C: Claude Code Remote Control (native)
- **Description:** Use `claude remote-control --spawn worktree --capacity N` on each Contabo node. Spawns N isolated full Claude Code instances in separate git worktrees. Web dashboard accessible from phone/browser at claude.ai/code.
- **Pros:** Zero infrastructure work — already available in Claude Code v2.1.81; native worktree isolation; web dashboard built-in; capacity configurable per node; can combine with Agent SDK for programmatic session creation
- **Cons:** Experimental feature; API rate limits cap practical concurrency to ~3-4 active sessions per API key; no controller/worker delegation pattern (flat parallelism)
- **Estimated effort:** 0 days (configuration only)

## 3. Decision

We chose **Option C: Claude Code Remote Control** because it provides full Claude Code instances with zero infrastructure work, and the controller/worker pattern from Option A can be layered on top via Agent SDK if needed later. Option B is not feasible for our stack.

**Fallback:** If the controller/worker delegation pattern (tech lead → developers) proves necessary for Stage 5 code builds specifically, port custom Supervibes to Linux (Option A) as a targeted enhancement — not a full platform dependency.

## 4. Trade-offs Accepted

- **Flat parallelism vs. hierarchical delegation:** Remote Control spawns independent sessions without a "controller" coordinating them. We accept this for now and use OpenClaw + Agent SDK as the coordination layer instead.
- **API rate limits:** Practical concurrency is ~3-4 active sessions per node per API key. We accept this and distribute across nodes (4 nodes × 3-4 sessions = 12-16 concurrent instances).

## 5. Consequences

**Immediate actions required:**
- [ ] Configure `claude remote-control --spawn worktree --capacity 4` on smo-brain, smo-dev, and Contabo nodes (Mamoun, Day 1)
- [ ] Test concurrent session spawning and verify API throttling behavior (Lana, Day 1)
- [ ] Set up pm2/systemd to auto-start Remote Control on node boot (Lana, Day 1)

**What changes as a result:**
- No Supervibes port needed for MVP
- Each node becomes a multi-instance Claude Code server accessible via web dashboard
- OpenClaw dispatches work to specific nodes via Agent SDK; Remote Control manages local session lifecycle

**Reversal cost:** Easy (< 1 day) — can switch to ported Supervibes at any time since Remote Control is just a configuration flag
