# App Store Submission

## iOS App Store Submission

### Prerequisites Checklist

- [ ] Apple Developer Account ($99/year)
- [ ] App Store Connect access
- [ ] App icon (1024x1024 PNG, no alpha, no rounded corners)
- [ ] Screenshots for all required sizes
- [ ] App description and metadata
- [ ] Privacy policy URL
- [ ] Production build (.ipa with Distribution certificate)

### App Store Connect Setup

1. **Create App**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Apps → + → New App
   - Fill in: Name, Primary Language, Bundle ID, SKU

2. **App Information**
   ```
   Name: [Your App Name] (30 chars max)
   Subtitle: [Tagline] (30 chars max)
   Privacy Policy URL: https://example.com/privacy
   Category: [Primary Category]
   Secondary Category: [Optional]
   ```

3. **Pricing and Availability**
   - Price: Free or Paid
   - Availability: Select countries

### Required Screenshots

| Device | Size | Required |
|--------|------|----------|
| iPhone 6.9" | 1320 x 2868 | Yes (Pro Max) |
| iPhone 6.7" | 1290 x 2796 | Yes (Plus/Pro Max) |
| iPhone 6.5" | 1284 x 2778 | Yes (Max) |
| iPhone 5.5" | 1242 x 2208 | Yes (Plus) |
| iPad Pro 12.9" (6th gen) | 2048 x 2732 | If iPad support |
| iPad Pro 12.9" (2nd gen) | 2048 x 2732 | If iPad support |

**Screenshot Tips:**
- 2-10 screenshots per size
- Use marketing screenshots (not raw app screenshots)
- Show key features and value proposition
- Add text overlays for context
- Tools: Rotato, AppMockUp, Sketch templates

### App Store Description

```markdown
# Description Template (4000 chars max)

[Opening hook - 1-2 sentences about main benefit]

KEY FEATURES:
• [Feature 1 with benefit]
• [Feature 2 with benefit]
• [Feature 3 with benefit]
• [Feature 4 with benefit]

[Social proof or awards if applicable]

[Brief description of how it works]

WHAT'S INCLUDED:
• [Feature/content 1]
• [Feature/content 2]
• [Feature/content 3]

[Call to action - download now, try free, etc.]

SUBSCRIPTION INFO (if applicable):
[Pricing and terms]
[Auto-renewal info]
[Cancellation info]

CONTACT:
Website: https://example.com
Support: support@example.com
Twitter: @handle

Privacy Policy: https://example.com/privacy
Terms of Use: https://example.com/terms
```

### Keywords

```
100 characters max, comma-separated
keyword1,keyword2,keyword3,keyword4

Tips:
- Don't repeat app name
- Don't use category names
- Use singular or plural, not both
- Include common misspellings
- Research competitor keywords
```

### App Review Guidelines

**Common Rejection Reasons:**

1. **Crashes and bugs**
   - Test on real devices
   - Test all user flows
   - Handle edge cases

2. **Incomplete information**
   - Demo account if login required
   - Explanation of non-obvious features
   - In-app purchase test instructions

3. **Privacy violations**
   - Request permissions when needed (not at launch)
   - Explain why each permission is needed
   - Privacy policy must cover all data collection

4. **Guideline 4.2 - Minimum functionality**
   - App must provide real value
   - Not just a website wrapper
   - Not a simple container for ads

5. **Guideline 2.1 - App completeness**
   - No placeholder content
   - No broken links
   - All features must work

### Review Notes

```markdown
# App Review Notes Template

Demo Account:
Email: demo@example.com
Password: TestPassword123

In-App Purchase Testing:
Use Sandbox account (automatically created in TestFlight)

Key Features to Test:
1. [Feature 1]: Navigate to [location] and [action]
2. [Feature 2]: [Instructions]

Special Instructions:
- [Any device requirements]
- [Any location requirements]
- [Any timing requirements]

Contact for Questions:
Email: dev@example.com
Phone: +1-XXX-XXX-XXXX
```

### EAS Submit Configuration

```json
// eas.json
{
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@email.com",
        "ascAppId": "1234567890",  // From App Store Connect
        "appleTeamId": "XXXXXXXXXX",
        "appName": "My App"
      }
    }
  }
}
```

### Submission Commands

```bash
# Submit existing build
eas submit --platform ios

# Build and submit
eas build --platform ios --auto-submit

# Submit to TestFlight
eas submit --platform ios --latest
```

---

## Google Play Store Submission

### Prerequisites Checklist

- [ ] Google Play Developer Account ($25 one-time)
- [ ] Google Play Console access
- [ ] Service account for automated uploads
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500)
- [ ] Screenshots for phones and tablets
- [ ] App description and metadata
- [ ] Privacy policy URL
- [ ] Production build (.aab App Bundle)

### Google Play Console Setup

