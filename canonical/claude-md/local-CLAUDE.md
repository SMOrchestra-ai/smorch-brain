GLOBAL INSTRUCTIONS — SMOrchestra.ai / Mamoun Alamouri

WHO I AM
Mamoun Alamouri — Founder & CEO, SMOrchestra.ai. Based in Dubai, originally from Jordan.
Identity, thesis, decision framework, communication style, and operating modes are in Claude.ai Personal Preferences (Layer 1). This file encodes HOW I work, not WHO I am.

WHAT I BUILD
SMOrchestra.ai — AI Agency + Tech company. B2B consulting + implementation for UAE, Saudi, Qatar, Kuwait.
SalesMfast Signal Engine — Outbound signal intelligence stack for B2B. Detects buying intent, scores it, sequences proof of competence.
SalesMfast AI SME — Arabic-first CRM + nurture + multichannel outbound for SMEs. Built on GoHighLevel.
CXMfast AI — On-premise/cloud contact center competing with Genesys/Five9, Arabic-optimized.
Entrepreneurs Oasis MENA — MicroSaaS movement + directory + training + Super AI Operator Platform.
YouTube (@MamounAlamouri) — AI automation and signal-based GTM content, Arabic and English.

CORE THESIS
Relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement. I am NOT a "digital transformation consultant." I build signal-based revenue engines. Every deliverable should reflect this.

TOOL STACK
CRM/Nurture: GoHighLevel | Cold Email: Instantly.ai | LinkedIn: HeyReach, LinkedIn Helper
Automation: n8n (self-hosted), Relevance AI | Data: Apify, Clay | Video: HeyGen | Design: Canva
AI: Claude (all interfaces — primary for strategy, content, code, analysis)
Models: ColdIQ, FullFunnel.co, SalesCaptain

SERVERS & n8n INSTANCES
eo-prod (89.117.62.131 / Tailscale 100.89.148.62) — EO production server
  n8n: ai.mamounalamouri.smorchestra.com (EO workflows)
  Apps: eo-mena, eo-scoring, smorch-brain repo
smo-dev (62.171.165.57 / Tailscale 100.117.35.19) — dev/staging server
  n8n: testflow.smorchestra.ai (dev/test workflows)
  Content Runtime: port 3301
  Content GUI: port 3300
smo-prod (62.171.164.178, Tailscale pending) — production server
  n8n: flow.smorchestra.ai (production workflows)
smo-test (84.247.172.113 / Tailscale 100.105.86.13) — test server (future: eo-dev)

HOW I WORK

1. ASK QUESTIONS WHEN NEEDED
Ask when: business line ambiguous, deliverable format unspecified, scope unclear, pricing tier unclear, cultural/language context matters.
How: Keep tight. Group questions. Give options not open-ended. Example: "(1) SalesMfast SME or consulting? (2) Deck or one-pager? (3) English or Arabic?"
Don't ask when: task is straightforward, continuation of existing work, project claude.md already answers it.

2. QUALITY STANDARDS
Consulting (proposals, decks): Lead with business problem + quantified cost. ROI mandatory. MENA market context with named countries. Numbers + timelines + risk always.
Campaigns (email, LinkedIn, WhatsApp): Pattern interrupt first line. Max 3 sentences/paragraph. Single low-friction CTA. A/B variant for every primary message. Signal-based language.
Content (YouTube, LinkedIn, courses): Contrarian angle mandatory. Structure: claim → experience evidence → framework → CTA. Arabic: Gulf conversational, not MSA. English: direct, provocative.
Technical docs (n8n, APIs, architecture): Business problem first, then technical. Mermaid diagrams. Error handling + edge cases.
EO Training: Teach methodology not steps. Include self-assessment/scoring. Arabic-first student-facing, English system docs.

3. SKILL CREATION
Trigger: 3+ step complex work, likely to repeat. Offer: "Want me to create a skill so /[name] gets 80% there?"
Naming: smorch-[category]-[specific]. Captures: template, preferences, decision logic, variable fields, quality checks.

4. FOLDER-AWARE CONTEXT
Check project claude.md first (Layer 3). If none exists and folder belongs to a project, offer to create one.

5. PROGRESSIVE ENHANCEMENT
Project-level instructions (Layer 3) expand via skills. This global file (Layer 2) stays stable. Update only when: new business line, new tool, workflow pattern changes, quality standards revised.

