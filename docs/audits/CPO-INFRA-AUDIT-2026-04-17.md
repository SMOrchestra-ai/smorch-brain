# CPO Infrastructure Audit — 10-Point Assessment + Remediation Plan

**Date:** 2026-04-17
**Auditor:** Claude (CPO / Lead Architect role)
**Owner:** Mamoun Alamouri
**Scope:** All 11 repos, smo-dev + smo-brain servers, full dev/QA/deploy pipeline
**Goal:** GitHub = single source of truth. Zero drift. Clean handoffs. No blind spots.

---

## Executive Summary

**Composite Score: 5.8/10** — Foundation is solid (git topology fixed, SOPs written, hooks active) but enforcement, automation, and per-project maturity are inconsistent. Six repos have weak/missing CLAUDE.md, four repos have no .env.example, zero repos have CI/CD or deployment configs, and the dev→QA→deploy pipeline is manual end-to-end.

---

## Audit Results

### Point 1: GitHub as Single Source of Truth — 8/10

**What's working:**
- All 11 repos have `.git` at project root in `~/Desktop/cowork-workspace/CodingProjects/`
- Home dir (`~/`) no longer a git repo
- SOP-10 enforces start/finish checklist
- SessionStart hook detects wrong repo + behind-remote
- Destructive command hook blocks `rm -rf`, `git push --force`
- PRODUCT-ARCHITECTURE.md documents all product lines

**Gaps:**
- [ ] No CI/CD pipelines — zero repos have `.github/workflows/`. No automated build/lint check on PR.
- [ ] No branch protection on most repos — only eo-mena has protection rules.

**Remedy:**
- Create `.github/workflows/ci.yml` for all Next.js repos (lint + build on PR)
- Enable branch protection (require PR, require CI pass) on all active repos
- Add `require_code_owner_reviews` where applicable

---

### Point 2: No Drift — 7/10

**What's working:**
- SOP-10 3-way sync check (local = GitHub = server)
- SessionStart hook warns when behind remote
- Commit discipline documented

**Gaps:**
- [ ] No automated server sync verification — no cron that alerts on drift
- [ ] No deploy webhook — merge to main doesn't trigger deploy
- [ ] smorch-brain on smo-brain server has no auto-sync

**Remedy:**
- Create n8n scheduled workflow that checks server HEAD vs GitHub HEAD every 6 hours
- Add PM2 ecosystem.config.js with deploy commands per repo
- Create `scripts/deploy.sh` per deployed repo for one-command deploy
- Add post-deploy verification (curl health check + commit hash match)

---

### Point 3: QA on Latest with Right Commit — 6/10

**What's working:**
- SOP-01 QA Protocol is comprehensive (5-hat scoring)
- `git log --oneline -1` comparison documented

**Gaps:**
- [ ] No commit hash display in app — QA can't verify which version they're testing
- [ ] No QA environment URL per branch
- [ ] No real test suites — only contabo-mcp-server has tests

**Remedy:**
- Add build-time commit hash stamp to all Next.js apps (via `next.config.js` env injection)
- Add `/api/health` endpoint to every deployed app returning `{ version, commit, branch, timestamp }`
- Create basic smoke test scripts per project in `scripts/smoke-test.sh`

---

### Point 4: QA Team Full Context — 5/10

**What's working:**
- SOP-01 has structured QA phases
- SOP-06 defines Lana's role clearly
- Linear integration for task assignment

**Gaps:**
- [ ] No QA onboarding doc — no single "start here" for Lana
- [ ] No docs/qa/ folder in most repos
- [ ] No project-specific test scenarios
- [ ] No severity-based escalation matrix

**Remedy:**
- Create `smorch-brain/docs/qa/QA-ONBOARDING.md` — master QA guide with all project URLs, credentials needed, test tools
- Create `docs/qa/test-scenarios.md` in each deployed repo
- Create escalation matrix in SOP-01 (P0: Telegram immediately, P1: Linear + Telegram, P2: Linear only)
- Standardize QA handover format

---

### Point 5: Env Variable Lock — 4/10 🔴

**What's working:**
- EO-MENA, SaaSFast, SaaSfast-ar, content-automation have `.env.example`
- EO-MENA CLAUDE.md lists all required env vars

