# Server & Machine Alignment Instructions

**Date:** 2026-03-24
**Purpose:** Bring any Claude Code machine to 10/10 parity with Mamoun's desktop
**Time:** ~5 minutes per machine

---

## What This Installs

| Component | What It Does |
|-----------|-------------|
| **5 hooks** | Destructive command blocker, Supabase SQL guard, secret scanner, auto-formatter, compaction restorer, session bootstrap |
| **3 agents** | code-reviewer (with persistent memory), test-runner (with persistent memory), pr-creator (with auto-labeling) |
| **3 rules** | infra-guard, auth-security, database-guard (load only when touching matching files) |
| **Git hook** | Conventional commit enforcer (rejects bad commit messages at git level) |
| **Latest skills** | Profile-specific skills from smorch-brain registry |

---

## Instructions for smo-brain

Paste this entire block into Claude Code on smo-brain:

```
Align this machine with the SMOrchestra AI-native architecture. Execute ALL steps in order. Do NOT skip any step. Do NOT ask questions — just execute.

STEP 1 — Pull latest from smorch-brain:
cd ~/smorch-brain && git pull origin dev
smorch pull --profile smo-brain
smorch status

STEP 2 — Install hooks in settings.json:
Read the current ~/.claude/settings.json (create if missing).
Merge the hooks from ~/smorch-brain/docs/settings-hooks-reference.json into it.
The final file must have ALL of these hook sections:
- PreToolUse: Bash (destructive command blocker), mcp__cb73f37d* (SQL guard), Write|Edit (secret scanner)
- PostToolUse: Write|Edit (auto-formatter with prettier)
- PostCompact: manual|auto (context restorer)
- SessionStart: * (session bootstrap)

IMPORTANT: Do NOT include enabledPlugins or skipDangerousModePermissionPrompt — those are desktop-only settings.

Read ~/smorch-brain/docs/settings-hooks-reference.json for the exact hook content. Merge it into ~/.claude/settings.json preserving any existing settings.

STEP 3 — Install agents:
mkdir -p ~/.claude/agents
cp ~/smorch-brain/docs/agents-templates/code-reviewer.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/test-runner.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/pr-creator.md ~/.claude/agents/

STEP 4 — Install conditional rules:
mkdir -p ~/.claude/rules
cp ~/smorch-brain/docs/rules-templates/infra-guard.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/auth-security.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/database-guard.md ~/.claude/rules/

STEP 5 — Install git commit hook on all local repos:
for repo in ~/smorch-brain $(find ~/workspaces -maxdepth 2 -name .git -type d 2>/dev/null | xargs -I{} dirname {}); do
  if [ -d "$repo/.git" ]; then
    cp ~/smorch-brain/hooks/commit-msg "$repo/.git/hooks/commit-msg"
    chmod +x "$repo/.git/hooks/commit-msg"
    echo "Hook installed: $repo"
  fi
done

STEP 6 — Verify everything:
echo "=== VERIFICATION ==="
echo -n "smorch CLI: " && smorch --help >/dev/null 2>&1 && echo "✅" || echo "❌"
echo -n "Profile: " && smorch status 2>/dev/null | grep "Profile:"
echo -n "Skills: " && smorch status 2>/dev/null | grep "Installed:"
echo ""
echo "--- Hooks ---"
echo -n "Destructive blocker: " && jq '.hooks.PreToolUse[0].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Bash" && echo "✅" || echo "❌"
echo -n "SQL guard: " && jq '.hooks.PreToolUse[1].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "mcp__cb73f37d" && echo "✅" || echo "❌"
echo -n "Secret scanner: " && jq '.hooks.PreToolUse[2].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Write" && echo "✅" || echo "❌"
echo -n "Auto-formatter: " && jq '.hooks.PostToolUse' ~/.claude/settings.json 2>/dev/null | grep -q "prettier" && echo "✅" || echo "❌"
echo -n "Compaction restorer: " && jq '.hooks.PostCompact' ~/.claude/settings.json 2>/dev/null | grep -q "CONTEXT RESTORE" && echo "✅" || echo "❌"
echo -n "Session bootstrap: " && jq '.hooks.SessionStart' ~/.claude/settings.json 2>/dev/null | grep -q "SESSION BOOTSTRAP" && echo "✅" || echo "❌"
echo ""
echo "--- Agents ---"
echo -n "code-reviewer: " && ls ~/.claude/agents/code-reviewer.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "test-runner: " && ls ~/.claude/agents/test-runner.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "pr-creator: " && ls ~/.claude/agents/pr-creator.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Rules ---"
echo -n "infra-guard: " && ls ~/.claude/rules/infra-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "auth-security: " && ls ~/.claude/rules/auth-security.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "database-guard: " && ls ~/.claude/rules/database-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Git Hook ---"
echo -n "Commit hook: " && ls ~/smorch-brain/.git/hooks/commit-msg 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "=== ALL ITEMS MUST SHOW ✅ ==="

Report the full verification output.
```

