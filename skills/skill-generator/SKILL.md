---
name: skill-generator
description: Create new Claude Code skills with proper structure and YAML frontmatter. Use when creating a new skill, documenting reusable knowledge, or saving solutions for future projects.
user-invocable: true
---

# Skill Generator

Use this skill to create new Claude Code skills with proper structure, naming conventions, and metadata.

## Quick Start

When creating a new skill, gather this information:

1. **Skill name**: lowercase, hyphens only (e.g., `react-testing-patterns`)
2. **Description**: What it does + trigger keywords (max 1024 chars)
3. **Scope**: Personal (`~/.claude/skills/`) or Project (`.claude/skills/`)
4. **Content**: The knowledge/instructions to save

## Skill Template

```yaml
---
name: skill-name-here
description: Brief description with trigger keywords users would naturally say when they need this skill.
---

# Skill Title

## Problem

What problem does this skill solve?

## Solution

How to solve it.

## Implementation Steps

1. Step one
2. Step two
3. Step three

## Examples

Show usage examples if applicable.

## References

- Links to documentation or resources
```

## Directory Structure

```
~/.claude/skills/           # Personal (all projects)
├── skill-name/
│   └── SKILL.md            # Required

.claude/skills/             # Project (shared via repo)
├── skill-name/
│   └── SKILL.md
```

### Multi-File Skills (for complex topics)

```
skill-name/
├── SKILL.md                # Main entry point (<500 lines)
├── reference.md            # Detailed docs (loaded on demand)
├── examples.md             # Usage examples
└── scripts/
    └── helper.sh           # Utility scripts
```

## Writing Effective Descriptions

The description determines when Claude auto-discovers your skill. Include trigger keywords users would naturally say.

### Good Descriptions

| Skill | Description |
|-------|-------------|
| `netlify-spa-routing` | Fix Netlify 404 errors for Single Page Applications. Use when deploying React, Vue, or other SPAs to Netlify and getting "Page Not Found" on direct navigation or page refresh. |
| `supabase-rls` | Set up Row Level Security policies in Supabase. Use when configuring database permissions, protecting user data, or fixing "permission denied" errors. |
| `react-query-patterns` | Implement data fetching with TanStack React Query. Use for caching, mutations, optimistic updates, or replacing useEffect fetch patterns. |

### Bad Descriptions

| Description | Problem |
|-------------|---------|
| "Helps with deployments" | Too vague, no trigger keywords |
| "Useful stuff" | No context for when to use |
| "React" | Single word, won't match user intent |

## Optional YAML Fields

```yaml
---
name: skill-name
description: Required description with trigger keywords

# Optional fields:
allowed-tools: Read, Grep, Bash(npm:*)     # Restrict available tools
model: claude-sonnet-4-20250514            # Override default model
context: fork                               # Run in isolated subagent
agent: general-purpose                      # Agent type (with fork)
user-invocable: true                        # Show in slash menu (default: true)
---
```

## Creation Checklist

- [ ] Directory name matches `name` field in YAML
- [ ] Directory uses lowercase + hyphens only
- [ ] YAML frontmatter starts on line 1 with `---`
- [ ] `name` and `description` fields present
- [ ] Description includes trigger keywords
- [ ] Content is under 500 lines (link to supporting files if needed)
- [ ] File is named exactly `SKILL.md` (case-sensitive)

## Example: Creating a New Skill

**User request:** "Save this Supabase edge function pattern for reuse"

**Steps:**

1. Create directory:
   ```bash
   mkdir -p ~/.claude/skills/supabase-edge-functions
   ```

2. Create SKILL.md with frontmatter:
   ```bash
   cat > ~/.claude/skills/supabase-edge-functions/SKILL.md << 'EOF'
   ---
   name: supabase-edge-functions
   description: Create and deploy Supabase Edge Functions. Use when building serverless APIs, handling webhooks, or adding backend logic to Supabase projects.
   ---

   # Supabase Edge Functions

   [Content here...]
   EOF
   ```

3. Verify:
   ```bash
   ls ~/.claude/skills/supabase-edge-functions/
   head -5 ~/.claude/skills/supabase-edge-functions/SKILL.md
   ```

## Skill Categories (Suggested Naming)

| Category | Naming Pattern | Example |
|----------|----------------|---------|
| Framework fixes | `{framework}-{issue}` | `netlify-spa-routing` |
| Patterns | `{tech}-{pattern}` | `react-query-patterns` |
| Integrations | `{service}-integration` | `stripe-integration` |
| Workflows | `{action}-workflow` | `pr-review-workflow` |
| Templates | `{type}-template` | `api-template` |

## Scope Decision Guide

| Choose Personal (`~/.claude/skills/`) when... | Choose Project (`.claude/skills/`) when... |
|-----------------------------------------------|---------------------------------------------|
| Knowledge applies to many projects | Knowledge is project-specific |
| Personal preferences/workflows | Team should share the knowledge |
| General development patterns | Codebase-specific conventions |
| You want it everywhere | It should be version controlled |
