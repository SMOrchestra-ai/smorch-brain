# EO Training Factory: Tools Builder Sub-Skill Reference

## Purpose
Build interactive tools, scorecards, matrices, frameworks, and lead magnets for EO training products. Each tool serves dual purposes: diagnostic assessment and teaching mechanism.

---

## Discovery Flow: Questions to Ask First

Before building ANY tool, walk through this question flow to determine scope and format.

### Phase 1: Training Context
1. **What is the training topic?**
   - Example: "MicroSaaS Strategy for MENA founders"
   - This determines which frameworks are relevant (GTM, MAS, ICP, etc.)

2. **Who is the primary user?**
   - Founder, marketer, sales leader, operator?
   - MENA-specific considerations? (mobile-first, offline capability, language support)

### Phase 2: Tool Type Selection
3. **What primary problem does this tool solve?**
   - Help user self-assess? → Strategy Selector / Diagnostic Tool
   - Score readiness on known dimensions? → Scoring Matrix
   - Show where they fit in the framework? → Framework Visualization
   - Drive signup/lead generation? → Lead Magnet
   - Multiple purposes? → Diagnostic Tool (preferred, teaches while scoring)

4. **What's the use case?**
   - Personal reflection (can be Excel)
   - Share with team (should be HTML)
   - Embed in training (must be HTML)
   - Lead magnet on landing page (must be HTML + CTA)
   - Live workshop tool (must be mobile-first HTML)

### Phase 3: Tool Design
5. **What dimensions should be scored?** (if scoring)
   - List the 3-7 key dimensions for this topic
   - Example MicroSaaS: Product-Market Fit, GTM Clarity, Team Capability, Funding Stage, Market Timing
   - Each dimension: 1-5 scale or different scale?
   - How are results aggregated? (simple sum, weighted formula, narrative?)

6. **What are the output paths/recommendations?**
   - How many distinct result types? (2-4 recommended)
   - What action should follow each result?
   - Example: "Score 15-20 → Advanced GTM workshop | Score 10-14 → GTM Fundamentals | Score <10 → Back to product-market fit"

7. **What are the scoring thresholds?**
   - Break points for each result path
   - Reasoning for each threshold
   - What MENA-specific context informs these breaks?

### Phase 4: Format & Delivery
8. **Is this for internal use or public sharing?**
   - Internal (personal, team-only) → Excel
   - Public/sharable → HTML
   - Embedded in LMS/landing page → HTML
   - Lead magnet → HTML + CTA

9. **Should it have a CTA?**
   - Yes: What does it link to? (training, free hour, email list, etc.)
   - CTA must be singular, clear, and benefit-driven
   - Example: "Want to learn what to do with this score? Watch the free hour."

10. **What MENA-specific proof points should be included?**
    - 3+ real examples from MENA founders/markets
    - Source: FounderOS dataset, case studies, or research
    - Include in results page when relevant to user's score

---

## Tool Type Decision Tree

```
START: What do you need?

├─ "Help users self-assess across multiple dimensions"
│  └─ Use: STRATEGY SELECTOR / DIAGNOSTIC TOOL
│     (Scored questionnaire + framework teaching)
│     Output: Assessment score + narrative results + CTA
│     Format: React + Tailwind HTML
│
├─ "Score readiness on a specific matrix/framework"
│  ├─ "For internal team use"
│  │  └─ Use: SCORING MATRIX (Excel)
│  │     Output: Score calculation + visual indicator
│  │     Format: .xlsx with formulas
│  │
│  └─ "For public sharing/embedding"
│     └─ Use: SCORING MATRIX (HTML)
│        Output: Interactive calculator + results
│        Format: React + Tailwind HTML
│
├─ "Show where user fits in a framework"
│  └─ Use: FRAMEWORK VISUALIZATION
│     (2x2 matrix, arc progression, etc.)
│     Output: User plots their position + interpretation
│     Format: React + Tailwind HTML
│
└─ "Drive lead generation / sharing"
   └─ Use: LEAD MAGNET
      (Tool + results page + email CTA)
      Output: Sharable results + email signup
      Format: React + Tailwind HTML + email integration
```

---

## Supported Tool Types & Production Patterns

### Type 1: Strategy Selector / Diagnostic Tool

**Use Case:** Scored questionnaire that teaches while assessing. Dual-purpose: determines user path AND introduces framework.

