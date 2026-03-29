# DRIFT AUDIT REPORT — 2026-03-28

## Summary

| Metric | Count |
|---|---|
| Total unique source skill names | 86 |
| Total unique deployed skill names | 52 |
| Matching (no drift) | 1 |
| Drifted (source != deployed) | 12 |
| Missing deployments (source only) | 73 |
| Orphaned deployments (deployed only, no source) | 39 |

---

## Drifted Skills (12)

These skills exist in both source (.remote-plugins) and deployed (.local-plugins/cache) but have different content. The deployed versions in `.local-plugins/cache/local-desktop-app-uploads/smorch-gtm-engine/1.0.0/` are all dated 2026-02-25, while source versions are from late March 2026.

### HIGH PRIORITY (large delta, core GTM skills)

| Skill | Source Size | Deployed Size | Delta | Source Date | Notes |
|---|---|---|---|---|---|
| **signal-to-trust-gtm** | 6,673b | 32,056b | -25,383b | 2026-03-27 | Source was massively refactored/split. Deployed has monolithic version. |
| **wedge-generator** | 4,944b | 20,870b | -15,926b | 2026-03-27 | Source was refactored/split. Deployed has old monolithic version. |
| **signal-detector** | 5,347b | 19,327b | -13,980b | 2026-03-27 | Source was refactored/split. Deployed has old monolithic version. |
| **positioning-engine** | 20,292b | 11,600b | +8,692b | 2026-03-27 | Source expanded significantly vs deployed. |

### MEDIUM PRIORITY (moderate delta, operator skills)

| Skill | Source Size | Deployed Size | Delta | Source Date | Notes |
|---|---|---|---|---|---|
| **asset-factory** | 17,167b | 16,334b | +833b | 2026-03-27 | Minor content additions. |
| **campaign-strategist** | 16,807b | 16,281b | +526b | 2026-03-27 | Minor content additions. |
| **clay-operator** | 10,874b | 11,309b | -435b | 2026-03-27 | Source slightly smaller (cleanup). |
| **ghl-operator** | 15,982b | 16,358b | -376b | 2026-03-27 | Source slightly smaller (cleanup). |
| **heyreach-operator** | 18,742b | 19,037b | -295b | 2026-03-27 | Source slightly smaller (cleanup). |
| **instantly-operator** | 18,058b | 18,459b | -401b | 2026-03-27 | Source slightly smaller (cleanup). |
| **n8n-architect** | 19,863b | 20,198b | -335b | 2026-03-25 | Source slightly smaller (cleanup). |
| **outbound-orchestrator** | 19,167b | 19,192b | -25b | 2026-03-27 | Near-identical, trivial diff. |

### Source Paths (drifted)
- `.remote-plugins/plugin_01WfqJDLDqASHbFYKWEmNhN1/skills/` — smorch-gtm-engine skills
- `.remote-plugins/plugin_01QMhq2ngxJVHtFJxaAteTf8/skills/` — smorch-gtm-tools skills
- `.remote-plugins/plugin_0167cibTauF3GWSpKsmdEiMP/skills/` — smorch-dev skills

### Deployed Path (all drifted)
- `.local-plugins/cache/local-desktop-app-uploads/smorch-gtm-engine/1.0.0/skills/`

---

## Matching Skills (1)

Only **scraper-layer** has identical content between source and deployed.

---

## Missing Deployments (73)

These skills exist in source (.claude/skills or .remote-plugins) but have NO corresponding deployed version in .local-plugins/cache. This is expected for most skills because they are loaded directly from .claude/skills and .remote-plugins at runtime, NOT through the local cache. Only the `smorch-gtm-engine` plugin had a separate local-desktop-app-uploads cache entry.

### Categorized by Plugin

**Core Cowork Skills (.claude/skills) — 16 skills, no local cache expected:**
algorithmic-art, brand-guidelines, canvas-design, doc-coauthoring, docx, frontend-design, internal-comms, mcp-builder, pdf, pptx, schedule, skill-creator, theme-factory, using-superpowers, web-artifacts-builder, xlsx

**smorch-gtm-engine (plugin_01WfqJDLDqASHbFYKWEmNhN1) — 5 skills without cache:**
campaign-guide, lead-research-assistant, smorch-linkedin-intel, smorch-perfect-webinar, smorch-skill-creator

**smorch-gtm-tools (plugin_01QMhq2ngxJVHtFJxaAteTf8) — 2 skills without cache:**
linear-operator, smorch-tool-super-admin-creator

**smorch-dev (plugin_0167cibTauF3GWSpKsmdEiMP) — 10 skills, no local cache:**
get-api-docs, mcp-builder, n8n-architect (has drifted cache entry), receiving-code-review, requesting-code-review, smo-skill-creator, smorch-tool-super-admin-creator, systematic-debugging, validation-sprint, webapp-testing

