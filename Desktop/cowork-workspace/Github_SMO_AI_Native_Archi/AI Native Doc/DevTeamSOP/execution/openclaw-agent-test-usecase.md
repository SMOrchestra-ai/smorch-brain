# OpenClaw Agent Setup — Test Use Case

**Date:** 2026-03-29
**Purpose:** Validate OpenClaw ↔ Paperclip integration end-to-end
**Prerequisites:** Paperclip running at localhost:3100, OpenClaw running on smo-brain (100.89.148.62)

---

## Problem Statement

OpenClaw gateway connection to Paperclip failed with `missing scope: operator.write` on gateway token `lkjalijower02349lsk90iiojwrjower900923`. This test use case validates the fix and proves the full dispatch chain works.

---

## Test 1: Fix OpenClaw Gateway Token Scope

### Steps

1. **SSH to smo-brain:**
```bash
ssh root@100.89.148.62
```

2. **Check current OpenClaw gateway config:**
```bash
cat /root/.openclaw/config.yaml | grep -A5 gateway
# Or check the gateway service
systemctl status openclaw-gateway
```

3. **Generate a new gateway token with `operator.write` scope:**
```bash
# On smo-brain, use OpenClaw CLI to generate invite with correct scopes
openclaw invite create --scopes "operator.read,operator.write" --name "paperclip-bridge"
```

4. **On Desktop (Paperclip side), accept the invite:**
```bash
# Via Paperclip API
curl -X POST http://localhost:3100/api/access/accept-invite \
  -H "Content-Type: application/json" \
  -d '{
    "gatewayUrl": "ws://100.89.148.62:18789",
    "token": "<NEW_TOKEN_FROM_STEP_3>",
    "name": "smo-brain-openclaw"
  }'
```

5. **Verify the connection:**
```bash
# Check Paperclip sees OpenClaw agents
curl -s http://localhost:3100/api/gateways | python3 -m json.tool
```

### Expected Result
- Gateway status: `connected`
- OpenClaw agents visible in Paperclip dashboard
- No `missing scope: operator.write` error

---

## Test 2: Single-Role Dispatch via OpenClaw → Paperclip

### Test Brief

Send this to OpenClaw via Telegram:

```
@smo_brain_bot Using the VP Engineering role, create a simple Express.js health check endpoint:
1. Write tests first (TDD)
2. Implement the endpoint
3. Score with engineering-scorer (target >= 8/10)
4. Save all files to workspace
```

### Expected Flow
```
Telegram → OpenClaw (CEO+COO)
  → OpenClaw reads vp-engineering.md skill
  → Dispatches to Claude Code on smo-dev/Desktop
  → Claude Code runs with superpowers methodology
  → Output: test file + implementation + score
  → OpenClaw reports back to Telegram
```

### Validation Checklist
- [ ] OpenClaw received the message via Telegram
- [ ] Correct role skill loaded (vp-engineering.md)
- [ ] Claude Code spawned with Superpowers methodology
- [ ] Tests written before implementation (TDD)
- [ ] Engineering-scorer run, result >= 8/10
- [ ] Files saved to workspace (not just stdout)
- [ ] Telegram reply received with results

---

## Test 3: Multi-Role Dispatch (CEO Orchestration)

### Test Brief

Send to OpenClaw via Telegram:

```
@smo_brain_bot I need a complete landing page section for EO MENA training program. Coordinate:

1. Content Lead: Write hero section copy in English + Arabic (bilingual)
2. VP Engineering: Build the HTML/CSS component with Tailwind, RTL support
3. QA Lead: Review accessibility (WCAG 2.1 AA) and RTL layout
4. DevOps: Create a Dockerfile for the static page

Each role should save output to their workspace. Report status for each role when done.
```

### Expected Flow
```
Telegram → OpenClaw (CEO+COO)
  → Decomposes into 4 role tasks
  → Sequences: Content → Engineering → QA → DevOps
  → Each role dispatched with correct methodology
  → CEO aggregates results
  → Reports to Telegram with per-role status
```

### Validation Checklist
- [ ] OpenClaw decomposed the brief into 4 tasks
- [ ] Content Lead produced bilingual copy (EN+AR)
- [ ] VP Engineering built HTML/CSS with RTL
- [ ] QA Lead reviewed accessibility
- [ ] DevOps created Dockerfile
- [ ] CEO reported aggregated status
- [ ] Total execution time < 30 minutes
- [ ] Total API cost < $5

---

## Test 4: n8n Role Dispatch Webhook

### Test Brief

Test the n8n webhook directly (bypassing OpenClaw):

```bash
# Test valid role
curl -X POST https://ai.mamounalamouri.smorchestra.com/webhook/smo-role-dispatch \
  -H "Content-Type: application/json" \
  -d '{
    "role": "engineering",
    "task": "List all files in your workspace and report your current status."
  }'

# Test invalid role (should return 400)
curl -X POST https://ai.mamounalamouri.smorchestra.com/webhook/smo-role-dispatch \
  -H "Content-Type: application/json" \
  -d '{
    "role": "cfo",
    "task": "Generate a financial report"
  }'
```

### Expected Results
- Valid role: HTTP 200 with `{ dispatched: true, role: "engineering", agentId: "a370cf96..." }`
- Invalid role: HTTP 400 with `{ error: "Unknown role: cfo", validRoles: [...] }`
- Agent wakes up and executes the task

---

