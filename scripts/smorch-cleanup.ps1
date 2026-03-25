<#
.SYNOPSIS
    smorch-cleanup -- Remove duplicate skills from Claude machines (PowerShell)

.DESCRIPTION
    Finds skills in ~/.claude/skills/ that also exist in installed plugins
    (~/.claude/plugins/), and commands in ~/.claude/commands/ that are
    oversized (>50 lines, likely skill duplicates). Backs up and removes
    duplicates after confirmation.

.PARAMETER DryRun
    Show what would be cleaned without making changes.

.PARAMETER Force
    Skip confirmation prompt.

.EXAMPLE
    .\smorch-cleanup.ps1
    .\smorch-cleanup.ps1 -DryRun
    .\smorch-cleanup.ps1 -Force
#>

param(
    [switch]$DryRun,
    [switch]$Force,
    [Alias("h")]
    [switch]$Help
)

$VERSION = "1.0.0"
$SKILLS_DIR = Join-Path $env:USERPROFILE ".claude\skills"
$PLUGINS_DIR = Join-Path $env:USERPROFILE ".claude\plugins"
$COMMANDS_DIR = Join-Path $env:USERPROFILE ".claude\commands"
$DATE_STAMP = Get-Date -Format "yyyyMMdd"
$SKILLS_BACKUP_DIR = Join-Path $env:USERPROFILE ".claude\skills-cleanup-backup-$DATE_STAMP"
$COMMANDS_BACKUP_DIR = Join-Path $env:USERPROFILE ".claude\commands-backup-$DATE_STAMP"

# --- Logging helpers ---

function Log-Info    { param([string]$Msg) Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline; Write-Host $Msg }
function Log-Success { param([string]$Msg) Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $Msg }
function Log-Warn    { param([string]$Msg) Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $Msg }
function Log-Error   { param([string]$Msg) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $Msg }
function Log-Header  { param([string]$Msg) Write-Host ""; Write-Host "=== $Msg ===" -ForegroundColor White }

function Show-Usage {
    Write-Host @"
smorch-cleanup v$VERSION -- Remove duplicate skills from Claude machines

Usage: smorch-cleanup.ps1 [options]

Description:
  Finds skills in ~/.claude/skills/ that also exist in installed plugins
  (~/.claude/plugins/), and commands in ~/.claude/commands/ that are
  oversized (>50 lines, likely skill duplicates). Backs up and removes
  duplicates after confirmation.

Options:
  -DryRun     Show what would be cleaned without making changes
  -Force      Skip confirmation prompt
  -Help       Show this help message

Backup locations:
  Skills:   $SKILLS_BACKUP_DIR
  Commands: $COMMANDS_BACKUP_DIR
"@
}

if ($Help) {
    Show-Usage
    return
}

# --- Duplicate detection ---

$script:SkillDupes = @()
$script:OversizedCommands = @()

function Find-SkillDuplicates {
    Log-Header "Scanning for duplicate skills"

    if (-not (Test-Path $SKILLS_DIR)) {
        Log-Warn "No skills directory found at $SKILLS_DIR -- skipping"
        return
    }

    if (-not (Test-Path $PLUGINS_DIR)) {
        Log-Warn "No plugins directory found at $PLUGINS_DIR -- skipping"
        return
    }

    # Build set of all .md filenames inside plugins
    $pluginSkills = @{}
    $pluginFiles = Get-ChildItem -Path $PLUGINS_DIR -Filter "*.md" -Recurse -File -ErrorAction SilentlyContinue
    foreach ($pf in $pluginFiles) {
        $pluginSkills[$pf.Name] = $true
    }

    # Check each skill file against plugin contents
    $skillFiles = Get-ChildItem -Path $SKILLS_DIR -Filter "*.md" -Recurse -File -ErrorAction SilentlyContinue
    foreach ($sf in $skillFiles) {
        if ($pluginSkills.ContainsKey($sf.Name)) {
            $script:SkillDupes += $sf.FullName
        }
    }

    if ($script:SkillDupes.Count -eq 0) {
        Log-Success "No duplicate skills found"
    }
    else {
        Log-Warn "Found $($script:SkillDupes.Count) duplicate skill(s):"
        foreach ($f in $script:SkillDupes) {
            $basename = Split-Path $f -Leaf
            Write-Host "  - " -ForegroundColor Yellow -NoNewline
            Write-Host "$basename  " -NoNewline
            Write-Host "($f)" -ForegroundColor Cyan
        }
    }
}

