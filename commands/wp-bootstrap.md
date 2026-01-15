# Bootstrap WordPress Project Command

Sets up a local WordPress project structure for Rocket.net deployment.

## Usage
```
/project:wp-bootstrap [project-name]
```

## What It Creates

```
[project-name]/
├── .claude/
│   ├── CLAUDE.md                  # Project context
│   └── settings.json
│
├── theme-child/                   # Child theme
│   ├── style.css                  # Theme header
│   ├── functions.php              # Theme functions
│   ├── screenshot.png             # Theme screenshot (placeholder)
│   ├── assets/
│   │   ├── css/
│   │   │   └── custom.css
│   │   ├── js/
│   │   │   └── custom.js
│   │   └── images/
│   ├── elementor/
│   │   └── widgets/               # Custom Elementor widgets
│   └── template-parts/            # Reusable templates
│
├── plugin-client/                 # Client functionality plugin
│   ├── plugin-client.php          # Plugin header
│   └── includes/
│       └── class-custom-post-types.php
│
├── deployment/
│   ├── deploy.sh                  # Deployment script
│   ├── .env.example               # Environment template
│   └── sync-from-staging.sh       # Pull from Rocket.net
│
├── docs/
│   └── client-guide.md            # Content management guide
│
├── .wp-env.json                   # wp-env configuration
├── .gitignore
├── .env.example
└── README.md
```

## Template Files

### .claude/CLAUDE.md
```markdown
# [Project Name] - WordPress Site

## Project Overview
WordPress website on Rocket.net managed hosting using Elementor Pro.

## Stack
- **Hosting**: Rocket.net
- **Page Builder**: Elementor Pro
- **Theme**: [Parent Theme] with custom child theme
- **Plugins**: Elementor Pro, WooCommerce, RankMath Pro, WP Mail SMTP, Smush, Essential Addons, LeadConnector

## Environments
- **Production**: https://[domain].com
- **Staging**: https://[staging].rocketcdn.me
- **Local**: http://localhost:8888

## Development Workflow
1. Make changes locally or on staging
2. Test thoroughly
3. Push to staging if local
4. Push staging → production

## Conventions
- All custom code in child theme or plugin-client
- Follow WordPress coding standards
- Use Elementor Global Colors/Fonts
- Test responsive on all breakpoints

## Key Files
- `theme-child/functions.php` - Theme customizations
- `theme-child/assets/css/custom.css` - Additional styles
- `plugin-client/plugin-client.php` - Site-specific functionality
```

### theme-child/style.css
```css
/*
 Theme Name: [Parent Theme] Child
 Template: [parent-theme-slug]
 Version: 1.0.0
 Description: Custom child theme for [Project Name]
 Author: [Your Agency]
 Author URI: [Your URL]
*/
```

### theme-child/functions.php
```php
<?php
/**
 * [Project Name] Child Theme Functions
 */

// Prevent direct access
if (!defined('ABSPATH')) exit;

/**
 * Enqueue parent and child theme styles
 */
add_action('wp_enqueue_scripts', function() {
    // Parent theme style
    wp_enqueue_style(
        'parent-style',
        get_template_directory_uri() . '/style.css'
    );
    
    // Child theme style
    wp_enqueue_style(
        'child-style',
        get_stylesheet_uri(),
        ['parent-style']
    );
    
    // Custom CSS
    wp_enqueue_style(
        'child-custom',
        get_stylesheet_directory_uri() . '/assets/css/custom.css',
        ['child-style'],
        '1.0.0'
    );
    
    // Custom JS
    wp_enqueue_script(
        'child-custom',
        get_stylesheet_directory_uri() . '/assets/js/custom.js',
        ['jquery'],
        '1.0.0',
        true
    );
});

/**
 * Performance optimizations
 */
add_action('init', function() {
    // Remove emoji scripts
    remove_action('wp_head', 'print_emoji_detection_script', 7);
    remove_action('wp_print_styles', 'print_emoji_styles');
});

/**
 * Custom functionality
 */
// Add your customizations below
```