**Example:** MicroSaaS Strategy Selector
- **Input:** 15-25 questions across 5-7 dimensions
- **Scoring:** Each dimension scored 1-5 based on answers
- **Output:** Primary strategy path + secondary path + reasoning + MENA proof points
- **CTA:** Single, clear link to training/free hour

**Production Pattern:**

```html
<!-- Single .html file, CDN dependencies only -->
<!DOCTYPE html>
<html>
<head>
  <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Strategy Selector - [Training Name]</title>
</head>
<body class="bg-gray-50">
  <div id="root"></div>
  <script type="text/babel">
    // App component structure:
    // 1. QuestionnairePhase: Show questions, track answers
    // 2. ScoringPhase: Calculate dimensions
    // 3. ResultsPhase: Display path + reasoning + CTA

    // Data structure:
    const QUESTIONS = [
      {
        id: 1,
        text: "How clear is your target customer?",
        dimension: "ICP_Clarity", // dimension key
        answers: [
          { text: "Very unclear", value: 1 },
          { text: "Somewhat unclear", value: 2 },
          { text: "Neutral", value: 3 },
          { text: "Fairly clear", value: 4 },
          { text: "Extremely clear", value: 5 }
        ]
      }
      // ... more questions
    ];

    // Result paths (scored on dimensions)
    const PATHS = {
      "Enterprise_GTM": {
        name: "Enterprise Go-to-Market",
        description: "Your profile suggests...",
        triggers: { ICP_Clarity: [4, 5], GTM_Readiness: [4, 5] },
        menaExamples: [
          { founder: "Name", company: "Company", market: "Market", insight: "Why this path fits" }
          // 3+ examples
        ],
        nextStep: "Take the Enterprise GTM training"
      }
      // ... more paths
    };
  </script>
</body>
</html>
```

**Component Structure:**
```jsx
<App>
  {phase === 'questions' && <QuestionnaireForm />}
  {phase === 'results' && <ResultsPage />}
</App>

// QuestionnaireForm: renders questions 1 by 1, stores answers in state
// ResultsPage: shows primary + secondary path, MENA examples, CTA button
```

**Scoring Logic Template:**
```javascript
// Calculate dimension scores (1-5 range)
const calculateDimensions = (answers) => {
  const dimensions = {};

  // Group questions by dimension
  const questionsByDimension = QUESTIONS.reduce((acc, q) => {
    if (!acc[q.dimension]) acc[q.dimension] = [];
    acc[q.dimension].push(q.id);
    return acc;
  }, {});

  // Average score per dimension
  Object.entries(questionsByDimension).forEach(([dim, qIds]) => {
    const scores = qIds.map(id => answers[id]).filter(s => s !== undefined);
    dimensions[dim] = Math.round(scores.reduce((a, b) => a + b, 0) / scores.length * 10) / 10;
  });

  return dimensions;
};

// Determine paths (primary + secondary)
const determinePaths = (dimensions) => {
  const paths = Object.entries(PATHS)
    .map(([key, path]) => ({
      key,
      path,
      score: calculatePathScore(dimensions, path.triggers)
    }))
    .sort((a, b) => b.score - a.score);

  return {
    primary: paths[0],
    secondary: paths[1] || paths[0],
    dimensions
  };
};
```

**Quality Checklist:**
- [ ] Every question combination produces a valid result (no "no path matched" states)
- [ ] All paths have 3+ MENA examples with specific founder names and context
- [ ] Results page shows dimension scores visually (bar chart or radar)
- [ ] Primary + secondary paths both have reasoning text
- [ ] CTA is visible and benefit-driven
- [ ] Mobile layout: questions are full-width, results are stacked, CTA button is thumb-friendly
- [ ] All images/assets load from CDN (no local files)
- [ ] Page loads in <2 seconds

---

### Type 2: Scoring Matrix

**Use Case:**
- **Excel:** Internal team scoring, personal worksheets, training materials
- **HTML:** Public tool, shareable results, lead magnet

#### 2A: Scoring Matrix (Excel)

**Examples:**
- Market Attractiveness Score (MAS): 4 dimensions × 1-5 score = /20 total
- ICP Clarity Score: 4 dimensions × 1-5 score = /20 total
- GTM Fitness Scorecard: 13 motions × 3 dimensions (Fit, Readiness, MENA Viability) × weighted formula

