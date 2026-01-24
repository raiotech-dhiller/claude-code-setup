---
name: expo-deployment
description: |
  Expo and EAS deployment patterns for React Native apps.
  Use when building with EAS Build, submitting to app stores,
  configuring OTA updates, or managing app credentials.
  Covers iOS/Android deployment workflows.
---

# Expo Deployment

Comprehensive guide for deploying React Native apps with Expo and EAS.

## EAS CLI Setup

```bash
# Install EAS CLI
npm install -g eas-cli

# Login to Expo account
eas login

# Initialize EAS in project
eas build:configure
```

## EAS Build Configuration

### Basic `eas.json`

```json
{
  "cli": {
    "version": ">= 5.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "simulator": false
      }
    },
    "production": {}
  },
  "submit": {
    "production": {}
  }
}
```

### Advanced Configuration

```json
{
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "env": {
        "APP_ENV": "development",
        "API_URL": "https://api.dev.example.com"
      }
    },
    "staging": {
      "distribution": "internal",
      "channel": "staging",
      "env": {
        "APP_ENV": "staging",
        "API_URL": "https://api.staging.example.com"
      },
      "ios": {
        "buildConfiguration": "Release"
      },
      "android": {
        "buildType": "apk"
      }
    },
    "production": {
      "channel": "production",
      "env": {
        "APP_ENV": "production",
        "API_URL": "https://api.example.com"
      },
      "autoIncrement": true
    }
  }
}
```

## Build Commands

```bash
# Development build (with dev client)
eas build --profile development --platform ios
eas build --profile development --platform android

# Preview build (internal distribution)
eas build --profile preview --platform all

# Production build
eas build --profile production --platform all

# Check build status
eas build:list

# Download build artifacts
eas build:view --json | jq '.artifacts.buildUrl'
```

## App Configuration (`app.json`/`app.config.js`)

### Dynamic Configuration

```javascript
// app.config.js
const IS_PROD = process.env.APP_ENV === "production";

export default {
  name: IS_PROD ? "MyApp" : "MyApp (Dev)",
  slug: "my-app",
  version: "1.0.0",
  orientation: "portrait",
  icon: "./assets/icon.png",
  splash: {
    image: "./assets/splash.png",
    resizeMode: "contain",
    backgroundColor: "#ffffff",
  },
  ios: {
    bundleIdentifier: IS_PROD
      ? "com.example.myapp"
      : "com.example.myapp.dev",
    buildNumber: "1",
    supportsTablet: true,
    infoPlist: {
      NSCameraUsageDescription:
        "This app uses the camera to scan QR codes.",
    },
  },
  android: {
    package: IS_PROD
      ? "com.example.myapp"
      : "com.example.myapp.dev",
    versionCode: 1,
    adaptiveIcon: {
      foregroundImage: "./assets/adaptive-icon.png",
      backgroundColor: "#ffffff",
    },
    permissions: ["CAMERA"],
  },
  extra: {
    eas: {
      projectId: "your-project-id",
    },
    apiUrl: process.env.API_URL,
  },
  updates: {
    url: "https://u.expo.dev/your-project-id",
  },
  runtimeVersion: {
    policy: "sdkVersion",
  },
};
```

## iOS Deployment

### Credentials Setup

```bash
# Let EAS manage credentials (recommended)
eas credentials

# View existing credentials
eas credentials --platform ios

# Create new credentials
eas build --platform ios
# EAS will prompt for Apple Developer credentials
```

### Distribution Certificate & Provisioning

1. **App Store Distribution**
   - EAS creates Distribution Certificate
   - Creates App Store provisioning profile
   - Registers bundle ID automatically

2. **Internal Distribution (Ad Hoc)**
   - Registers devices via link
   - Creates Ad Hoc provisioning profile
   - Limited to 100 devices

### App Store Submission

```bash
# Configure submission
# In eas.json, ensure submit profile exists:
{
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@email.com",
        "ascAppId": "1234567890",
        "appleTeamId": "ABCDEFGHIJ"
      }
    }
  }
}

# Submit to App Store Connect
eas submit --platform ios

# Build and submit in one command
eas build --platform ios --auto-submit
```

### App Store Connect Checklist

- [ ] App icon (1024x1024 PNG, no alpha)
- [ ] Screenshots (all required sizes)
- [ ] App description
- [ ] Keywords
- [ ] Support URL
- [ ] Privacy policy URL
- [ ] Age rating questionnaire
- [ ] App category

## Android Deployment

### Credentials Setup

