# Quality Gate Enforcement Protocol

All commands and skills in the EO MicroSaaS OS must check these gates before executing. Gates are HARD STOPS. No exceptions. No "I'll do it later" bypasses.

## Gate Definitions

### Gate 0: Scorecard Minimum
**Checks before**: Brain Ingestion (Step 1)
**Required files** (at least ONE path must pass):

- **Path A (Web)**: SC1-*.md AND SC2-*.md exist in workspace
- **Path B (DOCX)**: Scoring DOCX files uploaded and processed into SC format
- **Path C (In-Plugin)**: SC1 and SC2 scoring output files exist
- **Path D (Templates)**: All 8 brain templates exist with 300+ chars each

**Check method**:
```
Glob: **/SC1*.md → must find at least 1 file
Glob: **/SC2*.md → must find at least 1 file
OR
Glob: **/brain-templates/problem.md → check wc -c > 300
Glob: **/brain-templates/icp.md → check wc -c > 300
(repeat for all 8 templates)
```

**Fail message**: "You need scorecard results before I can build your brain files. Three options: (1) Complete them at score.entrepreneursoasis.me, (2) Upload scoring DOCX files, or (3) Run /eo-score 1 to do them right here. Alternatively, run /eo-templates for the manual path."

### Gate 1: Brain Completeness
**Checks before**: GTM Assets (Step 2), Tech Architecture (Step 4)
**Required**: 12 files in project-brain/ directory

**Check method**:
```
For each of these 12 filenames:
  companyprofile.md, founderprofile.md, brandvoice.md, niche.md,
  icp.md, positioning.md, competitor-analysis.md, market-analysis.md,
  strategy.md, gtm.md, project-instruction.md, cowork-instruction.md

  1. Glob: **/project-brain/{filename} → must exist
  2. Read file → wc -c must be > 200
  3. Content must contain actual answers (not just template headers)
```

**Fail message**: "Your brain files are incomplete. [X]/12 files found. Missing: [list missing files]. Without complete context, everything I generate downstream will be generic. Run /eo to fix this."

**Partial pass**: If 8+ files exist with 200+ chars each, allow GTM Assets and Tech Architecture but flag: "Warning: [missing files] are empty. Outputs will be weaker in those areas. Recommend completing them."

### Gate 2: Architecture + CLAUDE.md Exists
**Checks before**: Graduation (/eo-graduate) AND any dev skill (eo-db-architect, eo-microsaas-dev, eo-api-connector)
**Required**: architecture/brd.md AND architecture/tech-stack-decision.md AND CLAUDE.md
**Environment**: Architecture is produced in Cowork (Phase 1, Step 4). Must exist before graduation.

**Check method**:
```
Glob: **/architecture/brd.md → must exist, wc -c > 500
Glob: **/architecture/tech-stack-decision.md → must exist, wc -c > 200
Glob: **/CLAUDE.md → must exist, wc -c > 300
```

**Fail message**: "No BRD or CLAUDE.md found. Architecture must be done before graduation. Run eo-tech-architect in Cowork first. It will produce your BRD, stack decisions, MCP plan, and CLAUDE.md that configures Claude Code automatically."

### Gate 3: Code Exists
**Checks before**: QA Testing (eo-qa-testing)
**Required**: Source code directory with actual application files

**Check method**:
```
Glob: **/src/**/*.{ts,tsx,js,jsx} → must find at least 5 files
OR
Glob: **/app/**/*.{ts,tsx,js,jsx} → must find at least 5 files
```

**Fail message**: "No application code found. QA testing needs something to test. Complete the build phase first (eo-microsaas-dev)."

### Gate 4: QA Pass
**Checks before**: Security Hardening (eo-security-hardener)
**Required**: qa-report.md with PASS status

**Check method**:
```
Glob: **/qa-report.md → must exist
Grep: "PASS" or "Status: PASS" in qa-report.md
Must NOT contain: "FAIL" or "Status: FAIL" in the overall status line
```

**Fail message**: "QA report shows failures. Fix the issues listed in qa-report.md before running security. Security auditing broken code wastes time."

### Gate 5: Security Pass
**Checks before**: Deployment (eo-deploy-infra)
**Required**: security-audit.md with zero CRITICAL findings

**Check method**:
```
Glob: **/security-audit.md → must exist
Grep: "CRITICAL" in security-audit.md
Count CRITICAL findings → must be 0
```

**Fail message**: "You have [N] CRITICAL security issues. These must be resolved before deployment. Each CRITICAL finding in security-audit.md has a specific fix. Apply them, then rerun security hardening."

## Gate Check Protocol

Every skill and command MUST run gate checks before executing. The check sequence:

```
1. Determine which gate applies to the requested action
2. Run ALL file existence checks for that gate
3. Run content quality checks (char count, keyword presence)
4. If ANY check fails:
   a. Display the fail message
   b. Show what's missing specifically
   c. Suggest the exact command to fix it
   d. DO NOT proceed with the requested action
5. If ALL checks pass:
   a. Display brief confirmation: "Gate [N] passed. Proceeding."
   b. Execute the requested skill/action
```

## Gate Override (NONE)

There is no override mechanism. If a founder asks to skip a gate, respond:

"I get it, you want to move fast. But these gates exist because I've seen what happens without them: founders build apps with no ICP clarity and wonder why nobody signs up. Founders deploy code with CRITICAL security holes and get their database dumped. The gates save you from expensive mistakes. Let's fix [specific blocker] first. It'll take [estimated time]."

## Gate Status Display

When showing gates in /eo-status, use this format:

```
Quality Gates
=============
Gate 0: Scorecards ...... PASSED (SC1: 96, SC2: 97, SC3: 96, SC4: 97, SC5: 85)
Gate 1: Brain Files ..... PASSED (12/12, all >200 chars)
Gate 2: Architecture .... FAILED (brd.md missing)
Gate 3: Code ............ LOCKED (needs Gate 2)
Gate 4: QA .............. LOCKED (needs Gate 3)
Gate 5: Security ........ LOCKED (needs Gate 4)
```

States:
- **PASSED**: All checks cleared
- **FAILED**: Checks ran but didn't pass (show what's missing)
- **LOCKED**: Can't even check yet (upstream gate not passed)
- **SKIPPED**: Not applicable (e.g., Gate 0 skipped when using template path)
