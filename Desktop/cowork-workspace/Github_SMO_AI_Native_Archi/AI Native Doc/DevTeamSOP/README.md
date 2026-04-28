# SMOrchestra AI-Native Organization — Documentation Hub

**Single source of truth for all architecture, SOPs, project docs, and operational guides.**

All documentation lives under `AI Native Doc/DevTeamSOP/`. If it's not here, it doesn't exist.

---

## Quick Navigation

| I need to... | Go to |
|--------------|-------|
| Understand the 3-layer architecture | [architecture/architecture-final-2026-03-30.md](architecture/architecture-final-2026-03-30.md) |
| Know how BRDs flow through the system | [architecture/guide-brd-execution-pipeline.md](architecture/guide-brd-execution-pipeline.md) |
| Check which node runs what | [sops/SOP-Infrastructure-Node-Roles.md](sops/SOP-Infrastructure-Node-Roles.md) |
| Follow GitHub branch/PR standards | [sops/SOP-Github-Standards.md](sops/SOP-Github-Standards.md) |
| Understand agent roles | [roles/](roles/) |
| Score code quality before merge | [sops/SOP-Pre-Upload-Scoring.md](sops/SOP-Pre-Upload-Scoring.md) |
| Review a project BRD | [projects/](projects/) |
| Look up an architecture decision | [architecture/adr/ADR-index.md](architecture/adr/ADR-index.md) |
| Set up infrastructure (OpenClaw, n8n) | [infrastructure/](infrastructure/) |
| Onboard a team member | [onboarding/](onboarding/) |
| Check server health / fix memory issues | [sops/SOP-Server-Health-Maintenance.md](sops/SOP-Server-Health-Maintenance.md) |

---

## Folder Structure

```
DevTeamSOP/
├── sops/                  # Operational SOPs (GitHub, infra, QA, roles, scoring)
├── architecture/          # System architecture, diagrams, API reference
│   └── adr/               # Architecture Decision Records (ADR-001 through ADR-015)
├── roles/                 # Agent role definitions (VP Eng, QA Lead, DevOps, etc.)
├── infrastructure/        # Node setup, OpenClaw, n8n, deployment guides
├── execution/             # Sprint plans, soak test plan, agent test cases
│   └── archive/           # Superseded execution plans (v1, v2)
├── onboarding/            # Human team profiles, onboarding guides
│   └── team-profiles/     # Individual team member profiles
├── scoring/               # Dev scoring + GTM scoring skill trees
│   ├── dev-scoring/       # Code quality scoring skills
│   └── gtm-scoring/       # GTM/marketing scoring skills
├── skills/                # Skill SOPs, creation guides, distribution
│   ├── campaign-guide/    # Campaign management skill
│   └── linear-operator/   # Linear task management skill
├── projects/              # Project-specific BRDs, plans, and artifacts
│   ├── email-verification/  # Email verification L1-L4
│   ├── scorecard-cc/        # CC Intelligence Scorecard
│   ├── super-operator/      # Super AI Operator Platform
│   └── queue-engine/        # Queue Engine build scripts
├── guides/                # Reference guides, best practices
├── research/              # Deep research docs (OpenClaw, Paperclip, audits)
├── content/               # Content marketing (LinkedIn, social)
├── audit-reports/         # Periodic audit reports
└── archive/               # Superseded/old versions (kept for reference)
```

---

## Project Status (as of 2026-04-02)

| Project | Status | What's next |
|---------|--------|-------------|
| Email Verification L1-L2 | **COMPLETE** | 17/17 tests. Deployed. |
| SSE V3 (Signal Sales Engine) | **IN PROGRESS** | Soak test for AI-Native Org. Separate chat. |
| CC Intelligence Scorecard | NOT BUILT | BRD ready. Needs build prioritization. |
| Super AI Operator | BRD v1.2 | Audit → v1.0 → build |
| Queue Engine | PHASE 0 | Scripts done. Pending soak test integration. |
| AI-Native Org Infra | PHASE 6 | 5 E2E blockers before soak test runs. |

See [INDEX.md](INDEX.md) → Project Status Dashboard for full details.

---

## Hard Rules

- **smo-dev deploys apps.** smo-brain orchestrates. Never mix.
- **PRs to `dev`** for Signal-Sales-Engine and EO repos. Never to `main`.
- **Agent compute uses ALL nodes** — smo-brain, smo-dev, desktop. Never consolidate.
- **No API keys — except Google.** OAuth/subscription auth only.
- **BRD flow:** BRD → @SMO-AI-CEO (CEO inbox) → Paperclip decomposes → al-Jazari (VP Eng) executes → PR. Never bypass for production work.
- **Server health cron runs 3x daily** (06:00, 14:00, 22:00) on both servers. Kills orphaned Claude/Codex sessions >6h, reaps zombies, auto-restarts dead services on smo-brain. See [SOP-Server-Health-Maintenance.md](sops/SOP-Server-Health-Maintenance.md).

---

## For AI Agents / Claude Code Sessions

**Start here:** Read this README, then check [INDEX.md](INDEX.md) for detailed routing by topic.

The INDEX file maps every question type to the exact file that answers it. Use it as your lookup table.
