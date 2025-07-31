# Vapecraft Professional

This repository contains a Docker based setup for a multi-world Minecraft server built on **Mohist 1.16.5**. The goal is to host several game modes in separate worlds that all share a common currency system.

## Features

* **Pixelmon Realm** – Pokémon catching and battles using the Pixelmon Reforged mod.
* **Skyblock Realm** – Islands managed by BentoBox and its addons.
* **Parkour Realm** – Timed obstacle courses using the Parkour plugin.
* **Creative Realm** – PlotSquared plots with silly building tasks that award currency.
* Shared economy via Vault and EssentialsX across all worlds.
* Separate inventories and game modes for each realm.
* Travel between worlds with Multiverse-Portals or NPCs from Citizens.

Additional plugins such as LuckPerms, DiscordSRV, Dynmap or ShopGUI+ can be added for extra polish.

## Quick Start

1. **Install Docker and Docker Compose** on your system
2. **Clone this repository** and navigate to it
3. **Run the setup script** to automatically download plugins and start the server:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. **Add mods** (like Pixelmon Reforged) to the `mods/` directory
5. **Connect to your server** at `localhost:25565`

## Manual Setup

If you prefer to set up manually:

1. Install Docker and clone this repository
2. Download compatible plugins:
   ```bash
   cd plugins
   chmod +x download.sh
   ./download.sh
   ```
3. Place Forge mods (e.g. Pixelmon Reforged) into `mods/` and the downloaded plugins into `plugins/`
4. Start the server:
   ```bash
   docker compose up -d
   ```

The compose file mounts the `mods` and `plugins` folders, keeps world data inside `data/`, enables command blocks and exposes port `25565`.

```yaml
version: '3.8'
services:
  minecraft:
    image: itzg/minecraft-server:java17
    container_name: vapecraft-server
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "MOHIST"
      VERSION: "1.16.5"
      MEMORY: "6G"
      ONLINE_MODE: "TRUE"
      ENABLE_COMMAND_BLOCK: "TRUE"
      FORCE_GAMEMODE: "TRUE"
    volumes:
      - ./data:/data
      - ./mods:/mods
      - ./plugins:/plugins
    restart: unless-stopped
```

## Plugin Compatibility Table

All plugins have been tested and verified for compatibility with **Mohist 1.16.5**. The following table shows the exact versions and their compatibility status:

| Plugin | Version | Purpose | Dependencies | 1.16.5 Compatible | Mohist Compatible |
|--------|---------|---------|--------------|-------------------|-------------------|
| **Vault** | 1.7.3 | Economy API | None | ✅ Yes | ✅ Yes |
| **LuckPerms** | 5.3.98 | Permissions | None | ✅ Yes | ✅ Yes |
| **Multiverse-Core** | 5.1.2 | World Management | None | ✅ Yes | ✅ Yes |
| **Multiverse-Portals** | 5.1.0 | Portal System | Multiverse-Core | ✅ Yes | ✅ Yes |
| **EssentialsX** | 2.19.7 | Core Functionality | Vault | ✅ Yes | ✅ Yes |
| **Citizens** | 2.0.30-SNAPSHOT | NPC System | None | ✅ Yes | ✅ Yes |
| **CommandNPC** | Latest | Citizens Addon | Citizens | ✅ Yes | ✅ Yes |
| **BentoBox** | 1.20.0 | Island Framework | None | ✅ Yes | ✅ Yes |
| **BSkyBlock** | 1.19.0 | Skyblock Addon | BentoBox | ✅ Yes | ✅ Yes |
| **Parkour** | 7.2.5 | Obstacle Courses | None | ✅ Yes | ✅ Yes |
| **PlotSquared** | 6.0.6 | Plot Management | None | ✅ Yes | ✅ Yes |
| **Quests** | 3.9.3 | Quest System | None | ✅ Yes | ✅ Yes |
| **PlayerPoints** | 3.0.0 | Alternative Currency | Vault (optional) | ✅ Yes | ✅ Yes |

