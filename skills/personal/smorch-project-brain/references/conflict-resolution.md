# Conflict Resolution — Rules for Contradictory Data Between Inputs

## PURPOSE
When multiple inputs provide conflicting data for the same field, these rules determine which source wins.

---

## PRIORITY HIERARCHY (Highest to Lowest)

1. **User verbal correction** — Always wins. If Mamoun says "the price is $3,000," it's $3,000 regardless of what files say
2. **User verbal input** — Original verbal context (not a correction, but first-time verbal data)
3. **Newer uploaded file** — More recent file by upload timestamp
4. **Older uploaded file** — Earlier file by upload timestamp
5. **Web research** — Scraped data from websites/LinkedIn
6. **System inference** — Data the system inferred from context (lowest priority)

---

## CONFLICT DETECTION

### Same Field, Different Values
When two sources provide different values for the same brain field:

**Auto-resolve (don't ask user):**
- Verbal always wins over file
- Newer file always wins over older file
- Log the resolution: "[field]: resolved to [value] from [source], overriding [old value] from [old source]"

**Ask user (present both options):**
- File says X, web research says Y (neither is clearly more authoritative)
- Two files uploaded at the same time say different things
- Verbal from current session contradicts verbal from a previous brain version

**Format for asking:**
```
CONFLICT: [field name] in [brain file]
  Source A: "[value A]" (from: [filename or "verbal"])
  Source B: "[value B]" (from: [filename or "web research"])

Which is correct? (Or provide the right answer)
```

### Inconsistent Framing (Same Data, Different Angle)
When two sources describe the same thing but frame it differently:

**Example:** Deck says "We help businesses grow" but verbal says "We build signal detection engines for B2B sales teams"

**Resolution:** Use the MORE SPECIFIC framing. "Signal detection engines for B2B sales teams" > "help businesses grow." Tag: "[REFINED: merged from [source A] and [source B], selected more specific framing]"

### Partial Overlap
When one source has partial data and another source fills in the gaps:

**Resolution:** Merge both. No conflict exists; they complement each other. Tag fields with their respective sources.

---

## SPECIAL CASES

### Pricing Conflicts
Price is the most sensitive field. NEVER auto-resolve pricing conflicts.
- Always ask user to confirm
- Present all pricing data found with sources
- Include competitive pricing context if available

### ICP Conflicts
When multiple sources describe different customers:
- Ask: "Are these different personas (both valid) or is one more accurate?"
- If both valid: make one PRIMARY and note the other as SECONDARY persona
- If one is more accurate: use it and discard the other

### Positioning Conflicts
When different sources position the product differently:
- This is common (decks for investors vs. decks for customers)
- Ask: "Which audience is this brain for?" and use the positioning that matches
- Log the alternative positioning in brain-log.md for future reference

---

## LOGGING

All conflict resolutions must be logged in brain-log.md:

```markdown
### Conflicts Resolved
- [field]: [winning value] from [source] (overrode: [losing value] from [other source], reason: [rule applied])
```
