# n8n Federation Plan — Cross-Server Workflow Triggers

**Status:** 🔒 Deferred — implement when first cross-server workflow is needed
**Last reviewed:** 2026-03-16
**Depends on:** Multi-node infrastructure (Steps 1–11) ✅ Complete

---

## What This Is

Connecting two independent n8n instances over the Tailscale mesh so workflows on one server can trigger workflows on the other via webhooks.

| Instance | Server | Tailscale IP | Port | Current Use |
|----------|--------|-------------|------|-------------|
| n8n Instance 1 | smo-brain | 100.89.148.62 | 5678 | EO Assessment System (scorecards → Claude API → GoHighLevel) |
| n8n Instance 2 | smo-dev | 100.117.35.19 | 5678 | SaaSFast / ScrapMfast workflows |

---

## Why It's Deferred

1. **No active cross-server workflow needs it.** Both n8n instances are self-contained today. No workflow on smo-brain needs to trigger anything on smo-dev, or vice versa.

2. **OpenClaw handles distributed AI execution.** The 3-node gateway/agent mesh already dispatches Claude Code tasks across servers. n8n federation would be redundant for agent orchestration.

3. **Two coordination planes, different jobs:**

| Plane | Tool | Purpose |
|-------|------|---------|
| AI agent orchestration | OpenClaw | Dispatch Claude Code tasks across nodes, manage sessions, route to right server |
| Business workflow automation | n8n | Webhooks, API integrations, data transforms, CRM updates, scheduled jobs |

Federation matters when a **business workflow** on one server needs to trigger a **business workflow** on another — not when an AI agent needs to run remotely.

4. **Infrastructure is ready.** Tailscale mesh active, both n8n instances up, security model clean. When needed, this is a 20-minute job.

---

## Trigger Conditions

Implement federation when any of these happen:

| Trigger | What It Enables |
|---------|----------------|
| ScrapMfast detects a buying signal on smo-dev | → Webhook to smo-brain n8n → Create GHL contact → Start nurture sequence |
| SaaSFast deploys a new feature on smo-dev | → Notify smo-brain n8n → Update status dashboard → Send Telegram alert |
| EO Assessment completes on smo-brain | → Trigger enrichment on smo-dev (Apify scrape, Clay enrichment) |
| Centralized monitoring needed | → smo-brain polls both n8n instances for workflow execution health |

---

## Architecture

```
smo-brain (100.89.148.62)              smo-dev (100.117.35.19)
┌──────────────────────┐               ┌──────────────────────┐
│  n8n Instance 1      │               │  n8n Instance 2      │
│  localhost:5678      │               │  localhost:5678      │
│                      │               │                      │
│  EO Assessment       │  Tailscale    │  SaaSFast workflows  │
│  Signal orchestration│◄────mesh─────►│  ScrapMfast workflows│
│  GHL integration     │  (encrypted)  │  Signal detection    │
│                      │               │                      │
│  Webhook OUT:        │               │  Webhook OUT:        │
│  POST smo-dev:5678/  │               │  POST smo-brain:5678/│
│  webhook/<path>      │               │  webhook/<path>      │
└──────────────────────┘               └──────────────────────┘
```

**Security model:** Both n8n instances bind to loopback only. Cross-server access via Tailscale IP or Tailscale Serve. Never exposed to public internet.

---

## Implementation Steps

### Pre-requisites (already done)
- [x] Tailscale mesh active between smo-brain and smo-dev
- [x] SSH works: `ssh root@smo-dev` from smo-brain
- [x] Both n8n instances running
- [x] OpenClaw multi-node operational

### Step 1: Verify n8n on Both Servers

**On smo-brain:**
```bash
curl -s http://localhost:5678/healthz
ss -tlnp | grep 5678
```

**On smo-dev (via SSH):**
```bash
ssh root@smo-dev "curl -s http://localhost:5678/healthz"
ssh root@smo-dev "ss -tlnp | grep 5678"
```

### Step 2: Security Audit

Check n8n binding on both servers:

```bash
# Must show 127.0.0.1:5678, NOT 0.0.0.0:5678
ssh root@smo-dev "ss -tlnp | grep 5678"
```

**If bound to 0.0.0.0** → STOP. n8n is exposed to public internet. Fix:
- Update `N8N_HOST=127.0.0.1` in n8n environment
- Restart n8n
- Verify binding changed

### Step 3: Make n8n Reachable Over Tailscale

n8n binds to localhost by default. Two options to make it reachable from the other server:

