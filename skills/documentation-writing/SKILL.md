---
name: documentation-writing
description: |
  Core documentation writing patterns and best practices.
  Use when creating any documentation, choosing formats, structuring content,
  or establishing documentation standards for a project.
---

# Documentation Writing Patterns

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| User Docs | `references/user-docs-patterns.md` | Writing end-user content |
| Technical Docs | `references/technical-docs-patterns.md` | Writing developer content |
| API Documentation | `references/api-docs-patterns.md` | Documenting APIs |

## Documentation Types Decision Tree

```
What are you documenting?
│
├─► New feature for users
│   └─► User guide in docs/user/features/
│
├─► How to do something
│   ├─► For users → docs/user/how-to/
│   └─► For developers → docs/technical/development/
│
├─► API endpoint or function
│   └─► docs/technical/api/
│
├─► Architecture decision
│   └─► docs/technical/architecture/decisions/
│
├─► System overview
│   └─► docs/technical/architecture/
│
├─► Database changes
│   └─► docs/technical/database/
│
└─► Third-party integration
    └─► docs/technical/integrations/
```

## Writing Quality Guidelines

### Clarity Principles
1. **One idea per paragraph** - Don't combine multiple concepts
2. **Active voice** - "Click the button" not "The button should be clicked"
3. **Present tense** - "This function returns" not "This function will return"
4. **Specific over vague** - "Enter your email in the Email field" not "Enter your information"

### Structure Principles
1. **Inverted pyramid** - Most important information first
2. **Scannable headings** - Users should understand content from headings alone
3. **Progressive disclosure** - Basic info first, advanced details later
4. **Consistent depth** - Similar topics at similar detail levels

## Markdown Best Practices

### Headings
```markdown
# Page Title (one per page)
## Major Sections
### Subsections
#### Rarely needed - consider restructuring
```

### Code Blocks
```markdown
<!-- Always specify language for syntax highlighting -->
\`\`\`typescript
const example: string = "highlighted";
\`\`\`

<!-- Inline code for short references -->
Use the `useState` hook for local state.
```

### Tables
```markdown
<!-- Use for structured data with multiple attributes -->
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data     | Data     | Data     |
```

### Callouts (if supported)
```markdown
> **Note**: Important information
> **Warning**: Potential issues
> **Tip**: Helpful suggestions
```

## File Naming Conventions

### User Documentation
- `getting-started.md` - Onboarding
- `[feature-name].md` - Feature guides
- `how-to-[verb]-[noun].md` - Task guides
- `[flow-name]-flow.md` - User flows
- `faq.md` - Frequently asked questions

### Technical Documentation
- `overview.md` - High-level summaries
- `[component-name].md` - Component docs
- `[NNNN]-[kebab-case-title].md` - ADRs
- `schema.md` - Database documentation
- `setup.md`, `testing.md`, `deployment.md` - Process docs

## Cross-Referencing

### Internal Links
```markdown
<!-- Relative paths from current file -->
See [Getting Started](../getting-started.md) for initial setup.

<!-- Link to specific section -->
See [Authentication](./api/auth.md#login-endpoint) for details.
```

### Link Text Guidelines
- Use descriptive text: "See the [Authentication Guide](...)"
- Avoid "click here" or "this link"
- Keep link text short but meaningful

## Version Control for Docs

### Changelog Entry Format
```markdown
## [Version] - YYYY-MM-DD

### Added
- New feature description

### Changed
- Modified behavior description

### Fixed
- Bug fix description

### Removed
- Deprecated feature description
```

### Tracking Doc Updates
- Include last-updated date at bottom of technical docs
- Use git blame to track who changed what
- Consider doc review in PR process

## Common Anti-Patterns

### Avoid
- **Wall of text** - Break into sections with headings
- **Outdated examples** - Verify code works before publishing
- **Orphan pages** - Always link from parent/index page
- **Assumed knowledge** - Define terms or link to definitions
- **Screenshot overload** - Use sparingly, they become stale

### Fix Patterns
- Long paragraph → Break into list or multiple paragraphs
- Complex explanation → Add diagram or example
- Vague instruction → Include specific UI element names
- Missing context → Add "Before you begin" section
