---
name: woocommerce-elementor
description: |
  WooCommerce development with Elementor page builder integration.
  Use when building e-commerce features, customizing product pages,
  checkout flows, or integrating WooCommerce with Elementor templates.
---

# WooCommerce + Elementor Development

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Product Templates | `references/woo-product-templates.md` | Customizing product pages |
| Checkout | `references/woo-checkout.md` | Checkout customization |
| Hooks | `references/woocommerce-hooks.md` | Custom WooCommerce functionality |

## Elementor WooCommerce Widgets

### Product Widgets (Single Product Template)
| Widget | Purpose |
|--------|---------|
| Product Title | Display product name |
| Product Images | Main image + gallery |
| Product Price | Price with sale formatting |
| Product Rating | Star rating display |
| Product Stock | Stock status |
| Product Meta | SKU, categories, tags |
| Product Short Description | Brief description |
| Product Content | Full description |
| Product Add to Cart | Add to cart button |
| Product Tabs | Description/Reviews/Additional |
| Product Related | Related products grid |
| Upsells | Upsell products |

### Archive Widgets (Shop/Category Templates)
| Widget | Purpose |
|--------|---------|
| Archive Products | Products grid with filters |
| Archive Title | Category/shop title |
| Archive Description | Category description |
| Products | Manual product selection |

### Cart & Checkout Widgets
| Widget | Purpose |
|--------|---------|
| Cart | Full cart display |
| Checkout | Checkout form |
| My Account | Account pages |
| Menu Cart | Mini cart for header |

## Product Page Template

### Basic Single Product Structure
```
Theme Builder > Single Product

Container (Full Width)
├── Container (Product Top - Row)
│   ├── Container (50% - Images)
│   │   └── Product Images Widget
│   └── Container (50% - Details)
│       ├── Product Title Widget
│       ├── Product Rating Widget
│       ├── Product Price Widget
│       ├── Product Short Description Widget
│       ├── Product Add to Cart Widget
│       └── Product Meta Widget
│
├── Product Tabs Widget
│
├── Container (Related Products)
│   ├── Heading Widget ("You May Also Like")
│   └── Product Related Widget
│
└── Container (Upsells)
    ├── Heading Widget ("Frequently Bought Together")
    └── Upsells Widget
```

### Display Conditions
```
Include: Products > All
Exclude: (specific products if needed)
```

## Shop Page Template

### Shop Archive Structure
```
Theme Builder > Product Archive

Container
├── Container (Header)
│   ├── Archive Title Widget
│   └── Archive Description Widget
│
├── Container (Main - Row)
│   ├── Container (Sidebar - Optional)
│   │   ├── Product Categories Widget
│   │   └── Filter widgets
│   └── Container (Products)
│       └── Archive Products Widget
│           - Columns: 3-4
│           - Pagination: Yes
│           - Results Count: Yes
│           - Ordering: Yes
```

## WooCommerce Customization

### functions.php Snippets

#### Change Add to Cart Text
```php
add_filter('woocommerce_product_single_add_to_cart_text', function() {
    return 'Buy Now';
});

add_filter('woocommerce_product_add_to_cart_text', function() {
    return 'Add to Basket';
});
```

#### Custom Product Tabs
```php
// Add custom tab
add_filter('woocommerce_product_tabs', function($tabs) {
    $tabs['sizing'] = [
        'title'    => 'Size Guide',
        'priority' => 50,
        'callback' => function() {
            echo '<h2>Size Guide</h2>';
            echo '<p>Size guide content here...</p>';
        }
    ];
    return $tabs;
});

// Remove tabs
add_filter('woocommerce_product_tabs', function($tabs) {
    unset($tabs['reviews']);      // Remove reviews
    unset($tabs['additional_information']); // Remove additional info
    return $tabs;
}, 98);
```

#### Customize Related Products
```php
add_filter('woocommerce_output_related_products_args', function($args) {
    $args['posts_per_page'] = 4;
    $args['columns'] = 4;
    return $args;
});
```

#### Add Content After Add to Cart
```php
add_action('woocommerce_after_add_to_cart_button', function() {
    echo '<div class="trust-badges">';
    echo '<span>✓ Free Shipping</span>';
    echo '<span>✓ 30-Day Returns</span>';
    echo '</div>';
});
```

