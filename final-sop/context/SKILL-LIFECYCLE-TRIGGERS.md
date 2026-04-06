# Skill Lifecycle Triggers

> Maps every lifecycle event to the skill that should fire automatically.
> This is the single source of truth for "what runs when" across the AI-native dev org.

---

## Trigger Map

| Lifecycle Event | Trigger | Skill Invoked | Agent | Output |
|----------------|---------|---------------|-------|--------|
| BRD received | New BRD document committed or linked in Linear | `/write-spec` | VP Engineering | PRD with acceptance criteria |
| Sprint start | Sprint cycle begins in Linear | `/sprint-planning` | VP Engineering | Sprint plan with RICE scores + assignments |
| Ticket assigned (new system) | New feature ticket moves to In Progress | `/system-design` + `/architecture` | VP Engineering | ADR + system design doc |
| Ticket assigned (bug) | Bug ticket moves to In Progress | `/debug` (includes systematic debugging iron law) | VP Engineering | Root cause analysis + fix PR |
| During coding (pre-commit) | Code staged for commit | `/review-code` (self-review) | Authoring Agent | Pre-commit quality check |
| PR created | Pull request opened on dev branch | `/code-review` + Lana handover brief | QA Lead (Lana) | Review comments + handover brief |
| QA assigned | PR moves to QA column | `/test-webapp` + `/eo-qa-testing` | QA Lead (Lana) | Test results + score |
| Deploy to staging | Merge to staging branch | `/deploy-checklist` (staging variant) | DevOps Agent | Staging deploy checklist completed |
| Deploy to production | Staging approved, merge to main | `/deploy-checklist` (production variant) | DevOps Agent | Production deploy checklist + rollback plan |
| Incident detected | Alert fires or manual SEV report | `/incident-response` | DevOps Agent | Incident report with 5 Whys |
| Weekly cadence | Every Sunday (start of Gulf work week) | `/standup` + `/metrics-review` | CEO Agent | Weekly status + metrics dashboard |
| Quarterly cadence | First week of quarter | `/roadmap-update` + `/tech-debt` | VP Engineering + CEO | Roadmap refresh + tech debt audit |
| Project kickoff | New project created in Linear | `/system-design` + `/architecture` | VP Engineering | Architecture doc + ADR + initial sprint plan |
| Handover to Lana | PR ready for QA review | Lana handover brief template | Authoring Agent | Completed LANA-HANDOVER-BRIEF.md |

---

## n8n Automation Workflows (smo-dev)

| Workflow | ID | Trigger | What It Does |
|----------|----|---------|-------------|
| Weekly Stakeholder Update | `8X7AZ4MeT2QgCeu9` | Sunday 9am Dubai (5am UTC) | Fetches Linear issues, formats summary, sends to Mamoun via Telegram |
| Tech Debt Quarterly Review | `dQ1wbJaQu6FE79wq` | First Monday of Jan/Apr/Jul/Oct | Scans GitHub for tech-debt issues, creates Linear review ticket |
| Linear Issue Done → Summary | `Nt3HAjdA95oA3hS4` | Linear webhook (issue → completed) | Formats completion notice, sends to Mamoun via Telegram |
| BRD → Auto-PRD Pipeline | `YOKimeuDuOG8woFW` | Webhook POST to `/brd-to-prd` | Validates BRD, generates PRD via Claude, files in Linear |

**Activation:** All workflows created inactive. Set env vars (`LINEAR_API_KEY`, `TELEGRAM_WEBHOOK_URL`, `ANTHROPIC_API_KEY`) then activate.

---

## Notes

- **Trigger detection** is handled by Linear webhook + n8n workflow, not by agents polling.
- **Skill invocation** is the agent's responsibility once triggered. The agent reads the trigger context and invokes the appropriate skill.
- **Multiple skills per event** are executed sequentially by the assigned agent unless marked as parallelizable.
- **Override:** Any agent can invoke any skill manually. This table defines the automatic defaults.
- **MENA overlay** skills (Arabic RTL checks, Gulf calendar adjustments) fire in addition to the above when `mena-context` tag is present on the Linear project.
