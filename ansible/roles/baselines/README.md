# Baseline Role

This role provides a starting point for applying baseline configuration to Linux hosts.  
It is intentionally minimal and intended as a template for building standardized roles.

## Purpose

- Establish a consistent structure for Ansible roles
- Provide a foundation for baseline configuration (packages, users, basic hardening)
- Serve as a reusable starting point for future automation

## Structure

- **tasks/main.yml**  
  Core tasks applied by the role

- **defaults/main.yml**  
  Default variables for the role

## Notes

This role is a template and does not attempt to fully harden systems.  
It is intended to demonstrate structure, idempotence, and documentation practices.
