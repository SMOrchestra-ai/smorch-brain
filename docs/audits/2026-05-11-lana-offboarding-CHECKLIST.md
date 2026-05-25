# Lana Offboarding — Consolidated Checklist

**Date:** 2026-05-11 (revised 2026-05-11 after Mamoun gained mailbox control)
**Status:** Phase 1 (Claude-executable surfaces) complete. Phase 2 (manual surfaces) pending Mamoun — urgency downgraded after mailbox takeover.
**Subject:** lana@smorchestra.com (GitHub: `lanaalkurdsmo`, n8n user: `lana lana`, SSH key: `lana@lana-desktop-2026`)
**Reason:** Left the company.

> **POSTURE UPDATE — 2026-05-11:** Mamoun now controls the `lana@smorchestra.com` mailbox AND has reset its password. This is a major risk reduction:
>
> - Any service that uses email for password reset → Mamoun can lock her out at any time by initiating a reset.
> - Any service that uses email-delivered 2FA → Mamoun receives the codes.
> - Authenticator-app 2FA (Google Authenticator, Authy on her phone) is NOT covered — those still need explicit revocation per service.
>
> **What this changes in this doc:** the *future-access* concern collapses for most services. The *ownership-on-paper* (Supabase org name, n8n credential owner) can stay as-is — Mamoun can log in as her any time. The remaining real risk is **local copies of secrets she made during her tenure** (the §3 rotation list). That risk is unchanged.

> **Read this top-down.** Section 1 is what's already done. Section 2 is what only Mamoun can do — most items downgraded from 🚨 to ⚠️ after the mailbox takeover. Section 3 (secrets rotation) is the only thing that retains full urgency, because rotation defends against her local copies, not against future logins.

---

## 0. Executive 30-second summary

| Surface | Status | Notes |
|---|---|---|
| GitHub (org + repos + teams) | ✅ **Removed** | Commit `f957ff9` on smorch-brain main |
| Server SSH (all 4 hosts) | ✅ **Removed** | Backups at `/root/.ssh/authorized_keys.bak-20260525-152406` on each host |
| **lana@smorchestra.com mailbox** | ✅ **Taken over + password reset by Mamoun** | Recovery flows now route to Mamoun |
| Notion workspace | ✅ **Already clean** | No user with name/email matching "lana" |
| Canva | ✅ **No API surface** | 5 brand kits found, no member-listing API. Manual UI check (§2.7) |
| Gamma | ✅ **No lana-owned content** | Search returned 0 gammas |
| Instantly | ✅ **No lana-named account** | 0 accounts matched "lana" search |
| Ahrefs | ✅ **No API access** | API plan returns `Insufficient plan` for management. Manual UI (§2.7) |
| Supabase smo org | ⚠️ **Keep as-is (per Mamoun)** — Lana still listed as Owner on paper, but mailbox-controlled = effectively neutralized | §2.1 — ownership transfer is optional cleanup, NOT urgent |
| n8n smo-prod credentials | ⚠️ **Keep as-is (per Mamoun)** — 44 credentials still owned by Lana, but she can't log in without email-based reset (which routes to Mamoun) | §2.2 — ownership transfer is optional cleanup |
| n8n smo-dev | ⚠️ **API key broken** (auth error) | §2.3 |
| n8n smo-brain (eo-prod) | ⚠️ **API method-not-allowed** | §2.3 |
| GHL (SalesMfast SME) users | ⚠️ **Not exposed by salesmfast-ops MCP** | §2.4 |
| Linear, Slack, Telegram, WhatsApp, registrar, Cloudflare, Contabo control panel | ⚠️ **No MCP/connector** | §2.5–2.9 |
| Authenticator-app 2FA on her phone (Google Auth / Authy) | 🟡 **Still exists** | Per-service revocation needed in §2 — only matters for services where she set up authenticator-app 2FA |

**Bottom line:** **GitHub locked. SSH locked. Mailbox controlled. The remaining real risk is what she copied locally during her tenure — addressed by §3 (secrets rotation). Ownership-on-paper at Supabase + n8n can be left as-is per Mamoun's decision (mailbox control is sufficient deterrent).**

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

### 2.1 ⚠️ Supabase smo org — keep as-is per Mamoun (mailbox control = sufficient deterrent)

**Severity:** Downgraded from CRITICAL → optional cleanup. Mamoun's decision (2026-05-11): keep the org structure intact, since he now controls `lana@smorchestra.com` and can password-reset her Supabase login at any time. Her name on the paper is fine.

**Finding (for the record):** Supabase organization `caszzfthymlmrxnwxlan` is named **`lana@smorchestra.com's Org`** and contains:

