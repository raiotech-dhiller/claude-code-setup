---
name: skill-maintenance
description: |
  Maintain skills index and verify skill integrity.
  Use when adding new skills, auditing existing skills,
  or checking for orphan references between agents and skills.
---

# Skill Maintenance

Patterns for keeping the skills ecosystem healthy and organized.

## After Adding New Skills

### Checklist

1. **Verify SKILL.md structure**
   - YAML frontmatter with `name` and `description`
   - Description includes trigger keywords
   - Content under 500 lines (use references/ for more)

2. **Update skills/INDEX.md**
   - Add to appropriate category
   - Include brief description
   - Add "Use when" trigger hints

3. **Link to relevant agents**
   - Add skill name to agent's `skills:` field
   - Consider which specialists would use it

4. **Update orchestrator if needed**
   - Only if skill implies a new specialist capability

## Verification Commands

### Count All Skills

```bash
find ~/.claude/skills -name "SKILL.md" | wc -l
```

### List Agent Skill References

```bash
grep -h "^skills:" ~/.claude/agents/*.md
```

### Verify All Referenced Skills Exist

```bash
for skill in $(grep -ho "skills:.*" ~/.claude/agents/*.md | \
  sed 's/skills://' | tr ',' '\n' | tr -d ' '); do
  if [ ! -f ~/.claude/skills/$skill/SKILL.md ]; then
    echo "MISSING: $skill"
  fi
done
```

### Find Orphan Skills (Not Referenced by Any Agent)

```bash
# List all skills
all_skills=$(find ~/.claude/skills -name "SKILL.md" -exec dirname {} \; | xargs -n1 basename)

# List referenced skills
referenced=$(grep -h "^skills:" ~/.claude/agents/*.md | \
  sed 's/skills://' | tr ',' '\n' | tr -d ' ' | sort -u)

# Find orphans
for skill in $all_skills; do
  if ! echo "$referenced" | grep -q "^${skill}$"; then
    echo "ORPHAN: $skill"
  fi
done
```

### Validate YAML Frontmatter

```bash
for skill in ~/.claude/skills/*/SKILL.md; do
  if ! head -1 "$skill" | grep -q "^---$"; then
    echo "INVALID FRONTMATTER: $skill"
  fi
done
```

## Index Categories

Skills should be categorized in `INDEX.md` under:

| Category | Examples |
|----------|----------|
| Frontend | react-patterns, accessibility-patterns |
| Backend | supabase, api-design, error-handling |
| Infrastructure | aws-deployment, gcp-patterns, docker-patterns |
| WordPress | wordpress, wordpress-elementor, woocommerce-elementor |
| Content | copywriting, ux-writing, brand-voice |
| Client | client-communication, client-onboarding |
| Mobile | react-native, expo-deployment |
| Quality | testing-strategies, security-patterns |
| Workflow | git-workflows, github-patterns, skill-generator |
| Database | supabase, database-optimization |

## Skill Naming Conventions

| Pattern | Example | Use Case |
|---------|---------|----------|
| `{tech}-patterns` | react-patterns, gcp-patterns | General patterns for a technology |
| `{tech}-{specific}` | supabase-migration-cleanup | Specific tool/workflow |
| `{domain}-{type}` | client-onboarding | Domain-specific process |
| `{action}-{target}` | skill-generator | Action-oriented utility |

## Reference File Standards

For skills with `references/` subdirectory:

- **Length**: 200-300 lines per file
- **Structure**: Concept → Examples → Configuration → Troubleshooting
- **Code blocks**: Include runnable examples
- **Tables**: Use for quick reference (commands, options)
- **Checklists**: Use for verification/audit items

## Deprecating Skills

When a skill is no longer needed:

1. Remove from all agent `skills:` fields
2. Remove from `skills/INDEX.md`
3. Delete the skill directory
4. Commit with message: `chore: Remove deprecated {skill-name} skill`

## Skill Health Audit

Run periodically to ensure ecosystem health:

```bash
echo "=== Skill Audit ==="
echo ""
echo "Total skills:"
find ~/.claude/skills -name "SKILL.md" | wc -l

echo ""
echo "Skills with references:"
find ~/.claude/skills -type d -name "references" | wc -l

echo ""
echo "Orphan skills (not in any agent):"
# Run orphan detection script above

echo ""
echo "Missing skills (referenced but don't exist):"
# Run missing skills script above
```
