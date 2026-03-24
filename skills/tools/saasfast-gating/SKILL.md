---
name: saasfast-gating
description: "SaaSFast v3 Auth + Payment Gating Deployer — takes any existing web app (HTML pages, dashboards, assessment tools) and wraps it behind SaaSFast v3's landing page, Stripe payment, and Supabase auth. Produces a deployable repo with correct checkout flow, webhook user creation, magic link auth, and access gating. Triggers on: 'gate this app', 'add payment wall', 'put behind auth', 'saasfast gating', 'wrap with SaaSFast', 'add Stripe subscription to', 'gate access to', 'deploy behind payment', or any request to add auth+payment to an existing web app. Also triggers when integrating SaaSFast with another repo, creating a paid landing page for an existing tool, or setting up subscription-based access to HTML content."
---

# SaaSFast v3 Auth + Payment Gating

You are deploying SaaSFast v3 as a gating layer around an existing web app. This means the user has content (HTML pages, a dashboard, an assessment tool) and wants to put it behind:
1. A branded landing page with pricing
2. Stripe payment (subscription or one-time)
3. Supabase auth (magic link + optional Google OAuth)
4. Access gating (only paid users see the content)

## Architecture

```
[Landing Page] → [Stripe Checkout (guest OK)] → [Webhook: create user + set has_access=true]
                                                       |
[Sign In] → [Magic Link / Google] → [Gated Layout checks profiles.has_access]
                                                       |
                                            [API route serves HTML content]
```

**Single source of truth for access: `profiles.has_access`** (boolean, set by Stripe webhook, revoked on subscription cancellation).

## Step 0: Gather Inputs

Before writing any code, collect these from the user. Ask in a grouped format — don't ask one at a time:

**Required:**
- Target repo URL (the app to gate) or local path to HTML content
- App name (display name)
- Production domain (e.g., `score.entrepreneursoasis.me`)
- Stripe price ID (`price_xxx`)
- Display price and currency (e.g., `170 AED`)
- Plan mode: `subscription` or `payment`
- Gated section name (e.g., `assessment`, `dashboard`, `app`)

**Optional (has defaults):**
- Theme: `dark` or `light` (default: `dark`)
- Primary color (default: `#FF6600`)
- Default locale: `en` or `ar` (default: `en`)

**User provides later (not needed for code):**
- Stripe secret key, webhook secret
- Supabase service role key
- Resend API key

## Dependency Order — Do Not Skip

Start Resend domain verification FIRST (DNS propagation takes 5-30 min). While waiting:

```
1. Stripe Product + Price        ← gives you priceId
2. Supabase Project              ← gives you URL + keys
3. Resend Domain (start early!)  ← gives you verified sender
4. Code changes (steps 1-7)      ← needs priceId from #1
5. Supabase: Site URL + SMTP     ← needs Resend verified from #3
6. Stripe: Webhook endpoint      ← needs domain deployed
7. .env complete → Build → Deploy
```

## Step 1: Repository Setup

```bash
# Clone SaaSFast v3 as the base
gh repo clone SMOrchestra-ai/SaaSFast <new-repo-name>
cd <new-repo-name>

# Change git remote to new repo (if creating a new repo)
git remote set-url origin https://github.com/SMOrchestra-ai/<new-repo-name>.git

# Copy content HTML from target app
mkdir -p content-html/
# Copy the user's HTML files into content-html/
```

**Critical:** Identify ALL HTML files in the target repo. Create a mapping object:

```js
const CONTENT_MAP = {
  "slug1": "Actual-File-Name.html",
  "slug2": "Another-File.html",
  // ... one entry per HTML file
};
```

## Step 2: Configure `config/storefront.js`

This is the ONLY config file to edit. Everything else reads from it.

```js
const storefront = {
  appName: "<app-name>",
  appDescription: "<one-line-description>",
  domainName: "<production-domain>",  // NEVER localhost
  defaultLocale: "<en|ar>",
  stripe: {
    plans: [{
      priceId: "<price_xxx>",
      name: "<plan-display-name>",
      tier: "<tier-slug>",
      description: "<what-they-get>",
      price: <number>,
      currency: "<AED|USD|etc>",
      mode: "<subscription|payment>",
      isFeatured: true,
      features: [
        { name: "Feature 1" },
        // ...
      ],
    }],
  },
  resend: {
    fromNoReply: `<App Name> <noreply@<domain>>`,
    fromAdmin: `<Owner Name> <owner@domain>`,
    supportEmail: "support@<domain>",
  },
  auth: {
    loginUrl: "/signin",
    callbackUrl: "/<gated-section>",
  },
  colors: {
    theme: "<dark|light>",
    main: "<primary-color-hex>",
  },
};
```

