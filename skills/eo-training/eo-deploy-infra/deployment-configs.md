# EO Deploy Infra - Deployment Configurations

Reference file for VPS setup, Docker, Coolify, CI/CD, monitoring configs, and output templates.

---

## VPS Setup

### Server Provisioning
```bash
# Recommended starter spec
# Contabo VPS S: 4 vCPU, 8GB RAM, 200GB SSD - ~$6.99/mo
# Hetzner CX31: 2 vCPU, 8GB RAM, 80GB SSD - ~$7.49/mo

# OS: Ubuntu 22.04 LTS (most Coolify-compatible)
```

### OS Hardening
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

### SSH Key Management
- Generate ED25519 key pair for the student
- Document the key location and backup procedure
- Set up SSH config alias for easy access

---

## Docker Containerization

### Dockerfile (Next.js default)
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

### docker-compose.yml (multi-service apps)
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

### Container Optimization Rules
- Multi-stage builds: separate deps, build, and runtime stages
- Alpine base images (smaller attack surface, faster pulls)
- Non-root user inside container
- Health check endpoint required
- `.dockerignore` to exclude node_modules, .git, .env files

---

## Coolify PaaS Setup

### Installation
```bash
# One-line Coolify install (on the VPS)
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

### Configuration
1. Access Coolify dashboard at `http://[VPS-IP]:8000`
2. Create new project
3. Connect GitHub repository
4. Configure environment variables (from .env.production)
5. Set build command: `npm run build`
6. Set start command: `npm start` or use Dockerfile
7. Enable auto-deploy on push to `main` branch

### Environment Variable Management
- All secrets managed through Coolify UI (never in code)
- Separate environments: staging and production
- Required variables checklist generated from .env.example
- Supabase connection strings, API keys, payment gateway secrets

---

## Domain and SSL

### DNS Configuration (Cloudflare)
```
# A records
@ -> [VPS-IP] (proxied)
www -> [VPS-IP] (proxied)

# If using subdomains
app -> [VPS-IP] (proxied)
api -> [VPS-IP] (proxied)
```

### SSL Certificates
- Coolify handles SSL via Let's Encrypt (automatic)
- Cloudflare SSL mode: Full (strict)
- Force HTTPS redirect enabled
- HSTS header configured (from eo-security-hardener)

### Subdomain Routing
- `app.domain.com` -> Main application
- `api.domain.com` -> API (if separated)
- Wildcard `*.domain.com` for multi-tenant subdomains (if needed)

---

## CI/CD Pipeline

### GitHub Actions Workflow
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

### Pipeline Stages
1. **Lint**: ESLint + Prettier check
2. **Type Check**: `tsc --noEmit`
3. **Test**: Run test suite
4. **Build**: Production build
5. **Deploy**: Trigger Coolify webhook (only on main branch, only if tests pass)

### Rollback Strategy
- Coolify maintains previous deployments
- One-click rollback in Coolify dashboard
- Document: "If deployment breaks, click Rollback in Coolify -> Deployments"

---

## Monitoring and Alerting

### Uptime Monitoring (Uptime Kuma)
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

### Product Analytics (PostHog)
- Self-hosted PostHog or PostHog Cloud free tier
- Track: page views, feature usage, user journeys, errors
- Key events to track from Day 1: Signup completed, First meaningful action, Subscription started, Subscription cancelled

### Error Tracking
- Sentry free tier for error tracking
- Source maps uploaded during build
- Alert on new errors and error rate spikes

### Resource Monitoring
- VPS CPU, memory, disk usage
- Docker container health
- Database connection pool status
- Alert thresholds: CPU > 80%, Memory > 85%, Disk > 90%

---

## Output File Templates

### deployment-guide.md
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
