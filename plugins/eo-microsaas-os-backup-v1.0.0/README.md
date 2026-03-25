# EO MicroSaaS OS

A complete operating system that walks aspiring entrepreneurs from idea validation to live MicroSaaS product. Built for the Entrepreneurs Oasis (EO) MENA training program.

## What This Plugin Does

Guides founders through a gated 7-step journey across 3 phases:

**Phase 0: Assessment**
0. **Scorecard Assessment** - 5 scorecards (Project Definition, ICP Clarity, Market Attractiveness, Strategy Selector, GTM Fitness) via 4 possible entry paths

**Phase 1: Strategy (Cowork)**
1. **Brain Ingestion** - Converts scorecard results (or manual templates) into 12 structured context files
2. **GTM Asset Factory** - Generates campaign assets matched to your top GTM motions
3. **Skill Extraction** - Teaches you to create Claude operator skills for your SaaS tools

**Phase 2: Build (Claude Code)**
4. **Tech Architecture** - Recommends stack and produces BRD + architecture documents
5. **Development Pipeline** - Database, code, APIs, testing, security, deployment
6. **Go Live** - Docker, CI/CD, production deployment

## Getting Started

### Path A: Web Scorecards (Best Results)
1. Complete the 5 assessments at score.entrepreneursoasis.me
2. Upload your SC1-SC5 markdown result files
3. Run `/eo-score import`, then `/eo`

### Path B: Scoring DOCX Files
1. Upload your scoring Word documents
2. Run `/eo-score docx` to extract and score
3. Run `/eo` to continue

### Path C: Interactive Scorecards (Right Here)
1. Run `/eo-score 1` to start with Project Definition
2. Answer questions interactively (30-60 min per scorecard)
3. Progress through `/eo-score 2` through `/eo-score 5`

### Path D: Manual Templates (Quick Start)
1. Run `/eo-templates` to get 8 brain templates
2. Fill them out (be specific, use real data)
3. Run `/eo` to process them

## Commands

| Command | Description |
|---------|-------------|
| `/eo` | Start or continue your journey |
| `/eo-status` | Check progress and quality gate status |
| `/eo-score [1-5\|import\|docx]` | Run or import scorecard assessments |
| `/eo-templates` | Get 8 brain templates for manual entry |
| `/eo-graduate` | Generate Claude Code handoff package |

## Skills (16 total)

### Orchestrator
| Skill | Purpose |
|-------|---------|
| eo-os-navigator | Master orchestrator, routing, quality gates |

### Assessment (5 scoring engines)
| Skill | Purpose |
|-------|---------|
| project-definition-scoring-engine | SC1: Niche, positioning, MVP scope (100 pts) |
| icp-clarity-scoring-engine | SC2: ICP, pain/pleasure, hero journey (100 pts) |
| market-attractiveness-scoring-engine | SC3: Market size, competition, monetization (100 pts) |
| strategy-selector-engine | SC4: Strategy path + founder archetype (100 pts) |
| gtm-fitness-scoring-engine | SC5: 13 GTM motions + weight matrix (100 pts) |

### Strategy
| Skill | Purpose |
|-------|---------|
| eo-brain-ingestion | Scorecard/template processing into 12 brain files |
| eo-gtm-asset-factory | Campaign asset generation |
| eo-skill-extractor | Tool operator skill creation |

### Build
| Skill | Purpose |
|-------|---------|
| eo-tech-architect | Stack selection + BRD generation |
| eo-db-architect | Database schema + RLS + migrations |
| eo-microsaas-dev | Application code, 5-phase build pipeline |
| eo-api-connector | Third-party API integrations |
| eo-qa-testing | Code quality + functional + UX testing |
| eo-security-hardener | 7-domain security audit |
| eo-deploy-infra | Docker + CI/CD + production deployment |

## Quality Gates (6 Hard Stops)

No gate can be bypassed. No override mechanism.

| Gate | Before | Requires |
|------|--------|----------|
| Gate 0 | Brain Ingestion | SC1+SC2 results OR 8 filled templates |
| Gate 1 | GTM/Architecture | 12 brain files, 200+ chars each |
| Gate 2 | Development | BRD + tech stack decision documents |
| Gate 3 | QA Testing | 5+ source code files |
| Gate 4 | Security | QA report with PASS status |
| Gate 5 | Deployment | Security audit with zero CRITICAL findings |

## Environment Transition

- **Phase 0-1** (Assessment + Strategy): Works in Cowork
- **Phase 2** (Build): Requires Claude Code (terminal, git, npm, docker)
- **Graduation**: Run `/eo-graduate` to generate a portable handoff package with brain files, scorecards, and setup instructions for Claude Code

## Author

Mamoun Alamouri / SMOrchestra.ai
