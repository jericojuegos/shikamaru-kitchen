<#
.SYNOPSIS
  Shikamaru-Kitchen Universal Software Craft Eval Suite (eval-kitchen.ps1)
  Validates Universal Michelin-Grade Software Craft contracts across 4 automated evaluation suites:
    Suite 1: Core Craft Protocol & 5 Lifecycle Skills (/design, /scaffold, /prototype, /craft, /polish)
    Suite 2: Universal Stack-Agnostic Templates (<= 80-Line stack-rules.md.template & <= 100-Line spec.md.template)
    Suite 3: Interactive 4-State UI Prototype & Dynamic Mechanical Linter Contract
    Suite 4: End-to-End sync-kitchen Smoke Eval (isolated temp project assembly + cleanup)
#>

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

$TotalChecks = 0
$PassedChecks = 0
$FailedChecks = 0
$Failures = @()

function Assert-Eval {
    param(
        [string]$Suite,
        [string]$Name,
        [bool]$Condition,
        [string]$Detail = ""
    )
    $script:TotalChecks++
    if ($Condition) {
        $script:PassedChecks++
        Write-Host "  [PASS] $Name" -ForegroundColor Green
    } else {
        $script:FailedChecks++
        $Msg = "[$Suite] $Name" + $(if ($Detail) { " -> $Detail" } else { "" })
        $script:Failures += $Msg
        Write-Host "  [FAIL] $Name $(if ($Detail) { "($Detail)" })" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host " SHIKAMARU-KITCHEN UNIVERSAL SOFTWARE CRAFT EVAL SUITE (v1.0)" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# ==============================================================================
# SUITE 1: Core Craft Protocol & 5 Lifecycle Skills
# ==============================================================================
Write-Host "`n[Suite 1] Core Craft Protocol & 5 Software Craft Lifecycle Skills" -ForegroundColor Yellow

$ProtocolPath = Join-Path $RepoRoot ".agents\rules\kitchen-protocol.md"
Assert-Eval "Suite 1" ".agents/rules/kitchen-protocol.md exists" (Test-Path $ProtocolPath)
if (Test-Path $ProtocolPath) {
    $Proto = Get-Content $ProtocolPath -Raw
    Assert-Eval "Suite 1" "kitchen-protocol.md has YAML frontmatter" ($Proto -match "(?s)^---\r?\n.*?\r?\n---")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines Signature Craft vs Plumbing triage" (
        ($Proto -match "SIGNATURE CRAFT") -and ($Proto -match "PLUMBING")
    )
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 3-Pass Implementation Loop" ($Proto -match "3-Pass Implementation Loop")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 4-Point UX & Code Craft Audit" ($Proto -match "4-Point UX & Code Craft Audit")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 3-Strike Rule & Automatic Self-Healing" (
        ($Proto -match "3-Strike Rule") -and ($Proto -match "Automatic Self-Healing")
    )
}

foreach ($Skill in @("design", "scaffold", "prototype", "craft", "polish")) {
    $SkillPath = Join-Path $RepoRoot ".agents\skills\$Skill\SKILL.md"
    Assert-Eval "Suite 1" ".agents/skills/$Skill/SKILL.md exists" (Test-Path $SkillPath)
    if (Test-Path $SkillPath) {
        $Sc = Get-Content $SkillPath -Raw
        Assert-Eval "Suite 1" ".agents/skills/$Skill/SKILL.md has valid name & description frontmatter" (
            ($Sc -match "(?m)^name:\s*$Skill\s*$") -and ($Sc -match "(?m)^description:")
        )
    }
}

# ==============================================================================
# SUITE 2: Universal Stack-Agnostic Templates (<= 80-Line & <= 100-Line Caps)
# ==============================================================================
Write-Host "`n[Suite 2] Universal Stack-Agnostic Templates" -ForegroundColor Yellow

Assert-Eval "Suite 2" "No hardcoded stacks/ directory exists (100% Universal Stack-Agnostic)" (
    -not (Test-Path (Join-Path $RepoRoot "stacks"))
)

$StackRulesTpl = Join-Path $RepoRoot ".agents\templates\stack-rules.md.template"
Assert-Eval "Suite 2" ".agents/templates/stack-rules.md.template exists" (Test-Path $StackRulesTpl)
if (Test-Path $StackRulesTpl) {
    $RuleLines = (Get-Content $StackRulesTpl).Count
    Assert-Eval "Suite 2" "stack-rules.md.template is ultra-lean (<= 80 lines: $RuleLines)" ($RuleLines -le 80)
}

foreach ($Tpl in @("spec.md.template", "preview.html.template")) {
    $TplPath = Join-Path $RepoRoot ".agents\skills\prototype\resources\$Tpl"
    Assert-Eval "Suite 2" "prototype resource $Tpl exists" (Test-Path $TplPath)
}

