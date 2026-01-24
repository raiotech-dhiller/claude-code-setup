# WCAG 2.1 AA Checklist

Complete checklist for WCAG 2.1 Level AA compliance.

## Principle 1: Perceivable

### 1.1 Text Alternatives

#### 1.1.1 Non-text Content (Level A)

- [ ] All images have appropriate alt text
- [ ] Decorative images have empty alt (`alt=""`)
- [ ] Complex images have long descriptions
- [ ] Form inputs have associated labels
- [ ] Audio/video has text alternatives
- [ ] CAPTCHAs have text alternatives

**Testing:**
```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 25% in Q4">

<!-- Decorative image -->
<img src="divider.png" alt="" role="presentation">

<!-- Complex image -->
<figure>
  <img src="diagram.png" alt="Architecture diagram"
       aria-describedby="diagram-desc">
  <figcaption id="diagram-desc">
    [Detailed description...]
  </figcaption>
</figure>
```

### 1.2 Time-based Media

#### 1.2.1 Audio-only and Video-only (Level A)

- [ ] Audio-only has text transcript
- [ ] Video-only has text description or audio track

#### 1.2.2 Captions (Prerecorded) (Level A)

- [ ] Prerecorded video has synchronized captions
- [ ] Captions include speaker identification
- [ ] Captions include relevant sound effects

#### 1.2.3 Audio Description (Prerecorded) (Level A)

- [ ] Video has audio description of visual content
- [ ] Or full text alternative provided

#### 1.2.5 Audio Description (Prerecorded) (Level AA)

- [ ] Audio description provided for all prerecorded video

### 1.3 Adaptable

#### 1.3.1 Info and Relationships (Level A)

- [ ] Headings use proper heading elements (h1-h6)
- [ ] Lists use proper list elements (ul, ol, dl)
- [ ] Tables have proper headers (th) and structure
- [ ] Form fields have associated labels
- [ ] Required fields indicated programmatically
- [ ] Regions identified (header, nav, main, footer)

**Testing:**
```html
<!-- Proper table structure -->
<table>
  <caption>Monthly Sales</caption>
  <thead>
    <tr>
      <th scope="col">Month</th>
      <th scope="col">Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">January</th>
      <td>$10,000</td>
    </tr>
  </tbody>
</table>
```

#### 1.3.2 Meaningful Sequence (Level A)

- [ ] Content order makes sense when linearized
- [ ] CSS positioning doesn't change meaning
- [ ] Reading order matches visual order

#### 1.3.3 Sensory Characteristics (Level A)

- [ ] Instructions don't rely solely on shape
- [ ] Instructions don't rely solely on color
- [ ] Instructions don't rely solely on sound
- [ ] Instructions don't rely solely on location

**Bad:** "Click the green button on the right"
**Good:** "Click the Submit button"

#### 1.3.4 Orientation (Level AA)

- [ ] Content not restricted to single orientation
- [ ] Or orientation is essential (e.g., piano app)

#### 1.3.5 Identify Input Purpose (Level AA)

- [ ] Input fields have autocomplete attributes
- [ ] Input purpose can be determined programmatically

```html
<input type="email"
       autocomplete="email"
       name="email">
<input type="text"
       autocomplete="given-name"
       name="firstName">
<input type="text"
       autocomplete="cc-number"
       name="creditCard">
```

### 1.4 Distinguishable

#### 1.4.1 Use of Color (Level A)

- [ ] Color not sole means of conveying information
- [ ] Links distinguishable from text by more than color
- [ ] Error states have non-color indicators

```css
/* Links distinct from text */
a {
  color: blue;
  text-decoration: underline; /* Not just color */
}

/* Errors with icon, not just red */
.error {
  color: red;
  border-left: 4px solid red;
}
.error::before {
  content: "⚠️ ";
}
```

#### 1.4.2 Audio Control (Level A)

- [ ] Audio playing >3 seconds can be paused/stopped
- [ ] Audio volume can be controlled independently

#### 1.4.3 Contrast (Minimum) (Level AA)

- [ ] Text contrast ratio ≥ 4.5:1
- [ ] Large text (18pt+ or 14pt+ bold) ≥ 3:1
- [ ] Exception: Logos, decorative text, disabled controls

**Tools:**
- WebAIM Contrast Checker
- Chrome DevTools Color Picker
- Figma contrast plugins

#### 1.4.4 Resize Text (Level AA)

- [ ] Text can resize up to 200% without loss of content
- [ ] No horizontal scrolling at 200% zoom
- [ ] Content reflows properly

```css
/* Use relative units */
body {
  font-size: 16px;  /* Base size */
}
p {
  font-size: 1rem;  /* Relative to root */
  line-height: 1.5;
}
```

#### 1.4.5 Images of Text (Level AA)

