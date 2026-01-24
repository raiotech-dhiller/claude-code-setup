# Analytics Patterns

## Event Naming Conventions

### Standard Format

```
[Object]_[Action]

Examples:
- page_viewed
- button_clicked
- form_submitted
- item_purchased
- user_signed_up
```

### Naming Rules

```markdown
## Rules
1. Use snake_case (not camelCase or kebab-case)
2. Start with noun (object)
3. End with past-tense verb (action)
4. Be specific but not too specific
5. Keep consistent across platforms

## Good Examples
- checkout_started
- checkout_completed
- product_added_to_cart
- search_performed
- filter_applied

## Bad Examples
- click (too vague)
- user_did_thing (not specific)
- productAddedToCart (wrong case)
- button-clicked (wrong separator)
```

---

## Event Taxonomy

### Core Events (Every App)

```typescript
// Session events
analytics.track("session_started");
analytics.track("session_ended", { duration: 300 });

// Page events
analytics.page("Home");
analytics.page("Product", { productId: "123" });

// User events
analytics.track("user_signed_up", { method: "email" });
analytics.track("user_logged_in", { method: "oauth", provider: "google" });
analytics.track("user_logged_out");
```

### E-commerce Events

```typescript
// Product discovery
analytics.track("product_viewed", {
  product_id: "SKU123",
  product_name: "Blue T-Shirt",
  price: 29.99,
  currency: "USD",
  category: "Apparel",
});

analytics.track("product_list_viewed", {
  list_id: "featured",
  products: [{ product_id: "SKU123", position: 1 }],
});

// Cart events
analytics.track("product_added_to_cart", {
  product_id: "SKU123",
  quantity: 1,
  price: 29.99,
});

analytics.track("cart_viewed", {
  cart_id: "CART123",
  products: [...],
  total: 89.97,
});

// Checkout events
analytics.track("checkout_started", {
  cart_id: "CART123",
  value: 89.97,
  currency: "USD",
});

analytics.track("checkout_step_completed", {
  step: 1,
  step_name: "shipping",
});

// Purchase
analytics.track("order_completed", {
  order_id: "ORD123",
  total: 99.97,
  tax: 7.50,
  shipping: 2.50,
  products: [...],
  payment_method: "credit_card",
});
```

### SaaS Events

```typescript
// Onboarding
analytics.track("onboarding_started");
analytics.track("onboarding_step_completed", { step: "profile" });
analytics.track("onboarding_completed", { duration_seconds: 120 });

// Feature usage
analytics.track("feature_used", {
  feature: "export",
  format: "csv",
  rows: 1000,
});

// Subscription
analytics.track("subscription_started", {
  plan: "pro",
  billing: "annual",
  price: 99,
});

analytics.track("subscription_upgraded", {
  from_plan: "basic",
  to_plan: "pro",
});

analytics.track("subscription_cancelled", {
  plan: "pro",
  reason: "too_expensive",
});
```

---

## Implementation Patterns

### Analytics Wrapper

```typescript
// analytics.ts
type EventProperties = Record<string, unknown>;

class Analytics {
  private providers: AnalyticsProvider[] = [];

  constructor() {
    if (process.env.NODE_ENV === "production") {
      this.providers.push(new GoogleAnalytics());
      this.providers.push(new PostHog());
      this.providers.push(new Mixpanel());
    }
  }

  identify(userId: string, traits?: Record<string, unknown>) {
    this.providers.forEach((p) => p.identify(userId, traits));
  }

  track(event: string, properties?: EventProperties) {
    const enrichedProps = {
      ...properties,
      timestamp: new Date().toISOString(),
      page_url: window.location.href,
      user_agent: navigator.userAgent,
    };

    this.providers.forEach((p) => p.track(event, enrichedProps));

    if (process.env.NODE_ENV === "development") {
      console.log("[Analytics]", event, enrichedProps);
    }
  }

  page(name: string, properties?: EventProperties) {
    this.providers.forEach((p) => p.page(name, properties));
  }
}

export const analytics = new Analytics();
```

### React Hooks

```typescript
// useAnalytics.ts
import { useCallback, useEffect } from "react";
import { usePathname } from "next/navigation";
import { analytics } from "@/lib/analytics";

export function usePageView() {
  const pathname = usePathname();

  useEffect(() => {
    analytics.page(pathname);
  }, [pathname]);
}

export function useTrack() {
  return useCallback(
    (event: string, properties?: Record<string, unknown>) => {
      analytics.track(event, properties);
    },
    []
  );
}

// Usage
function ProductPage({ product }) {
  usePageView();
  const track = useTrack();

  return (
    <button onClick={() => track("product_added_to_cart", {
      product_id: product.id
    })}>
      Add to Cart
    </button>
  );
}
```

