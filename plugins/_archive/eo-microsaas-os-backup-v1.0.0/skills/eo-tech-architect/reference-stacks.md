# EO Tech Architect - Stack Reference Data

Reference file for default stack recommendations, AI stack, infrastructure, and cost estimates.

---

## Default Stack Recommendations

These are the defaults unless the student's requirements justify a different choice. Every deviation must have an explicit rationale documented in tech-stack-decision.md.

| Component | Default | Alternatives | Decision Factors |
|-----------|---------|-------------|-----------------|
| Frontend | Next.js (App Router) | Nuxt.js, SvelteKit, plain React | SSR needs, SEO requirements, developer familiarity |
| Backend | Next.js API Routes + Supabase | FastAPI, Express.js, Django | Complexity, real-time needs, team size |
| Database | Supabase (PostgreSQL) | PlanetScale, Neon, MongoDB | Data model complexity, scale requirements, cost |
| Auth | Supabase Auth | Clerk, Auth.js, Firebase Auth | Social login needs, multi-tenant, MENA phone auth |
| Hosting | Contabo VPS + Coolify | Vercel, Railway, Render | Budget, control needs, traffic expectations |
| Payments | Stripe (or regional) | Tap Payments, HyperPay | MENA market = regional gateway often required |

### When to Deviate from Defaults

**Deviate to FastAPI/Express backend when:**
- Product requires heavy background processing (queues, workers, long-running tasks)
- Real-time features are core (WebSockets, live collaboration)
- Team has strong Python/Node expertise and weak React skills

**Deviate to Vercel hosting when:**
- Budget allows $20-50/month for hosting
- Product is content-heavy with high SEO needs
- Student wants zero DevOps overhead and accepts vendor lock-in

**Deviate to MongoDB when:**
- Data model is highly flexible/schemaless (CMS, form builders)
- Student's existing codebase uses Mongoose/MongoDB

**Deviate to regional payment gateway when:**
- Primary market is Saudi Arabia, UAE, or Egypt
- Product needs local card networks (MADA, Meeza)
- Subscription billing with Arabic invoicing is required

---

## Agentic / AI Stack

Only recommend AI components when the student's product genuinely requires them. "AI-powered" is not a feature, it solves a specific user problem.

| Technology | Use Case | When to Recommend |
|-----------|----------|-------------------|
| Claude Code (required) | Development partner, code generation, debugging | ALWAYS: this is the primary build tool for Step 5 |
| Claude Agent SDK | Custom AI agents embedded in the product | When product requires autonomous AI workflows |
| LangChain / LangGraph | Complex chains, tool use, structured outputs | When product needs multi-step AI reasoning with state |
| LlamaIndex | RAG pipelines, document Q&A, knowledge bases | When product ingests and queries unstructured data |
| CrewAI | Multi-agent collaboration workflows | When product needs specialized agents working together |
| Gemini API | Vision, long-context, cost-effective inference | When Claude costs are prohibitive or vision tasks dominate |
| n8n AI nodes | No-code AI workflow integration | When AI features connect to existing n8n automations |

### AI Stack Decision Tree

```
Does the product need AI features for END USERS (not just for building)?
+-- NO -> Skip AI stack entirely. Claude Code is sufficient for development.
+-- YES -> What kind of AI?
|   +-- Chat/conversational -> Claude API or Gemini API (cost comparison)
|   +-- Document processing -> LlamaIndex + Supabase pgvector
|   +-- Multi-step workflows -> LangChain/LangGraph or CrewAI
|   +-- Image/vision -> Gemini API (cost) or Claude Vision (quality)
|   +-- Automation glue -> n8n AI nodes
```

---

## Infrastructure Stack

Optimized for solo MENA founders with $10K-50K total budget (not just infrastructure budget).

| Component | Default | Notes |
|-----------|---------|-------|
| VPS Provider | Contabo or Hetzner | Best cost/performance for MENA-adjacent regions |
| Container Runtime | Docker + Coolify | Self-hosted PaaS. Coolify manages deployments, SSL, domains |
| CI/CD | GitHub Actions | Free tier sufficient for most MicroSaaS |
| Monitoring | Uptime Kuma + PostHog | Self-hosted uptime + product analytics |
| Error Tracking | Sentry (free tier) | Or self-hosted GlitchTip |
| DNS/CDN | Cloudflare (free) | DNS, DDoS protection, edge caching |

### Monthly Infrastructure Cost Estimate

