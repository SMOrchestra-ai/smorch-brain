# Lana Offboarding — Consolidated Checklist

**Date:** 2026-05-11
**Status:** Phase 1 (Claude-executable surfaces) complete. Phase 2 (manual surfaces) pending Mamoun.
**Subject:** lana@smorchestra.com (GitHub: `lanaalkurdsmo`, n8n user: `lana lana`, SSH key: `lana@lana-desktop-2026`)
**Reason:** Left the company. 2FA prevented password rotation, so access revoked via removal across every surface.

> **Read this top-down.** Section 1 is what's already done — verify if you want. Section 2 is what only you can do — work it in priority order, top is highest blast-radius. Section 3 is the secret-rotation list.

---

## 0. Executive 30-second summary

| Surface | Status | Notes |
|---|---|---|
| GitHub (org + repos + teams) | ✅ **Removed** | Commit `f957ff9` on smorch-brain main |
| Server SSH (all 4 hosts) | ✅ **Removed** | Backups left at `/root/.ssh/authorized_keys.bak-20260525-152406` on each host |
| Notion workspace | ✅ **Already clean** | No user with name/email matching "lana" |
| Canva | ✅ **No API surface** | 5 brand kits found, no member-listing API. Manual UI check needed (§2.7) |
| Gamma | ✅ **No lana-owned content** | Search returned 0 gammas |
| Instantly | ✅ **No lana-named account** | 0 accounts matched "lana" search |
| Ahrefs | ✅ **No API access** | API plan returns `Insufficient plan` for management. Manual UI (§2.7) |
| **Supabase smo org** | 🚨 **CRITICAL — Lana OWNS the org with all SMO production data** | §2.1 |
| **n8n smo-prod credentials** | 🚨 **44/100 credentials owned by Lana**, including all production API keys | §2.2 |
| n8n smo-dev | ⚠️ **API key broken** (auth error) | §2.3 |
| n8n smo-brain (eo-prod) | ⚠️ **API method-not-allowed** | §2.3 |
| GHL (SalesMfast SME) users | ⚠️ **Not exposed by salesmfast-ops MCP** | §2.4 |
| Linear, Slack, Telegram, WhatsApp, registrar, Cloudflare, Contabo control panel | ⚠️ **No MCP/connector** | §2.5–2.9 |

**Bottom line:** **GitHub is locked, SSH is locked, but Lana legally owns one of your three Supabase orgs (the one with SMO production data) AND owns 44 n8n credentials in smo-prod.** Treat as time-sensitive — even though her *daily-use* access is gone, the ownership records are structural and need to be transferred or her leverage continues to exist.

---

## 1. What's done (verified)

### 1.1 GitHub — fully revoked ✅

22 successful `DELETE` API calls against `SMOrchestra-ai/*` and `smorchestraai-code/*`:

- 18 direct collaborator grants on org repos (7 admin, 11 read)
- 1 collaborator grant on personal repo `smorchestraai-code/SaaSfast-ar`
- 2 team memberships (`engineering`, `reviewers`)
- 1 org membership

**Verification:** all surfaces return `404 Not Found`. Org now has 1 member (`smorchestraai-code`). Audit details: [docs/audits/2026-05-11-lana-offboarding.md](2026-05-11-lana-offboarding.md). Commit: `f957ff9`.

### 1.2 Server SSH — locked out on 4 hosts ✅

Found the same SSH key (`ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoRkZzWT8qsUiZWOZzlAT7Xx7EMFOGQbtvaeV9rAEos lana@lana-desktop-2026`) in `/root/.ssh/authorized_keys` on **every server**:

| Host | Keys before | Keys after | Backup |
|---|---|---|---|
| smo-dev (100.83.242.99) | 4 | 3 | `/root/.ssh/authorized_keys.bak-20260525-152406` |
| smo-prod (100.108.44.127) | 4 | 3 | same name on host |
| eo-prod (100.89.148.62) | 5 | 4 | same name on host |
| eo-dev (100.99.145.22) | 2 | 1 | same name on host |

**Verification:** `grep 'lana@lana-desktop-2026'` returns empty on each host. No user account named `lana` in `/etc/passwd` on any host.

⚠️ **What this does NOT tell us:** whether Lana copied `.env` files, source code, or SSH host keys to her local machine while she had access. Assume she did — that's why §3 (secrets rotation) is mandatory.

