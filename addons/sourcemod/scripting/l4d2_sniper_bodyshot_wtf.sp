#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <l4d2weapons>
#include <colors>

#define HITGROUP_HEAD		1
#define HITGROUP_CHEST		2
#define HITGROUP_STOMACH	3
#define HITGROUP_LEFTARM 	4	
#define HITGROUP_RIGHTARM 	5
#define HITGROUP_LEFTLEG 	6
#define HITGROUP_RIGHTLEG 	7

new bool:bLateLoad;

public APLRes:AskPluginLoad2( Handle:plugin, bool:late, String:error[], errMax )
{
	bLateLoad = late;
	return APLRes_Success;
}

public Plugin:myinfo =
{
	name = "L4D2 Sniper Hunter Bodyshot",
	author = "Visor,J.Q",
	description = "Remove sniper weapons' stomach hitgroup damage multiplier against hunters and infecters",
	version = "1.1.2",
	url = "https://github.com/Attano/L4D2-Competitive-Framework"
};

public OnPluginStart()
{
	if (bLateLoad)
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientConnected(i) && IsClientInGame(i))
			{
				OnClientPutInServer(i);
			}
		}
	}
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_TraceAttack, TraceAttack);
}

public Action:TraceAttack(victim, &attacker, &inflictor, &Float:damage, &damagetype, &ammotype, hitbox, hitgroup)
{
	//CPrintToChatAll("Victim %N attacker %N ", victim, attacker);

	if (!IsTank(victim) || !IsSurvivor(attacker) || IsFakeClient(attacker))
		return Plugin_Continue;

	new weapon = GetClientActiveWeapon(attacker);
	if (!IsValidSniper(weapon))
		return Plugin_Continue;
	
	 //decl String:szHitgroup[32];
	 //HitgroupToString(hitgroup, szHitgroup, sizeof(szHitgroup));
	 //PrintToChatAll("Victim %N attacker %N hitgroup %s", victim, attacker, szHitgroup);
	 
	if (hitgroup == HITGROUP_HEAD && !IsJockey(victim) && !IsCharger(victim) && !IsHunter(victim))
	{
		CPrintToChatAll("{olive}%N{default}：用AWP爆头击杀了特感", attacker);
	}
	
	if (hitgroup == HITGROUP_HEAD && IsHunter(victim))
	{
		CPrintToChatAll("{olive}%N{default}：{blue}%N{default}喜欢乱飞？还是喜欢飞天花板？AWP教你做hunter", attacker, victim);
		CPrintToChatAll("{olive}观众{default}：哇！是爆头击杀啊！{blue}%N{default}好帅", attacker);
	}
	 
	if (hitgroup == HITGROUP_HEAD && !IsJockey(victim) && !IsCharger(victim))
	{
		damage = GetWeaponDamage(weapon) / 2.50;
		return Plugin_Changed;
	}
	
	if (hitgroup == HITGROUP_HEAD && IsCharger(victim))
	{
		CPrintToChatAll("{olive}%N{default}：{blue}%N{default}你的600血很多吗？AWP一枪的事情", attacker, victim);
		CPrintToChatAll("{olive}观众{default}：天哪！爆头击杀牛？！{blue}%N{default}开挂了吧？", attacker);
		damage = GetWeaponDamage(weapon) / 1.00;
		return Plugin_Changed;
	}
	if (hitgroup == HITGROUP_HEAD && IsJockey(victim))
	{
		CPrintToChatAll("{olive}%N{default}：我活了，被{blue}%N{default}用AWP一枪秒了，有什么好说的", victim, attacker);
		CPrintToChatAll("{olive}%N{default}：跳来跳去，针不戳，一枪爆头，针不戳", attacker);
		damage = GetWeaponDamage(weapon) / 1.60;
		return Plugin_Changed;
	}
	if (hitgroup == HITGROUP_STOMACH && IsHunter(victim))
	{
		damage = GetWeaponDamage(weapon) / 2.00;
		return Plugin_Changed;
	}
	if (hitgroup == HITGROUP_CHEST && IsHunter(victim))
	{
		damage = GetWeaponDamage(weapon) / 4.00;
		return Plugin_Changed;
	}
	if (hitgroup == HITGROUP_LEFTARM || hitgroup == HITGROUP_RIGHTARM)
	{
		damage = GetWeaponDamage(weapon) / 5.00;
		return Plugin_Changed;
	}
	if (hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_RIGHTLEG)
	{
		damage = GetWeaponDamage(weapon) / 8.00;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

// HitgroupToString(hitgroup, String:destination[], maxlength)
// {
	// new String:buffer[32];
	// switch (hitgroup)
	// {
		// case 0:
		// {
			// buffer = "generic";
		// }
		// case 1:
		// {
			// buffer = "head";
		// }
		// case 2:
		// {
			// buffer = "chest";
		// }
		// case 3:
		// {
			// buffer = "stomach";
		// }
		// case 4:
		// {
			// buffer = "left arm";
		// }
		// case 5:
		// {
			// buffer = "right arm";
		// }
		// case 6:
		// {
			// buffer = "left leg";
		// }
		// case 7:
		// {
			// buffer = "right leg";
		// }
		// case 10:
		// {
			// buffer = "gear";
		// }
	// }
	// strcopy(destination, maxlength, buffer);
// }

GetClientActiveWeapon(client)
{
	return GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
}

GetWeaponDamage(weapon)
{
	decl String:classname[64];
	GetEdictClassname(weapon, classname, sizeof(classname));
	return L4D2_GetIntWeaponAttribute(classname, L4D2IntWeaponAttributes:L4D2IWA_Damage);
}

bool:IsValidSniper(weapon)
{
	decl String:classname[64];
	GetEdictClassname(weapon, classname, sizeof(classname));
	return (StrEqual(classname, "weapon_sniper_scout") || StrEqual(classname, "weapon_sniper_awp"));
}

bool:IsSurvivor(client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

bool:IsHunter(client)
{
	return (client > 0
		&& client <= MaxClients
		&& IsClientInGame(client)
		&& GetClientTeam(client) == 3
		&& GetEntProp(client, Prop_Send, "m_zombieClass") == 3
		&& GetEntProp(client, Prop_Send, "m_isGhost") != 1);
}

bool:IsJockey(client)
{
	return (client > 0
		&& client <= MaxClients
		&& IsClientInGame(client)
		&& GetClientTeam(client) == 3
		&& GetEntProp(client, Prop_Send, "m_zombieClass") == 5
		&& GetEntProp(client, Prop_Send, "m_isGhost") != 1);
}

bool:IsCharger(client)
{
	return (client > 0
		&& client <= MaxClients
		&& IsClientInGame(client)
		&& GetClientTeam(client) == 3
		&& GetEntProp(client, Prop_Send, "m_zombieClass") == 6
		&& GetEntProp(client, Prop_Send, "m_isGhost") != 1);
}

bool:IsTank(client)
{
	return (client > 0
		&& client <= MaxClients
		&& IsClientInGame(client)
		&& GetClientTeam(client) == 3
		&& GetEntProp(client, Prop_Send, "m_zombieClass") != 8
		&& GetEntProp(client, Prop_Send, "m_isGhost") != 1);
}