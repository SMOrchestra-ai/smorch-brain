---
description: Run weekly campaign performance review with optimization recommendations
allowed-tools: Read, Write, Bash, Grep, Glob, Task, AskUserQuestion
---

Run a weekly performance review across all active campaigns.

**Step 1: Identify Active Campaigns**
- Scan workspace `campaigns/` directory for active campaigns
- If no campaigns found, check with the user for campaign locations

**Step 2: Collect Metrics**
For each active campaign, gather metrics from all channels:

- **Email (Instantly)**: Use instantly-operator to pull: sent, delivered, opened, open rate, clicked, replied, reply rate, bounced, unsubscribed
- **LinkedIn (HeyReach)**: Use heyreach-operator to pull: sent, accepted, acceptance rate, replied, reply rate, profile views
- **WhatsApp (GHL)**: Use ghl-operator to pull: sent, delivered, read, replied
- **Social (GHL)**: Use ghl-operator to pull: impressions, likes, comments, shares, clicks

**Step 3: Build Performance Summary**
Create a structured analysis:

- Per-channel metrics with week-over-week trends
- Funnel view: signals detected → fit pass → outreach sent → replies → meetings booked
- Channel comparison: which channel has highest reply rate, best cost per reply
- Asset performance: which specific emails/messages are performing best (and worst)
- Signal attribution: which signal types are converting to replies and meetings

**Step 4: Generate Recommendations**
Produce actionable recommendations in these categories:

- **Wedge Rotation**: Which wedge angles are working? Should we double down or rotate?
- **Channel Rebalance**: Should we shift volume between channels based on performance?
- **Signal Focus**: Which signal types should we monitor more/less aggressively?
- **Asset Swap**: Which underperforming assets should be replaced? With what angle?
- **Volume Adjustment**: Should we increase or decrease sending volume?

**Step 5: Present and Execute**
- Present dashboard summary + ranked recommendations
- Ask which recommendations to implement
- For approved recommendations, execute the changes:
  - Update campaign configs
  - Regenerate assets if wedge rotation approved
  - Adjust platform settings via operator skills

Save the weekly review report to `campaigns/[campaign-name]/reviews/week-[N]-review.md`.
