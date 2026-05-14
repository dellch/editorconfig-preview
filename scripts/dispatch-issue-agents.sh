#!/bin/bash
# Dispatch an implement-issue agent for each open issue in the specified
# milestone that isn't already being worked on (no linked open PR).
# Each agent becomes its own background session visible in agent view.
#
# Usage: ./scripts/dispatch-issue-agents.sh [milestone]
# Default milestone: "v0.1.0 - MVP"

set -euo pipefail

REPO="dellch/editorconfig-preview"
MILESTONE="${1:-v0.1.0 - MVP}"

echo "Checking issues in milestone: $MILESTONE"

gh issue list --repo "$REPO" --milestone "$MILESTONE" --state open --json number,title --jq '.[] | @base64' | while read -r encoded; do
  num=$(echo "$encoded" | base64 -d | jq -r '.number')
  title=$(echo "$encoded" | base64 -d | jq -r '.title')

  # Check if there's already an open PR that closes this issue
  linked_pr=$(gh pr list --repo "$REPO" --state open --search "closes #$num" --json number --jq 'length')

  if [ "$linked_pr" -gt 0 ]; then
    echo "Issue #$num ($title): open PR already exists, skipping"
    continue
  fi

  echo "Issue #$num ($title): dispatching agent"
  claude --agent implement-issue --bg "Implement issue #$num ($title) in repository $REPO."
done
