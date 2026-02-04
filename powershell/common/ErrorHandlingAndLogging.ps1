<#
.SYNOPSIS
    Lightweight logging helpers and a safe try/catch pattern for PowerShell scripts.

.DESCRIPTION
    Provides simple functions for structured logging (INFO/WARN/ERROR) and a
    consistent error handling approach that can be reused across scripts.

    Intended for small automation tooling where a full logging framework would
    be unnecessary overhead.

.EXAMPLE
    . .\ErrorHandlingAndLogging.ps1
    Write-Log -Level INFO -Message "Starting job" -LogPath ".\logs\job.log"

    try {
        # Do work
        Get-Content ".\missing.txt" -ErrorAction Stop
    }
    catch {
        Write-LogException -Exception $_ -Context "Reading input file" -LogPath ".\logs\job.log"
        throw
    }
#>

Set-StrictMode -Version Latest

function New-LogDirectory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LogPath
    )

    $dir = Split-Path -Path $LogPath -Parent
    if (-not [string]::IsNullOrWhiteSpace($dir) -and -not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }
}

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('INFO','WARN','ERROR')]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [string]$LogPath = ".\logs\script.log"
    )

    try {
        New-LogDirectory -LogPath $LogPath

        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $line = "$timestamp [$Level] $Message"

        $line | Out-File -FilePath $LogPath -Append -Encoding utf8
        Write-Host $line
    }
    catch {
        # If logging fails, we still want *something* visible
        Write-Warning "Logging failed: $($_.Exception.Message)"
        Write-Warning "Original message: [$Level] $Message"
    }
}

function Write-LogException {
    param(
        [Parameter(Mandatory=$true)]
        $Exception,

        [Parameter(Mandatory=$false)]
        [string]$Context = "Unhandled exception",

        [Parameter(Mandatory=$false)]
        [string]$LogPath = ".\logs\script.log"
    )

    $msg = $Exception.Exception.Message
    $type = $Exception.Exception.GetType().FullName

    Write-Log -Level ERROR -Message "$Context | $type | $msg" -LogPath $LogPath

    if ($Exception.ScriptStackTrace) {
        Write-Log -Level ERROR -Message "StackTrace: $($Exception.ScriptStackTrace)" -LogPath $LogPath
    }
}
