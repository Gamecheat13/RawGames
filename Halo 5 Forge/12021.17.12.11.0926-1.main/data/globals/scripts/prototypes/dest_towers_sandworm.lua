-- object dest_towers_sandworm

--## SERVER

function dest_towers_sandworm:init()
	
 	local obj:object = self;
	local count = 0;
	
	repeat
		if object_get_health(OBJECTS.reactor1) < 1 then
			count = count + 1;
			
		end
			
		sleep_s(.5)
	until (count > 0)
	
	repeat
		if  object_get_health(OBJECTS.reactor2) < 1 then
			count  = count + 1;
			
		end
		sleep_s(.5)
	until (count > 1)
		
		object_wake_physics(obj);
		PlayAnimation(obj,1,"device:position",30);
					
end