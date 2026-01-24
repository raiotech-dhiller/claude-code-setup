# ARIA Patterns

Common ARIA patterns for accessible interactive widgets.

## Core ARIA Concepts

### Roles, States, and Properties

```html
<!-- Role: What the element is -->
<div role="button">Click me</div>

<!-- State: Current condition (changes) -->
<button aria-pressed="true">Toggle</button>

<!-- Property: Characteristic (static) -->
<input aria-label="Search" aria-describedby="hint">
```

### When to Use ARIA

```
First rule of ARIA: Don't use ARIA if native HTML works

Preference order:
1. Native HTML element (<button>, <input>)
2. Native HTML with CSS
3. ARIA enhancement of native HTML
4. Custom component with ARIA (last resort)
```

---

## Interactive Patterns

### Button

```html
<!-- Native (preferred) -->
<button type="button">Action</button>

<!-- Custom button -->
<div
  role="button"
  tabindex="0"
  aria-label="Action"
  onclick="handleClick()"
  onkeydown="handleKeydown(event)"
>
  Action
</div>
```

```javascript
// Keyboard handling for custom button
function handleKeydown(event) {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault();
    handleClick();
  }
}
```

### Toggle Button

```html
<button
  type="button"
  aria-pressed="false"
  onclick="togglePressed(this)"
>
  <span class="icon">★</span>
  Favorite
</button>
```

```javascript
function togglePressed(button) {
  const pressed = button.getAttribute('aria-pressed') === 'true';
  button.setAttribute('aria-pressed', !pressed);
}
```

```css
[aria-pressed="true"] {
  background: var(--color-primary);
  color: white;
}
```

### Link vs Button

```html
<!-- Link: Navigation -->
<a href="/page">Go to page</a>

<!-- Button: Action -->
<button type="button">Perform action</button>

<!-- Never: -->
<a href="#" onclick="doSomething()">Bad pattern</a>
<span onclick="navigate()">Also bad</span>
```

---

## Modal Dialog

### Structure

```html
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
  aria-describedby="dialog-description"
>
  <h2 id="dialog-title">Confirm Delete</h2>
  <p id="dialog-description">
    Are you sure you want to delete this item?
    This action cannot be undone.
  </p>
  <div class="dialog-actions">
    <button type="button" data-dismiss>Cancel</button>
    <button type="button" data-confirm>Delete</button>
  </div>
</div>

<!-- Background overlay -->
<div class="dialog-backdrop" aria-hidden="true"></div>
```

### Focus Management

```javascript
class Dialog {
  constructor(element) {
    this.element = element;
    this.previousActiveElement = null;
    this.focusableElements = element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
  }

  open() {
    // Save current focus
    this.previousActiveElement = document.activeElement;

    // Show dialog
    this.element.hidden = false;
    this.element.setAttribute('aria-hidden', 'false');

    // Trap focus
    document.body.style.overflow = 'hidden';
    this.focusableElements[0]?.focus();

    // Listen for escape
    document.addEventListener('keydown', this.handleKeydown);
  }

  close() {
    this.element.hidden = true;
    this.element.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';

    // Return focus
    this.previousActiveElement?.focus();

    document.removeEventListener('keydown', this.handleKeydown);
  }

  handleKeydown = (event) => {
    if (event.key === 'Escape') {
      this.close();
      return;
    }

    if (event.key === 'Tab') {
      this.trapFocus(event);
    }
  };

  trapFocus(event) {
    const first = this.focusableElements[0];
    const last = this.focusableElements[this.focusableElements.length - 1];

    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  }
}
```

---

## Tabs

### Structure

```html
<div class="tabs">
  <!-- Tab list -->
  <div role="tablist" aria-label="Product information">
    <button
      role="tab"
      id="tab-1"
      aria-selected="true"
      aria-controls="panel-1"
    >
      Description
    </button>
    <button
      role="tab"
      id="tab-2"
      aria-selected="false"
      aria-controls="panel-2"
      tabindex="-1"
    >
      Specifications
    </button>
    <button
      role="tab"
      id="tab-3"
      aria-selected="false"
      aria-controls="panel-3"
      tabindex="-1"
    >
      Reviews
    </button>
  </div>

  <!-- Tab panels -->
  <div
    role="tabpanel"
    id="panel-1"
    aria-labelledby="tab-1"
  >
    Description content...
  </div>
  <div
    role="tabpanel"
    id="panel-2"
    aria-labelledby="tab-2"
    hidden
  >
    Specifications content...
  </div>
  <div
    role="tabpanel"
    id="panel-3"
    aria-labelledby="tab-3"
    hidden
  >
    Reviews content...
  </div>
</div>
```

### Keyboard Navigation

