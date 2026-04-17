# SMOrchestra SOPs — Single Source of Truth

**Location:** `smorch-brain/sops/` (GitHub: SMOrchestra-ai/smorch-brain)
**Last Updated:** 2026-04-17

---

## Quick Start

**Before ANY coding session, follow SOP-10:**
1. Right folder? `git rev-parse --show-toplevel`
2. Right remote? `git remote get-url origin`
3. Pulled latest? `git fetch && git status`
4. Right branch? `git branch --show-current`

**After EVERY coding session:**
1. All committed? `git status` (clean)
2. Pushed? `git push`
3. Server deployed? (if merging)
4. 3-way sync? local = GitHub = server

---

## SOP Index

| SOP | Title | Scope |
|-----|-------|-------|
| [SOP-01](SOP-01-QA-Protocol.md) | QA Protocol | Testing and quality gates |
| [SOP-02](SOP-02-Pre-Upload-Scoring.md) | Pre-Upload Scoring | Score work before pushing |
| [SOP-03](SOP-03-Github-Standards.md) | GitHub Standards | Repo management, two-account architecture |
| [SOP-04](SOP-04-Infrastructure-Node-Roles.md) | Infrastructure | Server roles and deployment |
| [SOP-05](SOP-05-Dev-Roles-Hierarchy.md) | Development Roles | Team hierarchy |
| [SOP-06](SOP-06-Team-Distribution.md) | Team Distribution | Human collaboration protocol |
| [SOP-07](SOP-07-Agentic-Coding-Orchestration.md) | Agentic Coding | AI agent orchestration |
| [SOP-08](SOP-08-Project-Kickoff-PreDev-Check.md) | Project Kickoff | Pre-dev verification |
| [SOP-09](SOP-09-Skill-Injection-Registry.md) | Skill Injection | Agent skill management |
| **[SOP-10](SOP-10-Session-Start-Finish.md)** | **Session Start & Finish** | **Enforced checklist for every session** |
| **[SOP-11](SOP-11-GitHub-Org-Cleanup.md)** | **GitHub Org Cleanup** | **Repo governance + cleanup plan** |

## Supporting Files

| File | Purpose |
|------|---------|
| [MASTERPLAN.md](MASTERPLAN.md) | Autopilot AI org architecture |
| [MAMOUN-GUIDE.md](MAMOUN-GUIDE.md) | CEO operating guide |
| [skills/](skills/) | Role-specific skill definitions |
| [onboarding/](onboarding/) | Project onboarding checklist |
