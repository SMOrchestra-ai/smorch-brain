<#
.SYNOPSIS
    smorch-server-setup -- One-command setup for new server or team member machine (PowerShell)

.DESCRIPTION
    Clones the smorch-brain repo, cleans duplicates, pulls the profile,
    adds smorch to PATH, and confirms everything is working.

.PARAMETER Profile
    Profile to install (e.g., mamoun, smo-brain, team-dev). Required.

.PARAMETER RepoUrl
    Override default repo URL.

.PARAMETER Branch
    Checkout specific branch (default: dev).

.PARAMETER SkipCleanup
    Skip the duplicate cleanup step.

.EXAMPLE
    .\smorch-server-setup.ps1 -Profile smo-brain
    .\smorch-server-setup.ps1 -Profile mamoun -Branch develop
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Profile,

    [string]$RepoUrl = "https://github.com/SMOrchestra-ai/smorch-brain.git",

    [string]$Branch = "dev",

    [switch]$SkipCleanup,

    [Alias("h")]
    [switch]$Help
)

# --- Prerequisite checks (early, before param-dependent code) ---
function Test-ScriptPrerequisites {
    $missing = @()
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $missing += "git" }
    if ($missing.Count -gt 0) {
        Write-Host "ERROR: Missing required tools: $($missing -join ', ')" -ForegroundColor Red
        exit 1
    }
}
Test-ScriptPrerequisites

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

$VERSION = "1.0.0"
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
$SCRIPTS_DIR = Join-Path $REPO_DIR "scripts"
$SMORCH_BIN = Join-Path $SCRIPTS_DIR "smorch.ps1"

# --- Logging helpers ---

function Log-Info    { param([string]$Msg) Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline; Write-Host $Msg }
function Log-Success { param([string]$Msg) Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $Msg }
function Log-Warn    { param([string]$Msg) Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $Msg }
function Log-Error   { param([string]$Msg) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $Msg }
function Log-Header  { param([string]$Msg) Write-Host ""; Write-Host "=== $Msg ===" -ForegroundColor White }
function Log-Step    { param([int]$Num, [string]$Msg) Write-Host ""; Write-Host "[$Num/6] " -ForegroundColor White -NoNewline; Write-Host $Msg }

if ($Help) {
    Write-Host @"
smorch-server-setup v$VERSION -- One-command setup for new machines

Usage: smorch-server-setup.ps1 -Profile <name> [options]

Required:
  -Profile <name>     Profile to install (e.g., mamoun, smo-brain, team-dev)

Options:
  -RepoUrl <url>      Override default repo URL
                      (default: https://github.com/SMOrchestra-ai/smorch-brain.git)
  -Branch <name>      Checkout specific branch (default: dev)
  -SkipCleanup        Skip the duplicate cleanup step
  -Help               Show this help message

What it does:
  1. Clones smorch-brain repo (if not already present)
  2. Runs smorch-cleanup to remove duplicates
  3. Runs smorch pull --profile <name> to install skills
  4. Adds smorch to PATH via PowerShell profile
  5. Runs smorch status to confirm setup
  6. Prints next steps

Example:
  .\smorch-server-setup.ps1 -Profile smo-brain
  .\smorch-server-setup.ps1 -Profile mamoun -Branch develop
"@
    return
}

# --- Step 0: Prerequisites ---

function Test-Prerequisites {
    Log-Step 0 "Checking prerequisites"

    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCmd) {
        Log-Error "git is not installed. Install git first."
        exit 1
    }
    Log-Success "git found"

    $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $pwshCmd) {
        $pwshCmd = Get-Command powershell -ErrorAction SilentlyContinue
    }
    if ($pwshCmd) {
        Log-Success "PowerShell found"
    }

    # Ensure ~/.claude directory exists
    $claudeDir = Join-Path $env:USERPROFILE ".claude\skills"
    if (-not (Test-Path $claudeDir)) {
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    }
    Log-Success "~/.claude directory ready"
}

# --- Step 1: Clone repo ---

function Install-Repo {
    Log-Step 1 "Cloning smorch-brain repository"

    if (Test-Path $REPO_DIR) {
        Log-Info "Repository already exists at $REPO_DIR"
        Log-Info "Pulling latest changes..."
        Push-Location "$REPO_DIR"
        try {
            $result = Invoke-GitWithRetry @("pull", "origin", "$Branch")
            if ($LASTEXITCODE -ne 0) {
                Log-Warn "Could not pull latest. Using existing local copy."
            }
            else {
                Log-Success "Repository updated"
            }
        }
        finally {
            Pop-Location
        }
    }
    else {
        Log-Info "Cloning from $RepoUrl (branch: $Branch)..."
        $result = Invoke-GitWithRetry @("clone", "--branch", "$Branch", "$RepoUrl", "$REPO_DIR")
        if ($LASTEXITCODE -ne 0) {
            Log-Error "Failed to clone repository from $RepoUrl"
            Log-Info "Check your network connection and repo access."
            exit 1
        }
        Log-Success "Repository cloned to $REPO_DIR"
    }

    # Verify smorch script exists
    if (-not (Test-Path $SMORCH_BIN)) {
        Log-Error "smorch.ps1 script not found at $SMORCH_BIN"
        Log-Error "Repository may be incomplete or corrupted."
        exit 1
    }
    Log-Success "smorch.ps1 verified"
}

