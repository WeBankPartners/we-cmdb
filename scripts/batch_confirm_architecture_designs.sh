#!/usr/bin/env bash
# Batch-confirm Application Architecture Diagram design data.
#
# Usage:
#   1. Set WECUBE_TOKEN (and, if necessary, WECMDB_BASE_URL) below.
#   2. ./scripts/batch_confirm_architecture_designs.sh design_guids.txt
#
# design_guids.txt contains one app_system_design_xxxx GUID per line. Empty
# lines and lines beginning with "#" are ignored.

set -uo pipefail

# Paste the raw access token here (without the "Bearer " prefix); do not
# commit a real token.
WECUBE_TOKEN="REPLACE_WITH_YOUR_WECUBE_TOKEN"

# The endpoint observed in the browser is:
# http://10.62.36.21:8080/wecmdb/api/v1/view-confirm
WECMDB_BASE_URL="http://10.62.36.21:8080"
VIEW_ID="app_arc_new"
API_PATH="/wecmdb/api/v1/view-confirm"

usage() {
  echo "Usage: $0 <design-guids.txt>"
}

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

guid_file=$1
if [[ ! -f "$guid_file" ]]; then
  echo "GUID file does not exist: $guid_file" >&2
  exit 2
fi

if [[ -z "$WECUBE_TOKEN" || "$WECUBE_TOKEN" == "REPLACE_WITH_YOUR_WECUBE_TOKEN" ]]; then
  echo "Please set WECUBE_TOKEN at the top of this script before running it." >&2
  exit 2
fi

api_url="${WECMDB_BASE_URL%/}${API_PATH}"
response_file=$(mktemp)
trap 'rm -f "$response_file"' EXIT

total=0
success=0
failed=0
skipped=0

while IFS= read -r raw_guid || [[ -n "$raw_guid" ]]; do
  # Handle Windows CRLF input and trim leading/trailing whitespace.
  guid=${raw_guid%$'\r'}
  guid="${guid#"${guid%%[![:space:]]*}"}"
  guid="${guid%"${guid##*[![:space:]]}"}"

  if [[ -z "$guid" || "$guid" == \#* ]]; then
    continue
  fi

  if [[ ! "$guid" =~ ^app_system_design_[A-Za-z0-9_-]+$ ]]; then
    echo "SKIP    $guid (expected app_system_design_xxxx)" >&2
    ((skipped += 1))
    continue
  fi

  ((total += 1))
  payload=$(printf '{"viewId":"%s","rootCi":"%s"}' "$VIEW_ID" "$guid")
  http_code=$(curl --silent --show-error --output "$response_file" --write-out '%{http_code}' \
    --connect-timeout 10 --max-time 600 \
    --request POST "$api_url" \
    --header "Authorization: Bearer $WECUBE_TOKEN" \
    --header 'Content-Type: application/json' \
    --header 'Accept-Language: zh-CN' \
    --data "$payload")
  curl_exit=$?

  if [[ $curl_exit -ne 0 ]]; then
    echo "FAILED  $guid (curl exit code: $curl_exit)" >&2
    ((failed += 1))
  elif [[ "$http_code" == "200" ]] && grep -Eq '"statusCode"[[:space:]]*:[[:space:]]*"OK"' "$response_file"; then
    echo "SUCCESS $guid"
    ((success += 1))
  else
    # WeCMDB business errors can still be returned with HTTP 200, so inspect
    # statusCode as well as the HTTP status before treating a request as done.
    response=$(tr '\n' ' ' < "$response_file")
    echo "FAILED  $guid (HTTP $http_code): $response" >&2
    ((failed += 1))
  fi
done < "$guid_file"

echo
echo "Completed: total=$total, success=$success, failed=$failed, skipped=$skipped"

if [[ $failed -gt 0 || $skipped -gt 0 ]]; then
  exit 1
fi
