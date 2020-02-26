-- object dest_forp_fusioncoil
--## SERVER

function dest_forp_fusioncoil:init()
	local obj:object = self;

	
	DeviceSetLayerAnimation(self, 1, "any:idle");
	DeviceSetLayerPlaybackLoop(self, 1);

	SleepUntil ([| object_get_health(obj) < 1], 1);
	PlayAnimation(obj,1,"device:position",30);
	sleep_s (0.5);
	print ("blowing up for fusion coil medium");
	object_damage_damage_section (self, "default", 1000);
				
end
				