---
description: Launch a full Signal-to-Trust campaign from a BRD
argument-hint: [brd-file-path]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Task, AskUserQuestion
---

Launch an autonomous Signal-to-Trust GTM campaign.

If a BRD file path is provided as $1, read and parse it. Otherwise, ask the user for campaign parameters using AskUserQuestion with these questions:

1. **ICP**: Which ICP are we targeting? (MENA SaaS Founders / US Real Estate / MENA Beauty Clinics / Other)
2. **Offer**: What product/service are we selling? What's the dream outcome?
3. **Quarterly Theme**: What quarterly outcome are we hammering?
4. **Monthly Narrowing**: How should we narrow from quarterly to monthly?
5. **Silence Type**: Which silence type? (Proof / Cost / Trust / Timing / Clarity)
6. **Channels**: Which channels? (Email + LinkedIn + WhatsApp + Social — confirm which)
7. **Constraints**: Budget, start date, duration, human approval gate?

Execute the skill chain in this exact order:

**Step 1: Positioning Engine** (Mode A: Full Canvas)
- Map BRD/answers to Dunford (competitive landscape) + Brunson (narrative) + Hormozi (offer architecture)
- Output: Positioning Canvas JSON

**Step 2: Campaign Strategist** (Q→M→W→D alignment)
- Input: quarterly theme + monthly narrowing + positioning canvas
- Validate domino effect: each level derives from the one above
- Output: 3 weekly wedge strategies

**Step 3: Signal Detector** (ICP Fit + Classification)
- If prospect list provided: validate fit, classify signals as Trust/Intent
- Apply Hard Stop Rules: Fit=Fail → STOP. Signal >90 days → STOP.
- Output: validated prospects with signal taxonomy

**Step 4: Wedge Generator** (Signal → One-Sentence Wedges)
- Input: weekly strategies + validated signals
- Apply Hard Stop Rules: one-sentence test, Intent > Trust in sequence order
- Output: 3 validated wedges per week (9 total)

**Step 5: Asset Factory** (Wedges → 42 Assets)
- Produce per campaign:
  - 18 emails (6/week × 3 weeks): subject + body + CTA
  - 12 LinkedIn messages (4/week × 3 weeks): connection request + follow-ups
  - 9 WhatsApp variants (3/week × 3 weeks): initial + follow-ups
  - 3 social posts (1/week × 3 weeks): platform-ready

Save all artifacts to the workspace folder under `campaigns/[campaign-name]/`.
Create subdirectories: `week-1/`, `week-2/`, `week-3/` with assets organized by channel.

Present a summary of the complete asset bundle for review before deployment.
After approval, ask if they want to deploy using `/deploy-campaign`.