**Option A: Tailscale Serve (recommended — matches OpenClaw pattern)**
```bash
# On smo-dev
sudo tailscale serve --bg 5678
```
Then smo-brain calls: `https://smo-dev.tail0c4e56.ts.net:443/webhook/<path>`

**Option B: Bind n8n to Tailscale IP**
```bash
# Update n8n env
N8N_HOST=100.117.35.19
# Restart n8n
```
Then smo-brain calls: `http://100.117.35.19:5678/webhook/<path>`

**Recommendation:** Option A (Tailscale Serve) — TLS encrypted, no public exposure, consistent with OpenClaw architecture.

### Step 4: Create Test Webhook on smo-dev

In smo-dev's n8n UI:
1. Create new workflow: "Federation Ping Test"
2. Add Webhook trigger node: `/webhook/federation-ping`
3. Add Respond to Webhook node: return `{"status": "pong", "server": "smo-dev", "timestamp": "{{$now}}"}`
4. Activate the workflow

### Step 5: Test Cross-Server Call

From smo-brain:
```bash
curl -X POST https://smo-dev.tail0c4e56.ts.net/webhook/federation-ping \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: <shared-secret>" \
  -d '{"test": true, "from": "smo-brain"}'
```

Expected response:
```json
{"status": "pong", "server": "smo-dev", "timestamp": "2026-XX-XXTXX:XX:XXZ"}
```

### Step 6: Set Up Shared Authentication

1. Generate a webhook secret:
```bash
openssl rand -hex 32
```

2. Store in n8n credentials on BOTH instances:
   - Go to n8n UI → Credentials → Add Credential → Header Auth
   - Name: "Federation Webhook Secret"
   - Header Name: `X-Webhook-Secret`
   - Header Value: `<the generated secret>`

3. On receiving workflows: add IF node after Webhook trigger to validate `X-Webhook-Secret` header matches.

### Step 7: Build First Real Federation Workflow

Template for smo-brain → smo-dev trigger:

**Sender (smo-brain n8n):**
```
Webhook/Schedule Trigger → Process Data → HTTP Request node
  URL: https://smo-dev.tail0c4e56.ts.net/webhook/<workflow-path>
  Method: POST
  Headers: X-Webhook-Secret = {{$credentials.federationSecret}}
  Body: JSON payload
  Settings: Retry on Fail = true, Max Retries = 3
```

**Receiver (smo-dev n8n):**
```
Webhook Trigger → Validate Secret (IF node) → Process → Respond
```

---

## Security Rules

1. **Never expose n8n to public internet.** Loopback + Tailscale only.
2. **Always use webhook secret.** Every cross-server call includes `X-Webhook-Secret` header.
3. **Store secrets in n8n credentials**, not hardcoded in workflow nodes.
4. **Enable retry on HTTP Request nodes.** 3 retries with exponential backoff.
5. **Rotate webhook secret quarterly.** Update in both n8n credentials vaults.
6. **Log federation calls.** Add a logging step in receiving workflows for audit trail.

---

## Claude Code Prompt (Ready to Paste)

When you're ready to implement, paste this into Claude Code on smo-brain:

```
Set up n8n federation between two n8n instances over Tailscale.

CONTEXT:
- smo-brain (this server): n8n Instance 1 at http://localhost:5678
- smo-dev: n8n Instance 2 at http://smo-dev:5678 (via Tailscale)
- Tailscale mesh active, SSH works between servers (root@smo-dev)
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
   - Option A: Use Tailscale Serve on smo-dev to proxy to localhost:5678
   - Option B: Update N8N_HOST on smo-dev to also listen on Tailscale IP (100.117.35.19)
   - STOP and show me options before changing anything.

5. Once smo-dev n8n is reachable via Tailscale:
   - Test: curl -X POST http://smo-dev:5678/webhook-test/ping -H "Content-Type: application/json" -d '{"test": true}'
   - If 404: need to create test workflow in smo-dev n8n UI first (manual step)

6. Security best practices:
   - Generate shared secret: openssl rand -hex 32
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

## Reference

| Item | Value |
|------|-------|
| smo-brain Tailscale IP | 100.89.148.62 |
| smo-dev Tailscale IP | 100.117.35.19 |
| Tailscale Serve (smo-brain) | `https://smo-brain.tail0c4e56.ts.net/` |
| n8n port (both) | 5678 |
| SSH user (smo-dev) | root |
| Related doc | `openclaw-multinode-execution-results.md` |
