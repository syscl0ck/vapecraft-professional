#!/usr/bin/env bash

# Vapecraft Professional Server Manager
# Provides utilities for managing the Minecraft server

set -e

SERVER_NAME="vapecraft-server"
COMPOSE_FILE="docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
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

# Function to check if server is running
is_server_running() {
    docker ps --format "table {{.Names}}" | grep -q "$SERVER_NAME"
}

# Function to check server status
status() {
    print_header "Server Status"
    if is_server_running; then
        print_status "Server is running"
        echo "Container: $SERVER_NAME"
        echo "Port: 25565"
        echo "Memory: 6GB"
        echo ""
        echo "Recent logs:"
        docker compose logs --tail=10
    else
        print_warning "Server is not running"
    fi
}

# Function to start the server
start() {
    print_header "Starting Server"
    if is_server_running; then
        print_warning "Server is already running"
        return
    fi
    
    print_status "Starting server with Docker Compose..."
    docker compose up -d
    print_status "Server started successfully"
    print_status "Use 'docker compose logs -f' to view logs"
}

# Function to stop the server
stop() {
    print_header "Stopping Server"
    if ! is_server_running; then
        print_warning "Server is not running"
        return
    fi
    
    print_status "Stopping server..."
    docker compose down
    print_status "Server stopped successfully"
}

# Function to restart the server
restart() {
    print_header "Restarting Server"
    print_status "Restarting server..."
    docker compose restart
    print_status "Server restarted successfully"
}

# Function to view logs
logs() {
    print_header "Server Logs"
    if ! is_server_running; then
        print_error "Server is not running"
        return
    fi
    
    if [ "$1" = "-f" ] || [ "$1" = "--follow" ]; then
        print_status "Following logs (Ctrl+C to exit)..."
        docker compose logs -f
    else
        docker compose logs --tail=50
    fi
}

# Function to access server console
console() {
    print_header "Server Console"
    if ! is_server_running; then
        print_error "Server is not running"
        return
    fi
    
    print_status "Accessing server console (type 'exit' to return)..."
    docker compose exec minecraft rcon-cli
}

# Function to backup server data
backup() {
    print_header "Backing Up Server Data"
    if is_server_running; then
        print_warning "Server is running. Consider stopping it first for a clean backup."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    BACKUP_DIR="backups"
    BACKUP_NAME="vapecraft-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p "$BACKUP_DIR"
    print_status "Creating backup: $BACKUP_NAME"
    
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" data/ plugins/ mods/ docker-compose.yml
    print_status "Backup created: $BACKUP_DIR/$BACKUP_NAME"
}

# Function to restore server data
restore() {
    print_header "Restoring Server Data"
    if [ -z "$1" ]; then
        print_error "Please specify a backup file to restore"
        echo "Usage: $0 restore <backup-file>"
        return
    fi
    
    if is_server_running; then
        print_warning "Server is running. Stopping it first..."
        docker compose down
    fi
    
    print_status "Restoring from: $1"
    tar -xzf "$1"
    print_status "Restore completed"
    print_status "You can now start the server with: $0 start"
}

# Function to update plugins
update_plugins() {
    print_header "Updating Plugins"
    if is_server_running; then
        print_warning "Server is running. Stopping it first..."
        docker compose down
    fi
    
    print_status "Clearing old plugins..."
    cd plugins
    ./clear_plugins.sh
    print_status "Downloading updated plugins..."
    ./download.sh
    cd ..
    print_status "Plugins updated successfully"
}

# Function to show help
show_help() {
    print_header "Vapecraft Professional Server Manager"
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  status              - Show server status"
    echo "  start               - Start the server"
    echo "  stop                - Stop the server"
    echo "  restart             - Restart the server"
    echo "  logs [-f|--follow]  - View server logs (use -f to follow)"
    echo "  console             - Access server console"
    echo "  backup              - Create a backup of server data"
    echo "  restore <file>      - Restore server data from backup"
    echo "  update-plugins      - Update all plugins"
    echo "  help                - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 logs -f"
    echo "  $0 backup"
    echo "  $0 restore backups/vapecraft-backup-20241201-120000.tar.gz"
}

# Main script logic
case "${1:-help}" in
    status)
        status
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    logs)
        logs "$2"
        ;;
    console)
        console
        ;;
    backup)
        backup
        ;;
    restore)
        restore "$2"
        ;;
    update-plugins)
        update_plugins
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 