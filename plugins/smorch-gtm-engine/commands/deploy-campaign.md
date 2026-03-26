---
description: Deploy approved campaign assets to Instantly, HeyReach, and GHL
argument-hint: "[campaign-name]"
allowed-tools: Read, Write, Bash, Grep, Glob, Task, AskUserQuestion
---

Deploy approved campaign assets to execution platforms using operator skills.

**Argument:** `$1` — Campaign name (matches folder in `campaigns/`)

**Pre-Deployment Checks:**

1. Verify all assets exist and are marked as reviewed/approved
2. Verify lead list is loaded and ICP-validated
3. Run collision prevention protocol (outbound-orchestrator):
   - Check 1: Opt-out / unsubscribe list
   - Check 2: Recent reply (no outreach within 7 days of reply)
   - Check 3: Recent touch (no same-channel touch within 3 days)
   - Check 4: Cross-channel dedup (no LinkedIn + email + WhatsApp on same day)
   - Check 5: Meeting already booked (exclude from outreach)
   - Check 6: Company-level limit (max 3 contacts per company per week)
   - Check 7: Ramadan/holiday calendar (adjust sending for MENA)
   - Check 8: PDPL/privacy compliance check

**Deployment Flow:**

Ask which channels to deploy (default: all that have assets):

**Email → Instantly** (via instantly-operator)
- Create campaign in Instantly with proper naming: `[campaign-name]-week-[N]`
- Set email sequences (step 1 → step 2 → step 3 with delays)
- Upload A/B variants for subject line testing
- Add validated leads to campaign
- Set sending schedule: Sun-Thu for MENA, Mon-Fri for US, 8AM-4PM local
- Set daily limit per sending account
- Ask: activate now or leave paused?

**LinkedIn → HeyReach** (via heyreach-operator)
- Create campaign: `[campaign-name]-LI-week-[N]`
- Set sequence: connection request → follow-up 1 (48h) → follow-up 2 (72h) → follow-up 3 (96h)
- Assign sender accounts with rotation
- Add leads with LinkedIn profile URLs
- Set daily connection limit per sender
- Configure: withdraw pending connections after 14 days, stop on reply

**WhatsApp → GHL** (via ghl-operator)
- Add contacts to GHL if not already present
- Tag contacts with campaign tags for workflow triggering
- Create/activate WhatsApp workflow: tag-triggered → send message → wait → follow-up
- Only for contacts marked `whatsapp_eligible: true`

**Social → GHL Scheduler** (via ghl-operator)
- Schedule social posts via GHL social planner
- Set posting time: Wednesday 10 AM Dubai time (or user preference)
- Channels: LinkedIn company page + Twitter

**Post-Deployment:**
- Log all deployment IDs to `campaigns/$1/deployment-log.json`
- Update campaign status to ACTIVE
- Set monitoring schedule reminder
- Confirm: "Campaign deployed to [N] channels. [X] leads in pipeline. First sends begin [date]."
