-- object dm_skew_ramp_001

--## SERVER

global k_down_time:number = 8;

function dm_skew_ramp_001:init()
	print ("dm_skew_ramp animation object script");
	print (object_get_health (self));
	repeat
		object_set_region_state(self, "button", MODEL_STATE.default);
		SleepUntil ([| object_get_health (self) < 1], 1);
		print ("animating ramp down");
		object_set_region_state(self, "button", MODEL_STATE.destroyed);
		object_cannot_take_damage (self);
		object_set_health (self, 1);
		device_set_position (self, 1);
		--make this a global
		sleep_s (k_down_time);
		device_set_position (self, 0);
		print ("animating ramp up");
		SleepUntil ([| device_get_position (self) == 0], 1);
		
		object_can_take_damage (self);
	until false;
end

