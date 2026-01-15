# Handoff Protocol

Context is approaching capacity. Generate a comprehensive handoff document.

## Instructions

1. **Analyze Current Session**: Review accomplishments and pending work.

2. **Generate HANDOFF.md** at `./HANDOFF.md` with ALL sections:

```markdown
# Session Handoff

## Metadata
| Field | Value |
|-------|-------|
| Generated | [timestamp] |
| Session ID | [if known] |
| Branch | [git branch] |
| Project | [name] |

## Current Goal
[One sentence objective]

## Completed Work
[List with file:line references]
- [x] Item (path/file.ts:15-30)

## In Progress
- [ ] Current task

## Failed Approaches - DO NOT REPEAT
| Approach | Why It Failed |
|----------|---------------|
| [Tried] | [Why it didn't work] |

## Key Decisions
| Decision | Rationale |
|----------|-----------|
| [Choice] | [Why] |

## Current State
**Working**: [What works]
**Broken**: [What doesn't + error messages]

## Session Insights
[Learnings worth preserving]

## Files Modified
| File | Changes |
|------|---------|
| [path] | [what changed] |

## Resume Instructions
1. [Verification step]
2. [Check state]
3. [Continue from]

## Environment Required
[Setup needed]
```

3. **Save** to `./HANDOFF.md`

4. **Inform me**:
```
✅ HANDOFF.md created with:
- [X] completed items
- [Y] pending items
- [Z] insights captured

To continue:
1. Run /clear
2. Resume: claude --continue
3. Say "continue from handoff"
```
