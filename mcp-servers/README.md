# MCP Servers

Model Context Protocol (MCP) servers provide additional capabilities to Claude Code.

## 🔌 Available Servers

### 🎭 **Playwright** 
- **Purpose**: Browser automation and testing
- **Installation**: Via URL (already running service)
- **Config**: `"url": "http://127.0.0.1:8931/mcp"`

### 📚 **Context7**
- **Purpose**: Documentation and context management
- **Installation**: `npm install -g context7`
- **Requires**: `CONTEXT7_API_KEY`

### 🔒 **Snyk**
- **Purpose**: Security vulnerability scanning
- **Installation**: `npm install -g snyk`
- **Requires**: `SNYK_TOKEN`

### 🤖 **CodeRabbit AI**
- **Purpose**: AI-powered code review
- **Installation**: `npm install -g coderabbitai-mcp`
- **Requires**: `GITHUB_PAT`, `CODERABBIT_API_KEY`

### 🔍 **Brave Search**
- **Purpose**: Web search capabilities
- **Installation**: `npm install -g @brave/brave-search-mcp-server`
- **Requires**: `BRAVE_API_KEY`

### 🎨 **shadcn/ui**
- **Purpose**: UI component library integration
- **Installation**: `npm install -g @jpisnice/shadcn-ui-mcp-server`
- **Requires**: `GITHUB_PERSONAL_ACCESS_TOKEN`

### 🎯 **Heroicons**
- **Purpose**: Icon library access
- **Installation**: `npm install -g heroicons-mcp`
- **Requires**: None

### ✨ **Lucide Icons**
- **Purpose**: Icon library access
- **Installation**: `npm install -g lucide-icons-mcp`
- **Requires**: None

### 📖 **Storybook**
- **Purpose**: Component documentation
- **Installation**: `npm install -g @storybook/mcp`
- **Requires**: None

### 🗄️ **Supabase**
- **Purpose**: Database and backend services
- **Installation**: `npm install -g @supabase/mcp-server-supabase`
- **Requires**: `SUPABASE_ACCESS_TOKEN`

### 🔍 **ESLint**
- **Purpose**: Code linting and formatting
- **Installation**: `npm install -g @eslint/mcp`
- **Requires**: None

### 🔀 **Git**
- **Purpose**: Git operations and version control
- **Installation**: `npm install -g @cyanheads/git-mcp-server`
- **Requires**: None

### 🧪 **Vitest**
- **Purpose**: Testing framework integration
- **Installation**: `npm install -g @djankies/vitest-mcp`
- **Requires**: None

### 🐙 **GitHub**
- **Purpose**: GitHub integration and operations
- **Installation**: `npm install -g github-mcp-server`
- **Requires**: `GITHUB_TOKEN`

## 🚀 Quick Installation

### Install All Servers
```bash
chmod +x install-all.sh
./install-all.sh
```

### Install Individual Server
```bash
npm install -g [package-name]
```

## 🔧 Configuration

After installation, update your `~/.claude/settings.json` with the appropriate paths and API keys.

### Finding Node Module Paths
```bash
# Check your global npm modules path
npm root -g

# Check specific package path
npm list -g [package-name]
```

### Updating Settings
1. Open `~/.claude/settings.json`
2. Update the `args` paths to match your Node.js installation
3. Add required API keys to the `env` section
4. Restart Claude Code

## 🔐 API Keys Required

| Server | Environment Variable | How to Get |
|--------|---------------------|------------|
| Context7 | `CONTEXT7_API_KEY` | [context7.ai](https://context7.ai) |
| Snyk | `SNYK_TOKEN` | [snyk.io](https://snyk.io) → Account Settings → API Token |
| CodeRabbit | `CODERABBIT_API_KEY` | [coderabbit.ai](https://coderabbit.ai) |
| CodeRabbit | `GITHUB_PAT` | GitHub → Settings → Developer settings → PAT |
| Brave Search | `BRAVE_API_KEY` | [brave.com/search/api](https://brave.com/search/api) |
| shadcn/ui | `GITHUB_PERSONAL_ACCESS_TOKEN` | Same as GitHub PAT |
| Supabase | `SUPABASE_ACCESS_TOKEN` | [supabase.com](https://supabase.com) → Project → Settings → API |
| GitHub | `GITHUB_TOKEN` | Same as GitHub PAT |

## 🔍 Troubleshooting

### Server Not Starting
1. **Check installation**: `npm list -g [package-name]`
2. **Verify path**: Ensure the path in settings.json is correct
3. **Check permissions**: Ensure the executable has proper permissions
4. **Review logs**: Check Claude Code logs for error messages

### API Key Issues
1. **Verify key format**: Check that the key matches the expected format
2. **Test key separately**: Use the service's CLI or API directly
3. **Check expiration**: Ensure the API key hasn't expired
4. **Review permissions**: Ensure the key has necessary permissions

### Path Issues
1. **Update Node version paths**: If you update Node.js, update the paths
2. **Check nvm usage**: If using nvm, ensure you're using the correct version
3. **Symlink issues**: Some package managers create symlinks that may need updating

### Common Fixes
```bash
# Reinstall problematic package
npm uninstall -g [package-name]
npm install -g [package-name]

# Clear npm cache
npm cache clean --force

# Check Claude Code logs
tail -f ~/.claude/debug/latest.log
```

## 🔄 Updates

To update MCP servers:

```bash
# Update all global packages
npm update -g

# Update specific package
npm update -g [package-name]
```

Remember to restart Claude Code after updates.

## 📚 Resources

- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [Claude Code Documentation](https://claude.ai/code)
- [Individual server documentation](https://github.com/search?q=mcp+server)