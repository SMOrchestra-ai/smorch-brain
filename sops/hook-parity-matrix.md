# Hook Parity Matrix

**Purpose:** Document which Claude Code hooks run where and WHY. Hooks differ by design — local does dev work, servers don't. This table prevents confusion.

**Last updated:** 2026-04-18

---

## Who Runs What

| Hook | Local | smo-dev | smo-prod | eo-prod | smo-test (future) | Rationale |
|------|:-----:|:-------:|:--------:|:-------:|:-----------------:|-----------|
| **PreToolUse: Bash destructive-blocker** | ✅ | ✅ | ✅ | ✅ | ✅ | Blocks rm -rf, force push, hard reset, drop/truncate. Universal. |
| **PreToolUse: SQL guard (cb73f37d Supabase)** | ✅ | ✅ | ✅ | ✅ | ✅ | Blocks destructive SQL on SSE Supabase. Anywhere MCP is used. |
| **PreToolUse: SQL guard (supabase-eo)** | ❌ | ❌ | ❌ | ✅ | ❌ | Only eo-prod has the supabase-eo MCP. |
| **PreToolUse: Write/Edit secret-scanner** | ✅ | ✅ | ✅ | ✅ | ✅ | Blocks known secret patterns (sk-, AKIA, ghp_, etc.). Universal. |
| **PostToolUse: Write auto-formatter (prettier)** | ✅ | ❌ | ❌ | ❌ | ❌ | Only local writes code. Servers never edit source. |
| **PostToolUse: Write skill-auto-push** | ✅ | ❌ | ❌ | ❌ | ❌ | Only local pushes skills to smorch-brain. Servers consume. |
| **PostCompact: context-restorer** | ✅ | ✅ | ✅ | ✅ | ✅ | Universal. Works same everywhere. |
| **SessionStart: session-bootstrap** | ✅ | ✅ | ✅ | ✅ | ✅ | Universal. Git sync check, branch warning. |
| **SessionStart: branch-protection-enforcer** | ✅ | ❌ | ❌ | ❌ | ❌ | Only relevant locally where branches are created. |

---

## Hook Counts

- **Local:** 7 hooks (dev workstation)
- **smo-dev:** 5 hooks (dev server)
- **smo-prod:** 5 hooks (prod server)
- **eo-prod:** 6 hooks (prod server + supabase-eo)
- **smo-test:** 5 hooks (when provisioned)

Differences are intentional. Do not "normalize" to local.

---

## What to Do If Parity Drifts

If drift detection alerts that a server hook count differs from this table:

1. Check `smorch-brain/canonical/settings/{server}-settings.json` against live server.
2. If live has more hooks than canonical → someone added one manually. Investigate. Either remove or promote to canonical.
3. If live has fewer hooks → someone removed one. Restore from canonical.
4. Update this table if design actually changes (rare).

---

## Adding a New Hook

1. Decide its scope: local-only, all-servers, specific-servers.
2. Add to appropriate `smorch-brain/canonical/settings/*.json` files.
3. Deploy via `scripts/sync-settings-to-machines.sh` (TBD).
4. Update this matrix.
5. Commit with message `hooks: add [name] for [scope]`.

---

## Removing a Hook

1. Deprecate in canonical with inline comment for 30 days before removal.
2. Announce in Telegram ops channel.
3. Remove from canonical + sync to machines.
4. Update this matrix.
