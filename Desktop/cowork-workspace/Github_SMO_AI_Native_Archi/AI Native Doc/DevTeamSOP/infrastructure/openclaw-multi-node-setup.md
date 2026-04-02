# OpenClaw Multi-Node Architecture: Setup Plan
# For Claude Code execution on servers

## MISSION
Expand OpenClaw from single-server operation into a 3-node distributed architecture:
- **Personal Server (Contabo):** Gateway + Orchestrator + Agent execution + Dev
- **SMO Dev Server (Contabo):** Agent execution + Dev
- **Desktop (macOS):** Agent execution + Dev + Cowork (already configured)

## IDENTITY
You are operating as Mamoun's Infrastructure Execution Agent. You execute server configuration, networking setup, and service deployment commands. You do NOT make architectural decisions. When a decision is needed, you stop and ask Mamoun.

---

## EXECUTION ORDER (Complete GitHub Migration FIRST)

This plan is **Phase 2**. Execute AFTER the GitHub repo migration (CLAUDE.md) is complete.

Why this order matters:
1. GitHub migration consolidates all repos into SMOrchestra-ai org
2. This setup configures agents to work against those consolidated repos
3. Branch protection and team permissions must be in place before agents push code
4. If you run this first, agents will point at old repo locations

After GitHub migration is done, update this file:
- Replace any repo references with final SMOrchestra-ai URLs
- Confirm branch protection is active on all repos
- Confirm SSH keys work from both servers to SMOrchestra-ai

---

## CONFIRMED DETAILS

### Node Inventory

| Node | Provider | Role | Services Running | AI Account |
|------|----------|------|-----------------|------------|
| Personal Server | Contabo VPS | Gateway + Orchestrator + Agent + Dev | OpenClaw, n8n (Instance 1), Claude Code, Codex | Account A |
| SMO Dev Server | Contabo VPS | Agent + Dev | n8n (Instance 2), Claude Code, Claude Agent SDK, Codex | Account B |
| Desktop | macOS (local) | Agent + Dev + Cowork | Claude Code, Codex, Cowork | Account A |

### Repo-to-Server Affinity (Post-Migration)

| Repo | Home Server | Deployed There |
|------|------------|----------------|
| eo-assessment-system | Personal Server | Yes |
| EO-Build | Personal Server | Yes |
| SaaSFast | SMO Dev Server | Yes |
| ScrapMfast | SMO Dev Server | Yes |
| ship-fast | TBD | Boilerplate, assign later |

### Account Matrix

| Tool | Personal Server | SMO Dev Server | Desktop |
|------|----------------|----------------|---------|
| Claude Code | Account A | Account B | Account A |
| Codex | Account A | Account B | Account A |
| n8n | Instance 1 (independent) | Instance 2 (independent) | N/A |
| OpenClaw | Gateway + Agent | Agent node | Agent node |
| GitHub SSH | Key mapped to smorchestraai-code or alamouri99 (both need SMOrchestra-ai access) | Key mapped to account with SMOrchestra-ai access | Key mapped to smorchestraai-code or alamouri99 |
| Tailscale | Same Tailnet | Same Tailnet | Same Tailnet |

### Network Topology

```
Desktop (macOS)                     Personal Server (Contabo)              SMO Dev Server (Contabo)
┌──────────────┐                    ┌──────────────────────┐               ┌──────────────────────┐
│  OpenClaw    │◄──Tailscale───────►│  OpenClaw Gateway    │◄──Tailscale──►│  OpenClaw Agent      │
│  Agent Node  │    mesh            │  + Agent Node        │    mesh       │  Node                │
│              │                    │  + n8n (master)      │               │  + n8n (worker)      │
│  Claude Code │                    │  Claude Code         │               │  Claude Code         │
│  (Account A) │                    │  (Account A)         │               │  (Account B)         │
└──────────────┘                    └──────────────────────┘               └──────────────────────┘
     ▲                                       ▲                                      ▲
     │                                       │                                      │
     └──────── All push to github.com/SMOrchestra-ai/* via SSH ────────────────────┘
```

---

## PHASE A: NETWORKING (Tailscale Mesh)
### Do this first. Everything depends on connectivity.

