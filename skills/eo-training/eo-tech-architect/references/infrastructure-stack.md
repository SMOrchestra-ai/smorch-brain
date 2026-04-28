# Infrastructure Stack - eo-tech-architect

VPS, containerization, CI/CD, monitoring, and cost projections.

## INFRASTRUCTURE STACK

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
─────────────────────────────────────
Contabo VPS (8GB RAM)        €8.99/mo
Supabase (free tier)         $0/mo (up to 500MB, 50K auth users)
Coolify (self-hosted)        $0/mo
Cloudflare (free)            $0/mo
GitHub Actions (free tier)   $0/mo
Sentry (free tier)           $0/mo
PostHog (free self-hosted)   $0/mo
Domain name                  ~$12/year
─────────────────────────────────────
TOTAL:                       ~$10-15/mo
```

Scale triggers: document when the student should expect to upgrade (user count, data volume, traffic thresholds).

---

