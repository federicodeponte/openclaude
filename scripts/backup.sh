#!/bin/bash
# OpenClaude Backup Script
# Creates a backup of your current Claude Code configuration

set -e

CLAUDE_DIR="$HOME/.claude"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/.claude-backup-$TIMESTAMP"
BACKUP_ARCHIVE="$HOME/claude-backup-$TIMESTAMP.tar.gz"

echo "💾 OpenClaude Backup Tool"
echo "========================"
echo ""

# Check if Claude directory exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ Claude directory not found at $CLAUDE_DIR"
    echo "   Nothing to backup."
    exit 1
fi

echo "📂 Source: $CLAUDE_DIR"
echo "📦 Backup: $BACKUP_DIR"
echo "🗜️  Archive: $BACKUP_ARCHIVE"
echo ""

# Create backup directory
echo "📁 Creating backup directory..."
mkdir -p "$BACKUP_DIR"

# Copy configuration files
echo "📋 Copying configuration files..."
cp -r "$CLAUDE_DIR"/* "$BACKUP_DIR/" 2>/dev/null || {
    echo "⚠️  Some files could not be copied (possibly permission issues)"
}

# Create inventory of what was backed up
echo "📝 Creating backup inventory..."
cat > "$BACKUP_DIR/BACKUP_INFO.txt" << EOF
OpenClaude Configuration Backup
===============================

Backup Date: $(date)
Source: $CLAUDE_DIR
Backup Location: $BACKUP_DIR

Files Backed Up:
$(find "$BACKUP_DIR" -type f -not -name "BACKUP_INFO.txt" | sed "s|$BACKUP_DIR/||" | sort)

Directories:
$(find "$BACKUP_DIR" -type d | sed "s|$BACKUP_DIR||" | grep -v "^$" | sort)

Total Files: $(find "$BACKUP_DIR" -type f -not -name "BACKUP_INFO.txt" | wc -l | tr -d ' ')
Total Size: $(du -sh "$BACKUP_DIR" | cut -f1)

Restore Instructions:
====================
To restore this backup:
1. Stop Claude Code
2. Backup current config: mv ~/.claude ~/.claude-old
3. Restore backup: cp -r "$BACKUP_DIR" ~/.claude
4. Start Claude Code

Or use the restore script:
./scripts/restore.sh "$BACKUP_ARCHIVE"
EOF

# Create compressed archive
echo "🗜️  Creating compressed archive..."
tar -czf "$BACKUP_ARCHIVE" -C "$(dirname "$BACKUP_DIR")" "$(basename "$BACKUP_DIR")"

# Verify backup
echo "✅ Verifying backup..."
if [ -f "$BACKUP_ARCHIVE" ]; then
    ARCHIVE_SIZE=$(du -sh "$BACKUP_ARCHIVE" | cut -f1)
    echo "✅ Archive created successfully: $ARCHIVE_SIZE"
else
    echo "❌ Archive creation failed"
    exit 1
fi

# Show backup summary
echo ""
echo "🎉 Backup Complete!"
echo "=================="
echo ""
echo "📦 Archive: $BACKUP_ARCHIVE"
echo "📁 Directory: $BACKUP_DIR" 
echo "📊 Size: $ARCHIVE_SIZE"
echo ""
echo "📋 Backed up files:"
find "$BACKUP_DIR" -type f -not -name "BACKUP_INFO.txt" | sed "s|$BACKUP_DIR/|   |" | head -10
TOTAL_FILES=$(find "$BACKUP_DIR" -type f -not -name "BACKUP_INFO.txt" | wc -l | tr -d ' ')
if [ "$TOTAL_FILES" -gt 10 ]; then
    echo "   ... and $((TOTAL_FILES - 10)) more files"
fi
echo ""
echo "🔄 To restore:"
echo "   tar -xzf $BACKUP_ARCHIVE"
echo "   cp -r $(basename "$BACKUP_DIR")/* ~/.claude/"
echo ""
echo "💡 Keep this backup safe for future restoration!"

# Optional cleanup
read -p "🗑️  Remove uncompressed backup directory? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$BACKUP_DIR"
    echo "✅ Uncompressed backup cleaned up"
else
    echo "📁 Uncompressed backup kept at: $BACKUP_DIR"
fi