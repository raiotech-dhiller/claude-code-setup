# Rocket.net Performance Optimization

## Rocket.net Built-in Optimizations

### What Rocket.net Handles
- **CDN**: Global Cloudflare Enterprise CDN
- **Caching**: Full page caching at edge
- **SSL**: Automatic SSL with HTTP/2
- **Compression**: Gzip/Brotli compression
- **PHP**: Optimized PHP with OPcache
- **Database**: Optimized MySQL configuration

### What You Don't Need
```
# DO NOT INSTALL - Rocket.net provides these
- W3 Total Cache
- WP Super Cache
- LiteSpeed Cache
- WP Rocket (conflicts may occur)
- Cloudflare plugin
- CDN plugins
- Most caching plugins
```

## Your Optimization Responsibilities

### 1. Image Optimization

#### Before Upload (Best)
- Resize to max display size
- Compress using ImageOptim, TinyPNG, Squoosh
- Use WebP format when possible
- Aim for <200KB for hero images, <100KB for thumbnails

#### Smush Plugin (Post-upload)
```
Settings:
- Auto-Smush: Enable
- Strip metadata: Enable
- Lazy Load: Enable (unless Elementor handles it)
- WebP: Enable if server supports
- Resize original: Set max width (e.g., 2000px)
```

#### Elementor Image Settings
- Use appropriate image sizes (not full size everywhere)
- Enable lazy load in Elementor settings
- Use CSS object-fit over oversized images

### 2. Elementor Performance

#### Elementor Settings
```
Settings > Performance:
- CSS Print Method: External File
- Optimized DOM Output: Enable
- Improved Asset Loading: Enable
- Font Display: Swap (for faster text rendering)
```

#### Page-Level Optimization
- Minimize widget count per page (<50 recommended)
- Avoid excessive nesting
- Use Global Widgets for repeating elements
- Use CSS Grid layouts over nested containers

#### Asset Loading
```
Settings > Features:
- Disable unused widgets (reduces JS/CSS)
- Disable features you don't use
```

### 3. Theme Performance

#### Child Theme Best Practices
```php
// functions.php - Dequeue unnecessary styles/scripts
add_action('wp_enqueue_scripts', function() {
    // Remove block library CSS if not using Gutenberg
    if (!is_admin()) {
        wp_dequeue_style('wp-block-library');
        wp_dequeue_style('wp-block-library-theme');
        wp_dequeue_style('wc-blocks-style'); // WooCommerce blocks
    }
}, 100);

// Disable emojis
remove_action('wp_head', 'print_emoji_detection_script', 7);
remove_action('wp_print_styles', 'print_emoji_styles');

// Disable embeds (if not using oEmbed)
add_action('init', function() {
    remove_action('rest_api_init', 'wp_oembed_register_route');
    remove_filter('oembed_dataparse', 'wp_filter_oembed_result', 10);
    remove_action('wp_head', 'wp_oembed_add_discovery_links');
});
```

### 4. Plugin Performance

#### Plugin Audit
```
Keep:                           Remove/Replace:
- Elementor Pro                 - Unused plugins
- WooCommerce (if needed)       - Overlapping functionality
- RankMath Pro                  - Resource-heavy plugins
- WP Mail SMTP                  - Old/unmaintained plugins
- Smush                         
- Essential Addons              
```

#### Conditional Plugin Loading
```php
// Load plugins only where needed (advanced)
add_filter('option_active_plugins', function($plugins) {
    if (!is_admin()) {
        // Remove contact form plugin from non-contact pages
        if (!is_page('contact')) {
            $key = array_search('wpforms/wpforms.php', $plugins);
            if ($key !== false) unset($plugins[$key]);
        }
    }
    return $plugins;
});
```

### 5. Database Optimization

#### Regular Cleanup
```
RankMath > Status & Tools > Database Tools:
- Clean orphaned term relationships
- Clean expired transients
- Clean orphaned post meta

Or via WP-CLI:
wp transient delete --expired
wp db optimize
```

#### Revisions Management
```php
// Limit post revisions
define('WP_POST_REVISIONS', 5);

// Or disable entirely (not recommended)
define('WP_POST_REVISIONS', false);
```

### 6. Font Optimization

#### Font Loading Strategy
```php
// Preload critical fonts
add_action('wp_head', function() {
    ?>
    <link rel="preload" href="<?php echo get_stylesheet_directory_uri(); ?>/assets/fonts/main-font.woff2" as="font" type="font/woff2" crossorigin>
    <?php
}, 1);
```

#### Google Fonts (if using)
```php
// Self-host Google Fonts (faster, GDPR compliant)
// Download from google-webfonts-helper.herokuapp.com
// Add to theme and enqueue locally
```

## Cache Management

### When to Clear Cache

| Action | Clear Cache? |
|--------|--------------|
| Content change | Usually auto-cleared |
| Plugin update | Yes |
| Theme file change | Yes |
| Elementor template edit | Yes + Regenerate CSS |
| CSS/JS file change | Yes |
| WooCommerce product update | Usually auto-cleared |

### Cache Clear Sequence
1. Elementor > Tools > Regenerate CSS
2. Clear Rocket.net cache
3. Clear browser cache (for testing)

### Cache Headers Check
```bash
# Check cache headers
curl -I https://yoursite.com | grep -i cache
# Should see: cache-control, cf-cache-status
```

## Monitoring Performance

### Tools
- **PageSpeed Insights**: https://pagespeed.web.dev
- **GTmetrix**: https://gtmetrix.com
- **WebPageTest**: https://webpagetest.org

### Target Metrics
| Metric | Target |
|--------|--------|
| Largest Contentful Paint (LCP) | <2.5s |
| First Input Delay (FID) | <100ms |
| Cumulative Layout Shift (CLS) | <0.1 |
| Time to First Byte (TTFB) | <600ms |
| Total Page Size | <2MB |
| Total Requests | <50 |

### Common Issues & Fixes

| Issue | Typical Cause | Fix |
|-------|---------------|-----|
| High LCP | Large hero image | Optimize image, preload |
| High CLS | Fonts/images loading | Set dimensions, preload fonts |
| Many requests | Excessive plugins/widgets | Audit and reduce |
| Large page size | Unoptimized images | Compress, resize |
| Slow TTFB | Database issues | Optimize queries, check hosting |

## WooCommerce Performance

### Store Optimization
```php
// Disable WooCommerce cart fragments on non-cart pages
add_action('wp_enqueue_scripts', function() {
    if (!is_woocommerce() && !is_cart() && !is_checkout()) {
        wp_dequeue_script('wc-cart-fragments');
    }
}, 99);

// Limit related products
add_filter('woocommerce_output_related_products_args', function($args) {
    $args['posts_per_page'] = 4;
    return $args;
});
```

### Product Images
- Use WebP for product images
- Set appropriate thumbnail sizes
- Enable lazy loading for product galleries

## Performance Testing Workflow

### Before Launch
1. Run PageSpeed Insights on key pages
2. Note baseline scores
3. Address critical issues

### Regular Monitoring
1. Monthly performance check
2. After major updates
3. After adding new plugins

### Quick Test Checklist
```
□ Homepage < 3s load time
□ Product pages < 3s load time
□ No console errors
□ Images lazy loading
□ No layout shift on load
□ Mobile performance acceptable
```
