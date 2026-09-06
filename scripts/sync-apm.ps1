<#
.SYNOPSIS
Syncs and validates assets from Master (Claude Plugin / Root Standard) to .apm/ compatibility layer.
.PARAMETER VerifyOnly
If specified, only validates consistency without modifying files.
#>
[CmdletBinding()]
param (
    [switch]$VerifyOnly
)

$ErrorActionPreference = "Stop"
$rootDir = Split-Path -Parent $PSScriptRoot
Set-Location $rootDir

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Agent Registry Master -> .apm Sync & Validator  " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

$hasErrors = $false

function Sync-DirectoryStructure {
    param (
        [string]$SourceDir,
        [string]$TargetDir,
        [string]$FileFilter = "*",
        [string]$TargetExtension = ""
    )

    if (-not (Test-Path $SourceDir)) {
        return
    }

    if (-not (Test-Path $TargetDir) -and -not $VerifyOnly) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    $files = Get-ChildItem -Path $SourceDir -Filter $FileFilter -File
    foreach ($file in $files) {
        $targetName = if ($TargetExtension) {
            [System.IO.Path]::ChangeExtension($file.Name, $TargetExtension)
        } else {
            $file.Name
        }
        $destPath = Join-Path $TargetDir $targetName

        if ($VerifyOnly) {
            if (-not (Test-Path $destPath)) {
                Write-Warning "[Missing] Target file does not exist: $destPath"
                $script:hasErrors = $true
            }
        } else {
            Copy-Item -Path $file.FullName -Destination $destPath -Force
            Write-Host "  [Synced] $($file.Name) -> $destPath" -ForegroundColor DarkGray
        }
    }
}

Write-Host "`n1. Processing Agents..." -ForegroundColor Yellow
Sync-DirectoryStructure -SourceDir "agents" -TargetDir ".apm\agents" -FileFilter "*.md" -TargetExtension ".agent.md"

Write-Host "`n2. Processing Commands / Prompts..." -ForegroundColor Yellow
Sync-DirectoryStructure -SourceDir "commands" -TargetDir ".apm\prompts" -FileFilter "*.md" -TargetExtension ".prompt.md"

Write-Host "`n3. Processing Instructions..." -ForegroundColor Yellow
Sync-DirectoryStructure -SourceDir "instructions" -TargetDir ".apm\instructions" -FileFilter "*.md" -TargetExtension ".instructions.md"

Write-Host "`n4. Processing Contexts..." -ForegroundColor Yellow
Sync-DirectoryStructure -SourceDir "contexts" -TargetDir ".apm\contexts" -FileFilter "*.md" -TargetExtension ".context.md"

Write-Host "`n5. Processing Chatmodes..." -ForegroundColor Yellow
Sync-DirectoryStructure -SourceDir "chatmodes" -TargetDir ".apm\chatmodes" -FileFilter "*.md" -TargetExtension ".chatmode.md"

Write-Host "`n6. Processing Skills..." -ForegroundColor Yellow
$skills = Get-ChildItem -Path "skills" -Directory
foreach ($skillDir in $skills) {
    $skillMd = Join-Path $skillDir.FullName "SKILL.md"
    if (Test-Path $skillMd) {
        $destFile = Join-Path ".apm\skills" "$($skillDir.Name).skill.md"
        if ($VerifyOnly) {
            if (-not (Test-Path $destFile)) {
                Write-Warning "[Missing] Target skill file does not exist: $destFile"
                $script:hasErrors = $true
            }
        } else {
            if (-not (Test-Path ".apm\skills")) { New-Item -ItemType Directory -Path ".apm\skills" -Force | Out-Null }
            Copy-Item -Path $skillMd -Destination $destFile -Force
            Write-Host "  [Synced Skill] $($skillDir.Name)/SKILL.md -> $destFile" -ForegroundColor DarkGray
        }
    }
}

Write-Host "`n7. Processing References..." -ForegroundColor Yellow
if (Test-Path "skills\code-review\references") {
    if (-not $VerifyOnly) {
        if (-not (Test-Path ".apm\references")) { New-Item -ItemType Directory -Path ".apm\references" -Force | Out-Null }
        Copy-Item -Path "skills\code-review\references\*" -Destination ".apm\references" -Recurse -Force
        Write-Host "  [Synced References] skills/code-review/references -> .apm/references" -ForegroundColor DarkGray
    }
}

Write-Host "`n8. Processing Hooks..." -ForegroundColor Yellow
if (Test-Path "hooks\pre-commit.ps1") {
    $hookDoc = "--`n`ndescription: Pre-commit hook executing lint and format validation.`n---`n# Pre-Commit Hook`n`nInvokes project linter and formatter prior to commit.`n`n## Executable Action`n``npm run lint && npm run format```n"
    $destHook = ".apm\hooks\pre-commit.hook.md"
    if ($VerifyOnly) {
        if (-not (Test-Path $destHook)) {
            Write-Warning "[Missing] Target hook does not exist: $destHook"
            $script:hasErrors = $true
        }
    } else {
        if (-not (Test-Path ".apm\hooks")) { New-Item -ItemType Directory -Path ".apm\hooks" -Force | Out-Null }
        Set-Content -Path $destHook -Value $hookDoc
        Write-Host "  [Synced Hook] hooks/ -> $destHook" -ForegroundColor DarkGray
    }
}

Write-Host "`n==================================================" -ForegroundColor Cyan
if ($hasErrors) {
    Write-Error "Verification failed: Inconsistencies detected between Master and .apm layer."
    exit 1
} else {
    Write-Host "  Sync & Verification Complete: All assets in sync! " -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    exit 0
}
