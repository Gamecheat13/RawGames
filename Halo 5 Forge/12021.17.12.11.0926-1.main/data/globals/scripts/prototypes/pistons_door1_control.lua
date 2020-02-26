-- object pistons_door1_control

--## SERVER


function pistons_door1_control:init()
	repeat
		device_set_position(self,0);
		device_set_power(self,1);
		SleepUntil ([| device_get_position (self) > 0], 1);
	
		if device_get_position (OBJECTS.red_door_small) == 0 then
			device_set_position(OBJECTS.red_door_small, 1);		
			device_set_power(self,0);
			sleep_s(1.7);
			kill_volume_enable(VOLUMES.kill_red_door_small_triggervolume);	
			SleepUntil ([| device_get_position (OBJECTS.red_door_small) == 1], 1);
		else
			kill_volume_disable(VOLUMES.kill_red_door_small_triggervolume);	
			device_set_position(OBJECTS.red_door_small, 0);		
			device_set_power(self,0);
			SleepUntil ([| device_get_position (OBJECTS.red_door_small) == 0], 1);
		end
		
	until false;
	
end