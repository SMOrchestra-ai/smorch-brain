# Lana Offboarding — Access Audit (BEFORE removal)

**Date:** 2026-05-11
**Triggered by:** lana@smorchestra.com left the company; 2FA prevents pw change so org/repo access must be revoked instead.
**GitHub username:** lanaalkurdsmo (account created 2025-04-13)

## Access surfaces (BEFORE removal)

### Org membership
- SMOrchestra-ai: member

### Team memberships
- SMOrchestra-ai/engineering: active
- SMOrchestra-ai/reviewers: active

### Direct repo collaborator (18 repos)

| Repo | Permission |
|---|---|
| SMOrchestra-ai/Signal-Sales-Engine | admin |
| SMOrchestra-ai/smorch-dev | admin |
| SMOrchestra-ai/eo-onboarding | admin |
| SMOrchestra-ai/eo-founding-offer | read |
| SMOrchestra-ai/EO-Scorecard-Platform | read |
| SMOrchestra-ai/eo-scoring-service | read |
| SMOrchestra-ai/eo-mena | read |
| SMOrchestra-ai/contabo-mcp-server | admin |
| SMOrchestra-ai/smorch-brain | read |
| SMOrchestra-ai/smorchestra-web | admin |
| SMOrchestra-ai/smorch-context | read |
| SMOrchestra-ai/content-automation | read |
| SMOrchestra-ai/eo-template-basic | read |
| SMOrchestra-ai/SaaSFast | read |
| SMOrchestra-ai/gtm-fitness-scorecard | admin |
| SMOrchestra-ai/digital-revenue-score | admin |
| SMOrchestra-ai/super-ai-agent | read |
| SMOrchestra-ai/smorch-dist | read |
| alamouri99/SaaSfast-ar | not-collab |

### Pending invitations
- None

### Outside collaborators
- None

---

## Removal actions executed (22 API calls)

All performed via `gh api -X DELETE` from account `smorchestraai-code` (admin:org scope).

| # | Action | Target | Result |
|---|---|---|---|
| 1-18 | Remove direct collaborator | All 18 SMOrchestra-ai repos | ✓ 204 No Content (each) |
| 19 | Remove direct collaborator | smorchestraai-code/SaaSfast-ar | ✓ 204 No Content |
| 20 | Remove team membership | SMOrchestra-ai/engineering | ✓ 204 No Content |
| 21 | Remove team membership | SMOrchestra-ai/reviewers | ✓ 204 No Content |
| 22 | Remove org membership | SMOrchestra-ai | ✓ 204 No Content |

## Verification (AFTER state)

- **Org membership** `GET /orgs/SMOrchestra-ai/memberships/lanaalkurdsmo` → `404 Not Found` ✓
- **All 7 teams** `GET /orgs/SMOrchestra-ai/teams/{slug}/memberships/lanaalkurdsmo` → `404 Not Found` ✓
- **All 18 org repo collaborator lists** → lanaalkurdsmo not present ✓
  - Public repos may report `permission: read` for any user (GitHub's public-readability default); confirmed via control test with `octocat` returning same `read` → not a real grant.
- **smorchestraai-code/SaaSfast-ar** collaborator list → lanaalkurdsmo not present ✓
- **Pending invites** → none for lanaalkurdsmo ✓
- **Org member list** → only `smorchestraai-code` remains ✓

## Out of scope (Mamoun needs to address separately)

GitHub access is now fully revoked, but a complete offboarding requires:

1. **Secrets rotation** — Lana likely had local copies of `.env` files / API keys for: FIRECRAWL_API_KEY, GHL_API_KEY (SalesMfast SME location), Supabase service-role keys, Anthropic API key, n8n credentials, Resend, Stripe. Per SOP-16, rotate all of these.
2. **SSH key audit** on the 4 SMO servers (smo-dev, smo-prod, eo-prod, eo-dev) — check `/root/.ssh/authorized_keys` and any per-user `~/.ssh/authorized_keys` for Lana's public key fingerprint(s).
3. **Linear** org membership — remove lana@smorchestra.com.
4. **GoHighLevel** — remove Lana as a user from the SalesMfast SME location (and any other GHL location).
5. **n8n** credentials — Lana may have credentials owned in n8n workflows; audit `flows.smorchestra.ai` and `testflow.smorchestra.ai`.
6. **Notion / Slack / Telegram / WhatsApp** business channels — remove from groups.
7. **Domain registrar / Cloudflare / Contabo control panel** — if Lana had access, revoke.
8. **Email** — `lana@smorchestra.com` mailbox: forward + archive + remove from any group aliases.
9. **SOP-13 (Lana Handover Protocol)** — this SOP is named for Lana's QA handover role. Either rename or repoint to the new QA owner.
10. **Lessons file** — capture L-NN "Offboarding checklist" so future departures have a 30-min runbook.

This audit covers item 1 only. The rest is on Mamoun.