### 1.3 Other connected MCPs — checked, nothing removable

| Surface | Finding |
|---|---|
| **Notion** | `notion-get-users query=lana` → 0 results. Either never had access or already clean. |
| **Supabase eo** | Org `mamoun@smorchestra.com's Org` — clean, Mamoun-owned. Contains 2 projects. |
| **Gamma** | `get_gammas query=lana` → 0 gammas. No lana-titled content. |
| **Instantly** | `list_accounts search=lana` → 0 email accounts. |
| **Canva** | 5 brand kits (SMOrchestra, Graia, Mamoun Alamouri, SMO.AI, kAG3ROTpO5Q-unnamed). No member-listing API; manual UI check needed. |
| **Ahrefs** | API returns `Insufficient plan` for `management-projects`. Manual UI check needed. |

---

## 2. What only you can do (work top-down)

### 2.1 🚨 Supabase smo org — Lana OWNS it. TRANSFER OWNERSHIP THIS WEEK.

**Severity:** Highest. She can delete the org (and 3 production databases) at any time from her Supabase login until ownership is moved.

**Finding:** Supabase organization `caszzfthymlmrxnwxlan` is named **`lana@smorchestra.com's Org`** and contains:

| Project | Status | DB host | Created |
|---|---|---|---|
| `SSE` (`ozylyahdhuueozqhxiwz`) | ACTIVE_HEALTHY | `db.ozylyahdhuueozqhxiwz.supabase.co` | 2025-12-22 |
| `claude campaign` (`ihfojxanjvysoacmpjxs`) | INACTIVE | `db.ihfojxanjvysoacmpjxs.supabase.co` | 2026-03-02 |
| `Content Repurposing Engine` (`kyxiyvmqqohxpfuoansv`) | ACTIVE_HEALTHY | `db.kyxiyvmqqohxpfuoansv.supabase.co` | 2026-04-01 |

**Actions for you (in order):**
1. Log into Supabase as Mamoun (mamoun@smorchestra.com).
2. Go to https://supabase.com/dashboard/org/caszzfthymlmrxnwxlan/team — verify Mamoun is at minimum a member of this org. **If not, you cannot proceed without Lana's cooperation — escalate to her 2FA recovery (or contact Supabase support with proof of company ownership).**
3. Open https://supabase.com/dashboard/org/caszzfthymlmrxnwxlan/settings → "Transfer Organization" — transfer ownership from Lana → Mamoun.
4. Once you are Owner, go to Team → remove `lana@smorchestra.com` as a member.
5. **Rotate every service-role key and anon key** for the 3 projects in this org (see §3).
6. Consider: rename the org to something less Lana-specific (e.g. "SMOrchestra Production").

**Risk if you delay:** Lana could log in, click "Delete project" or "Delete organization," and your SSE database is gone. Restore would require Supabase support + the most recent backup (point-in-time recovery is 7 days on Pro plan).

### 2.2 🚨 n8n smo-prod — 44 of 100 credentials owned by Lana. TRANSFER OWNERSHIP.

**Severity:** Highest. Each credential holds an actual production secret (API keys, OAuth tokens, DB connection strings). If Lana logs into n8n at `flows.smorchestra.ai`, she sees + can edit + can copy out all 44.

**Finding:** Lana's n8n user (`lana lana <lana@smorchestra.com>`, id `GpCTwbFy0QbwQBlH`) is `credential:owner` on:

