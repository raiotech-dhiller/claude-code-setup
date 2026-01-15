# Elementor Dynamic Tags

## Overview

Dynamic tags allow you to display dynamic content in Elementor widgets without hardcoding values. Essential for template creation and maintaining consistency.

## Built-in Dynamic Tags

### Post Tags
| Tag | Description | Example Output |
|-----|-------------|----------------|
| `{post:title}` | Post/page title | "My Blog Post" |
| `{post:excerpt}` | Post excerpt | "This is the excerpt..." |
| `{post:content}` | Full post content | [HTML content] |
| `{post:date}` | Post date | "January 15, 2025" |
| `{post:featured_image}` | Featured image URL | URL to image |
| `{post:url}` | Post permalink | https://site.com/post |
| `{post:id}` | Post ID | 123 |
| `{post:terms}` | Post categories/tags | "Category 1, Category 2" |

### Author Tags
| Tag | Description |
|-----|-------------|
| `{author:name}` | Author display name |
| `{author:bio}` | Author biography |
| `{author:avatar}` | Author avatar image |
| `{author:url}` | Author archive URL |
| `{author:email}` | Author email |

### Site Tags
| Tag | Description |
|-----|-------------|
| `{site:title}` | Site name |
| `{site:tagline}` | Site tagline |
| `{site:url}` | Site URL |
| `{site:logo}` | Site logo |

### Archive Tags
| Tag | Description |
|-----|-------------|
| `{archive:title}` | Archive title |
| `{archive:description}` | Archive description |

### WooCommerce Tags (if WC active)
| Tag | Description |
|-----|-------------|
| `{woo:product_price}` | Product price |
| `{woo:product_title}` | Product name |
| `{woo:product_image}` | Product image |
| `{woo:sale_badge}` | Sale badge |
| `{woo:stock_status}` | In stock/Out of stock |
| `{woo:add_to_cart}` | Add to cart button |

### Request Tags
| Tag | Description |
|-----|-------------|
| `{request:get}` | GET parameter value |
| `{request:url}` | Current URL |

## Using Dynamic Tags

### In Widget Settings
1. Click the widget setting field
2. Look for the dynamic tag icon (stack icon)
3. Click to open dynamic tag selector
4. Choose appropriate tag
5. Configure tag settings if available

### Supported Widget Fields
- Text fields (headings, text editor)
- URL fields (buttons, links)
- Image fields (image widgets, backgrounds)
- Number fields (counters)
- Some style settings

## Creating Custom Dynamic Tags

### Basic Dynamic Tag Structure

```php
<?php
/**
 * Custom Dynamic Tag
 */

if (!defined('ABSPATH')) exit;

class Custom_Dynamic_Tag extends \Elementor\Core\DynamicTags\Tag {

    /**
     * Tag name (slug)
     */
    public function get_name() {
        return 'custom-dynamic-tag';
    }

    /**
     * Tag title
     */
    public function get_title() {
        return __('Custom Tag', 'theme-child');
    }

    /**
     * Tag group
     */
    public function get_group() {
        return 'site';
    }

    /**
     * Tag categories (what field types can use this)
     */
    public function get_categories() {
        return [\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY];
    }

    /**
     * Register controls (optional settings for the tag)
     */
    protected function register_controls() {
        $this->add_control(
            'custom_option',
            [
                'label' => __('Option', 'theme-child'),
                'type' => \Elementor\Controls_Manager::SELECT,
                'options' => [
                    'value1' => __('Value 1', 'theme-child'),
                    'value2' => __('Value 2', 'theme-child'),
                ],
                'default' => 'value1',
            ]
        );
    }

    /**
     * Render tag output
     */
    public function render() {
        $option = $this->get_settings('custom_option');
        
        // Your logic here
        $output = 'Dynamic content based on ' . $option;
        
        echo esc_html($output);
    }
}
```

### Image/URL Dynamic Tag