**Production Pattern:**

```excel
[GTM Fitness Scorecard Example]

SHEET 1: Assessment
─────────────────────────────────────────────
| Motion | Definition | Fit (0.4) | Readiness (0.3) | MENA Viability (0.3) | Motion Score |
├─────────────────────────────────────────────
| 1 | Value Prop | [1-5] | [1-5] | [1-5] | =AVERAGE()*10 |
| ... (13 rows) |
├─────────────────────────────────────────────
| TOTAL SCORE | | | | | =SUM()/13 × 100 |
| BAND | | | | | =IF(TOTAL>85,"Advanced",...) |

SHEET 2: Guidance
─────────────────────────────────────────────
| Band | Score Range | Interpretation | Next Step |
| Advanced | 85-100 | Execution mode | Execute. Monitor competitors. |
| Solid | 70-84 | Ready to scale | Scale. Optimize unit economics. |
| Developing | 55-69 | Build readiness | Refine. Get traction proof. |
| Foundation | <55 | Early stage | Validate. Iterate product. |
```

**Scoring Formula Rules:**
- Simple Sum: `=SUM(D2:D5)` for straightforward addition
- Weighted: `=(Fit*0.4 + Readiness*0.3 + Viability*0.3)` for balanced importance
- Conditional: Use IF statements to assign bands/colors
- All formulas must work if user changes inputs
- No hard-coded values; all formulas reference cells

**Excel Quality Checklist:**
- [ ] All formulas work when inputs change
- [ ] Conditional formatting shows scoring bands visually (color)
- [ ] Guidance sheet explains each motion and scoring dimension
- [ ] No circular references
- [ ] File size <500KB
- [ ] Tested in Excel, Google Sheets, and Excel Online

#### 2B: Scoring Matrix (HTML)

**Use Case:** Interactive calculator for public sharing, embeddable, lead magnet version

**Production Pattern:**

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/recharts@2.5.0/dist/recharts.min.js"></script>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel">
    // Data structure
    const SCORING_MATRIX = {
      title: "GTM Fitness Scorecard",
      motions: [
        {
          id: 1,
          name: "Value Prop Clarity",
          description: "How clear is your differentiated value prop?",
          dimensions: {
            fit: "Answers demand/need",
            readiness: "Team understands it",
            viability: "MENA market resonates"
          }
        }
        // ... 13 motions
      ],
      formula: (motion_scores) => {
        // Weighted scoring
        const fit_avg = motion_scores.map(m => m.fit).reduce((a, b) => a + b, 0) / motion_scores.length;
        const readiness_avg = motion_scores.map(m => m.readiness).reduce((a, b) => a + b, 0) / motion_scores.length;
        const viability_avg = motion_scores.map(m => m.viability).reduce((a, b) => a + b, 0) / motion_scores.length;

        return (fit_avg * 0.4 + readiness_avg * 0.3 + viability_avg * 0.3) * 100;
      },
      bands: [
        { min: 85, max: 100, name: "Advanced", color: "bg-green-500", action: "Execute at scale" },
        { min: 70, max: 84, name: "Solid", color: "bg-blue-500", action: "Optimize & scale" },
        { min: 55, max: 69, name: "Developing", color: "bg-yellow-500", action: "Build readiness" },
        { min: 0, max: 54, name: "Foundation", color: "bg-red-500", action: "Validate core" }
      ]
    };

    // Component structure
    const App = () => {
      const [scores, setScores] = useState({});
      const [showResults, setShowResults] = useState(false);

      return (
        <div className="max-w-4xl mx-auto p-4">
          {!showResults ? (
            <ScoringForm motions={SCORING_MATRIX.motions} onSubmit={handleSubmit} />
          ) : (
            <ResultsPage scores={scores} matrix={SCORING_MATRIX} />
          )}
        </div>
      );
    };
  </script>
</body>
</html>
```

**Results Page Structure:**
```jsx
<ResultsPage>
  <ScoreDisplay score={totalScore} band={band} />
  {/* Shows large score, band name, color indicator */}

  <ScoreBands />
  {/* Shows where user falls on scale (visual) */}

  <DimensionBreakdown />
  {/* Bar chart: Fit vs Readiness vs Viability averages */}

  <ActionRecommendation />
  {/* Text + CTA based on band */}

  <ScoreBreakdown />
  {/* Table: each motion, dimensions, scores */}

  <ShareButton />
  {/* Screenshot-friendly results, "Share your score" CTA */}
