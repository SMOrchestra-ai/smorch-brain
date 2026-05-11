# eo-microsaas-training — Internal Docs Archive

Internal docs that previously lived in [`smorchestraai-code/eo-microsaas-training`](https://github.com/smorchestraai-code/eo-microsaas-training). Moved here on 2026-05-11 to keep the student-facing repo lean.

## Why this lives in smorch-brain (not the student repo)

The student-facing `eo-microsaas-training` repo is what paying training students clone via `git clone` then `bash install.sh`. Anything they don't NEED for the install or their daily work is noise that:

1. Bloats the clone size (BorisFramework images alone are ~217KB)
2. Exposes SMOrchestra-internal methodology (SOPs, framework images, exec summaries)
3. Confuses students browsing the repo for the install command

## Contents

| Path | Origin | Why internal |
|---|---|---|
| `BorisFramework/` | `eo-microsaas-training/BorisFramework/` | SMOrchestra engineering methodology — images of the Boris framework + boris.md explanation. Internal-only reference. |
| `sops/` | `eo-microsaas-training/sops/` | SOPs for our deployment, git workflow, and quality scorecard. Students follow the student playbook (CLAUDE.md), not these. |
| `reference/DEVELOPMENT-WORKFLOW-EXPLAINED.md` | `eo-microsaas-training/reference/` | Internal dev workflow explainer. Not needed for student install or use. |
| `docs/COWORK-REVAMP-CLAUDE-CODE-SLIDES.md` | `eo-microsaas-training/docs/` | Internal pilot slide deck for Cowork revamp. |
| `docs/COWORK-REVAMP-EO-MICROSAAS-OS.md` | `eo-microsaas-training/docs/` | Internal planning doc for the OS pivot. |
| `docs/PILOT-WEEK-RANKING-PLAN.md` | `eo-microsaas-training/docs/` | Internal pilot-week ranking plan. |
| `docs/STRUCTURE.md` | `eo-microsaas-training/docs/` | Internal repo-structure doc. |
| `docs/v1.4.0-executive-summary.docx` | `eo-microsaas-training/docs/` | Internal executive summary (Word doc — definitely shouldn't be student-facing). |
| `CONTRIBUTING.md` | `eo-microsaas-training/CONTRIBUTING.md` | Contributor guide. Students are consumers, not contributors. |

## What students still see in `eo-microsaas-training`

After this move, the student-facing repo contains only:

```
.claude-plugin/      ← marketplace manifest (REQUIRED for plugin install)
.claude/lessons.md   ← student lesson tracking
.gitignore
CHANGELOG.md         ← student-visible release notes
CLAUDE.md            ← STUDENT PLAYBOOK (copied to ~/.claude/CLAUDE.md by install.sh)
LICENSE
README.md            ← student entry point
install.sh           ← the bootstrap script
settings.json        ← STUDENT HOOKS (copied to ~/.claude/settings.json)
eo-microsaas-dev/    ← the plugin content being installed
examples/            ← student-facing usage examples
templates/           ← student-facing BRD / QA / Deploy templates
courses/             ← student-facing course material
```

Clean. Focused on what a paying student actually needs.
