---
description: Show cross-platform campaign metrics dashboard
argument-hint: [campaign-name]
allowed-tools: Read, Write, Bash, Grep, Glob, Task
---

Build and display a campaign performance dashboard with cross-platform metrics.

**Argument:** `$1` — Campaign name. If omitted, show an overview of all active campaigns.

**Data Collection:**

Pull metrics from all active channels:

- **Instantly** (via instantly-operator): campaign analytics — sent, delivered, opens, open rate, clicks, replies, reply rate, bounces, unsubscribes
- **HeyReach** (via heyreach-operator): campaign analytics — connection requests sent, accepted, acceptance rate, messages sent, replies, reply rate
- **GHL** (via ghl-operator): conversation stats — WhatsApp sent/delivered/read/replied, social post impressions/likes/comments/shares/clicks, pipeline data — opportunities created, stage progression, meetings booked
- **Cross-reference**: Match replies back to originating signals for attribution

**Dashboard Sections:**

1. **Campaign Health Summary**
   - Status: ACTIVE / PAUSED / COMPLETED
   - Duration: Week X of Y
   - Budget spent vs allocated
   - Overall conversion: signals → meetings → pipeline

2. **Channel Performance Cards**
   - Email: sent, open rate, reply rate, meetings from email
   - LinkedIn: sent, acceptance rate, reply rate, meetings from LinkedIn
   - WhatsApp: sent, read rate, reply rate, meetings from WhatsApp
   - Social: posts, engagement rate, click-through rate

3. **Funnel Visualization**
   - Signals Detected → Fit Pass → Outreach Sent → Replies → Meetings → Pipeline Value
   - Show conversion rate at each stage
   - Highlight bottlenecks (where drop-off is highest)

4. **Weekly Trend Charts**
   - Reply rate by channel over weeks
   - Meeting rate over weeks
   - Signal volume trend
   - Best performing day of week

5. **Signal Attribution**
   - Which signal types are producing the most replies?
   - Which signal types lead to meetings?
   - Signal → Channel → Outcome mapping

6. **Asset Performance**
   - Best performing email (subject line + open rate + reply rate)
   - Best performing LinkedIn message
   - Worst performers (candidates for replacement)

**Output:**
- Generate as a React (.jsx) or HTML artifact with charts (use Recharts or Chart.js)
- Also save as `campaigns/$1/dashboards/dashboard-[date].html`
- If no campaign data available, show template with sample data and instructions