## Step 3: Create Gated Layout

Create `app/<gated-section>/layout.js`:

```js
import { redirect } from "next/navigation";
import { createClient } from "@/libs/supabase/server";
import config from "@/config";

export default async function GatedLayout({ children }) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      redirect(config.auth.loginUrl || "/signin");
    }

    // ALWAYS check profiles.has_access — NEVER check purchases table
    const { data: profile, error } = await supabase
      .from("profiles")
      .select("has_access")
      .eq("id", user.id)
      .single();

    if (error || !profile?.has_access) {
      redirect("/#pricing");
    }

    return <>{children}</>;
  } catch (e) {
    if (e?.digest?.startsWith("NEXT_REDIRECT")) throw e;
    console.error("Gated layout error:", e.message);
    redirect("/#pricing");
  }
}
```

## Step 4: Create Content API Route

Create `app/api/<gated-section>/[item]/route.js`:

```js
import { createClient } from "@/libs/supabase/server";
import { NextResponse } from "next/server";
import fs from "fs";
import path from "path";

const CONTENT_MAP = {
  // <slug>: "<filename.html>" — populated from Step 1
};

export async function GET(request, { params }) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // ALWAYS check profiles.has_access — NEVER check purchases table
  const { data: profile } = await supabase
    .from("profiles")
    .select("has_access")
    .eq("id", user.id)
    .single();

  if (!profile?.has_access) {
    return NextResponse.json(
      { error: "Purchase required. Please select a plan." },
      { status: 403 }
    );
  }

  const { item } = await params;
  const filename = CONTENT_MAP[item];

  if (!filename) {
    return NextResponse.json({ error: "Not found" }, { status: 404 });
  }

  const filePath = path.join(process.cwd(), "content-html", filename);

  try {
    const html = fs.readFileSync(filePath, "utf-8");
    return new NextResponse(html, {
      headers: {
        "Content-Type": "text/html; charset=utf-8",
        "Cache-Control": "private, no-cache",
      },
    });
  } catch {
    return NextResponse.json({ error: "Content file not found" }, { status: 500 });
  }
}
```

## Step 5: Verify Critical Code Paths

### 5a. Check `libs/stripe.js` — client_reference_id

The `createCheckout` function MUST conditionally pass `client_reference_id`:

```js
// CORRECT — only pass when non-null
...(clientReferenceId ? { client_reference_id: clientReferenceId } : {}),
```

If it passes `clientReferenceId` directly (without the conditional), Stripe will reject with "empty string" error for guest checkouts. Fix it.

### 5b. Check `libs/supabase/middleware.js` — route skipping

The middleware MUST skip auth refresh for webhook and auth routes:

```js
const skipAuthRoutes = ["/api/webhook", "/api/lead", "/api/auth"];
if (skipAuthRoutes.some((route) => pathname.startsWith(route))) {
  return NextResponse.next({ request });
}
```

If missing, webhooks will fail with 500 errors.

### 5c. Check `app/api/auth/callback/route.js` — origin URL

The callback MUST use the production domain, not `request.url` origin:

```js
const origin = `https://${config.domainName}`;
```

If it uses `new URL(req.url).origin`, it will use localhost in some environments.

### 5d. Check webhook handler — user creation for guests

The webhook (`app/api/webhook/stripe/route.js`) must handle both:
- Authenticated users: look up by `client_reference_id`
- Guest users: look up by email, create user if not found via `supabase.auth.admin.createUser`

And MUST set `has_access: true` on the profile after payment.

## Step 6: Supabase Migration

Run this migration to ensure the profiles table has the required columns AND the auto-creation trigger:

```sql
-- Add gating columns
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS has_access boolean DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS customer_id text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS price_id text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS stripe_subscription_id text;

-- Auto-create profile when auth user is created (critical for guest checkout)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (NEW.id, NEW.email, 'visitor')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

Without the trigger, guest checkout fails because the webhook creates the auth user but can't find the profile row to set `has_access = true`.

Use the Supabase MCP `apply_migration` tool if available, or `execute_sql`.

## Step 6.5: Security — .env.example and .gitignore

Create `.env.example` (committed to repo, no real secrets) so future devs know what's needed. Verify `.gitignore` includes `.env`, `.env.local`, `.env.production`. If missing, add BEFORE first commit — leaked secrets in git history are permanent.

## Step 7: Landing Page Customization

Update these components based on the user's branding:

