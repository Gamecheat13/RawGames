-- object dest_highrise_capacitor2

--## SERVER

function dest_highrise_capacitor2:init()
--	print("Capacitor is Active!");
		
	while(true) do
	
		object_create_anew( "cannisterb" );
				
		objects_attach(self, "cannister", OBJECTS.cannisterb, "")
		
	
		SleepUntil( [|object_get_health(OBJECTS.cannisterb) < 0.5], 1 );
		
--		print("Capacitor cannisters destroyed!  Capacitor hiding!");
		
		device_set_position( self,1 );
				
		Sleep(900);
		
--		print("Resetting Capacitor");
		
		
		
		device_set_position( self,0 );
		
	end
	
	
end