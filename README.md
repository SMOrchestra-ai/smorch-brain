# SMOrchestra AI Brain

Complete skill library and plugin system for SMOrchestra.ai GTM operations.

## What's Inside

```
skills/              # 62 Cowork/Claude Code skills
  signal-to-trust-gtm/
  ghl-operator/
  n8n-architect/
  instantly-operator/
  heyreach-operator/
  clay-operator/
  positioning-engine/
  ... (62 total)

plugins/
  smorch-gtm-engine/   # Signal-to-Trust GTM plugin (13 skills + commands)
  eo-microsaas-os/     # EO MicroSaaS OS plugin (scorecards + dev pipeline)

CLAUDE.md              # Global behavior instructions
```

## Setup: Claude Code

### Option 1: Skills in Claude Code (recommended)

```bash
# Clone this repo
git clone git@github.com:YOUR_USER/smorch-brain.git

# Copy skills to Claude Code's global skill directory
cp -r smorch-brain/skills/* ~/.claude/skills/

# Copy your CLAUDE.md
cp smorch-brain/CLAUDE.md ~/.claude/CLAUDE.md
```

Skills will be available as slash commands: `/signal-to-trust-gtm`, `/ghl-operator`, etc.

### Option 2: Project-level skills

```bash
# In any project directory
mkdir -p .claude/skills
cp -r smorch-brain/skills/* .claude/skills/
cp smorch-brain/CLAUDE.md .claude/CLAUDE.md
```

### Plugins in Claude Code

```bash
# Install plugins locally
claude plugin add ./plugins/smorch-gtm-engine
claude plugin add ./plugins/eo-microsaas-os
```

## Setup: Cowork (Claude Desktop)

Skills and plugins are automatically loaded when placed in the Cowork workspace's `.skills/` and `.local-plugins/` directories.

## Skill Categories

### GTM Engine (Signal-to-Trust)
- `signal-to-trust-gtm` - Master orchestrator
- `signal-detector` - ICP validation + signal classification
- `wedge-generator` - Signal-to-wedge conversion
- `asset-factory` - Multi-channel sequence production
- `campaign-strategist` - Q>M>W>D hierarchy alignment
- `positioning-engine` - April Dunford + Hormozi + Brunson synthesis
- `outbound-orchestrator` - Cross-channel campaign coordination

### Tool Operators
- `ghl-operator` - GoHighLevel/SalesMfast CRM
- `instantly-operator` - Cold email campaigns
- `heyreach-operator` - LinkedIn outbound
- `clay-operator` - Enrichment + waterfall
- `n8n-architect` - Workflow automation
- `scraper-layer` - Signal ingestion (Apify/Firecrawl/Playwright)
- `smorch-salesnav-operator` - Sales Navigator browser ops
- `smorch-linkedin-intel` - LinkedIn content signal monitoring

### EO Training System
- `eo-brain-ingestion` - Scorecard processing
- `eo-gtm-asset-factory` - GTM asset bundles
- `eo-skill-extractor` - Skill creation teaching
- `eo-tech-architect` - Tech stack decisions
- `eo-microsaas-dev` - MicroSaaS build pipeline
- `eo-db-architect` / `eo-api-connector` / `eo-qa-testing` / `eo-security-hardener` / `eo-deploy-infra`

### Scoring Engines (5 scorecards)
1. `project-definition-scoring-engine`
2. `icp-clarity-scoring-engine`
3. `market-attractiveness-scoring-engine`
4. `strategy-selector-engine`
5. `gtm-fitness-scoring-engine`

### Content + Education
- `eo-youtube-mamoun` - YouTube deck builder (bilingual)
- `eo-training-factory` - Complete training product builder
- `smorch-perfect-webinar` - Webinar campaign bundles
- `content-systems` - Content production framework
- `movement-builder` - Brunson movement framework
- `engagement-engine` - Hook Model + Pattern Interrupts
- `validation-sprint` - Rapid validation methodology

### Meta/Utility
- `smo-skill-creator` - Create new skills
- `smorch-tool-super-admin-creator` - Tool operator skill builder
- `smo-offer-assets` - Offer asset factory (landing page + deck + one-pager)
- `get-api-docs` - API documentation fetcher

---

Built by Mamoun Alamouri / SMOrchestra.ai
