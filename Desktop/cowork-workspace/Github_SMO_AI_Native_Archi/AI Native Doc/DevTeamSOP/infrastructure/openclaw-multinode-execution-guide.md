# OpenClaw Multi-Node: Claude Code Execution Guide

## How to Use This Document

This is a **step-by-step playbook**. Each step contains a self-contained prompt you paste into Claude Code on a specific machine. Claude Code will execute it autonomously, stopping only when it needs input from you.

**Execution order matters.** Do not skip ahead. Each step depends on the previous one.

**Pre-requisites:**
- GitHub migration must be **complete**. All repos in `SMOrchestra-ai` org with branch protection active.
- `smorchestraai-code` is the sole GitHub account. `alamouri99` has been retired.

---

## Machine Legend

| Machine | Label Used Below | Where Claude Code Runs |
|---------|-----------------|----------------------|
| Personal Server (Contabo) | **[PERSONAL]** | Claude Code CLI on this server |
| SMO Dev Server (Contabo) | **[SMO-DEV]** | Claude Code CLI on this server |
| Desktop (macOS) | **[DESKTOP]** | Claude Code CLI or Cowork on desktop |

---

## Quick Reference: What Runs Where

| Step | Machine | Phase | What Happens |
|------|---------|-------|-------------|
| 1 | PERSONAL | A — Networking | Install Tailscale, get Tailscale IP |
| 2 | SMO-DEV | A — Networking | Install Tailscale, get Tailscale IP |
| 3 | DESKTOP | A — Networking | Verify Tailscale, get Tailscale IP |
| 4 | PERSONAL | A — Networking | Verify full mesh connectivity |
| 5 | PERSONAL | E — Git Auth | Verify Git/SSH access from Personal Server |
| 6 | SMO-DEV | E — Git Auth | Verify Git/SSH access from SMO Dev Server |
| 7 | PERSONAL | B — OpenClaw | Install & configure OpenClaw gateway |
| 8 | SMO-DEV | B — OpenClaw | Install & configure OpenClaw agent node |
| 9 | DESKTOP | B — OpenClaw | Connect desktop agent to gateway |
| 10 | PERSONAL | B — OpenClaw | Test multi-agent dispatch across all nodes |
| 11 | PERSONAL | C — Server Mgmt | Set up server management agent |
| 12 | PERSONAL | D — n8n (optional) | n8n federation between servers |

---

## STEP 1: Install Tailscale on Personal Server
**Machine: [PERSONAL]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your personal server:

```
You are setting up Tailscale on this server (Personal Server / smo-brain). This is Phase A, Step 1 of the OpenClaw multi-node setup.

CONTEXT:
- This server is a Contabo VPS running Linux
- This will be the hub/gateway node in a 3-node Tailscale mesh
- The other two nodes: SMO Dev Server (Contabo) and Desktop (macOS)
- After setup, this server's Tailscale hostname should be: smo-brain

EXECUTE IN ORDER:

1. Pre-check: detect OS, check if Tailscale is already installed
   - cat /etc/os-release | head -5
   - which tailscale 2>/dev/null && tailscale --version
   - ip link show | grep -E "wg|tun|tailscale"

2. If Tailscale is NOT installed:
   - curl -fsSL https://tailscale.com/install.sh | sh

3. Start Tailscale:
   - sudo tailscale up
   - This will print an auth URL. STOP and show me the URL so I can authenticate in my browser.
   - IMPORTANT: I need to authenticate with the SAME Tailscale account I will use on all 3 nodes.

4. After I confirm authentication, continue:
   - sudo tailscale set --hostname=smo-brain
   - tailscale status
   - tailscale ip -4

5. Report back:
   - Tailscale hostname
   - Tailscale IPv4 address (I need this for Steps 2 and 4)
   - Status: connected or error

STOP after reporting. Do NOT proceed to other phases.
```

