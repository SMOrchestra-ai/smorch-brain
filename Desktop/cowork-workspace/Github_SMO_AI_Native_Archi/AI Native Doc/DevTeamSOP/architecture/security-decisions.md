# Security Decisions Register

**System:** SMOrchestra AI-Native Organization on Paperclip
**Owner:** Mamoun Alamouri
**Last Updated:** 2026-03-30
**Next Full Review:** 2026-06-29

---

## SD-001: dangerouslySkipPermissions Required on All Agents

**Decision:** Accept `dangerouslySkipPermissions: true` on all Paperclip agents as a platform requirement.

**Risk Level:** HIGH (accepted)

**Analysis:**
Paperclip's `claude_local` adapter runs Claude Code in `--print` mode (non-interactive, headless). In this mode, Claude Code cannot prompt the user for tool-use permissions. Without `--dangerously-skip-permissions`, the agent would block on every file read, write, or bash command, making it non-functional.

This was verified by reading the adapter source at:
`paperclip/packages/adapters/claude-local/src/server/execute.ts`
- Line 407: `--print` is always passed (unconditional)
- Line 409: `--dangerously-skip-permissions` is passed when config flag is true
- These are independent flags, but `--print` mode is non-interactive, so permission prompts cannot be answered

**What this means:** Every agent (CEO, VP Engineering, DevOps, QA Lead, Content Lead, GTM Specialist, Data Engineer) can read/write any file accessible to the OS user running Paperclip, and execute arbitrary bash commands without approval.

**Mitigation:**
1. Paperclip runs under a single OS user (`mamounalamouri`). Agents cannot escalate beyond that user's permissions.
2. Agent instructions (role files in `AI-Native-Org/roles/`) constrain each agent's intended scope. This is a soft boundary (prompt-based), not a hard boundary (OS-enforced).
3. Paperclip runs locally on `localhost:3100` -- not exposed to the network (see SD-002).
4. OAuth subscription auth is used instead of API keys, so there are no stored credentials for agents to exfiltrate (see SD-004).
5. Each agent has `maxTurnsPerRun: 50` limiting the blast radius of a single run.

**What would make this better (future):**
- Paperclip or Claude Code adding per-agent allowlists for filesystem paths and tool access
- Running agents in separate OS user accounts or containers with restricted filesystem access
- Claude Code supporting a "print mode with allowlist" that permits specific tools without blanket skip

**Review Date:** 2026-06-29

---

## SD-002: Paperclip API Authentication (UPDATED 2026-03-30)

**Decision:** Use Paperclip OAuth authentication mode. Bind to Tailscale IP only.

**Risk Level:** LOW (improved from MEDIUM)

**Analysis:**
Per ADR-012, Paperclip now runs on smo-brain (100.89.148.62:3100), bound to the Tailscale IP. Authentication mode is set to `oauth` (NOT `local_trusted`). Only Tailscale mesh nodes can reach the API.

**Mitigation:**
1. Paperclip binds to Tailscale IP `100.89.148.62` -- not public internet, not `0.0.0.0`.
2. Authentication mode is `oauth` -- requires valid session token for API access.
3. iptables firewall on smo-brain drops all non-Tailscale, non-SSH traffic.
4. Tailscale mesh is encrypted and authenticated.

**Residual Risk:**
- Any compromised Tailscale node could access the API (currently: smo-brain, smo-dev, desktop).
- If Tailscale auth is compromised, attacker could reach Paperclip.

**Review Date:** 2026-06-29

---

## SD-003: Authentication Model -- OAuth Only, No API Keys

**Decision:** Use Anthropic OAuth subscription authentication exclusively. No API keys stored.

**Risk Level:** LOW

**Analysis:**
The `.env` file at `~/.paperclip/instances/default/.env` contains:
- `PAPERCLIP_AGENT_JWT_SECRET` -- used for internal agent JWT signing (required)
- `ANTHROPIC_API_KEY` -- removed/commented out
- `OPENAI_API_KEY` -- removed/commented out

Agents authenticate to Anthropic via OAuth subscription (Claude Pro/Team plan), not via API keys. This means:
- No API keys to leak or rotate
- Usage is billed through the subscription, with natural cost caps
- No risk of a stolen key being used to run up API bills

**Mitigation:**
1. JWT secret is a random 256-bit hex value -- sufficient entropy.
2. The `.env` file is in a user-owned directory with standard permissions.
3. API key lines are commented with clear notes explaining the decision.

**Review Date:** 2026-09-29

---

## SD-004: Secrets Management

**Decision:** Minimize stored secrets. Only the Paperclip JWT secret is stored on disk.

**Risk Level:** LOW

**Analysis:**
Secrets inventory for the Paperclip instance:
| Secret | Location | Purpose | Risk |
|--------|----------|---------|------|
| `PAPERCLIP_AGENT_JWT_SECRET` | `~/.paperclip/instances/default/.env` | Internal JWT signing for agent auth | Medium -- compromise allows forging agent identity within Paperclip |
| OAuth session tokens | Browser cookies / in-memory | Anthropic API access | Low -- ephemeral, expire automatically |

No API keys, no database passwords (embedded Postgres with local socket auth), no cloud credentials stored.

**Mitigation:**
1. The `.env` file should have `600` permissions (owner read/write only). Verify with `ls -la ~/.paperclip/instances/default/.env`.
2. The JWT secret should be rotated if the machine is compromised.
3. No secrets are committed to the Git repository.

