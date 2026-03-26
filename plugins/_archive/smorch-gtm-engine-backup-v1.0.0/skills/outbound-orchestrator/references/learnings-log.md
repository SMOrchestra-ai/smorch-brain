# Learnings Log — Outbound Orchestrator

## Format
Each entry: `[YYYY-MM-DD] CATEGORY: Learning | Source: [how discovered] | Action: [what changed]`

Categories: CHANNEL_MIX, TIMING, SCORING, MARKET, PATTERN, TOOLING, DEDUP

---

## Entries

### [2026-02-22] TOOLING: Initial infrastructure state discovered
**Source:** MCP discovery during skill creation
**Finding:**
- Instantly: 8 sending accounts (7 active, 1 paused), 13 campaigns (8 active, 2 draft, 3 stopped)
- HeyReach: 1 LinkedIn sender account (Sura Abdulaziz, ID 140055, currently inactive), 17 campaigns
- GHL: Active, connected via mcp__ghl-mcp__
- HeyReach single-sender limits multi-channel LinkedIn volume significantly
**Action:** Skill written to handle single-sender gracefully; scaling recommendations will flag need for additional LinkedIn accounts

### [2026-02-22] TOOLING: HeyReach webhook endpoint discrepancy
**Source:** MCP discovery — existing webhook points to `devflow.smorchestra.ai`, skill references `ai.mamounalamouri.smorchestra.com`
**Finding:** Two different n8n endpoints in use. Need user to confirm which is current production endpoint.
**Action:** Skill defaults to `ai.mamounalamouri.smorchestra.com` per user spec. Logged for verification.