### A0: Pre-Check - Current Network State
```bash
# Run on EACH server separately

echo "=== $(hostname) ==="
echo "--- Public IP ---"
curl -s ifconfig.me
echo ""

echo "--- OS ---"
cat /etc/os-release | head -3

echo "--- Existing VPN/Tunnel ---"
ip link show | grep -E "wg|tun|tailscale" || echo "No VPN interfaces found"

echo "--- Open Ports (listening) ---"
ss -tlnp | head -20

echo "--- Firewall ---"
ufw status 2>/dev/null || iptables -L -n 2>/dev/null | head -10
```

### A1: Install Tailscale on Personal Server
```bash
# Tailscale install (Debian/Ubuntu)
curl -fsSL https://tailscale.com/install.sh | sh

# Start and authenticate
sudo tailscale up

# This will print a URL. Open it in browser, authenticate with Mamoun's account.
# IMPORTANT: Use the same Tailscale account for ALL three nodes.

# Verify
tailscale status
tailscale ip -4  # Note this IP: will be the gateway address
```

### A2: Install Tailscale on SMO Dev Server
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Authenticate with SAME Tailscale account as Personal Server
tailscale status
tailscale ip -4  # Note this IP
```

### A3: Verify Desktop Tailscale
```bash
# Desktop should already have Tailscale (setup is complete per Mamoun)
tailscale status

# If not installed:
# macOS: brew install tailscale OR download from https://tailscale.com/download/mac
# Authenticate with SAME account
```

### A4: Verify Mesh Connectivity
```bash
# From Personal Server:
echo "=== Tailscale Network ==="
tailscale status

# Ping SMO Dev Server (use Tailscale IP from A2)
ping -c 3 <SMO_DEV_TAILSCALE_IP>

# Ping Desktop (use Tailscale IP from A3)
ping -c 3 <DESKTOP_TAILSCALE_IP>

# From SMO Dev Server:
ping -c 3 <PERSONAL_TAILSCALE_IP>
ping -c 3 <DESKTOP_TAILSCALE_IP>
```

### A5: Configure Tailscale ACLs (Optional but Recommended)
```bash
# Access Tailscale admin console: https://login.tailscale.com/admin/acls
# Set ACLs to restrict traffic between nodes to only required ports:

# Required ports:
# - 22 (SSH between servers for management)
# - 41230 or custom (OpenClaw gateway API)
# - 5678 (n8n webhook port, if enabling cross-server n8n later)
# - 443 (HTTPS for any web UIs)

# For now, leave default (all traffic allowed between your nodes)
# Tighten later once everything works
```

### A6: Set Hostnames for Readability
```bash
# On Personal Server:
sudo tailscale set --hostname=smo-brain

# On SMO Dev Server:
sudo tailscale set --hostname=smo-dev

# On Desktop:
sudo tailscale set --hostname=smo-desktop

# Verify names appear:
tailscale status
# Should show: smo-brain, smo-dev, smo-desktop
```

### A7: Validate SSH Over Tailscale
```bash
# From Personal Server, SSH to SMO Dev Server via Tailscale IP:
ssh mamoun@<SMO_DEV_TAILSCALE_IP> "echo 'SSH over Tailscale: OK'"

# From SMO Dev Server to Personal Server:
ssh mamoun@<PERSONAL_TAILSCALE_IP> "echo 'SSH over Tailscale: OK'"

# If SSH key auth needed:
# Copy Personal Server's public key to SMO Dev Server's authorized_keys (and vice versa)
ssh-copy-id mamoun@<SMO_DEV_TAILSCALE_IP>
```

---

## PHASE B: OPENCLAW MULTI-NODE SETUP

### B0: Document Current OpenClaw State
```bash
# Run on Personal Server ONLY (where OpenClaw currently runs)

echo "=== OpenClaw Current Config ==="

# Find OpenClaw installation
which openclaw 2>/dev/null || find / -name "openclaw" -type f 2>/dev/null | head -5

# Config location
ls -la ~/.openclaw/ 2>/dev/null || ls -la /etc/openclaw/ 2>/dev/null || echo "Config location unknown"

