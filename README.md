# multi1v1-heavy-round

A simple plugin that adds a "heavy" round to the multi1v1 plugin by Splewis.

## Features
- Adjust given health and armor to players
- Choose if players get a M249 or Negev
- Choose if players get a knife in the round

## Installation:
1. Download the latest release.
2. Put in csgo folder.

## Configuration:
After launching your server with the plugin, the plugin will create a config file named multi1v1.heavy-rounds.cfg in your CSGO/CFG folder.
Change these settings to your liking.

## CVARS
- ``heavyRound_health`` sets the health given to players in a Heavy round, default 200
- ``heavyRound_armor``    sets the armor given to players in a Heavy round, default 200, this is the max! Pointless to set more...
- ``heavyRound_weapon``   sets the weapon given to the players. 0 = M249, 1 = Negev (default 0)
- ``heavyRound_knife``   sets if players will receive a knife, 0 = yes, 1 = no (default 0)

## To do
- Give players in the arena unlimited ammo

## Changelog

Version: --- Description:

0.1.0--------Created the plugin

0.1.1--------Added the heavy armour

0.1.2--------Changed given armor value to 200

0.1.3--------Changed given health to 200

0.1.4--------Added event on player death to remove the suit & reset player model

0.1.5--------Added convars to set player health and armor << Maybe add a convar for setting the weapon? Perhaps...

0.1.6--------[BUG FIX]: When players did not die during the round either one or both kept the Heavy Armor Suit model

0.1.7--------Added convar to change config give players M249 or Negev

0.1.8--------Added convar to select if players get a knife
