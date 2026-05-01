---
status: active
last_reviewed: 2026-05-02
owner: Mamoun Alamouri
captured: "Codified 2026-05-02. Referenced in global ~/.claude/CLAUDE.md but never written until needed for Phase A tasks A10/A11 (n8n credential rotation). Trigger to write was the SSE Phase A activation plan needing it as a hard prerequisite."
---

# SOP-16: Secrets Rotation

**Version:** 1.0
**Date:** May 2026
**Owner:** Mamoun Alamouri
**Scope:** Rotation policy + procedure for every long-lived secret in the SMOrchestra production surface (n8n credentials, Supabase tokens, Anthropic/OpenAI API keys, GHL/Instantly/HeyReach API keys, GitHub PATs, server SSH keys, Contabo passwords)
**Skills Used:** `secrets-manager` (smorch-ops plugin) — orchestrates audit + rotate workflows
**Cadence:** 90 days for prod credentials; 180 days for read-only / lower-privilege keys; immediate on any compromise signal
**Related SOPs:** SOP-10 Incident-Response (compromise triggers immediate rotation), SOP-04 Infrastructure-Node-Roles (which servers hold which secrets)
**Principle:** Secrets are time-bound. A 2-year-old service-role key is a vulnerability regardless of whether it's been compromised.

---

## When This SOP Triggers

**Automatically (Claude Code must remind without being asked):**
- Any secret in the manifest (`smorch-brain/canonical/secrets-manifest.yaml`) older than its rotation cadence
- Any incident classified SEV2 or higher that involved credentials (per SOP-10)
- Before activating Sprint 6 INFRA (Phase A — credential surface must be rotated first)
- Before onboarding a new agent (Lana, future hires) — rotate any keys they shouldn't see history of

**On request:**
- User runs `/smo-secrets --audit` (lists all secrets + ages)
- User runs `/smo-secrets --rotate <secret-id>` (orchestrates the rotation per this SOP)

---

## Rotation cadence by secret class

| Class | Examples | Cadence | Notes |
|---|---|---|---|
| Backend service-role | Supabase service-role JWT, n8n encryption key | 90 days | Highest blast radius — full DB access |
| Backend basic-auth | n8n basic-auth password, server SSH passwords | 90 days | Brute-force surface — must be 32+ chars |
| Vendor API (write) | GHL pit-*, Instantly API key, HeyReach API key | 90 days | Send-side — compromise = customer reputation damage |
| Vendor API (read) | Ahrefs, Clay (read mode), Firecrawl | 180 days | Lower urgency, lower blast radius |
| Frontend public | Supabase publishable, anon JWT | 365 days OR on RLS policy change | Public by design; rotate on RLS schema change |
| Personal Access | GitHub PATs, Anthropic/OpenAI API keys | 90 days | Per-user surface |
| Infrastructure | Contabo OAuth client secret, VPS root passwords | 180 days | Provisioning surface; less frequent use |
| Server-to-server | Tailscale auth keys, internal API keys | 90 days | Lateral-movement surface |

**Hard rule:** No secret older than 365 days, regardless of class. If the manifest shows one, rotation is non-negotiable.

---

## The 7-step rotation procedure

Apply per-secret. Do NOT batch rotations of different classes in one operation (audit log gets muddy).

### Step 1 — Pre-rotation backup

For any secret whose loss would corrupt encrypted state (n8n encryption key, GPG keys, etc.):
```bash
# n8n encryption key example
ssh root@smo-prod 'n8n export:credentials --all --output=/root/n8n-creds-pre-rotation-$(date +%Y%m%d).json'
scp root@smo-prod:/root/n8n-creds-pre-rotation-*.json ~/Desktop/secrets-backups/
gpg --encrypt --recipient $YOUR_GPG_KEY ~/Desktop/secrets-backups/n8n-creds-pre-rotation-*.json
```

For session-token-style secrets (API keys), no backup needed — the new key fully replaces the old.

**Verification:** Backup file exists, encrypted, restorable (test restore on eo-dev before proceeding to Step 2).

### Step 2 — Generate new secret

| Secret type | Generation method |
|---|---|
| Random password | `openssl rand -base64 24` (32 chars after b64) |
| Random key | `openssl rand -hex 32` (n8n encryption key style) |
| Vendor API key | Generate via vendor dashboard (GHL, Instantly, HeyReach, Supabase) |
| GitHub PAT | https://github.com/settings/tokens |
| SSH key | `ssh-keygen -t ed25519 -C "alias-2026-05" -f ~/.ssh/<alias>` |

Store NEW secret in 1Password under the same item, with date-suffixed name: `n8n-prod-encryption-key-2026-05`. Mark old one as `retired-2026-05-XX`.

### Step 3 — Update consumers (rolling update)

Find every consumer of the old secret BEFORE swapping:
- Search code: `grep -r "<env-var-name>" ~/Desktop/repo-workspace/`
- Search server: `ssh root@<server> 'grep -r "<env-var-name>" /opt/apps/ /root/ 2>/dev/null'`
- Search MCP configs: `grep -r "<env-var-name>" ~/.claude.json ~/Library/Application\ Support/Claude/claude_desktop_config.json`
- Search GitHub Actions secrets: `gh secret list --repo <repo>`

For each consumer:
1. Update with NEW value
2. Restart consumer process (PM2, systemd, Claude Code session, etc.)
3. Smoke-test the consumer (login, API call, etc.)
4. Move to next consumer