# Current config
cat ~/.openclaw/config.yaml 2>/dev/null || cat /etc/openclaw/config.yaml 2>/dev/null || echo "No config found - ASK MAMOUN"

# Running processes
ps aux | grep -i openclaw | grep -v grep

# Service status
systemctl status openclaw 2>/dev/null || echo "Not a systemd service"

# Port usage
ss -tlnp | grep openclaw || echo "No port found - check config"

# Version
openclaw --version 2>/dev/null || echo "Version unknown"
```

**STOP HERE if OpenClaw config structure is unknown. Ask Mamoun for:**
1. Where is OpenClaw installed?
2. What config file format does it use?
3. How is it currently started (systemd, docker, manual)?
4. What port does the gateway listen on?

### B1: Configure Gateway on Personal Server
```bash
# TEMPLATE - adjust paths and config format based on B0 findings

# Backup current config
cp ~/.openclaw/config.yaml ~/.openclaw/config.yaml.backup.$(date +%Y%m%d)

# Update config to enable gateway mode
# The gateway must:
# 1. Listen on Tailscale IP (not 0.0.0.0 - restrict to mesh network)
# 2. Accept agent registrations
# 3. Define task routing rules

# Example config structure (VERIFY against actual OpenClaw docs):
cat > ~/.openclaw/config.yaml << 'EOF'
gateway:
  enabled: true
  listen: "0.0.0.0:41230"  # Will restrict via Tailscale ACLs
  auth:
    type: token
    token: "${OPENCLAW_GATEWAY_TOKEN}"  # Generate: openssl rand -hex 32

agents:
  local:
    enabled: true
    repos:
      - SMOrchestra-ai/eo-assessment-system
      - SMOrchestra-ai/EO-Build

routing:
  default: local
  rules:
    - repo: "SMOrchestra-ai/SaaSFast"
      target: smo-dev
    - repo: "SMOrchestra-ai/ScrapMfast"
      target: smo-dev
EOF

# Generate gateway auth token
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "GATEWAY TOKEN (save this - needed for agent nodes): $OPENCLAW_GATEWAY_TOKEN"
echo "OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> ~/.openclaw/.env

# Restart OpenClaw
systemctl restart openclaw 2>/dev/null || openclaw restart

# Verify gateway is listening
ss -tlnp | grep 41230
curl -s http://localhost:41230/health || echo "Health endpoint not available - check docs"
```

### B2: Install OpenClaw Agent on SMO Dev Server
```bash
# SSH to SMO Dev Server (use Tailscale)
ssh mamoun@smo-dev

# Check if OpenClaw is already installed
which openclaw 2>/dev/null && openclaw --version

# If not installed, install it (method depends on OpenClaw distribution):
# Option 1: Package manager
# Option 2: Binary download
# Option 3: Docker
# ASK MAMOUN for install method if not obvious

# Configure as agent node (not gateway)
mkdir -p ~/.openclaw

cat > ~/.openclaw/config.yaml << 'EOF'
agent:
  enabled: true
  name: smo-dev
  gateway:
    url: "http://smo-brain:41230"  # Tailscale hostname
    token: "${OPENCLAW_GATEWAY_TOKEN}"

  repos:
    - SMOrchestra-ai/SaaSFast
    - SMOrchestra-ai/ScrapMfast

  capabilities:
    - code
    - deploy
    - test
EOF

# Set the gateway token (Mamoun provides from B1)
echo "OPENCLAW_GATEWAY_TOKEN=<TOKEN_FROM_B1>" >> ~/.openclaw/.env

# Start agent
openclaw agent start

# Verify registration with gateway
curl -s http://smo-brain:41230/agents || echo "Check gateway API docs"
```

### B3: Configure Desktop Agent
```bash
# Desktop setup is "complete" per Mamoun
# Verify it can reach the gateway

# Test connectivity to gateway
curl -s http://smo-brain:41230/health

# If desktop OpenClaw needs gateway config:
# Edit ~/.openclaw/config.yaml and add gateway URL + token
# Same pattern as B2 but with name: smo-desktop
```

### B4: Test Task Dispatch
```bash
# From Personal Server (gateway):

