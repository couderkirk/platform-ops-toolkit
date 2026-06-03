<#
.SYNOPSIS
    Searches recent Active Directory account lockout events and reports likely source systems.

.DESCRIPTION
    Queries domain controller security logs for Event ID 4740, which indicates an AD account lockout.
    This helps identify the computer or system that may be repeatedly submitting bad credentials.

.PARAMETER Username
    The username to search for in recent lockout events.

.PARAMETER HoursBack
    Number of hours back to search. Defaults to 24.

.EXAMPLE
    .\Get-ADLockoutSource.ps1 -Username jdoe -HoursBack 12
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Username,

    [Parameter(Mandatory = $false)]
    [int]$HoursBack = 24
)

$StartTime = (Get-Date).AddHours(-$HoursBack)

Write-Host "Searching for lockout events for user '$Username' since $StartTime..."
Write-Host ""

try {
    $DomainControllers = Get-ADDomainController -Filter *

    foreach ($DC in $DomainControllers) {
        Write-Host "Checking domain controller: $($DC.HostName)"

        try {
            $Events = Get-WinEvent -ComputerName $DC.HostName -FilterHashtable @{
                LogName   = 'Security'
                Id        = 4740
                StartTime = $StartTime
            } -ErrorAction Stop

            foreach ($Event in $Events) {
                $Xml = [xml]$Event.ToXml()

                $TargetUser = ($Xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
                $CallerComputer = ($Xml.Event.EventData.Data | Where-Object { $_.Name -eq 'CallerComputerName' }).'#text'

                if ($TargetUser -eq $Username) {
                    [PSCustomObject]@{
                        TimeCreated        = $Event.TimeCreated
                        DomainController   = $DC.HostName
                        LockedOutUser      = $TargetUser
                        CallerComputerName = $CallerComputer
                    }
                }
            }
        }
        catch {
            Write-Warning "Unable to query $($DC.HostName): $($_.Exception.Message)"
        }
    }
}
catch {
    Write-Error "Failed to query domain controllers. Ensure the ActiveDirectory module is installed and you have appropriate permissions."
}
