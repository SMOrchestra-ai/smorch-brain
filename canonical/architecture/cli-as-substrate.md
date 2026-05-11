# CLI as Substrate — SMOrchestra Architecture Reference

**Status:** Canonical 2026-05-11
**Audience:** Mamoun + anyone building or operating SMO infra
**Companion SOP:** [SOP-36 — CLI Substrate Architecture](../../sops/SOP-36-CLI-Substrate-And-Printing-Press.md)

> **One-line frame:** *CLIs are the L2 substrate of the SMO stack — the executable equivalent of a shared library. Build the capability once as a CLI, then let cron, n8n, MCPs, agents, and humans all consume it.*

---

## 1. The 4-layer stack

```
┌──────────────────────────────────────────────────────────────────┐
│  L4 — USER SURFACES                                              │
│  What the world sees. Web apps, marketing pages, email, social,  │
│  chat, voice. Built for humans (and human-shaped intents).       │
├──────────────────────────────────────────────────────────────────┤
│  L3 — ORCHESTRATION                                              │
│  What coordinates work. MCPs, n8n workflows, cron jobs, PM2      │
│  services, agentic skills, webhook receivers. Built for "when    │
│  X happens, do Y" logic.                                         │
├──────────────────────────────────────────────────────────────────┤
│  L2 — SUBSTRATE  ◄── Printing Press CLIs live here               │
│  What does the work. Deterministic capabilities. CLIs, plus      │
│  databases, object storage, queues. Built for "given input X,    │
│  produce output Y, the same way every time."                     │
├──────────────────────────────────────────────────────────────────┤
│  L1 — PROVIDERS                                                  │
│  External APIs and infrastructure. Firecrawl, GHL, Stripe,       │
│  Supabase, Anthropic, Resend, Contabo, Tailscale, Linear, etc.   │
│  Built by someone else, billed by usage.                         │
└──────────────────────────────────────────────────────────────────┘
```

### Why these layers, in this order

| Layer | Determinism | LLM-cost | Caches? | Cron-able? |
|---|---|---|---|---|
| L4 | High at boundary, low at user-input | Low | Per page | n/a |
| L3 | Mixed — orchestration logic is deterministic, agentic flows are not | **High** when MCP-driven | Rarely | Sometimes |
| **L2** | **High** | **Zero (no LLM)** | **Yes** | **Yes** |
| L1 | Provider's choice | n/a | Provider-dependent | n/a |

**The doctrine:** push deterministic work DOWN. Every time you move a workflow from L3 (Claude burning tokens) to L2 (a CLI running under cron), you save money, gain caching, and earn predictable failure modes.

---

## 2. SMO capability map — where each piece lives today

### L4 — User surfaces (Next.js / static / external)
| Surface | Repo | Host |
|---|---|---|
| `saasfast-page-online` (SaaSfast marketing page) | `eo/SaaSfast-Page-Online` | eo-prod |
| `digital-revenue-score` (Next.js scorecard) | `smo/digital-revenue-score` | smo-prod |
| `gtm-fitness-scorecard` | `smo/gtm-fitness-scorecard` | smo-prod |
| `eo-dashboard` | `eo/eo-dashboard` (private) | smo-dev |
| `eo-mena` | `eo/eo-mena` | eo-prod |
| `eo-scorecard` | `eo/EO-Scorecard-Platform` | eo-prod |
| YouTube channel @MamounAlamouri | n/a | external |
| smorchestra.ai marketing site | `smo/smorchestra-web` | external (Netlify) |

### L3 — Orchestration
| Piece | Type | Where it runs | What it calls down to |
|---|---|---|---|
| `flows.smorchestra.ai` n8n | n8n workflows | smo-prod | L2 CLIs + L1 providers directly |
| `testflow.smorchestra.ai` n8n | n8n workflows | smo-dev | same |
| `ai.mamounalamouri.smorchestra.com` n8n | EO workflows | eo-prod | same |
| `sse-backend` (Signal Sales Engine) | PM2 Node service | smo-prod | currently L1 directly; migration target = L2 CLIs |
| `salesmfast-ops-mcp` | MCP facade | local Mac (stdio) | wraps GoHighLevel-MCP upstream → L1 |
| `pp-firecrawl` Claude Code skill | Agentic skill | local Mac (interactive) | shells out to L2 `firecrawl-pp-cli` |
| `eo-scoring` PM2 service | Node service | eo-prod | L1 (Supabase + Anthropic) directly |
| Cron: SSE competitor-diff (planned) | cron + bash | smo-prod | L2 `firecrawl-pp-cli` |

### L2 — Substrate (Printing Press CLIs + storage)

| Capability | CLI | Status |
|---|---|---|
| Web scraping / crawling / extraction | `firecrawl-pp-cli` v1.0.0 | ✅ installed on local + smo-dev + smo-prod |
| Printing Press factory (builds new CLIs) | `printing-press` v4.2.2 | ✅ installed on all 4 hosts |
| GHL contacts wrapper | `salesmfast-pp-cli` | 🟡 queued (Tier 1.5 — factory dogfood, contacts subdomain v1) |
| Gulf company research | `gulf-company-pp-cli` | 📋 planned (see ADR-006) |
| Transactional email | `resend-pp-cli` | 📋 planned (factory dogfood candidate) |
| Supabase REST | `supabase-pp-cli` | 📋 planned (factory dogfood candidate) |
| Contabo VPS ops | `contabo-pp-cli` (or `smo-ops-pp-cli`) | 📋 planned (replaces 2 MCPs) |
| Local SQLite (CLI caches) | per-CLI `~/.local/share/<cli>/data.db` | ✅ per-CLI, auto-managed |
| Supabase Postgres | Supabase | ✅ L1, accessed via L2 wrappers eventually |
| File storage | Contabo Object Storage | ✅ L1 |