</ResultsPage>
```

**HTML Scoring Matrix Quality Checklist:**
- [ ] All 13 motions scorecard (if using full GTM)
- [ ] Each dimension (Fit, Readiness, Viability) scored 1-5
- [ ] Formula matches exactly: (Fit×0.4 + Readiness×0.3 + Viability×0.3) × 100
- [ ] Scoring bands: 85-100 (Advanced), 70-84 (Solid), 55-69 (Developing), <55 (Foundation)
- [ ] Each band has specific action recommendation
- [ ] Results layout is mobile-first (responsive to 320px)
- [ ] Results are screenshot-friendly (no scroll needed for full score view)
- [ ] Page loads in <2 seconds

---

### Type 3: Framework Visualization

**Use Case:** Show user where they fit in a 2D or 3D framework. Interactive positioning.

**Examples:**
- 2x2 Demand-First Matrix (MAS vs GTM Readiness) — 4 quadrants
- Belief Arc progression (Awareness → Belief → Conviction → Action)
- 4-Layer Meta-Learning Architecture visualization

**Production Pattern:**

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/recharts@2.5.0/dist/recharts.min.js"></script>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel">
    // 2x2 Matrix Example
    const MATRIX_FRAMEWORK = {
      title: "Demand-First GTM Positioning",
      xAxis: {
        name: "Market Attractiveness Score",
        min: 0,
        max: 20,
        lowLabel: "Low Demand",
        highLabel: "High Demand"
      },
      yAxis: {
        name: "GTM Readiness",
        min: 0,
        max: 20,
        lowLabel: "Low Readiness",
        highLabel: "High Readiness"
      },
      quadrants: [
        {
          name: "Question Mark",
          xRange: [0, 10],
          yRange: [0, 10],
          guidance: "High risk. Validate market first."
        },
        {
          name: "Star",
          xRange: [10, 20],
          yRange: [10, 20],
          guidance: "Invest heavily. Scale operations."
        }
        // ... 4 quadrants
      ]
    };

    const MatrixVisualization = ({ userX, userY }) => {
      return (
        <ComposedChart width={500} height={500}>
          {/* Grid background */}
          <CartesianGrid />
          <XAxis type="number" dataKey="x" />
          <YAxis type="number" dataKey="y" />

          {/* Quadrant backgrounds */}
          {MATRIX_FRAMEWORK.quadrants.map(q => (
            <RectangleShape
              x={q.xRange[0]}
              y={q.yRange[0]}
              width={q.xRange[1] - q.xRange[0]}
              height={q.yRange[1] - q.yRange[0]}
              fill="rgba(0, 0, 0, 0.05)"
            />
          ))}

          {/* User position */}
          <Scatter name="Your position" data={[{ x: userX, y: userY }]} fill="#0D9488" />
        </ComposedChart>
      );
    };
  </script>
</body>
</html>
```

**Framework Visualization Quality Checklist:**
- [ ] User inputs for each axis (or imports from previous assessment)
- [ ] Quadrant/zone labels are clear
- [ ] Guidance text is specific to user's position
- [ ] Visual emphasis (color, size) highlights their quadrant
- [ ] Mobile-friendly (chart adapts to screen size)
- [ ] CTA relevant to their quadrant

---

### Type 4: Lead Magnet

**Use Case:** Standalone tool designed for sharing/embedding with explicit CTA to training/email signup.

**Key Requirements:**
- Must work as diagnostic AND teaching tool (dual purpose)
- Shareable results (screenshot-friendly, short URL, email-friendly)
- Mobile-first (MENA users, phone access)
- Single CTA (clear next step)
- All interactive (no videos, no downloads required)

**Production Pattern:**

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>MicroSaaS Strategy Selector - Free Assessment</title>
  <meta property="og:title" content="What's your MicroSaaS strategy?">
  <meta property="og:description" content="Free 2-min assessment → discover your path">
