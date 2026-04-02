# Lana - AI-Native Engineer, Product & Infrastructure

<!-- AI: This is Lana's employee context file. She owns technical builds using the AI-native architecture (OpenClaw + Claude Code + GitHub). Use this to understand her role, process, and quality standards. -->

## 1. Role & Mission

**Title:** AI-Native Engineer, Product Build & Campaign Infrastructure
**Mission:** Own the technical build and development of SMOrchestra products, operating as a senior technical reviewer, QA lead, and system integrity guardian within the AI-native architecture.

Lana's value is NOT in writing code line by line. In the AI-native architecture, Claude Code writes the code. Lana's value is in: judgment that AI cannot make, context that AI does not have, accountability that AI cannot own, and trust that humans extend to humans.

## 2. The AI-Native Architecture (How Lana Works)

Lana operates across 5 layers:

### Layer 1: Intent (Spec Writing, 10% of time)
- Takes business requirements from Mamoun and adds technical constraints, file scope declarations, acceptance criteria, negative constraints, and context notes
- A well-written spec produces correct output on the first try. Vague specs create revision cycles

### Layer 2: Orchestration (Monitoring, 5% of time)
- OpenClaw manages task queuing, dependency resolution, branch creation
- Lana monitors and intervenes when tasks get stuck (circular dependencies, resource conflicts)

### Layer 3: Execution (Claude Code writes, Lana does NOT write code normally)
- Claude Code works in isolated workspace, pinned to spec, with session TTL
- Lana may pair with Claude Code on complex debugging: providing judgment while AI handles mechanical changes

### Layer 4: Validation (CI + Self-Fix, 20% of time)
- CI runs automatically on every push. Self-fix loop gets one retry
- When self-fix fails, PR is tagged `needs-human-debug` and lands on Lana's desk
- These are the hard problems: race conditions, environment-specific configs, wrong test assertions

### Layer 5: Human Gate (Code Review, 40% of time) - PRIMARY ZONE
- Every AI-generated PR passes through Lana before reaching shared branch
- Reviews for: intent alignment, scope compliance, security implications, architectural consistency, test coverage
- Risk tiers: HIGH (Mamoun must review), MEDIUM (Lana merges with confidence), LOW (sanity check)
- No code ships without Lana saying "this is correct, this is safe, this belongs in our product"

## 3. Ownership Map

### Owns Entirely
- Signal Sales Engine V2 development
- AI autonomous campaign system technical build
- Code review for all AI-generated PRs
- QA and user testing (Arabic RTL validation, mobile responsive, edge cases)
- System integrity: branch health, hook enforcement, ADRs

### Supports
- Campaign technical implementation when Ruba needs technical setup/integration
- Technical needs across team on limited basis

## 4. Project Ownership

| Project | Role |
|---|---|
| SalesMfast Signal Engine (SS Engine Tech) | Primary owner: technical build |
| SalesMfast SME Platform | Primary owner: technical build |
| AI Super MicroSaaS Launcher | Primary owner: platform development |
| EO AppSumo Platform | Supports: technical maintenance |
| CXMfast Platform | Supports: technical build when active |

## 5. Tools & Systems

| Tool | Usage |
|---|---|
| Claude Code | AI agent that writes code, pinned to specs |
| OpenClaw | Task orchestration, dependency resolution, branch management |
| GitHub | Version control, PR management, CI/CD |
| Linear | Self-reporting, task tracking |
| n8n | Workflow orchestration for signal scoring and campaign infrastructure |
| Supabase | Database, auth, edge functions |
| Docker/Coolify | Deployment infrastructure |

## 6. Time Allocation

| Activity | % of Time | Focus |
|---|---|---|
| Code review | 40% | Intent alignment, security, scope, architecture |
| QA and user testing | 25% | User flows, Arabic RTL, mobile, edge cases |
| Troubleshooting/debugging | 20% | `needs-human-debug` PRs, production incidents |
| Spec writing | 10% | Technical constraints, acceptance criteria |
| System integrity | 5% | Branch health, hooks, ADRs, documentation |

## 7. Metrics

| Metric | Target |
|---|---|
| PR review turnaround (HIGH risk) | < 1 hour |
| PR review turnaround (MEDIUM risk) | < 4 hours |
| PR review turnaround (LOW risk) | < 8 hours |
| Escaped defect rate | < 2% |
| Spec quality (first-pass pass rate) | > 80% |
| `needs-human-debug` resolution | < 2 hours |

## 8. Standards & Accountability

- **Code delivery on time.** Deadlines are commitments, not aspirations
- **No losing code due to no backup.** Version control is non-negotiable. Every change committed, every branch tracked. Losing code is a terminal failure
- **Follow the AI-native process.** The 5-layer architecture exists for a reason. Skipping layers (especially the Human Gate) is not acceptable
- **Version control discipline.** Ability to roll back at all times. If you can't show the previous working version, the process failed
- **No rubber-stamping reviews.** Every PR reviewed as if it were going to production. Because it is
- Reply same day to all communications
- Claude skills must not be changed without speaking to Mamoun first
- Can create her own skills for specific engineering needs
- Must use Cowork mode, not chat, for all Claude work
- Linear for self-reporting on all active projects
- If a build breaks, a deployment fails, or code is lost, report it immediately. Mamoun should not discover technical problems; he should be told about them

## 9. The Engineer's Oath

> I review every agent PR as if it were my own code going to production.
> I write specs as if the agent has zero context beyond what I provide.
> I test as if no automated test exists.
> I flag risks even when the code looks correct.
> I never rubber-stamp a review.
> I own the quality of what ships, regardless of who, or what, wrote it.

---
*Last updated: 2026-03-24 | Review: quarterly | Persona: Employee (AI-Native Engineer)*
