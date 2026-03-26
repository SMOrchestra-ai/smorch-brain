# smorch-install-plugins.ps1 -- Install plugins for your role
# GTM roles: Cowork only (no Code plugins)
# Dev/EO roles: Cowork + 7 Claude Code dev tools
# Works on: Windows (PowerShell)

param(
    [string]$Role = "",
    [switch]$List,
    [switch]$Help
)

# --- Prerequisite checks ---
function Test-Prerequisites {
    $missing = @()
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { $missing += "claude" }
    if ($missing.Count -gt 0) {
        Write-Host "ERROR: Missing required tools: $($missing -join ', ')" -ForegroundColor Red
        exit 1
    }
}
Test-Prerequisites

if ($Help -or (-not $Role -and -not $List)) {
    Write-Host "smorch-install-plugins -- Install plugins for your role"
    Write-Host ""
    Write-Host "ROLES:"
    Write-Host "  -Role gtm-eo       GTM-EO team (Cowork only)"
    Write-Host "  -Role gtm-smo      GTM-SMO team (Cowork only)"
    Write-Host "  -Role dev          Dev team (Cowork + 7 Code dev tools)"
    Write-Host "  -Role eo-student   EO student (Cowork + 7 Code dev tools)"
    Write-Host "  -Role mamoun       Everything"
    Write-Host ""
    Write-Host "  -List              Show what each role gets"
    exit 0
}

function Install-CodePlugins {
    Write-Host "Installing 7 Claude Code Dev Tools" -ForegroundColor Cyan
    Write-Host "(NOT available in Cowork - Code only)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Language Servers:" -ForegroundColor Blue
    foreach ($p in @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp")) {
        Write-Host "  Installing $p@claude-plugins-official..." -ForegroundColor Blue -NoNewline
        try { claude /plugin install "$p@claude-plugins-official" 2>$null; Write-Host " OK" -ForegroundColor Green }
        catch { Write-Host " SKIP" -ForegroundColor Yellow }
    }
    Write-Host ""
    Write-Host "  Dev Tools:" -ForegroundColor Blue
    foreach ($p in @("code-review", "frontend-design", "github")) {
        Write-Host "  Installing $p@claude-plugins-official..." -ForegroundColor Blue -NoNewline
        try { claude /plugin install "$p@claude-plugins-official" 2>$null; Write-Host " OK" -ForegroundColor Green }
        catch { Write-Host " SKIP" -ForegroundColor Yellow }
    }
}

if ($List) {
    Write-Host "=== What Each Role Gets ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "GTM-EO:" -ForegroundColor Green
    Write-Host "  Cowork (7): smorch-context-brain, smorch-gtm-tools, smorch-gtm-engine,"
    Write-Host "              smorch-design, mamoun-personal-branding, smorch-gtm-scoring,"
    Write-Host "              eo-microsaas-os"
    Write-Host "  Code: None"
    Write-Host ""
    Write-Host "GTM-SMO:" -ForegroundColor Green
    Write-Host "  Cowork (6): smorch-context-brain, smorch-gtm-tools, smorch-gtm-engine,"
    Write-Host "              smorch-design, mamoun-personal-branding, smorch-gtm-scoring"
    Write-Host "  Code: None"
    Write-Host ""
    Write-Host "Dev:" -ForegroundColor Green
    Write-Host "  Cowork (2): smorch-dev, smorch-dev-scoring"
    Write-Host "  Code (7): 4 LSPs + code-review + frontend-design + github"
    Write-Host ""
    Write-Host "EO Student:" -ForegroundColor Green
    Write-Host "  Cowork (3): eo-microsaas-os, smorch-dev, smorch-dev-scoring"
    Write-Host "  Code (7): 4 LSPs + code-review + frontend-design + github"
    exit 0
}

