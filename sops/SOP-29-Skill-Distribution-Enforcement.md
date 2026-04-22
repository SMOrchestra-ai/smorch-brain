# SOP-13: Skill/Plugin/Template/Context Distribution & Enforcement

**Version:** 1.0
**Date:** 2026-04-17
**Owner:** Mamoun Alamouri
**Scope:** All projects that consume skills, plugins, templates, or context files
**Enforcement:** Automated — CI blocks merge if skill manifest doesn't match
**Goal:** Every machine (dev, QA, server) has exactly the right skills at the right version. No bloat, no missing, no drift.

---

## The Problem This Solves

Without enforcement:
- Developer has skill v1.0, server has v0.9, QA has v1.1
- New skills get added but old ones never removed → bloat
- Skills get edited on the server directly → untraceable drift
- Projects inherit skills they don't need → slow startup, confusing context

---

## Architecture: Three Sources of Truth

```
┌─────────────────────────────────────────────────────────┐
│                  smorch-brain/skills/                     │
│          SHARED skills (cross-project reusable)           │
│  Used by: content-automation, future projects             │
│  Distribution: smorch push → .claude/skills/              │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────┐
│           eo-assessment-system/                           │
│    EO-SPECIFIC skills (scoring engines, HTML scorecards)  │
│  Used by: EO-Scorecard-Platform only                      │
│  Distribution: deploy script copies skills/ to server     │
└─────────────────────┼───────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────┐
│         {project}/.claude/skills/                         │
│   PROJECT-LOCAL skills (not shared, project-specific)     │
│  Used by: that project only                               │
│  Distribution: committed in repo, deployed with code      │
└─────────────────────────────────────────────────────────┘
```

---

## The Manifest Lock System

Every project that uses skills MUST have a `skills.lock.json` at its root:

```json
{
  "$schema": "https://smorchestra.ai/schemas/skills-lock-v1.json",
  "project": "eo-scorecard-platform",
  "updated": "2026-04-17T12:00:00Z",
  "sources": {
    "eo-assessment-system": {
      "repo": "SMOrchestra-ai/eo-assessment-system",
      "branch": "v2-arabic",
      "commit": "eb1f66b"
    }
  },
  "skills": [
    {
      "id": "project-definition-scoring-engine",
      "source": "eo-assessment-system",
      "version": "1.0.0",
      "sha": "abc1234",
      "entrypoint": "SKILL.md",
      "references": 4,
      "model": "sonnet"
    },
    {
      "id": "icp-clarity-scoring-engine",
      "source": "eo-assessment-system",
      "version": "1.0.0",
      "sha": "def5678",
      "entrypoint": "SKILL.md",
      "references": 4,
      "model": "sonnet"
    }
  ],
  "plugins": [
    {
      "id": "supabase-eo",
      "type": "mcp",
      "required": true
    }
  ],
  "context": [
    {
      "id": "eo-brand-voice",
      "source": "smorch-context",
      "path": "EO/brandvoice.md"
    }
  ]
}
```

### Why this matters:
- CI checks `skills.lock.json` against actual `skills/` directory → blocks merge if mismatch
- Server deploy validates lock before starting app → won't start with wrong skills
- `smorch sync` command reads lock and pulls exactly what's needed — nothing more
- QA can verify: "which skill versions are running?" → `curl /api/health` returns skill versions

---

## Enforcement Points

### 1. CI (GitHub Actions) — blocks merge if skills don't match lock

```yaml
# Added to every repo's ci.yml
- name: Validate skills lock
  run: |
    if [ -f skills.lock.json ]; then
      node scripts/validate-skills-lock.js
    fi
```

### 2. Server startup — app refuses to start if skills mismatch

```typescript
// Added to server.ts / app startup
const lock = JSON.parse(fs.readFileSync('skills.lock.json', 'utf-8'));
for (const skill of lock.skills) {
  const manifestPath = `skills/${skill.id}/manifest.json`;
  if (!fs.existsSync(manifestPath)) {
    throw new Error(`Missing skill: ${skill.id} — run 'smorch sync' first`);
  }
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));
  if (manifest.version !== skill.version) {
    console.warn(`Skill ${skill.id}: expected v${skill.version}, found v${manifest.version}`);
  }
}
```

### 3. Deploy script — syncs skills before build

```bash
# Added to scripts/deploy.sh
echo "Syncing skills from lock..."
if [ -f skills.lock.json ]; then
  node scripts/sync-skills.js
fi
```

### 4. SessionStart hook — warns if local skills are stale

