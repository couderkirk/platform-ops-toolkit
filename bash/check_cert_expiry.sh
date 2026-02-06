#!/usr/bin/env bash
#
# check_cert_expiry.sh
#
# Purpose:
#   Check TLS certificate expiration for one or more endpoints and warn
#   if expiration is within a defined threshold.
#
# Usage:
#   ./check_cert_expiry.sh example.com:443 api.internal.local:8443
#
# Notes:
#   - Requires openssl
#   - Intended as a lightweight validation helper; not a full monitoring solution

set -euo pipefail

WARN_DAYS=30

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 host:port [host:port ...]"
  exit 1
fi

now_epoch=$(date +%s)

for target in "$@"; do
  host="${target%%:*}"
  port="${target##*:}"

  echo "Checking certificate for ${host}:${port}..."

  end_date=$(echo | openssl s_client -servername "$host" -connect "${host}:${port}" 2>/dev/null \
    | openssl x509 -noout -enddate | cut -d= -f2)

  if [ -z "$end_date" ]; then
    echo "  ERROR: Unable to retrieve certificate for ${host}:${port}"
    continue
  fi

  end_epoch=$(date -d "$end_date" +%s)
  days_left=$(( (end_epoch - now_epoch) / 86400 ))

  if [ "$days_left" -le 0 ]; then
    echo "  CRITICAL: Certificate expired ${days_left#-} days ago!"
  elif [ "$days_left" -le "$WARN_DAYS" ]; then
    echo "  WARNING: Certificate expires in ${days_left} days"
  else
    echo "  OK: Certificate valid for ${days_left} more days"
  fi
done