### Event Validation

```typescript
// eventSchema.ts
import { z } from "zod";

const ProductSchema = z.object({
  product_id: z.string(),
  product_name: z.string(),
  price: z.number(),
  currency: z.string().length(3),
  category: z.string().optional(),
});

const EventSchemas = {
  product_viewed: ProductSchema,
  product_added_to_cart: ProductSchema.extend({
    quantity: z.number().positive(),
  }),
  // ... more schemas
};

export function trackValidated<T extends keyof typeof EventSchemas>(
  event: T,
  properties: z.infer<typeof EventSchemas[T]>
) {
  const schema = EventSchemas[event];
  const validated = schema.parse(properties);
  analytics.track(event, validated);
}
```

---

## Google Analytics 4

### Setup

```html
<!-- In _document.tsx or layout -->
<Script
  src={`https://www.googletagmanager.com/gtag/js?id=${GA_TRACKING_ID}`}
  strategy="afterInteractive"
/>
<Script id="google-analytics" strategy="afterInteractive">
  {`
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '${GA_TRACKING_ID}', {
      page_path: window.location.pathname,
    });
  `}
</Script>
```

### Events

```typescript
// lib/gtag.ts
export const GA_TRACKING_ID = process.env.NEXT_PUBLIC_GA_ID;

// Page view
export function pageview(url: string) {
  window.gtag("config", GA_TRACKING_ID, {
    page_path: url,
  });
}

// Custom event
export function event(
  action: string,
  category: string,
  label?: string,
  value?: number
) {
  window.gtag("event", action, {
    event_category: category,
    event_label: label,
    value: value,
  });
}

// E-commerce
export function purchase(transaction: {
  transaction_id: string;
  value: number;
  currency: string;
  items: Array<{
    item_id: string;
    item_name: string;
    price: number;
    quantity: number;
  }>;
}) {
  window.gtag("event", "purchase", transaction);
}
```

### Enhanced Measurement

```typescript
// Automatically tracked by GA4:
// - Page views
// - Scrolls
// - Outbound clicks
// - Site search
// - Video engagement
// - File downloads

// Custom dimensions
gtag("config", GA_TRACKING_ID, {
  custom_map: {
    dimension1: "user_type",
    dimension2: "subscription_plan",
  },
});

gtag("event", "page_view", {
  user_type: "premium",
  subscription_plan: "annual",
});
```

---

## PostHog

### Setup

```typescript
// posthog.ts
import posthog from "posthog-js";

if (typeof window !== "undefined") {
  posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
    api_host: "https://app.posthog.com",
    capture_pageview: false, // Manual control
    capture_pageleave: true,
    autocapture: true,
    persistence: "localStorage+cookie",
    loaded: (posthog) => {
      if (process.env.NODE_ENV === "development") {
        posthog.debug();
      }
    },
  });
}

export { posthog };
```

### Feature Flags

```typescript
// Check flag
if (posthog.isFeatureEnabled("new-checkout")) {
  return <NewCheckout />;
}

// With payload
const variant = posthog.getFeatureFlag("pricing-page");
if (variant === "test-a") {
  return <PricingA />;
} else if (variant === "test-b") {
  return <PricingB />;
}

// React hook
import { useFeatureFlagEnabled } from "posthog-js/react";

function Component() {
  const flagEnabled = useFeatureFlagEnabled("new-feature");

  if (flagEnabled) {
    return <NewFeature />;
  }
  return <OldFeature />;
}
```

### Session Recording

```typescript
posthog.init(key, {
  // Recording settings
  session_recording: {
    maskAllInputs: true,
    maskInputFn: (text, element) => {
      if (element?.dataset.maskInput === "false") {
        return text;
      }
      return "*".repeat(text.length);
    },
  },
});
```

---

## Mixpanel

### Setup

```typescript
import mixpanel from "mixpanel-browser";

mixpanel.init(process.env.NEXT_PUBLIC_MIXPANEL_TOKEN!, {
  debug: process.env.NODE_ENV === "development",
  track_pageview: true,
  persistence: "localStorage",
});

export { mixpanel };
```

### Tracking

```typescript
// Identify
mixpanel.identify(userId);
mixpanel.people.set({
  $email: user.email,
  $name: user.name,
  plan: user.subscription,
});

// Track
mixpanel.track("Button Clicked", {
  button_name: "signup",
  page: "landing",
});

// Track links
mixpanel.track_links("#nav a", "Clicked Nav Link", {
  referrer: document.referrer,
});

// Time event
mixpanel.time_event("Checkout Completed");
// ... user completes checkout
mixpanel.track("Checkout Completed"); // Duration auto-calculated
```

### Cohort Analysis

```typescript
// Super properties (sent with every event)
mixpanel.register({
  platform: "web",
  app_version: "1.2.3",
});

