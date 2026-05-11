# ADR-006 — Build a Gulf-Company Research CLI (replace `company-goat` for SMO's market)

**Date:** 2026-05-11
**Status:** Proposed
**Decider:** Mamoun Alamouri (CPO)
**Context:** Printing Press adoption — see plan at `~/.claude/plans/i-want-you-to-enchanted-dragon.md`

---

## 1. Decision

- **Drop `company-goat-pp-cli` from SMO's CLI stack.** It is US-biased (SEC EDGAR + YC + UK Companies House are the load-bearing sources). For MENA prospects it returns domain probes only — insufficient signal for SSE dossiers.
- **Build a Gulf-equivalent CLI via the Printing Press factory** (working name: `gulf-company-pp-cli`), keeping the architectural pattern but swapping US/UK sources for GCC + MENA equivalents.
- Defer build until **after** GHL CLI (Tier 1.5) is shipped and stable.

---

## 2. Why drop `company-goat`

**Verified by smoke test 2026-05-11 (smo-dev):** Snapshot of "careem" — a known MENA unicorn — returned only RDAP/WHOIS domain probes (`careem.com`, `careem.io`, `careem.co`). No funding history, no legal entity, no founder data. Because:
- Careem isn't a US private company → no SEC EDGAR Form D filing
- Careem isn't UK-registered → no Companies House record
- Careem isn't a YC company → no YC directory entry
- Careem is on Wikidata but cross-referencing requires Wikidata QID hint, not just the domain

For SMO's actual ICP (UAE / KSA / Qatar / Kuwait B2B), `company-goat` is **3-5% useful** at best. Not worth the install footprint, attention surface, or the cognitive cost of remembering "this tool only works for US prospects."

---

## 3. The architecture we want to keep (the good parts)

`company-goat-pp-cli` got several things right that we should replicate:

### 3.1 Fan-out parallel sources with honesty contract
```
snapshot is the headline command. It runs every source query in parallel
via cliutil.FanoutRun and renders a unified per-section summary.

Sources are queried with bounded timeouts. Failed sources are reported
as "error" status; missing data renders as "no-data" — never silently
omitted (honesty contract).
```
- **Bounded timeouts per source** (typically 30s) — one slow source can't block the whole snapshot.
- **Honesty contract** — never silently drop a source. SSE consumers know when they're working with partial data.
- **Skippable sources** via `--skip funding,wiki` — agents can opt out of slow sources.

### 3.2 8-source architecture (US/UK shape)
| Source | What it returns | Auth |
|---|---|---|
| `funding` | SEC EDGAR Form D filings + YC batch | none (SEC) / none (YC scrape) |
| `legal` | Companies House (UK) + SEC EDGAR issuer (US) | optional `COMPANIES_HOUSE_API_KEY` |
| `engineering` | GitHub org: repo count, contributor count, commit cadence, top languages | optional `GITHUB_TOKEN` (recommended) |
| `launches` | Show HN posts (sorted by points, with year hints) | none |
| `mentions` | HN Algolia full-text search timeline + top N stories | none |
| `yc` | YC directory entry: batch, status, location | none |
| `wiki` | Wikidata facts: founded, founders, HQ, industry | none |
| `domain` | RDAP/WHOIS age + DNS records + hosting hint via CNAME | none |

### 3.3 Disambiguation flow
- `resolve <name>` returns numbered candidates if ambiguous
- `--pick N` selects from prior resolve
- `--domain stripe.com` skips resolution entirely

### 3.4 Cross-source `signal` command
Flags **suspicious patterns** by cross-referencing sources. Example:
> "Raised $5M Series A in 2024 (per SEC) but no GitHub commits since 2022 and last HN mention was 2021"

This is the GTM gold — it surfaces zombie companies, shell entities, fundraising-without-product. For SSE this is signal-rich qualification at the disqualification step.

