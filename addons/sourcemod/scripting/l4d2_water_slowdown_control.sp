#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>

// Force %0 to be between %1 and %2.
#define CLAMP(%0,%1,%2) (((%0) > (%2)) ? (%2) : (((%0) < (%1)) ? (%1) : (%0)))
// Linear scale %0 between %1 and %2.
#define SCALE(%0,%1,%2) CLAMP((%0-%1)/(%2-%1), 0.0, 1.0)
// Quadratic scale %0 between %1 and %2
#define SCALE2(%0,%1,%2) SCALE(%0*%0, %1*%1, %2*%2)

#define SURVIVOR_RUNSPEED		220.0
#define SURVIVOR_WATERSPEED_VS	170.0

ConVar hCvarSdInwaterTank;
ConVar hCvarSdInwaterSurvivor;
ConVar hCvarSdInwaterDuringTank;
ConVar hCvarSurvivorLimpspeed;

ConVar hCvarTankSpeedVS;

float fTankWaterSpeed;
float fSurvWaterSpeed;
float fSurvWaterSpeedDuringTank;
float fTankRunSpeed;

bool tankInPlay = false;

float fModifier[MAXPLAYERS+1] = -1.0;

public Plugin myinfo =
{
	name = "L4D2 Water Slowdown Control",
	author = "Visor, Sir, darkid, Forgetest",
	version = "2.6.2",
	description = "Manages the water slowdown for both teams",
	url = "https://github.com/ConfoglTeam/ProMod"
};

public void OnPluginStart()
{
	hCvarSdInwaterTank = CreateConVar("l4d2_slowdown_water_tank", "-1", "Maximum tank speed in the water (-1: ignore setting; 0: default; 210: default Tank Speed)", FCVAR_NONE, true, -1.0);
	hCvarSdInwaterSurvivor = CreateConVar("l4d2_slowdown_water_survivors", "-1", "Maximum survivor speed in the water outside of Tank fights (-1: ignore setting; 0: default; 220: default Survivor speed)", FCVAR_NONE, true, -1.0);
	hCvarSdInwaterDuringTank = CreateConVar("l4d2_slowdown_water_survivors_during_tank", "0", "Maximum survivor speed in the water during Tank fights (0: ignore setting; 220: default Survivor speed)", FCVAR_NONE, true, 0.0);

	hCvarSurvivorLimpspeed = FindConVar("survivor_limp_health");
	hCvarTankSpeedVS = FindConVar("z_tank_speed_vs");
	
	fTankWaterSpeed = GetConVarFloat(hCvarSdInwaterTank);
	fSurvWaterSpeed = GetConVarFloat(hCvarSdInwaterSurvivor);
	fSurvWaterSpeedDuringTank = GetConVarFloat(hCvarSdInwaterDuringTank);
	fTankRunSpeed = GetConVarFloat(hCvarTankSpeedVS);
	
	hCvarSdInwaterTank.AddChangeHook(OnConVarChanged);
	hCvarSdInwaterSurvivor.AddChangeHook(OnConVarChanged);
	hCvarSdInwaterDuringTank.AddChangeHook(OnConVarChanged);
	hCvarTankSpeedVS.AddChangeHook(OnConVarChanged);

	HookEvent("tank_spawn", TankSpawn, EventHookMode_PostNoCopy);
	HookEvent("round_start", RoundStart, EventHookMode_PostNoCopy);
	//HookEvent("player_hurt", PlayerHurt);
	HookEvent("player_death", TankDeath);
}

public void OnClientPutInServer(int client)
{
	fModifier[client] = -1.0;
}

public void OnClientDisconnect(int client)
{
	fModifier[client] = -1.0;
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	fTankWaterSpeed = GetConVarFloat(hCvarSdInwaterTank);
	fSurvWaterSpeed = GetConVarFloat(hCvarSdInwaterSurvivor);
	fSurvWaterSpeedDuringTank = GetConVarFloat(hCvarSdInwaterDuringTank);
	fTankRunSpeed = GetConVarFloat(hCvarTankSpeedVS);
}

