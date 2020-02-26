-- object pistons_door2_control

--## SERVER


function pistons_door2_control:init()
	repeat
		device_set_position(self,0);
		device_set_power(self,1);
		SleepUntil ([| device_get_position (self) > 0], 1);
	
		if device_get_position (OBJECTS.red_door_large) == 0 then
			device_set_position(OBJECTS.red_door_large, 1);		
			device_set_power(self,0);
			sleep_s(1.7);
			kill_volume_enable(VOLUMES.kill_red_door_large_triggervolume);	
			SleepUntil ([| device_get_position (OBJECTS.red_door_large) == 1], 1);
		else
			kill_volume_disable(VOLUMES.kill_red_door_large_triggervolume);	
			device_set_position(OBJECTS.red_door_large, 0);		
			device_set_power(self,0);
			SleepUntil ([| device_get_position (OBJECTS.red_door_large) == 0], 1);
		end
		
	until false;
	
end