---
name: accessibility-patterns
description: |
  Accessibility patterns for WCAG 2.1 compliance, ARIA, and keyboard navigation.
  Use when implementing accessible components, auditing for a11y issues,
  adding screen reader support, or ensuring keyboard accessibility.
  Covers web and mobile accessibility.
---

# Accessibility Patterns

## WCAG 2.1 Overview

### Principles (POUR)

| Principle | Meaning | Key Focus |
|-----------|---------|-----------|
| **P**erceivable | Users can perceive content | Alt text, captions, contrast |
| **O**perable | Users can operate interface | Keyboard, timing, navigation |
| **U**nderstandable | Users can understand content | Readable, predictable, errors |
| **R**obust | Works with assistive tech | Valid HTML, ARIA |

### Conformance Levels

- **Level A**: Minimum accessibility
- **Level AA**: Standard target (legally required in many cases)
- **Level AAA**: Enhanced accessibility

## Semantic HTML

### Document Structure

```html
<!-- Good: Semantic structure -->
<header>
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h1>Page Title</h1>
    <section aria-labelledby="intro-heading">
      <h2 id="intro-heading">Introduction</h2>
      <p>Content...</p>
    </section>
  </article>
</main>

<aside aria-label="Related content">
  <h2>Related Articles</h2>
</aside>

<footer>
  <nav aria-label="Footer navigation">
    <!-- Footer links -->
  </nav>
</footer>
```

### Heading Hierarchy

```html
<!-- Correct: Logical hierarchy -->
<h1>Main Page Title</h1>
  <h2>Section 1</h2>
    <h3>Subsection 1.1</h3>
    <h3>Subsection 1.2</h3>
  <h2>Section 2</h2>
    <h3>Subsection 2.1</h3>

<!-- Wrong: Skipping levels -->
<h1>Title</h1>
<h3>Jumped to h3</h3>  <!-- Missing h2 -->
```

## ARIA Patterns

### Roles and States

```html
<!-- Button with state -->
<button
  aria-pressed="false"
  aria-label="Toggle dark mode"
>
  🌙
</button>

<!-- Expandable section -->
<button
  aria-expanded="false"
  aria-controls="content-1"
>
  Show More
</button>
<div id="content-1" hidden>
  Hidden content
</div>

<!-- Loading state -->
<button
  aria-busy="true"
  aria-disabled="true"
>
  <span aria-hidden="true">⏳</span>
  Loading...
</button>
```

### Live Regions

```html
<!-- Polite announcements (waits for pause) -->
<div aria-live="polite" aria-atomic="true">
  Form saved successfully
</div>

<!-- Assertive announcements (interrupts) -->
<div aria-live="assertive" role="alert">
  Error: Password is required
</div>

<!-- Status updates -->
<div role="status" aria-live="polite">
  5 results found
</div>
```

### Common ARIA Patterns

```html
<!-- Tab Panel -->
<div role="tablist" aria-label="Product tabs">
  <button
    role="tab"
    aria-selected="true"
    aria-controls="panel-1"
    id="tab-1"
  >
    Description
  </button>
  <button
    role="tab"
    aria-selected="false"
    aria-controls="panel-2"
    id="tab-2"
    tabindex="-1"
  >
    Reviews
  </button>
</div>

<div
  role="tabpanel"
  id="panel-1"
  aria-labelledby="tab-1"
>
  Description content
</div>
<div
  role="tabpanel"
  id="panel-2"
  aria-labelledby="tab-2"
  hidden
>
  Reviews content
</div>
```

```html
<!-- Modal Dialog -->
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-desc"
>
  <h2 id="modal-title">Confirm Action</h2>
  <p id="modal-desc">Are you sure you want to delete this item?</p>
  <button>Cancel</button>
  <button>Confirm</button>
</div>
```

## Keyboard Navigation

### Focus Management