### plugin-client/plugin-client.php
```php
<?php
/**
 * Plugin Name: [Project Name] Functionality
 * Description: Site-specific functionality for [Project Name]
 * Version: 1.0.0
 * Author: [Your Agency]
 */

// Prevent direct access
if (!defined('ABSPATH')) exit;

/**
 * Initialize plugin
 */
class Client_Functionality {
    
    private static $instance = null;
    
    public static function instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    private function __construct() {
        $this->includes();
        $this->init_hooks();
    }
    
    private function includes() {
        require_once plugin_dir_path(__FILE__) . 'includes/class-custom-post-types.php';
    }
    
    private function init_hooks() {
        add_action('init', [$this, 'register_post_types']);
    }
    
    public function register_post_types() {
        // Register custom post types here
    }
}

// Initialize
Client_Functionality::instance();
```

### deployment/deploy.sh
```bash
#!/bin/bash
# Deploy to Rocket.net

set -e

# Load environment
if [ -f .env ]; then
    source .env
fi

ENV="${1:-staging}"

echo "🚀 Deploying to $ENV..."

if [ "$ENV" == "production" ]; then
    echo "⚠️  Deploying to PRODUCTION"
    read -p "Continue? (y/N) " confirm
    if [ "$confirm" != "y" ]; then
        echo "Aborted"
        exit 0
    fi
    HOST=$ROCKETNET_PROD_HOST
    USER=$ROCKETNET_PROD_USER
else
    HOST=$ROCKETNET_STAGING_HOST
    USER=$ROCKETNET_STAGING_USER
fi

# Deploy theme
echo "📦 Uploading theme..."
rsync -avz --delete \
    --exclude '.git' \
    --exclude 'node_modules' \
    --exclude '.DS_Store' \
    -e ssh \
    ./theme-child/ \
    "${USER}@${HOST}:/www/wp-content/themes/theme-child/"

# Deploy plugin
echo "📦 Uploading plugin..."
rsync -avz --delete \
    --exclude '.git' \
    -e ssh \
    ./plugin-client/ \
    "${USER}@${HOST}:/www/wp-content/plugins/plugin-client/"

echo "✅ Deployment complete!"
echo ""
echo "Next steps:"
echo "  1. Clear Rocket.net cache"
echo "  2. Regenerate Elementor CSS"
echo "  3. Test on $ENV"
```

### .env.example
```bash
# Rocket.net Staging
ROCKETNET_STAGING_HOST=sftp.rocketcdn.me
ROCKETNET_STAGING_USER=your-staging-user

# Rocket.net Production
ROCKETNET_PROD_HOST=sftp.rocketcdn.me
ROCKETNET_PROD_USER=your-prod-user

# Site URLs
STAGING_URL=https://staging.example.rocketcdn.me
PRODUCTION_URL=https://example.com
```

### .wp-env.json
```json
{
  "core": "WordPress/WordPress#6.4",
  "phpVersion": "8.2",
  "plugins": [
    "./plugin-client"
  ],
  "themes": [
    "./theme-child"
  ],
  "mappings": {
    "wp-content/themes/theme-child": "./theme-child",
    "wp-content/plugins/plugin-client": "./plugin-client"
  },
  "config": {
    "WP_DEBUG": true,
    "WP_DEBUG_LOG": true,
    "SCRIPT_DEBUG": true
  }
}
```

### .gitignore
```gitignore
# Environment
.env
.env.local
*.log

# WordPress
/wordpress/
/wp-content/uploads/
/wp-content/cache/

# Dependencies
node_modules/
vendor/

# Build
dist/

# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.sublime-*

# Backups
*.sql
*.sql.gz
```

### README.md
```markdown
# [Project Name]

WordPress website on Rocket.net.

## Quick Start

### Local Development
\`\`\`bash
# Install wp-env globally
npm install -g @wordpress/env

# Start local environment
wp-env start

# Access site at http://localhost:8888
\`\`\`

### Deployment
\`\`\`bash
# Copy and configure environment
cp .env.example .env
# Edit .env with your Rocket.net credentials

# Deploy to staging
./deployment/deploy.sh staging

# Deploy to production
./deployment/deploy.sh production
\`\`\`

## Project Structure
- \`theme-child/\` - Custom child theme
- \`plugin-client/\` - Site-specific functionality
- \`deployment/\` - Deployment scripts
- \`docs/\` - Documentation

## Environments
- Production: [URL]
- Staging: [URL]
- Local: http://localhost:8888
```

## Usage

After running `/project:wp-bootstrap my-client-site`:

1. Navigate to project directory
2. Copy `.env.example` to `.env` and fill in credentials
3. Start local development with `wp-env start`
4. Make changes
5. Deploy with `./deployment/deploy.sh staging`
