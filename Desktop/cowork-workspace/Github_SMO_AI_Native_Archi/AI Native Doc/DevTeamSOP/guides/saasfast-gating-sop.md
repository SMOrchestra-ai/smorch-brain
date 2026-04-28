# SaaSFast v3 Gating SOP — Ship Any App Behind Auth + Payment

## What This Solves

You have an existing web app (HTML pages, a dashboard, an assessment tool — anything).
You want to put it behind:
1. A landing page with pricing
2. Stripe payment (subscription or one-time)
3. Supabase auth (magic link + Google OAuth)
4. Access gating (only paid users see the app)

SaaSFast v3 handles all of this. This SOP documents exactly how to integrate it — avoiding every error we hit during the EO Scorecard integration.

---

## Architecture Overview

```
[Landing Page] --> [Stripe Checkout] --> [Webhook creates user + sets has_access]
                                              |
[Sign In] --> [Magic Link / Google] --> [Assessment Layout checks has_access]
                                              |
                                    [API route serves gated content]
```

**Source of truth for access**: `profiles.has_access` (boolean, set by Stripe webhook)

**Key files in SaaSFast v3:**
| File | Purpose |
|------|---------|
| `config/storefront.js` | App name, domain, Stripe plan, colors, auth URLs |
| `app/api/stripe/create-checkout/route.js` | Creates Stripe checkout (guest + auth) |
| `app/api/webhook/stripe/route.js` | Handles payment → creates user → sets access |
| `app/api/auth/callback/route.js` | Exchanges auth code for session |
| `libs/stripe.js` | Stripe session creation (handles null clientReferenceId) |
| `libs/supabase/middleware.js` | Refreshes auth tokens, skips webhook/auth routes |
| `libs/supabase/server.js` | Server-side Supabase client |
| `libs/resend.js` | Email sending via Resend |
| `middleware.js` | Root middleware — delegates to supabase middleware |
| `app/[gated-section]/layout.js` | Layout that checks auth + has_access |
| `app/api/[gated-section]/[item]/route.js` | API that serves gated content |

---

## Step-by-Step Integration

### Phase 1: Repository Setup

#### 1.1 Create the gated app repo

```bash
# Clone SaaSFast v3 as base
gh repo clone SMOrchestra-ai/SaaSFast my-gated-app
cd my-gated-app

# Copy your existing app's HTML/content into a directory
mkdir -p content-html/
cp /path/to/your/app/*.html content-html/
```

#### 1.2 Configure `config/storefront.js`

This is the ONLY config file you need to edit. Everything else reads from it.

```js
const storefront = {
  appName: "Your App Name",
  appDescription: "One-line description",
  domainName: "your-domain.com",           // CRITICAL: must match production URL
  defaultLocale: "en",                      // or "ar" for Arabic-first
  stripe: {
    plans: [
      {
        priceId: "price_xxx",              // From Stripe Dashboard
        name: "Plan Name",
        tier: "assessment",                // or "starter", "pro", etc.
        description: "What they get",
        price: 170,                        // Display price
        currency: "AED",                   // Display currency
        mode: "subscription",              // or "payment" for one-time
        isFeatured: true,
        features: [
          { name: "Feature 1" },
          { name: "Feature 2" },
        ],
      },
    ],
  },
  resend: {
    fromNoReply: "App Name <noreply@your-domain.com>",
    fromAdmin: "Your Name <you@your-domain.com>",
    supportEmail: "support@your-domain.com",
  },
  auth: {
    loginUrl: "/signin",
    callbackUrl: "/your-gated-section",    // Where to redirect after login
  },
  colors: {
    theme: "dark",                          // or "light"
    main: "#FF6600",                        // Primary brand color
  },
};
```

### Phase 2: Create the Gated Section

#### 2.1 Create the gated layout

Create `app/[section]/layout.js` (e.g., `app/assessment/layout.js`):

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

#### 2.2 Create the API route for gated content

Create `app/api/[section]/[item]/route.js`:

