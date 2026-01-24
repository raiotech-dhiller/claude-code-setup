# Sentry Setup Guide

## Installation

### React / Next.js

```bash
npx @sentry/wizard@latest -i nextjs
# Or manual install
npm install @sentry/nextjs
```

### Node.js / Express

```bash
npm install @sentry/node @sentry/profiling-node
```

### React Native

```bash
npx expo install @sentry/react-native
# Or for bare RN
npm install @sentry/react-native
npx pod-install
```

---

## Configuration

### Next.js Setup

```javascript
// sentry.client.config.js
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.NEXT_PUBLIC_VERCEL_GIT_COMMIT_SHA,

  // Sampling
  tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,

  // Integrations
  integrations: [
    Sentry.replayIntegration({
      maskAllText: false,
      blockAllMedia: false,
    }),
  ],

  // Filtering
  ignoreErrors: [
    "ResizeObserver loop limit exceeded",
    "ResizeObserver loop completed with undelivered notifications",
    "Non-Error promise rejection captured",
    /^Loading chunk \d+ failed/,
    /^Loading CSS chunk \d+ failed/,
  ],

  denyUrls: [
    /extensions\//i,
    /^chrome:\/\//i,
    /^chrome-extension:\/\//i,
  ],

  beforeSend(event, hint) {
    // Filter out specific errors
    const error = hint.originalException;
    if (error?.message?.includes("Network Error")) {
      return null;
    }

    // Add custom context
    event.tags = {
      ...event.tags,
      page_url: window.location.href,
    };

    return event;
  },
});
```

```javascript
// sentry.server.config.js
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.VERCEL_GIT_COMMIT_SHA,

  tracesSampleRate: 0.1,

  integrations: [
    Sentry.prismaIntegration(), // If using Prisma
  ],
});
```

```javascript
// next.config.js
const { withSentryConfig } = require("@sentry/nextjs");

const nextConfig = {
  // Your existing config
};

module.exports = withSentryConfig(nextConfig, {
  org: "your-org",
  project: "your-project",
  silent: true,
  widenClientFileUpload: true,
  hideSourceMaps: true,
  disableLogger: true,
});
```

### Express Setup

```javascript
// app.js
import * as Sentry from "@sentry/node";
import { ProfilingIntegration } from "@sentry/profiling-node";
import express from "express";

const app = express();

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.APP_VERSION,

  integrations: [
    new Sentry.Integrations.Http({ tracing: true }),
    new Sentry.Integrations.Express({ app }),
    new ProfilingIntegration(),
  ],

  tracesSampleRate: 0.1,
  profilesSampleRate: 0.1,
});

// Request handler MUST be first middleware
app.use(Sentry.Handlers.requestHandler());

// Tracing handler creates trace for every request
app.use(Sentry.Handlers.tracingHandler());

// Your routes
app.get("/", (req, res) => {
  res.send("Hello");
});

// Error handler MUST be before any other error middleware
app.use(Sentry.Handlers.errorHandler());

// Optional fallback error handler
app.use((err, req, res, next) => {
  res.status(500).json({ error: "Something went wrong" });
});
```

### React Native Setup

```javascript
// App.tsx
import * as Sentry from "@sentry/react-native";

Sentry.init({
  dsn: process.env.EXPO_PUBLIC_SENTRY_DSN,
  environment: __DEV__ ? "development" : "production",

  tracesSampleRate: __DEV__ ? 1.0 : 0.1,
  enableAutoSessionTracking: true,

  // Native crash handling
  enableNativeCrashHandling: true,
  attachStacktrace: true,
});

export default Sentry.wrap(App);
```

```javascript
// metro.config.js (for source maps)
const { getSentryExpoConfig } = require("@sentry/react-native/metro");

module.exports = getSentryExpoConfig(__dirname);
```

---

## Error Capturing

### Basic Capture

```javascript
import * as Sentry from "@sentry/react";

// Capture exception
try {
  riskyOperation();
} catch (error) {
  Sentry.captureException(error);
}

// Capture message
Sentry.captureMessage("User reached rate limit", "warning");
```

### With Context

```javascript
Sentry.captureException(error, {
  // Tags for filtering in UI
  tags: {
    feature: "checkout",
    payment_provider: "stripe",
    user_type: "premium",
  },

  // Extra data attached to event
  extra: {
    orderId: order.id,
    cartItems: cart.items,
    attemptNumber: retryCount,
  },

  // Fingerprint for grouping
  fingerprint: ["checkout-error", order.id],

  // Set level
  level: "error", // fatal, error, warning, info, debug
});
```

### User Context

```javascript
// Set user on login
Sentry.setUser({
  id: user.id,
  email: user.email,
  username: user.name,
  // Custom fields
  subscription: user.plan,
  companyId: user.companyId,
});

// Clear on logout
Sentry.setUser(null);
```

### Scopes

```javascript
// Configure scope for a block
Sentry.withScope((scope) => {
  scope.setTag("section", "billing");
  scope.setLevel("warning");
  scope.setExtra("billingPeriod", period);

  Sentry.captureException(error);
});

// Global scope configuration
Sentry.configureScope((scope) => {
  scope.setTag("app_version", "1.2.3");
});
```

### Breadcrumbs

```javascript
// Add manual breadcrumb
Sentry.addBreadcrumb({
  category: "auth",
  message: "User logged in",
  level: "info",
  data: {
    method: "oauth",
    provider: "google",
  },
});

// Navigation breadcrumbs (auto in React)
Sentry.addBreadcrumb({
  category: "navigation",
  message: `Navigated to ${pathname}`,
  level: "info",
});

// UI breadcrumbs
Sentry.addBreadcrumb({
  category: "ui.click",
  message: "User clicked checkout button",
  level: "info",
});
```

---

