# OpenClaw Multi-Node Setup — Execution Results Log

**Executed by:** Mamoun Alamouri + Claude Code
**Date:** 2026-03-16
**Status:** Steps 1–11 Complete | Step 12 (n8n federation) Deferred by design

---

## Final Architecture State

```
Desktop (macOS)                     Personal Server (Contabo)              SMO Dev Server (Contabo)
┌──────────────────┐                ┌──────────────────────┐               ┌──────────────────────┐
│  smo-desktop     │                │  smo-brain           │               │  smo-dev             │
│  100.100.239.103 │◄──Tailscale──►│  100.89.148.62       │◄──Tailscale──►│  100.117.35.19       │
│                  │    mesh        │                      │    mesh       │                      │
│  OpenClaw Agent  │    (WSS)      │  OpenClaw Gateway    │    (WSS)      │  OpenClaw Agent      │
│  v2026.3.13      │               │  v2026.3.14          │               │  v2026.3.13          │
│  LaunchAgent     │               │  Port 18789 (loop)   │               │  systemd service     │
│                  │               │  Tailscale Serve →   │               │  (openclaw-node)     │
│  Claude Code     │               │  https://smo-brain.  │               │                      │
│  (Account A)     │               │  tail0c4e56.ts.net/  │               │  Claude Code         │
│                  │               │                      │               │  (Account B)         │
│  Node v22.22.0   │               │  n8n (Instance 1)    │               │  n8n (Instance 2)    │
└──────────────────┘               │  Health cron active  │               │  Node v22.22.0       │
                                   └──────────────────────┘               └──────────────────────┘
     ▲                                       ▲                                      ▲
     └──────────── All push to github.com/SMOrchestra-ai/* via SSH (smorchestraai-code) ─┘
```

---

## Summary Scorecard

| Check | Status | Detail |
|-------|--------|--------|
| Tailscale mesh (3 nodes) | ✅ | smo-brain, smo-dev, smo-desktop all connected |
| OpenClaw gateway running | ✅ | v2026.3.14, port 18789, loopback + Tailscale Serve |
| OpenClaw agent: smo-dev | ✅ | Paired + connected, systemd service |
| OpenClaw agent: smo-desktop | ✅ | Paired + connected, LaunchAgent service |
| Git auth: smo-brain → all repos | ✅ | SSH as smorchestraai-code, 5/5 repos |
| Git auth: smo-dev → all repos | ✅ | SSH as smorchestraai-code, 5/5 repos |
| Health monitoring: smo-brain | ✅ | Cron every 15 min, log rotation |
| Node-down alerting | ✅ | Cron every 5 min, logs warnings |
| Node.js ≥ 18 on all nodes | ✅ | v22.22.0 everywhere |
| n8n federation | ⏳ | Step 12 — pending |

---

## Step-by-Step Results

### STEP 1 — Tailscale on Personal Server (smo-brain)
**Machine:** PERSONAL (Contabo VPS)
**Phase:** A — Networking
**Status:** ✅ Complete

**Results:**
- OS: Ubuntu Linux on Contabo VPS
- Tailscale installed and authenticated
- Hostname set: `smo-brain`
- Tailscale IPv4: `100.89.148.62`
- Public IP: `89.117.62.131`
- Status: Connected to tailnet `smorchestra.ai@`

---

### STEP 2 — Tailscale on SMO Dev Server (smo-dev)
**Machine:** SMO-DEV (Contabo VPS)
**Phase:** A — Networking
**Status:** ✅ Complete

**Results:**
- OS: Ubuntu Linux on Contabo VPS
- Tailscale installed and authenticated (same tailnet as smo-brain)
- Hostname set: `smo-dev`
- Tailscale IPv4: `100.117.35.19`
- Ping to smo-brain: OK

---

### STEP 3 — Tailscale on Desktop (smo-desktop)
**Machine:** DESKTOP (macOS)
**Phase:** A — Networking
**Status:** ✅ Complete

