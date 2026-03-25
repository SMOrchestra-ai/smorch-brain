# Extraction Map — Field-Level Input-to-Brain Mapping

## PURPOSE
This file tells the extraction engine exactly which content from input files maps to which field in which brain file. Every rule includes: source pattern → target field → confidence level.

---

## PPTX EXTRACTION RULES

### Slide Title Pattern Matching

Match slide titles (case-insensitive) to brain files. Speaker notes supplement the slide they belong to.

| Slide Title Contains | Maps To | Brain File | Confidence |
|---------------------|---------|------------|------------|
| "problem", "challenge", "pain", "gap", "why" | Problem section | company-profile.md | HIGH |
| "customer", "target", "persona", "ICP", "who we serve", "audience" | Primary Persona + Pains | icp.md | HIGH |
| "solution", "product", "platform", "what we do", "how it works" | Product/Service section | company-profile.md | HIGH |
| "pricing", "plans", "investment", "packages", "tiers" | Pricing section | offer.md | HIGH |
| "competition", "landscape", "vs", "alternatives", "market map" | Direct Competitors | competitive-landscape.md | HIGH |
| "team", "about us", "founder", "who we are" | Venture section (supplementary) | company-profile.md | MEDIUM |
| "go-to-market", "GTM", "distribution", "channels", "growth" | Primary Channels | gtm-channels.md | HIGH |
| "market", "opportunity", "TAM", "SAM", "market size" | Market section | company-profile.md | HIGH |
| "roadmap", "timeline", "phases", "milestones" | Timeline/Delivery | offer.md OR tech-spec.md | MEDIUM |
| "testimonial", "case study", "results", "proof" | Proof of Success | positioning.md (differentiators) | MEDIUM |
| "vision", "mission", "values" | One-liner (extract essence) | company-profile.md | LOW |
| "agenda", "overview", "table of contents" | SKIP — no brain data | — | — |
| "thank you", "Q&A", "contact", "next steps" | SKIP — no brain data | — | — |

### PPTX Content Pattern Matching (within slide body text)

| Content Pattern | Maps To | Brain File | Confidence |
|----------------|---------|------------|------------|
| Dollar amounts ($X, $X/month, $XK) | Pricing | offer.md | HIGH |
| Percentage claims (X% increase, X% reduction) | Dream Outcome metrics | icp.md | MEDIUM |
| Named company comparisons ("unlike [competitor]") | Competitive alternatives | competitive-landscape.md | HIGH |
| "For [role] who [struggle]" pattern | Positioning statement seed | positioning.md | HIGH |
| Bullet list of features (3-8 items) | Value Stack | offer.md | MEDIUM |
| "The only [category] that [mechanism]" | Unique mechanism | positioning.md | HIGH |
| Geographic mentions (UAE, Saudi, Dubai, MENA, Gulf) | Geography | company-profile.md + mena-context.md | HIGH |
| Time claims ("in X days", "within X hours") | Timeline to result | icp.md (dream outcome) | MEDIUM |
| Pain language ("frustrated", "losing", "wasting", "struggling") | Pain statements | icp.md | MEDIUM |
| ROI language ("save X hours", "increase by X%") | Dream outcome | icp.md | MEDIUM |

### Speaker Notes Extraction
- Speaker notes are HIGH value: they often contain the "real talk" behind polished slide text
- Map speaker notes to the same brain file as their parent slide
- If speaker notes contradict slide text, flag for user confirmation
- Speaker notes with "don't say" or "internal only" → DO NOT extract to brain (private context)

---

## DOCX / PDF EXTRACTION RULES

### Heading Pattern Matching

Match H1/H2/H3 headings (case-insensitive) to brain files. Same keyword patterns as PPTX slide titles, plus:

| Heading Contains | Maps To | Brain File | Confidence |
|-----------------|---------|------------|------------|
| "scope", "scope of work", "deliverables" | Deliverables + Timeline | engagement-model.md OR offer.md | HIGH |
| "requirements", "functional requirements", "user stories" | Core deliverable detail | tech-spec.md | HIGH |
| "architecture", "tech stack", "system design" | Tech stack | tech-spec.md | HIGH |
| "budget", "cost", "investment", "fees" | Pricing | offer.md | HIGH |
| "objectives", "goals", "KPIs", "success criteria" | Success metrics | offer.md | HIGH |
| "assumptions", "constraints", "limitations" | Anti-patterns | project-instruction.md | MEDIUM |
| "risks", "risk mitigation" | What NOT to do | project-instruction.md | MEDIUM |
| "background", "context", "situation" | Problem section | company-profile.md | HIGH |
| "approach", "methodology", "framework" | Unique mechanism | positioning.md | MEDIUM |
| "schedule", "timeline", "project plan" | Delivery timeline | engagement-model.md | HIGH |

