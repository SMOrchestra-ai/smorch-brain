<#
.SYNOPSIS
    smorch -- SMOrchestra Skill Registry CLI (PowerShell)

.DESCRIPTION
    Single tool for managing skills across all nodes.
    Repo: github.com/SMOrchestra-ai/smorch-brain

.PARAMETER Command
    The command to run: push, pull, install, remove, list, diff, status, init, audit, build-plugin

.EXAMPLE
    .\smorch.ps1 push
    .\smorch.ps1 pull --profile mamoun
    .\smorch.ps1 list --installed
    .\smorch.ps1 init --profile smo-brain
    .\smorch.ps1 build-plugin marketing
#>

param(
    [Parameter(Position = 0)]
    [string]$Command,

    [Parameter()]
    [string]$Profile,

    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]$Arguments
)

# --- Prerequisite checks ---
function Test-Prerequisites {
    $missing = @()
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $missing += "git" }
    if (-not (Get-Command zip -ErrorAction SilentlyContinue)) {
        # zip is needed for build-plugin; on Windows, Compress-Archive is used instead
        # Only warn if not on Windows
        if ($IsLinux -or $IsMacOS) { $missing += "zip" }
    }
    if ($missing.Count -gt 0) {
        Write-Host "ERROR: Missing required tools: $($missing -join ', ')" -ForegroundColor Red
        exit 1
    }
}
Test-Prerequisites