**smorch-gtm-scoring (plugin_018nKcJt36AjqATBPLqzJ4VT) — 7 skills:**
campaign-strategy-scorer, copywriting-scorer, linkedin-branding-scorer, offer-positioning-scorer, scoring-orchestrator, social-media-scorer, youtube-scorer

**smorch-dev-scoring (plugin_01LiJ5Q62D24fvufsyBcUSRn) — 7 skills:**
architecture-scorer, composite-scorer, engineering-scorer, gap-bridger, product-scorer, qa-scorer, ux-frontend-scorer

**eo-scoring-suite (plugin_01G52P93GMP65CCjg8TXPpCS) — 5 skills:**
gtm-fitness-scoring-engine, icp-clarity-scoring-engine, market-attractiveness-scoring-engine, project-definition-scoring-engine, strategy-selector-engine

**eo-microsaas-os (plugin_01Apx5EQXXDjHJqG9GcFuDV3) — 11 skills:**
eo-api-connector, eo-brain-ingestion, eo-db-architect, eo-deploy-infra, eo-gtm-asset-factory, eo-guide, eo-microsaas-dev, eo-os-navigator, eo-production-renderer, eo-qa-testing, eo-security-hardener, eo-skill-extractor, eo-tech-architect

**smorch-context-brain (plugin_01SjgYZY9kdv6brMFuveMqyS) — 2 skills:**
smorch-about-me, smorch-project-brain

**smorch-design (plugin_01GYJRhZ1aTvYQ8vLovPhKDf) — 3 skills (beyond those with source duplicates):**
smorch-brand-system (+ canvas-design, doc-coauthoring, frontend-design, web-artifacts-builder duplicated from .claude/skills)

**mamoun-personal-branding (plugin_01F1aKj7SCPeEYFSEfxQTSAg) — 6 skills:**
content-systems, engagement-engine, eo-youtube-mamoun, linkedin-ar-creator, linkedin-en-gtm, movement-builder

**eo-training-factory (plugin_01MN3nbABN47SZT4Uys6veK9) — 1 skill:**
eo-training-factory

---

## Orphaned Deployments (39 unique skill names)

These skills exist in `.local-plugins/cache/knowledge-work-plugins/` (Anthropic marketplace plugins) but have no corresponding source in `.claude/skills` or `.remote-plugins`. This is EXPECTED behavior: these are Anthropic-provided marketplace plugins (sales, marketing, engineering, design, data, product-management, productivity, cowork-plugin-management) that are managed by Anthropic, not by the smorch-brain source.

**Not actionable** — these are third-party plugins and do not require source tracking in smorch-brain.

Unique orphaned skill names: accessibility-review, account-research, brand-voice, call-prep, campaign-planning, code-review, competitive-analysis (x2 plugins), competitive-intelligence, content-creation, cowork-plugin-customizer, create-an-asset, create-cowork-plugin, daily-briefing, data-context-extractor, data-exploration, data-validation, data-visualization, design-critique, design-handoff, design-system-management, documentation, draft-outreach, feature-spec, incident-response, interactive-dashboard-builder, memory-management, metrics-tracking, performance-analytics, roadmap-management, sql-queries, stakeholder-comms, statistical-analysis, system-design, task-management, tech-debt, testing-strategy, user-research, user-research-synthesis, ux-writing

---

## Key Findings & Recommended Actions

### 1. STALE LOCAL CACHE (Critical)
The `local-desktop-app-uploads/smorch-gtm-engine/1.0.0/` cache is frozen at 2026-02-25. All 13 skills in this cache (12 drifted + 1 matching) are 30+ days behind the .remote-plugins source. This cache appears to be a leftover from a manual plugin upload and is no longer the active deployment path.

**Action:** Verify whether the local-desktop-app-uploads cache is still being read at runtime. If .remote-plugins takes precedence (which it should), consider deleting the stale cache to prevent confusion.

### 2. MAJOR REFACTORING DETECTED
signal-to-trust-gtm, wedge-generator, and signal-detector were dramatically refactored (reduced by 14-25KB each in source). This suggests these skills were split into multiple smaller skills following the progressive disclosure pattern. The deployed cache still has the old monolithic versions.

**Action:** Confirm the refactored source versions are loading correctly from .remote-plugins. If the old monolithic versions in the cache are loading instead, this is actively breaking skill behavior.

### 3. POSITIONING-ENGINE EXPANDED
positioning-engine grew by ~8.7KB in source (11.6KB to 20.3KB), suggesting significant new content was added.

**Action:** No action needed if .remote-plugins loads correctly. Just confirms active development on this skill.

---

## Quality Gate

| Check | Result |
|---|---|
| Scanned ALL plugin directories? | YES (.claude/skills, .remote-plugins/*, .local-plugins/cache/*) |
| Excluded whitespace-only changes? | YES (hash computed after stripping trailing whitespace) |
| Report is actionable? | YES (each drifted item has paths, sizes, dates, and recommended action) |

---

*Generated automatically by smorch-daily-audit scheduled task.*