**After this step, note the Tailscale IP: _____________ (you'll need it in Steps 2, 4, 7, 8)**

---

## STEP 2: Install Tailscale on SMO Dev Server
**Machine: [SMO-DEV]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your SMO Dev server:

```
You are setting up Tailscale on this server (SMO Dev Server / smo-dev). This is Phase A, Step 2 of the OpenClaw multi-node setup.

CONTEXT:
- This server is a Contabo VPS running Linux
- This will be an agent node in a 3-node Tailscale mesh
- The gateway node (Personal Server) is already on Tailscale with hostname: smo-brain
- After setup, this server's Tailscale hostname should be: smo-dev

EXECUTE IN ORDER:

1. Pre-check: detect OS, check if Tailscale is already installed
   - cat /etc/os-release | head -5
   - which tailscale 2>/dev/null && tailscale --version
   - ip link show | grep -E "wg|tun|tailscale"

2. If Tailscale is NOT installed:
   - curl -fsSL https://tailscale.com/install.sh | sh

3. Start Tailscale:
   - sudo tailscale up
   - This will print an auth URL. STOP and show me the URL so I can authenticate in my browser.
   - IMPORTANT: I must use the SAME Tailscale account as the Personal Server.

4. After I confirm authentication, continue:
   - sudo tailscale set --hostname=smo-dev
   - tailscale status
   - tailscale ip -4

5. Quick connectivity test to Personal Server:
   - ping -c 3 smo-brain

6. Report back:
   - Tailscale hostname
   - Tailscale IPv4 address
   - Ping to smo-brain: success/fail
   - Status: connected or error

STOP after reporting. Do NOT proceed to other phases.
```

**After this step, note the Tailscale IP: _____________ (you'll need it in Step 4)**

---

## STEP 3: Verify Tailscale on Desktop
**Machine: [DESKTOP]**
**Estimated time: 5 minutes**

Paste this into Claude Code on your desktop:

```
You are verifying Tailscale on this desktop (macOS). This is Phase A, Step 3 of the OpenClaw multi-node setup.

CONTEXT:
- Desktop setup is mostly complete already
- Tailscale should already be installed (if not, install it)
- This desktop joins a 3-node mesh with smo-brain (Personal Server) and smo-dev (SMO Dev Server)
- After verification, this node's Tailscale hostname should be: smo-desktop

EXECUTE IN ORDER:

1. Check Tailscale status:
   - tailscale status
   - tailscale ip -4

2. If Tailscale is NOT installed:
   - echo "Install Tailscale from https://tailscale.com/download/mac or: brew install tailscale"
   - STOP and wait for me to install it manually

3. If installed but not connected:
   - tailscale up
   - Show auth URL if needed

4. Set hostname:
   - sudo tailscale set --hostname=smo-desktop

5. Test connectivity:
   - ping -c 3 smo-brain
   - ping -c 3 smo-dev

6. Report back:
   - Tailscale hostname
   - Tailscale IPv4 address
   - Ping to smo-brain: success/fail
   - Ping to smo-dev: success/fail

STOP after reporting.
```

**After this step, note the Tailscale IP: _____________**

---

## STEP 4: Verify Full Mesh Connectivity + Tighten ACLs
**Machine: [PERSONAL]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your personal server:

```
You are verifying the full Tailscale mesh and recommending ACL lockdown. This is Phase A, Step 4 (final networking validation).

CONTEXT:
- 3 nodes should be on Tailscale: smo-brain (this server), smo-dev, smo-desktop
- All three must be able to reach each other

EXECUTE IN ORDER:

1. Show full Tailscale network:
   - tailscale status

2. Ping all nodes:
   - ping -c 3 smo-dev
   - ping -c 3 smo-desktop

3. Test SSH to SMO Dev Server:
   - Discover the user account on smo-dev:
     ssh root@smo-dev "whoami" 2>/dev/null || ssh mamoun@smo-dev "whoami" 2>/dev/null || echo "SSH user unknown - try common usernames"
   - If SSH works, run: ssh <user>@smo-dev "hostname && uptime"

4. Report: connectivity matrix
   - smo-brain -> smo-dev: ping OK/FAIL, SSH OK/FAIL
   - smo-brain -> smo-desktop: ping OK/FAIL
   - List all Tailscale IPs

5. If any connection fails:
   - Check firewall: sudo ufw status 2>/dev/null || sudo iptables -L -n 2>/dev/null | head -10
   - Check if Tailscale is running: systemctl status tailscaled
   - STOP and report the failure. Do NOT proceed.

6. ACL recommendation:
   - Print the following recommended Tailscale ACL config for me to apply at https://login.tailscale.com/admin/acls:
   - Allow ports: 22 (SSH), 18789 (OpenClaw gateway), 5678 (n8n), 443 (HTTPS)
   - Block all other ports between nodes

If all connectivity passes, Phase A (Networking) is COMPLETE.
STOP after reporting. Do NOT proceed to Phase E.
```

**CHECKPOINT:** All three nodes must ping each other and SSH must work between servers before continuing.

---

## STEP 5: Git Auth Verification — Personal Server
**Machine: [PERSONAL]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your personal server:

```
You are verifying Git/GitHub access from this server to the SMOrchestra-ai org. This is Phase E, Step 1.

CONTEXT:
- GitHub migration is complete. All repos are in SMOrchestra-ai org.
- There is ONE GitHub account: smorchestraai-code (org owner). No other accounts.
- This server needs SSH or HTTPS access to all SMOrchestra-ai repos.
- Repos to test: eo-assessment-system, EO-Build, SaaSFast, ScrapMfast, ship-fast

EXECUTE:

1. Check SSH key:
   - cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "No SSH key found"
   - ssh -T git@github.com 2>&1
   - Note which GitHub account the SSH key resolves to

2. If no SSH key exists, generate one:
   - ssh-keygen -t ed25519 -C "smo-brain-server"
   - cat ~/.ssh/id_ed25519.pub
   - STOP and show me the public key. I need to add it to smorchestraai-code's GitHub account.

3. Check gh CLI auth (if installed):
   - which gh 2>/dev/null && gh auth status
   - which gh 2>/dev/null && gh api /user --jq '.login'

4. Test access to all repos:
   - for REPO in eo-assessment-system EO-Build SaaSFast ScrapMfast ship-fast; do
       git ls-remote git@github.com:SMOrchestra-ai/$REPO.git HEAD 2>/dev/null && echo "$REPO: OK" || echo "$REPO: FAIL"
     done

5. Check Node.js version (needed for OpenClaw in next phase):
   - node --version 2>/dev/null || echo "Node.js NOT installed"
   - npm --version 2>/dev/null || echo "npm NOT installed"

6. If Node.js is not installed or < v18:
   - curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
   - sudo apt-get install -y nodejs
   - node --version && npm --version

7. Report:
   - SSH key: exists/generated, resolves to which GitHub account
   - Repos accessible: X/5, list any failures
   - Node.js version: installed/not installed
   - gh CLI: installed/not installed

STOP after reporting.
```

---

## STEP 6: Git Auth Verification — SMO Dev Server
**Machine: [SMO-DEV]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your SMO Dev server:

```
You are verifying Git/GitHub access from this server to the SMOrchestra-ai org. This is Phase E, Step 2.

CONTEXT:
- GitHub migration is complete. All repos are in SMOrchestra-ai org.
- There is ONE GitHub account: smorchestraai-code (org owner). No other accounts.
- This server primarily handles: SaaSFast and ScrapMfast
- This server also needs access to all repos for flexibility

EXECUTE:

1. Check SSH key:
   - cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "No SSH key found"
   - ssh -T git@github.com 2>&1
   - Note which GitHub account the SSH key resolves to

2. If no SSH key exists, generate one:
   - ssh-keygen -t ed25519 -C "smo-dev-server"
   - cat ~/.ssh/id_ed25519.pub
   - STOP and show me the public key. I need to add it to smorchestraai-code's GitHub account.

3. Test access to all repos:
   - for REPO in eo-assessment-system EO-Build SaaSFast ScrapMfast ship-fast; do
       git ls-remote git@github.com:SMOrchestra-ai/$REPO.git HEAD 2>/dev/null && echo "$REPO: OK" || echo "$REPO: FAIL"
     done

4. Check Node.js version (needed for OpenClaw in next phase):
   - node --version 2>/dev/null || echo "Node.js NOT installed"
   - npm --version 2>/dev/null || echo "npm NOT installed"

5. If Node.js is not installed or < v18:
   - curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
   - sudo apt-get install -y nodejs
   - node --version && npm --version

6. Report:
   - SSH key: exists/generated, resolves to which GitHub account
   - Repos accessible: X/5, list any failures
   - Node.js version: installed/not installed
   - Action needed: key needs adding to GitHub? invite to org?

STOP after reporting.
```

**CHECKPOINT:** Both servers must have SSH access to all SMOrchestra-ai repos and Node.js >= 18 before continuing.

---

## STEP 7: Discover OpenClaw Gateway State on Personal Server
**Machine: [PERSONAL]**
**Estimated time: 5 minutes**

OpenClaw is already installed and running on this server. This step captures the current state so we know what to configure on the other nodes.

Paste this into Claude Code on your personal server:

```
You are documenting the current OpenClaw setup on this server (Personal Server / smo-brain). This is Phase B, Step 1. OpenClaw is already installed and working — do NOT install or modify anything.

CONTEXT:
- OpenClaw is already installed and running on this server
- Tailscale mesh is active: smo-brain, smo-dev, smo-desktop all connected
- GitHub repos are in SMOrchestra-ai org
- Repo affinity: eo-assessment-system and EO-Build run locally; SaaSFast and ScrapMfast route to smo-dev
- We need to capture: version, config, ports, gateway status — so we can configure smo-dev and smo-desktop to connect

DISCOVERY ONLY — do NOT modify anything:

1. Version and install location:
   - which openclaw
   - openclaw --version
   - node --version && npm --version

2. Current config:
   - ls -la ~/.openclaw/
   - cat ~/.openclaw/openclaw.json 2>/dev/null || cat ~/.openclaw/config.yaml 2>/dev/null || echo "Config format unknown — list all files in ~/.openclaw/"

3. Running state:
   - openclaw status
   - openclaw health
   - pgrep -f openclaw
   - ss -tlnp | grep -E "18789|openclaw" || echo "Check which port OpenClaw listens on"

4. Diagnostics:
   - openclaw doctor

5. Gateway accessibility:
   - curl -s http://127.0.0.1:18789 2>/dev/null | head -5 || echo "Not on 18789 — check config for actual port"
   - What address/port is the gateway bound to?
   - Is Tailscale Serve configured? tailscale serve status 2>/dev/null

6. Report — I need these exact values for Steps 8 and 9:
   - OpenClaw version: ___
   - Config file path: ___
   - Config format (JSON5/YAML/other): ___
   - Gateway port: ___
   - Gateway bind address: ___
   - Gateway auth method (token/password/none): ___
   - Auth token/credential location (DO NOT print the actual token): ___
   - Tailscale Serve configured? yes/no
   - Any agents/workspaces currently configured? List them.

STOP after reporting. Do NOT modify any config or restart any services.
```

**After this step, Mamoun notes the gateway port, auth method, and config format — needed for Steps 8 and 9.**

---

## STEP 8: Install & Configure OpenClaw Agent on SMO Dev Server
**Machine: [SMO-DEV]**
**Estimated time: 15-30 minutes**

Paste this into Claude Code on your SMO Dev server:

```
You are configuring OpenClaw as an agent node on this server (SMO Dev Server / smo-dev). This is Phase B, Step 2.

CONTEXT:
- The OpenClaw gateway is running on smo-brain (Personal Server) over Tailscale
- Gateway is accessible at smo-brain:18789 via Tailscale
- This server handles: SMOrchestra-ai/SaaSFast and SMOrchestra-ai/ScrapMfast
- Tailscale is active: this server is smo-dev
- OpenClaw is installed via npm: npm i -g openclaw
- Config file: ~/.openclaw/openclaw.json (JSON5 format)

PHASE 1 - DISCOVERY:

1. Check if OpenClaw is already installed:
   - which openclaw 2>/dev/null
   - openclaw --version 2>/dev/null
   - ls -la ~/.openclaw/ 2>/dev/null
   - cat ~/.openclaw/openclaw.json 2>/dev/null

2. Check connectivity to gateway:
   - curl -s http://smo-brain:18789 2>/dev/null | head -5 || echo "Gateway not reachable on 18789"
   - ping -c 1 smo-brain

3. Check Node.js version:
   - node --version
   - npm --version

STOP HERE. Show me what you found.

I will then tell you:
- Whether to install OpenClaw (npm i -g openclaw)
- The gateway URL (smo-brain:18789)
- Any auth tokens needed

After I provide that info, you will:
- Install OpenClaw if needed: npm i -g openclaw
- Run initial setup: openclaw onboard
- Configure to connect to gateway on smo-brain:18789
- Verify connection: openclaw status && openclaw health
- Run diagnostics: openclaw doctor
```

---

## STEP 9: Connect Desktop Agent to Gateway
**Machine: [DESKTOP]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your desktop:

```
You are connecting this desktop's OpenClaw agent to the central gateway. This is Phase B, Step 3.

CONTEXT:
- Desktop OpenClaw setup may be partially complete
- The gateway runs on smo-brain (Personal Server) over Tailscale
- Gateway accessible at smo-brain:18789 via Tailscale
- This node is: smo-desktop
- OpenClaw is installed via npm: npm i -g openclaw
- Config file: ~/.openclaw/openclaw.json (JSON5 format)

EXECUTE:

1. Check current OpenClaw state:
   - which openclaw 2>/dev/null
   - openclaw --version 2>/dev/null
   - ls -la ~/.openclaw/ 2>/dev/null
   - cat ~/.openclaw/openclaw.json 2>/dev/null

2. Test gateway connectivity:
   - curl -s http://smo-brain:18789 2>/dev/null | head -5 || echo "Gateway not reachable"
   - ping -c 1 smo-brain

3. If OpenClaw is not installed:
   - npm i -g openclaw
   - openclaw onboard

STOP HERE. Show me what you found.

After I confirm:
- Update config to connect to gateway at smo-brain:18789
- Verify: openclaw status && openclaw health
- Run diagnostics: openclaw doctor
```

---

## STEP 10: Test Multi-Agent Dispatch Across All Nodes
**Machine: [PERSONAL]**
**Estimated time: 10 minutes**

Paste this into Claude Code on your personal server:

```
You are testing OpenClaw multi-agent connectivity across all 3 nodes. This is Phase B validation.

CONTEXT:
- Gateway runs on this server (smo-brain) at port 18789
- Agent nodes: smo-dev and smo-desktop should be connected
- Repo routing: eo-assessment-system and EO-Build = local; SaaSFast and ScrapMfast = smo-dev

EXECUTE:

1. Check gateway status:
   - openclaw status
   - openclaw health

2. Verify connected agents:
   - openclaw status should show connected nodes/agents
   - Expected: this gateway + smo-dev agent + smo-desktop agent

3. Run diagnostics:
   - openclaw doctor
   - Check for any warnings or errors

4. Test Control UI:
   - curl -s http://127.0.0.1:18789 | head -10
   - Confirm Control UI is accessible

5. Test Tailscale Serve (if configured):
   - Verify smo-dev can reach gateway: ssh <user>@smo-dev "curl -s http://smo-brain:18789 | head -5"
   - Verify smo-desktop can reach gateway (already tested in Step 9)

6. Report:
   - Gateway status: running/stopped
   - Connected agents: list all
   - Diagnostics: any warnings?
   - Control UI: accessible/not
   - Cross-node connectivity: all nodes can reach gateway? yes/no

If all nodes are connected and gateway is healthy, Phase B (OpenClaw Multi-Node) is COMPLETE.
STOP after reporting.
```

**CHECKPOINT:** All 3 nodes must be connected to the gateway before continuing.

---

## STEP 11: Set Up Server Management Agent
**Machine: [PERSONAL]**
**Estimated time: 20 minutes**

Paste this into Claude Code on your personal server:

```
You are creating a server management agent on this server (smo-brain) that monitors both Contabo servers. This is Phase C.

CONTEXT:
- This server (smo-brain) manages itself and smo-dev over Tailscale
- SSH to smo-dev works over Tailscale
- Management scope: health monitoring, service management, deployment, alerts
- n8n runs on this server (for alert webhooks)
- OpenClaw runs as a Node.js process (not systemd), check with: pgrep -f openclaw or openclaw health

EXECUTE:

1. Discover SSH user for smo-dev:
   - ssh root@smo-dev "whoami" 2>/dev/null && echo "USER=root" || true
   - ssh mamoun@smo-dev "whoami" 2>/dev/null && echo "USER=mamoun" || true
   - Use whichever user works

2. Discover n8n on this server:
   - curl -s http://localhost:5678/healthz 2>/dev/null && echo "n8n on 5678" || echo "n8n not on 5678"
   - ps aux | grep n8n | grep -v grep
   - systemctl status n8n 2>/dev/null || docker ps 2>/dev/null | grep n8n

3. Create management scripts directory:
   - mkdir -p ~/.smo/agents/server-manager

4. Create health check script at ~/.smo/agents/server-manager/health-check.sh:

#!/bin/bash
set -euo pipefail
echo "=== Health Check: $(hostname) at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
echo "--- CPU ---"
uptime
nproc
echo "--- Memory ---"
free -h | grep Mem
echo "--- Disk ---"
df -h / | tail -1
echo "--- Key Services ---"
# Check OpenClaw (Node.js process)
if pgrep -f "openclaw" > /dev/null 2>&1; then
  echo "openclaw: RUNNING"
  openclaw health 2>/dev/null || echo "openclaw health: check manually"
else
  echo "openclaw: DOWN <<<ALERT>>>"
fi
# Check n8n
if systemctl is-active --quiet n8n 2>/dev/null; then
  echo "n8n: RUNNING (systemd)"
elif pgrep -f n8n > /dev/null 2>&1; then
  echo "n8n: RUNNING (process)"
elif docker ps 2>/dev/null | grep -q n8n; then
  echo "n8n: RUNNING (docker)"
else
  echo "n8n: DOWN <<<ALERT>>>"
fi
echo "--- Docker ---"
docker ps --format "{{.Names}}: {{.Status}}" 2>/dev/null || echo "Docker not running"
echo "--- Tailscale ---"
tailscale status --json 2>/dev/null | jq -r '.Self.Online' || echo "Unknown"
echo "=== END ==="

5. Make it executable: chmod +x ~/.smo/agents/server-manager/health-check.sh

6. Test locally:
   - bash ~/.smo/agents/server-manager/health-check.sh

7. Test on smo-dev:
   - ssh <user>@smo-dev 'bash -s' < ~/.smo/agents/server-manager/health-check.sh

8. Create deploy script at ~/.smo/agents/server-manager/deploy.sh:

#!/bin/bash
set -euo pipefail
REPO=$1
SERVER=${2:-local}
BRANCH=${3:-dev}
echo "=== Deploy $REPO on $SERVER (branch: $BRANCH) ==="
if [ "$SERVER" = "local" ]; then
  echo "Finding local workspace for $REPO..."
  FOUND=$(find /home /root /opt -maxdepth 4 -name ".git" -path "*$REPO*" 2>/dev/null | head -1)
  if [ -n "$FOUND" ]; then
    DIR=$(dirname "$FOUND")
    echo "Found: $DIR"
    cd "$DIR" && git pull origin "$BRANCH"
  else
    echo "Workspace not found for $REPO"
    exit 1
  fi
elif [ "$SERVER" = "smo-dev" ]; then
  ssh <user>@smo-dev "cd \$(find /home /root /opt -maxdepth 4 -name '.git' -path '*$REPO*' 2>/dev/null | head -1 | xargs dirname) && git pull origin $BRANCH"
else
  echo "Unknown server: $SERVER"
  exit 1
fi

9. Make executable: chmod +x ~/.smo/agents/server-manager/deploy.sh

10. Set up cron for automated health checks:
    - crontab -l 2>/dev/null > /tmp/cron_backup || true
    - Add to crontab: */15 * * * * /bin/bash ~/.smo/agents/server-manager/health-check.sh >> ~/.smo/agents/server-manager/health.log 2>&1
    - Add to crontab: 0 */6 * * * df -h / | awk 'NR==2{if(int($5)>85) print "DISK ALERT: "$5" used on $(hostname)"}' | curl -s -X POST http://localhost:5678/webhook/server-alerts -H "Content-Type: application/json" -d "{\"alert\": \"$(cat)\"}" 2>/dev/null || true
    - Verify: crontab -l

11. Report:
   - Health check: local results
   - Health check: smo-dev results
   - Deploy script created
   - Cron jobs set up
   - n8n status (for future alert webhook integration)

Phase C is COMPLETE.
STOP after reporting.
```

---

## STEP 12: n8n Federation (Optional, Defer if Not Needed Now)
**Machine: [PERSONAL]**
**Estimated time: 15 minutes**

This step connects the two independent n8n instances so they can trigger each other's workflows over Tailscale. Skip this if you don't need cross-server n8n triggers yet.

Paste this into Claude Code on your personal server:

```
You are setting up n8n federation between two n8n instances. This is Phase D (optional).

CONTEXT:
- Personal Server (smo-brain): runs n8n Instance 1
- SMO Dev Server (smo-dev): runs n8n Instance 2
- Tailscale mesh is active between both servers
- Goal: each n8n can trigger webhooks on the other

EXECUTE:

1. Verify local n8n:
   - curl -s http://localhost:5678/healthz
   - If not on 5678, find it: ss -tlnp | grep -E "5678|n8n"

2. Verify remote n8n over Tailscale:
   - curl -s http://smo-dev:5678/healthz
   - If fails: ssh <user>@smo-dev "curl -s http://localhost:5678/healthz"
   - If that works but direct Tailscale call fails, n8n is bound to localhost only

3. SECURITY CHECK on smo-dev:
   - ssh <user>@smo-dev "ss -tlnp | grep 5678"
   - If bound to 0.0.0.0:5678 -> WARNING: n8n is exposed to public internet
   - Must be restricted to 127.0.0.1 or Tailscale IP only
   - If exposed: STOP and tell me. We need to fix n8n binding before proceeding.

4. If n8n on smo-dev is bound to localhost only (correct):
   - Set up a reverse tunnel or update n8n config to also listen on Tailscale IP
   - The Tailscale IP for smo-dev can be found: ssh <user>@smo-dev "tailscale ip -4"
   - Option A: Update N8N_HOST env var to include Tailscale IP
   - Option B: Use ssh tunnel: not practical for persistent use
   - STOP and show me the current n8n startup config so I can decide

5. Once smo-dev n8n is reachable via Tailscale:
   - Test: curl -X POST http://smo-dev:5678/webhook-test/ping -H "Content-Type: application/json" -d '{"test": true}'
   - If 404, create a test workflow on smo-dev first (manual step in n8n UI)

6. Cross-server webhook best practices:
   - Use shared webhook secret in X-Webhook-Secret header for authentication
   - Store the secret in n8n credentials (not hardcoded in workflow nodes)
   - Enable retry on error in HTTP Request nodes (n8n built-in: Settings > Retry on Fail > 3 retries)
   - Rotate the webhook secret periodically

7. Report:
   - Local n8n: status, port
   - Remote n8n: reachable via Tailscale? yes/no
   - Security: n8n exposed publicly? yes/no
   - Next step: what needs manual configuration in n8n UI

STOP after reporting.
```

---

## POST-SETUP VALIDATION CHECKLIST

Run this final check from your Personal Server after all steps complete:

```
You are running the final validation of the OpenClaw multi-node setup.

Check everything:

1. Tailscale mesh:
   - tailscale status (should show smo-brain, smo-dev, smo-desktop)

2. OpenClaw:
   - Gateway running: openclaw health && openclaw status
   - Diagnostics clean: openclaw doctor
   - Control UI accessible: curl -s http://127.0.0.1:18789 | head -5

3. Git auth:
   - Local: git ls-remote git@github.com:SMOrchestra-ai/eo-assessment-system.git HEAD
   - Remote: ssh <user>@smo-dev "git ls-remote git@github.com:SMOrchestra-ai/SaaSFast.git HEAD"

4. Server management:
   - Run health check locally: bash ~/.smo/agents/server-manager/health-check.sh
   - Run health check on smo-dev: ssh <user>@smo-dev 'bash -s' < ~/.smo/agents/server-manager/health-check.sh
   - Verify cron: crontab -l | grep health-check

5. Summary table:
   | Check | Status |
   |-------|--------|
   | Tailscale mesh (3 nodes) | ? |
   | OpenClaw gateway running | ? |
   | OpenClaw agent: smo-dev connected | ? |
   | OpenClaw agent: smo-desktop connected | ? |
   | Git auth: smo-brain → all repos | ? |
   | Git auth: smo-dev → all repos | ? |
   | Health check: local | ? |
   | Health check: smo-dev | ? |
   | Cron jobs active | ? |
   | Node.js >= 18 on both servers | ? |
```

---

## TROUBLESHOOTING

**Tailscale can't connect:**
- Check firewall: `sudo ufw allow 41641/udp` (Tailscale's port)
- Restart: `sudo systemctl restart tailscaled`
- Re-auth: `sudo tailscale up --reset`

**OpenClaw won't start:**
- Check Node.js: `node --version` (must be >= 18)
- Run diagnostics: `openclaw doctor`
- Check config: `cat ~/.openclaw/openclaw.json` (must be valid JSON5)
- Check port: `ss -tlnp | grep 18789`
- Reinstall: `npm i -g openclaw && openclaw onboard`

**OpenClaw agent won't connect to gateway:**
- Check gateway is running: `curl http://smo-brain:18789` from agent node
- Check Tailscale: `ping smo-brain` from agent node
- Check auth: verify tokens/credentials match between gateway and agent config
- Run diagnostics on both: `openclaw doctor`

**n8n not reachable over Tailscale:**
- n8n is likely bound to 127.0.0.1. Update N8N_HOST to the Tailscale IP or 0.0.0.0 (then firewall public access)
- NEVER expose n8n to public internet. Only Tailscale.

**Git access denied from server:**
- Check which GitHub account the SSH key maps to: `ssh -T git@github.com`
- That account must be `smorchestraai-code` (the only account)
- If key not added: copy public key and add at https://github.com/settings/ssh/new
- Must be logged in as `smorchestraai-code`

---

## HARD RULES

1. **Complete GitHub migration BEFORE starting this plan.** ✅ Done.
2. **Tailscale first.** No networking = no multi-node. Phase A must complete before E, B, C, or D.
3. **Git auth before OpenClaw.** Phase E must complete before Phase B. Agents need repo access.
4. **One phase at a time.** Full validation between each phase.
5. **Never expose n8n or OpenClaw gateway to public internet.** Tailscale mesh only. Keep gateway bound to loopback.
6. **Same Tailscale account for all three nodes.** One Tailnet, one mesh.
7. **Stop and ask Mamoun if:** OpenClaw config is unexpected, server paths are needed, firewall rules need changing, any service is down unexpectedly.
8. **Gateway token is sensitive.** Store in config, never commit to git.
9. **Test connectivity before configuring services.** Ping works → SSH works → service ports work.
10. **Account B on SMO Dev Server stays separate.** Different Anthropic account for billing isolation and audit trail. GitHub access uses smorchestraai-code SSH key on all servers.
11. **Desktop is already partially configured.** Verify config matches new architecture before assuming it works.
12. **Use `openclaw doctor` after every config change.** Built-in diagnostics catch issues early.
