---
name: monitoring-observability
description: |
  Monitoring and observability patterns for web applications.
  Use when setting up Sentry error tracking, LogRocket session replay,
  configuring analytics, or implementing logging infrastructure.
  Covers performance monitoring, alerting, and debugging tools.
---

# Monitoring and Observability

## The Three Pillars

| Pillar | Purpose | Tools |
|--------|---------|-------|
| **Logs** | Discrete events | Structured logging, CloudWatch |
| **Metrics** | Aggregated measurements | Prometheus, CloudWatch Metrics |
| **Traces** | Request flow | OpenTelemetry, X-Ray |

## Sentry Error Tracking

### Installation

```bash
# React/Next.js
npm install @sentry/react

# Node.js
npm install @sentry/node

# React Native
npm install @sentry/react-native
```

### React Setup

```typescript
// sentry.ts
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.NEXT_PUBLIC_APP_VERSION,

  // Performance monitoring
  tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,

  // Session replay (optional)
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
  integrations: [
    Sentry.replayIntegration({
      maskAllText: false,
      blockAllMedia: false,
    }),
  ],

  // Filter events
  beforeSend(event, hint) {
    // Don't send errors from development
    if (process.env.NODE_ENV === "development") {
      console.error("Sentry event:", event);
      return null;
    }

    // Filter out known non-issues
    const error = hint.originalException;
    if (error?.message?.includes("ResizeObserver")) {
      return null;
    }

    return event;
  },
});
```

### Error Boundaries

```tsx
import * as Sentry from "@sentry/react";

// Wrap your app
function App() {
  return (
    <Sentry.ErrorBoundary
      fallback={({ error, resetError }) => (
        <ErrorFallback error={error} onReset={resetError} />
      )}
      onError={(error, componentStack) => {
        console.error("Error boundary caught:", error);
      }}
    >
      <Router />
    </Sentry.ErrorBoundary>
  );
}

// Or use as HOC
const ProtectedComponent = Sentry.withErrorBoundary(MyComponent, {
  fallback: <ErrorFallback />,
});
```

### Manual Error Capture

```typescript
import * as Sentry from "@sentry/react";

// Capture exception with context
try {
  await riskyOperation();
} catch (error) {
  Sentry.captureException(error, {
    tags: {
      feature: "checkout",
      paymentProvider: "stripe",
    },
    extra: {
      orderId: order.id,
      cartItems: cart.items.length,
    },
    user: {
      id: user.id,
      email: user.email,
    },
  });
}

// Capture message
Sentry.captureMessage("User reached rate limit", {
  level: "warning",
  tags: { endpoint: "/api/search" },
});

// Set user context globally
Sentry.setUser({
  id: user.id,
  email: user.email,
  subscription: user.plan,
});

// Add breadcrumb for debugging
Sentry.addBreadcrumb({
  category: "navigation",
  message: `Navigated to ${path}`,
  level: "info",
});
```

### Performance Monitoring

```typescript
// Automatic instrumentation
Sentry.init({
  integrations: [
    Sentry.browserTracingIntegration(),
  ],
  tracesSampleRate: 0.1,
});

// Manual spans
const span = Sentry.startSpan(
  { name: "database.query", op: "db" },
  () => {
    return database.query(sql);
  }
);

// Transaction for complex operations
const transaction = Sentry.startTransaction({
  name: "processOrder",
  op: "task",
});

try {
  const span1 = transaction.startChild({ op: "validate" });
  await validateOrder(order);
  span1.finish();

  const span2 = transaction.startChild({ op: "payment" });
  await processPayment(order);
  span2.finish();
} finally {
  transaction.finish();
}
```

## LogRocket Session Replay

### Setup

```typescript
// logrocket.ts
import LogRocket from "logrocket";

LogRocket.init("your-app-id/your-project", {
  console: {
    isEnabled: true,
    shouldAggregateConsoleErrors: true,
  },
  network: {
    isEnabled: true,
    requestSanitizer: (request) => {
      // Sanitize sensitive headers
      if (request.headers.Authorization) {
        request.headers.Authorization = "[REDACTED]";
      }
      return request;
    },
    responseSanitizer: (response) => {
      // Sanitize sensitive response data
      return response;
    },
  },
  dom: {
    inputSanitizer: true,  // Mask all inputs
    textSanitizer: true,   // Mask text content
  },
});

// Identify user
LogRocket.identify(user.id, {
  name: user.name,
  email: user.email,
  plan: user.subscription,
});
```