### CSS Customization

#### Price Styling
```css
/* Regular price */
.woocommerce .price {
    font-size: 24px;
    font-weight: 700;
    color: var(--e-global-color-primary);
}

/* Sale price */
.woocommerce .price del {
    opacity: 0.5;
    font-size: 0.8em;
}

.woocommerce .price ins {
    color: #e74c3c;
    text-decoration: none;
}
```

#### Add to Cart Button
```css
.woocommerce .single_add_to_cart_button {
    background-color: var(--e-global-color-accent);
    padding: 15px 40px;
    font-weight: 600;
    text-transform: uppercase;
}

.woocommerce .single_add_to_cart_button:hover {
    background-color: var(--e-global-color-primary);
}
```

#### Product Grid
```css
/* Product card styling */
.woocommerce ul.products li.product {
    text-align: center;
}

.woocommerce ul.products li.product .woocommerce-loop-product__title {
    font-size: 16px;
    padding: 10px 0;
}

/* Sale badge */
.woocommerce span.onsale {
    background-color: #e74c3c;
    padding: 8px 12px;
    min-height: auto;
    min-width: auto;
    line-height: 1;
}
```

## Checkout Customization

### Elementor Checkout Widget
Use Theme Builder > Checkout with Elementor's Checkout widget for full customization.

### Remove Checkout Fields
```php
add_filter('woocommerce_checkout_fields', function($fields) {
    // Remove company field
    unset($fields['billing']['billing_company']);
    
    // Remove order notes
    unset($fields['order']['order_comments']);
    
    // Make phone optional
    $fields['billing']['billing_phone']['required'] = false;
    
    return $fields;
});
```

### Reorder Checkout Fields
```php
add_filter('woocommerce_checkout_fields', function($fields) {
    $fields['billing']['billing_email']['priority'] = 5;
    $fields['billing']['billing_phone']['priority'] = 6;
    return $fields;
});
```

### Custom Checkout Validation
```php
add_action('woocommerce_checkout_process', function() {
    if (empty($_POST['billing_phone'])) {
        wc_add_notice('Phone number is required for shipping updates.', 'error');
    }
});
```

## LeadConnector Integration

### WooCommerce to LeadConnector
```php
// After order completed, send to LeadConnector
add_action('woocommerce_order_status_completed', function($order_id) {
    $order = wc_get_order($order_id);
    
    $data = [
        'email' => $order->get_billing_email(),
        'first_name' => $order->get_billing_first_name(),
        'last_name' => $order->get_billing_last_name(),
        'phone' => $order->get_billing_phone(),
        'tags' => ['customer', 'woocommerce'],
    ];
    
    // Send to LeadConnector via API or webhook
});
```

## WP Fusion Integration

### Automatic Tag Application
Configure in WP Fusion settings:
- Apply tags on purchase
- Apply tags based on product
- Apply tags based on category
- Remove tags on refund

### Custom WP Fusion Logic
```php
// Apply tag based on order total
add_action('woocommerce_order_status_completed', function($order_id) {
    if (!function_exists('wp_fusion')) return;
    
    $order = wc_get_order($order_id);
    $total = $order->get_total();
    $user_id = $order->get_user_id();
    
    if ($total > 500) {
        wp_fusion()->user->apply_tags(['vip-customer'], $user_id);
    }
});
```

## Performance Considerations

### WooCommerce + Elementor
```php
// Disable cart fragments AJAX on non-cart pages
add_action('wp_enqueue_scripts', function() {
    if (!is_cart() && !is_checkout() && !is_woocommerce()) {
        wp_dequeue_script('wc-cart-fragments');
    }
}, 99);
```

### Optimize Product Queries
```php
// Limit products in widgets
add_filter('woocommerce_shortcode_products_query', function($query_args) {
    $query_args['posts_per_page'] = 8;
    return $query_args;
});
```

## Common Issues

### Add to Cart Not Working
1. Check for JavaScript errors
2. Clear all caches
3. Regenerate Elementor CSS
4. Check WooCommerce cart page is set

### Price Not Showing
1. Check product has price set
2. Check Elementor widget settings
3. Verify correct template active

### Checkout Issues
1. Check WooCommerce pages assigned
2. Test with default theme
3. Check for plugin conflicts
4. Verify payment gateway configured
