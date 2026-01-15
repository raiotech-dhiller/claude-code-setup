---
name: wordpress-rocketnet
description: |
  Rocket.net managed WordPress hosting workflows, deployments, and configurations.
  Use when deploying to Rocket.net, setting up staging, managing caches,
  or configuring Rocket.net-specific features.
---

# Rocket.net WordPress Hosting

## Reference Loading
| Topic | File | Load When |
|-------|------|-----------|
| Deployment | `references/rocketnet-deployment.md` | Pushing code to Rocket.net |
| Local Dev | `references/local-development.md` | Setting up local environment |
| Performance | `references/rocketnet-performance.md` | Optimizing for Rocket.net |

## Rocket.net Architecture

### Hosting Features
- Managed WordPress hosting
- Built-in Cloudflare CDN
- Enterprise-level caching
- Automatic backups
- Staging environments
- SSH/SFTP access
- Git deployments (via SSH)

### File Access
```
# SFTP/SSH
Host: [site].rocketcdn.me or custom
User: [provided in dashboard]
Port: 22
Root: /www/wp-content/
```

### Important Paths
```
/www/                          # WordPress root
/www/wp-content/themes/        # Themes
/www/wp-content/plugins/       # Plugins
/www/wp-content/uploads/       # Media
```

## Workflow Patterns

### Direct Staging Work (Current Workflow)
1. Create/access staging in Rocket.net dashboard
2. Make changes directly in WordPress admin
3. Test on staging URL
4. Push staging to production

### Local Development Workflow
1. Set up local environment
2. Develop theme/plugin changes
3. Push to Rocket.net staging via SFTP/Git
4. Test on staging
5. Push to production

## Cache Management

### Cache Layers
1. **Rocket.net Edge Cache** (Cloudflare)
2. **Server-level cache**
3. **WordPress object cache**

### Clearing Cache
```
# Via Dashboard
Rocket.net Dashboard > [Site] > Cache > Purge All

# Via WordPress Admin
Rocket.net plugin > Purge Cache

# Via SSH (if available)
wp cache flush
```

### When to Clear Cache
- After plugin updates
- After theme changes
- After Elementor CSS regeneration
- After content changes not appearing
- After WooCommerce product updates

## Staging Environments

### Creating Staging
1. Rocket.net Dashboard > [Site] > Staging
2. Click "Create Staging"
3. Wait for copy to complete

### Staging URL
```
https://[staging-subdomain].rocketcdn.me
OR
https://staging.[yourdomain].com (if configured)
```

### Push Staging to Production
1. Test all changes on staging
2. Dashboard > Staging > Push to Live
3. Select what to push (Files, Database, or Both)
4. Confirm and wait for completion

### Best Practices
- Always test on staging first
- Push files only if database changes not needed
- Backup production before major pushes
- Clear cache after push

## SFTP/SSH Access

### Connection Details
Found in: Dashboard > [Site] > SFTP/SSH

```
Host: sftp.rocketcdn.me (or custom)
Username: [site-specific]
Password: [set in dashboard]
Port: 22
```

### SSH Commands
```bash
# Connect
ssh username@sftp.rocketcdn.me

# Navigate to wp-content
cd /www/wp-content

# WP-CLI (if available)
cd /www && wp plugin list
```

### SFTP Upload
```bash
# Using sftp command
sftp username@sftp.rocketcdn.me
cd /www/wp-content/themes
put -r theme-child

# Using rsync (faster for large transfers)
rsync -avz -e ssh ./theme-child/ username@sftp.rocketcdn.me:/www/wp-content/themes/theme-child/
```

## Git Deployment

### Setup (if using Git)
```bash
# In local project
git init
git remote add rocket ssh://username@sftp.rocketcdn.me/www/wp-content/themes/theme-child

# Deploy
git push rocket main
```

### Recommended .gitignore
```
# WordPress
wp-config.php
wp-content/uploads/
wp-content/upgrade/
wp-content/cache/

# Elementor generated
wp-content/uploads/elementor/

# Environment
.env
*.log

# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
```

## Domain & SSL

### DNS Configuration
Point to Rocket.net nameservers or use CNAME provided.

### SSL
- Automatic via Cloudflare
- Always-on HTTPS
- No manual certificate management

## Backups

### Automatic Backups
- Daily automatic backups
- Retained for 14 days (plan dependent)

### Manual Backup
Dashboard > [Site] > Backups > Create Backup

### Restore
Dashboard > [Site] > Backups > [Select] > Restore

## Rocket.net Limitations

### Cannot Modify
- Core WordPress files
- Server configuration
- PHP version (managed)
- Some wp-config.php settings

### Plugin Restrictions
Some security/performance plugins conflict:
- Don't need: Caching plugins (W3TC, WP Super Cache)
- Don't need: CDN plugins (built-in)
- May conflict: Some security plugins

### Recommended Plugin Stack
```
# DO USE
- Elementor/Elementor Pro (page building)
- WooCommerce (e-commerce)
- RankMath/Yoast (SEO)
- WP Mail SMTP (email)
- Form plugins (Gravity, WPForms)
- CRM connectors (LeadConnector, WP Fusion)

# DON'T NEED (Rocket.net provides)
- Caching plugins
- CDN plugins
- Image optimization (use Smush, ImageOptim before upload)
- Backup plugins (unless offsite wanted)
```

## Troubleshooting

### Site Not Loading
1. Check Rocket.net status page
2. Purge cache
3. Check DNS propagation
4. Contact Rocket.net support

### Changes Not Appearing
1. Purge all caches (Rocket.net + browser)
2. Check staging vs production
3. Verify file was uploaded
4. Check Elementor CSS regenerated

### SFTP Connection Failed
1. Verify credentials in dashboard
2. Check IP whitelist (if enabled)
3. Reset SFTP password
4. Check port 22 not blocked

### Staging Push Failed
1. Check for database conflicts
2. Try files-only push first
3. Verify staging is current
4. Contact support if persistent
