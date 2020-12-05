#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>

Handle cvar_SdGunfireSi;
Handle cvar_SdGunfireTank;


public Plugin myinfo =
{
	name = "L4D2 Slowdown Control",
	author = "ProjectSky ,J.Q ",
	version = "2.6.2",
	description = "Manages the gunfire slowdown for zombie teams",
	url = "https://github.com/ConfoglTeam/ProMod"
};

public void OnPluginStart()
{
	cvar_SdGunfireSi = CreateConVar("l4d2_slowdown", "1", "Manages slowdown from gunfire for SI", FCVAR_NOTIFY);
	cvar_SdGunfireTank = CreateConVar("l4d2_slowdown_tank", "1", "Manages slowdown from gunfire for the Tank", FCVAR_NOTIFY);
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

public void OnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damageType)
{
	if(!IsClientInGame(victim) && GetClientTeam(victim) != 3) return;
	
	int zc = GetEntProp(victim, Prop_Send, "m_zombieClass");
	
	if(GetConVarBool(cvar_SdGunfireSi) && zc !=8)
	{
		SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
	}
	if(GetConVarBool(cvar_SdGunfireTank))
	{
		SetEntPropFloat(victim, Prop_Send, "m_flVelocityModifier", 1.0);
	}
}
