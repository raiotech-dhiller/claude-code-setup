Initialize Claude Code configuration for this project.

## Actions

1. **Create directory structure**:
```bash
mkdir -p .claude/{agents,skills,commands,handoffs,insights/decisions}
```

2. **Analyze project** to detect:
   - Tech stack (package.json, requirements.txt, etc.)
   - Existing README
   - Directory structure

3. **Generate project CLAUDE.md** with template:

```markdown
# [Project Name]

## Tech Stack
- **Frontend**: [detected]
- **Backend**: [detected]
- **Database**: [detected]
- **Hosting**: [detected]

## Directory Structure
[Key directories and purposes]

## Commands
- `npm run dev`: [description]
- `npm run build`: [description]
- `npm run test`: [description]

## Environment Variables
[List from .env.example]

## Project Conventions
[Coding standards, naming conventions]

## Architecture Decisions
See `.claude/insights/decisions/`

## Team Notes
[Team-specific information]
```

4. **Create project .gitignore additions**:
```
# Claude Code
HANDOFF.md
.claude/settings.local.json
```

5. **Suggest project-specific agents/skills** if patterns detected

---

Output generated CLAUDE.md for review before saving.
