-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

--Variable initialization for Descope Suppression mechanic applied to weapons that are scoped in
global g_suppressionVariables =
{
	descopeSuppressionEnabled = false;
	playerHasBeenSuppressed = {},
	playerSuppressedCountdown = {},
	playerSuppressedDelaySeconds = 5,
	playerSuppressionMagnitude = {},
	playerSuppressionScreenEffectOffAlphaValue = 0;
	playerSuppressionScreenEffectSuppressionIncreaseTransitionTime = 0.01,
	playerSuppressionScreenEffectDisableTransitionTimeIfReleasingAltFunction = 0.05,
	playerSuppressionScreenEffectValues =
	{
		{threshold = 100, alphaValue = 0.9, idleTransitionTime = 1},
		{threshold = 90, alphaValue = 0.85, idleTransitionTime = 0.9},
		{threshold = 80, alphaValue = 0.8, idleTransitionTime = 0.8},
		{threshold = 70, alphaValue = 0.75, idleTransitionTime = 0.7},
		{threshold = 60, alphaValue = 0.7, idleTransitionTime = 0.6},
		{threshold = 50, alphaValue = 0.6, idleTransitionTime = 0.5},
		{threshold = 40, alphaValue = 0.5, idleTransitionTime = 0.4},
		{threshold = 30, alphaValue = 0.4, idleTransitionTime = 0.3},
		{threshold = 20, alphaValue = 0.3, idleTransitionTime = 0.2},
		{threshold = 10, alphaValue = 0.2, idleTransitionTime = 0.1},
	},
};

global suppressionMagnitudesByDamageSource =
{
	--Kinetic Weapons
	[get_string_id_from_string("assault_rifle")] = 7;
	[get_string_id_from_string("battle_rifle")] = 14;
	[get_string_id_from_string("frag_grenade")] = 60;
	[get_string_id_from_string("gatling_mortar")] = 4;
	[get_string_id_from_string("hydra_launcher")] = 18;
	[get_string_id_from_string("magnum")] = 20;
	[get_string_id_from_string("proto_combat_shotgun")] = 4;
	[get_string_id_from_string("proto_doublebarrel_shotgun")] = 8;
	[get_string_id_from_string("proto_skewer")] = 70;
	[get_string_id_from_string("proto_spike_revolver")] = 30;
	[get_string_id_from_string("sidearm_pistol")] = 14;
	[get_string_id_from_string("smg")] = 5;
	[get_string_id_from_string("spiker")] = 7;
	[get_string_id_from_string("sniper_rifle")] = 60;
	[get_string_id_from_string("spnkr_rocket_launcher_olympus")] = 90;
	[get_string_id_from_string("vakara_78")] = 16;
	
	--Plasma Weapons
	[get_string_id_from_string("plasma_grenade")] = 60;
	[get_string_id_from_string("plasma_pistol")] = 10;
	[get_string_id_from_string("proto_energy_sword_plasmawave")] = 50;
	[get_string_id_from_string("proto_plasma_liquidator")] = 7;
	[get_string_id_from_string("proto_plasma_mixmaster")] = 20;
	[get_string_id_from_string("proto_plasma_plasmablaster")] = 30;
	[get_string_id_from_string("proto_slag_maker")] = 40;
	[get_string_id_from_string("proto_plasma_wetwork")] = 8;
	
	--Hardlight Weapons
	[get_string_id_from_string("proto_hardlight_grenade")] = 60;
	[get_string_id_from_string("proto_heatwave_02")] = 30;
	[get_string_id_from_string("proto_hotrod_gun")] = 10;
	
	--Shock Weapons
	[get_string_id_from_string("arc_charger")] = 1;
	[get_string_id_from_string("proto_lightning_grenade")] = 60;
	[get_string_id_from_string("proto_lightning_grenade_submunition")] = 10,
	[get_string_id_from_string("volt_action")] = 6;
}

function DescopeSuppression (enabled:boolean):void
	g_suppressionVariables.descopeSuppressionEnabled = enabled;
	for _,player in hpairs(PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(player); 
		if playerUnit ~= nil then
			if enabled == true then
				RegisterSuppressionSystemEventsForObject(playerUnit);
			else
				UnregisterSuppressionSystemForObject(playerUnit, player);
			end
		end
	end
end

function RegisterSuppressionSystemEventsForObject(inObject:object)
	RegisterEvent(g_eventTypes.objectDamagedEvent, ApplySuppressionDamageCallback, inObject);
	RegisterEvent(g_eventTypes.deathEvent, SuppressionSystemDeathCallback, inObject);
end

function GetSuppressionMagnitudeFromDamageSource(damageSource:string_id):number
	local suppressionMagnitude:number = suppressionMagnitudesByDamageSource[damageSource];
	return suppressionMagnitude or 0;
end

function ApplySuppressionDamageCallback (damageEvent):void
	local player:player = unit_get_player(damageEvent.defender);

	if player ~= nil then
		CreateThread (TookSuppressionDamage, player, damageEvent.attacker, GetSuppressionMagnitudeFromDamageSource(damageEvent.damageSource));
	end
end

function UnregisterSuppressionSystemForObject(object:object,aPlayer:player):void
	UnregisterEvent(g_eventTypes.deathEvent, SuppressionSystemDeathCallback, object);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, ApplySuppressionDamageCallback, object);
	if (aPlayer ~= nil) then
		if g_suppressionVariables.playerHasBeenSuppressed[aPlayer] == true then
			SuppressionStateCleanup(aPlayer);
		end
	end
