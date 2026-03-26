# Plugin Migration Guide — Moving Session Skills to Plugins

**Version 2.0 | March 2026**
**Platforms: macOS, Linux, Windows**

> **Repository Path Note:** The `smorch-brain` repo location varies by machine:
> - **Mac (Mamoun):** `~/Desktop/cowork-workspace/smorch-brain`
> - **Linux servers:** `~/smorch-brain`
> - **Windows:** `C:\Users\<you>\smorch-brain` or `C:\Users\<you>\Desktop\cowork-workspace\smorch-brain`
>
> The `smorch` CLI scripts auto-detect the correct location. When this document shows `~/smorch-brain`, substitute your machine's actual path.
>
> **Windows Setup (first time):**
> ```powershell
> # Windows: Run in PowerShell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  # One-time only
> git clone https://github.com/SMOrchestra-ai/smorch-brain.git $env:USERPROFILE\smorch-brain
> cd $env:USERPROFILE\smorch-brain\scripts
> .\smorch.ps1 pull -Profile <your-profile>
> ```

---

## Why Move Skills to Plugins?

Session skills (Cowork Customize > Skills) load into EVERY session, consuming context window tokens even when not needed. Plugin skills only load their descriptions (~100 tokens each) and fetch full content on demand via progressive disclosure.

**Rule of thumb:** If a skill is shared with others OR belongs to a logical group of 3+ related skills, it should be in a plugin.

---

## Current 24 Session Skills — Migration Recommendations

### Move to `eo-microsaas-os` Plugin (2 skills)

These are EO training skills that belong with the rest of the EO system:

| Skill | Reason |
|-------|--------|
| `eo-training-factory` | Core EO training skill, should be with eo-microsaas-os |
| `eo-gtm-asset-builder` | Produces EO GTM assets, pairs with eo-gtm-asset-factory |

### Move to `smorch-gtm-engine` Plugin (4 skills)

These are GTM/outbound skills that belong with the GTM stack:

| Skill | Reason |
|-------|--------|
| `smorch-linkedin-intel` | GTM signal layer — reads LinkedIn signals |
| `smorch-salesnav-operator` | GTM signal layer — Sales Navigator operations |
| `smorch-perfect-webinar` | Campaign asset type — part of GTM asset system |
| `smo-offer-assets` | Campaign asset type — produces offer bundles |

### Create NEW Plugin: `smorch-agency-tools` (6 skills)

Agency team needs these. Bundle as a plugin for distribution:

| Skill | Reason |
|-------|--------|
| `content-systems` | Agency content production framework |
| `movement-builder` | Agency content strategy |
| `engagement-engine` | Training engagement (agency + EO) |
| `validation-sprint` | Client validation methodology |
| `eo-youtube-mamoun` | YouTube content production |
| `smorch-about-me` | Client onboarding context builder |

### Create NEW Plugin: `smorch-dev-toolkit` (6 skills)

Dev team + all servers need these. Bundle as a plugin:

| Skill | Reason |
|-------|--------|
| `smo-skill-creator` | Skill creation (dev workflow) |
| `smorch-tool-super-admin-creator` | Tool operator skill builder |
| `systematic-debugging` | Debugging methodology |
| `requesting-code-review` | Code review requester |
| `receiving-code-review` | Code review receiver |
| `using-superpowers` | Session bootstrapper |

### Keep as Standalone Session Skills (6 skills)

These are either personal, too generic, or not worth plugin packaging:

| Skill | Reason to Keep Standalone |
|-------|--------------------------|
| `smorch-project-brain` | Already has its own plugin (smorch-project-brain) |
| `frontend-design` | Anthropic built-in (also in local plugins) |
| `get-api-docs` | Anthropic built-in (also in local plugins) |
| `lead-research-assistant` | Anthropic built-in (also in local plugins) |
| `webapp-testing` | Anthropic built-in (also in local plugins) |
| `saasfast-gating` | Niche, only used by you, not team-shared |

---

## How to Move a Skill to a Plugin (Step-by-Step)

