#!/bin/bash
# Claude Code VM Helper Scripts
# ABOUTME: Helper commands for managing Claude Code sessions on VM

# Quick SSH to VM (uses SSH config alias 'vm')
vm_ssh() {
    ssh vm "$@"
}

# Run command on VM (with error handling)
vm_exec() {
    local cmd="$1"
    vm_ssh "$cmd" 2>&1
}

# Check if VM is reachable
vm_check() {
    vm_ssh "echo OK" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ VM is reachable"
        return 0
    else
        echo "❌ VM is not reachable"
        return 1
    fi
}

# Check if dev server is running on VM
vm_check_dev() {
    local port="$1"
    vm_ssh "ps aux | grep -v grep | grep 'next dev.*${port}'" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Dev server on port ${port} is running"
        return 0
    else
        echo "❌ Dev server on port ${port} is NOT running"
        return 1
    fi
}

# Start dev server on VM
vm_start_dev() {
    local project="$1"  # scaile or zola
    local port="$2"
    local path="$3"

    echo "Starting dev server for ${project} on port ${port}..."
    vm_ssh "cd ${path} && nohup npm run dev -- -p ${port} -H 0.0.0.0 > /tmp/dev-${port}.log 2>&1 &"

    sleep 5
    echo "Waiting for server to start..."
    
    # Check if server started
    local attempts=0
    while [ $attempts -lt 10 ]; do
        if vm_ssh "curl -s -I http://localhost:${port}" &>/dev/null; then
            echo "✅ Dev server started successfully on port ${port}"
            return 0
        fi
        attempts=$((attempts + 1))
        sleep 2
    done
    
    echo "❌ Dev server failed to start on port ${port}"
    return 1
}

# Stop dev server on VM
vm_stop_dev() {
    local port="$1"
    echo "Stopping dev server on port ${port}..."
    vm_ssh "pkill -f 'next dev.*${port}'"
    echo "✅ Dev server stopped"
}

# View dev server logs
vm_logs() {
    local port="$1"
    local lines="${2:-50}"
    vm_ssh "tail -n ${lines} /tmp/dev-${port}.log"
}

# Restart dev server
vm_restart_dev() {
    local project="$1"
    local port="$2"
    local path="$3"
    
    echo "Restarting dev server for ${project}..."
    vm_stop_dev "${port}"
    sleep 2
    vm_start_dev "${project}" "${port}" "${path}"
}

# Check VM system status
vm_status() {
    echo "🖥️  VM Status Check"
    echo "=================="
    
    if vm_check; then
        echo ""
        echo "📊 System Info:"
        vm_ssh "uptime"
        vm_ssh "df -h / | tail -1"
        vm_ssh "free -h | head -2"
        
        echo ""
        echo "🔌 Port Status:"
        vm_ssh "netstat -tlnp 2>/dev/null | grep -E ':(5173|5174|8931)' | head -5"
        
        echo ""
        echo "⚙️  Node Processes:"
        vm_ssh "ps aux | grep -E '(node|npm)' | grep -v grep | head -3"
    fi
}

# Sync files to VM
vm_sync() {
    local local_path="$1"
    local vm_path="$2"
    
    if [ -z "$local_path" ] || [ -z "$vm_path" ]; then
        echo "Usage: vm_sync <local_path> <vm_path>"
        return 1
    fi
    
    echo "🔄 Syncing ${local_path} → VM:${vm_path}"
    rsync -avz --delete "$local_path/" vm:"$vm_path"
    echo "✅ Sync complete"
}

# Quick setup for Playwright MCP
vm_setup_playwright() {
    echo "🎭 Setting up Playwright MCP tunnel..."
    
    # Check if tunnel is already running
    if lsof -i :8931 &>/dev/null; then
        echo "✅ Playwright tunnel already running on port 8931"
        return 0
    fi
    
    # Start SSH tunnel for Playwright MCP
    ssh -f -N -L 8931:localhost:8931 vm
    
    if lsof -i :8931 &>/dev/null; then
        echo "✅ Playwright tunnel started on port 8931"
    else
        echo "❌ Failed to start Playwright tunnel"
        return 1
    fi
}

# Kill all tunnels
vm_kill_tunnels() {
    echo "🚫 Killing all SSH tunnels..."
    pkill -f "ssh.*-L.*vm"
    echo "✅ All tunnels killed"
}

# Health check
vm_health() {
    echo "🏥 VM Health Check"
    echo "=================="
    
    # Basic connectivity
    vm_check
    
    # Check disk space
    echo ""
    echo "💾 Disk Usage:"
    vm_ssh "df -h | grep -E '^/dev' | head -3"
    
    # Check memory
    echo ""
    echo "🧠 Memory Usage:"
    vm_ssh "free -h"
    
    # Check load
    echo ""
    echo "📈 Load Average:"
    vm_ssh "uptime"
    
    # Check critical services
    echo ""
    echo "🔌 Port Check:"
    for port in 5173 5174 8931; do
        if vm_ssh "netstat -tln | grep :${port}" &>/dev/null; then
            echo "✅ Port ${port} is listening"
        else
            echo "❌ Port ${port} is not listening"
        fi
    done
}

# Usage examples
show_vm_examples() {
    cat << 'EOF'
🚀 VM Helper Commands Usage

Basic Commands:
  vm_check                    # Check if VM is reachable
  vm_status                   # Show VM status overview
  vm_health                   # Comprehensive health check

Development Servers:
  vm_start_dev scaile 5173 /home/user/project  # Start dev server
  vm_stop_dev 5173                             # Stop dev server  
  vm_restart_dev scaile 5173 /home/user/project # Restart server
  vm_check_dev 5173                            # Check if running
  vm_logs 5173 100                             # View logs

File Sync:
  vm_sync ./local-dir /home/user/remote-dir    # Sync files

Tunnels:
  vm_setup_playwright         # Setup Playwright MCP tunnel
  vm_kill_tunnels            # Kill all SSH tunnels

Examples:
  source vm-helpers.sh        # Load these functions
  vm_status                   # Quick status check
  vm_start_dev myapp 5173 /home/user/myapp
  vm_logs 5173               # Check logs
EOF
}

# Load message
echo "🛠️  VM Helper functions loaded!"
echo "   Run 'show_vm_examples' for usage examples"