# List registered agents
openclaw agents list 2>/dev/null || curl -s http://localhost:41230/agents

# Expected: smo-brain (local), smo-dev, smo-desktop

# Test dispatch to each node:
# Local (personal server)
openclaw task run --target local --command "echo 'Local agent: OK'" 2>/dev/null

# SMO Dev Server
openclaw task run --target smo-dev --command "echo 'SMO Dev agent: OK'" 2>/dev/null

# Desktop
openclaw task run --target smo-desktop --command "echo 'Desktop agent: OK'" 2>/dev/null
```

**NOTE:** The exact commands above depend on OpenClaw's CLI API. Adjust based on actual OpenClaw documentation. The pattern is: gateway dispatches, agent executes, result returns.

---

## PHASE C: SERVER MANAGEMENT AGENT

### C1: Define Management Scope
The server management agent on Personal Server monitors and manages BOTH servers.

**What "manage" means:**
- Health monitoring: CPU, memory, disk, process status
- Service management: restart n8n, restart apps, restart OpenClaw agents
- Log access: tail logs, search for errors
- Deployment: pull latest code, rebuild, restart
- Backup: trigger backup scripts
- Alert: notify Mamoun via n8n webhook if something fails

### C2: Create Management Agent Profile
```bash
# On Personal Server

mkdir -p ~/.openclaw/agents/server-manager

cat > ~/.openclaw/agents/server-manager/config.yaml << 'EOF'
name: server-manager
description: "Manages both Contabo servers: health checks, deployments, restarts"
type: management

access:
  local:
    ssh: false  # Direct access, no SSH needed
    sudo: true
  smo-dev:
    ssh: true
    host: smo-dev  # Tailscale hostname
    user: mamoun
    sudo: true

schedules:
  health-check:
    cron: "*/15 * * * *"  # Every 15 minutes
    targets: [local, smo-dev]

  disk-check:
    cron: "0 */6 * * *"  # Every 6 hours
    targets: [local, smo-dev]
    threshold: 85  # Alert if disk > 85%

alerts:
  webhook: "http://localhost:5678/webhook/server-alerts"  # n8n webhook
EOF
```

### C3: Health Check Script
```bash
# Create reusable health check that works on both servers

cat > ~/.openclaw/agents/server-manager/health-check.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

echo "=== Health Check: $(hostname) at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="

# System resources
echo "--- CPU ---"
uptime | awk '{print $NF}' # 15-min load average
nproc

echo "--- Memory ---"
free -h | grep Mem | awk '{printf "Used: %s / Total: %s (%.0f%%)\n", $3, $2, $3/$2*100}'

echo "--- Disk ---"
df -h / | tail -1 | awk '{printf "Used: %s / Total: %s (%s)\n", $3, $2, $5}'

echo "--- Key Services ---"
for SVC in openclaw n8n; do
  if systemctl is-active --quiet $SVC 2>/dev/null; then
    echo "$SVC: RUNNING"
  elif pgrep -f $SVC > /dev/null 2>&1; then
    echo "$SVC: RUNNING (process)"
  else
    echo "$SVC: DOWN <<<ALERT>>>"
  fi
done

echo "--- Docker Containers (if applicable) ---"
docker ps --format "{{.Names}}: {{.Status}}" 2>/dev/null || echo "Docker not running or not installed"

echo "--- Tailscale ---"
tailscale status --json 2>/dev/null | jq -r '.Self.Online' || echo "Tailscale status unknown"

echo "=== END ==="
SCRIPT

chmod +x ~/.openclaw/agents/server-manager/health-check.sh

# Test locally
bash ~/.openclaw/agents/server-manager/health-check.sh

# Test on SMO Dev Server
ssh mamoun@smo-dev 'bash -s' < ~/.openclaw/agents/server-manager/health-check.sh
```

### C4: Deployment Script Template
```bash
cat > ~/.openclaw/agents/server-manager/deploy.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

REPO=$1
SERVER=$2  # "local" or "smo-dev"

echo "=== Deploy $REPO on $SERVER ==="

