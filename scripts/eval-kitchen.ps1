<#
.SYNOPSIS
  Shikamaru-Kitchen Michelin Brigade Eval Suite (eval-kitchen.ps1)
  Validates Master Kitchen contracts across 5 automated evaluation suites:
    Suite 1: Core Kitchen Protocol & 5 Culinary Lifecycle Skills (/menu, /prep, /taste, /cook, /plate)
    Suite 2: Stack Pack Structural, <= 80-Line Rule Cap & 0-Token Mechanical Architecture Linters
    Suite 3: Tasting Spoon 4-State Prototype & Recipe Templates
    Suite 4: INVENTORY.md Single Source of Truth Integrity
    Suite 5: End-to-End sync-kitchen Smoke Eval (isolated temp project assembly + cleanup)
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
Write-Host " SHIKAMARU-KITCHEN MICHELIN BRIGADE EVAL SUITE (v1.0)" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# ==============================================================================
# SUITE 1: Core Kitchen Protocol & 5 Culinary Lifecycle Skills
# ==============================================================================
Write-Host "`n[Suite 1] Core Kitchen Protocol & 5 Culinary Lifecycle Skills" -ForegroundColor Yellow

$ProtocolPath = Join-Path $RepoRoot "core\rules\kitchen-protocol.md"
Assert-Eval "Suite 1" "core/rules/kitchen-protocol.md exists" (Test-Path $ProtocolPath)
if (Test-Path $ProtocolPath) {
    $Proto = Get-Content $ProtocolPath -Raw
    Assert-Eval "Suite 1" "kitchen-protocol.md has YAML frontmatter" ($Proto -match "(?s)^---\r?\n.*?\r?\n---")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines Signature Dish vs House Staple triage" (
        ($Proto -match "SIGNATURE DISH") -and ($Proto -match "HOUSE STAPLE")
    )
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 3-Course Cooking Loop" ($Proto -match "3-Course Cooking Loop")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 4-Star Culinary Craft Standard" ($Proto -match "4-Star Culinary Craft")
    Assert-Eval "Suite 1" "kitchen-protocol.md defines 3-Strike Rule & Automatic Self-Healing" (
        ($Proto -match "3-Strike Rule") -and ($Proto -match "Automatic Kitchen Self-Healing")
    )
}

foreach ($Skill in @("menu", "prep", "taste", "cook", "plate")) {
    $SkillPath = Join-Path $RepoRoot "core\skills\$Skill\SKILL.md"
    Assert-Eval "Suite 1" "core/skills/$Skill/SKILL.md exists" (Test-Path $SkillPath)
    if (Test-Path $SkillPath) {
        $Sc = Get-Content $SkillPath -Raw
        Assert-Eval "Suite 1" "core/skills/$Skill/SKILL.md has valid name & description frontmatter" (
            ($Sc -match "(?m)^name:\s*$Skill\s*$") -and ($Sc -match "(?m)^description:")
        )
    }
}

$PlateContent = Get-Content (Join-Path $RepoRoot "core\skills\plate\SKILL.md") -Raw
Assert-Eval "Suite 1" "core/skills/plate/SKILL.md enforces Mandatory evidence/*.png Hard Gate & 4-Star Craft Audit" (
    ($PlateContent -match "Hard Gate.*Mandatory.*evidence/\*\.png") -and ($PlateContent -match "4-Star Culinary Craft Audit")
)

# ==============================================================================
# SUITE 2: Stack Pack Structural, <= 80-Line Rule Cap & Mechanical Linters
# ==============================================================================
Write-Host "`n[Suite 2] Stack Pack Structural, <= 80-Line Rule Cap & Mechanical Linters" -ForegroundColor Yellow

$StackDirs = Get-ChildItem (Join-Path $RepoRoot "stacks") -Directory
Assert-Eval "Suite 2" "At least 3 public stack packs exist in stacks/" ($StackDirs.Count -ge 3)

foreach ($StackDir in $StackDirs) {
    $SName = $StackDir.Name
    $AgentsTpl = Join-Path $StackDir.FullName "AGENTS.md.template"
    $StackRules = Join-Path $StackDir.FullName "rules\stack-rules.md"

    Assert-Eval "Suite 2" "stacks/$SName/AGENTS.md.template exists" (Test-Path $AgentsTpl)
    Assert-Eval "Suite 2" "stacks/$SName/rules/stack-rules.md exists" (Test-Path $StackRules)

    if (Test-Path $StackRules) {
        $LineCount = (Get-Content $StackRules).Count
        Assert-Eval "Suite 2" "stacks/$SName/rules/stack-rules.md is ultra-lean (<= 80 lines: $LineCount)" ($LineCount -le 80)
    }
}