```
muQSvVplVbipWN4Q  Header Auth account 4              httpHeaderAuth
J5DQDommVJy7iQT2  EO Account GHL                      httpHeaderAuth
Hrt9ykapyzzobUVP  Micro saas                          httpHeaderAuth
ADgiKIuZVQcFwTJm  GHL Webhook Secret                  httpHeaderAuth
JpcSVxzC0z5cczTS  anthropic_api                       anthropicApi
0zWVmhPu2oYHYyES  firecrawl_api                       httpHeaderAuth
jLgOXHHQe04LvQad  SSE                                 supabaseApi
SJ1LEQ52kjoYPq2m  Gmail account 4                     gmailOAuth2
pQJl9VeGTf4S6GYg  SMO>AI GMAO CREDINCILAC             googleDocsOAuth2Api
mb4U1DHH0ZHEWDek  Cludecampaign                       supabaseApi
GZ8Y5mXxP8wtuEKV  ruba account                        telegramApi
qeqqoH6YKennFPss  Header Auth account 3               httpHeaderAuth
PzKeIxHArQkSkPCR  Webflow account                     webflowOAuth2Api
vaQcZ4dGyBtftX0M  Notion account 3                    notionApi
o0FcUgv0220Yr5gV  Blotato account                     blotatoApi
nPwp7rVX3gdm8hBJ  Notion account 2                    notionApi
LT9ZqtFu6A81jeIn  Supabase account 3                  supabaseApi
BB1UasLVZpo2W6OT  SMO Google Ads account              googleAdsOAuth2Api
ptXW7QkDFGQxZFCL  Google Sheets Trigger account 2     googleSheetsTriggerOAuth2Api
CIIEvGp1tMEKRicd  Canva connction                     oAuth2Api
mF5tIZVb59kfai7x  Microsoft Outlook account 4         microsoftOutlookOAuth2Api
2JrGLKKAYjYxUUr7  Microsoft Outlook account 3         microsoftOutlookOAuth2Api
vybpGapoUqHG31V7  good one (Google Sheets)            googleSheetsOAuth2Api
L5uR4dlpR2IHeMu1  Google Docs account 2               googleDocsOAuth2Api
CpDEMxn88zfW6ZtJ  Google Drive account 3              googleDriveOAuth2Api
lHvUlPLqPsmtKDsC  Google Gemini(PaLM) Api account 4   googlePalmApi
igQwhJlJcOYj7hcg  Microsoft Outlook account LANA      microsoftOutlookOAuth2Api
tKItu8gNU4Ohj14e  Header Auth account 2               httpHeaderAuth
S7zVRHbC6yWGSemC  Supabase account 2                  supabaseApi
skr6BvYhjTzGbGKD  OpenAi account 5                    openAiApi
a1LR5ro2McCdWXPz  Microsoft account                   microsoftOAuth2Api
njnP6vXRIJhUjxjp  Google Drive account 2              googleDriveOAuth2Api
FUP24RcqDPFE5KA0  HighLevel account                   highLevelOAuth2Api
d1oM09YC2e7uiDfI  pro (Google Gemini)                 googlePalmApi
VQDaAqMpwY3SabZM  Telegram account 4                  telegramApi
VgBKDeh9T6PiUpG5  Microsoft Teams account             microsoftTeamsOAuth2Api
F5CbajgqV46crxvh  Google Sheets account               googleSheetsOAuth2Api
hMCdpK0nZSBQIiLu  Microsoft Drive account             microsoftOneDriveOAuth2Api
UqRmd4XDQ5o9NFmP  Telegram account 3                  telegramApi
wcFw2GE0V12wvflr  OpenAi account 4                    openAiApi
AD6CJ5KjS4mfViAV  Google Drive account                googleDriveOAuth2Api
7tsfcNNOkZlUs3hy  GHL                                 httpBearerAuth
hxjYvE5j7zNKgZko  Relevance Ai Agent                  httpBearerAuth
o4hkHsKkY1ckDhLE  Unnamed credential 2                httpBasicAuth
```

**I did NOT delete any of these** because deletion immediately breaks every workflow that uses them — production damage. Transfer-ownership in n8n UI is non-destructive.

**Actions for you (in order):**
1. Log into n8n at `https://flows.smorchestra.ai` as Mamoun.
2. Settings → Users → find `lana lana <lana@smorchestra.com>` (id `GpCTwbFy0QbwQBlH`).
3. For each of the 44 credentials above:
   - Open the credential
   - Add Mamoun as a shared user with `credential:owner` role
   - Then remove Lana from sharing
