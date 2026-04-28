# Lana Al-Kurd — AI-Native Onboarding Guide

**Version:** 1.0 | **Date:** March 2026
**For:** Lana Al-Kurd (@lanaalkurdsmo)
**Role:** Human Engineer / QA Lead / User Advocate
**Organization:** SMOrchestra-ai (GitHub Org)

---

## Welcome to AI-Native Development

You are joining an organization where **AI writes 80% of the code**. Your value is NOT in typing code — it's in **judgment, testing, user empathy, and quality assurance** that AI cannot do.

Read this guide completely. It covers:
1. GitHub access setup
2. Tool installation (Superpowers plugin, Dev Scoring plugin)
3. How you work with AI (Claude Code) and Mamoun
4. Daily and weekly routines
5. Your two focus areas (Signal Sales Engine + Ad-Hoc)
6. Linear task management

---

## Part 1: Prerequisites — GitHub Access

### Step 1: GitHub Organization Membership

You are a member of the **SMOrchestra-ai** GitHub organization on the **GitHub Team Plan**. Mamoun has sent you an invitation.

**Your GitHub account:** @lanaalkurdsmo
**Org:** SMOrchestra-ai
**Plan:** GitHub Team (includes enforced branch protection + required reviewers)
**Team:** `engineering` (write access to all repos)

**To get started:**
1. Check your email for the GitHub organization invitation from SMOrchestra-ai
2. Accept the invitation
3. Go to https://github.com/orgs/SMOrchestra-ai
4. Verify you can see all repos: SaaSFast, EO-Scorecard-Platform, Signal-Sales-Engine, eo-mena, smorch-brain, smorch-dist, smorch-context, supervibes
5. Verify you can open Pull Requests on any repo

**Branch protection is enforced by GitHub Team Plan:**
- You CANNOT push directly to `main` or `dev` — GitHub will reject it
- All changes require a Pull Request with at least 1 approving review
- CODEOWNERS rules auto-assign reviewers for sensitive files (infra/, auth/, billing/)

### Step 2: Clone Key Repos

Clone the repos you'll work with most:

```bash
# Create your workspace
mkdir -p ~/smo-workspace && cd ~/smo-workspace

# Clone production repos (use HTTPS — matches our auth setup)
git clone https://github.com/SMOrchestra-ai/Signal-Sales-Engine.git
git clone https://github.com/SMOrchestra-ai/SaaSFast.git
git clone https://github.com/SMOrchestra-ai/EO-Scorecard-Platform.git
git clone https://github.com/SMOrchestra-ai/eo-mena.git

# Clone the brain (skills registry + SOPs)
git clone https://github.com/SMOrchestra-ai/smorch-brain.git
```

### Step 3: Verify Git Config

```bash
git config --global user.name "Lana Al-Kurd"
git config --global user.email "your-email@example.com"
```

### Step 4: Branch Naming Convention

When you create branches, always use this pattern:
```
human/lana/TASK-XXX-short-description
```

Examples:
```bash
git checkout -b human/lana/TASK-042-arabic-rtl-fix
git checkout -b human/lana/TASK-055-email-verification-qa
```

**Never** push directly to `main` or `dev`. Always create your branch, push it, and open a PR.

---

## Part 2: Tool Installation

### 2.1 Superpowers Plugin (Claude Desktop)

The Superpowers plugin gives Claude Code enhanced capabilities for code review, debugging, and development workflows.

**Installation on your PC:**

1. Download the `superpowers.plugin` file from the shared Google Drive (Mamoun will share the link)
2. Open Claude Desktop on your PC
3. Go to **Settings → Plugins → My Uploads**
4. Click **Upload Plugin**
5. Select `superpowers.plugin`
6. Verify it appears in your available skills

**Installation on your dev server:**

1. SSH into your dev server
2. Copy the plugin file to the server:
   ```bash
   scp superpowers.plugin your-server:~/
   ```
