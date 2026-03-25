# smorch-install-plugins.ps1 — Install all recommended Claude Code plugins
# Works on: Windows (PowerShell)
# Usage: .\smorch-install-plugins.ps1 [-Mode all|lsp|official|gtm]

param(
    [ValidateSet("all", "lsp", "official", "gtm")]
    [string]$Mode = "all",
    [switch]$Help
)

if ($Help) {
    Write-Host "smorch-install-plugins — Install Claude Code plugins"
    Write-Host ""
    Write-Host "Usage: .\smorch-install-plugins.ps1 [-Mode all|lsp|official|gtm]"
    Write-Host ""
    Write-Host "Modes:"
    Write-Host "  all       Install everything (default)"
    Write-Host "  lsp       Install language server plugins only"
    Write-Host "  official  Install official Anthropic plugins only"
    Write-Host "  gtm       Install GTM agents plugins only"
    exit 0
}

function Install-Plugin {
    param([string]$Name, [string]$Registry)
    Write-Host "Installing $Name@$Registry..." -ForegroundColor Blue -NoNewline
    try {
        claude /plugin install "$Name@$Registry" 2>$null
        Write-Host " OK" -ForegroundColor Green
    } catch {
        Write-Host " SKIP (may already be installed)" -ForegroundColor Yellow
    }
}

$officialPlugins = @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp", "code-review", "frontend-design", "github")
$lspPlugins = @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp")
$gtmPlugins = @("campaign-orchestration", "content-marketing", "customer-analytics", "email-marketing", "growth-experiments", "revenue-analytics", "sales-enablement", "sales-pipeline", "sales-prospecting")

switch ($Mode) {
    "lsp" {
        Write-Host "Installing LSP plugins..." -ForegroundColor Green
        foreach ($p in $lspPlugins) { Install-Plugin -Name $p -Registry "claude-plugins-official" }
    }
    "official" {
        Write-Host "Installing official Anthropic plugins..." -ForegroundColor Green
        foreach ($p in $officialPlugins) { Install-Plugin -Name $p -Registry "claude-plugins-official" }
    }
    "gtm" {
        Write-Host "Installing GTM agents plugins..." -ForegroundColor Green
        foreach ($p in $gtmPlugins) { Install-Plugin -Name $p -Registry "gtm-agents" }
    }
    "all" {
        Write-Host "Installing ALL Claude Code plugins..." -ForegroundColor Green
        Write-Host ""
        Write-Host "=== Official Anthropic ===" -ForegroundColor Cyan
        foreach ($p in $officialPlugins) { Install-Plugin -Name $p -Registry "claude-plugins-official" }
        Write-Host ""
        Write-Host "=== GTM Agents ===" -ForegroundColor Cyan
        foreach ($p in $gtmPlugins) { Install-Plugin -Name $p -Registry "gtm-agents" }
    }
}

Write-Host ""
Write-Host "Done! Restart Claude Code to activate new plugins." -ForegroundColor Green
