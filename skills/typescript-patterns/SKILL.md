---
name: typescript-patterns
description: |
  TypeScript best practices, type patterns, and strict mode compliance.
  Use when working with TypeScript, defining types, or solving type errors.
---

# TypeScript Patterns

## Strict Mode Essentials
- Always enable strict mode
- Never use `any` (use `unknown` if needed)
- Define return types explicitly
- Use type guards for narrowing

## Useful Patterns
```typescript
// Discriminated unions
type Result<T> = 
  | { success: true; data: T }
  | { success: false; error: Error };

// Type guards
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}

// Utility types
type Readonly<T> = { readonly [K in keyof T]: T[K] };
type Partial<T> = { [K in keyof T]?: T[K] };
type Required<T> = { [K in keyof T]-?: T[K] };

// Branded types for type safety
type UserId = string & { readonly brand: unique symbol };
function createUserId(id: string): UserId {
  return id as UserId;
}
```

## Common Fixes
- "Object is possibly undefined" → Optional chaining or type guard
- "Type 'X' is not assignable" → Check type compatibility
- "Property does not exist" → Add to interface or use type assertion
