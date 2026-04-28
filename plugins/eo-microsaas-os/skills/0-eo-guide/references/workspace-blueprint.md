# EO-Brain Workspace Blueprint

**Version:** 2.0
**Used by:** 0-eo-guide (workspace scaffold on first run)

## Complete Directory Tree

Create this entire structure on first run. If any directory already exists, skip it. If files exist in Templates/, do NOT overwrite.

```
EO-Brain/
├── INDEX.md
├── README.md
├── _language-pref.md
├── _progress.md
│
├── 0-Scorecards/
│   └── (populated by eo-scoring-suite, external plugin)
│
├── 1-ProjectBrain/
│   ├── About-Me/
│   │   ├── my-background.md
│   │   ├── my-vision.md
│   │   ├── my-market.md
│   │   ├── my-goals.md
│   │   ├── my-operating-style.md
│   │   └── my-resources.md
│   ├── Project/
│   │   ├── companyprofile.md
│   │   ├── founderprofile.md
│   │   ├── brandvoice.md
│   │   ├── niche.md
│   │   ├── icp.md
│   │   ├── positioning.md
│   │   ├── competitor-analysis.md
│   │   ├── market-analysis.md
│   │   ├── strategy.md
│   │   └── gtm.md
│   ├── profile-settings.md
│   ├── cowork-instructions.md
│   ├── project-instruction.md
│   ├── templates/
│   └── output/
│
├── 2-GTM/
│   ├── Templates/
│   │   ├── preGTM/
│   │   │   ├── warm-whatsapp-msg.md
│   │   │   ├── cold-whatsapp-msg.md
│   │   │   ├── warm-linkedin-msg.md
│   │   │   ├── cold-linkedin-msg.md
│   │   │   ├── advisory-close-script.md
│   │   │   ├── outcome-demo-script.md
│   │   │   ├── landing-page.html
│   │   │   ├── one-pager.md
│   │   │   └── pitch-deck.md
│   │   ├── GTM/
│   │   │   ├── 01-waitlist-heat-to-webinar.md
│   │   │   ├── 02-build-in-public-trust.md
│   │   │   ├── 03-authority-education-engine.md
│   │   │   ├── 04-wave-riding.md
│   │   │   ├── 05-ltd-cash-to-mrr.md
│   │   │   ├── 06-signal-sniper-outbound.md
│   │   │   ├── 07-outcome-demo-first.md
│   │   │   ├── 08-hammering-feature-first.md
│   │   │   ├── 09-bofu-seo-strike.md
│   │   │   ├── 10-dream-100.md
│   │   │   ├── 11-7x4x11-strategy.md
│   │   │   ├── 12-value-trust-engine.md
│   │   │   ├── 13-paid-vsl-value-ladder.md
│   │   │   └── _MANIFEST.txt
│   │   └── deployment-guide.md
│   └── output/
│       ├── preGTM/
│       └── GTM/
│
├── 3-Newskills/
│   ├── Dev/
│   ├── GTM/
│   └── Ops/
│
├── 4-Architecture/
│   ├── tech-stack-decision.md
│   ├── brd.md
│   ├── mcp-integration-plan.md
│   └── db-architecture.md
│
└── 5-CodeHandover/
    ├── INDEX.md
    └── README.md
```

## File Creation Rules

1. **Create directories only.** Do NOT create placeholder files in Phase 1-5 folders. Those are populated by their respective skills.
2. **Exception:** `_language-pref.md`, `_progress.md`, `INDEX.md`, `README.md` are created by 0-eo-guide.
3. **If Templates/ has existing files**, do NOT overwrite. These are pre-loaded by the training program.
4. **Directory creation is idempotent.** Running scaffold multiple times should not break anything.

## Phase Folder Expectations

| Phase Folder | Populated By | Expected File Count |
|-------------|-------------|-------------------|
| 0-Scorecards/ | eo-scoring-suite (external) | 5 SC files + 1 founder brief = 6 |
| 1-ProjectBrain/ | 1-eo-brain-ingestion, 1-eo-template-factory | ~20-25 files total |
| 2-GTM/Templates/ | Pre-loaded by training | 9 preGTM + 13 GTM + 1 manifest + 1 guide = 24 |
| 2-GTM/output/ | 2-eo-gtm-asset-factory | 4-5 preGTM + 1 GTM playbook |
| 3-Newskills/ | 3-eo-skill-extractor (student-driven) | 1+ skills |
| 4-Architecture/ | 4-eo-tech-architect | 4 documents |
| 5-CodeHandover/ | 4-eo-code-handover | INDEX.md + README.md + manifest |