| Project | Status | DB host | Created |
|---|---|---|---|
| `SSE` (`ozylyahdhuueozqhxiwz`) | ACTIVE_HEALTHY | `db.ozylyahdhuueozqhxiwz.supabase.co` | 2025-12-22 |
| `claude campaign` (`ihfojxanjvysoacmpjxs`) | INACTIVE | `db.ihfojxanjvysoacmpjxs.supabase.co` | 2026-03-02 |
| `Content Repurposing Engine` (`kyxiyvmqqohxpfuoansv`) | ACTIVE_HEALTHY | `db.kyxiyvmqqohxpfuoansv.supabase.co` | 2026-04-01 |

**What you should still do (lower priority):**
1. **Defensive lockout** — log into Supabase as `lana@smorchestra.com` using your reset password. Add 2FA tied to YOUR authenticator app (not hers). Add Mamoun's primary email as a recovery email. This ensures her authenticator app — if she still has it — can be overridden.
2. **Rotate service-role keys** for `SSE` + `Content Repurposing Engine` per §3 priority 1 — this is the real protection (against secrets she may have copied locally).
3. **Optional later:** transfer org ownership to Mamoun via Supabase UI (Settings → Transfer Organization). Cosmetic / documentation cleanup. Not urgent.
4. **Optional later:** rename the org to "SMOrchestra Production" or similar. Cosmetic.

**What this posture does NOT cover:** if Lana set up authenticator-app 2FA (Google Authenticator on her phone) AND Supabase doesn't allow email-based recovery override, she could still log in despite Mamoun controlling email. Mitigation: do step 1 above today.

### 2.2 ⚠️ n8n smo-prod — keep ownership as-is per Mamoun (mailbox control = sufficient deterrent)

**Severity:** Downgraded from CRITICAL → optional cleanup. Mamoun's decision (2026-05-11): keep the credential ownership intact, since he controls `lana@smorchestra.com` and can password-reset her n8n login at any time. Transferring ownership of 44 credentials in the UI is tedious and offers no security gain beyond what email control already provides.

**Real risk that remains:** the underlying secret values inside these credentials. Even though she can't log in (Mamoun controls the recovery path), she likely copied the values locally during her tenure. That risk is addressed by §3 (rotation), NOT by transferring ownership.

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

**I did NOT delete or transfer any of these** — deletion would break every workflow that uses them (production damage), and per Mamoun's 2026-05-11 decision, ownership transfer is unnecessary given mailbox control.

**What you should still do (lower priority):**
1. **Defensive lockout** — log into n8n at `https://flows.smorchestra.ai` using Lana's email + your reset password. Settings → Personal → set up authenticator-app 2FA tied to YOUR device. Removes her authenticator-app fallback if she had one.
2. **Rotate the underlying secrets** per §3 — this is the real protection. The n8n credential entries will still say "owned by Lana" but the *values* will be new keys she doesn't have.
3. **Optional cleanup later:** in n8n UI, transfer each of the 44 credentials' ownership from Lana → Mamoun. Tedious (44 manual clicks). Pure documentation hygiene. Defer.
4. **Optional cleanup later:** delete Lana's n8n user account. Only do this AFTER all 44 credentials have been transferred — otherwise n8n may orphan them.

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

### 2.9 ✅ Email + identity hygiene — mailbox handled, residual cleanup remains

- ✅ **`lana@smorchestra.com` mailbox** — Mamoun took control + reset password (2026-05-11). This is the load-bearing move that downgrades most of the rest of this doc.
- ⚠️ **Removal from group aliases** — sales@, support@, team@, etc. — still TODO. With mailbox under your control, you can do this calmly.
- ⚠️ **Inbound 2FA codes / password resets currently routing to her mailbox** — review the inbox for any pending password resets she may have initiated (intent signal), and clear her notification preferences on third-party services so resets don't flood your inbox indefinitely.
- ⚠️ **Any third-party login that uses "Sign in with Google" via lana@smorchestra.com** — these need explicit revocation at each third-party. Inside her Google account (now yours): https://myaccount.google.com/permissions → revoke each.
- ⚠️ **OAuth tokens issued to apps via her Google identity** — even after revoking the Google grant, some apps cache long-lived refresh tokens. Cross-check with the §3 rotation list.

**Recommended hardening:** while you have her email + password, log into every service in this doc (Supabase, n8n, Linear, GHL, Notion, etc.) AS her, enable authenticator-app 2FA tied to YOUR phone (overriding hers if any), and add Mamoun's primary email as a recovery channel. This makes the mailbox-control posture durable against future password / 2FA tricks she might try.

---

## 3. Secrets rotation list — the main remaining risk

> **Why this section retains full urgency despite mailbox control:** locking her future logins does NOT invalidate API keys she may have copied to her personal machine during her tenure. A copied Anthropic key works from anywhere until it's rotated, regardless of whether she can still log into n8n. **This is the one thing the mailbox takeover does NOT solve. Work it down the priority list.**

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
