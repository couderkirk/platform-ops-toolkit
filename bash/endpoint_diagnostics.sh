#!/usr/bin/env bash

# Endpoint diagnostics script
# Usage: ./endpoint_diagnostics.sh example.com

set -e

TARGET=$1
PORT=${2:-443}

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <hostname> [port]"
  exit 1
fi

echo "========================================"
echo "Endpoint Diagnostics for: $TARGET"
echo "Port: $PORT"
echo "Timestamp: $(date)"
echo "========================================"
echo

############################
# DNS CHECK
############################
echo "[DNS] Checking DNS resolution..."

if command -v dig &> /dev/null; then
  DNS_RESULT=$(dig +short "$TARGET" | head -n1)
else
  DNS_RESULT=$(nslookup "$TARGET" 2>/dev/null | awk '/^Address: / { print $2 }' | head -n1)
fi

if [[ -z "$DNS_RESULT" ]]; then
  echo "❌ DNS resolution failed"
else
  echo "✅ DNS resolved: $DNS_RESULT"
fi

echo

############################
# TCP CONNECTIVITY
############################
echo "[TCP] Testing connectivity to $TARGET:$PORT..."

if timeout 5 bash -c "</dev/tcp/$TARGET/$PORT" 2>/dev/null; then
  echo "✅ TCP connection successful"
else
  echo "❌ TCP connection failed"
fi

echo

############################
# TLS CERTIFICATE CHECK
############################
echo "[TLS] Inspecting certificate..."

CERT_INFO=$(echo | timeout 5 openssl s_client -servername "$TARGET" -connect "$TARGET:$PORT" 2>/dev/null)

EXPIRY_DATE=$(echo "$CERT_INFO" | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

if [[ -z "$EXPIRY_DATE" ]]; then
  echo "❌ Unable to retrieve certificate"
else
  echo "Certificate expires: $EXPIRY_DATE"

  EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
  NOW_EPOCH=$(date +%s)

  DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

  echo "Days remaining: $DAYS_LEFT"

  if [[ "$DAYS_LEFT" -lt 30 ]]; then
    echo "⚠️  WARNING: Certificate expires soon"
  else
    echo "✅ Certificate validity OK"
  fi
fi

echo

############################
# HTTP CHECK
############################
echo "[HTTP] Checking HTTP response..."

HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "https://$TARGET")

if [[ "$HTTP_STATUS" == "200" ]]; then
  echo "✅ HTTP status: $HTTP_STATUS"
else
  echo "⚠️  HTTP status: $HTTP_STATUS"
fi

echo

############################
# LATENCY TEST
############################
echo "[LATENCY] Measuring response time..."

LATENCY=$(curl -o /dev/null -s -w "%{time_total}" "https://$TARGET")

echo "Response time: ${LATENCY}s"

echo
echo "Diagnostics complete."
echo "========================================"
