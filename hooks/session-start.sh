#!/bin/bash
# Automatically loads HANDOFF.md when starting/resuming sessions

read -r hook_input
source=$(echo "$hook_input" | jq -r '.source // "startup"' 2>/dev/null)

HANDOFF_FILE="./HANDOFF.md"

if [ -f "$HANDOFF_FILE" ]; then
    handoff_content=$(cat "$HANDOFF_FILE")
    
    if echo "$handoff_content" | grep -q "\[FILL"; then
        echo "📋 HANDOFF.md found but has unfilled sections." >&2
    else
        echo "📋 Loading handoff context from previous session..." >&2
    fi
    
    escaped_content=$(echo "$handoff_content" | jq -Rs .)
    echo "{\"additionalContext\": $escaped_content}"
else
    if [ "$source" = "resume" ]; then
        echo "ℹ️  Resuming session (no HANDOFF.md found)" >&2
    fi
    echo "{}"
fi
