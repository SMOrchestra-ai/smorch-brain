# GitHub Org Audit & Action Plan — SMOrchestra-ai

**Date:** 2026-03-22
**Version:** 1.0
**Owner:** Mamoun Alamouri
**Org:** https://github.com/SMOrchestra-ai
**Admin Account:** smorchestraai-code

---

## 1. The Ask

Mamoun requested a full audit of the SMOrchestra-ai GitHub organization against the AI-Native Git Architecture v2 plan. Specifically:

1. **Review what exists** — repos, branches, tags, releases, protection rules, org metadata, documentation artifacts
2. **Score against the v2 plan** — identify every gap between the architecture doc and reality
3. **Build an action plan** — fix every gap, establish ongoing discipline
4. **Create a reference guide** — what a 10/10 AI-Native GitHub architecture looks like
5. **Build a skill + SOPs** — so Claude Code enforces this automatically in every session

**Context:** Mamoun is experienced in enterprise tech but new to GitHub and product management as a daily practice. There is no product manager on the team. Claude Code must own this discipline.

---

## 2. What We Found — Full Audit Results

### 2.1 Organization Level

| Check | Status | Finding |
|-------|--------|---------|
| Org name | MISSING | null — not configured |
| Org description | MISSING | null — not configured |
| Org email | MISSING | null — not configured |
| Org blog/URL | MISSING | null — not configured |
| Teams created | PASS | `engineering`, `agents`, `reviewers` exist |
| Default branch | PASS | All 8 repos use `dev` as default |

### 2.2 Repository Inventory (8 repos)

| Repo | Description | README | CHANGELOG | AGENTS.md | PR Template | Issue Templates | Tags | Releases | CI |
|------|-------------|--------|-----------|-----------|-------------|-----------------|------|----------|----|
| **SaaSFast-v2** | Has one | YES | NO | NO | NO | NO | v3.0.0 | NO (tag only) | YES |
| **eo-assessment-system** | Has one | YES | NO | NO | YES | NO | v1.0.0 | NO | YES |
| **smorch-brain** | MISSING | YES | NO | NO | NO | NO | NONE | NO | YES |
| **EO-Build** | MISSING | NO | NO | NO | NO | NO | NONE | NO | YES |
| **SaaSFast** | MISSING | YES | NO | NO | NO | NO | NONE | NO | YES |
| **ScrapMfast** | MISSING | YES | NO | NO | NO | NO | NONE | NO | YES |
| **ship-fast** | MISSING | YES | NO | NO | NO | NO | NONE | NO | YES |
| **eo-mena** | MISSING | YES | NO | NO | NO | NO | NONE | NO | YES |

### 2.3 Branch Protection

| Check | Status | Finding |
|-------|--------|---------|
| main protected (all repos) | PASS | 1 required reviewer on all 8 repos |
| dev protected (all repos) | PASS | 1 required reviewer on all 8 repos |
| Enforce admins (eo-assessment-system) | PASS | Enabled |
| Enforce admins (other repos) | NOT CHECKED | Likely not enabled |

### 2.4 Architecture Scaffold (v2 Plan)

The v2 plan requires: `agents/`, `prompts/`, `specs/`, `product/`, `tests/`, `infra/`, `docs/`

| Repo | Has Scaffold | Notes |
|------|-------------|-------|
| **eo-assessment-system** | FULL | All 7 directories present. The ONLY repo that matches v2. |
| **SaaSFast-v2** | PARTIAL | Has `.github/CODEOWNERS` and CI, but no `agents/`, `prompts/`, `specs/` |
| **All other repos** | NONE | Only have `.github/CODEOWNERS` and CI workflow |

### 2.5 Version Control & Releases

| Check | Status | Finding |
|-------|--------|---------|
| SemVer tags exist | PARTIAL | Only 2 repos tagged (eo-assessment-system v1.0.0, SaaSFast-v2 v3.0.0) |
| GitHub Releases created | FAIL | ZERO releases across ALL repos. Tags exist but no release objects. |
| CHANGELOGs | FAIL | ZERO across all 8 repos |
| Conventional commits | PARTIAL | eo-assessment-system uses them. Others don't consistently. |

### 2.6 The v3.0.0 Deployment (SaaSFast-v2)

