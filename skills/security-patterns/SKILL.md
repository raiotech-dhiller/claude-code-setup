---
name: security-patterns
description: |
  Security patterns and best practices for web applications.
  Use when implementing authentication, authorization, or securing APIs.
---

# Security Patterns

## Authentication
```typescript
// JWT handling
const token = jwt.sign({ userId }, SECRET, { expiresIn: '1h' });
const decoded = jwt.verify(token, SECRET);

// Password hashing
const hash = await bcrypt.hash(password, 12);
const valid = await bcrypt.compare(password, hash);

// Session management
// - Rotate session IDs after login
// - Set secure, httpOnly, sameSite cookies
// - Implement session timeout
```

## Input Validation
```typescript
// Zod schema validation
const UserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  age: z.number().int().positive(),
});

// Sanitization
import DOMPurify from 'dompurify';
const clean = DOMPurify.sanitize(userInput);
```

## SQL Injection Prevention
```typescript
// Always use parameterized queries
const result = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// Never string concatenation
// BAD: `SELECT * FROM users WHERE id = ${userId}`
```

## XSS Prevention
```typescript
// React auto-escapes by default
// Avoid dangerouslySetInnerHTML
// Use Content-Security-Policy headers
// Sanitize user input before rendering
```

## CORS Configuration
```typescript
app.use(cors({
  origin: ['https://example.com'],
  methods: ['GET', 'POST'],
  credentials: true,
}));
```

## Security Headers
```typescript
app.use(helmet()); // Sets various security headers
// X-Content-Type-Options: nosniff
// X-Frame-Options: DENY
// Content-Security-Policy
// Strict-Transport-Security
```
