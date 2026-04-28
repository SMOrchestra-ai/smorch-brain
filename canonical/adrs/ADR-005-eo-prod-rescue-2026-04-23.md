# ADR-005 — eo-prod smorch-brain Rescue (2026-04-23)

**Status:** Accepted 2026-04-23
**Context:** During Phase 3 fleet audit, eo-prod's `/root/smorch-brain` local main was found 15 commits ahead + 31 behind origin/main — fully diverged. Investigation revealed the 15 local commits contained unpushed feature work from ~2026-03-22 (classic L-009 violation before the rebuild).

## Decision

Non-destructive 3-step rescue:
1. Push entire local main as `rescue/eo-prod-local-main-2026-04-23` branch → preserves 100% of content on GitHub for audit trail
2. Cherry-pick the 3 commits with content not on current main → integration PR #12, merged
3. Leave eo-prod local `/root/smorch-brain` untouched until CEO-approved reset

## Content landed via PR #12

- `hooks/commit-msg` + `hooks/install-hooks.sh` (conventional commit hook)
- `docs/openclaw-agent-context.md` (OpenClaw agent context file)
- `docs/claude-code-onboarding-guide.md` (Claude Code onboarding guide with scoring dimensions)

## Content NOT integrated (reason)

Other 12 rescue commits either:
- Already have equivalent content on current main (post-Phase-2 SOP recovery)
- Reference restructured content (smorch-github-ops skill, changelog-generator — may need separate evaluation)

Full rescue branch remains accessible on GitHub for future evaluation: `rescue/eo-prod-local-main-2026-04-23`.

## Consequences

- eo-prod `/root/smorch-brain` still on divergent local main until reset
- `sync-from-github.sh` cron will continue to skip this clone (marked dirty by divergence heuristic)
- `/opt/scripts/` on eo-prod is current (scripts live in smorch-dev, not smorch-brain) — enforcement continues uninterrupted
- SOPs not readable LOCALLY on eo-prod until reset; but readable on other machines or via GitHub directly

## Follow-up

When CEO approves the reset command (destructive — hook blocks it until approved):
- SSH to 100.89.148.62
- `cd /root/smorch-brain`
- `git fetch` (non-destructive)
- Destructive reset to origin/main (needs explicit approval in chat)

Rescue branch remains on GitHub regardless, so this is safe with zero data loss.
