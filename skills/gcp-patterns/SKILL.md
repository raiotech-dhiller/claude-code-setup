---
name: gcp-patterns
description: |
  GCP infrastructure patterns for Cloud Run, Cloud Functions, and Firebase.
  Use when deploying to Google Cloud Platform, setting up serverless functions,
  configuring Firebase projects, or managing GCP infrastructure.
  Covers IAM, Cloud Storage, Pub/Sub, and Cloud SQL.
---

# GCP Infrastructure Patterns

## Cloud Run Deployment

### Basic Service Configuration

```yaml
# service.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-service
  annotations:
    run.googleapis.com/ingress: all
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/minScale: "0"
        autoscaling.knative.dev/maxScale: "10"
        run.googleapis.com/cpu-throttling: "false"
    spec:
      containerConcurrency: 80
      timeoutSeconds: 300
      containers:
        - image: gcr.io/PROJECT_ID/my-service
          ports:
            - containerPort: 8080
          resources:
            limits:
              cpu: "1"
              memory: 512Mi
          env:
            - name: NODE_ENV
              value: production
```

### Deployment Commands

```bash
# Build and push image
gcloud builds submit --tag gcr.io/PROJECT_ID/my-service

# Deploy to Cloud Run
gcloud run deploy my-service \
  --image gcr.io/PROJECT_ID/my-service \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars="NODE_ENV=production"

# Update traffic split (canary deployment)
gcloud run services update-traffic my-service \
  --to-revisions=my-service-00002=10,my-service-00001=90
```

### Cloud Run with Secrets

```bash
# Create secret
echo -n "my-api-key" | gcloud secrets create api-key --data-file=-

# Grant Cloud Run access
gcloud secrets add-iam-policy-binding api-key \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

# Deploy with secret
gcloud run deploy my-service \
  --image gcr.io/PROJECT_ID/my-service \
  --update-secrets=API_KEY=api-key:latest
```

## Cloud Functions

### HTTP Function (Gen 2)

```typescript
// index.ts
import { HttpFunction } from "@google-cloud/functions-framework";

export const helloWorld: HttpFunction = (req, res) => {
  // CORS handling
  res.set("Access-Control-Allow-Origin", "*");
  if (req.method === "OPTIONS") {
    res.set("Access-Control-Allow-Methods", "GET, POST");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    res.status(204).send("");
    return;
  }

  const name = req.query.name || req.body?.name || "World";
  res.json({ message: `Hello, ${name}!` });
};
```

### Event-Driven Function (Pub/Sub)

```typescript
// index.ts
import { CloudEvent } from "@google-cloud/functions-framework";

interface PubSubData {
  message: {
    data: string;
    attributes?: Record<string, string>;
  };
}

export const processPubSub = (event: CloudEvent<PubSubData>) => {
  const data = event.data?.message?.data;
  if (data) {
    const decoded = Buffer.from(data, "base64").toString();
    console.log(`Received: ${decoded}`);
  }
};
```

### Deployment Commands

```bash
# Deploy HTTP function
gcloud functions deploy helloWorld \
  --gen2 \
  --runtime=nodejs20 \
  --region=us-central1 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=helloWorld

# Deploy Pub/Sub function
gcloud functions deploy processPubSub \
  --gen2 \
  --runtime=nodejs20 \
  --region=us-central1 \
  --trigger-topic=my-topic \
  --entry-point=processPubSub
```

## Firebase Configuration

### Firebase Project Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init

# Common initializations
firebase init firestore   # Firestore rules and indexes
firebase init hosting     # Static hosting
firebase init functions   # Cloud Functions
firebase init storage     # Storage rules
```

### Firestore Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Authenticated users can read their own data
    match /users/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }

    // Public read, authenticated write
    match /posts/{postId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Admin only
    match /admin/{document=**} {
      allow read, write: if request.auth.token.admin == true;
    }
  }
}
```

### Firebase Hosting with Cloud Run

```json
// firebase.json
{
  "hosting": {
    "public": "dist",
    "rewrites": [
      {
        "source": "/api/**",
        "run": {
          "serviceId": "my-api",
          "region": "us-central1"
        }
      },
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

## IAM Best Practices

### Service Account Setup

```bash
# Create service account
gcloud iam service-accounts create my-service-sa \
  --display-name="My Service Account"

# Grant minimal permissions
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:my-service-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client"

# Generate key (for local development only)
gcloud iam service-accounts keys create key.json \
  --iam-account=my-service-sa@PROJECT_ID.iam.gserviceaccount.com
