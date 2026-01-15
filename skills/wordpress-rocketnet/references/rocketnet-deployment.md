# Rocket.net Deployment Workflows

## Deployment Options

### Option 1: Direct Staging (Simplest)
Work directly on Rocket.net staging environment.

```
Workflow:
1. Access staging site WordPress admin
2. Make changes via Elementor/Gutenberg
3. Test on staging URL
4. Push staging → production
```

**Best for:** Content changes, Elementor design work, plugin configuration

### Option 2: SFTP Upload
Push files from local to Rocket.net.

```
Workflow:
1. Develop locally
2. Upload changed files via SFTP
3. Test on staging
4. Push staging → production
```

**Best for:** Theme/plugin code changes, child theme development

### Option 3: Git via SSH
Version-controlled deployments.

```
Workflow:
1. Develop locally with Git
2. Push to Rocket.net via SSH
3. Test on staging
4. Push staging → production
```

**Best for:** Ongoing development, team collaboration, version control

### Option 4: Dashboard Upload
Upload via Rocket.net interface.

```
Workflow:
1. Develop locally
2. Zip theme/plugin
3. Upload via Rocket.net File Manager
4. Extract and test
```

**Best for:** One-off uploads, non-technical handoffs

## SFTP Deployment Script

### deploy-sftp.sh
```bash
#!/bin/bash
# Deploy to Rocket.net via SFTP

# Configuration
ROCKETNET_HOST="${ROCKETNET_HOST:-sftp.rocketcdn.me}"
ROCKETNET_USER="${ROCKETNET_USER:-your-username}"
REMOTE_PATH="/www/wp-content/themes/theme-child"
LOCAL_PATH="./theme-child"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Deploying to Rocket.net...${NC}"

# Check if local path exists
if [ ! -d "$LOCAL_PATH" ]; then
    echo -e "${RED}Error: $LOCAL_PATH not found${NC}"
    exit 1
fi

# Deploy using rsync
rsync -avz --delete \
    --exclude '.git' \
    --exclude '.gitignore' \
    --exclude 'node_modules' \
    --exclude '.DS_Store' \
    --exclude '*.log' \
    -e ssh \
    "$LOCAL_PATH/" \
    "${ROCKETNET_USER}@${ROCKETNET_HOST}:${REMOTE_PATH}/"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment complete${NC}"
    echo -e "${YELLOW}Remember to:${NC}"
    echo "  1. Clear Rocket.net cache"
    echo "  2. Regenerate Elementor CSS if needed"
    echo "  3. Test on staging before pushing to production"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    exit 1
fi
```

### Usage
```bash
# Set credentials (or use .env)
export ROCKETNET_USER="your-username"
export ROCKETNET_HOST="sftp.rocketcdn.me"

# Run deployment
./deploy-sftp.sh
```

## Git Deployment Setup

### Initial Setup
```bash
# 1. Initialize Git in theme/plugin directory
cd wp-content/themes/theme-child
git init

# 2. Create initial commit
git add .
git commit -m "Initial commit"

# 3. Add Rocket.net as remote
git remote add rocketnet ssh://${ROCKETNET_USER}@${ROCKETNET_HOST}/www/wp-content/themes/theme-child

# 4. Set up bare repository on Rocket.net (via SSH)
ssh ${ROCKETNET_USER}@${ROCKETNET_HOST}
cd /www/wp-content/themes
mkdir theme-child.git
cd theme-child.git
git init --bare

# 5. Create post-receive hook for auto-deploy
cat > hooks/post-receive << 'EOF'
#!/bin/bash
GIT_WORK_TREE=/www/wp-content/themes/theme-child git checkout -f
EOF
chmod +x hooks/post-receive
exit
```

### Deploying with Git
```bash
# Deploy to Rocket.net
git push rocketnet main

# Or with specific branch
git push rocketnet feature-branch:main
```

## Database Sync Considerations

### When Database Sync Needed
- New custom post types
- New Elementor templates (stored in DB)
- New navigation menus
- Plugin settings changes
- ACF field configurations

### When Database Sync NOT Needed
- Theme file changes only
- CSS/JS updates
- Static asset changes
- functions.php modifications

### Handling Elementor Templates
Elementor templates are stored in database. Options:

1. **Export/Import** (Recommended for templates)
   ```
   Elementor > Templates > Saved Templates > Export
   Import on target site
   ```

2. **Database Push via Staging**
   ```
   Make changes on staging
   Push Database to production
   ```

3. **WP-CLI Export** (If available)
   ```bash
   wp elementor library export [template-id]
   ```

## Deployment Checklist

### Pre-Deployment
- [ ] All changes tested locally
- [ ] No console errors
- [ ] Responsive design checked
- [ ] Forms working
- [ ] Images optimized

### Deployment
- [ ] Files uploaded successfully
- [ ] No upload errors
- [ ] File permissions correct

### Post-Deployment
- [ ] Clear Rocket.net cache
- [ ] Regenerate Elementor CSS
- [ ] Test on staging
- [ ] Verify all pages load
- [ ] Test forms again
- [ ] Check mobile view
- [ ] Push staging → production
- [ ] Clear production cache
- [ ] Final production test

## Environment-Specific Configuration

### .env.example
```bash
# Rocket.net Staging
ROCKETNET_STAGING_HOST=sftp.rocketcdn.me
ROCKETNET_STAGING_USER=staging-user
ROCKETNET_STAGING_PATH=/www/wp-content/themes/theme-child

# Rocket.net Production
ROCKETNET_PROD_HOST=sftp.rocketcdn.me
ROCKETNET_PROD_USER=prod-user
ROCKETNET_PROD_PATH=/www/wp-content/themes/theme-child

# Local
WP_HOME=http://localhost:8000
WP_SITEURL=http://localhost:8000
```

### deploy.sh with Environment Support
```bash
#!/bin/bash

ENV="${1:-staging}"

if [ "$ENV" == "staging" ]; then
    source .env.staging
    HOST=$ROCKETNET_STAGING_HOST
    USER=$ROCKETNET_STAGING_USER
    PATH=$ROCKETNET_STAGING_PATH
elif [ "$ENV" == "production" ]; then
    echo "Warning: Deploying to PRODUCTION"
    read -p "Continue? (y/N) " confirm
    if [ "$confirm" != "y" ]; then
        echo "Aborted"
        exit 0
    fi
    source .env.production
    HOST=$ROCKETNET_PROD_HOST
    USER=$ROCKETNET_PROD_USER
    PATH=$ROCKETNET_PROD_PATH
else
    echo "Unknown environment: $ENV"
    exit 1
fi

# Deploy
rsync -avz --delete \
    --exclude '.git' \
    --exclude 'node_modules' \
    -e ssh \
    ./theme-child/ \
    "${USER}@${HOST}:${PATH}/"
```

### Usage
```bash
./deploy.sh staging    # Deploy to staging
./deploy.sh production # Deploy to production (with confirmation)
```

## Rollback Procedure

### Using Rocket.net Backups
1. Dashboard > [Site] > Backups
2. Select backup from before issue
3. Restore (Files, Database, or Both)
4. Clear cache

### Manual File Rollback (if using Git)
```bash
# Revert to previous commit
git revert HEAD
git push rocketnet main

# Or reset to specific commit
git reset --hard [commit-hash]
git push --force rocketnet main  # Careful!
```

### Emergency Theme Switch
If theme is broken:
1. Access via SFTP
2. Rename broken theme folder
3. WordPress will fall back to default theme
4. Fix issue and rename back