$SpecLines = (Get-Content (Join-Path $RepoRoot ".agents\skills\prototype\resources\spec.md.template")).Count
Assert-Eval "Suite 2" "unified spec.md.template is ultra-lean (<= 100 lines: $SpecLines)" ($SpecLines -le 100)

# ==============================================================================
# SUITE 3: 4-State UI Prototype & Dynamic Mechanical Linter Contract
# ==============================================================================
Write-Host "`n[Suite 3] 4-State UI Prototype & Dynamic Mechanical Linter Contract" -ForegroundColor Yellow

$PreviewContent = Get-Content (Join-Path $RepoRoot ".agents\skills\prototype\resources\preview.html.template") -Raw
Assert-Eval "Suite 3" "preview.html.template includes all 4 interactive UI states (happy, empty, loading, error)" (
    ($PreviewContent -match "state-happy") -and
    ($PreviewContent -match "state-empty") -and
    ($PreviewContent -match "state-loading") -and
    ($PreviewContent -match "state-error")
)

$DesignContent = Get-Content (Join-Path $RepoRoot ".agents\skills\design\SKILL.md") -Raw
Assert-Eval "Suite 3" ".agents/skills/design/SKILL.md auto-discovers stack and tailors stack-rules.md (<= 80 lines)" (
    $DesignContent -match "stack-rules\.md"
)

$ScaffoldContent = Get-Content (Join-Path $RepoRoot ".agents\skills\scaffold\SKILL.md") -Raw
Assert-Eval "Suite 3" ".agents/skills/scaffold/SKILL.md dynamically generates 0-Token Mechanical Architecture Linter" (
    $ScaffoldContent -match "Dynamically Generate.*0-Token Mechanical Architecture Linter"
)

$PolishContent = Get-Content (Join-Path $RepoRoot ".agents\skills\polish\SKILL.md") -Raw
Assert-Eval "Suite 3" ".agents/skills/polish/SKILL.md enforces Mandatory evidence/*.png Hard Gate & 4-Point Craft Audit" (
    ($PolishContent -match "Hard Gate.*Mandatory.*evidence/\*\.png") -and ($PolishContent -match "4-Point UX & Code Craft Audit")
)
Assert-Eval "Suite 3" ".agents/skills/polish/SKILL.md defaults to Remote PR creation (gh pr create) with optional --local review" (
    ($PolishContent -match "gh pr create") -and ($PolishContent -match "--local")
)
Assert-Eval "Suite 3" ".agents/scripts/remote-notify.mjs 2-way mobile reply bridge exists" (
    Test-Path (Join-Path $RepoRoot ".agents\scripts\remote-notify.mjs")
)

# ==============================================================================
# SUITE 4: End-to-End sync-kitchen Smoke Eval
# ==============================================================================
Write-Host "`n[Suite 4] End-to-End sync-kitchen Smoke Eval" -ForegroundColor Yellow

$TempProject = Join-Path ([System.IO.Path]::GetTempPath()) ("shikamaru-kitchen-eval-" + [System.Guid]::NewGuid().ToString("N").Substring(0, 8))
try {
    $SyncScript = Join-Path $RepoRoot "scripts\sync-kitchen.ps1"
    & $SyncScript -ProjectPath $TempProject -LocalExclude | Out-Null

    Assert-Eval "Suite 4" "sync-kitchen creates root AGENTS.md & CLAUDE.md" (
        (Test-Path (Join-Path $TempProject "AGENTS.md")) -and (Test-Path (Join-Path $TempProject "CLAUDE.md"))
    )
    Assert-Eval "Suite 4" "sync-kitchen creates docs/INDEX.md & docs/specs/" (
        (Test-Path (Join-Path $TempProject "docs\INDEX.md")) -and (Test-Path (Join-Path $TempProject "docs\specs"))
    )
    Assert-Eval "Suite 4" "sync-kitchen syncs .agents/rules/kitchen-protocol.md & starter stack-rules.md" (
        (Test-Path (Join-Path $TempProject ".agents\rules\kitchen-protocol.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\rules\stack-rules.md"))
    )
    Assert-Eval "Suite 4" "sync-kitchen syncs all 5 software craft skills (/design, /scaffold, /prototype, /craft, /polish)" (
        (Test-Path (Join-Path $TempProject ".agents\skills\design\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\scaffold\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\prototype\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\craft\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\polish\SKILL.md"))
    )
} finally {
    if (Test-Path $TempProject) {
        Remove-Item $TempProject -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`n==================================================================" -ForegroundColor Cyan
if ($FailedChecks -eq 0) {
    Write-Host " KITCHEN EVAL RESULT: PASS ($PassedChecks / $TotalChecks checks passed)" -ForegroundColor Green
    Write-Host "==================================================================`n" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host " KITCHEN EVAL RESULT: FAIL ($PassedChecks / $TotalChecks passed, $FailedChecks failed)" -ForegroundColor Red
    foreach ($F in $Failures) {
        Write-Host "   - $F" -ForegroundColor Red
    }
    Write-Host "==================================================================`n" -ForegroundColor Cyan
    exit 1
}
