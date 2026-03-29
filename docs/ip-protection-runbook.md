# IP Protection Runbook — SMOrchestra.ai

**Version:** 1.0 | **Date:** March 2026

---

## Architecture Overview

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│     smorch-brain (PRIVATE)  │     │     smorch-dist (TEAM)      │
│     Mamoun only             │     │     Read-only for team      │
│                             │     │                             │
│  /plugins/ (full source)    │     │  /plugins/ (compiled)       │
│  /skills/ (full source)     │     │  /dist/ (compiled .plugin)  │
│  /scripts/ (all commands)   │────▶│  /scripts/ (pull/list only) │
│  /profiles/ (all)           │     │  /profiles/ (team only)     │
│  /legal/ (agreements)       │     │  /LICENSE.md (dist license) │
│  /CLAUDE.md (founder)       │     │  /CLAUDE.md (team version)  │
│  /claude-dist/ (team md)    │     │                             │
└─────────────────────────────┘     └─────────────────────────────┘
      │                                      │
      │ smorch publish-dist                  │ smorch pull --profile <name>
      │ (compile + strip + push)             │ (team runs this)
      ▼                                      ▼
  Mamoun's machine only              Team machines (read-only)
```

---

## Quick Command Reference

| Task | Command | Who |
|------|---------|-----|
| Scan for unmarked IP | `smorch-add-ip-markers [plugin]` | Mamoun |
| Test what compile strips | `smorch compile --test <plugin>` | Mamoun |
| Compile one plugin | `smorch compile <plugin> <dir>` | Mamoun |
| Compile + publish all | `smorch publish-dist` | Mamoun |
| Preview publish | `smorch publish-dist --dry-run` | Mamoun |
| Setup GitHub teams | `smorch-setup-github-teams` | Mamoun (once) |
| Team pulls updates | `smorch pull --profile <name>` | Team |

---

## Phase 1: Initial Setup (Run Once)

### 1.1 Create smorch-dist repo
```bash
gh repo create SMOrchestra-ai/smorch-dist --private --description "SMOrchestra skill distribution (compiled)"
git clone git@github.com:SMOrchestra-ai/smorch-dist.git ~/Desktop/cowork-workspace/smorch-dist
```

### 1.2 Setup GitHub teams
```bash
bash scripts/smorch-setup-github-teams
```

### 1.3 Get contributor agreements signed
Send `legal/contributor-agreement.md` to all team members. No repo access until signed.

### 1.4 Add IP markers to high-value skills
```bash
# Scan for what needs marking
bash scripts/smorch-add-ip-markers

# Priority order for manual marking:
# 1. smorch-gtm-scoring (scorers + orchestrator — highest IP density)
# 2. smorch-gtm-engine (signal-to-trust, wedge, positioning)
# 3. eo-scoring-suite (5 scoring engines)
# 4. eo-microsaas-os (training methodology)
```

### 1.5 First publish
```bash
smorch publish-dist --dry-run   # Preview
smorch publish-dist             # Publish
```

---

## Phase 2: Team Migration

### For each team member:
1. Verify contributor agreement is signed
2. Remove their access from smorch-brain:
   ```bash
   gh api repos/SMOrchestra-ai/smorch-brain/collaborators/<username> -X DELETE
   ```
3. Add to appropriate GitHub team:
   ```bash
   gh api orgs/SMOrchestra-ai/teams/dev-team/memberships/<username> -X PUT
   ```
4. Walk them through setup:
   ```bash
   git clone git@github.com:SMOrchestra-ai/smorch-dist.git ~/Desktop/cowork-workspace/smorch-dist
   cd ~/Desktop/cowork-workspace/smorch-dist
   bash scripts/smorch init --profile developer
   ```

---

## Phase 3: Ongoing Operations

### When you update skills:
```bash
# In smorch-brain:
# 1. Make changes to plugins/skills
# 2. Compile and publish
smorch publish-dist
```

### When onboarding new team member:
1. Contributor agreement signed
2. Add to GitHub team (dev-team, gtm-team, or eo-students)
3. They clone smorch-dist
4. They run `smorch init --profile <role>`

### Monthly audit:
```bash
# Check who has access to source
gh api repos/SMOrchestra-ai/smorch-brain/collaborators -q '.[].login'

# Check who has access to dist
gh api repos/SMOrchestra-ai/smorch-dist/collaborators -q '.[].login'

# Verify no forks exist
gh api repos/SMOrchestra-ai/smorch-dist/forks -q '.[].full_name'
```

---

## Incident Response

### If plugin leak detected:
1. Check watermark in leaked file: `<!-- dist:<date>:<hash> -->`
2. Trace to team via watermark
3. Revoke team access immediately
4. Trigger contributor agreement enforcement
5. Re-publish with new watermarks

### If unauthorized access detected:
1. Rotate GitHub tokens
2. Remove all collaborators from smorch-brain
3. Re-add only verified founders
4. Audit git log for data exfiltration

---

## Compilation Details

### What gets stripped:
- Content between `<!-- IP:START -->` and `<!-- IP:END -->` markers
- Scoring descriptor tables (rows with |X/10| pattern)
- Sections titled: Calibration, Interpolation, Worked Example, Descriptor Level, Benchmark Source
- Reference files named: *rubric*, *calibration*, *descriptor*, *interpolation*, *benchmark*, *formula*
- Scripts named: *scoring*, *calibrat*, *rubric*, *formula*

### What survives compilation:
- Skill frontmatter (name, description, triggers)
- Execution flow (step-by-step instructions)
- Input/output format specs
- Criterion names and weights (needed for Claude to execute)
- Hard stop rules (needed for enforcement)
- CTA and action instructions
- Watermark + anti-disclosure instruction

### Testing compiled skills:
Run the same request against both source and compiled versions. Compiled should:
- Route correctly to the right scorer
- Enforce hard stops
- Produce scores in the correct format
- NOT include descriptor-level detail in explanations