function Find-OversizedCommands {
    Log-Header "Scanning for oversized commands (>50 lines)"

    if (-not (Test-Path $COMMANDS_DIR)) {
        Log-Warn "No commands directory found at $COMMANDS_DIR -- skipping"
        return
    }

    $commandFiles = Get-ChildItem -Path $COMMANDS_DIR -File -Recurse -ErrorAction SilentlyContinue
    foreach ($cf in $commandFiles) {
        $lines = (Get-Content $cf.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
        if ($lines -gt 50) {
            $script:OversizedCommands += @{ Path = $cf.FullName; Lines = $lines }
        }
    }

    if ($script:OversizedCommands.Count -eq 0) {
        Log-Success "No oversized commands found"
    }
    else {
        Log-Warn "Found $($script:OversizedCommands.Count) oversized command(s):"
        foreach ($entry in $script:OversizedCommands) {
            $basename = Split-Path $entry.Path -Leaf
            Write-Host "  - " -ForegroundColor Yellow -NoNewline
            Write-Host "$basename  " -NoNewline
            Write-Host "($($entry.Lines) lines)" -ForegroundColor Cyan
        }
    }
}

function Confirm-Cleanup {
    $total = $script:SkillDupes.Count + $script:OversizedCommands.Count

    if ($total -eq 0) {
        Log-Success "Nothing to clean up. Machine is already tidy."
        return $false
    }

    if ($DryRun) {
        Write-Host ""
        Log-Info "Dry run complete. $total item(s) would be moved to backup."
        return $false
    }

    if (-not $Force) {
        Write-Host ""
        Write-Host "Will move $total item(s) to backup directories." -ForegroundColor White
        Write-Host "  Skills backup:   $SKILLS_BACKUP_DIR"
        Write-Host "  Commands backup: $COMMANDS_BACKUP_DIR"
        Write-Host ""
        $response = Read-Host "Proceed? [y/N]"
        if ($response -notmatch '^[Yy]$') {
            Log-Info "Cancelled. No changes made."
            return $false
        }
    }

    return $true
}

function Move-Duplicates {
    $movedSkills = 0
    $movedCommands = 0

    # Move duplicate skills
    if ($script:SkillDupes.Count -gt 0) {
        if (-not (Test-Path $SKILLS_BACKUP_DIR)) {
            New-Item -ItemType Directory -Path $SKILLS_BACKUP_DIR -Force | Out-Null
        }
        foreach ($f in $script:SkillDupes) {
            $basename = Split-Path $f -Leaf
            Move-Item -Path $f -Destination (Join-Path $SKILLS_BACKUP_DIR $basename) -Force
            $movedSkills++
            Log-Info "Moved $basename -> skills-cleanup-backup-$DATE_STAMP/"
        }
    }

    # Move oversized commands
    if ($script:OversizedCommands.Count -gt 0) {
        if (-not (Test-Path $COMMANDS_BACKUP_DIR)) {
            New-Item -ItemType Directory -Path $COMMANDS_BACKUP_DIR -Force | Out-Null
        }
        foreach ($entry in $script:OversizedCommands) {
            $basename = Split-Path $entry.Path -Leaf
            Move-Item -Path $entry.Path -Destination (Join-Path $COMMANDS_BACKUP_DIR $basename) -Force
            $movedCommands++
            Log-Info "Moved $basename -> commands-backup-$DATE_STAMP/"
        }
    }

    Log-Header "Cleanup Report"
    Write-Host "  Skills moved:   " -NoNewline; Write-Host $movedSkills -ForegroundColor Green
    Write-Host "  Commands moved: " -NoNewline; Write-Host $movedCommands -ForegroundColor Green
    if ($movedSkills -gt 0) {
        Write-Host "  Skills backup:  " -NoNewline; Write-Host $SKILLS_BACKUP_DIR -ForegroundColor Cyan
    }
    if ($movedCommands -gt 0) {
        Write-Host "  Commands backup: " -NoNewline; Write-Host $COMMANDS_BACKUP_DIR -ForegroundColor Cyan
    }
    Write-Host ""
    Log-Success "Cleanup complete. Backups preserved if you need to restore."
}

# --- Main ---

Log-Header "smorch-cleanup v$VERSION"
if ($DryRun) {
    Log-Info "Running in dry-run mode (no changes will be made)"
}

Find-SkillDuplicates
Find-OversizedCommands

$proceed = Confirm-Cleanup
if ($proceed) {
    Move-Duplicates
}