Assert-Eval "Suite 2" "nextjs-supabase has 0-token Mechanical Architecture Linter (architecture.test.ts.template)" (
    Test-Path (Join-Path $RepoRoot "stacks\nextjs-supabase\skills\cook\examples\architecture.test.ts.template")
)
Assert-Eval "Suite 2" "python-fastapi has 0-token Mechanical Architecture Linter (test_architecture.py.template)" (
    Test-Path (Join-Path $RepoRoot "stacks\python-fastapi\skills\cook\examples\test_architecture.py.template")
)
Assert-Eval "Suite 2" "wp-hexagonal has 0-token Mechanical Architecture Linter (HexagonalArchitectureTest.php.template)" (
    Test-Path (Join-Path $RepoRoot "stacks\wp-hexagonal\skills\cook\examples\HexagonalArchitectureTest.php.template")
)

# ==============================================================================
# SUITE 3: Tasting Spoon 4-State Prototype & Recipe Templates
# ==============================================================================
Write-Host "`n[Suite 3] Tasting Spoon 4-State Prototype & Recipe Templates" -ForegroundColor Yellow

foreach ($Tpl in @("recipe.md.template", "design.md.template", "courses.md.template", "plating.md.template", "preview.html.template")) {
    $TplPath = Join-Path $RepoRoot "core\skills\taste\resources\$Tpl"
    Assert-Eval "Suite 3" "taste resource $Tpl exists" (Test-Path $TplPath)
}

$PreviewContent = Get-Content (Join-Path $RepoRoot "core\skills\taste\resources\preview.html.template") -Raw
Assert-Eval "Suite 3" "preview.html.template includes all 4 interactive Tasting Spoon states (happy, empty, loading, error)" (
    ($PreviewContent -match "state-happy") -and
    ($PreviewContent -match "state-empty") -and
    ($PreviewContent -match "state-loading") -and
    ($PreviewContent -match "state-error")
)

# ==============================================================================
# SUITE 4: INVENTORY.md Single Source of Truth Integrity
# ==============================================================================
Write-Host "`n[Suite 4] INVENTORY.md Single Source of Truth Integrity" -ForegroundColor Yellow

$InvPath = Join-Path $RepoRoot "INVENTORY.md"
Assert-Eval "Suite 4" "INVENTORY.md exists" (Test-Path $InvPath)
if (Test-Path $InvPath) {
    $InvContent = Get-Content $InvPath -Raw
    foreach ($StackDir in $StackDirs) {
        $SName = $StackDir.Name
        Assert-Eval "Suite 4" "INVENTORY.md catalogs stack '$SName'" ($InvContent -match [regex]::Escape("stacks/$SName/"))
    }
    Assert-Eval "Suite 4" "Zero private/company leaks in public INVENTORY.md" (
        -not ($InvContent -match "tangible")
    )
}

# ==============================================================================
# SUITE 5: End-to-End sync-kitchen Smoke Eval
# ==============================================================================
Write-Host "`n[Suite 5] End-to-End sync-kitchen Smoke Eval" -ForegroundColor Yellow

$TempProject = Join-Path ([System.IO.Path]::GetTempPath()) ("shikamaru-kitchen-eval-" + [System.Guid]::NewGuid().ToString("N").Substring(0, 8))
try {
    $SyncScript = Join-Path $RepoRoot "scripts\sync-kitchen.ps1"
    & $SyncScript -ProjectPath $TempProject -Stack "nextjs-supabase" -LocalExclude | Out-Null

    Assert-Eval "Suite 5" "sync-kitchen creates root AGENTS.md & CLAUDE.md" (
        (Test-Path (Join-Path $TempProject "AGENTS.md")) -and (Test-Path (Join-Path $TempProject "CLAUDE.md"))
    )
    Assert-Eval "Suite 5" "sync-kitchen creates docs/INDEX.md & docs/dishes/" (
        (Test-Path (Join-Path $TempProject "docs\INDEX.md")) -and (Test-Path (Join-Path $TempProject "docs\dishes"))
    )
    Assert-Eval "Suite 5" "sync-kitchen syncs .agents/rules/kitchen-protocol.md & stack-rules.md" (
        (Test-Path (Join-Path $TempProject ".agents\rules\kitchen-protocol.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\rules\stack-rules.md"))
    )
    Assert-Eval "Suite 5" "sync-kitchen syncs all 5 culinary skills (/menu, /prep, /taste, /cook, /plate)" (
        (Test-Path (Join-Path $TempProject ".agents\skills\menu\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\prep\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\taste\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\cook\SKILL.md")) -and
        (Test-Path (Join-Path $TempProject ".agents\skills\plate\SKILL.md"))
    )
    Assert-Eval "Suite 5" "sync-kitchen injects 0-token Mechanical Architecture Linter into .agents/skills/cook/examples/" (
        Test-Path (Join-Path $TempProject ".agents\skills\cook\examples\architecture.test.ts.template")
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
