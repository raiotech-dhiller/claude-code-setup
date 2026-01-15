#!/bin/bash
# Claude Code Setup Management Script
# Place in ~/.claude/scripts/setup-manage.sh
# Usage: ./setup-manage.sh [command] [args]

set -e

CLAUDE_DIR="$HOME/.claude"
cd "$CLAUDE_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if git is initialized
check_git() {
    if [ ! -d ".git" ]; then
        echo -e "${RED}Error: Git not initialized in ~/.claude${NC}"
        echo "Run: ./setup-manage.sh init"
        exit 1
    fi
}

case "${1:-help}" in
    init)
        echo -e "${BLUE}Initializing Git repository...${NC}"
        
        if [ -d ".git" ]; then
            echo -e "${YELLOW}Git already initialized${NC}"
            exit 0
        fi
        
        git init
        
        # Create .gitignore
        cat > .gitignore << 'EOF'
# Environment and secrets
.env
.env.*
*.local

# Logs
*.log
logs/

# Temp files
*.tmp
*.bak
.DS_Store

# Insights (regenerated)
insights/

# Credentials
*credentials*
*secret*
*token*
EOF
        
        git add .
        git commit -m "Initial Claude Code setup"
        git tag -a v1.0-baseline -m "Clean baseline configuration"
        
        echo -e "${GREEN}✓ Git initialized${NC}"
        echo -e "${GREEN}✓ Baseline tag created: v1.0-baseline${NC}"
        ;;
        
    save)
        check_git
        MESSAGE="${2:-Update Claude Code configuration}"
        
        if [ -z "$(git status --porcelain)" ]; then
            echo -e "${YELLOW}No changes to save${NC}"
            exit 0
        fi
        
        git add .
        git commit -m "$MESSAGE"
        echo -e "${GREEN}✓ Changes saved: $MESSAGE${NC}"
        ;;
        
    backup)
        check_git
        TAG_NAME="${2:-backup-$(date +%Y%m%d-%H%M%S)}"
        
        # Commit any pending changes first
        if [ -n "$(git status --porcelain)" ]; then
            git add .
            git commit -m "Auto-save before backup: $TAG_NAME"
        fi
        
        git tag -a "$TAG_NAME" -m "Backup: $TAG_NAME"
        echo -e "${GREEN}✓ Backup created: $TAG_NAME${NC}"
        ;;
        
    list)
        check_git
        echo -e "${BLUE}═══ Backup Tags ═══${NC}"
        git tag -l -n1
        echo ""
        echo -e "${BLUE}═══ Recent Commits ═══${NC}"
        git log --oneline -10
        ;;
        
    status)
        check_git
        echo -e "${BLUE}═══ Repository Status ═══${NC}"
        git status
        echo ""
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "${BLUE}═══ Changes ═══${NC}"
            git diff --stat
        fi
        ;;
        
    diff)
        check_git
        REF="${2:-HEAD}"
        git diff "$REF"
        ;;
        
    restore)
        check_git
        REF="$2"
        
        if [ -z "$REF" ]; then
            echo -e "${RED}Error: Specify a tag or commit to restore${NC}"
            echo "Usage: ./setup-manage.sh restore <tag-or-commit>"
            echo ""
            echo "Available tags:"
            git tag -l
            exit 1
        fi
        
        echo -e "${YELLOW}⚠️  This will restore to: $REF${NC}"
        echo -e "${YELLOW}Current state will be backed up first${NC}"
        read -p "Continue? (y/N) " confirm
        
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "Aborted"
            exit 0
        fi
        
        # Backup current state
        BACKUP_TAG="pre-restore-$(date +%Y%m%d-%H%M%S)"
        git add .
        git commit -m "Auto-save before restore" 2>/dev/null || true
        git tag -a "$BACKUP_TAG" -m "Auto-backup before restoring to $REF"
        
        # Restore
        git reset --hard "$REF"
        
        echo -e "${GREEN}✓ Restored to: $REF${NC}"
        echo -e "${GREEN}✓ Previous state backed up as: $BACKUP_TAG${NC}"
        ;;
        
    push)
        check_git
        
        if [ -z "$(git remote)" ]; then
            echo -e "${RED}Error: No remote configured${NC}"
            echo "Add remote first:"
            echo "  git remote add origin git@github.com:USER/REPO.git"
            exit 1
        fi
        
        git push origin main --tags
        echo -e "${GREEN}✓ Pushed to remote${NC}"
        ;;
        
    pull)
        check_git
        
        if [ -z "$(git remote)" ]; then
            echo -e "${RED}Error: No remote configured${NC}"
            exit 1
        fi
        
        # Stash local changes
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "${YELLOW}Stashing local changes...${NC}"
            git stash
            STASHED=true
        fi
        
        git pull origin main
        
        # Restore stashed changes
        if [ "$STASHED" = true ]; then
            echo -e "${YELLOW}Restoring local changes...${NC}"
            git stash pop
        fi
        
        echo -e "${GREEN}✓ Pulled from remote${NC}"
        ;;
        
    remote)
        check_git
        REMOTE_URL="$2"
        
        if [ -z "$REMOTE_URL" ]; then
            echo -e "${BLUE}Current remotes:${NC}"
            git remote -v
            exit 0
        fi
        
        if [ -n "$(git remote)" ]; then
            git remote set-url origin "$REMOTE_URL"
        else
            git remote add origin "$REMOTE_URL"
        fi
        
        echo -e "${GREEN}✓ Remote set to: $REMOTE_URL${NC}"
        ;;
        
    help|*)
        echo -e "${BLUE}Claude Code Setup Manager${NC}"
        echo ""
        echo "Usage: ./setup-manage.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init              Initialize Git repository"
        echo "  save [message]    Commit current changes"
        echo "  backup [name]     Create tagged backup point"
        echo "  list              Show backups and history"
        echo "  status            Show current changes"
        echo "  diff [ref]        Show changes since ref"
        echo "  restore <ref>     Restore to tag or commit"
        echo "  push              Push to GitHub"
        echo "  pull              Pull from GitHub"
        echo "  remote [url]      View or set remote URL"
        echo "  help              Show this help"
        echo ""
        echo "Examples:"
        echo "  ./setup-manage.sh init"
        echo "  ./setup-manage.sh save \"Added new copywriting skill\""
        echo "  ./setup-manage.sh backup v1.1-stable"
        echo "  ./setup-manage.sh restore v1.0-baseline"
        ;;
esac