1. **Create App**
   - Go to [Google Play Console](https://play.google.com/console)
   - All apps → Create app
   - Fill in: Name, Default language, App/Game, Free/Paid

2. **Store Listing**
   ```
   App name: [Name] (30 chars)
   Short description: (80 chars)
   Full description: (4000 chars)
   ```

### Required Graphics

| Asset | Size | Notes |
|-------|------|-------|
| App icon | 512 x 512 PNG | 32-bit with alpha |
| Feature graphic | 1024 x 500 | Required for promotion |
| Phone screenshots | 16:9 or 9:16 | Min 2, max 8 |
| Tablet screenshots | 16:9 or 9:16 | Required if tablet support |
| TV banner | 1280 x 720 | If TV support |

### Content Rating

Complete the content rating questionnaire:
- Violence
- Sexual content
- Language
- Controlled substances
- IARC rating generated automatically

### Data Safety

Required declaration of:
- Data collected
- Data shared
- Security practices
- Data deletion options

```markdown
# Data Safety Checklist

Data Types:
- [ ] Personal info (name, email, etc.)
- [ ] Financial info (payment, purchase history)
- [ ] Location (approximate, precise)
- [ ] Contacts
- [ ] User content (photos, files)
- [ ] App activity (interactions, search history)
- [ ] Device identifiers

Security:
- [ ] Data encrypted in transit
- [ ] Data deletion available
- [ ] Data deletion request process documented
```

### Service Account Setup

1. **Create Service Account**
   - Google Cloud Console → IAM → Service Accounts
   - Create service account
   - Download JSON key

2. **Grant Permissions**
   - Play Console → Settings → API access
   - Link Google Cloud project
   - Grant service account access

3. **EAS Configuration**
   ```json
   {
     "submit": {
       "production": {
         "android": {
           "serviceAccountKeyPath": "./google-service-account.json",
           "track": "internal"
         }
       }
     }
   }
   ```

### Release Tracks

| Track | Purpose | Visibility |
|-------|---------|------------|
| Internal | Team testing | Invite only (100 max) |
| Closed | Alpha/beta testing | Invite only |
| Open | Public beta | Anyone can join |
| Production | Public release | Everyone |

### Staged Rollout

```bash
# Start with small percentage
eas submit --platform android

# In Play Console:
# 1. Production → Create release
# 2. Roll out to 5%
# 3. Monitor for crashes
# 4. Gradually increase: 10% → 25% → 50% → 100%
```

### Submission Commands

```bash
# Submit to internal track
eas submit --platform android

# Specify track
eas submit --platform android --track production

# Build and submit
eas build --platform android --auto-submit
```

---

## TestFlight / Internal Testing

### iOS TestFlight

```bash
# Build for TestFlight
eas build --platform ios --profile production

# Submit to TestFlight
eas submit --platform ios
```

**TestFlight Groups:**
- Internal testers: Apple ID team members (instant access)
- External testers: Email invite (requires beta review)

### Android Internal Testing

```bash
# Build for internal testing
eas build --platform android --profile preview

# Submit to internal track
eas submit --platform android --track internal
```

**Share Link:**
- Play Console → Internal testing → Testers → Copy link
- Share link with testers (100 max)

---

## Release Checklist

### Pre-Release

```markdown
## Technical
- [ ] All features complete and tested
- [ ] No critical or high-severity bugs
- [ ] Performance acceptable (load times, memory)
- [ ] Crash-free sessions > 99%
- [ ] Analytics and error tracking configured

## Assets
- [ ] App icon in all sizes
- [ ] Screenshots for all required sizes
- [ ] Feature graphic (Android)
- [ ] App preview video (optional)

## Content
- [ ] App description finalized
- [ ] Keywords optimized
- [ ] What's New text prepared
- [ ] Privacy policy live and accurate
- [ ] Terms of service live

## Legal
- [ ] Privacy policy covers all data collection
- [ ] GDPR compliance (if applicable)
- [ ] COPPA compliance (if applicable)
- [ ] Export compliance (if applicable)

## Marketing
- [ ] Press kit ready
- [ ] Launch announcement drafted
- [ ] Social media posts scheduled
- [ ] App Store Optimization (ASO) done
```

### Post-Release

```markdown
## Monitoring
- [ ] Monitor crash reports (Sentry/Firebase)
- [ ] Check store reviews daily
- [ ] Monitor analytics for anomalies
- [ ] Verify in-app purchases working

## Response
- [ ] Respond to reviews (especially negative)
- [ ] Prepare hotfix process if needed
- [ ] Document known issues

## Iteration
- [ ] Collect user feedback
- [ ] Prioritize next release features
- [ ] Plan update schedule
```

---

## Version Management

### Semantic Versioning

```
MAJOR.MINOR.PATCH
1.0.0

MAJOR: Breaking changes, major new features
MINOR: New features, backward compatible
PATCH: Bug fixes, small improvements
```

### Auto-Increment in EAS

```json
// eas.json
{
  "build": {
    "production": {
      "autoIncrement": true  // Increments buildNumber/versionCode
    }
  }
}
```

### Manual Control

```javascript
// app.config.js
export default {
  version: "1.2.0",  // User-facing version
  ios: {
    buildNumber: "42",  // Internal build number
  },
  android: {
    versionCode: 42,  // Must be integer, always increment
  },
};
```

### What's New Text

```markdown
# What's New Template (4000 chars iOS / 500 chars Android)

Version 1.2.0

NEW:
• [Major new feature]
• [New feature 2]

IMPROVED:
• [Enhancement 1]
• [Enhancement 2]

FIXED:
• [Bug fix 1]
• [Bug fix 2]

Thanks for using [App Name]! We love hearing from you -
leave a review or contact us at support@example.com.
```
