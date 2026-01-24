---
name: github-patterns
description: |
  Token-efficient GitHub workflows, PR patterns, and repository management.
  Use when working with GitHub via MCP, optimizing API usage, or automating
  GitHub workflows. Covers PRs, issues, releases, and Actions.
---

# GitHub Patterns

Patterns for efficient GitHub operations, especially when using the GitHub MCP server.

## Token-Efficient Operations

### Fetching PRs

```bash
# Get PR overview (minimal tokens)
gh pr view 123 --json number,title,state,author,labels

# Get PR with diff context
gh pr view 123 --json number,title,body,files,additions,deletions

# List PRs efficiently
gh pr list --json number,title,state,author --limit 10

# Get PR review status
gh pr view 123 --json reviewDecision,reviews
```

### Fetching Issues

```bash
# Get issue overview
gh issue view 456 --json number,title,state,labels,assignees

# List issues by label
gh issue list --label "bug" --json number,title,state

# Search issues
gh issue list --search "is:open label:priority"
```

## PR Workflow Patterns

### Creating PRs

```bash
# Create with body
gh pr create \
  --title "feat: Add user authentication" \
  --body "## Summary
Implements JWT-based authentication.

## Changes
- Add auth middleware
- Add login endpoint
- Add token refresh

## Test Plan
- [ ] Manual login test
- [ ] Token expiration test"

# Create from template
gh pr create --template .github/PULL_REQUEST_TEMPLATE.md

# Create draft PR
gh pr create --draft --title "WIP: New feature"
```

### PR Review Workflow

```bash
# Request review
gh pr edit 123 --add-reviewer @username

# Approve PR
gh pr review 123 --approve

# Request changes
gh pr review 123 --request-changes --body "Please fix X"

# Comment without approval/rejection
gh pr review 123 --comment --body "Looks good, minor suggestion..."
```

### Merging PRs

```bash
# Squash merge (preferred for clean history)
gh pr merge 123 --squash

# Merge with message
gh pr merge 123 --squash --body "feat: Add auth (#123)"

# Auto-merge when checks pass
gh pr merge 123 --auto --squash

# Delete branch after merge
gh pr merge 123 --squash --delete-branch
```

## Issue Workflow Patterns

### Creating Issues

```bash
# Create with labels
gh issue create \
  --title "Bug: Login fails on Safari" \
  --body "## Steps to Reproduce
1. Open app in Safari
2. Click login
3. Enter credentials

## Expected
Successful login

## Actual
Error message appears" \
  --label "bug,priority:high"

# Create from template
gh issue create --template bug_report.md
```

### Issue Management

```bash
# Close issue
gh issue close 456

# Reopen issue
gh issue reopen 456

# Add labels
gh issue edit 456 --add-label "in-progress"

# Assign
gh issue edit 456 --add-assignee @username

# Link to PR
gh issue develop 456 --checkout
```

## Release Patterns

### Creating Releases

```bash
# Create release from tag
gh release create v1.2.0 \
  --title "v1.2.0" \
  --notes "## What's New
- Feature A
- Feature B

## Bug Fixes
- Fixed issue #123"

# Generate release notes automatically
gh release create v1.2.0 --generate-notes

# Create draft release
gh release create v1.2.0 --draft

# Upload assets
gh release create v1.2.0 ./dist/app.zip ./dist/app.tar.gz
```

### Release Management

```bash
# List releases
gh release list

# View specific release
gh release view v1.2.0

# Edit release
gh release edit v1.2.0 --notes "Updated notes"

# Delete release
gh release delete v1.2.0
```

## GitHub Actions Patterns

### Workflow Triggers

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

  # Manual trigger
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
```

### Efficient Caching

```yaml
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: |
      ~/.npm
      node_modules
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

### Matrix Builds

```yaml
strategy:
  matrix:
    node: [18, 20]
    os: [ubuntu-latest, macos-latest]
  fail-fast: false

steps:
  - uses: actions/setup-node@v4
    with:
      node-version: ${{ matrix.node }}
```

### Conditional Jobs

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: npm test

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: npm run deploy
```

## Branch Protection Patterns

### Recommended Settings

```bash
# Via GitHub CLI (requires admin)
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -f required_status_checks='{"strict":true,"contexts":["test","lint"]}' \
  -f enforce_admins=true \
  -f required_pull_request_reviews='{"required_approving_review_count":1}' \
  -f restrictions=null
```

### Rulesets (Modern)

```yaml
# .github/rulesets/main.yml
name: Main branch protection
target: branch
enforcement: active
conditions:
  ref_name:
    include: [main]
rules:
  - type: pull_request
    parameters:
      required_approving_review_count: 1
      dismiss_stale_reviews_on_push: true
      require_code_owner_review: false
  - type: required_status_checks
    parameters:
      strict_required_status_checks_policy: true
      required_status_checks:
        - context: test
        - context: lint
```

## API Efficiency

### Batch Operations

```bash
# Get multiple items in one call
gh api graphql -f query='
  query {
    repository(owner: "owner", name: "repo") {
      pullRequests(first: 10, states: OPEN) {
        nodes {
          number
          title
          author { login }
        }
      }
      issues(first: 10, states: OPEN) {
        nodes {
          number
          title
          labels(first: 5) { nodes { name } }
        }
      }
    }
  }
'
```

### Pagination

```bash
# Paginate through all PRs
gh pr list --json number,title --limit 100 --state all | jq 'length'

# API pagination
gh api repos/{owner}/{repo}/pulls --paginate
```

## Common Workflows

### Feature Branch Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature main

# Work on feature...
git commit -m "feat: Add new feature"

# Push and create PR
git push -u origin feature/new-feature
gh pr create --fill

# After review, merge
gh pr merge --squash --delete-branch
```

### Hotfix Workflow

```bash
# Create from main
git checkout -b hotfix/critical-fix main

# Make fix
git commit -m "fix: Critical security issue"

# Push and create PR with priority
git push -u origin hotfix/critical-fix
gh pr create --title "URGENT: Security fix" --label "priority:critical"

# Request immediate review
gh pr edit --add-reviewer @security-team
```

### Release Workflow

```bash
# Create release branch
git checkout -b release/v1.2.0 main

# Bump version
npm version 1.2.0 --no-git-tag-version
git commit -am "chore: Bump version to 1.2.0"

# Create PR for release
gh pr create --title "Release v1.2.0" --base main

# After merge, tag and release
git checkout main && git pull
git tag v1.2.0
git push origin v1.2.0
gh release create v1.2.0 --generate-notes
```

## References

- `references/pr-workflows.md` - Detailed PR workflow patterns
