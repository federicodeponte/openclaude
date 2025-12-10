# VM Development Setup

Configuration for remote VM development with Claude Code, including tunneling and synchronization.

## 🏗️ Overview

This setup enables:
- **Remote Development** - Run dev servers on VM, edit locally
- **SSH Tunneling** - Access VM services through local ports
- **File Synchronization** - Keep local and VM files in sync
- **Playwright Testing** - MCP server tunneling for browser automation

## 📁 Files

- `vm-config.json` - VM configuration and project mapping
- `vm-helpers.sh` - Shell functions for VM management
- `README.md` - This documentation

## 🚀 Quick Start

### 1. SSH Setup

```bash
# Add to ~/.ssh/config
Host vm
    HostName YOUR_VM_IP
    User YOUR_USERNAME
    IdentityFile ~/.ssh/google_compute_engine
    ServerAliveInterval 60
```

### 2. Load Helper Functions

```bash
# Add to ~/.zshrc or ~/.bashrc
source /path/to/vm-helpers.sh
```

### 3. Test Connection

```bash
vm_check    # Should show "✅ VM is reachable"
```

### 4. Start Development

```bash
vm_start_dev myproject 5173 /home/user/myproject
vm_logs 5173  # Check logs
```

## 🔧 Configuration

### VM Config Structure

```json
{
  "vm": {
    "host": "YOUR_VM_IP",
    "user": "YOUR_USERNAME", 
    "ssh_key": "~/.ssh/google_compute_engine"
  },
  "projects": {
    "myproject": {
      "local_path": "/Users/you/project",
      "vm_path": "/home/you/project",
      "port": 5173
    }
  }
}
```

### Port Mapping

| Port | Purpose | Service |
|------|---------|---------|
| 5173 | Primary dev server | Next.js/Vite |
| 5174 | Secondary dev server | Additional project |
| 8931 | Playwright MCP | Browser automation |
| 3000-5010 | Reverse tunnels | Various services |

## 🛠️ Helper Functions

### Connection & Status
```bash
vm_check                 # Check VM connectivity
vm_status               # Show VM overview
vm_health               # Comprehensive health check
```

### Development Servers
```bash
vm_start_dev <name> <port> <path>   # Start dev server
vm_stop_dev <port>                  # Stop server
vm_restart_dev <name> <port> <path> # Restart server
vm_check_dev <port>                 # Check if running
vm_logs <port> [lines]              # View logs
```

### File Synchronization
```bash
vm_sync <local> <remote>    # Sync files to VM
```

### Tunneling
```bash
vm_setup_playwright        # Setup Playwright tunnel
vm_kill_tunnels           # Kill all tunnels
```

## 📋 Common Workflows

### Starting a Development Session

```bash
# 1. Check VM status
vm_status

# 2. Sync latest files
vm_sync ~/myproject /home/user/myproject

# 3. Start dev server
vm_start_dev myproject 5173 /home/user/myproject

# 4. Setup Playwright (if needed)
vm_setup_playwright

# 5. Check everything is running
vm_health
```

### Debugging Issues

```bash
# Check server logs
vm_logs 5173 100

# Check VM resources
vm_health

# Restart services
vm_restart_dev myproject 5173 /home/user/myproject
```

### End of Session

```bash
# Stop dev servers
vm_stop_dev 5173
vm_stop_dev 5174

# Kill tunnels
vm_kill_tunnels
```

## 🔧 Troubleshooting

### Connection Issues

**"VM is not reachable"**
```bash
# Test direct SSH
ssh vm "echo test"

# Check SSH config
cat ~/.ssh/config | grep -A 5 "Host vm"

# Check VM status in cloud console
```

### Dev Server Issues

**"Dev server failed to start"**
```bash
# Check logs for errors
vm_logs 5173

# Check if port is already in use
vm_ssh "netstat -tlnp | grep 5173"

# Try different port
vm_start_dev myproject 5174 /home/user/myproject
```

**"ERR_CONNECTION_REFUSED"**
```bash
# Ensure server binds to 0.0.0.0
vm_ssh "cd /path/to/project && npm run dev -- -p 5173 -H 0.0.0.0"

# Check if tunnel is running
lsof -i :5173
```

### File Sync Issues

**Permission denied**
```bash
# Fix VM file permissions
vm_ssh "chmod -R 755 /home/user/myproject"

# Check rsync version
rsync --version
```

### Tunnel Issues

**Playwright MCP not connecting**
```bash
# Check tunnel status
lsof -i :8931

# Kill and restart tunnel
vm_kill_tunnels
vm_setup_playwright

# Test tunnel
curl -I http://localhost:8931
```

## 🔐 Security Considerations

- **SSH Keys** - Use SSH key authentication, not passwords
- **Firewall** - Only expose necessary ports
- **VPN** - Consider VPN for additional security
- **Regular Updates** - Keep VM system updated

## 📊 Performance Tips

- **Resource Monitoring** - Use `vm_health` to monitor usage
- **File Sync** - Only sync when necessary to save bandwidth
- **Port Management** - Close unused tunnels
- **Cleanup** - Regularly clean up logs and temp files

## 🔄 Automation

### LaunchAgent Setup (macOS)

Create plist files for automatic tunnel management:

```bash
# Example: Playwright tunnel
cat > ~/Library/LaunchAgents/com.playwright.vm-tunnel.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.playwright.vm-tunnel</string>
    <key>ProgramArguments</key>
    <array>
        <string>ssh</string>
        <string>-N</string>
        <string>-L</string>
        <string>8931:localhost:8931</string>
        <string>vm</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Load the service
launchctl load ~/Library/LaunchAgents/com.playwright.vm-tunnel.plist
```

## 📚 Advanced Usage

### Custom Sync Scripts

Create project-specific sync scripts for complex setups:

```bash
#!/bin/bash
# sync-myproject.sh

# Sync source code
vm_sync ~/myproject/src /home/user/myproject/src

# Sync package.json but exclude node_modules
rsync -avz --exclude node_modules ~/myproject/package*.json vm:/home/user/myproject/

# Install dependencies on VM
vm_ssh "cd /home/user/myproject && npm install"

echo "✅ Project sync complete"
```

### Multiple Environment Support

```bash
# Development
vm_start_dev myproject-dev 5173 /home/user/myproject-dev

# Staging  
vm_start_dev myproject-staging 5174 /home/user/myproject-staging

# Switch between environments
alias dev_env='vm_logs 5173'
alias staging_env='vm_logs 5174'
```