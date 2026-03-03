# Certificate Expiry Response Runbook

This runbook outlines the standard process for identifying, validating, renewing, and deploying expiring or expired TLS certificates for services hosted on Windows/IIS. It is intended to provide a repeatable workflow for responding to certificate-related incidents and preventing service disruption.

---

## Scope

This runbook applies to:

- Public or internal HTTPS endpoints
- Certificates bound to IIS
- Certificates issued by internal PKI or public CAs
- Services impacted by certificate expiration or misconfiguration

---

## Detection

Certificate issues may be identified through:

- Browser warnings (e.g., “Your connection is not private”)
- Monitoring alerts for impending certificate expiration
- Failed health checks or service availability checks
- User-reported access issues

Initial detection steps:

1. Navigate to the affected URL in a browser.
2. Inspect the certificate details:
   - Confirm expiration date
   - Confirm subject / SAN matches the expected hostname
   - Review certificate chain and issuing CA

---

## Triage

Determine the scope and urgency of the issue:

- Is the certificate expired or nearing expiration?
- Is the service production-facing?
- Are multiple services using the same certificate?
- Is the certificate managed by internal PKI or external CA?

Identify the host(s) running the service and whether IIS bindings reference the affected certificate.

---

## Validation

On the affected Windows host:

1. Open the local certificate store:
   - Use MMC (Certificates snap-in for Local Computer)
2. Locate the certificate:
   - Verify thumbprint matches the certificate observed in the browser
   - Confirm expiration date and private key availability
3. Identify how the certificate is used:
   - Check IIS bindings for the site
   - Confirm which certificate is currently bound to the HTTPS listener

---

## Resolution

High-level resolution steps:

1. Request or issue a new certificate:
   - Follow internal PKI or CA issuance process
2. Export the certificate (if required):
   - Include private key
   - Protect export with secure password handling
3. Import the new certificate on the target server:
   - Install into the appropriate certificate store
4. Update IIS bindings:
   - Bind the new certificate to the affected site(s)
5. Restart or recycle services if required

---

## Verification

After deployment:

- Confirm the new certificate is active in IIS bindings
- Re-test the service endpoint in a browser
- Validate certificate chain and expiration date
- Confirm monitoring no longer reports certificate warnings

---

## Prevention

To reduce recurrence:

- Track certificate expiration dates in a centralized inventory
- Implement monitoring or automated checks for upcoming expirations
- Establish renewal lead times (e.g., renew 30 days prior to expiry)
- Document certificate ownership and renewal responsibility

---

## Notes

This runbook documents the standard workflow for certificate renewal and deployment. Environment-specific details (PKI process, CA tools, approval flows) should be added as operational knowledge is captured.

---

## References

- Internal PKI documentation (if applicable)
- IIS HTTPS binding documentation
- Certificate management procedures