**Gaps:**
- [ ] 4 repos have NO `.env.example`: Signal-Sales-Engine, digital-revenue-score, gtm-fitness-scorecard, contabo-mcp-server
- [ ] No env documentation — files list vars but don't explain where to get values
- [ ] No env validation at startup — only content-automation validates
- [ ] EO-Scorecard `.env.example` says "SaaSFast v2" — not customized
- [ ] 6 repos don't declare env vars in CLAUDE.md

**Current state:**

| Repo | .env.example | .env.local | Env in CLAUDE.md | Validation |
|------|-------------|------------|-----------------|------------|
| EO-MENA | ✅ | ✅ | ✅ | ❌ |
| EO-Scorecard-Platform | ⚠️ (SaaSFast template) | ❌ | ❌ | ❌ |
| Signal-Sales-Engine | ❌ | ❌ | ❌ | ❌ |
| SaaSFast | ✅ | ✅ | ❌ | ❌ |
| SaaSfast-ar | ✅ | ❌ | ❌ | ❌ |
| content-automation | ✅ | ❌ | ❌ | ✅ |
| digital-revenue-score | ❌ | ❌ | ❌ | ❌ |
| gtm-fitness-scorecard | ❌ | ❌ | ❌ | ❌ |
| contabo-mcp-server | ❌ | ❌ | ❌ | ❌ |
| smorch-brain | ✅ (.env.template) | ❌ | ❌ | ❌ |

**Remedy:**
- Create `.env.example` for the 4 missing repos
- Add env documentation comments: what each var is, where to get it, which service
- Add env var section to every CLAUDE.md
- Add `scripts/check-env.sh` that validates required vars before `npm run dev`
- Fix EO-Scorecard `.env.example` header

---

### Point 6: No SaaSFast/SSE Mix-up — 9/10 ✅

**What's working:**
- PRODUCT-ARCHITECTURE.md clearly documents the distinction
- SaaSFast (internal launcher) vs SaaSfast-ar (standalone product) spelled out
- SSE three-module architecture with CPO recommendation documented
- Separate local folders, separate repos

**Gaps:**
- [ ] EO-Scorecard `.env.example` still says "SaaSFast v2"
- [ ] SaaSFast CLAUDE.md is skeletal (31 lines)

**Remedy:**
- Fix EO-Scorecard env header (done as part of Point 5)
- Expand SaaSFast CLAUDE.md (done as part of Point 8)

---

### Point 7: Server/Webserver Structure — 3/10 🔴

**Gaps (critical):**
- [ ] Zero deployment configs — no Dockerfile, docker-compose, ecosystem.config.js, PM2 config in ANY repo
- [ ] Deployment is fully manual — SSH + git pull + npm build + pm2 restart
- [ ] No Coolify config despite CLAUDE.md mentioning it
- [ ] Server paths not standardized — `/root/eo-mena-new/`, `/var/www/eo-scoring/`, `/root/content-automation/`
- [ ] No health checks — no way to know if app is running
- [ ] No rollback mechanism

**Current deployment map:**

| Product | Server | Path | PM2 | URL | Standardized? |
|---------|--------|------|-----|-----|---------------|
| EO MENA | contabo-main | /root/eo-mena-new/ | eo-main | entrepreneursoasis.me | ❌ ("-new"?) |
| EO Scorecard | contabo-main | /var/www/eo-scoring/ | eo-scoring | score.entrepreneursoasis.me | ❌ (/var/www vs /root) |
| Content Auto | smo-dev | /root/content-automation/ | content | TBD | ✅ |
| smorch-brain | smo-brain | /root/smorch-brain/ | N/A | N/A | ✅ |
| SSE v3 | smo-dev | TBD | TBD | TBD | Not deployed |
| SaaSFast | TBD | TBD | TBD | TBD | Not deployed |

**Remedy:**
- Create `ecosystem.config.js` in every deployed repo
- Create `scripts/deploy.sh` per repo (git pull + build + pm2 reload)
- Add `/api/health` endpoint to every Next.js app
- Standardize server paths: `/opt/apps/{repo-name}/` on all servers
- Create `scripts/rollback.sh` (git checkout previous tag + rebuild)
- Document target server directory structure

