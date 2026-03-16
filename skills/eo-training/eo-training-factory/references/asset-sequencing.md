# Asset Sequencing Logic

Why the deliverables are built in this order, and when you can safely deviate.

## The Dependency Graph

```
Training Macro (Phase 0)
    │
    ├── Curriculum Guide ──────────────────┐
    │       │                              │
    │       ├── Strategy Selector          │
    │       │   (parallel, independent)    │
    │       │                              │
    │       ├── Student Checklist          │
    │       │   (parallel, independent)    │
    │       │                              │
    │       └── Student Card              │
    │           (after Checklist)          │
    │                                      │
    │   ┌──────────────────────────────────┘
    │   │
    │   ├── Slide Decks ──────────┐
    │   │                         │
    │   ├── Trainer Guide ────────┤ (needs Slides + Curriculum)
    │   │                         │
    │   └── Training Ops ─────────┘ (needs Slides for timeline)
    │
    │   ┌──────────────────────────────────
    │   │
    │   ├── YouTube Video Preps ──┐
    │   │                         │
    │   ├── LinkedIn Posts ───────┤ (derives from YouTube messaging)
    │   │                         │
    │   ├── VSL Scripts ──────────┤ (distills YouTube + LinkedIn)
    │   │                         │
    │   ├── VSL Landing Page ─────┤ (built around VSL script)
    │   │                         │
    │   ├── Outbound Sequences ───┤ (needs all messaging)
    │   │                         │
    │   └── Signal Playbook ──────┘ (triggers the sequences)
    │
```

## Why This Order (Not Another)

### The Contrarian Logic

Most people build GTM first: "start selling before you build." That logic doesn't apply here because:

**Your training IS your GTM.** YouTube preps, LinkedIn posts, and outbound sequences all reference specific training content: frameworks, live demos, MENA proof points. If you build GTM before the Curriculum Guide, they'll be vague. Generic. The exact kind of "imported playbook" garbage EO fights against.

The Curriculum Guide locks the specificity. Then every downstream asset carries that specificity forward. The result: your outbound email references "the exact moment in Step 2 where I score 13 GTM motions for EO live" instead of "learn AI tools for your business."

### Exception: Strategy Selector

The Strategy Selector goes to Phase 1 position #2 (not after slides) because it's both a training asset AND a GTM asset. A founder takes the diagnostic, gets their score, and the CTA is "want to learn what to do with this score? Watch the free hour." It's a standalone lead magnet independent of training content.

## Parallel Build Opportunities

Within each phase, some deliverables can be built in parallel:

**Phase 1 parallels:**
- Strategy Selector, Student Checklist, and Student Card can all be built simultaneously once the Curriculum Guide is complete
- Strategy Selector can even start in parallel with the Curriculum Guide (it depends on frameworks, not curriculum content)

**Phase 2 parallels:**
- Slide Decks for different steps can be built in parallel
- Training Ops Checklist can start once slide deck structure is defined (doesn't need content)

**Phase 3 parallels:**
- LinkedIn Posts can start once YouTube Preps for the same step are done (step-level parallelism)
- Outbound Sequences and Signal Playbook can be built in parallel

## When to Deviate

Safe deviations:
- Building Strategy Selector in parallel with Curriculum Guide (different dependency)
- Building slide decks for early steps while curriculum for later steps is still being written
- Starting YouTube Preps for Step 1 while finishing slide decks for Step 5

Dangerous deviations:
- Building VSL before YouTube Preps (messaging won't be crystallized enough)
- Building Outbound Sequences before Curriculum Guide (references will be vague)
- Building Trainer Guide before Slide Decks (can't annotate slides that don't exist)
- Building Landing Page before VSL Scripts (page structure depends on script structure)

## Timeline Estimation

Per deliverable complexity:

| Complexity | Working Session | Examples |
|-----------|----------------|----------|
| Heavy | 1-2 sessions | Curriculum Guide, Slide Decks, YouTube Preps, Strategy Selector, VSL Landing Page |
| Medium | 0.5-1 session | Trainer Guide, Ops Checklist, LinkedIn Posts, VSL Scripts, Outbound Sequences, Signal Playbook |
| Light | 0.25-0.5 session | Student Card |

A "working session" = one focused Claude interaction session (typically 1-2 hours of real time).

**Total estimate for a full 14-deliverable build:** 10-13 working sessions.
