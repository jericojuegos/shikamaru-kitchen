<#
.SYNOPSIS
  Syncs the shikamaru-kitchen Michelin Brigade Engine (core + stack pack) into a target project.
  Supports `nextjs-supabase`, `python-fastapi`, and `wp-modular-oop`.

.EXAMPLE
  .\scripts\sync-kitchen.ps1 -ProjectPath "..\my-crafted-app" -Stack "nextjs-supabase"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [Parameter(Mandatory = $false)]
    [string]$Stack = "nextjs-supabase",

    [switch]$LocalExclude
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$CoreDir  = Join-Path $RepoRoot "core"

if (-not (Test-Path $ProjectPath)) {
    New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
}
$TargetRoot  = (Resolve-Path $ProjectPath).Path
$ProjectName = Split-Path -Leaf $TargetRoot
$Today       = Get-Date -Format "yyyy-MM-dd"

$StackList    = @($Stack -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
$PrimaryStack = $StackList[0]
$PrimaryDir   = Join-Path $RepoRoot "stacks\$PrimaryStack"

foreach ($S in $StackList) {
    $SDir = Join-Path $RepoRoot "stacks\$S"
    if (-not (Test-Path $SDir)) {
        Write-Error "Stack '$S' not found in stacks/."
        exit 1
    }
}

$VersionTag = ($StackList -join "+") + "-kitchen-v1.0"
Write-Host ""
Write-Host "[MICHELIN KITCHEN] Brigade Sync ($VersionTag)" -ForegroundColor Cyan
Write-Host "   Target Project : $TargetRoot"
Write-Host "   Stack Pack(s)  : $($StackList -join ', ')"

$AgentsDir = Join-Path $TargetRoot ".agents"
$DocsDir   = Join-Path $TargetRoot "docs"

$CookExamplesDir = Join-Path $AgentsDir "skills\cook\examples"
if (Test-Path $CookExamplesDir) {
    Remove-Item $CookExamplesDir -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Force -Path `
    (Join-Path $AgentsDir "rules"), `
    (Join-Path $AgentsDir "skills"), `
    (Join-Path $DocsDir "foundation\design-reference"), `
    (Join-Path $DocsDir "planning"), `
    (Join-Path $DocsDir "dishes") | Out-Null

# 1. Copy Core Rules & Culinary Skills -> .agents/{rules,skills}
Copy-Item -Path (Join-Path $CoreDir "rules\*") -Destination (Join-Path $AgentsDir "rules\") -Recurse -Force
Copy-Item -Path (Join-Path $CoreDir "skills\*") -Destination (Join-Path $AgentsDir "skills\") -Recurse -Force

# 2. Copy Stack Rules & Golden Recipe Examples -> .agents/
for ($idx = 0; $idx -lt $StackList.Count; $idx++) {
    $S = $StackList[$idx]
    $SDir = Join-Path $RepoRoot "stacks\$S"
    if ($idx -eq 0) {
        Copy-Item -Path (Join-Path $SDir "rules\*") -Destination (Join-Path $AgentsDir "rules\") -Recurse -Force
    } else {
        $TargetStackRule = Join-Path $AgentsDir "rules\stack-rules.md"
        $AddRule = Join-Path $SDir "rules\stack-rules.md"
        if ((Test-Path $TargetStackRule) -and (Test-Path $AddRule)) {
            $RawAdd = [System.IO.File]::ReadAllText($AddRule, [System.Text.Encoding]::UTF8)
            $StrippedAdd = $RawAdd -replace '(?s)^---\r?\n.*?\r?\n---\r?\n*', ''
            [System.IO.File]::AppendAllText($TargetStackRule, "`r`n`r`n---`r`n`r`n" + $StrippedAdd, [System.Text.Encoding]::UTF8)
        }
    }
    if (Test-Path (Join-Path $SDir "skills\*")) {
        Copy-Item -Path (Join-Path $SDir "skills\*") -Destination (Join-Path $AgentsDir "skills\") -Recurse -Force
    }
}

# 3. Initialize Root AGENTS.md, CLAUDE.md, docs/INDEX.md, and docs/planning/issues.md
$RootAgentsMd = Join-Path $TargetRoot "AGENTS.md"
if (-not (Test-Path $RootAgentsMd)) {
    $Tpl = [System.IO.File]::ReadAllText((Join-Path $PrimaryDir "AGENTS.md.template"), [System.Text.Encoding]::UTF8)
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
Write-Host "[DONE] Kitchen Sync Complete! Run /menu -> /prep -> /taste -> /cook -> /plate" -ForegroundColor Cyan
