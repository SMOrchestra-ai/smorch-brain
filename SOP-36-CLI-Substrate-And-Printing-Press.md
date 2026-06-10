# SOP-36 — CLI Substrate Architecture (Printing Press)

**Status:** Active 2026-05-11
**Scope:** Every SMOrchestra project. Defines when and how to use CLIs (vs MCPs, vs inline code), how to invoke them safely in agent/cron/MCP contexts, and how to build new CLIs via the Printing Press factory.
**Companion doc:** [canonical/architecture/cli-as-substrate.md](../canonical/architecture/cli-as-substrate.md) — the deep architecture reference (4-layer stack, capability map, anti-patterns).

---

## 1. The CLI-substrate doctrine

**Treat CLIs as the substrate layer of the SMO stack — the executable equivalent of a library.** Anything that:
- runs more than 3× a week,
- has a stable input/output shape,
- needs to be callable from cron, n8n, MCPs, agents, OR humans,
- needs caching/batching/deterministic exit codes,

should be a **CLI**, not a one-off script, not an MCP-only flow, not inline code in a service. The CLI gets built once and consumed by every layer above it.

### When to build a CLI

✅ **CLI is right for:**
- Scheduled scrape/enrich/diff jobs (SSE competitor monitoring, prospect upserts)
- Batch ETL (10+ items in one shot — contacts import, prospect dossier generation)
- Wrapping a noisy/paginated upstream API with a clean SMO-shaped interface (GHL contacts, Stripe billing, Resend mailer)
- Anything an MCP currently does that gets called >10×/week from cron or from non-Claude agents
- DevOps automation (smo-deploy, smo-health, smo-rollback already follow this pattern)

🟡 **Mixed (CLI + MCP wrapper around the CLI):**
- Tools used BOTH interactively in Claude Code AND by cron/n8n. Build the CLI first, then wrap it with a thin MCP that shells out to the CLI. Single source of truth.

❌ **CLI is wrong for:**
- User-facing UI (web apps stay web apps)
- Real-time bidirectional sessions (WebSocket, voice calls — CXMfast lives outside this pattern)
- One-off scripts that won't run again
- Trivial pass-through to a single API call with no caching/batching/transformation value

### Why CLIs beat ad-hoc MCP-only flows

| Dimension | MCP (in agent chat) | CLI (cron / script / wrapped MCP) |
|---|---|---|
| Cost per call | Claude tokens (LLM driving) | Just upstream API |
| Caching | None | Local SQLite + server-side `--max-age` |
| Batch mode | One call at a time | Native multi-input |
| Cron-able | No (needs active session) | Yes |
| Exit codes | Implicit via LLM | Explicit 0-7,10 |
| Auditability | LLM transcript only | Stdout/stderr + structured logs |
| Failure mode | Silent token burn | Loud non-zero exit |

The MCP isn't wrong — it's the right tool for **interactive exploration**. But once a workflow becomes "Claude does this same thing every night at 2am," it has outgrown the MCP shape.

---

## 2. Macro architecture — the 4-layer stack

```
┌──────────────────────────────────────────────────────────────────┐
│  L4 — USER SURFACES                                              │
│  Next.js apps · Marketing pages · Email · Chatwoot · YouTube ·   │
│  Telegram · GHL forms · Slack                                    │
│  (saasfast-page-online · eo-dashboard · digital-revenue-score)   │
├──────────────────────────────────────────────────────────────────┤
│  L3 — ORCHESTRATION                                              │
│  MCPs · n8n workflows · cron jobs · PM2 services · Claude Code   │
│  agents · webhook handlers                                       │
│  (salesmfast-ops-mcp · flows.smorchestra.ai · SSE skills)        │
├──────────────────────────────────────────────────────────────────┤
│  L2 — SUBSTRATE  ◄── Printing Press CLIs live here               │
│  Deterministic capabilities · CLIs · DB · object storage · Redis │
│  (firecrawl-pp-cli · salesmfast-pp-cli (planned) · future:       │
│   gulf-company-pp-cli · resend-pp-cli · supabase-pp-cli)         │
├──────────────────────────────────────────────────────────────────┤
│  L1 — PROVIDERS                                                  │
│  Firecrawl · GHL · Stripe · Supabase · Anthropic · OpenAI ·      │
│  Resend · Contabo · Tailscale · Linear                           │
└──────────────────────────────────────────────────────────────────┘
```

