---
name: react-patterns
description: |
  React development patterns, hooks, state management, and component architecture.
  Use when building React applications, creating components, implementing hooks,
  or optimizing performance. Covers React 18+ features.
---

# React Development Patterns

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Custom Hooks | `references/hooks-patterns.md` | Creating reusable hooks |
| Server Components | `references/server-components.md` | Next.js App Router |
| Testing | `references/testing-patterns.md` | Writing component tests |

## Component Structure
```typescript
interface Props {
  // Explicit prop types
}

export function ComponentName({ prop1, prop2 }: Props) {
  // 1. Hooks at top
  const [state, setState] = useState<Type>(initial);
  
  // 2. Derived state
  const derived = useMemo(() => compute(state), [state]);
  
  // 3. Effects
  useEffect(() => {
    // Side effects
  }, [dependencies]);
  
  // 4. Event handlers
  const handleEvent = useCallback(() => {
    // Handler logic
  }, [dependencies]);
  
  // 5. Render
  return <div>{/* JSX */}</div>;
}
```

## State Management Decision Tree
- **Local UI state**: `useState`
- **Complex local state**: `useReducer`
- **Shared across components**: Context or Zustand
- **Server state**: React Query / TanStack Query
- **Form state**: React Hook Form

## Performance Patterns
- `useMemo` for expensive computations
- `useCallback` for handlers passed to children
- `React.memo` for pure components
- Lazy loading for code splitting

## Anti-Patterns
- Prop drilling > 2 levels → Use context
- useEffect for derived state → Use useMemo
- Inline objects in JSX → Causes re-renders
- Missing dependencies → Stale closures