---

## Instructions for smo-dev

Paste this entire block into Claude Code on smo-dev:

```
Align this machine with the SMOrchestra AI-native architecture. Execute ALL steps in order. Do NOT skip any step. Do NOT ask questions — just execute.

STEP 1 — Pull latest from smorch-brain:
cd ~/smorch-brain && git pull origin dev
smorch pull --profile smo-dev
smorch status

STEP 2 — Install hooks in settings.json:
Read the current ~/.claude/settings.json (create if missing).
Merge the hooks from ~/smorch-brain/docs/settings-hooks-reference.json into it.
The final file must have ALL of these hook sections:
- PreToolUse: Bash (destructive command blocker), mcp__cb73f37d* (SQL guard), Write|Edit (secret scanner)
- PostToolUse: Write|Edit (auto-formatter with prettier)
- PostCompact: manual|auto (context restorer)
- SessionStart: * (session bootstrap)

IMPORTANT: Do NOT include enabledPlugins or skipDangerousModePermissionPrompt — those are desktop-only settings.

Read ~/smorch-brain/docs/settings-hooks-reference.json for the exact hook content. Merge it into ~/.claude/settings.json preserving any existing settings.

STEP 3 — Install agents:
mkdir -p ~/.claude/agents
cp ~/smorch-brain/docs/agents-templates/code-reviewer.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/test-runner.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/pr-creator.md ~/.claude/agents/

STEP 4 — Install conditional rules:
mkdir -p ~/.claude/rules
cp ~/smorch-brain/docs/rules-templates/infra-guard.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/auth-security.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/database-guard.md ~/.claude/rules/

STEP 5 — Install git commit hook on all local repos:
for repo in ~/smorch-brain $(find ~/workspaces -maxdepth 2 -name .git -type d 2>/dev/null | xargs -I{} dirname {}); do
  if [ -d "$repo/.git" ]; then
    cp ~/smorch-brain/hooks/commit-msg "$repo/.git/hooks/commit-msg"
    chmod +x "$repo/.git/hooks/commit-msg"
    echo "Hook installed: $repo"
  fi
done

STEP 6 — Verify everything:
echo "=== VERIFICATION ==="
echo -n "smorch CLI: " && smorch --help >/dev/null 2>&1 && echo "✅" || echo "❌"
echo -n "Profile: " && smorch status 2>/dev/null | grep "Profile:"
echo -n "Skills: " && smorch status 2>/dev/null | grep "Installed:"
echo ""
echo "--- Hooks ---"
echo -n "Destructive blocker: " && jq '.hooks.PreToolUse[0].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Bash" && echo "✅" || echo "❌"
echo -n "SQL guard: " && jq '.hooks.PreToolUse[1].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "mcp__cb73f37d" && echo "✅" || echo "❌"
echo -n "Secret scanner: " && jq '.hooks.PreToolUse[2].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Write" && echo "✅" || echo "❌"
echo -n "Auto-formatter: " && jq '.hooks.PostToolUse' ~/.claude/settings.json 2>/dev/null | grep -q "prettier" && echo "✅" || echo "❌"
echo -n "Compaction restorer: " && jq '.hooks.PostCompact' ~/.claude/settings.json 2>/dev/null | grep -q "CONTEXT RESTORE" && echo "✅" || echo "❌"
echo -n "Session bootstrap: " && jq '.hooks.SessionStart' ~/.claude/settings.json 2>/dev/null | grep -q "SESSION BOOTSTRAP" && echo "✅" || echo "❌"
echo ""
echo "--- Agents ---"
echo -n "code-reviewer: " && ls ~/.claude/agents/code-reviewer.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "test-runner: " && ls ~/.claude/agents/test-runner.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "pr-creator: " && ls ~/.claude/agents/pr-creator.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Rules ---"
echo -n "infra-guard: " && ls ~/.claude/rules/infra-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "auth-security: " && ls ~/.claude/rules/auth-security.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "database-guard: " && ls ~/.claude/rules/database-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Git Hook ---"
echo -n "Commit hook: " && ls ~/smorch-brain/.git/hooks/commit-msg 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "=== ALL ITEMS MUST SHOW ✅ ==="

Report the full verification output.
```

