#!/bin/bash
# Real-time context window monitoring with color-coded warnings

# Read JSON from stdin (Claude Code pipes status data here)
read -r status_json

# Extract metrics
used_pct=$(echo "$status_json" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
total_tokens=$(echo "$status_json" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null)
model=$(echo "$status_json" | jq -r '.model // "unknown"' 2>/dev/null)

# Convert to integer for comparison
used_int=${used_pct%.*}

# Define thresholds
WARN_THRESHOLD=70
ALERT_THRESHOLD=80
CRITICAL_THRESHOLD=90

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Build status indicator
if [ "$used_int" -ge "$CRITICAL_THRESHOLD" ]; then
    indicator="${RED}█${NC}"
    message="⚠️  CRITICAL: ${used_pct}% - HANDOFF NOW! Run: /project:handoff"
elif [ "$used_int" -ge "$ALERT_THRESHOLD" ]; then
    indicator="${RED}▓${NC}"
    message="⚠️  HIGH: ${used_pct}% - Prepare handoff. Run: /project:handoff"
elif [ "$used_int" -ge "$WARN_THRESHOLD" ]; then
    indicator="${YELLOW}▒${NC}"
    message="📊 Context: ${used_pct}% - Consider handoff soon"
else
    indicator="${GREEN}░${NC}"
    message=""
fi

# Output status line
echo -e "${indicator} ${used_pct}% | ${model}"

# Output warning to stderr
if [ -n "$message" ]; then
    echo -e "$message" >&2
fi

# Log for analysis
echo "$(date +%Y-%m-%dT%H:%M:%S) | ${used_pct}% | ${total_tokens} tokens | ${model}" >> ~/.claude/insights/context-log.txt
