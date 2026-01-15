Review accumulated insights and integrate valuable ones.

## Process

1. **Scan** insight directories:
   - `~/.claude/insights/sessions/`
   - `.claude/insights/`

2. **Categorize** by type:
   - Bug fixes with root cause
   - Performance optimizations
   - Pattern implementations
   - Configuration learnings
   - Dependency discoveries

3. **Evaluate** preservation value:
   - **High**: Prevents future bugs or saves significant time
   - **Medium**: Useful reference, not critical
   - **Low**: One-off, not reusable

4. **Propose integration** for high-value:
   - Add to existing skill
   - Update CLAUDE.md
   - Create new skill

5. **Identify skill gaps**:
   - What patterns keep appearing without a skill?
   - What domains need dedicated knowledge?
   - What client work could be templatized?

6. **Archive** processed insights

## Output

### High-Value Insights
```markdown
### Insight: [title]
**Source**: [session/file]
**Category**: [type]
**Value**: High

**Context**: [what happened]
**Integration**: [where to add]
**Content**: [exact text]
```

### Proposed New Skills
```markdown
### New Skill: [name]
**Justification**: [why needed]
**Trigger Keywords**: [invocation words]
**Initial Scope**: [what it covers]
```

---

Awaiting approval before changes.