```js
import { createClient } from "@/libs/supabase/server";
import { NextResponse } from "next/server";
import fs from "fs";
import path from "path";

// Map URL slugs to HTML files
const CONTENT_MAP = {
  page1: "Page-One.html",
  page2: "Page-Two.html",
  // ...add your mappings
};

export async function GET(request, { params }) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // IMPORTANT: Check profiles.has_access — NOT the purchases table
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

### Phase 2.5: Security — .gitignore and .env.example

#### Create `.env.example` (committed to repo — no secrets)

```env
# Supabase (Dashboard → Settings → API)
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Stripe (Dashboard → Developers → API Keys)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_xxx
STRIPE_SECRET_KEY=sk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# Resend (Dashboard → API Keys)
RESEND_API_KEY=re_xxx

# Auth (generate: openssl rand -base64 32)
NEXTAUTH_SECRET=generate-this-on-server
```

#### Verify `.gitignore` includes:

```
.env
.env.local
.env.production
```

If missing, add them BEFORE the first commit. Leaked secrets in git history are permanent.

### Phase 3: Supabase Database Setup

#### 3.1 Required columns on profiles table

The `profiles` table MUST have these columns (add via migration if missing):

```sql
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS has_access boolean DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS customer_id text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS price_id text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS stripe_subscription_id text;
```

#### 3.2 Profile auto-creation trigger

When a new user signs up (via magic link or OAuth), a profile row must exist BEFORE the webhook tries to update it. Add this trigger:

```sql
-- Auto-create profile row when a new auth user is created
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (NEW.id, NEW.email, 'visitor')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if any, then create
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

Without this trigger, the webhook will fail to find the profile for new guest users created via `supabase.auth.admin.createUser`.

#### 3.3 RLS policies

```sql
-- Users can read their own profile
CREATE POLICY "Users can read own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Service role can update profiles (webhook uses service_role key)
-- This is automatic — service_role bypasses RLS
```

### Phase 4: Environment Variables

Create `.env.local` with ALL of these. Missing any one will cause failures:

```env
# Supabase (Dashboard → Settings → API)
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...

# Stripe (Dashboard → Developers → API Keys)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Resend (Dashboard → API Keys)
RESEND_API_KEY=re_...

# Auth
NEXTAUTH_SECRET=<run: openssl rand -base64 32>
```

### Phase 5: External Service Configuration

#### 5.1 Supabase Auth Settings

Go to: `Supabase Dashboard → Authentication → URL Configuration`

| Setting | Value |
|---------|-------|
| Site URL | `https://your-domain.com` |
| Redirect URLs | `https://your-domain.com/**`, `http://localhost:3000/**` |

Go to: `Authentication → Email Templates`
- Ensure magic link URL uses `{{ .SiteURL }}` not hardcoded localhost

Go to: `Authentication → SMTP Settings → Enable Custom SMTP`

| Setting | Value |
|---------|-------|
| Host | `smtp.resend.com` |
| Port | `465` |
| Username | `resend` |
| Password | Your `RESEND_API_KEY` |
| Sender email | `noreply@your-domain.com` |
| Sender name | Your app name |

#### 5.2 Resend Domain Verification

```bash
# Via Resend MCP or Dashboard
# Create domain → get 3 DNS records → add to DNS provider
# Records: TXT (DKIM), MX (send subdomain), TXT (SPF)
```

#### 5.3 Stripe Webhook

Go to: `Stripe Dashboard → Developers → Webhooks → Add endpoint`

| Setting | Value |
|---------|-------|
| Endpoint URL | `https://your-domain.com/api/webhook/stripe` |
| Events | `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `invoice.paid`, `invoice.payment_failed` |

Copy the signing secret → put in `.env` as `STRIPE_WEBHOOK_SECRET`

#### 5.4 Stripe Product + Price

If you don't have a price yet:
1. Stripe Dashboard → Products → Add product
2. Set name, description
3. Add price (recurring for subscription, one-time for payment)
4. Copy the `price_xxx` ID → put in `config/storefront.js`

#### 5.5 Google OAuth (Optional)

1. Google Cloud Console → APIs & Services → Credentials
2. Create OAuth 2.0 Client ID (Web application)
3. Authorized redirect URI: `https://xxxxx.supabase.co/auth/v1/callback`
4. Copy Client ID + Secret → Supabase → Authentication → Providers → Google

