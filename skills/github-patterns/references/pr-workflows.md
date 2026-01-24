# PR Workflow Patterns

## PR Templates

### Standard Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->

## Summary

<!-- Brief description of what this PR does -->

## Type of Change

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Documentation update
- [ ] Refactoring (no functional changes)

## Changes Made

<!-- List the specific changes -->

-
-
-

## Testing

<!-- How was this tested? -->

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published

## Screenshots (if applicable)

<!-- Add screenshots for UI changes -->

## Related Issues

<!-- Link related issues -->

Closes #
```

### Feature Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE/feature.md -->

## Feature Summary

**What does this feature do?**


**Why is this needed?**


## Implementation Details

### Architecture Changes

<!-- Describe any architectural changes -->

### Database Changes

<!-- List any database/migration changes -->

- [ ] No database changes
- [ ] Migration included
- [ ] Seed data updated

### API Changes

<!-- List any API changes -->

- [ ] No API changes
- [ ] New endpoints added
- [ ] Existing endpoints modified
- [ ] Breaking changes (document in CHANGELOG)

## Testing Plan

### Unit Tests

- [ ] Tests for new functions/methods
- [ ] Tests for edge cases

### Integration Tests

- [ ] API endpoint tests
- [ ] Database interaction tests

### Manual Testing Steps

1.
2.
3.

## Rollout Plan

- [ ] Feature flag needed
- [ ] Gradual rollout planned
- [ ] Monitoring/alerts configured

## Documentation

- [ ] README updated
- [ ] API docs updated
- [ ] User guide updated
```

### Bug Fix Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE/bugfix.md -->

## Bug Description

**What was the bug?**


**How did it manifest?**


## Root Cause

<!-- What caused the bug? -->

## Solution

<!-- How did you fix it? -->

## Verification

### Before Fix

<!-- How to reproduce the bug -->

1.
2.
3.

### After Fix

<!-- How to verify the fix -->

1.
2.
3.

## Regression Testing

- [ ] Existing tests pass
- [ ] No new warnings
- [ ] Related functionality still works

## Related Issues

Fixes #
```

## PR Size Guidelines

### Small PRs (Preferred)

```
< 200 lines changed
Single concern/feature
Easy to review
Quick to merge
```

### Strategies for Small PRs

1. **Split by layer**
   - PR 1: Database migration
   - PR 2: Backend API
   - PR 3: Frontend UI

2. **Split by feature component**
   - PR 1: User list component
   - PR 2: User detail component
   - PR 3: User edit form

3. **Split by type**
   - PR 1: Refactoring (no behavior change)
   - PR 2: New feature
   - PR 3: Tests

### Stacked PRs

```bash
# Create base PR
git checkout -b feature/base main
# ... make changes
gh pr create --title "feat: Base implementation"

# Create dependent PR
git checkout -b feature/part2 feature/base
# ... make changes
gh pr create --base feature/base --title "feat: Part 2 (depends on #123)"

# After base merges, rebase
git checkout feature/part2
git rebase main
gh pr edit --base main
```

## Review Workflows

### Code Review Checklist

```markdown
## Reviewer Checklist

### Correctness
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Error handling appropriate
- [ ] No obvious bugs

### Design
- [ ] Fits existing architecture
- [ ] Appropriate abstractions
- [ ] Not over-engineered
- [ ] DRY where appropriate

### Readability
- [ ] Clear naming
- [ ] Understandable flow
- [ ] Appropriate comments
- [ ] No magic numbers

### Security
- [ ] No hardcoded secrets
- [ ] Input validation
- [ ] Auth checks where needed
- [ ] SQL injection safe

### Testing
- [ ] Tests are meaningful
- [ ] Good coverage
- [ ] Tests are maintainable

### Performance
- [ ] No N+1 queries
- [ ] No memory leaks
- [ ] Appropriate caching
- [ ] No blocking operations
```

### Review Comments

#### Approval

```markdown
LGTM! 🎉

This implementation is clean and well-tested. Just a minor suggestion:

> line 42: Consider extracting this to a constant for clarity

Not blocking - merge when ready.
```

#### Request Changes

```markdown
Thanks for this PR! A few things need addressing:

### Blocking

**Security Issue (line 58)**
The user input isn't sanitized before using in the query. Please use parameterized queries.

**Missing Error Handling (line 72-80)**
This async operation could fail silently. Add try/catch and appropriate error handling.

### Non-blocking

- Consider adding a test for the empty array case
- The variable name `x` could be more descriptive

Happy to re-review once the blocking issues are addressed!
```

### Auto-merge Patterns

```yaml
# .github/workflows/auto-merge.yml
name: Auto-merge Dependabot

on: pull_request

permissions:
  contents: write
  pull-requests: write

jobs:
  auto-merge:
    runs-on: ubuntu-latest
    if: github.actor == 'dependabot[bot]'
    steps:
      - name: Auto-merge minor updates
        run: gh pr merge --auto --squash "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Conventional Commits

### Format

```
type(scope): description

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that neither fixes nor adds |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks |
| `ci` | CI/CD changes |
| `build` | Build system changes |

### Examples

```bash
feat(auth): add OAuth2 login with Google

Implements Google OAuth2 authentication flow.

- Add OAuth2 callback handler
- Store tokens securely
- Add user profile sync

Closes #123

---

fix(api): handle null response from external service

The payment API occasionally returns null for the
transaction ID. This commit adds null checking and
appropriate error handling.

Fixes #456

---

refactor(components): extract Button component

No functional changes. Extracts the inline button
styling into a reusable Button component.
```

## CI Integration

### Required Checks

```yaml
# .github/workflows/pr-checks.yml
name: PR Checks

on:
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run typecheck

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
```

### PR Labeler

```yaml
# .github/labeler.yml
frontend:
  - 'src/components/**/*'
  - 'src/pages/**/*'

backend:
  - 'src/api/**/*'
  - 'src/services/**/*'

documentation:
  - '**/*.md'
  - 'docs/**/*'

dependencies:
  - 'package.json'
  - 'package-lock.json'
```

```yaml
# .github/workflows/labeler.yml
name: Labeler

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/labeler@v5
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
```

## Branch Naming

### Convention

```
type/description-in-kebab-case

Examples:
feature/user-authentication
bugfix/login-timeout
hotfix/security-patch
refactor/api-cleanup
docs/update-readme
```

### Automatic Cleanup

```yaml
# .github/workflows/cleanup.yml
name: Cleanup merged branches

on:
  pull_request:
    types: [closed]

jobs:
  cleanup:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Delete branch
        run: |
          gh api repos/${{ github.repository }}/git/refs/heads/${{ github.head_ref }} -X DELETE
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