**What happened:** Commit `57e9d31` merged dev → main with tag `v3.0.0` on 2026-03-22. This is a 7-phase platform revamp (multi-config, product catalog, customer dashboard, onboarding wizard, admin dashboard, white-label, Arabic RTL).

**What's right:**
- Proper merge commit (dev → main) ✅
- Tag created with descriptive message ✅
- Co-authored-by attribution ✅
- ADR-001 added for multi-deployment architecture decision ✅

**What's missing:**
- No GitHub Release created (just a tag — invisible to anyone browsing the repo) ❌
- No CHANGELOG.md ❌
- No release notes ❌
- Repo still named "SaaSFast-v2" — should be "SaaSFast" with v3.0.0 tag ❌

### 2.7 Repo Naming & Structure Issues

| Issue | Severity | Details |
|-------|----------|---------|
| **SaaSFast + SaaSFast-v2 = two repos** | HIGH | Major versions belong in the SAME repo. "SaaSFast-v2" should be "SaaSFast" with versions managed by tags. Having two repos means double maintenance, split history, and confusion about which is canonical. |
| **EO-Scorecard folder points to eo-assessment-system** | MEDIUM | Local folder named `EO-Scorecard` but remote is `eo-assessment-system`. Confusing. |
| **ship-fast purpose unclear** | LOW | Is this a template repo? Archive? Needs description. |

---

## 3. Gap Scorecard — v2 Plan vs Reality

