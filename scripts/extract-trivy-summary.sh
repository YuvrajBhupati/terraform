#!/usr/bin/env bash

set -euo pipefail

TRIVY_FILE="${1:-trivy-results.json}"
OUTPUT_FILE="${GITHUB_OUTPUT:-/tmp/trivy-output}"

DATA='[
  .Results[].Vulnerabilities[]?,
  .Results[].Misconfigurations[]?,
  .Results[].Secrets[]?
]'

CRITICAL=$(jq "$DATA | map(select(.Severity==\"CRITICAL\")) | length" "$TRIVY_FILE")
HIGH=$(jq "$DATA | map(select(.Severity==\"HIGH\")) | length" "$TRIVY_FILE")
MEDIUM=$(jq "$DATA | map(select(.Severity==\"MEDIUM\")) | length" "$TRIVY_FILE")
LOW=$(jq "$DATA | map(select(.Severity==\"LOW\")) | length" "$TRIVY_FILE")
UNKNOWN=$(jq "$DATA | map(select(.Severity==\"UNKNOWN\")) | length" "$TRIVY_FILE")

TOP_ISSUES=$(jq -r "
$DATA
| map(
    \"### 🔒 \(.Severity // \\\"N/A\\\") - \(.ID // .VulnerabilityID // \\\"N/A\\\")\n\" +
    \"**Title:** \(.Title // .Message // \\\"N/A\\\")\n\" +
    \"**Package:** \(.PkgName // \\\"N/A\\\") | **Installed:** \(.InstalledVersion // \\\"N/A\\\") | **Fixed:** \(.FixedVersion // \\\"N/A\\\")\n\" +
    \"**Link:** \(.PrimaryURL // \\\"N/A\\\")\"
  )
| join(\"\n\n---\n\n\")
" "$TRIVY_FILE")

ALLOWED_LICENSES="MIT|Apache-2.0|BSD-2-Clause|BSD-3-Clause|ISC"

DISALLOWED_LIST=$(jq -r '
  .Results[].Packages[]?
  | select(.Licenses != null)
  | select((.Licenses | join(",")) | test("'"$ALLOWED_LICENSES"'") | not)
  | "❌ **Package:** \(.Name)\n" +
    "   - License: \(.Licenses | join(","))\n" +
    "   - Version: \(.Version // "N/A")\n" +
    "   - Reason: Not in allowed license list\n" +
    "   - Action: Replace or get approval\n"
' "$TRIVY_FILE")

DISALLOWED_COUNT=$(echo "$DISALLOWED_LIST" | grep -c "❌" || true)

RUN_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-unknown}/actions/runs/${GITHUB_RUN_ID:-0}"

{
  echo "critical=$CRITICAL"
  echo "high=$HIGH"
  echo "medium=$MEDIUM"
  echo "low=$LOW"
  echo "unknown=$UNKNOWN"
  echo "disallowed_count=$DISALLOWED_COUNT"
  echo "run_url=$RUN_URL"

  echo "issues<<EOF"
  echo "$TOP_ISSUES"
  echo "EOF"

  echo "disallowed<<EOF"
  echo "$DISALLOWED_LIST"
  echo "EOF"
} >> "$OUTPUT_FILE"
