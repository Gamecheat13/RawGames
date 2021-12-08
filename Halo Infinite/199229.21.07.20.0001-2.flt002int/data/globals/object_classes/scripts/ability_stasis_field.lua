-- object ability_stasis_field

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure ability_stasis_field
	meta:table
	instance:luserdata
end

function ability_stasis_field:init() : void

	local objectList:object_list = Object_GetObjectsInSphere(Object_GetPosition(self), 1.5, ObjectTypeMask.All);
	--deal damage to knock targets off the ground
	HSDamageNewAtLocationWithDamageInfo(TAG('objects\armor\attachments\proto_abilities\proto_equipment_stasis_grenade_mp\damage_effects\stasis_detonation.damage_effect'), Object_GetPosition(self), Object_GetDamageOwnerObject(self), 'frag_grenade');

	for _, obj in hpairs(objectList) do
		if(obj~=self) then

			--freeze
			object_set_velocity(obj, 0.0, 0.0, 0.0); 
			object_set_angular_velocity(obj, 0.0, 0.0 , 0.0);

			if( Object_IsUnit(obj) ) then			
				if(Engine_GetObjectType(obj)==OBJECT_TYPE._object_type_biped) then -- only bipeds
					AddObjectTimedMalleablePropertyModifier('unit_locomotion_power_capacity', 2, 0, obj)	
					CreateThread(StasisTargetTrack, obj); -- start an update thread
				end
			end	
		end
			
	end

	Engine_CreateObject(TAG('objects\armor\attachments\proto_abilities\proto_equipment_stasis_grenade_mp\gravity_volume\gravity_volume.crate'), Object_GetPosition(self) ) -- create a knock up volume

end

function StasisTargetTrack(target_object)

	-- set initial location
	local initial_loc:location = location(target_object, "fx_root")
	RunClientScript("PlayStasisGrenadeSuspensionFX", target_object); -- play pfx
	SleepSeconds(0.3); -- wait
	--freeze
	object_set_velocity(target_object, 0.0, 0.0, 0.0); 
	object_set_angular_velocity(target_object, 0.0, 0.0 , 0.0);
	
	BeginStasisGravitySuspension(target_object);
	
end

function BeginStasisGravitySuspension(target_object)

	local low_grav_crate:object = Object_CreateFromTag(TAG('objects\armor\attachments\proto_abilities\proto_equipment_stasis_grenade_mp\gravity_volume\gravity_volume_constant.crate') ) -- spawn a crate to suspend the target, crate will self destruct

	-- lock the target in place
	local startTime:time_point = Game_TimeGet();

	repeat
		object_set_velocity(target_object, 0.0, 0.0, 0.0); 
		Object_SetPosition(low_grav_crate, location(target_object, "fx_root") );
		Sleep(1);
	until( Game_TimeGet():ElapsedTime(startTime) >= 0.25 )

end

--## CLIENT
function remoteClient.PlayStasisGrenadeSuspensionFX(target_obj) : void
	if (target_obj) then 
		local effect:effect_instance = effect_new_on_object_marker(TAG('fx\library_olympus\sandbox\abilities\master\gravity_stasis_master.effect'), target_obj, 'fx_root'); -- FX attached to target 

		SleepSeconds(1.5)
		if(target_obj ~= nil) then
			effect_kill_object_marker(TAG('fx\library_olympus\sandbox\abilities\master\gravity_stasis_master.effect'), target_obj, 'fx_root'); -- destroy effect
		end
	end
end
