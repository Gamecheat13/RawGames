-- object mp_equipment_shield_wall

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure mp_equipment_shield_wall
	meta:table
	instance:luserdata
end

function mp_equipment_shield_wall:init() : void
	local mpMedalEvents:table = _G["MPMedalEvents"];
	if (mpMedalEvents ~= nil) then
		mpMedalEvents.TrackDropWallShield(self);
	end

	CreateObjectThread(self, self.CustomInitThread, self);
end

-- Run through every damage section and check if any are alive. If they are all dead, set the sef destruct time on the object so it cleans up using proper vfx
function mp_equipment_shield_wall:CustomInitThread():void
	local damageSections:table = 
	{
		"left_row_0_column_1",
		"left_row_0_column_2",
		"left_row_0_column_3",
		"left_row_1_column_0",
		"left_row_1_column_1",
		"left_row_1_column_2",
		"left_row_1_column_3",
		"left_row_2_column_0",
		"left_row_2_column_1",
		"left_row_2_column_2",
		"left_row_2_column_3",
		"left_row_3_column_0",
		"left_row_3_column_1",
		"left_row_3_column_2",
		"left_row_3_column_3",
	}

	while(object_index_valid(self)) do
		local canDestroy:boolean = true;
		for _,section in hpairs(damageSections) do
			if object_damage_section_get_health(self, section) > 0 then
				canDestroy = false;
				break; -- No need to check any other sections if one is still alive
			end
		end
		if canDestroy then
			Object_SetSelfDestructTime(self, 1.0); -- Set the self destruct time so the device destroys itself using proper vfx
			break;
		end
		SleepSeconds(0.1); -- Don't need to be running this every frame
	end
end