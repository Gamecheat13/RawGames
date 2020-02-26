-- object fo_interactive_generator

--## SERVER

function fo_interactive_generator:init()
	--print("Generator is Active!");
	local obj_cannister:object = object_at_marker( self, "explosive1" );
	--print( obj_cannister );
	object_cannot_die( obj_cannister, true );
	while(true) do
		--chris french presents:

	
	SleepUntil( [| object_get_health(obj_cannister) < 0.98], 1 );
	--	print( "Health Dying", object_get_health(obj_cannister) );
	--	print("Generator cannisters destroyed!  Generator hiding!");
		object_cannot_take_damage( obj_cannister);
		device_set_position( self,1 );
				
		Sleep(900);--15 seconds if 60fps
		
--		print("Resetting Capacitor");
		object_set_health( obj_cannister, 1 ); 
		--object_set_region_state (obj_cannister, "", MODEL_STATE["default"]);

		object_damage_repair_section(obj_cannister,"default", 100000 );
		--print( "Health resurrect" ,object_get_health(obj_cannister) );
		device_set_position( self,0 );
		object_can_take_damage( obj_cannister );
		
	end


end