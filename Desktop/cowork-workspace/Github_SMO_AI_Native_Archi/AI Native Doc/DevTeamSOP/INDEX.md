# Documentation Index — Routing Guide

**Purpose:** Route any question to the exact file that answers it. AI agents and humans: use this as your lookup table.

---

## Project Status Dashboard

| Project | Status | Repo / Location | Notes |
|---------|--------|-----------------|-------|
| **Email Verification (L1-L2)** | COMPLETE | `Signal-Sales-Engine` on smo-dev | 17/17 tests passing. Edge function deployed. DB applied. |
| **SSE V3 (Signal Sales Engine)** | IN PROGRESS | `Signal-Sales-Engine` on smo-dev | Soak test for AI-Native Org. Separate chat. Specs at `smorch-context/SalesMfastGTM/Project6-SSEngineTech/` |
| **CC Intelligence Scorecard** | NOT BUILT | BRD + mockup in `projects/scorecard-cc/` | Waiting for build prioritization |
| **Super AI Operator Platform** | BRD v1.2 DONE | BRD in `projects/super-operator/` | Needs audit → v1.0 → build |
| **Queue Engine** | PHASE 0 DONE | Scripts in `projects/queue-engine/` | SQLite-based task queue. Pending soak test integration |
| **EO MENA v2** | IN PROGRESS | `~/Desktop/cowork-workspace/EO-MENA` | Separate repo. Replicating AppSumo for MENA |
| **AI-Native Org Infra** | PHASE 6 | This repo | OpenClaw auth done. 5 E2E blockers remaining before soak test |

---

## SOPs (Operational Procedures)

| Topic | File | When to use |
|-------|------|-------------|
| Infrastructure & node roles | [sops/SOP-Infrastructure-Node-Roles.md](sops/SOP-Infrastructure-Node-Roles.md) | Which server runs what, deployment targets, repo affinity |
| GitHub standards | [sops/SOP-Github-Standards.md](sops/SOP-Github-Standards.md) | Branch model, commit conventions, PR process, releases |
| Dev roles & hierarchy | [sops/SOP-Dev-Roles-Hierarchy.md](sops/SOP-Dev-Roles-Hierarchy.md) | Who does what — Mamoun, AI agents, Lana |
| QA protocol | [sops/SOP-QA-Protocol.md](sops/SOP-QA-Protocol.md) | Quality gates, review checklist, scoring thresholds |
| Pre-upload scoring | [sops/SOP-Pre-Upload-Scoring.md](sops/SOP-Pre-Upload-Scoring.md) | Code quality scoring before merge to dev/main |
| Team distribution | [sops/SOP-Team-Distribution.md](sops/SOP-Team-Distribution.md) | Team structure, responsibilities, communication |
| Agentic coding orchestration | [sops/SOP-Agentic-Coding-Orchestration.md](sops/SOP-Agentic-Coding-Orchestration.md) | How AI agents coordinate coding tasks |
| Server health maintenance | [sops/SOP-Server-Health-Maintenance.md](sops/SOP-Server-Health-Maintenance.md) | Automated cleanup of orphaned Claude/Codex sessions, zombie reaping, memory monitoring |

## Architecture

| Topic | File | When to use |
|-------|------|-------------|
| Full 3-layer architecture (LOCKED) | [architecture/architecture-final-2026-03-30.md](architecture/architecture-final-2026-03-30.md) | Paperclip + OpenClaw + Queue Engine — the definitive reference |
| System diagram | [architecture/system-diagram.md](architecture/system-diagram.md) | Visual system topology |
| BRD execution pipeline | [architecture/guide-brd-execution-pipeline.md](architecture/guide-brd-execution-pipeline.md) | How BRDs flow: @SMOQueueBot (CEO) → Paperclip decomposes → al-Jazari executes → PR |
| Skill routing matrix | [architecture/skill-router-matrix.md](architecture/skill-router-matrix.md) | 123 skills mapped to agent roles |
| API reference | [architecture/api-reference.md](architecture/api-reference.md) | Internal APIs between layers |
| Data governance | [architecture/data-governance.md](architecture/data-governance.md) | Data handling, privacy, retention |
| Security decisions | [architecture/security-decisions.md](architecture/security-decisions.md) | Auth, secrets, access control decisions |

## Architecture Decision Records (ADRs)

