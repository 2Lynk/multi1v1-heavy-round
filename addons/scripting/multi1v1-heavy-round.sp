/*	CHANGELOG
Version:	Description:
0.1			Created the plugin
0.1.1		Added the heavy armour
0.1.2		Changed given armor value to 200
0.1.3		Changed given health to 200
0.1.4		Added event on player death to remove the suit & reset player model
0.1.5		Added convars to set player health and armor << Maybe add a convar for setting the weapon? Perhaps...
0.1.6		[BUG FIX]: When players did not die during the round either one or both kept the Heavy Armor Suit model
0.1.7		Added convar to change config give players M249 or Negev
0.1.8		Added convar to select if players get a knife
0.1.9		Put HookEvent in OnPluginStart and defined g_sModel with the player current model before giving heavy armor suit (Thanks Cruze! https://forums.alliedmods.net/member.php?u=279498 )

*/

#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "2Lynk"
#define PLUGIN_VERSION "0.1.9"

#include <sourcemod>
#include <events>
#include <sdktools>
#include <sdkhooks>
#include <multi1v1>

#pragma semicolon 1
#pragma newdecls required

char g_sModel[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];

ConVar cv_heavyRound_health;
ConVar cv_heavyRound_armor;
ConVar cv_heavyRound_weapon;
ConVar cv_heavyRound_knife;

public Plugin myinfo = 
{
	name = "CS:GO Multi1v1: heavy round addon",
	author = PLUGIN_AUTHOR,
	description = "Heavy round for splewis 1v1 plugin",
	version = PLUGIN_VERSION,
	url = "https://github.com/2Lynk/multi1v1-heavy-round"
};

public void OnPluginStart(){
	// Create an hook, when the round ends execute the hook to remove the heavy armor suit and reset the player model
	 HookEvent("round_end", Event_OnRoundEnd);
}

public void Multi1v1_OnRoundTypesAdded() 
{
	// Add the new 1v1 round and call it Heavy
	Multi1v1_AddRoundType("Heavy", "heavy", heavyHandler, true, false, "", true);
	
	// Create convars to set the health to the players in the Heavy round
	cv_heavyRound_health = CreateConVar("heavyRound_health", "200", "ConVar to set the health given to players in a Heavy round");
	// Create convars to set the armor to the players in the Heavy round
	cv_heavyRound_armor = CreateConVar("heavyRound_armor", "200", "ConVar to set the armor given to players in a Heavy round. 200 is the max! Pointless to set more...");
	// Create convars to set the weapon to the players in the Heavy round
	cv_heavyRound_weapon = CreateConVar("heavyRound_weapon", "0", "ConVar to set the weapon given to players in a Heavy round. 0 = M249, 1 = Negev");
	// Create convars to set if the players are given a knife in the Heavy round
	cv_heavyRound_knife = CreateConVar("heavyRound_knife", "0", "ConVar to set if the players are given a knife in a Heavy round. 0 = yes, 1 = no");

	// Then create and add the convars to the cfg file
	AutoExecConfig(true, "multi1v1.heavy-rounds");	

}

public void heavyHandler(int client) 
{	
	// Set player health
	SetEntityHealth(client, cv_heavyRound_health.IntValue);
	// Set player armor
	SetEntProp(client, Prop_Data, "m_ArmorValue", cv_heavyRound_armor.IntValue);
	// Give player a knife?
	if(cv_heavyRound_knife.IntValue == 0){
		GivePlayerItem(client, "weapon_knife");
	}
	// Give player the weapon
	if(cv_heavyRound_weapon.IntValue == 0){
		GivePlayerItem(client, "weapon_m249");
	}else{
		GivePlayerItem(client, "weapon_negev");
	}
	
	// Get the current player model and write it to the g_sModel array so we can restore it at the end of the round
	GetClientModel(client, g_sModel[client], sizeof(g_sModel));
	// Then set the player model to Heavy Assault Suit
	GivePlayerItem(client, "item_heavyassaultsuit");
	
}

public Action Event_OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	// Loop through all the clients
	for(int iClient = 1; iClient <= MaxClients; iClient++)
	{
		// Check if client is ingame and isnt a fake client
		if (IsClientInGame(iClient) && (!IsFakeClient(iClient)))
		{
			// Check if the client has the Heavy Armor model
			if (GetEntProp(iClient, Prop_Send, "m_bHasHeavyArmor"))
			{
				// If so, delete it and restore the model from the player
				SetEntProp(iClient, Prop_Send, "m_bHasHeavyArmor", false);
				SetEntityModel(iClient, g_sModel[iClient]);
			}
		}
	}
}