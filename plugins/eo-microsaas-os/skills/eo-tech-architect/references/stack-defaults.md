# Default Stack Recommendations - eo-tech-architect

Standard technology recommendations and decision criteria.

## DEFAULT STACK RECOMMENDATIONS

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

