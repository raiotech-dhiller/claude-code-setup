# Essential Addons for Elementor

## Overview

Essential Addons extends Elementor with 90+ widgets and extensions. Key widgets relevant to your workflow are documented here.

## Most Useful Widgets

### Content Widgets

#### Post Grid / Post Timeline
Display posts in grid or timeline format.
- Query posts by category, tag, custom taxonomy
- Multiple layout options
- Pagination support
- Good for blog archives within pages

```
Use Cases:
- Homepage blog section
- Related posts (when Elementor's isn't sufficient)
- Portfolio displays
- News/updates sections
```

#### Filterable Gallery
Image gallery with category filtering.
- Isotope filtering
- Lightbox support
- Multiple layouts
- Animation effects

```
Use Cases:
- Portfolio pages
- Product showcases
- Before/after galleries
- Team or case study displays
```

#### Advanced Tabs / Advanced Accordion
Enhanced tab and accordion widgets.
- Nested Elementor content
- Icon support
- More styling options than core

```
Use Cases:
- FAQ sections
- Service descriptions
- Product features
- Pricing comparisons
```

#### Flip Box
Two-sided box with flip animation.
- Front/back content areas
- Multiple flip directions
- Icon, image, content support

```
Use Cases:
- Team member cards
- Service highlights
- Feature showcases
```

### Form & Conversion Widgets

#### Call to Action
Enhanced CTA boxes.
- Image/content combinations
- Ribbon badges
- Multiple layouts

#### Pricing Table
Professional pricing display.
- Feature lists
- Ribbons/badges
- Button styling

### Dynamic Content Widgets

#### Dynamic Gallery
Gallery from posts, custom post types.
- Query-based
- Filter support
- Multiple layouts

#### Post Carousel
Posts in carousel format.
- Custom queries
- Multiple slides visible
- Navigation options

#### Content Ticker
Scrolling content ticker.
- Post-based or manual
- Multiple animation types

### Creative Widgets

#### Animated Text
Text with typing, rotating, highlighted effects.
- Multiple animation styles
- Customizable timing

#### Countdown Timer
Timer with multiple styles.
- Evergreen or fixed date
- Redirect on expire
- Multiple layouts

#### Progress Bar
Animated progress indicators.
- Multiple styles
- Customizable colors
- Animation on scroll

### WooCommerce Widgets

#### Woo Product Grid
Enhanced product grid.
- Better styling options
- Quick view
- Category filtering

#### Woo Product Carousel
Products in carousel.
- Navigation options
- Multiple slides

#### Woo Product Compare
Product comparison feature.

## Extensions

### Reading Progress Bar
Shows reading progress on posts/pages.
- Global or per-page
- Position options
- Style customization

**Enable:** Essential Addons > Extensions > Reading Progress Bar

### Table of Contents
Auto-generated TOC from headings.
- Sticky option
- Collapsible
- Custom styling

### Scroll to Top
Scroll to top button.
- Multiple styles
- Position options
- Animation

### Custom JS
Add JavaScript to specific pages.
- Per-page scripts
- Global scripts

## Configuration

### Asset Loading
Essential Addons only loads assets for widgets in use.

**Settings:** Essential Addons > Elements
- Disable unused widgets (improves performance)
- Group by category

### Recommended Disabled Widgets
Unless actively using, disable:
- InfoBox (use Elementor's Icon Box)
- Dual Color Heading (use Elementor's Animated Headline)
- Data Table (unless needed)
- Social feeds (if not using)
- All integrations you don't use (Mailchimp, etc.)

## Common Widget Configurations

### Post Grid - Blog Section
```
Query:
  Source: Posts
  Include By: Terms > Categories > [Blog]
  Posts Per Page: 6
  Order By: Date
  
Layout:
  Preset: Grid Style 1
  Columns: 3
  
Style:
  [Customize to match site design]
```

### Filterable Gallery - Portfolio
```
Settings:
  Filter Controls: Yes
  Gallery Items: [Add items with categories]
  
Layout:
  Preset: Grid
  Columns: 3
  
Filter:
  All Label: "All Work"
  [Categories match your portfolio types]
```

### Pricing Table - Standard Setup
```
Header:
  Title: [Plan Name]
  Subtitle: [Description]
  
Pricing:
  Price: $XX
  Period: /month
  
Features:
  [Add feature items]
  
Button:
  Text: "Get Started"
  Link: [Checkout/Contact]
  
Ribbon:
  Show: Yes (for popular plan)
  Text: "Most Popular"
```

## Performance Tips

### Minimize Widget Use
- Use native Elementor widgets when sufficient
- Only use EA widgets for enhanced functionality
- Disable unused widgets in settings

### Asset Loading
EA has good asset loading, but verify:
- No unused EA CSS/JS loading
- Test page speed after adding EA widgets

### Caching
- EA works well with Rocket.net caching
- Clear cache after adding/configuring EA widgets
- Regenerate Elementor CSS after changes

## Troubleshooting

### Widget Not Appearing
1. Check widget is enabled in EA settings
2. Clear cache
3. Check for JavaScript errors
4. Verify Elementor and EA versions compatible

### Styling Not Applying
1. Check specificity (add custom CSS if needed)
2. Clear cache
3. Regenerate Elementor CSS
4. Check for theme conflicts

### Performance Issues
1. Disable unused widgets
2. Check for duplicate functionality
3. Audit page for excessive widget use
4. Test with EA deactivated to isolate issue
