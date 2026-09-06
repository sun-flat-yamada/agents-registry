<#
.SYNOPSIS
    Deterministic Trajectory & Log Parser for AI Agent Friction Detection.
.DESCRIPTION
    Parses agent session transcripts or raw log streams, deterministically extracts
    failure signals (exit code != 0, tool exceptions, user corrections, revert loops),
    and projects them onto invariant Canonical Signatures by masking ephemeral noise
    (PIDs, timestamps, temporary file paths).
.PARAMETER InputPath
    Path to a session log or transcript file (.json, .jsonl, or .log/.txt).
    If omitted or empty, reads from pipeline stdin.
.PARAMETER OutputFormat
    'Json' (default) or 'Text'
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$InputObject,
    [string]$InputPath,
    [string]$RawLog,
    [ValidateSet('Json', 'Text')]
    [string]$OutputFormat = 'Json'
)

$ErrorActionPreference = 'Stop'

function Get-InputContent {
    if (-not [string]::IsNullOrWhiteSpace($RawLog)) {
        return $RawLog
    }
    if ($InputPath -and (Test-Path $InputPath)) {
        return Get-Content -Path $InputPath -Raw -Encoding UTF8
    }
    if ($InputObject -and $InputObject.Count -gt 0) {
        return ($InputObject -join "`n")
    }
    $piped = @($input)
    if ($piped.Count -gt 0) {
        return ($piped -join "`n")
    }
    return ""
}

$rawText = Get-InputContent
if ([string]::IsNullOrWhiteSpace($rawText)) {
    Write-Warning "No input data provided to parse-trajectory. Please provide -InputPath or pipe log content."
    if ($OutputFormat -eq 'Json') {
        Write-Output "{ `"events`": [], `"totalEvents`": 0, `"uniqueSignatures`": 0 }"
    }
    exit 0
}

# Normalization Regex Patterns
function Normalize-Signal {
    param([string]$Text)
    
    $s = $Text
    # 1. Mask ISO 8601 / standard timestamps
    $s = [regex]::Replace($s, '\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:?\d{2})?', '<TIMESTAMP>')
    # 2. Mask Windows / Unix temporary paths
    $s = [regex]::Replace($s, '(?i)[a-z]:\\[^ \r\n\t"\''`]*(temp|tmp|\.harness-backup)[^ \r\n\t"\''`]*', '<TEMP_PATH>')
    $s = [regex]::Replace($s, '(?i)/tmp/[^ \r\n\t"\''`]*', '<TEMP_PATH>')
    # 3. Mask PIDs and process numbers
    $s = [regex]::Replace($s, '(?i)\b(pid|process)\s*[:=]?\s*\d+\b', '<PID>')
    # 4. Mask Hex SHA hashes (8+ chars)
    $s = [regex]::Replace($s, '\b[0-9a-fA-F]{8,64}\b', '<HASH>')
    # 5. Mask Absolute Paths (Windows & Unix)
    $s = [regex]::Replace($s, '(?i)[a-z]:\\(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]+', '<PATH>')
    $s = [regex]::Replace($s, '(?i)/(?:[a-zA-Z0-9_\-\.]+/)+[a-zA-Z0-9_\-\.]+', '<PATH>')
    # 6. Normalize Whitespace
    $s = [regex]::Replace($s, '\s+', ' ').Trim()

    return $s
}

function Get-CanonicalHash {
    param([string]$Type, [string]$NormalizedMessage)
    $rawKey = "$Type::$NormalizedMessage"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($rawKey)
    $hasher = [System.Security.Cryptography.SHA256]::Create()
    $hashBytes = $hasher.ComputeHash($bytes)
    $hex = -join ($hashBytes | ForEach-Object { $_.ToString("x2") })
    return $hex.Substring(0, 16)
}

$detectedEvents = [System.Collections.Generic.List[PSCustomObject]]::new()

# Line-by-line inspection
$lines = $rawText -split "\r?\n"
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $eventType = $null
    $rawSnippet = $line

    # Pattern A: Non-zero exit code
    if ($line -match '(?i)(exit code\s*[:=]?\s*([1-9]\d*)|failed with code\s*([1-9]\d*)|status[:=]\s*failed)') {
        $eventType = "EXIT_CODE_NONZERO"
    }
    # Pattern B: Tool Failure / Exception
    elseif ($line -match '(?i)(ToolError|Encountered error in tool|Unhandled exception|Command failed|Error: Cannot find module|SyntaxError:|TypeError:|ReferenceError:)') {
        $eventType = "TOOL_OR_RUNTIME_ERROR"
    }
    # Pattern C: Permission / Access Denied
    elseif ($line -match '(?i)(Permission denied|Access is denied|EACCES|EPERM|blocked by security policy)') {
        $eventType = "PERMISSION_DENIED"
    }
    # Pattern D: Rollback / Revert actions
    elseif ($line -match '(?i)(git checkout --|git reset|reverting back|restored to pre-update)') {
        $eventType = "ROLLBACK_DETECTED"
    }
    # Pattern E: User corrective intervention
    elseif ($line -match '(?i)(no,\s+don''t|that''s wrong|stop doing|always run .* first|やり直して|そうではなく|違う)') {
        $eventType = "USER_CORRECTION"
    }

    if ($eventType) {
        # Grab context (up to next 2 lines if available)
        $contextSnippet = $line
        if ($i + 1 -lt $lines.Count -and -not [string]::IsNullOrWhiteSpace($lines[$i+1])) {
            $contextSnippet += " | " + $lines[$i+1].Trim()
        }

        $norm = Normalize-Signal $contextSnippet
        $sig = Get-CanonicalHash -Type $eventType -NormalizedMessage $norm

        $rawSnippetShort = if ($line.Length -gt 120) { $line.Substring(0, 120) + "..." } else { $line }
        $detectedEvents.Add([PSCustomObject]@{
            LineNumber         = $i + 1
            EventType          = $eventType
            CanonicalSignature = $sig
            NormalizedSnippet  = $norm
            RawSnippet         = $rawSnippetShort
        })
    }
}

# Group by Canonical Signature
$grouped = $detectedEvents | Group-Object -Property CanonicalSignature | ForEach-Object {
    $first = $_.Group[0]
    [PSCustomObject]@{
        CanonicalSignature = $_.Name
        EventType          = $first.EventType
        Frequency          = $_.Count
        NormalizedSnippet  = $first.NormalizedSnippet
        SampleRaw          = $first.RawSnippet
        FirstLine          = $first.LineNumber
    }
} | Sort-Object -Property Frequency -Descending

if ($OutputFormat -eq 'Json') {
    $result = [PSCustomObject]@{
        Timestamp        = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
        TotalRawEvents   = $detectedEvents.Count
        UniqueSignatures = $grouped.Count
        SignatureGroups  = $grouped
    }
    $result | ConvertTo-Json -Depth 5
} else {
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  Trajectory Canonical Parser (Friction Extractor)" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "Total Raw Events: $($detectedEvents.Count)" -ForegroundColor DarkGray
    Write-Host "Unique Signatures: $($grouped.Count)`n" -ForegroundColor Yellow

    foreach ($g in $grouped) {
        Write-Host "[$($g.EventType)] Signature: $($g.CanonicalSignature) (Occurrences: $($g.Frequency))" -ForegroundColor Red
        Write-Host "  Normalized: $($g.NormalizedSnippet)" -ForegroundColor White
        Write-Host "  Sample Raw: $($g.SampleRaw)" -ForegroundColor DarkGray
    }
    Write-Host "==================================================" -ForegroundColor Cyan
}

exit 0
