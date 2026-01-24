# EAS Build Configuration

## Complete `eas.json` Configuration

```json
{
  "cli": {
    "version": ">= 5.0.0",
    "appVersionSource": "remote"
  },
  "build": {
    "base": {
      "node": "18.18.0",
      "env": {
        "APP_ENV": "development"
      }
    },
    "development": {
      "extends": "base",
      "developmentClient": true,
      "distribution": "internal",
      "ios": {
        "simulator": true
      },
      "android": {
        "buildType": "apk",
        "gradleCommand": ":app:assembleDebug"
      },
      "env": {
        "APP_ENV": "development",
        "API_URL": "http://localhost:3000"
      }
    },
    "development-device": {
      "extends": "development",
      "ios": {
        "simulator": false
      },
      "android": {
        "buildType": "apk"
      }
    },
    "preview": {
      "extends": "base",
      "distribution": "internal",
      "channel": "preview",
      "ios": {
        "resourceClass": "m-medium"
      },
      "android": {
        "buildType": "apk"
      },
      "env": {
        "APP_ENV": "staging",
        "API_URL": "https://api.staging.example.com"
      }
    },
    "preview-store": {
      "extends": "preview",
      "ios": {
        "simulator": false
      },
      "android": {
        "buildType": "app-bundle"
      }
    },
    "production": {
      "extends": "base",
      "channel": "production",
      "autoIncrement": true,
      "ios": {
        "resourceClass": "m-medium"
      },
      "android": {
        "buildType": "app-bundle"
      },
      "env": {
        "APP_ENV": "production",
        "API_URL": "https://api.example.com"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@email.com",
        "ascAppId": "1234567890",
        "appleTeamId": "XXXXXXXXXX"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "internal"
      }
    }
  }
}
```

## Configuration Options Reference

### Build Profile Options

| Option | Type | Description |
|--------|------|-------------|
| `extends` | string | Inherit from another profile |
| `developmentClient` | boolean | Build with expo-dev-client |
| `distribution` | "internal" \| "store" | Distribution method |
| `channel` | string | Update channel name |
| `autoIncrement` | boolean \| "version" \| "buildNumber" | Auto-increment version |
| `releaseChannel` | string | Classic updates channel (deprecated) |

### iOS-Specific Options

| Option | Description |
|--------|-------------|
| `simulator` | Build for simulator (true) or device (false) |
| `enterpriseProvisioning` | "universal" \| "adhoc" for enterprise accounts |
| `resourceClass` | "default" \| "m-medium" \| "m-large" \| "large" |
| `buildConfiguration` | "Debug" \| "Release" |
| `image` | Build image (e.g., "latest", "macos-ventura-13.6-xcode-15.0") |

### Android-Specific Options

| Option | Description |
|--------|-------------|
| `buildType` | "apk" \| "app-bundle" |
| `gradleCommand` | Custom gradle command |
| `resourceClass` | "default" \| "medium" \| "large" |
| `image` | Build image (e.g., "latest", "ubuntu-22.04-jdk-17-ndk-r21e") |

## Build Caching

```json
{
  "build": {
    "production": {
      "cache": {
        "key": "production-v1",
        "cacheDefaultPaths": true,
        "customPaths": [
          "node_modules/.cache",
          ".yarn/cache"
        ]
      }
    }
  }
}
```

### Clearing Cache

```bash
# Build with cleared cache
eas build --clear-cache

# Or update cache key in eas.json
"cache": {
  "key": "production-v2"  // Increment to bust cache
}
```

## Environment Variables

### In eas.json

```json
{
  "build": {
    "production": {
      "env": {
        "API_URL": "https://api.example.com",
        "FEATURE_FLAG": "true"
      }
    }
  }
}
```

### EAS Secrets (Sensitive Data)

```bash
# Create secret
eas secret:create --name STRIPE_KEY --value "sk_live_xxx" --scope project

# List secrets
eas secret:list

# Delete secret
eas secret:delete STRIPE_KEY

# Use in eas.json
{
  "build": {
    "production": {
      "env": {
        "STRIPE_KEY": "@secret:STRIPE_KEY"
      }
    }
  }
}
```

### Build-time vs Runtime

```javascript
// app.config.js

// Build-time (available during build)
const apiUrl = process.env.API_URL;

// Runtime (available in app)
export default {
  extra: {
    apiUrl: process.env.API_URL,  // Passed to runtime
  }
};

// In your app
import Constants from "expo-constants";
const apiUrl = Constants.expoConfig?.extra?.apiUrl;
```

