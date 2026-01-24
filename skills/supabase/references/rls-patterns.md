# Supabase Row Level Security Patterns

## RLS Fundamentals

### Enable RLS

```sql
-- Always enable RLS on tables with user data
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

-- Force RLS for table owner too (important for testing)
ALTER TABLE public.posts FORCE ROW LEVEL SECURITY;
```

### Policy Structure

```sql
CREATE POLICY "policy_name"
  ON table_name
  FOR [ALL | SELECT | INSERT | UPDATE | DELETE]
  TO [role_name | PUBLIC | authenticated | anon]
  USING (condition)        -- For SELECT, UPDATE, DELETE
  WITH CHECK (condition);  -- For INSERT, UPDATE
```

---

## Common Patterns

### User Owns Row

```sql
-- Users can only see their own data
CREATE POLICY "Users can view own data"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Users can insert their own data
CREATE POLICY "Users can insert own data"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own data
CREATE POLICY "Users can update own data"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own data
CREATE POLICY "Users can delete own data"
  ON public.profiles
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
```

### Public Read, Authenticated Write

```sql
-- Anyone can read
CREATE POLICY "Public read access"
  ON public.posts
  FOR SELECT
  TO PUBLIC
  USING (published = true);

-- Only authenticated users can write
CREATE POLICY "Authenticated users can create"
  ON public.posts
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = author_id);
```

### Organization/Team Based Access

```sql
-- Users can access data from their organization
CREATE POLICY "Org members can view"
  ON public.projects
  FOR SELECT
  TO authenticated
  USING (
    organization_id IN (
      SELECT org_id FROM public.org_members
      WHERE user_id = auth.uid()
    )
  );

-- Or with a join (can be more efficient)
CREATE POLICY "Org members can view"
  ON public.projects
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.org_members
      WHERE org_members.org_id = projects.organization_id
        AND org_members.user_id = auth.uid()
    )
  );
```

### Role-Based Access

```sql
-- Create roles enum
CREATE TYPE user_role AS ENUM ('admin', 'member', 'viewer');

-- Add role to org_members
ALTER TABLE public.org_members ADD COLUMN role user_role DEFAULT 'member';

-- Helper function
CREATE OR REPLACE FUNCTION get_user_role(org_id uuid)
RETURNS user_role AS $$
  SELECT role FROM public.org_members
  WHERE org_id = $1 AND user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER;

-- Admin-only actions
CREATE POLICY "Admins can delete"
  ON public.projects
  FOR DELETE
  TO authenticated
  USING (
    get_user_role(organization_id) = 'admin'
  );

-- Members can update
CREATE POLICY "Members can update"
  ON public.projects
  FOR UPDATE
  TO authenticated
  USING (
    get_user_role(organization_id) IN ('admin', 'member')
  )
  WITH CHECK (
    get_user_role(organization_id) IN ('admin', 'member')
  );
```

---

## Advanced Patterns

### Hierarchical Access (Parent-Child)

```sql
-- Users who can access a project can access its tasks
CREATE POLICY "Project members can view tasks"
  ON public.tasks
  FOR SELECT
  TO authenticated
  USING (
    project_id IN (
      SELECT id FROM public.projects
      WHERE organization_id IN (
        SELECT org_id FROM public.org_members
        WHERE user_id = auth.uid()
      )
    )
  );
```

### Time-Based Access

```sql
-- Content visible after publish date
CREATE POLICY "Published content only"
  ON public.articles
  FOR SELECT
  TO PUBLIC
  USING (
    published_at IS NOT NULL
    AND published_at <= now()
  );

-- Time-limited access
CREATE POLICY "Valid subscription access"
  ON public.premium_content
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.subscriptions
      WHERE user_id = auth.uid()
        AND expires_at > now()
    )
  );
```

### Shared Access (Invitations)

```sql
-- Users can access shared resources
CREATE POLICY "Shared access"
  ON public.documents
  FOR SELECT
  TO authenticated
  USING (
    owner_id = auth.uid()
    OR id IN (
      SELECT document_id FROM public.document_shares
      WHERE shared_with = auth.uid()
    )
  );

-- Share management
CREATE POLICY "Owners can share"
  ON public.document_shares
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.documents
      WHERE id = document_id AND owner_id = auth.uid()
    )
  );
```

### Soft Delete Pattern

```sql
-- Don't show deleted rows
CREATE POLICY "Hide soft deleted"
  ON public.items
  FOR SELECT
  TO authenticated
  USING (
    deleted_at IS NULL
    AND user_id = auth.uid()
  );

-- Soft delete instead of hard delete
CREATE POLICY "Soft delete only"
  ON public.items
  FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (
    user_id = auth.uid()
    AND (
      -- Only allow updating deleted_at
      deleted_at IS NOT NULL
      OR OLD.deleted_at IS NULL
    )
  );
```

---

## Performance Optimization

### Use Indexes