### Integration with Sentry

```typescript
import LogRocket from "logrocket";
import * as Sentry from "@sentry/react";

LogRocket.getSessionURL((sessionURL) => {
  Sentry.configureScope((scope) => {
    scope.setExtra("logrocket_session", sessionURL);
  });
});
```

### Custom Events

```typescript
// Track user actions
LogRocket.track("Purchase Completed", {
  orderId: order.id,
  amount: order.total,
  items: order.items.length,
});

// Log important events
LogRocket.log("Checkout started", { cartId: cart.id });
LogRocket.warn("Payment retry needed", { attempt: 2 });
LogRocket.error("Payment failed", { error: error.message });
```

## Analytics

### Google Analytics 4

```typescript
// gtag.ts
export const GA_TRACKING_ID = process.env.NEXT_PUBLIC_GA_ID;

// Track page views
export function pageview(url: string) {
  window.gtag("config", GA_TRACKING_ID, {
    page_path: url,
  });
}

// Track events
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

// E-commerce tracking
export function purchase(transaction: {
  transactionId: string;
  value: number;
  currency: string;
  items: Array<{
    id: string;
    name: string;
    price: number;
    quantity: number;
  }>;
}) {
  window.gtag("event", "purchase", {
    transaction_id: transaction.transactionId,
    value: transaction.value,
    currency: transaction.currency,
    items: transaction.items,
  });
}
```

### Next.js Integration

```tsx
// _app.tsx
import { useEffect } from "react";
import { useRouter } from "next/router";
import * as gtag from "../lib/gtag";

function MyApp({ Component, pageProps }) {
  const router = useRouter();

  useEffect(() => {
    const handleRouteChange = (url: string) => {
      gtag.pageview(url);
    };
    router.events.on("routeChangeComplete", handleRouteChange);
    return () => {
      router.events.off("routeChangeComplete", handleRouteChange);
    };
  }, [router.events]);

  return <Component {...pageProps} />;
}
```

### PostHog Analytics

```typescript
// posthog.ts
import posthog from "posthog-js";

posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY, {
  api_host: "https://app.posthog.com",
  capture_pageview: false,  // Manual control
  capture_pageleave: true,
  autocapture: true,
});

// Identify user
posthog.identify(user.id, {
  email: user.email,
  name: user.name,
  plan: user.subscription,
});

// Track events
posthog.capture("feature_used", {
  feature: "export",
  format: "csv",
});

// Feature flags
if (posthog.isFeatureEnabled("new-checkout")) {
  // Show new checkout
}
```

## Structured Logging

### Winston (Node.js)

```typescript
// logger.ts
import winston from "winston";

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: "api",
    version: process.env.APP_VERSION,
  },
  transports: [
    new winston.transports.Console({
      format:
        process.env.NODE_ENV === "development"
          ? winston.format.combine(
              winston.format.colorize(),
              winston.format.simple()
            )
          : winston.format.json(),
    }),
  ],
});

// Usage
logger.info("User logged in", {
  userId: user.id,
  method: "oauth",
  provider: "google",
});

logger.error("Payment failed", {
  error: error.message,
  orderId: order.id,
  amount: order.total,
});
```

### Request Logging Middleware

```typescript
// requestLogger.ts
import { Request, Response, NextFunction } from "express";
import logger from "./logger";

export function requestLogger(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const start = Date.now();

  res.on("finish", () => {
    const duration = Date.now() - start;

    logger.info("HTTP Request", {
      method: req.method,
      path: req.path,
      status: res.statusCode,
      duration,
      userAgent: req.get("user-agent"),
      ip: req.ip,
      userId: req.user?.id,
    });
  });

  next();
}
```

## Performance Monitoring

### Web Vitals