### Table Extraction

| Table Type (detected by column headers) | Maps To | Brain File |
|-----------------------------------------|---------|------------|
| Feature comparison (features × competitors) | Direct competitors + strengths/weaknesses | competitive-landscape.md |
| Pricing table (tiers × features × prices) | Pricing tiers | offer.md |
| Timeline/Gantt (phases × dates × deliverables) | Delivery milestones | engagement-model.md |
| RACI matrix (tasks × roles) | Team structure | engagement-model.md |
| Requirements matrix (ID × description × priority) | Feature/deliverable list | tech-spec.md OR offer.md |

### Bullet List Extraction

| Context (heading above the bullets) | Maps To | Brain File |
|-------------------------------------|---------|------------|
| Under "Pain" / "Problem" heading | Pain statements (up to 5) | icp.md |
| Under "Solution" / "Features" heading | Value stack components | offer.md |
| Under "Benefits" / "Outcomes" heading | Dream outcome metrics | icp.md |
| Under "Competitors" heading | Direct competitor names | competitive-landscape.md |
| Under "Channels" / "Distribution" heading | Primary/secondary channels | gtm-channels.md |
| Under "Risks" / "Challenges" heading | Anti-patterns | project-instruction.md |

---

## URL / WEBSITE EXTRACTION RULES

### Page-Level Mapping

| Page Type (detected by URL path or content) | Maps To | Brain File |
|---------------------------------------------|---------|------------|
| Homepage | Company one-liner, product category | company-profile.md |
| /about, /team | Company background | company-profile.md |
| /pricing, /plans | Pricing tiers, feature list | offer.md |
| /features, /product | Product description, value stack | offer.md + company-profile.md |
| /customers, /case-studies | Proof points, ICP evidence | icp.md + positioning.md |
| /blog (recent 3 posts) | Voice/tone indicators, content themes | brand-voice.md |
| /careers, /jobs | Company size indicator, growth signals | company-profile.md |

### LinkedIn Company Page Extraction

| Data Point | Maps To | Brain File |
|-----------|---------|------------|
| Company description | One-liner seed | company-profile.md |
| Industry | Industry vertical | company-profile.md |
| Company size | ICP company size (if this IS the customer's company) | icp.md |
| Specialties | Product category indicators | company-profile.md |
| Recent posts (last 5) | Voice/tone indicators + content themes | brand-voice.md |
| Employee count | Company size indicator | company-profile.md |

### LinkedIn Personal Profile Extraction

| Data Point | Maps To | Brain File |
|-----------|---------|------------|
| Headline | Role description | icp.md (if this is the ICP) |
| Experience | Background, domain expertise | company-profile.md (if this is the client) |
| Recent posts | Pain language, interests, voice indicators | icp.md + brand-voice.md |
| Recommendations | Proof points | positioning.md |

---

## CONFLICT RESOLUTION

When multiple inputs provide data for the same field:

| Conflict Type | Resolution | Log Action |
|--------------|-----------|------------|
| File A says X, File B says Y | Present both to user, ask to pick | Log in brain-log.md |
| File says X, user verbal says Y | **Verbal wins** (user is source of truth) | Log: "[field]: file said X, user corrected to Y" |
| Newer file says X, older file says Y | **Newer wins** (by upload timestamp) | Log: "[field]: updated from Y to X per newer file" |
| Web research says X, user says Y | **User wins** | Log: "[field]: research suggested X, user confirmed Y" |
| File says X, nothing contradicts | **Accept at stated confidence** | No log needed unless LOW confidence |

---

## CONFIDENCE SCORING

Every extracted field gets a confidence tag:

| Confidence | Criteria | Display |
|-----------|----------|---------|
| **HIGH** | Direct match: slide title + content clearly maps to field | No tag (clean output) |
| **MEDIUM** | Inferred: content likely maps but title doesn't explicitly match | `[INFERRED — verify]` |
| **LOW** | Ambiguous: could be this field or another, context unclear | `[LOW CONFIDENCE — verify: "original text"]` |

**Rule:** Any field with LOW confidence is treated as a gap in Phase 2 scoring. It counts as "populated" for yield but "WEAK" for quality.

---

## UNMATCHED CONTENT

Content that doesn't match any extraction pattern:
1. Log to brain-log.md under "Unclassified Content" section
2. Include original text + source file + page/slide number
3. After all extraction is complete, scan unclassified content for any patterns missed
4. If >30% of content is unclassified, warn user: "A lot of your content didn't map to standard brain fields. This might mean: (a) the files are more operational than strategic, (b) there's context I need you to explain verbally, or (c) the project type might be different than selected."
