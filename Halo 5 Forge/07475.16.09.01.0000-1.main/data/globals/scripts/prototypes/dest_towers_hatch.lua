-- object dest_towers_hatch
--## SERVER

function dest_towers_hatch:init()
	local obj:object = self;

	while(true) do
	
		object_create_anew( "core01" );
				
		objects_attach(self, "core", OBJECTS.core01, "")
		
	
		SleepUntil( [|object_get_health(OBJECTS.core01) < .9], 1 );
		
		PlayAnimation(obj,1,"any:close",30);
		Sleep(300);
				
		PlayAnimation(obj,1,"any:open",30);
				
	end	
	
end
				

