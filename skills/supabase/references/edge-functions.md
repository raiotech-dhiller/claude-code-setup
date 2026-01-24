# Supabase Edge Functions

## Setup

### Local Development

```bash
# Install Supabase CLI
npm install -g supabase

# Initialize project (if not done)
supabase init

# Create new function
supabase functions new my-function

# Serve locally
supabase functions serve

# Serve with env vars
supabase functions serve --env-file .env.local
```

### Project Structure

```
supabase/
├── functions/
│   ├── _shared/           # Shared code between functions
│   │   ├── cors.ts
│   │   ├── db.ts
│   │   └── auth.ts
│   ├── my-function/
│   │   └── index.ts
│   └── another-function/
│       └── index.ts
├── migrations/
└── config.toml
```

---

## Basic Function Structure

### Hello World

```typescript
// supabase/functions/hello/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const { name } = await req.json();

  const data = {
    message: `Hello ${name}!`,
  };

  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
  });
});
```

### With CORS

```typescript
// supabase/functions/_shared/cors.ts
export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// supabase/functions/my-function/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { data } = await req.json();

    return new Response(JSON.stringify({ success: true, data }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
```

---

## Authentication

### Verify JWT

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Get auth header
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response(JSON.stringify({ error: "No auth header" }), {
      status: 401,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  // Create client with user's token
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    {
      global: {
        headers: { Authorization: authHeader },
      },
    }
  );

  // Get user from token
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    return new Response(JSON.stringify({ error: "Invalid token" }), {
      status: 401,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  // User is authenticated
  return new Response(JSON.stringify({ userId: user.id }), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});
```

### Service Role Access

```typescript
// For admin operations, use service role key
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

// Bypass RLS
const { data, error } = await supabaseAdmin
  .from("profiles")
  .select("*")
  .eq("id", userId);
```

---

## Database Access

### Query Database

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    {
      global: {
        headers: { Authorization: req.headers.get("Authorization")! },
      },
    }
  );

  // Query with RLS applied
  const { data, error } = await supabase
    .from("posts")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(10);

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
  });
});
```

### Transaction Pattern

```typescript
// Use service role for transactions
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

// Call a database function for transaction
const { data, error } = await supabaseAdmin.rpc("transfer_credits", {
  from_user: senderId,
  to_user: receiverId,
  amount: 100,
});
```

---

## External API Calls

### Fetch External API

```typescript
serve(async (req) => {
  const { query } = await req.json();

  // Call external API
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
    },
    body: JSON.stringify({
      model: "gpt-4",
      messages: [{ role: "user", content: query }],
    }),
  });

  const data = await response.json();

  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
  });
});
```

### Webhook Handler

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@12.0.0?target=deno";

const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
  apiVersion: "2022-11-15",
});

const cryptoProvider = Stripe.createSubtleCryptoProvider();

