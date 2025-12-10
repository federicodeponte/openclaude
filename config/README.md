# Configuration Files

This directory contains the main Claude Code configuration files.

## 📄 Files

### `settings.json`
Main Claude Code configuration with:
- **Permissions** - Allow/deny/ask patterns for tools
- **MCP Servers** - 14 pre-configured servers
- **Status Line** - Custom terminal status display
- **Feature Flags** - UI behavior settings

### `vm-config.json`
VM development environment configuration:
- **VM Connection** - SSH settings and host info
- **Port Management** - Development server ports
- **Project Mapping** - Local to VM path mapping
- **Service Management** - Tunnel and sync services

### `permissions.json`
Isolated permissions configuration (optional):
- Can be used to manage permissions separately
- Import into main settings.json as needed

## 🔧 Setup Instructions

### 1. Copy to Claude Directory

```bash
# Backup existing config
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Copy new configuration
cp config/settings.json ~/.claude/settings.json
cp config/vm-config.json ~/.claude/vm-config.json
```

### 2. Update Paths and Credentials

Edit `~/.claude/settings.json` and replace:

- `YOUR_USERNAME` → Your actual username
- `YOUR_CONTEXT7_API_KEY` → Your Context7 API key
- `YOUR_SNYK_TOKEN` → Your Snyk token
- `YOUR_GITHUB_PERSONAL_ACCESS_TOKEN` → Your GitHub PAT
- `YOUR_CODERABBIT_API_KEY` → Your CodeRabbit API key
- `YOUR_BRAVE_API_KEY_HERE` → Your Brave Search API key
- `YOUR_SUPABASE_ACCESS_TOKEN` → Your Supabase token
- `YOUR_GITHUB_TOKEN` → Your GitHub token

### 3. Update Node.js Paths

The configuration assumes Node.js v20.19.5 installed via nvm. Update paths if needed:

```bash
# Check your node path
which node

# Update the paths in settings.json accordingly
```

### 4. VM Configuration (Optional)

If using VM development, edit `vm-config.json`:

- `YOUR_VM_HOST_IP` → Your VM's IP address
- Update project paths to match your setup
- Adjust port ranges as needed

## 🔐 API Key Setup

### Context7
1. Sign up at [context7.ai](https://context7.ai)
2. Get your API key from dashboard
3. Add to `CONTEXT7_API_KEY`

### Snyk
1. Create account at [snyk.io](https://snyk.io)
2. Go to Account Settings → API Token
3. Add to `SNYK_TOKEN`

### GitHub PAT
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic) with repo permissions
3. Add to `GITHUB_PAT` and `GITHUB_TOKEN`

### CodeRabbit
1. Sign up at [coderabbit.ai](https://coderabbit.ai)
2. Get API key from settings
3. Add to `CODERABBIT_API_KEY`

### Brave Search
1. Get API key from [brave.com/search/api](https://brave.com/search/api)
2. Add to `BRAVE_API_KEY`

### Supabase
1. Create project at [supabase.com](https://supabase.com)
2. Go to Settings → API → Service Role Key
3. Add to `SUPABASE_ACCESS_TOKEN`

## 🚦 Permissions Explained

### Allow
- `"*"` - Allow all tools by default
- Specific tools listed for clarity

### Deny
- Environment files (`.env*`)
- SSH keys and certificates
- Secret directories
- Private key files

### Ask
- Destructive git operations
- Force push commands
- Hard resets
- Recursive deletions

## 🔄 Updating Configuration

To update your configuration:

1. **Backup current settings**
2. **Merge new changes** from this repository
3. **Test with a simple command** to ensure it works
4. **Restart Claude Code** if needed

## ❗ Troubleshooting

### MCP Server Not Working
1. Check if the npm package is installed
2. Verify the path to the module
3. Ensure API keys are set correctly
4. Check Claude Code logs for errors

### Permission Denied
1. Review the deny patterns
2. Add specific allow rules if needed
3. Check file permissions on your system

### VM Connection Issues
1. Verify SSH key setup
2. Check VM IP address
3. Test connection manually: `ssh user@vm-ip`
4. Review vm-config.json paths