if [ "$SERVER" = "local" ]; then
  cd /path/to/$REPO  # MAMOUN: provide actual paths
  git pull origin dev
  # Add build commands per repo
  echo "Deployed $REPO locally"
elif [ "$SERVER" = "smo-dev" ]; then
  ssh mamoun@smo-dev "cd /path/to/$REPO && git pull origin dev"
  # Add remote build commands per repo
  echo "Deployed $REPO on smo-dev"
else
  echo "Unknown server: $SERVER"
  exit 1
fi
SCRIPT

chmod +x ~/.openclaw/agents/server-manager/deploy.sh
```

---

## PHASE D: N8N FEDERATION (Optional - Do When Needed)

Current state: two independent n8n instances. This phase connects them.

### D0: Pre-Check Both n8n Instances
```bash
# Personal Server n8n
echo "=== Personal Server n8n ==="
curl -s http://localhost:5678/healthz || echo "n8n not on port 5678"
# Check n8n version
curl -s http://localhost:5678/api/v1/workflows -H "X-N8N-API-KEY: ${N8N_API_KEY}" | jq '.count' 2>/dev/null || echo "API key needed"

# SMO Dev Server n8n (over Tailscale)
echo "=== SMO Dev Server n8n ==="
ssh mamoun@smo-dev "curl -s http://localhost:5678/healthz" || echo "n8n not accessible on smo-dev"
```

### D1: Expose SMO Dev n8n Webhook Endpoint
```bash
# On SMO Dev Server:
# n8n webhooks are already exposed on port 5678
# With Tailscale, Personal Server can reach them at: http://smo-dev:5678/webhook/<path>

# Test from Personal Server:
curl -s http://smo-dev:5678/healthz
# If this works, n8n federation is trivially possible

# SECURITY: n8n should ONLY be accessible via Tailscale, not public internet
# Verify n8n is NOT exposed publicly:
ssh mamoun@smo-dev "ss -tlnp | grep 5678"
# Should show 127.0.0.1:5678 or the Tailscale IP, NOT 0.0.0.0:5678

# If exposed on 0.0.0.0, restrict:
# Option 1: n8n config (N8N_HOST=127.0.0.1 or Tailscale IP)
# Option 2: Firewall rule (allow 5678 only from Tailscale subnet)
```

### D2: Cross-Server Workflow Pattern
```bash
# On Personal Server n8n, create a workflow that triggers SMO Dev n8n:

# Pattern: Webhook (trigger) > HTTP Request (to smo-dev n8n) > Process Response

# Example: Personal Server detects signal > triggers SaaSFast deployment on SMO Dev
# 1. Personal n8n: Webhook node receives signal
# 2. Personal n8n: HTTP Request node POSTs to http://smo-dev:5678/webhook/deploy-saasfast
# 3. SMO Dev n8n: Webhook node receives, runs deployment workflow
# 4. SMO Dev n8n: HTTP Request node POSTs result back to http://smo-brain:5678/webhook/deploy-result

# Authentication between n8n instances:
# Use shared webhook secret in headers: X-Webhook-Secret: <shared-secret>
```

### D3: Test Cross-Server Workflow
```bash
# Create a simple ping-pong test:

# 1. On SMO Dev n8n: Create workflow with Webhook trigger on /webhook/ping
#    Response: {"status": "pong", "from": "smo-dev", "time": "{{$now}}"}

# 2. From Personal Server, test:
curl -X POST http://smo-dev:5678/webhook/ping \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Expected: {"status": "pong", "from": "smo-dev", "time": "2026-03-13T..."}
```

---

## PHASE E: GIT AUTH ACROSS SERVERS

### Two-Account GitHub Context
Mamoun uses two GitHub accounts:
- `smorchestraai-code`: owns SMOrchestra-ai org (destination)
- `alamouri99`: owns MamounSMO org (source repos)

Both accounts (or at minimum, the SSH keys) need access to SMOrchestra-ai repos.
The simplest approach: add `alamouri99` as an admin/member of SMOrchestra-ai, then both accounts can access all repos.

### E1: Verify SSH Keys on Both Servers
```bash
# Personal Server:
echo "=== Personal Server SSH Key ==="
cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "No SSH key found"
ssh -T git@github.com 2>&1
# NOTE: Check which GitHub account this SSH key resolves to (alamouri99 or smorchestraai-code)