**Read this top-down:** every L4 surface ultimately depends on L1 providers. The question is how many layers of indirection. The doctrine says:

> Push deterministic, repeatable, cache-able work *down* to L2. Reserve L3 for orchestration and L4 for what users actually see.

**Concrete example — SSE competitor monitoring:**
- ❌ **Anti-pattern (today):** L3 MCP `firecrawl-mcp` called from a Claude Code skill, every night, every URL, full token burn per scrape, no cache.
- ✅ **Pattern (after migration):** L2 `firecrawl-pp-cli` runs from a cron on smo-prod with `--max-age 86400000`, writes to local SQLite, delivers to webhook. L3 skill reads the SQLite cache. Token cost ≈ 0. Upstream cost ≈ Firecrawl credits only.

---

## 3. Invoking a CLI — patterns

### 3.1 From cron (the canonical pattern)

```bash
# /etc/cron.d/sse-competitor-diff
0 2 * * * root . /etc/profile.d/printing-press.sh && \
  /root/go/bin/firecrawl-pp-cli batch scrape-and-extract-from-urls \
    --urls "$(cat /opt/sse/config/competitors.json)" \
    --max-age 86400000 \
    --agent \
    --deliver webhook:https://flows.smorchestra.ai/webhook/sse-competitor-diff \
    >> /var/log/sse-competitor-diff.log 2>&1
```

**Rules:**
- Always `source /etc/profile.d/printing-press.sh` first (loads env + PATH).
- Always use `--agent` flag (turns on `--json --compact --no-input --no-color --yes` — non-interactive, predictable).
- Always log to `/var/log/<job>.log` AND check exit code in a separate health probe.
- Use `--deliver webhook:...` to push results to the next layer (n8n, SSE backend) — don't pipe into a manual script if a webhook can do it.

### 3.2 From an n8n workflow

In an Execute Command node:
```bash
. /etc/profile.d/printing-press.sh && firecrawl-pp-cli scrape \
  --url "{{$json.url}}" \
  --max-age 3600000 \
  --agent
```
Wire the JSON output into the next n8n node. Cleaner than n8n's HTTP Request node calling Firecrawl directly (which loses local caching).

### 3.3 From a Node service (PM2 app, MCP wrapper, etc.)

```typescript
import { execFile } from "node:child_process";
import { promisify } from "node:util";
const exec = promisify(execFile);

async function scrape(url: string) {
  const { stdout } = await exec(
    "/root/go/bin/firecrawl-pp-cli",
    ["scrape", "--url", url, "--max-age", "86400000", "--agent"],
    { env: { ...process.env, FIRECRAWL_BEARER_AUTH: process.env.FIRECRAWL_BEARER_AUTH } },
  );
  return JSON.parse(stdout);
}
```