### Step 1: Copy Skill to Plugin Directory

```bash
# Mac/Linux
# Example: moving smorch-linkedin-intel to smorch-gtm-engine
# Use your machine's smorch-brain path (see Path Note at top)
cp -a ~/Desktop/cowork-workspace/SKILLs/smorch-linkedin-intel \
      ~/smorch-brain/plugins/smorch-gtm-engine/skills/smorch-linkedin-intel
```

```powershell
# Windows (PowerShell)
Copy-Item -Recurse "$env:USERPROFILE\Desktop\cowork-workspace\SKILLs\smorch-linkedin-intel" `
  "$env:USERPROFILE\smorch-brain\plugins\smorch-gtm-engine\skills\smorch-linkedin-intel"
```

### Step 2: Verify SKILL.md is Under 500 Lines

```bash
# Use your machine's smorch-brain path (see Path Note at top)
wc -l ~/smorch-brain/plugins/smorch-gtm-engine/skills/smorch-linkedin-intel/SKILL.md
# If over 500, refactor using progressive disclosure first
```

### Step 3: Rebuild the Plugin

```bash
# Mac/Linux
smorch build-plugin smorch-gtm-engine
# Output: ~/smorch-brain/dist/smorch-gtm-engine.plugin
```

```powershell
# Windows (PowerShell)
.\smorch.ps1 build-plugin -Name smorch-gtm-engine
```

### Step 4: Load Plugin into Cowork

1. Open Claude Desktop (Cowork)
2. Go to Customize > Workspace
3. Point workspace to your smorch-brain directory
4. Cowork scans and discovers all plugins automatically
5. Click Save -- plugins are now active
6. Verify the skill appears in the plugin's skill list

### Step 5: Remove from Session Skills

1. In Cowork: Customize > Skills > find the skill > Remove
2. In workspace: The skill stays in the workspace (no need to delete — it won't duplicate because Cowork session skills come from Customize, not the workspace symlink during Cowork sessions)

### Step 6: Test

1. Start a new Cowork session
2. Type something that should trigger the skill
3. Verify it fires from the plugin (check the skill attribution)
4. Test with `/skill-name` directly

### Step 7: Push to Registry

```bash
# Mac/Linux
smorch push
# This syncs the updated plugin to smorch-brain
```

```powershell
# Windows (PowerShell)
.\smorch.ps1 push
```

---

## How to Create a NEW Plugin

### Step 1: Create Plugin Directory Structure

```bash
# Mac/Linux
# Use your machine's smorch-brain path (see Path Note at top)
mkdir -p ~/smorch-brain/plugins/smorch-agency-tools/.claude-plugin
mkdir -p ~/smorch-brain/plugins/smorch-agency-tools/skills
mkdir -p ~/smorch-brain/plugins/smorch-agency-tools/commands
```

```powershell
# Windows (PowerShell)
$base = "$env:USERPROFILE\smorch-brain\plugins\smorch-agency-tools"
New-Item -ItemType Directory -Force -Path "$base\.claude-plugin", "$base\skills", "$base\commands"
```

### Step 2: Create plugin.json

```bash
# Use your machine's smorch-brain path (see Path Note at top)
cat > ~/smorch-brain/plugins/smorch-agency-tools/.claude-plugin/plugin.json << 'EOF'
{
  "name": "smorch-agency-tools",
  "version": "1.0.0",
  "description": "SMOrchestra Agency Tools — content systems, engagement, validation, and YouTube production for the GTM team",
  "author": "SMOrchestra.ai"
}
EOF
```

### Step 3: Create README.md

```bash
# Use your machine's smorch-brain path
cat > ~/smorch-brain/plugins/smorch-agency-tools/README.md << 'EOF'
# SMOrchestra Agency Tools

Content production, engagement, and validation skills for the SMOrchestra agency team.

## Skills Included
- content-systems — Matt Gray + Hormozi content production framework
- movement-builder — Russell Brunson movement building
- engagement-engine — Nir Eyal Hook Model for training
- validation-sprint — Rapid validation methodology
- eo-youtube-mamoun — YouTube deck builder
- smorch-about-me — Personal context file builder

