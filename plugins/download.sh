#!/bin/sh
# Simple helper to fetch plugin jars into this folder.
# Run at your own risk. Requires curl or wget and Internet access.

set -e

# Multiverse-Core (example version 4.3.2)
curl -L https://github.com/Multiverse/Multiverse-Core/releases/download/5.1.2/multiverse-core-5.1.2.jar

# Multiverse-Portals
curl -L https://github.com/Multiverse/Multiverse-Portals/releases/download/5.1.0/multiverse-portals-5.1.0.jar

# Vault
curl -o Vault-1.7.3.jar -L https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar

# EssentialsX (base jar)
curl -L https://github.com/EssentialsX/Essentials/releases/download/2.21.1/EssentialsX-2.21.1.jar

# LuckPerms
curl -L https://download.luckperms.net/1595/bukkit/loader/LuckPerms-Bukkit-5.5.10.jar

# Citizens
curl -L https://ci.citizensnpcs.co/job/Citizens2/3866/artifact/dist/target/Citizens-2.0.39-b3866.jar

# CommandNPC
# TODO: confirm if this plugin is still supported
#curl -o CommandNPC.jar -L https://github.com/CitizensDev/CommandNPC/releases/latest/download/CommandNPC.jar

# Quests
curl -o Quests-6782459.jar -L https://www.curseforge.com/minecraft/bukkit-plugins/quests/download/6782459

# PlayerPoints
curl -o PlayerPoints-586064.jar -L https://www.spigotmc.org/resources/playerpoints.80745/download?version=586064

# Parkour
curl -L https://github.com/A5H73Y/Parkour/releases/download/Parkour-7.2.5-RELEASE.128/Parkour-7.2.5-RELEASE.jar

# PlotSquared
# TODO: Find reputable download or compile from source
# curl -o PlotSquared.jar -L https://github.com/IntellectualSites/PlotSquared/releases/latest/download/PlotSquared-Bukkit.jar

# BentoBox
curl -L https://github.com/BentoBoxWorld/BentoBox/releases/download/3.7.1/BentoBox-3.7.1.jar

# BSkyBlock addon
curl -L https://github.com/BentoBoxWorld/BSkyBlock/releases/download/1.90.0/BSkyBlock-1.19.0.jar

