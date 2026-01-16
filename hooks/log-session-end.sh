#!/bin/bash
echo "$(date +%Y-%m-%dT%H:%M:%S) Session ended" >> ~/.claude/insights/sessions/$(date +%Y%m%d).log
