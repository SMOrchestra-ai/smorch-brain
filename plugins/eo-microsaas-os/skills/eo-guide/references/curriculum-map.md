# EO Training Curriculum Map

Quick reference for the guide to map modules to steps and expected outputs.

## Module Summary

| Module | Title | Duration | Key Concepts | Maps to Step |
|--------|-------|----------|-------------|-------------|
| 00 | Free Hour (Strategy Assessment) | ~60 min | Strategy Selector (4 paths, 8 archetypes), Market Attractiveness (4 dimensions), gated pre-qualification | Step 0 (SC3, SC4) |
| 01 | Claude as Business Brain | ~50 min | Context loading, competitive analysis, ICP definition, positioning, demand-first scoring | Step 0 (SC1, SC2) + Step 1 |
| 02 | Claude Desktop + CoWork | ~50 min | Filesystem MCP, GTM Scorecard (13 motions), data analysis on real spreadsheets | Step 2 (SC5 + GTM assets) |
| 03 | Skills | ~30 min | Skill anatomy (SKILL.md), download vs build, custom skill pipeline, 6-skill example | Step 3 |
| 04 | MCPs + Cowork | ~30 min | MCP installation, n8n workflow, architecture decisions, BRD generation | Step 4 |
| 05 | Claude Code | ~40 min | BRD-to-code pipeline, Supabase MCP, frontend build, Coolify deployment | Step 5 |
| 06 | Closing | ~10 min | Stack recap, 48-hour challenge, community ($97/month) | Post-completion |

Total training time: ~270 minutes (~4.5 hours)

## Belief Shifts Per Module

These are the mental model changes each module is designed to create:

| Module | FROM (Old Belief) | TO (New Belief) |
|--------|-------------------|-----------------|
| 00 | "I have a great idea" | "I have a scored, validated direction" |
| 01 | "AI is overhyped for real business" | "AI with my business context does real strategic work" |
| 02 | "I need a marketing team or agency" | "I need the right 3 GTM motions, systematically executed" |
| 03 | "I need to master every tool" | "I teach Claude the tool once, Claude operates it forever" |
| 04 | "Automation requires coding" | "Orchestration requires architecture, not code" |
| 05 | "I can't code, so I can't build" | "I architect, Claude codes. CLAUDE.md is my leverage." |
| 06 | "Building takes months" | "48 hours from deploy to first user" |

## EO Live Throughline

Each module builds the EO platform live as proof of concept:

- Module 00: EO platform idea is scored (Strategy Selector + MAS)
- Module 01: EO brain files are built live (12-file structure demo)
- Module 02: EO GTM motions are scored, assets generated
- Module 03: A real operator skill is built for an EO stack tool
- Module 04: EO tech stack selected, BRD generated
- Module 05: EO platform goes from BRD to deployed MVP

The student sees the instructor build the same thing they will build, using the same OS.

## Student Materials Reference

These materials support the training. Reference them when relevant:

| Material | Purpose | When to Reference |
|----------|---------|------------------|
| EO-Student-QuickStart-Card | 8 setup steps + 48-hour plan | Step 0 (getting started) |
| EO-Quick-Reference-Card | 10 milestones + 10 emergency prompts | Any time student is stuck |
| EO-MicroSaaS-Launch-Guide | Full technical stack guide (Next.js + Supabase + Coolify) | Step 4 and Step 5 |
| EO-Mastery-Checklist (XLSX) | 30-day plan, server deployment, ROI tracker, 25 prompts | Post-Step 5 |

## 10 Milestones (From Quick Reference Card)

These map to training progress:

1. Claude loaded with business context (Step 1)
2. All 5 scorecards completed (Step 0)
3. 12 brain files generated (Step 1)
4. GTM assets produced (Step 2)
5. First custom skill built (Step 3)
6. Architecture + BRD locked (Step 4)
7. Database schema deployed (Step 5a)
8. MVP application running (Step 5b)
9. QA + Security passed (Step 5d-e)
10. Production deployment live (Step 5f)

## Scorecard Details (for Step 0 Guidance)

| SC | Name | Questions | Max Score | Requires |
|----|------|-----------|-----------|----------|
| SC1 | Project Definition | 21 | 100 | Nothing |
| SC2 | ICP Clarity | 28 | 100 | SC1 |
| SC3 | Market Attractiveness | 25 | 100 | SC1 + SC2 |
| SC4 | Strategy Selector | AI-synthesized + 4 | 100 | SC1-SC3 |
| SC5 | GTM Fitness | 13 MC + weight matrix | 100 | SC1-SC4 |

Scoring order is sequential. SC2 requires SC1 context. SC3 requires SC1+SC2. And so on. Do not let students skip ahead.

Minimum to proceed past Step 0: SC1 + SC2 (but SC3-SC5 strongly recommended for richer brain files).
