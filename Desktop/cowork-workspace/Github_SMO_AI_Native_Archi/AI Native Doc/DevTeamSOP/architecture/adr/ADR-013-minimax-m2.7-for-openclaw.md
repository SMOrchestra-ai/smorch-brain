# ADR-013: Dual OpenClaw Gateway — Model Strategy

**Status:** ACCEPTED (UPDATED 2026-04-01)
**Date:** 2026-03-30 (updated 2026-04-01)
**Decision Maker:** Mamoun Alamouri

## Context

smo-brain runs two separate OpenClaw gateways with different model strategies:
- **Sulaiman (Chat):** Personal Telegram assistant, conversation, general queries
- **al-Jazari ChiefEng / al-Jazari (Coding):** Coding orchestration, Paperclip agent routing, BRD decomposition

MiniMax M2.7's superpower is agentic orchestration — ideal for coding task routing. GPT-5.4 via OAuth is the strongest conversational model available — ideal for Sulaiman's Telegram persona.

## Decision

**Two isolated gateways, each with model strategy matched to purpose.**

### Gateway Model Configuration

| | **Sulaiman (Chat — port 18789)** | **al-Jazari ChiefEng (Coding — port 18790)** |
|---|---|---|
| **Primary** | `openai-codex/gpt-5.4` (OAuth) | `minimax/MiniMax-M2.7` (API key) |
| **Fallback** | `google/gemini-3.1-pro` | `google/gemini-3-pro-preview`, `openai-codex/gpt-5.4` (OAuth) |
| **Heartbeat** | `google/gemini-2.5-flash-lite` | `google/gemini-2.5-flash-lite` |
| **Telegram bot** | `@SulaimanMoltbot` | `@al_Jazari_ChiefEng_bot` |
| **Config path** | `/root/.openclaw/openclaw.json` | `/opt/openclaw/coding/config/openclaw.json` |
| **State dir** | `/root/.openclaw/` | `/opt/openclaw/coding/state/` |
| **Systemd** | `openclaw-chat.service` | `openclaw-coding.service` |
| **MiniMax key** | No | Yes (exclusive) |

### Why MiniMax M2.7 for Coding Gateway

1. **Agentic orchestration strength:** MiniMax M2.7 excels at tool use, structured output, multi-step reasoning — exactly what BRD decomposition and task routing need.
2. **Cost:** $0.71/month for 500+ orchestration calls. Essentially free.
3. **Independence:** Own API key, own rate limits. No interference with Claude Code or Sulaiman OAuth.
4. **Fallback to GPT-5.4:** If MiniMax fails, coding gateway falls back to GPT-5.4 (strong but shares OAuth).

### Why GPT-5.4 for Chat Gateway

1. **Conversational quality:** GPT-5.4 is the strongest conversational model for Sulaiman's Arabic+English persona.
2. **OAuth included:** No additional API cost — uses existing subscription.
3. **Fallback to Gemini 3.1 Pro:** If GPT-5.4 rate-limited, falls back to Gemini 3.1 Pro (Google API key — allowed per auth exception).

### Pricing

| Model | Input/1M tokens | Output/1M tokens | Est. Monthly | Used By |
|-------|-----------------|-------------------|-------------|---------|
| MiniMax M2.7 | $0.30 | $1.20 | ~$0.71 | al-Jazari primary |
| GPT-5.4 (Codex) | OAuth included | OAuth included | $0 | Sulaiman primary, al-Jazari fallback |
| Gemini 3.1 Pro | API key (Google exception) | API key | $0 (free tier) | Sulaiman fallback |
| Gemini 3 Pro Preview | API key (Google exception) | API key | $0 (free tier) | al-Jazari fallback |
| Gemini 2.5 Flash Lite | Free tier | Free tier | ~$0 | Both heartbeats |

### Isolation Architecture

```
smo-brain (100.89.148.62)
├── openclaw-chat.service (Sulaiman)
│   ├── port 18789 (gateway)
│   ├── port 18791 (browser control)
│   ├── /root/.openclaw/ (config + state)
│   └── @SulaimanMoltbot (Telegram)
│
├── openclaw-coding.service (al-Jazari ChiefEng / al-Jazari)
│   ├── port 18790 (gateway)
│   ├── port 18792 (browser control)
│   ├── /opt/openclaw/coding/ (config + state + workspace)
│   └── @al_Jazari_ChiefEng_bot (Telegram)
│
└── Both use /root/moltbot binary (same runtime, isolated configs)
```

## Consequences

### Positive
- Each gateway has model optimized for its purpose
- No state bleed between chat and coding
- MiniMax cost isolated to coding gateway only
- Sulaiman unaffected by coding gateway changes
- Can later move coding gateway to separate server if load justifies

### Negative
- Two services to monitor (mitigated: both systemd with auto-restart)
- Two Telegram bots to maintain
- Shared `/root/moltbot` binary — updates affect both (mitigated: plan to migrate to official CLI later)