---

## Instructions for Developer Team Machines

Paste this entire block into Claude Code on ANY team developer machine:

```
Align this machine with the SMOrchestra AI-native architecture. Execute ALL steps in order. Do NOT skip any step. Do NOT ask questions — just execute.

STEP 0 — Bootstrap (first time only, skip if smorch-brain already exists):
If ~/smorch-brain does NOT exist:
  git clone git@github.com:SMOrchestra-ai/smorch-brain.git ~/smorch-brain
  chmod +x ~/smorch-brain/scripts/smorch
  mkdir -p ~/bin
  ln -sf ~/smorch-brain/scripts/smorch ~/bin/smorch
  export PATH="$HOME/bin:$PATH"

STEP 1 — Pull latest from smorch-brain:
cd ~/smorch-brain && git pull origin dev
smorch pull --profile developer
smorch status

STEP 2 — Install hooks in settings.json:
Read the current ~/.claude/settings.json (create if missing).
Merge the hooks from ~/smorch-brain/docs/settings-hooks-reference.json into it.
The final file must have ALL of these hook sections:
- PreToolUse: Bash (destructive command blocker), mcp__cb73f37d* (SQL guard), Write|Edit (secret scanner)
- PostToolUse: Write|Edit (auto-formatter with prettier)
- PostCompact: manual|auto (context restorer)
- SessionStart: * (session bootstrap)

IMPORTANT: Do NOT include enabledPlugins or skipDangerousModePermissionPrompt — those are desktop-only.

Read ~/smorch-brain/docs/settings-hooks-reference.json for the exact hook content. Merge it into ~/.claude/settings.json preserving any existing settings.

STEP 3 — Install agents:
mkdir -p ~/.claude/agents
cp ~/smorch-brain/docs/agents-templates/code-reviewer.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/test-runner.md ~/.claude/agents/
cp ~/smorch-brain/docs/agents-templates/pr-creator.md ~/.claude/agents/

STEP 4 — Install conditional rules:
mkdir -p ~/.claude/rules
cp ~/smorch-brain/docs/rules-templates/infra-guard.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/auth-security.md ~/.claude/rules/
cp ~/smorch-brain/docs/rules-templates/database-guard.md ~/.claude/rules/

STEP 5 — Install git commit hook on all local repos:
for repo in ~/smorch-brain $(find ~/Desktop/cowork-workspace -maxdepth 2 -name .git -type d 2>/dev/null | xargs -I{} dirname {}) $(find ~/workspaces -maxdepth 2 -name .git -type d 2>/dev/null | xargs -I{} dirname {}); do
  if [ -d "$repo/.git" ]; then
    cp ~/smorch-brain/hooks/commit-msg "$repo/.git/hooks/commit-msg"
    chmod +x "$repo/.git/hooks/commit-msg"
    echo "Hook installed: $repo"
  fi
done

STEP 6 — Verify everything:
echo "=== VERIFICATION ==="
echo -n "smorch CLI: " && smorch --help >/dev/null 2>&1 && echo "✅" || echo "❌"
echo -n "Profile: " && smorch status 2>/dev/null | grep "Profile:"
echo -n "Skills: " && smorch status 2>/dev/null | grep "Installed:"
echo ""
echo "--- Hooks ---"
echo -n "Destructive blocker: " && jq '.hooks.PreToolUse[0].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Bash" && echo "✅" || echo "❌"
echo -n "SQL guard: " && jq '.hooks.PreToolUse[1].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "mcp__cb73f37d" && echo "✅" || echo "❌"
echo -n "Secret scanner: " && jq '.hooks.PreToolUse[2].matcher' ~/.claude/settings.json 2>/dev/null | grep -q "Write" && echo "✅" || echo "❌"
echo -n "Auto-formatter: " && jq '.hooks.PostToolUse' ~/.claude/settings.json 2>/dev/null | grep -q "prettier" && echo "✅" || echo "❌"
echo -n "Compaction restorer: " && jq '.hooks.PostCompact' ~/.claude/settings.json 2>/dev/null | grep -q "CONTEXT RESTORE" && echo "✅" || echo "❌"
echo -n "Session bootstrap: " && jq '.hooks.SessionStart' ~/.claude/settings.json 2>/dev/null | grep -q "SESSION BOOTSTRAP" && echo "✅" || echo "❌"
echo ""
echo "--- Agents ---"
echo -n "code-reviewer: " && ls ~/.claude/agents/code-reviewer.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "test-runner: " && ls ~/.claude/agents/test-runner.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "pr-creator: " && ls ~/.claude/agents/pr-creator.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Rules ---"
echo -n "infra-guard: " && ls ~/.claude/rules/infra-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "auth-security: " && ls ~/.claude/rules/auth-security.md 2>/dev/null && echo "✅" || echo "❌"
echo -n "database-guard: " && ls ~/.claude/rules/database-guard.md 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "--- Git Hook ---"
echo -n "Commit hook (smorch-brain): " && ls ~/smorch-brain/.git/hooks/commit-msg 2>/dev/null && echo "✅" || echo "❌"
echo ""
echo "=== ALL ITEMS MUST SHOW ✅ ==="

Report the full verification output.
```

