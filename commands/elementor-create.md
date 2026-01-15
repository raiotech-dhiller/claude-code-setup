# Elementor Customization Command

Scaffold custom Elementor widgets, dynamic tags, or extensions.

## Usage
```
/project:elementor-create [type] [name]
```

**Types:**
- `widget` - Custom Elementor widget
- `dynamic-tag` - Custom dynamic tag
- `extension` - Elementor extension/module

## Workflow

### Widget Creation
1. Generate widget class file
2. Add to child theme or plugin
3. Register with Elementor
4. Create associated CSS/JS if needed

### Dynamic Tag Creation
1. Generate tag class file
2. Register tag group (if new)
3. Register tag with Elementor

## Integration with wordpress-website-specialist

```markdown
**Task**: Create custom Elementor [type]
**Name**: [widget/tag name]
**Location**: theme-child/elementor/ or plugin-client/includes/elementor/
**Output**: 
- Class file(s)
- Registration code
- Usage instructions
```

## Example Sessions

### Create Widget
```
> /project:elementor-create widget testimonial-card

[wordpress-website-specialist executes]

Creating testimonial-card widget...

Created files:
✓ theme-child/elementor/widgets/class-testimonial-card-widget.php
✓ theme-child/assets/css/widgets/testimonial-card.css

Registration added to functions.php

📦 Widget ready!

Usage:
1. Reload WordPress admin
2. Find "Testimonial Card" in Elementor widgets
3. Customize controls as needed in the class file
```

### Create Dynamic Tag
```
> /project:elementor-create dynamic-tag business-hours

[wordpress-website-specialist executes]

Creating business-hours dynamic tag...

Created files:
✓ theme-child/elementor/dynamic-tags/class-business-hours-tag.php

Registration added to functions.php

🏷️ Dynamic tag ready!

Usage:
1. Reload WordPress admin
2. In Elementor, click dynamic tag icon
3. Find "Business Hours" under Site group
```

## Templates Used

### Widget Template
```php
<?php
class [Name]_Widget extends \Elementor\Widget_Base {
    
    public function get_name() {
        return '[name-slug]';
    }
    
    public function get_title() {
        return __('[Display Name]', 'theme-child');
    }
    
    public function get_icon() {
        return 'eicon-[icon]';
    }
    
    public function get_categories() {
        return ['general'];
    }
    
    protected function register_controls() {
        // Content controls
        $this->start_controls_section('content_section', [
            'label' => __('Content', 'theme-child'),
            'tab' => \Elementor\Controls_Manager::TAB_CONTENT,
        ]);
        
        // Add controls here
        
        $this->end_controls_section();
        
        // Style controls
        $this->start_controls_section('style_section', [
            'label' => __('Style', 'theme-child'),
            'tab' => \Elementor\Controls_Manager::TAB_STYLE,
        ]);
        
        // Add style controls here
        
        $this->end_controls_section();
    }
    
    protected function render() {
        $settings = $this->get_settings_for_display();
        ?>
        <div class="[name-slug]-widget">
            <!-- Widget output -->
        </div>
        <?php
    }
}
```

### Dynamic Tag Template
```php
<?php
class [Name]_Tag extends \Elementor\Core\DynamicTags\Tag {
    
    public function get_name() {
        return '[name-slug]-tag';
    }
    
    public function get_title() {
        return __('[Display Name]', 'theme-child');
    }
    
    public function get_group() {
        return 'site';
    }
    
    public function get_categories() {
        return [\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY];
    }
    
    protected function register_controls() {
        // Add controls if needed
    }
    
    public function render() {
        // Output dynamic content
        echo esc_html('Dynamic content');
    }
}
```

### Registration Code
```php
// For widgets
add_action('elementor/widgets/register', function($widgets_manager) {
    require_once get_stylesheet_directory() . '/elementor/widgets/class-[name]-widget.php';
    $widgets_manager->register(new \[Name]_Widget());
});

// For dynamic tags
add_action('elementor/dynamic_tags/register', function($dynamic_tags) {
    require_once get_stylesheet_directory() . '/elementor/dynamic-tags/class-[name]-tag.php';
    $dynamic_tags->register(new \[Name]_Tag());
});
```

## Common Widget Types

### Content Widgets
- Testimonial cards
- Team member cards
- Pricing tables
- Feature boxes
- CTA sections

### Interactive Widgets
- Accordion/tabs (enhanced)
- Carousels/sliders
- Modal triggers
- Form integrations

### Data Display Widgets
- Post grids (custom)
- Statistics counters
- Timeline displays
- Comparison tables

## Checklist

### After Creating Widget
- [ ] Test in Elementor editor
- [ ] Verify all controls work
- [ ] Check frontend rendering
- [ ] Test responsive behavior
- [ ] Add any required CSS
- [ ] Document usage

### After Creating Dynamic Tag
- [ ] Test in supported widgets
- [ ] Verify output is correct
- [ ] Check escaping/sanitization
- [ ] Test with empty/null values