**Results:**
- OS: macOS 14.5 (arm64)
- Tailscale installed via Mac App Store (not Homebrew — Homebrew version required sudo for service start)
- Hostname set: `smo-desktop`
- Tailscale IPv4: `100.100.239.103`
- Ping to smo-brain: OK
- Ping to smo-dev: OK

**Lesson learned:** On macOS, install Tailscale from the App Store, not via `brew install tailscale`. The Homebrew version requires `sudo` for the background service which causes permission issues.

---

### STEP 4 — Full Mesh Connectivity Validation
**Machine:** PERSONAL (smo-brain)
**Phase:** A — Networking
**Status:** ✅ Complete

**Connectivity Matrix:**

| From → To | Ping | SSH |
|-----------|------|-----|
| smo-brain → smo-dev | ✅ OK | ✅ OK (root@smo-dev) |
| smo-brain → smo-desktop | ✅ OK | N/A (desktop) |
| smo-dev → smo-brain | ✅ OK | ✅ OK |
| smo-desktop → smo-brain | ✅ OK | N/A |
| smo-desktop → smo-dev | ✅ OK | N/A |

**Tailscale Status Output:**
```
smo-brain       100.89.148.62    linux   -
smo-dev         100.117.35.19    linux   -
smo-desktop     100.100.239.103  macOS   -
```

**Phase A: COMPLETE** — All three nodes on same tailnet, full mesh connectivity verified.

---

### STEP 5 — Git Auth on Personal Server (smo-brain)
**Machine:** PERSONAL (smo-brain)
**Phase:** E — Git Auth
**Status:** ✅ Complete

**Results:**
- SSH key exists, resolves to: `smorchestraai-code`
- `ssh -T git@github.com` → "Hi smorchestraai-code!"
- Repo access test (5/5 pass):

| Repo | Access |
|------|--------|
| eo-assessment-system | ✅ OK |
| EO-Build | ✅ OK |
| SaaSFast | ✅ OK |
| ScrapMfast | ✅ OK |
| ship-fast | ✅ OK |

- Node.js: v22.22.0
- npm: installed

---

### STEP 6 — Git Auth on SMO Dev Server (smo-dev)
**Machine:** SMO-DEV (smo-dev)
**Phase:** E — Git Auth
**Status:** ✅ Complete

**Results:**
- SSH key exists, resolves to: `smorchestraai-code`
- `ssh -T git@github.com` → "Hi smorchestraai-code!"
- Repo access test (5/5 pass):

| Repo | Access |
|------|--------|
| eo-assessment-system | ✅ OK |
| EO-Build | ✅ OK |
| SaaSFast | ✅ OK |
| ScrapMfast | ✅ OK |
| ship-fast | ✅ OK |

- Node.js: v22.22.0
- npm: installed

**Phase E: COMPLETE** — Both servers authenticated to all SMOrchestra-ai repos via SSH.

---

### STEP 7 — OpenClaw Gateway Discovery (smo-brain)
**Machine:** PERSONAL (smo-brain)
**Phase:** B — OpenClaw
**Status:** ✅ Complete

**Discovery Results:**
| Setting | Value |
|---------|-------|
| OpenClaw version | v2026.3.14 |
| Install method | npm (global) |
| Config file | `~/.openclaw/openclaw.json` |
| Config format | JSON |
| Gateway port | 18789 |
| Gateway bind | loopback (127.0.0.1) |
| Gateway auth | Token-based |
| Auth token location | `~/.openclaw/openclaw.json` → `gateway.authToken` |
| Tailscale Serve | Active → proxies `https://smo-brain.tail0c4e56.ts.net/` to `127.0.0.1:18789` |

**Architecture decision:** Gateway binds to loopback only. Tailscale Serve handles external exposure securely. This is the recommended OpenClaw + Tailscale pattern.

---

