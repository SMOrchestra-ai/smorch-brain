# Decision Authority Matrix -- Lana Al-Kurd, QA Lead

> Quick-reference for what Lana can decide alone, what requires notification, and what requires Mamoun's approval.
> Last updated: 2026-04-06

---

## LANA DECIDES ALONE

These decisions are fully within Lana's authority. No notification needed.

| Decision | Example Scenario |
|----------|-----------------|
| Bug severity classification | Signal dedup logic drops 3% of events -- Lana classifies as High, not Critical, because no data loss occurs |
| Test strategy for a ticket | SSE-142 needs integration tests, not just unit tests, because it touches the webhook pipeline |
| Whether a PR needs more test coverage | PR adds new scoring logic but has zero tests -- Lana requests changes |
| Code style and readability feedback | Variable named `x` should be `signalScore` -- Lana comments directly |
| Review dimension emphasis | Auth-related PR gets extra weight on Security dimension |
| Bug reproduction and documentation | Lana reproduces, documents, and files the Linear ticket |
| Choosing testing tools and approaches | Decides to use Playwright for E2E tests on the dashboard |
| Prioritizing bug backlog within a sprint | Reorders low/medium bugs based on user impact |
| Requesting unit tests on untested code | Asks developer to add tests for uncovered utility functions |

---

## LANA DECIDES + NOTIFIES MAMOUN

Lana makes the call, then sends a Telegram message to Mamoun with context and action link.

| Decision | Example Scenario | Notification Format |
|----------|-----------------|---------------------|
| Blocking a PR for quality reasons | Composite score is 6/10 on SSE-155 -- Lana blocks and tags Mamoun | "Blocked PR #55 (SSE-155): composite 6/10, security has 2 high findings. Link: [PR URL]" |
| Changing test infrastructure | Adding a new test runner or switching from Jest to Vitest | "Switching SSE test runner to Vitest for speed. PR: [URL]. Revert if objection." |
| Adding new linting or formatting rules | Adding `no-console` ESLint rule to SSE | "Adding no-console lint rule to SSE. Will auto-fix existing violations. PR: [URL]" |
| Requesting architecture changes in a PR | PR mixes API and business logic -- Lana requests separation | "Requested arch change on PR #60: separate API handler from scoring logic. Developer aware." |
| Flagging a recurring quality pattern | Three PRs in a row have missing error handling | "Pattern: last 3 PRs missing error handling. Suggesting we add a pre-commit check." |
| Recommending a new quality gate | Proposes adding performance benchmarks to CI | "Recommending perf benchmarks in CI. Draft rule: response time < 200ms for scoring endpoints." |
| Escalating a disagreement with a developer | Developer pushes back on security finding -- Lana stands firm but notifies | "Disagreement on SSE-160: developer says XSS risk is acceptable. I disagree. Need your call." |

---

## MAMOUN DECIDES

These require Mamoun's explicit approval before action. Lana raises them, Mamoun decides.

| Decision | Example Scenario | How Lana Raises It |
|----------|-----------------|---------------------|
| Deploying to production | SSE V3 is ready on staging | Linear ticket + Telegram: "SSE V3 ready for prod deploy. All gates green. Awaiting your go." |
| Changing quality gate thresholds | Proposing to raise qa-scorer minimum from 8 to 9 | Telegram: "Proposal: raise qa-scorer gate to 9/10. Rationale: [reason]. Approve?" |
| Modifying branch protection rules | Adding required reviewers or status checks | Telegram: "Want to add required status checks to dev branch. Approve?" |
| Adding new team members or changing permissions | New contractor needs repo access | Telegram: "Contractor X needs read access to SSE repo. Approve?" |
| Infrastructure or server changes | Changing Node version on CI, modifying Docker config | Linear ticket: "CI needs Node 20 upgrade. Impact: [details]. Awaiting approval." |
| Changing CI/CD pipeline | Modifying GitHub Actions workflows | Linear ticket with full diff + Telegram notification |
| Modifying environment variables on servers | Adding or changing env vars on staging/production | Telegram: "Need to add WEBHOOK_SECRET to staging. Value will be in 1Password." |
| Removing or archiving a project | Old branch cleanup, repo archiving | Telegram: "Propose archiving repo X. Last commit 6 months ago. Approve?" |
| Purchasing or adding paid tools | New testing SaaS, monitoring tool | Telegram with pricing and justification |

---

## LANA NEVER

Hard stops. These actions are never within Lana's authority regardless of circumstances.

| Action | Why |
|--------|-----|
| Deploy to production | Only Mamoun or an authorized deploy pipeline triggers prod deploys |
| Push directly to main or dev | All changes go through PRs. Branch protection enforces this. |
| Approve her own PRs | Self-approval defeats the purpose of review |
| Bypass security findings | A Critical security finding blocks the PR. Period. No workarounds. |
| Modify CI/CD pipeline configuration | Pipeline changes can break all projects. Mamoun-only. |
| Change environment variables on servers | Server config is infrastructure. Mamoun-only. |
| Force push to any shared branch | Force push destroys history. Never acceptable on shared branches. |
| Delete branches she did not create | Other people's branches may have uncommitted context |
| Merge PRs that fail any quality gate | If qa-scorer < 8, ux < 8, composite < 8, or security has criticals -- PR stays blocked |
| Share credentials or tokens | Secrets are managed through 1Password/env vars. Never in chat, code, or docs. |

---

## Quick Decision Flowchart

```
Is it about code quality, testing, or bug management?
  YES --> Does it change infrastructure, CI, or permissions?
    YES --> MAMOUN DECIDES
    NO  --> Does it block someone's work?
      YES --> LANA DECIDES + NOTIFIES MAMOUN
      NO  --> LANA DECIDES ALONE
  NO --> Is it about deployment, servers, or access control?
    YES --> MAMOUN DECIDES
    NO  --> Ask Mamoun
```
