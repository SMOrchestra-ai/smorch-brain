# Self-Learning Protocol — Build Log, Pattern Capture, Correction Cascade

## PURPOSE
This system gets smarter with every brain it builds. Corrections become rules. Patterns become defaults. Weak fields get better questions. The protocol has 4 components: Build Log, Pattern Capture, Correction Cascade, and Template Evolution.

---

## 1. BUILD LOG

### Location
`/projects/[client-name]/brain-log.md`

### Read Protocol
- READ brain-log.md at the start of every new brain creation (if it exists from a previous version)
- READ the master build-log at `references/build-log-master.md` at the start of every brain creation (captures cross-project patterns)

### Write Protocol
Write to the project's brain-log.md after every brain delivery AND after every brain update.

### Format
```markdown
## [YYYY-MM-DD] — Brain [Created | Updated]

### Metadata
- Project: [client name]
- Mode: DEEP | QUICK
- Project type: [type code]
- Input types: [PPTX, DOCX, PDF, verbal, URL — list all used]
- Input files: [filename1.pptx, filename2.docx, etc.]

### Extraction
- Extraction yield: [X/Y fields from files] ([percentage]%)
- High confidence fields: [count]
- Medium confidence fields: [count]
- Low confidence fields: [count]
- Unclassified content: [count of unmatched sections]

### Gap-Fill
- Rounds: [N]
- Questions asked: [M]
- User provided (A): [count]
- System researched (B): [count]
- Deferred (C): [count]
- Completeness improvement: [X% → Y%]

### Quality
- Overall score: [X/10]
- Per dimension: [list all 8 with scores]
- Auto-iterations: [count, which dimensions]
- Below-threshold flags: [list if any]

### Corrections
- Spot-check corrections: [list each: "field X: changed from A to B, reason: C"]
- Post-delivery corrections: [added when user corrects after delivery]

### Patterns Learned
- [Pattern 1: what to do differently next time, with specific rule]
- [Pattern 2: ...]

### Unresolved
- [UNDEFINED] fields remaining: [list with descriptions]
```

### Master Build Log
After completing a brain, also append a summary to `references/build-log-master.md`:

```markdown
## [date] — [client-name] ([type], [mode])
- Yield: [X%] | Score: [X/10] | Corrections: [count]
- Key pattern: [one-sentence lesson learned]
```

---

## 2. PATTERN CAPTURE

### When to Capture
Capture a pattern whenever:
- Mamoun corrects a brain file (any correction, no matter how small)
- The same gap appears in 2+ consecutive brains
- A field consistently scores WEAK across brains
- A specific input type consistently fails to provide certain data
- A question phrasing consistently gets better/worse answers

### Pattern Format
```markdown
### Pattern: [short descriptive name]
- Source: [which brain(s) triggered this]
- Observation: [what happened]
- Rule: [what to do going forward]
- Applies to: [which brain file(s) / field(s)]
- Confidence: [HIGH if seen 3+ times, MEDIUM if 2 times, LOW if 1 time but Mamoun explicitly stated it]
```

### Pattern Storage
- Project-specific patterns: in the project's brain-log.md under "Patterns Learned"
- Cross-project patterns: in `references/patterns.md`
- When a pattern reaches HIGH confidence (3+ occurrences): promote to `references/extraction-map.md` as a rule

### Example Patterns

```markdown
### Pattern: SME Decomposition
- Source: Project Alpha, Project Beta, Project Gamma
- Observation: Mamoun always changes "SMEs" or "businesses" to specific role + industry + geography
- Rule: NEVER use "SMEs" or "businesses" as ICP descriptor. Always decompose to: [role] at [company type] in [city/country]
- Applies to: icp.md (Primary Persona), company-profile.md (Market section)
- Confidence: HIGH (corrected 5 times across 3 projects)

### Pattern: WhatsApp Default for MENA Warm
- Source: Project Alpha, Project Delta
- Observation: Mamoun always moves WhatsApp above email for warm MENA leads in GTM channels
- Rule: For any MENA project, WhatsApp is PRIMARY channel for warm leads. Email is SECONDARY
- Applies to: gtm-channels.md (Primary Channels), mena-context.md
- Confidence: HIGH (corrected 3 times)

### Pattern: Pricing Context Required
- Source: Project Beta
- Observation: Mamoun added competitive pricing comparison when offer.md only had the client's price
- Rule: offer.md Pricing section must always include at least one competitor's price as anchor
- Applies to: offer.md (Pricing section)
- Confidence: MEDIUM (corrected 2 times)
```