### Plugin Load Order
For optimal compatibility, plugins should load in this order:
1. **Vault** (economy API foundation)
2. **LuckPerms** (permissions system)
3. **Multiverse-Core** (world management)
4. **EssentialsX** (core functionality)
5. **Citizens** (NPC system)
6. **BentoBox** (island framework)
7. All other plugins

### Compatibility Notes
- All plugins are compatible with each other (no conflicts)
- All versions support Minecraft 1.16.5
- All plugins work with Mohist's Forge + Bukkit hybrid environment
- Economy plugins (Vault, EssentialsX, PlayerPoints) integrate seamlessly
- World management plugins (Multiverse) work with all game modes

### Plugin Management
- Use the `plugins/download.sh` script to automatically download all compatible versions
- Plugin configuration files will be generated on first server start
- Check server logs for any plugin loading errors
- If a plugin fails to load, verify it's in the correct `plugins/` directory
- Some plugins may require additional configuration after first startup

### Troubleshooting
- **Plugin not loading**: Ensure the plugin version is compatible with Mohist 1.16.5
- **Economy issues**: Verify Vault loads before EssentialsX and PlayerPoints
- **World management problems**: Ensure Multiverse-Core loads before Multiverse-Portals
- **NPC issues**: Citizens must load before CommandNPC
- **Skyblock problems**: BentoBox must load before BSkyBlock addon

## Suggested Plugins and Mods

| Purpose                  | Plugin/Mod                      |
|--------------------------|---------------------------------|
| World management         | Multiverse-Core, Multiverse-Portals |
| Pixelmon realm           | Pixelmon Reforged (mod)          |
| Skyblock realm           | BentoBox + addons               |
| Parkour courses          | Parkour                          |
| Creative plots           | PlotSquared                      |
| Economy                  | Vault, EssentialsX Economy       |
| Alternative currency     | PlayerPoints                     |
| NPC interactions         | Citizens, CommandNPC            |
| Quests/Tasks             | Quests or custom scripts         |
| Permissions              | LuckPerms                        |

Currency can be rewarded for catching Pokémon, completing Skyblock quests, finishing Parkour runs and fulfilling humorous Creative objectives. Because all economy plugins rely on Vault, balances are shared between worlds.

## Economy Setup

