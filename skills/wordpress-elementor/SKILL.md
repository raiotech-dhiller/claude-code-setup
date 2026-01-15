---
name: wordpress-elementor
description: |
  Elementor and Elementor Pro development patterns for WordPress sites.
  Use when building pages with Elementor, creating custom widgets,
  extending Elementor functionality, or troubleshooting Elementor issues.
---

# WordPress Elementor Development

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Custom Widgets | `references/elementor-widgets.md` | Creating custom Elementor widgets |
| Dynamic Tags | `references/elementor-dynamic-tags.md` | Creating dynamic content |
| Theme Builder | `references/elementor-theme-builder.md` | Headers, footers, templates |
| Essential Addons | `references/essential-addons.md` | Using EA widgets and features |

## Elementor Architecture

### Container-Based Layout (Recommended)
```
Container (Flexbox/Grid)
├── Container (nested)
│   ├── Widget
│   └── Widget
└── Widget
```

### Legacy Section/Column (Avoid for new builds)
```
Section
├── Column
│   └── Widget
└── Column
    └── Widget
```

## Site Settings Strategy

### Global Colors
Define in Elementor > Site Settings > Global Colors:
```
Primary:    #[brand-color]
Secondary:  #[accent-color]
Text:       #[body-text]
Accent:     #[cta-color]
```

### Global Fonts
Define in Elementor > Site Settings > Global Fonts:
```
Primary:   [Heading font]
Secondary: [Body font]
Text:      [Body font - regular]
Accent:    [Special/accent font]
```

### Usage in Widgets
- Always use Global colors/fonts via picker
- Enables site-wide changes from one location
- Client can modify without editing pages

## Template Hierarchy

### Recommended Template Structure
```
Elementor > Templates > Theme Builder:
├── Header (Site-wide)
├── Footer (Site-wide)
├── Single Post
├── Archive
├── 404 Page
└── Search Results

Elementor > Templates > Saved Templates:
├── Hero Sections
├── CTA Blocks
├── Testimonial Layouts
├── Feature Sections
└── Contact Forms
```

## Responsive Design

### Breakpoints (Default)
| Device | Width | Elementor Setting |
|--------|-------|-------------------|
| Desktop | 1025px+ | Default |
| Tablet | 768-1024px | Tablet mode |
| Mobile | <768px | Mobile mode |

### Responsive Best Practices
```css
/* Use Elementor responsive controls instead of custom CSS when possible */

/* If custom CSS needed, use Elementor's responsive wrapper */
@media (max-width: 767px) {
  .elementor-element-[id] {
    /* mobile styles */
  }
}
```

### Common Responsive Patterns
- Stack columns on mobile (Elementor handles automatically)
- Reduce font sizes for mobile
- Hide decorative elements on mobile
- Adjust padding/margins per breakpoint
- Use different images for mobile (via conditions)

## Dynamic Content

### Dynamic Tags (Elementor Pro)
```
{post:title}           - Current post title
{post:excerpt}         - Post excerpt
{post:featured_image}  - Featured image
{author:name}          - Author name
{site:title}           - Site name
{acf:field_name}       - ACF field (if ACF installed)
{woo:product_price}    - WooCommerce price
```

### Query Loop Widget
- Use for repeating content
- Connect to custom post types
- Add filters and pagination
- Style once, applies to all

## Custom CSS Patterns

### Widget-Specific CSS
Add via Widget > Advanced > Custom CSS:
```css
/* 'selector' targets the widget wrapper */
selector {
  /* styles */
}

selector .elementor-heading-title {
  /* target specific element */
}
```

### Page-Specific CSS
Add via Page Settings > Custom CSS:
```css
body.elementor-page-[id] {
  /* page-specific styles */
}
```

### Site-Wide CSS
Add via Elementor > Custom Code or child theme:
```css
/* Target Elementor elements globally */
.elementor-widget-heading .elementor-heading-title {
  /* global heading styles */
}
```

## Performance Optimization

### DOM Reduction
- Avoid excessive nesting
- Use CSS Grid over nested containers when possible
- Combine widgets where logical
- Remove empty containers/sections

### Asset Loading
- Use Elementor's built-in lazy load
- Disable unused widgets in Elementor > Settings
- Use optimized image formats (WebP)
- Minimize custom JavaScript

### Caching Considerations
- Rocket.net handles server caching
- Elementor CSS is generated and cached
- Clear cache after major changes:
  - Elementor > Tools > Regenerate CSS
  - Rocket.net dashboard > Clear Cache

## Common Issues & Fixes

### Layout Breaking
| Issue | Cause | Fix |
|-------|-------|-----|
| Content overflow | Fixed widths | Use % or viewport units |
| Spacing inconsistent | Mixed units | Standardize on rem/em |
| Mobile layout broken | Desktop-only settings | Check responsive mode |

### Elementor CSS Not Loading
```bash
# Regenerate CSS
wp elementor flush-css

# Check permissions
chmod -R 755 wp-content/uploads/elementor/
```

### Widget Not Displaying
1. Check display conditions
2. Verify Elementor Pro license active
3. Check for JavaScript errors
4. Clear all caches

## Elementor + WooCommerce

### Product Page Builder
- Use Theme Builder > Single Product
- Customize with WooCommerce widgets
- Add upsells/cross-sells
- Custom checkout styling

### Shop Page Customization
- Theme Builder > Product Archive
- Query Loop for custom layouts
- Filter/sort integration
