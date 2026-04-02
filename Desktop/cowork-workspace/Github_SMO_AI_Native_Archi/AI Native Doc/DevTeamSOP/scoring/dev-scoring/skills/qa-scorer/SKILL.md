---
name: qa-scorer
description: >-
  Scores application quality across 8 dimensions: Functional Completeness, Edge Cases, Cross-Browser/Device, Real-World Performance, Data Integrity, Error Recovery, Security Testing, Usability. Triggers on "score QA", "quality check", "is this ready to ship", "test coverage review", "usability score", "QA scorecard", "pre-launch check".
---

# QA / Testing Scorer

Score application reliability, edge case coverage, and user-facing quality. Hat 4 of the 5-Hat Quality Scorecard System.

The core question: **Would a paying customer trust this product?**

## Scoring Process

### Step 1: Discover Testing Surface

Map the application's testing landscape:

1. **Test files**: Find all `*.test.*`, `*.spec.*`, `**/e2e/**`, `**/cypress/**`, `**/playwright/**`
2. **Coverage config**: Look for `jest.config*`, `vitest.config*`, `nyc`, coverage thresholds
3. **CI pipeline**: Check `.github/workflows/*` for test steps
4. **Test utilities**: Check for factories, fixtures, mock patterns
5. **Feature surface**: Count routes/pages (each is a testing target)

### Step 2: Score Each Dimension

Read `references/qa-anchors.md` for detailed rubrics. For calibration reference, see `../composite-scorer/references/calibration-examples.md` (QA section).

| Dimension | Weight | How to Evaluate |
|-----------|--------|----------------|
| Functional Completeness | 15% | Map features vs test coverage. Check for incomplete workflows. |
| Edge Case Coverage | 15% | Look for boundary tests, empty state handling, Arabic text tests. |
| Cross-Browser/Device | 10% | Check for responsive breakpoints, touch targets, viewport meta. |
| Real-World Performance | 10% | Look for loading states, API response handling, pagination. |
| Data Integrity | 15% | Check DB constraints, transactions, cascade rules, soft deletes. |
| Error Recovery | 10% | Check error boundaries, retry mechanisms, form state preservation. |
| Security Testing | 15% | Check auth tests, role boundary tests, injection tests. |
| Usability (Target User) | 10% | Check onboarding, tooltips, empty states, Arabic-first if applicable. |

### Automated Quality Signals

Run these programmatically:

```bash
# Test file ratio
echo "Source files:" && find . -name "*.ts" -o -name "*.tsx" | grep -v test | grep -v spec | wc -l
echo "Test files:" && find . -name "*.test.*" -o -name "*.spec.*" | wc -l

# Coverage thresholds in config
grep -r "coverageThreshold\|coverage" jest.config* vitest.config* 2>/dev/null

# Error boundary usage
grep -r "ErrorBoundary\|error-boundary\|onError" --include="*.tsx" --include="*.ts" -l

# Empty state handling
grep -r "empty\|no.data\|no.results\|nothing.here" --include="*.tsx" -l

# Loading states
grep -r "loading\|skeleton\|spinner\|isLoading" --include="*.tsx" -l
```

### MENA-Specific QA Checks

For Arabic/MENA-targeted products, additionally check:

- **RTL text rendering**: Search for `dir="rtl"` or `direction: rtl`. Missing = likely broken Arabic layout.
- **Arabic input handling**: Form inputs with Arabic text. Bidirectional text mixing.
- **Gulf timezone handling**: Date operations using timezone-aware libraries (dayjs, date-fns-tz).
- **WhatsApp integration edge cases**: If WhatsApp is a channel, check message length limits, media handling, template compliance.
- **Phone number formats**: Gulf phone formats (971, 966, 974, etc.) validated correctly.

### Step 3: Output Format

```
## QA Scorecard — [Project Name]
Phase: [phase] | Test files: [count] | Feature count: [est.]

### Category Score: X.X / 10 ([grade])

| Dimension | Score | Evidence |
|-----------|-------|----------|
| Functional Completeness | X/10 | [coverage ratio, untested features] |
| ... | ... | ... |

### Test Health Metrics
- Test-to-source ratio: X%
- Coverage threshold configured: [yes/no]
- E2E tests: [count]
- Error boundaries: [count]
- Loading states: [count] files

### Critical Gaps
- [Dimension]: Score X → Target 8. Action: [specific test to write]

### Hard Stops
- Data Integrity < 5: [PASS/FAIL]
- Functional Completeness < 5: [PASS/FAIL]
- Security Testing < 5: [PASS/FAIL]
```

### Skip Conditions

Do NOT run this scorer when:
- **Pre-Build phase with no code**: Nothing to test. Return "N/A: no application to QA."
- **Pure library/SDK** (no UI, no user-facing features): Replace Usability (Dim 8) and Cross-Browser (Dim 3) with "N/A" and redistribute their weights to Functional Completeness and Edge Cases.
- **Data pipeline or CLI tool**: Skip Cross-Browser/Device entirely. Focus on data integrity, edge cases, and error recovery.
