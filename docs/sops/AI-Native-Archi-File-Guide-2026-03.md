# AI-Native Architecture — Project File Guide

**Version:** 1.0 | **Date:** March 2026 | **Owner:** Mamoun Alamouri
**Purpose:** Every project in the SMOrchestra GitHub org must include these files. This guide explains what each file is, why it exists, who maintains it, and where it goes.

---

## Quick Reference — Required Files Per Project

```
project-root/
├── .claude/
│   └── CLAUDE.md                   ← Claude Code project instructions
├── .github/
│   ├── CODEOWNERS                  ← File-level ownership
│   ├── PULL_REQUEST_TEMPLATE.md    ← Standardized PR format
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug.md                  ← Bug report template
│   │   ├── feature.md              ← Feature request template
│   │   └── task.md                 ← Task template
│   └── workflows/
│       ├── ci.yml                  ← CI pipeline
│       ├── changelog-check.yml     ← CHANGELOG enforcement
│       └── agent-scope-check.yml   ← Agent PR scope validation
├── agents/                         ← Agent configuration (product repos only)
│   ├── openclaw/                   ← OpenClaw queue config
│   ├── claude/                     ← Claude Code session config
│   └── experiments/                ← Throwaway spikes
├── docs/                           ← Architecture decisions, runbooks
│   └── adr/                        ← Architecture Decision Records
├── prompts/                        ← Version-controlled prompt library
│   ├── codegen/                    ← Code generation prompts
│   ├── review/                     ← Review prompts
│   └── specs/                      ← Spec templates
├── specs/                          ← Work input files for agents
│   ├── tasks/                      ← TASK-XXX.md files
│   └── features/                   ← Feature briefs
├── product/                        ← Shippable product code
├── tests/                          ← All tests
├── infra/                          ← LOCKED — deployment, CI, environments
├── .gitignore                      ← Git ignore rules (node_modules, .env, etc.)
├── AGENTS.md                       ← AI agent behavior rules (cross-tool)
├── CHANGELOG.md                    ← Release history
├── README.md                       ← What this project is
└── SOPs/                           ← Project-level SOPs (copied from this guide)
    ├── SOP-QA-Protocol.md
    ├── SOP-Pre-Upload-Scoring.md
    ├── SOP-Github-Standards.md
    └── SOP-Team-Distribution.md
```

---

## File-by-File Explanation

### CLAUDE.md (`.claude/CLAUDE.md`)
**What:** Project-specific instructions for Claude Code. Loaded at the start of every session.
**Why:** Tells Claude what this project is, what skills to use, what rules to follow.
**Who maintains:** Claude Code (self-updates based on work patterns) + Mamoun (review).
**Must include:**
- Project description (one paragraph)
- Tech stack
- Required Skills section (from smorch-brain registry)
- Build/test commands
- Reference to SOPs: `@SOPs/SOP-QA-Protocol.md`, `@SOPs/SOP-Pre-Upload-Scoring.md`, `@SOPs/SOP-Github-Standards.md`, `@SOPs/SOP-Team-Distribution.md`

### AGENTS.md (root)
**What:** Cross-tool AI agent behavior standard. Works with Claude Code, Cursor, Copilot, Codex, and 25+ tools.
**Why:** Without it, every AI tool guesses the rules. With it, rules are explicit and version-controlled.
**Who maintains:** Mamoun + Claude Code.
**Must include:** Build commands, code style, commit conventions, agent boundaries, prohibited actions.

### CHANGELOG.md (root)
**What:** Human-readable release history.
**Why:** Anyone browsing the repo can see what changed and when. Required for release protocol.
**Who maintains:** Claude Code (auto-generates from commits) + engineer (reviews accuracy).
**Format:** Keep-a-Changelog standard with SemVer entries.

### README.md (root)
**What:** What this project is, how to run it, architecture overview.
**Why:** First thing anyone sees. Must answer "what is this?" in 10 seconds.
**Who maintains:** Engineering team.

### .github/CODEOWNERS
**What:** Maps file paths to owners who must approve PRs touching those files.
**Why:** Ensures infra/, auth/, billing/ changes always require Mamoun's review.
**Who maintains:** Mamoun.

### .github/PULL_REQUEST_TEMPLATE.md
**What:** Standardized PR format with summary, testing checklist, risk assessment.
**Why:** Every PR follows the same structure. No missing context.

### .github/ISSUE_TEMPLATE/ (bug.md, feature.md, task.md)
**What:** Templates for creating issues with required fields.
**Why:** Consistent issue quality. Agents and humans use the same format.

### .github/workflows/ (CI + checks)
**What:** GitHub Actions workflows for CI, CHANGELOG enforcement, and agent scope checking.
**Why:** Automated quality gates that run on every PR.