```sql
-- Index columns used in RLS policies
CREATE INDEX idx_org_members_user_id ON public.org_members(user_id);
CREATE INDEX idx_org_members_org_id ON public.org_members(org_id);
CREATE INDEX idx_projects_org_id ON public.projects(organization_id);

-- Composite index for common lookups
CREATE INDEX idx_org_members_lookup
  ON public.org_members(user_id, org_id);
```

### Security Definer Functions

```sql
-- Cache role lookup in a function
CREATE OR REPLACE FUNCTION user_org_ids()
RETURNS SETOF uuid AS $$
  SELECT org_id FROM public.org_members
  WHERE user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Use in policy (more efficient than subquery)
CREATE POLICY "Org access"
  ON public.projects
  FOR SELECT
  TO authenticated
  USING (organization_id IN (SELECT user_org_ids()));
```

### Avoid N+1 in Policies

```sql
-- ❌ Bad: Subquery runs for each row
CREATE POLICY "check each row"
  ON public.items
  FOR SELECT
  USING (
    (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
  );

-- ✅ Good: Use function or EXISTS
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users
    WHERE id = auth.uid() AND role = 'admin'
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE POLICY "admin check"
  ON public.items
  FOR SELECT
  USING (user_id = auth.uid() OR is_admin());
```

---

## Testing RLS Policies

### Test as User

```sql
-- Impersonate user for testing
SET request.jwt.claim.sub = 'user-uuid-here';
SET request.jwt.claim.role = 'authenticated';

-- Run queries as that user
SELECT * FROM public.posts;

-- Reset
RESET request.jwt.claim.sub;
RESET request.jwt.claim.role;
```

### Debug Policies

```sql
-- Check which policies exist
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'your_table';

-- Check if RLS is enabled
SELECT
  relname,
  relrowsecurity,
  relforcerowsecurity
FROM pg_class
WHERE relname = 'your_table';
```

### Policy Test Query

```sql
-- Test SELECT policy
EXPLAIN (ANALYZE, COSTS OFF)
SELECT * FROM public.projects
WHERE organization_id = 'test-org-id';

-- Check if policy is being applied
SET log_statement = 'all';
SET log_min_messages = 'debug5';
```

---

## Common Mistakes

### 1. Forgetting WITH CHECK

```sql
-- ❌ Bad: USING but no WITH CHECK
CREATE POLICY "update"
  ON public.posts
  FOR UPDATE
  USING (author_id = auth.uid());
-- User could potentially update author_id to someone else's

-- ✅ Good: Both clauses
CREATE POLICY "update"
  ON public.posts
  FOR UPDATE
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

### 2. Missing Service Role Bypass

```sql
-- RLS blocks service role by default
-- Use service_role key for admin operations
-- Or create bypass policy

CREATE POLICY "service_role_bypass"
  ON public.sensitive_table
  TO service_role
  USING (true);
```

### 3. Not Handling NULL

```sql
-- ❌ Bad: NULL user_id matches NULL auth.uid()
CREATE POLICY "check"
  ON public.items
  USING (user_id = auth.uid());

-- ✅ Good: Explicit NULL handling
CREATE POLICY "check"
  ON public.items
  USING (
    user_id IS NOT NULL
    AND user_id = auth.uid()
  );
```

### 4. Leaky Joins

```sql
-- ❌ Bad: Joining through RLS-protected table
-- might still expose data through error messages
SELECT p.*, u.email
FROM public.posts p
JOIN public.users u ON p.author_id = u.id;

-- ✅ Good: Only select needed columns
-- Ensure joined tables also have proper RLS
```

---

## Migration Patterns

### Add RLS to Existing Table

```sql
-- 1. Create policies BEFORE enabling RLS
CREATE POLICY "select_policy" ON public.my_table
  FOR SELECT USING (...);

CREATE POLICY "insert_policy" ON public.my_table
  FOR INSERT WITH CHECK (...);

CREATE POLICY "update_policy" ON public.my_table
  FOR UPDATE USING (...) WITH CHECK (...);

CREATE POLICY "delete_policy" ON public.my_table
  FOR DELETE USING (...);

-- 2. Enable RLS (now safe)
ALTER TABLE public.my_table ENABLE ROW LEVEL SECURITY;

-- 3. Force RLS for owner
ALTER TABLE public.my_table FORCE ROW LEVEL SECURITY;
```

### Update Policy

```sql
-- Drop and recreate (can't alter policies)
DROP POLICY IF EXISTS "old_policy" ON public.my_table;

CREATE POLICY "new_policy"
  ON public.my_table
  FOR SELECT
  USING (new_condition);
```

---

## Quick Reference

```sql
-- Common auth functions
auth.uid()              -- Current user's UUID
auth.jwt()              -- Full JWT claims
auth.role()             -- Current role
auth.email()            -- User's email (if in JWT)

-- Policy for each operation
FOR SELECT   → USING (condition)
FOR INSERT   → WITH CHECK (condition)
FOR UPDATE   → USING (old row) WITH CHECK (new row)
FOR DELETE   → USING (condition)
FOR ALL      → USING + WITH CHECK

-- Roles
anon          -- Unauthenticated users
authenticated -- Authenticated users
service_role  -- Service/admin key
PUBLIC        -- All roles
```
