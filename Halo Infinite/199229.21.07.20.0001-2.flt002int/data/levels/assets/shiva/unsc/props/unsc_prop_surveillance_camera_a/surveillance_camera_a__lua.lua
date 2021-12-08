-- object unsc_prop_surveillance_camera_a
-- author: Christopher Daugherty
-- 01/14/2020
--## SERVER

hstructure unsc_prop_surveillance_camera_a
	meta		:table				-- required
	instance	:luserdata			-- required (must be first slot after meta to prevent crash

end

function unsc_prop_surveillance_camera_a:init()
	CreateObjectThread(self, self.RandomRotate, self);
end

function unsc_prop_surveillance_camera_a:RandomRotate() --Every 30-40 seconds this will randomly rotate the unsc_prop_surveillance_camera_a
	repeat
		local selection = random_range(0, 2);
		if selection == 0 then
			Object_SetFunctionValue(self, "rotation_1", 1, 0)
			Object_SetFunctionValue(self, "rotation_2", 0, 0)
			Object_SetFunctionValue(self, "rotation_3", 0, 0)
		elseif selection == 1 then
			Object_SetFunctionValue(self, "rotation_2", 1, 0)
			Object_SetFunctionValue(self, "rotation_1", 0, 0)
			Object_SetFunctionValue(self, "rotation_3", 0, 0)
		elseif selection == 2 then
			Object_SetFunctionValue(self, "rotation_3", 1, 0)
			Object_SetFunctionValue(self, "rotation_1", 0, 0)
			Object_SetFunctionValue(self, "rotation_2", 0, 0)
		end
		SleepSeconds(10)
		Object_SetFunctionValue(self, "rotation_1", 0, 0)
		Object_SetFunctionValue(self, "rotation_2", 0, 0)
		Object_SetFunctionValue(self, "rotation_3", 0, 0)
		SleepRandomSeconds(20, 30);
	until(false);
end