```typescript
// React: Focus management hook
function useFocusTrap(ref: RefObject<HTMLElement>) {
  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const focusableElements = element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0] as HTMLElement;
    const lastElement = focusableElements[
      focusableElements.length - 1
    ] as HTMLElement;

    function handleKeyDown(e: KeyboardEvent) {
      if (e.key !== "Tab") return;

      if (e.shiftKey && document.activeElement === firstElement) {
        e.preventDefault();
        lastElement.focus();
      } else if (
        !e.shiftKey &&
        document.activeElement === lastElement
      ) {
        e.preventDefault();
        firstElement.focus();
      }
    }

    element.addEventListener("keydown", handleKeyDown);
    firstElement?.focus();

    return () => {
      element.removeEventListener("keydown", handleKeyDown);
    };
  }, [ref]);
}
```

### Skip Links

```html
<body>
  <a href="#main-content" class="skip-link">
    Skip to main content
  </a>

  <header><!-- Navigation --></header>

  <main id="main-content" tabindex="-1">
    <!-- Main content -->
  </main>
</body>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  padding: 8px;
  background: #000;
  color: #fff;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
</style>
```

### Keyboard Shortcuts

```typescript
// Roving tabindex for lists
function RovingTabIndex({ items }: { items: string[] }) {
  const [focusIndex, setFocusIndex] = useState(0);
  const refs = useRef<HTMLButtonElement[]>([]);

  const handleKeyDown = (e: KeyboardEvent, index: number) => {
    let newIndex = index;

    switch (e.key) {
      case "ArrowDown":
      case "ArrowRight":
        newIndex = (index + 1) % items.length;
        break;
      case "ArrowUp":
      case "ArrowLeft":
        newIndex = (index - 1 + items.length) % items.length;
        break;
      case "Home":
        newIndex = 0;
        break;
      case "End":
        newIndex = items.length - 1;
        break;
      default:
        return;
    }

    e.preventDefault();
    setFocusIndex(newIndex);
    refs.current[newIndex]?.focus();
  };

  return (
    <div role="listbox">
      {items.map((item, index) => (
        <button
          key={item}
          ref={(el) => (refs.current[index] = el!)}
          role="option"
          tabIndex={index === focusIndex ? 0 : -1}
          onKeyDown={(e) => handleKeyDown(e, index)}
        >
          {item}
        </button>
      ))}
    </div>
  );
}
```

## Color and Contrast

### Contrast Requirements

| Element | AA Ratio | AAA Ratio |
|---------|----------|-----------|
| Normal text | 4.5:1 | 7:1 |
| Large text (18pt+) | 3:1 | 4.5:1 |
| UI components | 3:1 | N/A |

### Testing Contrast

```typescript
// Calculate contrast ratio
function getContrastRatio(color1: string, color2: string): number {
  const lum1 = getLuminance(color1);
  const lum2 = getLuminance(color2);
  const lighter = Math.max(lum1, lum2);
  const darker = Math.min(lum1, lum2);
  return (lighter + 0.05) / (darker + 0.05);
}

function getLuminance(hex: string): number {
  const rgb = hexToRgb(hex);
  const [r, g, b] = rgb.map((c) => {
    c = c / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}
```

### Color-Blind Safe Patterns

```css
/* Don't rely on color alone */
.error {
  color: #dc2626;
  border-left: 4px solid #dc2626;  /* Visual indicator */
}

.error::before {
  content: "⚠️ ";  /* Icon indicator */
}

/* Link distinction without color */
a {
  text-decoration: underline;  /* Always visible */
}

a:hover,
a:focus {
  text-decoration-thickness: 2px;
}
```

## Forms

### Labels and Inputs

```html
<!-- Explicit label -->
<label for="email">Email address</label>
<input
  type="email"
  id="email"
  name="email"
  autocomplete="email"
  aria-describedby="email-hint"
  required
/>
<span id="email-hint" class="hint">
  We'll never share your email
</span>

<!-- Error state -->
<label for="password">Password</label>
<input
  type="password"
  id="password"
  aria-invalid="true"
  aria-describedby="password-error"
/>
<span id="password-error" role="alert" class="error">
  Password must be at least 8 characters
</span>
```

### Form Validation

