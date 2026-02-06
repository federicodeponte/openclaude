# OpenClaude

A comprehensive Claude Code configuration setup with MCP servers, permissions, and development tools.

## 🚀 Features

- **Complete MCP Server Setup** - 14 pre-configured MCP servers
- **Smart Permissions System** - Allow/deny/ask patterns for security
- **VM Development Environment** - Configured for remote development
- **Custom Commands** - AI agents and security scanning tools
- **Development Guidelines** - Comprehensive coding standards and workflows
- **In-Depth Guides** - Tutorials for browser automation, testing, and more

## 📁 Repository Structure

```
openclaude/
├── README.md                 # This file
├── config/
│   ├── settings.json        # Main Claude Code settings (sanitized)
│   ├── vm-config.json       # VM development configuration
│   └── permissions.json     # Isolated permissions configuration
├── mcp-servers/
│   ├── README.md           # MCP server documentation
│   └── install-all.sh      # Script to install all MCP servers
├── commands/
│   ├── agent.md            # AI agent commands
│   └── security/           # Security scanning commands
├── guidelines/
│   └── CLAUDE.md          # Development guidelines and best practices
├── guides/
│   ├── README.md           # Guides index
│   └── browser-use-local.md # Self-hosted browser automation
├── vm-setup/
│   ├── vm-helpers.sh       # VM helper scripts
│   └── README.md          # VM setup documentation
└── scripts/
    ├── install.sh          # One-click setup script
    └── backup.sh          # Backup existing config
```

## 🔧 MCP Servers Included

1. **playwright** - Browser automation and testing
2. **context7** - Documentation and context management
3. **snyk** - Security vulnerability scanning
4. **coderabbitai** - AI code review
5. **brave-search** - Web search capabilities
6. **shadcn-ui** - UI component library
7. **heroicons** - Icon library
8. **lucide-icons** - Icon library
9. **storybook** - Component documentation
10. **supabase** - Database and backend services
11. **eslint** - Code linting
12. **git** - Git operations
13. **vitest** - Testing framework
14. **github** - GitHub integration

## 🚦 Installation

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/federicodeponte/openclaude.git
cd openclaude

# Run the installation script
chmod +x scripts/install.sh
./scripts/install.sh
```

### Manual Setup

1. **Backup your existing configuration:**
   ```bash
   cp -r ~/.claude ~/.claude-backup
   ```

2. **Install MCP servers:**
   ```bash
   chmod +x mcp-servers/install-all.sh
   ./mcp-servers/install-all.sh
   ```

3. **Copy configuration files:**
   ```bash
   cp config/settings.json ~/.claude/settings.json
   cp config/vm-config.json ~/.claude/vm-config.json
   ```

4. **Set up environment variables:**
   ```bash
   # Add your API keys to the configuration
   # See config/README.md for details
   ```

## 🔐 Security & API Keys

This repository contains **sanitized configurations**. You'll need to add your own API keys:

- `CONTEXT7_API_KEY` - Context7 service
- `SNYK_TOKEN` - Snyk security scanning
- `GITHUB_PAT` - GitHub Personal Access Token
- `CODERABBIT_API_KEY` - CodeRabbit service
- `BRAVE_API_KEY` - Brave Search API
- `SUPABASE_ACCESS_TOKEN` - Supabase service

See `config/README.md` for detailed setup instructions.

## 🖥️ VM Development Setup

Includes configuration for remote VM development with automatic tunneling and synchronization.

Features:
- SSH tunnel management
- Port forwarding (3000-5010)
- Project synchronization
- Playwright testing support

See `vm-setup/README.md` for setup instructions.

## 📖 Guides

In-depth tutorials for development workflows:

- **[Browser-Use Local](guides/browser-use-local.md)** - Self-hosted browser automation with Ollama for product audits, UI testing, and screenshot verification. No cloud APIs required.

## 📋 Development Guidelines

Comprehensive development guidelines included covering:

- **Code Quality** - SOLID principles, DRY, KISS
- **Testing Standards** - Unit, integration, and E2E testing
- **Security Best Practices** - Credential management, code scanning
- **Git Workflow** - Branching, commits, PR process
- **Performance** - Optimization strategies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🔗 Related Projects

- [Claude Code](https://claude.ai/code) - Official Claude IDE
- [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) - Protocol for AI assistants

## 🆘 Support

- Create an issue for bug reports
- Discussions for questions and ideas
- Check the wiki for troubleshooting

---

**Built with ❤️ for the Claude Code community**