### docs/adr/ (Architecture Decision Records)
**What:** Documents WHY a decision was made (not just WHAT).
**Why:** When someone asks "why did we do it this way?" in 6 months, the ADR answers.
**Format:** `ADR-XXX-title.md` with Context, Decision, Consequences, Alternatives.

### SOPs/ (Project-Level Standard Operating Procedures)
**What:** 4 SOP files that govern how Claude Code operates on this project.
**Why:** Makes every session consistent. Claude reads these and follows them.
**Files:**
1. `SOP-QA-Protocol.md` — How to run QA (60 min max, 5-hat scoring)
2. `SOP-Pre-Upload-Scoring.md` — Score before push, bridge gaps to 10/10
3. `SOP-Github-Standards.md` — Repo management, branch naming, commits, releases
4. `SOP-Team-Distribution.md` — When and how to involve team members

---

## Files by Repo Type

### Product Repos (SaaSFast, eo-assessment-system, ScrapMfast, eo-mena, EO-Build)
ALL files listed above. Full scaffold.

### Skills/Config Repos (smorch-brain)
Light scaffold: `skills/`, `profiles/`, `scripts/`, `docs/`, AGENTS.md, CHANGELOG.md, README.md, CLAUDE.md

### Template/Archive Repos (ship-fast, SaaSFast-v1-archived)
README.md, AGENTS.md only. No scaffold, no SOPs.

---

## How to Bootstrap a New Project

```bash
# 1. Create repo with dev as default branch
gh repo create SMOrchestra-ai/NEW-REPO --public --default-branch dev

# 2. Clone locally (use HTTPS — matches our gh auth setup)
git clone https://github.com/SMOrchestra-ai/NEW-REPO.git
cd NEW-REPO

# 3. Copy SOP files from smorch-brain templates
mkdir -p SOPs .github/ISSUE_TEMPLATE .github/workflows .claude docs/adr agents prompts specs product tests infra
cp ~/smorch-brain/docs/templates/AGENTS.md ./AGENTS.md
cp ~/smorch-brain/docs/templates/CHANGELOG.md ./CHANGELOG.md
cp ~/smorch-brain/docs/templates/PULL_REQUEST_TEMPLATE.md ./.github/PULL_REQUEST_TEMPLATE.md
cp ~/smorch-brain/docs/templates/bug.md ./.github/ISSUE_TEMPLATE/bug.md
cp ~/smorch-brain/docs/templates/feature.md ./.github/ISSUE_TEMPLATE/feature.md
cp ~/smorch-brain/docs/templates/task.md ./.github/ISSUE_TEMPLATE/task.md
cp ~/smorch-brain/docs/ci-templates/*.yml ./.github/workflows/

# 4. Copy SOPs
cp ~/smorch-brain/docs/sops/SOP-QA-Protocol.md ./SOPs/
cp ~/smorch-brain/docs/sops/SOP-Pre-Upload-Scoring.md ./SOPs/
cp ~/smorch-brain/docs/sops/SOP-Github-Standards.md ./SOPs/
cp ~/smorch-brain/docs/sops/SOP-Team-Distribution.md ./SOPs/

# 5. Create CLAUDE.md
# (Claude Code will generate this on first session)

# 6. Initial commit
git add . && git commit -m "chore: bootstrap AI-native project scaffold"
git push origin dev

# 7. Create main branch and protect both
git checkout -b main && git push origin main
gh api -X PUT repos/SMOrchestra-ai/NEW-REPO/branches/main/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f enforce_admins=true
gh api -X PUT repos/SMOrchestra-ai/NEW-REPO/branches/dev/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1

# 8. Set repo metadata
gh repo edit SMOrchestra-ai/NEW-REPO --description "Description here" \
  --add-topic topic1 --add-topic topic2

# 9. Install git commit hook
cp ~/smorch-brain/hooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

# 10. Add .gitignore
cat > .gitignore << 'GITIGNORE'
node_modules/
.env
.env.local
.DS_Store
dist/
build/
*.log
GITIGNORE
```

### CLAUDE.md Template for New Projects
When creating the first CLAUDE.md for a project, include:
```markdown
# [Project Name]

[One paragraph: what this project does, who it serves, what tech it uses.]

## Tech Stack
- Frontend: [framework]
- Backend: [framework]
- Database: [Supabase/etc]
- Hosting: [Contabo/Vercel/etc]

## Build & Test Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Required Skills
When working on this project, use these skills from the smorch-brain registry:
- [category]/[skill-name]
- [category]/[skill-name]

## SOPs
Follow these operating procedures in every session:
@SOPs/SOP-QA-Protocol.md
@SOPs/SOP-Pre-Upload-Scoring.md
@SOPs/SOP-Github-Standards.md
@SOPs/SOP-Team-Distribution.md
```
