# Patterns — Detected Extraction & Generation Rules

## PURPOSE
Living document of patterns detected during brain builds. Each pattern has a confidence level based on occurrence count. Patterns at HIGH confidence (5+ occurrences) become default behaviors. Patterns at MEDIUM (3-4) are suggestions. Patterns at LOW (1-2) are observations.

---

## EXTRACTION PATTERNS

### Input Type: PPTX
<!-- Patterns in how slide content maps to brain fields -->

_No patterns yet._

### Input Type: DOCX/PDF
<!-- Patterns in how document sections map to brain fields -->

_No patterns yet._

### Input Type: URL/Website
<!-- Patterns in how page content maps to brain fields -->

_No patterns yet._

### Input Type: Verbal/Interview
<!-- Patterns in what users say vs. what they mean -->

_No patterns yet._

---

## GENERATION PATTERNS

### Project Type: Tech
_No patterns yet._

### Project Type: GTM Consulting
_No patterns yet._

### Project Type: GTM Agency
_No patterns yet._

### Project Type: Recorded Training
_No patterns yet._

### Project Type: Cohort Training
_No patterns yet._

### Project Type: Mastermind/Community
_No patterns yet._

### Project Type: Distribution
_No patterns yet._

---

## CORRECTION PATTERNS
<!-- When users correct a brain field, log it here to detect systematic biases -->
<!-- Format: FIELD: [file.field] | GENERATED: [what system produced] | CORRECTED TO: [what user wanted] | REASON: [why] | PROJECT: [name] -->

_No corrections yet._

---

## MENA-SPECIFIC PATTERNS
<!-- Regional patterns that affect extraction and generation -->

### Seeded Patterns (from reference files, not yet validated by builds)

1. **SME Decomposition** (MEDIUM — seeded, not yet validated)
   - When a MENA project says "SMEs," always decompose into specific sub-segments
   - Gulf SME is structurally different from Egyptian SME or Jordanian SME
   - Default: ask which SME segment during gap-fill

2. **WhatsApp Default** (MEDIUM — seeded, not yet validated)
   - For any MENA B2B project, WhatsApp should appear in gtm-channels.md as a primary or secondary channel
   - If input doesn't mention WhatsApp, add it with a [SYSTEM-INFERRED] tag and ask for confirmation

3. **Pricing Context** (MEDIUM — seeded, not yet validated)
   - Gulf pricing differs from Egypt/Jordan pricing for identical services
   - If pricing is provided without market context, flag for confirmation
   - Default: ask "Is this pricing for Gulf, Levant, or Egypt?"
