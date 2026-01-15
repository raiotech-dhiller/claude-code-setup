#!/usr/bin/env python3
"""
PreCompact Hook: Safety net backup before compaction.
Ideally handoffs happen before this triggers.
"""

import json
import sys
import shutil
from pathlib import Path
from datetime import datetime

def main():
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        print("Warning: Could not parse hook input", file=sys.stderr)
        return
    
    session_id = data.get('session_id', 'unknown')
    transcript_path = data.get('transcript_path')
    trigger = data.get('trigger', 'unknown')
    
    # Create backup directory
    backup_dir = Path.home() / '.claude' / 'backups' / 'pre-compact'
    backup_dir.mkdir(parents=True, exist_ok=True)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    # Backup transcript
    if transcript_path and Path(transcript_path).exists():
        backup_file = backup_dir / f"transcript_{session_id}_{timestamp}.jsonl"
        shutil.copy(transcript_path, backup_file)
        print(f"📦 Transcript backed up: {backup_file}", file=sys.stderr)
    
    # Log compaction event
    log_file = Path.home() / '.claude' / 'insights' / 'compaction-log.txt'
    with open(log_file, 'a') as f:
        f.write(f"{timestamp} | Session: {session_id} | Trigger: {trigger}\n")
    
    if trigger == 'auto':
        print("", file=sys.stderr)
        print("⚠️  AUTO-COMPACTION TRIGGERED", file=sys.stderr)
        print("   Next time, run /project:handoff earlier.", file=sys.stderr)
        print("", file=sys.stderr)

if __name__ == '__main__':
    main()