# --- Git retry helper ---
function Invoke-GitWithRetry {
    param([string[]]$GitArgs)
    $attempts = 0
    $max = 3
    while ($attempts -lt $max) {
        $result = & git @GitArgs 2>&1
        if ($LASTEXITCODE -eq 0) { return $result }
        $attempts++
        if ($attempts -lt $max) {
            Write-Host "  Network issue, retrying ($attempts/$max)..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        }
    }
    Write-Host "  Failed after $max attempts. Check your network." -ForegroundColor Red
    return $null
}

$VERSION = "2.0.0"
# Auto-detect repo location (works on Windows, Mac via PowerShell Core, Linux)
$cwPath = Join-Path (Join-Path (Join-Path $env:USERPROFILE "Desktop") "cowork-workspace") "smorch-brain"
$homePath = Join-Path $env:USERPROFILE "smorch-brain"
if (Test-Path $cwPath) {
    $REPO_DIR = $cwPath
} elseif (Test-Path $homePath) {
    $REPO_DIR = $homePath
} else {
    $REPO_DIR = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}
$SKILLS_TARGET = Join-Path $env:USERPROFILE ".claude\skills"
$MCP_TARGET = Join-Path $env:USERPROFILE ".claude\.mcp.json"
$STATE_FILE = Join-Path $REPO_DIR ".smorch-state"

# --- Helpers ---

function Write-Color {
    param(
        [string]$Message,
        [ConsoleColor]$Color = [ConsoleColor]::White
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Usage {
    Write-Host @"
smorch v$VERSION -- SMOrchestra Skill Registry (PowerShell)

Usage: smorch.ps1 <command> [options]

Commands:
  push                    Export Cowork skills to registry + git push
  pull                    Git pull + install current profile's skills
  pull --profile <name>   Pull + install specific profile (saves as default)
  install <path>          Install a category or single skill
  remove <path>           Remove a category or skill from this machine
  list                    Show all skills in registry (by category)
  list --installed        Show skills installed on this machine
  list --available        Show skills in registry but NOT installed
  list --profiles         Show available profiles
  diff                    Show what changed since last pull
  status                  Profile, last sync, skill counts
  init --profile <name>   First-time setup on a new machine
  audit                   Check for issues (unmapped, oversized, missing versions)
  build-plugin <name>     Build .plugin zip from plugins/<name>/

Registry: $REPO_DIR
Skills:   $SKILLS_TARGET
"@
}

# --- State management ---

function Load-State {
    $script:CURRENT_PROFILE = ""
    $script:LAST_SYNC = ""
    if (Test-Path $STATE_FILE) {
        Get-Content $STATE_FILE | ForEach-Object {
            if ($_ -match '^CURRENT_PROFILE="(.*)"') { $script:CURRENT_PROFILE = $Matches[1] }
            if ($_ -match '^LAST_SYNC="(.*)"') { $script:LAST_SYNC = $Matches[1] }
        }
    }
}

function Save-State {
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    @"
CURRENT_PROFILE="$($script:CURRENT_PROFILE)"
LAST_SYNC="$timestamp"
"@ | Set-Content -Path $STATE_FILE -Encoding UTF8
}

# --- Profile resolution ---

function Resolve-Profile {
    param([string]$ProfileName)

    $profileFile = Join-Path $REPO_DIR "profiles\$ProfileName.txt"
    if (-not (Test-Path $profileFile)) {
        Write-Color "ERROR: Profile '$ProfileName' not found at $profileFile" Red
        return @()
    }

    $skills = @()
    $lines = Get-Content $profileFile

    foreach ($rawLine in $lines) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrEmpty($line) -or $line.StartsWith("#")) { continue }

        if ($line -eq "*") {
            # All skills
            $catDirs = Get-ChildItem -Path (Join-Path $REPO_DIR "skills") -Directory -ErrorAction SilentlyContinue
            foreach ($catDir in $catDirs) {
                $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue
                foreach ($skillDir in $skillDirs) {
                    $skills += "$($catDir.Name)/$($skillDir.Name)/"
                }
            }
        }
        elseif ($line.EndsWith("/*")) {
            # Category wildcard
            $category = $line.TrimEnd("/*")
            $catPath = Join-Path $REPO_DIR "skills\$category"
            if (Test-Path $catPath) {
                $skillDirs = Get-ChildItem -Path $catPath -Directory -ErrorAction SilentlyContinue
                foreach ($skillDir in $skillDirs) {
                    $skills += "$category/$($skillDir.Name)/"
                }
            }
        }
        else {
            # Specific skill
            $skillPath = Join-Path $REPO_DIR "skills\$line"
            if (Test-Path $skillPath) {
                $skills += "$line/"
            }
            else {
                Write-Color "WARN: Skill '$line' not found in registry" Yellow
            }
        }
    }

    return $skills
}

# --- Category mapping ---

function Get-SkillCategory {
    param([string]$SkillName, [string]$SkillsPath)

    # Priority 1: .smorch-category file
    $categoryFile = Join-Path $SkillsPath "$SkillName\.smorch-category"
    if (Test-Path $categoryFile) {
        return (Get-Content $categoryFile -Raw).Trim()
    }

    # Priority 2: Hardcoded fallback map
    $map = @{
        "signal-to-trust-gtm" = "smorch-gtm"; "signal-detector" = "smorch-gtm"; "wedge-generator" = "smorch-gtm"
        "asset-factory" = "smorch-gtm"; "campaign-strategist" = "smorch-gtm"
        "positioning-engine" = "smorch-gtm"; "outbound-orchestrator" = "smorch-gtm"
        "ghl-operator" = "smorch-gtm"; "instantly-operator" = "smorch-gtm"; "heyreach-operator" = "smorch-gtm"
        "clay-operator" = "smorch-gtm"; "n8n-architect" = "smorch-gtm"; "scraper-layer" = "smorch-gtm"
        "smorch-salesnav-operator" = "smorch-gtm"; "smorch-linkedin-intel" = "smorch-gtm"
        "eo-brain-ingestion" = "eo-training"; "eo-gtm-asset-factory" = "eo-training"
        "eo-gtm-asset-builder" = "eo-training"; "eo-skill-extractor" = "eo-training"
        "eo-tech-architect" = "eo-training"; "eo-microsaas-dev" = "eo-training"
        "eo-db-architect" = "eo-training"; "eo-api-connector" = "eo-training"
        "eo-qa-testing" = "eo-training"; "eo-security-hardener" = "eo-training"
        "eo-deploy-infra" = "eo-training"; "eo-training-factory" = "eo-training"
        "eo-production-renderer" = "eo-training"; "eo-guide" = "eo-training"; "eo-os-navigator" = "eo-training"
        "project-definition-scoring-engine" = "eo-scoring"; "icp-clarity-scoring-engine" = "eo-scoring"
        "market-attractiveness-scoring-engine" = "eo-scoring"
        "strategy-selector-engine" = "eo-scoring"; "gtm-fitness-scoring-engine" = "eo-scoring"
        "eo-youtube-mamoun" = "content"; "smorch-perfect-webinar" = "content"
        "smo-offer-assets" = "content"; "content-systems" = "content"; "movement-builder" = "content"
        "engagement-engine" = "content"; "validation-sprint" = "content"; "arabic-localizer" = "content"
        "smo-skill-creator" = "dev-meta"; "smorch-tool-super-admin-creator" = "dev-meta"
        "systematic-debugging" = "dev-meta"; "smorch-github-ops" = "dev-meta"; "changelog-generator" = "dev-meta"
        "requesting-code-review" = "dev-meta"; "receiving-code-review" = "dev-meta"; "using-superpowers" = "dev-meta"
        "frontend-design" = "tools"; "webapp-testing" = "tools"; "get-api-docs" = "tools"
        "lead-research-assistant" = "tools"; "saasfast-gating" = "tools"
        "client-onboarding" = "tools"; "contabo-deployment" = "tools"; "supabase-admin" = "tools"
        "smorch-about-me" = "personal"; "smorch-project-brain" = "personal"
    }

    if ($map.ContainsKey($SkillName)) {
        return $map[$SkillName]
    }
    return ""
}

# --- Commands ---

function Invoke-Push {
    Write-Color "smorch push -- Exporting skills to registry" Cyan

    $skillsPath = Join-Path $env:USERPROFILE ".claude\skills"
    if (-not (Test-Path $skillsPath)) {
        Write-Color "ERROR: ~/.claude/skills not found" Red
        return
    }

    # Phase 0: Pull new CUSTOM skills from Cowork Desktop sessions (Windows path)
    $sessionsBase = Join-Path $env:LOCALAPPDATA "Claude\local-agent-mode-sessions"
    if (Test-Path $sessionsBase) {
        $pulled = 0
        $skipBuiltins = @(
            "algorithmic-art", "brand-guidelines", "canvas-design", "doc-coauthoring",
            "docx", "internal-comms", "mcp-builder", "pdf", "pptx", "schedule",
            "skill-creator", "theme-factory", "web-artifacts-builder", "xlsx"
        )

        $sessionSkillDirs = Get-ChildItem -Path $sessionsBase -Recurse -Directory -Depth 7 -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match '\.claude[\\/]skills[\\/][^\\/]+$' }

        foreach ($skillDir in $sessionSkillDirs) {
            $skillName = $skillDir.Name
            $destPath = Join-Path $skillsPath $skillName
            if (Test-Path $destPath) { continue }
            if ($skipBuiltins -contains $skillName) { continue }

            # Check manifest for Anthropic creator
            $manifest = Join-Path $skillDir.FullName "manifest.json"
            if (Test-Path $manifest) {
                try {
                    $json = Get-Content $manifest -Raw | ConvertFrom-Json
                    if ($json.creatorType -eq "anthropic") { continue }
                } catch { }
            }

            Copy-Item -Path $skillDir.FullName -Destination $destPath -Recurse -Force
            Write-Host "  + Pulled from Cowork: $skillName" -ForegroundColor Green
            $pulled++
        }
        if ($pulled -gt 0) {
            Write-Color "Pulled $pulled new skills from Cowork Desktop" Green
        }
    }

    $skillCount = (Get-ChildItem -Path $skillsPath -Directory -ErrorAction SilentlyContinue).Count
    Write-Host "Skills dir: " -NoNewline
    Write-Color "$skillsPath ($skillCount skills)" Green

    # Files/dirs to exclude from export
    $excludePatterns = @(
        "package-lock.json", "*.html", "*.ttf", "*.woff", "*.woff2",
        "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg", "*.ico",
        "node_modules", "__pycache__", ".DS_Store"
    )

    # Anthropic built-in skills to skip
    $skipSkills = @(
        "algorithmic-art", "brand-guidelines", "canvas-design", "doc-coauthoring",
        "docx", "internal-comms", "mcp-builder", "pdf", "pptx", "schedule",
        "skill-creator", "theme-factory", "web-artifacts-builder", "xlsx"
    )

    # Create category directories
    foreach ($cat in @("smorch-gtm", "eo-training", "eo-scoring", "content", "dev-meta", "tools", "personal")) {
        $catDir = Join-Path $REPO_DIR "skills\$cat"
        if (-not (Test-Path $catDir)) {
            New-Item -ItemType Directory -Path $catDir -Force | Out-Null
        }
    }

    $copied = 0
    $skipped = 0
    $oversized = 0

    $skillDirs = Get-ChildItem -Path $skillsPath -Directory -ErrorAction SilentlyContinue
    foreach ($skillDir in $skillDirs) {
        $skillName = $skillDir.Name

        # Check manifest for creatorType
        $manifest = Join-Path $skillDir.FullName "manifest.json"
        if (Test-Path $manifest) {
            try {
                $json = Get-Content $manifest -Raw | ConvertFrom-Json
                if ($json.creatorType -eq "anthropic") {
                    $skipped++
                    continue
                }
            } catch { }
        }

        # Skip known Anthropic skills by name
        if ($skipSkills -contains $skillName) {
            $skipped++
            continue
        }

        # Find category
        $category = Get-SkillCategory -SkillName $skillName -SkillsPath $skillsPath
        if ([string]::IsNullOrEmpty($category)) {
            Write-Color "UNMAPPED: $skillName -- add .smorch-category file or update Get-SkillCategory" Yellow
            $skipped++
            continue
        }

        # Flag oversized SKILL.md
        $skillMd = Join-Path $skillDir.FullName "SKILL.md"
        if (Test-Path $skillMd) {
            $size = (Get-Item $skillMd).Length
            if ($size -gt 20480) {
                $sizeKB = [math]::Floor($size / 1024)
                Write-Color "LARGE: $skillName/SKILL.md (${sizeKB}KB) -- consider using reference files" Yellow
                $oversized++
            }
        }

        # Copy skill, excluding bloat files
        $dest = Join-Path $REPO_DIR "skills\$category\$skillName"
        if (-not (Test-Path $dest)) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }

        # Use robocopy for selective copy with excludes
        $excludeDirs = @("node_modules", "__pycache__", ".DS_Store")
        $excludeFiles = @("package-lock.json", "*.html", "*.ttf", "*.woff", "*.woff2",
                          "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg", "*.ico")

        robocopy $skillDir.FullName $dest /E /XD $excludeDirs /XF $excludeFiles /NFL /NDL /NJH /NJS /NC /NS /NP | Out-Null
        $copied++
    }

    Write-Color "Exported: $copied skills | Skipped: $skipped Anthropic built-ins" Green
    if ($oversized -gt 0) {
        Write-Color "$oversized skill(s) over 20KB -- consider splitting into reference files" Yellow
    }

    # Git operations
    Push-Location "$REPO_DIR"
    try {
        git add skills/
        $hasChanges = git diff --cached --quiet 2>&1; $exitCode = $LASTEXITCODE
        if ($exitCode -eq 0) {
            Write-Color "No changes to commit." Yellow
        }
        else {
            $changes = (git diff --cached --stat | Select-Object -Last 1).Trim()
            git commit -m "skills: export from Cowork -- $changes"
            Write-Color "Committed." Green

            $pushResult = git push origin dev 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Color "Pushed to dev." Green
            }
            else {
                git checkout -b dev origin/dev 2>$null
                if ($LASTEXITCODE -ne 0) { git checkout dev 2>$null }
                git merge dev --no-edit 2>$null
                git push origin dev 2>&1 | Out-Null
                Write-Color "Pushed to dev." Green
            }
            Write-Color "Skills pushed to dev branch. Run 'smorch release' to promote to main via PR." Cyan
        }
    }
    finally {
        Pop-Location
    }
}