| ADR | File | Decision |
|-----|------|----------|
| Full index | [architecture/adr/ADR-index.md](architecture/adr/ADR-index.md) | Master list of all ADRs |
| ADR-001 | [architecture/adr/ADR-001-sqlite-vs-postgresql.md](architecture/adr/ADR-001-sqlite-vs-postgresql.md) | SQLite vs PostgreSQL |
| ADR-006 | [architecture/adr/ADR-006-parallel-execution-remote-control.md](architecture/adr/ADR-006-parallel-execution-remote-control.md) | Parallel execution + remote control |
| ADR-007 | [architecture/adr/ADR-007-ai-native-org-agent-sdk.md](architecture/adr/ADR-007-ai-native-org-agent-sdk.md) | Agent SDK choice |
| ADR-008 | [architecture/adr/ADR-008-superpowers-engineering-methodology.md](architecture/adr/ADR-008-superpowers-engineering-methodology.md) | Superpowers engineering methodology |
| ADR-009 | [architecture/adr/ADR-009-gstack-ceo-qa-methodology.md](architecture/adr/ADR-009-gstack-ceo-qa-methodology.md) | Gstack CEO/QA methodology |
| ADR-010 | [architecture/adr/ADR-010-keep-openclaw-defer-hermes.md](architecture/adr/ADR-010-keep-openclaw-defer-hermes.md) | Keep OpenClaw, defer Hermes |
| ADR-011 | [architecture/adr/ADR-011-multi-deployment-architecture.md](architecture/adr/ADR-011-multi-deployment-architecture.md) | Multi-deployment architecture |
| ADR-012 | [architecture/adr/ADR-012-paperclip-on-smo-brain.md](architecture/adr/ADR-012-paperclip-on-smo-brain.md) | Paperclip on smo-brain |
| ADR-013 | [architecture/adr/ADR-013-minimax-m2.7-for-openclaw.md](architecture/adr/ADR-013-minimax-m2.7-for-openclaw.md) | MiniMax M2.7 for OpenClaw |
| ADR-014 | [architecture/adr/ADR-014-three-layer-orchestration.md](architecture/adr/ADR-014-three-layer-orchestration.md) | Three-layer orchestration |
| ADR-015 | [architecture/adr/ADR-015-openclaw-gateway-adapter.md](architecture/adr/ADR-015-openclaw-gateway-adapter.md) | OpenClaw gateway adapter |

## Agent Roles

| Role | File |
|------|------|
| VP Engineering (al-Jazari) | [roles/vp-engineering.md](roles/vp-engineering.md) |
| QA Lead | [roles/qa-lead.md](roles/qa-lead.md) |
| DevOps | [roles/devops.md](roles/devops.md) |
| Content Lead | [roles/content-lead.md](roles/content-lead.md) |
| Data Engineer | [roles/data-engineer.md](roles/data-engineer.md) |
| GTM Specialist | [roles/gtm-specialist.md](roles/gtm-specialist.md) |

## Infrastructure

| Topic | File | When to use |
|-------|------|-------------|
| OpenClaw multi-node setup | [infrastructure/openclaw-multi-node-setup.md](infrastructure/openclaw-multi-node-setup.md) | Setting up OpenClaw across nodes |
| OpenClaw execution guide | [infrastructure/openclaw-multinode-execution-guide.md](infrastructure/openclaw-multinode-execution-guide.md) | Running agents across nodes |
| OpenClaw execution results | [infrastructure/openclaw-multinode-execution-results.md](infrastructure/openclaw-multinode-execution-results.md) | Test results from multi-node runs |
| Queue + OpenClaw integration | [infrastructure/openclaw-queue-integration-plan.md](infrastructure/openclaw-queue-integration-plan.md) | How queue engine connects to OpenClaw |
| n8n federation | [infrastructure/n8n-federation-plan.md](infrastructure/n8n-federation-plan.md) | n8n workflow distribution across nodes |
| Deployment guide | [infrastructure/deployment-guide-step1.md](infrastructure/deployment-guide-step1.md) | Step-by-step deployment |
| Build progress | [infrastructure/build-progress-2026-04-01.md](infrastructure/build-progress-2026-04-01.md) | What's operational right now |

## Execution Plans & Sprints

| Topic | File | Status |
|-------|------|--------|
| Soak test plan (v3) | [execution/execution-plan-v3-2026-03-30.md](execution/execution-plan-v3-2026-03-30.md) | CURRENT |
| Agent test use cases | [execution/openclaw-agent-test-usecase.md](execution/openclaw-agent-test-usecase.md) | E2E test flows |
| Sprint 1 | [execution/sprint1-2026-03-30.md](execution/sprint1-2026-03-30.md) | First sprint |
| Execution plan v1 | [execution/archive/execution-plan-v1.md](execution/archive/execution-plan-v1.md) | SUPERSEDED |
| Execution plan v2 | [execution/archive/execution-plan-v2.md](execution/archive/execution-plan-v2.md) | SUPERSEDED |

