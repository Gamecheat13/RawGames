-- object equipment_shroud_expanding

--## SERVER

-- Copyright (c) Microsoft. All rights reserved.

hstructure equipment_shroud_expanding
	meta:table
	instance:luserdata
end

function equipment_shroud_expanding:init() : void

	CreateThread(self.ExpandShroud, self);

end

function equipment_shroud_expanding:ExpandShroud()
	SleepUntilSeconds([|ObjectGetSpeed(self) <= 0.1], 0.05); -- Wait for device to come to rest
	SleepSeconds(0.5)
	local shroudObject = Engine_CreateObject(TAG(nil), location(self, ""));
	if shroudObject ~= nil then
		Object_SetScale(shroudObject, 0.01, 0)
		Object_SetScale(shroudObject, 2.2, 0.4)
	end
end

