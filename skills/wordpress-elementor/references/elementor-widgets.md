# Custom Elementor Widgets

## When to Create Custom Widgets

### Use Built-in First
1. Check Elementor core widgets
2. Check Elementor Pro widgets
3. Check Essential Addons for Elementor
4. Only then consider custom

### Custom Widget Use Cases
- Unique interactive functionality
- Complex API integrations
- Client-specific repeating components
- Integration with custom plugins

## Widget File Structure

```
wp-content/themes/theme-child/elementor/
└── widgets/
    ├── class-custom-widget.php
    └── class-another-widget.php

OR (recommended for complex widgets)

wp-content/plugins/client-functionality/
├── client-functionality.php
├── includes/
│   └── elementor/
│       ├── class-elementor-extension.php
│       └── widgets/
│           └── class-custom-widget.php
└── assets/
    ├── css/
    │   └── widget-styles.css
    └── js/
        └── widget-scripts.js
```

## Basic Widget Template

```php
<?php
/**
 * Custom Elementor Widget
 */

if (!defined('ABSPATH')) exit;

class Custom_Widget extends \Elementor\Widget_Base {

    /**
     * Widget name (slug)
     */
    public function get_name() {
        return 'custom_widget';
    }

    /**
     * Widget title (display name)
     */
    public function get_title() {
        return __('Custom Widget', 'theme-child');
    }

    /**
     * Widget icon
     */
    public function get_icon() {
        return 'eicon-code';
    }

    /**
     * Widget categories
     */
    public function get_categories() {
        return ['general'];
    }

    /**
     * Widget keywords for search
     */
    public function get_keywords() {
        return ['custom', 'widget', 'example'];
    }

    /**
     * Widget dependencies (scripts/styles)
     */
    public function get_script_depends() {
        return ['custom-widget-script'];
    }

    public function get_style_depends() {
        return ['custom-widget-style'];
    }

    /**
     * Register controls
     */
    protected function register_controls() {
        
        // Content Section
        $this->start_controls_section(
            'content_section',
            [
                'label' => __('Content', 'theme-child'),
                'tab' => \Elementor\Controls_Manager::TAB_CONTENT,
            ]
        );

        $this->add_control(
            'title',
            [
                'label' => __('Title', 'theme-child'),
                'type' => \Elementor\Controls_Manager::TEXT,
                'default' => __('Default Title', 'theme-child'),
                'placeholder' => __('Enter title', 'theme-child'),
            ]
        );

        $this->add_control(
            'description',
            [
                'label' => __('Description', 'theme-child'),
                'type' => \Elementor\Controls_Manager::TEXTAREA,
                'default' => '',
                'placeholder' => __('Enter description', 'theme-child'),
            ]
        );

        $this->end_controls_section();

        // Style Section
        $this->start_controls_section(
            'style_section',
            [
                'label' => __('Style', 'theme-child'),
                'tab' => \Elementor\Controls_Manager::TAB_STYLE,
            ]
        );

        $this->add_control(
            'title_color',
            [
                'label' => __('Title Color', 'theme-child'),
                'type' => \Elementor\Controls_Manager::COLOR,
                'global' => [
                    'default' => \Elementor\Core\Kits\Documents\Tabs\Global_Colors::COLOR_PRIMARY,
                ],
                'selectors' => [
                    '{{WRAPPER}} .widget-title' => 'color: {{VALUE}};',
                ],
            ]
        );

        $this->add_group_control(
            \Elementor\Group_Control_Typography::get_type(),
            [
                'name' => 'title_typography',
                'selector' => '{{WRAPPER}} .widget-title',
            ]
        );

        $this->end_controls_section();
    }

    /**
     * Render widget output
     */
    protected function render() {
        $settings = $this->get_settings_for_display();
        ?>
        <div class="custom-widget-wrapper">
            <?php if (!empty($settings['title'])) : ?>
                <h3 class="widget-title">
                    <?php echo esc_html($settings['title']); ?>
                </h3>
            <?php endif; ?>
            
            <?php if (!empty($settings['description'])) : ?>
                <div class="widget-description">
                    <?php echo wp_kses_post($settings['description']); ?>
                </div>
            <?php endif; ?>
        </div>
        <?php
    }

    /**
     * Render in editor (optional - for JavaScript templates)
     */
    protected function content_template() {
        ?>
        <#
        var title = settings.title;
        var description = settings.description;
        #>
        <div class="custom-widget-wrapper">
            <# if (title) { #>
                <h3 class="widget-title">{{{ title }}}</h3>
            <# } #>
            <# if (description) { #>
                <div class="widget-description">{{{ description }}}</div>
            <# } #>
        </div>
        <?php
    }
}
```

## Registration

