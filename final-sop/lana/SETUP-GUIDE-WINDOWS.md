# Lana Al-Kurd -- Windows Setup Guide

> All paths, commands, and instructions in this document are Windows-native.
> Last updated: 2026-04-06

---

## Step 1: Prerequisites

### 1.1 Install Node.js v18+
- Download the **Windows Installer (.msi)** from https://nodejs.org
- Run the installer. Accept defaults. Ensure "Add to PATH" is checked.
- Verify: open a new terminal and run `node --version` (must show v18+)

### 1.2 Install Git for Windows
- Download from https://git-scm.com/download/win
- During install:
  - Select **"Git Bash Here"** in context menu options
  - Select **"Use Git from Git Bash only"** or **"Git from the command line and also from 3rd-party software"**
  - Line ending: select **"Checkout as-is, commit Unix-style line endings"**
- Verify: open Git Bash and run `git --version`

### 1.3 Configure Git Identity
Open Git Bash and run:
```bash
git config --global user.name "Lana Al-Kurd"
git config --global user.email "lana@smorchestra.com"
git config --global core.autocrlf true
git config --system core.longpaths true
```

### 1.4 GitHub Authentication

You need a Personal Access Token (PAT) to clone repos and push branches.

**Create Your Token:**
1. Go to https://github.com/settings/tokens
2. Click **Generate new token (classic)**
3. Name: `smorchestra-dev`
4. Expiration: 90 days (you'll need to regenerate when it expires)
5. Select these scopes:
   - `repo` (full repo access -- required)
   - `read:org` (read org membership -- required)
   - `workflow` (GitHub Actions visibility -- optional)
6. Click **Generate token**
7. **Copy the token immediately** -- it only shows once

**Configure Git to Remember Your Token:**
```bash
git config --global credential.helper store
```

The first time you `git clone` or `git push`, Git will prompt:
- **Username:** your GitHub username
- **Password:** paste the PAT (not your GitHub password)

Git stores this after the first entry. You won't be asked again until the token expires.

> **Security:** Never share your PAT with anyone. Never paste it in code, docs, or chat. If compromised, revoke it immediately at https://github.com/settings/tokens and generate a new one.

### 1.5 Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```
Verify: `claude --version`

### 1.6 Terminal Setup
- **Recommended**: Use **Git Bash** as your default terminal for all git and claude operations.
- **Do NOT** use cmd.exe or PowerShell for git operations -- they handle paths and line endings differently.
- **Alternative**: Install Windows Terminal from the Microsoft Store, then add a Git Bash profile:
  1. Open Windows Terminal Settings
  2. Add New Profile > Command line: `C:\Program Files\Git\bin\bash.exe`
  3. Set as default profile

---

## Step 2: Clone Repositories

Open Git Bash:

```bash
mkdir -p ~/smorchestra && cd ~/smorchestra
```

> This creates `C:\Users\Lana\smorchestra` on your Windows filesystem.

Clone all required repos:

```bash
git clone https://github.com/SMOrchestra-ai/Signal-Sales-Engine.git
git clone https://github.com/SMOrchestra-ai/SaaSFast.git
git clone https://github.com/SMOrchestra-ai/EO-Scorecard-Platform.git
git clone https://github.com/SMOrchestra-ai/eo-mena.git
git clone https://github.com/SMOrchestra-ai/smorch-brain.git
git clone https://github.com/SMOrchestra-ai/smorch-dist.git
```

Verify all cloned:
```bash
ls ~/smorchestra
# Should show: Signal-Sales-Engine  SaaSFast  EO-Scorecard-Platform  eo-mena  smorch-brain  smorch-dist
```

---

## Step 3: Install Plugins

In Git Bash:

```bash
mkdir -p ~/.claude/plugins
```

Copy plugins from smorch-dist:
```bash
cp ~/smorchestra/smorch-dist/plugins/*.md ~/.claude/plugins/
```

Copy plugins from smorch-brain:
```bash
cp ~/smorchestra/smorch-brain/plugins/*.md ~/.claude/plugins/
```

Verify:
```bash
ls ~/.claude/plugins/
```

> **Windows path equivalent**: `%USERPROFILE%\.claude\plugins\` which resolves to `C:\Users\Lana\.claude\plugins\`

---

## Step 4: Create Global CLAUDE.md

Place the file at: `C:\Users\Lana\.claude\CLAUDE.md`

In Git Bash:
```bash
cp ~/smorchestra/Signal-Sales-Engine/DevTeamSOP/final-sop/lana/CLAUDE.md ~/.claude/CLAUDE.md
```

Or create it manually. The file is provided separately as `lana/CLAUDE.md` in this SOP package.

> The CLAUDE.md file contains your full QA Lead role definition, quality gates, bug templates, and review output format. It also includes the line: "You are running on Windows. Use forward slashes in paths. Use Git Bash for terminal commands."

---

## Step 5: Configure settings.json

Place the file at: `C:\Users\Lana\.claude\settings.json`

In Git Bash:
```bash
cp ~/smorchestra/Signal-Sales-Engine/DevTeamSOP/final-sop/lana/settings.json ~/.claude/settings.json
```

Or create it manually. The file is provided separately as `lana/settings.json` in this SOP package.

This configures:
- Destructive command blocking (rm -rf, git push --force, etc.)
- Secret scanning on file writes
- All hooks use Git Bash-compatible syntax

---

## Step 6: Configure MCP

Place the file at: `C:\Users\Lana\.claude\.mcp.json`

In Git Bash:
```bash
cp ~/smorchestra/Signal-Sales-Engine/DevTeamSOP/final-sop/lana/mcp.json ~/.claude/.mcp.json
```

### Set the Linear API Key

You need a Linear API key from Mamoun. Once you have it:

**Option A -- Permanent (Windows environment variable):**
Open cmd.exe or PowerShell and run:
```cmd
setx LINEAR_API_KEY "token-from-mamoun"
```
Then restart Git Bash for the variable to take effect.

**Option B -- Session only (Git Bash):**
```bash
export LINEAR_API_KEY="token-from-mamoun"
```
This only lasts until you close the terminal.

---

## Step 7: Verify Setup

```bash
cd ~/smorchestra/Signal-Sales-Engine
claude
```

Inside Claude Code, test these commands:
- `/score-project` -- should return a project score
- `/review` -- should run code review
- `/deploy-checklist` -- should generate a deploy checklist

If any fail, check the Troubleshooting section below.

---

## Step 8: Daily Workflow

### Morning Startup
```bash
cd ~/smorchestra/Signal-Sales-Engine
git checkout dev
git pull origin dev
claude
```

### Branch Creation
```bash
git checkout -b human/lana/TASK-XXX-description
```

### Work Cycle
1. Open Claude Code in the repo
2. Work on assigned Linear tickets
3. Run `/review` before pushing
4. Run `/score-project` to verify quality gates
5. Push and create PR targeting `dev`

### End of Day
```bash
git status
git add <changed-files>
git commit -m "feat(SSE-XXX): description"
git push origin human/lana/TASK-XXX-description
```

### Windows-Specific Notes
- Always use Git Bash, not cmd.exe or PowerShell
- If you see `\r` characters in diffs, run: `git config --global core.autocrlf true`
- Use forward slashes in all file paths when inside Git Bash
- Windows Defender may slow git operations on first run -- add `C:\Users\Lana\smorchestra` to exclusions

---

## Step 9: Troubleshooting

### "command not found" for claude or node
Your PATH may not include the npm global bin directory.
```bash
# Check where npm installs global packages
npm config get prefix
# Add that path's bin/ to your PATH in ~/.bashrc:
echo 'export PATH="$PATH:$(npm config get prefix)/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Line Ending Issues (CRLF vs LF)
```bash
git config --global core.autocrlf true
```
If files show as entirely changed in diffs, this is the cause.

### Long Path Errors
```bash
git config --system core.longpaths true
```
Requires running Git Bash as Administrator.

### Permission Errors on .claude Directory
Run Git Bash as Administrator, then:
```bash
chmod -R 755 ~/.claude
```

### Hooks Fail or Produce Errors
- Ensure you are running in Git Bash, not cmd.exe or PowerShell
- Check that `bash` is available: `which bash`
- If hooks reference `grep`, `awk`, or `sed`, these are available in Git Bash but not in cmd.exe

### Git Push Rejected
- You should never push directly to `main` or `dev`
- Create a branch first: `git checkout -b human/lana/TASK-XXX-description`
- Push the branch and create a PR

### MCP Connection Fails
- Verify the environment variable is set: `echo $LINEAR_API_KEY`
- If empty, re-export it or check that `setx` was used correctly
- Restart Git Bash after using `setx`

### Claude Code Crashes or Hangs
```bash
# Clear Claude Code cache
rm -rf ~/.claude/cache
# Reinstall
npm install -g @anthropic-ai/claude-code
```
