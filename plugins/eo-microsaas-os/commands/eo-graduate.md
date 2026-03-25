---
description: Generate your Claude Code handoff package
allowed-tools: Read, Write, Glob, Grep, Bash(ls:*), Bash(wc:*), Bash(mkdir:*), Bash(cp:*)
---

The founder is ready to transition from Cowork (Strategy + Architecture Phase) to Claude Code (Build Phase). Generate a complete handoff package.

Read the orchestrator for context:
@${CLAUDE_PLUGIN_ROOT}/skills/eo-os-navigator/SKILL.md

## Pre-Flight Check

Before generating the handoff, verify ALL prerequisites exist. Scan the workspace:

1. **Brain files**: Glob for `**/project-brain/*.md` - need 12 files, each with 200+ chars
2. **Scorecard results**: Glob for `**/SC[1-5]*.md` - need at least SC1 + SC2
3. **Architecture docs**: Glob for `**/architecture/brd.md` AND `**/architecture/tech-stack-decision.md` - MUST exist (Gate 2)
4. **CLAUDE.md**: Glob for `**/CLAUDE.md` - MUST exist (produced by eo-tech-architect)
5. **Founder brief**: Glob for `**/founder-brief*.md` or `**/eo-founder-brief*.md`

If brain files are missing or incomplete, STOP and say:
"You can't graduate yet. Your brain files are incomplete. Run /eo to see what's missing."

If architecture docs or CLAUDE.md are missing, STOP and say:
"You can't graduate yet. Architecture must be complete first. Run eo-tech-architect to produce your BRD, stack decisions, and CLAUDE.md. This is Step 4 and it runs right here in Cowork."

If prerequisites pass, continue.

## Generate Handoff Package

Create a directory called `claude-code-handoff/` in the workspace with:

### 1. HANDOFF-BRIEFING.md

Write this file with the following structure (pull real data from the brain files):

```markdown
# EO MicroSaaS OS - Claude Code Handoff Briefing

Generated: [today's date]
Founder: [from founderprofile.md]
Venture: [from companyprofile.md]
Overall Readiness: [from founder brief if available]

## What You've Completed

### Strategy + Architecture Phase (Cowork)
- [x] Scorecards: [list which SC files exist with scores]
- [x] Brain Ingestion: [count]/12 files generated
- [x] GTM Assets: [YES/NO - list what was generated]
- [x] Skill Extraction: [YES/NO]
- [x] Tech Architecture: [YES - list brd.md, tech-stack-decision.md, architecture-diagram.md, mcp-integration-plan.md]
- [x] CLAUDE.md: [YES - workspace instructions for Claude Code]

### What's Next (Claude Code)
- [ ] Step 5a: Database Architecture → schema + migrations
- [ ] Step 5b: Application Build → full app code
- [ ] Step 5c: API Integrations → third-party connections
- [ ] Step 5d: QA Testing → code quality + functional + UX
- [ ] Step 5e: Security Hardening → 7-domain audit
- [ ] Step 5f: Deployment → Docker + CI/CD + go live

## Your Context Files (Copy These to Claude Code)

These files ARE your project brain. They give Claude full context about your business:

### Project Files
- project-brain/companyprofile.md
- project-brain/founderprofile.md
- project-brain/brandvoice.md
- project-brain/niche.md
- project-brain/icp.md
- project-brain/positioning.md
- project-brain/competitor-analysis.md
- project-brain/market-analysis.md
- project-brain/strategy.md
- project-brain/gtm.md
- project-brain/project-instruction.md
- project-brain/cowork-instruction.md

### Scorecard Results
[list actual SC files found]

### Architecture Documents
- architecture/brd.md - Business Requirements Document
- architecture/tech-stack-decision.md - Stack decisions with rationale
- architecture/architecture-diagram.md - System diagrams (Mermaid)
- architecture/mcp-integration-plan.md - Integration roadmap

### CLAUDE.md
Workspace instructions file. Claude Code reads this automatically on startup.
Contains: project context, stack decisions, skill routing, build instructions.

### Founder Brief
[if exists, list path]

## Setup Instructions for Claude Code

### Step 1: Install required MCPs
Before opening Claude Code, install the MCPs listed in architecture/mcp-integration-plan.md.
At minimum, you need the tools your stack depends on (Supabase, Contabo, etc.).

### Step 2: Create your project directory
```bash
mkdir my-microsaas && cd my-microsaas
```

### Step 3: Copy your handoff files
Copy from this handoff package into your project root:
- `CLAUDE.md` (must be at project root - Claude Code reads it automatically)
- `project-brain/` folder (all 12 context files)
- `architecture/` folder (BRD + stack decisions + diagrams)
- `scorecards/` folder (assessment results)

### Step 4: Install the plugin
Make sure eo-microsaas-os plugin is installed in Claude Code.

### Step 5: Start building
Open Claude Code in your project directory. It reads CLAUDE.md automatically.
Say: "/eo" and the navigator picks up from Step 5a (Database Architecture).

Claude Code already knows: what you're building, which stack to use, which skills to invoke, and your full business context. Zero cold-start.

## Key Decisions Locked In (From Your Brain Files)

[Read and summarize key decisions from the brain files:]
- **Niche**: [from niche.md]
- **ICP**: [from icp.md - one-line summary]
- **Positioning**: [from positioning.md - the wedge statement]
- **Strategy Path**: [from strategy.md - primary path]
- **Top GTM Motions**: [from gtm.md - PRIMARY tier motions]
- **Brand Voice**: [from brandvoice.md - tone summary]

## Estimated Build Timeline

Based on your resource profile and strategy path:
[Pull from my-resources equivalent in founderprofile.md to estimate]

| Phase | Estimated Hours |
|-------|----------------|
| Database Design | 30-60 minutes |
| Application Build | 2-6 hours |
| API Integrations | 1-3 hours |
| QA + Security | 2-3 hours |
| Deployment | 1-2 hours |
| **Total** | **8-17 hours** |
```

### 2. Copy CLAUDE.md

Copy the CLAUDE.md file to `claude-code-handoff/CLAUDE.md` (project root level).

### 3. Copy brain files

Copy the entire `project-brain/` directory into `claude-code-handoff/project-brain/`.

### 4. Copy architecture docs

Copy the entire `architecture/` directory into `claude-code-handoff/architecture/`.

### 5. Copy scorecard results

Copy all SC*.md files into `claude-code-handoff/scorecards/`.

### 6. Copy founder brief

If it exists, copy to `claude-code-handoff/`.

## Graduation Message

After generating the package, tell the founder:

"Your handoff package is ready in `claude-code-handoff/`.

What's inside:
- CLAUDE.md - workspace instructions (Claude Code reads this automatically)
- HANDOFF-BRIEFING.md - your full status and setup instructions
- project-brain/ - all 12 context files
- architecture/ - BRD, stack decisions, diagrams, MCP plan
- scorecards/ - your assessment results

**Next steps:**
1. Install the MCPs listed in architecture/mcp-integration-plan.md
2. Copy `claude-code-handoff/` contents to your Claude Code project directory
3. Make sure CLAUDE.md is at the project root
4. Install the eo-microsaas-os plugin in Claude Code
5. Open Claude Code and say '/eo' - the navigator picks up from Step 5a

Your strategy and architecture phase is done. Claude Code knows everything. Time to build."
