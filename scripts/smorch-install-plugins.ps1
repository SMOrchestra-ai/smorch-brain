# smorch-install-plugins.ps1 — Install the right plugins for your role
# Works on: Windows (PowerShell)
# Usage: .\smorch-install-plugins.ps1 -Role gtm|dev|eo-student|mamoun

param(
    [string]$Role = "",
    [ValidateSet("all", "official", "lsp", "gtm", "list-cowork")]
    [string]$Mode = "",
    [switch]$Help
)

if ($Help -or (-not $Role -and -not $Mode)) {
    Write-Host "smorch-install-plugins — Install the right plugins for your role"
    Write-Host ""
    Write-Host "BY ROLE (recommended):"
    Write-Host "  -Role gtm          GTM team: all Code plugins + Cowork list"
    Write-Host "  -Role dev          Dev team: official Code plugins + Cowork list"
    Write-Host "  -Role eo-student   EO student: official Code plugins + Cowork list"
    Write-Host "  -Role mamoun       Everything"
    Write-Host ""
    Write-Host "MANUAL:"
    Write-Host "  -Mode all          All Claude Code plugins"
    Write-Host "  -Mode official     Official Anthropic only"
    Write-Host "  -Mode lsp          Language servers only"
    Write-Host "  -Mode gtm          GTM agents only"
    Write-Host "  -Mode list-cowork  Show Cowork plugins per role"
    exit 0
}

function Install-Plugin {
    param([string]$Name, [string]$Registry)
    Write-Host "Installing $Name@$Registry..." -ForegroundColor Blue -NoNewline
    try {
        claude /plugin install "$Name@$Registry" 2>$null
        Write-Host " OK" -ForegroundColor Green
    } catch {
        Write-Host " SKIP (already installed)" -ForegroundColor Yellow
    }
}

$officialPlugins = @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp", "code-review", "frontend-design", "github")
$gtmPlugins = @("campaign-orchestration", "content-marketing", "customer-analytics", "email-marketing", "growth-experiments", "revenue-analytics", "sales-enablement", "sales-pipeline", "sales-prospecting")

function Install-Official {
    Write-Host "=== Official Anthropic Plugins (7) ===" -ForegroundColor Cyan
    foreach ($p in $officialPlugins) { Install-Plugin -Name $p -Registry "claude-plugins-official" }
}

function Install-GtmAgents {
    Write-Host "=== GTM Agent Plugins (9) ===" -ForegroundColor Cyan
    foreach ($p in $gtmPlugins) { Install-Plugin -Name $p -Registry "gtm-agents" }
}

# Handle -Role
if ($Role) {
    switch ($Role) {
        "gtm" {
            Write-Host "=== GTM Team Setup ===" -ForegroundColor Green
            Write-Host "Installing: 7 official + 9 GTM agent plugins" -ForegroundColor White
            Write-Host ""
            Install-Official
            Write-Host ""
            Install-GtmAgents
            Write-Host ""
            Write-Host "=== NOW: Install these in Cowork Desktop ===" -ForegroundColor Cyan
            Write-Host "   Go to: Customize > Plugins > Search marketplace" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  1. smorch-context-brain     - Project brain builder"
            Write-Host "  2. smorch-gtm-tools         - Clay, GHL, Instantly, HeyReach, SalesNav"
            Write-Host "  3. smorch-gtm-engine        - Campaigns, signals, wedges, outbound"
            Write-Host "  4. smorch-design            - Frontend design, brand system"
            Write-Host "  5. mamoun-personal-branding  - LinkedIn, YouTube, content"
        }
        "dev" {
            Write-Host "=== Dev Team Setup ===" -ForegroundColor Green
            Write-Host "Installing: 7 official plugins (no GTM agents)" -ForegroundColor White
            Write-Host ""
            Install-Official
            Write-Host ""
            Write-Host "=== NOW: Install this in Cowork Desktop ===" -ForegroundColor Cyan
            Write-Host "  1. smorch-dev - Debugging, code review, MCP builder, n8n" -ForegroundColor White
        }
        "eo-student" {
            Write-Host "=== EO Student Setup ===" -ForegroundColor Green
            Write-Host "Installing: 7 official plugins (no GTM agents)" -ForegroundColor White
            Write-Host ""
            Install-Official
            Write-Host ""
            Write-Host "=== NOW: Install these in Cowork Desktop ===" -ForegroundColor Cyan
            Write-Host "  1. eo-microsaas-os - Full MicroSaaS journey" -ForegroundColor White
            Write-Host "  2. smorch-dev      - Debugging, code review, testing" -ForegroundColor White
        }
        "mamoun" {
            Write-Host "=== Mamoun (All Access) ===" -ForegroundColor Green
            Install-Official
            Write-Host ""
            Install-GtmAgents
        }
        default {
            Write-Host "Unknown role: $Role. Use: gtm, dev, eo-student, mamoun" -ForegroundColor Red
            exit 1
        }
    }
} elseif ($Mode) {
    switch ($Mode) {
        "all" { Install-Official; Write-Host ""; Install-GtmAgents }
        "official" { Install-Official }
        "lsp" {
            foreach ($p in @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp")) {
                Install-Plugin -Name $p -Registry "claude-plugins-official"
            }
        }
        "gtm" { Install-GtmAgents }
        "list-cowork" {
            Write-Host "=== Cowork Plugins by Role ===" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "GTM Team (5 plugins):" -ForegroundColor Green
            Write-Host "  smorch-context-brain, smorch-gtm-tools, smorch-gtm-engine,"
            Write-Host "  smorch-design, mamoun-personal-branding"
            Write-Host ""
            Write-Host "Dev Team (1 plugin):" -ForegroundColor Green
            Write-Host "  smorch-dev"
            Write-Host ""
            Write-Host "EO Student (2 plugins):" -ForegroundColor Green
            Write-Host "  eo-microsaas-os, smorch-dev"
        }
    }
}

Write-Host ""
Write-Host "Done! Restart Claude Code to activate new plugins." -ForegroundColor Green
