#!/bin/bash
# Generates structured HANDOFF.md template

SESSION_ID="${CLAUDE_SESSION_ID:-$(date +%s)}"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
PROJECT_NAME=$(basename "$(pwd)")

HANDOFF_FILE="./HANDOFF.md"
ARCHIVE_DIR="./.claude/handoffs"

# Archive existing handoff
if [ -f "$HANDOFF_FILE" ]; then
    mkdir -p "$ARCHIVE_DIR"
    mv "$HANDOFF_FILE" "$ARCHIVE_DIR/handoff-$(date +%Y%m%d-%H%M%S).md"
fi

cat > "$HANDOFF_FILE" << TEMPLATE
# Session Handoff

## Metadata
| Field | Value |
|-------|-------|
| Generated | ${TIMESTAMP} |
| Session ID | ${SESSION_ID} |
| Branch | ${BRANCH} |
| Project | ${PROJECT_NAME} |

---

## Current Goal
<!-- One sentence: what is the immediate objective? -->
[FILL: Current task description]

---

## Completed Work
<!-- List with file:line references -->
- [x] [FILL: Completed item] (path/to/file.ts:lines)

---

## In Progress
<!-- What's actively being worked on? -->
- [ ] [FILL: Current work item]

---

## Failed Approaches - DO NOT REPEAT
<!-- CRITICAL: Prevents wasting time on known dead ends -->
| Approach | Why It Failed |
|----------|---------------|
| [FILL: What was tried] | [FILL: Why it didn't work] |

---

## Key Decisions Made
| Decision | Rationale |
|----------|-----------|
| [FILL: Choice made] | [FILL: Why] |

---

## Current State
**Working**: [FILL: What functions correctly]

**Broken**: [FILL: What's not working + error messages]

---

## Session Insights
<!-- Learnings worth preserving -->
- [FILL: Patterns discovered, gotchas, etc.]

---

## Files Modified
| File | Changes |
|------|---------|
| [FILL: path/to/file] | [FILL: What changed] |

---

## Resume Instructions
1. [FILL: First verification step]
2. [FILL: How to check current state]
3. [FILL: Where to continue from]

---

## Environment Required
\`\`\`bash
# Required setup
[FILL: Env vars, services, etc.]
\`\`\`

---

**To resume**: \`claude --continue\` (SessionStart hook loads this automatically)
TEMPLATE

echo "✅ HANDOFF.md created at $HANDOFF_FILE"
echo "📝 Fill in [FILL] sections before running /clear"
