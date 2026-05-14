#!/bin/bash
# Dispatch an address-reviews agent for each open PR that doesn't have
# an active heartbeat (< 15 min old). Each agent becomes its own
# background session visible in agent view.

set -euo pipefail

REPO="dellch/editorconfig-preview"

gh pr list --repo "$REPO" --state open --json number,title,headRefName | jq -c '.[]' | while read -r pr; do
  num=$(echo "$pr" | jq -r '.number')
  title=$(echo "$pr" | jq -r '.title')
  branch=$(echo "$pr" | jq -r '.headRefName')

  # Check for active heartbeat
  heartbeat=$(gh api "repos/$REPO/issues/$num/comments" --jq '[.[] | select(.body | test("<!-- agent-heartbeat:")) | .body] | last // empty')

  if [ -n "$heartbeat" ]; then
    timestamp=$(echo "$heartbeat" | grep -oP '(?<=agent-heartbeat: )\S+')
    heartbeat_epoch=$(date -d "$timestamp" +%s 2>/dev/null || echo 0)
    now_epoch=$(date +%s)
    age_minutes=$(( (now_epoch - heartbeat_epoch) / 60 ))

    if [ "$age_minutes" -lt 15 ]; then
      echo "PR #$num ($title): agent active (heartbeat ${age_minutes}m ago), skipping"
      continue
    else
      echo "PR #$num ($title): stale heartbeat (${age_minutes}m), dispatching new agent"
    fi
  else
    echo "PR #$num ($title): no active agent, dispatching"
  fi

  claude --agent address-reviews --bg "Work on PR #$num ($title) in repository $REPO. The branch is $branch."
done
