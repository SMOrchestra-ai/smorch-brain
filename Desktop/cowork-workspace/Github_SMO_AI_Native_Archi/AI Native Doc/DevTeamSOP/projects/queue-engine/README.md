# AI-Native Organization — Build Artifacts

**Project:** Autonomous AI-Native Development Organization
**Plan:** `../AI-Native-Org/bulletproof-implementation-plan-ai-native-org-2026-03.docx`
**Status:** Phase 0 — Prerequisites Verification

## Folder Structure

```
AI-Native-Build/
├── README.md                     ← This file
├── phase-0-results.md            ← Prerequisites verification results
├── phase-0-fixes.sh              ← Script to fix all Phase 0 blockers
├── queue-schema.sql              ← SQLite queue database schema (Phase 1)
├── routing-sop.yaml              ← Claude Code vs Codex routing policy
├── classify-task.sh              ← Task complexity scorer + tier router
├── dispatch.sh                   ← Enhanced dispatcher with skills + tiers
├── n8n-workflows/                ← n8n workflow JSON exports (Phase 2-3)
└── scripts/                      ← Operational scripts
```

## Quick Start

1. Review `phase-0-results.md` for current state
2. Run `phase-0-fixes.sh` on each node to fix blockers
3. Proceed to Phase 1 (SQLite queue creation)
