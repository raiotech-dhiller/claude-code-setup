# Initialize Documentation Command

Sets up documentation structure for a new project.

## Usage
```
/project:init-docs [options]
```

**Options**:
- `--user-only` - Only create user documentation structure
- `--technical-only` - Only create technical documentation structure
- `--minimal` - Create minimal structure (expand as needed)

## Default Structure Created

```
docs/
├── README.md                      # Documentation index
├── user/
│   ├── getting-started.md         # Onboarding guide (template)
│   ├── features/
│   │   └── .gitkeep
│   ├── how-to/
│   │   └── .gitkeep
│   ├── user-flows/
│   │   └── .gitkeep
│   └── faq.md                     # FAQ template
│
├── technical/
│   ├── README.md                  # Technical overview template
│   ├── architecture/
│   │   ├── overview.md            # Architecture template
│   │   └── decisions/
│   │       └── 0001-initial-architecture.md  # First ADR
│   ├── api/
│   │   └── .gitkeep
│   ├── database/
│   │   └── schema.md              # Schema doc template
│   ├── development/
│   │   ├── setup.md               # Dev setup template
│   │   ├── testing.md             # Testing guide template
│   │   └── deployment.md          # Deployment guide template
│   └── integrations/
│       └── .gitkeep
│
└── changelog.md                   # Changelog template
```

## Template Contents

### docs/README.md
```markdown
# [Project Name] Documentation

## User Documentation
- [Getting Started](./user/getting-started.md) - New user onboarding
- [Features](./user/features/) - Feature guides
- [How-To Guides](./user/how-to/) - Task-oriented guides
- [FAQ](./user/faq.md) - Frequently asked questions

## Technical Documentation
- [Architecture Overview](./technical/architecture/overview.md)
- [API Reference](./technical/api/)
- [Database Schema](./technical/database/schema.md)
- [Development Setup](./technical/development/setup.md)
- [Architecture Decisions](./technical/architecture/decisions/)

## Changelog
See [CHANGELOG](./changelog.md) for release history.
```

### docs/user/getting-started.md
```markdown
# Getting Started with [Project Name]

Welcome! This guide will help you get up and running with [Project Name].

## What You'll Need
- [Prerequisite 1]
- [Prerequisite 2]

## Quick Start

### Step 1: [First Action]
[Instructions]

### Step 2: [Second Action]
[Instructions]

## What's Next?
- [Link to first feature to explore]
- [Link to common task]
```

### docs/technical/development/setup.md
```markdown
# Development Setup

## Prerequisites
- Node.js [version]
- [Other requirements]

## Quick Start
\`\`\`bash
# Clone and install
git clone [repo]
cd [project]
npm install

# Set up environment
cp .env.example .env.local

# Start development
npm run dev
\`\`\`

## Environment Variables
| Variable | Required | Description |
|----------|----------|-------------|
| | | |

## Project Structure
\`\`\`
src/
├── 
└── 
\`\`\`

## Common Tasks
[Add as project develops]
```

### docs/technical/architecture/decisions/0001-initial-architecture.md
```markdown
# 0001 Initial Architecture

**Date**: [Today's date]
**Status**: Accepted

## Context
[Describe the initial project requirements and constraints]

## Decision
[Describe the chosen architecture]

## Consequences
- [Positive consequence]
- [Trade-off or limitation]
```

### docs/changelog.md
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup

### Changed

### Fixed

### Removed
```

## Post-Initialization

After running this command:

1. **Fill in placeholders** - Replace `[Project Name]` and other placeholders
2. **Write initial ADR** - Document your initial architecture decisions
3. **Set up dev guide** - Fill in setup.md with actual requirements
4. **Configure changelog** - Set up release workflow to update changelog

## Integration with docs-specialist

The docs-specialist agent will:
- Respect this structure when creating new docs
- Place files in appropriate directories
- Update the main README.md index when adding new docs
- Follow established templates for consistency