## Projects

### Email Verification (L1-L2 COMPLETE)
| File | What |
|------|------|
| [projects/email-verification/BRD-email-verification-l1-l2.md](projects/email-verification/BRD-email-verification-l1-l2.md) | Business Requirements Document |
| [projects/email-verification/email-verification-plan.md](projects/email-verification/email-verification-plan.md) | Implementation plan |
| [projects/email-verification/claude-code-build-plan.md](projects/email-verification/claude-code-build-plan.md) | Claude Code execution plan |
| [projects/email-verification/email-verification-testing-guide-2026-04.md](projects/email-verification/email-verification-testing-guide-2026-04.md) | Testing guide |

### CC Intelligence Scorecard (NOT BUILT)
| File | What |
|------|------|
| [projects/scorecard-cc/](projects/scorecard-cc/) | BRD (.docx), mockup, schema, template, sample data |

### Super AI Operator Platform
| File | What |
|------|------|
| [projects/super-operator/super-coder-launcher-BRD-v1.2.md](projects/super-operator/super-coder-launcher-BRD-v1.2.md) | BRD v1.2 (current) |
| [projects/super-operator/super-coder-launcher-blueprint.md](projects/super-operator/super-coder-launcher-blueprint.md) | Technical blueprint |
| [projects/super-operator/vibemicrosaas-execution-plan-v1.md](projects/super-operator/vibemicrosaas-execution-plan-v1.md) | Execution plan |
| [projects/super-operator/Super AI.md](projects/super-operator/Super%20AI.md) | Vision doc |
| [projects/super-operator/super-operator-audit-context.md](projects/super-operator/super-operator-audit-context.md) | Audit context |
| [projects/super-operator/MicroSaaS Launcher Tech Audit.md](projects/super-operator/MicroSaaS%20Launcher%20Tech%20Audit.md) | Tech audit |
| [projects/super-operator/claude-code-repo-audit-instructions.md](projects/super-operator/claude-code-repo-audit-instructions.md) | Repo audit instructions |
| [projects/super-operator/CLAUDE-AUDIT.md](projects/super-operator/CLAUDE-AUDIT.md) | Claude audit findings |

### Queue Engine
| File | What |
|------|------|
| [projects/queue-engine/README.md](projects/queue-engine/README.md) | Overview |
| [projects/queue-engine/phase-0-results.md](projects/queue-engine/phase-0-results.md) | Phase 0 test results |
| Build scripts | `add-task.sh`, `classify-task.sh`, `create-pr.sh`, `db.sh`, `decompose-brd.sh`, `dispatch.sh`, `health-check.sh`, `notify-ceo.sh`, `paperclip-sync.sh`, `queue-approve.sh`, `queue-status.sh`, `score-task.sh`, `task-complete.sh` |
| Config | `routing-sop.yaml`, `executor-workflow.json`, `queue-schema.sql` |

### SSE V3 — Signal Sales Engine (SOAK TEST)
| What | Location |
|------|----------|
| Requirements (11 spec files) | `~/Desktop/cowork-workspace/smorch-context/SalesMfastGTM/Project6-SSEngineTech/` |
| Code repo | `Signal-Sales-Engine` on smo-dev (branch: `dev`) |
| Purpose | AI-Native Org soak test — first real project through BRD pipeline |

## Scoring Systems

| System | Path | What |
|--------|------|------|
| Dev scoring guide | [scoring/smorch-dev-scoring-guide.md](scoring/smorch-dev-scoring-guide.md) | How dev quality scoring works |
| Dev scoring report | [scoring/dev-scoring/SCORING-REPORT.md](scoring/dev-scoring/SCORING-REPORT.md) | Latest scoring results |
| Dev scoring skills | [scoring/dev-scoring/](scoring/dev-scoring/) | Architecture, engineering, QA, UX, product, composite, gap-bridger scorers |
| GTM scoring skills | [scoring/gtm-scoring/](scoring/gtm-scoring/) | Campaign, copywriting, LinkedIn, YouTube, social, offer-positioning scorers |

**Dev scoring commands:** `bridge-gaps`, `calibrate`, `score-hat`, `score-project` (in `scoring/dev-scoring/commands/`)
**GTM scoring commands:** `score`, `score-all`, `score-report` (in `scoring/gtm-scoring/commands/`)

## Skills & Distribution

