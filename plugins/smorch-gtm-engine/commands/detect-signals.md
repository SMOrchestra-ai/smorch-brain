---
description: Detect and validate buying signals for an ICP
argument-hint: "[icp-name or prospect-list-file]"
allowed-tools: Read, Write, Bash, Grep, Glob, Task, WebSearch, WebFetch, AskUserQuestion
---

Run signal detection and ICP validation using the signal-detector skill.

**If $1 is a file path**: Read the prospect list (CSV, JSON, or markdown) and validate each prospect.

**If $1 is an ICP name**: Load ICP criteria and search for signals using available data sources.

**If no argument**: Ask the user which ICP to target and whether they have a prospect list.

**Execution:**

1. **Load ICP Criteria**
   - Match to known ICPs: MENA SaaS Founders, US Real Estate Brokers, MENA Beauty Clinics, US eCommerce
   - For custom ICPs, ask for: industry, company size, geography, titles, revenue range

2. **Apply Hard Stop Rule 1: ICP Fit Gate**
   - Every prospect must pass fit criteria BEFORE signal evaluation
   - Fit=Fail → STOP immediately. No outreach regardless of signal strength.
   - Check: industry match, company size, geography, title relevance

3. **Apply Hard Stop Rule 2: Signal Freshness**
   - Signal > 90 days old → STOP. Stale signals produce bad outreach.
   - Exception: evergreen signals (company size, industry) don't decay

4. **Classify Signals**
   For each prospect that passes fit:
   - **Trust Signals**: Company awards, case studies published, industry speaking, content creation, certification announcements
   - **Intent Signals**: Job postings (hiring sales/marketing), funding rounds, tech stack changes, competitor mentions, pricing page visits, RFP activity

5. **Score and Rank**
   - Signal strength: strong / moderate / weak
   - Signal confidence: high / medium / low (based on source reliability)
   - Combined score determines outreach priority

6. **Output**
   - Summary: total prospects, fit pass/fail rate, signal type distribution
   - Validated prospect list with: name, company, fit status, signals detected, classification, score
   - Save to workspace: `signals/[icp-name]-[date]-validated.json`
   - Recommended: top 20 prospects ranked by signal strength for immediate outreach
