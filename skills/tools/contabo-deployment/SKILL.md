---
name: contabo-deployment
description: Contabo VPS Deployment — nginx reverse proxy, pm2 process management, SSL certificates, health checks, and rollback procedures for SMOrchestra infrastructure
category: tools
triggers:
  - deploy
  - contabo
  - nginx
  - pm2
  - SSL
  - server
  - VPS
  - production
  - go live
---

# Contabo Deployment Skill

You manage SMOrchestra's Contabo VPS infrastructure. All deployments use Contabo + nginx + pm2. No Vercel, no AWS, no Coolify.

## Infrastructure

| Server | Hostname | Purpose |
|--------|----------|---------|
| smo-brain | vmi3051702 | Gateway, OpenClaw, skills registry |
| smo-dev | vmi3071952 | Development, staging |

## MCP Tools Available
Use the Contabo MCP (prefix `mcp__contabo-server`) and SSH Manager MCP (prefix `mcp__ssh-manager`) for operations.

### Contabo MCP:
- `contabo_list_instances` — View all servers
- `contabo_get_instance` — Server details
- `contabo_restart_instance` — Restart server (MAMOUN-REQUIRED)
- `contabo_create_snapshot` — Snapshot before changes

### SSH Manager MCP:
- `ssh_execute` — Run commands on remote servers
- `ssh_deploy` — Deploy applications
- `ssh_health_check` — Check server health
- `ssh_service_status` — Check service status
- `ssh_tail` — View logs
- `ssh_upload` / `ssh_download` — Transfer files

## Safety Rules

### MAMOUN-REQUIRED (always ask first):
- Server restarts or shutdowns
- nginx configuration changes on production
- SSL certificate operations
- DNS changes (GoDaddy)
- New domain setup
- Deleting any server resource

### CLAUDE-AUTO (safe to run):
- Health checks and status monitoring
- Log viewing
- pm2 status and logs
- Read-only server inspection
- Creating snapshots (backup)

## Deployment Checklist

### Pre-Deploy
```
[ ] Code tested locally
[ ] All tests pass
[ ] git tag created
[ ] Snapshot created on Contabo
[ ] Current pm2 process noted
```

### Deploy Steps
```bash
# 1. SSH into server
ssh root@SERVER

# 2. Pull latest code
cd /path/to/app && git pull origin dev

# 3. Install dependencies
npm ci --production

# 4. Build if needed
npm run build

# 5. Restart with pm2
pm2 restart APP_NAME

# 6. Verify health
pm2 status
curl -s http://localhost:PORT/health
```

### Post-Deploy
```
[ ] pm2 shows 'online' status
[ ] Health endpoint responds 200
[ ] No errors in pm2 logs (pm2 logs APP --lines 50)
[ ] SSL certificate valid (curl -vI https://domain.com)
```

### Rollback
```bash
# If deploy fails:
git checkout PREVIOUS_TAG
npm ci --production
npm run build
pm2 restart APP_NAME

# If server is unresponsive:
# Use Contabo MCP to revert to snapshot
```

## nginx Configuration

### Standard reverse proxy template:
```nginx
server {
    listen 80;
    server_name domain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name domain.com;

    ssl_certificate /etc/letsencrypt/live/domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### SSL with Let's Encrypt:
```bash
certbot --nginx -d domain.com -d www.domain.com
```

## pm2 Management

```bash
pm2 start ecosystem.config.js    # Start from config
pm2 restart APP_NAME              # Restart
pm2 stop APP_NAME                 # Stop
pm2 delete APP_NAME               # Remove
pm2 logs APP_NAME --lines 100    # View logs
pm2 monit                        # Real-time monitoring
pm2 save                         # Save process list
pm2 startup                      # Auto-start on boot
```

### ecosystem.config.js template:
```javascript
module.exports = {
  apps: [{
    name: 'app-name',
    script: 'server.js',
    instances: 1,
    exec_mode: 'fork',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '/var/log/pm2/app-error.log',
    out_file: '/var/log/pm2/app-out.log',
    max_memory_restart: '500M'
  }]
};
```

## Domain Setup (GoDaddy)

1. Add A record: `domain.com` → server IP
2. Add CNAME: `www.domain.com` → `domain.com`
3. Wait for DNS propagation (5-30 min)
4. Run certbot for SSL
5. Configure nginx reverse proxy
6. Test: `curl -I https://domain.com`
