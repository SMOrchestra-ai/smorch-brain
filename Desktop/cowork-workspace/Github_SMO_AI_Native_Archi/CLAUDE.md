# AI-Native Architecture Repo

Architecture docs, ADRs, SOPs, and BRDs for the SMOrchestra AI-Native Organization.

## First Step — Always

**Read [`AI Native Doc/DevTeamSOP/README.md`](AI%20Native%20Doc/DevTeamSOP/README.md) first.** It's the master navigation for all documentation.

For detailed topic-to-file routing, use [`AI Native Doc/DevTeamSOP/INDEX.md`](AI%20Native%20Doc/DevTeamSOP/INDEX.md).

## Mandatory SOPs — Read Before Acting

All SOPs are in `AI Native Doc/DevTeamSOP/sops/`:

| SOP | File | Governs |
|-----|------|---------|
| **Infrastructure & Deployment** | `sops/SOP-Infrastructure-Node-Roles.md` | Node roles, deployment targets, PR branches, repo affinity |
| **GitHub Standards** | `sops/SOP-Github-Standards.md` | Branch model, commits, PRs, releases |
| **Dev Roles** | `sops/SOP-Dev-Roles-Hierarchy.md` | Who does what (Mamoun / AI / Lana) |
| **QA Protocol** | `sops/SOP-QA-Protocol.md` | Scoring, quality gates, pre-upload checks |
| **Pre-Upload Scoring** | `sops/SOP-Pre-Upload-Scoring.md` | Code quality scoring before merge |
| **Team Distribution** | `sops/SOP-Team-Distribution.md` | Team structure, responsibilities |
| **Agentic Coding** | `sops/SOP-Agentic-Coding-Orchestration.md` | AI agent coding coordination |

## Hard Rules (no SOP lookup needed)

- **smo-dev deploys apps.** smo-brain orchestrates. Never mix.
- **PRs to `dev`** for Signal-Sales-Engine and EO repos. Never to `main`.
- **Agent compute uses ALL nodes** — smo-brain, smo-dev, desktop. Never consolidate.
- **No API keys — except Google.** OAuth/subscription auth only. Google API keys are allowed.
- **BRD flow:** BRD → @SMO-AI-CEO (CEO inbox) → Paperclip decomposes → al-Jazari (VP Eng) executes → PR. Never bypass for production work.

## Directory Layout

Everything lives under `AI Native Doc/DevTeamSOP/`:

```
DevTeamSOP/
├── sops/              # Operational SOPs
├── architecture/      # System architecture + ADRs
├── roles/             # Agent role definitions
├── infrastructure/    # Node setup, deployment, build status
├── execution/         # Sprint plans, soak test, agent tests
├── onboarding/        # Team profiles, onboarding guides
├── scoring/           # Dev + GTM quality scoring skills
├── skills/            # Skill SOPs, creation, distribution
├── projects/          # Project BRDs (email-verification, scorecard-cc, super-operator, queue-engine)
├── guides/            # Best practices, reference guides
├── research/          # Deep research docs
├── content/           # Content marketing
├── audit-reports/     # Periodic audits
└── archive/           # Superseded/old versions
```

## Key Architecture Files

| What | File |
|------|------|
| 3-layer architecture (LOCKED) | `architecture/architecture-final-2026-03-30.md` |
| BRD execution pipeline | `architecture/guide-brd-execution-pipeline.md` |
| System diagram | `architecture/system-diagram.md` |
| ADR index | `architecture/adr/ADR-index.md` |
| Soak test plan | `execution/execution-plan-v3-2026-03-30.md` |
| Build progress | `infrastructure/build-progress-2026-04-01.md` |