Already in `.claude/settings.json` SessionStart hook. Extended to check:
```bash
# Check skills.lock.json exists and skills/ matches
if [ -f skills.lock.json ]; then
  EXPECTED=$(jq -r '.skills | length' skills.lock.json)
  ACTUAL=$(ls -d skills/*/manifest.json 2>/dev/null | wc -l)
  if [ "$EXPECTED" != "$ACTUAL" ]; then
    WARN="$WARN | SKILLS MISMATCH: lock expects $EXPECTED skills, found $ACTUAL"
  fi
fi
```

---

## Commands

### smorch sync
Reads `skills.lock.json` and pulls exactly the declared skills from their sources:
```bash
smorch sync                    # Sync all skills per lock
smorch sync --check            # Dry run — report mismatches only
smorch sync --update           # Pull latest from sources + update lock
```

### smorch push (existing)
Pushes shared skills from smorch-brain to target projects:
```bash
smorch push                    # Push to all registered targets
smorch push --project eo-mena  # Push to specific project
```

### smorch audit (existing)
Validates skill health:
```bash
smorch audit                   # Check all skills in current project
```

---

## Enforcement Matrix

| Check | Where | When | Blocks? |
|-------|-------|------|---------|
| skills.lock.json exists | CI | PR merge | ✅ Yes (for skill-using repos) |
| skills/ matches lock | CI | PR merge | ✅ Yes |
| Skill manifests valid | CI | PR merge | ✅ Yes |
| Skills present on server | Deploy script | Before build | ✅ Yes (abort deploy) |
| Skill versions match | Server startup | App boot | ⚠️ Warn (don't block prod) |
| Local skills fresh | SessionStart hook | Every session | ⚠️ Warn |

---

## Distribution Flow

### For EO-Scorecard-Platform (server-deployed AI service):

```
eo-assessment-system/     (skill authoring workspace)
    │
    │  Author edits SKILL.md, updates manifest.json
    │  Commits + pushes to GitHub
    │
    ├──► PR merged → CI validates manifest format
    │
    ├──► Developer runs: smorch sync (in EO-Scorecard-Platform)
    │    → Reads skills.lock.json
    │    → Clones specific skills from eo-assessment-system
    │    → Copies to skills/ directory
    │    → Updates lock with new SHA
    │
    ├──► Developer commits updated skills/ + skills.lock.json
    │    → CI validates lock matches skills/
    │
    └──► Deploy to server:
         → scripts/deploy.sh runs smorch sync first
         → npm run build
         → pm2 restart
         → Health endpoint confirms skill versions
```

### For content-automation (Claude Code subprocess):

```
smorch-brain/skills/      (shared skill source)
    │
    ├──► smorch push → content-automation/.claude/skills/
    │
    └──► Deploy to server:
         → git pull (gets latest .claude/skills/)
         → skill-resolver.ts reads from disk
         → claude-md-writer.ts generates CLAUDE.md per task
```

### For dev machines (Claude Code direct):

```
smorch-brain/skills/      (shared skill source)
    │
    ├──► smorch push → ~/.claude/skills/ (global)
    │                → {project}/.claude/skills/ (project-specific)
    │
    └──► SessionStart hook checks skill freshness
```

---

## Per-Project Skill Requirements

| Project | Skills Source | Plugins | Context |
|---------|-------------|---------|---------|
| EO-Scorecard-Platform | eo-assessment-system (5 scoring engines) | supabase-eo MCP | EO brand voice, ICP |
| content-automation | smorch-brain/skills (content generation) | n8n MCP | Brand voice, content calendar |
| EO-MENA | eo-microsaas-plugin (6 build skills) | supabase-eo MCP, GHL MCP | EO project-brain/ |
| Signal-Sales-Engine | TBD (scoring, campaign gen) | supabase MCP, n8n MCP | SSE specs |
| digital-revenue-score | TBD (score generation) | supabase-eo MCP, GHL MCP | DRS rubrics |

---

## Migration Steps (from current state)

1. Create `skills.lock.json` in EO-Scorecard-Platform (already has skills/)
2. Create `scripts/validate-skills-lock.js` validation script
3. Create `scripts/sync-skills.js` sync command
4. Add skill validation step to CI workflows
5. Add skill sync step to deploy scripts
6. Update SessionStart hook to check skills
7. Test full cycle: author → sync → deploy → verify

---

## Anti-Patterns

- ❌ Edit skills directly on the server (use eo-assessment-system repo, commit, deploy)
- ❌ Copy skills manually between machines (use smorch sync)
- ❌ Add skills without updating skills.lock.json (CI will block)
- ❌ Remove skills from lock without removing from skills/ (CI will block)
- ❌ Have skills in a project that aren't declared in the lock (bloat)
- ❌ Deploy without running smorch sync first (may deploy stale skills)
