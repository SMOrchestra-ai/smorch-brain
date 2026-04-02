# Execution Plan v3 — Three-Layer Architecture Build

**Date:** 2026-03-30 | **Architecture:** `architecture-final-2026-03-30.md` (LOCKED)
**Total estimated time:** 14-18 hours of build + 72h soak test
**Target completion:** 2026-04-04 (including soak)

---

## Prerequisites (Already Done)

- [x] OpenClaw running on smo-brain (systemd, `Restart=always`)
- [x] n8n-mamoun running on smo-brain (10 workflows)
- [x] Claude Code on smo-brain (v2.1.81+, Account A OAuth)
- [x] Claude Code on smo-dev (v2.1.85+, Account B OAuth)
- [x] Tailscale mesh: smo-brain ↔ smo-dev ↔ desktop
- [x] Queue DB (SQLite) at `/root/.smo/queue/queue.db`
- [x] Telegram bots: @SMOQueueBot + @SulaimanMoltbot
- [x] Architecture document locked and scored 100/100
- [x] ADRs 012-015 written and indexed

---

## Phase 1: Install Paperclip on smo-brain (3-4h)

### Step 1.1: Install Paperclip (45min)
**Node:** smo-brain (SSH from desktop)
**Action:**
```bash
# Install Paperclip globally
npm install -g @anthropic/paperclip

# Initialize instance
paperclip init --name smorchestra --port 3100 --host 100.89.148.62

# Configure OAuth auth (NOT local_trusted)
paperclip config set auth.mode oauth
paperclip config set auth.jwtSecret "$(openssl rand -hex 32)"
```
**Test:** `curl -s http://100.89.148.62:3100/api/health` returns 200
**Rollback:** `npm uninstall -g @anthropic/paperclip && rm -rf ~/.paperclip`

### Step 1.2: Create systemd Service (15min)
**Node:** smo-brain
**Action:**
```ini
# /etc/systemd/system/paperclip.service
[Unit]
Description=Paperclip Company OS
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/paperclip start --instance smorchestra
Restart=always
RestartSec=5
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```
**Test:** `systemctl status paperclip` shows active (running)

### Step 1.3: Create Company + Agents (1h)
**Node:** smo-brain
**Action:** Create company "SMOrchestra" with 7 agents via Paperclip API:

| Agent | Adapter | Config Key |
|-------|---------|-----------|
| CEO | `claude_local` | model: claude-sonnet-4, workDir: /workspaces/smo |
| VP Engineering | `openclaw_gateway` | agentId: main, gatewayUrl: ws://127.0.0.1:18789 |
| QA Lead | `claude_local` | model: claude-sonnet-4, workDir: /workspaces/smo |
| DevOps | `claude_local` | model: claude-sonnet-4, workDir: /workspaces/smo |
| Data Engineer | `claude_local` | model: claude-sonnet-4, workDir: /workspaces/smo |
| Content Lead | `openclaw_gateway` | agentId: main, gatewayUrl: ws://127.0.0.1:18789 |
| GTM Specialist | `openclaw_gateway` | agentId: main, gatewayUrl: ws://127.0.0.1:18789 |

Each agent gets:
- Role instructions from `AI-Native-Org/roles/{role}.md`
- `dangerouslySkipPermissions: true`
- `maxTurnsPerRun: 50`
- Heartbeat schedule (every 15min for active agents)
- Budget: $50/month per agent (total $350, under $400 Account A+B cap)

**Test:** Paperclip UI at `http://100.89.148.62:3100` shows all 7 agents in green
**Acceptance:** Each agent visible with correct adapter type and status

### Step 1.4: Configure Heartbeats (30min)
**Node:** smo-brain
**Action:** Enable heartbeats per agent:
- CEO: every 30min (strategy checks)
- VP Engineering: every 15min (task pickup)
- QA Lead: every 15min (test verification)
- DevOps: every 30min (infrastructure checks)
- Data Engineer: every 60min (pipeline monitoring)
- Content Lead: every 30min (content queue)
- GTM Specialist: every 60min (signal monitoring)

**Test:** Wait 15min. Check Paperclip run logs — VP Eng and QA should have 1 heartbeat each.
**Acceptance:** Heartbeat fires, agent wakes, run log shows execution attempt.

