# Daily Signal Triage SOP (15 Minutes)

## Objective
Convert Sales Navigator alerts into qualified, scored signals routed to the right channel within 24-48 hours of detection.

## Pre-Flight
- Open Chrome with LinkedIn session active
- Navigate to Sales Navigator homepage: `https://www.linkedin.com/sales/`
- Verify you're logged in and on the correct account

## Step-by-Step Execution

### Minute 0-2: Open Alerts Feed
1. Click "Alerts" or "All Alerts" on Sales Nav homepage
2. Note the total count of new alerts since last triage

### Minute 2-8: Filter and Scan
Work through alert categories in priority order:

**Priority 1 - Immediate Action Signals:**
- "Changed jobs" alerts - Lead moved companies or changed roles
- "Account raised money" - Funding events
- "Account accelerated growth" - Hiring velocity spike
- "Account merger or acquisition" - M&A activity

**Priority 2 - Warm Engagement Signals:**
- "Lead shared content" - Posted on LinkedIn (topic = conversation hook)
- "Lead viewed your profile" - Direct interest signal
- "Lead engaged with your content" - Interacted with your posts
- "Following your company" alerts

**Priority 3 - Monitoring Signals:**
- "Accounts preparing to grow" - Job postings increase
- "New decision makers" - Senior hires at saved accounts
- General account news/updates

### Minute 8-12: Qualify Each P1/P2 Signal

For each signal, run the 4-point qualification:

| Check | How to Verify | Pass/Fail |
|-------|--------------|-----------|
| ICP Fit - Industry | Account page → Industry field | Must match target verticals |
| ICP Fit - Size | Account page → Headcount | Must be in range (e.g., 51-2000) |
| ICP Fit - Geography | Account HQ or Lead geography | Must be target region |
| Role Fit | Lead title + seniority | Must be decision maker or champion |

**If all 4 pass → P1 or P2 (based on signal tier)**
**If 3 of 4 pass → P3 (monitor)**
**If <3 pass → Skip**

### Minute 12-15: Extract and Route

For each qualified signal, extract data:

```
Signal Record:
- Lead: [Full Name]
- Title: [Current Title]
- Company: [Company Name]
- LinkedIn URL: [https://www.linkedin.com/in/xxx/]
- Signal Type: [job_change | funding | growth | content_share | profile_view]
- Signal Detail: [e.g., "Moved from Acme to TechCorp as VP Sales"]
- Signal Date: [when detected]
- Priority: [P1 | P2 | P3]
- Recommended Action: [CR via HeyReach | Email via Instantly | Monitor | Deep dive]
- Message Angle: [one-line personalization hook based on signal]
```

### Routing Rules

| Priority | Signal Type | Action | Channel | Timing |
|---------|------------|--------|---------|--------|
| P1 | Job change | Outbound sequence | HeyReach CR + Instantly email (staggered 24hrs) | Today |
| P1 | Funding | Research → personalized outreach | HeyReach CR with funding reference | Within 48hrs |
| P1 | Growth spike | Account deep dive → multi-thread | Map committee first, then sequence | Within 1 week |
| P2 | Content share | Engage post → then CR | LinkedIn engagement first, CR next day | Today (engage) |
| P2 | Profile view | Direct CR | HeyReach or manual CR | Same day |
| P2 | Senior hire | Save + add to watchlist | Monitor for 1-2 weeks, then outreach | Week |
| P3 | Any | Bookmark in Sales Nav | Review next week | Next triage |

## Post-Triage Housekeeping
1. Clear processed alerts from feed
2. Update CRM tags if leads are already in GHL
3. Note any new patterns in `learnings-log.md`
4. If bookmarks >50, run cleanup (move old ones to lists or delete)

## Weekly Triage Summary (Friday/end of week)
Compile weekly stats:
- Total alerts processed
- P1 signals detected → outbound sequences launched
- P2 signals detected → monitoring added
- Response rates from previous week's P1 outreach
- Which signal types produced best meetings
