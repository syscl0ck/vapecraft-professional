#!/usr/bin/env bash

# Vapecraft Professional Troubleshooting Script
# Diagnoses common issues with the server setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_section() {
    echo -e "${BLUE}--- $1 ---${NC}"
}

# Function to check Docker installation
check_docker() {
    print_section "Docker Installation"
    if command -v docker >/dev/null 2>&1; then
        print_status "Docker is installed"
        docker_version=$(docker --version)
        echo "  Version: $docker_version"
    else
        print_error "Docker is not installed"
        echo "  Please install Docker from https://docs.docker.com/get-docker/"
        return 1
    fi
    
    if command -v docker compose >/dev/null 2>&1; then
        print_status "Docker Compose is available"
    else
        print_error "Docker Compose is not available"
        echo "  Please install Docker Compose"
        return 1
    fi
}

# Function to check server status
check_server_status() {
    print_section "Server Status"
    if docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"; then
        print_status "Server container is running"
        
        # Check container health
        container_status=$(docker inspect --format='{{.State.Status}}' vapecraft-server 2>/dev/null)
        if [ "$container_status" = "running" ]; then
            print_status "Container is healthy"
        else
            print_warning "Container status: $container_status"
        fi
        
        # Check port binding
        if docker port vapecraft-server 25565 >/dev/null 2>&1; then
            print_status "Port 25565 is bound"
        else
            print_error "Port 25565 is not bound"
        fi
    else
        print_warning "Server container is not running"
    fi
}

# Function to check file structure
check_file_structure() {
    print_section "File Structure"
    
    # Check required files
    required_files=("docker-compose.yml" "setup.sh" "server-manager.sh")
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_status "$file exists"
        else
            print_error "$file is missing"
        fi
    done
    
    # Check required directories
    required_dirs=("plugins" "mods" "data")
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            print_status "$dir directory exists"
        else
            print_error "$dir directory is missing"
        fi
    done
}

# Function to check plugins
check_plugins() {
    print_section "Plugin Status"
    
    if [ ! -d "plugins" ]; then
        print_error "Plugins directory does not exist"
        return
    fi
    
    # Check for essential plugins
    essential_plugins=("Vault.jar" "Multiverse-Core.jar" "EssentialsX.jar")
    for plugin in "${essential_plugins[@]}"; do
        if [ -f "plugins/$plugin" ]; then
            print_status "$plugin is installed"
        else
            print_error "$plugin is missing"
        fi
    done
    
    # Count total plugins
    plugin_count=$(find plugins -name "*.jar" | wc -l)
    echo "  Total plugins: $plugin_count"
    
    if [ "$plugin_count" -eq 0 ]; then
        print_warning "No plugins found. Run './plugins/download.sh' to download them."
    fi
}

# Function to check mods
check_mods() {
    print_section "Mod Status"
    
    if [ ! -d "mods" ]; then
        print_error "Mods directory does not exist"
        return
    fi
    
    mod_count=$(find mods -name "*.jar" | wc -l)
    echo "  Total mods: $mod_count"
    
    if [ "$mod_count" -eq 0 ]; then
        print_warning "No mods found. Consider adding Pixelmon Reforged for the Pixelmon realm."
        echo "  Download from: https://reforged.gg/downloads"
    else
        print_status "Mods are installed"
        echo "  Installed mods:"
        find mods -name "*.jar" -exec basename {} \;
    fi
}

# Function to check server logs for errors
check_logs() {
    print_section "Recent Log Analysis"
    
    if ! docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"; then
        print_warning "Server is not running, cannot check logs"
        return
    fi
    
    # Get recent logs
    recent_logs=$(docker compose logs --tail=50 2>/dev/null)
    
    # Check for common error patterns
    error_patterns=(
        "ERROR"
        "Exception"
        "Failed"
        "Could not"
        "Unable to"
        "Plugin.*failed"
        "World.*failed"
    )
    
    found_errors=false
    for pattern in "${error_patterns[@]}"; do
        if echo "$recent_logs" | grep -i "$pattern" >/dev/null; then
            if [ "$found_errors" = false ]; then
                print_warning "Found potential issues in logs:"
                found_errors=true
            fi
            echo "  - $pattern"
        fi
    done
    
    if [ "$found_errors" = false ]; then
        print_status "No obvious errors found in recent logs"
    fi
}

# Function to check disk space
check_disk_space() {
    print_section "Disk Space"
    
    # Check available disk space
    available_space=$(df -h . | awk 'NR==2 {print $4}')
    echo "  Available space: $available_space"
    
    # Check if we have at least 10GB free
    available_gb=$(df . | awk 'NR==2 {print $4}')
    if [ "$available_gb" -gt 10485760 ]; then  # 10GB in KB
        print_status "Sufficient disk space available"
    else
        print_warning "Low disk space. Consider freeing up space."
    fi
}

# Function to check memory usage
check_memory() {
    print_section "Memory Usage"
    
    if docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"; then
        # Get container memory usage
        memory_usage=$(docker stats vapecraft-server --no-stream --format "table {{.MemUsage}}" | tail -n 1)
        echo "  Container memory usage: $memory_usage"
        
        # Check if memory usage is reasonable
        if echo "$memory_usage" | grep -q "GiB"; then
            print_status "Memory usage looks normal"
        else
            print_warning "Memory usage might be high"
        fi
    else
        print_warning "Server is not running, cannot check memory usage"
    fi
}

# Function to provide recommendations
provide_recommendations() {
    print_section "Recommendations"
    
    echo "Based on the diagnostic results, here are some recommendations:"
    echo ""
    
    # Check if plugins need updating
    if [ ! -f "plugins/Vault.jar" ]; then
        echo "1. Download plugins: ./plugins/download.sh"
    fi
    
    # Check if server is not running
    if ! docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"; then
        echo "2. Start the server: ./server-manager.sh start"
    fi
    
    # Check if mods are missing
    if [ ! -d "mods" ] || [ -z "$(ls -A mods 2>/dev/null)" ]; then
        echo "3. Add mods to the mods/ directory (e.g., Pixelmon Reforged)"
    fi
    
    echo ""
    echo "For more detailed troubleshooting:"
    echo "  - View logs: ./server-manager.sh logs"
    echo "  - Access console: ./server-manager.sh console"
    echo "  - Check status: ./server-manager.sh status"
}

# Main diagnostic function
run_diagnostics() {
    print_header "Vapecraft Professional Diagnostics"
    echo "Running comprehensive system check..."
    echo ""
    
    # Run all checks
    check_docker
    echo ""
    check_file_structure
    echo ""
    check_plugins
    echo ""
    check_mods
    echo ""
    check_server_status
    echo ""
    check_logs
    echo ""
    check_disk_space
    echo ""
    check_memory
    echo ""
    provide_recommendations
}

# Function to show help
show_help() {
    echo "Vapecraft Professional Troubleshooting Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help message"
    echo "  --quick        Run quick diagnostics (skip log analysis)"
    echo ""
    echo "This script will check:"
    echo "  - Docker installation and availability"
    echo "  - File structure and required files"
    echo "  - Plugin installation status"
    echo "  - Mod installation status"
    echo "  - Server container status"
    echo "  - Recent log analysis"
    echo "  - Disk space and memory usage"
    echo "  - Provide recommendations for issues found"
}

# Main script logic
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --quick)
        print_header "Quick Diagnostics"
        check_docker
        check_file_structure
        check_plugins
        check_mods
        check_server_status
        check_disk_space
        ;;
    "")
        run_diagnostics
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac 