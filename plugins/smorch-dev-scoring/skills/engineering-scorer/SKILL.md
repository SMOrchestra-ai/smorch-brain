---
name: engineering-scorer
description: >-
  Scores code quality across 8 dimensions: Code Organization, TypeScript Quality, Error Handling, Testing Strategy, Performance, Security Practices, DRY/Duplication, Git/CI-CD. Triggers on "score code quality", "rate the engineering", "code quality check", "engineering scorecard", "how clean is this code", "review code standards". Also fires during composite-scorer runs.
---

# Engineering / Code Quality Scorer

Score code quality, maintainability, and engineering practices. Hat 3 of the 5-Hat Quality Scorecard System.

The core question: **Would you be comfortable maintaining this code at 3am when it breaks in production?**

## Scoring Process

### Step 1: Discover Codebase

Map the codebase structure systematically:

1. `ls` the root to understand project organization
2. Read `package.json` (dependencies, scripts, devDependencies for tooling)
3. Read `tsconfig.json` (strictness settings are a strong quality signal)
4. Check for: `.eslintrc*`, `.prettierrc*`, `jest.config*`, `vitest.config*`, `playwright.config*`
5. Check for: `.github/workflows/*`, `Dockerfile`, `docker-compose*`
6. Scan `src/` or `app/` structure for organization patterns

### Step 2: Score Each Dimension

Read `references/engineering-anchors.md` for detailed rubrics. For calibration reference, see `../composite-scorer/references/calibration-examples.md` (Engineering section).

| Dimension | Weight | How to Evaluate |
|-----------|--------|----------------|
| Code Organization | 15% | Folder structure depth. Separation of concerns. File size distribution. |
| TypeScript Quality | 10% | Grep for `any`, `@ts-ignore`, `as unknown`. Check tsconfig strict mode. |
| Error Handling | 15% | Grep for try/catch patterns. Check error boundaries. Look for unhandled promises. |
| Testing Strategy | 15% | Count test files. Check coverage config. Verify tests run in CI. |
| Performance | 10% | Bundle config. React.memo/useMemo usage. Image optimization. Lazy loading. |
| Security Practices | 10% | Input validation. CORS config. Auth middleware. Secrets in .env.example. |
| DRY / Duplication | 10% | Identify repeated patterns. Count shared utils vs inline code. |
| Git & CI/CD | 15% | Git log format. Branch strategy. CI pipeline steps. |

### Automated Checks

Run these checks programmatically where possible:

```bash
# TypeScript strictness
grep -c "strict" tsconfig.json

# any usage count
grep -r ":\s*any" --include="*.ts" --include="*.tsx" -c

# Test file count
find . -name "*.test.*" -o -name "*.spec.*" | wc -l

# Error boundary count (React)
grep -r "ErrorBoundary\|error-boundary" --include="*.tsx" -c

# God files (>300 lines)
find . -name "*.ts" -o -name "*.tsx" | xargs wc -l | sort -rn | head -20
```

### Step 3: Output Format

```
## Engineering Scorecard — [Project Name]
Phase: [phase] | Stack: [detected] | Files: [count] | Test files: [count]

### Category Score: X.X / 10 ([grade])

| Dimension | Score | Evidence |
|-----------|-------|----------|
| Code Organization | X/10 | [folder depth, separation quality] |
| TypeScript Quality | X/10 | [any count, strict mode, interface coverage] |
| ... | ... | ... |

### Automated Metrics
- `any` usage: X instances
- Test files: X (ratio: X%)
- God files (>300 LOC): X
- tsconfig strict: [yes/no]
- CI pipeline: [none/basic/full]

### Critical Gaps
- [Dimension]: Score X → Target 8. Action: [specific refactoring task]

### Hard Stops
- Security Practices < 5: [PASS/FAIL]
```

### Skip Conditions

Do NOT run this scorer when:
- **No code files exist**: Nothing to evaluate. Return "N/A: no codebase."
- **Pure design/prototype** (Figma export, static mockup): Engineering quality doesn't apply.
- **Third-party code review** (evaluating a vendor's codebase you can't change): Run as read-only assessment, flag that recommendations are for the vendor, not your team.
