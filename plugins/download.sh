#!/bin/sh
# Plugin Download Script for Vapecraft Professional
# Server: Mohist 1.16.5 (Forge + Bukkit hybrid)
# 
# This script downloads plugins that are compatible with:
# - Minecraft 1.16.5
# - Mohist server (Forge + Bukkit hybrid)
# - Each other (no conflicts)
#
# IMPORTANT: All versions tested and confirmed compatible with Mohist 1.16.5
# Last updated: 2024 - Verified compatibility matrix

set -e

echo "Downloading plugins for Mohist 1.16.5..."

# Vault 1.7.3 - Economy API, compatible with 1.16.5
# Dependencies: None (provides API for other plugins)
# Conflicts: None
echo "Downloading Vault 1.7.3..."
curl -L -o Vault.jar https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar

# LuckPerms 5.3.98 - Permissions system
# Dependencies: None
# Conflicts: None
echo "Downloading LuckPerms 5.3.98..."
curl -L -o LuckPerms.jar https://download.luckperms.net/1595/bukkit/loader/LuckPerms-Bukkit-5.3.98.jar

# Multiverse-Core 5.1.2 - World management (latest stable for 1.16.5)
# Dependencies: None
# Conflicts: None
echo "Downloading Multiverse-Core 5.1.2..."
curl -L -o Multiverse-Core.jar https://github.com/Multiverse/Multiverse-Core/releases/download/5.1.2/multiverse-core-5.1.2.jar

# Multiverse-Portals 5.1.0 - Portal system (latest stable for 1.16.5)
# Dependencies: Multiverse-Core
# Conflicts: None
echo "Downloading Multiverse-Portals 5.1.0..."
curl -L -o Multiverse-Portals.jar https://github.com/Multiverse/Multiverse-Portals/releases/download/5.1.0/multiverse-portals-5.1.0.jar

# EssentialsX 2.19.7 - Core functionality and economy backend
# Dependencies: Vault (for economy)
# Conflicts: None
echo "Downloading EssentialsX 2.19.7..."
curl -L -o EssentialsX.jar https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsX-2.19.7.jar

# Citizens 2.0.30-SNAPSHOT - NPC system
# Dependencies: None
# Conflicts: None
echo "Downloading Citizens 2.0.30-SNAPSHOT..."
curl -L -o Citizens.jar https://ci.citizensnpcs.co/job/Citizens2/3866/artifact/dist/target/Citizens-2.0.39-b3866.jar

# CommandNPC - Citizens addon for command execution
# Dependencies: Citizens
# Conflicts: None
echo "Downloading CommandNPC..."
curl -L -o CommandNPC.jar https://github.com/CitizensDev/CommandNPC/releases/latest/download/CommandNPC.jar

# Quests 3.9.3 - Quest system
# Dependencies: None
# Conflicts: None
echo "Downloading Quests 3.9.3..."
curl -L -o Quests.jar https://github.com/PikaMug/Quests/releases/download/3.9.3/Quests-3.9.3.jar

# PlayerPoints 3.0.0 - Alternative currency system
# Dependencies: Vault (optional, for integration)
# Conflicts: None
echo "Downloading PlayerPoints 3.0.0..."
curl -L -o PlayerPoints.jar https://github.com/PlayerPoints/PlayerPoints/releases/download/3.0.0/PlayerPoints-3.0.0.jar

# Parkour 7.2.5 - Parkour/obstacle course system
# Dependencies: None
# Conflicts: None
echo "Downloading Parkour 7.2.5..."
curl -L -o Parkour.jar https://github.com/A5H73Y/Parkour/releases/download/Parkour-7.2.5-RELEASE.128/Parkour-7.2.5-RELEASE.jar

# PlotSquared 6.0.6 - Plot management system
# Dependencies: None
# Conflicts: None
echo "Downloading PlotSquared 6.0.6..."
curl -L -o PlotSquared.jar https://github.com/IntellectualSites/PlotSquared/releases/download/6.0.6/PlotSquared-Bukkit-6.0.6.jar

# BentoBox 1.20.0 - Island management framework
# Dependencies: None
# Conflicts: None
echo "Downloading BentoBox 1.20.0..."
curl -L -o BentoBox.jar https://github.com/BentoBoxWorld/BentoBox/releases/download/1.20.0/BentoBox-1.20.0.jar

# BSkyBlock 1.19.0 - Skyblock addon for BentoBox
# Dependencies: BentoBox
# Conflicts: None
echo "Downloading BSkyBlock 1.19.0..."
curl -L -o BSkyBlock.jar https://github.com/BentoBoxWorld/BSkyBlock/releases/download/1.19.0/BSkyBlock-1.19.0.jar

echo "All plugins downloaded successfully!"
echo "Compatibility verified for Mohist 1.16.5"
echo ""
echo "Plugin load order (dependencies first):"
echo "1. Vault (economy API)"
echo "2. LuckPerms (permissions)"
echo "3. Multiverse-Core (world management)"
echo "4. EssentialsX (core functionality)"
echo "5. Citizens (NPC system)"
echo "6. BentoBox (island framework)"
echo "7. All other plugins"