</head>
<body class="bg-gray-50">
  <div id="root"></div>
  <script type="text/babel">
    const LeadMagnet = () => {
      const [phase, setPhase] = useState('intro');
      const [answers, setAnswers] = useState({});
      const [results, setResults] = useState(null);

      // INTRO PHASE: Hook + questions preview
      return (
        <div className="min-h-screen flex flex-col">
          {phase === 'intro' && (
            <IntroPage
              title="What's Your MicroSaaS Strategy?"
              tagline="2-minute assessment → discover your path"
              hooks={[
                "See which strategy fits your stage",
                "Get 3 MENA founder examples",
                "Watch your free training hour"
              ]}
              onStart={() => setPhase('questions')}
            />
          )}

          {phase === 'questions' && (
            <QuestionnairePhase
              onComplete={(answers) => {
                const results = calculateResults(answers);
                setResults(results);
                setPhase('results');
              }}
            />
          )}

          {phase === 'results' && (
            <ResultsPhase
              results={results}
              cta={{
                text: "Watch the Free Hour",
                link: "https://[training-url]",
                description: "Learn exactly what to do with this score"
              }}
              shareButton={true}
            />
          )}
        </div>
      );
    };

    // INTRO PHASE: Compelling hook + quick facts
    const IntroPage = ({ title, tagline, hooks, onStart }) => (
      <div className="max-w-md mx-auto px-4 py-8 text-center">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">{title}</h1>
        <p className="text-lg text-gray-600 mb-8">{tagline}</p>

        <ul className="text-left space-y-3 mb-8">
          {hooks.map((h, i) => (
            <li key={i} className="flex items-start gap-3">
              <span className="text-teal-500 font-bold">✓</span>
              <span className="text-gray-700">{h}</span>
            </li>
          ))}
        </ul>

        <button
          onClick={onStart}
          className="w-full bg-teal-500 text-white py-3 rounded-lg font-semibold hover:bg-teal-600"
        >
          Start Assessment
        </button>
      </div>
    );

    // RESULTS PHASE: Score + path + MENA examples + CTA
    const ResultsPhase = ({ results, cta, shareButton }) => (
      <div className="max-w-md mx-auto px-4 py-8">
        {/* Score Display */}
        <div className="bg-white rounded-lg p-6 mb-6 text-center">
          <h2 className="text-gray-600 text-sm mb-2">Your Strategy Path</h2>
          <h1 className="text-4xl font-bold text-teal-500 mb-1">{results.path.name}</h1>
          <p className="text-gray-600">{results.path.description}</p>
        </div>

        {/* Why This Path */}
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h3 className="font-semibold text-gray-900 mb-2">Why this path fits you</h3>
          <ul className="space-y-1 text-sm text-gray-700">
            {results.reasoning.map((r, i) => (
              <li key={i}>• {r}</li>
            ))}
          </ul>
        </div>

        {/* MENA Proof Points (3+ examples) */}
        <div className="mb-6">
          <h3 className="font-semibold text-gray-900 mb-3">MENA Founders on This Path</h3>
          {results.path.menaExamples.map((ex, i) => (
            <div key={i} className="border-l-4 border-teal-500 pl-4 mb-3">
              <p className="font-semibold text-sm text-gray-900">{ex.founder}</p>
              <p className="text-xs text-gray-600">{ex.company} • {ex.market}</p>
              <p className="text-sm text-gray-700 mt-1">{ex.insight}</p>
            </div>
          ))}
        </div>

        {/* Primary CTA */}
        <a
          href={cta.link}
          target="_blank"
          rel="noopener noreferrer"
          className="block w-full bg-teal-500 text-white py-4 rounded-lg font-semibold text-center hover:bg-teal-600 mb-3"
        >
          {cta.text}
        </a>
        <p className="text-xs text-gray-600 text-center mb-4">{cta.description}</p>

        {/* Share Button */}
        {shareButton && (
          <button
            onClick={() => shareResults(results)}
            className="w-full border-2 border-gray-300 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-50"
          >
            Share Your Results
          </button>
        )}
      </div>
    );
  </script>
