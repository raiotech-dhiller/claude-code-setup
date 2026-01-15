# Auto-Handoff Triggered

⚠️ **Context window is at high capacity.**

## Immediate Actions

1. **Quick State Capture**:
   - Current task (one line)
   - Last file being edited
   - Any uncommitted insights

2. **Generate Full Handoff**:
   - Create HANDOFF.md with all sections
   - Include ALL failed approaches
   - Document exact error messages

3. **Knowledge Extraction**:
   - Patterns discovered this session
   - Gotchas for skills/CLAUDE.md
   - Decisions and rationale

4. **Propose Updates** (if any):
   - Skill updates
   - CLAUDE.md updates
   - Wait for approval

## Output Format

```
## Quick Status
- Task: [one line]
- File: [last file:line]
- Blocker: [if any]

## HANDOFF.md Created
[Confirm file written]

## Proposed Knowledge Updates
[If any patterns worth preserving]

## Next Steps
Run /clear, then `claude --continue`
```
