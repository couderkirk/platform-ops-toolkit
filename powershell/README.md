# PowerShell

## Conventions

- Scripts are organized by domain (vmware, windows-ops, active-directory).
- Shared helpers live under `common/`.
- Filenames use PascalCase with descriptive naming.
- Logging and error handling are standardized where appropriate.

## VMware

- **vmware/Take_VM_Snapshot_With_Expiration.ps1**  
    Creates snapshots with an expiration tag to help prevent long-lived snapshot sprawl.

## Common Utilities

- **common/ErrorHandlingAndLogging.ps1**  
    Lightweight logging helpers and a reusable try/catch pattern for consistent error handling across scripts.
