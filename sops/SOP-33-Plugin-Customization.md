# SOP-33 — Plugin Customization Per Project (enforced)

**Status:** Active 2026-04-23
**Supersedes:** SOP-09 Skill-Injection-Registry + SOP-12 Claude-Code-Skill-Injection (both legacy; this SOP covers DEV-layer plugin selection, SOP-25 covers APP-layer runtime skill injection)

## The single source of truth

`{repo}/.smorch/project.json` field `dev_plugin` declares which Claude Code plugin powers this repo's dev workflow.

Valid values:
- `smorch-dev` (default — SMO internal team)
- `eo-microsaas-dev` (EO students; /eo-* commands, 90+ gate)
- `none` (research spike — no gates, no plugin)
- `{custom-id}` (client engagements — must be registered in `smorch-brain/canonical/plugin-registry.md`)

## Mandatory declarations per repo

1. **`.smorch/project.json`**: `dev_plugin` field + optional `plugin_marketplace`
2. **`CLAUDE.md` line 1 block**: states "This project uses the **{plugin-id}** plugin" verbatim
3. **`docs/` references**: all `/smo-*` command references match the declared plugin (auto-rewritten by `/smo-plugin-migrate` helper when switching plugins)

## Enforcement (pre-commit hook)

`smorch-dev/scripts/hooks/validate-plugin-overlay.sh`:

```bash
#!/bin/bash
[ ! -f .smorch/project.json ] && { echo "ERROR: .smorch/project.json missing"; exit 1; }
PLUGIN=$(jq -r '.dev_plugin // "missing"' .smorch/project.json)
[ "$PLUGIN" = "missing" ] && { echo "ERROR: .smorch/project.json has no dev_plugin field"; exit 1; }
[ "$PLUGIN" = "none" ] && exit 0  # spike — skip
if ! grep -q "This project uses the \*\*$PLUGIN\*\* plugin" CLAUDE.md 2>/dev/null; then
  echo "ERROR: CLAUDE.md top-of-file must declare plugin matching .smorch/project.json"
  echo "Expected block: 'This project uses the **$PLUGIN** plugin'"
  exit 1
fi
exit 0
```

Install on Mamoun's + Lana's Macs via `eng-desktop.sh`. Install on every server via `sync-from-github.sh` (runs every 30min).

## Skill/plugin/template injection decision tree

| Question | Answer | Home |
|---|---|---|
| Is this a slash command for engineers? (`/smo-plan`, `/eo-code`) | Yes | `~/.claude/plugins/{plugin-id}/commands/` |
| Is this a skill the engineer invokes during dev (test-driven-development, systematic-debugging)? | Yes | `~/.claude/plugins/{plugin-id}/skills/` OR `smorch-brain/skills/dev-meta/` |
| Is this a skill the DEPLOYED app injects into its own Claude API calls at runtime? | Yes | `{repo}/skills/` + declared in `{repo}/skills/runtime-skills.json` |
| Is this a template for dev-layer skills to render content? | Yes | `smorch-brain/skills/{category}/templates/` |
| Is this business context (project brain, brand voice, ICP)? | Yes | `{repo}/project-brain/` |

**Anti-pattern (blocked by pre-commit):** putting DEV-layer skills in `{repo}/skills/`. That dir is reserved for APP-layer runtime skills (per ADR-004). Dev skills bloat deployed app bundles and mask runtime bugs.

## How to add a new plugin

1. Create the plugin per Claude Code docs (`plugin.json` + `commands/` + `skills/` dirs)
2. Host in appropriate repo:
   - Internal-only (SMO team): new dir under `smorch-dev/plugins/` OR new repo in `SMOrchestra-ai`
   - Distributed to students/customers: new repo in `smorchestraai-code` with marketplace
3. Register in `smorch-brain/canonical/plugin-registry.md` with: plugin-id, marketplace, audience, ship-gate-threshold, command-prefix
4. Install test: `claude plugin install {id}@{marketplace}` on a clean test machine
5. Run `/smo-drift --desktop` to confirm no conflicts with existing plugins

## How to switch a repo's plugin

```bash
cd {repo}
# 1. Update overlay
jq '.dev_plugin = "eo-microsaas-dev"' .smorch/project.json > .smorch/project.json.tmp && mv .smorch/project.json.tmp .smorch/project.json
# 2. Update CLAUDE.md
# Manually rewrite the plugin declaration block + command references
# 3. Commit — pre-commit hook validates alignment
git add .smorch/project.json CLAUDE.md
git commit -m "chore(plugin): switch dev_plugin smorch-dev → eo-microsaas-dev"
```

## Enforcement beyond pre-commit

- **`/smo-*` commands** (in smorch-dev plugin) read `.smorch/project.json` on invocation. If `dev_plugin != "smorch-dev"`, they print: "This project uses {plugin}. Run `/{prefix}-{command}` instead." + exit.
- **`/smo-drift --desktop`** checks every local clone — flags mismatches between declared plugin and installed plugin on this machine.
- **`/smo-skill-sync --audit`** reports plugin-layer skills that accidentally landed in `{repo}/skills/` (APP-layer violation per ADR-004).

## Demo/training use case (student using eo-microsaas-dev)

Full workflow in Guide 03 (`guides/03-CUSTOMIZE-DEV-PLUGIN.md`). Key points:
- Student's CLAUDE.md declares `eo-microsaas-dev`
- Student's `.smorch/project.json` sets relaxed gates (90 vs 92)
- Student runs `/eo-plan` → `/eo-code` → `/eo-score` → `/eo-ship` (not `/smo-*`)
- Training machine provisioned via `eng-desktop.sh --eo-flag` which installs eo-microsaas-dev plugin in addition to smorch-dev