```bash
# Let EAS generate keystore (recommended)
eas build --platform android
# First build creates new keystore

# View keystore info
eas credentials --platform android

# Important: Download and backup keystore
eas credentials --platform android
# Select "Download credentials"
```

### Build Types

```json
// eas.json
{
  "build": {
    "preview": {
      "android": {
        "buildType": "apk"  // Direct install
      }
    },
    "production": {
      "android": {
        "buildType": "app-bundle"  // Play Store required
      }
    }
  }
}
```

### Play Store Submission

```bash
# Configure submission
{
  "submit": {
    "production": {
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "internal"  // internal, alpha, beta, production
      }
    }
  }
}

# Submit to Play Store
eas submit --platform android

# Build and submit
eas build --platform android --auto-submit
```

### Play Store Service Account

1. Go to Google Play Console
2. Setup → API access
3. Create service account
4. Grant "Release manager" permission
5. Download JSON key
6. Reference in eas.json

### Play Store Checklist

- [ ] High-res icon (512x512)
- [ ] Feature graphic (1024x500)
- [ ] Screenshots (min 2, various sizes)
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] Privacy policy URL
- [ ] Content rating questionnaire
- [ ] Target audience
- [ ] App category

## OTA Updates

### Configuration

```javascript
// app.config.js
export default {
  updates: {
    url: "https://u.expo.dev/your-project-id",
    fallbackToCacheTimeout: 30000,
  },
  runtimeVersion: {
    policy: "sdkVersion",  // or "appVersion" or custom
  },
};
```

### Publishing Updates

```bash
# Publish to all channels
eas update --branch production --message "Bug fixes"

# Publish to specific channel
eas update --branch staging --message "New feature testing"

# Check update status
eas update:list

# Rollback (publish previous commit)
eas update --branch production --message "Rollback"
```

### Runtime Version Strategies

```javascript
// SDK Version (automatic)
runtimeVersion: {
  policy: "sdkVersion"
}

// App Version (manual control)
runtimeVersion: {
  policy: "appVersion"
}

// Custom (full control)
runtimeVersion: "1.0.0"
```

### Update Hooks

```typescript
import * as Updates from "expo-updates";

async function checkForUpdates() {
  if (!Updates.isEnabled) return;

  const update = await Updates.checkForUpdateAsync();

  if (update.isAvailable) {
    await Updates.fetchUpdateAsync();
    await Updates.reloadAsync();
  }
}

// Check on app focus
import { useEffect } from "react";
import { AppState } from "react-native";

useEffect(() => {
  const subscription = AppState.addEventListener(
    "change",
    (state) => {
      if (state === "active") {
        checkForUpdates();
      }
    }
  );
  return () => subscription.remove();
}, []);
```

## Environment Variables

### Secrets in EAS

```bash
# Set secret
eas secret:create --name API_KEY --value "your-api-key" --scope project

# List secrets
eas secret:list

# Use in eas.json
{
  "build": {
    "production": {
      "env": {
        "API_KEY": "@secret:API_KEY"
      }
    }
  }
}
```

### Runtime Access

```typescript
// Access via expo-constants
import Constants from "expo-constants";

const apiUrl = Constants.expoConfig?.extra?.apiUrl;

// Or via process.env (build time only)
const apiKey = process.env.API_KEY;
```

## Debugging Builds

### Build Logs

```bash
# View build logs
eas build:view

# Download build logs
eas build:view --json | jq '.logs'
```

### Common Issues

| Issue | Solution |
|-------|----------|
| iOS signing failed | Run `eas credentials` and recreate |
| Android keystore lost | Check EAS dashboard, contact support |
| Build timeout | Increase resources or optimize dependencies |
| Native module error | Check compatibility, update packages |

### Build Caching

```json
// eas.json
{
  "build": {
    "production": {
      "cache": {
        "key": "v1",
        "paths": ["~/.npm"]
      }
    }
  }
}
```

## Workflow Patterns

### Development Workflow

```bash
# 1. Development build for testing
eas build --profile development --platform ios

# 2. Install on device/simulator
# Scan QR code from EAS dashboard

# 3. Run development server
npx expo start --dev-client
```

### Release Workflow

```bash
# 1. Create preview build for QA
eas build --profile preview --platform all

# 2. Internal testing via EAS dashboard
# Share internal distribution link

# 3. Production build
eas build --profile production --platform all

# 4. Submit to stores
eas submit --platform all

# 5. Post-release OTA updates
eas update --branch production --message "Hotfix"
```

## References

- `references/eas-build.md` - Detailed EAS Build configurations
- `references/app-store-submission.md` - Complete submission checklists
