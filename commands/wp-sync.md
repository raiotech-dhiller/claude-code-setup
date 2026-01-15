# WordPress Sync Command

Sync files and/or database from Rocket.net to local environment.

## Usage
```
/project:wp-sync [source] [scope]
```

**Source:**
- `staging` (default) - Pull from staging
- `production` - Pull from production

**Scope:**
- `files` - Theme and plugin files only
- `db` - Database only
- `all` - Both files and database

## Workflow

### File Sync
1. Connect to Rocket.net via SSH/SFTP
2. Download theme files to local
3. Download plugin files to local
4. Report sync status

### Database Sync
1. Export database from Rocket.net (via WP-CLI or phpMyAdmin export)
2. Download SQL file
3. Import to local database
4. Search/replace URLs

### Full Sync
1. Perform file sync
2. Perform database sync
3. Search/replace URLs

## Integration with wordpress-website-specialist

```markdown
**Task**: Sync WordPress from Rocket.net to local
**Source**: [staging/production]
**Scope**: [files/db/all]
**Local Path**: [project directory]
**Output**: Sync status and any URL replacements needed
```

## Example Sessions

### Sync Files Only
```
> /project:wp-sync staging files

[wordpress-website-specialist executes]

Connecting to staging.example.rocketcdn.me...
✓ Connected

Downloading files:
✓ theme-child/ synced
✓ plugin-client/ synced

📁 Local files updated from staging
```

### Sync Database
```
> /project:wp-sync staging db

[wordpress-website-specialist executes]

Connecting to staging.example.rocketcdn.me...
✓ Connected

Exporting database...
✓ Database exported (2.3MB)

Downloading...
✓ Downloaded to ./db-staging-2025-01-15.sql

Importing to local...
✓ Database imported

Replacing URLs...
✓ https://staging.example.rocketcdn.me → http://localhost:8888
   (342 replacements)

🗄️ Local database updated from staging
```

### Full Sync
```
> /project:wp-sync production all

⚠️ Syncing from PRODUCTION
This will overwrite local files and database.

Proceed? (yes/no)
> yes

[Full sync process...]
```

## Script Reference

### sync-from-staging.sh
```bash
#!/bin/bash
# Sync from Rocket.net to local

set -e

source .env

SOURCE="${1:-staging}"
SCOPE="${2:-all}"

if [ "$SOURCE" == "production" ]; then
    HOST=$ROCKETNET_PROD_HOST
    USER=$ROCKETNET_PROD_USER
    URL=$PRODUCTION_URL
else
    HOST=$ROCKETNET_STAGING_HOST
    USER=$ROCKETNET_STAGING_USER
    URL=$STAGING_URL
fi

LOCAL_URL="http://localhost:8888"

# Sync files
if [ "$SCOPE" == "files" ] || [ "$SCOPE" == "all" ]; then
    echo "📥 Syncing files from $SOURCE..."
    
    rsync -avz -e ssh \
        "${USER}@${HOST}:/www/wp-content/themes/theme-child/" \
        ./theme-child/ \
        --exclude 'node_modules'
    
    rsync -avz -e ssh \
        "${USER}@${HOST}:/www/wp-content/plugins/plugin-client/" \
        ./plugin-client/
    
    echo "✓ Files synced"
fi

# Sync database
if [ "$SCOPE" == "db" ] || [ "$SCOPE" == "all" ]; then
    echo "📥 Syncing database from $SOURCE..."
    
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    DB_FILE="db-${SOURCE}-${TIMESTAMP}.sql"
    
    # Export from remote
    ssh "${USER}@${HOST}" "cd /www && wp db export -" > "$DB_FILE"
    
    echo "✓ Database exported"
    
    # Import locally (wp-env)
    wp-env run cli wp db import "/var/www/html/${DB_FILE}"
    
    # Search replace
    wp-env run cli wp search-replace "$URL" "$LOCAL_URL" --all-tables
    
    echo "✓ Database imported and URLs replaced"
    
    # Cleanup
    rm "$DB_FILE"
fi

echo ""
echo "✅ Sync from $SOURCE complete!"
```

## URL Replacement

### Common Replacements
| From | To |
|------|-----|
| `https://site.com` | `http://localhost:8888` |
| `https://staging.site.rocketcdn.me` | `http://localhost:8888` |

### Elementor Data
Elementor stores URLs in serialized data. Use WP-CLI search-replace which handles serialized data correctly.

```bash
# Correct (handles serialized)
wp search-replace 'https://old.com' 'http://localhost:8888' --all-tables

# Also check for escaped URLs
wp search-replace 'https:\/\/old.com' 'http:\/\/localhost:8888' --all-tables
```

## Troubleshooting

### Database Import Fails
- Check local MySQL is running
- Verify database exists
- Check import file is valid SQL

### Elementor Styles Missing After Sync
1. Regenerate Elementor CSS
2. Clear all caches
3. Check URL replacement completed

### Media Files Missing
Media files (uploads/) are not synced by default. Options:
1. Sync manually if needed: `rsync -avz user@host:/www/wp-content/uploads/ ./uploads/`
2. Use staging URL for images during development
3. Set up reverse proxy for uploads