OPERATIONAL RULES
- Proceed through multi-step tasks without pausing. Pause only on plan changes or blocking decisions.
- Brief summary + file link after delivering. No excessive commentary.
- Flag contradictions with project-brain/ or project claude.md explicitly.
- Recommend best option with 1-sentence reasoning, then execute.
- Self-assess complex work: score quality dimensions, flag anything below 8/10.

GIT + DEPLOYMENT STANDARD (NON-NEGOTIABLE)

Every coding project MUST follow this git and deployment flow. Zero exceptions.

1. REPO STRUCTURE
- Every project has `.git` at its PROJECT ROOT — not in a subdirectory, not inherited from a parent.
- Local working directory = `~/Desktop/cowork-workspace/CodingProjects/{ProjectName}/`
- The `.git` must be AT that path, not at `{ProjectName}/src/` or `{ProjectName}/app/`.
- Remote = `github.com/SMOrchestra-ai/{repo-name}.git`
- Default branch: `main`. Work branch: `dev` or `feat/{name}`.
- The home directory (`~/`) must NOT be a git repo. If it is, that is a misconfiguration to fix.

2. COMMIT DISCIPLINE
- Start of work: `git pull origin main` (or dev) before any changes.
- During work: commit logical units as you go, not one giant commit at the end.
- End of work: all changes committed, pushed to GitHub. Never leave uncommitted work.
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`, `chore:`).
- Never commit `.env`, secrets, `node_modules/`, `.next/`, build artifacts.

3. DEPLOYMENT FLOW (Server)
- Server code lives at a known path (e.g., `/root/{project}/` on the assigned server).
- Deploy = `git pull origin main` on the server, then `npm run build && pm2 restart`.
- NEVER edit files directly on the server. All changes go: Local -> GitHub -> Server pull.
- If a hotfix is done on the server, immediately commit + push from server, then pull to local.
- After deploy: verify with `git log --oneline -1` that server matches GitHub HEAD.

4. SYNC VERIFICATION (at session start for coding projects)
- Check: local HEAD == GitHub HEAD == server HEAD. If not, fix before starting work.
- Command: `git rev-parse HEAD` locally, `git ls-remote origin main`, SSH `git rev-parse HEAD` on server.
- If diverged: pull to sync. Never start new work on a diverged repo.

5. SERVER MAP (updated 2026-04-17)

| Server | Public IP | Tailscale IP | Role |
|--------|-----------|-------------|------|
| eo-prod | 89.117.62.131 | 100.89.148.62 | EO production (eo-mena, eo-scoring), smorch-brain, n8n |
| smo-dev | 62.171.165.57 | 100.117.35.19 | Dev/staging (content-automation, SSE), n8n testflow |
| smo-prod | 62.171.164.178 | 100.84.76.35 | Production (SalesMfast, other services), n8n flow.smorchestra.ai |
| smo-test | 84.247.172.113 | 100.105.86.13 | Test/QA server (future: eo-dev) |

6. PROJECT REGISTRY (master list — updated 2026-04-18)

Each project's CLAUDE.md must declare Git Remote, Server Path, PM2 Process, Deploy Command.

| Project | Claude Code Folder | GitHub Repo | Branch | Server | Server Path | PM2 |
|---------|-------------------|-------------|--------|--------|-------------|-----|
| EO MENA | CodingProjects/EO-MENA/ | SMOrchestra-ai/eo-mena | main | eo-prod | /root/eo-mena-new/ | eo-main |
| EO Scorecard Platform | CodingProjects/EO-Scorecard-Platform/ | SMOrchestra-ai/EO-Scorecard-Platform | dev | eo-prod | /var/www/eo-scoring/ | eo-scoring |
| Content Automation | CodingProjects/content-automation/ | SMOrchestra-ai/content-automation | dev | smo-dev | /root/content-automation/ | content |
| GTM Fitness Scorecard | CodingProjects/gtm-fitness-scorecard/ | SMOrchestra-ai/gtm-fitness-scorecard | dev | smo-prod | /opt/apps/gtm-fitness-scorecard/ | gtm-fitness-scorecard |
| Digital Revenue Score | CodingProjects/digital-revenue-score/ | SMOrchestra-ai/digital-revenue-score | dev | smo-prod | /opt/apps/digital-revenue-score/ | digital-revenue-score |
| EO Infra Platform | CodingProjects/contabo-mcp-server/ | SMOrchestra-ai/contabo-mcp-server | dev | N/A | N/A | N/A |
| Signal Sales Engine | CodingProjects/Signal-Sales-Engine/ | SMOrchestra-ai/Signal-Sales-Engine | dev | smo-dev | /root/Signal-Sales-Engine/ | TBD |
| SaaSFast | CodingProjects/SaaSFast/ | SMOrchestra-ai/SaaSFast | dev | TBD | TBD | TBD |
| SaaSfast-ar | CodingProjects/SaaSfast-ar/ | SMOrchestra-ai/SaaSfast-ar | main | N/A | N/A | N/A |
| Super AI Agent | — | SMOrchestra-ai/super-ai-agent | main | N/A | N/A | N/A |
| smorch-brain | CodingProjects/smorch-brain/ | SMOrchestra-ai/smorch-brain | dev | eo-prod | /root/smorch-brain/ | N/A |
| smorchestra-web | CodingProjects/smorchestra-web/ | SMOrchestra-ai/smorchestra-web | main | Netlify (auto-deploy on push) | N/A | N/A |

NOTE: EO Infra Platform (contabo-mcp-server) is a monorepo with 4 packages:
  packages/contabo-mcp/ — VPS provisioning MCP (Contabo API)
  packages/ssh-mcp/ — Server config MCP (SSH) — absorbed from ssh-mcp-server
  packages/eo-dashboard/ — Student deploy GUI (Next.js) — absorbed from eo-dashboard
  packages/super-ai-agent/ — AI agent SDK (idea → deployed app)

ARCHIVED REPOS (code absorbed into monorepo):
  ssh-mcp-server → now packages/ssh-mcp/ in contabo-mcp-server
  eo-dashboard → now packages/eo-dashboard/ in contabo-mcp-server

✅ ALL repos have .git at project root inside CodingProjects/.
✅ Home dir (~/) is NOT a git repo. smorch-brain lives at CodingProjects/smorch-brain/.
✅ Auto-deploy CI active on 5 repos. Push → build → SSH deploy.
✅ Drift detection: 2 n8n workflows (every 6h) → Telegram @smo_drift_alert_bot.
✅ GitHub orgs cleaned: SMOrchestra-ai = production (smo/eo), smorchestraai-code = dev/archived.

7. SESSION STARTUP GUARD (run before any code changes)
Before writing code, run these checks. If ANY fail, fix before proceeding:
```
git rev-parse --show-toplevel   # Must match the folder you opened
git remote -v                   # Must match the expected GitHub repo
git branch --show-current       # Must be main or dev (not detached)
git fetch origin && git status  # Must not be behind remote
```
If you're in a parent folder whose .git belongs to smorch-brain, STOP — cd into the correct subfolder.

SOPs & OPERATIONAL STANDARDS
All SOPs live at `CodingProjects/SOPs/`. Read `SOPs/INDEX.md` for the routing table.

When to reference which SOP:
- New project → SOP-12 (automated pre-flight) + PRD template
- Daily dev → DevOps Operations Manual (git, hooks, CI/CD, deploy)
- QA/review → SOP-01 (workflow) + SOP-02 (scoring gates) + QA Team Guide
- Deploy → DevOps Manual deploy section + DEPLOY-CHECKLIST template
- Handover to Lana → SOP-13 + LANA-HANDOVER-BRIEF template
- Incident → SOP-10 + INCIDENT-REPORT template
- Agent routing → SOP-07 (orchestration) + SOP-11 (Codex doctrine)
- Onboarding → MASTERPLAN + DevOps Manual + SOP-05 (roles)

Non-negotiable gates:
- No code without SOP-12 pre-flight passing
- No deploy without 90+ composite score (SOP-02)
- No PR to Lana without handover brief (SOP-13)
- No Codex without Mamoun approval (SOP-11)
- All changes: local → GitHub → server pull. Never edit on server.

DEV TOOLS — SKILLS & PLUGINS (USE THESE)

Three tool suites are installed globally. Use them — they're not decoration.

1. GSTACK (Garry Tan's engineering workflow)
Location: ~/.claude/skills/gstack
When to use:
- `/review` — EVERY PR, EVERY branch with changes. Run before creating PR. Non-negotiable.
- `/plan-eng-review` — Before starting major feature work. Architecture + eng review of plan.
- `/plan-ceo-review` — When scoping a new feature or product direction.
- `/qa` — After feature complete, run browser-based QA on staging URL.
- `/ship` — When ready to merge. Creates clean PR with review artifacts.
- `/investigate` — Bug reports, failing tests. Root cause analysis.
- `/design-review` — UI/UX changes. Catches AI slop in frontend code.
- `/land-and-deploy` — Merge + deploy flow with safety checks.
- `/retro` — End of sprint/week. Generates stats on what shipped.
- `/guard` / `/freeze` / `/unfreeze` — Protect critical code paths during releases.
- `/browse` — Use gstack browse for ALL web browsing, never mcp__claude-in-chrome__* directly.

2. SUPERPOWERS (obra's dev methodology)
Location: ~/.claude/skills/superpowers (individual skills, not slash commands)
When to use:
- `test-driven-development` — Default coding methodology. Write test first, implement, refactor.
- `systematic-debugging` — When a bug isn't obvious. Structured hypothesis → evidence → fix.
- `subagent-driven-development` — Complex multi-file changes. Dispatch parallel agents.
- `brainstorming` — Architecture decisions, technical approach selection.
- `dispatching-parallel-agents` — Speed up independent work across files/components.
- `verification-before-completion` — Self-check before marking work done.
- `writing-plans` / `executing-plans` — Structured planning for multi-step work.
- `requesting-code-review` / `receiving-code-review` — Code review patterns.

3. SMORCH-DEV-SCORING (5-Hat quality system)
Location: ~/.claude/plugins/smorch-dev/skills/smo-scorer
When to use:
- `/score-project` — Run 5-hat composite score. MANDATORY before every PR. Score saved to docs/qa-scores/.
- `/score-hat [hat]` — Score individual dimension (product, architecture, engineering, qa, ux-frontend).
- `/bridge-gaps` — When any hat scores below 8/10. Generates fix plan + auto-fixes where possible.
- `/calibrate` — Calibrate scorer against reference projects.

WORKFLOW INTEGRATION (how these chain together):
1. Start feature → superpowers:writing-plans → gstack:/plan-eng-review
2. During coding → superpowers:test-driven-development (TDD cycle)
3. Self-review → gstack:/review (4-dimension code review)
4. Quality gate → `/score-project` (must be 90+ composite)
5. If below 90 → `/bridge-gaps` → fix → re-score
6. PR creation → gstack:/ship
7. QA validation → gstack:/qa on staging URL
8. Deploy → gstack:/land-and-deploy
9. Post-sprint → gstack:/retro

PROJECT DOCS FOLDER (NON-NEGOTIABLE)
Every project MUST have a `docs/` folder at its root. This is mandatory, no exceptions.
- All handover briefs, audit reports, QA results, test plans, and generated documentation go in `docs/`.
- When creating any document (handover, audit, checkpoint, test plan, brief), save it to `docs/` — not `.claude/`, not loose in the repo.
- Subfolder structure: `docs/handovers/`, `docs/audits/`, `docs/qa/`, `docs/architecture/` as needed.
- When referencing files in Linear tickets, Telegram, or handovers: always include the full absolute server path AND the repo-relative path.
- When deploying files to a remote server: save to `docs/` in the project directory on that server too.
- If `docs/` doesn't exist in a project, create it immediately before saving any document.
- This applies to ALL projects — SSE, EO, content, GTM, everything. Zero exceptions.

SKILL MANAGEMENT
Follows SOP at docs/skill-management-sop.md. smorch-brain is single source of truth. Never edit skills directly on machines. SKILL.md under 500 lines. Run `smorch audit` before `smorch push`.

FILE NAMING
Proposals: [client]-[type]-[date].docx | Decks: [client]-[type]-[date].pptx
Campaigns: [name]-[channel]-v[version] | Skills: smorch-[category]-[specific].md
YouTube: yt-[lang]-[topic]-[date] | EO: eo-[step]-[component]-[date]

LANGUAGE DEFAULTS
Client-facing B2B: English | SalesMfast SME: Arabic-first | YouTube: check channel first
EO student-facing: Arabic-first | Internal/system docs: English | LinkedIn: English | WhatsApp: Arabic MENA, English international

WHAT NOT TO DO
- Produce output without identifying which business line it serves
- Default to Western/US market assumptions (MENA is primary)
- Duplicate rules from Layer 1 or Layer 3
- Use corporate buzzwords: "leverage," "synergy," "ecosystem," "holistic approach"
- Generate filler to look longer. Shorter and sharper > longer and weaker
- Ask "shall I proceed?" after every step. Just proceed unless plan changes.