- [ ] Real text used instead of images of text
- [ ] Exception: Logos, essential images

#### 1.4.10 Reflow (Level AA)

- [ ] Content reflows at 320px width without horizontal scroll
- [ ] Content reflows at 256px height without vertical scroll
- [ ] Exception: Data tables, toolbars, certain diagrams

```css
/* Responsive design */
.container {
  max-width: 100%;
  padding: 0 1rem;
}
@media (min-width: 768px) {
  .container {
    max-width: 720px;
    margin: 0 auto;
  }
}
```

#### 1.4.11 Non-text Contrast (Level AA)

- [ ] UI components have 3:1 contrast ratio
- [ ] Focus indicators have 3:1 contrast ratio
- [ ] Graphics have 3:1 contrast ratio

```css
/* Button borders visible */
button {
  border: 2px solid #666;  /* 3:1+ against white */
  background: white;
}
button:focus {
  outline: 3px solid #005fcc;  /* Visible focus */
}
```

#### 1.4.12 Text Spacing (Level AA)

- [ ] Content works with increased text spacing:
  - Line height ≥ 1.5x font size
  - Paragraph spacing ≥ 2x font size
  - Letter spacing ≥ 0.12x font size
  - Word spacing ≥ 0.16x font size

```css
/* Test with this bookmarklet */
p {
  line-height: 1.5 !important;
  margin-bottom: 2em !important;
  letter-spacing: 0.12em !important;
  word-spacing: 0.16em !important;
}
```

#### 1.4.13 Content on Hover or Focus (Level AA)

- [ ] Dismissible: Hover content can be dismissed (Esc)
- [ ] Hoverable: Pointer can move to hover content
- [ ] Persistent: Content remains until dismissed

```css
/* Tooltip pattern */
.tooltip {
  position: absolute;
  /* Allow mouse to move into tooltip */
  margin-top: -4px;
}
.tooltip:hover,
.trigger:hover + .tooltip,
.trigger:focus + .tooltip {
  display: block;
}
```

---

## Principle 2: Operable

### 2.1 Keyboard Accessible

#### 2.1.1 Keyboard (Level A)

- [ ] All functionality available via keyboard
- [ ] No keyboard traps
- [ ] Focus order logical

```javascript
// Keyboard event handling
element.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' || e.key === ' ') {
    // Activate
  }
});
```

#### 2.1.2 No Keyboard Trap (Level A)

- [ ] User can tab into AND out of all components
- [ ] Modals trap focus appropriately
- [ ] Focus returns after modal closes

#### 2.1.4 Character Key Shortcuts (Level A)

- [ ] Single character shortcuts can be turned off
- [ ] Or remapped
- [ ] Or only active on focus

### 2.2 Enough Time

#### 2.2.1 Timing Adjustable (Level A)

- [ ] Time limits can be turned off, adjusted, or extended
- [ ] 20 second warning before timeout
- [ ] Exception: Real-time events, essential time limits

#### 2.2.2 Pause, Stop, Hide (Level A)

- [ ] Moving content can be paused, stopped, or hidden
- [ ] Auto-updating content can be paused
- [ ] Exception: Essential movement

### 2.3 Seizures and Physical Reactions

#### 2.3.1 Three Flashes or Below Threshold (Level A)

- [ ] No content flashes more than 3 times per second
- [ ] Or flash below general flash and red flash thresholds

### 2.4 Navigable

#### 2.4.1 Bypass Blocks (Level A)

- [ ] Skip link to main content
- [ ] Skip links for repeated content

```html
<body>
  <a href="#main" class="skip-link">Skip to main content</a>
  <header>...</header>
  <main id="main" tabindex="-1">...</main>
</body>
```

#### 2.4.2 Page Titled (Level A)

- [ ] Pages have descriptive, unique titles
- [ ] Title identifies page purpose

```html
<title>Contact Us - Company Name</title>
<title>Shopping Cart (3 items) - Store Name</title>
```

#### 2.4.3 Focus Order (Level A)

- [ ] Focus order matches visual/logical order
- [ ] Focus doesn't jump unexpectedly
- [ ] tabindex used sparingly (0, -1 only)

#### 2.4.4 Link Purpose (In Context) (Level A)

- [ ] Link purpose clear from link text
- [ ] Or link text + surrounding context
- [ ] No "click here" or "read more" alone

```html
<!-- Good -->
<a href="/pricing">View pricing plans</a>
<a href="/article">Read "10 Tips for Accessibility"</a>

<!-- Bad -->
<a href="/pricing">Click here</a>
<a href="/article">Read more</a>
```

#### 2.4.5 Multiple Ways (Level AA)

- [ ] Multiple ways to find pages (navigation, search, sitemap)

#### 2.4.6 Headings and Labels (Level AA)

- [ ] Headings describe content
- [ ] Labels describe purpose