```php
<?php
class Custom_Image_Tag extends \Elementor\Core\DynamicTags\Data_Tag {

    public function get_name() {
        return 'custom-image-tag';
    }

    public function get_title() {
        return __('Custom Image', 'theme-child');
    }

    public function get_group() {
        return 'media';
    }

    public function get_categories() {
        return [\Elementor\Modules\DynamicTags\Module::IMAGE_CATEGORY];
    }

    public function get_value(array $options = []) {
        // Return image data array
        $image_url = 'https://example.com/image.jpg';
        $image_id = attachment_url_to_postid($image_url);
        
        return [
            'id' => $image_id,
            'url' => $image_url,
        ];
    }
}
```

### Registering Custom Tags

```php
<?php
/**
 * Register custom dynamic tag group and tags
 */
add_action('elementor/dynamic_tags/register', function($dynamic_tags) {
    
    // Register custom group (optional)
    $dynamic_tags->register_group(
        'custom-group',
        [
            'title' => __('Custom Tags', 'theme-child'),
        ]
    );
    
    // Include and register tag
    require_once get_stylesheet_directory() . '/elementor/dynamic-tags/class-custom-tag.php';
    $dynamic_tags->register(new \Custom_Dynamic_Tag());
});
```

## Tag Categories

Categories determine what field types the tag can be used with:

```php
// Text output
\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY

// URL/link
\Elementor\Modules\DynamicTags\Module::URL_CATEGORY

// Image
\Elementor\Modules\DynamicTags\Module::IMAGE_CATEGORY

// Gallery
\Elementor\Modules\DynamicTags\Module::GALLERY_CATEGORY

// Media (image, video, etc.)
\Elementor\Modules\DynamicTags\Module::MEDIA_CATEGORY

// Number
\Elementor\Modules\DynamicTags\Module::NUMBER_CATEGORY

// Post meta
\Elementor\Modules\DynamicTags\Module::POST_META_CATEGORY

// Color (for style settings)
\Elementor\Modules\DynamicTags\Module::COLOR_CATEGORY
```

## Practical Examples

### Display Custom Field (without ACF)
```php
<?php
class Post_Meta_Tag extends \Elementor\Core\DynamicTags\Tag {

    public function get_name() {
        return 'post-meta-tag';
    }

    public function get_title() {
        return __('Post Meta', 'theme-child');
    }

    public function get_group() {
        return 'post';
    }

    public function get_categories() {
        return [\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY];
    }

    protected function register_controls() {
        $this->add_control(
            'meta_key',
            [
                'label' => __('Meta Key', 'theme-child'),
                'type' => \Elementor\Controls_Manager::TEXT,
            ]
        );
    }

    public function render() {
        $meta_key = $this->get_settings('meta_key');
        if (empty($meta_key)) return;
        
        $value = get_post_meta(get_the_ID(), $meta_key, true);
        echo esc_html($value);
    }
}
```

### Display User Data
```php
<?php
class User_Data_Tag extends \Elementor\Core\DynamicTags\Tag {

    public function get_name() {
        return 'user-data-tag';
    }

    public function get_title() {
        return __('User Data', 'theme-child');
    }

    public function get_group() {
        return 'site';
    }

    public function get_categories() {
        return [\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY];
    }

    protected function register_controls() {
        $this->add_control(
            'field',
            [
                'label' => __('Field', 'theme-child'),
                'type' => \Elementor\Controls_Manager::SELECT,
                'options' => [
                    'display_name' => __('Display Name', 'theme-child'),
                    'user_email' => __('Email', 'theme-child'),
                    'user_login' => __('Username', 'theme-child'),
                ],
            ]
        );
    }

    public function render() {
        if (!is_user_logged_in()) {
            echo __('Guest', 'theme-child');
            return;
        }
        
        $user = wp_get_current_user();
        $field = $this->get_settings('field');
        
        echo esc_html($user->$field);
    }
}
```

## Debugging Dynamic Tags

### Tag Not Showing
1. Check registration hook is `elementor/dynamic_tags/register`
2. Verify categories match field type
3. Check for PHP errors in tag class
4. Clear Elementor cache

### Tag Output Wrong
1. Use `var_dump()` temporarily in `render()`
2. Check `get_settings()` returns expected values
3. Verify escaping is appropriate for content type