```

### Common Role Bindings

| Use Case | Role |
|----------|------|
| Cloud SQL access | `roles/cloudsql.client` |
| Secret access | `roles/secretmanager.secretAccessor` |
| Pub/Sub publish | `roles/pubsub.publisher` |
| Storage read | `roles/storage.objectViewer` |
| Storage write | `roles/storage.objectCreator` |
| Logging | `roles/logging.logWriter` |

## Cloud SQL Connection

### From Cloud Run

```typescript
// db.ts
import { Pool } from "pg";

// Using Unix socket (Cloud Run to Cloud SQL)
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  host: `/cloudsql/${process.env.INSTANCE_CONNECTION_NAME}`,
});

export default pool;
```

### Cloud Run Configuration

```bash
gcloud run deploy my-service \
  --add-cloudsql-instances=PROJECT:REGION:INSTANCE \
  --set-env-vars="INSTANCE_CONNECTION_NAME=PROJECT:REGION:INSTANCE"
```

## Pub/Sub Patterns

### Publisher

```typescript
import { PubSub } from "@google-cloud/pubsub";

const pubsub = new PubSub();

async function publishMessage(topicName: string, data: object) {
  const topic = pubsub.topic(topicName);
  const messageBuffer = Buffer.from(JSON.stringify(data));

  const messageId = await topic.publish(messageBuffer, {
    timestamp: new Date().toISOString(),
  });

  console.log(`Message ${messageId} published`);
  return messageId;
}
```

### Subscriber (Push)

```typescript
// Cloud Run endpoint receiving push messages
app.post("/pubsub/push", (req, res) => {
  const message = req.body.message;
  const data = Buffer.from(message.data, "base64").toString();

  console.log("Received:", JSON.parse(data));

  res.status(200).send();
});
```

## Cloud Storage

### Signed URLs

```typescript
import { Storage } from "@google-cloud/storage";

const storage = new Storage();

async function generateSignedUrl(
  bucketName: string,
  fileName: string,
  action: "read" | "write"
) {
  const [url] = await storage
    .bucket(bucketName)
    .file(fileName)
    .getSignedUrl({
      version: "v4",
      action,
      expires: Date.now() + 15 * 60 * 1000, // 15 minutes
    });

  return url;
}
```

## Monitoring and Logging

### Structured Logging

```typescript
// Cloud Run/Functions automatically parse JSON logs
function log(severity: string, message: string, context?: object) {
  console.log(
    JSON.stringify({
      severity,
      message,
      ...context,
      timestamp: new Date().toISOString(),
    })
  );
}

// Usage
log("INFO", "User logged in", { userId: "123" });
log("ERROR", "Failed to process", { error: err.message });
```

### Cloud Monitoring Alerts

```bash
# Create alert policy via gcloud
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="High Error Rate" \
  --condition-filter='resource.type="cloud_run_revision" AND metric.type="run.googleapis.com/request_count" AND metric.labels.response_code_class="5xx"'
```

## Deployment Patterns

### CI/CD with Cloud Build

```yaml
# cloudbuild.yaml
steps:
  # Run tests
  - name: "node:20"
    entrypoint: npm
    args: ["test"]

  # Build container
  - name: "gcr.io/cloud-builders/docker"
    args:
      ["build", "-t", "gcr.io/$PROJECT_ID/my-service:$COMMIT_SHA", "."]

  # Push to GCR
  - name: "gcr.io/cloud-builders/docker"
    args: ["push", "gcr.io/$PROJECT_ID/my-service:$COMMIT_SHA"]

  # Deploy to Cloud Run
  - name: "gcr.io/google.com/cloudsdktool/cloud-sdk"
    entrypoint: gcloud
    args:
      - "run"
      - "deploy"
      - "my-service"
      - "--image"
      - "gcr.io/$PROJECT_ID/my-service:$COMMIT_SHA"
      - "--region"
      - "us-central1"
      - "--platform"
      - "managed"

images:
  - "gcr.io/$PROJECT_ID/my-service:$COMMIT_SHA"
```

### Blue-Green Deployment

```bash
# Deploy new revision without traffic
gcloud run deploy my-service \
  --image gcr.io/PROJECT_ID/my-service:v2 \
  --no-traffic

# Test new revision
NEW_URL=$(gcloud run revisions describe my-service-00002 --format='value(status.url)')
curl $NEW_URL/health

# Switch traffic
gcloud run services update-traffic my-service \
  --to-latest

# Rollback if needed
gcloud run services update-traffic my-service \
  --to-revisions=my-service-00001=100
```

## Cost Optimization

- Set `minScale: 0` for non-critical services
- Use CPU throttling for background tasks
- Set appropriate memory limits (affects CPU allocation)
- Use regional resources when global isn't needed
- Enable request-based autoscaling