### Step 1.5: Verify from Desktop Browser (15min)
**Node:** Desktop
**Action:** Open `http://100.89.148.62:3100` in browser
**Test:** Full UI loads. Can see company, agents, issues, run logs.
**Acceptance:** Paperclip UI fully functional from desktop via Tailscale.

**Phase 1 Deliverable:** Paperclip running on smo-brain with 7 agents configured, heartbeats active, UI accessible.

---

## Phase 2: Configure MiniMax M2.7 on OpenClaw (1-2h)

### Step 2.1: Get MiniMax API Key (15min)
**Action:** Sign up at `https://www.minimaxi.com/`, get API key
**Test:** `curl -H "Authorization: Bearer $KEY" https://api.minimax.chat/v1/models` returns model list

### Step 2.2: Update OpenClaw Model Config (30min)
**Node:** smo-brain
**Action:**
```bash
# Edit OpenClaw agent config
vim /root/moltbot/agents/main/config.yaml
# Set: model.primary = minimax/MiniMax-M2.7
# Set: model.fallback = google/gemini-2.0-flash-lite
# Add: provider.minimax.apiKey = $MINIMAX_API_KEY

# Restart OpenClaw
systemctl restart openclaw
```
**Test:** Send Telegram message to @SulaimanMoltbot: "Hello, what model are you running?"
**Acceptance:** Sulaiman responds coherently. Check OpenClaw logs confirm MiniMax provider used.

### Step 2.3: Test Role-Dispatch (30min)
**Node:** Telegram
**Action:** Send messages that should trigger different roles:
- "Review the architecture of eo-assessment-system" → VP Engineering
- "Write a LinkedIn post about AI automation" → Content Lead
- "What signals should we track for MENA SaaS?" → GTM Specialist
**Test:** Each message routes to correct role (check OpenClaw logs)
**Acceptance:** Role-dispatch skill correctly identifies and routes 3/3 messages.

### Step 2.4: Test Fallback (15min)
**Action:** Temporarily set an invalid MiniMax API key, send a message
**Test:** Sulaiman should fall back to Gemini Flash Lite and still respond
**Acceptance:** Degraded but functional response. Logs show fallback.
**Cleanup:** Restore valid API key.

**Phase 2 Deliverable:** OpenClaw running on MiniMax M2.7 (~$0.71/mo), Gemini fallback tested, role-dispatch working.

---

## Phase 3: Wire Paperclip to OpenClaw (2-3h)

### Step 3.1: Get OpenClaw Gateway Token (15min)
**Node:** smo-brain
**Action:**
```bash
cat /root/moltbot/gateway.yaml | grep -i token
# Or: oc gateway token
```
Store in Paperclip agent configs.

### Step 3.2: Configure openclaw_gateway Adapters (45min)
**Node:** smo-brain
**Action:** Update VP Eng, Content, GTM agents in Paperclip:
```bash
curl -X PATCH "http://100.89.148.62:3100/api/companies/{cid}/agents/{aid}" \
  -H "Content-Type: application/json" \
  -d '{
    "adapter": "openclaw_gateway",
    "config": {
      "gatewayUrl": "ws://127.0.0.1:18789",
      "authToken": "'$TOKEN'",
      "agentId": "main",
      "sessionStrategy": "issue",
      "timeout": 300000
    }
  }'
```
**Test:** Agent config saved, adapter type shows `openclaw_gateway` in UI

### Step 3.3: Test Single Heartbeat Wake (30min)
**Node:** smo-brain
**Action:**
1. Create a test issue in Paperclip: "Test: VP Eng heartbeat wake"
2. Assign to VP Engineering agent
3. Wait for next heartbeat (or trigger manually)
**Test:**
- Paperclip run log shows: started → sent wake → received response
- OpenClaw logs show: WebSocket message received, routed to main agent
- Sulaiman responds with acknowledgment
**Acceptance:** Full round-trip: Paperclip wake → OpenClaw → Sulaiman → response → Paperclip run log

### Step 3.4: Test Issue Lifecycle (45min)
**Node:** Paperclip UI
**Action:**
1. Create issue: "Build a health check endpoint for EO API"
2. Assign to VP Engineering
3. VP Eng heartbeat fires → Sulaiman receives → responds with plan
4. Mark issue as "in_progress" based on response
5. Next heartbeat → Sulaiman checks progress → reports status
**Test:** Issue transitions: created → assigned → in_progress → (eventually) done
**Acceptance:** At least 3 heartbeat cycles complete with meaningful status updates