---

## Profile Reference

| Machine | Profile | Skills Count |
|---------|---------|-------------|
| Mamoun desktop | mamoun | 51 (all) |
| smo-brain | smo-brain | ~22 (EO + scoring + core) |
| smo-dev | smo-dev | ~11 (GTM + dev) |
| Team developer | developer | ~15 (dev-meta + tools) |
| GTM team member | gtm-team | ~20 (GTM + content + tools) |
| EO student | eo-student | ~10 (EO training + scoring) |

---

## What Gets Installed on Every Machine

```
~/.claude/
├── settings.json         ← 5 hooks (destructive blocker, SQL guard, secret scanner, formatter, compaction restorer, session bootstrap)
├── agents/
│   ├── code-reviewer.md  ← Senior code review with persistent memory
│   ├── test-runner.md    ← Test execution with persistent memory
│   └── pr-creator.md     ← PR creation with auto-labeling (agent-generated, high-risk, self-fixed)
├── rules/
│   ├── infra-guard.md    ← Loads when touching infra/, Dockerfile, CI workflows
│   ├── auth-security.md  ← Loads when touching auth/, security/, .env files
│   └── database-guard.md ← Loads when touching migrations/, .sql files
└── skills/               ← Profile-specific skills from smorch-brain registry
    ├── dev-meta/         ← Debugging, code review, GitHub ops, changelog
    ├── tools/            ← Testing, API docs, Supabase admin, Contabo deployment
    ├── smorch-gtm/       ← (if in profile) GTM operators
    ├── eo-training/      ← (if in profile) EO training skills
    ├── eo-scoring/       ← (if in profile) Scoring engines
    └── content/          ← (if in profile) Content creation
```

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `smorch: command not found` | PATH not set or symlink missing | `ln -sf ~/smorch-brain/scripts/smorch /usr/local/bin/smorch` (servers) or `~/bin/smorch` (Mac) |
| `jq: command not found` | jq not installed | `apt install jq` (Linux) or `brew install jq` (Mac) |
| Git hook rejects commits | Commit message doesn't match `type(scope): description` | Use format: `feat(TASK-XXX): description` |
| Settings.json malformed | Bad merge | Delete and recreate: `cp ~/smorch-brain/docs/settings-hooks-reference.json ~/.claude/settings.json` |
| Secret scanner false positive | Code contains sk- or AKIA in docs/examples | The hook exempts .md, .env.example, and settings.json files |
| SQL guard blocks a legitimate query | DDL statement detected | The hook blocks DROP, TRUNCATE, and mass DELETE. For legitimate DDL, run directly in Supabase dashboard |

---

## Re-alignment (when updates are pushed)

When Mamoun updates hooks, agents, rules, or skills:

```bash
cd ~/smorch-brain && git pull origin dev
smorch pull
# Then re-run Steps 3-4 to update agents and rules:
cp ~/smorch-brain/docs/agents-templates/*.md ~/.claude/agents/
cp ~/smorch-brain/docs/rules-templates/*.md ~/.claude/rules/
```

For hooks changes, re-run Step 2 (merge settings-hooks-reference.json into settings.json).
