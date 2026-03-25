# smorch-install-plugins.ps1 — Install Claude Code plugins (CLI-only, not Cowork)
# Works on: Windows (PowerShell)
# Usage: .\smorch-install-plugins.ps1 [-Mode all|lsp|official|gtm|list-cowork]

param(
    [ValidateSet("all", "lsp", "official", "gtm", "list-cowork",
                 "typescript", "python", "rust", "go", "code-review", "frontend", "github")]
    [string]$Mode = "all",
    [switch]$Help
)

if ($Help) {
    Write-Host "smorch-install-plugins — Install Claude Code plugins"
    Write-Host ""
    Write-Host "Claude Code Only (NOT in Cowork):"
    Write-Host "  -Mode all         Install all Claude Code plugins (default)"
    Write-Host "  -Mode lsp         Install language server plugins only (dev team)"
    Write-Host "  -Mode official    Install official Anthropic plugins only"
    Write-Host "  -Mode gtm         Install GTM agents plugins only"
    Write-Host "  -Mode list-cowork Show Cowork-only plugins"
    Write-Host ""
    Write-Host "Individual: -Mode typescript|python|rust|go|code-review|frontend|github"
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
$lspPlugins = @("typescript-lsp", "pyright-lsp", "rust-analyzer-lsp", "gopls-lsp")
$gtmPlugins = @("campaign-orchestration", "content-marketing", "customer-analytics", "email-marketing", "growth-experiments", "revenue-analytics", "sales-enablement", "sales-pipeline", "sales-prospecting")

switch ($Mode) {
    "list-cowork" {
        Write-Host "=== Cowork-Only Plugins (install via Claude Desktop > Customize > Plugins) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  eo-microsaas-os (v3.1.0)    13 skills   Upload dist/eo-microsaas-os.plugin"
        Write-Host "  smorch-gtm-engine (v2.0.0)  12 skills   Upload dist/smorch-gtm-engine.plugin"
        Write-Host "  eo-training-factory           1 skill    Upload dist/eo-training-factory.plugin"
        Write-Host "  eo-scoring-suite              5 skills   Already installed (marketplace)"
        Write-Host "  smorch-dev                   13 skills   Already installed (marketplace)"
        Write-Host "  mamoun-personal-branding      5 skills   Already installed (marketplace)"
        Write-Host "  smorch-context-brain          2 skills   Already installed (marketplace)"
        Write-Host "  smorch-design                 5 skills   Already installed (marketplace)"
        Write-Host "  smorch-gtm-tools              5 skills   Already installed (marketplace)"
        Write-Host ""
        Write-Host "  Anthropic built-in           16 skills   Pre-installed with Cowork"
    }
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
    "typescript" { Install-Plugin -Name "typescript-lsp" -Registry "claude-plugins-official" }
    "python" { Install-Plugin -Name "pyright-lsp" -Registry "claude-plugins-official" }
    "rust" { Install-Plugin -Name "rust-analyzer-lsp" -Registry "claude-plugins-official" }
    "go" { Install-Plugin -Name "gopls-lsp" -Registry "claude-plugins-official" }
    "code-review" { Install-Plugin -Name "code-review" -Registry "claude-plugins-official" }
    "frontend" { Install-Plugin -Name "frontend-design" -Registry "claude-plugins-official" }
    "github" { Install-Plugin -Name "github" -Registry "claude-plugins-official" }
    "all" {
        Write-Host "Installing ALL Claude Code plugins..." -ForegroundColor Green
        Write-Host ""
        Write-Host "=== Official Anthropic (7 plugins) ===" -ForegroundColor Cyan
        foreach ($p in $officialPlugins) { Install-Plugin -Name $p -Registry "claude-plugins-official" }
        Write-Host ""
        Write-Host "=== GTM Agents (9 plugins, 36 skills) ===" -ForegroundColor Cyan
        foreach ($p in $gtmPlugins) { Install-Plugin -Name $p -Registry "gtm-agents" }
        Write-Host ""
        Write-Host "NOTE: Cowork-only plugins (9 total) must be installed via Desktop app." -ForegroundColor Yellow
        Write-Host "Run: .\smorch-install-plugins.ps1 -Mode list-cowork" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Done! Restart Claude Code to activate new plugins." -ForegroundColor Green
