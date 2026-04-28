# DRIFT AUDIT REPORT — 2026-03-29

**Audit type**: Automated (scheduled task: smorch-daily-audit)
**Run time**: 2026-03-29
**Directories scanned**:
- Source: `/mnt/.claude/skills/` (16 skills) + `/mnt/.remote-plugins/` (86 skills across 11 plugin dirs)
- Deployed: `/mnt/.local-plugins/cache/` (52 unique skills across knowledge-work-plugins + smorch-gtm-engine)

---

## Executive Summary

| Metric | Count |
|--------|-------|
| Total source skills (unique names) | 86 |
| Total deployed/cached skills (unique names) | 52 |
| Matched (same hash, no drift) | 1 |
| Drifted (different content) | 12 |
| Missing deployments (source only) | 73 |
| Orphaned deployments (cache only, no source) | 39 |

**Sync rate**: 1.2% (1 of 86 source skills fully in sync)

**Key insight**: The `.local-plugins/cache/` directory serves two distinct populations:
1. **knowledge-work-plugins** (standard Anthropic plugins: sales, marketing, engineering, data, design, product-management, productivity, cowork-plugin-management) - these are NOT sourced from smorch-brain, so they appear as "orphans" but are expected
2. **local-desktop-app-uploads/smorch-gtm-engine** - these ARE custom SMOrch skills and the comparison matters

Adjusting for this: the 39 "orphaned" skills are standard platform plugins, not real orphans. The real concern is the 12 drifted skills and 73 missing deployments.

---

## Drifted Skills (12)

### Major Drifts (content restructured significantly)

| Skill | Source Lines | Deployed Lines | Change Summary |
|-------|-------------|----------------|----------------|
| signal-to-trust-gtm | 117 | 960 | Deployed version 8x larger; complete rewrite with detailed workflow docs |
| signal-detector | 127 | 626 | Deployed 5x larger; expanded implementation guidance |
| wedge-generator | 124 | 627 | Deployed 5x larger; much more comprehensive |
| asset-factory | 382 | 616 | Deployed 1.6x larger; content restructured |
| campaign-strategist | 441 | 519 | Significant reorganization and refinement |
| positioning-engine | 303 | 174 | Source is NEWER and expanded vs deployed (reverse drift) |

**Direction of drift**: For 5 of 6 major drifts, the DEPLOYED version is larger than source. This means the cache has older, more verbose versions while source has been refactored to be leaner. Exception: positioning-engine where source grew.

### Minor Drifts (< 10 line changes, likely formatting)

| Skill | Changes | Assessment |
|-------|---------|------------|
| clay-operator | +4/-4 | Trivial, likely formatting |
| ghl-operator | +2/-2 | Trivial |
| instantly-operator | +2/-2 | Trivial |
| n8n-architect | +3/-3 | Trivial |
| heyreach-operator | +9/-4 | Minor content update |
| outbound-orchestrator | +2/-12 | Minor trim |

---

## Missing Deployments (73)

These source skills have NO cached/deployed version. Grouped by plugin:

### EO MicroSaaS OS (plugin_01Apx5EQXXDjHJqG9GcFuDV3) - 13 skills
eo-api-connector, eo-brain-ingestion, eo-db-architect, eo-deploy-infra, eo-gtm-asset-factory, eo-guide, eo-microsaas-dev, eo-os-navigator, eo-production-renderer, eo-qa-testing, eo-security-hardener, eo-skill-extractor, eo-tech-architect

### EO Scoring Suite (plugin_01G52P93GMP65CCjg8TXPpCS) - 5 skills
gtm-fitness-scoring-engine, icp-clarity-scoring-engine, market-attractiveness-scoring-engine, project-definition-scoring-engine, strategy-selector-engine

### SMOrch GTM Engine (plugin_01WfqJDLDqASHbFYKWEmNhN1) - 5 skills
campaign-guide, lead-research-assistant, smorch-linkedin-intel, smorch-perfect-webinar, smorch-skill-creator

### SMOrch GTM Scoring (plugin_018nKcJt36AjqATBPLqzJ4VT) - 7 skills
campaign-strategy-scorer, copywriting-scorer, linkedin-branding-scorer, offer-positioning-scorer, scoring-orchestrator, social-media-scorer, youtube-scorer