**Review Date:** 2026-09-29

---

## SD-005: Network Exposure (UPDATED 2026-03-30)

**Decision:** Services run on Tailscale mesh or localhost only. No public internet exposure.

**Risk Level:** LOW

**Analysis:**
Services and their network bindings on smo-brain:
| Service | Binding | Port | External Access |
|---------|---------|------|-----------------|
| Paperclip Server | 100.89.148.62 (Tailscale) | 3100 | Tailscale mesh only |
| OpenClaw Chat (Sulaiman) | 100.89.148.62 (Tailscale) | 18789 | Tailscale mesh only |
| OpenClaw Coding (al-Jazari ChiefEng) | 100.89.148.62 (Tailscale) | 18790 | Tailscale mesh only |
| n8n | 127.0.0.1 | 5678 | localhost only |
| Embedded PostgreSQL (Paperclip) | Unix socket | 54329 | No |
| PostgreSQL (n8n) | 127.0.0.1 | 5432 | localhost only |
| Redis | 127.0.0.1 | 6379 | localhost only |

**Mitigation:**
1. iptables on smo-brain: allow Tailscale + SSH + localhost, drop all else.
2. Paperclip and both OpenClaw gateways bind to Tailscale IP -- not public internet.
3. Each gateway has its own auth token, state dir, and workspace -- no state bleed.
4. Desktop accesses Paperclip UI via Tailscale (encrypted tunnel).

**Review Date:** 2026-09-29

---

## Threat Model: AI Agent Compromise

### What is an "agent compromise"?
An agent executing unintended actions due to prompt injection, instruction manipulation, or a bug in the orchestration layer.

### Attack Vectors

| # | Vector | Likelihood | Impact | Mitigation |
|---|--------|-----------|--------|------------|
| T1 | **Prompt injection via task content** -- A Linear issue or external input contains instructions that override agent behavior | Medium | High -- agent could read/write arbitrary files, exfiltrate data via bash commands | Agent instructions are appended as system prompts (higher priority). Claude's training resists prompt injection. However, no hard sandbox exists. |
| T2 | **Malicious skill injection** -- A compromised or malicious skill file is loaded | Low | High -- skill runs with full agent permissions | Skills are loaded from the local filesystem only (`AI-Native-Org/roles/` and Paperclip skills directory). No remote skill loading. Review all skill changes. |
| T3 | **Agent-to-agent escalation** -- One agent manipulates another via Paperclip task delegation | Low | Medium -- could cause unintended cross-agent actions | All agents report to CEO. Task routing goes through Paperclip's coordination layer. No direct agent-to-agent command execution. |
| T4 | **Local API abuse** -- Malware or rogue process calls Paperclip API to trigger agent runs with attacker-controlled prompts | Low | High -- could execute arbitrary code via agent | Localhost-only binding. Keep machine clean. Monitor for unexpected agent runs in Paperclip logs. |
| T5 | **Data exfiltration via agent bash access** -- Compromised agent uses bash to curl data to external server | Low | Critical -- could exfiltrate any file the OS user can read | No outbound network restrictions on agents currently. Future: add egress filtering or network policy. Monitor agent run logs for unexpected network calls. |
| T6 | **Supply chain via Paperclip update** -- A Paperclip update introduces a vulnerability | Very Low | High | Pin Paperclip version. Review changelogs before updating. |

### Blast Radius of a Single Compromised Agent

If one agent is compromised, it can:
- Read/write any file owned by the OS user (home directory, code repos, SSH keys, browser data)
- Execute any bash command (install software, make network requests, modify other agent instructions)
- Access the Paperclip API (create/delete agents, trigger other agent runs)

It CANNOT:
- Escalate to root (no sudo without password)
- Access other user accounts on the machine
- Persist beyond the agent run (no cron jobs unless explicitly created via bash)

### Recommended Monitoring

1. **Review agent run logs weekly** at `~/.paperclip/instances/default/logs/`
2. **Check for unexpected file modifications** in sensitive directories (`.ssh/`, `.env` files)
3. **Monitor Paperclip agent creation** -- unexpected new agents may indicate T4
4. **Audit agent instructions** before and after any changes -- diff against `AI-Native-Org/roles/` source of truth

---

## Decision Log

| Date | Decision | Author |
|------|----------|--------|
| 2026-03-29 | Initial security decisions register created | Mamoun Alamouri |
| 2026-03-29 | Accepted dangerouslySkipPermissions as platform requirement (SD-001) | Mamoun Alamouri |
| 2026-03-29 | Accepted unauthenticated localhost API (SD-002) | Mamoun Alamouri |
| 2026-03-29 | Confirmed OAuth-only auth, no API keys (SD-003) | Mamoun Alamouri |
| 2026-03-29 | Documented secrets inventory (SD-004) | Mamoun Alamouri |
| 2026-03-29 | Confirmed localhost-only network exposure (SD-005) | Mamoun Alamouri |
| 2026-03-30 | Updated SD-002: Paperclip moved to smo-brain with OAuth auth (ADR-012) | Mamoun Alamouri |
| 2026-03-30 | Updated SD-005: Network bindings for smo-brain deployment | Mamoun Alamouri |
| 2026-03-31 | Updated SD-005: Dual OpenClaw gateways (Chat:18789 + Coding:18790) | Mamoun Alamouri |