---

## 3. CORRECTION CASCADE

### When It Triggers
Any time a brain file is corrected (by user during spot-check, or post-delivery), the cascade runs.

### Cascade Rules

| File Changed | Check These Files | Specific Validation |
|-------------|-------------------|---------------------|
| **icp.md** | positioning.md | Top pain still appears in positioning statement? |
| | gtm-channels.md | Access channels still match channel priorities? |
| | offer.md | Price still within ICP budget range? |
| | project-instruction.md | ICP summary section matches? Decision framework references correct pain? |
| | mena-context.md | Geography/language preferences still align? |
| **positioning.md** | project-instruction.md | Positioning anchor section matches? Wedge matches? |
| | competitive-landscape.md | Unique mechanism still addresses identified gap? |
| | brand-voice.md | Voice examples still reflect positioning tone? |
| **offer.md** | icp.md | Price vs. budget alignment? |
| | competitive-landscape.md | Competitive pricing comparison still accurate? |
| | engagement-model.md | Deliverables still match offer value stack? |
| **competitive-landscape.md** | positioning.md | Gap exploitation still valid? Differentiators hold? |
| **gtm-channels.md** | project-instruction.md | GTM Priority section matches? |
| | mena-context.md | Channel preferences align with regional rules? |
| **brand-voice.md** | project-instruction.md | No contradiction with voice rules |
| **company-profile.md** | ALL files | Venture name, category, market still consistent? |
| **Any type-specific file** | project-instruction.md | File references list still complete? |

### Cascade Execution
1. Identify which file changed and what changed
2. Look up the cascade table above
3. Read each affected file
4. Check the specific validation
5. If inconsistency found: update the affected file with the correction
6. Tag the update: `[CASCADE: corrected to align with [source-file] update on [date]]`
7. Log all cascade actions in brain-log.md

### Cascade Depth
- Maximum 2 levels. If a cascade update triggers another cascade, stop and flag for user review
- Never cascade into global CLAUDE.md (project-instruction.md is the boundary)

---

## 4. TEMPLATE EVOLUTION

### Trigger
Run template evolution analysis after every 5 brains built (track count in build-log-master.md).

### Analysis Steps

1. **Default Detection**
   - Read build-log-master.md for all completed brains
   - For each brain file field: check if the value is identical or near-identical across 3+ brains
   - If yes: add as default value in the brain file template
   - Example: If mena-context.md always says "WhatsApp > email for warm leads" → make it a template default

2. **Weak Field Analysis**
   - For each brain file field: check quality scores across all brains
   - If a field scores WEAK (below 6/10) in 3+ brains: the question or template for that field needs improvement
   - Rewrite the intake question to be more specific
   - Add example answers to help the user calibrate
   - Example: If "Unique mechanism" is always weak → add: "Think of this as: what do you do that competitors structurally cannot copy? Not 'better UX' but 'proprietary signal detection from 10 data sources.'"

3. **Optional Field Reclassification**
   - For each RECOMMENDED or CONDITIONAL field: check how often it's populated across brains
   - If populated in <20% of brains: downgrade to OPTIONAL
   - If populated in >80% of brains: upgrade to RECOMMENDED or REQUIRED
   - Example: If content-plan.md is deferred in 4/5 brains → downgrade to OPTIONAL

4. **Question Refinement**
   - Review all gap-fill questions asked across all brains
   - For questions where user always picks (C) DEFER: the question might be premature. Move it to Round 2 or remove
   - For questions where user always picks (A) PROVIDE with detailed answers: the question is well-phrased. Keep it
   - For questions where user always picks (B) RESEARCH: the system should pre-research this before asking

### Evolution Output
After analysis, update:
- Brain file templates (in architecture doc or template reference files)
- Intake questions (in SKILL.md Round 1/2/3 definitions)
- references/extraction-map.md (new patterns from accumulated data)
- references/patterns.md (promoted patterns)
- references/build-log-master.md (mark "Template Evolution Run: [date]")

---

## INITIALIZATION

When the skill is first deployed (no build-log-master.md exists yet):
1. Create `references/build-log-master.md` with header: "# Master Build Log"
2. Create `references/patterns.md` with header: "# Cross-Project Patterns"
3. Both files start empty and accumulate data from production usage
4. Template evolution does NOT run until 5+ brains exist