## Installation
Load in Cowork: Customize > Workspace > point to smorch-brain directory > Save
EOF
```

### Step 4: Copy Skills Into Plugin

```bash
for skill in content-systems movement-builder engagement-engine \
             validation-sprint eo-youtube-mamoun smorch-about-me; do
  cp -a ~/Desktop/cowork-workspace/SKILLs/$skill \
        ~/smorch-brain/plugins/smorch-agency-tools/skills/$skill
done
```

### Step 5: Add Commands (Optional)

Create thin slash-command entrypoints in `commands/`:

```bash
cat > ~/smorch-brain/plugins/smorch-agency-tools/commands/content.md << 'EOF'
---
name: content
description: "Start content system planning"
---
Help me create a content system using the Content GPS framework. Ask me for my North Star idea and content pillars.
EOF
```

### Step 6: Build and Test

```bash
# Mac/Linux
smorch build-plugin smorch-agency-tools
# Load in Cowork: Customize > Workspace > point to smorch-brain > Save
# Cowork discovers all plugins automatically — test skills fire correctly
```

```powershell
# Windows (PowerShell)
.\smorch.ps1 build-plugin -Name smorch-agency-tools
```

---

## Decision Flowchart: Plugin vs Standalone

```
START: You have a new skill
  |
  Q1: Will 2+ people use this skill?
  |-- YES --> Q2
  |-- NO  --> Keep as STANDALONE (personal ~/.claude/skills/)
  |
  Q2: Does it belong to an existing group of 3+ related skills?
  |-- YES --> ADD TO EXISTING PLUGIN
  |-- NO  --> Q3
  |
  Q3: Will you create 2+ more skills in the same domain soon?
  |-- YES --> CREATE NEW PLUGIN (start with this skill)
  |-- NO  --> Keep as STANDALONE (project or personal)
  |
  Q4: Does someone without repo access need this?
  |-- YES --> Must be a PLUGIN (only distribution method)
  |-- NO  --> STANDALONE is fine
```

---

## Quick Command Reference

### Mac / Linux (bash)

```bash
# All ~/smorch-brain paths below: use your machine's actual path (see Path Note at top)

# Move skill to plugin
cp -a ~/Desktop/cowork-workspace/SKILLs/<skill> ~/smorch-brain/plugins/<plugin>/skills/

# Build plugin
smorch build-plugin <plugin-name>

# List what's in a plugin
ls ~/smorch-brain/plugins/<plugin>/skills/

# Create new plugin
mkdir -p ~/smorch-brain/plugins/<name>/{.claude-plugin,skills,commands}

# Full migration cycle
cp -a <skill> plugins/<plugin>/skills/   # copy
smorch build-plugin <plugin>             # build
# Load in Cowork: Customize > Workspace > point to smorch-brain > Save  # install
# Remove from Customize > Skills         # deduplicate
smorch push                              # sync to registry
```

### Windows (PowerShell)

```powershell
# Move skill to plugin
Copy-Item -Recurse "$env:USERPROFILE\Desktop\cowork-workspace\SKILLs\<skill>" "$env:USERPROFILE\smorch-brain\plugins\<plugin>\skills\"

# Build plugin
.\smorch.ps1 build-plugin -Name <plugin-name>

# List what's in a plugin
Get-ChildItem "$env:USERPROFILE\smorch-brain\plugins\<plugin>\skills\"

# Create new plugin
$base = "$env:USERPROFILE\smorch-brain\plugins\<name>"
New-Item -ItemType Directory -Force -Path "$base\.claude-plugin", "$base\skills", "$base\commands"

# Full migration cycle
Copy-Item -Recurse <skill> "plugins\<plugin>\skills\"   # copy
.\smorch.ps1 build-plugin -Name <plugin>                 # build
# Load in Cowork: Customize > Workspace > point to smorch-brain > Save  # install
# Remove from Customize > Skills                         # deduplicate
.\smorch.ps1 push                                        # sync to registry
```