| Dimension | v2 Plan Requirement | Current Score | Target |
|-----------|-------------------|---------------|--------|
| **Org metadata** | Name, description, email, URL | 0/10 | 10/10 |
| **Repo descriptions** | Every repo described | 2/10 | 10/10 |
| **Branch model** | main + dev + human/* + agent/* | 8/10 | 10/10 |
| **Branch protection** | Required reviews on main + dev | 9/10 | 10/10 |
| **Architecture scaffold** | All 7 directories per repo | 1/10 | 10/10 |
| **Version control** | SemVer tags + GitHub Releases | 1/10 | 10/10 |
| **CHANGELOGs** | Per-repo CHANGELOG.md | 0/10 | 10/10 |
| **AGENTS.md** | Per-repo agent behavior doc | 0/10 | 10/10 |
| **PR templates** | Standardized PR template | 1/10 | 10/10 |
| **Issue templates** | Bug, feature, task templates | 0/10 | 10/10 |
| **Commit conventions** | Conventional commits enforced | 3/10 | 10/10 |
| **Release protocol** | Tag → Release → CHANGELOG → deploy | 1/10 | 10/10 |
| **Documentation** | README + ARCHITECTURE + ADR | 2/10 | 10/10 |
| **Teams** | engineering, agents, reviewers | 10/10 | 10/10 |

**Overall Score: 2.7 / 10**

The branch model and team structure are solid. Everything else — documentation, versioning, releases, scaffolding — is either missing or inconsistent.

---

## 4. Action Plan

### Phase A: Fix Org & Repo Metadata (15 min)

| Step | Action | Command/Tool |
|------|--------|-------------|
| A1 | Set org metadata (name, description, email, blog) | `gh api -X PATCH orgs/SMOrchestra-ai` |
| A2 | Add descriptions to all 8 repos | `gh repo edit` per repo |
| A3 | Add topics/labels to all repos | `gh repo edit --add-topic` |

### Phase B: Standardize Repo Documentation (1 hour)

| Step | Action | Per Repo |
|------|--------|----------|
| B1 | Create CHANGELOG.md with retroactive entries | All 8 repos |
| B2 | Create AGENTS.md (AI agent behavior rules) | All 8 repos |
| B3 | Create PR template (.github/pull_request_template.md) | 7 repos (eo-assessment-system has one) |
| B4 | Create issue templates (bug, feature, task) | All 8 repos |
| B5 | Add README to EO-Build | EO-Build only |

### Phase C: Fix Version Control (30 min)

| Step | Action | Details |
|------|--------|---------|
| C1 | Create GitHub Release for SaaSFast-v2 v3.0.0 | With full release notes from the tag message |
| C2 | Create GitHub Release for eo-assessment-system v1.0.0 | Retroactive |
| C3 | Plan SaaSFast repo consolidation | Archive old SaaSFast, rename SaaSFast-v2 to SaaSFast |
| C4 | EO-Scorecard: create as separate repo if needed | Or confirm it stays inside eo-assessment-system |

### Phase D: Architecture Scaffold (1 hour)

| Step | Action | Repos |
|------|--------|-------|
| D1 | Add v2 scaffold to SaaSFast-v2 | agents/, prompts/, specs/, docs/ |
| D2 | Add v2 scaffold to smorch-brain | agents/, prompts/, specs/ (if applicable) |
| D3 | Evaluate scaffold need for other repos | Some may be templates/archives — don't scaffold those |

### Phase E: Build smorch-github-ops Skill (1 hour)

Creates a reusable skill that Claude Code invokes every session to enforce:
- Conventional commit format
- Branch naming validation
- Release workflow guidance
- CHANGELOG maintenance
- AGENTS.md generation
- Version control discipline (when major/minor/patch)

### Phase F: Claude Code SOPs (30 min)

Add to global CLAUDE.md:
- GitHub management rules
- Version control protocol
- Documentation requirements
- Release checklist
- How to handle new repos, new versions, new releases

### Phase G: Install External Skills/Plugins (30 min)

| Tool | Purpose | Action |
|------|---------|--------|
| `/release` plugin (kelp) | Changelog + version bumps | Install |
| Changelog Generator skill | Auto-generate from commits | Add to smorch-brain |
| Product Management plugin (Anthropic) | PRD, roadmap, stakeholder comms | Already available |

---

## 5. Validation — Does This Plan Fix Everything?

| Gap | Fixed By | Confidence |
|-----|----------|-----------|
| Org metadata empty | Phase A | 100% |
| Repo descriptions missing | Phase A | 100% |
| Zero CHANGELOGs | Phase B | 100% |
| Zero AGENTS.md | Phase B | 100% |
| No PR/issue templates (7 repos) | Phase B | 100% |
| Zero GitHub Releases | Phase C | 100% |
| SaaSFast repo duplication | Phase C | 100% |
| Architecture scaffold missing (7 repos) | Phase D | 90% (some repos may not need full scaffold) |
| No enforcement discipline | Phase E + F | 95% (skill + SOP together create enforcement) |
| No product management tooling | Phase G | 80% (tools exist, discipline requires habit) |

**Projected score after execution: 9.2 / 10**

The remaining 0.8 comes from: (1) repos that may not need full scaffold (templates/archives), (2) team habit formation for conventional commits, (3) ongoing CHANGELOG discipline requires consistent execution.

The skill (Phase E) and SOPs (Phase F) are what push it from 9.2 toward 10 — they make the discipline automatic rather than manual.

---

## 6. Key Decisions Needed

| Decision | Options | Recommendation |
|----------|---------|----------------|
| SaaSFast consolidation | (A) Rename SaaSFast-v2 → SaaSFast, archive old | **Option A** — clean break, one canonical repo |
| EO-Scorecard | (A) Keep in eo-assessment-system (B) Separate repo | **Depends on deployment** — if separate app, separate repo |
| ship-fast / SaaSFast overlap | (A) Archive ship-fast (B) Keep as template | Need clarification from Mamoun |
| Scaffold for smorch-brain | (A) Full scaffold (B) Light scaffold (just docs/) | **Option B** — smorch-brain is a skills registry, not a product |
| EO-Build scaffold | (A) Full scaffold (B) Archive | Need clarification — what is EO-Build's purpose? |

---

## 7. Timeline

| Phase | Duration | Dependencies |
|-------|----------|-------------|
| A: Org + repo metadata | 15 min | None |
| B: Documentation | 1 hour | None |
| C: Version control | 30 min | Phase A |
| D: Architecture scaffold | 1 hour | Phase C (need repo decisions) |
| E: Build skill | 1 hour | Phase B, D (needs to know what to enforce) |
| F: Claude Code SOPs | 30 min | Phase E (SOPs reference the skill) |
| G: External tools | 30 min | None |

**Total: ~5 hours across multiple sessions**

Phases A, B, G can run immediately. C requires one decision (SaaSFast consolidation). D and E require the reference guide (being built simultaneously).
