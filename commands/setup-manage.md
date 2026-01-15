# Setup Management Command

Manage Claude Code configuration with Git-based version control for backup, rollback, and team sharing.

## Usage
```
/setup:init                 # Initialize Git repo in ~/.claude
/setup:save [message]       # Commit current state with message
/setup:backup [tag-name]    # Create tagged backup point
/setup:list                 # Show backup history
/setup:restore [ref]        # Restore to commit or tag
/setup:diff [ref]           # Show changes since ref
/setup:status               # Show uncommitted changes
/setup:push                 # Push to remote (GitHub)
/setup:pull                 # Pull from remote
```

## Initial Setup

### Initialize Repository
```bash
cd ~/.claude

# Initialize Git
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# Environment and secrets
.env
.env.*
*.local

# Logs
*.log
logs/

# Temp files
*.tmp
*.bak
.DS_Store

# Insights/analytics (regenerated)
insights/

# Any credentials
*credentials*
*secret*
EOF

# Initial commit
git add .
git commit -m "Initial Claude Code setup"

# Create baseline tag
git tag -a v1.0-baseline -m "Clean baseline configuration"

echo "✓ Git repository initialized"
echo "✓ Baseline tag created: v1.0-baseline"
```

### Connect to GitHub
```bash
cd ~/.claude

# Create repo on GitHub first (via web or gh cli)
# Then add remote:
git remote add origin git@github.com:USERNAME/claude-code-setup.git

# Push with tags
git push -u origin main --tags

echo "✓ Connected to GitHub"
```

## Daily Operations

### Save Changes
After making changes to agents, skills, or commands:
```bash
cd ~/.claude
git add .
git commit -m "Added copy-specialist agent and skills"
```

Commit message conventions:
```
feat: Added [agent/skill/command] for [purpose]
fix: Fixed [issue] in [file]
docs: Updated [documentation]
refactor: Reorganized [area]
```

### Create Backup Point (Tag)
Before major experiments:
```bash
cd ~/.claude
git tag -a v1.1-pre-experiment -m "Before testing new orchestrator"
git push origin --tags
```

### View History
```bash
cd ~/.claude

# See commits
git log --oneline -20

# See tags (backup points)
git tag -l

# See what changed in a file
git log --oneline -p agents/orchestrator.md
```

### Check Current Status
```bash
cd ~/.claude
git status
git diff  # See uncommitted changes
```

## Rollback Operations

### Undo Uncommitted Changes
```bash
cd ~/.claude

# Discard changes to specific file
git checkout -- agents/orchestrator.md

# Discard all uncommitted changes
git checkout -- .
```

### Rollback to Previous Commit
```bash
cd ~/.claude

# See history
git log --oneline

# Soft rollback (keeps files, undoes commit)
git reset --soft HEAD~1

# Hard rollback (reverts files to previous state)
git reset --hard HEAD~1

# Rollback to specific commit
git reset --hard abc1234
```

### Rollback to Tagged Backup
```bash
cd ~/.claude

# List tags
git tag -l

# Rollback to tag
git checkout v1.0-baseline

# If you want to make this the new main:
git checkout -b main-restored v1.0-baseline
git branch -D main
git branch -m main
```

### Restore Single File from Past
```bash
cd ~/.claude

# Restore specific file from a commit/tag
git checkout v1.0-baseline -- agents/orchestrator.md

# Restore from 3 commits ago
git checkout HEAD~3 -- skills/copywriting/SKILL.md
```

## Team Collaboration

### Share Setup with Team
```bash
cd ~/.claude

# Ensure remote is set
git remote -v

# Push current state
git push origin main --tags
```

### Team Member Setup
```bash
# Clone the shared config
git clone git@github.com:TEAM/claude-code-setup.git ~/.claude

# Or if they have existing ~/.claude:
cd ~/.claude
git remote add origin git@github.com:TEAM/claude-code-setup.git
git fetch origin
git reset --hard origin/main
```

### Pull Team Updates
```bash
cd ~/.claude

# Save local changes first
git stash

# Pull updates
git pull origin main

# Restore local changes
git stash pop
```

### Handle Conflicts
```bash
# If pull has conflicts:
git status  # See conflicted files

# Edit files to resolve conflicts, then:
git add .
git commit -m "Resolved merge conflicts"
```

## Recommended Workflow

### Daily
1. Make changes to config
2. Test changes work
3. `git add . && git commit -m "Description"`

### Weekly
1. Review uncommitted changes: `git status`
2. Commit anything pending
3. Push to remote: `git push`

### Before Experiments
1. Commit current state
2. Create tag: `git tag -a v1.x-pre-experiment -m "Before [experiment]"`
3. Push tag: `git push origin --tags`
4. Experiment freely
5. If bad: `git reset --hard v1.x-pre-experiment`
6. If good: commit and continue

### Sharing New Addition
1. Create/modify files
2. Test thoroughly
3. Commit with clear message
4. Push to remote
5. Notify team

## Quick Reference

| Task | Command |
|------|---------|
| Save changes | `git add . && git commit -m "message"` |
| Create backup point | `git tag -a v1.x-name -m "description"` |
| View history | `git log --oneline` |
| View tags | `git tag -l` |
| Undo uncommitted | `git checkout -- .` |
| Rollback to tag | `git reset --hard tag-name` |
| Push to GitHub | `git push origin main --tags` |
| Pull updates | `git pull origin main` |

## GitHub Repository Structure

When shared, your repo will look like:
```
claude-code-setup/
├── README.md              # Setup instructions for team
├── .gitignore
├── agents/
│   ├── orchestrator.md
│   ├── react-specialist.md
│   ├── copy-specialist.md
│   └── ...
├── skills/
│   ├── copywriting/
│   ├── ux-writing/
│   └── ...
├── commands/
│   ├── copy-brief.md
│   ├── setup-manage.md    # This file
│   └── ...
├── scripts/
└── hooks/
```

### Recommended README.md for Repo
```markdown
# Claude Code Team Setup

Shared Claude Code configuration for [Team/Company].

## Quick Start

\`\`\`bash
# Clone to ~/.claude
git clone git@github.com:TEAM/claude-code-setup.git ~/.claude
\`\`\`

## What's Included

- **Agents**: [list key agents]
- **Skills**: [list key skills]
- **Commands**: [list key commands]

## Contributing

1. Create a branch: `git checkout -b feature/new-agent`
2. Make changes
3. Test locally
4. Commit and push
5. Open PR for review

## Version History

See [CHANGELOG.md](CHANGELOG.md) or `git tag -l` for versions.
```

## Sensitive Data Warning

Before pushing to GitHub (especially public repos), ensure:
- [ ] No API keys in any files
- [ ] No passwords or credentials
- [ ] No client-specific data that should be private
- [ ] `.gitignore` covers sensitive patterns

Review with: `git diff --cached` before pushing.
