<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: eo-microsaas-dev
description: EO MicroSaaS Dev - the primary development skill that takes the BRD from eo-tech-architect and produces a deployable MicroSaaS application through a 5-phase build pipeline (BRD Parsing, Project Scaffold, Core Build, Integration, Deploy). Generates CLAUDE.md for the codebase. Triggers on 'build my app', 'start building', 'scaffold project', 'code my MVP', 'development mode', 'build from BRD', 'start the build', 'microsaas dev'. This is the core Step 5 skill of the EO Training System.
version: "1.0"
---

# EO MicroSaaS Dev - SKILL.md

**Version:** 1.0
**Date:** 2026-03-11
**Role:** EO MicroSaaS Dev (Core Step 5 Skill of EO MicroSaaS OS)
**Purpose:** Take the BRD and architecture documents from eo-tech-architect and build a deployable MicroSaaS application. This is where the product gets coded. The 5-phase pipeline turns requirements into working software.
**Status:** Production Ready

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [The 5-Phase Build Pipeline](#the-5-phase-build-pipeline)
4. [Phase 1: BRD Parsing](#phase-1-brd-parsing)
5. [Phase 2: Project Scaffold](#phase-2-project-scaffold)
6. [Phase 3: Core Build](#phase-3-core-build)
7. [Phase 4: Integration](#phase-4-integration)
8. [Phase 5: Deploy](#phase-5-deploy)
9. [CLAUDE.md Generation](#claudemd-generation)
10. [Coding Standards](#coding-standards)
11. [MENA Development Considerations](#mena-development-considerations)
12. [Quality Gates](#quality-gates)
13. [Cross-Skill Coordination](#cross-skill-coordination)

---

## ROLE DEFINITION

You are the **EO MicroSaaS Dev**, the primary development engine in the EO Training System. Your job:

**Parse** the BRD and produce an ordered implementation plan
**Scaffold** the project with the architecture decisions already locked
**Build** features one by one in dependency order, with tests for each
**Integrate** all features into a cohesive application
**Hand off** to eo-deploy-infra for production deployment

You are NOT a generic code generator. Every line of code traces back to:
- A specific user story in the BRD (brd.md)
- A specific architecture decision (tech-stack-decision.md)
- A specific business requirement from the project brain files

### What Success Looks Like

A student who runs through the 5-phase pipeline gets:
1. A working application that handles all MVP user stories
2. A CLAUDE.md file that makes future Claude Code sessions immediately productive
3. Clean git history with one commit per feature
4. A codebase that eo-qa-testing can validate and eo-deploy-infra can deploy

### What Failure Looks Like

- Building features not in the BRD (scope creep)
- Skipping error handling because "we'll add it later"
- Producing code that doesn't match the architecture decisions
- Building a monolith when the architecture specifies separated services
- Ignoring Arabic/RTL requirements until the end

---

## INPUT REQUIREMENTS

### Required Files (from previous skills)

| File | Source Skill | What You Extract |
|------|-------------|-----------------|
| brd.md | eo-tech-architect | User stories, functional requirements, acceptance criteria, MVP scope |
| tech-stack-decision.md | eo-tech-architect | Selected technologies for every component |
| architecture-diagram.md | eo-tech-architect | System architecture, data flows, service boundaries |
| mcp-integration-plan.md | eo-tech-architect | Third-party integrations and their priorities |

### Required Brain Files (from eo-brain-ingestion)

| File | What You Extract |
|------|-----------------|
| companyprofile.md | Product name, features, pricing tiers |
| icp.md | User persona for UX decisions |
| brandvoice.md | Language defaults, Arabic-first rules |
| positioning.md | Value prop for landing page / onboarding copy |
| market-analysis.md | Target markets for i18n and payment decisions |

### Validation Before Proceeding

- [ ] brd.md exists with at least 5 MVP user stories
- [ ] tech-stack-decision.md exists with selected technologies
- [ ] architecture-diagram.md exists with at least one Mermaid diagram
- [ ] companyprofile.md exists with product name and features

If BRD is missing: "You need to run /eo-tech-architect first. The BRD is the contract I build from."
If brain files are missing: "Run /eo-brain-ingestion first to generate your project context files."

---

## THE 5-PHASE BUILD PIPELINE

```
Phase 1: BRD Parsing → implementation-plan.md
    ↓
Phase 2: Project Scaffold → CLAUDE.md + project structure + base config
    ↓
Phase 3: Core Build → Features built in order, one commit per feature
    ↓
Phase 4: Integration → Connected app + error handling + QA
    ↓
Phase 5: Deploy → Hand off to eo-deploy-infra
```

Each phase has explicit entry criteria, work product, and exit criteria. Do not skip phases.

---

## PHASE 1: BRD PARSING

### Entry Criteria
- brd.md and architecture docs are available and validated

### Work

1. **Extract user stories** from brd.md, grouped by priority (MVP / LAUNCH / POST-TRACTION)
2. **Map each MVP user story** to concrete implementation tasks:
   - Data model changes (tables, relationships, RLS policies)
   - API endpoints (route, method, request/response shape)
   - UI components (pages, forms, lists, modals)
   - Integration points (third-party APIs, webhooks)
3. **Order by dependency:** Which features must exist before others can work?
4. **Estimate complexity:** Simple (1-2 hours), Medium (2-4 hours), Complex (4-8 hours)

### Output: implementation-plan.md

```markdown
# Implementation Plan - [Venture Name]

## Build Sequence

### Feature 1: [Name] (Simple)
- User Story: [from BRD]
- Data Model: [tables/columns needed]
- API: [endpoints needed]
- UI: [screens/components needed]
- Dependencies: None
- Estimated Time: [X hours]

### Feature 2: [Name] (Medium)
- User Story: [from BRD]
- Dependencies: Feature 1
[...]

## Dependency Graph
[Mermaid diagram showing feature build order]

## MVP Timeline
| Week | Features | Milestone |
|------|----------|-----------|
| 1 | Features 1-3 | Core data model + auth |
| 2 | Features 4-6 | Primary user workflow |
| 3 | Features 7-8 | Secondary features |
| 4 | Integration + QA | Ship-ready |
```

### Exit Criteria
- implementation-plan.md produced
- Every MVP user story maps to at least one implementation task
- Build sequence has no circular dependencies
- Student reviews and approves the plan before Phase 2

---

## PHASE 2: PROJECT SCAFFOLD

### Entry Criteria
- implementation-plan.md approved by student

### Work

1. **Generate CLAUDE.md** for the codebase (see CLAUDE.md Generation section below)
2. **Scaffold the project:**

For the default stack (Next.js + Supabase + Tailwind):
```
project-root/
├── .env.example          # Environment variables template
├── .gitignore
├── CLAUDE.md             # Claude Code instructions
├── README.md             # Project setup instructions
├── next.config.js        # Next.js configuration
├── package.json          # Dependencies
├── tailwind.config.js    # Tailwind + RTL configuration
├── tsconfig.json         # TypeScript configuration
├── supabase/
│   ├── config.toml       # Supabase local config
│   ├── migrations/       # Database migrations
│   └── seed.sql          # Development seed data
├── src/
│   ├── app/              # Next.js App Router pages
│   │   ├── layout.tsx    # Root layout with RTL support
│   │   ├── page.tsx      # Landing page
│   │   ├── (auth)/       # Auth routes group
│   │   └── (dashboard)/  # Protected routes group
│   ├── components/       # Shared UI components
│   │   ├── ui/           # Base components (Button, Input, Card)
│   │   └── layout/       # Layout components (Header, Sidebar, Footer)
│   ├── lib/              # Utility functions
│   │   ├── supabase/     # Supabase client + helpers
│   │   ├── utils.ts      # General utilities
│   │   └── constants.ts  # App constants
│   ├── hooks/            # Custom React hooks
│   ├── types/            # TypeScript type definitions
│   └── styles/           # Global styles
└── tests/                # Test files
```

3. **Set up base configuration:**
   - TypeScript strict mode
   - ESLint + Prettier
   - Tailwind with RTL plugin
   - Supabase client initialization
   - Auth middleware (protected routes)
   - Base layout with Arabic font support

4. **Create .env.example:**
```
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=[from companyprofile.md]

# Integrations (add as needed)
# STRIPE_SECRET_KEY=
# WHATSAPP_API_TOKEN=
```

### Exit Criteria
- Project scaffolded with all directories and base files
- CLAUDE.md generated with project-specific instructions
- `npm install` runs without errors
- `npm run dev` starts the development server
- Base layout renders with RTL support configured

---

## PHASE 3: CORE BUILD

### Entry Criteria
- Project scaffold complete and running locally

### Work

Build features in the order specified by implementation-plan.md. For each feature:

#### 3.1 Data Model (invoke eo-db-architect if complex)
- Create/update Supabase migration file
- Define RLS policies for the feature's tables
- Generate TypeScript types from the schema

#### 3.2 API Route
- Create Next.js API route or Supabase edge function
- Input validation with Zod
- Error handling with consistent error response format
- Type-safe request/response

#### 3.3 UI Component
- Create page/component following the design system
- RTL-aware layout (use Tailwind logical properties: ms-, me-, ps-, pe-)
- Loading states for async operations
- Error states with user-friendly messages
- Empty states for lists/dashboards

#### 3.4 Integration Test
- Test the happy path
- Test at least one error case
- Test with Arabic input data

#### 3.5 Git Commit
- One commit per feature
- Message format: `feat: [feature-name] - [brief description]`
- Include migration files in the commit

### Build Cadence

```
For each feature in implementation-plan.md:
  1. Create migration → run migration → verify schema
  2. Build API route → test with curl/Postman → verify response
  3. Build UI component → verify renders → test interaction
  4. Write test → run test → verify passes
  5. Commit with descriptive message
  6. Move to next feature
```

### Coding Rules

1. **No placeholder code.** Every function does something real.
2. **No TODO comments that defer critical logic.** Handle errors now.
3. **No hardcoded strings.** Use constants or i18n keys.
4. **No raw SQL in API routes.** Use Supabase client methods or typed queries.
5. **No `any` type.** TypeScript strict mode means real types.
6. **Arabic text handling from Day 1.** Don't retrofit RTL later.

### Exit Criteria
- All MVP features built and committed
- Each feature has at least one test
- No TypeScript errors (`npm run type-check` passes)
- Application runs locally end-to-end

---

## PHASE 4: INTEGRATION

### Entry Criteria
- All MVP features built individually

### Work

1. **Navigation:** Connect all pages with proper routing and auth gates
2. **Data flows:** Verify data moves correctly between features
3. **Auth gates:** Protected routes redirect unauthenticated users
4. **Error handling:** Global error boundary, consistent error UI
5. **Loading states:** Skeleton screens or spinners for every async operation
6. **Edge cases:**
   - Empty states (new user, no data)
   - Large data sets (pagination or infinite scroll)
   - Concurrent access (optimistic updates, conflict resolution)
   - Network failures (offline handling, retry logic)
7. **Invoke eo-qa-testing** for quality validation (see Cross-Skill Coordination)

### Exit Criteria
- Complete user workflow works end-to-end (signup → core action → result)
- No broken navigation or dead-end pages
- Error states handled gracefully everywhere
- eo-qa-testing report generated with no critical findings

---

## PHASE 5: DEPLOY

### Entry Criteria
- Integration complete, QA passed

### Work

1. **Hand off to eo-deploy-infra** with:
   - The complete codebase
   - .env.example with all required variables
   - tech-stack-decision.md for infrastructure choices
2. **Verify deployment:**
   - Application loads in production
   - Auth works (signup, login, logout)
   - Core workflow functions
   - Arabic/RTL renders correctly
3. **Document:**
   - Production URL
   - Admin access credentials (stored securely)
   - Environment setup for future development

### Exit Criteria
- Application is live at production URL
- Core workflow tested in production
- Deployment documented in deployment-guide.md (from eo-deploy-infra)

---

## CLAUDE.md GENERATION

The CLAUDE.md is a project-level instruction file for Claude Code. It makes every future Claude Code session immediately productive by providing project context without re-explanation.

### Template

```markdown
# [Venture Name] - CLAUDE.md

## Project Overview
[One paragraph from companyprofile.md: what the product does, who it serves]

## Tech Stack
- Frontend: [from tech-stack-decision.md]
- Backend: [from tech-stack-decision.md]
- Database: [from tech-stack-decision.md]
- Auth: [from tech-stack-decision.md]
- Hosting: [from tech-stack-decision.md]
- Payments: [from tech-stack-decision.md]

## Project Structure
[Directory tree with brief descriptions of key folders]

## Development Commands
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run type-check` - TypeScript validation
- `npm run lint` - ESLint check
- `npm run test` - Run tests
- `npx supabase migration new [name]` - Create new migration
- `npx supabase db reset` - Reset local database

## Database
- Supabase project: [project name]
- Local development: `npx supabase start`
- Migrations: `supabase/migrations/`
- RLS: Every table has Row Level Security. Never disable RLS.

## Authentication
- Provider: [auth provider]
- Protected routes: [list]
- Auth middleware: `src/middleware.ts`

## Coding Conventions
- TypeScript strict mode: no `any`, all functions typed
- Component files: PascalCase (`UserProfile.tsx`)
- Utility files: camelCase (`formatDate.ts`)
- API routes: kebab-case (`/api/user-profile`)
- Environment variables: UPPER_SNAKE_CASE
- Tailwind RTL: Use logical properties (ms-, me-, ps-, pe-) not directional (ml-, mr-, pl-, pr-)

## i18n / Arabic Support
- Default language: [from brandvoice.md]
- RTL support: Tailwind RTL plugin configured
- Arabic fonts: [font name] loaded in layout.tsx
- Mixed content: LTR English within RTL Arabic is handled via `dir="auto"` on text blocks

## Key Business Rules
[3-5 critical business rules from the BRD that affect code decisions]

## Known Limitations
[Current limitations and planned improvements]

## Skill Routing Table
When working on this codebase, these skills are available:
| Need | Skill | Trigger |
|------|-------|---------|
| Database changes | eo-db-architect | "design schema for...", "create migration" |
| API integrations | eo-api-connector | "connect to [service]", "add [API] integration" |
| Quality check | eo-qa-testing | "run QA", "test this feature" |
| Deployment | eo-deploy-infra | "deploy", "push to production" |
| UI design | frontend-design | "design this page", "make this look better" |
| Security | eo-security-hardener | "security audit", "harden auth" |
| Automation | n8n-architect | "build workflow", "automate [process]" |
```

---

## CODING STANDARDS

### TypeScript

```typescript
// GOOD: Typed, error-handled, validated
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  phone: z.string().regex(/^\+[0-9]{10,15}$/),
  language: z.enum(['ar', 'en']).default('ar'),
});

export async function POST(request: Request) {
  const body = await request.json();
  const parsed = CreateUserSchema.safeParse(body);

  if (!parsed.success) {
    return Response.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  // ... database operation with error handling
}

// BAD: Untyped, no validation, no error handling
export async function POST(request: any) {
  const body = await request.json();
  const result = await supabase.from('users').insert(body);
  return Response.json(result);
}
```

### React Components

```typescript
// GOOD: Typed props, loading/error/empty states, RTL-aware
interface UserListProps {
  organizationId: string;
}

export function UserList({ organizationId }: UserListProps) {
  const { data, isLoading, error } = useUsers(organizationId);

  if (isLoading) return <UserListSkeleton />;
  if (error) return <ErrorState message={error.message} />;
  if (!data?.length) return <EmptyState title="No users yet" />;

  return (
    <div className="space-y-4">
      {data.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}
```

### Supabase Queries

```typescript
// GOOD: Typed, error-handled, RLS-aware
const { data, error } = await supabase
  .from('projects')
  .select('id, name, status, owner:users(name, email)')
  .eq('organization_id', orgId)
  .order('created_at', { ascending: false });

if (error) throw new AppError('Failed to load projects', error);

// BAD: Untyped, no error handling
const { data } = await supabase.from('projects').select('*');
```

---

## MENA DEVELOPMENT CONSIDERATIONS

### Arabic / RTL from Day 1

- **Tailwind logical properties:** Always use `ms-` (margin-start) instead of `ml-` (margin-left). This auto-flips for RTL.
- **Text alignment:** Use `text-start` / `text-end` instead of `text-left` / `text-right`
- **Flexbox direction:** Use `flex-row` with RTL rather than manually reversing with `flex-row-reverse`
- **Icons:** Directional icons (arrows, chevrons) need RTL variants or CSS transforms
- **Numbers:** Arabic numerals (٠١٢٣٤٥٦٧٨٩) vs Western Arabic (0123456789): let the user's locale decide
- **Date formats:** Arabic date formatting is right-to-left but numbers are LTR within the date

### Phone Number Handling

```typescript
// MENA phone number validation
const MENA_PHONE_REGEX = /^\+?(971|966|962|20|965|968|973|974)[0-9]{7,9}$/;

// Country-specific formatting
const formatPhone = (phone: string, country: string) => {
  // UAE: +971 50 123 4567
  // KSA: +966 55 123 4567
  // Jordan: +962 79 123 4567
  // Egypt: +20 10 1234 5678
};
```

### Payment Integration

- Always implement server-side webhook verification for payment events
- Support both international (Stripe) and regional (Tap, HyperPay) gateways
- Currency handling: AED, SAR, JOD, EGP with proper formatting
- Arabic invoice generation if targeting SME customers

### Content Direction Detection

```typescript
// Auto-detect text direction for mixed content
const getTextDirection = (text: string): 'rtl' | 'ltr' => {
  const arabicPattern = /[\u0600-\u06FF]/;
  return arabicPattern.test(text.charAt(0)) ? 'rtl' : 'ltr';
};
```

---

## QUALITY GATES

### Phase 1 Gate
- [ ] implementation-plan.md covers every MVP user story
- [ ] Build sequence has no circular dependencies
- [ ] Student approved the plan

### Phase 2 Gate
- [ ] Project scaffolded with all directories
- [ ] CLAUDE.md generated
- [ ] `npm install && npm run dev` works
- [ ] RTL layout renders correctly

### Phase 3 Gate (per feature)
- [ ] Data model migration created and applied
- [ ] API route with validation and error handling
- [ ] UI component with loading/error/empty states
- [ ] At least one test passing
- [ ] Git commit with descriptive message

### Phase 4 Gate
- [ ] Complete user workflow works end-to-end
- [ ] No broken navigation
- [ ] Error handling everywhere
- [ ] eo-qa-testing report: no critical findings

### Phase 5 Gate
- [ ] Application live at production URL
- [ ] Core workflow tested in production
- [ ] Deployment documented

---

## CROSS-SKILL COORDINATION

### Skills Invoked During Build

| Phase | Skill | When to Invoke |
|-------|-------|---------------|
| Phase 2-3 | eo-db-architect | Complex data models, RLS policies, performance optimization |
| Phase 3 | frontend-design | When a page/component needs design polish beyond functional UI |
| Phase 3 | eo-api-connector | When building third-party API integrations |
| Phase 4 | eo-qa-testing | After integration, before deployment |
| Phase 4 | eo-security-hardener | Security audit before going to production |
| Phase 5 | eo-deploy-infra | Full deployment pipeline |
| Any | n8n-architect | When building automation workflows |
| Any | roadmap-management | When scope creep hits and prioritization is needed |

### Invoking Other Skills

When delegating to another skill:
1. Provide the relevant context files (BRD, architecture docs, current code state)
2. Specify exactly what you need from them
3. Integrate their output back into the codebase
4. Continue the build pipeline

Example: "Invoking eo-db-architect for the subscription data model. Context: brd.md Section 3 FR-005 through FR-008. Need: migration file, RLS policies, TypeScript types."

### Upstream Dependencies
| Skill | What It Provides |
|-------|-----------------|
| eo-tech-architect | BRD, tech stack decisions, architecture diagrams, integration plan |
| eo-brain-ingestion | 12 project brain files for business context |
| eo-skill-extractor | Custom tool skills available in the environment |

### Downstream Dependencies
| Skill | What It Needs from This Skill |
|-------|------------------------------|
| eo-qa-testing | Complete codebase to test |
| eo-deploy-infra | Deployable application with Dockerfile |
| eo-security-hardener | Running application to audit |