3. Place it in the Claude skills directory:
   ```bash
   mkdir -p ~/.claude/skills/superpowers
   cp ~/superpowers.plugin ~/.claude/skills/superpowers/
   ```

**Key Superpowers skills you'll use:**

| Skill | When to Use |
|-------|------------|
| `requesting-code-review` | When you want AI to review code before you submit |
| `receiving-code-review` | When processing review feedback on your changes |
| `systematic-debugging` | When investigating a bug — forces root cause analysis |
| `brainstorming` | When exploring approaches to a problem |

### 2.2 Dev Scoring Plugin (smorch-dev-scoring)

This is SMOrchestra's 5-Hat Quality Scorecard System. It scores projects across 40 dimensions from 5 perspectives.

**Installation on your PC:**

1. Download `smorch-dev-scoring.plugin` from the shared Google Drive
2. Open Claude Desktop → Settings → Plugins → My Uploads
3. Upload the plugin
4. Verify by running `/score-hat product` on any project

**Installation on your dev server:**

```bash
# Clone smorch-brain if not already done
cd ~/smo-workspace
git clone https://github.com/SMOrchestra-ai/smorch-brain.git

# The scoring skills are in the brain
ls ~/smo-workspace/smorch-brain/skills/smorch-dev-scoring/
```

**Key scoring commands:**

| Command | What It Does | When to Use |
|---------|-------------|-------------|
| `/score-project` | Full 5-hat quality audit (all 40 dimensions) | Before releases, sprint reviews |
| `/score-hat engineering` | Score code quality only | After writing/reviewing code |
| `/score-hat qa` | Score test coverage and edge cases | After QA sessions |
| `/score-hat ux` | Score frontend quality and RTL | After UI testing |
| `/score-hat arch` | Score architecture quality | After schema/API changes |
| `/score-hat product` | Score scope and requirements | During planning |
| `/bridge-gaps` | Generate improvement plan from scores | After any scoring session |

**Understanding Scores:**

| Score | Grade | Meaning |
|-------|-------|---------|
| 9.0-10.0 | A+ | Ship with confidence |
| 8.0-8.9 | A | Strong, minor polish needed |
| 7.0-7.9 | B | Solid, known gaps have remediation path |
| 6.0-6.9 | C | Acceptable with caveats |
| Below 6.0 | D/F | Major work needed |

**Quality gates that block releases:**
- PR to dev: composite score must be **85+**
- Release to main: composite score must be **90+**
- Any security dimension below 5: **automatic FAIL regardless of composite**

### 2.3 Additional Tools

| Tool | Purpose | Installation |
|------|---------|-------------|
| **Node.js (v18+)** | Run project dev servers | `brew install node` (Mac) or `nvm install 18` |
| **Git** | Version control | Already installed on most systems |
| **VS Code / Cursor** | Code editor | Download from website |
| **Playwright** | Browser testing | `npm install -D @playwright/test && npx playwright install` |

---

## Part 3: Understanding the Documentation

### Where Documents Live

```
smorch-brain/docs/sops/
├── SOP-QA-Protocol.md              ← How to run QA (read this first)
├── SOP-Pre-Upload-Scoring.md       ← Score before every push
├── SOP-Github-Standards.md         ← Branch naming, commits, releases
├── SOP-Team-Distribution.md        ← How tasks are assigned to you
├── SOP-Dev-Roles-Hierarchy.md      ← Your role definition (NEW)
└── AI-Native-Archi-File-Guide.md   ← Required files per project
```

### Documents You Must Read (Priority Order)

