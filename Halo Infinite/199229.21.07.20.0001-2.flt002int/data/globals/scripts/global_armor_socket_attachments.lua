-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

global g_reconBackstabVariables =
{
	damageBoostTime = 7,
}

function ArmorFrameDeathCallback(deathEvent)
	if (PlayerGetRepresentation(unit_get_player(deathEvent.killerObject)) == get_string_id_from_string("armor_frame_recon_assassin") and 
		deathEvent.damageModifier == DAMAGE_MODIFIER.SilentMelee) then

		AddObjectTimedMalleablePropertyModifierBool("damage_boost_full_body_effects_enabled",g_reconBackstabVariables.damageBoostTime,true,unit_get_player(deathEvent.killerObject));
		AddObjectTimedMalleablePropertyModifier("melee_damage_scalar",g_reconBackstabVariables.damageBoostTime,1.6,unit_get_player(deathEvent.killerObject));
		AddObjectTimedMalleablePropertyModifier("weapon_damage_scalar",g_reconBackstabVariables.damageBoostTime,1.45,unit_get_player(deathEvent.killerObject));
		AddObjectTimedMalleablePropertyModifier("grenade_damage_scalar",g_reconBackstabVariables.damageBoostTime,1.2,unit_get_player(deathEvent.killerObject));
	end
	UnregisterEvent(g_eventTypes.deathEvent, ArmorFrameDeathCallback, deathEvent.deadObject);
end

function GetLocationRotationMatrix(thisPlayer:player, x_offset:number, y_offset:number, z_offset:number):matrix
	local playerPositionMatrix:matrix = location(thisPlayer,"").matrix;
	local playerUnit:object = Player_GetUnit(thisPlayer);
	local aim:number = object_get_function_value(playerUnit,"look_yaw");
	local pitch:number = object_get_function_value(playerUnit,"look_pitch");
	
	playerPositionMatrix.angles = vector(0,playerPositionMatrix.angles.y+pitch,playerPositionMatrix.angles.z+aim);
	playerPositionMatrix.pos = playerPositionMatrix:transform(vector(x_offset,y_offset,z_offset));
	return playerPositionMatrix;
end