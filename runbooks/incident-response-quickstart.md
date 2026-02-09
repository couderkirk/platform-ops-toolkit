# Incident Response Quickstart

This runbook provides a lightweight, practical framework for responding to operational incidents.  
It is intended to help responders stabilize services quickly, communicate clearly, and reduce time-to-recovery during high-pressure events.

The focus is on **containment, clarity, and restoration**, not post-incident process overhead.

---

## When to Use This Runbook

Use this workflow for:
- Service outages or partial degradation
- Failed deployments or configuration changes
- Performance regressions impacting users
- Security or access issues affecting availability

---

## Initial Triage (First 5–10 Minutes)

- [ ] Acknowledge the incident and assign an owner
- [ ] Identify impacted service(s) and user scope
- [ ] Establish communication channel (incident bridge / chat)
- [ ] Confirm alert source and basic symptoms
- [ ] Check for:
  - recent changes
  - active deployments
  - maintenance in progress
- [ ] Capture initial timeline and observations

---

## Stabilization

- [ ] Determine whether rollback is available and safe
- [ ] Identify quick mitigations:
  - traffic shift
  - feature flag disable
  - service restart
  - scale up/down
- [ ] Apply lowest-risk mitigation first
- [ ] Validate partial recovery before proceeding

---

## Investigation

- [ ] Review logs, metrics, and recent alerts
- [ ] Identify likely blast radius
- [ ] Validate dependencies (databases, certs, network paths, identity providers)
- [ ] Confirm whether the issue is:
  - systemic (platform-wide)
  - isolated (single service / host)

---

## Communication

- [ ] Provide initial status update to stakeholders
- [ ] Communicate:
  - what is impacted
  - what is known
  - next update time
- [ ] Avoid speculation; share confirmed facts only
- [ ] Update status at regular intervals

---

## Resolution

- [ ] Apply corrective change or remediation
- [ ] Validate service recovery from user perspective
- [ ] Monitor for regression or secondary impact
- [ ] Confirm alerts have cleared

---

## Post-Incident Follow-Up (Lightweight)

- [ ] Record timeline of key events
- [ ] Identify contributing factors
- [ ] Capture remediation actions and next steps
- [ ] Identify automation or monitoring improvements
- [ ] Schedule deeper post-incident review if needed

---

## Operational Notes

- Optimize for **time-to-stability**, not perfect diagnosis.
- Prefer reversible mitigations over risky permanent changes during incidents.
- Good communication reduces operational load as much as technical fixes.
