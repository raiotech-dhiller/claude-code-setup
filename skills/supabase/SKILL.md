---
name: supabase
description: |
  Supabase database operations, RLS policies, Edge Functions, and migrations.
  Use when working with Supabase, PostgreSQL queries, authentication,
  real-time features, or backend logic.
---

# Supabase Development

## MCP Tools Available
- `mcp__supabase__execute_sql`: Run queries
- `mcp__supabase__apply_migration`: Deploy migrations
- `mcp__supabase__deploy_edge_function`: Deploy functions
- `mcp__supabase__get_logs`: View logs
- `mcp__supabase__list_tables`: Schema exploration

## RLS Policy Patterns
```sql
-- Enable RLS (required)
ALTER TABLE my_table ENABLE ROW LEVEL SECURITY;

-- User-owned data
CREATE POLICY "Users view own data" ON my_table
  FOR SELECT USING (auth.uid() = user_id);

-- Team-based access
CREATE POLICY "Team members view data" ON team_data
  FOR SELECT USING (
    team_id IN (
      SELECT team_id FROM team_members 
      WHERE user_id = auth.uid()
    )
  );
```

## Migration Workflow
1. Create: `supabase migration new feature_name`
2. Edit generated SQL file
3. Test: `supabase db reset`
4. Deploy: `mcp__supabase__apply_migration`

## Edge Function Pattern
```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )
  
  // Function logic
  
  return new Response(JSON.stringify({ data }), {
    headers: { "Content-Type": "application/json" }
  })
})
```

## Common Pitfalls
- Forgetting RLS → Security vulnerability
- Anon key for admin ops → Permission denied
- Unhandled realtime disconnects → Stale data
- Missing indexes → Slow queries