```javascript
class Tabs {
  constructor(element) {
    this.tabs = element.querySelectorAll('[role="tab"]');
    this.panels = element.querySelectorAll('[role="tabpanel"]');

    this.tabs.forEach((tab, index) => {
      tab.addEventListener('click', () => this.selectTab(index));
      tab.addEventListener('keydown', (e) => this.handleKeydown(e, index));
    });
  }

  selectTab(index) {
    // Update tabs
    this.tabs.forEach((tab, i) => {
      const isSelected = i === index;
      tab.setAttribute('aria-selected', isSelected);
      tab.tabIndex = isSelected ? 0 : -1;
    });

    // Update panels
    this.panels.forEach((panel, i) => {
      panel.hidden = i !== index;
    });

    this.tabs[index].focus();
  }

  handleKeydown(event, currentIndex) {
    let newIndex = currentIndex;

    switch (event.key) {
      case 'ArrowRight':
      case 'ArrowDown':
        newIndex = (currentIndex + 1) % this.tabs.length;
        break;
      case 'ArrowLeft':
      case 'ArrowUp':
        newIndex = (currentIndex - 1 + this.tabs.length) % this.tabs.length;
        break;
      case 'Home':
        newIndex = 0;
        break;
      case 'End':
        newIndex = this.tabs.length - 1;
        break;
      default:
        return;
    }

    event.preventDefault();
    this.selectTab(newIndex);
  }
}
```

---

## Accordion

### Structure

```html
<div class="accordion">
  <h3>
    <button
      aria-expanded="false"
      aria-controls="content-1"
      id="header-1"
    >
      Section 1
      <span aria-hidden="true">▼</span>
    </button>
  </h3>
  <div
    id="content-1"
    role="region"
    aria-labelledby="header-1"
    hidden
  >
    Content for section 1...
  </div>

  <h3>
    <button
      aria-expanded="false"
      aria-controls="content-2"
      id="header-2"
    >
      Section 2
      <span aria-hidden="true">▼</span>
    </button>
  </h3>
  <div
    id="content-2"
    role="region"
    aria-labelledby="header-2"
    hidden
  >
    Content for section 2...
  </div>
</div>
```

### JavaScript

```javascript
class Accordion {
  constructor(element) {
    this.buttons = element.querySelectorAll('button[aria-expanded]');

    this.buttons.forEach((button) => {
      button.addEventListener('click', () => this.toggle(button));
    });
  }

  toggle(button) {
    const expanded = button.getAttribute('aria-expanded') === 'true';
    const contentId = button.getAttribute('aria-controls');
    const content = document.getElementById(contentId);

    button.setAttribute('aria-expanded', !expanded);
    content.hidden = expanded;
  }
}
```

---

## Menu / Dropdown

### Structure

```html
<div class="menu-container">
  <button
    aria-haspopup="true"
    aria-expanded="false"
    aria-controls="menu"
  >
    Options
    <span aria-hidden="true">▼</span>
  </button>

  <ul
    role="menu"
    id="menu"
    aria-label="Options"
    hidden
  >
    <li role="none">
      <button role="menuitem" tabindex="-1">Edit</button>
    </li>
    <li role="none">
      <button role="menuitem" tabindex="-1">Duplicate</button>
    </li>
    <li role="separator"></li>
    <li role="none">
      <button role="menuitem" tabindex="-1">Delete</button>
    </li>
  </ul>
</div>
```

### Keyboard Navigation

```javascript
class Menu {
  constructor(trigger, menu) {
    this.trigger = trigger;
    this.menu = menu;
    this.items = menu.querySelectorAll('[role="menuitem"]');
    this.currentIndex = 0;

    this.trigger.addEventListener('click', () => this.toggle());
    this.trigger.addEventListener('keydown', (e) => this.handleTriggerKeydown(e));
    this.menu.addEventListener('keydown', (e) => this.handleMenuKeydown(e));
  }

  toggle() {
    const expanded = this.trigger.getAttribute('aria-expanded') === 'true';

    if (expanded) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.trigger.setAttribute('aria-expanded', 'true');
    this.menu.hidden = false;
    this.currentIndex = 0;
    this.items[0].focus();
  }

  close() {
    this.trigger.setAttribute('aria-expanded', 'false');
    this.menu.hidden = true;
    this.trigger.focus();
  }

  handleTriggerKeydown(event) {
    if (event.key === 'ArrowDown' || event.key === 'Enter') {
      event.preventDefault();
      this.open();
    }
  }

  handleMenuKeydown(event) {
    switch (event.key) {
      case 'ArrowDown':
        event.preventDefault();
        this.focusItem(this.currentIndex + 1);
        break;
      case 'ArrowUp':
        event.preventDefault();
        this.focusItem(this.currentIndex - 1);
        break;
      case 'Home':
        event.preventDefault();
        this.focusItem(0);
        break;
      case 'End':
        event.preventDefault();
        this.focusItem(this.items.length - 1);
        break;
      case 'Escape':
        this.close();
        break;
      case 'Tab':
        this.close();
        break;
    }
  }

  focusItem(index) {
    this.currentIndex = Math.max(0, Math.min(index, this.items.length - 1));
    this.items[this.currentIndex].focus();
  }
}
```