**Target server structure:**
```
/opt/apps/
├── eo-mena/              # EO MENA Platform
├── eo-scoring/           # EO Scorecard Platform
├── content-automation/   # Content Engine
├── signal-sales-engine/  # SSE v3
└── saasfast/             # SaaSFast launcher
```

---

### Point 8: Skills/Plugins per Project — 5/10

**What's working:**
- EO-MENA has full plugin system (6 plugins)
- content-automation has structured skill resolver
- smorch-brain has skills/ folder and distribution system

**Gaps:**
- [ ] No `.claude/skills/` in 6 repos
- [ ] No "required skills" section in most CLAUDE.md files
- [ ] EO-Scorecard uses OpenAI GPT-4 — not Claude, not skill-injected

**Remedy:**
- Add required skills section to every CLAUDE.md
- For repos that use Claude as backend: define skill injection pattern
- For repos that don't: document as "no AI backend needed"
- Create standardized CLAUDE.md template with mandatory sections

---

### Point 9: Claude Code as Backend with Skill Injection — 6/10

**What's working:**
- **content-automation** — mature pattern: `skill-resolver.ts` → `claude-md-writer.ts` → subprocess
  - Skills are first-class: topic-aware, language-aware, fallback resolution
  - CLAUDE.md generated dynamically per task
- Architecture ready to scale to new asset types

**Gaps:**
- [ ] EO-Scorecard still uses OpenAI GPT-4 via `libs/gpt.js` — legacy, no skill injection
- [ ] No shared skill injection library — content-automation pattern isn't reusable
- [ ] No skill versioning

**Remedy:**
- Flag EO-Scorecard GPT-4→Claude migration as separate epic (not blocking infra cleanup)
- Document content-automation's skill injection pattern as the reference architecture
- Create `smorch-brain/docs/architecture/SKILL-INJECTION-REFERENCE.md`

---

### Point 10: Dev↔QA Handoff — 5/10

**What's working:**
- SOP-10 defines the flow: dev → PR → deploy → QA → PR to main
- Linear integration for task tracking
- Paperclip QA agent for automated validation

**Gaps:**
- [ ] No staging environment — QA tests on same server as dev
- [ ] No commit-hash visibility in running app
- [ ] No QA sign-off gate on GitHub
- [ ] No automated deploy notifications
- [ ] No handover template format

**Remedy:**
- Add commit hash to app (Point 3)
- Create QA handover template in smorch-brain
- Create n8n workflow: on deploy → Telegram notification to QA channel
- Add "QA-approved" label requirement before main merge (GitHub branch rule)
- Document staging strategy: dev branch = staging URL, main = production URL

---

## Remediation Execution Plan

### Phase 1: Foundation (this session — smo-dev + smo-brain)

| # | Task | Repos Affected | Est. Time |
|---|------|---------------|-----------|
| 1.1 | Create/upgrade CLAUDE.md for 6 weak repos | SSE, SaaSFast, SaaSfast-ar, EO-Scorecard, content-auto, smorch-brain | 45 min |
| 1.2 | Create `.env.example` for 4 missing repos + fix EO-Scorecard header | SSE, DRS, GTM, contabo-mcp, EO-Scorecard | 30 min |
| 1.3 | Add env var docs to all `.env.example` files | All repos | 30 min |
| 1.4 | Create `ecosystem.config.js` for all deployed repos | EO-MENA, EO-Scorecard, content-auto, smorch-brain | 20 min |
| 1.5 | Create `scripts/deploy.sh` per deployed repo | Same as 1.4 | 20 min |
| 1.6 | Add `/api/health` endpoint to all Next.js apps | EO-MENA, EO-Scorecard, SaaSFast, DRS, GTM, SSE | 30 min |
| 1.7 | Add build-time commit hash stamp | All Next.js repos | 20 min |
| 1.8 | Create CI workflow template (lint + build on PR) | All repos | 20 min |
| 1.9 | Create QA handover template + onboarding doc | smorch-brain | 20 min |
| 1.10 | Create escalation matrix | smorch-brain/sops | 10 min |
| 1.11 | Standardize server directories on smo-dev + smo-brain | Servers | 30 min |
| 1.12 | Enable branch protection on all active repos | GitHub API | 15 min |
| 1.13 | Create drift detection n8n workflow | smo-dev n8n | 20 min |
| 1.14 | Create deploy notification n8n workflow | smo-dev n8n | 15 min |
| 1.15 | Document skill injection reference architecture | smorch-brain | 15 min |