function Invoke-Pull {
    param(
        [string[]]$Args,
        [string]$ProfileParam
    )

    Load-State
    $profile = $script:CURRENT_PROFILE
    $forceFlag = $false

    # Use -Profile parameter if provided
    if (-not [string]::IsNullOrEmpty($ProfileParam)) {
        $profile = $ProfileParam
    }

    # Also check remaining args for -Profile or --profile and --force (backward compat)
    for ($i = 0; $i -lt $Args.Count; $i++) {
        if ($Args[$i] -in @("-Profile", "--profile") -and ($i + 1) -lt $Args.Count) {
            $profile = $Args[$i + 1]
            $i++
        }
        if ($Args[$i] -in @("-Force", "--force")) {
            $forceFlag = $true
        }
    }

    if ([string]::IsNullOrEmpty($profile)) {
        Write-Color "ERROR: No profile set. Run: smorch.ps1 pull --profile <name>" Red
        Write-Host "Available profiles:"
        $profileFiles = Get-ChildItem -Path (Join-Path $REPO_DIR "profiles") -Filter "*.txt" -ErrorAction SilentlyContinue
        foreach ($pf in $profileFiles) {
            Write-Host "  $($pf.BaseName)"
        }
        return
    }

    Write-Color "smorch pull -- Syncing profile: $profile" Cyan

    # Git pull with dirty tree handling
    Push-Location "$REPO_DIR"
    try {
        $dirtyWorktree = & git diff --quiet 2>&1; $wt = $LASTEXITCODE
        $dirtyIndex = & git diff --cached --quiet 2>&1; $ix = $LASTEXITCODE
        if ($wt -ne 0 -or $ix -ne 0) {
            if ($forceFlag) {
                Write-Host "Stashing local changes..." -ForegroundColor Yellow
                git stash
            } else {
                Write-Color "Uncommitted changes detected. Use --force to stash and pull, or commit first." Red
                return
            }
        }
        Write-Host "Pulling latest from GitHub..."
        $result = Invoke-GitWithRetry @("pull", "--rebase", "origin", "dev")
        if ($LASTEXITCODE -ne 0) {
            Write-Color "Git pull failed. Resolve conflicts manually." Red
            return
        }
        if ($forceFlag) {
            $stashList = git stash list 2>&1
            if ($stashList -match "stash@\{0\}") {
                git stash pop 2>$null
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "Warning: Could not pop stash. Run 'git stash pop' manually." -ForegroundColor Yellow
                }
            }
        }
    }
    finally {
        Pop-Location
    }

    # Backup current skills
    if ((Test-Path $SKILLS_TARGET) -and (Get-ChildItem -Path $SKILLS_TARGET -ErrorAction SilentlyContinue).Count -gt 0) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupDir = Join-Path $env:USERPROFILE ".claude\skills.bak.$timestamp"
        Copy-Item -Path $SKILLS_TARGET -Destination $backupDir -Recurse -Force
        Write-Color "Backup: $backupDir" Yellow
    }

    # Clean only managed categories
    $managedCats = @("smorch-gtm", "eo-training", "eo-scoring", "content", "dev-meta", "tools", "personal")
    foreach ($cat in $managedCats) {
        $catPath = Join-Path $SKILLS_TARGET $cat
        if (Test-Path $catPath) {
            Remove-Item -Path $catPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    if (-not (Test-Path $SKILLS_TARGET)) {
        New-Item -ItemType Directory -Path $SKILLS_TARGET -Force | Out-Null
    }

    $count = 0
    $resolvedSkills = Resolve-Profile -ProfileName $profile
    foreach ($skillPath in $resolvedSkills) {
        if ([string]::IsNullOrEmpty($skillPath)) { continue }
        $skillPath = $skillPath.TrimEnd("/")
        $parts = $skillPath -split "/"
        $category = $parts[0]
        $skillName = $parts[1]

        $destCatDir = Join-Path $SKILLS_TARGET $category
        if (-not (Test-Path $destCatDir)) {
            New-Item -ItemType Directory -Path $destCatDir -Force | Out-Null
        }

        $sourcePath = Join-Path $REPO_DIR "skills\$skillPath"
        $destPath = Join-Path $SKILLS_TARGET "$category\$skillName"
        Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
        $count++
    }

    # Install MCP config
    $baseMcp = Join-Path $REPO_DIR "mcp-configs\base.mcp.json"
    $overlayName = $profile -replace '-agent$', ''
    if ($overlayName -eq "mamoun") { $overlayName = "desktop" }
    $overlayMcp = Join-Path $REPO_DIR "mcp-configs\$overlayName.mcp.json"

    if (Test-Path $baseMcp) {
        if ((Test-Path $overlayMcp) -and (Get-Command jq -ErrorAction SilentlyContinue)) {
            jq -s '.[0].mcpServers * .[1].mcpServers | {mcpServers: .}' $baseMcp $overlayMcp | Set-Content -Path $MCP_TARGET -Encoding UTF8
            Write-Host "MCP: merged base + $overlayName"
        }
        else {
            Copy-Item -Path $baseMcp -Destination $MCP_TARGET -Force
            Write-Host "MCP: base only (no overlay or jq)"
        }
    }

    # Copy CLAUDE.md if exists
    $claudeMd = Join-Path $REPO_DIR "CLAUDE.md"
    if (Test-Path $claudeMd) {
        $destClaudeMd = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
        Copy-Item -Path $claudeMd -Destination $destClaudeMd -Force
    }

    # Save state
    $script:CURRENT_PROFILE = $profile
    Save-State

    Write-Color "Installed $count skills (profile: $profile)" Green
}

function Invoke-Install {
    param([string]$Target)

    if ([string]::IsNullOrEmpty($Target)) {
        Write-Color "Usage: smorch.ps1 install <category> or smorch.ps1 install <category/skill>" Red
        return
    }

    Push-Location "$REPO_DIR"
    try { Invoke-GitWithRetry @("pull", "--rebase", "origin", "dev") | Out-Null } finally { Pop-Location }

    $sourcePath = Join-Path $REPO_DIR "skills\$Target"
    if (Test-Path $sourcePath) {
        if ($Target -match "/") {
            # Single skill
            $category = ($Target -split "/")[0]
            $destCatDir = Join-Path $SKILLS_TARGET $category
            if (-not (Test-Path $destCatDir)) {
                New-Item -ItemType Directory -Path $destCatDir -Force | Out-Null
            }
            $destPath = Join-Path $SKILLS_TARGET $Target
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            Write-Color "Installed: $Target" Green
        }
        else {
            # Entire category
            $destCatDir = Join-Path $SKILLS_TARGET $Target
            if (-not (Test-Path $destCatDir)) {
                New-Item -ItemType Directory -Path $destCatDir -Force | Out-Null
            }
            $count = 0
            $skillDirs = Get-ChildItem -Path $sourcePath -Directory -ErrorAction SilentlyContinue
            foreach ($skillDir in $skillDirs) {
                Copy-Item -Path $skillDir.FullName -Destination (Join-Path $destCatDir $skillDir.Name) -Recurse -Force
                $count++
            }
            Write-Color "Installed: $Target ($count skills)" Green
        }
    }
    else {
        Write-Color "Not found in registry: $Target" Red
        Write-Host "Available categories:"
        Get-ChildItem -Path (Join-Path $REPO_DIR "skills") -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  $($_.Name)"
        }
    }
}

