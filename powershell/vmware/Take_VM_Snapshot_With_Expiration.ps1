<#
.SYNOPSIS
    Creates a snapshot for a VMware VM and tags it with an expiration date.

.DESCRIPTION
    This script creates a snapshot for a specified VM and stores an expiration
    timestamp in the snapshot description. This is useful for operational
    guardrails to prevent long-lived snapshots from accumulating and impacting
    performance.

    Note: VMware does not natively enforce snapshot expiration. A separate
    cleanup job or process should periodically remove expired snapshots.

.PARAMETER VMName
    Name of the VM to snapshot.

.PARAMETER SnapshotName
    Name of the snapshot.

.PARAMETER ExpirationDays
    Number of days until the snapshot should be considered expired.

.EXAMPLE
    .\Take_VM_Snapshot_With_Expiration.ps1 -VMName "app-server-01" -SnapshotName "pre-patch" -ExpirationDays 7
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$VMName,

    [Parameter(Mandatory = $true)]
    [string]$SnapshotName,

    [Parameter(Mandatory = $false)]
    [int]$ExpirationDays = 30
)

try {
    Write-Host "Creating snapshot '$SnapshotName' for VM '$VMName'..."

    $expirationDate = (Get-Date).AddDays($ExpirationDays)
    $description = "Snapshot expires on: $expirationDate"

    $snapshot = New-Snapshot `
        -VM $VMName `
        -Name $SnapshotName `
        -Description $description `
        -Quiesce:$false `
        -Memory:$false `
        -Confirm:$false

    Write-Host "Snapshot created successfully."
    Write-Host "Expiration date set to: $expirationDate"
}
catch {
    Write-Error "Failed to create snapshot for VM '$VMName'."
    Write-Error $_
}
