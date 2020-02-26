-- object dest_highrise_capacitor

--## SERVER

function dest_highrise_capacitor:init()
--	print("Capacitor is Active!");
		
	while(true) do
	
		object_create_anew( "cannisterc" );
				
		objects_attach(self, "cannister", OBJECTS.cannisterc, "")
		
	
		SleepUntil( [|object_get_health(OBJECTS.cannisterc) < 0.5], 1 );
		
--		print("Capacitor cannisters destroyed!  Capacitor hiding!");
		
		device_set_position( self,1 );
				
		Sleep(900);
		
--		print("Resetting Capacitor");
		
		
		
		device_set_position( self,0 );
		
	end
	
	
end