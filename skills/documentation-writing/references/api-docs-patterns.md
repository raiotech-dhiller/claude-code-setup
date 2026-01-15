# API Documentation Patterns

## API Documentation Principles

### Essential Information for Every Endpoint
1. HTTP method and path
2. Authentication requirements
3. Request parameters (path, query, body)
4. Response format with examples
5. Error responses
6. Rate limiting info (if applicable)

## REST API Documentation

### Endpoint Structure
```markdown
### [Action] [Resource]

\`\`\`http
[METHOD] /path/to/resource/:param
\`\`\`

[Brief description of what this endpoint does]

#### Authentication
[Required auth method - link to auth section]

#### Path Parameters
| Name | Type | Description |
|------|------|-------------|
| `param` | string | [Description] |

#### Query Parameters
| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `limit` | integer | No | 20 | Max results |

#### Request Body
\`\`\`json
{
  "field": "type - description"
}
\`\`\`

#### Response
**Success (200 OK)**
\`\`\`json
{
  "example": "response"
}
\`\`\`

**Errors**
| Status | Code | Description |
|--------|------|-------------|
| 400 | `validation_error` | Invalid input |
| 404 | `not_found` | Resource doesn't exist |
```

### Authentication Documentation
```markdown
## Authentication

All API requests require authentication via Bearer token.

### Getting a Token
\`\`\`bash
curl -X POST https://api.example.com/auth/token \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "secret"}'
\`\`\`

Response:
\`\`\`json
{
  "access_token": "eyJhbG...",
  "token_type": "Bearer",
  "expires_in": 3600
}
\`\`\`

### Using the Token
Include in all requests:
\`\`\`
Authorization: Bearer eyJhbG...
\`\`\`

### Token Refresh
[Refresh flow documentation]
```

### Pagination Documentation
```markdown
## Pagination

All list endpoints support cursor-based pagination.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| `limit` | integer | Items per page (max: 100) |
| `cursor` | string | Cursor from previous response |

### Response Format
\`\`\`json
{
  "data": [...],
  "pagination": {
    "next_cursor": "abc123",
    "has_more": true
  }
}
\`\`\`

### Example: Iterating All Pages
\`\`\`typescript
async function fetchAll<T>(endpoint: string): Promise<T[]> {
  const results: T[] = [];
  let cursor: string | undefined;

  do {
    const params = new URLSearchParams({ limit: '100' });
    if (cursor) params.set('cursor', cursor);
    
    const response = await fetch(\`\${endpoint}?\${params}\`);
    const { data, pagination } = await response.json();
    
    results.push(...data);
    cursor = pagination.has_more ? pagination.next_cursor : undefined;
  } while (cursor);

  return results;
}
\`\`\`
```

### Error Handling Documentation
```markdown
## Errors

### Error Response Format
All errors return a consistent JSON structure:
\`\`\`json
{
  "error": {
    "code": "error_code",
    "message": "Human-readable description",
    "details": {}  // Optional additional context
  }
}
\`\`\`

### HTTP Status Codes
| Status | Meaning |
|--------|---------|
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing/invalid auth |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 422 | Unprocessable - Validation failed |
| 429 | Too Many Requests - Rate limited |
| 500 | Internal Error - Server issue |

### Common Error Codes
| Code | HTTP Status | Description | Resolution |
|------|-------------|-------------|------------|
| `invalid_request` | 400 | Malformed request | Check request format |
| `unauthorized` | 401 | No valid token | Authenticate first |
| `rate_limited` | 429 | Too many requests | Wait and retry |

### Error Handling Example
\`\`\`typescript
async function apiCall<T>(url: string): Promise<T> {
  const response = await fetch(url, { headers: getAuthHeaders() });
  
  if (!response.ok) {
    const { error } = await response.json();
    
    switch (response.status) {
      case 401:
        // Redirect to login
        throw new AuthError(error.message);
      case 429:
        // Implement exponential backoff
        throw new RateLimitError(error.message);
      default:
        throw new ApiError(error.code, error.message);
    }
  }
  
  return response.json();
}
\`\`\`
```

## TypeScript SDK Documentation

