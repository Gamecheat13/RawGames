-- object fo_for_fusioncoil_med
--## SERVER

--function fo_for_fusioncoil_med:init()
--	local obj:object = self;

	
--	DeviceSetLayerAnimation(self, 1, "any:idle");
--	DeviceSetLayerPlaybackLoop(self, 1);

--	SleepUntil ([| object_get_health(obj) < 1], 1);
--		PlayAnimation(obj,1,"device:position",30);
--		sleep_s (0.75);
--		print ("blewwww");
--		object_damage_damage_section (self, "default", 1000);
				
--end
				
				
				
function fo_for_fusioncoil_med:init()
	print("fusion coil is Active!");
	DeviceSetLayerAnimation(self, 1, "any:idle");
	DeviceSetLayerPlaybackLoop(self, 1);
	--print( obj_cannister );
	object_cannot_die( self, true );
	while(true) do
		--chris french presents:

	
	SleepUntil( [| object_get_health(self) <= 0.80], 1 );
		--print( "Health Dying", self, " ", object_get_health(self));
	--	print("Generator cannisters destroyed!  Generator hiding!");
		object_cannot_take_damage( self);
		device_set_position( self,1 );
			
		SleepUntil( [| device_get_position(self) >= 0.40], 1 );	
			--print("destroy me");
			object_damage_damage_section( self, "default", 1000 );

		sleep_s( 60 );--2 mins if 60fps
		--sleep_s( 5 );--2 mins if 60fps
--		print("Resetting Capacitor");

		--object_set_region_state (obj_cannister, "", MODEL_STATE["default"]);

		object_set_health( self, 1 ); 
		object_damage_repair_section(self,"default", 100000 );
		--print( "Health resurrect" ,object_get_health(obj_cannister) );



		device_set_position_immediate( self,0 );

		object_dissolve_from_marker( self, "phase_in", "fx_a" );
		sleep_s( 0.5 );

		object_hide( self, false );
		
		object_can_take_damage( self );
		
	end


end