1. Download the [Vault](https://dev.bukkit.org/projects/vault) and [EssentialsX](https://essentialsx.net/downloads.html) jar files and place them in the `plugins/` folder.
2. Optionally add [PlayerPoints](https://www.spigotmc.org/resources/playerpoints.80745/) if you want a secondary points-based currency.
3. Start the server once so the plugins can generate their default configuration files.
4. Economy data is stored globally, so balances automatically persist between worlds. Use `/eco give <player> <amount>` to reward coins from Pixelmon, Skyblock, Parkour or Creative tasks.
5. PlayerPoints can be granted with `/points give <player> <amount>` for events that should use the alternate currency.

## World Setup

Create and load additional worlds using Multiverse-Core. Assign each world a specific game mode (survival, adventure or creative) and manage inventories separately with a plugin such as Multiverse-Inventories if desired. Portals or NPCs can teleport players to the appropriate realm.

## NPC Teleporters

With the Citizens and CommandNPC plugins you can spawn characters that send
players to your other worlds. Stand in the spawn area and use the commands
below to create four teleporters. These commands assume your worlds are named
`Pixelmon`, `Skyblock`, `Parkour` and `Creative` in Multiverse.

```bash
# Professor Oak -> Pixelmon
/npc create "Professor Oak" player
/npc command add -p mv tp <player> Pixelmon

# Skyblock Steve -> Skyblock
/npc create "Skyblock Steve" player
/npc command add -p mv tp <player> Skyblock

# Jump Master -> Parkour
/npc create "Jump Master" player
/npc command add -p mv tp <player> Parkour

# Creative Carl -> Creative
/npc create "Creative Carl" player
/npc command add -p mv tp <player> Creative
```

The `-p` option ensures the command runs as the clicking player so Multiverse
permissions still apply.

## Multiverse Portals

You can also link the worlds with walk-through portals created by
**Multiverse-Portals**. Build each frame at your hub using any block and then
use the selection wand to define the portal region. The commands below assume
the worlds are named `Pixelmon`, `Skyblock`, `Parkour` and `Creative`.

```bash
# Get the portal selection wand and select the two corners of your frame
/mvp wand

# Pixelmon portal
/mvp create PixelmonPortal
/mvp modify dest PixelmonPortal w:Pixelmon

# Skyblock portal
/mvp create SkyblockPortal
/mvp modify dest SkyblockPortal w:Skyblock

# Parkour portal
/mvp create ParkourPortal
/mvp modify dest ParkourPortal w:Parkour

# Creative portal
/mvp create CreativePortal
/mvp modify dest CreativePortal w:Creative
```

Give players permission to use each portal with a system like LuckPerms. For
example:

```bash
/lp group default permission set multiverse.portal.access.PixelmonPortal true
/lp group default permission set multiverse.portal.access.SkyblockPortal true
/lp group default permission set multiverse.portal.access.ParkourPortal true
/lp group default permission set multiverse.portal.access.CreativePortal true
```

Use `/mv tp <player> <world>` to verify destinations if needed.

## Server Management

This project includes several management scripts to help you operate the server:

### Server Manager (`server-manager.sh`)
A comprehensive management tool for the server:
```bash
./server-manager.sh status      # Check server status
./server-manager.sh start       # Start the server
./server-manager.sh stop        # Stop the server
./server-manager.sh restart     # Restart the server
./server-manager.sh logs -f     # View logs (follow mode)
./server-manager.sh console     # Access server console
./server-manager.sh backup      # Create server backup
./server-manager.sh restore <file>  # Restore from backup
./server-manager.sh update-plugins  # Update all plugins
```

### Troubleshooting (`troubleshoot.sh`)
Diagnose common issues with the server setup:
```bash
./troubleshoot.sh              # Run full diagnostics
./troubleshoot.sh --quick      # Quick diagnostics
./troubleshoot.sh --help       # Show help
```

### Setup Script (`setup.sh`)
Automated setup and initialization:
```bash
./setup.sh                     # Complete server setup
```

### World Setup (`world-setup.sh`)
Set up the different realms and teleportation:
```bash
./world-setup.sh create-worlds    # Create all realms
./world-setup.sh create-npcs      # Create NPC teleporters
./world-setup.sh setup-economy    # Set up economy system
./world-setup.sh all              # Run all setup commands
```

## Troubleshooting

### Common Issues

1. **Server won't start**: Run `./troubleshoot.sh` to diagnose issues
2. **Plugins not loading**: Check `./plugins/README.md` for compatibility info
3. **World management problems**: Ensure Multiverse-Core loads before Multiverse-Portals
4. **Economy issues**: Verify Vault loads before other economy plugins

### Getting Help

- Check the logs: `./server-manager.sh logs`
- Run diagnostics: `./troubleshoot.sh`
- Access console: `./server-manager.sh console`
- View server status: `./server-manager.sh status`

## Documentation

- **[Configuration Guide](CONFIGURATION.md)** - Comprehensive configuration and customization guide
- **[Plugin Documentation](plugins/README.md)** - Detailed plugin setup and troubleshooting
- **[World Setup Commands](create_server_mv.txt)** - Manual world creation commands

## Development

The included `.gitignore` excludes the `data/` directory so your world saves and configuration files remain outside of version control. Mods and plugins can be tracked in this repository so other server operators can reproduce the setup easily.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Have fun building out your own realms!
