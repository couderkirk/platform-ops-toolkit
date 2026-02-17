#!/usr/bin/env python3

import requests
import time

SERVICES = [
    "https://example.com/health",
    "https://api.example.com/status",
]

TIMEOUT_SECONDS = 5


def check_service(url):
    try:
        start = time.time()
        response = requests.get(url, timeout=TIMEOUT_SECONDS)
        latency = round(time.time() - start, 2)

        if response.status_code == 200:
            return {
                "url": url,
                "status": "healthy",
                "status_code": response.status_code,
                "latency_seconds": latency,
            }
        else:
            return {
                "url": url,
                "status": "unhealthy",
                "status_code": response.status_code,
                "latency_seconds": latency,
            }

    except requests.exceptions.RequestException as e:
        return {
            "url": url,
            "status": "error",
            "error": str(e),
        }


def main():
    print("Service Health Check\n")

    results = []
    for service in SERVICES:
        result = check_service(service)
        results.append(result)

    for r in results:
        if r["status"] == "healthy":
            print(f"[OK] {r['url']} ({r['latency_seconds']}s)")
        elif r["status"] == "unhealthy":
            print(f"[WARN] {r['url']} returned {r['status_code']}")
        else:
            print(f"[ERROR] {r['url']} - {r['error']}")


if __name__ == "__main__":
    main()
