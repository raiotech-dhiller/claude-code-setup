---
name: performance-optimization
description: |
  Performance optimization patterns for web applications.
  Use when optimizing load times, bundle sizes, or runtime performance.
---

# Performance Optimization

## Frontend Performance
```typescript
// Code splitting
const Component = lazy(() => import('./Component'));

// Memoization
const memoizedValue = useMemo(() => expensiveComputation(a, b), [a, b]);
const memoizedCallback = useCallback(() => doSomething(a), [a]);

// Virtual scrolling for large lists
import { FixedSizeList } from 'react-window';
```

## Bundle Optimization
```javascript
// Dynamic imports
const module = await import('./heavy-module');

// Tree shaking (use ES modules)
import { specificFunction } from 'library'; // Good
import * as library from 'library'; // Bad for tree shaking
```

## Image Optimization
- Use WebP/AVIF formats
- Responsive images with srcset
- Lazy loading for below-fold images
- CDN for static assets

## Caching Strategies
```typescript
// Cache-Control headers
res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');

// Service Worker caching
// ETags for validation
// Redis for server-side caching
```

## Metrics to Track
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- Time to Interactive (TTI)
- Cumulative Layout Shift (CLS)
- First Input Delay (FID)