### 3.5 Local SQLite sync for offline analysis
- `sync` command hydrates `~/.local/share/company-goat-pp-cli/data.db`
- Cross-company search, industry filtering, time-series queries all run offline
- `--data-source local` for zero-network agent workflows

### 3.6 Compound commands (`workflow archive`, `workflow status`)
Multi-source orchestration with shared rate-limiting + delivery sinks (`--deliver webhook:https://...`).

---

## 4. The Gulf equivalent — source map

For each US/UK source, identify the MENA counterpart(s). Some sources stay global; others get replaced.

### 4.1 Sources that stay global
- **`engineering`** — GitHub is global. Keep as-is. Add GitLab + Bitbucket public org lookup as bonus.
- **`wiki`** — Wikidata covers MENA. Keep + extend with Arabic Wikipedia entity lookups (different QIDs but same RDF model).
- **`domain`** — RDAP/WHOIS is global. Keep + add `.ae`, `.sa`, `.qa`, `.kw`, `.bh`, `.om`, `.eg` TLD heuristics for jurisdiction inference.

### 4.2 Sources that need full replacement
| US/UK source | Gulf replacement | Auth | Note |
|---|---|---|---|
| **`funding` (SEC EDGAR + YC)** | MAGNiTT public API (MENA funding intelligence) + Wamda news + Crunchbase MENA (rate-limited public) | MAGNiTT API key (paid, evaluate) | MAGNiTT is the canonical MENA fundraising tracker. Wamda is the news layer. |
| **`legal` (Companies House + SEC issuer)** | DIFC Registrar API · ADGM Registry · KSA Maroof (Ministry of Commerce) · Qatar Financial Centre · Kuwait Direct Investment Promotion Authority · Bahrain Commercial Registry · UAE National Economic Register | most public, none paid | Multi-jurisdiction. Auto-routing by `.ae` / `.sa` / `.qa` TLD or by `--region uae,ksa,qatar,kuwait,bahrain`. |
| **`launches` (Show HN)** | Wamda new-company announcements · MAGNiTT launches · ArabNet startup launches · Saudi Vision 2030 announcements | none (RSS scrape) | Show HN equivalent is the Wamda "Startups" tag feed. |
| **`mentions` (HN Algolia)** | Wamda full-text · MENAbytes (defunct but archived) · ArabNet · Magnitt News · ITP.net B2B | none (RSS / public search) | Build a unified MENA tech-news search index — store in SQLite for offline. |
| **`yc` (YC directory)** | Flat6Labs portfolio · 500 MENA portfolio · MISK Innovation Hub · BECO Capital portfolio · MEVP portfolio · Wamda Capital portfolio · Mubadala Tech Ventures · Saudi Aramco Ventures · QIA Tech Investments | none (public portfolio scrapes) | "MENA YC equivalents" — region's signal of vetted startups. |

### 4.3 New sources unique to MENA
- **Family-conglomerate map** — for B2B selling in the Gulf, the conglomerate parent (Al-Futtaim, Majid Al-Futtaim, Olayan, Alshaya, Saud Al Babtain, Mansour Group, Bukhamseen) matters more than the operating entity. Build a manual-curated mapping + a "parent_conglomerate" field returned by `snapshot`.
- **Government tender history** — UAE Federal Tenders, KSA Etimad, Qatar Tenders. Indicates B2B procurement readiness.
- **Arabic press mentions** — Al Arabiya Business, Al Eqtisadiah, Argaam. Many MENA companies have stronger Arabic-press footprint than English.

### 4.4 Disambiguation in the Gulf context
Arabic transliteration is messy ("Aramex" vs "أرامكس", "Careem" vs "كريم"). The `resolve` step should:
- Accept both Latin and Arabic name input
- Probe `.ae/.sa/.qa/.kw` domains
- Surface trademark registry hits (Saudi Authority for Intellectual Property)
- Return Arabic + transliterated candidates side-by-side

---

## 5. Implementation plan (factory dogfood)

**Order:** GHL CLI (Tier 1.5) ships first → then this.

