# VMware ESXi Host Upgrade Checklist

This runbook outlines a safe, repeatable process for upgrading VMware ESXi hosts in a production cluster.  
It assumes vCenter-managed hosts with sufficient cluster capacity to tolerate maintenance mode.

This is intentionally written as a checklist to reduce risk during routine lifecycle operations.

---

## Pre-Upgrade Validation

- [ ] Confirm target ESXi version is supported by:
  - server hardware model (OEM HCL)
  - storage adapters (HBA / NIC compatibility)
  - vCenter version
- [ ] Review VMware release notes and known issues for the target version
- [ ] Verify recent, successful backups of:
  - vCenter (if applicable)
  - host configuration profiles (if used)
- [ ] Confirm cluster has sufficient spare capacity to evacuate workloads
- [ ] Validate DRS and HA are healthy and enabled
- [ ] Check for existing host alarms, hardware faults, or degraded components
- [ ] Confirm no active snapshots or backup jobs tied to the host

---

## Change Preparation

- [ ] Notify stakeholders of maintenance window
- [ ] Place host in Maintenance Mode
- [ ] Verify all VMs successfully evacuate (no pinned or non-migratable workloads)
- [ ] Confirm no running services depend on local host storage
- [ ] Capture current ESXi version and build number
- [ ] Record host networking configuration (vmkernel ports, VLANs, uplinks)

---

## Upgrade Execution

- [ ] Apply ESXi upgrade using approved method:
  - Lifecycle Manager / Update Manager  
  - ISO upgrade  
  - OEM offline bundle  
- [ ] Monitor installation for errors or driver warnings
- [ ] Reboot host if required by upgrade process

---

## Post-Upgrade Validation

- [ ] Confirm host reconnects to vCenter
- [ ] Verify ESXi version and build match target
- [ ] Validate:
  - networking (vmkernel connectivity, management access)
  - storage paths and datastore visibility
  - hardware health status
- [ ] Exit Maintenance Mode
- [ ] Observe host for several minutes to confirm stability
- [ ] Confirm workloads rebalance as expected (DRS)

---

## Rollback / Recovery Notes

- If upgrade fails:
  - [ ] Do not remove host from vCenter until state is understood
  - [ ] Validate host boot state and console access
  - [ ] Escalate to vendor support if host fails to rejoin cluster
- Document failure details for future change refinement

---
## Post-Change Documentation

- [ ] Update CMDB / inventory with new ESXi version
- [ ] Record any anomalies or lessons learned
- [ ] Close change record with validation notes

---

## Operational Notes

- Avoid upgrading all hosts in a cluster simultaneously.
- Maintain version parity within clusters unless explicitly required otherwise.
- Treat hypervisor upgrades as routine reliability work, not one-off projects.
