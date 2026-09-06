<#
.SYNOPSIS
    Deterministic Static Linter for AI Agent Harness Configurations.
.DESCRIPTION
    Statically audits the repository's harness assets (skills, agents, hooks, rules)
    to detect structural defects, schema violations, context bloat (>300 lines),
    and dangling local file references in a 100% deterministic manner.
.PARAMETER OutputFormat
    'Text' (default) or 'Json'
.PARAMETER LineLimit
    Max recommended lines for instruction/rule files before flagging cognitive bloat (default: 300).
#>
[CmdletBinding()]
param (
    [ValidateSet('Text', 'Json')]
    [string]$OutputFormat = 'Text',

    [int]$LineLimit = 300
)

$ErrorActionPreference = 'Stop'
$rootDir = (Get-Item -Path "$PSScriptRoot\..\..\..").FullName

$issues = [System.Collections.Generic.List[PSCustomObject]]::new()

function Add-Issue {
    param(
        [string]$Category,
        [string]$Severity, # Error, Warning
        [string]$FilePath,
        [string]$Message,
        [string]$RuleId
    )
    $relPath = $FilePath.Replace($rootDir, "").TrimStart('\', '/')
    $issues.Add([PSCustomObject]@{
        RuleId   = $RuleId
        Category = $Category
        Severity = $Severity
        File     = $relPath
        Message  = $Message
    })
}

# 1. Inspect Skills (skills/*/SKILL.md)
$skillDirs = Get-ChildItem -Path (Join-Path $rootDir "skills") -Directory -ErrorAction SilentlyContinue
foreach ($dir in $skillDirs) {
    $skillMd = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skillMd)) {
        Add-Issue -Category "Skill" -Severity "Error" -FilePath $dir.FullName -Message "Missing SKILL.md in skill directory $($dir.Name)" -RuleId "SKILL_MD_MISSING"
        continue
    }

    $lines = Get-Content $skillMd -Encoding UTF8
    if ($lines.Count -gt $LineLimit) {
        Add-Issue -Category "Skill" -Severity "Warning" -FilePath $skillMd -Message "File length ($($lines.Count) lines) exceeds recommended $LineLimit line limit (cognitive bloat risk)" -RuleId "CONTEXT_BLOAT"
    }

    # Frontmatter check
    $content = $lines -join "`n"
    if ($content -match "(?s)^---\s*\r?\n(.*?)\r?\n---") {
        $frontmatter = $Matches[1]
        if ($frontmatter -notmatch "(?m)^name:\s*\S+") {
            Add-Issue -Category "Skill" -Severity "Error" -FilePath $skillMd -Message "Missing 'name' in YAML frontmatter" -RuleId "SKILL_FRONTMATTER_NAME"
        }
        if ($frontmatter -notmatch "(?m)^description:\s*\S+") {
            Add-Issue -Category "Skill" -Severity "Error" -FilePath $skillMd -Message "Missing 'description' in YAML frontmatter" -RuleId "SKILL_FRONTMATTER_DESC"
        }
    } else {
        Add-Issue -Category "Skill" -Severity "Error" -FilePath $skillMd -Message "Missing YAML frontmatter delimiters (---)" -RuleId "SKILL_FRONTMATTER_MISSING"
    }
}

# 2. Inspect Agents (agents/*.md)
$agentFiles = Get-ChildItem -Path (Join-Path $rootDir "agents") -Filter "*.md" -File -ErrorAction SilentlyContinue
foreach ($agent in $agentFiles) {
    $lines = Get-Content $agent.FullName -Encoding UTF8
    if ($lines.Count -gt $LineLimit) {
        Add-Issue -Category "Agent" -Severity "Warning" -FilePath $agent.FullName -Message "File length ($($lines.Count) lines) exceeds recommended $LineLimit line limit" -RuleId "CONTEXT_BLOAT"
    }

    $content = $lines -join "`n"
    if ($content -match "(?s)^---\s*\r?\n(.*?)\r?\n---") {
        $frontmatter = $Matches[1]
        if ($frontmatter -notmatch "(?m)^name:\s*\S+") {
            Add-Issue -Category "Agent" -Severity "Error" -FilePath $agent.FullName -Message "Missing 'name' in YAML frontmatter" -RuleId "AGENT_FRONTMATTER_NAME"
        }
        if ($frontmatter -notmatch "(?m)^description:\s*\S+") {
            Add-Issue -Category "Agent" -Severity "Error" -FilePath $agent.FullName -Message "Missing 'description' in YAML frontmatter" -RuleId "AGENT_FRONTMATTER_DESC"
        }
    } else {
        Add-Issue -Category "Agent" -Severity "Error" -FilePath $agent.FullName -Message "Missing YAML frontmatter delimiters (---)" -RuleId "AGENT_FRONTMATTER_MISSING"
    }
}