switch ($Role) {
    "gtm-eo" {
        Write-Host "=== GTM-EO Team Setup ===" -ForegroundColor Green
        Write-Host ""
        Write-Host "No Claude Code plugins needed for GTM roles." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Load plugins into Cowork Desktop:" -ForegroundColor Cyan
        Write-Host "  1. Open Claude Desktop (Cowork)"
        Write-Host "  2. Go to Customize > Workspace"
        Write-Host "  3. Point workspace to your smorch-brain directory"
        Write-Host "  4. Cowork scans and discovers all plugins automatically"
        Write-Host "  5. Click Save -- plugins are now active"
        Write-Host ""
        Write-Host "Your role gets these 7 plugins:" -ForegroundColor Cyan
        Write-Host "  - smorch-context-brain"
        Write-Host "  - smorch-gtm-tools"
        Write-Host "  - smorch-gtm-engine"
        Write-Host "  - smorch-design"
        Write-Host "  - mamoun-personal-branding"
        Write-Host "  - smorch-gtm-scoring"
        Write-Host "  - eo-microsaas-os"
    }
    "gtm-smo" {
        Write-Host "=== GTM-SMO Team Setup ===" -ForegroundColor Green
        Write-Host ""
        Write-Host "No Claude Code plugins needed for GTM roles." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Load plugins into Cowork Desktop:" -ForegroundColor Cyan
        Write-Host "  1. Open Claude Desktop (Cowork)"
        Write-Host "  2. Go to Customize > Workspace"
        Write-Host "  3. Point workspace to your smorch-brain directory"
        Write-Host "  4. Cowork scans and discovers all plugins automatically"
        Write-Host "  5. Click Save -- plugins are now active"
        Write-Host ""
        Write-Host "Your role gets these 6 plugins:" -ForegroundColor Cyan
        Write-Host "  - smorch-context-brain"
        Write-Host "  - smorch-gtm-tools"
        Write-Host "  - smorch-gtm-engine"
        Write-Host "  - smorch-design"
        Write-Host "  - mamoun-personal-branding"
        Write-Host "  - smorch-gtm-scoring"
    }
    "dev" {
        Write-Host "=== Dev Team Setup ===" -ForegroundColor Green
        Write-Host ""
        Install-CodePlugins
        Write-Host ""
        Write-Host "Load plugins into Cowork Desktop:" -ForegroundColor Cyan
        Write-Host "  1. Open Claude Desktop (Cowork)"
        Write-Host "  2. Go to Customize > Workspace"
        Write-Host "  3. Point workspace to your smorch-brain directory"
        Write-Host "  4. Cowork scans and discovers all plugins automatically"
        Write-Host "  5. Click Save -- plugins are now active"
        Write-Host ""
        Write-Host "Your role gets these 2 plugins:" -ForegroundColor Cyan
        Write-Host "  - smorch-dev"
        Write-Host "  - smorch-dev-scoring"
    }
    "eo-student" {
        Write-Host "=== EO Student Setup ===" -ForegroundColor Green
        Write-Host ""
        Install-CodePlugins
        Write-Host ""
        Write-Host "Load plugins into Cowork Desktop:" -ForegroundColor Cyan
        Write-Host "  1. Open Claude Desktop (Cowork)"
        Write-Host "  2. Go to Customize > Workspace"
        Write-Host "  3. Point workspace to your smorch-brain directory"
        Write-Host "  4. Cowork scans and discovers all plugins automatically"
        Write-Host "  5. Click Save -- plugins are now active"
        Write-Host ""
        Write-Host "Your role gets these 3 plugins:" -ForegroundColor Cyan
        Write-Host "  - eo-microsaas-os"
        Write-Host "  - smorch-dev"
        Write-Host "  - smorch-dev-scoring"
    }
    "mamoun" {
        Write-Host "=== Mamoun (All Access) ===" -ForegroundColor Green
        Install-CodePlugins
        Write-Host ""
        Write-Host "All Cowork plugins should already be installed." -ForegroundColor Cyan
    }
    default {
        Write-Host "Unknown role: $Role. Use: gtm-eo, gtm-smo, dev, eo-student, mamoun" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