```typescript
// Accessible form validation
function AccessibleForm() {
  const [errors, setErrors] = useState<Record<string, string>>({});
  const errorRef = useRef<HTMLDivElement>(null);

  const validate = (data: FormData) => {
    const newErrors: Record<string, string> = {};

    if (!data.get("email")) {
      newErrors.email = "Email is required";
    }

    setErrors(newErrors);

    // Focus error summary for screen readers
    if (Object.keys(newErrors).length > 0) {
      errorRef.current?.focus();
    }

    return Object.keys(newErrors).length === 0;
  };

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      if (validate(new FormData(e.currentTarget))) {
        // Submit
      }
    }}>
      {Object.keys(errors).length > 0 && (
        <div
          ref={errorRef}
          tabIndex={-1}
          role="alert"
          aria-labelledby="error-heading"
        >
          <h2 id="error-heading">
            There are {Object.keys(errors).length} errors
          </h2>
          <ul>
            {Object.entries(errors).map(([field, message]) => (
              <li key={field}>
                <a href={`#${field}`}>{message}</a>
              </li>
            ))}
          </ul>
        </div>
      )}

      <label htmlFor="email">Email</label>
      <input
        id="email"
        name="email"
        aria-invalid={!!errors.email}
        aria-describedby={errors.email ? "email-error" : undefined}
      />
      {errors.email && (
        <span id="email-error" className="error">
          {errors.email}
        </span>
      )}

      <button type="submit">Submit</button>
    </form>
  );
}
```

## Images and Media

### Alt Text Guidelines

```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 25% from Q1 to Q2 2024" />

<!-- Decorative image -->
<img src="decoration.png" alt="" role="presentation" />

<!-- Complex image with long description -->
<figure>
  <img
    src="diagram.png"
    alt="System architecture diagram"
    aria-describedby="diagram-desc"
  />
  <figcaption id="diagram-desc">
    Detailed description of the architecture...
  </figcaption>
</figure>

<!-- Image as link -->
<a href="/home">
  <img src="logo.png" alt="Company Name - Go to homepage" />
</a>
```

### Video Captions

```html
<video controls>
  <source src="video.mp4" type="video/mp4" />
  <track
    kind="captions"
    src="captions-en.vtt"
    srclang="en"
    label="English"
    default
  />
  <track
    kind="descriptions"
    src="descriptions-en.vtt"
    srclang="en"
    label="English audio descriptions"
  />
</video>
```

## React Native Accessibility

### Basic Props

```tsx
<TouchableOpacity
  accessible={true}
  accessibilityLabel="Submit form"
  accessibilityHint="Submits your registration"
  accessibilityRole="button"
  accessibilityState={{ disabled: isLoading }}
>
  <Text>Submit</Text>
</TouchableOpacity>

<TextInput
  accessible={true}
  accessibilityLabel="Email address"
  accessibilityHint="Enter your email to sign up"
  placeholder="email@example.com"
/>
```

### Screen Reader Announcements

```tsx
import { AccessibilityInfo } from "react-native";

// Announce to screen reader
AccessibilityInfo.announceForAccessibility("Form submitted successfully");

// Check if screen reader is enabled
const [screenReaderEnabled, setScreenReaderEnabled] = useState(false);

useEffect(() => {
  AccessibilityInfo.isScreenReaderEnabled().then(setScreenReaderEnabled);
  const subscription = AccessibilityInfo.addEventListener(
    "screenReaderChanged",
    setScreenReaderEnabled
  );
  return () => subscription.remove();
}, []);
```

## Testing Accessibility

### Automated Testing

```bash
# Lighthouse audit
npx lighthouse http://localhost:3000 --only-categories=accessibility

# axe-core with Playwright
npm install @axe-core/playwright
```

```typescript
// Playwright with axe
import { test, expect } from "@playwright/test";
import AxeBuilder from "@axe-core/playwright";

test("should not have accessibility violations", async ({ page }) => {
  await page.goto("/");

  const results = await new AxeBuilder({ page }).analyze();

  expect(results.violations).toEqual([]);
});
```

### Manual Testing Checklist

- [ ] Navigate entire page with keyboard only
- [ ] Test with screen reader (NVDA, VoiceOver)
- [ ] Check color contrast (use browser devtools)
- [ ] Resize to 200% and verify no content loss
- [ ] Test with reduced motion preference
- [ ] Verify focus indicators are visible
- [ ] Check heading structure (browser extension)

## References

- `references/wcag-checklist.md` - Complete WCAG 2.1 AA checklist
- `references/aria-patterns.md` - ARIA widget patterns and examples
