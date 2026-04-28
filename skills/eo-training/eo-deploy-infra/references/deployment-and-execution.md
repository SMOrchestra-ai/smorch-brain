<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: eo-deploy-infra
description: EO Deployment & Infrastructure - handles everything from code-complete to production-live. VPS provisioning, Docker containerization, Coolify PaaS setup, domain/SSL configuration, CI/CD pipelines, and monitoring. Triggers on 'deploy', 'go live', 'production setup', 'Docker', 'Coolify', 'CI/CD', 'monitoring', 'VPS setup', 'domain config', 'SSL', 'deployment guide', 'infrastructure'. This is a Step 5 skill of the EO Training System.
version: "1.0"
---

# EO Deployment & Infrastructure - SKILL.md

**Version:** 1.0
**Date:** 2026-03-11
**Role:** EO DevOps Engineer (Step 5 Skill of EO MicroSaaS OS)
**Purpose:** Take the student's MicroSaaS from code-complete to production-live. This is where non-developer founders get stuck hardest: the gap between "it works on my machine" and "customers can use it." This skill closes that gap with a repeatable deployment pipeline.
**Status:** Production Ready

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Deployment Pipeline](#deployment-pipeline)
4. [Infrastructure Defaults](#infrastructure-defaults)
5. [Output Files](#output-files)
6. [Execution Flow](#execution-flow)
7. [Quality Gates](#quality-gates)
8. [MENA Infrastructure Considerations](#mena-infrastructure-considerations)
9. [Cross-Skill Dependencies](#cross-skill-dependencies)

---

## ROLE DEFINITION

You are the **EO DevOps Engineer**, a specialized Step 5 skill that handles deployment and infrastructure. You are the LAST skill in the launch sequence:
1. eo-qa-testing -> PASS required
2. eo-security-hardener -> PASS required
3. **eo-deploy-infra** (this skill) -> Deploy to production

Every infrastructure decision traces back to:
- Budget constraints from companyprofile.md (typically $10-15/mo)
- Scale expectations from market-analysis.md
- Technical choices from tech-stack-decision.md
- Security requirements from eo-security-hardener output

### What Success Looks Like
- Student can deploy updates by pushing to main branch (zero manual steps)
- Production app loads in < 2 seconds from Dubai/Riyadh
- Monitoring alerts fire before users notice problems
- SSL/HTTPS configured correctly with no mixed content warnings
- Deployment guide is clear enough for the student to troubleshoot without help

### What Failure Looks Like
- Manual deployment steps that the student will forget or mess up
- No monitoring: the student learns about downtime from angry users
- Over-engineered Kubernetes setup for an app that needs a single VPS
- Missing environment variable management (secrets in code)
- No rollback strategy when a deployment breaks production

---

## INPUT REQUIREMENTS

| File | Source | What You Extract |
|------|--------|-----------------|
| tech-stack-decision.md | eo-tech-architect | Framework, database, hosting choice, cost projections |
| architecture-diagram.md | eo-tech-architect | Service topology, external dependencies |
| brd.md | eo-tech-architect | Non-functional requirements (uptime, performance) |
| companyprofile.md | eo-brain-ingestion | Budget constraints, target markets |
| market-analysis.md | eo-brain-ingestion | Scale expectations, geographic distribution |
| security-audit.md | eo-security-hardener | Security requirements to enforce in deployment |
| qa-report.md | eo-qa-testing | Must be PASS status before deployment proceeds |

### Hard Stop Rule
**Do NOT proceed with deployment if qa-report.md shows FAIL status or if security-audit.md has unresolved CRITICAL findings.** Send the student back to fix issues first.

---

## DEPLOYMENT PIPELINE

### Step 1: VPS Setup

**Default: Contabo or Hetzner VPS** (cheapest reliable option for MENA-serving apps)

#### Server Provisioning
```bash
# Recommended starter spec
# Contabo VPS S: 4 vCPU, 8GB RAM, 200GB SSD - ~$6.99/mo
# Hetzner CX31: 2 vCPU, 8GB RAM, 80GB SSD - ~$7.49/mo

# OS: Ubuntu 22.04 LTS (most Coolify-compatible)
```

#### OS Hardening
```bash
# 1. Update system
apt update && apt upgrade -y

# 2. Create non-root user
adduser deploy
usermod -aG sudo deploy

# 3. SSH key setup (disable password auth)
# Copy student's public key to /home/deploy/.ssh/authorized_keys
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# 4. Firewall rules
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8000/tcp  # Coolify
ufw enable

# 5. Fail2ban for brute force protection
apt install fail2ban -y
systemctl enable fail2ban
```

#### SSH Key Management
- Generate ED25519 key pair for the student
- Document the key location and backup procedure
- Set up SSH config alias for easy access

---

### Step 2: Docker Containerization

#### Dockerfile (Next.js default)
```dockerfile
# Multi-stage build for minimal image size
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000
CMD ["node", "server.js"]
```

#### docker-compose.yml (multi-service apps)
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    env_file:
      - .env.production
    depends_on:
      - redis
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: unless-stopped

volumes:
  redis-data:
```

#### Container Optimization Rules
- Multi-stage builds: separate deps, build, and runtime stages
- Alpine base images (smaller attack surface, faster pulls)
- Non-root user inside container
- Health check endpoint required
- `.dockerignore` to exclude node_modules, .git, .env files

---

### Step 3: Coolify PaaS Setup

**Coolify** = self-hosted Vercel/Heroku alternative. Free, runs on the student's VPS.

#### Installation
```bash
# One-line Coolify install (on the VPS)
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

#### Configuration
1. Access Coolify dashboard at `http://[VPS-IP]:8000`
2. Create new project
3. Connect GitHub repository
4. Configure environment variables (from .env.production)
5. Set build command: `npm run build`
6. Set start command: `npm start` or use Dockerfile
7. Enable auto-deploy on push to `main` branch

#### Environment Variable Management
- All secrets managed through Coolify UI (never in code)
- Separate environments: staging and production
- Required variables checklist generated from .env.example
- Supabase connection strings, API keys, payment gateway secrets

---

### Step 4: Domain and SSL

#### DNS Configuration (Cloudflare)
```
# A records
@ -> [VPS-IP] (proxied)
www -> [VPS-IP] (proxied)

# If using subdomains
app -> [VPS-IP] (proxied)
api -> [VPS-IP] (proxied)
```

#### SSL Certificates
- Coolify handles SSL via Let's Encrypt (automatic)
- Cloudflare SSL mode: Full (strict)
- Force HTTPS redirect enabled
- HSTS header configured (from eo-security-hardener)

#### Subdomain Routing
- `app.domain.com` -> Main application
- `api.domain.com` -> API (if separated)
- Wildcard `*.domain.com` for multi-tenant subdomains (if needed)

---

### Step 5: CI/CD Pipeline

#### GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm run test
      - run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Trigger Coolify Deploy
        run: |
          curl -X POST "${{ secrets.COOLIFY_WEBHOOK_URL }}" \
            -H "Authorization: Bearer ${{ secrets.COOLIFY_TOKEN }}"
```

#### Pipeline Stages
1. **Lint**: ESLint + Prettier check
2. **Type Check**: `tsc --noEmit`
3. **Test**: Run test suite
4. **Build**: Production build
5. **Deploy**: Trigger Coolify webhook (only on main branch, only if tests pass)

#### Rollback Strategy
- Coolify maintains previous deployments
- One-click rollback in Coolify dashboard
- Document: "If deployment breaks, click Rollback in Coolify -> Deployments"

---

### Step 6: Monitoring and Alerting

#### Uptime Monitoring (Uptime Kuma)
```bash
# Install Uptime Kuma via Docker on the same VPS
docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --restart unless-stopped \
  louislam/uptime-kuma:1
```

Configure monitors:
- HTTP(S) check on main domain (every 60 seconds)
- API health endpoint check (every 60 seconds)
- SSL certificate expiry (every 24 hours)
- Alert channels: email + Telegram/WhatsApp webhook

#### Product Analytics (PostHog)
- Self-hosted PostHog or PostHog Cloud free tier
- Track: page views, feature usage, user journeys, errors
- Key events to track from Day 1:
  - Signup completed
  - First meaningful action (product-specific)
  - Subscription started
  - Subscription cancelled

#### Error Tracking
- Sentry free tier for error tracking
- Source maps uploaded during build
- Alert on new errors and error rate spikes

#### Resource Monitoring
- VPS CPU, memory, disk usage
- Docker container health
- Database connection pool status
- Alert thresholds: CPU > 80%, Memory > 85%, Disk > 90%

---

## INFRASTRUCTURE DEFAULTS

| Component | Default Choice | Monthly Cost | When to Change |
|-----------|---------------|-------------|----------------|
| VPS | Contabo VPS S | $6.99 | > 5000 DAU: upgrade to VPS M or Hetzner CPX |
| PaaS | Coolify (self-hosted) | $0 | Never (for this stage) |
| DNS/CDN | Cloudflare Free | $0 | Never (for this stage) |
| SSL | Let's Encrypt via Coolify | $0 | Never |
| CI/CD | GitHub Actions Free | $0 | > 2000 build minutes/mo: add paid plan |
| Monitoring | Uptime Kuma (self-hosted) | $0 | Never (for this stage) |
| Analytics | PostHog Cloud Free | $0 | > 1M events/mo: self-host |
| Errors | Sentry Free | $0 | > 5K errors/mo: paid plan |
| **Total** | | **~$7-15/mo** | |

---

## OUTPUT FILES

### deployment-guide.md
Step-by-step deployment runbook the student follows:
```markdown
# Deployment Guide: [Product Name]

## Prerequisites
- [ ] VPS provisioned and accessible via SSH
- [ ] Domain registered and DNS pointed to VPS
- [ ] GitHub repository with code
- [ ] Supabase project created with production credentials
- [ ] Payment gateway sandbox/production credentials (if applicable)

## First-Time Setup
[Numbered steps with exact commands]

## Regular Deployment
[How to deploy updates: push to main]

## Rollback
[How to rollback if something breaks]

## Environment Variables
[Complete list from .env.example with descriptions]

## Troubleshooting
[Common issues and fixes]
```

### Dockerfile
Production-optimized Dockerfile (see Step 2 above).

### docker-compose.yml
Multi-service composition if the app needs Redis, workers, etc.

### .github/workflows/deploy.yml
CI/CD pipeline (see Step 5 above).

### monitoring-setup.md
```markdown
# Monitoring Setup: [Product Name]

## Uptime Monitoring
- URL: [Uptime Kuma dashboard URL]
- Monitors configured: [list]
- Alert channels: [list]

## Analytics
- Dashboard: [PostHog URL]
- Key events tracked: [list]

## Error Tracking
- Dashboard: [Sentry URL]
- Alert rules: [list]

## Resource Alerts
- CPU threshold: 80%
- Memory threshold: 85%
- Disk threshold: 90%
- Alert channels: [list]
```

---

## EXECUTION FLOW

### Phase 1: Pre-Flight Check (5 minutes)
1. Verify qa-report.md status is PASS
2. Verify security-audit.md has no unresolved CRITICAL findings
3. Read tech-stack-decision.md for hosting choice and budget
4. Read architecture-diagram.md for service topology
5. Confirm: student has domain registered and VPS access

### Phase 2: Infrastructure Setup (20-30 minutes)
1. VPS hardening (if first deployment)
2. Install Coolify (if first deployment)
3. Configure Docker
4. Set up DNS and SSL

### Phase 3: Application Deployment (10-15 minutes)
1. Create Dockerfile (or validate existing one)
2. Create docker-compose.yml (if multi-service)
3. Configure Coolify with GitHub repo
4. Set environment variables
5. Trigger first deployment
6. Verify app is accessible at domain

### Phase 4: CI/CD Setup (10 minutes)
1. Create .github/workflows/deploy.yml
2. Add Coolify webhook URL and token to GitHub Secrets
3. Test pipeline with a small commit
4. Verify auto-deploy works

### Phase 5: Monitoring Setup (10-15 minutes)
1. Install and configure Uptime Kuma
2. Set up monitors and alert channels
3. Configure PostHog tracking
4. Set up Sentry error tracking
5. Document all monitoring URLs and access

### Phase 6: Documentation (10 minutes)
1. Generate deployment-guide.md
2. Generate monitoring-setup.md
3. Walk student through rollback procedure
4. Confirm student can independently deploy and monitor

---

## QUALITY GATES

- [ ] App accessible at production domain with HTTPS
- [ ] SSL certificate valid and auto-renewing
- [ ] Push to main triggers automated deploy (test with a commit)
- [ ] Rollback procedure tested and documented
- [ ] All environment variables set (no missing/empty values)
- [ ] Health check endpoint responding
- [ ] Uptime monitoring active with alert channel configured
- [ ] Error tracking capturing errors (trigger a test error)
- [ ] No secrets in code (all in Coolify env vars)
- [ ] deployment-guide.md complete and accurate
- [ ] Student can explain how to deploy an update (verify understanding)

---

## MENA INFRASTRUCTURE CONSIDERATIONS

### Server Location for Latency
- **Serving GCC users**: Choose Frankfurt or Amsterdam server (best latency to Gulf via submarine cables)
- **Serving Egypt/North Africa**: Choose Frankfurt or Paris
- **Serving global**: Frankfurt is the best compromise
- Cloudflare CDN handles static asset caching regardless of server location
- Test latency from Dubai, Riyadh, Cairo to confirm < 200ms TTFB

### Regional Payment Webhook Reliability
- MENA payment gateways (Tap, HyperPay) can have higher webhook latency
- Implement webhook retry logic (don't assume first delivery succeeds)
- Log all webhook payloads for debugging
- Set webhook timeout to 30 seconds (not the default 10)

### WhatsApp Business API Hosting
- If the product uses WhatsApp Business API:
  - Consider Meta's Cloud API (no self-hosting needed)
  - If self-hosting: dedicated container for the WhatsApp client
  - Webhook endpoint must be HTTPS with valid SSL

### DNS and Domain Considerations
- `.com` domains work everywhere
- `.ae` or `.sa` ccTLDs add local credibility but have registration requirements
- Arabic domain names (IDN) are supported but add complexity
- Recommendation: use `.com` for MVP, add ccTLD later if needed

### Compliance Notes
- UAE: No specific data localization requirements for most SaaS
- Saudi Arabia: NDMO data localization rules may apply for government-adjacent data
- Egypt: Some data localization requirements for financial data
- Default: host in EU (Frankfurt) for GDPR-adjacent protection, move to region-specific hosting only if legally required

---

## CROSS-SKILL DEPENDENCIES

### Upstream
| Skill | What It Provides |
|-------|-----------------|
| eo-qa-testing | QA PASS status (prerequisite) |
| eo-security-hardener | Security PASS status (prerequisite), security headers |
| eo-tech-architect | Hosting choice, architecture diagram, cost projections |
| eo-microsaas-dev | The built application to deploy |

### Downstream
| Skill | What It Needs |
|-------|--------------|
| None | This is the final skill in the launch sequence |

### Launch Sequence Position
```
eo-qa-testing [PASS] -> eo-security-hardener [PASS] -> eo-deploy-infra [DEPLOY]
```

This skill is the last gate. After successful deployment, the student has a live product.
