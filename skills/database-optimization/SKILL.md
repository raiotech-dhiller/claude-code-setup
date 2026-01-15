---
name: database-optimization
description: |
  Database optimization techniques for PostgreSQL and general SQL.
  Use when optimizing queries, designing indexes, or debugging performance.
---

# Database Optimization

## Index Strategies
```sql
-- B-tree (default, equality and range)
CREATE INDEX idx_users_email ON users(email);

-- Partial index (filtered rows)
CREATE INDEX idx_active_users ON users(email) WHERE active = true;

-- Composite index (multiple columns)
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at DESC);

-- Covering index (includes all needed columns)
CREATE INDEX idx_orders_covering ON orders(user_id) INCLUDE (total, status);
```

## Query Optimization
```sql
-- Use EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123;

-- Avoid SELECT *
SELECT id, name, email FROM users WHERE id = 123;

-- Use EXISTS instead of IN for large sets
SELECT * FROM orders o
WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = o.user_id AND u.active);

-- Batch operations
INSERT INTO logs (message) VALUES ('a'), ('b'), ('c');
```

## Common Issues
- Missing indexes on foreign keys
- N+1 queries (use JOINs or batch loading)
- Over-indexing (slows writes)
- Not using connection pooling
- Missing VACUUM/ANALYZE

## Connection Pooling
```typescript
// Use a connection pool
const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});
```