**Critical:** Until the OLD secret is destroyed (Step 7), both old and new should work — design the swap so consumers can be updated independently.

### Step 4 — Activate new secret on the issuing system

Only AFTER all known consumers are updated:
- For vendor APIs: revoke old key in vendor dashboard
- For n8n basic-auth: update n8n env var, restart n8n
- For Supabase tokens: revoke old PAT in Supabase dashboard
- For SSH keys: remove old `authorized_keys` entry on each server

For n8n encryption key specifically: this is the high-risk step. Old key MUST remain available until all credentials re-encrypt successfully. Procedure:
```bash
# 1. Set new key in n8n env (e.g., N8N_ENCRYPTION_KEY=<new>)
# 2. Restart n8n
# 3. n8n re-reads credentials, re-encrypts with new key
# 4. Verify all 5 sample credentials still decrypt + work
# 5. Only then destroy old key in 1Password
```

### Step 5 — Verify new secret works end-to-end

Run a non-trivial smoke test:
- n8n basic-auth: login + execute a workflow
- n8n encryption key: list credentials in UI, test 1 connection from each credential type
- GHL API key: hit `/contacts/search` and get a known contact back
- Supabase PAT: `mcp__supabase-{org}__list_projects` returns expected projects
- Anthropic API: `claude --print "ping"` returns response

**If smoke fails:** STOP. Old secret should still work since you haven't destroyed it. Diagnose, fix, re-try.

### Step 6 — Audit log entry

Write to `docs/incidents/{date}-{secret-id}-rotation.md` (in the relevant project repo, OR in smorch-brain canonical for cross-project secrets):
```markdown
# {Date} — {Secret ID} rotation

**Trigger:** {scheduled cadence | incident response | onboarding}
**Old secret retired:** {date marked retired in 1Password}
**New secret active:** {date}
**Consumers updated:** {list}
**Smoke test:** {passed / details}
**Rollback path:** {if issue arises within 7 days, restore from {backup location}}
**Next rotation due:** {date + cadence}
```

Update `smorch-brain/canonical/secrets-manifest.yaml`:
```yaml
- name: n8n-prod-encryption-key
  type: encryption-key
  cadence_days: 90
  last_rotated: 2026-05-02
  next_due: 2026-08-02
  storage: 1password://Vault/n8n-prod-encryption-key-2026-05
```

### Step 7 — Destroy old secret (after cooling period)

7-day cooling period for high-risk secrets (n8n encryption key, Supabase service-role). Reason: if a downstream system silently depends on the old key, you want time to detect it before destroying the only copy.

After 7 days:
- 1Password: delete the retired entry (NOT just rename)
- Secret manager: hard-delete
- For vendor keys: vendor dashboard usually does this automatically when revoked

For low-risk secrets (read-only API keys), no cooling period — destroy on rotation.

---

## Failure modes

| Symptom | Root cause | Fix |
|---|---|---|
| New n8n encryption key set, old credentials fail to decrypt | n8n didn't re-encrypt before old key destroyed | Restore from pre-rotation backup; restart with old key; re-do procedure with verification at each step |
| Service intermittently fails post-rotation | Some consumer wasn't updated | Search again with broader patterns; check Docker container env, .env.local files in user homes |
| Audit log out of date with reality | Manual rotation skipped Step 6 | `/smo-secrets --audit` will surface drift; reconcile manually |
| Cooling period skipped, downstream fails | Pressure to "just clean it up" | Always 7 days for high-risk; never compress |

---

## Anti-patterns

- ❌ Don't rotate by editing `.env` files directly without using 1Password / vault as source of truth
- ❌ Don't reuse old passwords (manifest must enforce uniqueness; `/smo-secrets --audit` checks)
- ❌ Don't store secrets in Claude config files (`claude_desktop_config.json`, `~/.claude.json` mcpServers env blocks) without flagging — they're plaintext on disk. Use environment variables sourced from 1Password CLI when possible.
- ❌ Don't skip the cooling period because "everything looks fine" — that's exactly when silent dependencies bite
- ❌ Don't rotate during incident response unless the secret IS the incident — adds variables to debugging
- ❌ Don't batch unrelated secret rotations in one operation — audit log conflates causes

---

## Phase A specific application

Phase A tasks A10 (n8n basic-auth rotation) and A11 (n8n encryption key rotation) are the FIRST production application of this SOP. Reference notes:

**A10 sequence:**
- Class: Backend basic-auth (90-day cadence)
- Cooling period: 7 days
- Consumers: n8n web UI, GitHub Actions workflow-state gate (Step 1 of Phase A plan), Claude Code n8n MCPs (`n8n-smo-brain`, `n8n-smo-dev`)
- Smoke test: log in to https://flow.smorchestra.ai with new credentials

**A11 sequence:**
- Class: Backend service-role / encryption-key (90-day cadence)
- Cooling period: 7 days
- Consumers: n8n itself (sole consumer of the encryption key)
- Pre-rotation backup MANDATORY — restore-tested on eo-dev before proceeding
- Smoke test: 5 sample credentials decrypt + execute correctly post-rotation

Both tracked in `docs/incidents/2026-04-27-send-workflows-active-safety-fix.md` follow-ups #3 (basic-auth) and #4 (encryption key).
