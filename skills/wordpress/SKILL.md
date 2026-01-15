---
name: wordpress
description: |
  WordPress development for themes, plugins, and Gutenberg blocks.
  Use when working with WordPress sites, creating themes/plugins,
  or building custom blocks.
---

# WordPress Development

## Theme Structure
```
theme-name/
├── style.css              # Theme header + styles
├── functions.php          # Theme setup
├── index.php              # Main template
├── template-parts/        # Reusable parts
├── inc/                   # PHP includes
└── assets/                # CSS/JS/images
```

## Plugin Structure
```
plugin-name/
├── plugin-name.php        # Plugin header
├── includes/              # PHP classes
├── admin/                 # Admin functionality
├── public/                # Frontend functionality
└── languages/             # Translations
```

## Security Essentials
```php
// Escape output
echo esc_html($text);
echo esc_attr($attribute);
echo esc_url($url);
echo wp_kses_post($html);

// Sanitize input
$clean = sanitize_text_field($_POST['field']);
$email = sanitize_email($_POST['email']);
$int = absint($_POST['number']);

// Verify nonce
if (!wp_verify_nonce($_POST['nonce'], 'action_name')) {
    die('Security check failed');
}
```

## Gutenberg Block
```javascript
registerBlockType('namespace/block-name', {
    title: 'Block Name',
    icon: 'smiley',
    category: 'common',
    attributes: {
        content: { type: 'string' }
    },
    edit: ({ attributes, setAttributes }) => {
        // Editor view
    },
    save: ({ attributes }) => {
        // Frontend view
    }
});
```

## Hooks System
```php
// Actions (do something)
add_action('init', 'my_function');
add_action('wp_enqueue_scripts', 'enqueue_assets');

// Filters (modify something)
add_filter('the_content', 'modify_content');
add_filter('the_title', 'modify_title');
```
