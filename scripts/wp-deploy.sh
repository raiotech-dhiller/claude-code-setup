#!/bin/bash
# WordPress deployment script for Rocket.net
# Place in project: deployment/deploy.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ENV="${1:-staging}"
SCOPE="${2:-all}"

# Load environment
if [ -f .env ]; then
    source .env
elif [ -f deployment/.env ]; then
    source deployment/.env
else
    echo -e "${RED}Error: .env file not found${NC}"
    echo "Create .env from .env.example and configure your Rocket.net credentials"
    exit 1
fi

# Set host based on environment
if [ "$ENV" == "production" ]; then
    echo -e "${YELLOW}⚠️  PRODUCTION DEPLOYMENT${NC}"
    read -p "Type 'deploy' to confirm: " confirm
    if [ "$confirm" != "deploy" ]; then
        echo "Aborted"
        exit 0
    fi
    HOST="${ROCKETNET_PROD_HOST:-$ROCKETNET_HOST}"
    USER="${ROCKETNET_PROD_USER:-$ROCKETNET_USER}"
    SITE_URL="$PRODUCTION_URL"
elif [ "$ENV" == "staging" ]; then
    HOST="${ROCKETNET_STAGING_HOST:-$ROCKETNET_HOST}"
    USER="${ROCKETNET_STAGING_USER:-$ROCKETNET_USER}"
    SITE_URL="$STAGING_URL"
else
    echo -e "${RED}Unknown environment: $ENV${NC}"
    echo "Use: staging or production"
    exit 1
fi

# Verify credentials
if [ -z "$HOST" ] || [ -z "$USER" ]; then
    echo -e "${RED}Error: Missing Rocket.net credentials in .env${NC}"
    exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🚀 Deploying to ${ENV}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project root (where deploy.sh is called from)
PROJECT_ROOT="$(pwd)"

# Determine what to deploy
DEPLOY_THEME=false
DEPLOY_PLUGIN=false

if [ "$SCOPE" == "all" ]; then
    DEPLOY_THEME=true
    DEPLOY_PLUGIN=true
elif [ "$SCOPE" == "theme" ]; then
    DEPLOY_THEME=true
elif [ "$SCOPE" == "plugin" ]; then
    DEPLOY_PLUGIN=true
else
    echo -e "${RED}Unknown scope: $SCOPE${NC}"
    echo "Use: all, theme, or plugin"
    exit 1
fi

# Deploy theme
if [ "$DEPLOY_THEME" = true ]; then
    THEME_LOCAL="./theme-child"
    THEME_REMOTE="/www/wp-content/themes/theme-child"
    
    if [ -d "$THEME_LOCAL" ]; then
        echo -e "${YELLOW}📦 Uploading theme...${NC}"
        
        rsync -avz --delete \
            --exclude '.git' \
            --exclude 'node_modules' \
            --exclude '.DS_Store' \
            --exclude '*.log' \
            --exclude 'package.json' \
            --exclude 'package-lock.json' \
            -e "ssh -o StrictHostKeyChecking=no" \
            "$THEME_LOCAL/" \
            "${USER}@${HOST}:${THEME_REMOTE}/"
        
        echo -e "${GREEN}✓ Theme deployed${NC}"
    else
        echo -e "${YELLOW}⚠ Theme directory not found: $THEME_LOCAL${NC}"
    fi
fi

# Deploy plugin
if [ "$DEPLOY_PLUGIN" = true ]; then
    PLUGIN_LOCAL="./plugin-client"
    PLUGIN_REMOTE="/www/wp-content/plugins/plugin-client"
    
    if [ -d "$PLUGIN_LOCAL" ]; then
        echo -e "${YELLOW}📦 Uploading plugin...${NC}"
        
        rsync -avz --delete \
            --exclude '.git' \
            --exclude '.DS_Store' \
            -e "ssh -o StrictHostKeyChecking=no" \
            "$PLUGIN_LOCAL/" \
            "${USER}@${HOST}:${PLUGIN_REMOTE}/"
        
        echo -e "${GREEN}✓ Plugin deployed${NC}"
    else
        echo -e "${YELLOW}⚠ Plugin directory not found: $PLUGIN_LOCAL${NC}"
    fi
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deployment to ${ENV} complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Clear cache: Rocket.net Dashboard > Cache > Purge All"
echo "  2. Regenerate CSS: Elementor > Tools > Regenerate CSS"
if [ -n "$SITE_URL" ]; then
    echo "  3. Test at: $SITE_URL"
fi
echo ""

# Log deployment
LOG_DIR="${HOME}/.claude/insights"
mkdir -p "$LOG_DIR"
echo "$(date +%Y-%m-%dT%H:%M:%S) | $(basename $PROJECT_ROOT) | $ENV | $SCOPE" >> "$LOG_DIR/wp-deployments.log"

# Call post-deploy hook if exists
POST_HOOK="${HOME}/.claude/hooks/post-wp-deploy.sh"
if [ -x "$POST_HOOK" ]; then
    echo "{\"environment\":\"$ENV\",\"project\":\"$(basename $PROJECT_ROOT)\",\"scope\":\"$SCOPE\"}" | "$POST_HOOK"
fi
