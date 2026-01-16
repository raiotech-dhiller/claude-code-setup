# Global Development Preferences

## About Me
- Fullstack developer running a digital solutions agency
- Primary stack: React, React Native, TypeScript, Supabase, AWS/GCP, WordPress
- Clients have diverse needs; flexibility is essential
- Prefer functional programming, clean architecture, and type safety

---

## Self-Improvement Protocol

### When to Propose Updates
After completing significant work, evaluate:

1. **New Skills**: Did I use domain knowledge that should be reusable?
   - Novel patterns discovered
   - Repeated workflows that could be templated
   - External API integrations worth documenting

2. **CLAUDE.md Updates**: Did I learn something project-wide?
   - New conventions established
   - Pitfalls to avoid
   - Dependencies or tools added

3. **Agent Improvements**: Did an agent struggle with something?
   - Missing tools it needed
   - System prompt gaps
   - Better description for auto-delegation

4. **New Skill Proposals**: Should a new skill be created?
   - Emerging pattern used 3+ times
   - Complex domain requiring dedicated knowledge
   - Client-specific expertise worth capturing

### Approval Workflow
1. **Propose**: Show the exact change as a code block
2. **Explain**: Why this improvement helps
3. **Scope**: Personal (`~/.claude/`) or project (`.claude/`)?
4. **Wait**: I will say "approved" or provide feedback
5. **Never auto-execute configuration changes**

### Knowledge Accumulation Triggers
- After fixing a non-trivial bug → Log insight
- After implementing a new pattern → Consider skill update
- After repeated corrections → Update relevant CLAUDE.md
- At end of significant task → Run /project:reflect
- Weekly → Run /project:knowledge-review

---

## Context Management Protocol

### Automatic Monitoring
- Status line displays current context usage percentage
- Warnings appear at 70%, alerts at 80%, critical at 90%

### When Context Reaches 80%
1. Alert appears in status line
2. Run `/project:handoff` to generate HANDOFF.md
3. Fill in any missing sections (especially "Failed Approaches")
4. Run `/clear` to start fresh session
5. SessionStart hook automatically loads handoff on resume

### Handoff Requirements
ALWAYS include in HANDOFF.md:
- **Failed approaches** with specific reasons (prevents repeating mistakes)
- **Exact error messages** for any blockers
- **File:line references** for code locations
- **Session insights** worth preserving

### Resuming Work
After `/clear` or starting new session:
1. Handoff loads automatically via SessionStart hook
2. Say "continue from handoff" to resume
3. Verify state matches handoff before proceeding

---

## Code Style Preferences

### General
- TypeScript strict mode, no `any` types
- Functional programming approaches preferred
- Comprehensive error handling with typed errors
- JSDoc comments for public functions
- Prefer composition over inheritance

### React/React Native
- Functional components with hooks exclusively
- Custom hooks for reusable logic
- Proper memoization for performance
- Error boundaries for data-fetching components

### Backend/Database
- RLS policies on ALL Supabase tables
- Parameterized queries always
- Proper connection pooling awareness
- Migrations for all schema changes

### Infrastructure
- Infrastructure as code (no manual console changes)
- Blue-green deployments for zero downtime
- Comprehensive logging and monitoring
- Least-privilege IAM policies

---

## Verification Requirements

After code changes:
1. Type check: `npx tsc --noEmit` or project-specific command
2. Lint: `npm run lint` or `eslint .`
3. Test: Run relevant test suites
4. Format: Ensure consistent formatting

---

## Communication Style
- Be direct and concise
- Explain tradeoffs when relevant
- Ask clarifying questions upfront rather than assuming
- For complex tasks, present a plan before executing
- For multi-agent work, use the orchestrator

---

## Multi-Agent Workflow

### When to Use Orchestrator
- Complex tasks spanning multiple domains (frontend + backend + infra)
- Large features requiring parallel work streams
- Tasks benefiting from specialist expertise

### Delegation Pattern
- Orchestrator creates plan and divides work
- Each specialist receives only context they need
- Results synthesized by orchestrator
- Knowledge updates proposed after completion

### Parallel Execution
- Use git worktrees for full isolation
- Each worktree gets its own Claude instance
- Orchestrator coordinates via shared HANDOFF.md or scratchpad files

## Insight Logging

When you discover something worth preserving:
1. **During work**: Mention "I'll note this insight about [topic]"
2. **Log format** (append to `~/.claude/insights/sessions/YYYY-MM-DD.md`):

```
## [HH:MM] Brief Title
**Category**: bug-fix | pattern | decision | optimization | dependency
**Context**: [What was being worked on]
**Discovery**: [What was learned]
**Reusability**: high | medium | low
**Integration Target**: [skill name | CLAUDE.md section | new skill]
```

3. **Review trigger**: After significant tasks, suggest `/project:reflect`