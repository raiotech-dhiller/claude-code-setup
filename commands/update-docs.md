# Update Documentation Command

Analyzes recent code changes and updates documentation accordingly.

## Usage
```
/project:update-docs [scope]
```

**Scope options**:
- `auto` (default) - Analyze git diff and update affected docs
- `feature:[name]` - Document a specific feature
- `api` - Update API documentation only
- `full` - Full documentation audit

## Workflow

### 1. Change Detection
```bash
# Get recent changes (since last doc update or last commit)
git diff --name-only HEAD~1
# Or for uncommitted changes
git diff --name-only
```

### 2. Impact Analysis
Categorize changed files:
- `src/components/*` → May affect user docs
- `src/api/*`, `src/lib/*` → May affect technical/API docs
- `src/pages/*` → May affect user flows
- `supabase/migrations/*` → Update schema docs
- `*.config.*` → Update setup/config docs

### 3. Documentation Tasks

For each category of changes, delegate to docs-specialist:

```markdown
Use the docs-specialist agent with this context:

**Task**: Update documentation for recent code changes
**Changes Detected**:
[List of changed files with brief description]

**Documentation Scope**:
- User docs: [yes/no based on changes]
- Technical docs: [yes/no based on changes]
- API docs: [yes/no based on changes]

**Output**: 
1. Documentation impact analysis
2. Updated/new documentation files
3. Changelog entries if user-facing
```

### 4. Verification
After docs-specialist completes:
- Verify all referenced code examples work
- Check internal links are valid
- Ensure no orphan documentation

## Integration Points

### Post-Feature Workflow
After completing feature work:
```
/project:update-docs auto
```

### In Orchestrator Plans
Orchestrator should include documentation as a synthesis step:
```markdown
### Synthesis Step
1. Merge feature branches
2. Run `/project:update-docs auto`
3. Review documentation changes
4. Commit with feature
```

### Pre-PR Checklist
Include in code review:
- [ ] Documentation updated for changes
- [ ] Changelog updated if user-facing
- [ ] API docs reflect new/changed endpoints

## Example Invocations

### After Adding a Feature
```
> /project:update-docs feature:user-authentication
```
Docs-specialist will:
1. Find all auth-related code
2. Create/update user guide for authentication
3. Document API endpoints
4. Update technical architecture docs

### After API Changes
```
> /project:update-docs api
```
Docs-specialist will:
1. Scan for API route changes
2. Update endpoint documentation
3. Verify code examples
4. Update TypeScript types documentation

### Full Audit
```
> /project:update-docs full
```
Docs-specialist will:
1. Compare all code against all docs
2. Flag outdated documentation
3. Identify missing documentation
4. Propose documentation improvements