```typescript
// webVitals.ts
import { getCLS, getFID, getFCP, getLCP, getTTFB } from "web-vitals";

type Metric = {
  name: string;
  value: number;
  rating: "good" | "needs-improvement" | "poor";
};

function sendToAnalytics(metric: Metric) {
  // Send to your analytics endpoint
  fetch("/api/vitals", {
    method: "POST",
    body: JSON.stringify(metric),
    headers: { "Content-Type": "application/json" },
  });

  // Or send to Google Analytics
  gtag("event", metric.name, {
    event_category: "Web Vitals",
    value: Math.round(metric.value),
    event_label: metric.rating,
    non_interaction: true,
  });
}

// Measure Core Web Vitals
getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);
```

### API Performance Tracking

```typescript
// apiMetrics.ts
const apiMetrics = new Map<string, number[]>();

export function trackApiCall(
  endpoint: string,
  duration: number,
  success: boolean
) {
  const key = `${endpoint}:${success ? "success" : "error"}`;
  const times = apiMetrics.get(key) || [];
  times.push(duration);

  // Keep last 100 measurements
  if (times.length > 100) times.shift();
  apiMetrics.set(key, times);
}

export function getApiStats(endpoint: string) {
  const successTimes = apiMetrics.get(`${endpoint}:success`) || [];
  const errorTimes = apiMetrics.get(`${endpoint}:error`) || [];

  return {
    successRate:
      successTimes.length /
      (successTimes.length + errorTimes.length),
    avgDuration:
      successTimes.reduce((a, b) => a + b, 0) / successTimes.length,
    p95Duration: percentile(successTimes, 95),
  };
}
```

## Alerting Patterns

### Alert Levels

| Level | Response Time | Examples |
|-------|---------------|----------|
| **Critical** | Immediate | Service down, data loss |
| **High** | < 1 hour | Payment failures, auth issues |
| **Medium** | < 4 hours | Elevated error rates |
| **Low** | Next business day | Performance degradation |

### Sentry Alerts

```yaml
# sentry.yml (project settings)
alerts:
  - name: High Error Rate
    conditions:
      - type: event_frequency
        value: 100
        interval: 1h
    actions:
      - type: slack
        channel: "#alerts"
      - type: pagerduty
        severity: high

  - name: New Error Type
    conditions:
      - type: first_seen_event
    actions:
      - type: slack
        channel: "#errors"
```

### Custom Alert Webhook

```typescript
// alertWebhook.ts
interface AlertPayload {
  level: "critical" | "high" | "medium" | "low";
  title: string;
  message: string;
  metadata?: Record<string, unknown>;
}

async function sendAlert(alert: AlertPayload) {
  // Slack
  await fetch(process.env.SLACK_WEBHOOK_URL, {
    method: "POST",
    body: JSON.stringify({
      text: `[${alert.level.toUpperCase()}] ${alert.title}`,
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `*${alert.title}*\n${alert.message}`,
          },
        },
      ],
    }),
  });

  // PagerDuty for critical
  if (alert.level === "critical") {
    await fetch("https://events.pagerduty.com/v2/enqueue", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        routing_key: process.env.PAGERDUTY_KEY,
        event_action: "trigger",
        payload: {
          summary: alert.title,
          severity: "critical",
          source: "api",
        },
      }),
    });
  }
}
```

## Dashboard Patterns

### Key Metrics to Track

```markdown
## Application Health
- Error rate (target: < 1%)
- Response time p50, p95, p99
- Uptime percentage
- Active users

## Business Metrics
- Conversion rate
- Revenue per session
- Feature adoption
- User retention

## Infrastructure
- CPU/Memory utilization
- Database connections
- Queue depth
- Cache hit rate
```

### Grafana Dashboard JSON

```json
{
  "panels": [
    {
      "title": "Error Rate",
      "type": "stat",
      "targets": [
        {
          "expr": "sum(rate(http_requests_total{status=~\"5..\"}[5m])) / sum(rate(http_requests_total[5m])) * 100"
        }
      ],
      "thresholds": {
        "steps": [
          { "color": "green", "value": 0 },
          { "color": "yellow", "value": 1 },
          { "color": "red", "value": 5 }
        ]
      }
    }
  ]
}
```

## References

- `references/sentry-setup.md` - Complete Sentry configuration guide
- `references/analytics-patterns.md` - Analytics implementation patterns
