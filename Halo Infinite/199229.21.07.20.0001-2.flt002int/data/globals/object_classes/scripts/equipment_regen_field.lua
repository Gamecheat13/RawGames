-- object equipment_regen_field

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure equipment_regen_field
	meta:table
	instance:luserdata
end

global g_regenFieldVariables = table.makePermanent
{	
	regenRadius = 1.2;
	regenRate = 0.1;
	regenAmount = 2.25;
	armingTime = 0.3;
	healthMax = 90;
	shieldMax = 140;
}

function equipment_regen_field:init() : void
	CreateObjectThread(self, self.CustomInitThread, self);
end

function equipment_regen_field:CustomInitThread():void
	
	SleepUntilSeconds([|object_get_function_value(self, "projectile_attach") == 1], 0.05); -- gotta wait until the .equipment is at rest and active

	SleepSeconds(g_regenFieldVariables.armingTime);

	object_set_function_variable(self, "device_armed", 1, 0);

	CreateThread(self.RegenField, self);
end

function equipment_regen_field:RegenField()
	
	local playersInArea:table = {};

	-- Every X Seconds, reset the shield and body stun timers on ally players
	while(object_index_valid(self)) do
		local objs = Object_GetObjectsInSphere(location(self, "fx_offset"), g_regenFieldVariables.regenRadius, ObjectTypeMask.Biped);
		for _,target in hpairs(objs) do
			if(object_index_valid(target) and target:GetIsAffectedByOtherRegenField(self) == false) then			
				local curHealth:number = Object_GetHealth(target) * g_regenFieldVariables.healthMax;
				local curShield:number = object_get_shield(target) * g_regenFieldVariables.shieldMax;
				local healthNeeded:number = g_regenFieldVariables.healthMax - curHealth;
				local shieldNeeded:number = g_regenFieldVariables.shieldMax - curShield;
				local healRemaining:number = g_regenFieldVariables.regenAmount;
				
				if(healthNeeded > 0) then
					Object_SetHealth(target, (curHealth + healRemaining)/g_regenFieldVariables.healthMax);
					healRemaining = healRemaining - healthNeeded;
				end

				if(healRemaining > 0 and shieldNeeded > 0) then
					object_set_shield(target, (curShield + healRemaining)/g_regenFieldVariables.shieldMax);
				end

				-- if the player is new to the area, play the healing effect
				if(not playersInArea[target]) then
					playersInArea[target] = true;
					Object_SetFunctionValue(target, "heal_active", 1, 0);
					target:SetAffectedByRegenField(true, self);
				else
					playersInArea[target] = true;
				end
			end
		end

		-- Cleanup our player tracker and stop the effet on players that have left
		for obj,state in hpairs(playersInArea) do
			if(obj ~= nil) then
				if(state == false) then
					Object_SetFunctionValue(obj, "heal_active", 0, 0);
					obj:SetAffectedByRegenField(false, nil);
					playersInArea[obj] = nil;
				elseif(state == true) then
					playersInArea[obj] = false;
				end
			end
		end

		SleepSeconds(g_regenFieldVariables.regenRate);
	end

	-- Final Cleanup of vfx on players
	for obj,state in hpairs(playersInArea) do
		if(obj ~= nil and playersInArea[obj] ~= nil) then
			Object_SetFunctionValue(obj, "heal_active", 0, 0);
			obj:SetAffectedByRegenField(false, nil);
		end
	end
end