| Topic | File |
|-------|------|
| Skill creation SOP | [skills/skill-creation-sop.md](skills/skill-creation-sop.md) |
| Skill management SOP | [skills/skill-management-sop.md](skills/skill-management-sop.md) |
| Distribution guide | [skills/smorch-skills-distribution-guide.md](skills/smorch-skills-distribution-guide.md) |
| Distribution plan | [skills/smorch-skills-distribution-plan-2026-03.md](skills/smorch-skills-distribution-plan-2026-03.md) |
| Plugin migration | [skills/plugin-migration-guide.md](skills/plugin-migration-guide.md) |
| Server alignment | [skills/server-alignment-instructions.md](skills/server-alignment-instructions.md) |
| Team operations guide | [skills/team-operations-guide.md](skills/team-operations-guide.md) |
| BRD decomposer skill | [skills/brd-decomposer/SKILL.md](skills/brd-decomposer/SKILL.md) |
| Campaign guide skill | [skills/campaign-guide/SKILL.md](skills/campaign-guide/SKILL.md) |
| Linear operator skill | [skills/linear-operator/SKILL.md](skills/linear-operator/SKILL.md) |

## Onboarding & Team

| Topic | File |
|-------|------|
| Team operating rules | [onboarding/team-operating-rules.md](onboarding/team-operating-rules.md) |
| Human engineer role | [onboarding/human-engineer-role.md](onboarding/human-engineer-role.md) |
| Claude Code onboarding | [onboarding/claude-code-onboarding-guide.md](onboarding/claude-code-onboarding-guide.md) |
| Lana onboarding guide | [onboarding/lana-onboarding-guide.md](onboarding/lana-onboarding-guide.md) |
| GitHub seat decision | [onboarding/github-seat-decision-lana.md](onboarding/github-seat-decision-lana.md) |
| Team profiles | [onboarding/team-profiles/](onboarding/team-profiles/) |

**Team members:** [mamoun-founder](onboarding/team-profiles/mamoun-founder.md), [lana-engineer](onboarding/team-profiles/lana-engineer.md), [nour-content-support](onboarding/team-profiles/nour-content-support.md), [razan-training-lead](onboarding/team-profiles/razan-training-lead.md), [ruba-campaign-architect](onboarding/team-profiles/ruba-campaign-architect.md)

## Guides & Best Practices

| Topic | File |
|-------|------|
| AI-Native GitHub reference | [guides/ai-native-github-reference-guide.md](guides/ai-native-github-reference-guide.md) |
| GitHub best practices | [guides/ai-native-github-best-practices.md](guides/ai-native-github-best-practices.md) |
| Claude 50 best practices | [guides/claude-50-best-practices.md](guides/claude-50-best-practices.md) |
| NL Claude Code guide | [guides/NLClaudeCode.md](guides/NLClaudeCode.md) |
| GitHub agentic workflows | [guides/github-agentic-workflows-evaluation.md](guides/github-agentic-workflows-evaluation.md) |
| IP protection runbook | [guides/ip-protection-runbook.md](guides/ip-protection-runbook.md) |
| SaaSfast gating SOP | [guides/saasfast-gating-sop.md](guides/saasfast-gating-sop.md) |

## Research

| Topic | File |
|-------|------|
| OpenClaw deep research | [research/openclaw-orchestration-deep-research.md](research/openclaw-orchestration-deep-research.md) |
| Paperclip deep research | [research/paperclip-deep-research.md](research/paperclip-deep-research.md) |
| GitHub audit & action plan | [research/github-audit-and-action-plan.md](research/github-audit-and-action-plan.md) |
| AI-Native deep audit | [research/ai-native-deep-audit-findings.md](research/ai-native-deep-audit-findings.md) |

## Content Marketing

| Topic | File |
|-------|------|
| Content sprint plan | [content/social/content-sprint-2026-03-28.md](content/social/content-sprint-2026-03-28.md) |
| LinkedIn: AI-Native GitHub guide | [content/social/linkedin-article-ai-native-github-guide-2026-03.md](content/social/linkedin-article-ai-native-github-guide-2026-03.md) |
| LinkedIn: Claude 50 best practices | [content/social/linkedin-article-claude-50-best-practices-2026-03.md](content/social/linkedin-article-claude-50-best-practices-2026-03.md) |
| LinkedIn carousel: both guides | [content/social/linkedin-carousel-both-guides-2026-03.md](content/social/linkedin-carousel-both-guides-2026-03.md) |

## Audit Reports

| Report | File |
|--------|------|
| Weekly audit 2026-03-29 | [audit-reports/weekly-audit-2026-03-29.md](audit-reports/weekly-audit-2026-03-29.md) |
