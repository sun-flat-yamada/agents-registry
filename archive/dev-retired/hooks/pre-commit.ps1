<#
.SYNOPSIS
Pre-commit hook for linting and formatting validation.
#>
Write-Host "[Hook] Running pre-commit validation (lint and format checks)..." -ForegroundColor Cyan

if (Test-Path "package.json") {
    $scripts = Get-Content package.json | ConvertFrom-Json | Select-Object -ExpandProperty scripts -ErrorAction SilentlyContinue
    if ($scripts.lint) {
        Write-Host "[Hook] Executing npm run lint..." -ForegroundColor DarkGray
        npm run lint
        if ($LASTEXITCODE -ne 0) {
            Write-Error "[Hook] Lint check failed. Please resolve lint issues before committing."
            exit 1
        }
    }
    if ($scripts.format) {
        Write-Host "[Hook] Executing npm run format..." -ForegroundColor DarkGray
        npm run format
        if ($LASTEXITCODE -ne 0) {
            Write-Error "[Hook] Formatting check failed."
            exit 1
        }
    }
}
Write-Host "[Hook] Pre-commit checks passed successfully." -ForegroundColor Green
exit 0
