# Profile Research SOP

## Purpose
Structured process for extracting maximum intelligence from a LinkedIn profile in minimum time. Three depth levels depending on lead priority.

## Depth Levels

### Quick Scan (2 minutes - for batch research, P3 leads)
Extract:
1. Headline + current title
2. Location
3. One recent post topic (if any visible on profile)
4. Mutual connections count
5. Connection degree

Output: One personalization hook sentence

### Standard Research (5-7 minutes - for P2 leads, pre-outreach)
Everything in Quick Scan plus:
1. Full current role: company, title, duration
2. Previous 2 roles: trajectory assessment
3. Last 3-5 posts: topic analysis
4. Education: notable schools or certifications
5. Mutual connections: identify any who could introduce
6. About section: what do they say about themselves?
7. Featured section: what do they want people to see?

Output: Profile Intelligence Brief (Mode A format)

### Deep Dive (15-20 minutes - for P1 leads, key accounts)
Everything in Standard Research plus:
1. Full activity analysis: posts, comments, reactions (last 30 days)
2. Who do they engage with? (comment analysis)
3. Company page analysis (what is their company saying?)
4. Trust signal mapping (Mode F)
5. Career narrative: what story does their trajectory tell?
6. Public awards, features, speaking engagements
7. Content they reshare: whose thinking do they amplify?
8. LinkedIn recommendations given/received: who trusts them?

Output: Full Profile Brief + Trust Map + Recommended Engagement Sequence

## Execution Steps (Standard Research)

### Step 1: Open Profile
```
1. Navigate to LinkedIn URL
2. Wait 3-5 seconds for full load
3. read_page to capture accessibility tree
```

### Step 2: Header Section
```
1. Extract: Name, Headline, Location, Connection degree
2. Note: Profile photo (professional/casual), background image (custom = invested)
3. Check: Mutual connections count and notable names
4. Check: Creator mode badge (if present, they post regularly)
```

### Step 3: About Section
```
1. Scroll to or find "About" section
2. Read full text (may need to click "see more")
3. Note: How they describe themselves
4. Signal: Keywords related to your offer (growth, scaling, automation, operations)
5. Signal: Personal voice vs corporate bio (personal = higher engagement probability)
```

### Step 4: Experience Section
```
1. Current role: title, company, start date, description (if any)
2. Previous role: title, company, duration
3. Trajectory: promotion path? lateral moves? industry switches?
4. Signal: Recent role change = vendor evaluation window
5. Signal: Long tenure (>3 years) = likely has authority and budget
```

### Step 5: Activity Section
```
1. Click "Activity" or scroll to recent activity section
2. Read last 3-5 visible posts
3. For each: topic, date, engagement count, your signal interpretation
4. If they're active: they're an engagement-before-outreach candidate
5. If they're inactive: skip to mutual connections for warm intro path
```

### Step 6: Featured Section (if present)
```
1. What have they pinned? Articles, posts, external links?
2. This reveals what they want to be known for
3. Reference their featured content in outreach = instant credibility
```

### Step 7: Education & Certifications
```
1. Schools: any shared alma mater? (trust signal)
2. Certifications: industry-specific (shows investment in field)
3. In MENA: certain schools/certifications carry outsized network value
```

## Profile Scoring for Outreach Priority

After research, score the profile on two axes:

### Engagement Readiness (1-5)
- 5: Posts weekly, engages with comments, content aligned to your offer
- 4: Posts monthly, some relevant content
- 3: Occasionally active, mostly reshares
- 2: Rarely posts, profile is updated
- 1: Ghost profile, no activity, minimal info

### Personalization Depth (1-5)
- 5: Multiple strong personalization hooks (recent post + mutual connection + shared background)
- 4: Good hook (relevant content OR strong mutual connection)
- 3: Decent hook (generic content + same industry)
- 2: Minimal hook (only title/company to reference)
- 1: No hook available (cold approach only)

### Priority Matrix
| | Engagement 4-5 | Engagement 2-3 | Engagement 1 |
|---|---|---|---|
| **Personalization 4-5** | ENGAGE FIRST → CR | Direct CR with hook | Direct CR with hook |
| **Personalization 2-3** | Engage → generic CR | Generic CR | Email only |
| **Personalization 1** | Engage → generic CR | Email only | Skip or monitor |

## Data Capture Template

```json
{
  "linkedin_url": "",
  "full_name": "",
  "headline": "",
  "current_title": "",
  "company": "",
  "location": "",
  "profile_language": "",
  "connection_degree": "",
  "mutual_connections": 0,
  "notable_mutuals": [],
  "career_trajectory": "",
  "content_frequency": "daily|weekly|monthly|inactive",
  "primary_topics": [],
  "recent_post_hook": "",
  "trust_signals": [],
  "engagement_readiness": 0,
  "personalization_depth": 0,
  "recommended_approach": "",
  "opening_line": "",
  "research_depth": "quick|standard|deep",
  "researched_at": ""
}
```