### L1 — Providers
Firecrawl · GHL · Stripe · Supabase · Anthropic · OpenAI · Resend · Contabo · Tailscale · Linear · n8n (self-hosted on owned VPS) · Ahrefs · Clay · Instantly · GitHub · Notion

---

## 3. The MCP-vs-CLI question, finally settled

**Both exist. Both stay. They serve different jobs.**

| Same workflow | MCP shape | CLI shape |
|---|---|---|
| Example | "Hey Claude, scrape this competitor and tell me what changed" | `0 2 * * * firecrawl-pp-cli batch ... --deliver webhook:...` |
| Driver | LLM in a chat session | cron / script / PM2 service |
| Frequency | One-off, interactive | Scheduled, repeating |
| Cost dimension | Claude tokens + upstream | Upstream only |
| Caching | None | Yes (server-side + local) |
| Audit | Chat transcript | Logs + structured output |
| Right when | You're exploring or making a one-shot decision | The workflow has stabilized and runs on a schedule |

**Migration path for every workflow:**

```
phase 1: prototype it in an MCP-driven chat
   ↓ (workflow stabilizes, runs 3+ times)
phase 2: write a small bash script that calls the MCP via Claude Code agent
   ↓ (workflow is now a recurring need)
phase 3: build a pp-cli for it (or install one from the library)
   ↓ (cron it, mcp-wrap if interactive use still useful)
phase 4: cron runs the CLI; the MCP becomes a thin shim over the same CLI
```

Most SMO workflows are stuck in phase 1-2 today. The Printing Press adoption is what moves them to phase 3-4.

---

## 4. Anti-patterns (each one paired with the right pattern)

### ❌ "Just call the API directly from the Node service."
**Right pattern:** Shell out to the pp-cli from the Node service. Same caching, same auth, same observability. The CLI is your library.

### ❌ "We need a custom MCP wrapper around this API."
**Right pattern:** Build the CLI first. Wrap the CLI with an MCP if interactive use is still needed. Don't build two implementations.

### ❌ "Run this scrape job inside a Claude Code session at 2am."
**Right pattern:** Cron the CLI on smo-prod. Have it `--deliver webhook:...` to n8n. No LLM in the critical path.

### ❌ "Install every CLI from the library so we're ready."
**Right pattern:** Install only what you'll consume in the next 30 days. Each install adds binary + auth surface + maintenance. Easy to add later.

### ❌ "Use one CLI from the public library even though half the data sources don't apply to MENA."
**Right pattern:** Build the Gulf-tuned equivalent via the factory. See ADR-006 for the methodology.

### ❌ "Burn Claude tokens looping through 200 GHL contacts with the MCP."
**Right pattern:** `salesmfast-pp-cli contacts upsert --batch --input contacts.jsonl`. Once it exists, no LLM in the loop.

### ❌ "Hard-code the API key in the Node service env."
**Right pattern:** Auth lives at the CLI layer. The CLI reads from `/etc/profile.d/printing-press.sh` (server) or Keychain (Mac). Node service shells out — never sees the key.

---

## 5. Why this matters for SMO's thesis

> **The thesis:** "Relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement."

Signal-based selling requires **continuous, cheap, deterministic data gathering**:
- Competitor moves (daily web scrapes)
- Prospect changes (weekly enrichment)
- Buying signals (ad library, hiring, press) (multi-times-per-week)
- Custom Gulf data sources (registries, family-conglomerate maps, Arabic press)

If every one of those runs as an interactive Claude Code session, **token cost scales linearly with signal volume.** SMO can never afford to be high-signal because every signal is a Claude API bill.

If the same workflows run as L2 CLIs under cron with local cache, **token cost is bounded by interactive use only.** Signal volume can scale 100× without scaling token spend. *That's* the unlock. CLIs aren't a tech-aesthetic choice — they're the cost structure that makes signal-based GTM actually economical.

---

## 6. Reading order — if you're new to this doctrine

1. This doc (you are here) — the macro view + capability map
2. [SOP-36 — CLI Substrate Architecture](../../sops/SOP-36-CLI-Substrate-And-Printing-Press.md) — the recipes (invoke / build / operate)
3. [ADR-006 — Gulf-Company Research CLI](../adrs/ADR-006-gulf-company-cli-research-tool.md) — worked example of the build pattern
4. [SOP-35 — Dev → Prod Promotion](../../sops/SOP-35-Dev-To-Prod-Promotion.md) — how new CLIs get to production
5. Printing Press external docs: https://printingpress.dev

---

## 7. Living state — installed CLIs by host

This table is the source of truth. Update on every install/uninstall.

| Host | Factory | firecrawl-pp-cli | salesmfast-pp-cli (planned) | gulf-company-pp-cli (planned) | Last updated |
|---|---|---|---|---|---|
| Local Mac | v4.2.2 | v1.0.0 + auth | — | — | 2026-05-11 |
| smo-dev | v4.2.2 | v1.0.0 + auth | — | — | 2026-05-11 |
| smo-prod | v4.2.2 | v1.0.0 + auth | — | — | 2026-05-11 |
| eo-prod | v4.2.2 | — (factory only) | — | — | 2026-05-11 |
