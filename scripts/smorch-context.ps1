# smorch-context.ps1 — Download SMOrchestra context files (Windows PowerShell)
# Usage: .\smorch-context.ps1 -Folder EntrepreneurOasis

param(
    [Parameter(Position=0)]
    [string]$Action = "help",

    [Parameter()]
    [string]$Folder
)

$Version = "1.0.0"
$RepoUrl = "https://github.com/SMOrchestra-ai/smorch-context.git"
# Auto-detect repo location (works on Windows, Mac via PowerShell Core, Linux)
$cwPath = Join-Path $env:USERPROFILE "Desktop" "cowork-workspace" "smorch-context"
$homePath = Join-Path $env:USERPROFILE "smorch-context"
if (Test-Path $cwPath) {
    $ContextDir = $cwPath
} elseif (Test-Path $homePath) {
    $ContextDir = $homePath
} else {
    $ContextDir = Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "smorch-context"
}
$ValidFolders = @("EntrepreneurOasis", "SalesMfastGTM", "CC_CX")

function Show-Usage {
    Write-Host @"
smorch-context v$Version — Download SMOrchestra context files (Windows)

Usage:
  .\smorch-context.ps1 -Folder <name>     Download a specific context folder
  .\smorch-context.ps1 -Folder all         Download all context folders
  .\smorch-context.ps1 -Action list        Show available folders
  .\smorch-context.ps1 -Action update      Update all downloaded files
  .\smorch-context.ps1 -Action status      Show download status

Folders:
  EntrepreneurOasis    EO MENA — MicroSaaS training (4 projects)
  SalesMfastGTM        SalesMfast — B2B signal-based GTM (6 projects)
  CC_CX                CXMfast — Contact center technology (3 projects)

Examples:
  .\smorch-context.ps1 -Folder EntrepreneurOasis
  .\smorch-context.ps1 -Folder all
  .\smorch-context.ps1 -Action update
"@
}

function Ensure-Repo {
    if (-not (Test-Path (Join-Path $ContextDir ".git"))) {
        Write-Host "First-time setup: cloning smorch-context..." -ForegroundColor Cyan
        git clone --no-checkout $RepoUrl $ContextDir
        Push-Location $ContextDir
        git sparse-checkout init --cone
        Pop-Location
        Write-Host "Repo initialized with sparse-checkout." -ForegroundColor Green
    }
}

function Get-Folder {
    param([string]$FolderName)

    if ($FolderName -ne "all" -and $FolderName -notin $ValidFolders) {
        Write-Host "ERROR: Unknown folder '$FolderName'" -ForegroundColor Red
        Write-Host "Valid folders: $($ValidFolders -join ', ')"
        return
    }

    Ensure-Repo
    Push-Location $ContextDir

    Write-Host "Pulling latest from GitHub..." -ForegroundColor Cyan
    git pull origin main --rebase 2>&1 | Out-Null

    if ($FolderName -eq "all") {
        git sparse-checkout disable 2>$null
        git checkout main 2>$null
        Write-Host "Downloaded ALL context folders:" -ForegroundColor Green
        foreach ($f in $ValidFolders) {
            $path = Join-Path $ContextDir $f
            if (Test-Path $path) {
                $count = (Get-ChildItem -Path $path -Recurse -File).Count
                Write-Host "  $f ($count files)" -ForegroundColor Green
            }
        }
    } else {
        git sparse-checkout set $FolderName README.md 2>$null
        git checkout main 2>$null

        $path = Join-Path $ContextDir $FolderName
        if (Test-Path $path) {
            $count = (Get-ChildItem -Path $path -Recurse -File).Count
            Write-Host "Downloaded: $FolderName ($count files)" -ForegroundColor Green
            Write-Host ""
            Write-Host "Projects:" -ForegroundColor Cyan
            Get-ChildItem -Path $path -Directory | ForEach-Object { Write-Host "  $($_.Name)" }
        } else {
            Write-Host "ERROR: Folder '$FolderName' not found after checkout" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "Context files at: $ContextDir\$FolderName" -ForegroundColor Cyan
    Pop-Location
}

function Update-Context {
    if (-not (Test-Path (Join-Path $ContextDir ".git"))) {
        Write-Host "ERROR: No context downloaded yet. Run: .\smorch-context.ps1 -Folder <name>" -ForegroundColor Red
        return
    }
    Push-Location $ContextDir
    Write-Host "Updating context files..." -ForegroundColor Cyan
    git pull origin main --rebase
    Write-Host "Updated." -ForegroundColor Green
    Pop-Location
    Show-Status
}

function Show-Status {
    if (-not (Test-Path (Join-Path $ContextDir ".git"))) {
        Write-Host "Not set up yet. Run: .\smorch-context.ps1 -Folder <name>" -ForegroundColor Yellow
        return
    }
    Push-Location $ContextDir
    Write-Host "smorch-context status" -ForegroundColor Cyan
    Write-Host "Location: $ContextDir"
    Write-Host ""
    Write-Host "Downloaded folders:" -ForegroundColor Cyan
    foreach ($f in $ValidFolders) {
        $path = Join-Path $ContextDir $f
        if (Test-Path $path) {
            $count = (Get-ChildItem -Path $path -Recurse -File).Count
            Write-Host "  $f — $count files" -ForegroundColor Green
        } else {
            Write-Host "  $f — not downloaded" -ForegroundColor Yellow
        }
    }
    Pop-Location
}

function Show-List {
    Write-Host "Available Context Folders" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "EntrepreneurOasis — EO MENA MicroSaaS Training" -ForegroundColor Green
    Write-Host "  Project1-MicroSaaSClaudeOS Training"
    Write-Host "  Project2-EO Build AppSumoTech"
    Write-Host "  Project3-AI Super cowork training"
    Write-Host "  Project4-AI Super MicroSaaS LauncherTech"
    Write-Host ""
    Write-Host "SalesMfastGTM — B2B Signal-Based GTM" -ForegroundColor Green
    Write-Host "  Project1-SalesMfastExpand"
    Write-Host "  Project2-SalesMfastB2B"
    Write-Host "  Project3-SalesMfast-SME"
    Write-Host "  Project4-CohortTraining"
    Write-Host "  Project5-MarketingTransformation"
    Write-Host "  Project6-SSEngineTech"
    Write-Host ""
    Write-Host "CC_CX — Contact Center / CXMfast" -ForegroundColor Green
    Write-Host "  Project1-CC transformation"
    Write-Host "  Project2-CXMfast"
    Write-Host "  Project3-CX community"
}

# Main dispatch
if ($Folder) {
    Get-Folder -FolderName $Folder
} else {
    switch ($Action) {
        "list"    { Show-List }
        "update"  { Update-Context }
        "status"  { Show-Status }
        "help"    { Show-Usage }
        default   { Show-Usage }
    }
}