---

## Combobox (Autocomplete)

### Structure

```html
<div class="combobox">
  <label id="label" for="input">City</label>
  <div class="combobox-wrapper">
    <input
      type="text"
      id="input"
      role="combobox"
      aria-autocomplete="list"
      aria-expanded="false"
      aria-controls="listbox"
      aria-activedescendant=""
    >
    <ul
      id="listbox"
      role="listbox"
      aria-label="Cities"
      hidden
    >
      <li id="option-1" role="option">New York</li>
      <li id="option-2" role="option">Los Angeles</li>
      <li id="option-3" role="option">Chicago</li>
    </ul>
  </div>
</div>
```

### Visual States

```css
[role="option"] {
  padding: 8px 12px;
  cursor: pointer;
}

[role="option"]:hover,
[role="option"][aria-selected="true"] {
  background: var(--color-highlight);
}

[role="option"]:focus {
  outline: none;
  background: var(--color-focus);
}
```

---

## Alert / Notification

### Alert (Important, Immediate)

```html
<div role="alert" aria-live="assertive">
  Error: Your session has expired. Please log in again.
</div>
```

### Status (Informational)

```html
<div role="status" aria-live="polite">
  3 items added to cart
</div>
```

### Toast Notifications

```html
<div
  class="toast"
  role="status"
  aria-live="polite"
  aria-atomic="true"
>
  <span class="toast-message">Settings saved</span>
  <button
    aria-label="Dismiss notification"
    onclick="dismissToast()"
  >
    ×
  </button>
</div>
```

---

## Progress Indicators

### Progress Bar

```html
<div
  role="progressbar"
  aria-valuenow="25"
  aria-valuemin="0"
  aria-valuemax="100"
  aria-label="Upload progress"
>
  <div class="progress-fill" style="width: 25%"></div>
</div>
```

### Indeterminate Progress

```html
<div
  role="progressbar"
  aria-label="Loading"
  aria-busy="true"
>
  <span class="spinner" aria-hidden="true"></span>
</div>
```

### Loading States

```html
<!-- Loading content -->
<div aria-busy="true" aria-live="polite">
  <span class="sr-only">Loading results...</span>
  <div class="skeleton" aria-hidden="true"></div>
</div>

<!-- Button loading -->
<button aria-busy="true" aria-disabled="true">
  <span class="spinner" aria-hidden="true"></span>
  Saving...
</button>
```

---

## Form Patterns

### Required Fields

```html
<label for="email">
  Email
  <span aria-hidden="true">*</span>
</label>
<input
  id="email"
  type="email"
  required
  aria-required="true"
>
<p class="form-hint">* Required fields</p>
```

### Error Messages

```html
<div class="form-group">
  <label for="password">Password</label>
  <input
    id="password"
    type="password"
    aria-invalid="true"
    aria-describedby="password-error password-hint"
  >
  <p id="password-hint" class="hint">
    Must be at least 8 characters
  </p>
  <p id="password-error" class="error" role="alert">
    Password is too short
  </p>
</div>
```

### Error Summary

```html
<div
  role="alert"
  aria-labelledby="error-summary-title"
  tabindex="-1"
  id="error-summary"
>
  <h2 id="error-summary-title">
    There are 2 errors in your submission
  </h2>
  <ul>
    <li><a href="#email">Email is required</a></li>
    <li><a href="#password">Password is too short</a></li>
  </ul>
</div>
```

---

## ARIA Reference Tables

### Live Region Attributes

| Attribute | Values | Use |
|-----------|--------|-----|
| `aria-live` | off, polite, assertive | Announcement priority |
| `aria-atomic` | true, false | Announce whole region |
| `aria-relevant` | additions, removals, text, all | What changes to announce |

### Common Roles

| Role | Use Case |
|------|----------|
| `button` | Clickable actions |
| `link` | Navigation |
| `dialog` | Modal dialogs |
| `alert` | Important messages |
| `status` | Status updates |
| `tablist`, `tab`, `tabpanel` | Tab interfaces |
| `menu`, `menuitem` | Action menus |
| `listbox`, `option` | Selection lists |
| `combobox` | Autocomplete inputs |

### States and Properties

| Attribute | Values | Use |
|-----------|--------|-----|
| `aria-expanded` | true, false | Expandable elements |
| `aria-pressed` | true, false, mixed | Toggle buttons |
| `aria-selected` | true, false | Selected items |
| `aria-checked` | true, false, mixed | Checkboxes, radios |
| `aria-disabled` | true, false | Disabled state |
| `aria-hidden` | true, false | Hide from AT |
| `aria-invalid` | true, false | Validation state |
| `aria-busy` | true, false | Loading state |