### STEP 8 — OpenClaw Agent on SMO Dev Server (smo-dev)
**Machine:** SMO-DEV (smo-dev)
**Phase:** B — OpenClaw
**Status:** ✅ Complete

**Results:**
- OpenClaw installed via npm, updated to v2026.3.13
- Configured as remote node connecting to gateway at `wss://smo-brain.tail0c4e56.ts.net/`
- Pairing completed (required manual intervention — see lessons learned)
- Running as systemd service: `openclaw-node`
- Capabilities reported: browser, system

**Lessons Learned (Critical — save for future reference):**

1. **Pairing flow:** `openclaw node pair` sends a request → gateway stores it in `~/.openclaw/devices/pending.json` → approve with `openclaw nodes approve <requestId>`. But the CLI can't list pending requests when gateway uses Tailscale Serve proxy — must check `pending.json` on disk.

2. **Manual pairing workaround:** When `openclaw nodes pending` fails through Tailscale Serve proxy:
   - On gateway (smo-brain): `cat ~/.openclaw/devices/pending.json`
   - Copy the pending entry into `~/.openclaw/devices/paired.json`
   - Remove from `pending.json`
   - Restart gateway: `openclaw gateway restart`

3. **Trusted proxies required:** When using Tailscale Serve, the gateway MUST have `gateway.trustedProxies: ["127.0.0.1"]` set in `openclaw.json`. Without this, proxy headers from Tailscale Serve are rejected and pairing requests silently fail.