// Register once (persisted)
mixpanel.register_once({
  first_visit_date: new Date().toISOString(),
});

// Increment property
mixpanel.people.increment("login_count");
mixpanel.people.increment({ purchases: 1, spend: 99.99 });
```

---

## Attribution Tracking

### UTM Parameters

```typescript
// utils/attribution.ts
interface UTMParams {
  utm_source?: string;
  utm_medium?: string;
  utm_campaign?: string;
  utm_term?: string;
  utm_content?: string;
}

export function captureUTMParams(): UTMParams {
  const params = new URLSearchParams(window.location.search);
  const utm: UTMParams = {};

  ["source", "medium", "campaign", "term", "content"].forEach((key) => {
    const value = params.get(`utm_${key}`);
    if (value) {
      utm[`utm_${key}` as keyof UTMParams] = value;
    }
  });

  // Store for session
  if (Object.keys(utm).length > 0) {
    sessionStorage.setItem("utm_params", JSON.stringify(utm));
  }

  return utm;
}

export function getStoredUTM(): UTMParams {
  const stored = sessionStorage.getItem("utm_params");
  return stored ? JSON.parse(stored) : {};
}
```

### First-touch vs Last-touch

```typescript
// Track both for better attribution
function trackConversion(event: string) {
  const firstTouch = localStorage.getItem("first_touch_utm");
  const lastTouch = sessionStorage.getItem("utm_params");

  analytics.track(event, {
    first_touch: firstTouch ? JSON.parse(firstTouch) : null,
    last_touch: lastTouch ? JSON.parse(lastTouch) : null,
  });
}

// Store first touch on initial visit
function captureFirstTouch() {
  if (!localStorage.getItem("first_touch_utm")) {
    const utm = captureUTMParams();
    if (Object.keys(utm).length > 0) {
      localStorage.setItem("first_touch_utm", JSON.stringify(utm));
    }
  }
}
```

---

## Privacy and Consent

### Cookie Consent Integration

```typescript
// Only load analytics after consent
function initAnalytics() {
  if (hasAnalyticsConsent()) {
    gtag("consent", "update", {
      analytics_storage: "granted",
    });
    posthog.opt_in_capturing();
    mixpanel.opt_in_tracking();
  } else {
    gtag("consent", "default", {
      analytics_storage: "denied",
    });
    posthog.opt_out_capturing();
    mixpanel.opt_out_tracking();
  }
}

// On consent update
function updateConsent(granted: boolean) {
  if (granted) {
    gtag("consent", "update", { analytics_storage: "granted" });
    posthog.opt_in_capturing();
  } else {
    gtag("consent", "update", { analytics_storage: "denied" });
    posthog.opt_out_capturing();
    // Clear existing data
    posthog.reset();
  }
}
```

### Data Anonymization

```typescript
// Hash PII before tracking
import { createHash } from "crypto";

function hashEmail(email: string): string {
  return createHash("sha256").update(email.toLowerCase()).digest("hex");
}

analytics.identify(hashEmail(user.email), {
  // Don't include PII
  plan: user.subscription,
  signup_date: user.createdAt,
  // Hashed identifier if needed
  email_hash: hashEmail(user.email),
});
```

---

## Debugging

### Console Logging

```typescript
// Analytics debug mode
class Analytics {
  private debug = process.env.NODE_ENV === "development";

  track(event: string, properties?: EventProperties) {
    if (this.debug) {
      console.group(`[Analytics] ${event}`);
      console.log("Properties:", properties);
      console.trace("Called from:");
      console.groupEnd();
    }
    // ... actual tracking
  }
}
```

### Event Validator

```typescript
// Validate events match schema
function validateEvent(event: string, properties: unknown) {
  const schema = EventSchemas[event];
  if (!schema) {
    console.warn(`[Analytics] Unknown event: ${event}`);
    return false;
  }

  const result = schema.safeParse(properties);
  if (!result.success) {
    console.error(`[Analytics] Invalid properties for ${event}:`, result.error);
    return false;
  }

  return true;
}
```

### Testing Events

```typescript
// Jest test helper
class MockAnalytics {
  events: Array<{ event: string; properties: unknown }> = [];

  track(event: string, properties?: unknown) {
    this.events.push({ event, properties });
  }

  assertTracked(event: string, properties?: unknown) {
    const found = this.events.find(
      (e) =>
        e.event === event &&
        (!properties || JSON.stringify(e.properties) === JSON.stringify(properties))
    );
    expect(found).toBeDefined();
  }

  clear() {
    this.events = [];
  }
}
```
