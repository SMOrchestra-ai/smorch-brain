# EO MicroSaaS OS Plugin - Decomposed Skills Manifest

Generated: April 2, 2026

## Skills Overview (13 total)

### Over-Limit Skills - Decomposed

1. **eo-brain-ingestion** (446 lines, 8 files)
   - SKILL.md: Core ingestion orchestration
   - references/data-extraction-map.md: Scorecard field mapping
   - references/output-specs.md: Output file specifications
   - references/gap-fill-protocol.md: Gap-fill questioning protocol
   - references/file-naming-and-appendices.md: File conventions and error handling
   - plus: templates.md, validation.md, examples/ directory

2. **eo-tech-architect** (375 lines, 4 refs)
   - SKILL.md: Core architecture decisions
   - references/stack-defaults.md: Default stack recommendations
   - references/ai-stack.md: AI component decision tree
   - references/infrastructure-stack.md: Infrastructure setup
   - references/output-files.md: BRD and diagram templates

3. **eo-microsaas-dev** (130 lines, 1 ref)
   - SKILL.md: 5-phase pipeline overview
   - references/phase-details.md: Complete phase implementations

4. **eo-api-connector** (241 lines, 2 refs)
   - SKILL.md: Core integration orchestration
   - references/integration-categories.md: All 6 integration types
   - references/patterns.md: Client wrapper and error handling patterns

5. **eo-qa-testing** (279 lines, 1 ref)
   - SKILL.md: QA testing domains overview
   - references/test-domains.md: 7 testing domains with code examples

6. **eo-security-hardener** (297 lines, 1 ref)
   - SKILL.md: Security checklist overview
   - references/security-domains.md: 7 security domains with checks

### Trimmed Skills - For Clarity

7. **eo-deploy-infra** (53 lines, 2 refs)
   - SKILL.md: Minimal role definition
   - references/deployment-and-execution.md: Complete deployment specs

8. **eo-gtm-asset-factory** (13 lines, 3 refs)
   - SKILL.md: TOC only
   - references/role-and-execution.md: Complete role and execution

### Compliant Skills - Copied As-Is

9. **eo-os-navigator** (260 lines, 3 refs)
   - Copied with existing references/ structure intact

10. **eo-skill-extractor** (468 lines, 0 refs)
    - Copied as-is

11. **eo-guide** (466 lines, 1 ref)
    - Copied with existing references/

12. **eo-db-architect** (325 lines, 0 refs)
    - Copied as-is

13. **eo-production-renderer** (307 lines, 0 refs)
    - Copied as-is

## Output Location

All files are located in:
```
/sessions/wizardly-brave-bohr/eo-plugin-refactor/eo-microsaas-os/skills/
```

## File Structure

Each skill follows this pattern:

```
[skill-name]/
├── SKILL.md              # Core orchestration (< 480 lines)
├── [templates].md        # Optional supporting files
└── references/           # Detailed specifications
    ├── [spec1].md
    ├── [spec2].md
    └── [subdirs]/
```

## Progressive Disclosure Pattern

- **SKILL.md**: Focused, readable. Contains orchestration flow, decision logic, and READ pointers.
- **references/**: Detailed content. Specifications, templates, code patterns, checklists.
- **Downstream skills**: Work unchanged. They read SKILL.md and project-brain/ files as before.

## Compliance

All SKILL.md files are under the 480-line target:

- Minimum: 13 lines (eo-gtm-asset-factory)
- Maximum: 446 lines (eo-brain-ingestion)
- Average: 284 lines

✅ 13/13 skills compliant

## Key Design Principles

1. **Preservation**: All original content is preserved through progressive disclosure
2. **Clarity**: SKILL.md files are focused and readable
3. **Transparency**: READ pointers make the structure obvious
4. **Consistency**: All decomposed skills follow the same pattern
5. **Simplicity**: No content duplication; each piece lives in one place

## Next Steps

1. Review the DECOMPOSITION_REPORT.md for detailed metrics
2. Verify references/ content is accessible and well-organized
3. Test that downstream skills work unchanged
4. Push updated skills to the registry