## Test 5: OpenClaw → n8n → Paperclip Full Chain

### Test Brief

This tests the complete orchestration chain:

1. Send to OpenClaw via Telegram:
```
@smo_brain_bot Dispatch to GTM Specialist via n8n:
Create a 3-email cold outreach sequence for UAE SaaS companies
that recently raised Series A. Use signal-based approach.
```

2. OpenClaw should:
   - Recognize it needs to dispatch via n8n
   - Call the n8n webhook: `POST /webhook/smo-role-dispatch` with `role: "gtm"` and the task
   - n8n routes to Paperclip GTM Specialist agent
   - Agent wakes up and produces the sequence

### Validation Checklist
- [ ] OpenClaw called n8n webhook
- [ ] n8n execution logged in https://ai.mamounalamouri.smorchestra.com
- [ ] Paperclip GTM Specialist woke up (status changed to `running`)
- [ ] Agent produced deliverable in workspace
- [ ] OpenClaw reported completion to Telegram

---

## Test 6: Failure and Recovery

### 6a: Agent Timeout
```bash
# Set an agent to very low maxTurns to simulate timeout
curl -X PATCH http://localhost:3100/api/agents/0db9f389-5bb6-42df-81f0-5c23c1125bc2 \
  -H "Content-Type: application/json" \
  -d '{"adapterConfig": {"model": "claude-sonnet-4-20250514", "maxTurnsPerRun": 2, "dangerouslySkipPermissions": true}}'

# Trigger a task that needs more than 2 turns
curl -X POST http://localhost:3100/api/agents/0db9f389-5bb6-42df-81f0-5c23c1125bc2/wakeup \
  -H "Content-Type: application/json" \
  -d '{"message": "Research and compile a detailed 20-page competitive analysis of AI agencies in MENA.", "forceFreshSession": true}'

# Check status — should be error or idle (not stuck)
sleep 60 && curl -s http://localhost:3100/api/agents/0db9f389-5bb6-42df-81f0-5c23c1125bc2 | python3 -c "import json,sys; print(json.load(sys.stdin)['status'])"

# Restore maxTurns
curl -X PATCH http://localhost:3100/api/agents/0db9f389-5bb6-42df-81f0-5c23c1125bc2 \
  -H "Content-Type: application/json" \
  -d '{"adapterConfig": {"model": "claude-sonnet-4-20250514", "maxTurnsPerRun": 50, "dangerouslySkipPermissions": true}}'
```

### 6b: Paperclip Restart
```bash
# Kill Paperclip
pkill -f paperclipai

# Wait 10s, restart
sleep 10
cd ~/Desktop/cowork-workspace/paperclip && npx paperclipai start &

# Verify all agents still exist
curl -s http://localhost:3100/api/companies/1fd08eca-f681-468c-a468-9db41fa1425f/agents | python3 -c "
import json,sys
for a in json.load(sys.stdin):
    print(f\"{a['name']:20s} | {a['status']}\")
"
```

### 6c: Concurrent Agent Limit
```bash
# Try waking 4 agents simultaneously to test oauth concurrency
for agent in "a370cf96-be5e-42a4-bdd2-0d591b37d58c" "cd46d003-7aa4-41dc-8c4e-21a9c9a37eb6" "f39d02c9-8886-4207-8a45-3251c373a6e1" "e84f4270-70ae-4980-b379-ed8fde374e83"; do
  curl -s -X POST "http://localhost:3100/api/agents/$agent/wakeup" \
    -H "Content-Type: application/json" \
    -d '{"message": "Report your role and capabilities in one paragraph.", "forceFreshSession": true}' &
done
wait

# Check for 400 concurrency errors in run logs
sleep 120
for agent in "a370cf96-be5e-42a4-bdd2-0d591b37d58c" "cd46d003-7aa4-41dc-8c4e-21a9c9a37eb6" "f39d02c9-8886-4207-8a45-3251c373a6e1" "e84f4270-70ae-4980-b379-ed8fde374e83"; do
  status=$(curl -s "http://localhost:3100/api/agents/$agent" | python3 -c "import json,sys; print(json.load(sys.stdin)['status'])")
  echo "$agent: $status"
done
```

---

## Success Criteria

| Test | Pass Criteria |
|------|--------------|
| Test 1: Gateway Token | Connection established, no scope errors |
| Test 2: Single Role | Correct methodology loaded, output scored >= 8/10 |
| Test 3: Multi-Role | All 4 roles executed, CEO aggregated |
| Test 4: n8n Webhook | Valid → 200, invalid → 400, agent executes |
| Test 5: Full Chain | Telegram → OpenClaw → n8n → Paperclip → workspace output |
| Test 6a: Timeout | Agent status not stuck (error or idle), not running forever |
| Test 6b: Restart | All agents persist after Paperclip restart |
| Test 6c: Concurrency | At least 3 of 4 agents complete without 400 errors |

---

## Execution Order

1. **Test 1** (gateway fix) — PREREQUISITE for Tests 2, 3, 5
2. **Test 4** (n8n webhook) — Can run independently, validates infrastructure
3. **Test 2** (single role) — First OpenClaw dispatch test
4. **Test 3** (multi-role) — Full orchestration
5. **Test 5** (full chain) — End-to-end validation
6. **Test 6** (failure) — Chaos testing last

**Estimated total time:** 2-3 hours (including agent execution time)
**Estimated total cost:** < $10 (all via oauth subscription = $0 incremental)
