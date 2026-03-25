# EO MicroSaaS OS - Journey Map

## Visual Flow

```
ENTRY POINTS
=============
    [Scorecard Results]          [Manual Templates]
    (SC1-SC5 .md files)          (8 brain templates)
           |                            |
           v                            v
    +---------------------------------+
    |     STEP 1: BRAIN INGESTION     |
    |     eo-brain-ingestion          |
    |     Input: 5 scorecards OR      |
    |            8 filled templates    |
    |     Output: 12 brain files      |
    +---------------------------------+
                    |
        +-----------+-----------+
        v                       v
+-------------------+  +-------------------+
| STEP 2: GTM       |  | STEP 3: SKILL     |
| ASSETS            |  | EXTRACTION        |
| eo-gtm-asset-     |  | eo-skill-         |
| factory           |  | extractor         |
| Output: Campaign  |  | Output: Tool      |
| asset bundles     |  | operator skills   |
+-------------------+  +-------------------+
        |                       |
        +-----------+-----------+
                    |
                    v
    +---------------------------------+
    |   STEP 4: TECH ARCHITECTURE     |
    |   eo-tech-architect             |
    |   (runs in Cowork)              |
    |   Output: BRD + 3 arch docs     |
    |           + CLAUDE.md           |
    |           + MCP setup list      |
    +---------------------------------+
                    |
                    v
    +---------------------------------+
    |   GRADUATION (/eo-graduate)     |
    |   Handoff package includes:     |
    |   - CLAUDE.md (root level)      |
    |   - project-brain/ (12 files)   |
    |   - architecture/ (4 docs)      |
    |   - scorecards/ (SC1-SC5)       |
    +---------------------------------+
                    |
    ======= PHASE TRANSITION =======
    Install MCPs from plan
    Copy handoff to Claude Code dir
    =================================
                    |
                    v
    +---------------------------------+
    |   STEP 5: DEVELOPMENT PIPELINE  |
    |   (Claude Code reads CLAUDE.md  |
    |    automatically on startup)    |
    +---------------------------------+
        |
        v
    [5a] eo-db-architect
        Database schema, migrations, RLS
        |
        v
    [5b] eo-microsaas-dev
        Application code, 5-phase build
        |
        v
    [5c] eo-api-connector
        Third-party integrations
        |
        v
    [5d] eo-qa-testing -----> MUST PASS
        Code quality, functional, UX
        |
        v
    [5e] eo-security-hardener -> MUST PASS (zero CRITICAL)
        7-domain security audit
        |
        v
    [5f] eo-deploy-infra
        Docker, CI/CD, go live
        |
        v
    [LIVE PRODUCT]
```

## Quality Gates

```
Gate 0: Scorecards/Templates ---> Brain Ingestion
  REQUIRES: SC1+SC2 uploaded OR 8 templates filled

Gate 1: Brain Files ---> GTM/Architecture
  REQUIRES: 12 brain files with 200+ chars each

Gate 2: Architecture + CLAUDE.md ---> Graduation/Dev
  REQUIRES: brd.md + tech-stack-decision.md + CLAUDE.md

Gate 3: Code ---> QA
  REQUIRES: 5+ source files in src/

Gate 4: QA ---> Security
  REQUIRES: qa-report.md with PASS status

Gate 5: Security ---> Deploy
  REQUIRES: security-audit.md with zero CRITICAL
```

## Time Estimates

| Step | Estimated Time | Environment |
|------|---------------|-------------|
| Step 0: Scorecards | 2-4 hours | Web browser |
| Step 1: Brain Ingestion | 30-60 minutes | Cowork |
| Step 2: GTM Assets | 1-2 hours | Cowork |
| Step 3: Skill Extraction | 1-2 hours | Cowork |
| Step 4: Architecture | 1-2 hours | Cowork |
| Step G: Graduation | 10-15 minutes | Cowork |
| MCP Setup | 15-30 minutes | Local machine |
| Step 5a: Database | 30-60 minutes | Claude Code |
| Step 5b: App Build | 2-6 hours | Claude Code |
| Step 5c: API Integration | 1-3 hours | Claude Code |
| Step 5d: QA | 1-2 hours | Claude Code |
| Step 5e: Security | 30-60 minutes | Claude Code |
| Step 5f: Deploy | 1-2 hours | Claude Code |
| **TOTAL** | **10-24 hours** | |

## Parallel Paths

Steps 2 and 3 can run in parallel (both only need brain files).
Step 4 requires brain files (Gate 1) but can start before Steps 2-3 finish.
Steps 5a-5c are sequential but 5b calls 5a and 5c internally.
Steps 5d, 5e, 5f are strictly sequential (each gates the next).
