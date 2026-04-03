# Code Patterns Library - EO MicroSaaS Default Stack

Production-ready code patterns for Next.js 14+ App Router, Supabase, and Tailwind CSS. Copy directly into your project.

---

## Next.js App Router Patterns

### Page with Server Component Data Fetching

```tsx
// app/dashboard/page.tsx
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

export default async function DashboardPage() {
  const supabase = createServerComponentClient({ cookies })
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) redirect('/login')

  const { data: items, error } = await supabase
    .from('items')
    .select('*')
    .eq('user_id', session.user.id)
    .order('created_at', { ascending: false })

  if (error) return <ErrorState message={error.message} />
  if (!items?.length) return <EmptyState />

  return <ItemList items={items} />
}
```

**Why**: Server components minimize client bundle, fetch data once at build/request time, reduce hydration mismatches.

---

### Client Component with Loading/Error/Empty States

```tsx
'use client'
import { useState, useEffect } from 'react'

type AsyncState<T> = { data: T | null; loading: boolean; error: string | null }

export function useAsync<T>(fn: () => Promise<T>, deps?: any[]) {
  const [state, setState] = useState<AsyncState<T>>({ data: null, loading: true, error: null })

  useEffect(() => {
    let isMounted = true

    fn()
      .then(data => {
        if (isMounted) setState({ data, loading: false, error: null })
      })
      .catch(e => {
        if (isMounted) setState({ data: null, loading: false, error: e.message })
      })

    return () => { isMounted = false }
  }, deps)

  return state
}

// Usage
export function MyComponent() {
  const { data, loading, error } = useAsync(() => fetch('/api/data').then(r => r.json()))

  if (loading) return <Skeleton />
  if (error) return <ErrorUI message={error} />
  if (!data) return <EmptyUI />

  return <DataDisplay data={data} />
}
```

**Why**: Prevents state updates on unmounted components, handles all three states without race conditions.

---

### API Route with Input Validation

```tsx
// app/api/items/route.ts
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import { z } from 'zod'

const CreateItemSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().max(1000).optional(),
})

export async function POST(req: Request) {
  try {
    const supabase = createRouteHandlerClient({ cookies })
    const { data: { session } } = await supabase.auth.getSession()

    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await req.json()
    const parsed = CreateItemSchema.safeParse(body)

    if (!parsed.success) {
      return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 })
    }

    const { data, error } = await supabase
      .from('items')
      .insert({ ...parsed.data, user_id: session.user.id })
      .select()
      .single()

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json(data, { status: 201 })
  } catch (e) {
    console.error('API error:', e)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
```

**Why**: Zod validates input shape, auth check prevents unauthorized writes, single() ensures you get one record back.

---

### Dynamic Route with Slug

```tsx
// app/items/[id]/page.tsx
import { notFound } from 'next/navigation'
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'

export async function generateStaticParams() {
  const supabase = createServerComponentClient({ cookies })
  const { data: items } = await supabase.from('items').select('id')
  return items?.map(item => ({ id: item.id })) || []
}

export default async function ItemPage({ params }: { params: { id: string } }) {
  const supabase = createServerComponentClient({ cookies })
  const { data: item, error } = await supabase
    .from('items')
    .select('*')
    .eq('id', params.id)
    .single()

  if (error || !item) notFound()

  return <ItemDetail item={item} />
}
```

**Why**: generateStaticParams pre-renders common pages at build time; notFound() returns 404 for missing items.

---

## Supabase Patterns

### Authentication Middleware

```tsx
// middleware.ts (root of project)
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs'
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export async function middleware(req: NextRequest) {
  const res = NextResponse.next()
  const supabase = createMiddlewareClient({ req, res })

  const { data: { session } } = await supabase.auth.getSession()

  // Redirect unauthenticated users to login
  if (!session && req.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  // Refresh session if needed
  await supabase.auth.refreshSession()

  return res
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/protected/:path*'],
}
```

**Why**: Refreshes session automatically; redirects unauthenticated requests before they reach your pages.

---

### Row-Level Security (RLS) Policy Template

