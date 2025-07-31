# Vapecraft Professional Configuration Guide

This guide covers all aspects of configuring your Vapecraft Professional server, from basic setup to advanced customization.

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Plugin Configuration](#plugin-configuration)
3. [World Management](#world-management)
4. [Economy Setup](#economy-setup)
5. [Permissions](#permissions)
6. [Advanced Configuration](#advanced-configuration)
7. [Troubleshooting](#troubleshooting)

## Initial Setup

### Prerequisites
- Docker and Docker Compose installed
- At least 6GB RAM available
- 10GB+ free disk space

### Quick Setup
```bash
# Clone the repository
git clone <repository-url>
cd vapecraft-professional

# Run automated setup
chmod +x setup.sh
./setup.sh
```

### Manual Setup
```bash
# Download plugins
cd plugins
chmod +x download.sh
./download.sh

# Add mods to mods/ directory
# Start server
docker compose up -d
```

## Plugin Configuration

### Essential Plugins

#### Vault (Economy API)
- **File**: `data/plugins/Vault/config.yml`
- **Purpose**: Provides economy API for other plugins
- **Configuration**: Usually requires no changes

#### LuckPerms (Permissions)
- **File**: `data/plugins/LuckPerms/config.yml`
- **Purpose**: Permission management system
- **Key Commands**:
  ```bash
  /lp group default permission set <permission> true
  /lp user <player> parent set <group>
  /lp editor
  ```

#### Multiverse-Core (World Management)
- **File**: `data/plugins/Multiverse-Core/config.yml`
- **Purpose**: Manages multiple worlds
- **Key Commands**:
  ```bash
  /mv create <world> NORMAL -t FLAT
  /mv modify set mode <gamemode> <world>
  /mv list
  ```

#### Multiverse-Portals (Portal System)
- **File**: `data/plugins/Multiverse-Portals/config.yml`
- **Purpose**: Creates portals between worlds
- **Key Commands**:
  ```bash
  /mvp wand
  /mvp create <portal>
  /mvp modify dest <portal> w:<world>
  ```

#### EssentialsX (Core Functionality)
- **File**: `data/plugins/Essentials/config.yml`
- **Purpose**: Core server functionality and economy
- **Key Commands**:
  ```bash
  /eco give <player> <amount>
  /eco balance <player>
  /home
  /spawn
  ```

### Game-Specific Plugins

#### BentoBox (Island Framework)
- **File**: `data/plugins/BentoBox/config.yml`
- **Purpose**: Island management for Skyblock
- **Configuration**: Set island settings, protection, etc.

#### BSkyBlock (Skyblock Addon)
- **File**: `data/plugins/BSkyBlock/config.yml`
- **Purpose**: Skyblock game mode
- **Configuration**: Island generation, challenges, etc.

#### Parkour (Obstacle Courses)
- **File**: `data/plugins/Parkour/config.yml`
- **Purpose**: Parkour/obstacle course system
- **Key Commands**:
  ```bash
  /pa create <course>
  /pa checkpoint <course> <number>
  /pa finish <course>
  ```

#### PlotSquared (Plot Management)
- **File**: `data/plugins/PlotSquared/config.yml`
- **Purpose**: Plot management for Creative realm
- **Key Commands**:
  ```bash
  /plot auto
  /plot claim
  /plot home
  ```

#### Citizens (NPC System)
- **File**: `data/plugins/Citizens/config.yml`
- **Purpose**: NPC creation and management
- **Key Commands**:
  ```bash
  /npc create <name> player
  /npc command add -p <command>
  /npc select <id>
  ```

## World Management

### Creating Worlds

Use the world setup script for automatic creation:
```bash
./world-setup.sh create-worlds
```

Or create manually:
```bash
# Pixelmon world (flat terrain)
/mv create Pixelmon NORMAL -t FLAT

# Skyblock world
/mv create Skyblock NORMAL -g BSkyBlock

# Parkour world (normal terrain)
/mv create Parkour NORMAL

# Creative world (flat terrain)
/mv create Creative NORMAL -t FLAT
```

### Setting Game Modes
```bash
/mv modify set mode SURVIVAL Pixelmon
/mv modify set mode SURVIVAL Skyblock
/mv modify set mode ADVENTURE Parkour
/mv modify set mode CREATIVE Creative
```

### World Configuration
- **Spawn World**: Set in `data/plugins/Multiverse-Core/config.yml`
- **World Protection**: Configure per world
- **Inventory Separation**: Use Multiverse-Inventories plugin

## Economy Setup

### Vault + EssentialsX Economy
```bash
# Give money to player
/eco give <player> <amount>

# Take money from player
/eco take <player> <amount>

# Check balance
/eco balance <player>

# Set balance
/eco set <player> <amount>
```

### PlayerPoints (Alternative Currency)
```bash
# Give points
/points give <player> <amount>

# Take points
/points take <player> <amount>

# Check points
/points balance <player>
```

### Economy Integration
- Vault provides the API
- EssentialsX handles basic economy
- PlayerPoints provides alternative currency
- All plugins integrate through Vault

## Permissions

### Basic Permission Groups
```bash
# Default group (all players)
/lp group default permission set essentials.home true
/lp group default permission set multiverse.portal.access.* true

# VIP group
/lp group vip permission set essentials.home.multiple true
/lp group vip permission set essentials.fly true

# Admin group
/lp group admin permission set * true
```

### World-Specific Permissions
```bash
# Pixelmon permissions
/lp group default permission set pixelmon.* true

# Skyblock permissions
/lp group default permission set bskyblock.* true

# Parkour permissions
/lp group default permission set parkour.* true

# Creative permissions
/lp group default permission set plots.* true
```

### Portal Permissions
```bash
/lp group default permission set multiverse.portal.access.PixelmonPortal true
/lp group default permission set multiverse.portal.access.SkyblockPortal true
/lp group default permission set multiverse.portal.access.ParkourPortal true
/lp group default permission set multiverse.portal.access.CreativePortal true
```

## Advanced Configuration

### Server Properties
Edit `data/server.properties`:
```properties
# Basic settings
server-port=25565
max-players=20
view-distance=10
simulation-distance=8

# Game settings
difficulty=normal
gamemode=survival
pvp=true
spawn-protection=16

# Performance
max-tick-time=60000
network-compression-threshold=256
```

### JVM Arguments
Modify `docker-compose.yml` to add JVM arguments:
```yaml
environment:
  JVM_OPTS: "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
```

### Backup Configuration
Set up automated backups:
```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="backups"
BACKUP_NAME="vapecraft-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" data/ plugins/ mods/ docker-compose.yml
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
EOF

chmod +x backup.sh

# Add to crontab for daily backups
echo "0 2 * * * /path/to/vapecraft-professional/backup.sh" | crontab -
```

## Troubleshooting

### Common Issues

#### Server Won't Start
1. Check Docker status: `docker ps`
2. Check logs: `docker compose logs`
3. Verify ports: `netstat -tulpn | grep 25565`
4. Check disk space: `df -h`

#### Plugins Not Loading
1. Check plugin compatibility with Mohist 1.16.5
2. Verify plugin files are in correct directory
3. Check server logs for specific errors
4. Ensure proper load order

#### Economy Issues
1. Verify Vault loads before other economy plugins
2. Check Vault integration in server logs
3. Ensure economy provider is set correctly
4. Test with `/eco balance <player>`

#### World Management Problems
1. Ensure Multiverse-Core loads before Multiverse-Portals
2. Check world configuration files
3. Verify world permissions
4. Test world teleportation

#### Performance Issues
1. Monitor memory usage: `docker stats vapecraft-server`
2. Check CPU usage
3. Optimize JVM arguments
4. Reduce view distance if needed

### Diagnostic Commands
```bash
# Run full diagnostics
./troubleshoot.sh

# Check server status
./server-manager.sh status

# View logs
./server-manager.sh logs -f

# Access console
./server-manager.sh console
```

### Getting Help
- Check the main README.md for basic setup
- Review plugin-specific documentation
- Check server logs for error messages
- Use the troubleshooting script for diagnostics

## Maintenance

### Regular Tasks
1. **Daily**: Check server status and logs
2. **Weekly**: Create backups
3. **Monthly**: Update plugins and mods
4. **Quarterly**: Review and optimize configuration

### Monitoring
- Server uptime
- Player count and activity
- Resource usage (CPU, RAM, disk)
- Plugin performance
- Error logs

### Updates
```bash
# Update plugins
./server-manager.sh update-plugins

# Update mods (manual process)
# 1. Stop server
# 2. Replace mod files
# 3. Start server

# Update server
# 1. Backup data
# 2. Update docker-compose.yml
# 3. Rebuild container
```

This configuration guide should help you set up and maintain your Vapecraft Professional server effectively. For additional help, refer to the individual plugin documentation and the main README.md file. 