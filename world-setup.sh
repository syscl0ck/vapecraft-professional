#!/usr/bin/env bash

# Vapecraft Professional World Setup Script
# Helps set up the different realms/worlds for the server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"
}

# Function to execute command in server console
execute_command() {
    local command="$1"
    print_status "Executing: $command"
    echo "$command" | docker compose exec -T minecraft rcon-cli
}

# Function to create worlds
create_worlds() {
    print_header "Creating Vapecraft Realms"
    
    if ! is_server_running; then
        print_error "Server is not running. Please start the server first."
        echo "Use: ./server-manager.sh start"
        exit 1
    fi
    
    print_status "Creating worlds for Vapecraft Professional..."
    
    # Wait a moment for server to be ready
    sleep 5
    
    # Create Pixelmon world (flat terrain)
    print_status "Creating Pixelmon world..."
    execute_command "mv create Pixelmon NORMAL -t FLAT"
    
    # Create Skyblock world using BentoBox's generator
    print_status "Creating Skyblock world..."
    execute_command "mv create Skyblock NORMAL -g BSkyBlock"
    
    # Create Parkour world (normal terrain)
    print_status "Creating Parkour world..."
    execute_command "mv create Parkour NORMAL"
    
    # Create Creative world (flat terrain)
    print_status "Creating Creative world..."
    execute_command "mv create Creative NORMAL -t FLAT"
    
    print_status "Setting world game modes..."
    
    # Set game modes
    execute_command "mv modify set mode SURVIVAL Pixelmon"
    execute_command "mv modify set mode SURVIVAL Skyblock"
    execute_command "mv modify set mode ADVENTURE Parkour"
    execute_command "mv modify set mode CREATIVE Creative"
    
    # Set spawn world
    print_status "Setting spawn world..."
    execute_command "mv conf firstspawnworld Pixelmon"
    
    print_status "Worlds created successfully!"
}

# Function to create NPC teleporters
create_npcs() {
    print_header "Creating NPC Teleporters"
    
    if ! is_server_running; then
        print_error "Server is not running. Please start the server first."
        exit 1
    fi
    
    print_status "Creating NPC teleporters for each realm..."
    
    # Professor Oak -> Pixelmon
    print_status "Creating Professor Oak (Pixelmon teleporter)..."
    execute_command "npc create \"Professor Oak\" player"
    execute_command "npc command add -p mv tp <player> Pixelmon"
    
    # Skyblock Steve -> Skyblock
    print_status "Creating Skyblock Steve (Skyblock teleporter)..."
    execute_command "npc create \"Skyblock Steve\" player"
    execute_command "npc command add -p mv tp <player> Skyblock"
    
    # Jump Master -> Parkour
    print_status "Creating Jump Master (Parkour teleporter)..."
    execute_command "npc create \"Jump Master\" player"
    execute_command "npc command add -p mv tp <player> Parkour"
    
    # Creative Carl -> Creative
    print_status "Creating Creative Carl (Creative teleporter)..."
    execute_command "npc create \"Creative Carl\" player"
    execute_command "npc command add -p mv tp <player> Creative"
    
    print_status "NPC teleporters created successfully!"
    print_warning "Note: You'll need to position these NPCs manually in your spawn area"
}

# Function to set up portals
setup_portals() {
    print_header "Portal Setup Instructions"
    
    echo "To set up Multiverse portals, follow these steps:"
    echo ""
    echo "1. Get the portal selection wand:"
    echo "   /mvp wand"
    echo ""
    echo "2. Build portal frames in your hub area"
    echo ""
    echo "3. Select the corners of each portal frame with the wand"
    echo ""
    echo "4. Create the portals:"
    echo "   /mvp create PixelmonPortal"
    echo "   /mvp modify dest PixelmonPortal w:Pixelmon"
    echo ""
    echo "   /mvp create SkyblockPortal"
    echo "   /mvp modify dest SkyblockPortal w:Skyblock"
    echo ""
    echo "   /mvp create ParkourPortal"
    echo "   /mvp modify dest ParkourPortal w:Parkour"
    echo ""
    echo "   /mvp create CreativePortal"
    echo "   /mvp modify dest CreativePortal w:Creative"
    echo ""
    echo "5. Set permissions (if using LuckPerms):"
    echo "   /lp group default permission set multiverse.portal.access.PixelmonPortal true"
    echo "   /lp group default permission set multiverse.portal.access.SkyblockPortal true"
    echo "   /lp group default permission set multiverse.portal.access.ParkourPortal true"
    echo "   /lp group default permission set multiverse.portal.access.CreativePortal true"
}

# Function to set up economy
setup_economy() {
    print_header "Economy Setup"
    
    if ! is_server_running; then
        print_error "Server is not running. Please start the server first."
        exit 1
    fi
    
    print_status "Setting up economy system..."
    
    # Give some starting money to test
    execute_command "eco give <player> 1000"
    
    print_status "Economy setup complete!"
    echo ""
    echo "Economy commands:"
    echo "  /eco give <player> <amount>  - Give money to player"
    echo "  /eco take <player> <amount>  - Take money from player"
    echo "  /eco balance <player>        - Check player balance"
    echo "  /points give <player> <amount> - Give PlayerPoints"
}

# Function to show world list
list_worlds() {
    print_header "Current Worlds"
    
    if ! is_server_running; then
        print_error "Server is not running. Please start the server first."
        exit 1
    fi
    
    execute_command "mv list"
}

# Function to show help
show_help() {
    print_header "Vapecraft Professional World Setup"
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  create-worlds    - Create all realms (Pixelmon, Skyblock, Parkour, Creative)"
    echo "  create-npcs      - Create NPC teleporters for each realm"
    echo "  setup-portals    - Show portal setup instructions"
    echo "  setup-economy    - Set up economy system"
    echo "  list-worlds      - List all current worlds"
    echo "  all              - Run all setup commands"
    echo "  help             - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 create-worlds"
    echo "  $0 all"
}

# Main script logic
case "${1:-help}" in
    create-worlds)
        create_worlds
        ;;
    create-npcs)
        create_npcs
        ;;
    setup-portals)
        setup_portals
        ;;
    setup-economy)
        setup_economy
        ;;
    list-worlds)
        list_worlds
        ;;
    all)
        print_header "Running Complete World Setup"
        create_worlds
        echo ""
        create_npcs
        echo ""
        setup_economy
        echo ""
        setup_portals
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