#!/usr/bin/env bash

# Comprehensive setup script for Vapecraft Professional
# This script sets up the entire server environment including plugins and mods
# Based on instructions from README.md

set -e

echo "=== Vapecraft Professional Setup Script ==="
echo "Setting up Minecraft server with Mohist 1.16.5..."

# Verify Docker installation
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker is required but was not found. Please install Docker." >&2
  exit 1
fi

# Verify Docker Compose support
if ! docker compose version >/dev/null 2>&1; then
  echo "❌ Docker Compose is required but was not found. Please install Docker Compose." >&2
  exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Create required directories if they don't exist
echo "📁 Creating required directories..."
mkdir -p mods plugins data

# Check if plugins need to be downloaded
if [ ! -f "plugins/Vault.jar" ] || [ ! -f "plugins/Multiverse-Core.jar" ]; then
  echo "📥 Downloading plugins..."
  cd plugins
  chmod +x download.sh
  ./download.sh
  cd ..
  echo "✅ Plugins downloaded successfully"
else
  echo "✅ Plugins already exist, skipping download"
fi

# Check if mods directory is empty
if [ -z "$(ls -A mods 2>/dev/null)" ]; then
  echo ""
  echo "📋 MODS SETUP REQUIRED:"
  echo "Please add your Forge mods to the 'mods' directory:"
  echo "  - Pixelmon Reforged (for the Pixelmon realm)"
  echo "  - Any other mods you want to use"
  echo ""
  echo "You can download Pixelmon Reforged from:"
  echo "  https://reforged.gg/downloads"
  echo ""
fi

# Check if server is already running
if docker ps --format "table {{.Names}}" | grep -q "vapecraft-server"; then
  echo "⚠️  Server is already running. Stopping it first..."
  docker compose down
fi

echo "🚀 Starting the server..."
docker compose up -d

echo ""
echo "✅ Setup complete!"
echo ""
echo "📊 Server Status:"
echo "  - Container: vapecraft-server"
echo "  - Port: 25565"
echo "  - Memory: 6GB"
echo ""
echo "🔧 Next steps:"
echo "  1. Wait for the server to fully start (check logs with 'docker compose logs -f')"
echo "  2. Connect to the server and run the world creation commands from create_server_mv.txt"
echo "  3. Configure your realms and set up the economy system"
echo ""
echo "📝 Useful commands:"
echo "  - View logs: docker compose logs -f"
echo "  - Stop server: docker compose down"
echo "  - Restart server: docker compose restart"
echo "  - Access console: docker compose exec minecraft rcon-cli"
