<#
.SYNOPSIS
  Syncs the universal, stack-agnostic shikamaru-kitchen Michelin Brigade Engine into a target project.
  No hardcoded stack pack argument needed — /menu and /prep auto-detect/design the stack, tailor stack-rules.md (<= 80 lines),
  and dynamically generate the 0-Token Mechanical Architecture Linter for any language or framework!

.EXAMPLE
  .\scripts\sync-kitchen.ps1 -ProjectPath "..\my-crafted-app"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [switch]$LocalExclude
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$CoreDir  = Join-Path $RepoRoot ".agents"

if (-not (Test-Path $ProjectPath)) {
    New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
}
$TargetRoot  = (Resolve-Path $ProjectPath).Path
$ProjectName = Split-Path -Leaf $TargetRoot
$Today       = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "[MICHELIN KITCHEN] Universal Brigade Sync (v1.0)" -ForegroundColor Cyan
Write-Host "   Target Project : $TargetRoot"

$AgentsDir = Join-Path $TargetRoot ".agents"
$DocsDir   = Join-Path $TargetRoot "docs"

New-Item -ItemType Directory -Force -Path `
    (Join-Path $AgentsDir "rules"), `
    (Join-Path $AgentsDir "skills"), `
    (Join-Path $DocsDir "foundation\design-reference"), `
    (Join-Path $DocsDir "planning"), `
    (Join-Path $DocsDir "specs") | Out-Null

# 1. Copy Core Rules & 5 Craft Skills -> .agents/{rules,skills}
Copy-Item -Path (Join-Path $CoreDir "rules\*") -Destination (Join-Path $AgentsDir "rules\") -Recurse -Force
Copy-Item -Path (Join-Path $CoreDir "skills\*") -Destination (Join-Path $AgentsDir "skills\") -Recurse -Force

# 2. Initialize starter .agents/rules/stack-rules.md (if missing — /design tailors it to <= 80 lines for any stack)
$StackRulesMd = Join-Path $AgentsDir "rules\stack-rules.md"
if (-not (Test-Path $StackRulesMd)) {
    Copy-Item (Join-Path $CoreDir "templates\stack-rules.md.template") $StackRulesMd -Force
    Write-Host "[OK] Created starter .agents/rules/stack-rules.md (<= 80 lines)" -ForegroundColor Green
}

# 3. Initialize Root AGENTS.md, CLAUDE.md, docs/INDEX.md, and docs/planning/issues.md
$RootAgentsMd = Join-Path $TargetRoot "AGENTS.md"
if (-not (Test-Path $RootAgentsMd)) {
    $Tpl = [System.IO.File]::ReadAllText((Join-Path $CoreDir "templates\AGENTS.md.template"), [System.Text.Encoding]::UTF8)
    $Tpl = $Tpl -replace '\[PROJECT NAME\]', $ProjectName -replace '\[Project Name\]', $ProjectName -replace 'YYYY-MM-DD', $Today
    [System.IO.File]::WriteAllText($RootAgentsMd, $Tpl, [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Created root AGENTS.md" -ForegroundColor Green
}

$RootClaudeMd = Join-Path $TargetRoot "CLAUDE.md"
if (-not (Test-Path $RootClaudeMd)) {
    Copy-Item (Join-Path $CoreDir "templates\CLAUDE.md.template") $RootClaudeMd -Force
    Write-Host "[OK] Created root CLAUDE.md" -ForegroundColor Green
}

$DocsIndexMd = Join-Path $DocsDir "INDEX.md"
if (-not (Test-Path $DocsIndexMd)) {
    Copy-Item (Join-Path $CoreDir "templates\INDEX.md.template") $DocsIndexMd -Force
    Write-Host "[OK] Created docs/INDEX.md" -ForegroundColor Green
}

$IssuesMd = Join-Path $DocsDir "planning\issues.md"
if (-not (Test-Path $IssuesMd)) {
    Copy-Item (Join-Path $CoreDir "templates\issues.md.template") $IssuesMd -Force
    Write-Host "[OK] Created docs/planning/issues.md" -ForegroundColor Green
}

if ($LocalExclude) {
    $GitDir = Join-Path $TargetRoot ".git"
    if (-not (Test-Path $GitDir)) {
        Push-Location $TargetRoot
        try { git init --quiet 2>$null } finally { Pop-Location }
    }
    $ExcludeFile = Join-Path $GitDir "info\exclude"
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ExcludeFile) | Out-Null
    $Existing = if (Test-Path $ExcludeFile) { [System.IO.File]::ReadAllText($ExcludeFile, [System.Text.Encoding]::UTF8) } else { "" }
    foreach ($E in @("AGENTS.md", "CLAUDE.md", ".agents/", "docs/")) {
        if ($Existing -notmatch [regex]::Escape($E)) {
            $Existing += "`r`n$E"
        }
    }
    [System.IO.File]::WriteAllText($ExcludeFile, $Existing.Trim() + "`r`n", [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Added stealth exclusions to .git/info/exclude" -ForegroundColor Green
}

Write-Host ""
Write-Host "[DONE] Universal Kitchen Sync Complete! Run /design -> /scaffold -> /prototype -> /craft -> /polish" -ForegroundColor Cyan