public Action TankSpawn(Event event, const char[] name, bool dontBroadcast) 
{
	if (!tankInPlay) 
	{
		tankInPlay = true;
		if (fSurvWaterSpeedDuringTank > 0.0) 
		{
			PrintToChatAll("\x05Water Slowdown\x01 has been reduced while Tank is in play.");
		}
	}
}

public Action TankDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsInfected(client) && IsTank(client)) 
	{
		CreateTimer(0.1, Timer_CheckTank);
	}
}

public Action Timer_CheckTank(Handle timer)
{
	int tankclient = FindTankClient();
	if (!tankclient || !IsPlayerAlive(tankclient))
	{
		tankInPlay = false;
		if (fSurvWaterSpeedDuringTank > 0.0)
		{
			PrintToChatAll("\x05Water Slowdown\x01 has been restored to normal.");
		}
	}
}

public Action RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	tankInPlay = false;
}

/**
 *
 * Slowdown application: Infected & Survivors
 *
**/

public Action L4D_OnGetRunTopSpeed(int client, float &retVal)
{
	if (!IsClientInGame(client)) return Plugin_Continue;
	
	bool bInWater = (GetEntityFlags(client) & FL_INWATER) ? true : false;
	bool bAdrenaline = GetEntProp(client, Prop_Send, "m_bAdrenalineActive") ? true : false;
	
	if (IsSurvivor(client))
	{
		// Adrenaline = Don't care, don't mess with it.
		// Limping = 260 speed (both in water and on the ground)
		// Healthy = 260 speed (both in water and on the ground)
		if (bAdrenaline) 
		  return Plugin_Continue;

		// Only bother if survivor is in water and healthy
		if (bInWater && !IsLimping(client))
		{
			// speed of survivors in water during Tank fights
			if (tankInPlay)
			{
				if (fSurvWaterSpeedDuringTank == 0.0) return Plugin_Continue; // Vanilla YEEEEEEEEEEEEEEEs
				else 
				{
					retVal = fSurvWaterSpeedDuringTank;
					return Plugin_Handled;
				}
			}
			
			// speed of survivors in water outside of Tank fights
			else if (fSurvWaterSpeed != -1.0)
			{
				// slowdown off
				if (fSurvWaterSpeed == 0.0)
				{
					retVal = SURVIVOR_RUNSPEED;
					return Plugin_Handled;
				}
					
				// specific speed
				else
				{
					retVal = fSurvWaterSpeed;
					return Plugin_Handled;
				}
			}
		}
	}
	
	else if (IsInfected(client)) 
	{
		// boolean to store whether the speed is changed (probably no need, but for safety)
		bool bOverride = false;
		
		// Only bother the actual speed if player is a tank moving in water
		if (bInWater && IsTank(client) && fTankWaterSpeed != -1.0)
		{
			// slowdown off
			if (fTankWaterSpeed == 0.0)
			{
				retVal = fTankRunSpeed;
				bOverride = true;
			}
			
			// specific speed
			else
			{
				retVal = fTankWaterSpeed;
				bOverride = true;
			}
		}
		
		// The player (SI or Tank) is getting slowdown due to gunfire
		if (fModifier[client] != -1.0)
		{
			retVal *= fModifier[client];
			fModifier[client] = -1.0;
			bOverride = true;
		}
		
		// The final value is either changed or unchanged one
		if (bOverride) return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

stock int FindTankClient()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsInfected(i) || !IsTank(i) || !IsPlayerAlive(i))
			continue;

		return i; // Found tank, return
	}
	return 0;
}

bool IsSurvivor(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2;
}

bool IsInfected(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 3;
}

bool IsTank(int client)
{
	return GetEntProp(client, Prop_Send, "m_zombieClass") == 8;
}

bool IsLimping(int client)
{
	// Assume Clientchecks and the like have been done already
	int PermHealth = GetClientHealth(client);

	float buffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
	float bleedTime = GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime");
	float decay = GetConVarFloat(FindConVar("pain_pills_decay_rate"));

	float TempHealth = CLAMP(buffer - (bleedTime * decay), 0.0, 100.0); // buffer may be negative, also if pills bleed out then bleedTime may be too large.

	return RoundToFloor(PermHealth + TempHealth) < GetConVarInt(hCvarSurvivorLimpspeed);
}