### Phase 6: Landing Page Customization

#### 6.1 Components to update

| Component | What to change |
|-----------|---------------|
| `components/Hero.js` | Headline, subtitle, CTA text, scorecard/feature preview |
| `components/Pricing.js` | Reads from config — usually no changes needed |
| `components/FAQ.js` | Replace FAQ content |
| `components/CTA.js` | Bottom CTA text |
| `components/Footer.js` | Links, legal pages |
| `app/globals.css` | Colors, fonts, custom CSS classes |
| `app/layout.js` | Font imports if changing typeface |

#### 6.2 Design matching

If matching an existing app's dark theme, update in `globals.css`:

```css
[data-theme="dark"] {
  --b1: 222 47% 4%;    /* Page background */
  --b2: 222 30% 9%;    /* Section backgrounds */
  --b3: 222 24% 11%;   /* Card backgrounds */
  --p: 24 100% 50%;    /* Primary color */
}
```

### Phase 7: Deployment (Contabo + nginx)

#### 7.1 Server setup

```bash
ssh root@your-server
cd /var/www/
git clone https://github.com/your-org/your-repo.git
cd your-repo
npm ci

# Create .env with all variables from Phase 4
nano .env

# Generate NEXTAUTH_SECRET
echo "NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> .env

# Build
npm run build

# Start with pm2
pm2 start npm --name "your-app" -- start
pm2 save
```

#### 7.2 nginx config

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

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

#### 7.3 SSL certificate

```bash
apt install certbot python3-certbot-nginx
certbot --nginx -d your-domain.com
```

### Phase 8: QA Checklist

Run these checks BEFORE going live:

#### Code checks
- [ ] `config/storefront.js` has correct `domainName` (not localhost)
- [ ] `config/storefront.js` has correct `priceId` from Stripe
- [ ] `config/storefront.js` `auth.callbackUrl` points to gated section
- [ ] Gated layout checks `profiles.has_access` (NOT `purchases` table)
- [ ] API route checks `profiles.has_access` (NOT `purchases` table)
- [ ] `libs/stripe.js` only passes `client_reference_id` when non-null
- [ ] All `.env` variables are set (8 total)
- [ ] `npm run build` succeeds

#### Supabase checks
- [ ] Site URL = production domain (not localhost)
- [ ] Redirect URLs include production domain with `/**`
- [ ] Custom SMTP enabled with Resend credentials
- [ ] `profiles` table has `has_access`, `customer_id`, `price_id` columns
- [ ] RLS enabled on profiles table

#### Stripe checks
- [ ] Webhook endpoint URL = `https://domain/api/webhook/stripe`
- [ ] Webhook events: `checkout.session.completed`, `customer.subscription.deleted`, `invoice.paid`
- [ ] Webhook signing secret in `.env`
- [ ] `allow_promotion_codes: true` in checkout (for discount codes)

#### Resend checks
- [ ] Domain verified (DKIM + SPF records in DNS)
- [ ] `from` email matches verified domain

#### Functional tests
- [ ] Landing page loads with correct branding
- [ ] "Start Assessment" button → Stripe checkout (no login required)
- [ ] Complete payment → email received with magic link
- [ ] Magic link → redirects to gated section (not localhost)
- [ ] Sign in with Google → lands on gated section
- [ ] Gated content loads (API returns HTML, not 403)
- [ ] Cancel subscription → `has_access` set to false

---

## Errors We Hit and How to Avoid Them

