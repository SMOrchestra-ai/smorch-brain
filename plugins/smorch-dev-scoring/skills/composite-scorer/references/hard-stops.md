# Hard Stop Quality Gates

## What Is a Hard Stop?

A hard stop is a dimension-level score so low that it blocks project advancement regardless of the overall composite score. A project scoring 8.5/10 composite but 3/10 on Security Architecture still FAILS.

Hard stops exist because certain quality dimensions have non-linear risk: a security flaw doesn't degrade gracefully, it creates catastrophic exposure.

## Hard Stop Rules

### Rule 1: Security Architecture (Hat 2, Dimension 4)
- **Threshold**: Score < 5
- **Applies in**: All phases
- **Rationale**: Insecure architecture is a foundation problem. API keys in source code, no auth middleware, CORS set to `*`, no input validation: these cannot be patched later, they must be designed correctly.
- **Resolution**: Score 5+ requires at minimum: proper auth flow implemented, secrets in env (not source), restrictive CORS, input validation on API endpoints.

### Rule 2: Security Practices (Hat 3, Dimension 6)
- **Threshold**: Score < 5
- **Applies in**: All phases
- **Rationale**: Even with good architecture, poor security practices in code (raw SQL concatenation, no CSRF protection, secrets in git history) create exploitable vulnerabilities.
- **Resolution**: Score 5+ requires: parameterized queries, validation library (Zod/Yup), .env in .gitignore, auth middleware on protected routes.

### Rule 3: Security Testing (Hat 4, Dimension 7)
- **Threshold**: Score < 5
- **Applies in**: Pre-Launch, Post-Launch
- **Rationale**: Untested security is assumed broken. Before going live, auth boundaries, role escalation, and injection vectors must be verified by tests.
- **Resolution**: Score 5+ requires: auth flow tests, authorization boundary tests, basic injection prevention verified.

### Rule 4: Data Integrity (Hat 4, Dimension 5)
- **Threshold**: Score < 5
- **Applies in**: All phases
- **Rationale**: Data loss or corruption destroys user trust permanently. No constraints, no transactions, no validation on writes = inevitable data corruption.
- **Resolution**: Score 5+ requires: foreign keys enforced, server-side validation, unique constraints on logical keys.

### Rule 5: Problem Clarity (Hat 1, Dimension 1)
- **Threshold**: Score < 4
- **Applies in**: Pre-Build only
- **Rationale**: Building before understanding the problem guarantees waste. At pre-build, you must at minimum articulate who the user is and what pain you're solving.
- **Resolution**: Score 4+ requires: target user identified, core problem articulated, at least informal validation that the problem exists.

### Rule 6: Functional Completeness (Hat 4, Dimension 1)
- **Threshold**: Score < 5
- **Applies in**: Pre-Launch, Post-Launch
- **Rationale**: Shipping with broken core workflows creates negative first impressions that are nearly impossible to recover from, especially in MENA markets where word-of-mouth is primary.
- **Resolution**: Score 5+ requires: all primary user flows tested, happy path works end-to-end, critical workflows have at least one test each.

### Rule 7: RTL/Bilingual Support (Hat 5, Dimension 6)
- **Threshold**: Score < 5
- **Applies in**: All phases (MENA-targeted products only)
- **Rationale**: Arabic-first products with broken RTL layout signal "this wasn't built for us" to the target market. It's a trust destroyer, not a cosmetic issue.
- **Applies when**: Product targets Arabic-speaking users, has Arabic UI text, or positions as MENA-native.
- **Resolution**: Score 5+ requires: `dir="rtl"` functional, logical CSS properties (not hardcoded left/right), Arabic font loaded with correct line-height.

## Hard Stop Override

Hard stops can be overridden in exactly one scenario: **when the team explicitly acknowledges the risk and documents a remediation timeline**.

Override format:
```
HARD STOP OVERRIDE — [Dimension]
Current score: X/10
Acknowledged by: [name]
Remediation deadline: [date]
Mitigation in place: [what's protecting against the risk until fixed]
```

Overrides must be documented in the project's scoring history and re-evaluated at next scoring.