## Credentials Management

### View Credentials

```bash
# iOS credentials
eas credentials --platform ios

# Android credentials
eas credentials --platform android
```

### iOS Credentials

```bash
# Set up credentials interactively
eas credentials --platform ios

# Options:
# 1. Let EAS manage (recommended)
# 2. Use existing from App Store Connect
# 3. Upload your own

# Download credentials for backup
eas credentials --platform ios
# Select "Download credentials"
```

### Android Credentials

```bash
# Generate new keystore (first build does this automatically)
eas credentials --platform android

# Download keystore for backup
eas credentials --platform android
# Select "Download keystore"
```

### Credential Backup

```bash
# Download all credentials
eas credentials --platform ios
# Select "Download credentials"

eas credentials --platform android
# Select "Download keystore"

# Store securely:
# - 1Password
# - AWS Secrets Manager
# - Encrypted backup
```

## Custom Build Hooks

### prebuild hook

```json
// package.json
{
  "scripts": {
    "eas-build-pre-install": "echo 'Before npm install'",
    "eas-build-post-install": "echo 'After npm install'",
    "eas-build-on-success": "echo 'Build succeeded'",
    "eas-build-on-error": "echo 'Build failed'",
    "eas-build-on-cancel": "echo 'Build canceled'"
  }
}
```

### Custom Script Example

```bash
#!/bin/bash
# scripts/prepare-build.sh

# Set version from git tag
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "1.0.0")
echo "Building version: $VERSION"

# Generate build metadata
echo "{\"buildTime\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"gitCommit\": \"$(git rev-parse HEAD)\"}" > build-meta.json
```

```json
// package.json
{
  "scripts": {
    "eas-build-pre-install": "./scripts/prepare-build.sh"
  }
}
```

## Monorepo Configuration

### Project Structure

```
monorepo/
├── apps/
│   ├── mobile/
│   │   ├── app.json
│   │   ├── eas.json
│   │   └── package.json
│   └── web/
├── packages/
│   ├── ui/
│   └── shared/
├── package.json
└── yarn.lock
```

### EAS Configuration for Monorepo

```json
// apps/mobile/eas.json
{
  "cli": {
    "version": ">= 5.0.0"
  },
  "build": {
    "production": {
      "env": {
        "YARN_ENABLE_IMMUTABLE_INSTALLS": "false"
      }
    }
  }
}
```

### Yarn Workspaces

```json
// Root package.json
{
  "workspaces": [
    "apps/*",
    "packages/*"
  ]
}
```

## Build Variants

### Multiple App Variants

```javascript
// app.config.js
const IS_DEV = process.env.APP_ENV === "development";
const IS_STAGING = process.env.APP_ENV === "staging";

export default {
  name: IS_DEV ? "MyApp (Dev)" : IS_STAGING ? "MyApp (Staging)" : "MyApp",
  slug: "my-app",
  ios: {
    bundleIdentifier: IS_DEV
      ? "com.example.myapp.dev"
      : IS_STAGING
      ? "com.example.myapp.staging"
      : "com.example.myapp",
  },
  android: {
    package: IS_DEV
      ? "com.example.myapp.dev"
      : IS_STAGING
      ? "com.example.myapp.staging"
      : "com.example.myapp",
  },
};
```

## Build Commands Reference

```bash
# Build for specific platform
eas build --platform ios
eas build --platform android
eas build --platform all

# Build with specific profile
eas build --profile production
eas build --profile preview

# Build locally (no EAS servers)
eas build --local

# Build with cleared cache
eas build --clear-cache

# Non-interactive build
eas build --non-interactive

# Auto-submit after build
eas build --auto-submit

# View build status
eas build:list

# View specific build
eas build:view

# Cancel running build
eas build:cancel

# Run build on specific runner
eas build --resource-class large
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| "No bundle identifier" | Check app.json/app.config.js |
| iOS signing failed | Run `eas credentials` and recreate |
| Android keystore issues | Check `eas credentials --platform android` |
| Build timeout | Increase `resourceClass` or optimize deps |
| Cache issues | Build with `--clear-cache` |

### Debug Build Issues

```bash
# View detailed build logs
eas build:view

# Check build configuration
eas config --platform ios
eas config --platform android

# Validate project
npx expo-doctor
```

### Build Logs Location

```bash
# Download logs via CLI
eas build:view --json | jq '.logsUrl'

# Or from EAS Dashboard
# https://expo.dev > Project > Builds > Select build > Logs
```
