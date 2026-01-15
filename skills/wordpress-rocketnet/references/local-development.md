# Local WordPress Development

## Environment Options

### Option 1: Local by Flywheel (Recommended)
**Pros:** Easy setup, good GUI, built-in SSL, Live Links for sharing
**Cons:** Resource heavy, Mac/Windows only

### Option 2: Docker (wp-env or custom)
**Pros:** Consistent environments, lightweight, scriptable
**Cons:** More setup, command-line based

### Option 3: DDEV
**Pros:** Good middle ground, WordPress-optimized
**Cons:** Requires Docker, learning curve

### Option 4: Laravel Valet + WordPress (Mac only)
**Pros:** Very fast, minimal resources
**Cons:** Mac only, manual database setup

## Local by Flywheel Setup

### Create New Site
1. Open Local
2. Click "+" to create new site
3. Choose "Create a new site"
4. Name: `project-name`
5. Environment: Preferred (or Custom for specific PHP/MySQL)
6. WordPress credentials: Set admin user
7. Click "Add Site"

### Connect to Rocket.net Site
1. Create site in Local
2. Use plugin like "WP Migrate DB Pro" or manual export
3. Export database from Rocket.net staging
4. Import to Local
5. Search/replace URLs
6. Pull wp-content files via SFTP

### Development Workflow
```
1. Make changes in Local
2. Test locally
3. Push theme/plugin files to Rocket.net staging
4. Test on staging
5. Push staging → production
```

## Docker Setup (wp-env)

### Prerequisites
```bash
# Node.js and npm
node --version  # v16+

# Docker
docker --version
docker-compose --version
```

### Install wp-env
```bash
npm install -g @wordpress/env
```

### Basic .wp-env.json
```json
{
  "core": "WordPress/WordPress#6.4",
  "phpVersion": "8.2",
  "plugins": [
    "https://downloads.wordpress.org/plugin/elementor.latest-stable.zip",
    "https://downloads.wordpress.org/plugin/woocommerce.latest-stable.zip"
  ],
  "themes": [
    "./theme-child"
  ],
  "mappings": {
    "wp-content/themes/theme-child": "./theme-child"
  },
  "config": {
    "WP_DEBUG": true,
    "WP_DEBUG_LOG": true,
    "SCRIPT_DEBUG": true
  }
}
```

### Commands
```bash
# Start environment
wp-env start

# Stop environment
wp-env stop

# Destroy environment
wp-env destroy

# Run WP-CLI commands
wp-env run cli wp plugin list

# Access MySQL
wp-env run cli mysql
```

### Access
- Site: http://localhost:8888
- Admin: http://localhost:8888/wp-admin
- Username: admin
- Password: password

## Docker Compose Setup (Custom)

### docker-compose.yml
```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:6.4-php8.2-apache
    ports:
      - "8000:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DEBUG: 1
    volumes:
      - ./wp-content:/var/www/html/wp-content
      - wordpress_data:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - db_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
    depends_on:
      - db

volumes:
  wordpress_data:
  db_data:
```

### Commands
```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f wordpress

# Access WordPress container
docker-compose exec wordpress bash

# Run WP-CLI (if installed in container)
docker-compose exec wordpress wp plugin list --allow-root
```

## Project Structure

### Recommended Local Structure
```
project-name/
├── .wp-env.json              # wp-env configuration
├── docker-compose.yml        # OR Docker Compose config
├── .env                      # Environment variables
├── .gitignore
├── README.md
│
├── theme-child/              # Child theme
│   ├── style.css
│   ├── functions.php
│   ├── screenshot.png
│   ├── assets/
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   ├── elementor/
│   │   └── widgets/
│   └── template-parts/
│
├── plugin-client/            # Client-specific plugin
│   ├── plugin-client.php
│   └── includes/
│
├── deployment/               # Deployment scripts
│   ├── deploy.sh
│   └── .env.example
│
└── docs/                     # Project documentation
    └── README.md
```

### .gitignore
```gitignore
# WordPress
/wp-content/uploads/
/wp-content/upgrade/
/wp-content/cache/
/wp-content/plugins/*
!/wp-content/plugins/plugin-client/
/wp-content/themes/*
!/wp-content/themes/theme-child/

# Environment
.env
.env.local
*.log

# Docker
docker-compose.override.yml

# wp-env
.wp-env.override.json

# Node
node_modules/

# Build
dist/

# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.sublime-*
```

## Database Sync

### Export from Rocket.net
```bash
# Via WP-CLI (if available on Rocket.net)
ssh user@rocketnet.site
cd /www
wp db export backup.sql

# Download
scp user@rocketnet.site:/www/backup.sql ./
```

### Import to Local
```bash
# wp-env
wp-env run cli wp db import /var/www/html/backup.sql

# Docker Compose
docker-compose exec -T db mysql -u wordpress -pwordpress wordpress < backup.sql

# Local by Flywheel
# Use Database tab > Import
```

### Search/Replace URLs
```bash
# Using WP-CLI
wp search-replace 'https://production-site.com' 'http://localhost:8000' --all-tables

# Common patterns to replace:
# - https://site.com → http://localhost:8000
# - https://staging.site.com → http://localhost:8000
```

## Asset Building (Optional)

### If Using Build Process
```json
// package.json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "watch": "vite build --watch"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
```

### vite.config.js
```javascript
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    outDir: 'theme-child/assets/dist',
    rollupOptions: {
      input: {
        main: 'src/js/main.js',
        styles: 'src/css/main.css',
      },
      output: {
        entryFileNames: '[name].js',
        assetFileNames: '[name].[ext]',
      },
    },
  },
});
```

## Syncing with Rocket.net

### Pull Changes from Staging
```bash
# Pull wp-content files
rsync -avz -e ssh \
    user@rocketnet:/www/wp-content/themes/theme-child/ \
    ./theme-child/ \
    --exclude 'node_modules'

# Pull database
ssh user@rocketnet "cd /www && wp db export - | gzip" > db-backup.sql.gz
```

### Push Changes to Staging
```bash
# Push theme
rsync -avz --delete \
    --exclude '.git' \
    --exclude 'node_modules' \
    -e ssh \
    ./theme-child/ \
    user@rocketnet:/www/wp-content/themes/theme-child/
```

## Debugging

### Enable Debug Mode
```php
// wp-config.php (or .wp-env.json for wp-env)
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
define('SCRIPT_DEBUG', true);
```

### View Debug Log
```bash
# wp-env
wp-env run cli tail -f /var/www/html/wp-content/debug.log

# Docker
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug.log

# Local by Flywheel
# Site folder > logs > php > error.log
```

### Elementor Debug
```php
// In theme functions.php
add_action('init', function() {
    if (defined('ELEMENTOR_VERSION')) {
        error_log('Elementor version: ' . ELEMENTOR_VERSION);
    }
});
```