# 3. Inspect Lifecycle Hooks (hooks/hooks.json)
$hooksJsonPath = Join-Path $rootDir "hooks\hooks.json"
if (Test-Path $hooksJsonPath) {
    try {
        $rawHooks = Get-Content $hooksJsonPath -Raw -Encoding UTF8
        $hooksObj = $rawHooks | ConvertFrom-Json
        
        # Check PreToolUse / PostToolUse hook commands
        $hookTypes = @("PreToolUse", "PostToolUse")
        foreach ($ht in $hookTypes) {
            if ($hooksObj.PSObject.Properties[$ht]) {
                foreach ($entry in $hooksObj.$ht) {
                    $cmd = $entry.command
                    # Extract script paths like ./hooks/pre-commit.ps1 or ./hooks/pre-commit.sh
                    $matches = [regex]::Matches($cmd, "(\./hooks/[a-zA-Z0-9\._\-]+)")
                    foreach ($m in $matches) {
                        $scriptRel = $m.Groups[1].Value.Replace('/', '\')
                        $scriptFull = Join-Path $rootDir $scriptRel.TrimStart('.\')
                        if (-not (Test-Path $scriptFull)) {
                            Add-Issue -Category "Hook" -Severity "Error" -FilePath $hooksJsonPath -Message "Referenced hook script does not exist: $scriptRel" -RuleId "HOOK_SCRIPT_NOT_FOUND"
                        }
                    }
                }
            }
        }
    } catch {
        Add-Issue -Category "Hook" -Severity "Error" -FilePath $hooksJsonPath -Message "Invalid JSON syntax in hooks.json: $($_.Exception.Message)" -RuleId "HOOKS_JSON_SYNTAX"
    }
}

# 4. Check Local Markdown Link Integrity (Dangling References in skills/ and agents/)
$docFiles = Get-ChildItem -Path (Join-Path $rootDir "skills"), (Join-Path $rootDir "agents") -Filter "*.md" -Recurse -File -ErrorAction SilentlyContinue
$invalidChars = [System.IO.Path]::GetInvalidPathChars()
foreach ($doc in $docFiles) {
    $docContent = Get-Content $doc.FullName -Raw -Encoding UTF8
    # Match markdown links: [text](path) excluding web schemes, anchors, and file protocols
    $linkMatches = [regex]::Matches($docContent, '\[([^\]]+)\]\((?!https?:\/\/|mailto:|file:\/\/|#|[a-zA-Z]+:)([^)]+)\)')
    foreach ($lm in $linkMatches) {
        $linkTarget = $lm.Groups[2].Value.Split('#')[0].Trim()
        if (-not [string]::IsNullOrWhiteSpace($linkTarget)) {
            # Skip if target contains illegal characters
            if ($linkTarget.IndexOfAny($invalidChars) -ge 0 -or $linkTarget -match '[\*\?"<>\|]') {
                continue
            }
            try {
                $targetFull = $null
                if ([System.IO.Path]::IsPathRooted($linkTarget)) {
                    $targetFull = $linkTarget
                } else {
                    $docDir = Split-Path $doc.FullName -Parent
                    $targetFull = [System.IO.Path]::GetFullPath((Join-Path $docDir $linkTarget))
                }
                if (-not (Test-Path $targetFull)) {
                    Add-Issue -Category "Link" -Severity "Warning" -FilePath $doc.FullName -Message "Dangling local link target not found: $linkTarget" -RuleId "DANGLING_LINK_REF"
                }
            } catch {
                # Ignore invalid path conversions for complex markdown expressions
            }
        }
    }
}

# Output Results
$errorCount = @($issues | Where-Object { $_.Severity -eq 'Error' }).Count
$warningCount = @($issues | Where-Object { $_.Severity -eq 'Warning' }).Count

if ($OutputFormat -eq 'Json') {
    $output = [PSCustomObject]@{
        Timestamp    = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
        TotalIssues  = $issues.Count
        Errors       = $errorCount
        Warnings     = $warningCount
        HealthScore  = [Math]::Max(0, 100 - ($errorCount * 15 + $warningCount * 3))
        Issues       = $issues
    }
    $output | ConvertTo-Json -Depth 5
} else {
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  Harness Static Linter (Deterministic Audit)    " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "Scanned Root: $rootDir" -ForegroundColor DarkGray
    $summaryColor = if ($errorCount -gt 0) { 'Red' } elseif ($warningCount -gt 0) { 'Yellow' } else { 'Green' }
    Write-Host "Total Issues: $($issues.Count) (Errors: $errorCount, Warnings: $warningCount)" -ForegroundColor $summaryColor
    
    $healthScore = [Math]::Max(0, 100 - ($errorCount * 15 + $warningCount * 3))
    $healthColor = if ($healthScore -ge 90) { 'Green' } elseif ($healthScore -ge 70) { 'Yellow' } else { 'Red' }
    Write-Host "Harness Static Health Score: $healthScore / 100`n" -ForegroundColor $healthColor

    foreach ($issue in $issues) {
        $color = if ($issue.Severity -eq 'Error') { 'Red' } else { 'Yellow' }
        Write-Host "[$($issue.Severity.ToUpper())] $($issue.RuleId) - $($issue.File)" -ForegroundColor $color
        Write-Host "  $($issue.Message)" -ForegroundColor DarkGray
    }
    Write-Host "==================================================" -ForegroundColor Cyan
}

if ($errorCount -gt 0) {
    exit 1
} else {
    exit 0
}