| # | Document | Why | Time |
|---|----------|-----|------|
| 1 | **SOP-Dev-Roles-Hierarchy.md** | Defines your role, what you do and don't do | 10 min |
| 2 | **SOP-Team-Distribution.md** | How tasks come to you via Linear | 10 min |
| 3 | **SOP-QA-Protocol.md** | Your primary QA workflow (60-min protocol) | 15 min |
| 4 | **SOP-Github-Standards.md** | Branch naming, commits, PR format | 15 min |
| 5 | **human-engineer-role-ai-native-2026-03.md** | Deep philosophy of your role | 20 min |
| 6 | **smorch-dev-scoring-guide.md** | How the 5-hat scoring works | 15 min |
| 7 | **SOP-Pre-Upload-Scoring.md** | Scoring gates before PRs | 10 min |
| 8 | **AI-Native-Archi-File-Guide.md** | What files every project must have | 10 min |

### How to Use Scoring in Your Work

When you review a PR or test a feature:

1. **Check the PR body** — every PR includes a quality score section:
   ```
   ## Quality Score
   Composite: 92/100
   Hats scored: Engineering, UX/Frontend
   Gap bridge applied: No
   ```

2. **If score is missing** — ask the AI to run scoring before you review

3. **Run scoring yourself** after QA:
   ```
   /score-hat qa      ← after testing
   /score-hat ux      ← after RTL/UI testing
   ```

4. **Use gap bridger** to prioritize fixes:
   ```
   /bridge-gaps       ← generates ranked improvement list
   ```

---

## Part 4: Linear Task Management

### How You Receive Tasks

1. Claude Code (AI) creates tasks on **Linear** and assigns them to you
2. Each task includes: what to do, where to look, what to check, how to report back
3. Tasks follow templates from SOP-4 (Code Review, QA Testing, Debug)

### Your Linear Workflow

```
Task appears in Linear (assigned to you)
  → Read the task description carefully
  → Check the branch name / PR link
  → Do the work (review, test, debug)
  → Report back (Linear comment or PR review)
  → AI reads your feedback and acts on it
```

### How to Report on Linear

**For QA tasks:**
```
✅ QA PASS — tested all checklist items, no issues found
```
or
```
🔴 QA FAIL — 3 issues found:
1. BUG: Arabic text in invoice notes renders LTR when starting with number
   - Steps: Create invoice → add Arabic note starting with "3 عناصر" → generate PDF
   - Expected: Note renders RTL
   - Actual: Note renders LTR
   - Screenshot: [attached]
2. BUG: ...
```

**For Code Review tasks:**
```
APPROVE — Code matches spec, scope is clean, no security issues
```
or
```
REQUEST CHANGES — 2 issues:
🔴 CRITICAL: Auth token not invalidated on password change (security risk)
🟡 SUGGESTION: Error message on line 45 is generic, should be specific
```

**For Debug tasks:**
```
ROOT CAUSE: The timezone calculation uses UTC offset (+4) instead of IANA identifier (Asia/Dubai).
Gulf Standard Time doesn't observe DST, but the library assumes all +4 zones do.
FIX: Replace offset-based calculation with IANA timezone in src/utils/timezone.ts line 23.
If simple fix: I've pushed to human/lana/TASK-XXX-fix
If complex: Structured spec above for AI to implement.
```

---

## Part 5: Daily Routine

### Morning (First 30 Minutes)

| Step | Action | Tool |
|------|--------|------|
| 1 | Open Linear — check new tasks assigned to you | Linear app/web |
| 2 | Open GitHub — check overnight PRs waiting for review | GitHub PR dashboard |
| 3 | Triage: sort PRs by risk tier (HIGH first, then MEDIUM, then LOW) | GitHub labels |
| 4 | Start with HIGH-risk PR reviews (< 2 hour SLA) | GitHub + local dev |

### Core Work Block (4-6 Hours)

| Priority | Activity | Details |
|----------|----------|---------|
| 1st | **HIGH-risk PR reviews** | Pull branch locally, test, verify security + intent alignment |
| 2nd | **MEDIUM-risk PR reviews** | Review diff, verify scope, spot-check test coverage |
| 3rd | **QA testing** (if assigned) | Run through test checklist, test Arabic RTL, mobile, edge cases |
| 4th | **Debug tasks** (if any `needs-human-debug`) | Root cause analysis, write fix spec or push fix |
| 5th | **LOW-risk PR reviews** | Quick sanity check, verify no scope creep |
| 6th | **Ad-hoc tasks** from Linear | Whatever the AI has assigned for today |