</body>
</html>
```

**Lead Magnet Quality Checklist:**
- [ ] Intro page has compelling hook (benefit-focused, not feature-focused)
- [ ] Assessment takes 2 minutes max (7-12 questions)
- [ ] Results show strategy name + 3+ MENA examples with specific founder names
- [ ] MENA examples include context (company, market, relevance to path)
- [ ] CTA is single, clear, benefit-driven (not "learn more", but "watch the free hour")
- [ ] Results page is screenshot-friendly (fits mobile screen without scroll)
- [ ] Share button generates short URL or image (no email required to see results)
- [ ] Page loads in <2 seconds on 4G connection (test in DevTools)
- [ ] Works on iOS Safari, Android Chrome (test on actual phones)
- [ ] No server required (all logic in React state)

---

## EO Color Scheme

Use consistently across all tools:

```css
--navy: #1B2A4A        /* Primary: Headers, CTA backgrounds */
--teal: #0D9488        /* Secondary: Interactive, highlights */
--gold: #D97706        /* Accent: Emphasis, badges */
--accent: #E8612D      /* Tertiary: Secondary CTAs, callouts */
--light-orange: #FF6600 /* Light accent alternative */
```

**Usage:**
- Primary CTA button: `bg-teal-500 hover:bg-teal-600`
- Headers: `text-navy`
- Score badges: `bg-gold text-navy`
- Results path name: `text-teal-500`
- MENA example highlight: `border-l-4 border-teal-500`

---

## Technical Requirements for All HTML Tools

### Essentials
- **Framework:** React 18 (via CDN)
- **Styling:** Tailwind CSS (via CDN)
- **Charts (if needed):** Recharts (via CDN)
- **Single File:** All code in one .html file, no separate JS/CSS files
- **No Build Step:** Must work in browser as-is
- **No Backend:** All logic in React state, no server calls
- **No LocalStorage:** Use React state only (some environments block localStorage)

### Performance
- **Load Time:** <2 seconds on 4G
- **Bundle Size:** <500KB total (all CDN scripts combined)
- **Rendering:** Smooth on mobile (60fps, no jank)

### Mobile-First Design
- **Min Width:** 320px (iPhone SE)
- **Viewport:** `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
- **Font Size:** Min 16px for inputs (prevents iOS zoom)
- **Touch Targets:** Min 44×44px for buttons
- **Results Layout:** Stacked (no side-by-side) on mobile

### Responsive Breakpoints
```tailwind
sm: 640px    /* Default: mobile */
md: 768px    /* Tablet: slight adjustments */
lg: 1024px   /* Desktop: multi-column layouts */
```

### No External Assets
- All images: Data URIs or inline SVG
- All fonts: System fonts or Google Fonts CDN
- All icons: Tailwind classes or inline SVG
- No file downloads or submissions

### Accessibility
- Semantic HTML (`<button>`, `<label>`, `<form>`)
- ARIA labels for interactive elements
- Color not sole indicator (use icons + text)
- Keyboard navigation (Tab, Enter, Arrow keys)
- Focus states visible (`:focus-visible`)

---

## Production Checklist: Use Before Launching

### Discovery Phase
- [ ] Asked all 10 discovery questions
- [ ] Documented user persona (founder, marketer, etc.)
- [ ] Chose tool type via decision tree
- [ ] Confirmed use case (internal vs. public, embedded vs. lead magnet)
- [ ] Listed all dimensions/questions
- [ ] Defined result paths and scoring thresholds
- [ ] Collected 3+ MENA examples per path (from FounderOS or research)
- [ ] Defined primary CTA and link

### Design Phase
- [ ] Sketched user flow (intro → questions → results)
- [ ] Designed results page on mobile (fits without scroll)
- [ ] Chose EO color scheme colors
- [ ] Confirmed button copy (benefit-driven, not feature-driven)
- [ ] Wrote MENA example copy (founder name, company, market, insight)

### Development Phase
- [ ] Built as single .html file with React + Tailwind CDN
- [ ] Implemented all questions and scoring logic
- [ ] Validated scoring math (every combination produces valid result)
- [ ] Created results display with all required elements
- [ ] Added CTA button with tracking link
- [ ] Tested on mobile (iOS Safari, Android Chrome)
- [ ] Tested on desktop (Chrome, Firefox, Safari)
- [ ] Tested page load time (should be <2s)

