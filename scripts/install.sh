#!/bin/bash
# OpenClaude Installation Script
# One-click setup for Claude Code configuration

set -e

CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 OpenClaude Installation"
echo "========================="
echo ""

# Check dependencies
echo "🔍 Checking dependencies..."

if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install Node.js and npm first."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ git not found. Please install git first."
    exit 1
fi

echo "✅ Dependencies check passed"
echo ""

# Backup existing configuration
if [ -d "$CLAUDE_DIR" ]; then
    echo "💾 Backing up existing Claude configuration..."
    cp -r "$CLAUDE_DIR" "$BACKUP_DIR"
    echo "✅ Backup created at: $BACKUP_DIR"
else
    echo "📁 Creating new Claude directory..."
    mkdir -p "$CLAUDE_DIR"
fi
echo ""

# Create directory structure
echo "📁 Setting up directory structure..."
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/commands/security"
echo "✅ Directory structure created"
echo ""

# Copy configuration files
echo "⚙️  Installing configuration files..."

# Main settings
cp "$REPO_DIR/config/settings.json" "$CLAUDE_DIR/settings.json"
echo "✅ settings.json installed"

# VM configuration (optional)
if [ -f "$REPO_DIR/config/vm-config.json" ]; then
    cp "$REPO_DIR/config/vm-config.json" "$CLAUDE_DIR/vm-config.json"
    echo "✅ vm-config.json installed"
fi

# Commands
if [ -d "$REPO_DIR/commands" ]; then
    cp -r "$REPO_DIR/commands"/* "$CLAUDE_DIR/commands/"
    echo "✅ Command files installed"
fi

# Guidelines
if [ -f "$REPO_DIR/guidelines/CLAUDE.md" ]; then
    cp "$REPO_DIR/guidelines/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "✅ Guidelines installed"
fi

# VM helpers
if [ -f "$REPO_DIR/vm-setup/vm-helpers.sh" ]; then
    cp "$REPO_DIR/vm-setup/vm-helpers.sh" "$CLAUDE_DIR/vm-helpers.sh"
    chmod +x "$CLAUDE_DIR/vm-helpers.sh"
    echo "✅ VM helpers installed"
fi

echo ""

# Install MCP servers
echo "📦 Installing MCP servers..."
if [ -f "$REPO_DIR/mcp-servers/install-all.sh" ]; then
    cd "$REPO_DIR/mcp-servers"
    chmod +x install-all.sh
    ./install-all.sh
else
    echo "⚠️  MCP installation script not found, installing manually..."
    
    # Install key MCP servers
    npm install -g context7 || echo "Failed to install context7"
    npm install -g snyk || echo "Failed to install snyk"  
    npm install -g @brave/brave-search-mcp-server || echo "Failed to install brave-search"
    npm install -g github-mcp-server || echo "Failed to install github-mcp"
    npm install -g @eslint/mcp || echo "Failed to install eslint-mcp"
fi
echo ""

# Update paths in settings
echo "🔧 Updating configuration paths..."
USERNAME=$(whoami)
NODE_PATH=$(npm root -g)
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Replace USERNAME placeholders
sed -i.bak "s/YOUR_USERNAME/$USERNAME/g" "$SETTINGS_FILE" 2>/dev/null || \
sed -i '' "s/YOUR_USERNAME/$USERNAME/g" "$SETTINGS_FILE" 2>/dev/null || \
echo "⚠️  Could not automatically update username paths"

# Update node paths
if [ -n "$NODE_PATH" ]; then
    sed -i.bak "s|/Users/USERNAME/.nvm/versions/node/v20.19.5/lib/node_modules|$NODE_PATH|g" "$SETTINGS_FILE" 2>/dev/null || \
    sed -i '' "s|/Users/USERNAME/.nvm/versions/node/v20.19.5/lib/node_modules|$NODE_PATH|g" "$SETTINGS_FILE" 2>/dev/null || \
    echo "⚠️  Could not automatically update node paths"
fi

# Clean up backup files
rm -f "$SETTINGS_FILE.bak"

echo "✅ Configuration paths updated"
echo ""

# Setup instructions
echo "🎉 Installation Complete!"
echo "========================"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. 🔐 Add your API keys to ~/.claude/settings.json:"
echo "   - CONTEXT7_API_KEY"
echo "   - SNYK_TOKEN"  
echo "   - GITHUB_PAT"
echo "   - CODERABBIT_API_KEY"
echo "   - BRAVE_API_KEY"
echo "   - SUPABASE_ACCESS_TOKEN"
echo ""
echo "2. 🖥️  If using VM development, update ~/.claude/vm-config.json:"
echo "   - VM host IP address"
echo "   - Project paths"
echo ""
echo "3. 🔄 Restart Claude Code to apply changes"
echo ""
echo "4. 🧪 Test the installation:"
echo "   - Try a simple command in Claude Code"
echo "   - Check if MCP servers are working"
echo ""
echo "📚 Documentation:"
echo "   - Configuration: $REPO_DIR/config/README.md"
echo "   - MCP Servers: $REPO_DIR/mcp-servers/README.md"
echo "   - VM Setup: $REPO_DIR/vm-setup/README.md"
echo ""
echo "💾 Backup location: $BACKUP_DIR"
echo ""

# VM helper setup prompt
if [ -f "$CLAUDE_DIR/vm-helpers.sh" ]; then
    echo "🛠️  VM Helpers Available!"
    echo "   Add to your shell profile (~/.zshrc or ~/.bashrc):"
    echo "   source $CLAUDE_DIR/vm-helpers.sh"
    echo ""
fi

echo "🎊 OpenClaude is ready to use!"