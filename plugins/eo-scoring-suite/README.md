# EO Scoring Suite

5 assessment scorecards for the EO MicroSaaS OS. Evaluates Project Definition, ICP Clarity, Market Attractiveness, Strategy Path, and GTM Fitness.

## Quick Start

Run `/eo-score` to begin. Three input paths available:

1. **Web Import** - Upload SC*.md results from score.entrepreneursoasis.me
2. **DOCX Import** - Upload scoring Word documents
3. **In-Plugin** - Run scorecards interactively in Claude

## Scorecard Sequence

Scorecards must be completed in order. Each requires all previous scorecards.

| # | Scorecard | Time | Output Files |
|---|-----------|------|-------------|
| 1 | Project Definition | 30-45 min | project-brief.md, niche-validation.md, positioning.md, product-spec.md |
| 2 | ICP Clarity | 35-45 min | icp-refined.md |
| 3 | Market Attractiveness | 60-90 min | MarketAttractiveness.md |
| 4 | Strategy Selector | 45-50 min | strategy-recommendation.md |
| 5 | GTM Fitness | 30-35 min | gtm-fitness.md |

Total: 3.5-4.5 hours for the full journey.

## Score Bands

Each scorecard scores /100 with band classifications. Minimum 70 required to proceed to the next scorecard.

## Skill Architecture

Each skill follows progressive disclosure:
- **SKILL.md** (<480 lines) - Orchestration flow, scoring philosophy, section architecture
- **references/** - Question banks, scoring rubrics, frameworks, output templates

## Version

v2.0.0 - Refactored for progressive disclosure compliance (April 2026)
