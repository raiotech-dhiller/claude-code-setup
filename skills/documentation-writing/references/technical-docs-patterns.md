# Technical Documentation Patterns

## Audience Definition

### Developer Characteristics
- Technical background assumed
- Looking for specific information quickly
- Will test/implement based on docs
- Appreciate depth and precision
- May be internal team or external developers

## Documentation Types

### Architecture Documentation

#### System Overview
```markdown
# [System Name] Architecture

## Overview
[High-level description of what the system does]

## System Context
[How this system fits into the larger ecosystem]

\`\`\`
[ASCII diagram or Mermaid diagram of system boundaries]
\`\`\`

## Key Components
| Component | Purpose | Technology |
|-----------|---------|------------|
| [Name]    | [What it does] | [Stack] |

## Data Flow
[Describe how data moves through the system]

## Dependencies
- **[Dependency]**: [Why needed, version requirements]

## Related
- [Link to component docs]
- [Link to API docs]
```

#### Architecture Decision Record (ADR)
```markdown
# [NNNN] [Decision Title]

**Date**: YYYY-MM-DD
**Status**: [Proposed | Accepted | Deprecated | Superseded by NNNN]
**Deciders**: [Who was involved]

## Context
[What is the issue that we're seeing that is motivating this decision or change?]

## Decision Drivers
- [Driver 1]
- [Driver 2]

## Considered Options
1. [Option 1]
2. [Option 2]
3. [Option 3]

## Decision Outcome
Chosen option: "[Option N]", because [justification].

### Positive Consequences
- [Benefit 1]
- [Benefit 2]

### Negative Consequences
- [Drawback 1]
- [Mitigation strategy]

## Pros and Cons of Options

### Option 1: [Name]
- ✓ [Pro]
- ✗ [Con]

### Option 2: [Name]
...

## Links
- [Related ADR or document]
```

### API Documentation

#### REST Endpoint Documentation
```markdown
# [Resource Name] API

Base URL: `https://api.example.com/v1`

## Authentication
[How to authenticate - link to auth doc]

## Endpoints

### List [Resources]
\`\`\`http
GET /resources
\`\`\`

**Query Parameters**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `limit` | integer | No | Max items to return (default: 20, max: 100) |
| `offset` | integer | No | Number of items to skip |
| `filter` | string | No | Filter expression |

**Response**
\`\`\`json
{
  "data": [
    {
      "id": "res_123",
      "name": "Example",
      "created_at": "2024-01-15T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 100,
    "limit": 20,
    "offset": 0
  }
}
\`\`\`

**Error Responses**
| Status | Code | Description |
|--------|------|-------------|
| 400 | `invalid_filter` | Filter expression is malformed |
| 401 | `unauthorized` | Missing or invalid authentication |

### Create [Resource]
\`\`\`http
POST /resources
\`\`\`

**Request Body**
\`\`\`json
{
  "name": "string, required",
  "description": "string, optional",
  "config": {
    "option": "value"
  }
}
\`\`\`

**Response** (201 Created)
\`\`\`json
{
  "data": {
    "id": "res_456",
    "name": "New Resource",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
\`\`\`
```

#### Function/Method Documentation
```markdown
## `functionName(param1, param2, options?)`

[Brief description of what the function does]

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `param1` | `string` | Yes | [Description] |
| `param2` | `number` | Yes | [Description] |
| `options` | `Options` | No | Configuration options |

#### Options Object
\`\`\`typescript
interface Options {
  timeout?: number;      // Request timeout in ms (default: 5000)
  retries?: number;      // Number of retry attempts (default: 3)
  onProgress?: (p: number) => void;  // Progress callback
}
\`\`\`

### Returns
`Promise<Result>` - [Description of return value]

\`\`\`typescript
interface Result {
  success: boolean;
  data?: ResponseData;
  error?: Error;
}
\`\`\`

### Example
\`\`\`typescript
const result = await functionName('input', 42, {
  timeout: 10000,
  onProgress: (p) => console.log(\`\${p}% complete\`)
});

if (result.success) {
  console.log(result.data);
}
\`\`\`

### Throws
- `ValidationError` - When param1 is empty
- `TimeoutError` - When request exceeds timeout

### Notes
- [Important implementation detail]
- [Performance consideration]
```

