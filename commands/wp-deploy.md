# WordPress Deploy Command

Deploy WordPress theme and plugins to Rocket.net.

## Usage
```
/project:wp-deploy [environment] [scope]
```

**Environments:**
- `staging` (default) - Deploy to Rocket.net staging
- `production` - Deploy to Rocket.net production (with confirmation)

**Scope:**
- `all` (default) - Theme + plugins
- `theme` - Theme only
- `plugin` - Client plugin only

## Workflow

### Pre-Deployment Checks
1. Verify environment variables configured
2. Check for uncommitted changes (if using Git)
3. Run any build process (if applicable)

### Deployment Steps
1. Connect to Rocket.net via SSH/SFTP
2. Upload changed files
3. Report deployment status

### Post-Deployment
1. Remind to clear cache
2. Remind to regenerate Elementor CSS
3. Provide testing URL

## Integration with wordpress-website-specialist

When invoked, delegate to wordpress-website-specialist agent with:

```markdown
**Task**: Deploy WordPress files to Rocket.net
**Environment**: [staging/production]
**Scope**: [all/theme/plugin]
**Files**: 
- theme-child/ (if theme or all)
- plugin-client/ (if plugin or all)
**Output**: Deployment status and next steps
```

## Example Sessions

### Deploy to Staging
```
> /project:wp-deploy staging all

[wordpress-website-specialist executes]

✅ Deployment to staging complete!

Files deployed:
- theme-child/ → /www/wp-content/themes/theme-child/
- plugin-client/ → /www/wp-content/plugins/plugin-client/

Next steps:
1. Clear cache: Rocket.net Dashboard > Cache > Purge All
2. Regenerate CSS: Elementor > Tools > Regenerate CSS
3. Test at: https://staging.example.rocketcdn.me
```

### Deploy to Production
```
> /project:wp-deploy production theme

⚠️ You're about to deploy to PRODUCTION
Scope: theme only

Proceed? (yes/no)
> yes

[wordpress-website-specialist executes with caution]

✅ Production deployment complete!
```

## Script Reference

The command uses deployment/deploy.sh from the project:

```bash
#!/bin/bash
# deploy.sh [environment] [scope]

ENV="${1:-staging}"
SCOPE="${2:-all}"

# ... deployment logic
```

## Error Handling

### Connection Failed
- Verify SSH credentials in .env
- Check Rocket.net SFTP is enabled
- Verify IP not blocked

### Permission Denied
- Check file permissions on Rocket.net
- Verify correct user has write access

### Files Not Appearing
- Clear Rocket.net cache
- Check correct path
- Verify file upload completed
