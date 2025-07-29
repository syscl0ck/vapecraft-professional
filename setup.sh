#!/usr/bin/env bash

# Basic setup script for Vapecraft Professional
# It ensures Docker is available and runs docker compose to start the server.
# Based on instructions from README.md

set -e

# Verify Docker installation
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but was not found. Please install Docker." >&2
  exit 1
fi

# Verify Docker Compose support
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose is required but was not found. Please install Docker Compose." >&2
  exit 1
fi

# Create required directories if they don't exist
mkdir -p mods plugins data

cat <<MSG
Copy any Forge mods into the 'mods' directory and Bukkit/Spigot plugins into the 'plugins' directory before starting the server.
MSG

# Start the server using Docker Compose
docker compose up -d