```sql
-- Create public items table with RLS
CREATE TABLE items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT now(),
  UNIQUE(user_id, name)
);

ALTER TABLE items ENABLE ROW LEVEL SECURITY;

-- Users can only see their own items
CREATE POLICY "Users see own items"
  ON items FOR SELECT
  USING (auth.uid() = user_id);

-- Users can only create items for themselves
CREATE POLICY "Users create own items"
  ON items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can only update their own items
CREATE POLICY "Users update own items"
  ON items FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can only delete their own items
CREATE POLICY "Users delete own items"
  ON items FOR DELETE
  USING (auth.uid() = user_id);
```

**Why**: Ensures database security at the row level; no client can access another user's data even if they craft SQL directly.

---

### Realtime Subscription

```tsx
'use client'
import { useEffect, useState } from 'react'
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'

export function useRealtimeItems(userId: string) {
  const [items, setItems] = useState([])
  const supabase = createClientComponentClient()

  useEffect(() => {
    // Initial fetch
    supabase
      .from('items')
      .select('*')
      .eq('user_id', userId)
      .then(({ data }) => setItems(data || []))

    // Subscribe to changes
    const channel = supabase
      .channel(`items:${userId}`)
      .on('postgres_changes',
        { event: '*', schema: 'public', table: 'items', filter: `user_id=eq.${userId}` },
        (payload) => {
          if (payload.eventType === 'INSERT') {
            setItems(prev => [...prev, payload.new])
          } else if (payload.eventType === 'UPDATE') {
            setItems(prev => prev.map(item => item.id === payload.new.id ? payload.new : item))
          } else if (payload.eventType === 'DELETE') {
            setItems(prev => prev.filter(item => item.id !== payload.old.id))
          }
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [userId, supabase])

  return items
}
```

**Why**: Subscribes to database changes; updates UI in real-time when other users (or the same user from another tab) modify data.

---

### Storage Upload with Signed URLs

```tsx
// app/api/upload/route.ts
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'

export async function POST(req: Request) {
  const supabase = createRouteHandlerClient({ cookies })
  const { data: { session } } = await supabase.auth.getSession()

  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const formData = await req.formData()
  const file = formData.get('file') as File

  if (!file) return NextResponse.json({ error: 'No file' }, { status: 400 })

  const filePath = `${session.user.id}/${Date.now()}-${file.name}`

  const { error: uploadError } = await supabase.storage
    .from('uploads')
    .upload(filePath, file)

  if (uploadError) return NextResponse.json({ error: uploadError.message }, { status: 500 })

  // Generate signed URL (expires in 1 hour)
  const { data: { signedUrl } } = await supabase.storage
    .from('uploads')
    .createSignedUrl(filePath, 3600)

  return NextResponse.json({ url: signedUrl, path: filePath })
}
```

**Why**: Signed URLs prevent direct public access while allowing temporary download links. Paths are scoped to user_id for security.

---

## RTL/Bilingual Patterns

### RTL Layout Provider

```tsx
// components/rtl-provider.tsx
'use client'
import { usePathname } from 'next/navigation'

export function RTLProvider({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()
  const isArabic = pathname.startsWith('/ar')

  return (
    <div
      dir={isArabic ? 'rtl' : 'ltr'}
      lang={isArabic ? 'ar' : 'en'}
      className={`${isArabic ? 'font-cairo' : 'font-inter'}`}
    >
      {children}
    </div>
  )
}
```

**Why**: Switches text direction and font based on locale. Works with Tailwind's RTL utilities.

---

### Bilingual Text Component

```tsx
// components/bidi-text.tsx
interface BidiTextProps {
  ar: string
  en: string
  locale: 'ar' | 'en'
}

export function BidiText({ ar, en, locale }: BidiTextProps) {
  return (
    <span dir={locale === 'ar' ? 'rtl' : 'ltr'} lang={locale}>
      {locale === 'ar' ? ar : en}
    </span>
  )
}

// Usage: <BidiText ar="مرحبا" en="Hello" locale={locale} />
```

**Why**: Ensures proper text direction and language tagging. Use in headings, CTAs, any user-facing copy.

---

### Tailwind RTL Configuration

```js
// tailwind.config.ts
import type { Config } from 'tailwindcss'

export default {
  content: ['./app/**/*.tsx', './components/**/*.tsx'],
  theme: {
    fontFamily: {
      inter: ['Inter', 'sans-serif'],
      cairo: ['Cairo', 'sans-serif'],
    },
  },
  plugins: [require('tailwindcss-rtl')],
} satisfies Config
```