### End of Day (Last 15 Minutes)

| Step | Action |
|------|--------|
| 1 | Update all Linear tasks with status (done, in-progress, blocked) |
| 2 | Comment on any pending PRs with your findings |
| 3 | If any CRITICAL issues found, ensure Mamoun has been notified |
| 4 | Check tomorrow's queue — anything time-sensitive arriving overnight? |

### Time Budget

| Activity | Daily Target |
|----------|-------------|
| Code review | 3-4 hours |
| QA testing | 1.5-2 hours |
| Debugging | 1-1.5 hours |
| Spec feedback / reporting | 0.5-1 hour |
| System checks | 15-30 min |

---

## Part 6: Weekly Routine

### Monday — Sprint Kickoff
- Review week's task queue on Linear
- Check which PRs are pending from weekend agent work
- Prioritize: any overdue reviews? Any blocked tasks?
- Align with Mamoun on week priorities (if needed)

### Tuesday–Thursday — Core Execution
- Follow daily routine (Part 5)
- Focus area work: Signal Sales Engine testing, ad-hoc projects

### Friday — Weekly Wrap
- Ensure all assigned tasks are closed or have status updates
- Run `/score-project` on any repo you've been testing heavily this week
- File any deferred bugs that accumulated during the week
- Update Linear with week summary

### Sunday — Weekly Architecture Audit (AI runs this)
- AI runs the automated weekly audit at 9am Dubai time
- AI may create tasks for you based on audit findings
- Check Linear Sunday afternoon for any new assignments

### Monthly — Archive Review (1st of Month)
- AI flags archived repos for review
- Mamoun decides what to delete
- You may be asked to verify no critical code is lost before deletion

---

## Part 7: Your Two Focus Areas

### Focus Area 1: Signal Sales Engine

The Signal Sales Engine is a B2B signal intelligence stack. You work across three sub-areas:

**A. Ops Side — Email Verification & Campaign Automation**

What you test:
- Email verification workflows (does Instantly.ai integration work end-to-end?)
- Campaign sequences trigger correctly
- Bounce handling and warmup processes
- Data flows between Instantly → n8n → GoHighLevel

How to test:
```
1. Verify email verification API returns correct results for known good/bad emails
2. Test campaign trigger: create test contact → verify sequence starts
3. Test bounce handling: send to known-bad email → verify bounce recorded
4. Check n8n workflow execution logs for errors
```

**B. Data Input Side — Scrapers & Firecrawl**

What you test:
- Scraper outputs for data accuracy and completeness
- Firecrawl integration results
- Data enrichment quality (are the signals correct?)
- Pipeline reliability (do scrapers run on schedule?)

How to test:
```
1. Run scraper → verify output matches source (spot-check 10 records)
2. Check enrichment fields: are emails valid? Are company sizes correct?
3. Verify Firecrawl outputs parse correctly into our schema
4. Check pipeline logs for failures or retries
```

**C. Brain Orchestration Layer — Clay Replacement Vision**

What you do:
- Review BRD for v3 (when AI drafts it) — check for feasibility and gaps
- Test signal detection accuracy against known signals
- Validate scoring outputs match expectations
- Stay macro — don't get into implementation details

### Focus Area 2: Ad-Hoc Projects

These come through Linear, assigned by AI, usually in the morning.

Examples:
- "Test the new EO scorecard Arabic flow"
- "QA the SaaSFast dashboard refactor"
- "Debug the webhook failure on eo-mena"
- "Review this agent PR for the supervibes feature"

**Your approach for ad-hoc:**
1. Read the Linear ticket completely
2. Check the branch and PR
3. Set up local environment if needed (`npm install && npm run dev`)
4. Follow the test checklist in the ticket
5. Report back on Linear within the SLA

