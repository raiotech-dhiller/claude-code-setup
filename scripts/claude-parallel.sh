#!/bin/bash
# Launch multiple Claude Code instances in git worktrees

NUM_WORKERS=${1:-3}
BASE_BRANCH=${2:-main}
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

echo "🚀 Setting up $NUM_WORKERS parallel Claude Code instances..."

for i in $(seq 1 $NUM_WORKERS); do
    WORKTREE_DIR="../${PROJECT_NAME}-worker-${i}"
    BRANCH_NAME="parallel-work-${i}-$(date +%s)"
    
    # Create worktree
    git worktree add "$WORKTREE_DIR" -b "$BRANCH_NAME" "$BASE_BRANCH" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Worker $i: $WORKTREE_DIR on branch $BRANCH_NAME"
    else
        echo "⚠️  Worker $i: Failed to create worktree (may already exist)"
    fi
done

echo ""
echo "📋 Launch commands (run in separate terminals):"
for i in $(seq 1 $NUM_WORKERS); do
    echo "   Terminal $i: cd ../${PROJECT_NAME}-worker-${i} && claude"
done

echo ""
echo "🧹 Cleanup when done:"
echo "   git worktree list"
echo "   git worktree remove ../${PROJECT_NAME}-worker-N"