## Performance Monitoring

### Automatic Instrumentation

```javascript
Sentry.init({
  integrations: [
    Sentry.browserTracingIntegration({
      tracingOrigins: ["localhost", "api.example.com"],
    }),
  ],
  tracesSampleRate: 0.1,
});
```

### Custom Transactions

```javascript
// Start a transaction
const transaction = Sentry.startTransaction({
  name: "processOrder",
  op: "task",
  data: {
    orderId: order.id,
  },
});

try {
  // Create child spans
  const validateSpan = transaction.startChild({
    op: "validate",
    description: "Validate order data",
  });
  await validateOrder(order);
  validateSpan.finish();

  const paymentSpan = transaction.startChild({
    op: "payment",
    description: "Process payment",
  });
  await processPayment(order);
  paymentSpan.finish();

  transaction.setStatus("ok");
} catch (error) {
  transaction.setStatus("internal_error");
  throw error;
} finally {
  transaction.finish();
}
```

### Function Spans

```javascript
// Wrap function in span
const result = await Sentry.startSpan(
  {
    name: "database.query",
    op: "db.query",
    data: { query: "SELECT * FROM users" },
  },
  async () => {
    return await database.query(sql);
  }
);
```

---

## Source Maps

### Build Upload (Webpack)

```javascript
// webpack.config.js
const SentryWebpackPlugin = require("@sentry/webpack-plugin");

module.exports = {
  plugins: [
    new SentryWebpackPlugin({
      org: "your-org",
      project: "your-project",
      authToken: process.env.SENTRY_AUTH_TOKEN,
      include: "./dist",
      urlPrefix: "~/",
      release: process.env.APP_VERSION,
    }),
  ],
};
```

### CLI Upload

```bash
# Install CLI
npm install -g @sentry/cli

# Upload source maps
sentry-cli releases new $VERSION
sentry-cli releases files $VERSION upload-sourcemaps ./dist --url-prefix '~/'
sentry-cli releases finalize $VERSION
```

### Vercel Integration

```bash
# Automatic with Next.js
# Add to Vercel environment variables:
SENTRY_AUTH_TOKEN=your-token
SENTRY_ORG=your-org
SENTRY_PROJECT=your-project
```

---

## Session Replay

### Configuration

```javascript
Sentry.init({
  integrations: [
    Sentry.replayIntegration({
      // Capture 10% of all sessions
      sessionSampleRate: 0.1,

      // Capture 100% of sessions with errors
      errorSampleRate: 1.0,

      // Privacy settings
      maskAllText: false,
      maskAllInputs: true,
      blockAllMedia: false,

      // Custom masking
      mask: [".sensitive-data", "#credit-card"],
      block: [".do-not-record"],
    }),
  ],
});
```

### Privacy Controls

```html
<!-- Block element from replay -->
<div class="sentry-block">Sensitive content</div>

<!-- Mask text content -->
<div class="sentry-mask">User email here</div>

<!-- Ignore element interactions -->
<button class="sentry-ignore">Click me</button>
```

---

## Alerts and Notifications

### Issue Alerts

```yaml
# In Sentry UI: Alerts → Create Alert → Issue Alert

Conditions:
- Event occurs
- First seen event
- Regression

Filters:
- environment:production
- level:error

Actions:
- Send Slack notification
- Send email
- Create Jira ticket
```

### Metric Alerts

```yaml
# Alerts → Create Alert → Metric Alert

Metric: crash_free_rate
Threshold: < 99.5%
Time window: 1 hour

Alert me when:
- Critical: crash_free_rate < 99%
- Warning: crash_free_rate < 99.5%
```

### Slack Integration

```bash
# 1. Install Sentry Slack app in workspace
# 2. Configure in Sentry: Settings → Integrations → Slack
# 3. Set up alert rules to post to channels
```

---

## Sampling Strategies

### Dynamic Sampling

```javascript
Sentry.init({
  tracesSampler: (samplingContext) => {
    // Always sample errors
    if (samplingContext.transactionContext.name.includes("error")) {
      return 1.0;
    }

    // Sample more for important routes
    if (samplingContext.transactionContext.name === "/checkout") {
      return 0.5;
    }

    // Sample less for health checks
    if (samplingContext.transactionContext.name === "/health") {
      return 0.01;
    }

    // Default
    return 0.1;
  },
});
```

### Parent-based Sampling

```javascript
Sentry.init({
  tracesSampleRate: 0.1,

  // Continue trace if parent was sampled
  tracePropagationTargets: ["localhost", /^https:\/\/api\.example\.com/],
});
```

---

## Environment Configuration

### Development vs Production

```javascript
const isProd = process.env.NODE_ENV === "production";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  enabled: isProd, // Disable in development

  // Higher sampling in dev
  tracesSampleRate: isProd ? 0.1 : 1.0,
  replaysSessionSampleRate: isProd ? 0.1 : 0,

  // Debug mode in dev
  debug: !isProd,
});
```

### Environment Variables

```bash
# .env.local
NEXT_PUBLIC_SENTRY_DSN=https://xxx@sentry.io/123
SENTRY_AUTH_TOKEN=sntrys_xxx
SENTRY_ORG=your-org
SENTRY_PROJECT=your-project

# Vercel
# Add via Vercel dashboard or CLI
vercel env add SENTRY_AUTH_TOKEN
```

---

## Debugging

### Debug Mode

```javascript
Sentry.init({
  debug: true, // Logs to console
});
```

### Test Event

```javascript
// Send test event
Sentry.captureMessage("Test event from development", "info");

// Force error
setTimeout(() => {
  throw new Error("Test error");
}, 1000);
```

### Verify Installation

```bash
# Using Sentry CLI
sentry-cli info

# Check events are arriving
sentry-cli events list --project your-project
```
