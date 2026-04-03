# File Naming Conventions and Appendices - eo-brain-ingestion

Reference documentation for file organization, score extraction patterns, and error handling.

## FILE NAMING CONVENTIONS

All output files go into a `project-brain/` directory:

```
project-brain/
  companyprofile.md
  founderprofile.md
  brandvoice.md
  niche.md
  icp.md
  positioning.md
  competitor-analysis.md
  market-analysis.md
  strategy.md
  gtm.md
  personal-preferences.md     [NEW]
  cowork-instruction.md        [REVISED]
  project-instruction.md       [REVISED]
```

File names are fixed. Do not rename them. Downstream skills depend on these exact names.

---


## SELF-SCORE PROTOCOL

After generating all 13 files, score the output across 8 dimensions before delivering to the student.

### Scoring Dimensions

| # | Dimension | What to Check | Scoring |
|---|-----------|---------------|---------|
| 1 | Extraction accuracy | Every field traces to a scorecard answer, coached answer, or gap-fill response. Zero fabricated data. | 10 = all traceable, 8 = 1-2 inferred, 6 = 3+ inferred, <6 = fabricated data present |
| 2 | Completeness | All 13 files generated. No empty sections. No "[TODO]" markers except in technical placeholders. | 10 = all complete, 8 = 1-2 thin sections, 6 = 3+ gaps, <6 = missing files |
| 3 | Instruction quality | All 3 instruction files follow the 6 design principles (positive framing, behavioral rules, critical at edges, verifiable, no duplication, meta-patterns). | 10 = all 6 applied, 8 = 4-5 applied, 6 = 2-3 applied, <6 = generic instructions |
| 4 | Layer separation | No content duplicated across the 3 instruction layers. Each layer contains only what belongs at its scope. | 10 = zero duplication, 8 = minor overlap, 6 = significant overlap, <6 = layers confused |
| 5 | Thesis capture | personal-preferences.md CORE THESIS accurately reflects the founder's contrarian belief, not a generic statement. | 10 = specific + contrarian + evidence-backed, 8 = specific but missing one element, 6 = generic, <6 = wrong |
| 6 | Archetype alignment | Operating modes, decision framework, and quality standards align with the founder's archetype. | 10 = all aligned, 8 = mostly aligned, 6 = partially, <6 = mismatched |
| 7 | MENA context | Regional specifics present in all relevant files. Trust mechanics, WhatsApp, Arabic, payment methods. | 10 = thorough, 8 = present but thin, 6 = mentioned once, <6 = missing |
| 8 | Actionability | Student can paste personal-preferences.md immediately. cowork-instruction.md works as-is for CLAUDE.md. project-instruction.md is a functional onboarding doc. | 10 = paste-ready, 8 = needs minor edits, 6 = needs restructuring, <6 = not usable |

### Scoring Output

Present this table after generation:

```
SELF-SCORE: Brain Ingestion Output Quality
===========================================
1. Extraction accuracy     [X]/10
2. Completeness            [X]/10
3. Instruction quality     [X]/10
4. Layer separation        [X]/10
5. Thesis capture          [X]/10
6. Archetype alignment     [X]/10
7. MENA context            [X]/10
8. Actionability           [X]/10
-----------------------------------------
OVERALL                    [AVG]/10

[If any dimension < 8: "FLAG: [dimension] scored [X]/10. Reason: [specific gap]. Suggested fix: [action]."]
[If overall < 8.5: "ITERATE: Overall score below threshold. Improving [weakest dimensions] before delivery."]
```

### Threshold

- Minimum overall score to deliver: 8.5/10
- If below 8.5: iterate on the weakest dimensions automatically before presenting to student
- If a single dimension is below 7: fix it before delivering regardless of overall score

---

## APPENDIX: SCORE EXTRACTION PATTERNS

### SC1 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
Dimension scores: Look for Section headers with `(XX points)` and scored answers

### SC2 Score Pattern
Look for: `**Clarity Score:** XX/100` in first 10 lines
Dimension scores: Look for table with columns `| Dimension | Score | Status |`

### SC3 Score Pattern
Look for: `**Overall Score:** XX/100` in first 10 lines
Dimension scores: Look for table with columns `| Dimension | Score | Max | Percentage |`

### SC4 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
No dimension-level scores (path selection is holistic)

### SC5 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
Motion scores: Look for table with columns `| # | Motion | Fit | Readiness | MENA | Score | Tier |`
Count motions with Tier = PRIMARY. Need >= 3.

---

## APPENDIX: ERROR HANDLING

| Error | Response |
|-------|----------|
| Missing scorecard file | "I cannot find [SC name]. Have you completed this scorecard? If yes, tell me the exact filename." |
| Score not parseable | "I cannot read the score from [filename]. Can you tell me your score for [SC name]?" |
| File is empty or corrupt | "The file [filename] appears empty. Please check it and re-upload." |
| Student wants to skip coaching | "I can proceed, but I will flag the weak areas in your output files. Downstream skills may ask you to strengthen these later." |
| Student wants to re-run a scorecard | "Go ahead. Run the scorecard skill, then come back here and I will re-ingest. I will not lose your other data." |
| Dimension data is missing from file | "Your [SC name] file is missing [field]. This sometimes happens with older scorecard versions. Can you answer this quickly: [targeted question]?" |
| Gap-fill answer too short | "I can work with that, but the [section] in your output will be thinner. Want to expand, or should I proceed and flag it?" |
| Self-score below threshold | Iterate on weak dimensions automatically. Tell student: "I scored my own output at [X]/10. Improving [dimensions] before delivering to you." |

---

*Generated by EO MicroSaaS Operating System - Brain Ingestion Engine v2.0*