### In Child Theme functions.php
```php
<?php
/**
 * Register custom Elementor widgets
 */
add_action('elementor/widgets/register', function($widgets_manager) {
    // Require widget file
    require_once get_stylesheet_directory() . '/elementor/widgets/class-custom-widget.php';
    
    // Register widget
    $widgets_manager->register(new \Custom_Widget());
});

/**
 * Register widget scripts and styles
 */
add_action('elementor/frontend/after_register_scripts', function() {
    wp_register_script(
        'custom-widget-script',
        get_stylesheet_directory_uri() . '/assets/js/custom-widget.js',
        ['jquery'],
        '1.0.0',
        true
    );
});

add_action('elementor/frontend/after_register_styles', function() {
    wp_register_style(
        'custom-widget-style',
        get_stylesheet_directory_uri() . '/assets/css/custom-widget.css',
        [],
        '1.0.0'
    );
});
```

### In Plugin
```php
<?php
/**
 * Plugin Name: Client Functionality
 */

// Initialize Elementor extension
add_action('elementor/init', function() {
    require_once plugin_dir_path(__FILE__) . 'includes/elementor/class-elementor-extension.php';
    new Client_Elementor_Extension();
});
```

## Common Control Types

### Text & Content
```php
// Text input
$this->add_control('text', [
    'type' => \Elementor\Controls_Manager::TEXT,
]);

// Textarea
$this->add_control('textarea', [
    'type' => \Elementor\Controls_Manager::TEXTAREA,
]);

// WYSIWYG editor
$this->add_control('wysiwyg', [
    'type' => \Elementor\Controls_Manager::WYSIWYG,
]);

// Code editor
$this->add_control('code', [
    'type' => \Elementor\Controls_Manager::CODE,
    'language' => 'html',
]);
```

### Selection
```php
// Select dropdown
$this->add_control('select', [
    'type' => \Elementor\Controls_Manager::SELECT,
    'options' => [
        'option1' => __('Option 1', 'theme-child'),
        'option2' => __('Option 2', 'theme-child'),
    ],
    'default' => 'option1',
]);

// Select2 (multiple)
$this->add_control('select2', [
    'type' => \Elementor\Controls_Manager::SELECT2,
    'multiple' => true,
    'options' => [...],
]);

// Switcher (toggle)
$this->add_control('switcher', [
    'type' => \Elementor\Controls_Manager::SWITCHER,
    'label_on' => __('Yes', 'theme-child'),
    'label_off' => __('No', 'theme-child'),
    'return_value' => 'yes',
    'default' => 'no',
]);
```

### Media
```php
// Image/media selector
$this->add_control('image', [
    'type' => \Elementor\Controls_Manager::MEDIA,
    'default' => [
        'url' => \Elementor\Utils::get_placeholder_image_src(),
    ],
]);

// Gallery
$this->add_control('gallery', [
    'type' => \Elementor\Controls_Manager::GALLERY,
]);

// Icon
$this->add_control('icon', [
    'type' => \Elementor\Controls_Manager::ICONS,
    'default' => [
        'value' => 'fas fa-star',
        'library' => 'solid',
    ],
]);
```

### Style Controls
```php
// Color with global colors support
$this->add_control('color', [
    'type' => \Elementor\Controls_Manager::COLOR,
    'global' => [
        'default' => \Elementor\Core\Kits\Documents\Tabs\Global_Colors::COLOR_PRIMARY,
    ],
    'selectors' => [
        '{{WRAPPER}} .element' => 'color: {{VALUE}};',
    ],
]);

// Typography group
$this->add_group_control(
    \Elementor\Group_Control_Typography::get_type(),
    [
        'name' => 'typography',
        'selector' => '{{WRAPPER}} .element',
    ]
);

// Box shadow group
$this->add_group_control(
    \Elementor\Group_Control_Box_Shadow::get_type(),
    [
        'name' => 'box_shadow',
        'selector' => '{{WRAPPER}} .element',
    ]
);

// Border group
$this->add_group_control(
    \Elementor\Group_Control_Border::get_type(),
    [
        'name' => 'border',
        'selector' => '{{WRAPPER}} .element',
    ]
);
```

### Responsive Controls
```php
// Slider with responsive
$this->add_responsive_control(
    'width',
    [
        'label' => __('Width', 'theme-child'),
        'type' => \Elementor\Controls_Manager::SLIDER,
        'size_units' => ['px', '%', 'vw'],
        'range' => [
            'px' => ['min' => 0, 'max' => 1000],
            '%' => ['min' => 0, 'max' => 100],
        ],
        'selectors' => [
            '{{WRAPPER}} .element' => 'width: {{SIZE}}{{UNIT}};',
        ],
    ]
);
```

## Creating Custom Widget Category

```php
add_action('elementor/elements/categories_registered', function($elements_manager) {
    $elements_manager->add_category(
        'client-widgets',
        [
            'title' => __('Client Widgets', 'theme-child'),
            'icon' => 'fa fa-plug',
        ]
    );
});
```

Then in widget:
```php
public function get_categories() {
    return ['client-widgets'];
}
```
