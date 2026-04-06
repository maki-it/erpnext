#!/usr/bin/env bash
# Invoke easy-install.py build with the tags and options from the environment.
set -euo pipefail

: "${TAGS:?Error: required environment variable TAGS is not set.}"
: "${FRAPPE_BRANCH:?Error: required environment variable FRAPPE_BRANCH is not set.}"

SHOULD_PUSH="${SHOULD_PUSH:-false}"

CMD=(python3 easy-install.py build --apps-json apps.json --frappe-branch "$FRAPPE_BRANCH")

while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  CMD+=(--tag "$tag")
done <<< "$TAGS"

if [[ "$SHOULD_PUSH" == "true" ]]; then
  CMD+=(--push)
fi

"${CMD[@]}"