### Quality Assurance
- [ ] Every question combination produces a valid result (no errors, no blank states)
- [ ] All dimensions calculate correctly
- [ ] All result paths have 3+ MENA examples with real context
- [ ] Results page is screenshot-friendly on mobile (no critical scroll)
- [ ] CTA link works and tracks correctly
- [ ] Share button works (generates URL or exports image)
- [ ] Mobile design: buttons are thumb-friendly (44px+), text is readable (16px+)
- [ ] Loading: no console errors, all CDN scripts load
- [ ] Performance: page loads in <2 seconds on 4G (test in DevTools)
- [ ] Accessibility: keyboard navigation works, color + icon used for status

### Launch Prep
- [ ] CTA link verified (correct URL, tracking active)
- [ ] Email/signup integration tested (if applicable)
- [ ] Tool title and metadata (og:title, og:description) set
- [ ] Documented where tool will live (landing page, email, embed code)
- [ ] Created short URL (if shareable)
- [ ] Tested on actual phones (not just browser emulation)
- [ ] Created backup link (in case primary link changes)

---

## Common Patterns by Training Type

### MicroSaaS Strategy (Example)
- **Tool Type:** Strategy Selector + Diagnostic
- **Dimensions:** ICP Clarity, GTM Readiness, Product Stage, Funding, Founder Experience
- **Result Paths:**
  - Bootstrapped Product-Led Growth
  - Venture-Backed Enterprise Sales
  - Funded Niche-First Strategy
  - Founder-Market Fit Focus (early stage)
- **Scoring:** Sum dimensions, divide by count, multiply by 20 for /100 scale
- **CTA:** "Watch the [Strategy Name] Free Hour"

### GTM Framework (Example)
- **Tool Type:** Scoring Matrix (HTML) + Framework Visualization
- **Dimensions:** Fit, Readiness, MENA Viability (13 motions × 3 dimensions)
- **Result Bands:** Advanced (85+), Solid (70-84), Developing (55-69), Foundation (<55)
- **Scoring:** Weighted formula (Fit×0.4 + Readiness×0.3 + Viability×0.3)
- **CTA:** "Get the GTM Execution Plan"

### Market Validation (Example)
- **Tool Type:** Diagnostic Tool
- **Dimensions:** Problem Validation, Solution Clarity, Market Size, ICP Fit, Price Signal
- **Result Paths:** Ready to Build, Refine Positioning, Validate Problem First, Pivot Strategy
- **MENA Examples:** 3+ founders who followed each path successfully
- **CTA:** "Watch the Market Validation Training"

---

## Troubleshooting

**"Page loads slowly"**
- Check CDN scripts are loading (DevTools Network tab)
- Move heavy computations to useMemo
- Remove unused Tailwind classes
- Limit MENA examples to 3 per path

**"Results page doesn't fit on mobile"**
- Use stacked layout (flex-col)
- Reduce padding/margin on mobile (px-2, py-4)
- Move secondary content below fold
- Test actual device (not just browser emulation)

**"Scoring doesn't match framework"**
- Print dimension calculations: `console.log(dimensions)`
- Test with known good inputs (e.g., all 5's should be max score)
- Verify weighted formula matches framework doc exactly
- Round consistently (Math.round() vs Math.floor())

**"CTA link doesn't work"**
- Verify URL is correct (copy from browser address bar)
- Test link in new tab (target="_blank")
- Check analytics to see if clicks are tracked
- Have backup link ready if primary URL changes

---

## When to Ask for Help

Escalate to the trainer/design lead if:
- Tool needs custom backend (scoring API, database)
- Tool needs video content integration
- Tool needs real-time multiplayer (team assessments)
- Tool needs payment/subscription integration
- Tool needs to work offline (downloads, mobile app)
- Tool needs to export to PDF/DOCX
- Tool is in a language other than English

These are out of scope for this sub-skill. Build only single-user, browser-based, self-contained tools.

---

## Next Steps After Building

1. **Get Feedback:** Share with 3 MENA founders matching tool's persona
   - Does result path feel accurate?
   - Is MENA example relevant?
   - Would they share it?

2. **Measure Engagement:**
   - Track completion rate (intro → results)
   - Track CTA click-through rate
   - Measure time in tool
   - Monitor scroll depth on results page

3. **Iterate Based on Data:**
   - If dropout is high at question 5, simplify/rewrite
   - If MENA examples don't resonate, swap for local examples
   - If CTA CTR is low, change button copy or positioning

4. **Integrate into Training:**
   - Embed in lesson landing page
   - Reference results in training content
   - Use results to personalize recommendations
   - Create follow-up based on result path