serve(async (req) => {
  const signature = req.headers.get("Stripe-Signature");
  const body = await req.text();

  let event;
  try {
    event = await stripe.webhooks.constructEventAsync(
      body,
      signature!,
      Deno.env.get("STRIPE_WEBHOOK_SECRET")!,
      undefined,
      cryptoProvider
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 400,
    });
  }

  switch (event.type) {
    case "checkout.session.completed":
      const session = event.data.object;
      // Handle successful payment
      await handlePayment(session);
      break;
    case "customer.subscription.deleted":
      const subscription = event.data.object;
      // Handle cancellation
      await handleCancellation(subscription);
      break;
  }

  return new Response(JSON.stringify({ received: true }), {
    headers: { "Content-Type": "application/json" },
  });
});
```

---

## Scheduled Functions

### Cron Triggers

```typescript
// supabase/functions/daily-cleanup/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  // Verify it's from Supabase scheduler
  const authHeader = req.headers.get("Authorization");
  if (authHeader !== `Bearer ${Deno.env.get("CRON_SECRET")}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  // Cleanup old records
  const { error } = await supabase
    .from("sessions")
    .delete()
    .lt("expires_at", new Date().toISOString());

  if (error) {
    console.error("Cleanup failed:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
    });
  }

  return new Response(JSON.stringify({ success: true }), {
    headers: { "Content-Type": "application/json" },
  });
});
```

### Set Up Cron via pg_cron

```sql
-- Enable extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule function call
SELECT cron.schedule(
  'daily-cleanup',
  '0 3 * * *',  -- 3 AM daily
  $$
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/daily-cleanup',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.cron_secret'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
```

---

## Error Handling

### Structured Errors

```typescript
// supabase/functions/_shared/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code: string = "INTERNAL_ERROR"
  ) {
    super(message);
  }
}

export function handleError(error: unknown) {
  if (error instanceof AppError) {
    return new Response(
      JSON.stringify({
        error: error.message,
        code: error.code,
      }),
      {
        status: error.statusCode,
        headers: { "Content-Type": "application/json" },
      }
    );
  }

  console.error("Unexpected error:", error);
  return new Response(
    JSON.stringify({
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    }),
    {
      status: 500,
      headers: { "Content-Type": "application/json" },
    }
  );
}

// Usage
serve(async (req) => {
  try {
    // ...
    if (!data) {
      throw new AppError("Not found", 404, "NOT_FOUND");
    }
    // ...
  } catch (error) {
    return handleError(error);
  }
});
```

---

## Environment Variables

### Local Development

```bash
# .env.local
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
OPENAI_API_KEY=sk-xxx
STRIPE_SECRET_KEY=sk_test_xxx
```

### Production Secrets

```bash
# Set secrets (one at a time)
supabase secrets set OPENAI_API_KEY=sk-xxx

# Set from file
supabase secrets set --env-file .env.production

# List secrets
supabase secrets list
```

### Access in Function

```typescript
const apiKey = Deno.env.get("OPENAI_API_KEY");

// Built-in variables (always available)
const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
```

---

## Deployment

### Deploy Single Function

```bash
supabase functions deploy my-function
```

### Deploy All Functions

```bash
supabase functions deploy
```

### Deploy with Import Map

```typescript
// import_map.json
{
  "imports": {
    "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2",
    "shared/": "./supabase/functions/_shared/"
  }
}
```

```bash
supabase functions deploy --import-map import_map.json
```

---

## Testing

### Local Testing

```bash
# Start local Supabase
supabase start

# Serve functions
supabase functions serve

# Test with curl
curl -i --location --request POST \
  'http://localhost:54321/functions/v1/my-function' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"name":"test"}'
```

### Unit Tests

```typescript
// supabase/functions/my-function/index.test.ts
import { assertEquals } from "https://deno.land/std@0.168.0/testing/asserts.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

Deno.test("my-function returns correct data", async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!
  );

  const { data, error } = await supabase.functions.invoke("my-function", {
    body: { name: "Test" },
  });

  assertEquals(error, null);
  assertEquals(data.message, "Hello Test!");
});
```

```bash
# Run tests
deno test --allow-net --allow-env supabase/functions/
```

---

## Invoking from Client

### JavaScript Client

```typescript
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Invoke function
const { data, error } = await supabase.functions.invoke("my-function", {
  body: { name: "World" },
});

// With options
const { data, error } = await supabase.functions.invoke("my-function", {
  body: { name: "World" },
  headers: {
    "x-custom-header": "value",
  },
});
```

### Direct HTTP Call

```typescript
const response = await fetch(
  "https://your-project.supabase.co/functions/v1/my-function",
  {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${session.access_token}`,
    },
    body: JSON.stringify({ name: "World" }),
  }
);

const data = await response.json();
```

---

## Best Practices

### 1. Keep Functions Small

```typescript
// ❌ Bad: Monolithic function
serve(async (req) => {
  // 500 lines of code handling everything
});

// ✅ Good: Focused functions
// functions/users/create/index.ts
// functions/users/update/index.ts
// functions/payments/process/index.ts
```

### 2. Use Shared Code

```typescript
// _shared/supabase.ts
export function createSupabaseClient(req: Request) {
  return createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    {
      global: {
        headers: { Authorization: req.headers.get("Authorization")! },
      },
    }
  );
}

// Usage in function
import { createSupabaseClient } from "../_shared/supabase.ts";
const supabase = createSupabaseClient(req);
```

### 3. Handle Timeouts

```typescript
// Edge functions have 60s timeout
// For long operations, use background jobs

// Quick response, process later
serve(async (req) => {
  const { taskId } = await req.json();

  // Queue task for background processing
  await queueTask(taskId);

  // Return immediately
  return new Response(JSON.stringify({ queued: true }));
});
```
