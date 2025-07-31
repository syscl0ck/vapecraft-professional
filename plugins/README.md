# Plugin Setup for Vapecraft Professional

This directory contains the plugin management scripts and downloaded plugins for the Vapecraft Professional server running on **Mohist 1.16.5**.

## Quick Setup

1. **Download all plugins automatically:**
   ```bash
   chmod +x download.sh
   ./download.sh
   ```

2. **Clear all plugins (if needed):**
   ```bash
   chmod +x clear_plugins.sh
   ./clear_plugins.sh
   ```

## Plugin Compatibility

All plugins in this setup have been tested and verified for compatibility with:
- **Minecraft 1.16.5**
- **Mohist server** (Forge + Bukkit hybrid)
- **Each other** (no conflicts)

## Installed Plugins

| Plugin | Version | Purpose | Status |
|--------|---------|---------|--------|
| **Vault** | 1.7.3 | Economy API | ✅ Core |
| **LuckPerms** | 5.3.98 | Permissions | ✅ Core |
| **Multiverse-Core** | 5.1.2 | World Management | ✅ Core |
| **Multiverse-Portals** | 5.1.0 | Portal System | ✅ Core |
| **EssentialsX** | 2.19.7 | Core Functionality | ✅ Core |
| **Citizens** | 2.0.30-SNAPSHOT | NPC System | ✅ Core |
| **CommandNPC** | Latest | Citizens Addon | ✅ Core |
| **BentoBox** | 1.20.0 | Island Framework | ✅ Core |
| **BSkyBlock** | 1.19.0 | Skyblock Addon | ✅ Core |
| **Parkour** | 7.2.5 | Obstacle Courses | ✅ Core |
| **PlotSquared** | 6.0.6 | Plot Management | ✅ Core |
| **Quests** | 3.9.3 | Quest System | ✅ Core |
| **PlayerPoints** | 3.0.0 | Alternative Currency | ✅ Core |

## Plugin Load Order

For optimal compatibility, plugins load in this order:
1. **Vault** (economy API foundation)
2. **LuckPerms** (permissions system)
3. **Multiverse-Core** (world management)
4. **EssentialsX** (core functionality)
5. **Citizens** (NPC system)
6. **BentoBox** (island framework)
7. All other plugins

## Manual Download Sources

If you need to download plugins manually, use these sources:

| Plugin | Download Source |
|--------|-----------------|
| Vault | https://github.com/MilkBowl/Vault/releases |
| LuckPerms | https://luckperms.net/download |
| Multiverse-Core | https://github.com/Multiverse/Multiverse-Core/releases |
| Multiverse-Portals | https://github.com/Multiverse/Multiverse-Portals/releases |
| EssentialsX | https://github.com/EssentialsX/Essentials/releases |
| Citizens | https://github.com/CitizensDev/Citizens2/releases |
| CommandNPC | https://github.com/CitizensDev/CommandNPC/releases |
| Quests | https://github.com/PikaMug/Quests/releases |
| PlayerPoints | https://github.com/PlayerPoints/PlayerPoints/releases |
| Parkour | https://github.com/A5H73Y/Parkour/releases |
| PlotSquared | https://github.com/IntellectualSites/PlotSquared/releases |
| BentoBox | https://github.com/BentoBoxWorld/BentoBox/releases |
| BSkyBlock | https://github.com/BentoBoxWorld/BSkyBlock/releases |

## Troubleshooting

### Plugin Not Loading
- Ensure the plugin version is compatible with Mohist 1.16.5
- Check server logs for specific error messages
- Verify the plugin is in the correct `plugins/` directory

### Economy Issues
- Verify Vault loads before EssentialsX and PlayerPoints
- Check that Vault is properly linked in server logs

### World Management Problems
- Ensure Multiverse-Core loads before Multiverse-Portals
- Check Multiverse configuration files

### NPC Issues
- Citizens must load before CommandNPC
- Verify Citizens permissions are set correctly

### Skyblock Problems
- BentoBox must load before BSkyBlock addon
- Check BentoBox configuration

## Configuration

Plugin configuration files will be generated on first server start in the `data/plugins/` directory. You can modify these files to customize plugin behavior.

## Updates

To update plugins:
1. Stop the server: `./server-manager.sh stop`
2. Clear old plugins: `./clear_plugins.sh`
3. Download new versions: `./download.sh`
4. Start the server: `./server-manager.sh start`

## Notes

- All plugins are compatible with each other (no conflicts)
- All versions support Minecraft 1.16.5
- All plugins work with Mohist's Forge + Bukkit hybrid environment
- Economy plugins (Vault, EssentialsX, PlayerPoints) integrate seamlessly
- World management plugins (Multiverse) work with all game modes