**Usage in JSX**:
```tsx
<div className="ltr:mr-4 rtl:ml-4">Content</div>
<button className="ltr:text-left rtl:text-right">Submit</button>
```

**Why**: tailwindcss-rtl plugin auto-flips margin, padding, and flex directions based on dir attribute.

---

## Error Handling Pattern

### Global Error Boundary

```tsx
// app/error.tsx
'use client'
import { useEffect } from 'react'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-50">
      <div className="bg-white p-8 rounded shadow">
        <h1 className="text-2xl font-bold text-gray-900">Something went wrong</h1>
        <p className="text-gray-600 mt-2">{error.message}</p>
        <button
          onClick={reset}
          className="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
        >
          Try again
        </button>
      </div>
    </div>
  )
}
```

**Why**: Catches errors in any child component. Reset attempts to re-render without refreshing the page.

---

### Toast Notification System

```tsx
// lib/toast.tsx
import { toast as sonnerToast } from 'sonner'

export function toast(message: string, type: 'success' | 'error' | 'info' = 'info') {
  if (type === 'success') sonnerToast.success(message)
  if (type === 'error') sonnerToast.error(message)
  if (type === 'info') sonnerToast.message(message)
}

// Usage in API responses
const { error } = await supabase.from('items').insert(data)
if (error) toast(error.message, 'error')
else toast('Item created', 'success')
```

**Why**: Shows non-blocking feedback for async operations. Install: `npm install sonner`.

---

### Form Validation Display

```tsx
'use client'
import { useState } from 'react'
import { z } from 'zod'

const formSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  email: z.string().email('Invalid email'),
})

export function MyForm() {
  const [errors, setErrors] = useState<Record<string, string>>({})

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)

    const parsed = formSchema.safeParse(Object.fromEntries(formData))
    if (!parsed.success) {
      const fieldErrors = parsed.error.flatten().fieldErrors
      setErrors(Object.fromEntries(
        Object.entries(fieldErrors).map(([key, msgs]) => [key, msgs?.[0] || ''])
      ))
      return
    }

    // Submit...
  }

  return (
    <form onSubmit={handleSubmit}>
      <input name="name" placeholder="Name" />
      {errors.name && <span className="text-red-600">{errors.name}</span>}
      <button type="submit">Submit</button>
    </form>
  )
}
```

**Why**: Client-side validation with clear error display before API call. Zod provides schema validation.

---

## Deployment Dockerfile

```dockerfile
# Multi-stage Next.js Dockerfile (Coolify-compatible)

FROM node:20-alpine AS base
WORKDIR /app
RUN apk add --no-cache libc6-compat

# Install dependencies
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci

# Build application
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Environment variables for build
ENV NEXT_PUBLIC_SUPABASE_URL=http://placeholder \
    NEXT_PUBLIC_SUPABASE_ANON_KEY=http://placeholder

RUN npm run build

# Production image
FROM base AS runner
ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT 3000

CMD ["node", "server.js"]
```

**Usage**:
```bash
# Build
docker build -t eo-app:latest .

# Run locally
docker run -e NEXT_PUBLIC_SUPABASE_URL=... -e NEXT_PUBLIC_SUPABASE_ANON_KEY=... -p 3000:3000 eo-app:latest
```

**Why**: Multi-stage build keeps production image small. Coolify expects EXPOSE 3000 and PORT env var.

---

## Quick Reference

| Pattern | File | Use When |
|---------|------|----------|
| Server Component Data Fetching | app/page.tsx | Initial page load, SEO-critical data |
| useAsync Hook | components/hooks.tsx | Client-side data fetching with states |
| API Route | app/api/route.ts | POST/PUT/DELETE operations, validation |
| Dynamic Routes | app/[id]/page.tsx | Individual resource pages |
| Middleware | middleware.ts | Auth checks, redirects, session refresh |
| RLS Policies | SQL migration | Database-level security |
| Realtime | useRealtimeItems() | Live data updates across tabs/users |
| Storage | app/api/upload/route.ts | File uploads, signed URLs |
| RTL Provider | components/rtl-provider.tsx | Arabic/RTL layout support |
| Error Boundary | app/error.tsx | Catch errors in component tree |
| Form Validation | components/form.tsx | Input validation + error display |
| Dockerfile | ./Dockerfile | Production deployment |