| # | Error | Root Cause | Prevention |
|---|-------|-----------|------------|
| 1 | "Please login" on checkout click | ButtonCheckout required auth session | SaaSFast v3 already handles guest checkout — don't add auth checks to checkout route |
| 2 | `client_reference_id` empty string error | Passed `null` as empty string to Stripe | `libs/stripe.js` now uses `...(clientReferenceId ? { client_reference_id: clientReferenceId } : {})` |
| 3 | Magic link points to localhost | Supabase Site URL was `http://localhost:3000` | Set Site URL to production domain BEFORE first test |
| 4 | Magic link email never arrives | No custom SMTP configured | Configure Resend SMTP in Supabase BEFORE first test |
| 5 | OTP expired error on magic link | Default Supabase OTP expiry = 300s (5 min) | Increase to 3600s in Supabase → Auth → Rate Limits |
| 6 | Google OAuth 400 "provider not enabled" | Google provider not toggled on in Supabase | Enable in Supabase → Auth → Providers → Google |
| 7 | 502 Bad Gateway on `/api/auth/callback` | nginx proxy timeout or app not running | Ensure `proxy_read_timeout` and `proxy_connect_timeout` are high (86400) |
| 8 | "Purchase required" for paid user | API route checked `purchases` table (empty) | ALWAYS check `profiles.has_access` — it's the single source of truth |
| 9 | Build fails — missing Supabase keys | `.env` not set during build | Create `.env.local` with at least the NEXT_PUBLIC vars before build |
| 10 | Wrong design — light theme on dark app | DaisyUI theme set to "light" | Set `colors.theme: "dark"` in config AND override DaisyUI HSL vars in globals.css |

---

## Dependency Map — What Blocks What

Do these in order. Each row depends on the ones above it.

```
1. Stripe Product + Price           ← needed for priceId in config
2. Supabase Project                 ← needed for URL + keys in .env
3. Resend Domain + DNS records      ← needed for email verification (takes 5-30 min)
4. Code: config/storefront.js       ← needs priceId from step 1
5. Code: gated layout + API route   ← needs config from step 4
6. Code: landing page components    ← independent, can parallel with step 5
7. Supabase: Site URL + SMTP        ← needs Resend verified from step 3
8. Stripe: Webhook endpoint         ← needs domain deployed first (or use CLI for local)
9. .env file complete               ← needs all keys from steps 1-3 + webhook secret from step 8
10. Build + Deploy                  ← needs .env from step 9
11. Stripe: Test webhook            ← needs app running from step 10
```

**Parallelizable:** Steps 1, 2, 3 can run simultaneously. Steps 5 and 6 can run simultaneously.

**Biggest blocker:** Resend domain verification (step 3) — start this FIRST because DNS propagation takes time.

---

## Troubleshooting — When Something Goes Wrong

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Checkout button shows "Something went wrong" | Missing or invalid `STRIPE_SECRET_KEY` | Check `.env`, restart app |
| Payment succeeds but no email arrives | Resend domain not verified, or SMTP not configured in Supabase | Check Resend dashboard for domain status, check Supabase SMTP settings |
| Magic link lands on localhost | Supabase Site URL is still `http://localhost:3000` | Update to `https://your-domain.com` in Supabase → Auth → URL Config |
| Magic link says "expired" | OTP expiry too short (default 300s) | Increase to 3600 in Supabase → Auth → Rate Limits |
| 502 after clicking magic link | nginx timeout on `/api/auth/callback` | Add `proxy_read_timeout 86400;` to nginx config, reload nginx |
| "Purchase required" after paying | API checks `purchases` table instead of `profiles.has_access` | Fix API route to query `profiles.has_access` |
| Webhook returns 500 | Missing `STRIPE_WEBHOOK_SECRET` or `SUPABASE_SERVICE_ROLE_KEY` | Check `.env` has both values, restart app |
| Build fails with Supabase error | Missing `NEXT_PUBLIC_SUPABASE_URL` or `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Set at least the NEXT_PUBLIC vars before building |
| Emails land in spam | Missing SPF/DKIM records | Add all 3 Resend DNS records, wait for verification |
| Google sign-in returns 400 | Provider not enabled or wrong redirect URI | Enable Google in Supabase → Auth → Providers, check redirect URI matches |

---

## Quick Reference: The 3-Command Deploy

Once all external services are configured:

```bash
# 1. Clone and configure
git clone https://github.com/your-org/your-gated-app.git
cd your-gated-app && cp .env.example .env && nano .env

# 2. Build
npm ci && npm run build

# 3. Run
pm2 start npm --name "your-app" -- start
```

That's it. The app handles everything else — guest checkout, webhook user creation, magic links, access gating, subscription cancellation.