---

## Part 8: Key Rules to Remember

### The Golden Rules

1. **Never push to main or dev directly.** Always use branches and PRs.
2. **Never merge without Mamoun's approval on HIGH-risk items.**
3. **Always use structured bug reports.** Not "it's broken" — give steps, expected, actual, screenshot.
4. **Run scoring after QA.** Your testing should move the quality score up.
5. **Follow conventional commits** if you ever commit code:
   ```
   fix(TASK-42): description of the fix
   ```
6. **Your branch naming:** `human/lana/TASK-XXX-slug`
7. **Report CRITICAL issues immediately** — don't wait for end of day.
8. **Trust the AI's code, but verify the AI's judgment.** The code compiles and passes tests — your job is to check if it does the RIGHT thing.

### What to Escalate to Mamoun

| Situation | Action |
|-----------|--------|
| CRITICAL security issue found | Notify immediately via Linear + direct message |
| Architecture concern (wrong approach) | Flag on PR comment + notify Mamoun |
| Task unclear or contradictory | Ask on Linear ticket, wait for clarification |
| Blocked for > 2 hours | Notify Mamoun with options |
| Disagreement with AI's approach | Document your reasoning, Mamoun decides |

### SLA Expectations

| Task Type | Your SLA |
|-----------|---------|
| HIGH-risk PR review | 2 hours |
| MEDIUM-risk PR review | 4 hours |
| LOW-risk PR review | 8 hours (same business day) |
| QA testing | Same business day |
| Debug task | 24 hours |
| User testing | 48 hours |

---

## Part 9: Environment Setup Checklist

Before your first day of work, verify:

```
[ ] GitHub: accepted SMOrchestra-ai org invitation
[ ] GitHub: can see all 8 org repos
[ ] GitHub: can create branches and open PRs
[ ] Git: configured with your name and email
[ ] Repos: cloned Signal-Sales-Engine, SaaSFast, EO-Scorecard-Platform, eo-mena, smorch-brain
[ ] Node.js: v18+ installed
[ ] Claude Desktop: Superpowers plugin installed and working
[ ] Claude Desktop: Dev Scoring plugin installed and working
[ ] Linear: account set up, can see SMOrchestra workspace
[ ] Linear: notifications enabled for assigned tasks
[ ] Read: SOP-Dev-Roles-Hierarchy.md
[ ] Read: SOP-Team-Distribution.md
[ ] Read: SOP-QA-Protocol.md
[ ] Read: SOP-Github-Standards.md
[ ] Read: human-engineer-role-ai-native-2026-03.md
[ ] Read: smorch-dev-scoring-guide.md
[ ] Test: ran `/score-hat product` on any project successfully
[ ] Test: created a test branch (human/lana/test-setup), pushed, deleted
```

If any item fails, report to Mamoun with the specific error.

---

## Part 10: Quick Reference Card

Keep this open during your first week:

| I need to... | Do this... |
|--------------|-----------|
| Review a PR | Read spec → Read diff → Check scope → Test locally → MERGE/REVISE/BLOCK |
| Report a bug | Linear ticket: steps, expected, actual, screenshot, affected files |
| Create a branch | `git checkout -b human/lana/TASK-XXX-slug` |
| Run QA scoring | `/score-hat qa` then `/bridge-gaps` |
| Check project quality | `/score-project` |
| Debug a CI failure | Read CI output → reproduce locally → identify root cause → write fix spec |
| Test Arabic RTL | Switch browser to Arabic → test all text, layout mirrors, numbers, dates |
| Escalate CRITICAL | Linear comment immediately + direct message to Mamoun |
| Check my tasks | Open Linear → filter by "Assigned to me" |
| End of day | Update Linear tasks → comment on pending PRs → check for CRITICAL items |

---

*This guide is your operating manual. Follow it precisely. When in doubt, ask on the Linear ticket — never guess. Your judgment is the last line of defense before code ships to real users.*
