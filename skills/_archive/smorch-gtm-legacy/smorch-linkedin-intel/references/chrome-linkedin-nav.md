# Chrome Navigation Patterns for LinkedIn (Non-Sales Navigator)

## Core LinkedIn URLs

| Destination | URL | Notes |
|------------|-----|-------|
| Feed / Home | `https://www.linkedin.com/feed/` | Main content feed |
| Profile (own) | `https://www.linkedin.com/in/me/` | Redirects to your profile |
| Profile (other) | `https://www.linkedin.com/in/[username]/` | Target profile |
| Profile Activity | `https://www.linkedin.com/in/[username]/recent-activity/` | All activity |
| Profile Posts | `https://www.linkedin.com/in/[username]/recent-activity/all/` | Posts only |
| Company Page | `https://www.linkedin.com/company/[slug]/` | Company overview |
| Company Posts | `https://www.linkedin.com/company/[slug]/posts/` | Company content |
| Company People | `https://www.linkedin.com/company/[slug]/people/` | Employee directory |
| Search (General) | `https://www.linkedin.com/search/results/all/?keywords=[query]` | Universal search |
| Search (Posts) | `https://www.linkedin.com/search/results/content/?keywords=[query]` | Content search |
| Search (People) | `https://www.linkedin.com/search/results/people/?keywords=[query]` | People search |
| Notifications | `https://www.linkedin.com/notifications/` | All notifications |
| Messaging | `https://www.linkedin.com/messaging/` | Inbox |

## Navigation with Claude in Chrome

### Profile Deep Dive Sequence
```
1. Navigate to profile URL
2. Wait 3-5 seconds
3. read_page → capture header section (name, title, location)
4. Scroll down using scroll action
5. read_page → capture About section
6. Continue scrolling → Experience section
7. read_page → capture roles
8. find "Activity" or "Show all activity" → click
9. Wait 3 seconds
10. read_page → capture recent posts
```

### Activity Feed Analysis
```
1. Navigate to profile activity URL
2. read_page → capture first batch of posts
3. For each post visible:
   a. Extract: date, text preview, engagement count
   b. If full text needed: find "see more" → click
   c. read_page → capture full post text
4. Scroll down for more posts
5. Repeat until 10-15 posts analyzed or no more content
```

### Company Page Analysis
```
1. Navigate to company page URL
2. read_page → capture company overview (about, employee count, industry)
3. find "Posts" tab → click
4. read_page → capture recent company posts
5. Optionally: find "People" tab → click
6. read_page → analyze employee list (if accessible)
```

### Content Search (Topic Tracking)
```
1. Navigate to content search URL with keywords
2. read_page → capture search results
3. For each relevant post:
   a. Extract: author name, title, company, post text, engagement
   b. Click author name to check profile (quick scan)
   c. Navigate back to search results
4. Filter by date if available (use "Recent" sort)
5. Process 10-20 results per search
```

## Element Finding Strategies

### Finding Key Profile Elements
- **Name**: Usually the first heading element on profile page
- **Title/Headline**: Second heading or first description element
- **About section**: Look for "About" heading, content follows
- **Experience**: Look for "Experience" heading, list items follow
- **Activity**: Look for "Activity" link or "Show all activity" button
- **Connection degree**: Usually near the name, shows "1st", "2nd", "3rd"
- **Mutual connections**: Link showing "X mutual connections"

### Finding Post Elements
- **Post text**: Main content block within feed items
- **Author**: Name link at top of each post card
- **Date**: Relative time stamp (e.g., "2d", "1w") near author name
- **Engagement count**: Likes/reactions count below post
- **Comments count**: Comment icon with count
- **"see more" button**: Expands truncated post text

### Finding Company Elements
- **Company name**: Main heading on company page
- **Employee count**: Usually in overview section
- **Industry**: In company details
- **Posts tab**: Tab navigation on company page
- **People tab**: Tab navigation on company page

## Error Handling

### "Profile not available"
- Profile may be private or outside your network
- Note as "limited access" in research output
- Try company page instead for indirect intel

### "Content not available" on activity feed
- Some profiles hide their activity
- Try searching for their name in content search instead
- Check if they have a "Creator" badge (creators' content is always visible)

### Login redirect / session expired
- Stop immediately
- Alert user to log in manually
- Never attempt credential entry

### Rate limiting indicators
- Slow page loads (>10 seconds)
- "Something went wrong" errors
- CAPTCHA or verification prompts
- Repeated redirects to login page

Response: Stop session, wait 15+ minutes, reduce remaining scope

## Data Extraction Tips

### Profile Language Detection
LinkedIn doesn't always explicitly show profile language. Detect by:
- Language of headline/title
- Language of About section
- Language of recent posts
- URL locale prefix (rarely reliable)

### Connection Degree Importance
- 1st degree: Can message directly, highest trust baseline
- 2nd degree: Mutual connections visible, warm path available
- 3rd degree: Limited visibility, may need InMail or email
- "Out of network": Very limited, search only via Sales Navigator

### Screenshot Best Practices
- Use `screenshot` action to capture evidence of signals
- Screenshot profile headers for record keeping
- Screenshot relevant posts before they disappear
- Name screenshots: `[name]-[type]-[date].png`
- Store in session directory for reference

## Session Logging
After each LinkedIn browsing session:
```
Session: [date] [start-end time]
Profiles researched: [count]
Content analyzed: [count of posts]
Signals found: [count and types]
Issues: [any UI changes, errors, rate limits]
Time per profile: [average minutes]
```
