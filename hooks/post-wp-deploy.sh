#!/bin/bash
# Post-deployment hook for WordPress/Rocket.net sites
# Called after successful deployment

# This hook reminds about post-deployment tasks
# and logs deployment for reference

DEPLOY_LOG="${HOME}/.claude/insights/wp-deployments.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Read deployment info from stdin (if piped from deploy script)
read -r DEPLOY_INFO 2>/dev/null || DEPLOY_INFO="{}"

# Parse deployment info
ENV=$(echo "$DEPLOY_INFO" | jq -r '.environment // "unknown"' 2>/dev/null || echo "unknown")
PROJECT=$(echo "$DEPLOY_INFO" | jq -r '.project // "unknown"' 2>/dev/null || echo "unknown")
SCOPE=$(echo "$DEPLOY_INFO" | jq -r '.scope // "all"' 2>/dev/null || echo "all")

# Log deployment
mkdir -p "$(dirname "$DEPLOY_LOG")"
echo "${TIMESTAMP} | ${PROJECT} | ${ENV} | ${SCOPE}" >> "$DEPLOY_LOG"

# Output reminders
cat << 'EOF' >&2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 POST-DEPLOYMENT CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

□ Clear Rocket.net Cache
  Dashboard > [Site] > Cache > Purge All

□ Regenerate Elementor CSS (if theme/CSS changed)
  WordPress Admin > Elementor > Tools > Regenerate CSS

□ Test Key Pages
  - Homepage
  - Contact/Forms
  - WooCommerce checkout (if applicable)

□ Check Mobile Responsiveness
  - Test on actual device or responsive mode

□ Verify Forms Working
  - Test contact form submissions
  - Check LeadConnector/CRM receiving data

□ Monitor for Errors
  - Check browser console
  - Check PHP error logs if issues

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# If production deployment, extra warning
if [ "$ENV" == "production" ]; then
    cat << 'EOF' >&2

⚠️  PRODUCTION DEPLOYMENT - Additional checks:
□ Verify live site loads correctly
□ Check critical conversion paths
□ Monitor uptime for next 30 minutes
□ Have rollback plan ready

EOF
fi