### Database Documentation

#### Schema Documentation
```markdown
# Database Schema

## Overview
[Brief description of database purpose and structure]

## Entity Relationship Diagram
\`\`\`mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "ordered in"
\`\`\`

## Tables

### users
[Description of table purpose]

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | uuid | No | gen_random_uuid() | Primary key |
| email | varchar(255) | No | - | Unique email address |
| created_at | timestamptz | No | now() | Creation timestamp |
| metadata | jsonb | Yes | '{}' | Flexible metadata |

**Indexes**
- `users_pkey` - Primary key on `id`
- `users_email_key` - Unique index on `email`
- `users_created_at_idx` - Index for sorting by creation date

**RLS Policies**
\`\`\`sql
-- Users can only see their own record
CREATE POLICY "Users can view own record" ON users
  FOR SELECT USING (auth.uid() = id);
\`\`\`

### Related Tables
- [orders](#orders) - User's orders
- [profiles](#profiles) - Extended user data
```

### Development Workflow Documentation

#### Setup Guide
```markdown
# Development Setup

## Prerequisites
- Node.js 18+
- pnpm 8+
- Docker (for local services)
- [Other requirements]

## Quick Start
\`\`\`bash
# Clone repository
git clone [repo-url]
cd [project]

# Install dependencies
pnpm install

# Set up environment
cp .env.example .env.local
# Edit .env.local with your values

# Start local services
docker-compose up -d

# Run database migrations
pnpm db:migrate

# Start development server
pnpm dev
\`\`\`

## Environment Variables
| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `API_KEY` | Yes | External service API key |
| `DEBUG` | No | Enable debug logging |

## Project Structure
\`\`\`
src/
├── components/     # React components
├── lib/           # Utility functions
├── pages/         # Next.js pages
└── types/         # TypeScript types
\`\`\`

## Common Tasks

### Running Tests
\`\`\`bash
pnpm test          # Run all tests
pnpm test:watch    # Watch mode
pnpm test:coverage # With coverage report
\`\`\`

### Database Operations
\`\`\`bash
pnpm db:migrate    # Run migrations
pnpm db:seed       # Seed test data
pnpm db:reset      # Reset database
\`\`\`

## Troubleshooting

### Port already in use
\`\`\`bash
# Find and kill process on port 3000
lsof -i :3000
kill -9 [PID]
\`\`\`

### Database connection issues
[Common fixes]
```

## Code Example Guidelines

### Good Code Examples
```typescript
// ✓ Includes necessary imports
import { useState, useEffect } from 'react';
import { fetchUser } from '@/lib/api';

// ✓ Shows complete, working code
// ✓ Uses realistic variable names
// ✓ Includes error handling
export function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetchUser(userId)
      .then(setUser)
      .catch(setError);
  }, [userId]);

  if (error) return <div>Error: {error.message}</div>;
  if (!user) return <div>Loading...</div>;
  
  return <div>{user.name}</div>;
}
```

### Bad Code Examples
```typescript
// ✗ Missing imports
// ✗ Incomplete code (won't run)
// ✗ No error handling
// ✗ Unclear variable names
const x = useState();
// ... do something
```

## Keeping Docs Updated

### Triggers for Doc Updates
- New API endpoint added
- Function signature changed
- New configuration option
- Behavior change
- Bug fix that changes documented behavior
- Deprecation

### Documentation Review Checklist
- [ ] All code examples tested and working
- [ ] No references to removed features
- [ ] Version numbers current
- [ ] Links not broken
- [ ] Types match actual implementation
