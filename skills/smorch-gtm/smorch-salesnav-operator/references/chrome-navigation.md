# Chrome Navigation Patterns for Sales Navigator

## Important: Browser Safety First

Before any navigation session:
1. Confirm LinkedIn session is active (check for profile icon in top-right)
2. Set mental timer: max 45 minutes per session
3. Plan your actions before starting - know what you're extracting before you click

## Core URLs

| Destination | URL | Notes |
|------------|-----|-------|
| Sales Nav Home | `https://www.linkedin.com/sales/` | Dashboard + alerts feed |
| Lead Search | `https://www.linkedin.com/sales/search/people` | Advanced lead filters |
| Account Search | `https://www.linkedin.com/sales/search/company` | Company-level search |
| All Alerts | `https://www.linkedin.com/sales/alerts` | Signal triage starting point |
| Saved Searches | `https://www.linkedin.com/sales/search/saved-searches` | Manage saved searches |
| Lead Lists | `https://www.linkedin.com/sales/lists/people` | Manage lead lists |
| Account Lists | `https://www.linkedin.com/sales/lists/company` | Manage account lists |
| Personas | `https://www.linkedin.com/sales/personas` | Configure personas |
| Inbox | `https://www.linkedin.com/sales/inbox` | InMail and messages |

## Navigation Approach with Claude in Chrome

Claude in Chrome uses accessibility tree reading (`read_page`) and element finding (`find`) to interact with Sales Navigator. Key principles:

### Reading the Page
- Use `read_page` to get the accessibility tree of the current view
- Filter with `filter: "interactive"` when looking for buttons, inputs, dropdowns
- Use `find` with natural language queries for specific elements

### Clicking Elements
- Always use `ref` from `read_page` or `find` results for reliable clicking
- Prefer `ref`-based clicks over coordinate-based clicks
- Wait 2-3 seconds after each click for page state to settle

### Form Inputs
- Use `form_input` for dropdowns, checkboxes, text fields
- For Boolean search fields: type the full Boolean string, don't try to build it character by character
- After entering search criteria, wait 3-5 seconds for results to update

## Common Navigation Sequences

### Sequence 1: Daily Alert Triage
```
1. Navigate to: https://www.linkedin.com/sales/alerts
2. read_page → identify alert categories/tabs
3. Click on each category tab (Lead alerts, Account alerts)
4. For each alert:
   a. read_page → extract alert text (signal type, lead name, company)
   b. Click alert to expand details
   c. Screenshot the alert for evidence
   d. Click lead name to open profile (if P1/P2 signal)
   e. Extract profile data
   f. Navigate back to alerts feed
5. Pace: 3-5 seconds between actions
```

### Sequence 2: Lead Search Execution
```
1. Navigate to: https://www.linkedin.com/sales/search/people
2. read_page → identify filter panels
3. Apply filters in order:
   a. Geography → find geography input → type country → select from dropdown
   b. Seniority → find seniority filter → check boxes (VP, CXO, Director)
   c. Function → find function filter → check boxes
   d. Current title → find title Boolean input → type Boolean string
   e. Spotlight → find spotlight section → check desired filter
4. Wait 5 seconds for results to load
5. read_page → extract result count
6. If >2,500: add more filters
7. Screenshot the search configuration
8. Process results page by page (max 100 pages for leads)
```

### Sequence 3: Profile Data Extraction
```
1. From search results, click lead name
2. Wait 3-5 seconds for profile to load
3. read_page → extract:
   - Full name
   - Current title and company
   - Location
   - Connection degree
   - Profile language (check page language attribute or content language)
   - Recent activity summary (if visible)
4. Screenshot profile header for evidence
5. Navigate back to search results
6. Pace: wait 3 seconds before next profile
```

### Sequence 4: Save Lead to List
```
1. On lead profile or search result
2. find "Save" button → click
3. read_page → identify list selection dropdown
4. Select target list (or create new list)
5. Confirm save
6. Wait 2 seconds
```

### Sequence 5: Account Deep Dive
```
1. Navigate to account page (from search result or URL)
2. read_page → extract company overview:
   - Headcount, growth %, industry, HQ
3. Click "People" tab
4. Apply persona filter or seniority filter
5. read_page → extract buying committee members
6. Click each key person for profile data
7. Screenshot relationship map if available
```

## Error Handling

### "Session expired" or login prompt
- Stop all actions immediately
- Alert user: "LinkedIn session expired. Please log in manually and confirm."
- Do NOT attempt to enter credentials

### "Something went wrong" error page
- Wait 10 seconds
- Try refreshing the page once
- If error persists, note the URL and action that caused it
- Reduce activity pace for remainder of session

### Rate limiting / slow page loads
- If pages take >10 seconds to load, Sales Nav may be throttling
- Stop current sequence
- Wait 5 minutes before resuming
- Reduce remaining session scope by 50%

### CAPTCHA or verification
- Stop immediately
- Alert user: "LinkedIn is showing a verification challenge. Please complete it manually."
- After user confirms completion, wait 30 seconds before resuming
- Reduce activity pace significantly

### Element not found
- If `find` returns no results for expected element
- Try `read_page` with full tree to see current page state
- The UI may have updated - LinkedIn A/B tests frequently
- Log the issue in `learnings-log.md` with screenshot

## Data Extraction Best Practices

### From Search Results Page
Each search result card typically contains:
- Name (linked to profile)
- Current title
- Company name (linked to company page)
- Location
- Connection degree
- Shared connections count
- Spotlight badge (if applicable: "Changed jobs", "Posted recently")

### From Profile Page
Additional data available:
- Full title (may be longer than search card shows)
- About section (first ~300 chars visible)
- Experience history (current + past roles)
- Education
- Profile language
- Recent activity (posts, articles)
- Shared connections list
- "How you're connected" path

### From Account Page
- Company overview (headcount, founded, industry, HQ)
- Growth data (headcount growth %, hiring trends)
- Key people (by your Persona filter)
- Recent activities and news
- Relationship Explorer (shows paths to key contacts)
- Similar companies (useful for ICP expansion)

## Session Logging

After each browser session, log:
```
Session: [date] [time started] - [time ended]
Objective: [what we set out to do]
Actions taken: [summary of navigation]
Data extracted: [count of leads/signals]
Issues: [any errors, slow loads, or UI changes]
Safety: [stayed within limits? any warnings?]
```

Store in `learnings-log.md`.