end

function SuppressionSystemDeathCallback(deathEventStruct):void
	UnregisterSuppressionSystemForObject(deathEventStruct.deadObject,deathEventStruct.deadPlayer);
end

function TookSuppressionDamage(aPlayer:player, attacker:object, suppressionAmount:number):void
	local playerSuppressedCountdownTimer = g_suppressionVariables.playerSuppressedCountdown[aPlayer] or 0;

	if is_player_using_ads(aPlayer) == true then
		if g_suppressionVariables.playerHasBeenSuppressed[aPlayer] ~= true then
			g_suppressionVariables.playerHasBeenSuppressed[aPlayer] = true;
			CreateThread(StartSuppressionTimer, aPlayer);
		end

		g_suppressionVariables.playerSuppressionMagnitude[aPlayer] = g_suppressionVariables.playerSuppressionMagnitude[aPlayer] or 0;
		g_suppressionVariables.playerSuppressionMagnitude[aPlayer] = g_suppressionVariables.playerSuppressionMagnitude[aPlayer] + suppressionAmount;
		
		for _, suppressedValue in ipairs(g_suppressionVariables.playerSuppressionScreenEffectValues) do
			if g_suppressionVariables.playerSuppressionMagnitude[aPlayer] >= suppressedValue.threshold then
				object_set_function_variable(aPlayer, "playerdescopemagnitude", suppressedValue.alphaValue, g_suppressionVariables.playerSuppressionScreenEffectSuppressionIncreaseTransitionTime);
				break;
			end
		end
		g_suppressionVariables.playerSuppressedCountdown[aPlayer] = 0;
	end
end

--Retain suppression magnitude while this thread is alive for playerSuppressedDelaySeconds
function StartSuppressionTimer(aPlayer:player):void
	
	g_suppressionVariables.playerHasBeenSuppressed[aPlayer] = true;
	g_suppressionVariables.playerSuppressedCountdown[aPlayer] = g_suppressionVariables.playerSuppressedCountdown[aPlayer] or 0;
	repeat
		Sleep(1);
		g_suppressionVariables.playerSuppressedCountdown[aPlayer] = g_suppressionVariables.playerSuppressedCountdown[aPlayer] + 1;
	
	--Keeping the suppression effect on for 5 seconds or until the player exits out of ads.
	until g_suppressionVariables.playerSuppressedCountdown[aPlayer] >= seconds_to_frames(g_suppressionVariables.playerSuppressedDelaySeconds) or is_player_using_ads(aPlayer) == false;
	g_suppressionVariables.playerSuppressedCountdown[aPlayer] = 0;
	
	if g_suppressionVariables.playerHasBeenSuppressed[aPlayer] then
		
		for _, suppressedValue in ipairs(g_suppressionVariables.playerSuppressionScreenEffectValues) do
			--Reverse the suppression screen effect over a unique time per suppression magnitude threshold.
			if g_suppressionVariables.playerSuppressionMagnitude[aPlayer] >= suppressedValue.threshold then
				object_set_function_variable(aPlayer, "playerdescopemagnitude", g_suppressionVariables.playerSuppressedScreenEffectOffAlphaValue, suppressedValue.idleTransitionTime);
				break;
			end
		end
		

		--Reverse the suppression screen effect quickly if the player releases the ADS button.
		if is_player_using_ads(aPlayer) == false then
			object_set_function_variable(aPlayer, "playerdescopemagnitude", g_suppressionVariables.playerSuppressedScreenEffectOffAlphaValue, g_suppressionVariables.playerSuppressionScreenEffectDisableTransitionTimeIfReleasingAltFunction);
		end
		
		
		g_suppressionVariables.playerHasBeenSuppressed[aPlayer] = false;
		g_suppressionVariables.playerSuppressionMagnitude[aPlayer] = 0;
	end
	SuppressionStateCleanup(aPlayer);
end

function SuppressionStateCleanup(aPlayer:player):void
	g_suppressionVariables.playerSuppressionMagnitude[aPlayer] = 0;
	g_suppressionVariables.playerHasBeenSuppressed[aPlayer] = false;
	RunClientScript("KillSuppression_FX", aPlayer);
end

--## CLIENT
global g_clientSuppressionVariables =
{
	suppressionEffect = TAG('objects\weapons\fx\de_scope\de_scope.effect');
};

function remoteClient.PlaySuppressionStart_FX(aPlayer:player):void
	--Play 3rd Person Descope Suppression Biped VFX on affected target.  Also play first person Descope Suppression screen effect.  
	effect_new_on_object_marker( g_clientSuppressionVariables.suppressionEffect, aPlayer, "head" );
end

--Function for killing the Suppression state fx when the player's static goes away entirely.
function remoteClient.KillSuppression_FX(aPlayer:player):void
	effect_kill_object_marker( g_clientSuppressionVariables.suppressionEffect, aPlayer, "head" );  
end