| Component | What to change |
|-----------|---------------|
| `components/Hero.js` | Headline, subtitle, feature preview cards |
| `components/Pricing.js` | Usually auto-reads from config — verify |
| `components/FAQ.js` | Replace with app-specific FAQ content |
| `components/CTA.js` | Bottom CTA text |
| `components/Footer.js` | Links, legal, support email |
| `app/globals.css` | Theme colors, custom card styles |
| `app/layout.js` | Font imports if matching existing app |

If matching an existing dark app, set `colors.theme: "dark"` in config AND override DaisyUI HSL variables in `globals.css`.

## Step 8: Output the .env Template

Present this to the user — they fill in the values:

```env
# Supabase (Dashboard → Settings → API)
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Stripe (Dashboard → Developers → API Keys)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# Resend (Dashboard → API Keys)
RESEND_API_KEY=

# Auth (generate: openssl rand -base64 32)
NEXTAUTH_SECRET=
```

## Step 9: External Service Configuration Checklist

Present this as a checklist — these are manual steps the user MUST do:

### Supabase Dashboard (do BEFORE first test)
- [ ] **Site URL** → `https://<production-domain>` (Authentication → URL Configuration)
- [ ] **Redirect URLs** → add `https://<domain>/**` and `http://localhost:3000/**`
- [ ] **Email OTP Expiry** → set to `3600` seconds (Auth → Rate Limits)
- [ ] **Custom SMTP** → enable with Resend credentials:
  - Host: `smtp.resend.com`, Port: `465`
  - Username: `resend`, Password: `<RESEND_API_KEY>`
  - Sender: `noreply@<domain>`

### Resend
- [ ] Add domain → get 3 DNS records (DKIM TXT, SPF MX, SPF TXT)
- [ ] Add DNS records to provider (GoDaddy/Cloudflare/etc)
- [ ] Verify domain

### Stripe
- [ ] Create webhook endpoint: `https://<domain>/api/webhook/stripe`
- [ ] Subscribe to events: `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `invoice.paid`, `invoice.payment_failed`
- [ ] Copy webhook signing secret to `.env`
- [ ] Enable promotion codes on the price (for discount code support)

### Google OAuth (optional)
- [ ] Google Cloud Console → Create OAuth 2.0 Client ID
- [ ] Redirect URI: `https://<supabase-project-ref>.supabase.co/auth/v1/callback`
- [ ] Enable in Supabase → Auth → Providers → Google

## Step 10: Deployment Template

### nginx config:
```nginx
server {
    listen 443 ssl;
    server_name <domain>;

    ssl_certificate /etc/letsencrypt/live/<domain>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<domain>/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
        proxy_connect_timeout 86400;
    }
}
```

### pm2 commands:
```bash
npm ci && npm run build
pm2 start npm --name "<app-name>" -- start
pm2 save
```

## Step 11: Pre-Launch QA

Run these checks BEFORE telling the user it's ready:

### Code verification
- [ ] `config/storefront.js` → `domainName` is production URL (not localhost)
- [ ] `config/storefront.js` → `priceId` matches Stripe dashboard
- [ ] `config/storefront.js` → `auth.callbackUrl` points to gated section
- [ ] Gated layout → checks `profiles.has_access`
- [ ] API route → checks `profiles.has_access`
- [ ] `libs/stripe.js` → `client_reference_id` is conditional
- [ ] `middleware.js` → skips `/api/webhook` and `/api/auth`
- [ ] `npm run build` passes

### Functional (if dev server available)
- [ ] Landing page loads
- [ ] Checkout button works without login
- [ ] Gated section redirects to signin when not logged in
- [ ] Gated section redirects to pricing when logged in but no access

## Error Prevention Rules

These are non-negotiable. Every error here was hit in production:

1. **NEVER check the `purchases` table for access.** Always use `profiles.has_access`. The purchases table is for product-level tracking in the storefront mode — it's empty in gating mode.

2. **NEVER pass `client_reference_id` when null.** Stripe rejects empty strings. Use the conditional spread pattern.

3. **NEVER set `domainName` to localhost.** Magic links, auth callbacks, and email links all derive from this value.

4. **ALWAYS configure Supabase SMTP before first test.** Default Supabase email is rate-limited to 3/hour and links expire in 5 minutes. Users will think auth is broken.

5. **ALWAYS set Supabase Site URL to production domain.** Magic links use this as the base URL. If it's localhost, links will point to localhost.

6. **ALWAYS ensure nginx has high proxy timeouts.** The auth callback and Stripe webhook can take several seconds. Default nginx timeout causes 502.

7. **NEVER modify the original app's HTML files.** SaaSFast gates access to them — it doesn't alter them. Copy them into `content-html/` and serve as-is.
