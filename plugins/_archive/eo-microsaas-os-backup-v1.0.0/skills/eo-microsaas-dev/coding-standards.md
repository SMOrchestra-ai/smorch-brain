# EO MicroSaaS Dev - Coding Standards & Templates

Reference file for coding standards, code examples, CLAUDE.md template, and MENA development considerations.

---

## CLAUDE.md Generation Template

The CLAUDE.md is a project-level instruction file for Claude Code. It makes every future Claude Code session immediately productive by providing project context without re-explanation.

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

## TypeScript Coding Standards

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

---

## React Component Standards

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

---

## Supabase Query Standards

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

## MENA Development Considerations

### Arabic / RTL from Day 1

- **Tailwind logical properties:** Always use `ms-` (margin-start) instead of `ml-` (margin-left). This auto-flips for RTL.
- **Text alignment:** Use `text-start` / `text-end` instead of `text-left` / `text-right`
- **Flexbox direction:** Use `flex-row` with RTL rather than manually reversing with `flex-row-reverse`
- **Icons:** Directional icons (arrows, chevrons) need RTL variants or CSS transforms
- **Numbers:** Arabic numerals vs Western Arabic: let the user's locale decide
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