**Rules:**
- Always pass `--agent` for clean JSON.
- Always whitelist env vars explicitly (don't leak the rest of `process.env`).
- Always set a timeout (`{ timeout: 60_000 }` on `exec` if scraping; CLI's own `--timeout` flag too).
- Always parse stdout as JSON inside a try/catch — CLI errors go to stderr, not stdout.

### 3.4 From Claude Code (interactive agent use)

Use the focused skill that ships with each CLI (e.g. `pp-firecrawl`). The skill has been hand-tuned for agent consumption — token-efficient, knows the safe defaults. Don't shell out manually unless the skill is missing.

### 3.5 From an MCP that wraps the CLI

If a workflow needs to be exposed to Claude Code AS WELL AS run from cron, build the MCP as a thin shim over the CLI — don't reimplement the API logic in TypeScript. Same source of truth, same caching, same auth.

---

## 4. Building a new CLI — factory dogfood workflow

The Printing Press factory binary (`printing-press` v4.x) lives on every SMO host. To build a new CLI:

### 4.1 Decision gate (do this before invoking the factory)

Answer all 7 questions in writing. If any is "no" or unclear, stop.

1. **Frequency:** Does this API get called >3×/week from SMO? *(if no → just write a one-off script)*
2. **Cache fit:** Are there repeat-call patterns where caching saves money or latency? *(if no → maybe just an MCP)*
3. **Batch fit:** Will we ever process >5 items in a batch? *(if no → an MCP may be enough)*
4. **Cron fit:** Will this run from cron or scheduled n8n? *(if yes → CLI is mandatory)*
5. **Multi-consumer:** Will it be called from more than one place (cron + agent + MCP)? *(if yes → CLI is mandatory)*
6. **Auth model known:** Do we know the auth flow (API key / OAuth / location-scoped)?
7. **Existing CLI in library:** Has someone already built this? Check `npx -y @mvanhorn/printing-press list | grep -i <api>` and `printingpress.dev`.

### 4.2 Factory invocation

**Always invoke the factory in a fresh, dedicated Claude Code session.** The factory skill (`/printing-press`) drives a multi-phase agent loop (research → generate → build → shipcheck → smoke test) that consumes significant context. Mixing it with other session work risks mid-build context compaction.

1. Decide the repo location. SMO conventions:
   - Tool wraps an upstream platform used by an SMO product → `shared/<smo-product>-pp-cli` (e.g. `shared/salesmfast-pp-cli` for GHL).
   - Generic infrastructure CLI → `smo/<tool>-pp-cli`.
   - Project-scoped CLI → `<project>/cli/`.
2. `mkdir -p <target>/ && cd <target>/`
3. Open a fresh Claude Code session in that directory.
4. Type the invocation prompt (template below) — adapt scope, auth model, smoke target.
5. Let the factory run. Don't bail early; the shipcheck phase catches issues a partial build won't.

**Invocation prompt template:**
```
/printing-press <Platform Name>

Context (locked decisions):
- Repo target: this directory
- v1 scope: <one subdomain only — list which>
- Defer: <list everything you're NOT building in v1>
- Auth model: <api-key | oauth | location-scoped> + which env vars
- Smoke target: <dev tenant | prod tenant — and read-only constraint>
- Naming: binary is <name>-pp-cli
- API spec source: <Stoplight URL | OpenAPI URL | HAR capture path>

Acceptance criteria:
- All ops have --dry-run mode
- --agent flag returns clean JSON + proper exit codes (0-7,10)
- Local SQLite cache for repeat-call workloads
- Behavioral test matrix runs against the smoke target (read-only ops only on prod)
- README cookbook includes the 3 most common SMO patterns
```

### 4.3 Post-build checklist (before declaring v1 shipped)

- [ ] `<tool>-pp-cli doctor` returns OK on local Mac
- [ ] `--agent` JSON output validates against expected schema for top 5 commands
- [ ] At least one `--dry-run` test verified (no upstream API call)
- [ ] At least one real call verified (with cost recorded)
- [ ] SQLite cache populated after `sync` (or documented why sync isn't applicable)
- [ ] Auth env var(s) added to `smorch-brain/canonical/secrets-manifest.yaml`
- [ ] Auth env var(s) deployed to `/etc/profile.d/printing-press.sh` on every target host (smo-dev minimum; smo-prod + eo-prod if production cron uses it)
- [ ] README in the repo covers: install, auth setup, 3 common patterns, troubleshooting
- [ ] Commit + push to GitHub (SMOrchestra-ai org or shared org per the directory convention)
- [ ] If this replaces an existing MCP path, keep MCP installed as fallback per SOP-35 (dev→prod promotion) gating

### 4.4 Published to public library? (optional)

If the CLI is generic enough to benefit other Printing Press users (not SMO-specific), consider `/printing-press-publish` to push to the public library. Not for SMO-specific tools (`salesmfast-pp-cli`, `gulf-company-pp-cli` — keep these private).

---

## 5. Operational discipline

### 5.1 Auth + secrets

- **Never** in `~/.claude.json` (Claude reads it every session = LLM exposure).
- **Local Mac:** macOS Keychain (`security add-generic-password -s <service> -a smo -w "<key>"`) + the CLI's own `~/.config/<cli>/config.toml` written via `<cli> auth set-token`.
- **Servers:** `/etc/profile.d/printing-press.sh` (chmod 600, root-owned). One file per host. Append new CLI vars here.
- **Rotation:** per SOP-16 (90-day cycle). Add every CLI's env var to `canonical/secrets-manifest.yaml`.
- **Env var naming:** match what the CLI expects — they often differ from the MCP equivalent. Example: `FIRECRAWL_BEARER_AUTH` (CLI) ≠ `FIRECRAWL_API_KEY` (MCP). Document in the secrets manifest.

### 5.2 Caching

Two cache layers exist; know which one you're using.

| Layer | What it caches | How to enable |
|---|---|---|
| **Server-side (upstream provider)** | Recent responses to identical requests, served by the provider | `--max-age <ms>` flag on each call. Pick TTL by data freshness need (24h for competitor scrape = `86400000`). |
| **Local SQLite (the CLI's own DB)** | Synced upstream resources for offline queries | `<cli> sync` populates; `--data-source local` reads from it. Only useful when the provider has a bulk-export pattern (SEC filings, YC directory). |

Don't claim "cache wins" without naming which layer. Most SMO use cases benefit from `--max-age`, not the local SQLite.

### 5.3 Versioning

CLIs are Go binaries. Versioned via Go module tags (`v1.0.0`, `v1.1.0`) AND via `<cli> version` runtime output. Always pin the factory and major CLIs to known-good versions in `canonical/printing-press-versions.md` (create on first lock).

### 5.4 Deploy

CLIs go on every host that needs them — there's no "deploy pipeline" beyond `go install` + auth env setup. But:
- **Same version across hosts.** Drift = silent bugs. Use SOP-30 drift detection.
- **Smoke test on smo-dev for ≥7 days before smo-prod cutover** for any *production* workload. (Exception: dev-class smo-prod, per ADR-006 plan-mode note, allows simultaneous install but cron cutover stays gated.)
- **eo-prod gets the factory binary only** by default, no Tier 1/2 CLIs, until a concrete EO use case lands.

### 5.5 Telemetry

Every CLI should expose:
- `<cli> doctor` — health check (config, auth, API reachability, cache state)
- `<cli> team get-credit-usage` (or equivalent) — upstream cost telemetry
- `<cli> version` — for drift detection
- Exit codes: 0 = OK, 1-7 = various errors, 10 = retryable (per Printing Press convention)

Run `doctor` from a daily cron and alert on anything other than OK.

---

## 6. Decision rubric — which layer is this?

When you're about to write code that talks to an external service, ask in order:

1. **Is there already a Printing Press CLI for this?**
   `npx -y @mvanhorn/printing-press list | grep -i <name>` → if yes, just install + use.
2. **Will it be called from cron / n8n / non-Claude code, or batch >5 items?**
   → Build a CLI via the factory (SOP-36 §4).
3. **Will it be called only from Claude Code interactively?**
   → MCP is fine. But check question 2 again in 30 days; usage patterns change.
4. **One-off, will never run again?**
   → Inline script. Don't over-engineer.

**Default lean:** when uncertain between MCP and CLI, build the CLI. You can always wrap a CLI with an MCP later (cheap). You can't easily *un-MCP* a workflow that's grown crufty.

---

## 7. Anti-patterns to avoid

- ❌ **Calling Firecrawl/GHL/Stripe directly from a service when a pp-cli exists.** Use the CLI as your library.
- ❌ **Two CLIs for the same API** (one factory-built, one hand-rolled). Pick one. Delete the other.
- ❌ **Hand-rolling auth in a service** when the CLI handles it. Shell out to `<cli> auth status` and trust the CLI's auth.
- ❌ **Burning Claude tokens for batch ETL.** If you find yourself in a Claude Code session running the same scrape 50× via MCP, stop and write a cron.
- ❌ **Installing every CLI from the library "just in case."** Each CLI = ~20 MB binary + auth surface + maintenance. Install only what you'll consume.
- ❌ **Public-library publishing of SMO-specific CLIs.** `salesmfast-pp-cli` is private. `gulf-company-pp-cli` is private. Only generic tools (that the broader community could use) go to `printing-press-publish`.

---

## 8. References

- Plan that triggered this SOP: `~/.claude/plans/i-want-you-to-enchanted-dragon.md`
- Companion architecture doc: [canonical/architecture/cli-as-substrate.md](../canonical/architecture/cli-as-substrate.md)
- Related ADRs:
  - [ADR-006 — Gulf-Company Research CLI](../canonical/adrs/ADR-006-gulf-company-cli-research-tool.md)
- Related SOPs:
  - SOP-16 — Secrets Rotation (90-day)
  - SOP-30 — Drift Enforcement (binary version parity across hosts)
  - SOP-35 — Dev → Prod Promotion (the gating rules CLIs respect)
- External:
  - Printing Press: https://printingpress.dev
  - CLI factory repo: https://github.com/mvanhorn/cli-printing-press
  - CLI library catalog: https://github.com/mvanhorn/printing-press-library
