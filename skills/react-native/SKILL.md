---
name: react-native
description: |
  React Native mobile development patterns, Expo workflows, and cross-platform UI.
  Use when building mobile apps, working with React Native components,
  handling native modules, or debugging mobile issues.
---

# React Native Development

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Navigation | `references/navigation-patterns.md` | Setting up navigation |
| Expo | `references/expo-workflows.md` | Using Expo tools |
| Native Modules | `references/native-modules.md` | Platform-specific code |

## Core Patterns
```typescript
// StyleSheet over inline styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
});

// Platform-specific code
import { Platform } from 'react-native';

const styles = StyleSheet.create({
  header: {
    paddingTop: Platform.select({
      ios: 44,
      android: 0,
    }),
  },
});
```

## Navigation (React Navigation 6+)
```typescript
// Type-safe navigation
type RootStackParamList = {
  Home: undefined;
  Details: { id: string };
};

const Stack = createNativeStackNavigator<RootStackParamList>();
```

## Testing
- `@testing-library/react-native` for components
- Detox for E2E on iOS/Android
- Jest mocks for native modules

## Common Pitfalls
- Missing SafeAreaView → Content under notch
- Inline styles → Performance issues
- Unhandled keyboard → Covered inputs
- Platform assumptions → Test both platforms