# --- Step 2: Run cleanup ---

function Invoke-Cleanup {
    Log-Step 2 "Running smorch-cleanup"

    if ($SkipCleanup) {
        Log-Info "Skipping cleanup (-SkipCleanup flag set)"
        return
    }

    $cleanupScript = Join-Path $SCRIPTS_DIR "smorch-cleanup.ps1"
    if (-not (Test-Path $cleanupScript)) {
        Log-Warn "smorch-cleanup.ps1 not found at $cleanupScript -- skipping"
        return
    }

    try {
        & $cleanupScript -Force
        Log-Success "Cleanup complete"
    }
    catch {
        Log-Warn "Cleanup encountered issues but continuing setup"
    }
}

# --- Step 3: Pull profile ---

function Install-Profile {
    Log-Step 3 "Pulling profile: $Profile"

    try {
        & $SMORCH_BIN pull -Profile $Profile
        if ($LASTEXITCODE -ne 0) {
            Log-Error "Failed to pull profile '$Profile'"
            Log-Info "Check available profiles with: smorch.ps1 list --profiles"
            exit 1
        }
        Log-Success "Profile '$Profile' installed"
    }
    catch {
        Log-Error "Failed to pull profile '$Profile': $_"
        exit 1
    }
}

# --- Step 4: Add to PATH ---

function Add-ToPath {
    Log-Step 4 "Adding smorch to PATH"

    # Check if already in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -and $currentPath.Contains($SCRIPTS_DIR)) {
        Log-Info "PATH already contains $SCRIPTS_DIR"
    }
    else {
        # Add to user PATH environment variable
        $newPath = "$SCRIPTS_DIR;$currentPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Log-Success "Added $SCRIPTS_DIR to user PATH"
    }

    # Also add to PowerShell profile for alias convenience
    $psProfile = $PROFILE.CurrentUserCurrentHost
    $profileDir = Split-Path $psProfile -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }

    $aliasLine = "Set-Alias -Name smorch -Value `"$SMORCH_BIN`""
    if ((Test-Path $psProfile) -and (Get-Content $psProfile -Raw -ErrorAction SilentlyContinue) -match [regex]::Escape("smorch")) {
        Log-Info "PowerShell profile already contains smorch alias"
    }
    else {
        Add-Content -Path $psProfile -Value ""
        Add-Content -Path $psProfile -Value "# smorch-brain CLI"
        Add-Content -Path $psProfile -Value $aliasLine
        Log-Success "Added smorch alias to PowerShell profile"
    }

    # Add to current session
    $env:Path = "$SCRIPTS_DIR;$env:Path"
}

# --- Step 5: Verify ---

function Test-Setup {
    Log-Step 5 "Verifying setup"

    try {
        & $SMORCH_BIN status
        Log-Success "Setup verified"
    }
    catch {
        Log-Warn "smorch status returned an error. Check output above."
    }
}

# --- Step 6: Next steps ---

function Show-NextSteps {
    Log-Step 6 "Setup complete"

    Write-Host ""
    Write-Host "smorch-server-setup finished successfully." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "  1. Reload your shell:    " -NoNewline; Write-Host ". `$PROFILE" -ForegroundColor Cyan
    Write-Host "  2. Verify installation:  " -NoNewline; Write-Host "smorch status" -ForegroundColor Cyan
    Write-Host "  3. List installed skills: " -NoNewline; Write-Host "smorch list --installed" -ForegroundColor Cyan
    Write-Host "  4. Run an audit:         " -NoNewline; Write-Host "smorch audit" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Profile: " -ForegroundColor White -NoNewline; Write-Host $Profile
    Write-Host "Repo:    " -ForegroundColor White -NoNewline; Write-Host $REPO_DIR
    Write-Host "Scripts: " -ForegroundColor White -NoNewline; Write-Host $SCRIPTS_DIR
    Write-Host ""
}

# --- Main ---

Log-Header "smorch-server-setup v$VERSION"
Log-Info "Setting up profile: $Profile"

Test-Prerequisites
Install-Repo
Invoke-Cleanup
Install-Profile
Add-ToPath
Test-Setup
Show-NextSteps
