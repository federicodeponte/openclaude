#!/bin/bash
# OpenClaude MCP Servers Installation Script
# Installs all MCP servers globally via npm

set -e

echo "🚀 Installing OpenClaude MCP Servers..."
echo "======================================="

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install Node.js and npm first."
    exit 1
fi

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "❌ node not found. Please install Node.js first."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"
echo ""

# Array of MCP servers to install
declare -a servers=(
    "context7"
    "snyk"
    "coderabbitai-mcp"
    "@brave/brave-search-mcp-server"
    "@jpisnice/shadcn-ui-mcp-server"
    "heroicons-mcp"
    "lucide-icons-mcp"
    "@storybook/mcp"
    "@supabase/mcp-server-supabase"
    "@eslint/mcp"
    "@cyanheads/git-mcp-server"
    "@djankies/vitest-mcp"
    "github-mcp-server"
)

# Install each server
for server in "${servers[@]}"; do
    echo "📦 Installing $server..."
    if npm install -g "$server"; then
        echo "✅ $server installed successfully"
    else
        echo "❌ Failed to install $server"
        echo "   You can try installing manually: npm install -g $server"
    fi
    echo ""
done

echo "🎉 MCP Servers Installation Complete!"
echo "====================================="
echo ""
echo "📋 Next Steps:"
echo "1. Update your ~/.claude/settings.json with API keys"
echo "2. Verify paths match your Node.js installation"
echo "3. Restart Claude Code"
echo ""
echo "🔧 To check installation:"
echo "npm list -g --depth=0 | grep -E '(context7|snyk|coderabbit|brave|shadcn|heroicons|lucide|storybook|supabase|eslint|git-mcp|vitest|github)'"
echo ""
echo "📚 See README.md for API key setup instructions"