4. **Bind setting:** `gateway.bind: loopback` + Tailscale Serve proxying to `127.0.0.1:18789` is the correct combination. Setting `gateway.bind: tailnet` breaks local CLI access (the gateway listens on Tailscale IP only, and local commands can't reach it).

5. **502 errors from Tailscale Serve:** If Tailscale Serve is proxying to `127.0.0.1:18789` but gateway is bound to Tailscale IP → 502. Fix: ensure both match (loopback bind + loopback proxy).

---

### STEP 9 — OpenClaw Agent on Desktop (smo-desktop)
**Machine:** DESKTOP (macOS)
**Phase:** B — OpenClaw
**Status:** ✅ Complete

**Results:**
- OpenClaw v2026.3.13 (updated from v2026.3.11 during setup)
- Already paired to gateway (appeared in nodes list as "mamouns-macbook-pro" / "Mamoun-Mac")
- Initial issue: node service crashed in a loop — log only showed PATH lines, no gateway connection
- Root cause: default `openclaw node install` set `--host 127.0.0.1 --port 18790` (local gateway), not the remote WSS URL

**Fix applied:**
```bash
# Foreground test (confirmed connection works):
openclaw node run --host smo-brain.tail0c4e56.ts.net --port 443 --tls

# Permanent install with correct params:
openclaw node uninstall
openclaw node install --host smo-brain.tail0c4e56.ts.net --port 443 --tls
```

**Final state:**
- LaunchAgent installed: `/Users/mamounalamouri/Library/LaunchAgents/ai.openclaw.node.plist`
- Command: `openclaw node run --host smo-brain.tail0c4e56.ts.net --port 443 --tls`
- Logs: `~/.openclaw/logs/node.log`
- Runtime: running, survives reboots
- Capabilities: browser, system

**Lesson learned:** When connecting a desktop node to a remote gateway via Tailscale Serve, `openclaw node install` defaults to localhost. You must explicitly pass `--host <gateway-tailscale-hostname> --port 443 --tls` to connect through the Tailscale Serve HTTPS proxy.

---

### STEP 10 — Multi-Node Validation
**Machine:** PERSONAL (smo-brain)
**Phase:** B — OpenClaw
**Status:** ✅ Complete

**`openclaw nodes status` from smo-brain:**
```
Known: 3 · Paired: 3 · Connected: 2

┌────────────┬──────────────┬────────────────────┬────────┐
│ Node       │ IP           │ Status             │ Caps   │
├────────────┼──────────────┼────────────────────┼────────┤
│ Mamoun-Mac │ 100.100.239.103 │ paired · connected │ browser, system │
│ smo-dev    │ 100.117.35.19   │ paired · connected │ browser, system │
│ yousef     │ 176.28.150.48   │ paired · disconnected │ — │
└────────────┴──────────────┴────────────────────┴────────┘
```

**Notes:**
- "yousef" is a separate/stale node entry, not part of this architecture. Can be removed later with `openclaw nodes remove`.
- Both target nodes (smo-dev + Mamoun-Mac) connected and reporting capabilities.

**Phase B: COMPLETE** — Gateway + 2 agent nodes operational.

---

### STEP 11 — Health Monitoring (smo-brain)
**Machine:** PERSONAL (smo-brain)
**Phase:** C — Server Management
**Status:** ✅ Complete

**Created:**

| Item | Path | Schedule |
|------|------|----------|
| Health check script | `/root/scripts/health-check.sh` | Every 15 min (cron) |
| Node alert script | `/root/scripts/alert-node-down.sh` | Every 5 min (cron) |
| Health log | `/var/log/smo-health.log` | Auto-rotated (1000 lines) |

**Test results:**
- Health check: OK — gateway running, HTTP 200, 3 Tailscale peers, 72% disk free, 24% memory
- Node alert: WARNING for "yousef" node disconnected (expected — stale entry). smo-dev and Mamoun-Mac connected.

**Phase C: COMPLETE** — Automated monitoring active.

---

### STEP 12 — n8n Federation (Deferred)
**Machine:** PERSONAL (smo-brain)
**Phase:** D — n8n
**Status:** 🔒 Deferred — not needed yet. Trigger when first cross-server workflow is required.

**Strategic Assessment (2026-03-16):**

n8n federation was evaluated and intentionally deferred. Rationale:

1. **No active cross-server workflow needs it.** smo-brain's n8n runs the EO Assessment System (scorecards → Claude API → GoHighLevel) — self-contained. smo-dev's n8n serves SaaSFast/ScrapMfast — also self-contained. No workflow today requires one instance to trigger the other.

2. **OpenClaw already handles distributed execution.** The 3-node gateway/agent mesh dispatches AI agent work across servers. n8n federation would be a redundant coordination layer for agent orchestration.

3. **Two coordination planes serve different purposes:**
   - **OpenClaw** = AI agent orchestration (dispatch Claude Code tasks across nodes)
   - **n8n** = business workflow automation (webhooks, API integrations, CRM updates, scheduled jobs)
   - Federation becomes important when a *business workflow* on one server needs to trigger a *business workflow* on another — not when an AI agent needs to run remotely.

4. **Infrastructure is ready.** Tailscale mesh is active, both n8n instances are up, security model is clean (loopback + Tailscale only). When federation is needed, it's a 20-minute job.

**Trigger conditions — implement federation when any of these happen:**

| Trigger | Use Case |
|---------|----------|
| ScrapMfast detects a buying signal on smo-dev | → Fire webhook to smo-brain's n8n → Create GHL contact → Start nurture sequence |
| SaaSFast deploys a new feature on smo-dev | → Notify smo-brain's n8n → Update status dashboard → Send Telegram alert |
| EO Assessment completes on smo-brain | → Trigger enrichment workflow on smo-dev (Apify scrape, Clay enrichment) |
| Centralized monitoring needed | → smo-brain polls both n8n instances for workflow execution health |

**When ready to implement, use this prompt on smo-brain:**

```
Set up n8n federation between two n8n instances over Tailscale.

CONTEXT:
- smo-brain (this server): n8n Instance 1 at http://localhost:5678
- smo-dev: n8n Instance 2 at http://smo-dev:5678 (via Tailscale)
- Tailscale mesh active, SSH works between servers
- Security: n8n must stay bound to loopback. Use Tailscale for cross-server access.

EXECUTE:

1. Verify local n8n:
   - curl -s http://localhost:5678/healthz
   - If not on 5678, find it: ss -tlnp | grep -E "5678|n8n"

2. Verify remote n8n over Tailscale:
   - curl -s http://smo-dev:5678/healthz
   - If fails: ssh root@smo-dev "curl -s http://localhost:5678/healthz"
   - If local works but Tailscale doesn't: n8n is bound to localhost only

3. SECURITY CHECK on smo-dev:
   - ssh root@smo-dev "ss -tlnp | grep 5678"
   - If bound to 0.0.0.0:5678 → WARNING: n8n exposed to public internet
   - Must be restricted to 127.0.0.1 or Tailscale IP only
   - If exposed: STOP and report. Fix binding before proceeding.

4. If n8n on smo-dev is bound to localhost only (correct):
   - Option A: Update N8N_HOST on smo-dev to also listen on Tailscale IP (100.117.35.19)
   - Option B: Use Tailscale Serve on smo-dev to proxy to localhost:5678
   - STOP and show me options before changing anything.

5. Once smo-dev n8n is reachable via Tailscale:
   - Test: curl -X POST http://smo-dev:5678/webhook-test/ping -H "Content-Type: application/json" -d '{"test": true}'
   - If 404: need to create test workflow in smo-dev n8n UI first (manual step)

6. Security best practices:
   - Shared webhook secret in X-Webhook-Secret header
   - Store secret in n8n credentials (not hardcoded in workflows)
   - Enable retry on error in HTTP Request nodes (3 retries)

7. Report:
   - Local n8n: status, port
   - Remote n8n: reachable via Tailscale? yes/no
   - Security: n8n exposed publicly? yes/no
   - Action needed in n8n UI

STOP after reporting.
```

---

## Configuration Reference

### smo-brain (Gateway)

| Setting | Value |
|---------|-------|
| Tailscale IP | 100.89.148.62 |
| Public IP | 89.117.62.131 |
| Tailscale hostname | smo-brain |
| OpenClaw version | v2026.3.14 |
| Gateway port | 18789 |
| Gateway bind | loopback |
| Tailscale Serve URL | `https://smo-brain.tail0c4e56.ts.net/` |
| Config file | `~/.openclaw/openclaw.json` |
| Trusted proxies | `["127.0.0.1"]` |
| Auth method | Token |
| Health check cron | Every 15 min |
| Node alert cron | Every 5 min |
| OS | Ubuntu Linux |
| Node.js | v22.22.0 |

### smo-dev (Agent Node)

| Setting | Value |
|---------|-------|
| Tailscale IP | 100.117.35.19 |
| Tailscale hostname | smo-dev |
| OpenClaw version | v2026.3.13 |
| Gateway connection | `wss://smo-brain.tail0c4e56.ts.net/` |
| Service | systemd (`openclaw-node`) |
| Config file | `~/.openclaw/openclaw.json` |
| Paired device file | `~/.openclaw/devices/paired.json` |
| Repo affinity | SaaSFast, ScrapMfast |
| Git SSH | smorchestraai-code (5/5 repos) |
| OS | Ubuntu Linux |
| Node.js | v22.22.0 |

### smo-desktop (Agent Node)

| Setting | Value |
|---------|-------|
| Tailscale IP | 100.100.239.103 |
| Tailscale hostname | smo-desktop |
| OpenClaw version | v2026.3.13 |
| Gateway connection | `smo-brain.tail0c4e56.ts.net:443` (TLS) |
| Service | LaunchAgent (`ai.openclaw.node.plist`) |
| LaunchAgent path | `/Users/mamounalamouri/Library/LaunchAgents/ai.openclaw.node.plist` |
| Node run command | `openclaw node run --host smo-brain.tail0c4e56.ts.net --port 443 --tls` |
| Logs | `~/.openclaw/logs/node.log` |
| OS | macOS 14.5 (arm64) |
| Node.js | v22.22.0 |

---

## Key Lessons Learned

### 1. Tailscale Serve + OpenClaw Gateway Pattern
The correct architecture is: gateway binds to `loopback` (127.0.0.1:18789) + Tailscale Serve proxies the HTTPS URL to localhost. Never set `gateway.bind: tailnet` — it breaks local CLI access.

### 2. Trusted Proxies Are Mandatory
When using Tailscale Serve as a reverse proxy, set `gateway.trustedProxies: ["127.0.0.1"]` in `openclaw.json`. Without this, the gateway rejects forwarded headers and pairing requests silently fail.

### 3. Pairing Flow Has CLI Limitations
The `openclaw nodes pending` command can't list pending requests through a Tailscale Serve proxy. Workaround: manually read `~/.openclaw/devices/pending.json`, copy the entry to `paired.json`, clear pending, restart gateway.

### 4. Desktop Node Service Defaults to Localhost
`openclaw node install` on macOS defaults to connecting to a local gateway. For remote gateways via Tailscale Serve, you must explicitly specify: `openclaw node install --host <tailscale-hostname> --port 443 --tls`

### 5. macOS Tailscale Installation
Use the App Store version of Tailscale on macOS, not `brew install tailscale`. The Homebrew version requires `sudo` for the background service, which causes permission issues.

### 6. Version Consistency Matters
Keep OpenClaw versions aligned across nodes. The gateway (smo-brain) should be the same or newer version than agent nodes. Update with `openclaw update`.

---

## Maintenance Runbook

### Daily Operations
- Health logs auto-generated every 15 min at `/var/log/smo-health.log` on smo-brain
- Node connectivity checked every 5 min
- No manual intervention needed unless alerts fire

### Restarting Services

**smo-brain (gateway):**
```bash
openclaw gateway restart
```

**smo-dev (agent):**
```bash
sudo systemctl restart openclaw-node
```

**smo-desktop (agent):**
```bash
openclaw node restart
```

### Checking Node Status (from smo-brain)
```bash
openclaw nodes status
```

### Adding a New Node
1. Install OpenClaw: `npm i -g openclaw`
2. Run `openclaw onboard`, set gateway mode to `remote`, URL to `wss://smo-brain.tail0c4e56.ts.net/`
3. Run `openclaw node pair` on the new node
4. On smo-brain: check `~/.openclaw/devices/pending.json`, move entry to `paired.json`, restart gateway
5. Install node service: `openclaw node install --host smo-brain.tail0c4e56.ts.net --port 443 --tls`

### Removing a Stale Node
```bash
# From smo-brain
openclaw nodes remove <node-id>
```

### Updating OpenClaw
```bash
# On each node
openclaw update
# Then restart the service
```

---

## GitHub Account Reference

| Item | Value |
|------|-------|
| GitHub Org | SMOrchestra-ai |
| GitHub Account | smorchestraai-code (sole admin) |
| Repos | eo-assessment-system, EO-Build, SaaSFast, ScrapMfast, ship-fast |
| SSH Auth | Both servers + desktop authenticate as smorchestraai-code |
| Former account | alamouri99 — **retired, no longer used** |

---

## What's Next

| Item | Priority | Status | Notes |
|------|----------|--------|-------|
| **n8n Federation** | Low | 🔒 Deferred | Trigger when first cross-server workflow is needed. Prompt saved above. |
| **Cleanup: remove "yousef" node** | Low | Optional | `openclaw nodes remove <id>` on smo-brain |
| **ACL Lockdown** | Medium | Recommended | Tighten Tailscale ACLs: allow only ports 22, 18789, 443, 5678 |
| **Backup configs** | Medium | Recommended | Back up `~/.openclaw/` dirs on all nodes |

## Completion Status

**Multi-node infrastructure: DONE.** Steps 1–11 complete. All mandatory phases (A, B, C, E) operational. Phase D deferred by design — infrastructure is ready, trigger when business workflows require cross-server coordination.