### Step 3.5: Test All Three OpenClaw Agents (30min)
**Action:** Create one issue for each OpenClaw agent:
- VP Eng: "Review PR #42 architecture"
- Content: "Draft LinkedIn post about AI-native organizations"
- GTM: "Identify 3 buying signals for MENA SaaS companies"
**Test:** All three agents respond via their respective heartbeats
**Acceptance:** 3/3 agents responsive with role-appropriate responses

**Phase 3 Deliverable:** Paperclip successfully wakes OpenClaw agents, receives responses, tracks issue lifecycle.

---

## Phase 4: Wire Paperclip to Queue Engine (2-3h)

### Step 4.1: Verify Existing Paperclip Sync (15min)
**Node:** smo-brain
**Action:** Check n8n workflow `RnrHAtAdBESrdvn1` (Paperclip Sync, every 5min)
**Test:** Workflow runs, checks queue.db, syncs to Paperclip
**Acceptance:** Recent execution shows success status
**Fix if broken:** Update `PAPERCLIP_URL` from `http://100.100.239.103:3100` to `http://100.89.148.62:3100` (desktop → smo-brain)

### Step 4.2: Build Reverse Sync: Paperclip → Queue (1h)
**Node:** smo-brain (n8n)
**Action:** Create n8n workflow:
1. Trigger: Paperclip webhook (on issue created/assigned)
2. Parse issue: extract title, description, assigned agent, priority
3. Call `add-task.sh` to insert into Queue Engine SQLite
4. Respond to Paperclip with task ID
**Test:** Create issue in Paperclip → task appears in `sqlite3 /root/.smo/queue/queue.db "SELECT * FROM tasks ORDER BY created_at DESC LIMIT 1"`
**Acceptance:** Paperclip issue → Queue task in <30 seconds

### Step 4.3: Test Full Flow: Paperclip → Queue → Claude Code → PR (1.5h)
**Action:**
1. Create Paperclip issue: "Add /healthz endpoint to EO Assessment API"
2. Assign to VP Engineering
3. VP Eng heartbeat wakes Sulaiman → decomposes → adds tasks to Queue
4. Queue Processor dispatches to Claude Code on smo-brain
5. Claude Code builds, pushes to branch
6. CI runs → quality gate → PR created
7. Paperclip Sync updates issue with PR URL and score
**Test:** End-to-end: issue created → PR visible in Paperclip issue metadata
**Acceptance:** PR created with passing CI and quality score ≥7/10. Paperclip issue shows PR URL.

**Phase 4 Deliverable:** Bidirectional sync between Paperclip and Queue Engine. Full BRD→PR pipeline via Paperclip.

---

## Phase 5: Hardening + End-to-End Test + Soak (4h build + 72h soak)

### Step 5.1: Set Up Backup Crons (30min)
**Node:** smo-brain
**Action:**
```bash
# SQLite hourly backup
echo "0 * * * * sqlite3 /root/.smo/queue/queue.db '.backup /root/.smo/queue/backups/queue-hourly.db'" | crontab -

# Paperclip PG daily backup
echo "0 2 * * * pg_dump -p 54329 paperclip > /root/.smo/backups/paperclip/pg-daily-\$(date +\%Y\%m\%d).sql" >> /var/spool/cron/root

# n8n workflow export
echo "0 2 * * * curl -s http://localhost:5678/api/v1/workflows -H 'X-N8N-API-KEY: $KEY' > /root/.smo/backups/n8n/workflows-\$(date +\%Y\%m\%d).json" >> /var/spool/cron/root
```
**Test:** Run each backup command manually, verify output files exist
**Acceptance:** Backup files created with non-zero size

### Step 5.2: Set Up Health Check Cron (30min)
**Node:** smo-brain (n8n)
**Action:** Create n8n workflow: every 2min, check all services health. Alert via Telegram on 2 consecutive failures.
**Test:** Stop Paperclip, wait 4min, verify Telegram alert received
**Acceptance:** Alert received within 5min of service down

### Step 5.3: Apply Firewall Rules (15min)
**Node:** smo-brain
**Action:** Apply iptables rules from architecture doc (Tailscale + SSH + localhost only)
**Test:** From external network, verify port 3100 unreachable. From Tailscale, verify accessible.
**Acceptance:** Only Tailscale mesh can reach Paperclip

