-- object unsc_prop_siren_light_a
-- author: Christopher Daugherty
-- 01/14/2020
--## SERVER

hstructure unsc_prop_siren_light_a
	meta		:table				-- required
	instance	:luserdata			-- required (must be first slot after meta to prevent crash)

end

function unsc_prop_siren_light_a:init()
	RunClientScript("SetSirenWakeAndSleepDistances", self, 15, 16);		-- automatically sleep on client if no one's looking at it or within 16 units. wake up if looked at and within 15 units
    CreateObjectThread(self, self.RandomRotate, self);
end

function unsc_prop_siren_light_a:RandomRotate()
    
	repeat
		local num_rotations = random_range(1, 5)
		local anim_time = 4 --Time of one animation loop
		local sleep_time = ((num_rotations) * anim_time)

		Object_SetFunctionValue(self, "rotation", 1, 0)
		Object_SetFunctionValue(self, "fx_cone", 1, 0)
		SleepSeconds(sleep_time)
		--Object_SetFunctionValue(self, "rotation", 0, 0) -- this is what it was causing it to stop
		--Object_SetFunctionValue(self, "fx_cone", 0, 0) -- uncomment to turn off effect cone/lensflare
		SleepSeconds(sleep_time / 2);
	until(false)
end

--## CLIENT

function remoteClient.SetSirenWakeAndSleepDistances(siren:object, wakeWithinDistance:number, sleepBeyondDistance:number)
	Object_SetVisibilityWakeManagerWakeWithinDistance(siren, wakeWithinDistance);
	Object_SetVisibilityWakeManagerSleepBeyondDistance(siren, sleepBeyondDistance);
end