# SMO Dev Server:
echo "=== SMO Dev Server SSH Key ==="
ssh mamoun@smo-dev "cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo 'No SSH key'"
ssh mamoun@smo-dev "ssh -T git@github.com 2>&1"
# NOTE: This may resolve to a different GitHub account
```

### E2: Ensure Both Keys Have Access to SMOrchestra-ai Repos
```bash
# Check which account the current gh CLI is authenticated as:
gh api /user --jq '.login'

# List SSH keys on the authenticated account:
gh ssh-key list

# Add keys to whichever account(s) need access:
# If Personal Server key resolves to alamouri99, ensure alamouri99 is a member of SMOrchestra-ai
# If keys need to be added to smorchestraai-code account, authenticate as that account first:
# gh auth login  (authenticate as smorchestraai-code)
gh ssh-key add ~/.ssh/id_ed25519.pub --title "smo-brain (personal server)"

# SMO Dev Server key:
ssh mamoun@smo-dev "cat ~/.ssh/id_ed25519.pub" | gh ssh-key add - --title "smo-dev (SMO dev server)"
```

### E3: Test Git Access to All Repos
```bash
# From Personal Server:
for REPO in eo-assessment-system EO-Build SaaSFast ScrapMfast ship-fast; do
  git ls-remote git@github.com:SMOrchestra-ai/$REPO.git HEAD 2>/dev/null && echo "$REPO: OK" || echo "$REPO: FAIL"
done

# From SMO Dev Server:
ssh mamoun@smo-dev 'for REPO in eo-assessment-system EO-Build SaaSFast ScrapMfast ship-fast; do
  git ls-remote git@github.com:SMOrchestra-ai/$REPO.git HEAD 2>/dev/null && echo "$REPO: OK" || echo "$REPO: FAIL"
done'
```

---

## HARD RULES

1. **Complete GitHub migration (CLAUDE.md) BEFORE starting this plan.** Agents need consolidated repos to point at.
2. **Tailscale first.** No networking = no multi-node. Phase A must complete before B, C, or D.
3. **One phase at a time.** Full validation between each phase.
4. **Never expose n8n or OpenClaw gateway to public internet.** Tailscale mesh only.
5. **Same Tailscale account for all three nodes.** One Tailnet, one mesh.
6. **Stop and ask Mamoun if:** OpenClaw config format is unknown, server paths are needed, firewall rules need changing, any service is down unexpectedly.
7. **Gateway token is sensitive.** Store in .env file, never commit to git.
8. **Test connectivity before configuring services.** Ping works > then SSH works > then service ports work.
9. **Account B on SMO Dev Server stays separate.** Different Claude Code and Codex accounts for billing isolation and audit trail.
10. **Desktop is already configured.** Don't reinstall or reconfigure what works. Only add gateway connection.

---

## WHAT TO REPORT BACK TO MAMOUN

After each phase, provide:
1. Phase completed (A/B/C/D/E)
2. All node IPs (Tailscale)
3. Connectivity test results (pass/fail per node pair)
4. Services running and ports
5. Any config changes made
6. Any issues found
7. Next phase ready (yes/no + blockers)

---

## OPEN ITEMS (Mamoun to provide)

- [ ] Personal Server: actual paths to repo workspaces
- [ ] Personal Server: actual paths to OpenClaw installation and config
- [ ] SMO Dev Server: actual paths to repo workspaces
- [ ] SMO Dev Server: OpenClaw installed? If not, install method preference
- [ ] Both servers: OS version (Ubuntu 22? 24? Debian?)
- [ ] Both servers: current firewall setup (ufw? iptables? none?)
- [ ] Both servers: user account name (mamoun? root? other?)
- [ ] n8n on both servers: how is it running (Docker? npm? systemd?)
- [ ] n8n API keys for both instances
- [ ] Confirm desktop Tailscale is installed and working
- [ ] Server paths for deployed apps (eo-assessment-system, EO-Build, SaaSFast, ScrapMfast)
