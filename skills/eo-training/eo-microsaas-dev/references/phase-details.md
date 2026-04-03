# Phase Implementation Details - eo-microsaas-dev

Complete phase workflows, code patterns, and execution steps.

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

