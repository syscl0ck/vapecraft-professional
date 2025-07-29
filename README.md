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

## Running with Docker

1. Install Docker and clone this repository.
2. Place Forge mods (e.g. Pixelmon Reforged) into `mods/` and Bukkit/Spigot plugins into `plugins/`.
3. Start the server with Docker Compose:

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

## Suggested Plugins and Mods

| Purpose                  | Plugin/Mod                      |
|--------------------------|---------------------------------|
| World management         | Multiverse-Core, Multiverse-Portals |
| Pixelmon realm           | Pixelmon Reforged (mod)          |
| Skyblock realm           | BentoBox + addons               |
| Parkour courses          | Parkour                          |
| Creative plots           | PlotSquared                      |
| Economy                  | Vault, EssentialsX Economy       |
| NPC interactions         | Citizens, CommandNPC            |
| Quests/Tasks             | Quests or custom scripts         |
| Permissions              | LuckPerms                        |

Currency can be rewarded for catching Pokémon, completing Skyblock quests, finishing Parkour runs and fulfilling humorous Creative objectives. Because all economy plugins rely on Vault, balances are shared between worlds.

## World Setup

Create and load additional worlds using Multiverse-Core. Assign each world a specific game mode (survival, adventure or creative) and manage inventories separately with a plugin such as Multiverse-Inventories if desired. Portals or NPCs can teleport players to the appropriate realm.

## Development

The included `.gitignore` excludes the `data/` directory so your world saves and configuration files remain outside of version control. Mods and plugins can be tracked in this repository so other server operators can reproduce the setup easily.

---

Have fun building out your own realms!