4. Once all 44 are transferred, **delete Lana's n8n user account** from Settings → Users.
5. Rotate the actual secret values in §3 (the n8n ownership transfer doesn't change the underlying API keys).

### 2.3 n8n smo-dev + smo-brain — both MCPs broken, manual audit needed

- `flows-testflow.smorchestra.ai` (smo-dev) — MCP returned `AUTHENTICATION_ERROR`. The n8n API key in your MCP config is stale. **Action:** log in via UI, rotate the API key, update MCP config in `~/.claude.json`, then re-audit credentials.
- `ai.mamounalamouri.smorchestra.com` (eo-prod n8n, aka smo-brain) — MCP returned `GET method not allowed`. Likely older n8n version. **Action:** manual UI audit of Settings → Users + every credential's "Sharing" tab. Pattern: find any owned by `lana@smorchestra.com`, transfer to Mamoun, then delete her user.

### 2.4 GHL (SalesMfast SME location) — manual user removal

The `salesmfast-ops` MCP only exposes contacts/conversations/etc., not Users-of-location. **Action:** log into GoHighLevel agency view → Locations → SalesMfast SME location → Settings → My Staff → remove `lana@smorchestra.com`. Repeat for any other GHL location she may have had access to.

### 2.5 Linear — manual removal

Linear MCP is disconnected in this session, but Lana likely had Linear access (the smorch-brain `MAMOUN-GUIDE.md` documents a Linear webhook + Mamoun's project structure). **Action:** https://linear.app/smorchestra/settings/members → remove `lana@smorchestra.com`. Reassign any open issues she owned.

### 2.6 Slack / Telegram / WhatsApp / Discord — communication channels

- **Slack** (if any SMO workspace) — Admin → Manage members → deactivate her account.
- **Telegram** — channels (Linear notifications, n8n alerts, internal team) — remove from each. Note her n8n credential `ruba account` (telegramApi) — that's a separate Telegram identity tied to her workflows.
- **WhatsApp Business** — any group she was admin of, demote first then remove.
- **Discord** (if any) — same pattern.

### 2.7 Canva + Ahrefs + Gamma — manual UI audit

- **Canva** — settings → Members & teams → remove `lana@smorchestra.com`. 5 brand kits (SMOrchestra, Graia, Mamoun Alamouri, SMO.AI) — check sharing for each.
- **Ahrefs** — workspace settings → members → remove her seat.
- **Gamma** — workspace settings → members → remove. Search for any gammas she shared with you.

### 2.8 Contabo / Cloudflare / Domain Registrar — infrastructure access

- **Contabo** (both your SMO panel + EO panel) — log into both control panels → User Management → remove `lana@smorchestra.com` if listed. **The Contabo MCP is disconnected in this session, so I could not verify via API.**
- **Cloudflare** (if SMO uses Cloudflare for DNS/WAF) — account members → remove.
- **Domain registrar** (name.com / GoDaddy / Cloudflare Registrar) — account access list → remove. **High blast radius** — domain control = root.

### 2.9 Email + identity hygiene

- **`lana@smorchestra.com` mailbox** — Google Workspace / Outlook 365 admin → suspend account first (preserves data + recovers any 2FA SMS that comes in), then in 30 days delete + forward archive to ops mailbox.
- **Google Workspace** — admin → users → suspend. Removes Gmail/Drive/Calendar access in one shot.
- **Removal from group aliases** — sales@, support@, team@, etc.
- **Any third-party login that uses "Sign in with Google" via her email** — those need explicit revocation at the third-party side.

---

## 3. Secrets rotation list (do this AFTER §2.1 + §2.2, NOT before)

Lana had n8n ownership on credentials containing these production secrets. Assume she has copies locally. Rotate in this priority order:

| Priority | Secret | Where it's used | Rotation owner |
|---|---|---|---|
| 1 | **Supabase service-role keys** for `SSE` + `Content Repurposing Engine` projects | n8n credentials `SSE` / `LT9ZqtFu6A81jeIn` / `mb4U1DHH0ZHEWDek` / `S7zVRHbC6yWGSemC`; sse-backend on smo-prod; any direct app config | Supabase dashboard → API → Reset service-role key |
| 2 | **Anthropic API key** | n8n credential `anthropic_api` (`JpcSVxzC0z5cczTS`); any app config referencing `ANTHROPIC_API_KEY` | console.anthropic.com → API keys → create new + revoke old |
| 3 | **OpenAI API key** | n8n credentials `OpenAi account 4/5`; any app config | platform.openai.com → API keys |
| 4 | **Firecrawl API key** | n8n credential `firecrawl_api` (`0zWVmhPu2oYHYyES`); MCP config in `~/.claude.json`; CLI config on local + smo-dev + smo-prod `/etc/profile.d/printing-press.sh` + `~/.config/firecrawl-pp-cli/config.toml` + Keychain | firecrawl.dev → API → rotate. Then update **all 5 consumer locations**. |
| 5 | **GHL location API key + GHL Webhook Secret** | n8n credentials `EO Account GHL`, `HighLevel account`, `GHL Webhook Secret`, `GHL` (HTTP Bearer); `shared/salesmfast-ops-mcp` `.env`; any app reading `GHL_API_KEY` | GHL → Settings → Business Profile → API Keys; rotate webhook secret in Settings → My Integrations |
| 6 | **Google Workspace OAuth tokens** | All 12 `*OAuth2Api` n8n credentials (Gmail, Sheets, Docs, Drive, Outlook, etc.) | Workspace admin → revoke OAuth grants for `lana@smorchestra.com` (will force re-auth on every workflow — expected) |
| 7 | **Microsoft 365 OAuth tokens** | Outlook / Teams / OneDrive credentials | MS365 admin → revoke |
| 8 | **Google Ads OAuth** | `SMO Google Ads account` | revoke at ads.google.com |
| 9 | **Notion integration tokens** | `Notion account 2/3` | notion.so/my-integrations → rotate |
| 10 | **Telegram bot tokens** | `Telegram account 3/4`, `ruba account` | @BotFather → /revoke or rotate |
| 11 | **Webflow, Blotato, Relevance AI, Canva OAuth** | each respective credential | each provider's dashboard |
| 12 | **SSH host keys + Tailscale keys** | If you suspect she had server access beyond the SSH key we removed — rotate ssh host keys on all 4 servers; rotate Tailscale auth keys | per-server |

**Discipline:** every rotation goes into `canonical/secrets-manifest.yaml` (per SOP-16 — that manifest needs to be created if it doesn't already exist).

---

## 4. SOP + lessons follow-ups

1. **SOP-13 (Lana Handover Protocol)** is named for Lana's QA role. Either rename to "QA Handover Protocol" or repoint to the new QA owner.
2. **Create SOP-37 (Offboarding Runbook)** based on this checklist. The 4-server SSH key audit, n8n credential audit, Supabase org ownership check, and secrets rotation list should become standard offboarding steps.
3. **Add L-NN to `~/.claude/lessons.md`** — "Before granting any team member SSH root, Supabase org Owner role, or n8n credential ownership, write down the offboarding revoke path. We had to chase 100+ surfaces in one session because access was granted ad-hoc."
4. **Pre-existing 2026-05-01 multi-server audit** missed all of this because (a) Lana was still employed and (b) the audit was scoped to security drift, not access mapping. Future audits should include a "**Lana-style access mapping**" question per audited surface: "If <person> left tomorrow, what's the complete removal path?"

---

## 5. Disconnected MCPs (could not audit this session)

These MCPs were disconnected at session start; I could not query them. **Manual audit needed:**

- `mcp__claude_ai_Linear__*` — 33 tools missing (Linear org)
- `mcp__contabo-eo__*` — 63 tools missing (Contabo EO panel)
- `mcp__contabo-smo__*` — 63 tools missing (Contabo SMO panel)
- `mcp__railway__*` — 14 tools missing (Railway — confirm nothing SMO uses)
- `mcp__claude_ai_Clay__*` — Clay org access
- `mcp__claude_ai_Google_Drive__*` — 2 tools partial — confirm full Workspace access via admin
- `mcp__claude_ai_Stripe__*` — 2 tools partial — Stripe Dashboard → Team → remove

---

## Appendix — exact commands used in §1 (reproducibility)

```bash
# GitHub
for repo in <18 repos>; do gh api -X DELETE /repos/SMOrchestra-ai/$repo/collaborators/lanaalkurdsmo; done
gh api -X DELETE /repos/smorchestraai-code/SaaSfast-ar/collaborators/lanaalkurdsmo
gh api -X DELETE /orgs/SMOrchestra-ai/teams/engineering/memberships/lanaalkurdsmo
gh api -X DELETE /orgs/SMOrchestra-ai/teams/reviewers/memberships/lanaalkurdsmo
gh api -X DELETE /orgs/SMOrchestra-ai/members/lanaalkurdsmo

# SSH (each server)
ssh root@<host> "
  cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.bak-$(date +%Y%m%d-%H%M%S)
  grep -v 'lana@lana-desktop-2026' /root/.ssh/authorized_keys > /tmp/ak.new
  cat /tmp/ak.new > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
"
```

Audit predecessor: [2026-05-11-lana-offboarding.md](2026-05-11-lana-offboarding.md) (GitHub-only, kept for evidence).