### Phase 1 — One-source MVP (`gulf-company-pp-cli legal --region uae`)
- Pick the easiest source: **DIFC Registrar** (public, well-documented, JSON API).
- Build via factory: `/printing-press difc-registrar` inside Claude Code, feed it the DIFC API spec.
- Output: legal entity lookup for UAE companies registered at DIFC.
- Validate against 10 known SMO prospects (e.g. SalesMfast's pilot list).

### Phase 2 — Add 3 more legal sources (ADGM, KSA Maroof, Qatar Financial Centre)
- Wrap each as a separate factory-generated mini-CLI, then compose under a single `legal` command.
- Auto-route by TLD + `--region` flag.

### Phase 3 — Add MAGNiTT funding source
- Evaluate MAGNiTT API pricing (RULE 0 spend gate).
- If too expensive: fall back to Wamda + ArabNet RSS scraping (free but lossy).

### Phase 4 — Add `signal` cross-source consistency check
- Same shape as `company-goat-pp-cli signal`, but with MENA-tuned heuristics:
  - "DIFC entity active but no Wamda mention in 3+ years" → zombie
  - "Family conglomerate subsidiary with no separate funding round" → likely internal venture, not VC
  - "Arabic-press-only company with no English coverage" → strong local play, weak international ambition

### Phase 5 — `sync` + offline analysis
- Sync DIFC + ADGM + KSA Maroof + MAGNiTT to local SQLite.
- Enables: "give me all UAE B2B SaaS companies founded 2022-2024 with >5 GitHub contributors."

---

## 6. Non-goals (out of scope)

- Personal-data lookup (LinkedIn profiles of executives) — that's a different tool (contact-goat, gated). This one is **company-level only.**
- Real-time scraping of Arabic press — Phase 1-2 use RSS / public APIs only. Browser scraping deferred.
- Replacing scrape-creators / Apify — those are social/content scrapers. Different layer.

---

## 7. Risks + open questions

| Risk | Mitigation |
|---|---|
| MAGNiTT API costs unknown | RULE 0 gate at Phase 3. If too expensive, fall back to RSS. |
| Government-registry APIs are flaky / rate-limited | Local SQLite sync mitigates. Cache aggressively. |
| Arabic name disambiguation is hard | Phase 1 = Latin names only. Arabic-input support is Phase 2+. |
| Build effort underestimated | Factory does 70% of the work per source. Estimate: 0.5 day per source × 8 sources = 4 days total. Spread over 2-3 weeks. |
| Maintenance: registries change endpoints | Same risk as `company-goat-pp-cli` carries today. Acceptable. |

---

## 8. Consequences

**Positive:**
- SMO owns a Gulf-specific intelligence asset no competitor has.
- Directly serves SSE / SalesMfast SME prospect dossier workflow.
- Factory-built = SMO controls the source mix, can add/swap sources without vendor dependency.
- Reusable for EO MENA: same tool for student company intel.

**Negative:**
- 4 days of factory dogfood before any value lands.
- Multi-jurisdiction means more code paths than `company-goat` (which had 2 jurisdictions: US + UK).
- Some sources may require sustained scraping infra (RSS feeds change, government sites get redesigned).

**Neutral:**
- Skipping `company-goat-pp-cli` means losing US/UK coverage. SMO sells in MENA — acceptable trade-off. If we ever sell to US/UK clients, we can re-install `company-goat-pp-cli` alongside (no conflict).

---

## 9. References

- Architecture inspiration: `company-goat-pp-cli` v1.0.0 — output of `company-goat-pp-cli --help` and `company-goat-pp-cli agent-context`
- Printing Press factory: `~/go/bin/printing-press` v4.2.2
- Plan file: `~/.claude/plans/i-want-you-to-enchanted-dragon.md`
- Related ADRs:
  - `ADR-004-dev-vs-app-layer-separation.md`
  - `ADR-005-eo-prod-rescue-2026-04-23.md`
