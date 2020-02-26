-- object dest_towers_elevator
--## SERVER

function dest_towers_elevator:init()
	local obj:object = self;
	
	SleepUntil ([| object_get_health(obj) < .75], 1);
	PlayAnimation(obj,1,"any:damage",30);
		
		
	SleepUntil ([| object_get_health(obj) < .4], 1);
	PlayAnimation(obj,2,"any:fall",30);	

end
				