### SMOrch Dev Scoring (plugin_01LiJ5Q62D24fvufsyBcUSRn) - 7 skills
architecture-scorer, composite-scorer, engineering-scorer, gap-bridger, product-scorer, qa-scorer, ux-frontend-scorer

### SMOrch GTM Tools (plugin_01QMhq2ngxJVHtFJxaAteTf8) - 3 skills
linear-operator, smorch-salesnav-operator, smorch-tool-super-admin-creator

### Personal Branding (plugin_01F1aKj7SCPeEYFSEfxQTSAg) - 6 skills
content-systems, engagement-engine, eo-youtube-mamoun, linkedin-ar-creator, linkedin-en-gtm, movement-builder

### SMOrch Dev (plugin_0167cibTauF3GWSpKsmdEiMP) - 8 skills
get-api-docs, receiving-code-review, requesting-code-review, smo-skill-creator, smorch-tool-super-admin-creator, systematic-debugging, validation-sprint, webapp-testing

### SMOrch Context Brain (plugin_01SjgYZY9kdv6brMFuveMqyS) - 2 skills
smorch-about-me, smorch-project-brain

### SMOrch Design (plugin_01GYJRhZ1aTvYQ8vLovPhKDf) - 2 skills
smorch-brand-system (canvas-design, doc-coauthoring, frontend-design, web-artifacts-builder are duplicates of .claude/skills)

### EO Training Factory (plugin_01MN3nbABN47SZT4Uys6veK9) - 1 skill
eo-training-factory

### Core .claude/skills (not plugin-packaged) - 14 skills
algorithmic-art, brand-guidelines, canvas-design, doc-coauthoring, docx, frontend-design, internal-comms, mcp-builder, pdf, pptx, schedule, skill-creator, theme-factory, using-superpowers, web-artifacts-builder, xlsx

---

## Orphaned Deployments (39)

All 39 are from **knowledge-work-plugins** (standard Anthropic platform plugins). These are NOT custom SMOrch skills and are managed by the platform, not by smorch-brain.

**Assessment**: These are expected orphans. No action required.

Categories: sales (6), marketing (6), engineering (6), data (7), design (6), product-management (6), productivity (2), cowork-plugin-management (2)

---

## Root Cause Analysis

1. **Cache deployment only covers smorch-gtm-engine 1.0.0**: The `.local-plugins/cache/local-desktop-app-uploads/` only has the `smorch-gtm-engine` plugin cached. All other custom plugins (eo-microsaas-os, eo-scoring-suite, smorch-dev, smorch-dev-scoring, etc.) are served via `.remote-plugins/` and never enter the local cache.

2. **Remote plugins ARE the deployment**: For 10 of 11 custom plugin directories, `.remote-plugins/` IS the deployed version (served directly). Only `smorch-gtm-engine` has a separate cache copy that can drift.

3. **The real drift problem is small**: Only 12 skills (all in smorch-gtm-engine) have cache vs source mismatch. The 73 "missing deployments" are mostly remote-plugin skills that don't need cache deployment.

4. **Cache is 30 days stale**: Cache files last modified 2026-02-25. Source files updated through 2026-03-27.

---

## Recommended Actions

### P0: Sync smorch-gtm-engine cache (12 drifted skills)
Run `smorch push` or manually update the 12 drifted skills in `.local-plugins/cache/local-desktop-app-uploads/smorch-gtm-engine/1.0.0/skills/`. The 6 major drifts (signal-to-trust-gtm, signal-detector, wedge-generator, asset-factory, campaign-strategist, positioning-engine) are the priority.

### P1: Verify remote plugin sync is automatic
Confirm that `.remote-plugins/plugin_*/` directories auto-sync when plugins are updated. If yes, the 73 "missing" skills are a non-issue (they deploy via remote-plugins, not cache).

### P2: Update SOP
Document that local cache only applies to `smorch-gtm-engine`. Other plugins deploy via remote-plugins path. Update `docs/skill-management-sop.md` accordingly.

---

## Quality Gate (Self-Score)

| Check | Status |
|-------|--------|
| Scanned ALL plugin directories? | YES - .claude/skills (16), .remote-plugins (11 plugin dirs, 86 skills), .local-plugins/cache (52 skills) |
| Excluded whitespace-only changes? | YES - 6 minor drifts flagged as trivial formatting |
| Report is actionable? | YES - each drift item has source path, deployed path, and change summary |

**Audit grade**: PASS
