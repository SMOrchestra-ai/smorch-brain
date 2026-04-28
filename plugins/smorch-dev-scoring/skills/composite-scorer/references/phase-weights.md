# Phase-Based Category Weights

## Why Phase Matters

Different project phases demand different quality priorities. Scoring a pre-build project harshly on QA test coverage is unfair; scoring a pre-launch project leniently on security is dangerous. The phase-weight matrix ensures each hat's influence matches what matters most at that stage.

## Weight Matrix

| Category | Pre-Build | During Build | Pre-Launch | Post-Launch |
|----------|-----------|-------------|------------|-------------|
| Product (Hat 1) | **30%** | 20% | 15% | 20% |
| Architecture (Hat 2) | **30%** | **25%** | 15% | 15% |
| Engineering (Hat 3) | 15% | **25%** | **25%** | **25%** |
| QA / Testing (Hat 4) | 10% | 15% | **25%** | **25%** |
| UX Frontend (Hat 5) | 15% | 15% | **20%** | 15% |
| **Total** | 100% | 100% | 100% | 100% |

## Phase Rationale

### Pre-Build (Planning)
Product and Architecture dominate (60% combined). If you don't have clarity on what you're building and how it's structured, nothing else matters. Engineering and QA carry minimal weight because there's little code to evaluate. UX carries 15% because wireframes and design decisions happen here.

### During Build (Development)
Balanced across the three execution hats: Architecture (25%), Engineering (25%), Product (20%). This phase catches architectural drift from the plan and ensures code quality standards are established early. QA at 15% because testing should be written alongside features, not after.

### Pre-Launch (Polish)
QA and Engineering dominate (50% combined). The product should be defined and architecture locked by now. Focus shifts to: does it work correctly (QA 25%), is the code maintainable (Engineering 25%), and does it look and feel right (UX 20%)? Product drops to 15% because scope changes at this stage are expensive.

### Post-Launch (Iterate)
Engineering and QA stay dominant (50% combined) because production code quality and reliability directly impact users and revenue. Product rebounds to 20% because post-launch iteration needs product-thinking about what to build next. Architecture at 15% because the foundation is set. UX at 15% for ongoing polish.

## Phase Detection Heuristics

Use these signals to infer phase if the user doesn't specify:

**Pre-Build signals**:
- BRD/PRD/spec files exist but no `src/` or `app/` directory
- `package.json` has zero or minimal dependencies
- Only documentation files in the repo
- No git commits with code changes

**During Build signals**:
- Active `src/` or `app/` directory with code
- Git log shows recent code commits
- Test coverage < 60% (still building)
- TODO/FIXME comments present
- Some features incomplete (commented out, placeholder pages)

**Pre-Launch signals**:
- Feature-complete (all routes/pages implemented)
- CI pipeline exists and passes
- Staging URL or preview deployment configured
- Focus on bug fixes in recent commits (not new features)
- Coverage > 60%

**Post-Launch signals**:
- Production URL exists and serves traffic
- Monitoring/analytics configured (Sentry, PostHog, Vercel Analytics)
- Production database has real user data
- Git tags with version numbers
- Hotfix branches in history
