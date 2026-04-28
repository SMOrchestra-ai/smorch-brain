# Shared Scoring Dimensions — EO MicroSaaS OS V2

All skills use 10 scoring dimensions: **7 universal** (apply to every skill) + **3 skill-specific** (defined per skill).

## 7 Universal Dimensions (apply to ALL skills)

| # | Dimension | What It Measures | Scoring Guide |
|---|-----------|------------------|---------------|
| 1 | **Completeness** | Does the output contain ALL required sections/files? No missing pieces. | 10 = all sections present. 8 = 1 minor section missing. 6 = structural gap. |
| 2 | **Accuracy** | Is the extracted/generated content factually correct? Do numbers match source files? | 10 = zero errors. 8 = 1-2 minor mismatches. 6 = significant error. |
| 3 | **Language Compliance** | Is the output in the student's chosen language? Are tech terms in English? Gulf Arabic conversational (not MSA)? | 10 = perfect language match. 8 = minor language mix. 6 = wrong language or MSA formal. |
| 4 | **MENA Context** | Does the output reflect MENA realities? (WhatsApp, Tap/HyperPay, RTL, trust-first, Gulf culture) | 10 = MENA-native. 8 = mostly MENA. 6 = generic Western defaults. |
| 5 | **Actionability** | Can the student USE this output immediately? Copy-paste ready? No "fill in the blanks"? | 10 = zero editing needed. 8 = 1-2 fields need student input. 6 = requires significant editing. |
| 6 | **Upstream Dependency Use** | Does the output correctly read and reference files from prior phases? | 10 = all upstream files consumed. 8 = 1 file missed. 6 = critical upstream data ignored. |
| 7 | **Teaching Value** | Does the student understand WHY, not just WHAT? Did the skill explain decisions? | 10 = clear rationale for every decision. 8 = most decisions explained. 6 = output without explanation. |

## 3 Skill-Specific Dimensions (defined per skill)

### 0-eo-guide
| 8 | Phase Detection Accuracy | Correctly identifies which phase the student is in |
| 9 | Coaching Warmth | Tone is encouraging, not robotic. Uses founder language. |
| 10 | Route Correctness | Points student to the right next skill |

### 1-eo-brain-ingestion
| 8 | Extraction Depth | All 5 scorecards mined thoroughly, no data left on the table |
| 9 | Gap-Fill Quality | Coaching questions target real gaps, not generic prompts |
| 10 | Cross-File Consistency | About-Me, Project, and Layer 1-3 files tell a coherent story |

### 1-eo-template-factory
| 8 | Recipe Relevance | Templates match the student's GTM motion and business model |
| 9 | Context Injection | Brain file data correctly woven into recipe instructions |
| 10 | Variety | Universal + conditional recipes cover different workflow types |

### 2-eo-gtm-asset-factory
| 8 | Placeholder Fill Rate | % of {{PLACEHOLDER}} tags successfully replaced with real content |
| 9 | Brand Consistency | Colors, fonts, tone match brandvoice.md across all assets |
| 10 | Deploy Readiness | Files are production-ready (HTML renders, DOCX formatted, PPTX styled) |

### 3-eo-skill-extractor
| 8 | Student Decision Quality | Student made informed choices (not just accepting defaults) |
| 9 | SKILL.md Structure | Generated skill follows the correct format with all sections |
| 10 | Cross-Skill Integration | New skill connects to existing skills and data flows |

### 4-eo-tech-architect
| 8 | Stack Right-Sizing | Stack matches founder capability and 30-day MVP timeline |
| 9 | BRD Executability | User stories have clear acceptance criteria Claude Code can build from |
| 10 | Integration Completeness | MCP plan covers all tools from the student's GTM stack |

### 4-eo-code-handover
| 8 | INDEX Completeness | Every file in EO-Brain/ is listed with purpose and usage |
| 9 | Bootstrap Prompt Quality | Claude Code can initialize the entire project from one prompt |
| 10 | Gap Flagging | Missing files and incomplete phases are clearly documented |

---

## Scoring Protocol

- **Threshold:** 8.5/10 average across all 10 dimensions
- **If below 8.5:** Identify the 2 lowest dimensions. Fix them. Re-score.
- **Display format:** Show all 10 scores in a table. Highlight any below 8.
- **Never inflate.** A 7 is a 7. The student benefits from honest scoring.