function Invoke-Remove {
    param([string]$Target)

    if ([string]::IsNullOrEmpty($Target)) {
        Write-Color "Usage: smorch.ps1 remove <category> or smorch.ps1 remove <category/skill>" Red
        return
    }

    $targetPath = Join-Path $SKILLS_TARGET $Target
    if (Test-Path $targetPath) {
        Remove-Item -Path $targetPath -Recurse -Force
        Write-Color "Removed: $Target" Green
    }
    else {
        Write-Color "Not installed: $Target" Red
    }
}

function Invoke-List {
    param([string[]]$Args)

    $mode = "registry"
    foreach ($arg in $Args) {
        switch ($arg) {
            "--installed" { $mode = "installed" }
            "--available" { $mode = "available" }
            "--profiles"  { $mode = "profiles" }
        }
    }

    switch ($mode) {
        "registry" {
            Write-Color "Skills Registry (smorch-brain)" Cyan
            $catDirs = Get-ChildItem -Path (Join-Path $REPO_DIR "skills") -Directory -ErrorAction SilentlyContinue
            foreach ($catDir in $catDirs) {
                $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue
                $count = ($skillDirs | Measure-Object).Count
                Write-Host ""
                Write-Color "$($catDir.Name)/ ($count skills)" Green
                foreach ($skillDir in $skillDirs) {
                    Write-Host "  $($skillDir.Name)"
                }
            }
        }
        "installed" {
            Write-Color "Installed Skills ($SKILLS_TARGET)" Cyan
            if (-not (Test-Path $SKILLS_TARGET)) {
                Write-Host "  (none)"
                return
            }
            $total = 0
            $catDirs = Get-ChildItem -Path $SKILLS_TARGET -Directory -ErrorAction SilentlyContinue
            foreach ($catDir in $catDirs) {
                $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue
                $count = ($skillDirs | Measure-Object).Count
                $total += $count
                Write-Host ""
                Write-Color "$($catDir.Name)/ ($count skills)" Green
                foreach ($skillDir in $skillDirs) {
                    Write-Host "  $($skillDir.Name)"
                }
            }
            Write-Host ""
            Write-Color "Total: $total skills" Cyan
        }
        "available" {
            Write-Color "Available but NOT installed" Cyan
            $catDirs = Get-ChildItem -Path (Join-Path $REPO_DIR "skills") -Directory -ErrorAction SilentlyContinue
            foreach ($catDir in $catDirs) {
                $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue
                foreach ($skillDir in $skillDirs) {
                    $installedPath = Join-Path $SKILLS_TARGET "$($catDir.Name)\$($skillDir.Name)"
                    if (-not (Test-Path $installedPath)) {
                        Write-Host "  $($catDir.Name)/$($skillDir.Name)"
                    }
                }
            }
        }
        "profiles" {
            Write-Color "Available Profiles" Cyan
            $profileFiles = Get-ChildItem -Path (Join-Path $REPO_DIR "profiles") -Filter "*.txt" -ErrorAction SilentlyContinue
            foreach ($pf in $profileFiles) {
                $name = $pf.BaseName
                $resolved = Resolve-Profile -ProfileName $name 2>$null
                $count = ($resolved | Measure-Object).Count
                Write-Host "  " -NoNewline
                Write-Host "$name" -ForegroundColor Green -NoNewline
                Write-Host " ($count skills)"
            }
        }
    }
}

