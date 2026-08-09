#!/usr/bin/env bash
# Bulk domain availability check via RDAP (rdap.org universal redirector).
# Usage: check-domain.sh domain1.com domain2.io domain3.dev ...
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <domain> [domain2] [domain3] ..." >&2
  exit 1
fi

for domain in "$@"; do
  code=$(curl -s -L -o /dev/null -w "%{http_code}" --max-time 10 "https://rdap.org/domain/${domain}" || echo "000")
  case "$code" in
    200) status="REGISTERED" ;;
    404) status="AVAILABLE (per RDAP)" ;;
    000) status="NO RDAP / connection failed (try whois or the registrar's own lookup)" ;;
    *) status="UNKNOWN (HTTP $code)" ;;
  esac
  printf "%-30s %s\n" "$domain" "$status"
  sleep 1
done