**Total estimated: ~5 hours**

### Phase 2: Production Server (after Mamoun adds contabo-main to Tailscale)

| # | Task |
|---|------|
| 2.1 | Standardize server directories on contabo-main |
| 2.2 | Deploy ecosystem.config.js to contabo-main |
| 2.3 | Verify 3-way sync for EO-MENA and EO-Scorecard |
| 2.4 | Add health check monitoring |
| 2.5 | Enable drift detection for production |

### Phase 3: Future Epics (separate sessions)

| # | Task | Why Separate |
|---|------|-------------|
| 3.1 | EO-Scorecard GPT-4 → Claude migration | Major refactor, own BRD |
| 3.2 | Shared skill injection library | Extract from content-automation |
| 3.3 | Staging environment per project | Requires DNS + server capacity planning |
| 3.4 | Automated deploy on merge | Requires webhook infrastructure |

---

## Target State After Remediation

| # | Dimension | Current | Target |
|---|-----------|---------|--------|
| 1 | GitHub as truth | 8/10 | 10/10 |
| 2 | No drift | 7/10 | 9/10 |
| 3 | QA on latest | 6/10 | 9/10 |
| 4 | QA context | 5/10 | 9/10 |
| 5 | Env lock | 4/10 | 9/10 |
| 6 | No mix-up | 9/10 | 10/10 |
| 7 | Server structure | 3/10 | 8/10 |
| 8 | Skills/plugins | 5/10 | 8/10 |
| 9 | Skill injection | 6/10 | 7/10 |
| 10 | Dev↔QA handoff | 5/10 | 9/10 |
| **Composite** | | **5.8/10** | **9.0/10** |

(10/10 on points 2, 7, 9 requires Phase 2 + Phase 3 work)

---

## Verification Checklist (run after Phase 1)

```bash
# 1. Every repo has CLAUDE.md with mandatory sections
for repo in EO-MENA EO-Scorecard-Platform Signal-Sales-Engine SaaSFast SaaSfast-ar content-automation digital-revenue-score gtm-fitness-scorecard contabo-mcp-server smorch-brain; do
  echo "$repo: $(test -f $repo/CLAUDE.md && grep -c 'Deploy Command\|Server Path\|Environment Variables' $repo/CLAUDE.md || echo 'MISSING')"
done

# 2. Every repo has .env.example
for repo in EO-MENA EO-Scorecard-Platform Signal-Sales-Engine SaaSFast SaaSfast-ar content-automation digital-revenue-score gtm-fitness-scorecard contabo-mcp-server smorch-brain; do
  echo "$repo: $(test -f $repo/.env.example && echo 'OK' || echo 'MISSING')"
done

# 3. Every deployed repo has ecosystem.config.js + deploy.sh
for repo in EO-MENA EO-Scorecard-Platform content-automation; do
  echo "$repo: eco=$(test -f $repo/ecosystem.config.js && echo OK || echo MISSING) deploy=$(test -f $repo/scripts/deploy.sh && echo OK || echo MISSING)"
done

# 4. Every Next.js app has /api/health
for repo in EO-MENA EO-Scorecard-Platform SaaSFast digital-revenue-score gtm-fitness-scorecard; do
  echo "$repo: $(find $repo -path '*/api/health/route.*' 2>/dev/null | head -1 || echo 'MISSING')"
done

# 5. Every repo has CI workflow
for repo in EO-MENA EO-Scorecard-Platform Signal-Sales-Engine SaaSFast SaaSfast-ar content-automation digital-revenue-score gtm-fitness-scorecard contabo-mcp-server smorch-brain; do
  echo "$repo: $(test -f $repo/.github/workflows/ci.yml && echo 'OK' || echo 'MISSING')"
done

# 6. Branch protection enabled
for repo in eo-mena EO-Scorecard-Platform Signal-Sales-Engine SaaSFast SaaSfast-ar content-automation digital-revenue-score gtm-fitness-scorecard contabo-mcp-server smorch-brain; do
  echo "$repo: $(gh api repos/SMOrchestra-ai/$repo/branches/main/protection 2>/dev/null | jq -r '.required_pull_request_reviews.required_approving_review_count // "NONE"')"
done
```
