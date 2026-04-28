# ADR Template: Architecture Decision Record

Use this template whenever a significant decision is made between alternatives.
Create as a Linear document attached to the relevant ticket.

---

## ADR-[NUMBER]: [Decision Title]

**Date:** [YYYY-MM-DD]
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-[N]
**Decider:** [Name]
**Stakeholders:** [Names]
**Ticket:** [SMO-XXX]

### 1. Context

What is the situation that requires a decision? What problem are we solving? What constraints exist?

Keep this factual. No opinions yet. 2-4 sentences.

### 2. Options Considered

#### Option A: [Name]
- **Description:** What this option entails (1-2 sentences)
- **Pros:** [List specific advantages]
- **Cons:** [List specific disadvantages]
- **Estimated effort:** [hours or 90-min blocks]
- **Estimated cost:** [if applicable]

#### Option B: [Name]
- **Description:** [same structure]
- **Pros:** [List]
- **Cons:** [List]
- **Estimated effort:** [hours or 90-min blocks]
- **Estimated cost:** [if applicable]

#### Option C: [Name] (if applicable)
[Same structure]

### 3. Decision

We chose **Option [X]** because: [1-2 sentence justification focusing on the commercial or execution impact]

### 4. Trade-offs Accepted

What are we giving up by making this choice? Be specific.

- [Trade-off 1]: We accept [downside] in exchange for [upside]
- [Trade-off 2]: [Same structure]

### 5. Consequences

**Immediate actions required:**
- [ ] [Action 1 with owner and deadline]
- [ ] [Action 2]

**What changes as a result:**
- [System/process/tool change 1]
- [System/process/tool change 2]

**Reversal cost:** How hard is it to undo this decision?
- Easy (< 1 day) | Medium (1-3 days) | Hard (> 1 week) | Irreversible

---

## Examples of When to Write an ADR

| Situation | ADR Required? |
|---|---|
| Choosing between Instantly and Lemlist for cold email | Yes |
| Deciding to use n8n vs Relevance AI for a workflow | Yes |
| Changing pricing on a training offer | Yes |
| Deciding to skip a campaign phase | Yes |
| Choosing between thumbnail designs | No (operational) |
| Fixing a typo in a post | No (trivial) |
| Switching a project deadline by > 3 days | Yes |
| Adding a new tool to the stack | Yes |

## Decision Rights Reference

| Decision Type | Who Decides | Who Must Be Informed |
|---|---|---|
| GTM strategy, offers, pricing | Mamoun | All |
| Campaign architecture (within approved strategy) | Ruba | Mamoun |
| Training offer packaging, launch timing | Razan | Mamoun |
| Content angle, LinkedIn messaging | Nour | Ruba or Razan (depending on track) |
| Technical architecture, deployment | Lana | Mamoun |
| Skill modifications | Mamoun | All |
| Tool additions or changes | Mamoun | All |