### Type Definitions
```markdown
## Types

### Core Types

#### User
\`\`\`typescript
interface User {
  /** Unique identifier */
  id: string;
  
  /** User's email address */
  email: string;
  
  /** Display name */
  name: string | null;
  
  /** Account creation timestamp */
  createdAt: Date;
  
  /** User's role */
  role: 'admin' | 'member' | 'viewer';
}
\`\`\`

#### CreateUserInput
\`\`\`typescript
interface CreateUserInput {
  /** Required: User's email */
  email: string;
  
  /** Optional: Display name */
  name?: string;
  
  /** Optional: Initial role (default: 'member') */
  role?: 'admin' | 'member' | 'viewer';
}
\`\`\`
```

### Client Documentation
```markdown
## SDK Client

### Installation
\`\`\`bash
npm install @example/sdk
\`\`\`

### Initialization
\`\`\`typescript
import { ExampleClient } from '@example/sdk';

const client = new ExampleClient({
  apiKey: process.env.EXAMPLE_API_KEY,
  // Optional configuration
  baseUrl: 'https://api.example.com',  // Default
  timeout: 30000,  // 30 seconds
  retries: 3,      // Retry failed requests
});
\`\`\`

### Usage Examples

#### Create a Resource
\`\`\`typescript
const user = await client.users.create({
  email: 'new@example.com',
  name: 'New User',
});
console.log(user.id);
\`\`\`

#### List with Filters
\`\`\`typescript
const activeUsers = await client.users.list({
  filter: { status: 'active' },
  limit: 50,
});

for (const user of activeUsers) {
  console.log(user.name);
}
\`\`\`

#### Handle Errors
\`\`\`typescript
import { ApiError, RateLimitError } from '@example/sdk';

try {
  await client.users.delete('user_123');
} catch (error) {
  if (error instanceof RateLimitError) {
    console.log(\`Rate limited. Retry after \${error.retryAfter}s\`);
  } else if (error instanceof ApiError) {
    console.error(\`API Error: \${error.code} - \${error.message}\`);
  }
}
\`\`\`
```

## Webhook Documentation

```markdown
## Webhooks

### Overview
Webhooks notify your application when events occur.

### Setup
1. Register webhook URL in dashboard
2. Select events to subscribe to
3. Store the signing secret

### Verifying Signatures
\`\`\`typescript
import crypto from 'crypto';

function verifyWebhook(
  payload: string,
  signature: string,
  secret: string
): boolean {
  const expected = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expected)
  );
}
\`\`\`

### Event Types
| Event | Description | Payload |
|-------|-------------|---------|
| `user.created` | New user registered | User object |
| `user.updated` | User profile changed | User object + changes |
| `user.deleted` | User account removed | User ID |

### Event Payload Structure
\`\`\`json
{
  "id": "evt_abc123",
  "type": "user.created",
  "created_at": "2024-01-15T10:00:00Z",
  "data": {
    // Event-specific payload
  }
}
\`\`\`

### Best Practices
- Respond with 200 quickly, process async
- Implement idempotency (events may be retried)
- Store event IDs to detect duplicates
- Set up alerting for failed deliveries
```

## OpenAPI/Swagger Integration

```markdown
## API Specification

### OpenAPI Document
The full API specification is available at:
- JSON: \`https://api.example.com/openapi.json\`
- YAML: \`https://api.example.com/openapi.yaml\`

### Interactive Documentation
Explore the API interactively:
- Swagger UI: \`https://api.example.com/docs\`
- Redoc: \`https://api.example.com/redoc\`

### Code Generation
Generate client SDKs from the OpenAPI spec:
\`\`\`bash
# TypeScript
npx openapi-typescript https://api.example.com/openapi.json -o types.ts

# Full client
npx openapi-generator generate -i https://api.example.com/openapi.json -g typescript-fetch -o ./client
\`\`\`
```

## Rate Limiting Documentation

```markdown
## Rate Limits

### Default Limits
| Endpoint Category | Limit | Window |
|-------------------|-------|--------|
| Read operations | 1000 | 1 minute |
| Write operations | 100 | 1 minute |
| Search | 30 | 1 minute |

### Rate Limit Headers
Every response includes:
\`\`\`
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1705312800
\`\`\`

### Handling Rate Limits
\`\`\`typescript
async function fetchWithRetry<T>(url: string): Promise<T> {
  const response = await fetch(url);
  
  if (response.status === 429) {
    const resetTime = response.headers.get('X-RateLimit-Reset');
    const waitMs = (Number(resetTime) * 1000) - Date.now();
    
    await new Promise(resolve => setTimeout(resolve, waitMs));
    return fetchWithRetry(url);
  }
  
  return response.json();
}
\`\`\`
```
