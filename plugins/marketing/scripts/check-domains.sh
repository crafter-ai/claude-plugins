#!/usr/bin/env bash
# Checks whether domains are registered, asking each registry's RDAP server.
#
# Usage:
#   check-domains.sh [--tlds com,app[,com.br]] NAME [NAME...]
#   printf 'name1\nname2\n' | check-domains.sh --tlds com,app,com.br
#
# NAME is a bare label ("vercel"), expanded across --tlds, or a full domain
# ("vercel.com.br"), checked as is. Default TLDs: com,app.
#
# Output: one line per domain with AVAILABLE (not registered), TAKEN
# (registered), INVALID (bad label) or UNKNOWN (registry unreachable after
# retries), then a summary of names available on every requested TLD.
set -euo pipefail

usage() { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; }

tlds="com,app"
names=()
while [ $# -gt 0 ]; do
  case "$1" in
    --tlds) tlds="$2"; shift 2 ;;
    --tlds=*) tlds="${1#--tlds=}"; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; names+=("$@"); break ;;
    -*) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    *) names+=("$1"); shift ;;
  esac
done
if [ ${#names[@]} -eq 0 ] && [ ! -t 0 ]; then
  while read -r -a line; do names+=(${line[@]+"${line[@]}"}); done
fi
[ ${#names[@]} -gt 0 ] || { usage >&2; exit 2; }

# Authoritative RDAP servers per IANA's bootstrap registry (data.iana.org/rdap/dns.json).
# Any other TLD goes through rdap.org, which redirects to the right server (best effort).
rdap_url() {
  local domain=$1 tld=${1#*.}
  case "$tld" in
    com)     echo "https://rdap.verisign.com/com/v1/domain/$domain" ;;
    app)     echo "https://pubapi.registry.google/rdap/domain/$domain" ;;
    br|*.br) echo "https://rdap.registro.br/domain/$domain" ;;
    *)       echo "https://rdap.org/domain/$domain" ;;
  esac
}

# RDAP answers 200 for a registered domain and 404 for an unregistered one.
# Verisign closes the TLS connection abruptly after a 404, which makes curl exit
# non-zero even though it received the status, so trust the printed code and
# only treat a missing one ("000") as a failure.
check() {
  local domain=$1 url code attempt
  url=$(rdap_url "$domain")
  for attempt in 1 2 3; do
    code=$(curl -sS -L --max-time 20 -o /dev/null -w '%{http_code}' \
      -H 'Accept: application/rdap+json' "$url" 2>/dev/null || true)
    [[ $code =~ ^[0-9]{3}$ ]] || code=000
    case "$code" in
      200) echo TAKEN; return ;;
      404) echo AVAILABLE; return ;;
      *)   sleep "$attempt" ;;
    esac
  done
  echo "UNKNOWN(http $code)"
}

valid_label() { [[ $1 =~ ^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$ ]]; }

IFS=',' read -r -a tld_list <<< "$tlds"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fully=(); partly=()
printf '%-40s %s\n' DOMAIN STATUS
for raw in "${names[@]}"; do
  name=$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
  [ -n "$name" ] || continue
  domains=()
  if [[ $name == *.* ]]; then
    domains=("$name")
  else
    for t in "${tld_list[@]}"; do domains+=("$name.$t"); done
  fi
  if ! valid_label "${name%%.*}"; then
    for d in "${domains[@]}"; do printf '%-40s %s\n' "$d" INVALID; done
    continue
  fi
  # The TLDs live on different registries, so one name's lookups can run in parallel.
  for d in "${domains[@]}"; do check "$d" > "$tmp/$d" & done
  wait
  available=0
  for d in "${domains[@]}"; do
    status=$(cat "$tmp/$d")
    printf '%-40s %s\n' "$d" "$status"
    [ "$status" = AVAILABLE ] && available=$((available + 1))
  done
  if [ "$available" -eq "${#domains[@]}" ]; then fully+=("$name")
  elif [ "$available" -gt 0 ]; then partly+=("$name"); fi
  sleep 0.2
done
echo
echo "Available on every requested TLD: ${fully[*]:-none}"
echo "Available on some requested TLDs: ${partly[*]:-none}"