#### 2.4.7 Focus Visible (Level AA)

- [ ] Keyboard focus indicator visible
- [ ] Focus indicator has sufficient contrast

```css
:focus {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

/* Don't remove focus for keyboard users */
:focus:not(:focus-visible) {
  outline: none;  /* Remove for mouse */
}
:focus-visible {
  outline: 3px solid #005fcc;  /* Keep for keyboard */
}
```

### 2.5 Input Modalities

#### 2.5.1 Pointer Gestures (Level A)

- [ ] Multi-point or path-based gestures have alternatives
- [ ] Single pointer alternative available

#### 2.5.2 Pointer Cancellation (Level A)

- [ ] Down-event doesn't execute action (use click/up)
- [ ] Abort or undo available
- [ ] Up-event reverses down-event

#### 2.5.3 Label in Name (Level A)

- [ ] Accessible name includes visible label text

```html
<!-- Good: accessible name matches visible -->
<button aria-label="Submit form">Submit form</button>

<!-- Bad: accessible name different from visible -->
<button aria-label="Send">Submit</button>
```

#### 2.5.4 Motion Actuation (Level A)

- [ ] Motion-triggered functionality has UI alternative
- [ ] Motion can be disabled

---

## Principle 3: Understandable

### 3.1 Readable

#### 3.1.1 Language of Page (Level A)

- [ ] Page language declared in HTML

```html
<html lang="en">
```

#### 3.1.2 Language of Parts (Level AA)

- [ ] Language changes marked in content

```html
<p>The French word for cat is <span lang="fr">chat</span>.</p>
```

### 3.2 Predictable

#### 3.2.1 On Focus (Level A)

- [ ] Focus doesn't cause context change
- [ ] No auto-submit on focus

#### 3.2.2 On Input (Level A)

- [ ] Input doesn't cause unexpected context change
- [ ] Changes warned in advance
- [ ] Submit buttons for forms

#### 3.2.3 Consistent Navigation (Level AA)

- [ ] Navigation order consistent across pages
- [ ] Navigation position consistent

#### 3.2.4 Consistent Identification (Level AA)

- [ ] Same functionality has same label/icon
- [ ] Consistent icon meanings

### 3.3 Input Assistance

#### 3.3.1 Error Identification (Level A)

- [ ] Errors identified in text
- [ ] Error field identified
- [ ] Not just color indication

```html
<label for="email">Email</label>
<input id="email" aria-describedby="email-error" aria-invalid="true">
<span id="email-error" class="error" role="alert">
  Please enter a valid email address
</span>
```

#### 3.3.2 Labels or Instructions (Level A)

- [ ] Labels provided for inputs
- [ ] Instructions provided when needed
- [ ] Required fields indicated

#### 3.3.3 Error Suggestion (Level AA)

- [ ] Error messages suggest correction
- [ ] Valid format examples provided

```html
<span class="error">
  Invalid date. Please use format MM/DD/YYYY (e.g., 01/15/2024)
</span>
```

#### 3.3.4 Error Prevention (Legal, Financial, Data) (Level AA)

- [ ] Submissions reversible
- [ ] Or data checked and confirmed
- [ ] Or mechanism to review/correct

---

## Principle 4: Robust

### 4.1 Compatible

#### 4.1.1 Parsing (Level A)

- [ ] Valid HTML (no duplicate IDs, proper nesting)
- [ ] Complete start/end tags

#### 4.1.2 Name, Role, Value (Level A)

- [ ] Custom components have accessible names
- [ ] Roles communicate purpose
- [ ] States/values programmatically available

```html
<!-- Custom toggle -->
<button
  role="switch"
  aria-checked="false"
  aria-label="Enable notifications"
>
  <span class="toggle-slider"></span>
</button>
```

#### 4.1.3 Status Messages (Level AA)

- [ ] Status messages announced via live region
- [ ] No focus change required

```html
<div role="status" aria-live="polite">
  5 search results found
</div>

<div role="alert" aria-live="assertive">
  Error: Form submission failed
</div>
```

---

## Quick Testing Procedure

### Manual Tests (5 minutes)

1. **Tab through page** - Logical order? All interactive?
2. **Zoom to 200%** - Content readable? No overlap?
3. **Check headings** (DevTools) - Logical hierarchy?
4. **Check contrast** (DevTools) - 4.5:1 minimum?
5. **Turn off CSS** - Content still makes sense?

### Automated Tests

```bash
# Lighthouse
npx lighthouse http://localhost:3000 --only-categories=accessibility

# axe-core
npm install @axe-core/cli
npx axe http://localhost:3000
```

### Screen Reader Tests

- **macOS**: VoiceOver (Cmd + F5)
- **Windows**: NVDA (free) or Narrator
- **Mobile**: VoiceOver (iOS), TalkBack (Android)
