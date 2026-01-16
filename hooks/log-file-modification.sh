#!/bin/bash
# Logs file modification events to daily session log

LOG_DIR="$HOME/.claude/insights/sessions"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d).log"

mkdir -p "$LOG_DIR"
echo "$(date +%Y-%m-%dT%H:%M:%S) File modified" >> "$LOG_FILE"
