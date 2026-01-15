---
name: git-workflows
description: |
  Git workflows, branching strategies, and collaboration patterns.
  Use when managing branches, resolving conflicts, or setting up workflows.
---

# Git Workflows

## Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Production fixes

## Common Commands
```bash
# Create feature branch
git checkout -b feature/feature-name develop

# Rebase on latest
git fetch origin
git rebase origin/develop

# Interactive rebase (clean up commits)
git rebase -i HEAD~3

# Squash merge
git merge --squash feature/feature-name
```

## Commit Message Format
```
type(scope): subject

body (optional)

footer (optional)
```

Types: feat, fix, docs, style, refactor, test, chore

## Conflict Resolution
1. `git status` to see conflicts
2. Edit files to resolve
3. `git add <resolved-files>`
4. `git rebase --continue` or `git merge --continue`

## Useful Aliases
```bash
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
```