Produce a cost breakdown for every architecture recommendation:

```
EXAMPLE: Default Stack Monthly Costs
-------------------------------------
Contabo VPS (8GB RAM)        EUR8.99/mo
Supabase (free tier)         $0/mo (up to 500MB, 50K auth users)
Coolify (self-hosted)        $0/mo
Cloudflare (free)            $0/mo
GitHub Actions (free tier)   $0/mo
Sentry (free tier)           $0/mo
PostHog (free self-hosted)   $0/mo
Domain name                  ~$12/year
-------------------------------------
TOTAL:                       ~$10-15/mo
```

Scale triggers: document when the student should expect to upgrade (user count, data volume, traffic thresholds).

---

## API Integration Categories

Map the student's product needs to integration categories and prioritize for MVP vs. post-launch:

| Category | Services | Complexity | MVP Priority |
|----------|----------|-----------|-------------|
| Payments | Stripe, Tap Payments, HyperPay, PayPal | High (webhooks, idempotency, refunds) | Must-have if monetizing |
| Messaging | WhatsApp Business API, Twilio, SendGrid | Medium (rate limits, templates, deliverability) | Must-have for MENA products |
| Auth Providers | Google OAuth, Apple Sign-In, phone OTP | Medium (token management, session handling) | Must-have |
| Storage | Supabase Storage, S3, Cloudflare R2 | Low-Medium (upload, resize, CDN) | If product has file uploads |
| AI Services | Claude API, OpenAI, Gemini | Medium (streaming, token management, fallbacks) | If product has AI features |
| Analytics | PostHog, Mixpanel, Google Analytics | Low (event tracking, user identification) | Should-have from launch |

### Integration Priority Framework

For each integration, classify as:
- **MVP-CRITICAL**: Product doesn't work without it. Build in Month 1.
- **LAUNCH-DAY**: Not in MVP but needed for public launch. Build in Month 2.
- **POST-TRACTION**: Nice-to-have, build after first 20 paying customers. Month 3+.
- **SKIP**: Not needed for this product. Document why.

---

## MENA Architecture Considerations

These are not optional nice-to-haves. They are structural requirements for any product targeting Arabic-speaking MENA markets.

### Arabic / RTL Support
- Frontend must support RTL layout from Day 1 (not retrofitted later)
- Next.js: use `dir="rtl"` on html element, Tailwind RTL plugin
- Database: ensure UTF-8 encoding handles Arabic text, search, and sorting
- Fonts: include Arabic web fonts (Cairo, Tajawal, IBM Plex Arabic) in the bundle
- Mixed content: support LTR English within RTL Arabic layouts (common in tech products)

### Payment Infrastructure
- Stripe works in UAE but has limitations in Saudi Arabia, Jordan, Egypt
- Saudi Arabia: MADA card network is dominant, requires Tap Payments or HyperPay
- Egypt: local cards via Fawry or Paymob often needed alongside international cards
- Jordan: limited card penetration, consider eFAWATEERcom or wallet-based payments
- Always implement webhook-based payment confirmation (don't rely on client-side callbacks)

### Hosting and Latency
- Contabo has a Singapore DC (closest to Gulf) but no MENA DC
- Hetzner has no MENA DC
- Cloudflare CDN reduces perceived latency for static assets
- For latency-sensitive applications (real-time, video): consider AWS Bahrain or Azure UAE
- Most MicroSaaS products are fine with EU hosting + Cloudflare CDN

### WhatsApp Integration
- WhatsApp Business API is effectively mandatory for B2B and B2C in MENA
- BSPs (Business Solution Providers): 360dialog, Twilio, MessageBird
- Template messages require pre-approval (plan for 24-48 hour approval delays)
- Session messages (within 24h of user contact) are free, template messages are paid
- GHL already handles WhatsApp for many use cases: check if student needs direct API access

### Phone-Based Authentication
- SMS OTP is more trusted than email verification in MENA
- Supabase Auth supports phone OTP out of the box
- Consider dual auth: phone OTP for Arabic users, email/OAuth for English users
- SMS costs: ~$0.03-0.08 per message depending on country

### Data Residency
- UAE has data protection laws (PDPL) but enforcement is evolving
- Saudi Arabia: PDPA requires certain data categories to remain in-kingdom
- For MVP: document data residency approach, implement if required by customer contracts
- Most early-stage MicroSaaS can operate with EU-hosted data + clear privacy policy
