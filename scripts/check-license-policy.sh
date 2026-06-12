#!/usr/bin/env bash

set -euo pipefail

TRIVY_FILE="${1:-trivy-results.json}"

ALLOWED_LICENSES="MIT|Apache-2.0|BSD-2-Clause|BSD-3-Clause|ISC"

DISALLOWED=$(jq -r "
[
  .Results[].Packages[]?
  | select(.Licenses != null)
  | select(
      (.Licenses | join(\",\"))
      | test(\"$ALLOWED_LICENSES\")
      | not
    )
]
| length
" "$TRIVY_FILE")

echo "Disallowed count: $DISALLOWED"

if [ "$DISALLOWED" -gt 0 ]; then
  echo "❌ Found disallowed licenses (not in allowed list)"
  exit 1
fi

echo "✅ All licenses are compliant"