function Invoke-Diff {
    Push-Location "$REPO_DIR"
    try {
        git fetch origin dev 2>$null
        $diffOutput = git diff HEAD..origin/dev --stat -- skills/ 2>$null
        if ([string]::IsNullOrEmpty($diffOutput)) {
            Write-Color "No changes since last pull." Green
        }
        else {
            Write-Color "Changes on GitHub since last pull:" Cyan
            Write-Host $diffOutput
        }
    }
    finally {
        Pop-Location
    }
}

function Invoke-Status {
    Load-State
    Write-Color "smorch status" Cyan
    Write-Host ([string]::new([char]0x2500, 34))

    $profileDisplay = if ([string]::IsNullOrEmpty($script:CURRENT_PROFILE)) { "<not set>" } else { $script:CURRENT_PROFILE }
    $syncDisplay = if ([string]::IsNullOrEmpty($script:LAST_SYNC)) { "never" } else { $script:LAST_SYNC }

    Write-Host "Profile:    " -NoNewline; Write-Color $profileDisplay Green
    Write-Host "Last sync:  $syncDisplay"
    Write-Host "Registry:   $REPO_DIR"
    Write-Host "Skills dir: $SKILLS_TARGET"

    # Count installed
    if (Test-Path $SKILLS_TARGET) {
        $installed = 0
        $catDirs = Get-ChildItem -Path $SKILLS_TARGET -Directory -ErrorAction SilentlyContinue
        foreach ($catDir in $catDirs) {
            $installed += (Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
        }
        Write-Host "Installed:  " -NoNewline; Write-Color "$installed skills" Green
    }
    else {
        Write-Host "Installed:  " -NoNewline; Write-Color "0 (no skills dir)" Red
    }

    # Count in registry
    $registryCount = 0
    $regSkillsDir = Join-Path $REPO_DIR "skills"
    if (Test-Path $regSkillsDir) {
        $catDirs = Get-ChildItem -Path $regSkillsDir -Directory -ErrorAction SilentlyContinue
        foreach ($catDir in $catDirs) {
            $registryCount += (Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
        }
    }
    Write-Host "Registry:   $registryCount skills"

    # Git status
    Push-Location "$REPO_DIR" -ErrorAction SilentlyContinue
    try {
        $branch = git branch --show-current 2>$null
        $behind = git rev-list HEAD..origin/dev --count 2>$null
        if ([string]::IsNullOrEmpty($behind)) { $behind = "?" }
        Write-Host "Git branch: $branch ($behind commits behind)"
    }
    catch {
        Write-Host "Git branch: (unknown)"
    }
    finally {
        Pop-Location
    }
    Write-Host ([string]::new([char]0x2500, 34))
}

function Invoke-Init {
    param(
        [string[]]$Args,
        [string]$ProfileParam
    )

    $profile = ""

    # Use -Profile parameter if provided
    if (-not [string]::IsNullOrEmpty($ProfileParam)) {
        $profile = $ProfileParam
    }

    # Also check remaining args for -Profile or --profile (backward compat)
    for ($i = 0; $i -lt $Args.Count; $i++) {
        if ($Args[$i] -in @("-Profile", "--profile") -and ($i + 1) -lt $Args.Count) {
            $profile = $Args[$i + 1]
            $i++
        }
    }

    if ([string]::IsNullOrEmpty($profile)) {
        Write-Color "Usage: smorch.ps1 init --profile <name>" Red
        Write-Host "Available profiles:"
        $profileFiles = Get-ChildItem -Path (Join-Path $REPO_DIR "profiles") -Filter "*.txt" -ErrorAction SilentlyContinue
        foreach ($pf in $profileFiles) {
            Write-Host "  $($pf.BaseName)"
        }
        return
    }

    Write-Color "smorch init -- First-time setup" Cyan

    # Ensure repo is cloned
    if (-not (Test-Path $REPO_DIR)) {
        Write-Host "Cloning smorch-brain..."
        git clone git@github.com:SMOrchestra-ai/smorch-brain.git "$REPO_DIR"
    }

    # Pull and install
    Invoke-Pull -Args @() -ProfileParam $profile

    Write-Color "Setup complete! Run 'smorch.ps1 status' to verify." Green
}

function Invoke-Audit {
    Write-Color "smorch audit -- Checking for issues" Cyan
    Write-Host ([string]::new([char]0x2500, 34))
    $issues = 0

    $skillsPath = Join-Path $env:USERPROFILE ".claude\skills"

    # 1. Unmapped skills
    if (Test-Path $skillsPath) {
        Write-Host ""
        Write-Color "Checking for unmapped skills..." Cyan
        $skillDirs = Get-ChildItem -Path $skillsPath -Directory -ErrorAction SilentlyContinue
        foreach ($skillDir in $skillDirs) {
            $skillMd = Join-Path $skillDir.FullName "SKILL.md"
            if (-not (Test-Path $skillMd)) { continue }
            $categoryFile = Join-Path $skillDir.FullName ".smorch-category"
            if (-not (Test-Path $categoryFile)) {
                Write-Color "  UNMAPPED: $($skillDir.Name) -- missing .smorch-category file" Yellow
                $issues++
            }
        }
    }

    # 2. Missing version files
    Write-Host ""
    Write-Color "Checking for missing version files..." Cyan
    if (Test-Path $skillsPath) {
        $skillDirs = Get-ChildItem -Path $skillsPath -Directory -ErrorAction SilentlyContinue
        foreach ($skillDir in $skillDirs) {
            $skillMd = Join-Path $skillDir.FullName "SKILL.md"
            if (-not (Test-Path $skillMd)) { continue }
            $versionFile = Join-Path $skillDir.FullName ".smorch-version"
            if (-not (Test-Path $versionFile)) {
                Write-Color "  NO VERSION: $($skillDir.Name) -- missing .smorch-version file" Yellow
                $issues++
            }
        }
    }

    # 3. Oversized SKILL.md files (>500 lines)
    Write-Host ""
    Write-Color "Checking for oversized SKILL.md files (>500 lines)..." Cyan
    $searchPaths = @($skillsPath, (Join-Path $REPO_DIR "plugins"))
    foreach ($searchPath in $searchPaths) {
        if (-not (Test-Path $searchPath)) { continue }
        $skillMdFiles = Get-ChildItem -Path $searchPath -Filter "SKILL.md" -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $skillMdFiles) {
            $lineCount = (Get-Content $file.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
            if ($lineCount -gt 500) {
                Write-Color "  OVERSIZED: $($file.FullName) ($lineCount lines, limit: 500)" Red
                $issues++
            }
        }
    }

    # 4. Skills not in any profile
    Write-Host ""
    Write-Color "Checking for skills not in any profile..." Cyan
    $regSkillsDir = Join-Path $REPO_DIR "skills"
    if (Test-Path $regSkillsDir) {
        $profilesDir = Join-Path $REPO_DIR "profiles"
        $profileFiles = Get-ChildItem -Path $profilesDir -Filter "*.txt" -ErrorAction SilentlyContinue
        $profileContents = @()
        foreach ($pf in $profileFiles) {
            $profileContents += Get-Content $pf.FullName -ErrorAction SilentlyContinue
        }
        $allProfileText = $profileContents -join "`n"

        $catDirs = Get-ChildItem -Path $regSkillsDir -Directory -ErrorAction SilentlyContinue
        foreach ($catDir in $catDirs) {
            $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue
            foreach ($skillDir in $skillDirs) {
                $catName = $catDir.Name
                $skillName = $skillDir.Name
                $inProfile = $false
                if ($allProfileText -match [regex]::Escape("$catName/*") -or
                    $allProfileText -match [regex]::Escape("$catName/$skillName") -or
                    $allProfileText -match '^\*$') {
                    $inProfile = $true
                }
                # Also check each profile for standalone *
                if (-not $inProfile) {
                    foreach ($line in $profileContents) {
                        if ($line.Trim() -eq "*") { $inProfile = $true; break }
                    }
                }
                if (-not $inProfile) {
                    Write-Color "  ORPHAN: $catName/$skillName -- not in any profile" Yellow
                    $issues++
                }
            }
        }
    }

    Write-Host ""
    Write-Host ([string]::new([char]0x2500, 34))
    if ($issues -eq 0) {
        Write-Color "All clear! No issues found." Green
    }
    else {
        Write-Color "Found $issues issue(s) to fix." Red
    }
}

function Invoke-BuildPlugin {
    param([string]$PluginName)

    if ([string]::IsNullOrEmpty($PluginName)) {
        Write-Color "Usage: smorch.ps1 build-plugin <name>" Red
        Write-Host "Available plugins:"
        Get-ChildItem -Path (Join-Path $REPO_DIR "plugins") -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  $($_.Name)"
        }
        return
    }

    $pluginDir = Join-Path $REPO_DIR "plugins\$PluginName"
    if (-not (Test-Path $pluginDir)) {
        Write-Color "Plugin not found: $pluginDir" Red
        return
    }

    $distDir = Join-Path $REPO_DIR "dist"
    if (-not (Test-Path $distDir)) {
        New-Item -ItemType Directory -Path $distDir -Force | Out-Null
    }
    $output = Join-Path $distDir "$PluginName.plugin"

    Write-Color "Building plugin: $PluginName" Cyan

    # Create zip excluding junk files
    $excludeDirs = @(".DS_Store", "node_modules", "__pycache__", ".git")
    $tempZip = "$output.zip"

    # Get all files, filter out excluded patterns
    $files = Get-ChildItem -Path $pluginDir -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $relativePath = $_.FullName.Substring($pluginDir.Length + 1)
        $exclude = $false
        foreach ($ed in $excludeDirs) {
            if ($relativePath -match [regex]::Escape($ed)) { $exclude = $true; break }
        }
        -not $exclude
    }

    if (Test-Path $output) { Remove-Item $output -Force }
    Compress-Archive -Path $files.FullName -DestinationPath $tempZip -Force
    Rename-Item -Path $tempZip -NewName (Split-Path $output -Leaf) -Force

    $size = "{0:N1} KB" -f ((Get-Item $output).Length / 1024)
    Write-Color "Built: $output ($size)" Green
    Write-Host "To install: Cowork > Customize > Workspace > point to smorch-brain > Save"
}

# --- Main dispatch ---

switch ($Command) {
    "push"          { Invoke-Push }
    "pull"          { Invoke-Pull -Args $Arguments -ProfileParam $Profile }
    "install"       { Invoke-Install -Target ($Arguments | Select-Object -First 1) }
    "remove"        { Invoke-Remove -Target ($Arguments | Select-Object -First 1) }
    "list"          { Invoke-List -Args $Arguments }
    "diff"          { Invoke-Diff }
    "status"        { Invoke-Status }
    "init"          { Invoke-Init -Args $Arguments -ProfileParam $Profile }
    "audit"         { Invoke-Audit }
    "build-plugin"  { Invoke-BuildPlugin -PluginName ($Arguments | Select-Object -First 1) }
    "--version"     { Write-Host "smorch v$VERSION" }
    { $_ -in "-h", "--help", "", $null } { Show-Usage }
    default         { Write-Host "Unknown command: $Command"; Show-Usage }
}
