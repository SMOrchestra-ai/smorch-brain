# SMOrchestra AI-Native Organization — Final SOP

**Version:** 2.0 | **Date:** 2026-04-06 | **Owner:** Mamoun Alamouri

This is the single source of truth for how SMOrchestra's AI-native dev organization operates. Every agent (Sulaiman, al-Jazari, QA Lead, DevOps, GTM, Content, Data Eng) and every human (Mamoun, Lana) reads from this folder.

---

## Quick Navigation

| I need to... | Read this |
|---|---|
| Understand the full plan | [MASTERPLAN.md](MASTERPLAN.md) |
| Know which skills each agent has | [skills/](skills/) — one file per agent |
| Review QA protocol | [sops/SOP-01-QA-Protocol.md](sops/SOP-01-QA-Protocol.md) |
| Check scoring gates | [sops/SOP-02-Pre-Upload-Scoring.md](sops/SOP-02-Pre-Upload-Scoring.md) |
| Follow GitHub standards | [sops/SOP-03-Github-Standards.md](sops/SOP-03-Github-Standards.md) |
| Check server roles | [sops/SOP-04-Infrastructure-Node-Roles.md](sops/SOP-04-Infrastructure-Node-Roles.md) |
| Understand team hierarchy | [sops/SOP-05-Dev-Roles-Hierarchy.md](sops/SOP-05-Dev-Roles-Hierarchy.md) |
| Know when to involve Lana | [sops/SOP-06-Team-Distribution.md](sops/SOP-06-Team-Distribution.md) |
| Route work to Claude Code vs Codex | [sops/SOP-11-Codex-Doctrine.md](sops/SOP-11-Codex-Doctrine.md) |
| Handle an incident | [sops/SOP-10-Incident-Response.md](sops/SOP-10-Incident-Response.md) |
| Start a new project | [sops/SOP-12-Project-Onboarding-Auto.md](sops/SOP-12-Project-Onboarding-Auto.md) |
| Hand work to Lana | [sops/SOP-13-Lana-Handover-Protocol.md](sops/SOP-13-Lana-Handover-Protocol.md) |
| Write an ADR / PRD / Sprint Plan | [templates/](templates/) |
| Activate MENA context | [context/MENA-DEEP-OVERLAY.md](context/MENA-DEEP-OVERLAY.md) |
| Know when skills auto-fire | [context/SKILL-LIFECYCLE-TRIGGERS.md](context/SKILL-LIFECYCLE-TRIGGERS.md) |
| Set up Lana's machine | [lana/SETUP-GUIDE-WINDOWS.md](lana/SETUP-GUIDE-WINDOWS.md) |
| Check Lana's authority | [lana/DECISION-AUTHORITY-MATRIX.md](lana/DECISION-AUTHORITY-MATRIX.md) |
| Run pre-flight check | [onboarding/PROJECT-ONBOARD-CHECKLIST.md](onboarding/PROJECT-ONBOARD-CHECKLIST.md) |

---

## Folder Structure

```
final-sop/
├── README.md                  ← You are here
├── MASTERPLAN.md              ← Full injection plan (vision + execution)
│
├── sops/                      ← Standard Operating Procedures (13)
│   ├── SOP-01 to SOP-08      ← Original SOPs (cleaned)
│   ├── SOP-09                 ← Skill Injection Registry
│   ├── SOP-10                 ← Incident Response Protocol
│   ├── SOP-11                 ← Codex Doctrine
│   ├── SOP-12                 ← Project Onboarding Automation
│   └── SOP-13                 ← Lana Handover Protocol
│
├── skills/                    ← Per-agent skill manifests (7)
│   ├── SKILLS-CEO.md          ← Sulaiman
│   ├── SKILLS-VP-ENG.md       ← al-Jazari
│   ├── SKILLS-QA.md           ← QA Lead
│   ├── SKILLS-DEVOPS.md       ← DevOps
│   ├── SKILLS-GTM.md          ← GTM Specialist
│   ├── SKILLS-CONTENT.md      ← Content Lead
│   └── SKILLS-DATA-ENG.md     ← Data Engineer
│
├── templates/                 ← Reusable output templates (7)
│   ├── ADR-TEMPLATE.md
│   ├── PRD-TEMPLATE.md
│   ├── INCIDENT-REPORT.md
│   ├── DEPLOY-CHECKLIST.md
│   ├── SPRINT-PLAN.md
│   ├── WORKFORCE-PLAN.md
│   └── LANA-HANDOVER-BRIEF.md
│
├── context/                   ← Shared context layers (3)
│   ├── MENA-DEEP-OVERLAY.md   ← Injectable, not enforced
│   ├── SKILL-LIFECYCLE-TRIGGERS.md
│   └── SESSION-STRATEGY-MATRIX.md
│
├── lana/                      ← Lana's complete setup (6)
│   ├── SETUP-GUIDE-WINDOWS.md
│   ├── CLAUDE.md              ← Her global Claude Code config
│   ├── settings.json          ← Her hooks
│   ├── mcp.json               ← Her MCP connections
│   ├── DECISION-AUTHORITY-MATRIX.md
│   └── LANA-PROJECT-CONTEXT-TEMPLATE.md
│
└── onboarding/                ← Project startup (1)
    └── PROJECT-ONBOARD-CHECKLIST.md
```

---

## For AI Agents: Session Start Protocol

When starting a new session on any project:
1. Read this README for navigation
2. Read your SKILLS-[ROLE].md from skills/
3. Read the project's CLAUDE.md for project-specific rules
4. Check context/SKILL-LIFECYCLE-TRIGGERS.md to know when skills auto-fire
5. If MENA project: load context/MENA-DEEP-OVERLAY.md
6. If new project: run onboarding/PROJECT-ONBOARD-CHECKLIST.md

## For Lana: Getting Started

1. Follow [lana/SETUP-GUIDE-WINDOWS.md](lana/SETUP-GUIDE-WINDOWS.md) to set up your machine
2. Read [lana/DECISION-AUTHORITY-MATRIX.md](lana/DECISION-AUTHORITY-MATRIX.md) — this is your authority reference
3. For each project you work on, check if `.claude/LANA-PROJECT-CONTEXT.md` exists in the repo

## 5 Hard Rules

1. **smorch-brain is source of truth** — Never edit skills on servers directly
2. **Claude Code is default** — Codex only when Workforce Plan is approved by Mamoun
3. **Score before ship** — Composite >= 8/10 or it doesn't merge
4. **One message for blockers** — Pre-flight consolidates, don't ping Mamoun 5 times
5. **Context travels with work** — Every handover to Lana includes project context + authority level
