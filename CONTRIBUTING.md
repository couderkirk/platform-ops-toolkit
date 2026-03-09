# Contributing

This repository is a personal operations toolkit containing scripts, runbooks, and automation patterns used for infrastructure troubleshooting and reliability work.

The goal is to keep the toolkit organized, practical, and easy to navigate.

---

## Repository Structure

- **bash/**  
  Linux operational utilities and troubleshooting tools.

- **powershell/**  
  Windows and infrastructure automation scripts.

- **python/**  
  Service validation and operational helper utilities.

- **ansible/**  
  Infrastructure automation roles and example playbooks.

- **runbooks/**  
  Operational procedures and incident response documentation.

---

## Adding New Tools

When adding a new script or utility:

1. Place the file in the appropriate language directory.
2. Ensure the script includes basic usage instructions.
3. Add an entry to the corresponding README index.

Example README entry:

- **endpoint_diagnostics.sh**  
  Troubleshooting utility that checks DNS resolution, TLS certificate status, and HTTP availability.

---

## Documentation Expectations

All operational procedures should be added as runbooks.

Runbooks should include the following sections where applicable:

- detection
- triage
- validation
- resolution
- prevention

---

## Goal of This Toolkit

This repository is intended to act as a reusable platform operations toolkit containing practical tools for diagnosing, responding to, and preventing infrastructure incidents.