### Step 5.4: Budget Enforcement Test (30min)
**Action:** Set $10 budget limit on a test agent. Trigger enough runs to exceed.
**Test:** Agent auto-pauses at $10. Telegram alert sent.
**Acceptance:** Hard stop works, agent cannot execute after budget exhausted

### Step 5.5: End-to-End Test via Telegram (1h)
**Action:** `/brd Build a health check monitoring dashboard for EO Assessment System`
**Expected:** BRD → 4-5 tasks → approve → dispatch → build → CI → PRs → Paperclip sync
**Acceptance:**
- Tasks appear in `/status` within 5min
- After `/approve-all`, agents start within 2min
- PRs created within 2h
- Paperclip issues updated with PR URLs and scores

### Step 5.6: End-to-End Test via Paperclip (1h)
**Action:** Create issue in Paperclip UI with BRD
**Expected:** Same flow as 5.5 but initiated from Paperclip
**Acceptance:** Same criteria as 5.5

### Step 5.7: 72-Hour Soak Test (72h, unattended)
**Action:** Submit a real multi-day BRD. Walk away. Check Telegram 2-3x/day.
**Monitoring:**
- Heartbeats firing every 15-60min per agent
- No unrecovered service crashes
- Budget tracking accurate
- Dead letter queue empty or near-empty
- Quality scores ≥7/10 on completed tasks

**Acceptance Criteria:**
- ≥80% tasks complete without human intervention
- 0 unrecovered failures (all auto-recovered)
- Budget tracking within 10% of actual
- All services still running after 72h
- ≥5 PRs created and merged

**Phase 5 Deliverable:** Battle-tested autonomous system with proven 72h reliability.

---

## Timeline Summary

| Phase | Duration | Start Dependency | Can Parallelize? |
|-------|----------|-----------------|-----------------|
| Phase 1: Paperclip on smo-brain | 3-4h | None | No (foundation) |
| Phase 2: MiniMax M2.7 | 1-2h | None | **Yes — parallel with Phase 1** |
| Phase 3: Wire Paperclip↔OpenClaw | 2-3h | Phase 1 + Phase 2 done | No |
| Phase 4: Wire Paperclip↔Queue | 2-3h | Phase 3 done | No |
| Phase 5: Harden + Test + Soak | 4h + 72h | Phase 4 done | No |

**Optimistic path (parallelizing Phase 1+2):** 12h build + 72h soak = **~4 days total**
**Conservative path:** 14-18h build + 72h soak = **~6 days total**

```
Day 1: Phase 1 (Paperclip) + Phase 2 (MiniMax) in parallel     [4h]
Day 1: Phase 3 (Wire Paperclip↔OpenClaw)                       [3h]
Day 2: Phase 4 (Wire Paperclip↔Queue)                          [3h]
Day 2: Phase 5.1-5.6 (Hardening + E2E tests)                   [4h]
Day 3-5: Phase 5.7 (72h soak test)                              [72h]
Day 6: Review soak results, fix issues                          [2h]
```

---

## Rollback Plan

Each phase has a clean rollback:

| Phase | Rollback Action | Data Loss |
|-------|----------------|-----------|
| Phase 1 | `systemctl stop paperclip && npm uninstall -g @anthropic/paperclip` | None (new install) |
| Phase 2 | Revert OpenClaw config to GPT-5.4 OAuth | None |
| Phase 3 | Remove `openclaw_gateway` config from Paperclip agents, set to idle | None |
| Phase 4 | Deactivate reverse sync n8n workflow | None |
| Phase 5 | Revert firewall, disable backup crons | None |

**Nuclear rollback:** Everything reverts to current state (OpenClaw + n8n + Queue Engine running independently, Paperclip not installed on smo-brain). Telegram + Queue still work.

---

## Success Criteria

The system is production-ready when ALL of these are true:

1. **BRD → PR in <4h** for a simple 3-task BRD
2. **72h uptime** with zero unrecovered failures
3. **Budget enforcement** auto-pauses at limit
4. **Heartbeats fire 24/7** regardless of desktop state
5. **Telegram visibility** shows accurate real-time status
6. **Paperclip UI** shows all agents, issues, run logs from desktop browser
7. **Quality gates** block PRs scoring <7/10
8. **Dead letters** catch and surface all failures
9. **Backups** run hourly (SQLite) and daily (PG, n8n)
10. **Cost** stays under $431/month total
