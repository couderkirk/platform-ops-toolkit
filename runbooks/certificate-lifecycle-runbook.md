# Certificate Expiry & Renewal Runbook

This runbook outlines a practical process for identifying, renewing, and validating expiring TLS/SSL certificates across infrastructure and application services, including (but not limited to) VMware components, web services, APIs, and network appliances.

Certificate expiration and misconfiguration are common causes of avoidable outages. The goal of this runbook is to reduce last-minute renewals, prevent service disruptions, and standardize renewal validation across platforms.

---

## Scope

Applies to certificates used by:
- VMware components (vCenter, ESXi, NSX, vSAN services)
- Public-facing web services and APIs
- Internal applications and service endpoints
- Load balancers / reverse proxies
- VPN gateways and network appliances
- Monitoring agents and automation endpoints

---

## Detection & Inventory

- [ ] Maintain a certificate inventory:
  - hostname / service
  - certificate owner
  - expiration date
  - renewal authority (public CA, internal CA)
- [ ] Ensure monitoring/alerts exist for certificates expiring within:
  - 30 days (warning)
  - 14 days (escalation)
  - 7 days (urgent)
- [ ] Validate alert delivery path (email, ticketing, on-call notification)
- [ ] Periodically validate inventory accuracy against live services

---

## Pre-Renewal Validation

- [ ] Identify certificate owner and renewal authority
- [ ] Confirm certificate type:
  - public CA (e.g., customer-facing services)
  - internal CA (e.g., VMware, internal apps)
- [ ] Validate:
  - Subject / SAN entries
  - Key length and algorithm requirements
  - Compatibility with target platform (e.g., VMware service expectations)
- [ ] Identify all services and dependencies using the certificate
- [ ] Confirm any platform-specific constraints:
  - VMware service restarts required?
  - Load balancer certificate reload behavior?
  - Client trust store dependencies?

---

## Renewal Process

- [ ] Generate CSR (if required)
- [ ] Submit renewal request to appropriate CA
- [ ] Validate issued certificate details before deployment:
  - CN / SAN correctness
  - Expiration date
  - Full certificate chain provided
- [ ] Store renewed certificate securely until deployment window

---

## Deployment

- [ ] Install renewed certificate on target service(s)
- [ ] Restart or reload services as required:
  - VMware services (if applicable)
  - web servers / proxies
  - load balancers
- [ ] Validate:
  - Service availability
  - TLS handshake success
  - No client-side trust errors
- [ ] Confirm certificate chain is correctly presented end-to-end

---

## Common Failure Modes to Check

- [ ] Missing intermediate certificate in chain
- [ ] SAN mismatch (hostname not included)
- [ ] Expired root or intermediate CA
- [ ] Service using cached or old certificate after renewal
- [ ] Client trust store not updated (internal CA scenarios)
- [ ] Certificate renewed but bound to wrong service or listener
- [ ] Time drift on host causing premature expiry validation

---

## Post-Renewal Validation

- [ ] Confirm new expiration date is reflected in monitoring
- [ ] Remove or archive old certificate if applicable
- [ ] Validate that no residual services reference the expired certificate
- [ ] Close alert or incident

---

## Rollback / Failure Handling

- If deployment fails:
  - [ ] Revert to previous known-good certificate (if still valid)
  - [ ] Validate service restoration
  - [ ] Escalate to platform / security team if renewal is blocked

---

## Documentation & Improvements

- [ ] Update certificate inventory with new expiration date
- [ ] Record any issues encountered during renewal
- [ ] Identify automation opportunities (e.g., ACME, certbot, scheduled checks)
- [ ] Review whether additional monitoring coverage is needed

---

## Operational Notes

- Certificates should be treated as part of routine reliability maintenance, not emergency response.
- Avoid manual, last-minute renewals for production-facing services.
- Where possible, automate issuance and renewal workflows.
