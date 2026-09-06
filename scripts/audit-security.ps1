<#
.SYNOPSIS
Cross-platform PowerShell runner for AI Skills and Agent Security Audit (Cisco + NVIDIA Scanners).
.PARAMETER Target
Specific skill directory or agent markdown file to scan.
.PARAMETER ChangedOnly
Scan only assets added or modified in git.
.PARAMETER Scanners
List of scanners to run (cisco, nvidia, builtin, all). Default: all.
.PARAMETER FailOn
Failure severity threshold (critical, high, medium, low, any). Default: high.
.PARAMETER Strict
Enforce strict mode (fail on warnings).
.PARAMETER OutputJson
Filepath to save JSON audit report.
.PARAMETER OutputMarkdown
Filepath to save Markdown audit report.
.PARAMETER OutputSarif
Filepath to save SARIF 2.1.0 audit report for GitHub Code Scanning.
.PARAMETER NoInstall
Skip automatic venv creation and dependency installation.
#>
[CmdletBinding()]
param (
    [string]$Target,
    [switch]$ChangedOnly,
    [string[]]$Scanners = @("all"),
    [ValidateSet("critical", "high", "medium", "low", "any")]
    [string]$FailOn = "high",
    [switch]$Strict,
    [string]$OutputJson,
    [string]$OutputMarkdown,
    [string]$OutputSarif,
    [switch]$NoInstall,
    [switch]$VerboseOutput
)

$ErrorActionPreference = "Stop"
$rootDir = Split-Path -Parent $PSScriptRoot
Set-Location $rootDir

# Ensure Output Encoding is UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$venvDir = Join-Path $rootDir ".venv-security"
$venvPython = Join-Path $venvDir "Scripts\python.exe"

if (-not $NoInstall) {
    if (-not (Test-Path $venvPython)) {
        Write-Host "Setting up Python 3.12 virtual environment for security scanners..." -ForegroundColor Cyan
        
        # Check if uv is available
        $hasUv = Get-Command "uv" -ErrorAction SilentlyContinue
        if ($hasUv) {
            Write-Host "Using uv to create .venv-security with Python 3.12..." -ForegroundColor DarkGray
            & uv venv --python 3.12 $venvDir
            Write-Host "Installing Cisco and NVIDIA security scanners via uv..." -ForegroundColor DarkGray
            & uv pip install -r (Join-Path $rootDir "scripts\requirements-security.txt") --python $venvPython
        } else {
            # Fallback to system python
            $pythonCmd = Get-Command "python3.12" -ErrorAction SilentlyContinue
            if (-not $pythonCmd) { $pythonCmd = Get-Command "python" -ErrorAction SilentlyContinue }
            if ($pythonCmd) {
                Write-Host "Creating venv using $($pythonCmd.Source)..." -ForegroundColor DarkGray
                & $pythonCmd.Source -m venv $venvDir
                & $venvPython -m pip install --upgrade pip
                & $venvPython -m pip install -r (Join-Path $rootDir "scripts\requirements-security.txt")
            } else {
                Write-Warning "Python not found. Running with system environment."
            }
        }
    }
}

$runner = if (Test-Path $venvPython) { $venvPython } else { "python" }

$argsList = @((Join-Path $rootDir "scripts\security-audit.py"))

if ($Target) { $argsList += @("--target", $Target) }
if ($ChangedOnly) { $argsList += "--changed-only" }
if ($Scanners) { $argsList += @("--scanners") + $Scanners }
if ($FailOn) { $argsList += @("--fail-on", $FailOn) }
if ($Strict) { $argsList += "--strict" }
if ($OutputJson) { $argsList += @("--output-json", $OutputJson) }
if ($OutputMarkdown) { $argsList += @("--output-markdown", $OutputMarkdown) }
if ($OutputSarif) { $argsList += @("--output-sarif", $OutputSarif) }
if ($VerboseOutput) { $argsList += "--verbose" }

# Execute security auditor
& $runner @argsList
$exitCode = $LASTEXITCODE
exit $exitCode
