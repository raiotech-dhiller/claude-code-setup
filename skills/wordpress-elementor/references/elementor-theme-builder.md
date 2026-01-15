# Elementor Theme Builder

## Overview

Theme Builder (Elementor Pro) allows you to design every part of your WordPress theme without coding. This creates consistency across your site and simplifies management.

## Template Types

### Header
- Site-wide navigation
- Logo placement
- Mobile menu
- Sticky behavior
- Transparent header options

### Footer
- Site-wide footer
- Widgets/columns layout
- Copyright info
- Social links

### Single Post
- Blog post layout
- Post meta display
- Author box
- Related posts
- Comments section

### Single Page
- Default page layout
- Specific page templates

### Archive
- Blog archive/category pages
- Custom post type archives
- Search results

### Product (WooCommerce)
- Single Product
- Product Archive/Shop
- Cart
- Checkout
- My Account

### 404 Page
- Custom error page

### Search Results
- Search results layout

## Building Site Headers

### Basic Header Structure
```
Container (Direction: Row, Justify: Space Between, Align: Center)
├── Site Logo Widget
├── Nav Menu Widget
└── Container (Action buttons)
    ├── Button Widget (CTA)
    └── Search Widget
```

### Sticky Header
1. Select header container/section
2. Advanced > Motion Effects > Sticky
3. Set "Sticky On" (Top)
4. Set devices (Desktop, Tablet, Mobile)
5. Optional: Effects on Scroll (shrink, change background)

### Transparent Header
1. Create header template
2. Set background to transparent
3. In display conditions, choose specific pages
4. On those pages, adjust first section padding to overlap header

### Mobile Menu
Nav Menu Widget settings:
- Breakpoint: Tablet or Mobile
- Toggle Button: Hamburger icon
- Full Width: Yes/No
- Toggle Align: Right (typically)

## Building Footers

### Multi-Column Footer
```
Container (Direction: Column)
├── Container (Direction: Row, 4 columns)
│   ├── Container (About/Logo)
│   │   ├── Image Widget (Logo)
│   │   └── Text Widget (Description)
│   ├── Container (Quick Links)
│   │   ├── Heading Widget
│   │   └── Icon List Widget (Links)
│   ├── Container (Services)
│   │   ├── Heading Widget
│   │   └── Icon List Widget (Links)
│   └── Container (Contact)
│       ├── Heading Widget
│       └── Icon List Widget (Contact info)
└── Container (Copyright bar)
    ├── Text Widget (© 2025 Company)
    └── Social Icons Widget
```

## Single Post Templates

### Standard Blog Post Layout
```
Container
├── Post Title Widget (Dynamic: Post Title)
├── Post Info Widget (Date, Author, Categories)
├── Post Featured Image Widget
├── Post Content Widget
├── Post Navigation Widget (Prev/Next)
├── Author Box Widget
└── Post Comments Widget
```

### Using Dynamic Tags in Posts
- Title: {post:title}
- Featured Image: {post:featured_image}
- Content: Use Post Content widget (auto-pulls content)
- Date: {post:date} or Post Info widget

## Archive Templates

### Blog Archive Layout
```
Container
├── Archive Title Widget
├── Archive Posts Widget
│   └── Configure: Layout, Columns, Pagination
└── (Optional) Sidebar Container
```

### Archive Posts Widget Settings
- Skin: Classic/Cards/Full Content
- Columns: 2-4 for grid
- Posts Per Page: Match Reading Settings or custom
- Pagination: Numbers/Load More/Infinite Scroll
- Query: Default (archive) or custom

## Display Conditions

### Condition Types
| Condition | Use Case |
|-----------|----------|
| Entire Site | Headers/footers |
| All Singular | Single posts/pages |
| All Archives | Category/tag pages |
| Front Page | Homepage only |
| Specific Pages | Named pages |
| Posts in Category | Category-specific templates |
| WooCommerce | Product/shop pages |

### Condition Logic
- Include: Show template on these
- Exclude: Don't show on these (overrides include)
- Priority: When multiple templates match, higher number wins

### Common Condition Setups

**Site-wide header with different homepage header:**
```
Header 1:
  Include: Entire Site
  Exclude: Front Page

Header 2 (Transparent):
  Include: Front Page
```

**Different single post template for category:**
```
Default Post Template:
  Include: All Singular > Posts

Featured Post Template:
  Include: All Singular > Posts in Category > Featured
```

## Theme Builder + WooCommerce

### Single Product Template
```
Container
├── Product Images Widget
├── Container (Product Details)
│   ├── Product Title Widget
│   ├── Product Rating Widget
│   ├── Product Price Widget
│   ├── Product Short Description Widget
│   ├── Add to Cart Widget
│   └── Product Meta Widget (SKU, Categories)
├── Product Tabs Widget (Description, Reviews, etc.)
├── Related Products Widget
└── Upsells Widget
```

### Product Archive/Shop Template
```
Container
├── Archive Title Widget (or custom heading)
├── Archive Products Widget
│   └── Configure columns, pagination
├── (Optional) Filter sidebar
```

### Cart Page
Usually customize via:
- WooCommerce > Cart widget
- Or Elementor's Cart widget (Pro)

### Checkout Page
- WooCommerce > Checkout widget
- Style via Custom CSS or Elementor's checkout widget

## Template Best Practices

### Naming Convention
```
[Type] - [Description] - [Variation]
Examples:
Header - Main - Sticky
Header - Transparent - Homepage
Footer - Main
Single - Post - Default
Single - Post - Featured
Archive - Blog
Archive - Category - News
Product - Single - Default
```

### Template Organization
1. Create base templates first (header, footer)
2. Build single templates with dynamic content
3. Create archive templates
4. Add variation templates as needed
5. Test all conditions

### Performance Considerations
- Reuse templates where possible
- Use Global Widgets for repeating elements
- Avoid complex conditions (simplify logic)
- Test template loading speed

## Troubleshooting

### Template Not Displaying
1. Check display conditions
2. Verify no conflicting conditions
3. Check template status (Published)
4. Clear cache (Elementor + Rocket.net)

### Header/Footer Not Full Width
1. Check page layout (Elementor Canvas or Full Width)
2. Verify container is set to Full Width
3. Check theme settings for container width

### Dynamic Content Not Showing
1. Verify correct dynamic tag selected
2. Check if post has the required data
3. Test on published content (not draft)

### Condition Conflicts
1. Review all templates with overlapping conditions
2. Adjust priority (higher number = higher priority)
3. Use Exclude conditions to resolve
